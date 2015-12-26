quest
	TWCIdol1
		name   = "Pixie Wisdom \[Weekly]"
		desc   = "An extremely sassy pixie asked you for your help collecting ingredients for a birthday party."
		reward = /questReward/PVP2
		repeat = 6048000

		Kill
			desc = "The ingredients list includes demonic essence, pixie parts and what appears to be... Human parts?"
			reqs = list("Demonic Essence"         = 15,
						"Kill Player"             = 100,
			            "Kill Pixie"              = 200,
			            "Kill Bubbles the Spider" = 1)

		Reward
			desc = "Go back to the Sassy Pixie to get your reward."
			reqs = list("Sassy Pixie" = 1)

	PeaceWeekly
		name   = "Royal Blood \[Weekly]"
		desc   = "A woman with very pale skin and red eyes named Austra asked you to help her murder an old creature."
		reward = /questReward/BloodCoin
		repeat = 6048000

		Gather
			desc = "Gather 50 blood sacks from acromantulas. You also feel the need to violently attack vengeful ghosts for some odd unexplained reason."
			reqs = list("Blood Sack"          = 50,
			            "Kill Vengeful Ghost" = 50)

		Reward
			desc = "Go back to the Austra."
			reqs = list("Austra" = 1)

	TutorialWand
		name   = "Tutorial: The Wand Maker"
		desc   = "You arrived at Diagon Alley, as a young wizard your first objective is to find a wand to cast spells with."
		reward = /questReward/TutorialWand

		Reward
			desc = "You heard a rumour there's a powerful wand maker around here somewhere, find him and buy a powerful wand to begin your magical adventure."
			reqs = list("Ollivander" = 1)

	TutorialPalmer
		name   = "Tutorial: Friendly Professor"
		desc   = "Ollivander told you about a friendly professor named palmer who will help you out."
		reward = /questReward/TutorialPalmer

		Reward
			desc = "Palmer is a professor he's probably at the castle."
			reqs = list("Professor Palmer" = 1)

	TutorialQuests
		name   = "Tutorial: Quests"
		desc   = "Palmer sent you to meet a bunch of new people, fun!"
		reward = /questReward/TutorialQuests

		Hunter
			desc = "The first person is apparently a monster hunter named Hunter. How very original."
			reqs = list("Hunter" = 1)
		Tom
			desc = "The second person is a bar owner, why would a respected professor send you to a bar, that's so very odd."
			reqs = list("Tom" = 1)
		Reward
			desc = "Go back to Palmer and make him give you a reward, quests are not fun without a reward!"
			reqs = list("Professor Palmer" = 1)


	Ritual
		name   = "Demonic Ritual"
		desc   = "Tammie told you about a ritual capable of increasing your power."
		reward = /questReward/Ritual

		Essence
			desc = "Find demonic essences for the ritual."
			reqs = list("Demonic Essence" = 5)
		TrollingEssence
			desc = "It appears one of the essences you've collected disappeared, find another."
			reqs = list("Demonic Essence" = 1)
		Reward
			desc = "Go back to Tammie for your reward!"
			reqs = list("Tammie" = 1)

	Easter
		name   = "Sweet Easter"
		desc   = "The easter bunny wants you to help him find a new brand of chocolate he made but seem to have lost."
		reward = /questReward/Easter

		GetChocolate
			desc = "Find the chocolate, you heard a rumour a guy named Zonko has it."
			reqs = list("Zonko" = 1)
		Reward
			desc = "Go back to the Easter Bunny to get your reward!"
			reqs = list("Easter Bunny" = 1)

	PVP1
		name   = "PvP Introduction"
		desc   = "Zerf wants you to fight a few players... He probably just wants you to get dirt on your face so you look less shiny."
		reward = /questReward/PVP1

		Kill
			desc = "Kill 20 players."
			reqs = list("Kill Player" = 20)
		Reward
			desc = "Go back to Zerf to get your reward!"
			reqs = list("Zerf" = 1)

	PVP2
		name   = "Culling the Herd"
		desc   = "Zerf wants you to fight a massive amount of players... I wonder what he gets out of it."
		reward = /questReward/PVP2

		Kill
			desc = "Kill 1000 players."
			reqs = list("Kill Player" = 1000)
		Reward
			desc = "Go back to the Zerf to get your reward!"
			reqs = list("Zerf" = 1)

	PVP3
		name   = "Strength of Dragons"
		desc   = "Zerf will reward you greatly (unlike last time... you hope) if you manage to show him how powerful you've become."
		reward = /questReward/PVP3

		Players
			desc = "Time to show some strength, let's kill stuff!"
			reqs = list("Kill Player"            = 1000,
			            "Kill Floating Eye"      = 200,
			            "Kill Wisp"              = 200)

		FakeReward1
			desc = "Go back to the Zerf to get your reward!"
			reqs = list("Zerf" = 1)

		Boss
			desc = "Zerf told you to kill more, how about you try boss monsters?"
			reqs = list("Kill Basilisk"           = 1,
			            "Kill Stickman"           = 1,
			            "Kill Eye of The Fallen"  = 1,
			            "Kill Tamed Dog"          = 1,
			            "Kill Willy the Whisp"    = 1,
			            "Kill The Evil Snowman"   = 1,
			            "Kill Bubbles the Spider" = 1)

		FakeReward2
			desc = "Go back to the Zerf to get your reward!"
			reqs = list("Zerf" = 1)

		Boost
			desc = "You decided Zerf is cray cray, it would be easier to fool him by making yourself smell like a demon."
			reqs = list("Kill Demon Rat"  = 50,
			            "Demonic Essence" = 5)

		Reward
			desc = "Go back to the Zerf and fool him to get your reward!"
			reqs = list("Zerf" = 1)

	Extermination
		name   = "Pest Extermination \[Daily]"
		desc   = "The hunter wants you to help him exterminate monsters."
		reward = /questReward/Artifact
		repeat = 864000

		Kill
			desc = "Kill 50 of each monster."
			reqs = list("Kill Rat"             = 50,
			            "Kill Pixie"           = 50,
			            "Kill Dog"             = 50,
			            "Kill Snake"           = 50,
			            "Kill Wolf"            = 50,
			            "Kill Troll"           = 50,
			            "Kill Archangel"       = 50,
			            "Kill Water Elemental" = 50,
			            "Kill Fire Elemental"  = 50,
			            "Kill Wyvern"          = 50)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)

	Basilisk
		name   = "To kill a Boss \[Daily]"
		desc   = "The basilisk is found at the Chamber of Secrets, kill the Basilisk and any demon rat that gets in your way!"
		reward = /questReward/Artifact
		repeat = 864000

		Kill
			desc = "Kill 1 basilisk and 50 demon rats."
			reqs = list("Kill Basilisk"        = 1,
			            "Kill Demon Rat"       = 50)
		Reward
			desc = "Go back to Saratri to get your reward!"
			reqs = list("Saratri" = 1)

	Stickman
		name   = "Draw Me a Stick \[Daily]"
		desc   = "The stickman is found at the Chamber of Secrets floor 2, kill the Stickman and any Troll that gets in your way!"
		reward = /questReward/Teleport
		repeat = 864000

		Kill
			desc = "Kill 1 stickman and 50 trolls."
			reqs = list("Kill Stickman"        = 1,
			            "Kill Troll"       = 50)
		Reward
			desc = "Go back to Malcolm to get your reward!"
			reqs = list("Malcolm" = 1)


	Eyes
		name   = "The Eyes in the Sand \[Daily]"
		desc   = "The desert is a mysterious area filled with strange creatures called floating eyes, I wonder if they bleed..."
		reward = /questReward/Artifact
		repeat = 864000

		Kill
			desc = "Kill 60 floating eyes."
			reqs = list("Kill Floating Eye" = 60)
		Reward
			desc = "Go back to the Mysterious Wizard to get your reward!"
			reqs = list("Mysterious Wizard" = 1)

	Wisps
		name   = "Will of the Wisp \[Daily]"
		desc   = "The vengeful wisp wants you to execute revenge, you must kill wisps!"
		reward = /questReward/Artifact
		repeat = 864000

		Kill
			desc = "Kill 80 wisps."
			reqs = list("Kill Wisp" = 80)
		Reward
			desc = "Go back to the Vengeful Wisp to get your reward!"
			reqs = list("Vengeful Wisp" = 1)

	Rats
		name   = "Pest Extermination: Rat"
		desc   = "The hunter wants you to help him exterminate rats from the forest"
		reward = /questReward/Mon1

		Kill
			desc = "Kill 50 rats."
			reqs = list("Kill Rat" = 50)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	DemonRats
		name   = "Pest Extermination: Demon Rat"
		desc   = "The hunter wants you to help him exterminate demon rats from the Chamber of Secrets"
		reward = /questReward/Mon2

		Kill
			desc = "Kill 100 demon rats."
			reqs = list("Kill Demon Rat" = 100)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Pixie
		name   = "Pest Extermination: Pixie"
		desc   = "The hunter wants you to help him exterminate pixies from the pixie pit"
		reward = /questReward/Mon3

		Kill
			desc = "Kill 150 pixies."
			reqs = list("Kill Pixie" = 150)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Dog
		name   = "Pest Extermination: Dog"
		desc   = "The hunter wants you to help him exterminate dogs from the forest"
		reward = /questReward/Mon4

		Kill
			desc = "Kill 200 dogs."
			reqs = list("Kill Dog" = 200)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Snake
		name   = "Pest Extermination: Snake"
		desc   = "The hunter wants you to help him exterminate snakes from the graveyard"
		reward = /questReward/Mon5

		Kill
			desc = "Kill 250 snakes."
			reqs = list("Kill Snake" = 250)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Wolf
		name   = "Pest Extermination: Wolf"
		desc   = "The hunter wants you to help him exterminate wolves from the forest"
		reward = /questReward/Mon6

		Kill
			desc = "Kill 300 wolves."
			reqs = list("Kill Wolf" = 300)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Troll
		name   = "Pest Extermination: Troll"
		desc   = "The hunter wants you to help him exterminate trolls from the forest"
		reward = /questReward/Mon7

		Kill
			desc = "Kill 50 trolls."
			reqs = list("Kill Troll" = 50)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	FireBats
		name   = "Pest Extermination: Fire Bat"
		desc   = "The hunter wants you to help him exterminate fire bats from Silverblood Grounds"
		reward = /questReward/Mon8

		Kill
			desc = "Kill 300 fire bats."
			reqs = list("Kill Fire Bat" = 300)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	FireGolem
		name   = "Pest Extermination: Fire Golem"
		desc   = "The hunter wants you to help him exterminate fire golems from Silverblood Grounds"
		reward = /questReward/Mon9

		Kill
			desc = "Kill 350 fire golems."
			reqs = list("Kill Fire Golem" = 350)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Archangel
		name   = "Pest Extermination: Archangel"
		desc   = "The hunter wants you to help him exterminate Archangel from Silverblood Castle"
		reward = /questReward/Mon10

		Kill
			desc = "Kill 400 archangels."
			reqs = list("Kill Archangel" = 400)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	WaterElemental
		name   = "Pest Extermination: Water Elemental"
		desc   = "The hunter wants you to help him exterminate water elementals from Silverblood Castle"
		reward = /questReward/Mon11

		Kill
			desc = "Kill 400 water elementals."
			reqs = list("Kill Water Elemental" = 400)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	FireElemental
		name   = "Pest Extermination: Fire Elemental"
		desc   = "The hunter wants you to help him exterminate fire elementals from Silverblood Castle"
		reward = /questReward/Mon12

		Kill
			desc = "Kill 400 fire elementals."
			reqs = list("Kill Fire Elemental" = 400)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Wyvern
		name   = "Pest Extermination: Wyvern"
		desc   = "The hunter wants you to help him exterminate wyverns from Silverblood Castle"
		reward = /questReward/Mon13

		Kill
			desc = "Kill 400 wyverns."
			reqs = list("Kill Wyvern" = 400)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)


	Tom
		name   = "Rats in the Cellar"
		reward = /questReward/Gold

		Clear
			desc = "Tom wants you to clear his cellar of rats, kill 35 rats and pull the lever at the end of the cellar."
			reqs = list("Lever" = 1, "Kill Rat" = 35)
		Reward
			desc = "Go back to Tom to get your reward!"
			reqs = list("Tom" = 1)

	Lord
		name = "Stolen by the Lord"
		reward = /questReward/Gold

		FindLord
			desc = "Girl wants you to find and rescue her baby from Lord, you heard a rumour he's at a place called Silverblood, maybe you can get there from the forest."
			reqs = list("Lord" = 1)
		Reward
			desc = "Return the baby back to Girl and get your reward!"
			reqs = list("Girl" = 1)

	Alyssa
		name = "Make a Potion"
		reward = /questReward/RoyaleShoes

		FindHerbs
			desc = "Alyssa wants you to help her procure an immortality potions, go find Onion Root, Indigo Seeds, Silver Spider Legs and Salamander Drop."
			reqs = list("Onion Root" = 1, "Indigo Seeds" = 1, "Silver Spider Legs" = 1, "Salamander Drop" = 1)
		Reward
			desc = "You have all the ingredients, go back to Alyssa for your reward."
			reqs = list("Alyssa" = 1)


	MakeAFortune
		name = "Make a Fortune"
		reward = /questReward/RoyaleScarf

		Kill
			desc = "Cassandra wants you to help her procure a peice of the rarest monsters in the land, of course that requires you to kill some nasty beasts."
			reqs = list("Kill Wyvern"           = 50,
			            "Kill Floating Eye"     = 50,
			            "Kill Wisp"             = 50,
			            "Kill Basilisk"         = 1,
			            "Kill Willy the Whisp"  = 1,
			            "Kill The Evil Snowman" = 1,
			            "Kill Tamed Dog"        = 1,
			            "Kill Player"           = 30)
		Reward
			desc = "You have all the monster essences, go back to Cassandra for your reward."
			reqs = list("Cassandra" = 1)

	MakeASpell
		name = "Make a Spell"
		reward = /questReward/RoyaleWand

		Kill
			desc = "Cassandra wants you to help her procure a new spell capable of changing the laws of magic."
			reqs = list("Demonic Essence"        = 5,
						"Kill Demon Rat"         = 50,
			            "Kill Floating Eye"      = 200,
			            "Kill Wisp"              = 50,
			            "Kill Basilisk"          = 1,
			            "Kill Stickman"          = 1,
			            "Kill Eye of The Fallen" = 1,
			            "Kill Tamed Dog"         = 1,
			            "Kill Player"            = 60)
		Reward
			desc = "You have all the monster essences, go back to Cassandra for your reward."
			reqs = list("Cassandra" = 1)

	MakeAWig
		name = "Make a Wig"
		reward = /questReward/RoyaleWig

		Kill
			desc = "Cassandra wishes to create a beautiful wig to distract everyone from her hideous face... and personality."
			reqs = list("Kill Troll" 			 = 69,
						"Kill Wyvern"            = 300,
						"Demonic Essence"        = 40,
						"Kill Demon Rat"         = 400,
			            "Kill Floating Eye"      = 300,
			            "Kill Wisp"              = 200,
			            "Kill Player"            = 100,
			            "Kill Basilisk"          = 3,
			            "Kill Stickman"          = 2,
			            "Kill Eye of The Fallen" = 1,
			            "Kill Tamed Dog"         = 10,
			            "Onion Root"             = 1,
			            "Indigo Seeds"           = 1,
			            "Silver Spider Legs"     = 1)
		Reward
			desc = "You collected everything you required, go back to Cassandra for your reward."
			reqs = list("Cassandra" = 1)

	Fred
		name = "On House Arrest"
		reward = /questReward/Gold

		GetWand
			desc = "Fred wants you to go withdraw a special wand from his vault at Gringotts, one of the bank goblins will help you."
			reqs = list("Fred's Wand" = 1)
		Reward
			desc = "Use the wand to free Fred."
			reqs = list("Fred" = 1)

	MasterofKeys
		name   = "Master of Keys"
		desc   = "Professor Palmer offered you help opening a legendary golden chest."
		reward = /questReward/Masterkey

		Key
			desc = "It'll be a bit of a grind but everything worthawhile takes work, go fight some of the most worthy monsters."
			reqs = list("Kill Wisp"               = 200,
			            "Kill Floating Eye"       = 100,
			            "Kill Player"             = 50,
			            "Kill Basilisk"           = 3,
			            "Kill Stickman"           = 2,
			            "Kill Eye of The Fallen"  = 1,
			            "Kill Tamed Dog"          = 5,
			            "Kill The Evil Snowman"   = 10,
			            "Kill Willy the Whisp"    = 5,
			            "Kill Bubbles the Spider" = 2)

		Reward
			desc = "Go back to Palmer."
			reqs = list("Professor Palmer" = 1)

questReward

	Gold
		exp  = 1000
		gold = 10000
	Mon1
		gold = 1000
		exp  = 10000
	Mon2
		gold = 2000
		exp  = 20000
		items = /obj/items/lamps/double_exp_lamp
	Mon3
		gold = 3000
		exp  = 30000
	Mon4
		gold  = 4000
		exp   = 40000
		items = list(/obj/items/wearable/title/Hunter,
				     /obj/items/lamps/triple_exp_lamp)
	Mon5
		gold = 5000
		exp  = 50000
	Mon6
		gold = 6000
		exp  = 60000
		items = /obj/items/lamps/triple_exp_lamp
	Mon7
		gold = 7000
		exp  = 70000
	Mon8
		gold = 8000
		exp  = 80000
		items = /obj/items/lamps/quadaple_exp_lamp
	Mon9
		gold  = 9000
		exp   = 90000
		items = list(/obj/items/wearable/title/Pest,
					 /obj/items/lamps/penta_exp_lamp)
	Mon10
		gold = 10000
		exp  = 100000
	Mon11
		gold = 11000
		exp  = 110000
		items = /obj/items/lamps/quadaple_exp_lamp
	Mon12
		gold = 12000
		exp  = 120000
		items = /obj/items/lamps/triple_exp_lamp
	Mon13
		gold  = 13000
		exp   = 130000
		items = list(/obj/items/wearable/title/Exterminator,
					 /obj/items/lamps/sextuple_exp_lamp)
	Artifact
		gold  = 14000
		exp   = 140000
		items = /obj/items/artifact
	Teleport
		gold  = 16000
		exp   = 160000
		items = list(/obj/items/magic_stone/teleport,
					 /obj/items/magic_stone/teleport,
		             /obj/items/magic_stone/teleport)
	RoyaleShoes
		gold  = 5000
		exp   = 10000
		items = /obj/items/wearable/shoes/royale_shoes
	RoyaleScarf
		gold  = 24000
		items = /obj/items/wearable/scarves/royale_scarf
	RoyaleWand
		gold  = 32000
		items = /obj/items/wearable/wands/royale_wand
	RoyaleWig
		get(mob/Player/p)
			var/t = p.Gender == "Male" ? /obj/items/wearable/wigs/male_royale_wig : /obj/items/wearable/wigs/female_royale_wig
			var/obj/o = new t (p)
			p << infomsg("You receive [o.name].")
			p.Resort_Stacking_Inv()
	PVP1
		gold  = 15000
		exp   = 15000
		items = list(/obj/items/bagofgoodies,
			         /obj/items/wearable/wands/salamander_wand)
	PVP2
		gold  = 60000
		exp   = 60000
		items = list(/obj/items/bagofgoodies,
			         /obj/items/artifact,
			         /obj/items/artifact,
			         /obj/items/artifact,
			         /obj/items/magic_stone/teleport,
			         /obj/items/magic_stone/teleport,
			         /obj/items/magic_stone/teleport)

	PVP3
		gold  = 1337
		items = /obj/items/wearable/wands/dragonhorn_wand

	Ritual
		gold  = 3000
		exp   = 30000
		items = list(/obj/items/bagofgoodies,
					 /obj/items/lamps/penta_exp_lamp)
	Easter
		exp   = 10000
		items = /obj/items/wearable/wands/maple_wand

	TutorialWand
		exp   = 10
		gold  = 50
	TutorialPalmer
		exp   = 25
		gold  = 100
	TutorialQuests
		exp   = 50
		gold  = 150

	Masterkey
		exp   = 32000
		gold  = 3200
		items = /obj/items/key/master_key

	BloodCoin
		exp   = 32000
		gold  = 3200
		items = /obj/items/magic_stone/summoning/blood