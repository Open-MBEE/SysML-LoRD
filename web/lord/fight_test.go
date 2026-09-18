package lord

import (
	"errors"
	"strings"
	"testing"

	"github.com/Open-MBEE/OpenSysML/client/opensysml"
)

// set writes the warrior's attributes so a test can stage a fight.
func set(t *testing.T, g *Game, values map[string]int64) {
	t.Helper()
	for attribute, value := range values {
		if err := g.SetPreference(attribute, IntValue(value)); err != nil {
			t.Fatal(err)
		}
	}
}

// hunt walks into the forest and finds a foe.
func hunt(t *testing.T, g *Game) *Outcome {
	t.Helper()
	play(t, g, "F", nil)
	o := play(t, g, "L", nil)
	if o.To != "fighting" || !o.After.Foe.Present {
		t.Fatalf("hunting: %s %+v", o.To, o.After.Foe)
	}
	return o
}

func TestTheFightOffersSwordSkillAndFlight(t *testing.T) {
	g := newGame(t, 1, Character{Class: "deathKnight"})
	hunt(t, g)
	fight := menu(t, g)
	if fight.Title != "A Fight in the Forest" || strings.Join(keys(fight), "") != "ASR" {
		t.Fatalf("fight = %s %v", fight.Title, keys(fight))
	}
	if c := find(t, fight, "S"); c.Signal != "UseASkill" || c.Enabled {
		t.Fatalf("an untrained warrior may use a skill: %+v", c)
	}
	set(t, g, map[string]int64{"deathKnightUses": 1})
	c := find(t, menu(t, g), "S")
	if !c.Enabled || len(c.Params) != 1 || len(c.Params[0].Options) != 1 || c.Params[0].Options[0].Value != "Move::deathKnight" {
		t.Fatalf("a death knight's skills: %+v", c)
	}
	if _, err := g.Play("S", map[string]string{"move": "Move::heatWave"}); !errors.Is(err, ErrBadArgument) {
		t.Fatalf("a skill not offered: err = %v, want ErrBadArgument", err)
	}
}

func TestMysticalSkillsAreOfferedByTheirCost(t *testing.T) {
	g := newGame(t, 1, Character{Class: "mysticalSkills"})
	hunt(t, g)
	for uses, want := range map[int64]string{
		0:  "",
		1:  "Move::pinchRealHard",
		3:  "Move::pinchRealHard",
		4:  "Move::pinchRealHard Move::disappear",
		8:  "Move::pinchRealHard Move::disappear Move::heatWave",
		20: "Move::pinchRealHard Move::disappear Move::heatWave Move::lightShield Move::shatter Move::mindHeal",
	} {
		set(t, g, map[string]int64{"mysticalUses": uses})
		c := find(t, menu(t, g), "S")
		var got []string
		for _, o := range c.Params[0].Options {
			got = append(got, o.Value)
		}
		if strings.Join(got, " ") != want || c.Enabled != (want != "") {
			t.Fatalf("with %d uses: offered %v enabled=%v, want %q", uses, got, c.Enabled, want)
		}
	}
}

func TestASkillSpendsAUseAndAFallenFoeEndsTheFight(t *testing.T) {
	g := newGame(t, 1, Character{Class: "deathKnight"})
	set(t, g, map[string]int64{"deathKnightUses": 2, "strength": 1000})
	before := hunt(t, g).After
	o := play(t, g, "S", map[string]string{"move": "Move::deathKnight"})
	if o.To != "forest" || o.After.Foe.Present || o.After.DeathKnightUses != 1 {
		t.Fatalf("the power move: %s %+v uses=%d", o.To, o.After.Foe, o.After.DeathKnightUses)
	}
	if o.After.Gold != before.Gold+before.Foe.Gold || o.After.Experience != before.Experience+before.Foe.Experience {
		t.Fatalf("the spoils: %d gold %d experience, foe held %d and %d", o.After.Gold, o.After.Experience, before.Foe.Gold, before.Foe.Experience)
	}
	if lines := strings.Join(o.Narrate(g), "\n"); !strings.Contains(lines, "Death Knights") || !strings.Contains(lines, "killed") {
		t.Fatalf("the kill went unsung: %q", lines)
	}
}

func TestMysticalMovesAreNarratedByTheirEffect(t *testing.T) {
	g := newGame(t, 1, Character{Class: "mysticalSkills"})
	set(t, g, map[string]int64{"mysticalUses": 40, "hitPoints": 5, "maxHitPoints": 50, "strength": 0})
	foe := hunt(t, g).After.Foe.Name
	for _, step := range []struct{ move, want string }{
		{"Move::lightShield", "A shield of light forms around you."},
		{"Move::mindHeal", "Your mind knits your wounds closed."},
		{"Move::disappear", "You disappear before " + foe + "'s eyes and slip away."},
	} {
		o := play(t, g, "S", map[string]string{"move": step.move})
		lines := strings.Join(o.Narrate(g), "\n")
		if !strings.Contains(lines, step.want) || !strings.Contains(lines, foe) {
			t.Fatalf("%s: %q", step.move, lines)
		}
		if strings.Contains(lines, "You are healed") {
			t.Fatalf("%s told twice: %q", step.move, lines)
		}
	}
	if g.Location() != "forest" {
		t.Fatalf("after disappearing the warrior is %s", g.Location())
	}
}

func TestTheSwordEndsTheFightOneWayOrTheOther(t *testing.T) {
	g := newGame(t, 1, Character{})
	set(t, g, map[string]int64{"strength": 1000})
	play(t, g, "F", nil)
	won := fightOut(t, g)
	if won.To != "forest" || won.After.Foe.Present || !won.After.Alive || won.After.Foe.HitPoints != 0 {
		t.Fatalf("the victory: %s %+v", won.To, won.After.Foe)
	}
	set(t, g, map[string]int64{"strength": 0, "hitPoints": 1})
	lost := fightOut(t, g)
	if lost.To != "slain" || lost.After.Alive || lost.After.Foe.Present || lost.After.Gold != 0 {
		t.Fatalf("the defeat: %s alive=%v %+v gold=%d", lost.To, lost.After.Alive, lost.After.Foe, lost.After.Gold)
	}
	if lines := strings.Join(lost.Narrate(g), "\n"); !strings.Contains(lines, "slain") {
		t.Fatalf("the death went unsung: %q", lines)
	}
}

func TestARoundIsNarratedBlowByBlow(t *testing.T) {
	g := newGame(t, 1, Character{})
	set(t, g, map[string]int64{"hitPoints": 1000, "maxHitPoints": 1000, "defense": 0})
	found := hunt(t, g)
	if lines := strings.Join(found.Narrate(g), "\n"); !strings.Contains(lines, found.After.Foe.Name) {
		t.Fatalf("the meeting: %q", lines)
	}
	o := play(t, g, "A", nil)
	lines := strings.Join(o.Narrate(g), "\n")
	if !strings.Contains(lines, found.After.Foe.Name) {
		t.Fatalf("the round names no foe: %q", lines)
	}
	if hurt := o.Before.HitPoints - o.After.HitPoints; hurt > 0 && !strings.Contains(lines, "hits you") {
		t.Fatalf("%d damage taken in silence: %q", hurt, lines)
	}
	if dealt := o.Before.Foe.HitPoints - o.After.Foe.HitPoints; dealt > 0 && !strings.Contains(lines, "You hit") {
		t.Fatalf("%d damage dealt in silence: %q", dealt, lines)
	} else if dealt == 0 && !strings.Contains(lines, "miss") {
		t.Fatalf("a miss unsung: %q", lines)
	}
}

func TestRunningSometimesWorks(t *testing.T) {
	escaped, caught := false, false
	for seed := uint64(1); seed <= 20 && !(escaped && caught); seed++ {
		g := newGame(t, seed, Character{})
		set(t, g, map[string]int64{"hitPoints": 1000, "maxHitPoints": 1000})
		hunt(t, g)
		o := play(t, g, "R", nil)
		switch {
		case o.To == "forest" && !o.After.Foe.Present && o.After.HitPoints == o.Before.HitPoints:
			escaped = true
		case o.To == "fighting" && o.After.Foe.Present:
			caught = true
		default:
			t.Fatalf("seed %d: the run: %s %+v", seed, o.To, o.After.Foe)
		}
	}
	if !escaped || !caught {
		t.Fatalf("escaped=%v caught=%v across the seeds", escaped, caught)
	}
}

func TestDisappearAlwaysEscapes(t *testing.T) {
	for seed := uint64(1); seed <= 5; seed++ {
		g := newGame(t, seed, Character{Class: "mysticalSkills"})
		set(t, g, map[string]int64{"mysticalUses": 4})
		hunt(t, g)
		o := play(t, g, "S", map[string]string{"move": "Move::disappear"})
		if o.To != "forest" || o.After.Foe.Present || o.After.HitPoints != o.Before.HitPoints || o.After.MysticalUses != 0 {
			t.Fatalf("seed %d: disappearing: %s %+v hp %d->%d uses=%d", seed, o.To, o.After.Foe, o.Before.HitPoints, o.After.HitPoints, o.After.MysticalUses)
		}
	}
}

func TestMidnightHealsTheLivingToo(t *testing.T) {
	g := newGame(t, 1, Character{})
	set(t, g, map[string]int64{"hitPoints": 3})
	o := play(t, g, "N", nil)
	if !o.After.Alive || o.After.HitPoints != o.After.MaxHitPoints {
		t.Fatalf("the morning after: alive=%v %d/%d", o.After.Alive, o.After.HitPoints, o.After.MaxHitPoints)
	}
}

func TestOnlyAChampionMaySeekTheDragon(t *testing.T) {
	g := newGame(t, 1, Character{})
	play(t, g, "F", nil)
	if c := find(t, menu(t, g), "D"); c.Signal != "SeekTheDragon" || c.Enabled {
		t.Fatalf("a novice may seek the dragon: %+v", c)
	}
	if _, err := g.Play("D", nil); !errors.Is(err, ErrRefused) {
		t.Fatalf("seeking the dragon at level 1: err = %v, want ErrRefused", err)
	}
	set(t, g, map[string]int64{"level": 12})
	if c := find(t, menu(t, g), "D"); !c.Enabled {
		t.Fatalf("a champion may not seek the dragon: %+v", c)
	}
}

func TestSlayingTheDragonStartsTheWarriorOver(t *testing.T) {
	g := newGame(t, 1, Character{})
	set(t, g, map[string]int64{"level": 12, "strength": 100000, "hitPoints": 100000, "maxHitPoints": 100000, "gems": 3, "charm": 40, "bankGold": 9000})
	play(t, g, "F", nil)
	o := play(t, g, "D", nil)
	if o.To != "fighting" || !o.After.Foe.Present || !o.After.Foe.Dragon || o.After.ForestFightsLeft != o.Before.ForestFightsLeft-1 {
		t.Fatalf("seeking the dragon: %s %+v", o.To, o.After.Foe)
	}
	if lines := strings.Join(o.Narrate(g), "\n"); !strings.Contains(lines, "Red Dragon") {
		t.Fatalf("the dragon appears unannounced: %q", lines)
	}
	o = play(t, g, "A", nil)
	w := o.After
	if o.To != "forest" || w.Foe.Present || w.DragonKills != 1 {
		t.Fatalf("the dragon fight: %s %+v kills=%d", o.To, w.Foe, w.DragonKills)
	}
	if w.Level != 1 || w.Experience != 0 || w.HitPoints != 20 || w.MaxHitPoints != 20 || w.Strength != 10 || w.Defense != 1 || w.Gold != 500 || w.BankGold != 0 || w.Weapon != "Fists" {
		t.Fatalf("born again as %+v", *w)
	}
	if w.Gems != 3 || w.Charm != 40 {
		t.Fatalf("gems and charm lost in rebirth: %+v", *w)
	}
	if c := find(t, menu(t, g), "D"); c.Enabled {
		t.Fatalf("the reborn may seek the dragon again: %+v", c)
	}
}

func TestTheFoeStrikesOnlyInAFight(t *testing.T) {
	g := newGame(t, 1, Character{})
	o, err := g.Invoke("foeStrikes", nil)
	if err != nil {
		t.Fatal(err)
	}
	if !o.Refused || o.After.HitPoints != o.Before.HitPoints {
		t.Fatalf("struck by no foe: refused=%v hp %d->%d", o.Refused, o.Before.HitPoints, o.After.HitPoints)
	}
	set(t, g, map[string]int64{"strength": 0, "hitPoints": 1, "experience": 1000})
	play(t, g, "F", nil)
	slain := fightOut(t, g)
	if slain.After.Alive || slain.After.Experience != 900 {
		t.Fatalf("the death: alive=%v experience=%d", slain.After.Alive, slain.After.Experience)
	}
	if o, err = g.Invoke("foeStrikes", nil); err != nil {
		t.Fatal(err)
	}
	if !o.Refused || o.After.Experience != 900 {
		t.Fatalf("the dead struck again: refused=%v experience=%d", o.Refused, o.After.Experience)
	}
}

func TestARescueIsNotAMiss(t *testing.T) {
	g := newGame(t, 1, Character{})
	set(t, g, map[string]int64{"hitPoints": 1, "maxHitPoints": 30, "strength": 0, "defense": 0, "children": 1})
	if err := g.SetPreference("fairy", opensysml.Bool(true)); err != nil {
		t.Fatal(err)
	}
	hunt(t, g)
	foe := snapshot(t, g).Foe.Name
	// untilRescued attacks until the foe's blow lands, which the seeded foe cannot always manage.
	untilRescued := func(saved func(*Snapshot) bool) *Outcome {
		for rounds := 0; rounds < 100; rounds++ {
			o := play(t, g, "A", nil)
			if saved(o.After) {
				return o
			}
			if o.After.HitPoints != o.Before.HitPoints || o.To != "fighting" {
				t.Fatalf("round %d: %s hp %d->%d", rounds, o.To, o.Before.HitPoints, o.After.HitPoints)
			}
		}
		t.Fatal("the foe never landed a blow in 100 rounds")
		return nil
	}
	child := untilRescued(func(s *Snapshot) bool { return s.Children == 0 })
	if child.After.Children != 0 || child.After.HitPoints != 1 {
		t.Fatalf("the child's turn: children=%d hp=%d", child.After.Children, child.After.HitPoints)
	}
	lines := strings.Join(child.Narrate(g), "\n")
	if strings.Contains(lines, "misses") || !strings.Contains(lines, foe+" aims a killing blow") || !strings.Contains(lines, "children took the blow") {
		t.Fatalf("the child's rescue: %q", lines)
	}
	fairy := untilRescued(func(s *Snapshot) bool { return !s.Fairy })
	if fairy.After.Fairy || fairy.After.HitPoints != 30 {
		t.Fatalf("the fairy's turn: fairy=%v hp=%d", fairy.After.Fairy, fairy.After.HitPoints)
	}
	lines = strings.Join(fairy.Narrate(g), "\n")
	if strings.Contains(lines, "misses") || !strings.Contains(lines, foe+" aims a killing blow") || !strings.Contains(lines, "fairy in your pocket flies free") {
		t.Fatalf("the fairy's rescue: %q", lines)
	}
}

func TestArmouredWarriorsBreakOffTheFight(t *testing.T) {
	g := newGame(t, 1, Character{})
	set(t, g, map[string]int64{"defense": 1000})
	rival, err := g.Eval("rival")
	if err != nil {
		t.Fatal(err)
	}
	id, ok := g.Instance(rival)
	if !ok {
		t.Fatalf("rival is %v, not an object", rival)
	}
	if err := g.session.SetFeature(id, "defense", IntValue(1000)); err != nil {
		t.Fatal(err)
	}
	o, err := g.Invoke("attack", nil)
	if err != nil {
		t.Fatal(err)
	}
	if o.Refused || !o.After.Alive || o.After.PlayerFightsLeft != o.Before.PlayerFightsLeft-1 || o.After.PlayerKills != 0 {
		t.Fatalf("the stand-off: refused=%v alive=%v fights %d->%d kills=%d", o.Refused, o.After.Alive, o.Before.PlayerFightsLeft, o.After.PlayerFightsLeft, o.After.PlayerKills)
	}
}
