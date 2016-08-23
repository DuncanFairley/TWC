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
	demon_rat/icon_state = "rat"
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


WorldData
	var
		eyesKilled = 0
		list/areaData

obj
	eye_counter
		var/marks     = 0
		maptext_width = 64
		pixel_x       = 8

		New()
			..()
			tag = "EyeCounter"
			spawn(1)
				maptext = "<b><span style=\"font-size:4; color:#FF4500;\">[worldData.eyesKilled]</span></b>"

		proc
			add()
				worldData.eyesKilled++
				if(worldData.eyesKilled >= 1000)
					worldData.eyesKilled = 0
					marks++
					. = 1
				updateDisplay()

			updateDisplay()
				if(worldData.eyesKilled >= 100)
					pixel_x = -5
				else if(worldData.eyesKilled >= 10)
					pixel_x = -4
				else
					pixel_x = 8

				maptext = "<b><span style=\"font-size:4; color:#FF4500;\">[worldData.eyesKilled]</span></b>"


AreaData
	var
		count
		rep
		guild

		tmp/list/killedBy

	New(count, rep)
		..()
		src.count = count
		src.rep   = rep

	proc
		sort()
			if(killedBy)
				var/winner = killedBy[1]

				if(killedBy.len > 1)
					for(var/i = 2 to killedBy.len)
						var/who = killedBy[i]
						if(killedBy[who] > killedBy[winner])
							winner = who

				guild = winner
				killedBy = null



		add(guildName)

			if(!killedBy) killedBy = list()

			if(guildName in killedBy)
				killedBy[guildName]++
			else
				killedBy[guildName] = 1
obj
	countdown
		var/marks      = 0
		maptext_width  = 128
		maptext_height = 128
		pixel_x        = 8
		layer          = 11
		maptext_y      = 32

		New()
			..()
			if(!istype(loc.loc, /area/newareas)) return

			var/area/newareas/a = loc.loc

			tag = "area_[a.name]"

			spawn(1)

				if(!worldData.areaData) worldData.areaData = list()

				var/AreaData/data = worldData.areaData[tag]
				if(!data)
					data = new(500, prob(50) ? 1 : -1)
					worldData.areaData[tag] = data

				data.rep = -data.rep
				Completed()
				updateDisplay()

		proc
			Completed()
				var/area/newareas/a = loc.loc
				var/AreaData/data = worldData.areaData[tag]

				data.rep = -data.rep
				a.faction()

				for(var/mob/NPC/Enemies/Vampire/v in a)
					v.rep = abs(v.rep) * data.rep
					v.faction()



			add(c = 1, guild)
				var/AreaData/data = worldData.areaData[tag]
				data.count--

				if(guild)
					data.add(guild)

				if(data.count <= 0)
					data.count = 500
					marks++
					Completed()

					data.sort()

					. = 1
				updateDisplay()

			updateDisplay()
				var/AreaData/data = worldData.areaData[tag]
				if(data.count >= 100)
					pixel_x = -5
				else if(data.count >= 10)
					pixel_x = -4
				else
					pixel_x = 8

				maptext  = "<span style=\"font-size:4; color:#FF4500;\"><b>[data.count]</b></span>"
				overlays = list()
				if(data.guild)
					var/image/i      = new

					var/guild/g = worldData.guilds[data.guild]

					i.maptext        = "<span style=\"font-size:3; color:#FF4500;\">[g.name]</span>"
					i.maptext_width  = maptext_width
					i.maptext_height = maptext_height
					i.maptext_x      = -16

					overlays += i


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
	outside
		Spider_Pit
			icon       = 'black50.dmi'
			icon_state = "white"
			antiTeleport = 1

	newareas
		var/tmp
			active = 0

		proc/faction()
			var/AreaData/data = worldData.areaData["area_[name]"]
			if(data && icon)
				var/c = data.rep > 0 ? "#600606" : "#0cf"

				if(region && region.areas)
					for(var/area/a in region.areas)
						if(!a.icon) continue
						animate(a, color = c, time = 20)

					for(var/node in region.nodes)
						var/turf/t = locate(region.nodes[node])
						if(!t) break

						for(var/area/a in orange(1, t))
							if(a == src || a == t.loc) continue

							if(a.icon)
								animate(a, color = c, time = 20)

							break

		outside
			Forbidden_ForestNE
			Forbidden_ForestNW
			Forbidden_ForestSE
			Forbidden_ForestSW
			Quidditch
				icon         = 'black50.dmi'
				icon_state   = "white"
				antiTeleport = 1
			Spider_Pit
				icon         = 'black50.dmi'
				icon_state   = "white"
				antiTeleport = 1

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
			if(!active && isplayer(O))
				active = 1
				for(var/mob/NPC/Enemies/M in src)
					if(M.state == M.WANDER || M.state == M.INACTIVE)
						M.ChangeState(M.SEARCH)

		Exited(atom/movable/O)
			. = ..()
			if(active && isplayer(O))
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
		var/HPmodifier = 1
		var/DMGmodifier = 0.6
		var/list/drops
		var/tmp/turf/origloc

		Enemies
			appearance_flags = LONG_GLIDE|TILE_BOUND
			post_init = 1
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
				MoveDelay     = 4
				AttackDelay   = 4
				respawnTime   = 1200

				prizePoolSize = 1
				damageReq     = 15

				iconSize      = 1

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

			MapInit()
				set waitfor = 0
				calcStats()
				origloc = loc
				ShouldIBeActive()


			proc/calcStats()
				Dmg = round(DMGmodifier * ((src.level -1) + 5))
				MHP = round(HPmodifier * (4 * (src.level - 1) + 200))
				gold = round(src.level / 2)
				Expg = round(src.level * 5)
				HP = MHP
//NEWMONSTERS

			proc/SpawnPet(mob/Player/killer, chance, defaultColor, spawnType)
				if(!origloc) return
				if(color == "#dd0000")
					if(defaultColor == "rand")
						var/color1 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
						var/color2 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
						var/color3 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))

						animate(src, color = color1, time = 10, loop = -1)
						animate(color = color2, time = 10)
						animate(color = color3, time = 10)
					else
						color = defaultColor

					var/StatusEffect/Potions/Luck/l = killer.findStatusEffect(/StatusEffect/Potions/Luck)
					if(l)
						chance *= l.factor
					else
						var/StatusEffect/Potions/Tame/t = killer.findStatusEffect(/StatusEffect/Potions/Tame)
						if(t)
							chance *= t

					if(prob(chance * 10))
						var/obj/items/wearable/w = new spawnType (loc)
						w.prizeDrop(killer.ckey, 300)
				else
					if(killer.findStatusEffect(/StatusEffect/Lamps/Farming))
						chance *= 4

					if(prob(chance))
						if(defaultColor == "rand")
							animate(src)

						color = "#d00"

			proc/Death(mob/Player/killer)
				if(state == INACTIVE || state == WANDER) return
				state = INACTIVE

				if(!killer) return

				if(canBleed)
					new /obj/corpse(loc, src)

				var/rate        = 1
				var/rate_factor = DropRateModifier

				if(killer.House == worldData.housecupwinner)
					rate += 0.25

				rate += killer.getGuildAreas() * 0.05

				var/StatusEffect/Lamps/DropRate/d = killer.findStatusEffect(/StatusEffect/Lamps/DropRate)
				if(d)
					rate_factor *= d.rate

				var/StatusEffect/Potions/Luck/l = killer.findStatusEffect(/StatusEffect/Potions/Luck)
				if(l)
					rate_factor *= l.factor

				rate *= rate_factor

				var/obj/items/prize

				var/list/possible_drops = istext(drops)	? drops_list[drops] : drops

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
					t.prizeDrop(killer.ckey, protection=150, decay=FALSE)

				if(prize)

					if(prizePoolSize > 1 && damage && damage.len > 1)
						if(!(killer.ckey in damage) || damage[killer.ckey] < damageReq)
							damage[killer.ckey] = damageReq

						bubblesort_by_value(damage)

						var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						for(var/i = damage.len to max(1 + damage.len - prizePoolSize, 1) step -1)
							if(damage[i] == "" || damage[i] == null) continue
							if(damage[damage[i]] < damageReq) break

							var/obj/items/item = new prize (loc)
							item.prizeDrop(damage[i], 602)

							var/randomDir
							if(dirs.len)
								randomDir = pick(dirs)
								dirs -= randomDir

							spawn(2)
								if(randomDir)
									step(item, randomDir)
					else
						prize = new prize (loc)
						prize.prizeDrop(killer.ckey, protection=150, decay=FALSE)
				damage = null

			proc/state()
				set waitfor = 0
				if(active) return
				active = 1
				while(src.loc && state != 0)
					switch(state)
						if(WANDER)
							step_rand(src)
						if(SEARCH)
							Search()
						if(HOSTILE)
							Attack()
						if(CONTROLLED)
							BlindAttack()
					sleep(lag)
				active = 0
			var/tmp
				mob/Player/target
				blockCount = 0
				lag = 10


			proc
				ChangeState(var/i_State)
					state = i_State

					if(state != 0)
						switch(state)
							if(WANDER)     lag = 10
							if(SEARCH)     lag = 10
							if(HOSTILE)    lag = max(MoveDelay, 1)
							if(CONTROLLED) lag = 12

						glide_size = 32/lag


						state()

				Search()
					step_rand(src)
					for(var/mob/Player/M in ohearers(src, Range))
						if(M.loc.loc != src.loc.loc) continue
						if(ignore && (M in ignore)) continue

						if(!isPathBlocked(M, src, 1, src.density))
							target = M
							ChangeState(HOSTILE)
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

				Ignore(mob/M)
					set waitfor = 0
					if(!ignore) ignore = list()
					ignore += M
					sleep(50)
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
				blockCount++
				if(blockCount > 10)
					target = null
					ShouldIBeActive()

			proc/Kill(mob/Player/p)
				set waitfor = 0
				p.Death_Check(src)

			proc/Attack()

				if(prob(20))
					step_rand(src)
					sleep(lag)

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
						blockCount = 0
						Move(t)
					else
						Blocked()
				else
					var/dmg = Dmg + extraDmg + rand(0, 12)

					if(target.level > level && !target.findStatusEffect(/StatusEffect/Lamps/Farming))
						dmg -= dmg * ((target.level - (level + 1))/150)
					else if(target.level < level)
						dmg += dmg * ((1 + level - target.level)/200)
					dmg = round(dmg)

					if(dmg<1)
						//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
					else
						target.HP -= dmg
						target.updateHPMP()
						hearers(target)<<"<SPAN STYLE='color: red'>[src] attacks [target] and causes [dmg] damage!</SPAN>"
						if(target.HP <= 0)
							Kill(target)
					sleep(AttackDelay)


//////Monsters///////

			Summoned
				state = SEARCH
				MapInit()
					set waitfor = 0
					calcStats()
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
					icon = 'Mobs_128x128.dmi'
					iconSize = 4
					pixel_x = -48
					pixel_y = -48
					name = "Tiny Spider"
					icon_state = "spider"
					level = 700
					MoveDelay = 1
					AttackDelay = 3
					Range = 20
					HPmodifier = 1.3
					DMGmodifier = 0.7

					Death()
						emit(loc    = loc,
							 ptype  = /obj/particle/fluid/blood,
						     amount = 25,
						     angle  = new /Random(0, 360),
						     speed  = 5,
						     life   = new /Random(1,10))

					MapInit()
						set waitfor = 0
						..()

						SetSize(rand(5,15) / 10)

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
						step_rand(src)
						for(var/mob/Player/M in ohearers(src, Range))
							if(M.loc.loc != src.loc.loc) continue
							if(M.Immortal && M.admin) continue

							target = M
							ChangeState(HOSTILE)

							spawn()
								var/time = 5
								while(src && state == HOSTILE && M == target && time > 0)
									sleep(30)
									time--

								if(M == target && state == HOSTILE)
									target = null
									ChangeState(SEARCH)

							break

					ChangeTarget()
						var/min_dist = Range
						for(var/mob/Player/M in ohearers(src, Range))
							if(M.Immortal) continue
							if(M.loc.loc != src.loc.loc) continue
							if(ignore && (M in ignore)) continue

							if(!isPathBlocked(M, src, 1, src.density))
								var/dist = get_dist(src, M)
								if(min_dist > dist)
									target = M
							else
								Ignore(M)

					Basilisk
						icon = 'Mobs_128x128.dmi'
						iconSize = 4
						icon_state = "basilisk"
						name = "Mini Basilisk"
						HPmodifier = 3
						DMGmodifier = 3
						MoveDelay = 3
						level = 2000

						Search()
							step_rand(src)
							for(var/mob/Player/M in ohearers(src, Range))
								if(M.loc.loc != src.loc.loc) continue
								if(M.Immortal) continue

								target = M
								ChangeState(HOSTILE)

								spawn()
									var/time = 5
									while(src && state == HOSTILE && M == target && time > 0)
										sleep(30)
										time--

									if(M == target && state == HOSTILE)
										target = null
										ChangeState(SEARCH)

								break

						Death()

					Acromantula
						icon = 'Mobs_128x128.dmi'
						iconSize = 4
						pixel_x = -48
						pixel_y = -48
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

						MapInit()
							set waitfor = 0
							..()
							SetSize(5 + (rand(-10, 10) / 10))

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

					Ghost
						name = "Vengeful Ghost"
						icon = 'NPCs.dmi'
						HPmodifier = 1.9
						DMGmodifier = 0.8
						layer = 5
						MoveDelay = 2
						AttackDelay = 3
						Range = 15
						level = 850
						canBleed = FALSE
						prizePoolSize = 1

						MapInit()
							set waitfor = 0
							..()

							if(prob(51))
								icon   = 'FemaleStaff.dmi'
								gender = FEMALE
							else
								icon   = 'MaleStaff.dmi'
								gender = MALE

							GenerateIcon(src)

							alpha = rand(100,180)

							animate(src, color = "#f55", pixel_y = 2,  time = 6, loop = -1)
							animate(     color = "#f55", pixel_y = 0,  time = 6)
							animate(     color = null,   pixel_y = -2, time = 6)

						Attacked(obj/projectile/p)

							if(p.owner && isplayer(p.owner) && p.owner.loc.loc == loc.loc)

								if(prob(40))
									var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
									while(dirs.len)
										var/d = pick(dirs)
										dirs -= d
										var/turf/t = get_step(p.owner, d)
										if(t && t.loc == loc.loc)
											target = p.owner
											loc    = t
											break

							if(p.icon_state == "gum" || (p.icon_state == "blood" && prob(70)))
								..()
								emit(loc    = src,
									 ptype  = /obj/particle/red,
								     amount = 2,
								     angle  = new /Random(1, 359),
								     speed  = 2,
								     life   = new /Random(15,20))
							else
								emit(loc    = src,
									 ptype  = /obj/particle/green,
								     amount = 2,
								     angle  = new /Random(1, 359),
								     speed  = 2,
								     life   = new /Random(15,20))


					VampireLord
						name = "Vampire Lord"
						icon = 'FemaleVampire.dmi'
						icon_state = "flying"
						HPmodifier = 8
						DMGmodifier = 3
						MoveDelay = 2
						AttackDelay = 0
						Range = 15
						level = 1600

						var/tmp/fired = 0

						MapInit()
							set waitfor = 0
							..()

							if(prob(49))
								icon   = 'MaleVampire.dmi'
								gender = MALE
							else
								gender = FEMALE

							GenerateIcon(src)

							var/image/i = new('VampireWings.dmi', "flying")
							i.layer = FLOAT_LAYER - 3
							i.pixel_x = -16
							i.pixel_y = -16
							i.color   = rgb(rand(0,255), rand(0,255), rand(0,255))

							overlays += i

							animate(src, pixel_y = pixel_y,      time = 2, loop = -1)
							animate(     pixel_y = pixel_y + 1,  time = 2)
							animate(     pixel_y = pixel_y,      time = 2)
							animate(     pixel_y = pixel_y - 1,  time = 2)

						Attack(mob/M)
							..()
							if(!fired && target && state == HOSTILE)
								fired = 1
								spawn(30) fired = 0

								if(prob(25))

									var/hp = 0

									for(var/mob/Player/p in oview(9, src))
										hp++
										emit(loc    = p.loc,
											 ptype  = /obj/particle/fluid/blood,
										     amount = 60,
										     angle  = new /Random(get_angle(src, p) + 95, get_angle(src, p) + 85),
										     speed  = 6,
										     life   = new /Random(1,50))

										p << errormsg("[name] fed on your blood.")

										p.HP -= 1500
										p.Death_Check(src)

									HP += hp * 250
									if(HP > MHP)
										HP = MHP

								else

									for(var/obj/redroses/S in oview(3, src))
										flick("burning", S)
										spawn(8) S.loc = null


									var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
									var/tmp_d = dir
									for(var/d in dirs)
										dir = d
										castproj(Type = /obj/projectile/Blood, icon_state = "blood", damage = Dmg + rand(-4,8), name = "Cruor", cd = 0, lag = 1)
									dir = tmp_d
									sleep(AttackDelay)

						Attacked(obj/projectile/p)

							if(p.owner && isplayer(p.owner) && p.owner.loc.loc == loc.loc)

								if(prob(55))
									var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
									while(dirs.len)
										var/d = pick(dirs)
										dirs -= d
										var/turf/t = get_step(p.owner, d)
										if(t.loc == loc.loc)
											target = p.owner
											loc    = t
											break
								else if(MoveDelay == 2 && prob(45))
									MoveDelay = 1
									ChangeState(state)
									spawn(rand(40,60))
										MoveDelay = 2
										ChangeState(state)

							p.damage = round(p.damage * rand(5, 10)/10)

							..()

						Death()
							emit(loc    = loc,
								 ptype  = /obj/particle/fluid/blood,
							     amount = 60,
							     angle  = new /Random(0, 360),
							     speed  = 4,
							     life   = new /Random(1,25))
							..()


					Wisp
						icon = 'Mobs_128x128.dmi'
						iconSize = 4
						pixel_x = -48
						pixel_y = -48
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

						MapInit()
							set waitfor = 0
							..()
							alpha = rand(190,240)

							var/color1 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
							var/color2 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
							var/color3 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))

							animate(src, color = color1, time = 10, loop = -1)
							animate(color = color2, time = 10)
							animate(color = color3, time = 10)

							SetSize(3 + (rand(-10, 10) / 10))

							spawn()
								while(src.loc)
									proj = pick(list("gum", "quake", "iceball","fireball", "aqua", "black") - proj)
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
										if("aqua")
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
							if(p.icon_state == proj || (p.icon_state == "blood" && prob(65)))
								..()
								emit(loc    = src,
									 ptype  = /obj/particle/red,
								     amount = 2,
								     angle  = new /Random(1, 359),
								     speed  = 2,
								     life   = new /Random(15,20))
							else
								emit(loc    = src,
									 ptype  = /obj/particle/green,
								     amount = 2,
								     angle  = new /Random(1, 359),
								     speed  = 2,
								     life   = new /Random(15,20))


					Golem
						icon = 'Mobs_128x128.dmi'
						icon_state = "golem"
						iconSize = 4
						pixel_x = -48
						pixel_y = -24
						name = "Stone Golem"
						HPmodifier = 9
						DMGmodifier = 2
						layer = 5
						MoveDelay = 2
						AttackDelay = 1
						Range = 15
						level = 1800
						canBleed = FALSE
						var/tmp/fired = 0

						Attack(mob/M)
							..()
							if(!fired && target && state == HOSTILE)
								fired = 1
								spawn(rand(18,38)) fired = 0

								var/r = rand(3,8)
								var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								var/tmp_d = dir

								for(var/i = 1 to r)
									dir = pick(dirs)
									dirs -= dir
									castproj(Type = /obj/projectile/Grav, icon_state = "grav", name = "Gravitate", cd = 0, lag = 1)
								dir = tmp_d
								sleep(AttackDelay)

						Attacked(obj/projectile/p)
							if(p.icon_state == "iceball" || p.icon_state == "aqua" || (p.icon_state == "blood" && prob(60)))
								..()
								emit(loc    = src,
									 ptype  = /obj/particle/red,
								     amount = 2,
								     angle  = new /Random(1, 359),
								     speed  = 2,
								     life   = new /Random(15,20))
							else
								emit(loc    = src,
									 ptype  = /obj/particle/green,
								     amount = 2,
								     angle  = new /Random(1, 359),
								     speed  = 2,
								     life   = new /Random(15,20))

						Death(mob/Player/killer)
							if(killer)
								worldData.elderWand = killer.ckey
								Players << infomsg("Stone Golem was defeated and the elder wand's magic power was harnessed by <b>[killer.name]</b> ")
							..()

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
						element = WATER

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
									ChangeState(state)
								else if(percent <= 60)
									AttackDelay = 1
								else if(percent <= 80)
									MoveDelay = 2
									ChangeState(state)

					Stickman
						icon_state = "stickman"
						name = "Mini Stickman"
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
						step_rand(src)
						sleep(3)
						Heal()

					proc
						Heal()
							for(var/mob/Player/M in ohearers(3, src))
								M.HP += round((M.MHP/100) + rand(-10, 10))
								if(M.HP > M.MHP) M.HP = M.MHP
								M.updateHPMP()
					BlindAttack()//removeoMob
						Heal()

					MapInit()
						set waitfor = 0
						light(src, 3, 600, "orange")
						..()


			Stickman
				icon = 'Mobs_128x128.dmi'
				iconSize = 4
				pixel_x = -48
				pixel_y = -48
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

				MapInit()
					set waitfor = 0
					..()
					SetSize(2)

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

				Kill(mob/Player/p)
					set waitfor = 0
					..(p)

					sleep(1)

					var/hudobj/teleport/t = new (null, p.client, null, show=1)
					t.dest = "CoSBoss2Out"
					p << errormsg("Click the teleport stone on screen button at the bottom right to go back to the Stickman.")

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
				level = 50
				HPmodifier = 0.2
				DMGmodifier = 0.1

				Death(mob/Player/killer)
					..()

					SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/rat)


			Demon_Rat
				icon_state = "rat"
				level = 700

				Death(mob/Player/killer)
					..()

					SpawnPet(killer, 0.5, null, /obj/items/wearable/pets/rat)

			Pixie
				icon_state = "pixie"
				level = 100
				HPmodifier = 0.75
				DMGmodifier = 0.40

				Death(mob/Player/killer)
					..()

					SpawnPet(killer, 0.4, null, /obj/items/wearable/pets/pixie)

			Dog
				icon_state = "dog"
				level = 150
				HPmodifier = 0.8
				DMGmodifier = 0.45

				Death(mob/Player/killer)
					..()

					SpawnPet(killer, 0.3, null, /obj/items/wearable/pets/dog)

			Snake
				icon_state = "snake"
				level = 200

				Death(mob/Player/killer)
					..()

					SpawnPet(killer, 0.2, null, /obj/items/wearable/pets/snake)

			Wolf
				icon_state = "wolf"
				level = 300

				Death(mob/Player/killer)
					..()

					SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/wolf)

			Snowman
				icon = 'Snowman.dmi'
				level = 700
				HPmodifier  = 3
				DMGmodifier = 1
				MoveDelay = 4
				AttackDelay = 3
				respawnTime = 1800
				element = WATER

			Acromantula
				icon = 'Mobs_128x128.dmi'
				iconSize = 4
				pixel_x = -48
				pixel_y = -48

				icon_state = "spider"
				level = 800
				MoveDelay = 3
				AttackDelay = 3

				HPmodifier = 1.6
				DMGmodifier = 0.6

				respawnTime = 1800

				ChangeState(var/i_State)
					set waitfor = FALSE

					..(i_State)

					if(i_State == WANDER && origloc && HP > 0)
						HP = MHP
						while(state == WANDER && get_dist(loc, origloc) > 2)
							var/i = step_to(src, origloc)
							if(!i) break
							sleep(1)

				Death(mob/Player/killer)
					emit(loc    = loc,
						 ptype  = /obj/particle/fluid/blood,
					     amount = 25,
					     angle  = new /Random(0, 360),
					     speed  = 5,
					     life   = new /Random(5,15))
					..()

					var/s = prob(45) ? 2 : 1
					for(var/i = 1 to s)
						new /mob/NPC/Enemies/Summoned/Acromantula (loc)


					SpawnPet(killer, 0.03, null, /obj/items/wearable/pets/acromantula)

				MapInit()
					set waitfor = 0
					..()

					SetSize(rand(15,30) / 10)

			Vampire
				icon = 'FemaleVampire.dmi'
				level = 850
				HPmodifier  = 1.8
				DMGmodifier = 0.6
				MoveDelay   = 2
				AttackDelay = 3
				respawnTime = 2400

				drops = "Vampire"

				var/rep = 2

				MapInit()
					set waitfor = 0
					..()
					if(prob(49))
						icon   = 'MaleVampire.dmi'
						gender = MALE
					else
						gender = FEMALE

					GenerateIcon(src)

				ShouldIBeActive()
					..()

					if(rep != 0)
						var/area/newareas/a = loc.loc
						if(!istype(a, /area/newareas)) return

						var/AreaData/data = worldData.areaData["area_[a.name]"]

						if(data && ((data.rep > 0 && rep > 0) || (data.rep < 0 && rep < 0)))
							rep    = -rep
							faction()

				proc/faction()
					if(rep < 0)
						name = "Peace Vampire"
					else if(rep > 0)
						name = "Chaos Vampire"
					else
						name = "Vampire"

				Death(mob/Player/killer)
					emit(loc    = loc,
					 ptype  = /obj/particle/fluid/blood,
					     amount = 25,
					     angle  = new /Random(0, 360),
					     speed  = 5,
					     life   = new /Random(1,10))

					if(killer)

						var/r = rep
						if(prob(52)) r /= 2

						killer.addRep(r)

						var/area/newareas/a = loc.loc
						if(a && istype(a, /area/newareas))
							var/obj/countdown/c = locate("area_[a.name]")

							if(c)
								c.add(1, killer.guild)

					..()

				Attacked(obj/projectile/p)
					p.damage = round(p.damage * rand(7, 10)/10)
					if(MoveDelay == 3 && p.owner && p.owner.loc.loc == loc.loc && prob(60))
						MoveDelay = 1
						ChangeState(state)
						spawn(80)
							MoveDelay = 2
							ChangeState(state)
					..()

				ChangeState(var/i_State)
					set waitfor = FALSE

					..(i_State)

					if(i_State == WANDER && origloc && HP > 0)
						HP = MHP
						while(state == WANDER && get_dist(loc, origloc) > 2)
							var/i = step_to(src, origloc)
							if(!i) break
							sleep(1)


			Wisp
				icon = 'Mobs_128x128.dmi'
				iconSize = 4
				pixel_x = -48
				pixel_y = -48

				icon_state = "wisp"
				level = 800

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
					if(p.icon_state == "gum" || (p.icon_state == "blood" && prob(75)))
						..()
						emit(loc    = src,
							 ptype  = /obj/particle/red,
						     amount = 2,
						     angle  = new /Random(1, 359),
						     speed  = 2,
						     life   = new /Random(15,20))
					else
						emit(loc    = src,
							 ptype  = /obj/particle/green,
						     amount = 2,
						     angle  = new /Random(1, 359),
						     speed  = 2,
						     life   = new /Random(15,20))

				MapInit()
					set waitfor = 0
					..()
					alpha = rand(190,255)

					var/color1 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
					var/color2 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
					var/color3 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))

					animate(src, color = color1, time = 10, loop = -1)
					animate(color = color2, time = 10)
					animate(color = color3, time = 10)

					SetSize(1 + (rand(-5,15) / 50)) // -10% to +30% size change

				Death(mob/Player/killer)
					..()

					SpawnPet(killer, 0.02, "rand", /obj/items/wearable/pets/wisp)


			Floating_Eye
				icon = 'Mobs_128x128.dmi'
				iconSize = 4
				pixel_x = -48
				pixel_y = -48

				icon_state = "eye1"
				level = 900
				HPmodifier  = 2
				DMGmodifier = 0.8
				var
					tmp/fired = 0
					Random/cd = new(30, 50)

				MoveDelay = 3
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

					MapInit()
						set waitfor = 0
						..()
						animate(src, color = rgb(255, 0, 0), time = 10, loop = -1)
						animate(color = rgb(255, 0, 255), time = 10)
						animate(color = rgb(rand(60,255), rand(60,255), rand(60,255)), time = 10)

						SetSize(3)
						origloc = null
				New()
					..()
					SetSize(1)
					icon_state = "eye[rand(1,2)]"
					if(prob(60))
						transform *= 1 + (rand(-15,30) / 50) // -30% to +60% size change

				Search()
					step_rand(src)
					for(var/mob/Player/M in ohearers(src, Range))
						if(M.loc.loc == src.loc.loc)
							target = M
							ChangeState(HOSTILE)
							break

				Death(mob/Player/killer)
					..()
					var/obj/eye_counter/count = locate("EyeCounter")
					if(count.add())
						Players << infomsg("The Eye of The Fallen has appeared somewhere in the desert!")
						new /mob/NPC/Enemies/Floating_Eye/Eye_of_The_Fallen (locate(rand(4,97),rand(4,97),rand(4,5)))

					SpawnPet(killer, 0.01, null, /obj/items/wearable/pets/floating_eye)

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
				icon = 'Mobs_128x128.dmi'
				iconSize = 4
				pixel_x = -48
				pixel_y = -48

				icon_state = "troll"
				level = 750
				HPmodifier  = 4
				DMGmodifier = 0.55
				MoveDelay   = 4
				AttackDelay = 3

				MapInit()
					set waitfor = 0
					..()
					SetSize(rand(10,20) / 10)

				Attack()
					var/p = 20
					for(var/mob/NPC/Enemies/m in oview(1, src))
						if(src == m) continue
						p += 15

					var/tmpdmg = extraDmg
					var/tmplvl = level
					if(prob(p))
						extraDmg = 1000
						level    = 1000
					..()
					extraDmg = tmpdmg
					level    = tmplvl

				Death(mob/Player/killer)
					..()

					SpawnPet(killer, 0.04, null, /obj/items/wearable/pets/troll)

			House_Elf
				icon_state = "houseelf"
				level = 5
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

				New()
					move()
				proc/move()
					set waitfor = 0
					walk_rand(src,15)

					sleep(100)
					walk(src, 0)
					loc = null
			Archangel
				icon_state = "archangel"
				level = 500
				element = EARTH
			Water_Elemental
				icon_state = "water elemental"
				level = 550
				canBleed = FALSE
				element = WATER
			Fire_Elemental
				icon_state = "fire elemental"
				level = 600
				canBleed = FALSE
				element = FIRE
			Wyvern
				icon_state = "wyvern"
				level = 650
			Basilisk
				icon = 'Mobs_128x128.dmi'
				iconSize = 4
				pixel_x = -48
				pixel_y = -48

				icon_state = "basilisk"
				level = 2000
				HPmodifier = 4
				DMGmodifier = 3
				MoveDelay = 3
				AttackDelay = 1
				Range = 16
				respawnTime = 6000

				prizePoolSize = 2

				ChangeState(var/i_State)
					..(i_State)

					if(state == 0 && origloc && HP > 0)
						loc = origloc

				MapInit()
					set waitfor = 0
					..()
					SetSize(2)

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

							var/mob/Player/M = target
							if(!M.trnsed)
								M:StateChange()
							else
								M.nomove = 1
							spawn(rand(10,30))
								if(M && M.nomove)
									if(!M.trnsed)
										M.StateChange()
										M.ApplyOverlays()
									else
										M.nomove = 0

				Kill(mob/Player/p)
					set waitfor = 0
					..(p)

					sleep(1)

					var/hudobj/teleport/t = new (null, p.client, null, show=1)
					t.dest = "CoSBasOut"
					p << errormsg("Click the teleport stone on screen button at the bottom right to go back to the Basilisk.")



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


obj/corpse
	New(Loc, mob/NPC/Enemies/monster)
		set waitfor = 0
		..()

		appearance = monster.appearance
		dir        = monster.dir
		layer      = 2

		var/matrix/m = transform
		m.Turn(90 * pick(1, -1))
		animate(src, transform = m, time = 10, easing = pick(BOUNCE_EASING, BACK_EASING))

		if(monster.level >= 1000)
			if(!monster.respawnTime)
				sleep(300)
			else
				sleep(monster.respawnTime / 2 + 10)
		else
			sleep(40)

		animate(src, alpha = 0, time = 10)
		sleep(10)
		loc = null