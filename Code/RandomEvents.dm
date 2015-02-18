
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

var/list/currentEvents

RandomEvent
	var/chance = 10
	var/name
	var/beepType = 1

	proc
		start()
			if(!currentEvents) currentEvents = list()

			if(name in currentEvents)
				currentEvents[name]++
			else
				currentEvents[name] = 1

			for(var/mob/Player/p in Players)
				p.beep(beepType)
		end()
			currentEvents[name]--
			if(currentEvents[name] <= 0)
				currentEvents -= name

			if(currentEvents.len == 0) currentEvents = null

	Class
		name = "Class"
		beepType = 2
		start()
			var/spell = pick(spellList ^ list(/mob/Spells/verb/Self_To_Dragon, /mob/Spells/verb/Self_To_Human, /mob/Spells/verb/Episky, /mob/Spells/verb/Inflamari))

			var/class/c

			for(var/t in typesof(/class/))
				if(ends_with("[t]", replace(spellList[spell], " ", "_")))
					c = new t
					break

			if(c)
				c.name      = spellList[spell]
				c.spelltype = spell
				curClass    = c.subject
				classdest   = locate("[c.subject] Class")

				var/obj/teacher/t = new (classdest.loc)
				t.classInfo = c
				c.professor = t

				..()

				for(var/i = 5; i > 0; i--)
					Players << announcemsg("[c.subject] Class is starting in [i] minute[i > 1 ? "s" : ""] for [c.name]. Click <a href=\"?src=\ref[usr];action=class_path\">here</a> for directions.")
					sleep(600)


				c.start()
				sleep(600 * 30)
				Players << announcemsg("[c.subject] Class ended.")
				t.loc = null
				t.classInfo = null
				c.professor = null
				classdest = null

				for(var/mob/M in Players)
					if(M.classpathfinding)
						for(var/image/C in M.client.images)
							if(C.icon == 'arrows.dmi')
								M.client.images.Remove(C)
						M.classpathfinding = 0
				end()
			else
				world.log << "TWC Error: [spell] not found in class type list (Class.dmi)"


	TheEvilSnowman
		name = "The Evil Snowman"
		start()
			..()
			var/minutes = rand(15,45)
			var/list/m = list()
			Players << infomsg("The Evil Snowman and his army appeared outside Hogwarts, defend yourselves until reinforcements arrive! Reinforcements will arrive in [minutes] minutes, if you manage to kill the evil snowman before then you might be able to get a nice prize!")

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
			for(var/mob/NPC/Enemies/Summoned/mon in m)
				if(mon.loc != null) message = 1
				mon.loc = null
				mon.state = monster.INACTIVE
				m -= mon
			m = null

			if(message) Players << infomsg("The evil snowman and his minions have magically vanished by the powers of the ministry.")
			end()

	WillytheWhisp
		name = "Willy the Whisp"
		start()
			..()
			var/minutes = rand(15,45)
			var/list/m = list()
			Players << infomsg("Willy the Whisp and his army are haunting right outside Hogwarts, defend yourselves until ghostbus---- reinforcements arrive! Reinforcements will arrive in [minutes] minutes, if you manage to kill Willy the Whisp before then you might be able to get a nice prize!")

			var/obj/spawner/spawn_loc = pick(spawners)
			var/mob/NPC/Enemies/Summoned/Boss/monster = new /mob/NPC/Enemies/Summoned/Boss/Wisp(spawn_loc.loc)
			m += monster
			for(var/i = 1 to rand(15,40))
				spawn_loc = pick(spawners)
				monster = new (spawn_loc.loc)

				monster.DMGmodifier = 1
				monster.HPmodifier  = 1.5
				monster.MoveDelay   = 3
				monster.AttackDelay = 3
				monster.level       = 650
				monster.name        = "Wisp"
				monster.icon_state  = "wisp"
				monster.icon        = 'Mobs.dmi'
				monster.color       = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
				monster.alpha       = rand(125, 240)
				monster.calcStats()
				m += monster

			sleep(minutes * 600)

			var/message = 0
			for(var/mob/NPC/Enemies/Summoned/mon in m)
				if(mon.loc != null) message = 1
				mon.loc = null
				mon.state = monster.INACTIVE
				m -= mon
			m = null

			if(message) Players << infomsg("Willy the Whisp and his minions have magically vanished by the powers of the ministry.")
			end()

	EntranceKillZone
		name = "Entrance Kill Zone"
		start()
			..()
			var/minutes = rand(10,30)
			Players << errormsg("<b>Warning:</b> Hogwarts magical defenses are being suppressed by a dark evil magic, Entrance Hall will become a kill zone in 5 minutes for [minutes] minutes!<br>Move to another area (The library, common room, second floor etc) if you wish to remain safe.")
			sleep(600)
			for(var/i = 4 to 1 step -1)
				Players << errormsg("<b>Warning:</b> Entrance Hall will become a kill zone in [i] minute[i > 1 ? "s" : ""]!")
				sleep(600)
			Players << errormsg("<b>Warning:</b> Entrance Hall will become a kill zone in 10 seconds!") // extra 10 seconds to ensure afk sign toggles on
			sleep(100)
			Players << infomsg("Entrance Hall is now a kill zone for [minutes] minutes, defend yourselves from dark wizards who can now enter or other students who feel like murdering you!")

			var/area/entrance = locate(/area/hogwarts/Entrance_Hall)
			for(var/mob/Player/p in entrance)
				if(p.away) p.loc = locate(49,56,21)


			entrance.safezoneoverride = 1
			sleep(minutes * 600)

			entrance.safezoneoverride = 0
			Players << infomsg("Hogwarts magical defenses are restored, Entrance Hall is safe again.")
			end()

	OldSystem
		name = "Old Dueling System"
		start()
			..()
			var/minutes = rand(10,30)
			Players << infomsg("Old dueling system is active for [minutes] minutes outside!")

			for(var/area/A in outside_areas)
				A.oldsystem = 1
				spawn(minutes * 600) A.oldsystem = 0

			sleep(minutes * 600)

			Players << infomsg("Old dueling system event is over.")
			end()

	Snitches
		name = "Catch Snitches"
		start()
			..()
			var/minutes = rand(10,30)
			var/snitches = rand(15,30)
			Players << infomsg("[snitches] snitches were released right outside Hogwarts, each snitch you catch will reward you!<br>The snitches will disappear in [minutes] minutes. To catch snitches you need to fly on a broom and use \"Catch-Snitch\" verb (The verb will only appear when you are near the snitch, it is recommended to macro it).")

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
			if(message) Players << infomsg("The snitches have vanished.")
			end()

	DropRate
		name = "Drop Rate Bonus"
		start()
			..()
			var/minutes = rand(30,60)
			var/bonus = rand(25,100)

			DropRateModifier += bonus / 100
			var/tmpDropRate = DropRateModifier
			Players << infomsg("You feel a strange magic surrounding you, increasing your drop rate by [bonus]% for [minutes] minutes (This stacks on top of any other bonuses).")

			spawn(minutes * 600)
				end()
				if(DropRateModifier == tmpDropRate)
					Players << infomsg("The drop rate bonus event is over.")
					DropRateModifier -= bonus / 100

	Sale
		name = "Crazy Sale"
		start()
			..()
			var/minutes = rand(30,60)
			var/sale = rand(10,30)

			shopPriceModifier -= sale / 100
			var/tmpShopModifier = shopPriceModifier
			Players << infomsg("There's a crazy sale going on! You should check out Marvelous Magical Mystery or wig shops, they have a [sale]% discount for the next [minutes] minutes!")

			spawn(minutes * 600)
				end()
				if(shopPriceModifier == tmpShopModifier)
					Players << infomsg("The sale ended.")
					shopPriceModifier += sale / 100


	Invasion
		name = "Monster Invasion"
		start()
			..()
			var/minutes = rand(10,30)
			var/monsters = rand(50,100)
			var/tier = rand(1,7)
			var/list/types = list("Rat", "Demon Rat", "Pixie", "Dog", "Snake", "Wolf", "Troll")

			Players << infomsg("[types[tier]]s are invading for [minutes] minutes, they're right outside Hogwarts, defend the castle!<br>(The monsters have a leader, stronger than the rest, he drops a valuable prize based on level)")

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
			end()
			var/message = 0
			for(var/mob/NPC/Enemies/Summoned/monster in m)
				if(monster.loc != null) message = 1
				monster.loc = null
				monster.state = monster.INACTIVE
				m -= monster
			m = null

			if(message) Players << infomsg("The monsters have been driven away.")

mob/Player
	var/playSounds = TRUE

	proc/beep(type = 0)
		if((type == 1 && EventNotifications) || (type == 2 && ClassNotifications) || !type)
			winset(src, "mainwindow", "flash=2")

			if(playSounds)
				var/sound/S = sound('Alert.ogg')
				src << S

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