
var/list/events

proc/init_random_events()
	events = list()
	for(var/e in typesof(/RandomEvent/)-/RandomEvent)
		events += new e
	bubblesort_by_value(events, "chance")
	scheduler.schedule(new/Event/RandomEvents, world.tick_lag * rand(3000, 36000)) // 5 minutes to 1 hour


var/list/spawners = list()

obj/spawner
	invisibility = 10
	New()
		..()
		spawners += src

RandomEvent
	var/chance = 10
	var/name

	proc/start()
		for(var/client/C)
			if(C.mob && C.mob.EventNotifications)winset(C,"mainwindow","flash=2")


	EntranceKillZone
		name = "Entrance Kill Zone"
		start()
			..()
			var/minutes = rand(10,30)
			world << errormsg("<b>Warning:</b> Hogwarts magical defenses are being suppressed by a dark evil magic, Entrance Hall will become a kill zone in 5 minutes for [minutes] minutes!<br>Move to another area (The library, common room, second floor etc) if you wish to remain safe.")
			sleep(600)
			world << errormsg("<b>Warning:</b> Entrance Hall will become a kill zone in 4 minutes!")
			sleep(600)
			world << errormsg("<b>Warning:</b> Entrance Hall will become a kill zone in 3 minutes!")
			sleep(600)
			world << errormsg("<b>Warning:</b> Entrance Hall will become a kill zone in 2 minutes!")
			sleep(600)
			world << errormsg("<b>Warning:</b> Entrance Hall will become a kill zone in 1 minute!")
			sleep(600)
			world << errormsg("<b>Warning:</b> Entrance Hall will become a kill zone in 10 seconds!") // extra 10 seconds to ensure afk sign toggles on
			sleep(100)
			world << infomsg("Entrance Hall is now a kill zone for [minutes] minutes, defend yourselves from dark wizards who can now enter or other students who feel like murdering you!")

			var/area/entrance = locate(/area/hogwarts/Entrance_Hall)
			for(var/mob/Player/p in entrance)
				if(p.away) p.loc = locate(49,56,21)

			entrance.safezoneoverride = 1
			sleep(minutes * 600)
			entrance.safezoneoverride = 0
			world << infomsg("Hogwarts magical defenses are restored, Entrance Hall is safe again.")

	OldSystem
		name = "Old Dueling System"
		start()
			..()
			var/minutes = rand(10,30)
			world << infomsg("Old dueling system is active for [minutes] minutes outside!")

			for(var/area/A in outside_areas)
				A.oldsystem = 1
				spawn(minutes * 600) A.oldsystem = 0

			sleep(minutes * 600)
			world << infomsg("Old dueling system event is over.")

	Snitches
		name = "Catch Snitches"
		start()
			..()
			var/minutes = rand(10,30)
			var/snitches = rand(15,30)
			world << infomsg("[snitches] snitches were released right outside Hogwarts, each snitch you catch will reward you!<br>The snitches will disappear in [minutes] minutes. To catch snitches you need to fly on a broom and use \"Catch-Snitch\" verb (The verb will only appear when you are near the snitch, it is recommended to macro it).")

			var/list/s = list()
			for(var/i = 0; i < snitches; i++)
				var/obj/spawner/spawn_loc = pick(spawners)
				s += new/obj/quidditch/snitch { prize = 1 } (spawn_loc.loc)

			sleep(minutes * 600)

			for(var/obj/quidditch/snitch/sn in s)
				s -= sn
				del sn
			s = null

			sleep(234)

	DropRate
		name = "Drop Rate Bonus"
		start()
			..()
			var/minutes = rand(30,60)
			var/bonus = rand(25,100)

			DropRateModifier += bonus / 100
			var/tmpDropRate = DropRateModifier
			world << infomsg("You sense a strange magic increasing your drop rate by [bonus]% for [minutes] minutes (This stacks with any other bonuses).")

			spawn(minutes * 600)
				if(DropRateModifier == tmpDropRate)
					world << infomsg("The drop rate bonus event is over.")
					DropRateModifier -= bonus / 100


	Invasion
		name = "Monster Invasion"
		start()
			..()
			var/minutes = rand(10,30)
			var/monsters = rand(50,100)
			var/tier = rand(1,7)

			var/_name
			var/_icon
			var/_icon_state

			switch(tier)
				if(1)
					_name       = "Rat"
					_icon       = 'monsters.dmi'
					_icon_state = "demon rat"
				if(2)
					_name       = "Demon Rat"
					_icon       = 'monsters.dmi'
					_icon_state = "demon rat"
				if(3)
					_name       = "Pixie"
					_icon       = 'monsters2.dmi'
					_icon_state = "pixie"
				if(4)
					_name       = "Dog"
					_icon       = 'NewMobs.dmi'
					_icon_state = "dog"
				if(5)
					_name       = "Snake"
					_icon       = 'Animagus.dmi'
					_icon_state = "Snake"
				if(6)
					_name       = "Wolf"
					_icon       = 'monsters2.dmi'
					_icon_state = "wolf"
				if(7)
					_name       = "Troll"
					_icon       = 'monsters2.dmi'
					_icon_state = "troll"

			world << infomsg("[_name]s are invading for [minutes] minutes, they're right outside Hogwarts, defend the castle!<br>(The monsters have a leader, stronger than the rest, he drops a valuable prize based on level)")

			var/list/m = list()
			for(var/i = 0; i <= monsters; i++)
				var/obj/spawner/spawn_loc = pick(spawners)
				var/mob/NPC/Enemies/Summoned/monster = new (spawn_loc.loc)

				monster.DMGmodifier = 1
				monster.HPmodifier  = 1
				monster.level       = tier * 100
				monster.name        = _name
				monster.icon        = _icon
				monster.icon_state  = _icon_state

				if(i == monsters)
					monster.MoveDelay = 2
					monster.AttackDelay = 2
					monster.level *= 2
					monster.name   = "[pick("Odd ", "Big ", "Giant ", "Mysteriously Big ", "Enormous ", "Magical ", "")][monster.name][pick(" King", " Queen", " Leader", "")]"

					if(tier < 3)
						monster.drops = list("100" = list(/obj/items/bagofgoodies))
					else if(tier == 3)
						monster.drops = list("100" = list(/obj/items/bagofgoodies,
														  /obj/items/lamps/double_drop_rate_lamp,
														  /obj/items/lamps/double_exp_lamp,
														  /obj/items/lamps/double_gold_lamp))
					else if(tier == 4)
						monster.drops = list("100" = list(/obj/items/artifact,
														  /obj/items/lamps/double_drop_rate_lamp,
														  /obj/items/lamps/double_exp_lamp,
														  /obj/items/lamps/double_gold_lamp,
														  /obj/items/lamps/farmer_lamp,
														  /obj/items/wearable/title/Warrior))
					else if(tier == 5)
						monster.drops = list("100" = list(/obj/items/artifact,
														  /obj/items/lamps/double_drop_rate_lamp,
														  /obj/items/lamps/double_exp_lamp,
														  /obj/items/lamps/double_gold_lamp,
														  /obj/items/lamps/triple_drop_rate_lamp,
														  /obj/items/lamps/triple_exp_lamp,
														  /obj/items/lamps/triple_gold_lamp,
														  /obj/items/lamps/farmer_lamp,
														  /obj/items/wearable/title/Warrior))
					else if(tier == 6)
						monster.drops = list("100" = list(/obj/items/artifact,
												 		  /obj/items/lamps/triple_drop_rate_lamp,
												  		  /obj/items/lamps/triple_exp_lamp,
												  		  /obj/items/lamps/triple_gold_lamp,
												  		  /obj/items/wearable/title/Warrior,
												  		  /obj/items/wearable/title/Warmonger))

					else if(tier == 7)
						monster.drops = list("100" = list(/obj/items/artifact,
												  		  /obj/items/scroll/prize,
												  		  /obj/items/lamps/triple_drop_rate_lamp,
												  		  /obj/items/lamps/triple_gold_lamp,
												  		  /obj/items/wearable/title/Warmonger))

				monster.calcStats()

				m += monster

			sleep(minutes * 600)

			for(var/mob/NPC/Enemies/Summoned/monster in m)
				monster.loc = null
				monster.state = monster.INACTIVE
				m -= monster
			m = null




obj/items/scroll/prize

	icon = 'Scroll.dmi'
	icon_state = "wrote"
	destroyable = 0
	accioable = 0
	wlable = 0
	name = "Prize Ticket"
	content = "<body bgcolor=black><u><font color=blue size=3><b>Prize Ticket</b></u></font><br><p><font color=white size=2>Turn this scroll to an admin+ to recieve a prize decided by the admin+.</font></p></body>"


	Name(msg as text)
		set hidden = 1

	write()
		set hidden = 1


