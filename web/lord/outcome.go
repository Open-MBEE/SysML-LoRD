package lord

import (
	"fmt"
	"strings"

	"github.com/Open-MBEE/OpenSysML/client/opensysml"
)

// Outcome is what one command made of the model: where the day machine went,
// the warrior before and after, whether the model refused the deed, and the
// dice the run drew on the way.
type Outcome struct {
	From, To      string
	Before, After *Snapshot
	Choices       []opensysml.ChoicePoint
	// Refused is a deed the model turned down at its opening decision; one it
	// carried out that changed nothing is not refused.
	Refused bool
}

// Moved reports whether the day machine changed state.
func (o *Outcome) Moved() bool { return o.From != o.To }

// Narrate tells the outcome as the game's screens did: the foe met, each side's
// blow, the old man's dice or the bard's song, and every change to the warrior's standing.
func (o *Outcome) Narrate(g *Game) []string {
	var lines []string
	lines = append(lines, o.fightLines()...)
	lines = append(lines, o.slaughterLines()...)
	lines = append(lines, o.tavernLines()...)
	lines = append(lines, o.songLines()...)
	lines = append(lines, o.changes()...)
	if master := o.masterLine(g); master != "" {
		lines = append(lines, master)
	}
	return lines
}

// slaughterLines tells the skill a slaughter opened with, if any.
func (o *Outcome) slaughterLines() []string {
	b, a := o.Before, o.After
	if b.Foe.Present || a.PlayerFightsLeft >= b.PlayerFightsLeft {
		return nil
	}
	switch {
	case a.DeathKnightUses < b.DeathKnightUses:
		return []string{"You call on the power of the Death Knights!"}
	case a.ThievingUses < b.ThievingUses:
		return []string{"You slip behind your victim for a sneak attack!"}
	}
	return nil
}

// tavernLines tells how the old man's dice fell on a wager.
func (o *Outcome) tavernLines() []string {
	if !o.decided("decision dice") {
		return nil
	}
	d := o.After.Gold - o.Before.Gold
	if d > 0 {
		return []string{fmt.Sprintf("The old man rolls the dice... and curses. You win %s!", plural(d, "gold piece"))}
	}
	return []string{fmt.Sprintf("The old man rolls the dice... and grins. You lose %s.", plural(-d, "gold piece"))}
}

// songLines tells which song Seth Able sang and what it did for the warrior.
func (o *Outcome) songLines() []string {
	if !o.decided("decision song") {
		return nil
	}
	lines := []string{"Seth Able strikes up a song for you."}
	switch {
	case o.took("decision song", "->threeFights"), o.took("decision song", "->twoFights"), o.took("decision song", "->oneFight"):
		lines = append(lines, "A rousing ballad of the forest: you feel ready for more fights today.")
	case o.took("decision song", "->userBattle"):
		lines = append(lines, "A song of vengeance: you feel ready for another fight against a warrior.")
	case o.took("decision song", "->hitPointsMaxed"):
		lines = append(lines, "A soothing melody: your wounds close and you feel fully rested.")
	case o.took("decision song", "->hitPointUp"):
		lines = append(lines, "A song of endurance: you feel hardier than before.")
	case o.took("decision song", "->bankDoubled"):
		lines = append(lines, fmt.Sprintf("A song of riches: the bank doubles your savings to %s.", plural(o.After.BankGold, "gold piece")))
	case o.took("decision song", "->charmPoint"):
		lines = append(lines, "A song of your deeds: the crowd finds you more charming.")
	}
	return lines
}

// masterLine tells whom the training hall put before the warrior on arrival: the
// master whose class is the next level, read from the hall's parts.
func (o *Outcome) masterLine(g *Game) string {
	if o.To != "trainingHall" || o.From == "trainingHall" {
		return ""
	}
	names, err := g.Members(lordPackage + "::TrainingHall")
	if err != nil {
		return ""
	}
	level := o.Before.Level
	for _, name := range names {
		v, err := g.Eval("town.training." + name)
		if err != nil {
			continue
		}
		inst, ok := g.Instance(v)
		if !ok {
			continue
		}
		teaches, err := wholeFeature(g, inst, "teaches")
		if err != nil || teaches != level+1 {
			continue
		}
		master, err := g.Feature(inst, "name")
		if err != nil {
			return ""
		}
		weapon, err := g.Feature(inst, "weapon")
		if err != nil {
			return ""
		}
		required, err := wholeFeature(g, inst, "experienceRequired")
		if err != nil {
			return ""
		}
		if o.After.Level > level {
			return fmt.Sprintf("%s bows: you have learned all the %s can teach.", spell(master), spell(weapon))
		}
		if o.After.TrainedToday && !o.Before.TrainedToday {
			return fmt.Sprintf("%s bests you and sends you off to rest; try again tomorrow.", spell(master))
		}
		line := fmt.Sprintf("%s, master of the %s, teaches level %d to warriors of %d experience.", spell(master), spell(weapon), level+1, required)
		if o.After.Experience < required {
			line += fmt.Sprintf(" You have %d; come back stronger.", o.After.Experience)
		}
		return line
	}
	return "No master has anything left to teach you."
}

// wholeFeature reads an Integer attribute of a model part.
func wholeFeature(g *Game, inst opensysml.InstanceID, attribute string) (int64, error) {
	v, err := g.Feature(inst, attribute)
	if err != nil {
		return 0, err
	}
	return whole(attribute, v)
}

// fightLines tell a round of a fight from the foe before and after and the dice
// the run drew: the meeting, the warrior's blow, the escape, the foe's answer, the kill.
func (o *Outcome) fightLines() []string {
	b, a := o.Before.Foe, o.After.Foe
	var lines []string
	add := func(format string, args ...any) { lines = append(lines, fmt.Sprintf(format, args...)) }
	if !b.Present && a.Present {
		add("You have encountered %s!! It wields %s.", a.Name, a.Weapon)
		return lines
	}
	if !b.Present {
		return lines
	}
	switch o.skill() {
	case "deathKnight":
		add("You call on the power of the Death Knights!")
	case "thieving":
		add("You slip behind %s for a sneak attack!", b.Name)
	case "pinchRealHard":
		add("You pinch %s real hard!", b.Name)
	case "heatWave":
		add("A heat wave rolls over %s!", b.Name)
	case "shatter":
		add("Your spell shatters against %s!", b.Name)
	case "disappear":
		add("You disappear before %s's eyes and slip away.", b.Name)
	case "lightShield":
		add("A shield of light forms around you.")
	case "mindHeal":
		add("Your mind knits your wounds closed.")
	}
	if o.decided("decision swing") {
		if d := b.HitPoints - a.HitPoints; d > 0 {
			add("You hit %s for %s!", b.Name, plural(d, "point"))
		} else {
			add("You swing at %s and miss!", b.Name)
		}
	}
	switch {
	case o.took("decision flee", "->escape"):
		add("You run away from %s like a coward!", b.Name)
	case o.took("decision flee", "->caught"):
		add("You try to run, but %s cuts you off!", b.Name)
	}
	if o.decided("decision foeSwing") {
		switch {
		case o.took("decision foeAttacks", "->flamingBreath"):
			add("%s breathes fire over you!", b.Name)
		case o.took("decision foeAttacks", "->stomp"):
			add("%s stomps you!", b.Name)
		case o.took("decision foeAttacks", "->hugeClaw"):
			add("%s rakes you with a huge claw!", b.Name)
		case o.took("decision foeAttacks", "->swishingTail"):
			add("%s swats you with its tail!", b.Name)
		}
		had := o.Before.HitPoints
		if o.skill() == "mindHeal" {
			had = o.After.MaxHitPoints
		}
		switch {
		case o.After.Children < o.Before.Children, o.Before.Fairy && !o.After.Fairy:
			add("%s aims a killing blow at you!", b.Name)
		case !o.After.Alive:
			add("%s strikes the killing blow.", b.Name)
		case had-o.After.HitPoints > 0:
			add("%s hits you for %s!", b.Name, plural(had-o.After.HitPoints, "point"))
		default:
			add("%s swings at you and misses!", b.Name)
		}
	}
	if b.HitPoints > 0 && a.HitPoints <= 0 {
		add("You have killed %s!", b.Name)
	}
	return lines
}

// skill names the move a round spent skill uses on, or "" for a plain round; a
// mystical move is told by what it costs.
func (o *Outcome) skill() string {
	b, a := o.Before, o.After
	if !b.Foe.Present {
		return ""
	}
	switch {
	case a.DeathKnightUses < b.DeathKnightUses:
		return "deathKnight"
	case a.ThievingUses < b.ThievingUses:
		return "thieving"
	}
	switch b.MysticalUses - a.MysticalUses {
	case 1:
		return "pinchRealHard"
	case 4:
		return "disappear"
	case 8:
		return "heatWave"
	case 12:
		return "lightShield"
	case 16:
		return "shatter"
	case 20:
		return "mindHeal"
	}
	return ""
}

// decided reports whether the run passed the named decision.
func (o *Outcome) decided(where string) bool {
	for _, c := range o.Choices {
		if c.Kind == opensysml.ChoiceDecisionBranch && c.Where == where {
			return true
		}
	}
	return false
}

// took reports whether the run took a branch of the named decision ending in suffix.
func (o *Outcome) took(where, suffix string) bool {
	for _, c := range o.Choices {
		if c.Kind == opensysml.ChoiceDecisionBranch && c.Where == where && c.Taken < len(c.Alternatives) &&
			strings.HasSuffix(c.Alternatives[c.Taken], suffix) {
			return true
		}
	}
	return false
}

// changes lists every difference between the warrior before and after.
func (o *Outcome) changes() []string {
	b, a := o.Before, o.After
	var lines []string
	add := func(format string, args ...any) { lines = append(lines, fmt.Sprintf(format, args...)) }
	if b.Alive && !a.Alive {
		add("You have been slain! Your gold is lost, and the day with it.")
	}
	if !b.Alive && a.Alive {
		add("You awaken, alive again, your wounds healed.")
	}
	if a.Level > b.Level {
		add("You are now level %d!", a.Level)
	} else if a.Level < b.Level {
		add("You start over at level %d.", a.Level)
	}
	if a.DragonKills > b.DragonKills {
		add("You have slain the Red Dragon! The realm rejoices.")
	}
	if a.PlayerKills > b.PlayerKills {
		add("You have killed another warrior!")
	}
	if d := a.Gold - b.Gold; !o.decided("decision dice") {
		if d > 0 {
			add("You gain %s.", plural(d, "gold piece"))
		} else if d < 0 && a.Alive {
			add("You spend %s.", plural(-d, "gold piece"))
		}
	}
	if d := a.BankGold - b.BankGold; d != 0 {
		add("Your bank account now holds %s.", plural(a.BankGold, "gold piece"))
	}
	if d := a.Experience - b.Experience; d > 0 {
		add("You gain %s.", plural(d, "experience point"))
	} else if d < 0 {
		add("You lose %s.", plural(-d, "experience point"))
	}
	if d := a.HitPoints - b.HitPoints; d < 0 && a.Alive && !o.decided("decision foeSwing") {
		add("You lose %s.", plural(-d, "hit point"))
	} else if d > 0 && o.skill() != "mindHeal" {
		add("You are healed for %s.", plural(d, "hit point"))
	}
	if a.MaxHitPoints != b.MaxHitPoints {
		add("Your hit points now peak at %d.", a.MaxHitPoints)
	}
	if a.Strength != b.Strength {
		add("Your strength is now %d.", a.Strength)
	}
	if a.Defense != b.Defense {
		add("Your defense is now %d.", a.Defense)
	}
	if a.WeaponTier != b.WeaponTier {
		add("You wield a new weapon.")
	}
	if a.ArmourTier != b.ArmourTier {
		add("You wear new armour.")
	}
	if d := a.Gems - b.Gems; d > 0 {
		add("You find %s!", plural(d, "gem"))
	} else if d < 0 {
		add("You part with %s.", plural(-d, "gem"))
	}
	if a.Charm != b.Charm {
		add("Your charm is now %d.", a.Charm)
	}
	if a.Class != b.Class {
		add("You now follow the way of the %s.", className(a.Class))
	}
	for _, skill := range []struct {
		name   string
		before int64
		after  int64
	}{
		{"Death Knight", b.DeathKnightSkill, a.DeathKnightSkill},
		{"Mystical", b.MysticalSkill, a.MysticalSkill},
		{"Thieving", b.ThievingSkill, a.ThievingSkill},
	} {
		if skill.after > skill.before {
			add("You learn more of the %s skills: %d points.", skill.name, skill.after)
		}
	}
	if a.Spouse != b.Spouse {
		if a.Spouse == "nobody" {
			add("You are divorced.")
		} else {
			add("You are married to %s!", spouseName(a.Spouse))
		}
	}
	if a.Children > b.Children {
		add("A child is born to you!")
	} else if a.Children < b.Children {
		add("One of your children took the blow meant for you.")
	}
	if !b.Horse && a.Horse {
		add("The fairies grant you a horse.")
	}
	if !b.Fairy && a.Fairy {
		add("You catch a fairy and pocket it.")
	} else if b.Fairy && !a.Fairy {
		add("The fairy in your pocket flies free.")
	}
	if !b.InnRoom && a.InnRoom {
		add("You take a room at the inn for the night.")
	}
	if !b.Bribed && a.Bribed {
		add("The bartender pockets your gold and forgets your name.")
	}
	if a.Day > b.Day {
		add("A new day dawns. You have %s in the forest and %s against other warriors.",
			plural(a.ForestFightsLeft, "fight"), plural(a.PlayerFightsLeft, "fight"))
	} else if a.ForestFightsLeft > b.ForestFightsLeft || a.PlayerFightsLeft > b.PlayerFightsLeft {
		add("You have %s in the forest and %s against other warriors.",
			plural(a.ForestFightsLeft, "fight"), plural(a.PlayerFightsLeft, "fight"))
	}
	if a.News != b.News && a.News != "" {
		add("The town crier: %s", a.News)
	}
	return lines
}

func plural(n int64, noun string) string {
	if n == 1 {
		return fmt.Sprintf("1 %s", noun)
	}
	return fmt.Sprintf("%d %ss", n, noun)
}

// className spells a CharacterClass literal as the guild names itself.
func className(literal string) string {
	switch literal {
	case "deathKnight":
		return "Death Knight"
	case "mysticalSkills":
		return "Mystical Skills"
	case "thievingSkills":
		return "Thieving Skills"
	}
	return literal
}

// moveName spells a Move literal as the fight offers it.
func moveName(literal string) string {
	switch literal {
	case "attack":
		return "Attack"
	case "deathKnight":
		return "Power of the Death Knights"
	case "thieving":
		return "Sneak attack"
	}
	return spaced(literal)
}

// spouseName spells a Spouse literal as the inn knows them.
func spouseName(literal string) string {
	switch literal {
	case "violet":
		return "Violet"
	case "sethAble":
		return "Seth Able"
	case "nobody":
		return "nobody"
	}
	return literal
}
