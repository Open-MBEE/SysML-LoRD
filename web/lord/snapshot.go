package lord

import (
	"fmt"

	"github.com/Open-MBEE/OpenSysML/client/opensysml"
)

// Snapshot is the warrior's standing as the model holds it, read attribute by
// attribute from the hero instance; the screen renders it and outcomes diff it.
type Snapshot struct {
	Name             string `json:"name"`
	Sex              string `json:"sex"`
	Class            string `json:"class"`
	Level            int64  `json:"level"`
	Experience       int64  `json:"experience"`
	HitPoints        int64  `json:"hitPoints"`
	MaxHitPoints     int64  `json:"maxHitPoints"`
	Strength         int64  `json:"strength"`
	Defense          int64  `json:"defense"`
	WeaponTier       int64  `json:"weaponTier"`
	Weapon           string `json:"weapon"`
	ArmourTier       int64  `json:"armourTier"`
	Armour           string `json:"armour"`
	Gold             int64  `json:"gold"`
	BankGold         int64  `json:"bankGold"`
	Gems             int64  `json:"gems"`
	Charm            int64  `json:"charm"`
	DeathKnightUses  int64  `json:"deathKnightUses"`
	MysticalUses     int64  `json:"mysticalUses"`
	ThievingUses     int64  `json:"thievingUses"`
	DeathKnightSkill int64  `json:"deathKnightPoints"`
	MysticalSkill    int64  `json:"mysticalPoints"`
	ThievingSkill    int64  `json:"thievingPoints"`
	FavouredMove     string `json:"favouredMove"`
	ForestFightsLeft int64  `json:"forestFightsLeft"`
	PlayerFightsLeft int64  `json:"playerFightsLeft"`
	Day              int64  `json:"daysPlayed"`
	Alive            bool   `json:"alive"`
	DragonKills      int64  `json:"dragonKills"`
	PlayerKills      int64  `json:"playerKills"`
	Spouse           string `json:"spouse"`
	Children         int64  `json:"children"`
	Horse            bool   `json:"horse"`
	Fairy            bool   `json:"fairy"`
	InnRoom          bool   `json:"innRoom"`
	Bribed           bool   `json:"bribed"`
	TrainedToday     bool   `json:"trainedToday"`
	News             string `json:"news"`
	Foe              Foe    `json:"foe"`
}

// Foe is the monster before the warrior as the model holds it: none between fights.
type Foe struct {
	Present    bool   `json:"present"`
	Dragon     bool   `json:"dragon"`
	Name       string `json:"name"`
	Weapon     string `json:"weapon"`
	HitPoints  int64  `json:"hitPoints"`
	Strength   int64  `json:"strength"`
	Defense    int64  `json:"defense"`
	Gold       int64  `json:"gold"`
	Experience int64  `json:"experience"`
}

// Snapshot reads the warrior's attributes from the model.
func (g *Game) Snapshot() (*Snapshot, error) {
	s := &Snapshot{}
	var err error
	read := func(step func() error) {
		if err == nil {
			err = step()
		}
	}
	str := func(dst *string, attribute string) {
		read(func() (e error) { *dst, e = g.String(attribute); return })
	}
	lit := func(dst *string, attribute string) {
		read(func() (e error) { *dst, e = g.Literal(attribute); return })
	}
	num := func(dst *int64, attribute string) {
		read(func() (e error) { *dst, e = g.Int(attribute); return })
	}
	flag := func(dst *bool, attribute string) {
		read(func() (e error) { *dst, e = g.Bool(attribute); return })
	}
	str(&s.Name, "name")
	lit(&s.Sex, "sex")
	lit(&s.Class, "class")
	num(&s.Level, "level")
	num(&s.Experience, "experience")
	num(&s.HitPoints, "hitPoints")
	num(&s.MaxHitPoints, "maxHitPoints")
	num(&s.Strength, "strength")
	num(&s.Defense, "defense")
	num(&s.WeaponTier, "weaponTier")
	num(&s.ArmourTier, "armourTier")
	num(&s.Gold, "gold")
	num(&s.BankGold, "bankGold")
	num(&s.Gems, "gems")
	num(&s.Charm, "charm")
	num(&s.DeathKnightUses, "deathKnightUses")
	num(&s.MysticalUses, "mysticalUses")
	num(&s.ThievingUses, "thievingUses")
	num(&s.DeathKnightSkill, "deathKnightPoints")
	num(&s.MysticalSkill, "mysticalPoints")
	num(&s.ThievingSkill, "thievingPoints")
	lit(&s.FavouredMove, "favouredMove")
	num(&s.ForestFightsLeft, "forestFightsLeft")
	num(&s.PlayerFightsLeft, "playerFightsLeft")
	num(&s.Day, "daysPlayed")
	flag(&s.Alive, "alive")
	num(&s.DragonKills, "dragonKills")
	num(&s.PlayerKills, "playerKills")
	lit(&s.Spouse, "spouse")
	num(&s.Children, "children")
	flag(&s.Horse, "horse")
	flag(&s.Fairy, "fairy")
	flag(&s.InnRoom, "innRoom")
	flag(&s.Bribed, "bribed")
	flag(&s.TrainedToday, "trainedToday")
	str(&s.News, "news")
	if err != nil {
		return nil, err
	}
	if s.Foe, err = g.foe(); err != nil {
		return nil, err
	}
	if s.Weapon, err = g.gearName("WeaponShop", "town.weapons", s.WeaponTier, "Fists"); err != nil {
		return nil, err
	}
	if s.Armour, err = g.gearName("ArmourShop", "town.armour", s.ArmourTier, "Nothing!"); err != nil {
		return nil, err
	}
	return s, nil
}

// foe reads the warrior's foe part.
func (g *Game) foe() (Foe, error) {
	v, err := g.value("foe")
	if err != nil {
		return Foe{}, err
	}
	inst, ok := g.Instance(v)
	if !ok {
		return Foe{}, fmt.Errorf("%w: the warrior's foe is %s, not a part", ErrModelInvalid, spell(v))
	}
	var f Foe
	read := func(step func() error) {
		if err == nil {
			err = step()
		}
	}
	num := func(dst *int64, attribute string) {
		read(func() error { n, e := wholeFeature(g, inst, attribute); *dst = n; return e })
	}
	flag := func(dst *bool, attribute string) {
		read(func() error {
			v, e := g.Feature(inst, attribute)
			if e != nil {
				return e
			}
			b, ok := v.(opensysml.Bool)
			if !ok {
				return fmt.Errorf("foe.%s is %s, not a boolean", attribute, spell(v))
			}
			*dst = bool(b)
			return nil
		})
	}
	str := func(dst *string, attribute string) {
		read(func() error {
			v, e := g.Feature(inst, attribute)
			if e != nil {
				return e
			}
			s, ok := v.(opensysml.String)
			if !ok {
				return fmt.Errorf("foe.%s is %s, not a string", attribute, spell(v))
			}
			*dst = string(s)
			return nil
		})
	}
	flag(&f.Present, "present")
	flag(&f.Dragon, "dragon")
	str(&f.Name, "name")
	str(&f.Weapon, "weapon")
	num(&f.HitPoints, "hitPoints")
	num(&f.Strength, "strength")
	num(&f.Defense, "defense")
	num(&f.Gold, "gold")
	num(&f.Experience, "experience")
	return f, err
}

// gearName is the name of the shop's piece at the tier the warrior holds, or
// what a warrior holding none has: bare fists, no armour.
func (g *Game) gearName(shop, path string, tier int64, bare string) (string, error) {
	if tier == 0 {
		return bare, nil
	}
	names, err := g.Members(lordPackage + "::" + shop)
	if err != nil {
		return "", err
	}
	for _, name := range names {
		v, err := g.Eval(path + "." + name)
		if err != nil {
			return "", err
		}
		inst, ok := g.Instance(v)
		if !ok {
			continue
		}
		t, err := g.Feature(inst, "tier")
		if err != nil {
			return "", err
		}
		if n, err := whole("tier", t); err == nil && n == tier {
			label, err := g.Feature(inst, "name")
			if err != nil {
				return "", err
			}
			return spell(label), nil
		}
	}
	return "", fmt.Errorf("%w: %s sells nothing of tier %d", ErrModelInvalid, shop, tier)
}
