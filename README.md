# Legend of the Red Dragon

**Play it: <https://lord.opensysml.org/>**

[`lord.sysml`](lord.sysml) is *Legend of the Red Dragon*, the 1989 BBS door
game, modelled as its rules were written: every mechanic a warrior meets — the
twelve forest levels and the Red Dragon, the three skill trees, Violet and Seth
Able at the inn, gems and charm, rooms and bribes, the slaughter of other
players, the fairies, the Old Hag and the Dark Cloak Tavern, and the town crier
at midnight — is an executable SysML action or transition, guarded so that the
warrior's invariants hold however it is reached. [Played in the browser](#in-the-browser),
it looks like the door game did — a black screen, the menus, a warrior's stats —
with the page pressing the model's keys and no rule of its own. What it still is
not is the bulletin board: a warrior is saved in the browser that made them, and
no other players are on the line. The game can be finished: the tests play
[a whole game](#a-whole-game), from the boat to the dragon, for each guild.
Every output below is what the commands print.

The model is written for [OpenSysML](https://github.com/Open-MBEE/OpenSysML),
the SysML v2 implementation this repository depends on as a Go module: the
browser game is a program on its public Go API, and `go tool sysml` (Go 1.25
or later) builds the `sysml` command of the release `go.mod` pins, so every
command below runs from a clone with nothing else installed. The solver
sections need `z3` on `PATH` — see
[installing a solver](https://opensysml.org/guide/01-install/#installing-a-solver-optional).

The four packages:

| Package | What it holds |
| --- | --- |
| `Lord` | the realm: `Fighter` and the `Monster`, `Dragon` and `Master` kinds of it, `Weapon` and `Armour`, King Arthur's Weapons and Abdul's Armour with their thirteen items each, Turgon's hall with its eleven masters, the forest with all twelve levels of monsters, the Red Dragon, the Dark Cloak Tavern and the fairy glade, the bank, the healer, the Red Dragon Inn with Violet's and Seth Able's favours, and the `Town` that holds them |
| `LordPlay` | a `Warrior` with the stats screen's attributes and the `Foe` before him, fourteen constraints the game never breaks, one action per deed the realm offers (`meet`, `meetTheDragon`, `strike`, `useSkill`, `run`, `win`, `attack`, `heal`, `deposit`, `withdraw`, `robTheBank`, `buyWeapon`, `buyArmour`, `train`, `learnSkill`, `meetTheOldHag`, `askTheFairies`, `catchAFairy`, `changeProfession`, `gamble`, `buyRoom`, `bribeTheBartender`, `tradeGems`, `flirt`, `divorce`, `listenToTheBard`, `newDay`), the `day` state machine that is the game's menu, and six warriors: `hero`, fresh off the boat; `heroine`, of the other sex and charming enough for the bard; `rival`, whom the slaughter menu offers; `champion`, at level twelve with the best of both shops and a Death Knight master; and `cornered` and `dragonslayer`, the hero and the champion a round into a fight, for the checker |
| `LordOdds` | requirements a warrior is checked against — for the dragon, for a wedding, for a slaughter — two the solver is asked to satisfy, one it is asked to explain, and four analyses it is asked to minimize |
| `LordViews` | the menu as a state diagram, the warrior's swing, the foe's answer, a slaughter and a flirt as flows, the town and the forest as trees, and *The Daily Happenings*, a document with the warrior's standing, both shops' price lists, the masters, both sweethearts' favours and two levels of the forest |

## From the command line

Analyse the model:

```bash
go tool sysml lord.sysml -validate
```

```
✓ package Lord
✓ package LordPlay
✓ package LordOdds
✓ package LordViews
✓ lord.sysml: no errors
```

**A blow.** `Hit` is the game's damage rule. A swing lands with a weight the
dice give it, `quarters`, nought to four: half the striker's strength, plus
that many eighths of it, less the target's defense, never below nought — so
a mighty blow is the full strength less defense and a weak one half of it,
and a foe of enough defense turns the weak ones away. `Blow` is the mighty
blow, never less than one, the bound the analyses reason with, and
`BlowsToKill` counts how many of them a target takes. `Shielded` halves a
blow behind a Mystical Light Shield, `RoomPrice` is the inn's rate by level,
`SkillUses` turns skill points into a day's uses, and `Interest` is what the
bank adds overnight.

```bash
go tool sysml lord.sysml \
  -calc "LordPlay::Hit(10, 0, 0)" \
  -calc "LordPlay::Hit(10, 0, 4)" \
  -calc "LordPlay::Hit(6, 1, 2)" \
  -calc "LordPlay::Blow(10, 3)" \
  -calc "LordOdds::BlowsToKill(1100, 0, 15000)" \
  -calc "LordPlay::Shielded(2000, true)" \
  -calc "LordPlay::RoomPrice(12)" \
  -calc "LordPlay::SkillUses(40, 4)" \
  -calc "LordPlay::Interest(1500, 10)"
```

```
✓ LordPlay::Hit(10, 0, 0)
  = 5
  standing: value (observed: 1 run under reverse)
✓ LordPlay::Hit(10, 0, 4)
  = 10
  standing: value (observed: 1 run under reverse)
✓ LordPlay::Hit(6, 1, 2)
  = 3
  standing: value (observed: 1 run under reverse)
✓ LordPlay::Blow(10, 3)
  = 7
  standing: value (observed: 1 run under reverse)
✓ LordOdds::BlowsToKill(1100, 0, 15000)
  = 14
  standing: value (observed: 1 run under reverse)
✓ LordPlay::Shielded(2000, true)
  = 1000
  standing: value (observed: 1 run under reverse)
✓ LordPlay::RoomPrice(12)
  = 4800
  standing: value (observed: 1 run under reverse)
✓ LordPlay::SkillUses(40, 4)
  = 10
  standing: value (observed: 1 run under reverse)
✓ LordPlay::Interest(1500, 10)
  = 150
  standing: value (observed: 1 run under reverse)
```

**A fight.** A forest fight is a round at a time, as the game's menu had it.
`meet` picks a monster of the warrior's level and copies it into `foe` — the
warrior carries the foe before him as a part, `present` while the fight
lasts. `strike` is one round: the dice weigh the swing, `Hit` takes it off
the foe, and if the foe still stands `foeStrikes` answers in kind — a blow
of its own weight, and where the foe is the dragon one of its four attacks.
`useSkill` is the round opened with a skill instead, `run` the attempt to
leave, `win` the spoils of a fallen foe. Each roll is a decision the model
leaves to the schedule with several open guards, as it leaves the monster's
chance of dropping a gem. `cornered` is the hero a round into a fight, the
Small Thief before him and neither yet touched; `-instantiate` creates him
and `-action "<action> <object>"` performs one action on him. `-engine check`
searches every schedule of that action — every way its dice can fall — and
reports what it can end as. `-check-diverge` names the features to compare
across outcomes and `-check-property` the constraints to hold at every step:

```bash
go tool sysml lord.sysml -engine check \
  -instantiate LordPlay::cornered -action "LordPlay::Warrior::strike cornered" \
  -check-diverge quarters \
  -check-property LordPlay::Warrior::theDeadHaveNoHitPoints \
  -check-property LordPlay::Warrior::hitPointsWithinMaximum
go tool sysml lord.sysml -engine check \
  -instantiate LordPlay::cornered -action "LordPlay::Warrior::foeStrikes cornered" \
  -check-diverge this.hitPoints -check-diverge this.alive \
  -check-property LordPlay::Warrior::theDeadHaveNoHitPoints \
  -check-property LordPlay::Warrior::hitPointsWithinMaximum
```

```
✗ Action LordPlay::Warrior::strike: divergent (44 states, 43 moves, depth 11)
  divergent: quarters ends as 0 or 1 or 2 or 3 or 4
    quarters = 0
    quarters = 1
    quarters = 2
    quarters = 3
    quarters = 4
  standing: sensitive (witnessed: 44 states, 43 moves searched, witness of 5 choices replayed)
✗ Action LordPlay::Warrior::foeStrikes: divergent (48 states, 47 moves, depth 11)
  divergent: this.hitPoints ends as 15 or 16 or 17 or 18
    this.hitPoints = 15
    this.hitPoints = 16
    this.hitPoints = 17
    this.hitPoints = 18
  standing: sensitive (witnessed: 48 states, 47 moves searched, witness of 4 choices replayed)
```

Five weights to the hero's swing, from five to the full ten of his strength
against a thief with no defense; the thief's dagger, six points through the
hero's one of defense, takes two to five of his twenty hit points, and
`this.alive` did not diverge — no answer of the thief's kills a fresh hero
in one blow. No property was violated on any state. `-check-witness <dir>`
writes the schedule that reaches each outcome, and `-schedule replay:<file>`
runs one again.

**The dragon.** The dragon is the fight the game is named for. `meetTheDragon`
lets only a twelfth-level warrior with fights left near it; each round the
warrior strikes, or spends a skill use on a power move, a sneak attack or one
of the Mystical arts, and the dragon answers with one of its four attacks —
the flaming breath no armour blunts, a stomp, a huge claw or a swish of its
tail — the choice, and the weight of it, being the dice's. A child of the
warrior's may take a blow, a caught fairy revives the fallen once, and the
slayer is born again at level one, keeping skills, charm, gems, family and
the kill. `dragonslayer` is the champion at the dragon's throat; the dragon's
answer to him has ten outcomes:

```bash
go tool sysml lord.sysml -engine check \
  -instantiate LordPlay::dragonslayer \
  -action "LordPlay::Warrior::foeStrikes dragonslayer" \
  -check-diverge this.hitPoints -check-diverge this.alive
```

```
✗ Action LordPlay::Warrior::foeStrikes: divergent (138 states, 137 moves, depth 11)
  divergent: this.hitPoints ends as 3100 or 3350 or 3500 or 3600 or 3850 or 4100 or 4225 or 4350 or 4475 or 4500
    this.hitPoints = 3100
    this.hitPoints = 3350
    this.hitPoints = 3500
    this.hitPoints = 3600
    this.hitPoints = 3850
    this.hitPoints = 4100
    this.hitPoints = 4225
    this.hitPoints = 4350
    this.hitPoints = 4475
    this.hitPoints = 4500
  standing: sensitive (witnessed: 138 states, 137 moves searched, witness of 8 choices replayed)
```

The breath is a thousand whatever the dice say; the stomp, two thousand
strength through the champion's six hundred of defense, is four hundred to
fourteen hundred; the claw, at half the strength, nothing to four hundred;
and the tail, at a quarter, never gets through. [The REPL section](#the-dragon-1)
plays the fight out.

**Who may face the dragon.** `-satisfy` evaluates the `assert satisfy`
statements one element makes. `dragonFights` asserts `readyForTheDragon` — a
level-twelve warrior with the top item from each shop — of both warriors, and
three ways of outlasting the dragon of the champion:

```bash
go tool sysml lord.sysml -satisfy=LordOdds::dragonFights
```

```
✓ satisfy readyForTheDragon by champion holds (on LordPlay::champion ID: 1)
  standing: holds (observed: 1 run under reverse)
✗ satisfy readyForTheDragon by hero fails (on LordPlay::hero ID: 13)
  Required condition evaluated to false: warrior.level == 12
  standing: violated (witnessed: 1 run under reverse)
✗ satisfy outlastTheDragon by champion fails (on LordPlay::champion ID: 1)
  Required condition evaluated to false: warrior.hitPoints + Blow(dragonStrength, warrior.defense) > Blow(dragonStrength, warrior.defense) * BlowsToKill(warrior.strength, 0, dragonHitPoints)
  standing: violated (witnessed: 1 run under reverse)
✗ satisfy outlastTheBreath by champion fails (on LordPlay::champion ID: 1)
  Required condition evaluated to false: warrior.hitPoints + breath > breath * BlowsToKill(warrior.strength, 0, dragonHitPoints)
  standing: violated (witnessed: 1 run under reverse)
✗ satisfy slayWithPowerMoves by champion fails (on LordPlay::champion ID: 1)
  Required condition evaluated to false: warrior.hitPoints + max(breath, Blow(dragonStrength, warrior.defense)) > max(breath, Blow(dragonStrength, warrior.defense)) * BlowsToKill(3 * warrior.strength, 0, dragonHitPoints)
  standing: violated (witnessed: 1 run under reverse)
```

`outlastTheDragon` is a straight brawl of mighty blows, the warrior swinging
first: fourteen blows of 1100 fell the dragon, and thirteen stomps of 1400
land in the meantime. `outlastTheBreath` is the same brawl against the breath
alone. `slayWithPowerMoves` is the Death Knights' way, five power moves of
three blows against the dragon's hardest answer every round. The champion's
4500 hit points guarantee none of them — the dice must be kinder than the
worst, and [below](#the-dragon-1) they are, and are not; the solver section
says what would need no luck. `weddings` and `slaughter` check the inn's and
the slaughter menu's requirements the same way.

**The views.** `-render` writes a view in the form its definition names.
`townSquare` is the game's menu as a state diagram, one state per place and
one transition per key, guarded as the game guards them. `-render` writes
Mermaid when its output is a pipe or file and plain text at a terminal;
`-render-form mermaid` asks for the diagram either way:

```bash
go tool sysml lord.sysml -render LordViews::townSquare \
  -render-form mermaid
```

```
stateDiagram-v2
  state "LordPlay::Warrior::day<br>«exhibit state»" as n0 {
    state "townSquare<br>«state»<br>initial" as n1
    state "forest<br>«state»" as n2
    state "fighting<br>«state»" as n3
    state "darkCloakTavern<br>«state»" as n4
    state "healersHut<br>«state»" as n5
    state "bank<br>«state»" as n6
    state "trainingHall<br>«state»" as n7
    state "inn<br>«state»" as n8
    state "asleep<br>«state»" as n9
    state "slaughter<br>«state»" as n10
    state "otherPlaces<br>«state»" as n11
    state "slain<br>«state»" as n12
    [*] --> n1
  }
  n1 --> n2 : townSquare_forest: accept EnterForest
  n1 --> n5 : townSquare_healer: accept VisitTheHealer / healing
  n1 --> n6 : townSquare_bank: accept VisitTheBank
  n1 --> n7 : townSquare_training: accept VisitTheTrainingHall / training
  n1 --> n8 : townSquare_inn: accept VisitTheInn
  n1 --> n10 : townSquare_slaughter: accept SlaughterOtherPlayers
  n1 --> n11 : townSquare_otherPlaces: accept OtherPlaces
  n1 --> n1 : townSquare_midnight: accept NewDay / midnight
  n2 --> n3 : forest_fight: accept LookForSomethingToKill [forestFightsLeft #gt; 0 and alive] / hunting
  n2 --> n3 : forest_dragon: accept SeekTheDragon [forestFightsLeft #gt; 0 and alive and level == 12] / braving
  n2 --> n2 : forest_guild: accept MeetYourGuild [alive] / learning
  n2 --> n2 : forest_hag: accept MeetTheOldHag [alive and gems #gt;= 1] / bargaining
  n2 --> n2 : forest_fairies: accept AskTheFairies [alive and not blessedToday] / asking
  n2 --> n2 : forest_catch: accept CatchAFairy [alive and not fairy and not grabbedToday] / grabbing
  n2 --> n4 : forest_tavern: accept FindTheDarkCloakTavern [alive]
  n2 --> n12 : forest_slain: [not alive]
  n2 --> n1 : forest_town: accept ReturnToTown
  n3 --> n3 : fighting_attack: accept AttackTheFoe [alive and foe.present and foe.hitPoints #gt; 0] / striking
  n3 --> n3 : fighting_skill: accept UseASkill [alive and foe.present and foe.hitPoints #gt; 0 and SkillReady(s.move, deathKnightUses, thievingUses, mysticalUses, lightShield)] / casting
  n3 --> n3 : fighting_run: accept RunAway [alive and foe.present and foe.hitPoints #gt; 0] / fleeing
  n3 --> n2 : fighting_won: [alive and foe.present and foe.hitPoints #lt;= 0] / claiming
  n3 --> n2 : fighting_fled: [alive and not foe.present]
  n3 --> n12 : fighting_slain: [not alive]
  n4 --> n4 : tavern_gamble: accept Gamble [alive and gold #gt;= 100] / betting
  n4 --> n4 : tavern_profession: accept ChangeProfession [alive] / retraining
  n4 --> n2 : tavern_forest: accept ReturnToTheForest
  n5 --> n1 : healer_town: accept ReturnToTown
  n6 --> n6 : bank_rob: accept RobTheBank [alive and class == CharacterClass::thievingSkills and fairy] / robbing
  n6 --> n1 : bank_town: accept ReturnToTown
  n7 --> n1 : training_town: accept ReturnToTown
  n8 --> n8 : inn_flirt: accept FlirtAtTheInn [alive and not flirtedToday] / flirting
  n8 --> n8 : inn_divorce: accept AskForADivorce [alive and spouse != Spouse::nobody] / divorcing
  n8 --> n8 : inn_bard: accept ListenToTheBard [alive and not heardTheBard] / listening
  n8 --> n8 : inn_bribe: accept BribeTheBartender [alive and level #gt;= 2 and not bribed and gold #gt;= BribePrice(level)] / bribing
  n8 --> n8 : inn_gems: accept TradeGems [alive and level #gt;= 2 and gems #gt;= town.inn.gemsPerStatPoint] / trading
  n8 --> n9 : inn_room: accept BuyARoom [alive and not innRoom and (charm #gt;= town.inn.charmForAFreeRoom or gold #gt;= RoomPrice(level))] / lodging
  n8 --> n1 : inn_town: accept ReturnToTown
  n9 --> n1 : asleep_midnight: accept NewDay / midnight
  n10 --> n10 : slaughter_attack: accept AttackAWarrior [playerFightsLeft #gt; 0 and alive] / attacking
  n10 --> n12 : slaughter_slain: [not alive]
  n10 --> n1 : slaughter_town: accept ReturnToTown
  n11 --> n1 : otherPlaces_town: accept ReturnToTown
  n12 --> n1 : slain_midnight: accept NewDay / midnight
```

`forestFight` and `foesTurn` are the warrior's swing and the foe's answer as
flowcharts, with the decisions the dice make; `slaughter` and `flirting` are
the slaughter and the flirt; `theTown` and `theForest` are trees:

```bash
go tool sysml lord.sysml -render LordViews::forestFight
go tool sysml lord.sysml -render LordViews::foesTurn
go tool sysml lord.sysml -render LordViews::slaughter
go tool sysml lord.sysml -render LordViews::flirting
go tool sysml lord.sysml -render LordViews::theTown
go tool sysml lord.sysml -render LordViews::theForest
```

**The Daily Happenings.** `-render-document` compiles a document definition,
runs its queries and writes Markdown. With `-instantiate`, the `Verdicts`
query reads the hero the session holds — every constraint asserted of the
warrior and every `satisfy` asserted about it — and the lists are `Project`
over the realm's parts: both shops, the masters, both sweethearts' favours,
and the monsters of two forest levels, the first and the twelfth, each
filtered from the forest by level and ordered by the experience they yield:

```bash
go tool sysml lord.sysml \
  -instantiate LordPlay::hero -render-document LordViews::DailyHappenings
```

```
# The Daily Happenings

What holds of the warrior, at the town square.

*The warrior's standing*

| path | kind | name | verdict | reason |
| --- | --- | --- | --- | --- |
| LordPlay::hero | constraint | levelInRange | holds |  |
| LordPlay::hero | constraint | fightsNotOverdrawn | holds |  |
| LordPlay::hero | constraint | playerFightsNotOverdrawn | holds |  |
…
| LordPlay::hero | constraint | theBardTakesBrides | holds |  |
| LordPlay::hero | satisfaction |  | violated | satisfaction satisfy readyForTheDragon by hero: require condition evaluated to false: warrior.level == 12 |
| LordPlay::hero | satisfaction |  | violated | satisfaction satisfy mayWedViolet by hero: require condition evaluated to false: warrior.charm >= favour.charmNeeded |
| LordPlay::hero | satisfaction |  | holds |  |

*King Arthur's Weapons*

| tier | strength | price | weapon |
| --- | --- | --- | --- |
| 1 | 5 | 200 | Stick |
…
| 13 | 800 | 40000000 | Nira's Teeth |

*Abdul's Armour*
…
*Turgon's Warrior Training*

| teaches | experienceRequired | hitPoints | strength | defense | master |
| --- | --- | --- | --- | --- | --- |
| 2 | 100 | 15 | 10 | 2 | Halder |
…
| 12 | 10000000 | 800 | 260 | 80 | Turgon |

*Violet's favours*

| charmNeeded | experiencePerLevel | favour |
| --- | --- | --- |
| 1 | 5 | Wink |
…
| 100 | 1000 | Marry Her |

*Seth Able's favours*
…
*The forest, level one*

| weapon | strength | hitPoints | gold | experience | monster |
| --- | --- | --- | --- | --- | --- |
| Sharp Teeth | 3 | 4 | 32 | 1 | Large Green Rat |
…
| Short Sword | 12 | 15 | 234 | 10 | Bran The Warrior |

*The forest, level twelve*

| weapon | strength | hitPoints | gold | experience | monster |
| --- | --- | --- | --- | --- | --- |
| Flaming Breath | 2000 | 15000 | 0 | 0 | The Red Dragon |
| Chant Of Insanity | 1497 | 1383 | 224964 | 39878 | The Wizard Of Darkness |
…
| Spiked Steel Mace | 1800 | 2878 | 524838 | 112833 | Great Ogre Of The North |
```

## From the REPL

```bash
go tool sysml
```

```
%load lord.sysml
```

Each section below starts afresh — `%clear`, then `%load` again — so the
object numbers in its output are the ones shown.

### A day in the realm

`%instantiate` creates the hero and starts the `day` machine the warrior
exhibits, in `townSquare`. `%state` binds the debugger to that running
machine; `%send` queues one of the menu's signals and `%advance 1` dispatches
it and lets the effect it triggers — a round of a fight, a night's sleep, the
stroke of midnight — run to completion. (`%step` dispatches one event at a
time; a transition whose effect runs a deed takes two.) Looking for something
to kill puts the hero in `fighting`, before whatever monster of his level the
dice serve; each `AttackTheFoe` is a round, and the machine leaves the fight
of itself when the foe falls, taking the spoils on the way out:

```
%instantiate LordPlay::hero
%state LordPlay::hero
%send EnterForest
%advance 1
%send LookForSomethingToKill
%advance 1
%eval in LordPlay::hero : foe.name
%eval in LordPlay::hero : foe.hitPoints
%send AttackTheFoe
%advance 1
%eval in LordPlay::hero : foe.hitPoints
%eval in LordPlay::hero : hitPoints
%send AttackTheFoe
%advance 1
%eval in LordPlay::hero : gold
%eval in LordPlay::hero : experience
%eval in LordPlay::hero : forestFightsLeft
```

```
✓ Created instance of LordPlay::hero
  ID: 1
✓ Debugging state machine "day" exhibited by object #1 of "LordPlay::hero"
  Current state: townSquare
✓ Sent EnterForest to object #1 of "LordPlay::hero"
  Accepted by state machine "day" in state townSquare: transition townSquare_forest fires on it
✓ Advanced to 1.0 (2 event(s) processed)
  Current state: forest
✓ Sent LookForSomethingToKill to object #1 of "LordPlay::hero"
  Accepted by state machine "day" in state forest: transition forest_fight fires on it
✓ Advanced to 2.0 (2 event(s) processed)
  Current state: fighting
  1 choice point; %trace on to see them
✓ foe.name (on LordPlay::hero ID: 1)
  = "Small Thief"
✓ foe.hitPoints (on LordPlay::hero ID: 1)
  = 9
✓ Sent AttackTheFoe to object #1 of "LordPlay::hero"
  Accepted by state machine "day" in state fighting: transition fighting_attack fires on it
✓ Advanced to 3.0 (2 event(s) processed)
  Current state: fighting
  2 choice points; %trace on to see them
✓ foe.hitPoints (on LordPlay::hero ID: 1)
  = 4
✓ hitPoints (on LordPlay::hero ID: 1)
  = 18
✓ Sent AttackTheFoe to object #1 of "LordPlay::hero"
  Accepted by state machine "day" in state fighting: transition fighting_attack fires on it
✓ Advanced to 4.0 (3 event(s) processed)
  Current state: forest
  2 choice points; %trace on to see them
✓ gold (on LordPlay::hero ID: 1)
  = 556
✓ experience (on LordPlay::hero ID: 1)
  = 2
✓ forestFightsLeft (on LordPlay::hero ID: 1)
  = 14
```

Under the default schedule the dice fall the same way every run: the forest
serves the Small Thief, the hero's swing is the weak one, five of his ten
strength, and the thief's answer is weak too, two through the hero's
defense. Two rounds, and the thief's fifty-six gold and two experience are
the hero's. The champion, at level twelve, is served a monster of his own
level, and a warrior who would rather not finish may `RunAway` — the dice
say whether the foe lets him:

```
%instantiate LordPlay::champion
%state LordPlay::champion
%send EnterForest
%advance 1
%send LookForSomethingToKill
%advance 1
%eval in LordPlay::champion : foe.name
%eval in LordPlay::champion : foe.hitPoints
%send AttackTheFoe
%advance 1
%eval in LordPlay::champion : foe.hitPoints
%eval in LordPlay::champion : hitPoints
%send RunAway
%advance 1
%eval in LordPlay::champion : foe.present
```

```
✓ Created instance of LordPlay::champion
  ID: 17
✓ Debugging state machine "day" exhibited by object #17 of "LordPlay::champion"
  Current state: townSquare
✓ Sent EnterForest to object #17 of "LordPlay::champion"
  Accepted by state machine "day" in state townSquare: transition townSquare_forest fires on it
✓ Advanced to 5.0 (2 event(s) processed)
  Current state: forest
✓ Sent LookForSomethingToKill to object #17 of "LordPlay::champion"
  Accepted by state machine "day" in state forest: transition forest_fight fires on it
✓ Advanced to 6.0 (2 event(s) processed)
  Current state: fighting
  1 choice point; %trace on to see them
✓ foe.name (on LordPlay::champion ID: 17)
  = "Corinthian Giant"
✓ foe.hitPoints (on LordPlay::champion ID: 17)
  = 2544
✓ Sent AttackTheFoe to object #17 of "LordPlay::champion"
  Accepted by state machine "day" in state fighting: transition fighting_attack fires on it
✓ Advanced to 7.0 (2 event(s) processed)
  Current state: fighting
  2 choice points; %trace on to see them
✓ foe.hitPoints (on LordPlay::champion ID: 17)
  = 1994
✓ hitPoints (on LordPlay::champion ID: 17)
  = 3900
✓ Sent RunAway to object #17 of "LordPlay::champion"
  Accepted by state machine "day" in state fighting: transition fighting_run fires on it
✓ Advanced to 8.0 (3 event(s) processed)
  Current state: forest
  1 choice point; %trace on to see them
✓ foe.present (on LordPlay::champion ID: 17)
  = false
```

Which monster the forest serves is the first of those choice points, and
`-engine check` on the deed the `forest_fight` transition performs walks all
of them:

```bash
go tool sysml lord.sysml -engine check \
  -instantiate LordPlay::hero \
  -action "LordPlay::Warrior::day::forest_fight::hunting hero" \
  -check-diverge this.foe
```

```
✗ Action LordPlay::Warrior::day::forest_fight::hunting: divergent (82 states, 81 moves, depth 11)
  divergent: this.foe ends as LordPlay::Foe#1{… name = "Small Bear" …}
    this.foe = LordPlay::Foe#1{… name = "Large Green Rat" …}
    this.foe = LordPlay::Foe#1{… name = "Bran The Warrior" …}
    this.foe = LordPlay::Foe#1{… name = "Large Mosquito" …}
    this.foe = LordPlay::Foe#1{… name = "Small Thief" …}
    this.foe = LordPlay::Foe#1{… name = "Rude Boy" …}
    this.foe = LordPlay::Foe#1{… name = "Evil Wretch" …}
    this.foe = LordPlay::Foe#1{… name = "Ugly Old Hag" …}
    this.foe = LordPlay::Foe#1{… name = "Old Man" …}
    this.foe = LordPlay::Foe#1{… name = "Wild Boar" …}
    this.foe = LordPlay::Foe#1{… name = "Small Troll" …}
    this.foe = LordPlay::Foe#1{… name = "Small Bear" …}
  standing: sensitive (witnessed: 82 states, 81 moves searched, witness of 4 choices replayed)
```

Eleven foes (each witness line abridged to the monster's name), the eleven
monsters of the first level, Bran the Warrior among them.

Back to town with the hero, a room at the inn for the night, and midnight
gives the fights and the hit points back and turns the guest out:

```
%state LordPlay::hero
%send ReturnToTown
%advance 1
%send VisitTheInn
%advance 1
%send BuyARoom
%advance 1
%eval in LordPlay::hero : gold
%send NewDay
%advance 1
%eval in LordPlay::hero : hitPoints
%eval in LordPlay::hero : forestFightsLeft
%eval in LordPlay::hero : innRoom
```

```
✓ Sent BuyARoom to object #1 of "LordPlay::hero"
  Accepted by state machine "day" in state inn: transition inn_room fires on it
✓ Advanced to 11.0 (1 event(s) processed)
  Current state: asleep
✓ gold (on LordPlay::hero ID: 1)
  = 156
✓ Sent NewDay to object #1 of "LordPlay::hero"
  Accepted by state machine "day" in state asleep: transition asleep_midnight fires on it
✓ Advanced to 12.0 (1 event(s) processed)
  Current state: townSquare
  1 choice point; %trace on to see them
✓ hitPoints (on LordPlay::hero ID: 1)
  = 20
✓ forestFightsLeft (on LordPlay::hero ID: 1)
  = 15
✓ innRoom (on LordPlay::hero ID: 1)
  = false
```

A signal the current state does not accept is refused naming the state: in
`townSquare`, `%send LookForSomethingToKill` reports `accepts no signal
LookForSomethingToKill now: state machine "day" in state townSquare`. A
signal the state accepts but whose every transition is guarded off — `RobTheBank`
at the bank without a fairy, `TradeGems` with one gem, `UseASkill` naming a
spell the warrior lacks the uses for — is refused too, before it is queued:
`would fire no transition on RobTheBank now, so it was not sent:
... the guard of every transition RobTheBank triggers is false`.

The training hall dispatches the same way: `VisitTheTrainingHall` puts the
warrior before the master who teaches the next level — Halder for a
first-level warrior, Barak for a second, Turgon for an eleventh — so the
machine can carry a warrior from the boat to the dragon's door, and a
twelfth-level warrior finds no master waiting. The REPL takes declarations as
well as commands, so two warriors the model does not ship, a second-level
squire with Barak's four hundred experience and an eleventh-level veteran with
Turgon's ten million, show the two ends; the hero, fresh off the boat with no
experience, is turned away by Halder and stays first level:

```
%clear
%load lord.sysml
package Probe {
    private import LordPlay::*;
    part squire : Warrior { attribute :>> level = 2; attribute :>> experience = 400; attribute :>> hitPoints = 20; attribute :>> maxHitPoints = 20; attribute :>> strength = 30; attribute :>> defense = 10; }
    part veteran : Warrior { attribute :>> level = 11; attribute :>> experience = 10000000; attribute :>> hitPoints = 2000; attribute :>> maxHitPoints = 2000; attribute :>> strength = 900; attribute :>> defense = 500; }
}
%instantiate LordPlay::hero
%state LordPlay::hero
%send VisitTheTrainingHall
%advance 1
%eval in LordPlay::hero : level
%instantiate Probe::squire
%state Probe::squire
%send VisitTheTrainingHall
%advance 1
%eval in Probe::squire : level
%instantiate Probe::veteran
%state Probe::veteran
%send VisitTheTrainingHall
%advance 1
%eval in Probe::veteran : level
```

```
✓ level (on LordPlay::hero ID: 1)
  = 1
✓ level (on Probe::squire ID: 16)
  = 3
✓ level (on Probe::veteran ID: 29)
  = 12
```

### The dragon

`%schedule seed:<n>` makes the dice a seeded run instead of the first branch
every time, which is how the browser plays. `SeekTheDragon` is the forest's
key for a twelfth-level warrior, and `UseASkill(move=…)` opens a round with a
skill: the Death Knights' power move is three blows for a use, and the
champion has ten. Under seed one the seventh fells the dragon, the machine
takes the kill on its way back to the forest, and the champion wakes a
first-level warrior of twenty hit points and five hundred gold with his
forty skill points kept:

```
%clear
%load lord.sysml
%schedule seed:1
%instantiate LordPlay::champion
%state LordPlay::champion
%send EnterForest
%advance 1
%send SeekTheDragon
%advance 1
%eval in LordPlay::champion : foe.hitPoints
%send UseASkill(move=Lord::Move::deathKnight)
%advance 1
%eval in LordPlay::champion : foe.hitPoints
%eval in LordPlay::champion : hitPoints
%eval in LordPlay::champion : deathKnightUses
```

```
✓ Sent SeekTheDragon to object #1 of "LordPlay::champion"
  Accepted by state machine "day" in state forest: transition forest_dragon fires on it
✓ Advanced to 2.0 (2 event(s) processed)
  Current state: fighting
✓ foe.hitPoints (on LordPlay::champion ID: 1)
  = 15000
✓ Sent UseASkill(move=Move::deathKnight) to object #1 of "LordPlay::champion"
  Accepted by state machine "day" in state fighting: transition fighting_skill fires on it
✓ Advanced to 3.0 (2 event(s) processed)
  Current state: fighting
  3 choice points; %trace on to see them
✓ foe.hitPoints (on LordPlay::champion ID: 1)
  = 12525
✓ hitPoints (on LordPlay::champion ID: 1)
  = 4500
✓ deathKnightUses (on LordPlay::champion ID: 1)
  = 9
```

Three blows of 825 — solid ones, half the strength and two eighths — and the
dragon's tail, which never gets through. Five more rounds the same way, and
the seventh:

```
%send UseASkill(move=Lord::Move::deathKnight)
%advance 1
%send UseASkill(move=Lord::Move::deathKnight)
%advance 1
%send UseASkill(move=Lord::Move::deathKnight)
%advance 1
%send UseASkill(move=Lord::Move::deathKnight)
%advance 1
%send UseASkill(move=Lord::Move::deathKnight)
%advance 1
%eval in LordPlay::champion : foe.hitPoints
%eval in LordPlay::champion : hitPoints
%send UseASkill(move=Lord::Move::deathKnight)
%advance 1
%eval in LordPlay::champion : dragonKills
%eval in LordPlay::champion : level
%eval in LordPlay::champion : hitPoints
%eval in LordPlay::champion : deathKnightPoints
%eval in LordPlay::champion : gold
```

```
✓ foe.hitPoints (on LordPlay::champion ID: 1)
  = 564
✓ hitPoints (on LordPlay::champion ID: 1)
  = 2175
✓ Sent UseASkill(move=Move::deathKnight) to object #1 of "LordPlay::champion"
  Accepted by state machine "day" in state fighting: transition fighting_skill fires on it
✓ Advanced to 9.0 (3 event(s) processed)
  Current state: forest
  1 choice point; %trace on to see them
✓ dragonKills (on LordPlay::champion ID: 1)
  = 1
✓ level (on LordPlay::champion ID: 1)
  = 1
✓ hitPoints (on LordPlay::champion ID: 1)
  = 20
✓ deathKnightPoints (on LordPlay::champion ID: 1)
  = 40
✓ gold (on LordPlay::champion ID: 1)
  = 500
```

The same ten sends under `%schedule seed:6` end in `slain` after the seventh:
the dragon's answers fall harder, the champion's 4500 hit points run out
first, and the eighth `UseASkill` is refused — `accepts no signal UseASkill
now: state machine "day" in state slain`. He wakes at midnight, level twelve
still, and may try again.

### Every deed on its own

`%invoke <object> <action> [<parameter>=<expression> ...]` performs one of the
warrior's actions directly, outside the `day` machine, so a deed can be tried
on its own or a fight played a round at a time. A round is `strike`; the
fallen foe's spoils are `win`, which the machine performs of itself and a
direct fight must ask for. `%schedule reverse` puts the default schedule back
after the seeded dragon fight. The Old Man has thirteen hit points and a
cane, and under that schedule is three weak blows' work:

```
%clear
%load lord.sysml
%schedule reverse
%instantiate LordPlay::hero
%invoke LordPlay::hero meet monster=Lord::town.forest.level1.oldMan
%eval in LordPlay::hero : foe.hitPoints
%invoke LordPlay::hero strike
%eval in LordPlay::hero : foe.hitPoints
%eval in LordPlay::hero : hitPoints
%invoke LordPlay::hero strike
%invoke LordPlay::hero strike
%eval in LordPlay::hero : foe.hitPoints
%eval in LordPlay::hero : hitPoints
%invoke LordPlay::hero win
%eval in LordPlay::hero : foe.present
%eval in LordPlay::hero : gold
%invoke LordPlay::hero heal
%eval in LordPlay::hero : hitPoints
%eval in LordPlay::hero : gold
%invoke LordPlay::hero train
%eval in LordPlay::hero : level
%invoke LordPlay::hero deposit amount=300
%invoke LordPlay::hero newDay
%eval in LordPlay::hero : bankGold
%invoke LordPlay::hero buyWeapon weapon=Lord::town.weapons.stick
%eval in LordPlay::hero : gold
%constraint LordPlay::hero::noDebt
```

```
✓ Invoked meet on object #1 of "LordPlay::hero"
✓ foe.hitPoints (on LordPlay::hero ID: 1)
  = 13
✓ Invoked strike on object #1 of "LordPlay::hero"
✓ foe.hitPoints (on LordPlay::hero ID: 1)
  = 8
✓ hitPoints (on LordPlay::hero ID: 1)
  = 19
✓ Invoked strike on object #1 of "LordPlay::hero"
✓ Invoked strike on object #1 of "LordPlay::hero"
✓ foe.hitPoints (on LordPlay::hero ID: 1)
  = 0
✓ hitPoints (on LordPlay::hero ID: 1)
  = 18
✓ Invoked win on object #1 of "LordPlay::hero"
✓ foe.present (on LordPlay::hero ID: 1)
  = false
✓ gold (on LordPlay::hero ID: 1)
  = 573
✓ Invoked heal on object #1 of "LordPlay::hero"
✓ hitPoints (on LordPlay::hero ID: 1)
  = 20
✓ gold (on LordPlay::hero ID: 1)
  = 563
✓ Invoked train on object #1 of "LordPlay::hero"
✓ level (on LordPlay::hero ID: 1)
  = 1
✓ Invoked deposit on object #1 of "LordPlay::hero"
✓ Invoked newDay on object #1 of "LordPlay::hero"
✓ bankGold (on LordPlay::hero ID: 1)
  = 330
✓ Invoked buyWeapon on object #1 of "LordPlay::hero"
✓ gold (on LordPlay::hero ID: 1)
  = 63
✓ Constraint LordPlay::hero::noDebt passed (on LordPlay::hero ID: 1)
  standing: holds (observed: 1 run under reverse)
```

The healer charges five gold a hit point a level, the bank pays a tenth
overnight, and the Stick is two hundred. Every deed checks its own
preconditions, so the warrior's invariants hold whichever way it is reached —
through the `day` machine's guarded transitions or directly here — and
whatever its parameters say. The forest turns away a dead warrior or one
whose fights are spent, so `forestFightsLeft` never goes below zero, and a
monster of another level, so a first-level warrior never meets the Corinthian
Giant and the champion does not prey on the Small Thief; the dragon receives
the champion and no one else; the healer and the masters turn away the dead,
so the slain keep no hit points until morning; the bank moves only gold the
warrior has, and pays interest but never charges it; a shop refuses a price
below zero, the forest a foe with negative stats or gold, and the hall a
master with no hit points to take; a master refuses a twelfth-level warrior,
so `train` never makes a level thirteen; and a warrior may not slaughter
himself:

```
%instantiate LordPlay::champion
%invoke LordPlay::champion train master=Lord::town.training.turgon
%eval in LordPlay::champion : level
%invoke LordPlay::hero meet monster=Lord::town.forest.level12.corinthianGiant
%eval in LordPlay::hero : foe.present
%invoke LordPlay::champion meet monster=Lord::town.forest.level1.smallThief
%eval in LordPlay::champion : foe.present
%invoke LordPlay::hero meetTheDragon
%eval in LordPlay::hero : foe.present
%invoke LordPlay::champion meetTheDragon
%eval in LordPlay::champion : foe.name
%eval in LordPlay::champion : forestFightsLeft
%invoke LordPlay::hero deposit amount=1000
%eval in LordPlay::hero : gold
%invoke LordPlay::hero attack victim=LordPlay::hero
%eval in LordPlay::hero : playerFightsLeft
```

```
✓ Invoked train on object #21 of "LordPlay::champion"
✓ level (on LordPlay::champion ID: 21)
  = 12
✓ Invoked meet on object #1 of "LordPlay::hero"
✓ foe.present (on LordPlay::hero ID: 1)
  = false
✓ Invoked meet on object #21 of "LordPlay::champion"
✓ foe.present (on LordPlay::champion ID: 21)
  = false
✓ Invoked meetTheDragon on object #1 of "LordPlay::hero"
✓ foe.present (on LordPlay::hero ID: 1)
  = false
✓ Invoked meetTheDragon on object #21 of "LordPlay::champion"
✓ foe.name (on LordPlay::champion ID: 21)
  = "The Red Dragon"
✓ forestFightsLeft (on LordPlay::champion ID: 21)
  = 14
✓ Invoked deposit on object #1 of "LordPlay::hero"
✓ gold (on LordPlay::hero ID: 1)
  = 63
✓ Invoked attack on object #1 of "LordPlay::hero"
✓ playerFightsLeft (on LordPlay::hero ID: 1)
  = 3
```

### The skills

Each class has a master who teaches once a day: the Death Knights' castle
judges the warrior, the Mystical hut asks a riddle, the Thieves' Guild takes a
gem for the lesson. Whether the castle judges rightly is the dice, so the
default schedule grants the point; a second visit the same day is refused.
Forty points is mastery, and the master turns away a master. Midnight turns
points into uses — one per four points for the Death Knights and the thieves,
one per point for the mystics — and `useSkill` spends them when `move` names
a skill the warrior has the uses for, and does nothing when it does not:

```
%clear
%load lord.sysml
%instantiate LordPlay::hero
%invoke LordPlay::hero learnSkill
%eval in LordPlay::hero : deathKnightPoints
%invoke LordPlay::hero learnSkill
%eval in LordPlay::hero : deathKnightPoints
%invoke LordPlay::hero newDay
%eval in LordPlay::hero : deathKnightUses
%invoke LordPlay::hero meet monster=Lord::town.forest.level1.oldMan
%invoke LordPlay::hero useSkill move=Lord::Move::deathKnight
%eval in LordPlay::hero : foe.hitPoints
%eval in LordPlay::hero : hitPoints
%instantiate LordPlay::champion
%invoke LordPlay::champion learnSkill
%eval in LordPlay::champion : taughtToday
%instantiate LordPlay::heroine
%invoke LordPlay::heroine learnSkill
%invoke LordPlay::heroine newDay
%eval in LordPlay::heroine : mysticalUses
%invoke LordPlay::heroine meet monster=Lord::town.forest.level1.oldMan
%invoke LordPlay::heroine useSkill move=Lord::Move::pinchRealHard
%eval in LordPlay::heroine : foe.hitPoints
%eval in LordPlay::heroine : hitPoints
%eval in LordPlay::heroine : mysticalUses
%invoke LordPlay::heroine useSkill move=Lord::Move::pinchRealHard
%eval in LordPlay::heroine : foe.hitPoints
```

```
✓ deathKnightPoints (on LordPlay::hero ID: 1)
  = 1
✓ deathKnightPoints (on LordPlay::hero ID: 1)
  = 1
✓ deathKnightUses (on LordPlay::hero ID: 1)
  = 0
✓ foe.hitPoints (on LordPlay::hero ID: 1)
  = 13
✓ hitPoints (on LordPlay::hero ID: 1)
  = 20
✓ taughtToday (on LordPlay::champion ID: 17)
  = false
✓ mysticalUses (on LordPlay::heroine ID: 29)
  = 1
✓ foe.hitPoints (on LordPlay::heroine ID: 29)
  = 3
✓ hitPoints (on LordPlay::heroine ID: 29)
  = 19
✓ mysticalUses (on LordPlay::heroine ID: 29)
  = 0
✓ foe.hitPoints (on LordPlay::heroine ID: 29)
  = 3
```

One point is no use, so the hero's power move is turned away and the Old Man
untouched; the champion's forty points leave nothing to teach; the heroine's
one use was Pinch Real Hard, two blows in one, ten off the Old Man, who
answered with his cane, and her second pinch, with no use left, did nothing.
The spells cost their uses in the game's order — one to pinch, four to
disappear, which always gets away, eight for the heat wave, twelve for the
light shield that halves every blow until the fight ends, sixteen to shatter,
twenty for the mind heal. The `day` machine asks the same of `UseASkill`, so
the browser dims a spell the warrior cannot afford.

### At the inn

`flirt` asks a favour of Violet or of Seth Able, whichever suits the warrior's
sex; each costs charm to be granted and experience by level to ask, once a
day. The heroine has the charm for the bard's hand but not the five
experience a wink costs at level one, so her first wink is refused; a boar
pays for it, and the wink adds a point of charm. Marrying the bard costs no
experience at all — the next day, since the wink was today's favour. A room
at the inn is free to a warrior of 101 charm; a divorce leaves the bard's
bride with thirty:

```
%clear
%load lord.sysml
%instantiate LordPlay::heroine
%invoke LordPlay::heroine flirt favour=Lord::town.inn.sethAble.wink
%eval in LordPlay::heroine : charm
%invoke LordPlay::heroine meet monster=Lord::town.forest.level1.wildBoar
%invoke LordPlay::heroine strike
%invoke LordPlay::heroine strike
%invoke LordPlay::heroine win
%eval in LordPlay::heroine : experience
%invoke LordPlay::heroine flirt favour=Lord::town.inn.sethAble.wink
%eval in LordPlay::heroine : charm
%invoke LordPlay::heroine flirt favour=Lord::town.inn.sethAble.marryHim
%eval in LordPlay::heroine : spouse
%invoke LordPlay::heroine newDay
%invoke LordPlay::heroine flirt favour=Lord::town.inn.sethAble.marryHim
%eval in LordPlay::heroine : spouse
%invoke LordPlay::heroine buyRoom
%eval in LordPlay::heroine : gold
%invoke LordPlay::heroine divorce
%eval in LordPlay::heroine : charm
```

```
✓ charm (on LordPlay::heroine ID: 1)
  = 125
✓ experience (on LordPlay::heroine ID: 1)
  = 5
✓ charm (on LordPlay::heroine ID: 1)
  = 126
✓ spouse (on LordPlay::heroine ID: 1)
  = Spouse::nobody
✓ spouse (on LordPlay::heroine ID: 1)
  = Spouse::sethAble
✓ gold (on LordPlay::heroine ID: 1)
  = 558
✓ charm (on LordPlay::heroine ID: 1)
  = 30
```

The hero, with one point of charm, is refused Violet's hand and the bard's
wink alike, pays four hundred for his room, and cannot bribe the bartender
before level two or trade gems he does not have:

```
%instantiate LordPlay::hero
%invoke LordPlay::hero flirt favour=Lord::town.inn.violet.marryHer
%eval in LordPlay::hero : spouse
%invoke LordPlay::hero flirt favour=Lord::town.inn.sethAble.wink
%eval in LordPlay::hero : charm
%invoke LordPlay::hero buyRoom
%eval in LordPlay::hero : gold
%invoke LordPlay::hero bribeTheBartender
%eval in LordPlay::hero : bribed
%invoke LordPlay::hero tradeGems stat=Lord::Stat::hitPoints
%eval in LordPlay::hero : maxHitPoints
```

```
✓ spouse (on LordPlay::hero ID: 21)
  = Spouse::nobody
✓ charm (on LordPlay::hero ID: 21)
  = 1
✓ gold (on LordPlay::hero ID: 21)
  = 100
✓ bribed (on LordPlay::hero ID: 21)
  = false
✓ maxHitPoints (on LordPlay::hero ID: 21)
  = 20
```

### The slaughter

`attack` is a fight with another warrior, three a day, against the `rival`
unless `victim` names another. The loser's gold and a tenth of the loser's
experience go to the winner, who counts the kill — a slain sleeper's gems too,
though an attacker who dies keeps his — and the slain lie until morning. Two
warriors whose armour turns every blow of the other's, with no skill to call
on, break off with nothing won or lost but the fight. A warrior
asleep at the inn is out of reach unless the attacker has bribed the
bartender and is within a level of the sleeper:

```
%clear
%load lord.sysml
%instantiate LordPlay::hero
%instantiate LordPlay::rival
%invoke LordPlay::hero attack
%eval in LordPlay::hero : gold
%eval in LordPlay::hero : gems
%eval in LordPlay::hero : experience
%eval in LordPlay::hero : playerKills
%eval in LordPlay::rival : alive
%invoke LordPlay::hero attack
%eval in LordPlay::hero : playerFightsLeft
%instantiate LordPlay::heroine
%invoke LordPlay::heroine buyRoom
%invoke LordPlay::hero attack victim=LordPlay::heroine
%eval in LordPlay::hero : playerFightsLeft
```

```
✓ gold (on LordPlay::hero ID: 1)
  = 620
✓ gems (on LordPlay::hero ID: 1)
  = 1
✓ experience (on LordPlay::hero ID: 1)
  = 5
✓ playerKills (on LordPlay::hero ID: 1)
  = 1
✓ alive (on LordPlay::rival ID: 13)
  = false
✓ playerFightsLeft (on LordPlay::hero ID: 1)
  = 2
✓ playerFightsLeft (on LordPlay::hero ID: 1)
  = 2
```

The dead rival is refused as a target, and so is the heroine in her room;
neither refusal costs a fight. Picking on the `champion` ends the other way,
and the rewards go the other way with it:

```
%instantiate LordPlay::champion
%invoke LordPlay::hero attack victim=LordPlay::champion
%eval in LordPlay::hero : alive
%eval in LordPlay::hero : gold
%eval in LordPlay::champion : gold
%eval in LordPlay::champion : playerKills
```

```
✓ alive (on LordPlay::hero ID: 1)
  = false
✓ gold (on LordPlay::hero ID: 1)
  = 0
✓ gold (on LordPlay::champion ID: 39)
  = 1120
✓ playerKills (on LordPlay::champion ID: 39)
  = 1
```

### Other places

Off the town square: the fairies grant a blessing to whoever asks, once a
day — a kiss that heals, a horse, a sad story worth a gem, or lore — and one
may be caught and carried, once a day too, to revive the warrior once in the
forest or at the dragon's feet, or to open the bank's vault to a thief. The
Dark Cloak Tavern changes a warrior's profession and takes wagers; the Old
Hag trades a gem for a hit point and a full heal. Midnight pays the bank's
interest, gives the fights and the uses back, and the town crier's news is
the dice:

```
%clear
%load lord.sysml
%instantiate LordPlay::hero
%invoke LordPlay::hero deposit amount=400
%invoke LordPlay::hero catchAFairy
%eval in LordPlay::hero : fairy
%invoke LordPlay::hero robTheBank
%eval in LordPlay::hero : gold
%invoke LordPlay::hero changeProfession profession=Lord::CharacterClass::thievingSkills
%invoke LordPlay::hero robTheBank
%eval in LordPlay::hero : gold
%eval in LordPlay::hero : fairy
%invoke LordPlay::hero gamble
%eval in LordPlay::hero : gold
%invoke LordPlay::hero newDay
%eval in LordPlay::hero : bankGold
%eval in LordPlay::hero : news
```

```
✓ fairy (on LordPlay::hero ID: 1)
  = true
✓ gold (on LordPlay::hero ID: 1)
  = 100
✓ gold (on LordPlay::hero ID: 1)
  = 1100
✓ fairy (on LordPlay::hero ID: 1)
  = false
✓ gold (on LordPlay::hero ID: 1)
  = 1200
✓ bankGold (on LordPlay::hero ID: 1)
  = 440
✓ news (on LordPlay::hero ID: 1)
  = "More children are missing today."
```

A Death Knight with a fairy in his pocket cannot pick the lock; a thief with
one takes a thousand a level and the fairy is spent.

### What the solver says

`%check` asks whether a requirement's conditions can hold at all, `%solve`
fills in values that satisfy them, and `%explain` names the conditions that
conflict when they cannot. `FirstDayShopping` is the starting purse plus at
most fifteen fights of first-level gold, spent on a weapon; `FirstDayLongSword`
asks for the Long Sword:

```
%check LordOdds::FirstDayShopping
%solve LordOdds::FirstDayShopping
%check LordOdds::FirstDayLongSword
%explain LordOdds::FirstDayLongSword
```

```
✓ Requirement FirstDayShopping is satisfiable (z3, 11ms)
  LordOdds::FirstDayShopping::forestGold = 500
  LordOdds::FirstDayShopping::startingGold = 500
  LordOdds::FirstDayShopping::weaponPrice = 1000
  standing: satisfiable (witnessed: 1 query by solve)
✓ Requirement FirstDayShopping has values satisfying it (z3, 8ms)
  Synthesised:
    LordOdds::FirstDayShopping::forestGold = 500
    LordOdds::FirstDayShopping::startingGold = 500
    LordOdds::FirstDayShopping::weaponPrice = 1000
  One witness: a solver may answer with any of the assignments that satisfy it.
  standing: satisfiable (witnessed: 1 query by solve)
✗ Requirement FirstDayLongSword is unsatisfiable (z3, 8ms)
  standing: unsatisfiable (proved over inputs: 1 query by solve)
✗ Requirement FirstDayLongSword is unsatisfiable: 4 conditions conflict (z3, 40ms)
  Every condition below is needed: dropping any one leaves the rest satisfiable.
  1. required condition: `startingGold == 500` …
  2. required condition: `forestGold <= 15 * 110` …
  3. required condition: `weaponPrice <= startingGold + forestGold` …
  4. required condition: `weaponPrice >= 10000` …
  standing: unsatisfiable (proved over inputs: 1 query by solve)
```

A Dagger on the first day, yes; a Long Sword, no, and the four conditions that
rule it out are named.

`%optimize` minimizes an analysis case's objective. `ToughEnough` asks the
fewest hit points that win the straight brawl with the dragon — mighty blows
both ways — holding the best of both shops; `ToughEnoughWithPowerMoves` asks
the same of a Death Knight who opens every round with a power move and takes
the dragon's hardest answer every round:

```
%optimize LordOdds::ToughEnough
%optimize LordOdds::ToughEnoughWithPowerMoves
```

```
✓ Analysis ToughEnough is optimized (z3, 7ms)
  minimize fewestHitPoints = `hitPoints`: 18201
  LordOdds::ToughEnough::defense = 600
  LordOdds::ToughEnough::hitPoints = 18201
  LordOdds::ToughEnough::roundsToKill = 14
  LordOdds::ToughEnough::strength = 1100
  standing: satisfiable (witnessed: 1 query by solve)
✓ Analysis ToughEnoughWithPowerMoves is optimized (z3, 9ms)
  minimize fewestHitPoints = `hitPoints`: 5601
  LordOdds::ToughEnoughWithPowerMoves::defense = 600
  LordOdds::ToughEnoughWithPowerMoves::hitPoints = 5601
  LordOdds::ToughEnoughWithPowerMoves::roundsToKill = 5
  LordOdds::ToughEnoughWithPowerMoves::strength = 1100
  standing: satisfiable (witnessed: 1 query by solve)
```

18201 hit points: no warrior in the game has them, which is why the game
gives its warriors skills. Five mighty power moves need 5601 — the four
stomps of 1400 a champion of 600 defense may take before the fifth move
lands, and one more. The shipped champion has 4500 and ten power moves, and
wins or dies by how the dice weigh them, as the two seeds above show.
`PowerMoves` asks the fewest lessons that give three uses to a warrior who
will gain five levels, and `GemsForDefense` the gems for five points of
defense: seven and ten.

## A whole game

The game can be won from the boat. `TestAWarriorCanSlayTheDragon` in
[`web/lord`](web/lord/) plays the model through the same `Game` the browser
uses — the menu's keys, nothing else — with a plain strategy: hunt while the
fights and the hit points last, run when a foe is winning, heal, bank the
gold, buy the best weapon and armour in reach, train when the master will
have you, learn the guild's skill daily, sleep at the inn, and seek the
dragon at level twelve. It plays a Death Knight, a Mystical and a Thieving
warrior under three seeds each to the kill and fails if any deed the
strategy relies on is refused or the dragon is not slain within the days it
allows:

```bash
go test ./web/lord -run TestAWarriorCanSlayTheDragon -v
```

```
=== RUN   TestAWarriorCanSlayTheDragon/seed1_deathKnight
    playthrough_test.go:333: dragon slain on day 107 after 11024 moves; level 12, 1587 gold banked, born again at level 1
=== RUN   TestAWarriorCanSlayTheDragon/seed2_mysticalSkills
    playthrough_test.go:333: dragon slain on day 135 after 14771 moves; level 12, 1389 gold banked, born again at level 1
=== RUN   TestAWarriorCanSlayTheDragon/seed3_thievingSkills
    playthrough_test.go:333: dragon slain on day 97 after 10555 moves; level 12, 1510 gold banked, born again at level 1
```

A hundred days or so, as the game took its players; the day-by-day log the
test keeps (`-v` prints it) is where a rule that stalls a warrior — a level
he cannot earn, a foe he cannot survive, a purse he cannot refill — shows
up first.

## In the browser

[`web/`](web/) plays the model as the game a player saw: a terminal-styled page
with the warrior's stats, the menu of the state the day machine is in, and the
keys the game took. The model runtime is compiled to WebAssembly and runs in
the tab, so there is no game server: the page is static files, and
<https://lord.opensysml.org/> is them, published by [GitHub Pages](.github/workflows/pages.yml)
from every push to `main`. Build and serve them yourself with any file server:

```bash
make web
python3 -m http.server -d build/web 8000
```

Open <http://localhost:8000/>, name your warrior, choose a sex and a skill
guild, and the town square is drawn. Press a menu's key or click its line; a
choice that needs more — how much to deposit, which weapon, which blessing,
which skill — asks for it, and <kbd>Esc</kbd> takes the question back. A
fight is a round a key: the foe's name, weapon and hit points stand in the
heading while it lasts, and the menu is attack, skill and run until it ends.
The page is the model's, not a copy of it:

- **Each browser plays its own model.** The page fetches `lord.sysml` and hands it
  to the runtime in `lord.wasm`, which parses and checks it, instantiates
  `LordPlay::hero` and starts its `day` machine — all in the browser. Nothing
  is sent anywhere or shared with another browser. Edit the model in
  `build/web/`, reload, and the changed rules are what you play.
- **The save is the game replayed.** After every key the page keeps, in the
  browser's `localStorage`, the game's seed, the character and the keys pressed
  so far, with a digest of the model they were played against. Opening the page
  again makes a new game from the seed and character and plays the keys back:
  the dice being seeded, the warrior returns exactly as left. A save from
  another revision of the model, or one of whose moves the menu no longer
  offers, is refused rather than replayed into a different game, and the
  character screen is shown; *Retire* forgets the save. Two tabs that resume
  the same warrior play apart, so the save follows the tab that wrote it
  last and the other is told its moves are not kept.
- **The menu is the state machine.** Each key is one of the `accept` triggers
  of the transitions out of the current state; a choice the guard refuses
  (*Seek the Red Dragon* at level one, robbing the bank untrained, a room with
  no gold, a spell without the uses) is drawn dimmed and, pressed, is refused
  by the machine, not the page. Where a transition's deed takes an argument —
  the fairies' blessing, a wager, a profession, a favour, a stat for the gems,
  the skill to use — the page asks for it and sends the signal or performs
  the action with the argument bound to the model's own value
  (`Blessing::horse`, `town.inn.violet.wink`, `Move::heatWave`), with the same
  guard deciding.
- **The stats are the warrior's features.** Name, level, hit points, gold in
  hand and in the bank, experience, gems, charm, the fights left, the
  skill points and the foe before the warrior are read from the instance
  after every command; the page never adds or subtracts.
- **What happened is what the schedule decided.** The foe the forest served,
  how hard each blow landed and which attack the dragon chose are the run's
  recorded choices; every other line of the log is a difference between the
  warrior before and after.

`make web` assembles `build/web/` (`WEB_OUT` to put it
elsewhere): `lord.wasm` built from [`web/main.go`](web/main.go) with
`GOOS=js GOARCH=wasm`, Go's `wasm_exec.js` loader, the page, and a copy of
the model. The page needs an HTTP server only because browsers will not fetch
WebAssembly from `file://`; the one above is Python's, and any other serves.
The binary carries the whole SysML toolchain and its bundled standard library,
so it is large — about 57 MB, 13 MB compressed — and a model that does not
play (one with errors, or without `LordPlay::hero` and its day machine) is
refused when the page loads it, before any warrior is made.

The game itself is the [`web/lord`](web/lord/) package: one `Game` per
warrior, that sends the day machine the signal a key stands for, invokes the
deed an argument-taking choice performs, and projects the hero's features for
the page. It has no dependence on the browser and is what the tests exercise;
`main.go` only hands it to JavaScript.

The package is written against OpenSysML's public Go API alone,
[`client/opensysml`](https://pkg.go.dev/github.com/Open-MBEE/OpenSysML/client/opensysml),
as any program outside that repository must be; the version it plays is the
one `go.mod` pins. A `Game` opens an in-process client with `opensysml.New`, parses the model
with `ParseSource`, and plays it in a `Session` (`opensysml.OpenSession`), the
API's persistent shape: the session keeps the hero it instantiated, the day
machine's state, the clock and the seeded schedule between keys. The menu is
`Session.Transitions` filtered to the signal triggers out of the active state,
each dimmed or lit by `Session.Accepts` — asked with the very arguments the
key would send, so a spell is lit only when the machine would take it; a key
is `Session.Send` followed by `Session.Advance`, which runs the deed and the
completion transitions after it; an argument-taking choice is
`Session.Perform` on the hero, refused when its `Performance.TurnedAway()` —
the opening decision left by its else branch — and narrated from its
`ChoicePoint`s; the stats are `Session.Feature` reads, and the values a
choice binds (`Blessing::horse`, `town.inn.violet.wink`) are
`Session.Evaluate` in the hero's scope. Each direct deed rolls under a seed of
its own that the game's seed determines (`Session.SetSchedule`), so a seed and
a sequence of keys replay the same day.

## What the model leaves open, and where it guesses

The dice are the schedule. The game rolls which monster the forest serves,
how hard each swing lands, which attack the dragon answers with, whether a
foe lets a warrior run, what the fairies grant, whether a monster drops a
gem, whether the castle judges rightly, whether a night upstairs leaves a
child, which song the bard sings and what the crier calls; the model leaves
each open as a decision with several true guards, and lets the executor, the
checker or a replayed witness make it.

The numbers are the game's where the game published them — the shops, the
masters, the monsters' names, weapons, hit points, strength, gold and
experience, the dragon's 15000 and 2000, the inn's 400 a level, Violet's 100
charm and Seth Able's 125, the forty points of mastery, the twenty hit points
a warrior starts with and the hit points, strength and defense each level
adds. Where it did not, the model says so in a comment and picks: a blow is
half the striker's strength plus the dice's eighths of it, less the target's
defense; forest monsters have no published defense and are given none; the
dragon's breath is set at a thousand points through any armour, the stomp at
its strength, the claw at half and the tail at a quarter, each less the
warrior's defense; a skill point is one use per four points for the Death
Knights and the thieves and one per point for the mystics; a bribe is four
times a room; a bank robbery takes a thousand gold a level; a child grows up
at once to take a blow; the dragon's slayer, born again, is given a full
day's forest fights along with the level-one stats. None of these is a rule
of the executor — each is an
attribute or a calculation in `lord.sysml`, changed by editing it.

The game had a screen, a modem and a hundred players on one bulletin board;
the model has warriors, and `attack` takes one of them as its `victim`. There
is no character file: a warrior lives as long as the REPL session, the
`-instantiate` that made it, or the browser tab that plays it.
