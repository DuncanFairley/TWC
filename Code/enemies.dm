/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

area/var/safezoneoverride = 0
obj/statues
	icon = 'statues.dmi'
	density = 1
	acromantula/icon_state = "acromantula"
	firebat/icon_state = "firebat"
	fire_golem/icon_state = "firegolem"
	bird/icon_state = "bird"
	demon_rat/icon_state = "demon rat"
	troll/icon_state = "troll"
	dementor/icon_state = "dementor"
	pixie/icon_state = "pixie"
	wyvern/icon_state = "wyvern"
	fire_elemental/icon_state = "fire elemental"
	water_elemental/icon_state = "water elemental"
	basilisk/icon_state = "basilisk"
	floating_eye/icon_state = "eye"
	archangel/icon_state = "archangel"
	snake/icon_state = "snake"
	house_elf/icon_state = "houseelf"
	dragon/icon_state = "dragon"
	wolf/icon_state = "wolf"
	skeleton/icon_state = "skeleton"
	bat/icon_state = "bat"
	werewolf/icon_state = "werewolf"
	rat/icon_state = "rat"
	black_cat/icon_state = "blackcat"
	white_cat/icon_state = "whitecat"
	dog/icon_state = "dog"
	frog/icon_state = "frog"
	rabbit/icon_state = "rabbit"
	turkey/icon_state = "turkey"

var/floatingEyesKilled = 0

proc
	isPathBlocked(mob/source, mob/target, dist=1, dense_override=0, dist_limit=10)
		if(!(source && source.loc)) return 1
		if(!(target && target.loc)) return 1
		if(!source.density && !dense_override) return 0

		var/obj/o = new (source.loc)
		o.density = 1

		var/const/STEPS_LIMIT = 10

		var/turf/t = get_step_to(o, target, dist)
		var/distance = get_dist(o, target)

		for(var/steps = 0 to STEPS_LIMIT)
			if(!t) break
			if(distance <= dist_limit) break

			o.loc    = t
			t        = get_step_to(o, target, dist)
			distance = get_dist(o, target)

		if(!t && get_dist(o, target) > dist)
			o.loc = null
			return 1
		o.loc = null
		if(distance > dist_limit)
			return 1
		return 0
area
	newareas
		var/tmp/active = 0
		outside
			Forbidden_ForestNE
			Forbidden_ForestNW
			Forbidden_ForestSE
			Forbidden_ForestSW
			Pixie_Pit
			Desert1
				antiTeleport = TRUE
			Desert2
				antiTeleport = TRUE
			Desert3
				antiTeleport = TRUE
			Silverblood_Bats
			Silverblood_Golems
			Graveyard
			Hogsmeade
			layer = 6	// set this layer above everything else so the overlay obscures everything
			var
				lit = 1	// determines if the area is lit or dark.
				obj/weather/Weather	// what type of weather the area is having
			proc
				daycycle()
					lit = 1 - lit	// toggle lit between 1 and 0
					if(lit)
						overlays -= 'black50.dmi'	// remove the 50% dither
						//if(type == /area/outside)
							//world<<"<b>Event: <font color=blue>The sun rises over the forest. A new day begins."	// remove the dither
					else
						overlays += 'black50.dmi'	// add the 50% dither
					spawn(9000) daycycle()
		inside
			Silverblood_Maze
				antiTeleport = TRUE
				antiFly      = TRUE
			Ratcellar
				antiTeleport = TRUE
				antiFly      = TRUE
			Chamber_of_Secrets
				antiTeleport = TRUE
				antiFly      = TRUE
				Floor1
				Floor1_Boss
				Floor2
				Floor2_Boss

			Graveyard_Underground
				antiTeleport = TRUE
				antiFly      = TRUE
		Entered(atom/movable/O)
			. = ..()
			if(isplayer(O))
				active = 1
				for(var/mob/NPC/Enemies/M in src)
					if(M.state == M.WANDER)
						M.state = M.SEARCH

		Exited(atom/movable/O)
			. = ..()
			if(isplayer(O))
				var/isempty = 1
				for(var/mob/Player/M in src)
					if(M != O)
						isempty = 0
						break
				if(isempty)
					active = 0
					for(var/mob/NPC/Enemies/M in src)
						M.state = M.WANDER

area/Exit(atom/movable/O, atom/newloc)
	.=..()
	if(istype(O, /mob/NPC) && O:removeoMob && !issafezone(src) && issafezone(newloc.loc)) return 0

mob
	test
		verb
			View_Error_Log()
				src << browse(file("Logs/[VERSION]-log.txt"))
			Reconnect_MySQL()
				connected = my_connection.Connect(DBI,mysql_username,mysql_password)
				src << "New connection started."
mob
	NPC
		icon = 'Mobs.dmi'
		see_invisible = 1
		var/activated = 0
		var/HPmodifier = 0.9
		var/DMGmodifier = 0.55
		var/list/drops = list()
		var/tmp/turf/origloc

		Enemies
			player = 0
			Gm = 1
			monster = 1
			NPC = 1

			drops = list("0.7" = list(/obj/items/Whoopie_Cushion,
			 			  			  /obj/items/Smoke_Pellet,
			 			  			  /obj/items/Tube_of_fun))

			var
				const
					INACTIVE   = 0
					WANDER     = 1
					SEARCH     = 2
					HOSTILE    = 4
					CONTROLLED = 8

				tmp
					state = WANDER
					list/ignore

				Range = 12
				MoveDelay = 5
				AttackDelay = 5
				respawnTime = 1200


			New()
				. = ..()
				spawn(1) // fix for monsters not setting their variables if loaded from swap maps
					calcStats()
					origloc = loc
					sleep(rand(10,60))
					ShouldIBeActive()
					state()

			Move(NewLoc,Dir=0)
				if(!removeoMob && isturf(NewLoc))
					var/turf/t = NewLoc
					if(t.loc != loc.loc)
						var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						dirs -= Dir
						while(dirs.len)
							var/d = pick(dirs)
							dirs -= d

							var/turf/new_t = get_step(loc, d)
							if(new_t && new_t.loc == loc.loc)
								NewLoc = new_t
								Dir = d
								break
						if(NewLoc:loc != loc.loc) return
				..()

			proc/calcStats()
				Dmg = round(DMGmodifier * ((src.level -1) + 5))
				MHP = round(HPmodifier * (4 * (src.level - 1) + 200))
				gold = round(src.level / 2)
				Expg = round(src.level * 6)
				HP = MHP
//NEWMONSTERS
			proc/Death(mob/Player/killer)
				var/rate = 1

				if(killer.House == housecupwinner)
					rate += 0.25

				var/StatusEffect/Lamps/DropRate/d = killer.findStatusEffect(/StatusEffect/Lamps/DropRate)
				if(d)
					rate *= d.rate

				rate *= DropRateModifier

				var/obj/items/prize
				for(var/i in drops)
					if(prob(text2num(i) * rate))
						var/t = istype(drops[i], /list) ? pick(drops[i]) : drops[i]
						prize = new t (loc)
						break

				if(name == initial(name) && prob(0.1))
					var/obj/items/wearable/title/Slayer/t = new (loc)
					t.title = "[name] Slayer"
					t.name  = "Title: [name] Slayer"
					prize = t

				if(prize)
					prize.antiTheft = 1
					prize.owner     = killer.ckey
					spawn(150)
						if(prize)
							prize.antiTheft = 0
							prize.owner     = null

			proc/state()
				var/lag = 10
				while(src && src.loc)
					var/s = state
					switch(state)
						if(INACTIVE)
							lag = 50
						if(WANDER)
							Wander()
							lag = 27
						if(SEARCH)
							Search()
							lag = 15
						if(HOSTILE)
							Attack()
							lag = MoveDelay
						if(CONTROLLED)
							BlindAttack()
							lag = 12
					if(s == state)
						if(lag <= 0) lag = 1
						sleep(lag)
					else
						sleep(1)
			var/tmp/mob/target


			proc
				Search()
					Wander()
					for(var/mob/Player/M in ohearers(src, Range))
						if(M.loc.loc != src.loc.loc) continue
						if(ignore && (M in ignore)) continue

						if(!isPathBlocked(M, src, 1, src.density))
							target = M
							state  = HOSTILE
							break
						else
							Ignore(M)

				ChangeTarget()
					var/min_dist = Range
					for(var/mob/Player/M in ohearers(src, Range))
						if(M.loc.loc != src.loc.loc) continue
						if(ignore && (M in ignore)) continue

						if(!isPathBlocked(M, src, 1, src.density))
							var/dist = get_dist(src, M)
							if(min_dist > dist)
								target = M
						else
							Ignore(M)

				Wander()
					step_rand(src)
					sleep(1)

				Ignore(mob/M)
					if(!ignore) ignore = list()
					ignore += M
					spawn(100)
						if(M && ignore)
							ignore -= M
							if(ignore.len == 0)
								ignore = null
						else
							ignore = null

			proc/ReturnToStart()
				state = INACTIVE
				if(loc.loc != origloc.loc)
					if(z == origloc.z)
						density = 0
						while(loc.loc != origloc.loc)
							sleep(1)
							step_towards(src, origloc)
						density = 1
					else
						src.loc = origloc
				ShouldIBeActive()

			proc/ShouldIBeActive()
				if(!loc)
					state = INACTIVE
					return 0

				if(istype(loc.loc, /area/newareas) && loc.loc:active)
					state = SEARCH
					return 1

				state = WANDER
				return 0


			proc/BlindAttack()//removeoMob
				var/mob/Player/M = locate() in ohearers(1, src)
				if(M)
					var/dmg = Dmg+extraDmg+rand(0,4)
					if(dmg<1)
						//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
					else
						M.HP -= dmg
						hearers(M)<<"<SPAN STYLE='color: red'>[src] attacks [M] and causes [dmg] damage!</SPAN>"
						if(src.removeoMob)
							spawn() M.Death_Check(src.removeoMob)
						else
							spawn() M.Death_Check(src)

			proc/Blocked()
				target = null
				ShouldIBeActive()

			proc/Attack()

				if(prob(20))
					step_rand(src)
					sleep(2)

				if(state != HOSTILE) return

				var/distance = get_dist(src, target)
				if(!target || !target.loc || target.loc.loc != loc.loc || distance > Range)
					target = null
					ChangeTarget()
					if(!target)
						ShouldIBeActive()
						return

				if(distance > 1)
					if(prob(10))
						ChangeTarget()

					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						step_rand(src)
						Blocked()
				else
					var/dmg = Dmg+extraDmg+rand(0,4)

					if(target.level > level && !target.findStatusEffect(/StatusEffect/Lamps/Farming))
						dmg -= dmg * ((target.level - level)/100)
					else if(target.level < level)
						dmg += dmg * ((level - target.level)/200)
					dmg = round(dmg)

					if(dmg<1)
						//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
					else
						target.HP -= dmg
						hearers(target)<<"<SPAN STYLE='color: red'>[src] attacks [target] and causes [dmg] damage!</SPAN>"
						spawn()target.Death_Check(src)
					sleep(AttackDelay)

//////Monsters///////

			Summoned
				state = SEARCH
				New()
					calcStats()
					spawn(1)
						state()

				ShouldIBeActive()
					if(!loc)
						state = INACTIVE
						return 0

					state = SEARCH
					return 1

				ReturnToStart()
					ShouldIBeActive()

				Dementor
					icon_state = "dementor"
					level = 300

					Death()

				Snake
					icon_state = "snake"
					level = 250

					Death()

				Boss

					Attack()
						..()

					Search()
						Wander()
						for(var/mob/Player/M in ohearers(src, Range))
							if(M.loc.loc != src.loc.loc) continue

							target = M
							state  = HOSTILE

							spawn()
								var/time = 5
								while(src && state == HOSTILE && M == target && time > 0)
									sleep(30)
									time--

								if(M == target && state == HOSTILE)
									target = null
									state = SEARCH

							break


					Blocked()
						density = 0
						var/turf/t = get_step_to(src, target, 1)
						if(t)
							Move(t)
						else
							..()
						density = 1

					Basilisk
						icon_state = "basilisk"
						HPmodifier = 3
						DMGmodifier = 3
						MoveDelay = 3
						level = 2000

						Death()

					Wisp
						icon_state = "wisp"
						name = "Willy the Whisp"
						HPmodifier = 6
						DMGmodifier = 2
						layer = 5
						MoveDelay = 2
						AttackDelay = 1
						Range = 15
						level = 1200
						var/tmp/fired = 0
						var/proj = "gum"
						canBleed = FALSE

						drops = list("100" = list(/obj/items/key/basic_key,
						                          /obj/items/key/wizard_key,
						                          /obj/items/wearable/title/Ghost,
												  /obj/items/lamps/triple_drop_rate_lamp,
												  /obj/items/lamps/triple_gold_lamp,
												  /obj/items/wearable/afk/heart_ring))


						New()
							..()
							alpha = rand(190,240)

							var/color1 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
							var/color2 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
							var/color3 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))

							animate(src, color = color1, time = 10, loop = -1)
							animate(color = color2, time = 10)
							animate(color = color3, time = 10)

							transform *= 3 + (rand(-10, 10) / 10)

							spawn()
								while(src.loc)
									proj = pick(list("gum", "quake", "iceball","fireball", "", "black") - proj)
									switch(proj)
										if("gum")
											animate(src, color = "#fa8bd8", time = 10, loop = -1)
											animate(color = "#c811f1", time = 10)
											animate(color = "#ec06a3", time = 10)
										if("quake")
											animate(src, color = "#aa8d84", time = 10, loop = -1)
											animate(color = "#767309", time = 10)
											animate(color = "#a4903d", time = 10)
										if("iceball")
											animate(src, color = "#24e3f3", time = 10, loop = -1)
											animate(color = "#a4bcd3", time = 10)
											animate(color = "#4a9ee0", time = 10)
										if("fireball")
											animate(src, color = "#dd6103", time = 10, loop = -1)
											animate(color = "#b21039", time = 10)
											animate(color = "#b81114", time = 10)
										if("black")
											animate(src, color = "#000000", time = 10, loop = -1)
											animate(color = "#ffffff", time = 10)
										if("")
											animate(src, color = "#0e3492", time = 10, loop = -1)
											animate(color = "#2a32fb", time = 10)
											animate(color = "#cdf0e3", time = 10)
									sleep(200)

						Attack(mob/M)
							..()
							if(!fired && target && state == HOSTILE)
								fired = 1
								spawn(rand(30,50)) fired = 0

								for(var/obj/redroses/S in oview(3, src))
									flick("burning", S)
									spawn(8) S.loc = null

								if(prob(80))
									var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
									var/tmp_d = dir
									for(var/d in dirs)
										dir = d
										castproj(0, 'attacks.dmi', "fireball", Dmg + rand(-4,8), "fire ball", 0, 1)
									dir = tmp_d
									sleep(AttackDelay)

						Attacked(projname, damage)
							if(projname == proj && prob(99))
								emit(loc    = src,
									 ptype  = /obj/particle/red,
								     amount = 2,
								     angle  = new /Random(1, 359),
								     speed  = 2,
								     life   = new /Random(15,20))
							else
								HP+=damage

								emit(loc    = src,
									 ptype  = /obj/particle/green,
								     amount = 2,
								     angle  = new /Random(1, 359),
								     speed  = 2,
								     life   = new /Random(15,20))

					Snowman
						icon = 'Snowman.dmi'
						name = "The Evil Snowman"
						HPmodifier = 10
						DMGmodifier = 0.5
						layer = 5
						MoveDelay = 3
						AttackDelay = 2
						Range = 15
						level = 1000
						var/tmp/fired = 0
						extraDmg = 400

						drops = list("100" = list(/obj/items/key/basic_key,
						                          /obj/items/key/pentakill_key,
						                          /obj/items/wearable/title/Snowflakes,
												  /obj/items/lamps/triple_drop_rate_lamp,
												  /obj/items/lamps/triple_gold_lamp,
												  /obj/items/wearable/afk/hot_chocolate))

						Attack(mob/M)
							..()
							if(!fired && target && state == HOSTILE)
								if(prob(40))
									fired = 1
									spawn(rand(30,50)) fired = 0

									var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
									var/tmp_d = dir
									var/dmg = round((Dmg+extraDmg) * 1.5 + rand(-4,8))
									for(var/d in dirs)
										dir = d
										castproj(0, 'attacks.dmi', "snowball", dmg, "snowball", 0, 1)
									dir = tmp_d
									sleep(AttackDelay)
						Attacked()
							..()
							if(HP > 0)
								var/percent = MHP / HP
								var/matrix/M = matrix()*percent
								transform = M

								extraDmg = percent * 400

								if(percent >= 5)
									MoveDelay = 1
								else if(percent >= 3)
									AttackDelay = 1
								else if(percent >= 2)
									MoveDelay = 2

					Stickman
						icon_state = "stickman"
						level = 500
						HPmodifier  = 1
						DMGmodifier = 1

						MoveDelay   = 3
						AttackDelay = 1

						var/tmp/fired = 0

						BlindAttack()
							spawn()
								for(var/i = 1 to 3)
									castproj(0, 'attacks.dmi', "gum", Dmg + rand(-4,8), "Waddiwasi")
									sleep(4)

						Attack()
							if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,10)))
								target = null
								ShouldIBeActive()
								return

							if(prob(30))
								ChangeTarget()

							var/distance = get_dist(src, target)
							if(distance > 5)
								var/turf/t = get_step_to(src, target, 1)
								if(t)
									Move(t)
								else
									target = null
									ShouldIBeActive()
							else if(distance <= 3)
								step_away(src, target)
							else if(distance > 3)
								step_rand(src)

							dir=get_dir(src, target)
							if(AttackDelay)	sleep(AttackDelay)
							castproj(0, 'attacks.dmi', "gum", Dmg + rand(-4,8), "Waddiwasi")



				Phoenix
					icon_state = "bird"
					level = 6

					Search()
						Wander()
						sleep(3)
						Heal()

					proc
						Heal()
							for(var/mob/Player/M in ohearers(3, src))
								M.HP += round((M.MHP/20)+rand(0,50))
								if(M.HP > M.MHP) M.HP = M.MHP
								M.updateHPMP()
					BlindAttack()//removeoMob
						Heal()

					New()
						light(src, 3, 600, "orange")
						..()


			Stickman
				icon_state = "stickman"
				level = 2200
				HPmodifier  = 2
				DMGmodifier = 1.5

				MoveDelay   = 2
				AttackDelay = 0

				var/tmp/fired = 0

				Range = 16
				respawnTime = 6000

				New()
					..()
					transform *= 2

				drops = list("2"    = /obj/items/key/wizard_key,
				             "10"   = list(/obj/items/artifact,
										   /obj/items/stickbook,
										   /obj/items/crystal/soul,
				                           /obj/items/wearable/title/Surf),
							 "15"   = list(/obj/items/artifact,
							               /obj/items/crystal/magic,
							               /obj/items/crystal/strong_luck),
							 "30"   = list(/obj/items/DarknessPowder,
								 		   /obj/items/Whoopie_Cushion,
										   /obj/items/U_No_Poo,
							 			   /obj/items/Smoke_Pellet,
							 			   /obj/items/Tube_of_fun,
							 			   /obj/items/Swamp))

				Attack()
					if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,10)))
						target = null
						ShouldIBeActive()
						return

					if(prob(30))
						ChangeTarget()

					var/distance = get_dist(src, target)
					if(distance > 5)
						var/turf/t = get_step_to(src, target, 1)
						if(t)
							Move(t)
						else
							target = null
							ShouldIBeActive()
					else if(distance <= 3)
						step_away(src, target)
					else if(distance > 3)
						step_rand(src)

					if(prob(15) && !fired)
						fired = 1
						spawn(100) fired = 0
						var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						var/tmp_d = dir
						var/dmg = round(Dmg * 0.75) + rand(-4,8)
						for(var/d in dirs)
							dir = d
							castproj(0, 'attacks.dmi', "fireball", dmg, "Incindia", 0, 1)
						dir = tmp_d
					else
						dir=get_dir(src, target)
						if(AttackDelay)	sleep(AttackDelay)
						castproj(0, 'attacks.dmi', "gum", Dmg + rand(-4,8), "Waddiwasi")

				Blocked()
					density = 0
					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						..()
					density = 1

				Death(mob/Player/killer)
					..(killer)

					var/obj/Hogwarts_Door/gate/door = locate("CoSBoss2LockDoor")
					if(door)
						door.door = 1

						var/obj/teleport/portkey/t = new (loc)
						t.dest = "teleportPointCoS Floor 3"

						spawn(respawnTime)
							door.door = 0
							t.loc = null

						spawn(2)
							t.density = 1
							step_rand(t)
							t.density = 0

			Rat
				icon_state = "rat"
				level = 10
			Demon_Rat
				icon_state = "demon rat"
				level = 50
				drops = list("0.7" =      /obj/items/demonic_essence,
							 "0.8" = list(/obj/items/Whoopie_Cushion,
			 	 			 			  /obj/items/Smoke_Pellet,
			 	 			 			  /obj/items/Tube_of_fun))
			Pixie
				icon_state = "pixie"
				level = 100
			Dog
				icon_state = "dog"
				level = 150
			Snake
				icon_state = "snake"
				level = 200
			Wolf
				icon_state = "wolf"
				level = 300
			Acromantula
				icon_state = "spider"
				level = 700
			Snowman
				icon = 'Snowman.dmi'
				level = 700
				HPmodifier  = 3
				DMGmodifier = 1
				MoveDelay = 4
				AttackDelay = 3
				drops = list("0.01" =      /obj/items/artifact,
							 "5"    = list(/obj/items/DarknessPowder,
								 		   /obj/items/Whoopie_Cushion,
										   /obj/items/U_No_Poo,
							 			   /obj/items/Smoke_Pellet,
							 			   /obj/items/Tube_of_fun,
							 			   /obj/items/Swamp),
							 "30"   = /obj/items/gift)
			Wisp
				icon_state = "wisp"
				level = 750

				HPmodifier  = 1.4
				DMGmodifier = 0.8
				MoveDelay = 3
				canBleed = FALSE
				var/tmp/fired = 0

				drops = list("3"    =      /obj/items/crystal/luck,
							 "0.3"  = list(/obj/items/key/basic_key,
							               /obj/items/key/wizard_key,
							               /obj/items/key/pentakill_key,
							               /obj/items/key/sunset_key),
						     "0.8"  = list(/obj/items/crystal/defense,
							 			   /obj/items/crystal/damage),
						     "0.01" = /obj/items/artifact,
							 "0.03" = list(/obj/items/wearable/title/Magic,
							 			   /obj/items/crystal/magic,
						     			   /obj/items/crystal/strong_luck,
						     			   /obj/items/crystal/soul),
							 "5"    = list(/obj/items/DarknessPowder,
							 			   /obj/items/Smoke_Pellet,
							 			   /obj/items/Tube_of_fun))


				Attack(mob/M)
					..()
					if(!fired && target && state == HOSTILE)
						fired = 1
						spawn(rand(50,150)) fired = 0

						for(var/obj/redroses/S in oview(3, src))
							flick("burning", S)
							spawn(8) S.loc = null

						if(prob(80))
							dir=get_dir(src, target)
							castproj(0, 'attacks.dmi', "fireball", Dmg + rand(-4,8), "fire ball")
							sleep(AttackDelay)

				Attacked(projname, damage)
					if(projname == "gum" && prob(95))
						emit(loc    = src,
							 ptype  = /obj/particle/red,
						     amount = 2,
						     angle  = new /Random(1, 359),
						     speed  = 2,
						     life   = new /Random(15,20))
					else
						HP+=damage

						emit(loc    = src,
							 ptype  = /obj/particle/green,
						     amount = 2,
						     angle  = new /Random(1, 359),
						     speed  = 2,
						     life   = new /Random(15,20))

				New()
					..()
					alpha = rand(190,255)

					var/color1 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
					var/color2 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
					var/color3 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))

					animate(src, color = color1, time = 10, loop = -1)
					animate(color = color2, time = 10)
					animate(color = color3, time = 10)

					if(prob(70)) transform *= 1 + (rand(-5,15) / 50) // -10% to +30% size change



			Floating_Eye
				icon_state = "eye1"
				level = 900
				HPmodifier  = 2
				DMGmodifier = 0.8
				var
					tmp/fired = 0
					Random/cd = new(30, 50)

				MoveDelay = 4
				AttackDelay = 1

				Eye_of_The_Fallen
					level = 2400
					cd = new(5, 10)

					MoveDelay = 2

					drops = list("2"      =      /obj/items/key/sunset_key,
					             "10"     = list(/obj/items/artifact,
										         /obj/items/crystal/soul,
				                                 /obj/items/wearable/title/Fallen),
							     "15"     = list(/obj/items/artifact,
							                     /obj/items/crystal/magic,
							                     /obj/items/crystal/strong_luck),
							     "30"     = list(/obj/items/DarknessPowder,
								 		         /obj/items/Whoopie_Cushion,
										         /obj/items/U_No_Poo,
							 			         /obj/items/Smoke_Pellet,
							 			         /obj/items/Tube_of_fun,
							 			         /obj/items/Swamp))


					Death()
						..()
						var/obj/teleport/portkey/t = new (loc)
						t.dest = "@Hogwarts"

						spawn(respawnTime)
							t.loc = null

						spawn(2)
							t.density = 1
							step_rand(t)
							t.density = 0

					New()
						..()
						animate(src, color = rgb(255, 0, 0), time = 10, loop = -1)
						animate(color = rgb(255, 0, 255), time = 10)
						animate(color = rgb(rand(60,255), rand(60,255), rand(60,255)), time = 10)

						transform *= 3

						origloc = null
				New()
					..()
					icon_state = "eye[rand(1,2)]"
					if(prob(60))
						transform *= 1 + (rand(-15,30) / 50) // -30% to +60% size change

				drops = list("0.03" = /obj/items/wearable/title/Eye,
							 "0.5"  = list(/obj/items/key/basic_key,
							               /obj/items/key/wizard_key,
							               /obj/items/key/pentakill_key,
							               /obj/items/key/sunset_key),
							 "0.6"  = /obj/items/artifact,
							 "1"    = list(/obj/items/DarknessPowder,
								 	 	   /obj/items/Whoopie_Cushion,
									 	   /obj/items/U_No_Poo,
							 		 	   /obj/items/Smoke_Pellet,
							 		 	   /obj/items/Tube_of_fun,
							 		       /obj/items/Swamp))

				Search()
					Wander()
					for(var/mob/Player/M in ohearers(src, Range))
						if(M.loc.loc == src.loc.loc)
							target = M
							state  = HOSTILE
							break

				Death()
					..()
					if(++floatingEyesKilled >= 1000)
						floatingEyesKilled = 0
						Players << infomsg("The Eye of The Fallen has appeared somewhere in the desert!")
						new /mob/NPC/Enemies/Floating_Eye/Eye_of_The_Fallen (locate(rand(4,97),rand(4,97),rand(4,5)))

				Blocked()
					density = 0
					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						..()
					density = 1

				Attack(mob/M)
					..()
					if(!fired && target && state == HOSTILE)
						var/fire = 0
						if(prob(40))
							fire = 1
						else if(prob(10))
							fire = 2
						if(fire)
							fired = 1
							spawn(cd.get()) fired = 0

							var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
							if(fire == 1)
								var/tmp_d = dir
								var/dmg = round(Dmg * 1.5 + rand(-4,8))
								for(var/d in dirs)
									dir = d
									castproj(0, 'attacks.dmi', "crucio2", dmg, "death ball", 0, 1)
								dir = tmp_d
							else
								for(var/d in dirs)
									var/obj/Flippendo/S = new (src.loc)
									S.owner = src
									walk(S, d, 2)
									spawn(20) if(S) del S
							sleep(AttackDelay)

			Troll
				icon_state = "troll"
				level = 350
				HPmodifier  = 3
				DMGmodifier = 0.8
				MoveDelay   = 4
				AttackDelay = 4

				drops = list("0.9" = list(/obj/items/Whoopie_Cushion,
			 				  			  /obj/items/Smoke_Pellet,
			 			  				  /obj/items/Tube_of_fun),
			 			  	 "0.7" = list(/obj/items/wearable/bling,
			 			  	 			  /obj/items/bucket,
			 			  	 			  /obj/items/scroll,
			 			  	 			  /obj/items/wearable/title/Troll))

				New()
					..()
					transform *= rand(10,20) / 10

				Attack()
					var/tmpdmg = extraDmg
					var/tmplvl = level
					if(prob(5))
						extraDmg = 600
						level    = 1000
					..()
					extraDmg = tmpdmg
					level    = tmplvl
			House_Elf
				icon_state = "houseelf"
				level = 5
			/*Stone_Golem
				icon = 'Mobs.dmi'
				icon_state="stonegolem"
				level = 6*/
			Dementor
				icon_state = "dementor"
				level = 750
			Dementor_ /////SUMMONED/////
				icon_state = "dementor"
				level = 300
			Stickman_ ///SUMMONED///
				icon_state = "stickman"
				level = 500
			Bird_    ///SUMMONED///
				icon_state = "bird"
				level = 6
			Fire_Bat
				icon_state = "firebat"
				level = 400
				var/tmp/fired = 0
				AttackDelay = 3
				Attack()
					if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,10)))
						target = null
						ShouldIBeActive()
						return

					if(!fired && prob(80))
						fired = 1
						dir=get_dir(src, target)
						castproj(0, 'attacks.dmi', "fireball", Dmg + rand(-4,8), "fire ball")
						spawn(rand(15,30)) fired = 0
						sleep(AttackDelay)

					var/distance = get_dist(src, target)
					if(distance > 5)
						var/turf/t = get_step_to(src, target, 1)
						if(t)
							Move(t)
						else
							target = null
							ShouldIBeActive()
					else if(distance <= 3)
						step_away(src, target)
					else if(distance > 3)
						step_rand(src)
						sleep(2)
			Fire_Golem
				icon_state = "firegolem"
				level = 450
				AttackDelay = 3
				var/tmp/fired = 0
				Attack()
					if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,10)))
						target = null
						ShouldIBeActive()
						return

					if(!fired && prob(80))
						fired = 1
						dir=get_dir(src, target)
						castproj(0, 'attacks.dmi', "fireball", Dmg + rand(-4,8), "fire ball")
						spawn(rand(15,30)) fired = 0
						sleep(AttackDelay)

					var/distance = get_dist(src, target)
					if(distance > 5)
						var/turf/t = get_step_to(src, target, 1)
						if(t)
							Move(t)
						else
							target = null
							ShouldIBeActive()
					else if(distance < 3)
						step_away(src, target)
					else if(distance >= 3)
						step_rand(src)
						sleep(2)

			Slug
				icon_state = "slug"
				monster=1
				player=0
				New()
					move()
				proc/move()
					spawn(5)
						while(src)
							walk_rand(src,15)
							sleep(100)
							del src
			Archangel
				icon_state = "archangel"
				level = 500
			Water_Elemental
				icon_state = "water elemental"
				level = 550
				canBleed = FALSE
			Fire_Elemental
				icon_state = "fire elemental"
				level = 600
				canBleed = FALSE
			Wyvern
				icon_state = "wyvern"
				level = 650
			Basilisk
				icon_state = "basilisk"
				level = 2000
				HPmodifier = 4
				DMGmodifier = 3
				MoveDelay = 3
				Range = 16
				respawnTime = 6000

				New()
					..()
					transform *= 2

				drops = list("2"    = /obj/items/key/pentakill_key,
							 "10"   = list(/obj/items/artifact,
										   /obj/items/wearable/title/Petrified,
										   /obj/items/crystal/soul,
										   /obj/items/crystal/magic,
						     			   /obj/items/crystal/strong_luck),
							 "15"   = list(/obj/items/artifact,
										   /obj/items/crystal/damage,
										   /obj/items/crystal/defense,
						     			   /obj/items/crystal/luck),
							 "30"   = list(/obj/items/DarknessPowder,
								 		   /obj/items/Whoopie_Cushion,
										   /obj/items/U_No_Poo,
							 			   /obj/items/Smoke_Pellet,
							 			   /obj/items/Tube_of_fun,
							 			   /obj/items/Swamp))

				var/tmp/fired = 0

				Blocked()
					density = 0
					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						..()
					density = 1

				Attack()
					..()

					if(!fired && target)
						var/d = get_dir(src, target)
						if(!(d & (d - 1)))

							fired = 1
							spawn(rand(50,150)) fired = 0

							var/mob/M = target
							M.movable    = 1
							M.icon_state = "stone"
							M.overlays = null
							spawn(rand(10,30))
								if(M && M.movable)
									M.movable    = 0
									M.icon_state = ""
									M:ApplyOverlays()

				Death(mob/Player/killer)
					..(killer)

					var/obj/Hogwarts_Door/gate/door = locate("CoSLockDoor")
					if(door)
						door.door = 1

						var/obj/teleport/portkey/t = new (loc)
						t.dest = "CoSFloor2"

						spawn(respawnTime)
							door.door = 0
							t.loc = null

						spawn(2)
							t.density = 1
							step_rand(t)
							t.density = 0

mob
	Stickman_
		icon = 'Mobs.dmi'
		icon_state = "stickman"
		gold = 0
		HP = 50
		MHP = 50
		Def=0
		player = 0
		Dmg = 50
		see_invisible = 1
		Expg = 10
		level = 2
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(5,10))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(10)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			if(!M)
				spawn()Wander()
				return
			var/dmg = Dmg+rand(0,20)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s sticky stick-ness doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] sticks [M] with a stick and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)

	Slug
		icon='Mobs.dmi'
		icon_state="slug"
		monster=1
		see_invisible = 1
		HP=25
		gold=0
		player=0
		New()
			move()
			..()
		proc/move()
			spawn(5)
				while(src)
					walk_rand(src,15)
					sleep(100)
					del src
			..()