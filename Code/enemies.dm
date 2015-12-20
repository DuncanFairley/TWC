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

obj
	eye_counter
		var/count     = 0
		var/marks     = 0
		maptext_width = 64
		pixel_x       = 8

		New()
			..()
			tag = "EyeCounter"
			maptext = "<b><font size=4 color=#FF4500>0</font></b>"

		proc
			add()
				count++
				if(count >= 1000)
					count = 0
					marks++
					. = 1
				updateDisplay()

			updateDisplay()
				if(count >= 100)
					pixel_x = -5
				else if(count >= 10)
					pixel_x = -4
				else
					pixel_x = 8

				maptext = "<b><font size=4 color=#FF4500>[count]</font></b>"

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
			if(isplayer(O) && !active)
				active = 1
				for(var/mob/NPC/Enemies/M in src)
					if(M.state == M.WANDER || M.state == M.INACTIVE)
						M.ChangeState(M.SEARCH)

		Exited(atom/movable/O)
			. = ..()
			if(isplayer(O) && active)
				var/isempty = 1
				for(var/mob/Player/M in src)
					if(M != O)
						isempty = 0
						break
				if(isempty)
					active = 0
					for(var/mob/NPC/Enemies/M in src)
						if(M.state != M.INACTIVE)
							M.ChangeState(region ? M.WANDER : M.INACTIVE)

area/Exit(atom/movable/O, atom/newloc)
	.=..()

	if(istype(O, /mob/NPC/Enemies) && . && newloc && O:state)
		if(O:removeoMob)
			if(!issafezone(src) && issafezone(newloc.loc)) return 0
		else
			var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
			dirs -= O.dir

			. = 0
			while(dirs.len)
				var/d = pick(dirs)
				dirs -= d

				var/turf/t = get_step(O, d)
				if(t && t.loc == src)
					step(O, d)
					break


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
		var/active = 0
		var/HPmodifier = 0.9
		var/DMGmodifier = 0.55
		var/list/drops
		var/tmp/turf/origloc

		Enemies
			player = 0
			Gm = 1
			monster = 1
			NPC = 1

			var
				const
					INACTIVE   = 0
					WANDER     = 1
					SEARCH     = 2
					HOSTILE    = 4
					CONTROLLED = 8

				tmp
					state = INACTIVE
					list
						ignore
						damage

				Range         = 12
				MoveDelay     = 5
				AttackDelay   = 5
				respawnTime   = 1200

				prizePoolSize = 1
				damageReq     = 15

			Dispose()
				..()

				damage  = null
				origloc = null
				drops   = null
				state   = INACTIVE

			Attacked(obj/projectile/p)
				..()
				if(prizePoolSize > 1 && p.owner && p.damage && HP > 0)
					if(!damage) damage = list()

					var/perc = (p.damage / MHP) * 100

					if(p.owner.ckey in damage)
						damage[p.owner.ckey] += perc
					else
						damage[p.owner.ckey] = perc

			New()
				. = ..()
				spawn(1) // fix for monsters not setting their variables if loaded from swap maps
					calcStats()
					origloc = loc
					sleep(rand(10,60))
					ShouldIBeActive()


			proc/calcStats()
				Dmg = round(DMGmodifier * ((src.level -1) + 5))
				MHP = round(HPmodifier * (4 * (src.level - 1) + 200))
				gold = round(src.level / 2)
				Expg = round(src.level * 5)
				HP = MHP
//NEWMONSTERS
			proc/Death(mob/Player/killer)
				if(state == INACTIVE) return
				state = INACTIVE

				var/rate = 1

				if(killer.House == housecupwinner)
					rate += 0.25

				var/StatusEffect/Lamps/DropRate/d = killer.findStatusEffect(/StatusEffect/Lamps/DropRate)
				if(d)
					rate *= d.rate

				rate *= DropRateModifier

				var/obj/items/prize

				var/list/possible_drops = drops

				if(!possible_drops && name == initial(name))
					possible_drops = (name in drops_list) ? drops_list[name] : drops_list["default"]

				if(islist(possible_drops))
					for(var/i in possible_drops)
						var/chance = text2num(i)

						if(!chance)
							prize = pick(possible_drops)
							break
						else if(prob(chance * rate))
							var/t = islist(possible_drops[i]) ? pick(possible_drops[i]) : possible_drops[i]
							prize = t
							break
				else if(possible_drops)
					prize = possible_drops

				if(name == initial(name) && prob(0.1))
					var/obj/items/wearable/title/Slayer/t = new (loc)
					t.title = "[name] Slayer"
					t.name  = "Title: [name] Slayer"

					t.antiTheft = 1
					t.owner     = killer.ckey

					spawn(150)
						if(t)
							t.antiTheft = 0
							t.owner     = null

				if(prize)

					if(prizePoolSize > 1 && damage && damage.len > 1)
						if(!(killer.ckey in damage) || damage[killer.ckey] < damageReq)
							damage[killer.ckey] = damageReq

						bubblesort_by_value(damage)

						var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						for(var/i = damage.len to max(1 + damage.len - prizePoolSize, 1) step -1)
							if(damage[damage[i]] < damageReq) break

							var/obj/items/item = new prize (loc)

							item.antiTheft = 1
							item.owner     = damage[i]

							var/randomDir
							if(dirs.len)
								randomDir = pick(dirs)
								dirs -= randomDir

							spawn(2)
								if(randomDir)
									step(item, randomDir)

								sleep(600)
								if(item)
									item.antiTheft = 0
									item.owner     = null

					else
						prize = new prize (loc)

						prize.antiTheft = 1
						prize.owner     = killer.ckey
						spawn(150)
							if(prize)
								prize.antiTheft = 0
								prize.owner     = null

				damage = null

			proc/state()
				set waitfor = 0
				if(active) return
				active = 1
				while(src && src.loc && state != 0)
					switch(state)
						if(WANDER)
							Wander()
						if(SEARCH)
							Search()
						if(HOSTILE)
							Attack()
						if(CONTROLLED)
							BlindAttack()
					sleep(getStateLag(state))
				active = 0
			var/tmp/mob/target


			proc
				getStateLag(var/i_State)
					if(state == WANDER)   return 15
					if(state == SEARCH)   return 10
					if(state == HOSTILE)  return max(MoveDelay, 1)
					if(state == CONTROLLED) return 12
					return 1

				ChangeState(var/i_State)
					state = i_State

					if(state != 0)
						state()

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
				ChangeState(INACTIVE)
				if(loc.loc != origloc.loc)
					if(z == origloc.z)
						density = 0
						while(loc.loc != origloc.loc)
							var/t = get_step_towards(src, origloc)
							if(!t)
								loc = origloc
								break
							loc = get_step_towards(src, origloc)
							sleep(1)
						density = 1
					else
						src.loc = origloc
				ShouldIBeActive()

			proc/ShouldIBeActive()
				ChangeState(INACTIVE)
				if(!loc) return 0

				if(istype(loc.loc, /area/newareas))
					var/area/newareas/a = loc.loc

					if(a.active)
						ChangeState(SEARCH)
						return 1
					if(a.region && a.region.active)
						ChangeState(WANDER)

			proc/BlindAttack()//removeoMob
				for(var/mob/Player/p in range(1, src))
					if(p.loc.loc != loc.loc) continue

					var/dmg = Dmg+extraDmg+rand(0,4)
					if(dmg<1)
						//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
					else
						p.HP -= dmg
						hearers(p)<<"<SPAN STYLE='color: red'>[src] attacks [p] and causes [dmg] damage!</SPAN>"
						if(src.removeoMob)
							spawn() p.Death_Check(src.removeoMob)
						else
							spawn() p.Death_Check(src)
					break

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

					ChangeState(SEARCH)
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

				Acromantula
					icon_state = "spider"
					level = 700
					MoveDelay = 1
					AttackDelay = 3
					Range = 20
					HPmodifier = 1.4
					DMGmodifier = 0.8

					Death()
						emit(loc    = loc,
							 ptype  = /obj/particle/fluid/blood,
						     amount = 25,
						     angle  = new /Random(0, 360),
						     speed  = 5,
						     life   = new /Random(1,10))

				Blocked()
					density = 0
					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						..()
					density = 1

				Boss
					prizePoolSize = 3

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
									ChangeState(SEARCH)

							break

					Basilisk
						icon_state = "basilisk"
						HPmodifier = 3
						DMGmodifier = 3
						MoveDelay = 3
						level = 2000

						Death()

					Acromantula
						name = "Bubbles the Spider"
						icon_state = "spider"
						level = 1400
						HPmodifier = 12
						DMGmodifier = 4
						MoveDelay = 2
						AttackDelay = 0
						Range = 16
						var/tmp
							fired       = 0
							damageTaken = 0

						New()
							..()
							transform *= 5 + (rand(-10, 10) / 10)

						Attack(mob/M)
							..()
							if(!fired && target && state == HOSTILE)
								fired = 1
								spawn(rand(10,20)) fired = 0

								var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								var/tmp_d = dir
								for(var/d in dirs)
									dir = d
									castproj(icon_state = "quake", damage = Dmg + rand(-4,8), name = "rubble", cd = 0, lag = 1)
								dir = tmp_d
								sleep(AttackDelay)

						Attacked(obj/projectile/p)
							..()
							if(HP > 0)
								damageTaken += p.damage

								var/limit = 3
								while(damageTaken >= 1000 && limit)
									new /mob/NPC/Enemies/Summoned/Acromantula (loc)
									damageTaken -= 1000
									limit--

						Death()
							emit(loc    = loc,
								 ptype  = /obj/particle/fluid/blood,
							     amount = 100,
							     angle  = new /Random(0, 360),
							     speed  = 6,
							     life   = new /Random(1,25))
							..()


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
										castproj(icon_state = "fireball", damage = Dmg + rand(-4,8), name = "fire ball", cd = 0, lag = 1)
									dir = tmp_d
									sleep(AttackDelay)

						Attacked(obj/projectile/p)
							if(p.icon_state == proj && prob(99))
								..()
								emit(loc    = src,
									 ptype  = /obj/particle/red,
								     amount = 2,
								     angle  = new /Random(1, 359),
								     speed  = 2,
								     life   = new /Random(15,20))
							else
								HP += p.damage

								emit(loc    = src,
									 ptype  = /obj/particle/green,
								     amount = 2,
								     angle  = new /Random(1, 359),
								     speed  = 2,
								     life   = new /Random(15,20))

					Snowman
						icon = 'Snowman.dmi'
						name = "The Evil Snowman"
						HPmodifier = 12
						DMGmodifier = 0.8
						layer = 5
						MoveDelay = 3
						AttackDelay = 2
						Range = 15
						level = 1000
						var/tmp/fired = 0
						extraDmg = 400

						#ifdef HIDDEN
						Death(mob/Player/killer)
							var/obj/snow_counter/count = locate("SnowCounter")
							if(count.add(100))
								spawn()
									var/mob/NPC/Enemies/Summoned/Boss/Snowman/Super/s = new(loc)
									sleep(36000)
									s.Dispose()

								Players << infomsg("<b>The Super Evil Snowman has appeared outside, I hear he's so super evil that he gathered super rare items.</b>")
							..()
						#endif

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
										castproj(icon_state = "snowball", damage = dmg, name = "snowball", cd = 0, lag = 1)
									dir = tmp_d
									sleep(AttackDelay)
						Attacked()
							..()
							if(HP > 0)
								var/percent = MHP / HP
								var/matrix/M = matrix() * min(percent, 10)
								transform = M

								extraDmg = percent * 400

								percent = (1 / percent) * 100

								if(percent <= 30)
									MoveDelay = 1
								else if(percent <= 60)
									AttackDelay = 1
								else if(percent <= 80)
									MoveDelay = 2

					Stickman
						icon_state = "stickman"
						level = 500
						HPmodifier  = 1
						DMGmodifier = 1

						MoveDelay   = 3
						AttackDelay = 1

						var/tmp/fired = 0

						Death()


						BlindAttack()
							spawn()
								for(var/i = 1 to 3)
									castproj(icon_state = "gum", damage = Dmg + rand(-4,8), name = "Waddiwasi")
									sleep(4)

						Attack()
							if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,Range)))
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
							castproj(icon_state = "gum", damage = Dmg + rand(-4,8), name = "Waddiwasi")



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
				DMGmodifier = 1.3

				MoveDelay   = 2
				AttackDelay = 1

				prizePoolSize = 2

				var/tmp/fired = 0

				Range = 16
				respawnTime = 6000

				New()
					..()
					transform *= 2

				ChangeState(var/i_State)
					..(i_State)

					if(state == 0 && origloc && HP > 0)
						loc = origloc

				Attack()
					if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,Range)))
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
							castproj(icon_state = "fireball", damage = dmg, name = "Incindia", cd = 0, lag = 1)
						dir = tmp_d
					else
						dir=get_dir(src, target)
						if(AttackDelay)	sleep(AttackDelay)
						castproj(icon_state = "gum", damage = Dmg + rand(-4,8), name = "Waddiwasi")

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

							var/limit = 3
							while(istype(t.loc, /turf/water) && limit--)
								sleep(1)
								t.density = 1
								step_rand(t)
								t.density = 0


			Rat
				icon_state = "rat"
				level = 10
			Demon_Rat
				icon_state = "demon rat"
				level = 50
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
				respawnTime = 1800

				#ifdef HIDDEN
				Death(mob/Player/killer)
					var/obj/snow_counter/count = locate("SnowCounter")
					if(count.add(1))

						spawn()
							var/obj/spawner/spawn_loc = pick(spawners)

							var/mob/NPC/Enemies/Summoned/Boss/Snowman/Super/s = new(spawn_loc.loc)
							sleep(36000)
							s.Dispose()

						Players << infomsg("<b>The Super Evil Snowman has appeared outside, I hear he's so super evil that he gathered super rare items.</b>")
					..()
				#endif

			Wisp
				icon_state = "wisp"
				level = 750

				HPmodifier  = 1.4
				DMGmodifier = 0.8
				MoveDelay = 3
				canBleed = FALSE
				var/tmp/fired = 0

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
							castproj(icon_state = "fireball", damage = Dmg + rand(-4,8), name = "fire ball")
							sleep(AttackDelay)

				Attacked(obj/projectile/p)
					if(p.icon_state == "gum" && prob(95))
						..()
						emit(loc    = src,
							 ptype  = /obj/particle/red,
						     amount = 2,
						     angle  = new /Random(1, 359),
						     speed  = 2,
						     life   = new /Random(15,20))
					else
						HP += p.damage

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
					cd = new(3, 6)
					HPmodifier = 3.2

					prizePoolSize = 2

					Range     = 20
					MoveDelay = 2


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

						spawn(2) origloc = null
				New()
					..()
					icon_state = "eye[rand(1,2)]"
					if(prob(60))
						transform *= 1 + (rand(-15,30) / 50) // -30% to +60% size change

				Search()
					Wander()
					for(var/mob/Player/M in ohearers(src, Range))
						if(M.loc.loc == src.loc.loc)
							target = M
							state  = HOSTILE
							break

				Death()
					..()
					var/obj/eye_counter/count = locate("EyeCounter")
					if(count.add())
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
							var/tmp_d = dir
							if(fire == 1)
								var/dmg = round(Dmg * 1.5 + rand(-4,8))
								for(var/d in dirs)
									dir = d
									castproj(icon_state = "crucio2", damage = dmg, name = "death ball", cd = 0, lag = 1)
							else
								for(var/d in dirs)
									dir = d
									castproj(Type = /obj/projectile/Flippendo, icon_state = "flippendo", name = "Flippendo", cd = 0, lag = 1)

							dir = tmp_d

							sleep(AttackDelay)

			Troll
				icon_state = "troll"
				level = 350
				HPmodifier  = 3
				DMGmodifier = 0.8
				MoveDelay   = 4
				AttackDelay = 4

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

			Projectile
				var/tmp/fired = 0
				AttackDelay = 3

				Fire_Bat
					icon_state = "firebat"
					level = 400

				Fire_Golem
					icon_state = "firegolem"
					level = 450

				Attack()
					if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src, Range)))
						target = null
						ShouldIBeActive()
						return

					if(!fired && prob(80))
						fired = 1
						dir=get_dir(src, target)
						castproj(icon_state = "fireball", damage = Dmg + rand(-4,8), name = "fire ball")
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

				prizePoolSize = 2

				ChangeState(var/i_State)
					..(i_State)

					if(state == 0 && origloc && HP > 0)
						loc = origloc

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
							 "16"   = list(/obj/items/DarknessPowder,
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
							if(!M.trnsed)
								M:StateChange()
							else
								M.movable = 1
							spawn(rand(10,30))
								if(M && M.movable)
									if(!M.trnsed)
										M:StateChange()
										M:ApplyOverlays()
									else
										M.movable = 0

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