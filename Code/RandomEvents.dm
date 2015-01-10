
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

	BossFight
		name = "Boss Fight"
		start()
			..()
			var/minutes = rand(15,45)
			var/list/m = list()
			switch(pick("Snowman"))
				if("Snowman")
					world << infomsg("The Evil Snowman and his army appeared outside Hogwarts, defend yourselves until reinforcements arrive! Reinforcements will arrive in [minutes] minutes, if you manage to kill the evil snowman before then you might be able to get a nice prize!")

					var/obj/spawner/spawn_loc = pick(spawners)
					var/mob/NPC/Enemies/Summoned/Boss/monster = new /mob/NPC/Enemies/Summoned/Boss/Snowman(spawn_loc.loc)
					m += monster
					for(var/i = 1 to rand(15,40))
						spawn_loc = pick(spawners)
						monster = new (spawn_loc.loc)

						monster.DMGmodifier = 1
						monster.HPmodifier  = 1.5
						monster.MoveDelay   = 3
						monster.AttackDelay = 3
						monster.level       = 600
						monster.name        = "Snowman"
						monster.icon        = 'Snowman.dmi'
						monster.color       = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
						monster.calcStats()
						m += monster

			sleep(minutes * 600)

			var/message = 0
			for(var/mob/NPC/Enemies/Summoned/monster in m)
				if(monster.loc != null) message = 1
				monster.loc = null
				monster.state = monster.INACTIVE
				m -= monster
			m = null

			if(message) world << infomsg("The monsters outside have magically vanished by the powers of the ministry.")

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

			var/message = 0
			for(var/obj/quidditch/snitch/sn in s)
				if(sn && sn.loc) message = 1
				s -= sn
				del sn
			s = null
			if(message) world << infomsg("The snitches have vanished.")

	DropRate
		name = "Drop Rate Bonus"
		start()
			..()
			var/minutes = rand(30,60)
			var/bonus = rand(25,100)

			DropRateModifier += bonus / 100
			var/tmpDropRate = DropRateModifier
			world << infomsg("You feel a strange magic surrounding you, increasing your drop rate by [bonus]% for [minutes] minutes (This stacks on top of any other bonuses).")

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
			var/list/types = list("Rat", "Demon Rat", "Pixie", "Dog", "Snake", "Wolf", "Troll")

			world << infomsg("[types[tier]]s are invading for [minutes] minutes, they're right outside Hogwarts, defend the castle!<br>(The monsters have a leader, stronger than the rest, he drops a valuable prize based on level)")

			var/list/m = list()
			for(var/i = 0; i <= monsters; i++)
				var/obj/spawner/spawn_loc = pick(spawners)
				var/mob/NPC/Enemies/Summoned/monster = new (spawn_loc.loc)

				monster.DMGmodifier = 1
				monster.HPmodifier  = 1
				monster.level       = tier * 100
				monster.name        = types[tier]
				monster.icon        = 'Mobs.dmi'
				monster.icon_state  = lowertext(types[tier])

				if(i == monsters)
					monster.transform *= 3

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
												  		  /obj/items/wearable/scarves/red_scarf,
												  		  /obj/items/wearable/scarves/blue_scarf,
												  		  /obj/items/wearable/scarves/green_scarf,
												  		  /obj/items/wearable/scarves/yellow_scarf,
												  		  /obj/items/lamps/triple_drop_rate_lamp,
												  		  /obj/items/lamps/triple_gold_lamp,
												  		  /obj/items/wearable/title/Warmonger))

				monster.calcStats()

				m += monster

			sleep(minutes * 600)

			var/message = 0
			for(var/mob/NPC/Enemies/Summoned/monster in m)
				if(monster.loc != null) message = 1
				monster.loc = null
				monster.state = monster.INACTIVE
				m -= monster
			m = null

			if(message) world << infomsg("The monsters have been driven away.")




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