quest
	Cloud
		name   = "Happy Little Cloud"
		desc   = "Bob wants you to kill some fluffy clouds."
		reward = /questReward/TrainingDummy1

		Kill
			desc = "Kill Clouds."
			reqs = list("Kill Cloud" = 900)

		Reward
			desc = "Go back to Bob."
			reqs = list("Bob" = 1)
	RoR
		name   = "In my time of Requirement"
		desc   = "Bob wants you to find room of requirement for him, he seems like an upstanding guy."
		reward = /questReward/RoR

		FindRor
			desc = "Find Room of Requirement."
			reqs = list("Go to Room of Requirement" = 1)

		Reward
			desc = "Go back to Bob."
			reqs = list("Bob" = 1)
	TrainingDummy1
		name   = "Battle Training I"
		desc   = "This training dummy is itching for a fight, attack it!"
		reward = /questReward/TrainingDummy1

		Reward
			desc = "Fight Training Dummy Mk-I."
			reqs = list("Kill Dummy Mk-I" = 3)
	FaultyTrainingDummy
		name   = "Faulty Training Dummies"
		desc   = "Destroy the faulty training dummies!"
		reward = /questReward/TrainingDummy1

		Reward
			desc = "Fight faulty training dummies."
			reqs = list("Kill Training Dummy" = 500)
	TrainingDummy2
		name   = "Battle Training II"
		desc   = "This training dummy is itching for a fight, attack it!"
		reward = /questReward/TrainingDummy2

		Reward
			desc = "Fight Training Dummy Mk-II."
			reqs = list("Kill Dummy Mk-II" = 3)
	TrainingDummy3
		name   = "Battle Training III"
		desc   = "This training dummy is itching for a fight, attack it!"
		reward = /questReward/TrainingDummy3

		Reward
			desc = "Fight Training Dummy Mk-III."
			reqs = list("Kill Dummy Mk-III" = 3)
	TrainingDummy4
		name   = "Battle Training IV"
		desc   = "This training dummy is itching for a fight, attack it!"
		reward = /questReward/TrainingDummy4

		Reward
			desc = "Fight Training Dummy Mk-IV."
			reqs = list("Kill Dummy Mk-IV" = 3)
	TrainingDummy5
		name   = "Battle Training V"
		desc   = "This training dummy is itching for a fight, attack it!"
		reward = /questReward/TrainingDummy5

		Reward
			desc = "Fight Training Dummy Mk-V."
			reqs = list("Kill Dummy Mk-V" = 3)
	TrainingDummy
		name   = "Battle Training \[Daily]"
		desc   = "This training dummy is itching for a fight, attack it!"
		reward = /questReward/TrainingDummy
		repeat = 864000

		Reward
			desc = "Fight Training Dummy Mk-V."
			reqs = list("Kill Dummy Mk-V" = 1)


	Puzzle1
		name = "Light a Way"
		desc = "You found a secret door, find out where it leads."
		reward = /questReward/CatBook

		Room1
			desc = "This room is dark, are there no torches here?"
			reqs = list("Get to the next room" = 1)

		Room2
			desc = "There must be something cool hidden behind that door."
			reqs = list("Get to the final room" = 1)

		Reward
			desc = "A book, I wonder if it contains any spells I could learn."
			reqs = list("Approach the book" = 1)

	Puzzle2
		name = "Inferi"
		desc = "You walked through the fireplace, it teleported you here, where does this lead?"
		reward = /questReward/InferiBook

		Room1
			desc = "Those torches seem odd."
			reqs = list("Unlock the two gates" = 1)

		Room2
			desc = "I can see my own reflection in the water."
			reqs = list("Get to the other side" = 1)

		Room3
			desc = "A hallway, this seems too easy"
			reqs = list("Get to the final room" = 1)

		Reward
			desc = "A book, I wonder if it contains any spells I could learn."
			reqs = list("Approach the book" = 1)

	Puzzle3
		name = "Top of The World"
		desc = "You walked through the tunnel, it led you here, it's a bit dusty but maybe you can find something useful."
		reward = /questReward/Levitate

		Room1
			desc = "A locked gate, perhaps there's a way to open it."
			reqs = list("Unlock the gate" = 1)

		Room2
			desc = "Looks like a storage area, get to the other side."
			reqs = list("Get to the other side" = 1)

		Reward
			desc = "A book, you seem to understand it only if you hold it, copy the book."
			reqs = list("Copy the book" = 1)

	Animagus
		name = "Amato Animo Animato Animagus"
		desc = "You decided to start animagus training and placed a leaf of a mandrake in your mouth."
		reward = /questReward/Animagus

		Potion
			desc = "You also need to make animagus potion."
			reqs = list("Kill Elites" = 5,
						"Kill Dog"    = 50,
			            "Kill Snake"  = 50,
			            "Kill Wolf"   = 50,
			            "Demonic Essence" = 3)

		Reward
			desc = "You gathered the ingredients. Go to the animagus chamber."
			reqs = list("Go to Animagus Chamber" = 1)

	Elites
		name   = "The Elite \[Repeatable]"
		desc   = "Todd spoke about elite monsters that are harder to kill but are also more rewarding."
		reward = /questReward/Slayer
		repeat = 1

		Kill
			desc = "Impress Todd by killing elite monsters."
			reqs = list("Kill Elites" = 40)

		Reward
			desc = "Go back to Todd One Eye."
			reqs = list("Todd One Eye" = 1)

	Blueprint1
		name   = "Blue Books: Vol I"
		desc   = "Blotts found a basic blueprint you can use at student housing to construct wooden structures."
		reward = /questReward/Blueprint1

		Wood
			desc = "Blotts wants you to gather some wood, try shooting trees found in student housing (west of the castle)."
			reqs = list("Chop Tree" = 10)

		Reward
			desc = "Go back to Blotts."
			reqs = list("Blotts" = 1)

	Blueprint2
		name   = "Blue Books: Vol II"
		desc   = "Blotts found a house blueprint you can use at student housing to construct hogwarts house related structures."
		reward = /questReward/Blueprint2

		Monsters
			desc = "Blotts wants you to slay some monsters and gather some wood, like a proper Hogwarts student."
			reqs = list("Kill Dog"             = 50,
			            "Kill Snake"           = 50,
			            "Kill Wolf"            = 50,
			            "Kill Pixie"           = 50,
			            "Chop Tree"            = 20)

		Reward
			desc = "Go back to Blotts."
			reqs = list("Blotts" = 1)

	Blueprint3
		name   = "Blue Books: Vol III"
		desc   = "Blotts offered to sell you books."
		reward = /questReward/Blueprint3

		Monsters
			desc = "Blotts wants you to help out Tom clear his basement of rats."
			reqs = list("Kill Rat"             = 200)

		Reward
			desc = "Go back to Blotts."
			reqs = list("Blotts" = 1)

	Blueprint4
		name   = "Blue Books: Vol IV"
		desc   = "Blotts offered to sell you books."
		reward = /questReward/Blueprint4

		Rock
			desc = "Blotts found a new blueprint involving rocks, go smash some."
			reqs = list("Smash Rock" = 10)

		Reward
			desc = "Go back to Blotts."
			reqs = list("Blotts" = 1)

	Blueprint5
		name   = "Blue Books: Vol V"
		desc   = "Blotts heard green men have a blueprint you could use."
		reward = /questReward/Blueprint5

		GreenMen
			desc = "Blotts sent you to receive a new blueprint from the green men."
			reqs = list("Green Men" = 1)

		Reward
			desc = "You can't read those papers, you should go back to Blotts to have them translated."
			reqs = list("Blotts" = 1)
	Cloak1
		name   = "Cloak of Invisibility"
		desc   = "Divo can make you an invisibility cloak knock offs using creatures skins and furrs."
		reward = /questReward/Cloak

		Kill
			desc = "Time to harvest some creatures!"
			reqs = list("Kill Dog"             = 50,
			            "Kill Snake"           = 50,
			            "Kill Wolf"            = 50,
			            "Demonic Essence"      = 3)

		Reward
			desc = "Go back to Divo."
			reqs = list("Divo" = 1)

	Cloak2
		name   = "Cloak of Visibility"
		desc   = "Divo can restore your invisibility cloak."
		reward = /questReward/Cloak
		repeat = 36000

		Kill
			desc = "Time to kill some demon rats!"
			reqs = list("Demonic Essence" = 3)

		Reward
			desc = "Go back to Divo."
			reqs = list("Divo" = 1)


	EnchantingTutorial
		name   = "Secret of the Crypt"
		desc   = "The crypt has a powerful tool, an enchantment circle. Figure out how it works and enchant anything to prove yourself worthy."
		reward = /questReward/TutorialOther

		Enchant
			desc = "Prove that you can do the enchantment ritual."
			reqs = list("Enchant" = 1)

		Reward
			desc = "Go back to the Vengeful Wisp."
			reqs = list("Vengeful Wisp" = 1)

	PotionTutorial
		name   = "Brother Trouble"
		desc   = "Simon's brother has big lacerations on his legs. Create a health potion to quickly heal him before it's too late."
		reward = /questReward/TutorialOther

		Brew
			desc = "The ingredients list says using rat powder, daisy powder, aconite, and aconite powder to make a regular health potion. Of course, you can do better than that however."
			reqs = list("Brew Potion" = 1)

		Reward
			desc = "Go back to Simon to save his brother!"
			reqs = list("Simon" = 1)

	PotionBook
		name   = "Brewing Practice"
		desc   = "Practice never hurts..."
		reward = /questReward/PotionsBook

		Brew
			desc = "Simon says you need to brew more potions."
			reqs = list("Brew Potion" = 10)

		Reward
			desc = "Go back to Simon."
			reqs = list("Simon" = 1)

	ProjectileBook
		name   = "Pixie Love"
		desc   = "An extremely sassy pixie asked you to kill the other pixies."
		reward = /questReward/ProjectileBook

		Kill
			desc = "Kill them all"
			reqs = list("Kill Pixie" = 200)

		Reward
			desc = "Go back to the Sassy Pixie to get your reward."
			reqs = list("Sassy Pixie" = 1)

	TWCIdol1
		name   = "Pixie Wisdom \[Weekly]"
		desc   = "An extremely sassy pixie asked you for your help collecting ingredients for a birthday party."
		reward = /questReward/PVP2
		repeat = 6048000

		Kill
			desc = "The ingredients list includes demonic essence, pixie parts and what appears to be... Human parts?"
			reqs = list("Demonic Essence"         = 10,
						"Kill Player"             = 10,
			            "Kill Pixie"              = 200,
			            "Kill Bubbles the Spider" = 1)

		Reward
			desc = "Go back to the Sassy Pixie to get your reward."
			reqs = list("Sassy Pixie" = 1)

	PeaceWeekly
		name   = "Royal Blood \[Weekly]"
		desc   = "A woman with very pale skin and red eyes named Austra asked you to help her murder an old creature."
		reward = /questReward/clanReward/BloodCoin
		repeat = 6048000

		Gather
			desc = "Gather 50 blood sacks from acromantulas. You also feel the need to violently attack vengeful ghosts for some odd unexplained reason."
			reqs = list("Blood Sack"          = 40,
			            "Kill Vengeful Ghost" = 50)

		Reward
			desc = "Go back to the Austra."
			reqs = list("Austra" = 1)

	PeaceDaily
		name   = "Preserve Peace \[Daily]"
		desc   = "A stranger with pale skin asked you to kill other strangers with pale skin who supposedly spread chaos. One must fight fire with fire."
		reward = /questReward/clanReward/peace
		repeat = 864000

		Kill
			desc = "Kill chaos vampires and their pets."
			reqs = list("Kill Chaos Vampire" = 50,
			            "Kill Acromantula"   = 30)

		Reward
			desc = "Go back to the stranger with the weird skin."
			reqs = list("Peace Vampire" = 1)

	ChaosDaily
		name   = "Spread Chaos \[Daily]"
		desc   = "A stranger with pale skin asked you to kill other strangers with pale skin supposedly for the fun of it. Why not kill everyone while you're at it."
		reward = /questReward/clanReward/chaos
		repeat = 864000

		Kill
			desc = "Spread chaos."
			reqs = list("Kill Peace Vampire" = 50,
			            "Kill Acromantula"   = 30)

		Reward
			desc = "Go back to the stranger with the weird skin."
			reqs = list("Chaos Vampire" = 1)


	PeaceRankUp
		name   = "Preserve Peace \[Rank Up]"
		desc   = "A stranger with pale skin asked you to kill other strangers with pale skin who supposedly spread chaos. One must fight fire with fire."
		reward = /questReward/clanReward/peaceRankUp
		repeat = 36000

		Kill
			desc = "Kill chaos vampires and their pets."
			reqs = list("Kill Chaos Vampire" = 50,
			            "Kill Acromantula"   = 25,
			            "Blood Sack"         = 5,
			            "Demonic Essence"    = 1)

		Reward
			desc = "Go back to the stranger with the weird skin."
			reqs = list("Peace Vampire Lord" = 1)

	ChaosRankUp
		name   = "Spread Chaos \[Rank Up]"
		desc   = "A stranger with pale skin asked you to kill other strangers with pale skin supposedly for the fun of it. Why not kill some spiders while you're at it."
		reward = /questReward/clanReward/chaosRankUp
		repeat = 36000

		Kill
			desc = "Spread chaos."
			reqs = list("Kill Peace Vampire" = 50,
			            "Kill Acromantula"   = 25,
			            "Blood Sack"         = 5,
			            "Demonic Essence"    = 1)

		Reward
			desc = "Go back to the stranger with the weird skin."
			reqs = list("Chaos Vampire Lord" = 1)


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

	Crushed
		name   = "Crushed"
		desc   = "Jake asked for your help."
		reward = /questReward/Mon3

		Sarah
			desc = "Jake wants you to deliver a letter to Sarah."
			reqs = list("Sarah" = 1)
		Reward
			desc = "Break Jake's heart for a girl like you're a text message."
			reqs = list("Jake" = 1)

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

	Halloween1
		name   = "Pumpkin Harvest"
		desc   = "Bob the Zombie wants you to clear out the pumpkins that have invaded his crypt."
		reward = /questReward/Mon10

		Kill
			desc = "Kill all the pumpkins."
			reqs = list("Kill Pumpkin" = 500)
		Reward
			desc = "Go back to Bob."
			reqs = list("Bob the Zombie" = 1)

	Halloween2
		name   = "Breath of Life"
		desc   = "Bob the Zombie wants you to help him gather ingredients that will help him appear more human-like."
		reward = /questReward/Artifact

		Kill
			desc = "Harvest some pumpkins, demonic essence and other ingredients."
			reqs = list("Kill Pumpkin"         = 200,
			            "Demonic Essence"      = 5,
			            "Blood Sack"           = 10,
			            "Kill Snake"           = 100,
			            "Kill Water Elemental" = 100,
			            "Kill Troll"           = 50)
		Reward
			desc = "Go back to Bob."
			reqs = list("Bob the Zombie" = 1)

	Halloween3
		name   = "Breath of Death \[Daily]"
		desc   = "Bob the Zombie offered you a fragment of the stone that resurrected him for one last favour."
		reward = /questReward/Halloween
		repeat = 864000

		Kill
			desc = "Bob desires to be the only undead, kill the other zombies."
			reqs = list("Kill Zombie"  = 2,
			            "Kill Pumpkin" = 200)
		Reward
			desc = "Go back to Bob."
			reqs = list("Bob the Zombie" = 1)

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
			reqs = list("Kill Player"            = 500,
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


	ExtremeExtermination
		name   = "Extreme Pest Extermination"
		desc   = "The hunter wants you to help him exterminate even more monsters."
		reward = /questReward/Monster
		repeat = 864000

		Kill
			desc = "Exterminate!"
			reqs = list("Kill Rat"             = 100,
			            "Kill Pixie"           = 100,
			            "Kill Dog"             = 100,
			            "Kill Snake"           = 100,
			            "Kill Wolf"            = 100,
			            "Kill Troll"           = 50,
			            "Kill Archangel"       = 50,
			            "Kill Water Elemental" = 50,
			            "Kill Fire Elemental"  = 50,
			            "Kill Wyvern"          = 50,
			            "Kill Acromantula"     = 50)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)

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
		reward = /questReward/Boss
		repeat = 864000

		Kill
			desc = "Kill 1 basilisk and 10 demon rats."
			reqs = list("Kill Basilisk"        = 1,
			            "Kill Demon Rat"       = 10)
		Reward
			desc = "Go back to Saratri to get your reward!"
			reqs = list("Saratri" = 1)

	Stickman
		name   = "Draw Me a Stick \[Daily]"
		desc   = "The stickman is found at the Chamber of Secrets floor 2, kill the Stickman and any Troll that gets in your way!"
		reward = /questReward/Boss
		repeat = 864000

		Kill
			desc = "Kill 1 stickman and 10 trolls."
			reqs = list("Kill Stickman"    = 1,
			            "Kill Troll"       = 10)
		Reward
			desc = "Go back to Malcolm to get your reward!"
			reqs = list("Malcolm" = 1)


	Eyes
		name   = "The Eyes in the Sand \[Daily]"
		desc   = "The desert is a mysterious area filled with strange creatures called floating eyes, I wonder if they bleed..."
		reward = /questReward/Artifact
		repeat = 864000

		Kill
			desc = "Kill 50 floating eyes."
			reqs = list("Kill Floating Eye" = 50)
		Reward
			desc = "Go back to the Mysterious Wizard to get your reward!"
			reqs = list("Mysterious Wizard" = 1)

	Wisps
		name   = "Will of the Wisp \[Daily]"
		desc   = "The vengeful wisp wants you to execute revenge, you must kill wisps!"
		reward = /questReward/Artifact
		repeat = 864000

		Kill
			desc = "Kill 50 wisps."
			reqs = list("Kill Wisp" = 50)
		Reward
			desc = "Go back to the Vengeful Wisp to get your reward!"
			reqs = list("Vengeful Wisp" = 1)

	Rats
		name   = "Pest Extermination: Rat"
		desc   = "The hunter wants you to help him exterminate rats from the forest"
		reward = /questReward/Mon1

		Kill
			desc = "Kill 100 rats."
			reqs = list("Kill Rat" = 100)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	CommonPests
		name   = "Pest Extermination: Common Pests"
		desc   = "The hunter wants you to help him exterminate common pests. Using Episkey to heal will increase your chances of survival in battle!"
		reward = /questReward/Mon2

		Kill
			desc = "Kill 150 rats and 100 pixies."
			reqs = list("Kill Rat"   = 150,
						"Kill Pixie" = 100)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Pixie
		name   = "Pest Extermination: Pixie"
		desc   = "The hunter wants you to help him exterminate pixies from the pixie pit"
		reward = /questReward/Mon3

		Kill
			desc = "Kill 200 pixies."
			reqs = list("Kill Pixie" = 200)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Dog
		name   = "Pest Extermination: Dog"
		desc   = "The hunter wants you to help him exterminate dogs from the forest"
		reward = /questReward/Mon4

		Kill
			desc = "Kill 300 dogs."
			reqs = list("Kill Dog" = 300)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Snake
		name   = "Pest Extermination: Snake"
		desc   = "The hunter wants you to help him exterminate snakes from the graveyard"
		reward = /questReward/Mon5

		Kill
			desc = "Kill 400 snakes."
			reqs = list("Kill Snake" = 400)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Wolf
		name   = "Pest Extermination: Wolf"
		desc   = "The hunter wants you to help him exterminate wolves from the forest"
		reward = /questReward/Mon6

		Kill
			desc = "Kill 500 wolves."
			reqs = list("Kill Wolf" = 500)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	UncommonPests
		name   = "Pest Extermination: Uncommon Pests"
		desc   = "The hunter wants you to help him exterminate some of the tougher pests"
		reward = /questReward/Mon7

		Kill
			desc = "Kill 300 snakes and 200 wolves."
			reqs = list("Kill Snake" = 200,
						"Kill Wolf"  = 300)
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
			desc = "Kill 300 fire golems."
			reqs = list("Kill Fire Golem" = 300)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Archangel
		name   = "Pest Extermination: Archangel"
		desc   = "The hunter wants you to help him exterminate Archangel from Silverblood Castle"
		reward = /questReward/Mon10

		Kill
			desc = "Kill 500 archangels."
			reqs = list("Kill Archangel" = 500)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	WaterElemental
		name   = "Pest Extermination: Water Elemental"
		desc   = "The hunter wants you to help him exterminate water elementals from Silverblood Castle"
		reward = /questReward/Mon11

		Kill
			desc = "Kill 540 water elementals."
			reqs = list("Kill Water Elemental" = 540)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	FireElemental
		name   = "Pest Extermination: Fire Elemental"
		desc   = "The hunter wants you to help him exterminate fire elementals from Silverblood Castle"
		reward = /questReward/Mon12

		Kill
			desc = "Kill 560 fire elementals."
			reqs = list("Kill Fire Elemental" = 560)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Wyvern
		name   = "Pest Extermination: Wyvern"
		desc   = "The hunter wants you to help him exterminate wyverns from Silverblood Castle"
		reward = /questReward/Mon13

		Kill
			desc = "Kill 600 wyverns."
			reqs = list("Kill Wyvern" = 600)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	DemonRats
		name   = "Pest Extermination: Demon Rat"
		desc   = "The hunter wants you to help him exterminate demon rats from the Chamber of Secrets"
		reward = /questReward/Mon10

		Kill
			desc = "Kill 456 demon rats."
			reqs = list("Kill Demon Rat" = 456)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Troll
		name   = "Pest Extermination: Troll"
		desc   = "The hunter wants you to help him exterminate trolls from the forest"
		reward = /questReward/Mon10

		Kill
			desc = "Kill 69 trolls."
			reqs = list("Kill Troll" = 69)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Acromantulas
		name   = "Pest Extermination: Acromantula"
		desc   = "The hunter wants you to help him exterminate acromantulas from the spider pit"
		reward = /questReward/Mon14

		Kill
			desc = "Kill 333 acromantulas."
			reqs = list("Kill Acromantula" = 333)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)

	Tom
		name   = "Rats in the Cellar"
		reward = /questReward/Mon3

		Clear
			desc = "Tom wants you to clear his cellar of rats, kill 60 rats and pull the lever at the end of the cellar."
			reqs = list("Lever" = 1, "Kill Rat" = 60)
		Reward
			desc = "Go back to Tom to get your reward!"
			reqs = list("Tom" = 1)

	Lord
		name = "Stolen by the Lord"
		reward = /questReward/Mon10

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
		reward = /questReward/Mon5

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
			            "Kill Player"             = 30,
			            "Kill Basilisk"           = 3,
			            "Kill Stickman"           = 2,
			            "Kill Eye of The Fallen"  = 1,
			            "Kill Tamed Dog"          = 5,
			            "Kill The Evil Snowman"   = 3,
			            "Kill Willy the Whisp"    = 3,
			            "Kill Bubbles the Spider" = 3)

		Reward
			desc = "Go back to Palmer."
			reqs = list("Professor Palmer" = 1)

	Gradutate
		name   = "Strength of Graduate \[Weekly]"
		desc   = "Professor Palmer challenged you to show your mastery and strength of magic arts by defeating the strongest monster she could think of."
		reward = /questReward/Masterkey
		repeat = 864000

		Key
			desc = "Defeat a vampire lord."
			reqs = list("Kill Vampire Lord" = 1)

		Grind
			desc = "This won't be fun without a bit of a grind. Did you really think it will end with only one monster?"
			reqs = list("Kill Wisp"               = 100,
			            "Kill Floating Eye"       = 50,
			            "Kill Player"             = 10,
			            "Kill Tamed Dog"          = 3)

		Reward
			desc = "Go back to Palmer."
			reqs = list("Professor Palmer" = 1)

questReward
	RoR
		exp  = 40000
		items = /obj/items/requirement_stone
	TrainingDummy1
		exp  = 120000
		items = /obj/items/lamps/double_exp_lamp
	TrainingDummy2
		exp  = 140000
		items = /obj/items/lamps/triple_exp_lamp
	TrainingDummy3
		exp  = 160000
		items = /obj/items/lamps/quadaple_exp_lamp
	TrainingDummy4
		exp  = 180000
		items = /obj/items/lamps/penta_exp_lamp
	TrainingDummy5
		exp  = 200000
		items = /obj/items/lamps/sextuple_exp_lamp
	TrainingDummy
		exp  = 220000
	Blueprint1
		exp   = 20000
		items = /obj/items/wearable/blueprint/basic_blueprint
	Blueprint2
		exp   = 20000
		items = /obj/items/wearable/blueprint/house_blueprint
	Blueprint3
		exp   = 20000
		items = /obj/items/wearable/blueprint/book_blueprint
	Blueprint4
		exp   = 20000
		items = /obj/items/wearable/blueprint/stone_blueprint
	Blueprint5
		exp   = 5000
		items = /obj/items/wearable/blueprint/utility_blueprint
	ProjectileBook
		gold  = 1000
		exp   = 40000
		items = /obj/items/spellbook/projectile
	CatBook
		exp   = 10000
		items = /obj/items/spellbook/felinious
	InferiBook
		exp   = 40000
		items = /obj/items/spellbook/inferi
	Levitate
		exp   = 20000
		items = /obj/items/wearable/brooms/levitate
	PotionsBook
		gold  = 2000
		exp   = 2000
		items = /obj/items/potions_book
	Monster
		gold  = 16000
		exp   = 200000
	Mon1
		gold = 1000
		exp  = 20000
	Mon2
		gold = 2000
		exp  = 30000
		items = /obj/items/lamps/double_exp_lamp
	Mon3
		gold = 3000
		exp  = 40000
	Mon4
		gold  = 4000
		exp   = 50000
		items = list(/obj/items/wearable/title/Hunter,
				     /obj/items/lamps/triple_exp_lamp)
	Mon5
		gold = 5000
		exp  = 70000
	Mon6
		gold = 6000
		exp  = 80000
		items = /obj/items/lamps/triple_exp_lamp
	Mon7
		gold = 7000
		exp  = 90000
		items = /obj/items/lamps/triple_exp_lamp
	Mon8
		gold = 8000
		exp  = 100000
		items = /obj/items/lamps/quadaple_exp_lamp
	Mon9
		gold  = 9000
		exp   = 110000
		items = list(/obj/items/wearable/title/Pest,
					 /obj/items/lamps/penta_exp_lamp)
	Mon10
		gold = 10000
		exp  = 120000
	Mon11
		gold = 11000
		exp  = 140000
		items = /obj/items/lamps/quadaple_exp_lamp
	Mon12
		gold = 12000
		exp  = 160000
		items = /obj/items/lamps/triple_exp_lamp
	Mon13
		gold  = 13000
		exp   = 180000
		items = list(/obj/items/wearable/title/Exterminator,
					 /obj/items/lamps/sextuple_exp_lamp)
	Mon14
		gold = 14000
		exp  = 200000
		items = list(/obj/items/artifact,
					 /obj/items/artifact,
					 /obj/items/magic_stone/summoning/random)
	Boss
		gold  = 20000
		exp   = 200000
		items = /obj/items/artifact
		items = /obj/items/magic_stone/teleport
	Artifact
		gold  = 14000
		exp   = 140000
		items = /obj/items/artifact
	Teleport
		gold  = 16000
		exp   = 160000
		items = /obj/items/magic_stone/teleport
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
	Halloween
		exp   = 10000
		items = /obj/items/magic_stone/summoning/resurrection

	TutorialWand
		exp   = 1000
		gold  = 500
	TutorialPalmer
		exp   = 2000
		gold  = 1000
	TutorialQuests
		exp   = 4000
		gold  = 2000
	TutorialOther
		exp   = 6000
		gold  = 3000

	Masterkey
		exp   = 32000
		gold  = 3200
		items = /obj/items/key/master_key

	Cloak
		exp   = 84000
		items = /obj/items/wearable/invisibility_cloak
		get(mob/Player/p)
			var/obj/items/wearable/invisibility_cloak/c = locate() in p
			if(c)
				if(c in p.Lwearing)
					c.Equip(p,1,1)
				c.time = world.realtime
			else
				..(p)

	clanReward
		BloodCoin
			exp    = 32000
			gold   = 32000
			points = 60
			items  = /obj/items/magic_stone/summoning/blood


		exp   = 10000
		gold  = 5000

		peace
			points = 50
		chaos
			points = -50

		peaceRankUp
			points = 15
			max    = 0
		chaosRankUp
			points = -15
			max    = 0
	Slayer
		points = 50000
	Animagus
		exp   = 40000
		items = /obj/items/potions/animagus_potion