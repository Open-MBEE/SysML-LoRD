package lord

import (
	"errors"
	"fmt"
	"strconv"
	"strings"
	"testing"
)

// player plays one warrior through the menus with a plain strategy: fight while
// the fights last, heal when hurt, bank the gold at night, buy what the shops
// sell when it can be paid for, train when the master will take it.
type player struct {
	t      *testing.T
	g      *Game
	log    []string
	moves  int
	deaths int
	fights int
	runs   int
}

func (p *player) state() string { return p.g.Location() }

func (p *player) warrior() *Snapshot { return snapshot(p.t, p.g) }

// press plays a key, failing the test on anything but the model's own refusal,
// which it reports so the strategy's guesses can be checked.
func (p *player) press(key string, inputs map[string]string) (*Outcome, bool) {
	p.t.Helper()
	o, err := p.g.Play(key, inputs)
	if err != nil {
		if errors.Is(err, ErrRefused) {
			return nil, false
		}
		p.t.Fatalf("day %d, %s: %s %v: %v\n%s", p.warrior().Day, p.state(), key, inputs, err, strings.Join(p.log, "\n"))
	}
	p.moves++
	p.log = append(p.log, fmt.Sprintf("%s %v -> %s", key, inputs, o.To))
	if len(p.log) > 60 {
		p.log = p.log[1:]
	}
	return o, true
}

func (p *player) must(key string, inputs map[string]string) *Outcome {
	p.t.Helper()
	o, ok := p.press(key, inputs)
	if !ok {
		p.t.Fatalf("day %d, %s: %s refused; warrior %+v\n%s", p.warrior().Day, p.state(), key, *p.warrior(), strings.Join(p.log, "\n"))
	}
	return o
}

func (p *player) choice(key string) (Choice, bool) {
	for _, c := range menu(p.t, p.g).Choices {
		if c.Key == key {
			return c, c.Enabled
		}
	}
	return Choice{}, false
}

// price reads "price N" out of an option's detail.
func price(o Option) int64 {
	for _, d := range strings.Split(o.Detail, ", ") {
		if n, ok := strings.CutPrefix(d, "price "); ok {
			v, _ := strconv.ParseInt(n, 10, 64)
			return v
		}
	}
	return -1
}

// shop buys the best item of the shop the gold on hand pays for, if it is better
// than the one worn.
func (p *player) shop(key, param string, tier int64) {
	c, ok := p.choice(key)
	if !ok {
		return
	}
	w := p.warrior()
	var best Option
	var bestTier int64
	for i, o := range c.Params[0].Options {
		if t := int64(i + 1); t > tier && price(o) >= 0 && price(o) <= w.Gold && t > bestTier {
			best, bestTier = o, t
		}
	}
	if bestTier > 0 {
		p.must(key, map[string]string{param: best.Value})
	}
}

func (p *player) town() {
	p.t.Helper()
	for p.state() != "townSquare" {
		p.must("R", nil)
	}
}

// heal draws what a full healing costs from the bank, sees the healers if hurt,
// and returns to the square.
func (p *player) heal() {
	p.t.Helper()
	w := p.warrior()
	if w.HitPoints >= w.MaxHitPoints {
		return
	}
	if need := (w.MaxHitPoints-w.HitPoints)*5*w.Level - w.Gold; need > 0 && w.BankGold > 0 {
		p.must("K", nil)
		p.must("W", map[string]string{"amount": strconv.FormatInt(min(need, w.BankGold), 10)})
		p.town()
	}
	if p.warrior().Gold >= 5*w.Level {
		p.must("H", nil)
		p.must("H", nil)
		p.town()
	}
}

// bank puts the gold on hand away.
func (p *player) bank() {
	p.t.Helper()
	if w := p.warrior(); w.Gold > 0 {
		p.must("K", nil)
		p.must("D", map[string]string{"amount": strconv.FormatInt(w.Gold, 10)})
		p.town()
	}
}

// trade turns every pair of gems into a stat at the inn, rotating through the three.
func (p *player) trade() {
	p.t.Helper()
	if w := p.warrior(); w.Level < 2 || w.Gems < 2 {
		return
	}
	p.must("I", nil)
	c, ok := p.choice("G")
	if !ok {
		p.t.Fatalf("day %d: no gem trade at the inn", p.warrior().Day)
	}
	stats := c.Params[0].Options
	for i := 0; p.warrior().Gems >= 2; i++ {
		p.must("G", map[string]string{"stat": stats[i%len(stats)].Value})
	}
	p.town()
}

// skill picks the skill worth spending this round, or none: the Death Knight's
// and the thief's whenever they have a use; the mystic mends when hurt, shields
// against the dragon, and otherwise throws the strongest spell the uses allow.
func (p *player) skill(w *Snapshot, shielded bool) string {
	switch w.Class {
	case "deathKnight":
		if w.DeathKnightUses > 0 {
			return "Move::deathKnight"
		}
	case "thievingSkills":
		if w.ThievingUses > 0 {
			return "Move::thieving"
		}
	case "mysticalSkills":
		switch u := w.MysticalUses; {
		case u >= 20 && w.HitPoints*2 < w.MaxHitPoints:
			return "Move::mindHeal"
		case u >= 12 && w.Foe.Dragon && !shielded:
			return "Move::lightShield"
		case u >= 16:
			return "Move::shatter"
		case u >= 8:
			return "Move::heatWave"
		case u >= 1:
			return "Move::pinchRealHard"
		}
	}
	return ""
}

// fight sees a fight through: skills while they last, plain attacks otherwise,
// and a run while a caught run cannot kill if the fight looks lost.
func (p *player) fight() {
	p.t.Helper()
	shielded := false
	for p.state() == "fighting" {
		w := p.warrior()
		move := p.skill(w, shielded)
		did := "A"
		if !w.Foe.Dragon && p.shouldRun(w, move) {
			if _, ok := p.press("R", nil); ok {
				p.runs++
				did = "R"
			}
		}
		if did == "A" && move != "" {
			if _, ok := p.press("S", map[string]string{"move": move}); ok {
				shielded = shielded || move == "Move::lightShield"
				did = "S"
			}
		}
		if did == "A" {
			p.must("A", nil)
			p.fights++
		}
		if after := p.warrior(); !after.Alive {
			p.t.Logf("slain by %s (str %d, %d hp left) at %d/%d hp after %s", w.Foe.Name, w.Foe.Strength, w.Foe.HitPoints, w.HitPoints, w.MaxHitPoints, did)
		}
	}
}

// shouldRun weighs the foe's blows against the rounds it should take to fell it:
// run while the worst blow cannot kill, once the expected blows would.
func (p *player) shouldRun(w *Snapshot, move string) bool {
	worst := max(0, w.Foe.Strength-w.Defense)
	expected := max(0, w.Foe.Strength*3/4-w.Defense)
	mine := w.Strength * 3 / 4 * skillFactor(move)
	rounds := (w.Foe.HitPoints + mine - 1) / mine
	if w.HitPoints <= worst {
		return w.Foe.HitPoints > mine
	}
	return w.HitPoints <= (rounds-1)*expected+worst
}

// skillFactor is how many plain blows a skill's blow is worth.
func skillFactor(move string) int64 {
	switch move {
	case "Move::deathKnight", "Move::thieving", "Move::heatWave":
		return 3
	case "Move::pinchRealHard":
		return 2
	case "Move::shatter":
		return 6
	}
	return 1
}

// day plays one day from the town square to the next midnight: gear up and train,
// catch a fairy, fight while the fights and the hit points last, bank, sleep.
func (p *player) day() {
	p.t.Helper()
	w := p.warrior()
	if w.BankGold > 0 {
		p.must("K", nil)
		p.must("W", map[string]string{"amount": strconv.FormatInt(w.BankGold, 10)})
		p.town()
	}
	p.heal()
	p.shop("W", "weapon", p.warrior().WeaponTier)
	p.shop("A", "armour", p.warrior().ArmourTier)
	p.must("T", nil)
	p.town()
	p.trade()
	p.bank()
	p.must("F", nil)
	p.press("G", nil)
	p.press("C", nil)
	p.town()
	p.heal()
	p.must("F", nil)
	for {
		w = p.warrior()
		if !w.Alive || w.ForestFightsLeft == 0 {
			break
		}
		if w.HitPoints < w.MaxHitPoints && w.BankGold+w.Gold >= 5*w.Level {
			p.town()
			p.heal()
			p.bank()
			p.must("F", nil)
			continue
		}
		if w.HitPoints*2 < w.MaxHitPoints {
			break
		}
		if w.Level == 12 && w.HitPoints == w.MaxHitPoints {
			p.must("D", nil)
		} else {
			p.must("L", nil)
		}
		p.fight()
	}
	if p.state() == "slain" {
		p.deaths++
		p.must("N", nil)
		return
	}
	p.town()
	p.bank()
	p.must("I", nil)
	if _, ok := p.press("S", nil); ok {
		p.must("N", nil)
		return
	}
	p.town()
	p.must("N", nil)
}

// TestAWarriorCanSlayTheDragon plays whole games, from the boat to the dragon,
// under three seeds and every class; it fails if any deed the strategy relies on
// is refused, if the model errs, or if a hundred and fifty days are not enough.
func TestAWarriorCanSlayTheDragon(t *testing.T) {
	if testing.Short() {
		t.Skip("a whole game takes a while")
	}
	for _, tc := range []struct {
		seed  uint64
		class string
	}{{1, "deathKnight"}, {2, "mysticalSkills"}, {3, "thievingSkills"}} {
		t.Run(fmt.Sprintf("seed%d_%s", tc.seed, tc.class), func(t *testing.T) {
			g := newGame(t, tc.seed, Character{Class: tc.class})
			p := &player{t: t, g: g}
			for day := 1; day <= 150; day++ {
				if p.warrior().DragonKills > 0 {
					w := p.warrior()
					t.Logf("dragon slain on day %d after %d moves; level %d, %d gold banked, born again at level %d", day-1, p.moves, 12, w.BankGold, w.Level)
					return
				}
				p.day()
				w := p.warrior()
				t.Logf("day %d: level %d exp %d hp %d/%d str %d def %d gold %d bank %d gems %d skill %d/%d/%d deaths %d runs %d %s", day, w.Level, w.Experience, w.HitPoints, w.MaxHitPoints, w.Strength, w.Defense, w.Gold, w.BankGold, w.Gems, w.DeathKnightSkill, w.MysticalSkill, w.ThievingSkill, p.deaths, p.runs, map[bool]string{true: "", false: "(slain)"}[w.Alive])
			}
			t.Fatalf("no dragon slain in 150 days: %+v", *p.warrior())
		})
	}
}
