// Legend of the Red Dragon, the 1989 BBS door game: the realm, a warrior's day,
// what a solver can say about the dragon, and the views. README.md runs it.

// The realm: fighters, the shops' stock, the masters, the forest with its twelve
// levels of monsters and the dragon, the inn and its locals, the tavern, the town.
package Lord {
    private import ScalarValues::*;

    // The three skill trees; a warrior studies one at a time and keeps all three.
    enum def CharacterClass {
        enum deathKnight;
        enum mysticalSkills;
        enum thievingSkills;
    }

    enum def Sex {
        enum male;
        enum female;
    }

    // Whom a warrior is married to; the barmaid takes grooms, the bard brides.
    enum def Spouse {
        enum nobody;
        enum violet;
        enum sethAble;
    }

    // What a warrior does with a round of combat: swing, or spend a skill.
    enum def Move {
        enum attack;
        enum deathKnight;
        enum thieving;
        enum pinchRealHard;
        enum disappear;
        enum heatWave;
        enum lightShield;
        enum shatter;
        enum mindHeal;
    }

    // The stat the bartender raises for two gems.
    enum def Stat {
        enum strength;
        enum defense;
        enum hitPoints;
    }

    // What a warrior may ask the fairies for.
    enum def Blessing {
        enum kiss;
        enum horse;
        enum sadStory;
        enum lore;
    }

    // Anyone who trades blows: a warrior, a forest monster, a master, the dragon.
    abstract part def Fighter {
        attribute name : String;
        attribute hitPoints : Integer;
        attribute strength : Integer;
        attribute defense : Integer;
    }

    // A forest monster as the game's enemy file lists it; monsters have no armour.
    part def Monster :> Fighter {
        attribute weapon : String default = "";
        attribute level : Integer;
        attribute gold : Integer;
        attribute experience : Integer;
        attribute :>> defense default = 0;
        attribute deadly : Boolean default = false;
    }

    // The one monster the game is named for; only a level-twelve warrior meets it.
    // Its breath burns for a thousand whatever the armour; its other three attacks strike.
    part def Dragon :> Monster {
        attribute :>> name = "The Red Dragon";
        attribute :>> weapon = "Flaming Breath";
        attribute :>> level = 12;
        attribute :>> hitPoints = 15000;
        attribute :>> strength = 2000;
        attribute :>> gold = 0;
        attribute :>> experience = 0;
        attribute breath : Integer = 1000;
    }

    // A master of Turgon's hall: beating one is the only way up a level.
    part def Master :> Fighter {
        attribute weapon : String;
        attribute teaches : Integer;
        attribute experienceRequired : Integer;
        attribute hitPointsTaught : Integer;
        attribute strengthTaught : Integer;
        attribute defenseTaught : Integer;
    }

    // A tier is the item's place in its shop's list; the game sells one at a time.
    part def Weapon {
        attribute name : String;
        attribute tier : Integer;
        attribute strength : Integer;
        attribute price : Integer;
    }

    part def Armour {
        attribute name : String;
        attribute tier : Integer;
        attribute defense : Integer;
        attribute price : Integer;
    }

    // King Arthur's Weapons, as the game lists them.
    part def WeaponShop {
        part stick : Weapon { attribute :>> name = "Stick"; attribute :>> tier = 1; attribute :>> strength = 5; attribute :>> price = 200; }
        part dagger : Weapon { attribute :>> name = "Dagger"; attribute :>> tier = 2; attribute :>> strength = 10; attribute :>> price = 1000; }
        part shortSword : Weapon { attribute :>> name = "Short Sword"; attribute :>> tier = 3; attribute :>> strength = 20; attribute :>> price = 3000; }
        part longSword : Weapon { attribute :>> name = "Long Sword"; attribute :>> tier = 4; attribute :>> strength = 30; attribute :>> price = 10000; }
        part hugeAxe : Weapon { attribute :>> name = "Huge Axe"; attribute :>> tier = 5; attribute :>> strength = 40; attribute :>> price = 30000; }
        part boneCruncher : Weapon { attribute :>> name = "Bone Cruncher"; attribute :>> tier = 6; attribute :>> strength = 60; attribute :>> price = 100000; }
        part twinSwords : Weapon { attribute :>> name = "Twin Swords"; attribute :>> tier = 7; attribute :>> strength = 80; attribute :>> price = 150000; }
        part powerAxe : Weapon { attribute :>> name = "Power Axe"; attribute :>> tier = 8; attribute :>> strength = 120; attribute :>> price = 200000; }
        part ablesSword : Weapon { attribute :>> name = "Able's Sword"; attribute :>> tier = 9; attribute :>> strength = 180; attribute :>> price = 400000; }
        part wansWeapon : Weapon { attribute :>> name = "Wan's Weapon"; attribute :>> tier = 10; attribute :>> strength = 250; attribute :>> price = 1000000; }
        part spearOfGold : Weapon { attribute :>> name = "Spear of Gold"; attribute :>> tier = 11; attribute :>> strength = 350; attribute :>> price = 4000000; }
        part crystalShard : Weapon { attribute :>> name = "Crystal Shard"; attribute :>> tier = 12; attribute :>> strength = 500; attribute :>> price = 10000000; }
        part nirasTeeth : Weapon { attribute :>> name = "Nira's Teeth"; attribute :>> tier = 13; attribute :>> strength = 800; attribute :>> price = 40000000; }
    }

    // Abdul's Armour, as the game lists it.
    part def ArmourShop {
        part coat : Armour { attribute :>> name = "Coat"; attribute :>> tier = 1; attribute :>> defense = 1; attribute :>> price = 200; }
        part heavyCoat : Armour { attribute :>> name = "Heavy Coat"; attribute :>> tier = 2; attribute :>> defense = 3; attribute :>> price = 1000; }
        part leatherVest : Armour { attribute :>> name = "Leather Vest"; attribute :>> tier = 3; attribute :>> defense = 10; attribute :>> price = 3000; }
        part bronzeArmour : Armour { attribute :>> name = "Bronze Armor"; attribute :>> tier = 4; attribute :>> defense = 15; attribute :>> price = 10000; }
        part ironArmour : Armour { attribute :>> name = "Iron Armor"; attribute :>> tier = 5; attribute :>> defense = 25; attribute :>> price = 30000; }
        part graphiteArmour : Armour { attribute :>> name = "Graphite Armor"; attribute :>> tier = 6; attribute :>> defense = 35; attribute :>> price = 100000; }
        part erdricksArmour : Armour { attribute :>> name = "Erdrick's Armor"; attribute :>> tier = 7; attribute :>> defense = 50; attribute :>> price = 150000; }
        part armourOfDeath : Armour { attribute :>> name = "Armor of Death"; attribute :>> tier = 8; attribute :>> defense = 75; attribute :>> price = 200000; }
        part ablesArmour : Armour { attribute :>> name = "Able's Armor"; attribute :>> tier = 9; attribute :>> defense = 100; attribute :>> price = 400000; }
        part fullBodyArmour : Armour { attribute :>> name = "Full Body Armor"; attribute :>> tier = 10; attribute :>> defense = 150; attribute :>> price = 1000000; }
        part bloodArmour : Armour { attribute :>> name = "Blood Armor"; attribute :>> tier = 11; attribute :>> defense = 225; attribute :>> price = 4000000; }
        part magicProtection : Armour { attribute :>> name = "Magic Protection"; attribute :>> tier = 12; attribute :>> defense = 300; attribute :>> price = 10000000; }
        part belarsMail : Armour { attribute :>> name = "Belar's Mail"; attribute :>> tier = 13; attribute :>> defense = 400; attribute :>> price = 40000000; }
    }

    // Turgon's Warrior Training: one master per level a warrior can still gain.
    part def TrainingHall {
        part halder : Master { attribute :>> name = "Halder"; attribute :>> weapon = "Short Sword"; attribute :>> teaches = 2; attribute :>> experienceRequired = 100; attribute :>> hitPoints = 15; attribute :>> strength = 10; attribute :>> defense = 2; attribute :>> hitPointsTaught = 10; attribute :>> strengthTaught = 5; attribute :>> defenseTaught = 2; }
        part barak : Master { attribute :>> name = "Barak"; attribute :>> weapon = "Battle Axe"; attribute :>> teaches = 3; attribute :>> experienceRequired = 400; attribute :>> hitPoints = 25; attribute :>> strength = 15; attribute :>> defense = 4; attribute :>> hitPointsTaught = 15; attribute :>> strengthTaught = 7; attribute :>> defenseTaught = 3; }
        part aragorn : Master { attribute :>> name = "Aragorn"; attribute :>> weapon = "Twin Swords"; attribute :>> teaches = 4; attribute :>> experienceRequired = 1000; attribute :>> hitPoints = 40; attribute :>> strength = 22; attribute :>> defense = 7; attribute :>> hitPointsTaught = 20; attribute :>> strengthTaught = 10; attribute :>> defenseTaught = 5; }
        part olodrin : Master { attribute :>> name = "Olodrin"; attribute :>> weapon = "Power Axe"; attribute :>> teaches = 5; attribute :>> experienceRequired = 4000; attribute :>> hitPoints = 60; attribute :>> strength = 32; attribute :>> defense = 10; attribute :>> hitPointsTaught = 30; attribute :>> strengthTaught = 12; attribute :>> defenseTaught = 10; }
        part sandtiger : Master { attribute :>> name = "Sandtiger"; attribute :>> weapon = "Blessed Sword"; attribute :>> teaches = 6; attribute :>> experienceRequired = 10000; attribute :>> hitPoints = 90; attribute :>> strength = 45; attribute :>> defense = 15; attribute :>> hitPointsTaught = 50; attribute :>> strengthTaught = 20; attribute :>> defenseTaught = 15; }
        part sparhawk : Master { attribute :>> name = "Sparhawk"; attribute :>> weapon = "Double Bladed Sword"; attribute :>> teaches = 7; attribute :>> experienceRequired = 40000; attribute :>> hitPoints = 130; attribute :>> strength = 60; attribute :>> defense = 20; attribute :>> hitPointsTaught = 75; attribute :>> strengthTaught = 35; attribute :>> defenseTaught = 22; }
        part atsukoSensei : Master { attribute :>> name = "Atsuko Sensei"; attribute :>> weapon = "Huge Curved Blade"; attribute :>> teaches = 8; attribute :>> experienceRequired = 100000; attribute :>> hitPoints = 180; attribute :>> strength = 80; attribute :>> defense = 27; attribute :>> hitPointsTaught = 125; attribute :>> strengthTaught = 50; attribute :>> defenseTaught = 35; }
        part aladdin : Master { attribute :>> name = "Aladdin"; attribute :>> weapon = "Shiny Lamp"; attribute :>> teaches = 9; attribute :>> experienceRequired = 400000; attribute :>> hitPoints = 250; attribute :>> strength = 105; attribute :>> defense = 35; attribute :>> hitPointsTaught = 185; attribute :>> strengthTaught = 75; attribute :>> defenseTaught = 60; }
        part princeCaspian : Master { attribute :>> name = "Prince Caspian"; attribute :>> weapon = "Flashing Rapier"; attribute :>> teaches = 10; attribute :>> experienceRequired = 1000000; attribute :>> hitPoints = 350; attribute :>> strength = 140; attribute :>> defense = 45; attribute :>> hitPointsTaught = 250; attribute :>> strengthTaught = 110; attribute :>> defenseTaught = 80; }
        part gandalf : Master { attribute :>> name = "Gandalf"; attribute :>> weapon = "Huge Fireballs"; attribute :>> teaches = 11; attribute :>> experienceRequired = 4000000; attribute :>> hitPoints = 500; attribute :>> strength = 190; attribute :>> defense = 60; attribute :>> hitPointsTaught = 350; attribute :>> strengthTaught = 150; attribute :>> defenseTaught = 120; }
        part turgon : Master { attribute :>> name = "Turgon"; attribute :>> weapon = "Able's Sword"; attribute :>> teaches = 12; attribute :>> experienceRequired = 10000000; attribute :>> hitPoints = 800; attribute :>> strength = 260; attribute :>> defense = 80; attribute :>> hitPointsTaught = 550; attribute :>> strengthTaught = 200; attribute :>> defenseTaught = 150; }
    }

    // One level of the forest: the eleven monsters a warrior of that level meets.
    part def ForestLevel {
        attribute level : Integer;
    }

    // Chance's tavern, hidden in the forest: change your profession, gamble with the old man.
    part def DarkCloakTavern {
        attribute gemsForTheRecords : Integer = 2;
        attribute oddsInTheHousesFavour : Integer = 49;
    }

    // Teesha and Nolan: a blessing for the asking, or a fairy for the catching.
    part def FairyGlade {
        attribute loreExperiencePerLevel : Integer = 10;
    }

    // The forest: twelve levels of monsters as the game's enemy file lists them
    // (strength, hit points, gold, experience; the deadliest of each level marked),
    // the Red Dragon, and the places a warrior stumbles on between fights.
    part def Forest {
        part level1 : ForestLevel {
            attribute :>> level = 1;
            part smallThief : Monster { attribute :>> name = "Small Thief"; attribute :>> weapon = "Small Dagger"; attribute :>> level = 1; attribute :>> hitPoints = 9; attribute :>> strength = 6; attribute :>> gold = 56; attribute :>> experience = 2; }
            part rudeBoy : Monster { attribute :>> name = "Rude Boy"; attribute :>> weapon = "Cudgel"; attribute :>> level = 1; attribute :>> hitPoints = 7; attribute :>> strength = 3; attribute :>> gold = 7; attribute :>> experience = 3; }
            part oldMan : Monster { attribute :>> name = "Old Man"; attribute :>> weapon = "Cane"; attribute :>> level = 1; attribute :>> hitPoints = 13; attribute :>> strength = 5; attribute :>> gold = 73; attribute :>> experience = 4; }
            part largeGreenRat : Monster { attribute :>> name = "Large Green Rat"; attribute :>> weapon = "Sharp Teeth"; attribute :>> level = 1; attribute :>> hitPoints = 4; attribute :>> strength = 3; attribute :>> gold = 32; attribute :>> experience = 1; }
            part wildBoar : Monster { attribute :>> name = "Wild Boar"; attribute :>> weapon = "Sharp Tusks"; attribute :>> level = 1; attribute :>> hitPoints = 9; attribute :>> strength = 10; attribute :>> gold = 58; attribute :>> experience = 5; }
            part uglyOldHag : Monster { attribute :>> name = "Ugly Old Hag"; attribute :>> weapon = "Garlic Breath"; attribute :>> level = 1; attribute :>> hitPoints = 9; attribute :>> strength = 6; attribute :>> gold = 109; attribute :>> experience = 4; }
            part largeMosquito : Monster { attribute :>> name = "Large Mosquito"; attribute :>> weapon = "Blood Sucker"; attribute :>> level = 1; attribute :>> hitPoints = 3; attribute :>> strength = 2; attribute :>> gold = 46; attribute :>> experience = 2; }
            part branTheWarrior : Monster { attribute :>> name = "Bran The Warrior"; attribute :>> weapon = "Short Sword"; attribute :>> level = 1; attribute :>> hitPoints = 15; attribute :>> strength = 12; attribute :>> gold = 234; attribute :>> experience = 10; attribute :>> deadly = true; }
            part evilWretch : Monster { attribute :>> name = "Evil Wretch"; attribute :>> weapon = "Finger Nail"; attribute :>> level = 1; attribute :>> hitPoints = 12; attribute :>> strength = 7; attribute :>> gold = 76; attribute :>> experience = 3; }
            part smallBear : Monster { attribute :>> name = "Small Bear"; attribute :>> weapon = "Claws"; attribute :>> level = 1; attribute :>> hitPoints = 7; attribute :>> strength = 9; attribute :>> gold = 154; attribute :>> experience = 6; }
            part smallTroll : Monster { attribute :>> name = "Small Troll"; attribute :>> weapon = "Uglyness"; attribute :>> level = 1; attribute :>> hitPoints = 14; attribute :>> strength = 6; attribute :>> gold = 87; attribute :>> experience = 5; }
        }
        part level2 : ForestLevel {
            attribute :>> level = 2;
            part greenPython : Monster { attribute :>> name = "Green Python"; attribute :>> weapon = "Dripping Fangs"; attribute :>> level = 2; attribute :>> hitPoints = 17; attribute :>> strength = 13; attribute :>> gold = 80; attribute :>> experience = 6; }
            part gathTheBarbarian : Monster { attribute :>> name = "Gath The Barbarian"; attribute :>> weapon = "Huge Spiked Club"; attribute :>> level = 2; attribute :>> hitPoints = 13; attribute :>> strength = 12; attribute :>> gold = 134; attribute :>> experience = 9; }
            part evilWoodNymph : Monster { attribute :>> name = "Evil Wood Nymph"; attribute :>> weapon = "Flirtatios Behavior"; attribute :>> level = 2; attribute :>> hitPoints = 10; attribute :>> strength = 15; attribute :>> gold = 160; attribute :>> experience = 11; }
            part fedrickTheLimpingBaboon : Monster { attribute :>> name = "Fedrick The Limping Baboon"; attribute :>> weapon = "Scary Faces"; attribute :>> level = 2; attribute :>> hitPoints = 23; attribute :>> strength = 8; attribute :>> gold = 97; attribute :>> experience = 6; }
            part wildMan : Monster { attribute :>> name = "Wild Man"; attribute :>> weapon = "Hands"; attribute :>> level = 2; attribute :>> hitPoints = 14; attribute :>> strength = 13; attribute :>> gold = 134; attribute :>> experience = 8; }
            part brorandiaTheViking : Monster { attribute :>> name = "Brorandia The Viking"; attribute :>> weapon = "Hugely Spiked Mace"; attribute :>> level = 2; attribute :>> hitPoints = 18; attribute :>> strength = 21; attribute :>> gold = 330; attribute :>> experience = 20; attribute :>> deadly = true; }
            part hugeBaldMan : Monster { attribute :>> name = "Huge Bald Man"; attribute :>> weapon = "Glare From Forehead"; attribute :>> level = 2; attribute :>> hitPoints = 19; attribute :>> strength = 19; attribute :>> gold = 311; attribute :>> experience = 16; }
            part senileSeniorCitizen : Monster { attribute :>> name = "Senile Senior Citizen"; attribute :>> weapon = "Crazy Ravings"; attribute :>> level = 2; attribute :>> hitPoints = 11; attribute :>> strength = 13; attribute :>> gold = 270; attribute :>> experience = 13; }
            part membrainMan : Monster { attribute :>> name = "Membrain Man"; attribute :>> weapon = "Strange Ooze"; attribute :>> level = 2; attribute :>> hitPoints = 16; attribute :>> strength = 10; attribute :>> gold = 190; attribute :>> experience = 11; }
            part bentRiverDryad : Monster { attribute :>> name = "Bent River Dryad"; attribute :>> weapon = "Pouring Waterfall"; attribute :>> level = 2; attribute :>> hitPoints = 16; attribute :>> strength = 12; attribute :>> gold = 150; attribute :>> experience = 9; }
            part rockMan : Monster { attribute :>> name = "Rock Man"; attribute :>> weapon = "Large Stones"; attribute :>> level = 2; attribute :>> hitPoints = 27; attribute :>> strength = 8; attribute :>> gold = 300; attribute :>> experience = 12; }
        }
        part level3 : ForestLevel {
            attribute :>> level = 3;
            part lazyBum : Monster { attribute :>> name = "Lazy Bum"; attribute :>> weapon = "Unwashed Body Odor"; attribute :>> level = 3; attribute :>> hitPoints = 29; attribute :>> strength = 19; attribute :>> gold = 380; attribute :>> experience = 18; }
            part twoHeadedRotwieler : Monster { attribute :>> name = "Two Headed Rotwieler"; attribute :>> weapon = "Twin Barking"; attribute :>> level = 3; attribute :>> hitPoints = 32; attribute :>> strength = 18; attribute :>> gold = 384; attribute :>> experience = 17; }
            part purpleMonchichi : Monster { attribute :>> name = "Purple Monchichi"; attribute :>> weapon = "Continous Whining"; attribute :>> level = 3; attribute :>> hitPoints = 29; attribute :>> strength = 14; attribute :>> gold = 763; attribute :>> experience = 23; }
            part bone : Monster { attribute :>> name = "Bone"; attribute :>> weapon = "Terrible Smoke Smell"; attribute :>> level = 3; attribute :>> hitPoints = 11; attribute :>> strength = 27; attribute :>> gold = 432; attribute :>> experience = 16; }
            part redNeck : Monster { attribute :>> name = "Red Neck"; attribute :>> weapon = "Awfull Country Slang"; attribute :>> level = 3; attribute :>> hitPoints = 16; attribute :>> strength = 19; attribute :>> gold = 563; attribute :>> experience = 19; }
            part wingedDemonOfDeath : Monster { attribute :>> name = "Winged Demon Of Death"; attribute :>> weapon = "Red Glare"; attribute :>> level = 3; attribute :>> hitPoints = 23; attribute :>> strength = 42; attribute :>> gold = 830; attribute :>> experience = 28; attribute :>> deadly = true; }
            part blackOwl : Monster { attribute :>> name = "Black Owl"; attribute :>> weapon = "Hooked Beak"; attribute :>> level = 3; attribute :>> hitPoints = 29; attribute :>> strength = 28; attribute :>> gold = 711; attribute :>> experience = 26; }
            part muscledMidget : Monster { attribute :>> name = "Muscled Midget"; attribute :>> weapon = "Low Punch"; attribute :>> level = 3; attribute :>> hitPoints = 19; attribute :>> strength = 26; attribute :>> gold = 870; attribute :>> experience = 32; }
            part headbangerOfTheWest : Monster { attribute :>> name = "Headbanger Of The West"; attribute :>> weapon = "Ear Shattering Noises"; attribute :>> level = 3; attribute :>> hitPoints = 27; attribute :>> strength = 23; attribute :>> gold = 245; attribute :>> experience = 43; }
            part morbidWalker : Monster { attribute :>> name = "Morbid Walker"; attribute :>> weapon = "Endless Walking"; attribute :>> level = 3; attribute :>> hitPoints = 10; attribute :>> strength = 28; attribute :>> gold = 764; attribute :>> experience = 9; }
            part magicalEvilGnome : Monster { attribute :>> name = "Magical Evil Gnome"; attribute :>> weapon = "Spell Of Fire"; attribute :>> level = 3; attribute :>> hitPoints = 25; attribute :>> strength = 24; attribute :>> gold = 638; attribute :>> experience = 28; }
        }
        part level4 : ForestLevel {
            attribute :>> level = 4;
            part deathDog : Monster { attribute :>> name = "Death Dog"; attribute :>> weapon = "Teeth"; attribute :>> level = 4; attribute :>> hitPoints = 52; attribute :>> strength = 36; attribute :>> gold = 1150; attribute :>> experience = 36; }
            part weakOrc : Monster { attribute :>> name = "Weak Orc"; attribute :>> weapon = "Spiked Club"; attribute :>> level = 4; attribute :>> hitPoints = 32; attribute :>> strength = 27; attribute :>> gold = 900; attribute :>> experience = 25; }
            part darkElf : Monster { attribute :>> name = "Dark Elf"; attribute :>> weapon = "Small bow"; attribute :>> level = 4; attribute :>> hitPoints = 57; attribute :>> strength = 43; attribute :>> gold = 1070; attribute :>> experience = 33; }
            part evilHobbit : Monster { attribute :>> name = "Evil Hobbit"; attribute :>> weapon = "Smoking Pipe"; attribute :>> level = 4; attribute :>> hitPoints = 95; attribute :>> strength = 35; attribute :>> gold = 1240; attribute :>> experience = 46; }
            part shortGoblin : Monster { attribute :>> name = "Short Goblin"; attribute :>> weapon = "Short Sword"; attribute :>> level = 4; attribute :>> hitPoints = 45; attribute :>> strength = 34; attribute :>> gold = 768; attribute :>> experience = 24; }
            part hugeBlackBear : Monster { attribute :>> name = "Huge Black Bear"; attribute :>> weapon = "Razor Claws"; attribute :>> level = 4; attribute :>> hitPoints = 48; attribute :>> strength = 67; attribute :>> gold = 1765; attribute :>> experience = 76; }
            part rabidWolf : Monster { attribute :>> name = "Rabid Wolf"; attribute :>> weapon = "Deathlock Fangs"; attribute :>> level = 4; attribute :>> hitPoints = 39; attribute :>> strength = 45; attribute :>> gold = 1400; attribute :>> experience = 43; }
            part youngWizard : Monster { attribute :>> name = "Young Wizard"; attribute :>> weapon = "Weak Magic"; attribute :>> level = 4; attribute :>> hitPoints = 35; attribute :>> strength = 64; attribute :>> gold = 1754; attribute :>> experience = 64; }
            part mudMan : Monster { attribute :>> name = "Mud Man"; attribute :>> weapon = "Mud Balls"; attribute :>> level = 4; attribute :>> hitPoints = 65; attribute :>> strength = 56; attribute :>> gold = 870; attribute :>> experience = 43; }
            part deathJester : Monster { attribute :>> name = "Death Jester"; attribute :>> weapon = "Horrible Jokes"; attribute :>> level = 4; attribute :>> hitPoints = 46; attribute :>> strength = 34; attribute :>> gold = 1343; attribute :>> experience = 32; }
            part rockMan : Monster { attribute :>> name = "Rock Man"; attribute :>> weapon = "Large Stones"; attribute :>> level = 4; attribute :>> hitPoints = 54; attribute :>> strength = 87; attribute :>> gold = 1754; attribute :>> experience = 76; attribute :>> deadly = true; }
        }
        part level5 : ForestLevel {
            attribute :>> level = 5;
            part pandionKnight : Monster { attribute :>> name = "Pandion Knight"; attribute :>> weapon = "Orkos Broadsword"; attribute :>> level = 5; attribute :>> hitPoints = 59; attribute :>> strength = 64; attribute :>> gold = 3100; attribute :>> experience = 98; }
            part jabba : Monster { attribute :>> name = "Jabba"; attribute :>> weapon = "Whiplashing Tail"; attribute :>> level = 5; attribute :>> hitPoints = 198; attribute :>> strength = 61; attribute :>> gold = 2384; attribute :>> experience = 137; }
            part manokenSloth : Monster { attribute :>> name = "Manoken Sloth"; attribute :>> weapon = "Dripping Paws"; attribute :>> level = 5; attribute :>> hitPoints = 69; attribute :>> strength = 54; attribute :>> gold = 2452; attribute :>> experience = 97; }
            part trojanWarrior : Monster { attribute :>> name = "Trojan Warrior"; attribute :>> weapon = "Twin Swords"; attribute :>> level = 5; attribute :>> hitPoints = 87; attribute :>> strength = 73; attribute :>> gold = 3432; attribute :>> experience = 154; }
            part misfitTheUgly : Monster { attribute :>> name = "Misfit The Ugly"; attribute :>> weapon = "Strange Ideas"; attribute :>> level = 5; attribute :>> hitPoints = 89; attribute :>> strength = 75; attribute :>> gold = 2563; attribute :>> experience = 120; }
            part georgeOfTheJungle : Monster { attribute :>> name = "George Of The Jungle"; attribute :>> weapon = "Echoing Screams"; attribute :>> level = 5; attribute :>> hitPoints = 43; attribute :>> strength = 56; attribute :>> gold = 2230; attribute :>> experience = 128; }
            part silentDeath : Monster { attribute :>> name = "Silent Death"; attribute :>> weapon = "Pale Smoke"; attribute :>> level = 5; attribute :>> hitPoints = 98; attribute :>> strength = 113; attribute :>> gold = 4711; attribute :>> experience = 230; attribute :>> deadly = true; }
            part baldMedusa : Monster { attribute :>> name = "Bald Medusa"; attribute :>> weapon = "Glare Of Stone"; attribute :>> level = 5; attribute :>> hitPoints = 120; attribute :>> strength = 78; attribute :>> gold = 4000; attribute :>> experience = 256; }
            part blackAlligator : Monster { attribute :>> name = "Black Alligator"; attribute :>> weapon = "Extra Sharp Teeth"; attribute :>> level = 5; attribute :>> hitPoints = 65; attribute :>> strength = 65; attribute :>> gold = 3245; attribute :>> experience = 123; }
            part clancySonOfEmpororLen : Monster { attribute :>> name = "Clancy, Son Of Emporor Len"; attribute :>> weapon = "Spiked Bull Whip"; attribute :>> level = 5; attribute :>> hitPoints = 324; attribute :>> strength = 52; attribute :>> gold = 4764; attribute :>> experience = 324; }
            part blackSorcerer : Monster { attribute :>> name = "Black Sorcerer"; attribute :>> weapon = "Spell Of Lightning"; attribute :>> level = 5; attribute :>> hitPoints = 25; attribute :>> strength = 86; attribute :>> gold = 2838; attribute :>> experience = 154; }
        }
        part level6 : ForestLevel {
            attribute :>> level = 6;
            part ironWarrior : Monster { attribute :>> name = "Iron Warrior"; attribute :>> weapon = "3 Iron"; attribute :>> level = 6; attribute :>> hitPoints = 253; attribute :>> strength = 100; attribute :>> gold = 6542; attribute :>> experience = 364; }
            part blackSoul : Monster { attribute :>> name = "Black Soul"; attribute :>> weapon = "Black Candle"; attribute :>> level = 6; attribute :>> hitPoints = 432; attribute :>> strength = 112; attribute :>> gold = 5865; attribute :>> experience = 432; attribute :>> deadly = true; }
            part goldMan : Monster { attribute :>> name = "Gold Man"; attribute :>> weapon = "Rock Arm"; attribute :>> level = 6; attribute :>> hitPoints = 354; attribute :>> strength = 86; attribute :>> gold = 8964; attribute :>> experience = 493; }
            part screamingZombie : Monster { attribute :>> name = "Screaming Zombie"; attribute :>> weapon = "Gaping Mouth Full Of Teeth"; attribute :>> level = 6; attribute :>> hitPoints = 286; attribute :>> strength = 98; attribute :>> gold = 5322; attribute :>> experience = 354; }
            part satansHelper : Monster { attribute :>> name = "Satans Helper"; attribute :>> weapon = "Pack Of Lies"; attribute :>> level = 6; attribute :>> hitPoints = 165; attribute :>> strength = 112; attribute :>> gold = 7543; attribute :>> experience = 453; }
            part wildStallion : Monster { attribute :>> name = "Wild Stallion"; attribute :>> weapon = "Hoofs"; attribute :>> level = 6; attribute :>> hitPoints = 245; attribute :>> strength = 78; attribute :>> gold = 4643; attribute :>> experience = 532; }
            part belar : Monster { attribute :>> name = "Belar"; attribute :>> weapon = "Fists Of Rage"; attribute :>> level = 6; attribute :>> hitPoints = 352; attribute :>> strength = 120; attribute :>> gold = 9432; attribute :>> experience = 565; attribute :>> deadly = true; }
            part emptyArmour : Monster { attribute :>> name = "Empty Armour"; attribute :>> weapon = "Cutting Wind"; attribute :>> level = 6; attribute :>> hitPoints = 390; attribute :>> strength = 67; attribute :>> gold = 6431; attribute :>> experience = 432; }
            part ragingLion : Monster { attribute :>> name = "Raging Lion"; attribute :>> weapon = "Teeth And Claws"; attribute :>> level = 6; attribute :>> hitPoints = 274; attribute :>> strength = 98; attribute :>> gold = 3643; attribute :>> experience = 365; }
            part hugeStoneWarrior : Monster { attribute :>> name = "Huge Stone Warrior"; attribute :>> weapon = "Rock Fist"; attribute :>> level = 6; attribute :>> hitPoints = 232; attribute :>> strength = 112; attribute :>> gold = 4942; attribute :>> experience = 543; }
            part magicalEvilGnome : Monster { attribute :>> name = "Magical Evil Gnome"; attribute :>> weapon = "Spell Of Fire"; attribute :>> level = 6; attribute :>> hitPoints = 234; attribute :>> strength = 89; attribute :>> gold = 6384; attribute :>> experience = 321; }
        }
        part level7 : ForestLevel {
            attribute :>> level = 7;
            part emporerLen : Monster { attribute :>> name = "Emporer Len"; attribute :>> weapon = "Lightning Bull Whip"; attribute :>> level = 7; attribute :>> hitPoints = 432; attribute :>> strength = 210; attribute :>> gold = 12043; attribute :>> experience = 764; }
            part nightHawk : Monster { attribute :>> name = "Night Hawk"; attribute :>> weapon = "Blood Red Talons"; attribute :>> level = 7; attribute :>> hitPoints = 675; attribute :>> strength = 220; attribute :>> gold = 10433; attribute :>> experience = 686; attribute :>> deadly = true; }
            part chargingRhinoceros : Monster { attribute :>> name = "Charging Rhinoceros"; attribute :>> weapon = "Rather Large Horn"; attribute :>> level = 7; attribute :>> hitPoints = 454; attribute :>> strength = 187; attribute :>> gold = 9853; attribute :>> experience = 654; }
            part goblinPygmy : Monster { attribute :>> name = "Goblin Pygmy"; attribute :>> weapon = "Death Squeeze"; attribute :>> level = 7; attribute :>> hitPoints = 576; attribute :>> strength = 165; attribute :>> gold = 13252; attribute :>> experience = 754; }
            part goliath : Monster { attribute :>> name = "Goliath"; attribute :>> weapon = "Six Fingered Fist"; attribute :>> level = 7; attribute :>> hitPoints = 343; attribute :>> strength = 243; attribute :>> gold = 14322; attribute :>> experience = 898; }
            part angryLiontaur : Monster { attribute :>> name = "Angry Liontaur"; attribute :>> weapon = "Arms And Teeth"; attribute :>> level = 7; attribute :>> hitPoints = 495; attribute :>> strength = 187; attribute :>> gold = 13259; attribute :>> experience = 753; }
            part fallenAngel : Monster { attribute :>> name = "Fallen Angel"; attribute :>> weapon = "Throwing Halos"; attribute :>> level = 7; attribute :>> hitPoints = 654; attribute :>> strength = 154; attribute :>> gold = 12339; attribute :>> experience = 483; }
            part wickedWombat : Monster { attribute :>> name = "Wicked Wombat"; attribute :>> weapon = "The Dark Wombats Curse"; attribute :>> level = 7; attribute :>> hitPoints = 464; attribute :>> strength = 198; attribute :>> gold = 13283; attribute :>> experience = 786; }
            part massiveDinosaur : Monster { attribute :>> name = "Massive Dinosaur"; attribute :>> weapon = "Gaping Jaws"; attribute :>> level = 7; attribute :>> hitPoints = 986; attribute :>> strength = 200; attribute :>> gold = 16753; attribute :>> experience = 1204; attribute :>> deadly = true; }
            part swissButcher : Monster { attribute :>> name = "Swiss Butcher"; attribute :>> weapon = "Meat Cleaver"; attribute :>> level = 7; attribute :>> hitPoints = 453; attribute :>> strength = 230; attribute :>> gold = 8363; attribute :>> experience = 532; }
            part deathGnome : Monster { attribute :>> name = "Death Gnome"; attribute :>> weapon = "Touch Of Death"; attribute :>> level = 7; attribute :>> hitPoints = 232; attribute :>> strength = 270; attribute :>> gold = 10000; attribute :>> experience = 654; }
        }
        part level8 : ForestLevel {
            attribute :>> level = 8;
            part screechingWitch : Monster { attribute :>> name = "Screeching Witch"; attribute :>> weapon = "Spell Of Ice"; attribute :>> level = 8; attribute :>> hitPoints = 674; attribute :>> strength = 300; attribute :>> gold = 19753; attribute :>> experience = 2283; }
            part rundorig : Monster { attribute :>> name = "Rundorig"; attribute :>> weapon = "Poison Claws"; attribute :>> level = 8; attribute :>> hitPoints = 675; attribute :>> strength = 330; attribute :>> gold = 17853; attribute :>> experience = 2748; }
            part wheeler : Monster { attribute :>> name = "Wheeler"; attribute :>> weapon = "Annoying Laugh"; attribute :>> level = 8; attribute :>> hitPoints = 786; attribute :>> strength = 250; attribute :>> gold = 23433; attribute :>> experience = 1980; }
            part deathKnight : Monster { attribute :>> name = "Death Knight"; attribute :>> weapon = "Huge Silver Sword"; attribute :>> level = 8; attribute :>> hitPoints = 674; attribute :>> strength = 287; attribute :>> gold = 21923; attribute :>> experience = 4282; }
            part werewolf : Monster { attribute :>> name = "Werewolf"; attribute :>> weapon = "Fangs"; attribute :>> level = 8; attribute :>> hitPoints = 543; attribute :>> strength = 230; attribute :>> gold = 19474; attribute :>> experience = 3853; }
            part fireOrk : Monster { attribute :>> name = "Fire Ork"; attribute :>> weapon = "FireBall"; attribute :>> level = 8; attribute :>> hitPoints = 674; attribute :>> strength = 267; attribute :>> gold = 24933; attribute :>> experience = 3942; }
            part wansBeast : Monster { attribute :>> name = "Wans Beast"; attribute :>> weapon = "Crushing Embrace"; attribute :>> level = 8; attribute :>> hitPoints = 1243; attribute :>> strength = 193; attribute :>> gold = 17141; attribute :>> experience = 2432; }
            part lordMathese : Monster { attribute :>> name = "Lord Mathese"; attribute :>> weapon = "Fencing Sword"; attribute :>> level = 8; attribute :>> hitPoints = 875; attribute :>> strength = 245; attribute :>> gold = 24935; attribute :>> experience = 2422; }
            part kingVidion : Monster { attribute :>> name = "King Vidion"; attribute :>> weapon = "Long Sword Of Death"; attribute :>> level = 8; attribute :>> hitPoints = 1243; attribute :>> strength = 400; attribute :>> gold = 28575; attribute :>> experience = 6764; attribute :>> deadly = true; }
            part babyDragon : Monster { attribute :>> name = "Baby Dragon"; attribute :>> weapon = "Dragon Smoke"; attribute :>> level = 8; attribute :>> hitPoints = 2322; attribute :>> strength = 176; attribute :>> gold = 25863; attribute :>> experience = 3675; }
            part deathGnome : Monster { attribute :>> name = "Death Gnome"; attribute :>> weapon = "Touch Of Death"; attribute :>> level = 8; attribute :>> hitPoints = 870; attribute :>> strength = 356; attribute :>> gold = 31638; attribute :>> experience = 2300; }
        }
        part level9 : ForestLevel {
            attribute :>> level = 9;
            part pinkElephant : Monster { attribute :>> name = "Pink Elephant"; attribute :>> weapon = "Stomping"; attribute :>> level = 9; attribute :>> hitPoints = 1232; attribute :>> strength = 434; attribute :>> gold = 33844; attribute :>> experience = 7843; }
            part gwendolensNightmare : Monster { attribute :>> name = "Gwendolens Nightmare"; attribute :>> weapon = "Dreams"; attribute :>> level = 9; attribute :>> hitPoints = 764; attribute :>> strength = 490; attribute :>> gold = 35846; attribute :>> experience = 8232; }
            part flyingCobra : Monster { attribute :>> name = "Flying Cobra"; attribute :>> weapon = "Poison Fangs"; attribute :>> level = 9; attribute :>> hitPoints = 1123; attribute :>> strength = 400; attribute :>> gold = 37694; attribute :>> experience = 8433; }
            part rentakisPet : Monster { attribute :>> name = "Rentakis Pet"; attribute :>> weapon = "Gaping Maw"; attribute :>> level = 9; attribute :>> hitPoints = 987; attribute :>> strength = 556; attribute :>> gold = 37584; attribute :>> experience = 9854; }
            part ernestBrown : Monster { attribute :>> name = "Ernest Brown"; attribute :>> weapon = "Knee"; attribute :>> level = 9; attribute :>> hitPoints = 2488; attribute :>> strength = 432; attribute :>> gold = 34833; attribute :>> experience = 9754; }
            part scallianRap : Monster { attribute :>> name = "Scallian Rap"; attribute :>> weapon = "Way Of Hurting People"; attribute :>> level = 9; attribute :>> hitPoints = 788; attribute :>> strength = 601; attribute :>> gold = 22430; attribute :>> experience = 6784; }
            part apeman : Monster { attribute :>> name = "Apeman"; attribute :>> weapon = "Hairy Hands"; attribute :>> level = 9; attribute :>> hitPoints = 1283; attribute :>> strength = 498; attribute :>> gold = 38955; attribute :>> experience = 7202; }
            part hemoGlob : Monster { attribute :>> name = "Hemo-Glob"; attribute :>> weapon = "Weak Insults"; attribute :>> level = 9; attribute :>> hitPoints = 1232; attribute :>> strength = 212; attribute :>> gold = 27853; attribute :>> experience = 4432; }
            part frankenmoose : Monster { attribute :>> name = "FrankenMoose"; attribute :>> weapon = "Butting Head"; attribute :>> level = 9; attribute :>> hitPoints = 1221; attribute :>> strength = 455; attribute :>> gold = 31221; attribute :>> experience = 5433; }
            part earthShaker : Monster { attribute :>> name = "Earth Shaker"; attribute :>> weapon = "Earthquake"; attribute :>> level = 9; attribute :>> hitPoints = 985; attribute :>> strength = 767; attribute :>> gold = 37565; attribute :>> experience = 7432; attribute :>> deadly = true; }
            part gollumsWrath : Monster { attribute :>> name = "Gollums Wrath"; attribute :>> weapon = "Ring Of Invisibility"; attribute :>> level = 9; attribute :>> hitPoints = 2344; attribute :>> strength = 621; attribute :>> gold = 42533; attribute :>> experience = 13544; }
        }
        part level10 : ForestLevel {
            attribute :>> level = 10;
            part toraksSonKorak : Monster { attribute :>> name = "Toraks Son, Korak"; attribute :>> weapon = "Sword Of Lightning"; attribute :>> level = 10; attribute :>> hitPoints = 1384; attribute :>> strength = 921; attribute :>> gold = 46575; attribute :>> experience = 13877; attribute :>> deadly = true; }
            part brandTheWanderer : Monster { attribute :>> name = "Brand The Wanderer"; attribute :>> weapon = "Fighting Quarter Staff"; attribute :>> level = 10; attribute :>> hitPoints = 2788; attribute :>> strength = 643; attribute :>> gold = 38755; attribute :>> experience = 13744; }
            part theGrimestReaper : Monster { attribute :>> name = "The Grimest Reaper"; attribute :>> weapon = "White Sickle"; attribute :>> level = 10; attribute :>> hitPoints = 1674; attribute :>> strength = 878; attribute :>> gold = 39844; attribute :>> experience = 14237; }
            part deathDealer : Monster { attribute :>> name = "Death Dealer"; attribute :>> weapon = "Stare Of Paralization"; attribute :>> level = 10; attribute :>> hitPoints = 1764; attribute :>> strength = 765; attribute :>> gold = 47333; attribute :>> experience = 13877; }
            part tigerOfTheDeepJungle : Monster { attribute :>> name = "Tiger Of The Deep Jungle"; attribute :>> weapon = "Eye Of The Tiger"; attribute :>> level = 10; attribute :>> hitPoints = 3101; attribute :>> strength = 587; attribute :>> gold = 43933; attribute :>> experience = 9766; }
            part sweetLookingLittleGirl : Monster { attribute :>> name = "Sweet Looking Little Girl"; attribute :>> weapon = "Demon Strike"; attribute :>> level = 10; attribute :>> hitPoints = 1232; attribute :>> strength = 989; attribute :>> gold = 52322; attribute :>> experience = 14534; attribute :>> deadly = true; }
            part floatingEvilEye : Monster { attribute :>> name = "Floating Evil Eye"; attribute :>> weapon = "Evil Stare"; attribute :>> level = 10; attribute :>> hitPoints = 2232; attribute :>> strength = 776; attribute :>> gold = 43233; attribute :>> experience = 13455; attribute :>> deadly = true; }
            part slock : Monster { attribute :>> name = "Slock"; attribute :>> weapon = "Swamp Slime"; attribute :>> level = 10; attribute :>> hitPoints = 1675; attribute :>> strength = 744; attribute :>> gold = 56444; attribute :>> experience = 14333; }
            part adultGoldDragon : Monster { attribute :>> name = "Adult Gold Dragon"; attribute :>> weapon = "Dragon Fire"; attribute :>> level = 10; attribute :>> hitPoints = 3222; attribute :>> strength = 565; attribute :>> gold = 56444; attribute :>> experience = 15364; }
            part killJoy : Monster { attribute :>> name = "Kill Joy"; attribute :>> weapon = "Terrible Stench"; attribute :>> level = 10; attribute :>> hitPoints = 3222; attribute :>> strength = 988; attribute :>> gold = 168844; attribute :>> experience = 25766; attribute :>> deadly = true; }
            part blackSorcerer : Monster { attribute :>> name = "Black Sorcerer"; attribute :>> weapon = "Spell Of Lightning"; attribute :>> level = 10; attribute :>> hitPoints = 25; attribute :>> strength = 86; attribute :>> gold = 2838; attribute :>> experience = 187; }
        }
        part level11 : ForestLevel {
            attribute :>> level = 11;
            part gormaTheLeper : Monster { attribute :>> name = "Gorma The Leper"; attribute :>> weapon = "Contagous Desease"; attribute :>> level = 11; attribute :>> hitPoints = 2766; attribute :>> strength = 1132; attribute :>> gold = 168774; attribute :>> experience = 26333; }
            part shogunWarrior : Monster { attribute :>> name = "Shogun Warrior"; attribute :>> weapon = "Japanese Nortaki"; attribute :>> level = 11; attribute :>> hitPoints = 3878; attribute :>> strength = 1143; attribute :>> gold = 165433; attribute :>> experience = 26555; }
            part apparentlyWeakOldWoman : Monster { attribute :>> name = "Apparently Weak Old Woman"; attribute :>> weapon = "*GODS HAMMER*"; attribute :>> level = 11; attribute :>> hitPoints = 1878; attribute :>> strength = 1543; attribute :>> gold = 173522; attribute :>> experience = 37762; }
            part ablesCreature : Monster { attribute :>> name = "Ables Creature"; attribute :>> weapon = "Bear Hug"; attribute :>> level = 11; attribute :>> hitPoints = 2455; attribute :>> strength = 985; attribute :>> gold = 176775; attribute :>> experience = 28222; }
            part whiteBearOfLore : Monster { attribute :>> name = "White Bear Of Lore"; attribute :>> weapon = "Snow Of Death"; attribute :>> level = 11; attribute :>> hitPoints = 1875; attribute :>> strength = 1344; attribute :>> gold = 65544; attribute :>> experience = 16775; attribute :>> deadly = true; }
            part mountain : Monster { attribute :>> name = "Mountain"; attribute :>> weapon = "Landslide"; attribute :>> level = 11; attribute :>> hitPoints = 1284; attribute :>> strength = 1544; attribute :>> gold = 186454; attribute :>> experience = 38774; attribute :>> deadly = true; }
            part sheenaTheShapechanger : Monster { attribute :>> name = "Sheena The Shapechanger"; attribute :>> weapon = "Deadly Illusions"; attribute :>> level = 11; attribute :>> hitPoints = 1898; attribute :>> strength = 1463; attribute :>> gold = 165755; attribute :>> experience = 26655; }
            part shadowstormwarrior : Monster { attribute :>> name = "ShadowStormWarrior"; attribute :>> weapon = "Mystical Storm"; attribute :>> level = 11; attribute :>> hitPoints = 2767; attribute :>> strength = 1655; attribute :>> gold = 162445; attribute :>> experience = 26181; attribute :>> deadly = true; }
            part madman : Monster { attribute :>> name = "Madman"; attribute :>> weapon = "Chant Of Insanity"; attribute :>> level = 11; attribute :>> hitPoints = 1764; attribute :>> strength = 1265; attribute :>> gold = 149564; attribute :>> experience = 25665; }
            part vegetableCreature : Monster { attribute :>> name = "Vegetable Creature"; attribute :>> weapon = "Pickled Cabbage"; attribute :>> level = 11; attribute :>> hitPoints = 172; attribute :>> strength = 111; attribute :>> gold = 4838; attribute :>> experience = 2187; }
            part cyclopsWarrior : Monster { attribute :>> name = "Cyclops Warrior"; attribute :>> weapon = "Fire Eye"; attribute :>> level = 11; attribute :>> hitPoints = 2899; attribute :>> strength = 1744; attribute :>> gold = 204000; attribute :>> experience = 49299; attribute :>> deadly = true; }
        }
        part level12 : ForestLevel {
            attribute :>> level = 12;
            part corinthianGiant : Monster { attribute :>> name = "Corinthian Giant"; attribute :>> weapon = "De-rooted Tree"; attribute :>> level = 12; attribute :>> hitPoints = 2544; attribute :>> strength = 2400; attribute :>> gold = 336643; attribute :>> experience = 60333; attribute :>> deadly = true; }
            part theScreamingEunich : Monster { attribute :>> name = "The Screaming Eunich"; attribute :>> weapon = "High Pitched Voice"; attribute :>> level = 12; attribute :>> hitPoints = 2877; attribute :>> strength = 1488; attribute :>> gold = 197888; attribute :>> experience = 78884; }
            part blackWarlock : Monster { attribute :>> name = "Black Warlock"; attribute :>> weapon = "Satanic Choruses"; attribute :>> level = 12; attribute :>> hitPoints = 2767; attribute :>> strength = 1366; attribute :>> gold = 168483; attribute :>> experience = 58989; }
            part kalTorak : Monster { attribute :>> name = "Kal Torak"; attribute :>> weapon = "Cthrek Goru"; attribute :>> level = 12; attribute :>> hitPoints = 6666; attribute :>> strength = 876; attribute :>> gold = 447774; attribute :>> experience = 94663; }
            part theMightyShadow : Monster { attribute :>> name = "The Mighty Shadow"; attribute :>> weapon = "Shadow Axe"; attribute :>> level = 12; attribute :>> hitPoints = 2332; attribute :>> strength = 1633; attribute :>> gold = 176333; attribute :>> experience = 51655; }
            part blackUnicorn : Monster { attribute :>> name = "Black Unicorn"; attribute :>> weapon = "Shredding Horn"; attribute :>> level = 12; attribute :>> hitPoints = 1587; attribute :>> strength = 1899; attribute :>> gold = 336693; attribute :>> experience = 41738; }
            part mutatedBlackWidow : Monster { attribute :>> name = "Mutated Black Widow"; attribute :>> weapon = "Venom Bite"; attribute :>> level = 12; attribute :>> hitPoints = 1276; attribute :>> strength = 2575; attribute :>> gold = 434370; attribute :>> experience = 98993; attribute :>> deadly = true; }
            part humongousBlackWyre : Monster { attribute :>> name = "Humongous Black Wyre"; attribute :>> weapon = "Death Talons"; attribute :>> level = 12; attribute :>> hitPoints = 3453; attribute :>> strength = 1166; attribute :>> gold = 653834; attribute :>> experience = 76000; }
            part theWizardOfDarkness : Monster { attribute :>> name = "The Wizard Of Darkness"; attribute :>> weapon = "Chant Of Insanity"; attribute :>> level = 12; attribute :>> hitPoints = 1383; attribute :>> strength = 1497; attribute :>> gold = 224964; attribute :>> experience = 39878; }
            part greatOgreOfTheNorth : Monster { attribute :>> name = "Great Ogre Of The North"; attribute :>> weapon = "Spiked Steel Mace"; attribute :>> level = 12; attribute :>> hitPoints = 2878; attribute :>> strength = 1800; attribute :>> gold = 524838; attribute :>> experience = 112833; }
        }

        part redDragon : Dragon;
        part darkCloakTavern : DarkCloakTavern;
        part fairies : FairyGlade;
    }

    // The bank: a tenth a day on deposits, and a vault a thief with a fairy can crack.
    part def Bank {
        attribute dailyInterestPercent : Integer = 10;
        attribute haulPerLevel : Integer = 1000;
    }

    // The healers charge five gold a hit point per level of the patient.
    part def HealersHut {
        attribute goldPerHitPointPerLevel : Integer = 5;
    }

    // A favour asked of Violet or of the bard: the charm it takes and the experience it costs.
    part def Flirt {
        attribute name : String;
        attribute suitor : Sex;
        attribute charmNeeded : Integer;
        attribute experiencePerLevel : Integer;
        attribute beds : Boolean default = false;
        attribute weds : Boolean default = false;
    }

    // Violet, Turgon's daughter, the barmaid; her favours are a man's to ask.
    part def Barmaid {
        attribute name : String = "Violet";
        part wink : Flirt { attribute :>> name = "Wink"; attribute :>> suitor = Sex::male; attribute :>> charmNeeded = 1; attribute :>> experiencePerLevel = 5; }
        part kissHerHand : Flirt { attribute :>> name = "Kiss Her Hand"; attribute :>> suitor = Sex::male; attribute :>> charmNeeded = 2; attribute :>> experiencePerLevel = 10; }
        part peckHerOnTheLips : Flirt { attribute :>> name = "Peck Her On The Lips"; attribute :>> suitor = Sex::male; attribute :>> charmNeeded = 4; attribute :>> experiencePerLevel = 20; }
        part sitHerOnYourLap : Flirt { attribute :>> name = "Sit Her On Your Lap"; attribute :>> suitor = Sex::male; attribute :>> charmNeeded = 8; attribute :>> experiencePerLevel = 30; }
        part grabHerBackside : Flirt { attribute :>> name = "Grab Her Backside"; attribute :>> suitor = Sex::male; attribute :>> charmNeeded = 16; attribute :>> experiencePerLevel = 40; }
        part carryHerUpstairs : Flirt { attribute :>> name = "Carry Her Upstairs"; attribute :>> suitor = Sex::male; attribute :>> charmNeeded = 32; attribute :>> experiencePerLevel = 40; attribute :>> beds = true; }
        part marryHer : Flirt { attribute :>> name = "Marry Her"; attribute :>> suitor = Sex::male; attribute :>> charmNeeded = 100; attribute :>> experiencePerLevel = 1000; attribute :>> weds = true; }
    }

    // Seth Able the bard; his favours are a woman's to ask, and his songs are for all.
    part def Bard {
        attribute name : String = "Seth Able";
        part wink : Flirt { attribute :>> name = "Wink"; attribute :>> suitor = Sex::female; attribute :>> charmNeeded = 1; attribute :>> experiencePerLevel = 5; }
        part flutterEyelashes : Flirt { attribute :>> name = "Flutter Eyelashes"; attribute :>> suitor = Sex::female; attribute :>> charmNeeded = 2; attribute :>> experiencePerLevel = 10; }
        part dropHanky : Flirt { attribute :>> name = "Drop Hanky"; attribute :>> suitor = Sex::female; attribute :>> charmNeeded = 4; attribute :>> experiencePerLevel = 20; }
        part askForADrink : Flirt { attribute :>> name = "Ask The Bard To Buy You A Drink"; attribute :>> suitor = Sex::female; attribute :>> charmNeeded = 8; attribute :>> experiencePerLevel = 30; }
        part kissTheBard : Flirt { attribute :>> name = "Kiss The Bard Soundly"; attribute :>> suitor = Sex::female; attribute :>> charmNeeded = 16; attribute :>> experiencePerLevel = 40; }
        part seduceTheBard : Flirt { attribute :>> name = "Completely Seduce The Bard"; attribute :>> suitor = Sex::female; attribute :>> charmNeeded = 32; attribute :>> experiencePerLevel = 40; attribute :>> beds = true; }
        part marryHim : Flirt { attribute :>> name = "Marry Him"; attribute :>> suitor = Sex::female; attribute :>> charmNeeded = 125; attribute :>> experiencePerLevel = 0; attribute :>> weds = true; }
    }

    // The Red Dragon Inn: a room by level, the bartender's bribe, gems for stats, and the locals.
    part def Inn {
        attribute roomPricePerLevel : Integer = 400;
        attribute bribePerLevel : Integer = 1600;
        attribute charmForAFreeRoom : Integer = 101;
        attribute gemsPerStatPoint : Integer = 2;
        part violet : Barmaid;
        part sethAble : Bard;
    }

    // The town square, one part per place the game's menu leads to.
    part def Town {
        part bank : Bank;
        part healer : HealersHut;
        part inn : Inn;
        part weapons : WeaponShop;
        part armour : ArmourShop;
        part training : TrainingHall;
        part forest : Forest;
    }

    part town : Town;
}

// A warrior's day: the deeds each place offers, the menu as a state machine, midnight.
package LordPlay {
    private import ScalarValues::*;
    private import IntegerFunctions::max;
    private import RealFunctions::floor;
    private import Lord::*;

    // A blow with all the strength behind it, less defense, never less than one: the
    // training bout's rule and the bound the analyses reckon with.
    calc def Blow {
        in strength : Integer;
        in defense : Integer;

        max(1, strength - defense)
    }

    // A blow as the game rolls it: half the strength, the dice's share of the other half
    // (none, a quarter, half, three quarters or all of it), less defense; nothing left is a miss.
    calc def Hit {
        in strength : Integer;
        in defense : Integer;
        in quarters : Integer;

        max(0, floor(strength / 2) + floor(strength * quarters / 8) - defense)
    }

    // The same blow through a Light Shield, which halves it.
    calc def Shielded {
        in blow : Integer;
        in shield : Boolean;

        floor(blow / (if shield ? 2 else 1))
    }

    // What the bank adds overnight, in whole gold pieces.
    calc def Interest {
        in bankGold : Integer;
        in percent : Integer;

        floor(bankGold * percent / 100)
    }

    // A tenth of the experience: what death costs, and what a killer takes.
    calc def Tithe {
        in experience : Integer;

        floor(experience / 10)
    }

    // The inn's rates and the healers' rate rise with the warrior's level.
    calc def RoomPrice {
        in level : Integer;

        400 * level
    }

    calc def BribePrice {
        in level : Integer;

        1600 * level
    }

    calc def HealRate {
        in level : Integer;

        5 * level
    }

    // Skill uses for the day: one per so many skill points.
    calc def SkillUses {
        in points : Integer;
        in pointsPerUse : Integer;

        floor(points / pointsPerUse)
    }

    // Whether a skill's move can be paid for out of the day's uses; a shield already up
    // cannot be raised again.
    calc def SkillReady {
        in move : Move;
        in deathKnightUses : Integer;
        in thievingUses : Integer;
        in mysticalUses : Integer;
        in shielded : Boolean;

        (move == Move::deathKnight and deathKnightUses >= 1)
            or (move == Move::thieving and thievingUses >= 1)
            or (move == Move::pinchRealHard and mysticalUses >= 1)
            or (move == Move::disappear and mysticalUses >= 4)
            or (move == Move::heatWave and mysticalUses >= 8)
            or (move == Move::lightShield and mysticalUses >= 12 and not shielded)
            or (move == Move::shatter and mysticalUses >= 16)
            or (move == Move::mindHeal and mysticalUses >= 20)
    }

    // The menu keys of the game, as the signals a warrior's day accepts.
    attribute def EnterForest;
    attribute def LookForSomethingToKill;
    attribute def SeekTheDragon;
    attribute def AttackTheFoe;
    attribute def UseASkill {
        attribute move : Move;
    }
    attribute def RunAway;
    attribute def MeetYourGuild;
    attribute def MeetTheOldHag;
    attribute def AskTheFairies;
    attribute def CatchAFairy;
    attribute def FindTheDarkCloakTavern;
    attribute def Gamble;
    attribute def ChangeProfession;
    attribute def ReturnToTheForest;
    attribute def ReturnToTown;
    attribute def VisitTheHealer;
    attribute def VisitTheBank;
    attribute def RobTheBank;
    attribute def VisitTheTrainingHall;
    attribute def VisitTheInn;
    attribute def FlirtAtTheInn;
    attribute def AskForADivorce;
    attribute def ListenToTheBard;
    attribute def BribeTheBartender;
    attribute def TradeGems;
    attribute def BuyARoom;
    attribute def SlaughterOtherPlayers;
    attribute def AttackAWarrior;
    attribute def OtherPlaces;
    attribute def NewDay;

    // The monster before the warrior, copied out of the forest when met; `present` while
    // the fight is on, `dragon` in the lair.
    part def Foe {
        attribute present : Boolean default = false;
        attribute dragon : Boolean default = false;
        attribute name : String default = "";
        attribute weapon : String default = "";
        attribute hitPoints : Integer default = 0;
        attribute strength : Integer default = 0;
        attribute defense : Integer default = 0;
        attribute gold : Integer default = 0;
        attribute experience : Integer default = 0;
        attribute breath : Integer default = 0;
    }

    // A warrior: the stats screen, the deeds the realm offers, and the day itself.
    part def Warrior :> Fighter {
        attribute sex : Sex default = Sex::male;
        attribute class : CharacterClass default = CharacterClass::deathKnight;
        attribute level : Integer default = 1;
        attribute experience : Integer default = 0;
        attribute :>> hitPoints default = 20;
        attribute maxHitPoints : Integer default = 20;
        attribute :>> strength default = 10;
        attribute :>> defense default = 1;
        attribute weaponTier : Integer default = 0;
        attribute weaponStrength : Integer default = 0;
        attribute armourTier : Integer default = 0;
        attribute armourDefense : Integer default = 0;
        attribute gold : Integer default = 500;
        attribute bankGold : Integer default = 0;
        attribute gems : Integer default = 0;
        attribute charm : Integer default = 1;
        attribute deathKnightPoints : Integer default = 0;
        attribute mysticalPoints : Integer default = 0;
        attribute thievingPoints : Integer default = 0;
        attribute deathKnightUses : Integer default = 0;
        attribute mysticalUses : Integer default = 0;
        attribute thievingUses : Integer default = 0;
        attribute lightShield : Boolean default = false;
        // The move a fight opens with when none is named.
        attribute favouredMove : Move default = Move::attack;
        attribute forestFightsLeft : Integer default = 15;
        attribute playerFightsLeft : Integer default = 3;
        attribute daysPlayed : Integer default = 1;
        attribute alive : Boolean default = true;
        attribute dragonKills : Integer default = 0;
        attribute playerKills : Integer default = 0;
        attribute spouse : Spouse default = Spouse::nobody;
        attribute children : Integer default = 0;
        attribute lays : Integer default = 0;
        attribute horse : Boolean default = false;
        attribute fairy : Boolean default = false;
        attribute innRoom : Boolean default = false;
        attribute bribed : Boolean default = false;
        attribute heardTheBard : Boolean default = false;
        attribute flirtedToday : Boolean default = false;
        attribute trainedToday : Boolean default = false;
        attribute taughtToday : Boolean default = false;
        attribute blessedToday : Boolean default = false;
        attribute grabbedToday : Boolean default = false;
        attribute news : String default = "";
        part foe : Foe;

        // What the game never lets happen, asserted of every warrior.
        assert constraint levelInRange { level >= 1 and level <= 12 }
        assert constraint fightsNotOverdrawn { forestFightsLeft >= 0 and forestFightsLeft <= 18 + children }
        assert constraint playerFightsNotOverdrawn { playerFightsLeft >= 0 and playerFightsLeft <= 4 }
        assert constraint hitPointsWithinMaximum { hitPoints <= maxHitPoints and maxHitPoints >= 1 }
        assert constraint theDeadHaveNoHitPoints { alive or hitPoints == 0 }
        assert constraint noDebt { gold >= 0 and bankGold >= 0 }
        assert constraint gemsNotOwed { gems >= 0 }
        assert constraint charmNotNegative { charm >= 0 }
        assert constraint skillsWithinMastery {
            deathKnightPoints >= 0 and deathKnightPoints <= 40
                and mysticalPoints >= 0 and mysticalPoints <= 40
                and thievingPoints >= 0 and thievingPoints <= 40
        }
        assert constraint usesNotOverdrawn { deathKnightUses >= 0 and mysticalUses >= 0 and thievingUses >= 0 }
        assert constraint gearFromTheShops {
            weaponTier >= 0 and weaponTier <= 13 and armourTier >= 0 and armourTier <= 13
        }
        assert constraint familyCounted { children >= 0 and lays >= 0 and playerKills >= 0 and dragonKills >= 0 }
        assert constraint violetTakesGrooms { spouse != Spouse::violet or sex == Sex::male }
        assert constraint theBardTakesBrides { spouse != Spouse::sethAble or sex == Sex::female }

        // The forest serves a monster of the warrior's level for a fight left; the warrior then
        // chooses each round: the sword, a skill, or the way out.
        action meet {
            in monster : Monster default = town.forest.level1.smallThief;

            first start;
            then decide mayFight;
            if forestFightsLeft > 0 and alive and not foe.present and monster.level == level
                and not (monster istype Dragon) and monster.hitPoints > 0 and monster.strength >= 0
                and monster.defense >= 0 and monster.gold >= 0 and monster.experience >= 0 then engage;
            else done;

            action engage {
                assign foe.present := true;
                assign foe.dragon := false;
                assign foe.name := monster.name;
                assign foe.weapon := monster.weapon;
                assign foe.hitPoints := monster.hitPoints;
                assign foe.strength := monster.strength;
                assign foe.defense := monster.defense;
                assign foe.gold := monster.gold;
                assign foe.experience := monster.experience;
                assign foe.breath := 0;
                assign forestFightsLeft := forestFightsLeft - 1;
                assign lightShield := false;
            }
            then done;
        }

        // The dragon's lair, open to a level-twelve warrior with a fight left.
        action meetTheDragon {
            in dragon : Dragon default = town.forest.redDragon;

            first start;
            then decide mayFight;
            if forestFightsLeft > 0 and alive and not foe.present and level == 12
                and dragon.hitPoints > 0 and dragon.strength >= 0 and dragon.defense >= 0
                and dragon.breath >= 0 then engage;
            else done;

            action engage {
                assign foe.present := true;
                assign foe.dragon := true;
                assign foe.name := dragon.name;
                assign foe.weapon := dragon.weapon;
                assign foe.hitPoints := dragon.hitPoints;
                assign foe.strength := dragon.strength;
                assign foe.defense := dragon.defense;
                assign foe.gold := dragon.gold;
                assign foe.experience := dragon.experience;
                assign foe.breath := dragon.breath;
                assign forestFightsLeft := forestFightsLeft - 1;
                assign lightShield := false;
            }
            then done;
        }

        // The foe's turn, while there is a fight: its dice, its blow through the shield if one is
        // up, and what is left of the warrior. The dragon breathes, stomps, claws or lashes.
        action foeStrikes {
            attribute foeQuarters : Integer = 0;
            attribute incoming : Integer = 0;

            first start;
            then decide foeMayStrike;
            if alive and foe.present and foe.hitPoints > 0 then foeSwing;
            else done;

            decide foeSwing;

            action foeWeakBlow { assign foeQuarters := 0; }
            action foeGlancingBlow { assign foeQuarters := 1; }
            action foeSolidBlow { assign foeQuarters := 2; }
            action foeHardBlow { assign foeQuarters := 3; }
            action foeMightyBlow { assign foeQuarters := 4; }

            merge foeRolled;
            decide foeAttacks;

            action blow {
                assign incoming := Shielded(Hit(foe.strength, defense, foeQuarters), lightShield);
            }

            action flamingBreath {
                assign incoming := Shielded(foe.breath, lightShield);
            }

            action stomp {
                assign incoming := Shielded(Hit(foe.strength, defense, foeQuarters), lightShield);
            }

            action hugeClaw {
                assign incoming := Shielded(Hit(floor(foe.strength / 2), defense, foeQuarters), lightShield);
            }

            action swishingTail {
                assign incoming := Shielded(Hit(floor(foe.strength / 4), defense, foeQuarters), lightShield);
            }

            merge struck;
            decide warriorStanding;

            action takeBlow {
                assign hitPoints := hitPoints - incoming;
            }

            // A grown child sneaks up on the foe and takes the killing blow instead.
            action childIntervenes {
                assign children := children - 1;
                assign foe.hitPoints := max(0, foe.hitPoints - Hit(strength, foe.defense, 4));
            }

            // A fairy caught today flies out of the pocket and revives the warrior once.
            action fairyRevives {
                assign fairy := false;
                assign hitPoints := maxHitPoints;
            }

            // Death costs the gold on hand, a tenth of the experience, and the day.
            action die {
                assign alive := false;
                assign hitPoints := 0;
                assign gold := 0;
                assign experience := experience - Tithe(experience);
                assign lightShield := false;
                assign foe.present := false;
            }

            first foeSwing if true then foeWeakBlow;
            first foeSwing if true then foeGlancingBlow;
            first foeSwing if true then foeSolidBlow;
            first foeSwing if true then foeHardBlow;
            first foeSwing if true then foeMightyBlow;
            succession first foeWeakBlow then foeRolled;
            succession first foeGlancingBlow then foeRolled;
            succession first foeSolidBlow then foeRolled;
            succession first foeHardBlow then foeRolled;
            succession first foeMightyBlow then foeRolled;
            succession first foeRolled then foeAttacks;
            first foeAttacks if not foe.dragon then blow;
            first foeAttacks if foe.dragon then flamingBreath;
            first foeAttacks if foe.dragon then stomp;
            first foeAttacks if foe.dragon then hugeClaw;
            first foeAttacks if foe.dragon then swishingTail;
            succession first blow then struck;
            succession first flamingBreath then struck;
            succession first stomp then struck;
            succession first hugeClaw then struck;
            succession first swishingTail then struck;
            succession first struck then warriorStanding;
            first warriorStanding if incoming < hitPoints then takeBlow;
            first warriorStanding if incoming >= hitPoints and children > 0 then childIntervenes;
            first warriorStanding if incoming >= hitPoints and children <= 0 and fairy then fairyRevives;
            first warriorStanding if incoming >= hitPoints and children <= 0 and not fairy then die;
            succession first takeBlow then done;
            succession first childIntervenes then done;
            succession first fairyRevives then done;
            succession first die then done;
        }

        // One round with the sword: the warrior's dice and blow, then the foe's if it stands.
        action strike {
            attribute quarters : Integer = 0;

            first start;
            then decide mayStrike;
            if alive and foe.present and foe.hitPoints > 0 then swing;
            else done;

            decide swing;

            action weakBlow { assign quarters := 0; }
            action glancingBlow { assign quarters := 1; }
            action solidBlow { assign quarters := 2; }
            action hardBlow { assign quarters := 3; }
            action mightyBlow { assign quarters := 4; }

            action blow {
                assign foe.hitPoints := max(0, foe.hitPoints - Hit(strength, foe.defense, quarters));
            }

            decide foeStanding;

            action foesTurn { first start; then perform foeStrikes; then done; }

            first swing if true then weakBlow;
            first swing if true then glancingBlow;
            first swing if true then solidBlow;
            first swing if true then hardBlow;
            first swing if true then mightyBlow;
            succession first weakBlow then blow;
            succession first glancingBlow then blow;
            succession first solidBlow then blow;
            succession first hardBlow then blow;
            succession first mightyBlow then blow;
            succession first blow then foeStanding;
            first foeStanding if foe.hitPoints > 0 then foesTurn;
            first foeStanding if foe.hitPoints <= 0 then done;
            succession first foesTurn then done;
        }

        // One round with a skill, for its price in uses: the Death Knights' power move and the
        // thieves' sneak attack are three blows in one; the mystics' spells each their own.
        // An attacking skill lands for at least a point; the foe answers unless it falls or is fled.
        action useSkill {
            in move : Move default = favouredMove;

            attribute quarters : Integer = 0;

            first start;
            then decide ready;
            if alive and foe.present and foe.hitPoints > 0
                and ((move == Move::deathKnight and deathKnightUses >= 1)
                    or (move == Move::thieving and thievingUses >= 1)
                    or (move == Move::pinchRealHard and mysticalUses >= 1)
                    or (move == Move::heatWave and mysticalUses >= 8)
                    or (move == Move::shatter and mysticalUses >= 16)) then swing;
            if alive and foe.present and foe.hitPoints > 0
                and move == Move::disappear and mysticalUses >= 4 then vanish;
            if alive and foe.present and foe.hitPoints > 0
                and move == Move::lightShield and mysticalUses >= 12 and not lightShield then shield;
            if alive and foe.present and foe.hitPoints > 0
                and move == Move::mindHeal and mysticalUses >= 20 then mend;
            else done;

            decide swing;

            action weakBlow { assign quarters := 0; }
            action glancingBlow { assign quarters := 1; }
            action solidBlow { assign quarters := 2; }
            action hardBlow { assign quarters := 3; }
            action mightyBlow { assign quarters := 4; }

            merge rolled;
            decide spell;

            action powerMove {
                assign foe.hitPoints := max(0, foe.hitPoints - max(1, 3 * Hit(strength, foe.defense, quarters)));
                assign deathKnightUses := deathKnightUses - 1;
            }

            action sneakAttack {
                assign foe.hitPoints := max(0, foe.hitPoints - max(1, 3 * Hit(strength, foe.defense, quarters)));
                assign thievingUses := thievingUses - 1;
            }

            action pinch {
                assign foe.hitPoints := max(0, foe.hitPoints - max(1, 2 * Hit(strength, foe.defense, quarters)));
                assign mysticalUses := mysticalUses - 1;
            }

            action heat {
                assign foe.hitPoints := max(0, foe.hitPoints - max(1, 3 * Hit(strength, foe.defense, quarters)));
                assign mysticalUses := mysticalUses - 8;
            }

            action shatterBlow {
                assign foe.hitPoints := max(0, foe.hitPoints - max(1, 6 * Hit(strength, foe.defense, quarters)));
                assign mysticalUses := mysticalUses - 16;
            }

            // Disappear never fails; the foe is left behind, spoils and all.
            action vanish {
                assign mysticalUses := mysticalUses - 4;
                assign lightShield := false;
                assign foe.present := false;
            }

            action shield {
                assign lightShield := true;
                assign mysticalUses := mysticalUses - 12;
            }

            action mend {
                assign hitPoints := maxHitPoints;
                assign mysticalUses := mysticalUses - 20;
            }

            merge landed;
            decide foeStanding;

            action foesTurn { first start; then perform foeStrikes; then done; }

            first swing if true then weakBlow;
            first swing if true then glancingBlow;
            first swing if true then solidBlow;
            first swing if true then hardBlow;
            first swing if true then mightyBlow;
            succession first weakBlow then rolled;
            succession first glancingBlow then rolled;
            succession first solidBlow then rolled;
            succession first hardBlow then rolled;
            succession first mightyBlow then rolled;
            succession first rolled then spell;
            first spell if move == Move::deathKnight then powerMove;
            first spell if move == Move::thieving then sneakAttack;
            first spell if move == Move::pinchRealHard then pinch;
            first spell if move == Move::heatWave then heat;
            first spell if move == Move::shatter then shatterBlow;
            succession first powerMove then landed;
            succession first sneakAttack then landed;
            succession first pinch then landed;
            succession first heat then landed;
            succession first shatterBlow then landed;
            succession first shield then landed;
            succession first mend then landed;
            succession first landed then foeStanding;
            first foeStanding if foe.hitPoints > 0 then foesTurn;
            first foeStanding if foe.hitPoints <= 0 then done;
            succession first foesTurn then done;
            succession first vanish then done;
        }

        // Running is the dice's to grant: the warrior gets away, or is caught and struck.
        action run {
            first start;
            then decide mayRun;
            if alive and foe.present and foe.hitPoints > 0 then flee;
            else done;

            decide flee;

            action escape {
                assign foe.present := false;
                assign lightShield := false;
            }

            action caught { first start; then perform foeStrikes; then done; }

            first flee if true then escape;
            first flee if true then caught;
            succession first escape then done;
            succession first caught then done;
        }

        // A fallen foe's gold and experience, and a gem if the dice say so. The dragon yields
        // the kill instead: the warrior wakes a new person, keeping skills, charm, gems and kin.
        action win {
            first start;
            then decide fallen;
            if alive and foe.present and foe.hitPoints <= 0 then claim;
            else done;

            action claim {
                assign gold := gold + foe.gold;
                assign experience := experience + foe.experience;
                assign lightShield := false;
                assign foe.present := false;
            }

            decide spoils;

            action findGem {
                assign gems := gems + 1;
            }

            action noGem;

            action slay {
                assign dragonKills := dragonKills + 1;
            }

            action bornAgain {
                assign level := 1;
                assign experience := 0;
                assign maxHitPoints := 20;
                assign hitPoints := 20;
                assign strength := 10;
                assign defense := 1;
                assign weaponTier := 0;
                assign weaponStrength := 0;
                assign armourTier := 0;
                assign armourDefense := 0;
                assign gold := 500;
                assign bankGold := 0;
                assign forestFightsLeft := 15 + children;
            }

            succession first claim then spoils;
            first spoils if foe.dragon then slay;
            first spoils if not foe.dragon then findGem;
            first spoils if not foe.dragon then noGem;
            succession first slay then bornAgain;
            succession first bornAgain then done;
            succession first findGem then done;
            succession first noGem then done;
        }

        // Slaughter another warrior: three a day, none asleep at the inn unless the bartender
        // is bribed and the sleeper is at most a level below. Power moves need a higher-level
        // foe. The loser's gold and a tenth of the experience go to the winner, who counts the
        // kill; a slain sleeper's gems go too, while an attacker who dies keeps the gems. Two
        // warriors neither of whom can mark the other, skills spent, break off the fight.
        action attack {
            in victim : Warrior = rival;
            in move : Move default = favouredMove;

            attribute rounds : Integer = 0;
            attribute quarters : Integer = 0;
            attribute victimQuarters : Integer = 0;
            attribute incoming : Integer = 0;
            attribute skillReady : Boolean = false;
            attribute standOff : Boolean = false;

            first start;
            then decide mayAttack;
            if playerFightsLeft > 0 and alive and victim != self and victim.alive and victim.hitPoints > 0
                and victim.strength >= 0 and victim.defense >= 0
                and victim.gold >= 0 and victim.experience >= 0 and victim.gems >= 0
                and (not victim.innRoom or (bribed and victim.level >= level - 1)) then engage;
            else done;

            action engage {
                assign playerFightsLeft := playerFightsLeft - 1;
                assign lightShield := false;
            }

            merge nextRound;

            action ready {
                assign skillReady := victim.level > level
                    and ((move == Move::deathKnight and deathKnightUses >= 1)
                        or (move == Move::thieving and thievingUses >= 1));
                assign standOff := not skillReady
                    and Hit(strength, victim.defense, 4) <= 0
                    and Hit(victim.strength, defense, 4) <= 0;
                assign rounds := rounds + 1;
            }

            decide fightOn;
            decide swing;

            action weakBlow { assign quarters := 0; }
            action glancingBlow { assign quarters := 1; }
            action solidBlow { assign quarters := 2; }
            action hardBlow { assign quarters := 3; }
            action mightyBlow { assign quarters := 4; }

            merge rolled;
            decide choose;

            action strike {
                assign victim.hitPoints := max(0, victim.hitPoints - Hit(strength, victim.defense, quarters));
            }

            action powerMove {
                assign victim.hitPoints := max(0, victim.hitPoints - max(1, 3 * Hit(strength, victim.defense, quarters)));
                assign deathKnightUses := deathKnightUses - 1;
            }

            action sneakAttack {
                assign victim.hitPoints := max(0, victim.hitPoints - max(1, 3 * Hit(strength, victim.defense, quarters)));
                assign thievingUses := thievingUses - 1;
            }

            merge landed;
            decide victimStanding;

            merge victimsTurn;
            decide victimSwing;

            action victimWeakBlow { assign victimQuarters := 0; }
            action victimGlancingBlow { assign victimQuarters := 1; }
            action victimSolidBlow { assign victimQuarters := 2; }
            action victimHardBlow { assign victimQuarters := 3; }
            action victimMightyBlow { assign victimQuarters := 4; }

            action riposte {
                assign incoming := Hit(victim.strength, defense, victimQuarters);
            }

            decide warriorStanding;

            action takeBlow {
                assign hitPoints := hitPoints - incoming;
            }

            action fairyRevives {
                assign fairy := false;
                assign hitPoints := maxHitPoints;
            }

            action slay {
                assign victim.alive := false;
                assign gold := gold + victim.gold;
                assign victim.gold := 0;
                assign gems := gems + victim.gems;
                assign victim.gems := 0;
                assign experience := experience + Tithe(victim.experience);
                assign victim.experience := victim.experience - Tithe(victim.experience);
                assign playerKills := playerKills + 1;
            }

            action die {
                assign victim.gold := victim.gold + gold;
                assign victim.experience := victim.experience + Tithe(experience);
                assign victim.playerKills := victim.playerKills + 1;
                assign alive := false;
                assign hitPoints := 0;
                assign gold := 0;
                assign experience := experience - Tithe(experience);
            }

            succession first engage then nextRound;
            succession first nextRound then ready;
            succession first ready then fightOn;
            first fightOn if standOff then done;
            first fightOn if not standOff then swing;
            first swing if true then weakBlow;
            first swing if true then glancingBlow;
            first swing if true then solidBlow;
            first swing if true then hardBlow;
            first swing if true then mightyBlow;
            succession first weakBlow then rolled;
            succession first glancingBlow then rolled;
            succession first solidBlow then rolled;
            succession first hardBlow then rolled;
            succession first mightyBlow then rolled;
            succession first rolled then choose;
            first choose if not skillReady then strike;
            first choose if skillReady and move == Move::deathKnight then powerMove;
            first choose if skillReady and move == Move::thieving then sneakAttack;
            succession first strike then landed;
            succession first powerMove then landed;
            succession first sneakAttack then landed;
            succession first landed then victimStanding;
            first victimStanding if victim.hitPoints <= 0 then slay;
            first victimStanding if victim.hitPoints > 0 then victimsTurn;
            succession first victimsTurn then victimSwing;
            first victimSwing if true then victimWeakBlow;
            first victimSwing if true then victimGlancingBlow;
            first victimSwing if true then victimSolidBlow;
            first victimSwing if true then victimHardBlow;
            first victimSwing if true then victimMightyBlow;
            succession first victimWeakBlow then riposte;
            succession first victimGlancingBlow then riposte;
            succession first victimSolidBlow then riposte;
            succession first victimHardBlow then riposte;
            succession first victimMightyBlow then riposte;
            succession first riposte then warriorStanding;
            first warriorStanding if incoming < hitPoints then takeBlow;
            first warriorStanding if incoming >= hitPoints and fairy then fairyRevives;
            first warriorStanding if incoming >= hitPoints and not fairy then die;
            succession first takeBlow then nextRound;
            succession first fairyRevives then nextRound;
            succession first slay then done;
            succession first die then done;
        }

        // The healers mend every point, or as many as the gold on hand pays for, at five
        // gold a point per level. The dead are past healing.
        action heal {
            attribute rate : Integer = 0;
            attribute affordable : Integer = 0;

            first start;
            then decide mayHeal;
            if alive and level >= 1 and hitPoints < maxHitPoints then price;
            else done;

            action price {
                assign rate := HealRate(level);
                assign affordable := floor(gold / rate);
            }

            decide canAffordAll;

            action mendAll {
                assign gold := gold - (maxHitPoints - hitPoints) * rate;
                assign hitPoints := maxHitPoints;
            }

            action mendSome {
                assign hitPoints := hitPoints + affordable;
                assign gold := gold - affordable * rate;
            }

            succession first price then canAffordAll;
            first canAffordAll if affordable >= maxHitPoints - hitPoints then mendAll;
            first canAffordAll if affordable < maxHitPoints - hitPoints then mendSome;
            succession first mendAll then done;
            succession first mendSome then done;
        }

        // Gold in the bank earns interest and cannot be taken by another player.
        // The teller moves only gold the warrior actually has.
        action deposit {
            in amount : Integer;

            first start;
            then decide hasGold;
            if alive and amount >= 0 and gold >= amount then move;
            else done;

            action move {
                assign bankGold := bankGold + amount;
                assign gold := gold - amount;
            }
            then done;
        }

        action withdraw {
            in amount : Integer;

            first start;
            then decide hasGold;
            if alive and amount >= 0 and bankGold >= amount then move;
            else done;

            action move {
                assign bankGold := bankGold - amount;
                assign gold := gold + amount;
            }
            then done;
        }

        // A thief with a fairy in the pocket picks the vault's lock: a haul by level.
        action robTheBank {
            first start;
            then decide mayRob;
            if alive and class == CharacterClass::thievingSkills and fairy then pickTheLock;
            else done;

            action pickTheLock {
                assign gold := gold + town.bank.haulPerLevel * level;
                assign fairy := false;
            }
            then done;
        }

        // A shop sells for the full price, the new item's stat replacing the old one's.
        action buyWeapon {
            in weapon : Weapon default = town.weapons.stick;

            first start;
            then decide canPay;
            if alive and weapon.price >= 0 and weapon.strength >= 0
                and weapon.tier >= 0 and weapon.tier <= 13 and gold >= weapon.price then pay;
            else done;

            action pay {
                assign gold := gold - weapon.price;
                assign strength := strength - weaponStrength + weapon.strength;
                assign weaponStrength := weapon.strength;
                assign weaponTier := weapon.tier;
            }
            then done;
        }

        action buyArmour {
            in armour : Armour default = town.armour.coat;

            first start;
            then decide canPay;
            if alive and armour.price >= 0 and armour.defense >= 0
                and armour.tier >= 0 and armour.tier <= 13 and gold >= armour.price then pay;
            else done;

            action pay {
                assign gold := gold - armour.price;
                assign defense := defense - armourDefense + armour.defense;
                assign armourDefense := armour.defense;
                assign armourTier := armour.tier;
            }
            then done;
        }

        // A bout at the hall, against Halder unless told otherwise, once a day: a win is the
        // next level and a skill point in the warrior's class; a loss only bruises, and the
        // master mends it. Only the master of the next level will fight, and a real one.
        action train {
            in master : Master default = town.training.halder;

            attribute masterLeft : Integer = 0;
            attribute promoted : Boolean = false;

            first start;
            then decide ready;
            if alive and not trainedToday and level < 12 and master.teaches == level + 1
                and experience >= master.experienceRequired
                and master.hitPoints > 0 and master.strength >= 0 and master.defense >= 0
                and master.hitPointsTaught >= 0 and master.strengthTaught >= 0
                and master.defenseTaught >= 0 then bout;
            else turnedAway;

            action bout {
                assign trainedToday := true;
                assign masterLeft := master.hitPoints;
                loop {
                    assign masterLeft := masterLeft - Blow(strength, master.defense);
                    assign hitPoints := if masterLeft > 0 ? max(1, hitPoints - Blow(master.strength, defense)) else hitPoints;
                } until masterLeft <= 0 or hitPoints <= 1;
            }

            action turnedAway;

            decide verdict;

            action levelUp {
                assign level := level + 1;
                assign maxHitPoints := maxHitPoints + master.hitPointsTaught;
                assign hitPoints := hitPoints + master.hitPointsTaught;
                assign strength := strength + master.strengthTaught;
                assign defense := defense + master.defenseTaught;
                assign deathKnightPoints := if class == CharacterClass::deathKnight and deathKnightPoints < 40 ? deathKnightPoints + 1 else deathKnightPoints;
                assign mysticalPoints := if class == CharacterClass::mysticalSkills and mysticalPoints < 40 ? mysticalPoints + 1 else mysticalPoints;
                assign thievingPoints := if class == CharacterClass::thievingSkills and thievingPoints < 40 ? thievingPoints + 1 else thievingPoints;
                assign promoted := true;
            }

            action beaten {
                assign hitPoints := maxHitPoints;
            }

            succession first bout then verdict;
            first verdict if masterLeft <= 0 then levelUp;
            first verdict if masterLeft > 0 then beaten;
            succession first levelUp then done;
            succession first beaten then done;
            succession first turnedAway then done;
        }

        // A skill lesson in the forest, from the warrior's own guild: the Death Knights'
        // judgement is a coin toss, the mystic's number a guess, the thieves' lesson a gem.
        // Forty points is ultra mastery, and the end of the lessons.
        action learnSkill {
            first start;
            then decide guild;
            if alive and not taughtToday and class == CharacterClass::deathKnight and deathKnightPoints < 40 then castle;
            if alive and not taughtToday and class == CharacterClass::mysticalSkills and mysticalPoints < 40 then hut;
            if alive and not taughtToday and class == CharacterClass::thievingSkills and thievingPoints < 40 and gems >= 1 then lesson;
            else done;

            action castle {
                assign taughtToday := true;
            }
            decide judgement;

            action judgedRightly {
                assign deathKnightPoints := deathKnightPoints + 1;
            }

            action judgedWrongly;

            action hut {
                assign taughtToday := true;
            }
            decide guess;

            action guessed {
                assign mysticalPoints := mysticalPoints + 1;
            }

            action missed;

            action lesson {
                assign taughtToday := true;
                assign gems := gems - 1;
                assign thievingPoints := thievingPoints + 1;
            }

            succession first castle then judgement;
            first judgement if true then judgedRightly;
            first judgement if true then judgedWrongly;
            succession first judgedRightly then done;
            succession first judgedWrongly then done;
            succession first hut then guess;
            first guess if true then guessed;
            first guess if true then missed;
            succession first guessed then done;
            succession first missed then done;
            succession first lesson then done;
        }

        // The Old Hag heals a warrior and adds a hit point, for a gem.
        action meetTheOldHag {
            first start;
            then decide hasGem;
            if alive and gems >= 1 then bargain;
            else done;

            action bargain {
                assign gems := gems - 1;
                assign maxHitPoints := maxHitPoints + 1;
                assign hitPoints := maxHitPoints;
            }
            then done;
        }

        // The fairies grant one blessing a day for the asking: a healing kiss, a horse, a gem
        // for a sad story, or lore worth experience by level.
        action askTheFairies {
            in blessing : Blessing = Blessing::kiss;

            first start;
            then decide mayAsk;
            if alive and not blessedToday then ask;
            else done;

            action ask {
                assign blessedToday := true;
            }
            decide granted;

            action kissed {
                assign hitPoints := maxHitPoints;
            }

            action mounted {
                assign horse := true;
            }

            action tearToGem {
                assign gems := gems + 1;
            }

            action lore {
                assign experience := experience + town.forest.fairies.loreExperiencePerLevel * level;
            }

            succession first ask then granted;
            first granted if blessing == Blessing::kiss then kissed;
            first granted if blessing == Blessing::horse then mounted;
            first granted if blessing == Blessing::sadStory then tearToGem;
            first granted if blessing == Blessing::lore then lore;
            succession first kissed then done;
            succession first mounted then done;
            succession first tearToGem then done;
            succession first lore then done;
        }

        // One grab for a fairy a day: caught, it revives the warrior once today; missed,
        // the thornberry bush leaves one hit point.
        action catchAFairy {
            first start;
            then decide mayGrab;
            if alive and not fairy and not grabbedToday then grab;
            else done;

            action grab {
                assign grabbedToday := true;
            }
            decide luck;

            action caught {
                assign fairy := true;
            }

            action thornberries {
                assign hitPoints := 1;
            }

            succession first grab then luck;
            first luck if true then caught;
            first luck if true then thornberries;
            succession first caught then done;
            succession first thornberries then done;
        }

        // At the Dark Cloak Tavern, Chance changes a warrior's profession; the skills
        // already learned are kept.
        action changeProfession {
            in profession : CharacterClass = CharacterClass::thievingSkills;

            first start;
            then decide mayChange;
            if alive then change;
            else done;

            action change {
                assign class := profession;
            }
            then done;
        }

        // The old man's games: a wager the warrior can cover, won or lost on the dice.
        action gamble {
            in wager : Integer = 100;

            first start;
            then decide mayBet;
            if alive and wager > 0 and gold >= wager then bet;
            else done;

            action bet;
            decide dice;

            action won {
                assign gold := gold + wager;
            }

            action lost {
                assign gold := gold - wager;
            }

            succession first bet then dice;
            first dice if true then won;
            first dice if true then lost;
            succession first won then done;
            succession first lost then done;
        }

        // A room for the night keeps a warrior off the slaughter list; charm enough
        // and the bartender waives the price.
        action buyRoom {
            attribute price : Integer = 0;

            first start;
            then action quote {
                assign price := if charm >= town.inn.charmForAFreeRoom ? 0 else RoomPrice(level);
            }
            then decide mayStay;
            if alive and not innRoom and gold >= price then stay;
            else done;

            action stay {
                assign gold := gold - price;
                assign innRoom := true;
            }
            then done;
        }

        // The bartender, bribed, lends the room keys; he will not talk to a first-level warrior.
        action bribeTheBartender {
            first start;
            then decide mayBribe;
            if alive and level >= 2 and not bribed and gold >= BribePrice(level) then pay;
            else done;

            action pay {
                assign gold := gold - BribePrice(level);
                assign bribed := true;
            }
            then done;
        }

        // Two gems buy a point of the stat named, from the bartender, from level two.
        action tradeGems {
            in stat : Stat = Stat::defense;

            first start;
            then decide mayTrade;
            if alive and level >= 2 and gems >= town.inn.gemsPerStatPoint then pay;
            else done;

            action pay {
                assign gems := gems - town.inn.gemsPerStatPoint;
            }

            decide which;

            action moreStrength {
                assign strength := strength + 1;
            }

            action moreDefense {
                assign defense := defense + 1;
            }

            action moreHitPoints {
                assign maxHitPoints := maxHitPoints + 1;
                assign hitPoints := hitPoints + 1;
            }

            succession first pay then which;
            first which if stat == Stat::strength then moreStrength;
            first which if stat == Stat::defense then moreDefense;
            first which if stat == Stat::hitPoints then moreHitPoints;
            succession first moreStrength then done;
            succession first moreDefense then done;
            succession first moreHitPoints then done;
        }

        // A favour asked of Violet or the bard, once a day: it takes the charm, costs the
        // experience, and wins a charm point; a night upstairs may leave a child; the last
        // favour is marriage. The married and the wrong sex are turned away.
        action flirt {
            in favour : Flirt = town.inn.violet.wink;

            attribute cost : Integer = 0;

            first start;
            then action reckon {
                assign cost := favour.experiencePerLevel * level;
            }
            then decide welcome;
            if alive and not flirtedToday and favour.suitor == sex and spouse == Spouse::nobody
                and favour.charmNeeded >= 0 and favour.experiencePerLevel >= 0
                and charm >= favour.charmNeeded and experience >= cost then pay;
            else done;

            action pay {
                assign experience := experience - cost;
                assign flirtedToday := true;
            }

            decide favourKind;

            action charmed {
                assign charm := charm + 1;
            }

            action wed {
                assign spouse := if favour.suitor == Sex::male ? Spouse::violet else Spouse::sethAble;
            }

            action bed {
                assign lays := lays + 1;
                assign charm := charm + 1;
            }

            decide cradle;

            action childBorn {
                assign children := children + 1;
            }

            action noChild;

            succession first pay then favourKind;
            first favourKind if favour.weds then wed;
            first favourKind if favour.beds and not favour.weds then bed;
            first favourKind if not favour.beds and not favour.weds then charmed;
            succession first charmed then done;
            succession first wed then done;
            succession first bed then cradle;
            first cradle if true then childBorn;
            first cradle if true then noChild;
            succession first childBorn then done;
            succession first noChild then done;
        }

        // A divorce sets charm back to fifty, or to thirty for a bride the bard leaves.
        action divorce {
            first start;
            then decide married;
            if alive and spouse != Spouse::nobody then separate;
            else done;

            action separate {
                assign charm := if spouse == Spouse::sethAble ? 30 else 50;
                assign spouse := Spouse::nobody;
            }
            then done;
        }

        // Seth Able's song, once a day: which one he sings is the dice, and each does
        // something for the listener.
        action listenToTheBard {
            first start;
            then decide mayListen;
            if alive and not heardTheBard then listen;
            else done;

            action listen {
                assign heardTheBard := true;
            }

            decide song;

            action threeFights {
                assign forestFightsLeft := forestFightsLeft + 3;
            }

            action twoFights {
                assign forestFightsLeft := forestFightsLeft + 2;
            }

            action oneFight {
                assign forestFightsLeft := forestFightsLeft + 1;
            }

            action userBattle {
                assign playerFightsLeft := playerFightsLeft + 1;
            }

            action hitPointsMaxed {
                assign hitPoints := maxHitPoints;
            }

            action hitPointUp {
                assign maxHitPoints := maxHitPoints + 1;
                assign hitPoints := hitPoints + 1;
            }

            action bankDoubled {
                assign bankGold := 2 * bankGold;
            }

            action charmPoint {
                assign charm := charm + 1;
            }

            succession first listen then song;
            first song if true then threeFights;
            first song if true then twoFights;
            first song if true then oneFight;
            first song if true then userBattle;
            first song if true then hitPointsMaxed;
            first song if true then hitPointUp;
            first song if true then bankDoubled;
            first song if true then charmPoint;
            succession first threeFights then done;
            succession first twoFights then done;
            succession first oneFight then done;
            succession first userBattle then done;
            succession first hitPointsMaxed then done;
            succession first hitPointUp then done;
            succession first bankDoubled then done;
            succession first charmPoint then done;
        }

        // Midnight: the fights come back, one more per child; the skills' uses are dealt;
        // the bank pays (never charges); the slain rise; the fairy escapes; the inn empties;
        // and the town crier has the day's news, whichever the dice pick.
        action newDay {
            in interestPercent : Integer = 10;

            first start;
            then action reset {
                assign daysPlayed := daysPlayed + 1;
                assign forestFightsLeft := 15 + children;
                assign playerFightsLeft := 3;
                assign foe.present := false;
                assign deathKnightUses := SkillUses(deathKnightPoints, 4);
                assign thievingUses := SkillUses(thievingPoints, 4);
                assign mysticalUses := mysticalPoints;
                assign bankGold := bankGold + Interest(bankGold, max(0, interestPercent));
                assign hitPoints := maxHitPoints;
                assign alive := true;
                assign lightShield := false;
                assign fairy := false;
                assign innRoom := false;
                assign bribed := false;
                assign heardTheBard := false;
                assign flirtedToday := false;
                assign trainedToday := false;
                assign taughtToday := false;
                assign blessedToday := false;
                assign grabbedToday := false;
            }

            decide crier;

            action moreChildrenMissing { assign news := "More children are missing today."; }
            action smallGirlMissing { assign news := "A small girl was missing today."; }
            action townInGrief { assign news := "The town is in grief.  Several children didn't come home today."; }
            action dragonSighting { assign news := "Dragon sighting reported today by a drunken old man."; }
            action bloodyRemains { assign news := "Despair covers the land - more bloody remains have been found today."; }
            action natureWalk { assign news := "A group of children did not return from a nature walk today."; }
            action landInChaos { assign news := "The land is in chaos today.  Will the abductions ever stop?"; }
            action dragonScales { assign news := "Dragon scales have been found in the forest today..Old or new?"; }
            action missingCattle { assign news := "Several farmers report missing cattle today."; }
            action childFound { assign news := "A Child was found today!  But scared deaf and dumb."; }

            succession first reset then crier;
            first crier if true then moreChildrenMissing;
            first crier if true then smallGirlMissing;
            first crier if true then townInGrief;
            first crier if true then dragonSighting;
            first crier if true then bloodyRemains;
            first crier if true then natureWalk;
            first crier if true then landInChaos;
            first crier if true then dragonScales;
            first crier if true then missingCattle;
            first crier if true then childFound;
            succession first moreChildrenMissing then done;
            succession first smallGirlMissing then done;
            succession first townInGrief then done;
            succession first dragonSighting then done;
            succession first bloodyRemains then done;
            succession first natureWalk then done;
            succession first landInChaos then done;
            succession first dragonScales then done;
            succession first missingCattle then done;
            succession first childFound then done;
        }

        // The game's menu: the town square, the places its keys lead to, the forest and
        // what hides in it, the inn's room, and the grave a slain warrior waits in.
        exhibit state day {
            entry; then townSquare;

            state townSquare;

            state forest;

            // Face to face with a monster: the sword, a skill or the way out, round by round.
            state fighting;

            state darkCloakTavern;

            state healersHut;

            state bank;

            state trainingHall;

            state inn;

            // Abed at the inn, a warrior waits for midnight.
            state asleep;

            state slaughter;

            // The town's "Other Places" are the game's plug-in modules; the model has none.
            state otherPlaces;

            state slain;

            transition townSquare_forest
                first townSquare
                accept EnterForest
                then forest;

            // While fights remain, the dice pick one of the monsters of the warrior's level to meet.
            transition forest_fight
                first forest
                accept LookForSomethingToKill
                if forestFightsLeft > 0 and alive
                do action hunting {
                    first start;
                    then decide byLevel;
                    if level == 1 then level1;
                    if level == 2 then level2;
                    if level == 3 then level3;
                    if level == 4 then level4;
                    if level == 5 then level5;
                    if level == 6 then level6;
                    if level == 7 then level7;
                    if level == 8 then level8;
                    if level == 9 then level9;
                    if level == 10 then level10;
                    if level == 11 then level11;
                    if level == 12 then level12;
                    else done;

                    action level1 {
                        first start;
                        then decide roll;
                        if true then smallThief;
                        if true then rudeBoy;
                        if true then oldMan;
                        if true then largeGreenRat;
                        if true then wildBoar;
                        if true then uglyOldHag;
                        if true then largeMosquito;
                        if true then branTheWarrior;
                        if true then evilWretch;
                        if true then smallBear;
                        if true then smallTroll;
                        action smallThief { first start; then perform meet { in monster = town.forest.level1.smallThief; } then done; }
                        then done;
                        action rudeBoy { first start; then perform meet { in monster = town.forest.level1.rudeBoy; } then done; }
                        then done;
                        action oldMan { first start; then perform meet { in monster = town.forest.level1.oldMan; } then done; }
                        then done;
                        action largeGreenRat { first start; then perform meet { in monster = town.forest.level1.largeGreenRat; } then done; }
                        then done;
                        action wildBoar { first start; then perform meet { in monster = town.forest.level1.wildBoar; } then done; }
                        then done;
                        action uglyOldHag { first start; then perform meet { in monster = town.forest.level1.uglyOldHag; } then done; }
                        then done;
                        action largeMosquito { first start; then perform meet { in monster = town.forest.level1.largeMosquito; } then done; }
                        then done;
                        action branTheWarrior { first start; then perform meet { in monster = town.forest.level1.branTheWarrior; } then done; }
                        then done;
                        action evilWretch { first start; then perform meet { in monster = town.forest.level1.evilWretch; } then done; }
                        then done;
                        action smallBear { first start; then perform meet { in monster = town.forest.level1.smallBear; } then done; }
                        then done;
                        action smallTroll { first start; then perform meet { in monster = town.forest.level1.smallTroll; } then done; }
                        then done;
                    }
                    then done;
                    action level2 {
                        first start;
                        then decide roll;
                        if true then greenPython;
                        if true then gathTheBarbarian;
                        if true then evilWoodNymph;
                        if true then fedrickTheLimpingBaboon;
                        if true then wildMan;
                        if true then brorandiaTheViking;
                        if true then hugeBaldMan;
                        if true then senileSeniorCitizen;
                        if true then membrainMan;
                        if true then bentRiverDryad;
                        if true then rockMan;
                        action greenPython { first start; then perform meet { in monster = town.forest.level2.greenPython; } then done; }
                        then done;
                        action gathTheBarbarian { first start; then perform meet { in monster = town.forest.level2.gathTheBarbarian; } then done; }
                        then done;
                        action evilWoodNymph { first start; then perform meet { in monster = town.forest.level2.evilWoodNymph; } then done; }
                        then done;
                        action fedrickTheLimpingBaboon { first start; then perform meet { in monster = town.forest.level2.fedrickTheLimpingBaboon; } then done; }
                        then done;
                        action wildMan { first start; then perform meet { in monster = town.forest.level2.wildMan; } then done; }
                        then done;
                        action brorandiaTheViking { first start; then perform meet { in monster = town.forest.level2.brorandiaTheViking; } then done; }
                        then done;
                        action hugeBaldMan { first start; then perform meet { in monster = town.forest.level2.hugeBaldMan; } then done; }
                        then done;
                        action senileSeniorCitizen { first start; then perform meet { in monster = town.forest.level2.senileSeniorCitizen; } then done; }
                        then done;
                        action membrainMan { first start; then perform meet { in monster = town.forest.level2.membrainMan; } then done; }
                        then done;
                        action bentRiverDryad { first start; then perform meet { in monster = town.forest.level2.bentRiverDryad; } then done; }
                        then done;
                        action rockMan { first start; then perform meet { in monster = town.forest.level2.rockMan; } then done; }
                        then done;
                    }
                    then done;
                    action level3 {
                        first start;
                        then decide roll;
                        if true then lazyBum;
                        if true then twoHeadedRotwieler;
                        if true then purpleMonchichi;
                        if true then bone;
                        if true then redNeck;
                        if true then wingedDemonOfDeath;
                        if true then blackOwl;
                        if true then muscledMidget;
                        if true then headbangerOfTheWest;
                        if true then morbidWalker;
                        if true then magicalEvilGnome;
                        action lazyBum { first start; then perform meet { in monster = town.forest.level3.lazyBum; } then done; }
                        then done;
                        action twoHeadedRotwieler { first start; then perform meet { in monster = town.forest.level3.twoHeadedRotwieler; } then done; }
                        then done;
                        action purpleMonchichi { first start; then perform meet { in monster = town.forest.level3.purpleMonchichi; } then done; }
                        then done;
                        action bone { first start; then perform meet { in monster = town.forest.level3.bone; } then done; }
                        then done;
                        action redNeck { first start; then perform meet { in monster = town.forest.level3.redNeck; } then done; }
                        then done;
                        action wingedDemonOfDeath { first start; then perform meet { in monster = town.forest.level3.wingedDemonOfDeath; } then done; }
                        then done;
                        action blackOwl { first start; then perform meet { in monster = town.forest.level3.blackOwl; } then done; }
                        then done;
                        action muscledMidget { first start; then perform meet { in monster = town.forest.level3.muscledMidget; } then done; }
                        then done;
                        action headbangerOfTheWest { first start; then perform meet { in monster = town.forest.level3.headbangerOfTheWest; } then done; }
                        then done;
                        action morbidWalker { first start; then perform meet { in monster = town.forest.level3.morbidWalker; } then done; }
                        then done;
                        action magicalEvilGnome { first start; then perform meet { in monster = town.forest.level3.magicalEvilGnome; } then done; }
                        then done;
                    }
                    then done;
                    action level4 {
                        first start;
                        then decide roll;
                        if true then deathDog;
                        if true then weakOrc;
                        if true then darkElf;
                        if true then evilHobbit;
                        if true then shortGoblin;
                        if true then hugeBlackBear;
                        if true then rabidWolf;
                        if true then youngWizard;
                        if true then mudMan;
                        if true then deathJester;
                        if true then rockMan;
                        action deathDog { first start; then perform meet { in monster = town.forest.level4.deathDog; } then done; }
                        then done;
                        action weakOrc { first start; then perform meet { in monster = town.forest.level4.weakOrc; } then done; }
                        then done;
                        action darkElf { first start; then perform meet { in monster = town.forest.level4.darkElf; } then done; }
                        then done;
                        action evilHobbit { first start; then perform meet { in monster = town.forest.level4.evilHobbit; } then done; }
                        then done;
                        action shortGoblin { first start; then perform meet { in monster = town.forest.level4.shortGoblin; } then done; }
                        then done;
                        action hugeBlackBear { first start; then perform meet { in monster = town.forest.level4.hugeBlackBear; } then done; }
                        then done;
                        action rabidWolf { first start; then perform meet { in monster = town.forest.level4.rabidWolf; } then done; }
                        then done;
                        action youngWizard { first start; then perform meet { in monster = town.forest.level4.youngWizard; } then done; }
                        then done;
                        action mudMan { first start; then perform meet { in monster = town.forest.level4.mudMan; } then done; }
                        then done;
                        action deathJester { first start; then perform meet { in monster = town.forest.level4.deathJester; } then done; }
                        then done;
                        action rockMan { first start; then perform meet { in monster = town.forest.level4.rockMan; } then done; }
                        then done;
                    }
                    then done;
                    action level5 {
                        first start;
                        then decide roll;
                        if true then pandionKnight;
                        if true then jabba;
                        if true then manokenSloth;
                        if true then trojanWarrior;
                        if true then misfitTheUgly;
                        if true then georgeOfTheJungle;
                        if true then silentDeath;
                        if true then baldMedusa;
                        if true then blackAlligator;
                        if true then clancySonOfEmpororLen;
                        if true then blackSorcerer;
                        action pandionKnight { first start; then perform meet { in monster = town.forest.level5.pandionKnight; } then done; }
                        then done;
                        action jabba { first start; then perform meet { in monster = town.forest.level5.jabba; } then done; }
                        then done;
                        action manokenSloth { first start; then perform meet { in monster = town.forest.level5.manokenSloth; } then done; }
                        then done;
                        action trojanWarrior { first start; then perform meet { in monster = town.forest.level5.trojanWarrior; } then done; }
                        then done;
                        action misfitTheUgly { first start; then perform meet { in monster = town.forest.level5.misfitTheUgly; } then done; }
                        then done;
                        action georgeOfTheJungle { first start; then perform meet { in monster = town.forest.level5.georgeOfTheJungle; } then done; }
                        then done;
                        action silentDeath { first start; then perform meet { in monster = town.forest.level5.silentDeath; } then done; }
                        then done;
                        action baldMedusa { first start; then perform meet { in monster = town.forest.level5.baldMedusa; } then done; }
                        then done;
                        action blackAlligator { first start; then perform meet { in monster = town.forest.level5.blackAlligator; } then done; }
                        then done;
                        action clancySonOfEmpororLen { first start; then perform meet { in monster = town.forest.level5.clancySonOfEmpororLen; } then done; }
                        then done;
                        action blackSorcerer { first start; then perform meet { in monster = town.forest.level5.blackSorcerer; } then done; }
                        then done;
                    }
                    then done;
                    action level6 {
                        first start;
                        then decide roll;
                        if true then ironWarrior;
                        if true then blackSoul;
                        if true then goldMan;
                        if true then screamingZombie;
                        if true then satansHelper;
                        if true then wildStallion;
                        if true then belar;
                        if true then emptyArmour;
                        if true then ragingLion;
                        if true then hugeStoneWarrior;
                        if true then magicalEvilGnome;
                        action ironWarrior { first start; then perform meet { in monster = town.forest.level6.ironWarrior; } then done; }
                        then done;
                        action blackSoul { first start; then perform meet { in monster = town.forest.level6.blackSoul; } then done; }
                        then done;
                        action goldMan { first start; then perform meet { in monster = town.forest.level6.goldMan; } then done; }
                        then done;
                        action screamingZombie { first start; then perform meet { in monster = town.forest.level6.screamingZombie; } then done; }
                        then done;
                        action satansHelper { first start; then perform meet { in monster = town.forest.level6.satansHelper; } then done; }
                        then done;
                        action wildStallion { first start; then perform meet { in monster = town.forest.level6.wildStallion; } then done; }
                        then done;
                        action belar { first start; then perform meet { in monster = town.forest.level6.belar; } then done; }
                        then done;
                        action emptyArmour { first start; then perform meet { in monster = town.forest.level6.emptyArmour; } then done; }
                        then done;
                        action ragingLion { first start; then perform meet { in monster = town.forest.level6.ragingLion; } then done; }
                        then done;
                        action hugeStoneWarrior { first start; then perform meet { in monster = town.forest.level6.hugeStoneWarrior; } then done; }
                        then done;
                        action magicalEvilGnome { first start; then perform meet { in monster = town.forest.level6.magicalEvilGnome; } then done; }
                        then done;
                    }
                    then done;
                    action level7 {
                        first start;
                        then decide roll;
                        if true then emporerLen;
                        if true then nightHawk;
                        if true then chargingRhinoceros;
                        if true then goblinPygmy;
                        if true then goliath;
                        if true then angryLiontaur;
                        if true then fallenAngel;
                        if true then wickedWombat;
                        if true then massiveDinosaur;
                        if true then swissButcher;
                        if true then deathGnome;
                        action emporerLen { first start; then perform meet { in monster = town.forest.level7.emporerLen; } then done; }
                        then done;
                        action nightHawk { first start; then perform meet { in monster = town.forest.level7.nightHawk; } then done; }
                        then done;
                        action chargingRhinoceros { first start; then perform meet { in monster = town.forest.level7.chargingRhinoceros; } then done; }
                        then done;
                        action goblinPygmy { first start; then perform meet { in monster = town.forest.level7.goblinPygmy; } then done; }
                        then done;
                        action goliath { first start; then perform meet { in monster = town.forest.level7.goliath; } then done; }
                        then done;
                        action angryLiontaur { first start; then perform meet { in monster = town.forest.level7.angryLiontaur; } then done; }
                        then done;
                        action fallenAngel { first start; then perform meet { in monster = town.forest.level7.fallenAngel; } then done; }
                        then done;
                        action wickedWombat { first start; then perform meet { in monster = town.forest.level7.wickedWombat; } then done; }
                        then done;
                        action massiveDinosaur { first start; then perform meet { in monster = town.forest.level7.massiveDinosaur; } then done; }
                        then done;
                        action swissButcher { first start; then perform meet { in monster = town.forest.level7.swissButcher; } then done; }
                        then done;
                        action deathGnome { first start; then perform meet { in monster = town.forest.level7.deathGnome; } then done; }
                        then done;
                    }
                    then done;
                    action level8 {
                        first start;
                        then decide roll;
                        if true then screechingWitch;
                        if true then rundorig;
                        if true then wheeler;
                        if true then deathKnight;
                        if true then werewolf;
                        if true then fireOrk;
                        if true then wansBeast;
                        if true then lordMathese;
                        if true then kingVidion;
                        if true then babyDragon;
                        if true then deathGnome;
                        action screechingWitch { first start; then perform meet { in monster = town.forest.level8.screechingWitch; } then done; }
                        then done;
                        action rundorig { first start; then perform meet { in monster = town.forest.level8.rundorig; } then done; }
                        then done;
                        action wheeler { first start; then perform meet { in monster = town.forest.level8.wheeler; } then done; }
                        then done;
                        action deathKnight { first start; then perform meet { in monster = town.forest.level8.deathKnight; } then done; }
                        then done;
                        action werewolf { first start; then perform meet { in monster = town.forest.level8.werewolf; } then done; }
                        then done;
                        action fireOrk { first start; then perform meet { in monster = town.forest.level8.fireOrk; } then done; }
                        then done;
                        action wansBeast { first start; then perform meet { in monster = town.forest.level8.wansBeast; } then done; }
                        then done;
                        action lordMathese { first start; then perform meet { in monster = town.forest.level8.lordMathese; } then done; }
                        then done;
                        action kingVidion { first start; then perform meet { in monster = town.forest.level8.kingVidion; } then done; }
                        then done;
                        action babyDragon { first start; then perform meet { in monster = town.forest.level8.babyDragon; } then done; }
                        then done;
                        action deathGnome { first start; then perform meet { in monster = town.forest.level8.deathGnome; } then done; }
                        then done;
                    }
                    then done;
                    action level9 {
                        first start;
                        then decide roll;
                        if true then pinkElephant;
                        if true then gwendolensNightmare;
                        if true then flyingCobra;
                        if true then rentakisPet;
                        if true then ernestBrown;
                        if true then scallianRap;
                        if true then apeman;
                        if true then hemoGlob;
                        if true then frankenmoose;
                        if true then earthShaker;
                        if true then gollumsWrath;
                        action pinkElephant { first start; then perform meet { in monster = town.forest.level9.pinkElephant; } then done; }
                        then done;
                        action gwendolensNightmare { first start; then perform meet { in monster = town.forest.level9.gwendolensNightmare; } then done; }
                        then done;
                        action flyingCobra { first start; then perform meet { in monster = town.forest.level9.flyingCobra; } then done; }
                        then done;
                        action rentakisPet { first start; then perform meet { in monster = town.forest.level9.rentakisPet; } then done; }
                        then done;
                        action ernestBrown { first start; then perform meet { in monster = town.forest.level9.ernestBrown; } then done; }
                        then done;
                        action scallianRap { first start; then perform meet { in monster = town.forest.level9.scallianRap; } then done; }
                        then done;
                        action apeman { first start; then perform meet { in monster = town.forest.level9.apeman; } then done; }
                        then done;
                        action hemoGlob { first start; then perform meet { in monster = town.forest.level9.hemoGlob; } then done; }
                        then done;
                        action frankenmoose { first start; then perform meet { in monster = town.forest.level9.frankenmoose; } then done; }
                        then done;
                        action earthShaker { first start; then perform meet { in monster = town.forest.level9.earthShaker; } then done; }
                        then done;
                        action gollumsWrath { first start; then perform meet { in monster = town.forest.level9.gollumsWrath; } then done; }
                        then done;
                    }
                    then done;
                    action level10 {
                        first start;
                        then decide roll;
                        if true then toraksSonKorak;
                        if true then brandTheWanderer;
                        if true then theGrimestReaper;
                        if true then deathDealer;
                        if true then tigerOfTheDeepJungle;
                        if true then sweetLookingLittleGirl;
                        if true then floatingEvilEye;
                        if true then slock;
                        if true then adultGoldDragon;
                        if true then killJoy;
                        if true then blackSorcerer;
                        action toraksSonKorak { first start; then perform meet { in monster = town.forest.level10.toraksSonKorak; } then done; }
                        then done;
                        action brandTheWanderer { first start; then perform meet { in monster = town.forest.level10.brandTheWanderer; } then done; }
                        then done;
                        action theGrimestReaper { first start; then perform meet { in monster = town.forest.level10.theGrimestReaper; } then done; }
                        then done;
                        action deathDealer { first start; then perform meet { in monster = town.forest.level10.deathDealer; } then done; }
                        then done;
                        action tigerOfTheDeepJungle { first start; then perform meet { in monster = town.forest.level10.tigerOfTheDeepJungle; } then done; }
                        then done;
                        action sweetLookingLittleGirl { first start; then perform meet { in monster = town.forest.level10.sweetLookingLittleGirl; } then done; }
                        then done;
                        action floatingEvilEye { first start; then perform meet { in monster = town.forest.level10.floatingEvilEye; } then done; }
                        then done;
                        action slock { first start; then perform meet { in monster = town.forest.level10.slock; } then done; }
                        then done;
                        action adultGoldDragon { first start; then perform meet { in monster = town.forest.level10.adultGoldDragon; } then done; }
                        then done;
                        action killJoy { first start; then perform meet { in monster = town.forest.level10.killJoy; } then done; }
                        then done;
                        action blackSorcerer { first start; then perform meet { in monster = town.forest.level10.blackSorcerer; } then done; }
                        then done;
                    }
                    then done;
                    action level11 {
                        first start;
                        then decide roll;
                        if true then gormaTheLeper;
                        if true then shogunWarrior;
                        if true then apparentlyWeakOldWoman;
                        if true then ablesCreature;
                        if true then whiteBearOfLore;
                        if true then mountain;
                        if true then sheenaTheShapechanger;
                        if true then shadowstormwarrior;
                        if true then madman;
                        if true then vegetableCreature;
                        if true then cyclopsWarrior;
                        action gormaTheLeper { first start; then perform meet { in monster = town.forest.level11.gormaTheLeper; } then done; }
                        then done;
                        action shogunWarrior { first start; then perform meet { in monster = town.forest.level11.shogunWarrior; } then done; }
                        then done;
                        action apparentlyWeakOldWoman { first start; then perform meet { in monster = town.forest.level11.apparentlyWeakOldWoman; } then done; }
                        then done;
                        action ablesCreature { first start; then perform meet { in monster = town.forest.level11.ablesCreature; } then done; }
                        then done;
                        action whiteBearOfLore { first start; then perform meet { in monster = town.forest.level11.whiteBearOfLore; } then done; }
                        then done;
                        action mountain { first start; then perform meet { in monster = town.forest.level11.mountain; } then done; }
                        then done;
                        action sheenaTheShapechanger { first start; then perform meet { in monster = town.forest.level11.sheenaTheShapechanger; } then done; }
                        then done;
                        action shadowstormwarrior { first start; then perform meet { in monster = town.forest.level11.shadowstormwarrior; } then done; }
                        then done;
                        action madman { first start; then perform meet { in monster = town.forest.level11.madman; } then done; }
                        then done;
                        action vegetableCreature { first start; then perform meet { in monster = town.forest.level11.vegetableCreature; } then done; }
                        then done;
                        action cyclopsWarrior { first start; then perform meet { in monster = town.forest.level11.cyclopsWarrior; } then done; }
                        then done;
                    }
                    then done;
                    action level12 {
                        first start;
                        then decide roll;
                        if true then corinthianGiant;
                        if true then theScreamingEunich;
                        if true then blackWarlock;
                        if true then kalTorak;
                        if true then theMightyShadow;
                        if true then blackUnicorn;
                        if true then mutatedBlackWidow;
                        if true then humongousBlackWyre;
                        if true then theWizardOfDarkness;
                        if true then greatOgreOfTheNorth;
                        action corinthianGiant { first start; then perform meet { in monster = town.forest.level12.corinthianGiant; } then done; }
                        then done;
                        action theScreamingEunich { first start; then perform meet { in monster = town.forest.level12.theScreamingEunich; } then done; }
                        then done;
                        action blackWarlock { first start; then perform meet { in monster = town.forest.level12.blackWarlock; } then done; }
                        then done;
                        action kalTorak { first start; then perform meet { in monster = town.forest.level12.kalTorak; } then done; }
                        then done;
                        action theMightyShadow { first start; then perform meet { in monster = town.forest.level12.theMightyShadow; } then done; }
                        then done;
                        action blackUnicorn { first start; then perform meet { in monster = town.forest.level12.blackUnicorn; } then done; }
                        then done;
                        action mutatedBlackWidow { first start; then perform meet { in monster = town.forest.level12.mutatedBlackWidow; } then done; }
                        then done;
                        action humongousBlackWyre { first start; then perform meet { in monster = town.forest.level12.humongousBlackWyre; } then done; }
                        then done;
                        action theWizardOfDarkness { first start; then perform meet { in monster = town.forest.level12.theWizardOfDarkness; } then done; }
                        then done;
                        action greatOgreOfTheNorth { first start; then perform meet { in monster = town.forest.level12.greatOgreOfTheNorth; } then done; }
                        then done;
                    }
                    then done;
                }
                then fighting;

            transition forest_dragon
                first forest
                accept SeekTheDragon
                if forestFightsLeft > 0 and alive and level == 12
                do action braving { perform meetTheDragon; }
                then fighting;

            transition fighting_attack
                first fighting
                accept AttackTheFoe
                if alive and foe.present and foe.hitPoints > 0
                do action striking { perform strike; }
                then fighting;

            transition fighting_skill
                first fighting
                accept s : UseASkill
                if alive and foe.present and foe.hitPoints > 0
                    and SkillReady(s.move, deathKnightUses, thievingUses, mysticalUses, lightShield)
                do action casting { perform useSkill { in move = s.move; } }
                then fighting;

            transition fighting_run
                first fighting
                accept RunAway
                if alive and foe.present and foe.hitPoints > 0
                do action fleeing { perform run; }
                then fighting;

            // A fallen foe is stripped on the way back to the forest; a fled one is left behind.
            transition fighting_won
                first fighting
                if alive and foe.present and foe.hitPoints <= 0
                do action claiming { perform win; }
                then forest;

            transition fighting_fled
                first fighting
                if alive and not foe.present
                then forest;

            transition fighting_slain
                first fighting
                if not alive
                then slain;

            transition forest_guild
                first forest
                accept MeetYourGuild
                if alive
                do action learning { perform learnSkill; }
                then forest;

            transition forest_hag
                first forest
                accept MeetTheOldHag
                if alive and gems >= 1
                do action bargaining { perform meetTheOldHag; }
                then forest;

            transition forest_fairies
                first forest
                accept AskTheFairies
                if alive and not blessedToday
                do action asking { perform askTheFairies; }
                then forest;

            transition forest_catch
                first forest
                accept CatchAFairy
                if alive and not fairy and not grabbedToday
                do action grabbing { perform catchAFairy; }
                then forest;

            transition forest_tavern
                first forest
                accept FindTheDarkCloakTavern
                if alive
                then darkCloakTavern;

            transition tavern_gamble
                first darkCloakTavern
                accept Gamble
                if alive and gold >= 100
                do action betting { perform gamble; }
                then darkCloakTavern;

            transition tavern_profession
                first darkCloakTavern
                accept ChangeProfession
                if alive
                do action retraining { perform changeProfession; }
                then darkCloakTavern;

            transition tavern_forest
                first darkCloakTavern
                accept ReturnToTheForest
                then forest;

            transition forest_slain
                first forest
                if not alive
                then slain;

            transition forest_town
                first forest
                accept ReturnToTown
                then townSquare;

            transition townSquare_healer
                first townSquare
                accept VisitTheHealer
                do action healing { perform heal; }
                then healersHut;

            transition healer_town
                first healersHut
                accept ReturnToTown
                then townSquare;

            transition townSquare_bank
                first townSquare
                accept VisitTheBank
                then bank;

            transition bank_rob
                first bank
                accept RobTheBank
                if alive and class == CharacterClass::thievingSkills and fairy
                do action robbing { perform robTheBank; }
                then bank;

            transition bank_town
                first bank
                accept ReturnToTown
                then townSquare;

            // The hall sends the master of the next level; a twelfth-level warrior meets none.
            transition townSquare_training
                first townSquare
                accept VisitTheTrainingHall
                do action training {
                    first start;
                    then decide byLevel;
                    if level == 1 then halder;
                    if level == 2 then barak;
                    if level == 3 then aragorn;
                    if level == 4 then olodrin;
                    if level == 5 then sandtiger;
                    if level == 6 then sparhawk;
                    if level == 7 then atsukoSensei;
                    if level == 8 then aladdin;
                    if level == 9 then princeCaspian;
                    if level == 10 then gandalf;
                    if level == 11 then turgon;
                    else done;
                    action halder { first start; then perform train { in master = town.training.halder; } then done; }
                    then done;
                    action barak { first start; then perform train { in master = town.training.barak; } then done; }
                    then done;
                    action aragorn { first start; then perform train { in master = town.training.aragorn; } then done; }
                    then done;
                    action olodrin { first start; then perform train { in master = town.training.olodrin; } then done; }
                    then done;
                    action sandtiger { first start; then perform train { in master = town.training.sandtiger; } then done; }
                    then done;
                    action sparhawk { first start; then perform train { in master = town.training.sparhawk; } then done; }
                    then done;
                    action atsukoSensei { first start; then perform train { in master = town.training.atsukoSensei; } then done; }
                    then done;
                    action aladdin { first start; then perform train { in master = town.training.aladdin; } then done; }
                    then done;
                    action princeCaspian { first start; then perform train { in master = town.training.princeCaspian; } then done; }
                    then done;
                    action gandalf { first start; then perform train { in master = town.training.gandalf; } then done; }
                    then done;
                    action turgon { first start; then perform train { in master = town.training.turgon; } then done; }
                    then done;
                }
                then trainingHall;

            transition training_town
                first trainingHall
                accept ReturnToTown
                then townSquare;

            transition townSquare_inn
                first townSquare
                accept VisitTheInn
                then inn;

            transition inn_flirt
                first inn
                accept FlirtAtTheInn
                if alive and not flirtedToday
                do action flirting { perform flirt; }
                then inn;

            transition inn_divorce
                first inn
                accept AskForADivorce
                if alive and spouse != Spouse::nobody
                do action divorcing { perform divorce; }
                then inn;

            transition inn_bard
                first inn
                accept ListenToTheBard
                if alive and not heardTheBard
                do action listening { perform listenToTheBard; }
                then inn;

            transition inn_bribe
                first inn
                accept BribeTheBartender
                if alive and level >= 2 and not bribed and gold >= BribePrice(level)
                do action bribing { perform bribeTheBartender; }
                then inn;

            transition inn_gems
                first inn
                accept TradeGems
                if alive and level >= 2 and gems >= town.inn.gemsPerStatPoint
                do action trading { perform tradeGems; }
                then inn;

            transition inn_room
                first inn
                accept BuyARoom
                if alive and not innRoom
                    and (charm >= town.inn.charmForAFreeRoom or gold >= RoomPrice(level))
                do action lodging { perform buyRoom; }
                then asleep;

            transition inn_town
                first inn
                accept ReturnToTown
                then townSquare;

            transition asleep_midnight
                first asleep
                accept NewDay
                do action midnight { perform newDay; }
                then townSquare;

            transition townSquare_slaughter
                first townSquare
                accept SlaughterOtherPlayers
                then slaughter;

            transition slaughter_attack
                first slaughter
                accept AttackAWarrior
                if playerFightsLeft > 0 and alive
                do action attacking { perform attack; }
                then slaughter;

            transition slaughter_slain
                first slaughter
                if not alive
                then slain;

            transition slaughter_town
                first slaughter
                accept ReturnToTown
                then townSquare;

            transition townSquare_otherPlaces
                first townSquare
                accept OtherPlaces
                then otherPlaces;

            transition otherPlaces_town
                first otherPlaces
                accept ReturnToTown
                then townSquare;

            // Midnight comes to a warrior in the square too, without the inn's protection.
            transition townSquare_midnight
                first townSquare
                accept NewDay
                do action midnight { perform newDay; }
                then townSquare;

            transition slain_midnight
                first slain
                accept NewDay
                do action midnight { perform newDay; }
                then townSquare;
        }
    }

    part hero : Warrior {
        attribute :>> name = "Sir Devin";
    }

    // A warrior of the other sex, charming enough for the bard's hand.
    part heroine : Warrior {
        attribute :>> name = "Dame Devin";
        attribute :>> sex = Sex::female;
        attribute :>> class = CharacterClass::mysticalSkills;
        attribute :>> charm = 125;
    }

    // Whom the slaughter menu offers unless told otherwise: a first-level warrior
    // with a day's takings and a gem, out in the open.
    part rival : Warrior {
        attribute :>> name = "Bran the Braggart";
        attribute :>> experience = 50;
        attribute :>> gold = 120;
        attribute :>> gems = 1;
    }

    // A warrior at the top of the ladder, kitted out from both shops and a Death Knight master.
    part champion : Warrior {
        attribute :>> name = "Turgon's Equal";
        attribute :>> level = 12;
        attribute :>> experience = 10000000;
        attribute :>> hitPoints = 4500;
        attribute :>> maxHitPoints = 4500;
        attribute :>> strength = 1100;
        attribute :>> defense = 600;
        attribute :>> weaponTier = 13;
        attribute :>> weaponStrength = 800;
        attribute :>> armourTier = 13;
        attribute :>> armourDefense = 400;
        attribute :>> deathKnightPoints = 40;
        attribute :>> deathKnightUses = 10;
        attribute :>> favouredMove = Move::deathKnight;
    }

    // The hero a round into a forest fight, the Small Thief before him and neither yet touched.
    part cornered :> hero {
        part :>> foe {
            attribute :>> present = true;
            attribute :>> name = Lord::town.forest.level1.smallThief.name;
            attribute :>> weapon = Lord::town.forest.level1.smallThief.weapon;
            attribute :>> hitPoints = Lord::town.forest.level1.smallThief.hitPoints;
            attribute :>> strength = Lord::town.forest.level1.smallThief.strength;
            attribute :>> gold = Lord::town.forest.level1.smallThief.gold;
            attribute :>> experience = Lord::town.forest.level1.smallThief.experience;
        }
    }

    // The champion at the dragon's throat, the first round about to be struck.
    part dragonslayer :> champion {
        part :>> foe {
            attribute :>> present = true;
            attribute :>> dragon = true;
            attribute :>> name = Lord::town.forest.redDragon.name;
            attribute :>> weapon = Lord::town.forest.redDragon.weapon;
            attribute :>> hitPoints = Lord::town.forest.redDragon.hitPoints;
            attribute :>> strength = Lord::town.forest.redDragon.strength;
            attribute :>> breath = Lord::town.forest.redDragon.breath;
        }
    }
}

// What holds of a warrior, and what a solver can say about the dragon, the shops,
// the skills and the inn.
package LordOdds {
    private import ScalarValues::*;
    private import RealFunctions::floor;
    private import IntegerFunctions::max;
    private import TradeStudies::*;
    private import Lord::*;
    private import LordPlay::*;

    // Blows needed to take `targetHitPoints` off, landing every one.
    calc def BlowsToKill {
        in strength : Integer;
        in defense : Integer;
        in targetHitPoints : Integer;

        floor((targetHitPoints + Blow(strength, defense) - 1) / Blow(strength, defense))
    }

    // Only a level-twelve warrior with the best of both shops is let near the dragon.
    requirement def ReadyForTheDragon {
        subject warrior : Warrior;

        require constraint { warrior.level == 12 }
        require constraint { warrior.weaponTier == 13 }
        require constraint { warrior.armourTier == 13 }
    }

    // A straight brawl, the dragon stomping every round and the warrior swinging first:
    // the warrior must survive one blow fewer than it takes to fell the dragon.
    requirement def OutlastTheDragon {
        subject warrior : Warrior;
        attribute dragonHitPoints : Integer = 15000;
        attribute dragonStrength : Integer = 2000;

        require constraint {
            warrior.hitPoints + Blow(dragonStrength, warrior.defense)
                > Blow(dragonStrength, warrior.defense) * BlowsToKill(warrior.strength, 0, dragonHitPoints)
        }
    }

    // The same brawl against the flaming breath alone, which no armour blunts.
    requirement def OutlastTheBreath {
        subject warrior : Warrior;
        attribute dragonHitPoints : Integer = 15000;
        attribute breath : Integer = 1000;

        require constraint {
            warrior.hitPoints + breath > breath * BlowsToKill(warrior.strength, 0, dragonHitPoints)
        }
    }

    requirement readyForTheDragon : ReadyForTheDragon;
    requirement outlastTheDragon : OutlastTheDragon;
    requirement outlastTheBreath : OutlastTheBreath;

    // The Death Knights' way: three blows a round while the uses last, and the dragon's
    // hardest answer every round, breath or stomp, whichever hurts more.
    requirement def SlayWithPowerMoves {
        subject warrior : Warrior;
        attribute dragonHitPoints : Integer = 15000;
        attribute dragonStrength : Integer = 2000;
        attribute breath : Integer = 1000;

        require constraint {
            warrior.deathKnightUses >= BlowsToKill(3 * warrior.strength, 0, dragonHitPoints)
        }
        require constraint {
            warrior.hitPoints + max(breath, Blow(dragonStrength, warrior.defense))
                > max(breath, Blow(dragonStrength, warrior.defense))
                    * BlowsToKill(3 * warrior.strength, 0, dragonHitPoints)
        }
    }

    requirement slayWithPowerMoves : SlayWithPowerMoves;

    part dragonFights {
        assert satisfy readyForTheDragon by champion;
        assert satisfy readyForTheDragon by hero;
        assert satisfy outlastTheDragon by champion;
        assert satisfy outlastTheBreath by champion;
        assert satisfy slayWithPowerMoves by champion;
    }

    // A hand a warrior may ask for: the right sex, the charm, and nobody's spouse yet.
    requirement def MayWed {
        subject warrior : Warrior;
        ref part favour : Flirt;

        require constraint { favour.weds }
        require constraint { warrior.sex == favour.suitor }
        require constraint { warrior.charm >= favour.charmNeeded }
        require constraint { warrior.spouse == Spouse::nobody }
    }

    requirement mayWedViolet : MayWed { ref part :>> favour = town.inn.violet.marryHer; }
    requirement mayWedTheBard : MayWed { ref part :>> favour = town.inn.sethAble.marryHim; }

    part weddings {
        assert satisfy mayWedViolet by hero;
        assert satisfy mayWedViolet by heroine;
        assert satisfy mayWedTheBard by heroine;
    }

    // A sleeper at the inn may be attacked only by a bribed warrior at most a level above.
    requirement def MaySlaughter {
        subject attacker : Warrior;
        ref part sleeper : Warrior;

        require constraint { attacker.alive and attacker.playerFightsLeft > 0 }
        require constraint { sleeper.alive }
        require constraint { attacker != sleeper }
        require constraint { not sleeper.innRoom or (attacker.bribed and sleeper.level >= attacker.level - 1) }
    }

    requirement maySlaughterTheRival : MaySlaughter { ref part :>> sleeper = rival; }

    part slaughter {
        assert satisfy maySlaughterTheRival by hero;
        assert satisfy maySlaughterTheRival by champion;
    }

    // The fewest hit points that win the brawl with the best of both shops.
    analysis def ToughEnough {
        attribute hitPoints : Integer;
        attribute strength : Integer;
        attribute defense : Integer;
        attribute roundsToKill : Integer;

        objective fewestHitPoints : MinimizeObjective {
            subject :>> selectedAlternative;
            require constraint { strength == 1100 }
            require constraint { defense == 600 }
            require constraint { hitPoints >= 1 }
            require constraint { roundsToKill >= 1 }
            require constraint { strength * roundsToKill >= 15000 }
            require constraint { strength * (roundsToKill - 1) < 15000 }
            require constraint { hitPoints + (2000 - defense) > (2000 - defense) * roundsToKill }

            in calc :>> eval { hitPoints }
        }
    }

    // The same question the Death Knights' way: three blows a round, the stomp answering.
    analysis def ToughEnoughWithPowerMoves {
        attribute hitPoints : Integer;
        attribute strength : Integer;
        attribute defense : Integer;
        attribute roundsToKill : Integer;

        objective fewestHitPoints : MinimizeObjective {
            subject :>> selectedAlternative;
            require constraint { strength == 1100 }
            require constraint { defense == 600 }
            require constraint { hitPoints >= 1 }
            require constraint { roundsToKill >= 1 }
            require constraint { 3 * strength * roundsToKill >= 15000 }
            require constraint { 3 * strength * (roundsToKill - 1) < 15000 }
            require constraint { hitPoints + (2000 - defense) > (2000 - defense) * roundsToKill }

            in calc :>> eval { hitPoints }
        }
    }

    // The fewest Death Knight lessons for a day's worth of power moves, a level a day
    // being the other way to a point: four points buy one use.
    analysis def PowerMoves {
        attribute usesWanted : Integer;
        attribute levelsGained : Integer;
        attribute lessons : Integer;

        objective fewestLessons : MinimizeObjective {
            subject :>> selectedAlternative;
            require constraint { usesWanted == 3 }
            require constraint { levelsGained >= 0 and levelsGained <= 11 }
            require constraint { lessons >= 0 }
            require constraint { levelsGained + lessons <= 40 }
            require constraint { levelsGained + lessons >= 4 * usesWanted }
            require constraint { levelsGained <= 5 }

            in calc :>> eval { lessons }
        }
    }

    // The fewest gems that raise defense by the points asked, two gems a point at the inn.
    analysis def GemsForDefense {
        attribute pointsWanted : Integer;
        attribute gems : Integer;

        objective fewestGems : MinimizeObjective {
            subject :>> selectedAlternative;
            require constraint { pointsWanted == 5 }
            require constraint { gems >= 0 }
            require constraint { gems >= 2 * pointsWanted }

            in calc :>> eval { gems }
        }
    }

    // A first day: the starting purse plus fifteen fights of forest gold, and a weapon from it.
    requirement def FirstDayShopping {
        attribute startingGold : Integer;
        attribute forestGold : Integer;
        attribute weaponPrice : Integer;

        require constraint { startingGold == 500 }
        require constraint { forestGold >= 0 }
        require constraint { forestGold <= 15 * 110 }
        require constraint { weaponPrice <= startingGold + forestGold }
        require constraint { weaponPrice >= 1000 }
    }

    // The same day, asking for a Long Sword.
    requirement def FirstDayLongSword :> FirstDayShopping {
        require constraint { weaponPrice >= 10000 }
    }

    // The most a warrior of a given level pays for a night's rest and the bartender's silence.
    calc def NightAtTheInn {
        in level : Integer;

        RoomPrice(level) + BribePrice(level)
    }
}

// How the game is shown: the menu as a state diagram, the fights as flows, the town
// as a tree, and the news screen as a document with the shops', masters' and forest's lists.
package LordViews {
    private import Views::*;
    private import StandardViewDefinitions::*;
    private import DocumentQueries::*;
    private import KerML::Root::Element;
    private import ScalarValues::String;
    private import LordPlay::*;

    view townSquare : StateTransitionView {
        expose LordPlay::Warrior::day;
    }

    view forestFight : ActionFlowView {
        expose LordPlay::Warrior::strike;
    }

    view foesTurn : ActionFlowView {
        expose LordPlay::Warrior::foeStrikes;
    }

    view slaughter : ActionFlowView {
        expose LordPlay::Warrior::attack;
    }

    view flirting : ActionFlowView {
        expose LordPlay::Warrior::flirt;
    }

    view theTown {
        expose Lord::Town;
        render asTreeDiagram;
    }

    view theForest {
        expose Lord::Forest;
        render asTreeDiagram;
    }

    // The document's query roots: a table's query is bound to a usage.
    part kingArthurs : Lord::WeaponShop;
    part abduls : Lord::ArmourShop;
    part turgons : Lord::TrainingHall;
    part violets : Lord::Barmaid;
    part seths : Lord::Bard;
    part woods : Lord::Forest;

    // A part's items, one row each, as its definition declares them.
    calc def Stock :> Query {
        in shop : Element;
        WhereType(
            source = OwnedElements(
                source = RelatedElements(
                    source = shop,
                    relationshipKind = "typing",
                    direction = "outgoing",
                    maxDepth = 1
                )
            ),
            type = "PartUsage"
        )
    }

    // The forest's monsters of one level, one row each.
    calc def Haunting :> Query {
        in forest : Element;
        in level : String;
        WhereFeature(
            source = WhereFeature(
                source = WhereType(
                    source = Descendants(
                        source = RelatedElements(
                            source = forest,
                            relationshipKind = "typing",
                            direction = "outgoing",
                            maxDepth = 1
                        ),
                        maxDepth = 2
                    ),
                    type = "PartUsage"
                ),
                'feature' = "hitPoints",
                operator = ">",
                value = "0"
            ),
            'feature' = "level",
            operator = "==",
            value = level
        )
    }

    calc def WeaponList :> Query {
        in shop : Element;
        Project(
            source = Stock(shop = shop),
            properties = ("tier", "strength", "price"),
            columns = (Column(name = "weapon", expression = Lord::Weapon::name))
        )
    }

    calc def ArmourList :> Query {
        in shop : Element;
        Project(
            source = Stock(shop = shop),
            properties = ("tier", "defense", "price"),
            columns = (Column(name = "armour", expression = Lord::Armour::name))
        )
    }

    calc def MasterList :> Query {
        in hall : Element;
        Project(
            source = Stock(shop = hall),
            properties = ("teaches", "experienceRequired", "hitPoints", "strength", "defense"),
            columns = (Column(name = "master", expression = Lord::Master::name))
        )
    }

    calc def FavourList :> Query {
        in local : Element;
        Project(
            source = Stock(shop = local),
            properties = ("charmNeeded", "experiencePerLevel"),
            columns = (Column(name = "favour", expression = Lord::Flirt::name))
        )
    }

    calc def MonsterList :> Query {
        in forest : Element;
        in level : String;
        Project(
            source = OrderBy(
                source = Haunting(forest = forest, level = level),
                property = "experience",
                direction = "ascending",
                missing = "last",
                multiple = "error"
            ),
            properties = ("weapon", "strength", "hitPoints", "gold", "experience"),
            columns = (Column(name = "monster", expression = Lord::Monster::name))
        )
    }

    // Every assertion about the warrior bound to `root`.
    calc def Standing :> Query {
        in root : Element;
        Project(
            source = Verdicts(source = root),
            properties = ("path", "kind", "name", "verdict", "reason")
        )
    }

    // The Daily Happenings: the hero's standing as the session holds it, and the realm's lists.
    part def DailyHappenings :> Document {
        attribute redefines title = "The Daily Happenings";

        part intro : Paragraph {
            attribute redefines text = "What holds of the warrior, at the town square.";
        }
        part standing : Table {
            attribute redefines caption = "The warrior's standing";
            calc rows : Standing {
                in root = hero;
            }
        }
        part weapons : Table {
            attribute redefines caption = "King Arthur's Weapons";
            calc rows : WeaponList {
                in shop = kingArthurs;
            }
        }
        part armour : Table {
            attribute redefines caption = "Abdul's Armour";
            calc rows : ArmourList {
                in shop = abduls;
            }
        }
        part masters : Table {
            attribute redefines caption = "Turgon's Warrior Training";
            calc rows : MasterList {
                in hall = turgons;
            }
        }
        part violet : Table {
            attribute redefines caption = "Violet's favours";
            calc rows : FavourList {
                in local = violets;
            }
        }
        part sethAble : Table {
            attribute redefines caption = "Seth Able's favours";
            calc rows : FavourList {
                in local = seths;
            }
        }
        part forestOne : Table {
            attribute redefines caption = "The forest, level one";
            calc rows : MonsterList {
                in forest = woods;
                in level = "1";
            }
        }
        part forestTwelve : Table {
            attribute redefines caption = "The forest, level twelve";
            calc rows : MonsterList {
                in forest = woods;
                in level = "12";
            }
        }
    }
}
