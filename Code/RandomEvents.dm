/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
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
	var/chance = 13
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

	FFA
		name = "Free For All"

		var/tmp/mob/Player/winner

		start()
			if(currentArena || (name in currentEvents))	return

			..()
			arenaSummon = 3

			var/rounds = rand(2,4)
			var/obj/clock/timer = locate("FFAtimer")

			for(var/mob/Player/p in Players)
				p << "<h3>An automated FFA is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[p];action=arena_teleport\">click here to teleport.</a> The first round will start in 2 minutes.</h3>"
			sleep(1200)
			while(rounds)
				rounds--
				arenaSummon = 3
				for(var/mob/Player/p in Players)
					p << "<h3>An automated FFA is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[p];action=arena_teleport\">click here to teleport.</a> The [rounds==0 ? "last" : ""] round will start in 1 minute.</h3>"
				sleep(600)
				currentArena = new()
				arenaSummon = 0
				currentArena.roundtype = FFA_WARS
				for(var/mob/M in locate(/area/arenas/MapThree/WaitingArea))
					if(M.client)
						M.DuelRespawn = 0
						currentArena.players.Add(M)
				if(currentArena.players.len < 2)
					currentArena.players << "There isn't enough players to start the round."
					for(var/mob/Player/p in Players)
						p << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[p];action=arena_leave\">clicking here.</a></b>"
					del(currentArena)
				else
					currentArena.players << "<center><font size = 4>The arena mode is <u>Free For All</u>. Everyone is your enemy.<br>The last person standing wins!</center>"
					sleep(30)
					currentArena.players << "<h5>Round starting in 10 seconds</h5>"
					sleep(50)
					currentArena.players << "<h5>5 seconds</h5>"
					sleep(10)
					currentArena.players << "<h5>4 seconds</h5>"
					sleep(10)
					currentArena.players << "<h5>3 seconds</h5>"
					sleep(10)
					currentArena.players << "<h5>2 seconds</h5>"
					sleep(10)
					currentArena.players << "<h5>1 seconds</h5>"
					sleep(10)
					currentArena.players << "<h4>Go!</h5>"
					currentArena.started = 1

					var/count = currentArena.players.len

					var/list/rndturfs = list()
					for(var/turf/T in locate(/area/arenas/MapThree/PlayArea))
						rndturfs.Add(T)
					currentArena.speaker = pick(MapThreeWaitingAreaTurfs)
					for(var/mob/M in currentArena.players)
						var/turf/T = pick(rndturfs)
						M.loc = T
						M.density = 1
						M.HP = M.MHP+M.extraMHP
						M.MP = M.MMP+M.extraMMP
						M.updateHPMP()

					timer.invisibility = 0
					timer.setTime(6)

					while(currentArena && !timer.countdown())
						sleep(10)

					timer.invisibility = 2

					if(currentArena)
						while(currentArena && currentArena.players && currentArena.players.len > 1)
							var/mob/Player/p = pick(currentArena.players)
							p.HP = 0
							p.Death_Check()

					if(winner)
						var/prize = 10000 * count
						winner.gold += prize
						winner << infomsg("You won [comma(prize)] gold for winning the round.")
						goldlog << "[time2text(world.realtime,"MMM DD - hh:mm")]: (FFA) [winner.name] won [comma(prize)] gold.<br />"

			end()

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
					for(var/mob/Player/p in Players)
						p << announcemsg("[c.subject] Class is starting in [i] minute[i > 1 ? "s" : ""] for [c.name]. Click <a href=\"?src=\ref[p];action=class_path\">here</a> for directions.")
					sleep(600)


				c.start()
				sleep(600 * 30)
				Players << announcemsg("[c.subject] class has ended.")
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
				mon.ChangeState(monster.INACTIVE)
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
				mon.ChangeState(monster.INACTIVE)
				m -= mon
			m = null

			if(message) Players << infomsg("Willy the Whisp and his minions have magically vanished by the powers of the ministry.")
			end()


	Spider
		name = "Spiders"
		start()
			..()
			var/minutes = rand(15,45)
			var/list/m = list()
			Players << infomsg("Something doesn't quite smell right outside Hogwarts, be cautious, evil forces are crawling, defend yourselves until reinforcements arrive! Reinforcements will arrive in [minutes] minutes, if you manage to ...butcher them... before then you might be able to get a nice prize!")

			var/obj/spawner/spawn_loc = pick(spawners)
			var/mob/NPC/Enemies/Summoned/monster = new /mob/NPC/Enemies/Summoned/Boss/Acromantula(spawn_loc.loc)
			m += monster
			for(var/i = 1 to rand(10,30))
				spawn_loc = pick(spawners)
				monster = new /mob/NPC/Enemies/Summoned/Acromantula (spawn_loc.loc)

				m += monster

			sleep(minutes * 600)

			var/message = 0
			for(var/mob/NPC/Enemies/Summoned/mon in m)
				if(mon.loc != null) message = 1
				mon.loc = null
				mon.ChangeState(monster.INACTIVE)
				m -= mon
			m = null

			if(message) Players << infomsg("The pesky spiders were exterminated. All hail the dalek--- ministry.")
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
				if(p.away) p.loc = locate("@GreatHall")


			entrance.safezoneoverride = 1
			sleep(minutes * 600)

			for(var/mob/NPC/Enemies/ai in entrance)
				Respawn(ai)

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

	TreasureHunt
		name = "Treasure Hunt"
		chance = 15
		var/list
			totalTreasures
			winners

		start()
			..()
			var/minutes = rand(9, 16)
			var/chests  = rand(2, 6)

			Players << infomsg("A wizard-pirate dropped [chests] chests off his ship while casually flying through the castle's restricted airspace, he might've dropped those chests because we might've fired our magic-space guns at him.<br>Find the treasure chests before other pesky looters get them! You have [minutes] minutes.<br>(Treasure is not visible, it's hidden somewhere outside the castle.)")

			var/list/treasures = list()
			if(!winners) winners = list()
			if(!totalTreasures) totalTreasures = list()
			for(var/i = 1 to chests)

				var/obj/spawner/spawn_loc = pick(spawners)

				var/obj/items/treasure/t = new (spawn_loc.loc)
				treasures += t
				totalTreasures += t

				t.density = 1
				for(var/j = 1 to 5)
					step_rand(t)
				t.density = 0

			sleep(minutes * 600)

			var/end = FALSE
			for(var/obj/t in treasures)
				treasures -= t
				if(!t.loc) continue
				totalTreasures -= t
				if(!totalTreasures.len)
					totalTreasures = null
					end = TRUE
				t.loc     = null

			if(end)
				end()

			treasures = null

		end()
			winners = null

			Players << infomsg("Treasure Hunt is over.")
			currentEvents -= name

			if(currentEvents.len == 0) currentEvents = null

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
				monster.ChangeState(monster.INACTIVE)
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

obj/items/treasure
	var/event = "Treasure Hunt"

	Take()
		set src in oview(1)

		if(event == "Treasure Hunt")
			var/RandomEvent/TreasureHunt/e = locate() in events
			if(e && (usr.ckey in e.winners))
				usr << errormsg("You already found a chest!")
				return

		loc = null

		var/t = pickweight(list(/obj/items/chest/basic_chest     = 45,
		                        /obj/items/chest/wizard_chest    = 15,
		                        /obj/items/chest/pentakill_chest = 15,
								/obj/items/chest/prom_chest      = 10,
								/obj/items/chest/summer_chest    = 10,
		                        /obj/items/chest/sunset_chest    = 5))

		var/obj/items/i = new t (usr)
		usr:Resort_Stacking_Inv()

		Players << infomsg("<b>[event]:</b> [usr] found a [i.name]!")

		if(event == "Treasure Hunt")
			var/RandomEvent/TreasureHunt/e = locate() in events
			if(e && e.totalTreasures && (src in e.totalTreasures))
				e.totalTreasures -= src

				e.winners += usr.ckey

				if(!e.totalTreasures.len)
					e.totalTreasures = null
					e.end()

