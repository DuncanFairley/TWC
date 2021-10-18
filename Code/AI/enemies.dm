/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */


area/var/safezoneoverride = 0

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

obj
	guildPillar
		maptext_height = 64
		maptext_y      = 32
		layer          = 11
		post_init      = 1
		density        = 1

		name = "Guild Conquest Pillar"

		icon       = 'clanpillar.dmi'
		icon_state = "Slyth"

		var
			HP = 100
			tmp/obj/healthbar/hpbar

		Attacked(obj/projectile/p)
			if(HP > 0 && p.owner && isplayer(p.owner))

				var/mob/Player/player = p.owner
				if(!player.guild) return

				flick("[icon_state]-V", src)

				HP--

				if(HP <= 0)
					var/AreaData/data = worldData.areaData[tag]
					data.guild = player.guild

					updateDisplay()
					respawn()
				else
					var/percent = HP / initial(HP)
					hpbar.Set(percent, src)


		MapInit()
			var/area/a = loc.loc

			tag = "area_[a.name]"

			icon_state = pick("Slyth","Huffle","Raven","Gryff")

			if(!worldData.areaData) worldData.areaData = list()

			var/AreaData/data = worldData.areaData[tag]
			if(!data)
				data = new
				worldData.areaData[tag] = data

			hpbar = new(src)

			updateDisplay()

		proc
			respawn()
				set waitfor = 0

				hpbar.loc = null
				hpbar = null

				var/obj/clock/timer = new(get_step(src, SOUTH))

				timer.setTime(6,0)

				var/isHours = 1
				while(!timer.countdown())

					if(isHours)
						if(timer.minutes == 0)
							isHours = 0
							timer.setTime(60,0)
							continue

						sleep(600)
					else
						sleep(10)

				timer.loc = null

				HP = initial(HP)
				hpbar = new(src)


			updateDisplay()
				var/AreaData/data = worldData.areaData[tag]
				if(data.guild)
					var/guild/g = worldData.guilds[data.guild]
					maptext = "<b style=\"font-size:3;color:#FF4500;\">[g.name]</b>"

					var/pixelsize = length(g.name) * 11
					maptext_width = pixelsize
					maptext_x     = -ceil(pixelsize/3)


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
		post_init      = 1

		MapInit()
			if(!istype(loc.loc, /area/newareas)) return

			var/area/newareas/a = loc.loc

			tag = "area_[a.name]"

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

				for(var/mob/Enemies/Vampire/v in a)
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
	var
		containsMonsters = 0
		tmp
			active = 0
	outside
		Spider_Pit
			icon       = 'black50.dmi'
			icon_state = "white"
			antiTeleport = 1
		Pixie_Pit

	newareas

		containsMonsters = 1

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
			Desert
				antiTeleport = TRUE
			Silverblood_Bats
			Silverblood_Golems
			Graveyard
			layer = 6	// set this layer above everything else so the overlay obscures everything

		inside
			Pixie_Pit
			Pumpkin_Pit
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

			Dungeon
				antiTeleport = FALSE
				antiFly      = TRUE
				SnowmmanEntrance
				Snowman
				SnowmanBoss
					antiTeleport = TRUE

		Entered(atom/movable/O)
			. = ..()

			if(isplayer(O) && ++active == 1)
				for(var/mob/Enemies/M in src)
					if(M.state == M.WANDER || M.state == M.INACTIVE)
						M.ChangeState(M.SEARCH)

		Exited(atom/movable/O)
			set waitfor = 0
			. = ..()
			sleep(1)
			if(isplayer(O) && active > 0)
				if(--active == 0)
					for(var/mob/Enemies/M in src)
						if(M.state != M.INACTIVE)
							if(!region)
								M.ChangeState(M.INACTIVE)
							else if(!M.target)
								M.ChangeState(M.WANDER)

area/Exit(atom/movable/O, atom/newloc)
	.=..()

	if(istype(O, /mob/Enemies) && . && newloc && O:state)
		var/mob/Enemies/e = O
		if(e.removeoMob)
			if(!issafezone(src) && issafezone(newloc.loc)) return 0
		else
			if(e.target)
				if(issafezone(newloc.loc))
					e.target = null
				else if(e.target.loc.loc == newloc.loc)
					return

			var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
			dirs -= e.dir

			. = 0
			while(dirs.len)
				var/d = pick(dirs)
				dirs -= d

				var/turf/t = get_step(e, d)
				if(t && t.loc == src)
					step(e, d)
					break


mob
	test
		verb
			View_Error_Log()
				src << browse(file("Logs/[VERSION].[SUB_VERSION]-log.txt"))
			Reconnect_MySQL()
				connected = my_connection.Connect(DBI,mysql_username,mysql_password)
				src << "New connection started."
mob
	Enemies
		icon = 'Mobs.dmi'
		see_invisible = 1
		var/active = 0
		var/HPmodifier = 1
		var/DMGmodifier = 0.6
		var/list/drops
		var/tmp/turf/origloc
		var/tmp/obj/healthbar/big/hpbar

		appearance_flags = LONG_GLIDE|TILE_BOUND|PIXEL_SCALE
		post_init = 1
		var
			const
				INACTIVE   = 0
				WANDER     = 1
				SEARCH     = 2
				HOSTILE    = 4
				CONTROLLED = 8
				AGGRO      = 16

			tmp
				state = INACTIVE
				list
					ignore
					damage

			Range         = 12
			MoveDelay     = 4
			AttackDelay   = 4
			respawnTime   = 600

			prizePoolSize = 1
			damageReq     = 15

			iconSize      = 1

			isElite       = 0

		Dispose()
			..()

			damage  = null
			origloc = null
			drops   = null
			state   = INACTIVE

			if(hpbar)
				hpbar.loc = null
				hpbar = null

		Attacked(obj/projectile/p)
			if(!isplayer(p.owner)) return
			if(!origloc && p.owner && p.owner.loc.loc != loc.loc) return

			..()
			if(prizePoolSize > 1 && p.owner && p.damage && HP > 0)
				if(!damage) damage = list()

				var/perc = (p.damage / MHP) * 100

				if(p.owner.ckey in damage)
					damage[p.owner.ckey] += perc
				else
					damage[p.owner.ckey] = perc

			if(HP > 0)

				if((state == WANDER || state == SEARCH) && p.owner)
					target = p.owner
					ChangeState(HOSTILE)

				if(hpbar)
					var/percent = HP / MHP
					hpbar.Set(percent, src)

		Move(NewLoc)
			if(hpbar)
				hpbar.glide_size = glide_size
				hpbar.loc = NewLoc
			.=..()

		MapInit()
			set waitfor = 0
			calcStats()
			origloc = loc

			if(isElite)
				SetSize(3)

				namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16)
				hpbar = new(src)

			ShouldIBeActive()


		proc/calcStats()
			Dmg = DMGmodifier * (    (src.level)  + 5)
			MHP = HPmodifier  * (4 * (src.level)  + 200)

			Dmg = round(Dmg * (rand(10,14)/10), 1)
			MHP = round(MHP * (rand(10,14)/10), 1)

			gold = round(src.level / 2)
			Expg = src.level * 6

			if(isElite)
				Dmg  *= 3
				MHP  *= 4
				gold *= 3
				Expg *= 3

			HP = MHP

//NEWMONSTERS

		proc/SpawnPet(mob/Player/killer, chance, defaultColor, spawnType)
			if(!origloc) return

			var/list/shinyList = SHINY_LIST
			var/isShiny = (color in shinyList) ? color : 0

			if(color == "#dd0000" || isShiny)
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
						chance *= t.factor

				if(isElite) chance *= 2

				if(prob(chance * 10))
					var/obj/items/wearable/pets/w = new spawnType (loc)
					if(isShiny)
						w.function |= PET_SHINY|PET_LIGHT
						w.color = isShiny
					w.prizeDrop(killer.ckey, 300)
			else
				if(killer.findStatusEffect(/StatusEffect/Lamps/Farming))
					chance *= 3

				if(prob(chance))
					if(defaultColor == "rand")
						animate(src)

					if(prob(1))
						color = pick(shinyList)
					else
						color = "#d00"

		proc/SpawnPortal(dest, var/obj/Hogwarts_Door/gate/door, chance = 100, lava=0, timer=0)
			set waitfor = 0

			if(isElite) chance *= 5

			if(prob(100 - chance)) return

			if(door)
				door = locate(door)
				if(door)
					door.door = 1

			var/turf/target = locate(dest)
			if(istype(target, /atom/movable)) target = target.loc

			var/obj/portkey/P1 = new(loc, 0, "portkey", respawnTime-50)
			var/obj/portkey/P2 = new(target, 0, "portkey", respawnTime-50)
			P1.partner = P2
			P2.partner = P1

			sleep(2)

			P1.density = 1
			step_rand(P1)

			if(lava)
				var/limit = 3
				while(istype(P1.loc, /turf/lava) && limit--)
					sleep(1)
					step_rand(P1)

			P1.density = 0

			if(timer)
				var/obj/clock/c = new(get_step(P1, SOUTH))

				var/min = round(respawnTime/600)
				var/sec = respawnTime - min*600

				c.setTime(min,sec)

				while(!c.countdown())
					sleep(10)

				c.loc = null
			else
				sleep(respawnTime-50)

			if(door) door.door = 0


		proc/Death(mob/Player/killer)
			if(state == INACTIVE || state == WANDER) return
			state = INACTIVE

			if(!killer || killer.Immortal) return

			if(canBleed)
				new /obj/corpse(loc, src)

			var/rate        = 1 + killer.dropRate/100
			var/rate_factor = worldData.DropRateModifier

			if(killer.House == worldData.housecupwinner)
				rate += 0.25

			if(killer.guild) rate += killer.getGuildAreas() * 0.05

			var/knowledge = monsterkills[name] + 1
			if(knowledge)
				rate += round(log(10, knowledge)) * 0.05

			var/StatusEffect/Lamps/DropRate/d = killer.findStatusEffect(/StatusEffect/Lamps/DropRate)
			if(d)
				rate_factor *= d.rate

			var/StatusEffect/Potions/Luck/l = killer.findStatusEffect(/StatusEffect/Potions/Luck)
			if(l)
				rate_factor *= l.factor

			var/sparks = isElite
			if(isElite)
				rate += 1
				var/obj/items/elite/e = new (loc)
				e.level = round(level/50)
				e.name  = "sword of might: level [e.level]"
				e.prizeDrop(killer.ckey, decay=1)
				killer << infomsg("<i>[name] dropped [e.name]</i>")

				if(killer.pet)
					killer.pet.fetch(e)

			rate *= rate_factor

			var/obj/items/prize

			var/list/possible_drops = istext(drops)	? drops_list[drops] : drops

			if(!possible_drops && name == initial(name))

				if(name in drops_list)
					possible_drops = drops_list[name]
				else
					possible_drops = drops_list["default"]

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
				if(isElite)
					t.title = "Elite [name] Slayer"
					t.name  = "Title: Elite [name] Slayer"
				else
					t.title = "[name] Slayer"
					t.name  = "Title: [name] Slayer"
				t.prizeDrop(killer.ckey, decay=FALSE)
				killer << infomsg("<i>[name] dropped [t.name]</i>")
				sparks = 1

				if(killer.pet)
					killer.pet.fetch(t)

			var/base = worldData.baseChance * clamp(1 + (level - killer.level) / 200, 0.1, 20) * clamp(level/200, 0.1, 20)
			if(level <= killer.level) base *= (level / 800) * 0.4

			if(prize)
				sparks = 1
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
					prize.prizeDrop(killer.ckey, decay=1)
					killer << infomsg("<i>[name] dropped [prize.name]</i>")
					if(killer.pet)
						killer.pet.fetch(prize)

			else if(prob(base*rate*3))
				sparks = 1
				prize = pickweight(list(/obj/items/crystal/defense = 1,
										/obj/items/crystal/damage  = 1,
										/obj/items/crystal/luck    = 1))

				prize = new prize (loc, round(level/50))
				prize.prizeDrop(killer.ckey, decay=1)
				killer << infomsg("<i>[name] dropped [prize.name]</i>")
				if(killer.pet)
					killer.pet.fetch(prize)

			if(prob(base * rate + killer.pity))
				sparks = 1
				prize = pick(drops_list["legendary"])
				prize = new prize (loc)
				prize.prizeDrop(killer.ckey, decay=1)
				killer << colormsg("<i>[name] dropped [prize.name]</i>", "#FFA500")
				killer.pity = 0

			if(sparks)
				emit(loc    = loc,
				 	 ptype  = /obj/particle/star,
				 	 amount = 3,
				 	 angle  = new /Random(0, 360),
				 	 speed  = 5,
				 	 life   = new /Random(4,8))
			else
				killer.pity += base/300

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
				set waitfor = 0

				state = i_State

				if(state != 0)
					switch(state)
						if(WANDER)
							lag    = 10
							target = null
						if(SEARCH)
							lag = 10
						if(HOSTILE)
							lag = max(MoveDelay, 1)
						if(CONTROLLED)
							target = null
							lag = 12

					glide_size = 32/lag

					state()
				else
					target = null
					if(loc && origloc && origloc.loc != loc.loc)
						loc = origloc

			Search()
				step_rand(src)
				for(var/mob/Player/M in ohearers(src, Range))
					if(M.loc.loc != src.loc.loc) continue
					if(M.Immortal) continue
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
					if(M.Immortal) continue
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
				sleep(30)
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
			if(!loc)
				ChangeState(INACTIVE)
				return 0

			if(origloc && loc.loc != origloc.loc)
				loc = origloc

			if(istype(loc.loc, /area/newareas))
				var/area/newareas/a = loc.loc

				if(a.active)
					ChangeState(SEARCH)
					return 1
				if(a.region && a.region.active)
					ChangeState(WANDER)
					return 0

			ChangeState(INACTIVE)


		proc/BlindAttack()//removeoMob
			for(var/mob/Player/p in range(1, src))
				if(p.loc.loc != loc.loc) continue

				var/dmg = Dmg+rand(0,4)
				if(dmg<1)
					//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
				else
					dmg = p.onDamage(dmg, src)
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

			var/active = 1
			if(origloc)
				var/area/newareas/a = origloc.loc
				if(istype(a, /area/newareas) && !a.active)
					if(a.region)
						active = a.region.active
					else
						active = 0

			var/distance = get_dist(src, target)
			if(!active || !target || !target.loc || distance > Range)
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
				var/dmg = Dmg + rand(0, 12)

				if(isElite || target.findStatusEffect(/StatusEffect/Lamps/Farming))
					dmg = dmg * (1 + abs(level - target.level)/200) + 100
				else
					if(target.level > level)
						dmg -= dmg * ((target.level - (level + 1))/150)
					else if(target.level < level)
						dmg += dmg * ((1 + level - target.level)/200)

				dmg = round(dmg - target.Slayer.level)

				if(target.animagusOn)
					dmg = dmg * 0.7 - target.Animagus.level

				if(dmg > 0)
					dmg = target.onDamage(dmg, src)
					if(target)
						if(target.MonsterMessages) hearers(target)<<"<SPAN STYLE='color: red'>[src] attacks [target] and causes [dmg] damage!</SPAN>"
						if(target.HP <= 0)
							Kill(target)
				else
					for(var/obj/summon/s in target.Summons)
						if(!s.target) s.target = src
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

			Slug
				icon_state = "slug"

				MapInit()
					set waitfor = 0
					walk_rand(src,15)

					sleep(100)
					walk(src, 0)
					loc = null
				BlindAttack()
				Death()

			Sword
				icon = 'Mobs_128x128.dmi'
				icon_state = "sword"
				iconSize = 4
				pixel_x = -48
				pixel_y = -24
				name = "Flying Sword"
				level = 800
				MoveDelay = 2
				AttackDelay = 5
				Range = 20
				HPmodifier = 1.5
				DMGmodifier = 0.8
				canBleed = FALSE
				var/tmp/obj/Shadow/s

				Death()
					if(s)
						s.loc = null
						s = null

					if("The Black Blade" in worldData.currentEvents)
						var/RandomEvent/Sword/e = locate() in worldData.events
						e.swords--
				Dispose()
					..()

					if(s)
						s.loc = null
						s = null

				MapInit()
					set waitfor = 0
					..()

					var/size = rand(10,30) / 10
					SetSize(size)

					s = new (loc)
					s.transform = matrix() * size

					animate(src, pixel_y = 0, time = 2, loop = -1)
					animate(pixel_y = 1, time = 2)
					animate(pixel_y = 0, time = 2)
					animate(pixel_y = -1, time = 2)


				Move(newLoc)
					if(s)
						s.glide_size = glide_size
						s.loc = newLoc
					..()

			Acromantula
				icon = 'Mobs.dmi'
				name = "Tiny Spider"
				icon_state = "spider"
				level = 700
				MoveDelay = 2
				AttackDelay = 5
				Range = 20
				HPmodifier = 2
				DMGmodifier = 1

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
					icon = 'Mobs.dmi'
					icon_state = "basilisk"
					name = "Mini Basilisk"
					HPmodifier = 3
					DMGmodifier = 3
					MoveDelay = 3
					level = 2000

					MapInit()
						set waitfor = 0
						..()
						SetSize(2)

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
					icon = 'Mobs.dmi'
					name = "Bubbles the Spider"
					icon_state = "spider"
					level = 2000
					HPmodifier = 20
					DMGmodifier = 4
					MoveDelay = 3
					AttackDelay = 1
					Range = 20
					var/tmp
						fired       = 0
						damageTaken = 0

					MapInit()
						set waitfor = 0
						..()
						SetSize(5 + (rand(-10, 10) / 10))

						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16)
						hpbar = new(src)

					Attack(mob/M)
						..()
						if(!fired && target && state == HOSTILE)
							fired = 1
							spawn(40) fired = 0

							var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
							for(var/d in dirs)
								castproj(icon_state = "quake", damage = Dmg, name = "rubble", cd = 0, lag = 1,Dir=d)
							sleep(AttackDelay)

					Attacked(obj/projectile/p)
						..()
						if(HP > 0)
							damageTaken += p.damage

							var/limit = 3
							var/threshold = max(MHP / 10, 2000)
							while(damageTaken >= threshold && limit)
								new /mob/Enemies/Summoned/Acromantula (loc)
								damageTaken -= threshold
								limit--

					Death()
						emit(loc    = loc,
							 ptype  = /obj/particle/fluid/blood,
							 amount = 100,
							 angle  = new /Random(0, 360),
							 speed  = 6,
							 life   = new /Random(1,25))
						..()

				Zombie
					name = "Zombie"
					HPmodifier = 20
					DMGmodifier = 2
					MoveDelay = 3
					AttackDelay = 3
					Range = 20
					level = 2000

					MapInit()
						set waitfor = 0
						..()

						if(prob(51))
							icon   = 'FemaleVampire.dmi'
							gender = FEMALE
						else
							icon   = 'MaleVampire.dmi'
							gender = MALE

						GenerateIcon(src)

						namefont.QuickName(src, "The [name]", "#eee", "#e00", top=1)
						hpbar = new(src)

					Attacked(obj/projectile/p)
						if(p.owner && isplayer(p.owner) && p.owner.loc.loc == loc.loc)
							if(MoveDelay == 3 && prob(30))
								MoveDelay = 1
								ChangeState(state)
								spawn(30)
									MoveDelay = 3
									ChangeState(state)

							if(p.icon_state == "blood")
								emit(loc    = src,
									 ptype  = /obj/particle/green,
									 amount = 2,
									 angle  = new /Random(1, 359),
									 speed  = 2,
									 life   = new /Random(15,20))
							else
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
					HPmodifier = 20
					DMGmodifier = 3
					MoveDelay = 3
					AttackDelay = 1
					Range = 20
					level = 2000

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

						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, px=0, py=2)
						hpbar = new(src)

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

									p.onDamage(1500, src)
									p.Death_Check(src)

								HP += hp * 250
								if(HP > MHP)
									HP = MHP

							else

								for(var/obj/redroses/S in oview(3, src))
									flick("burning", S)
									spawn(8) S.loc = null


								var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								for(var/d in dirs)
									castproj(Type = /obj/projectile/Blood, icon_state = "blood", damage = Dmg + rand(-4,8), name = "Cruor", cd = 0, lag = 1, Dir=d)
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
							else if(MoveDelay == 3 && prob(45))
								MoveDelay = 1
								ChangeState(state)
								spawn(rand(40,60))
									MoveDelay = 3
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
					icon = 'Mobs.dmi'
					icon_state = "wisp"
					name = "Willy the Whisp"
					HPmodifier = 20
					DMGmodifier = 2
					layer = 5
					MoveDelay = 3
					AttackDelay = 1
					Range = 15
					level = 2000
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

						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16)
						hpbar = new(src)

						while(loc)
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
							sleep(600)

					Attack(mob/M)
						..()
						if(!fired && target && state == HOSTILE)
							fired = 1
							spawn(40) fired = 0

							for(var/obj/redroses/S in oview(3, src))
								flick("burning", S)
								spawn(8) S.loc = null

							if(prob(80))
								var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								for(var/d in dirs)
									castproj(icon_state = "fireball", damage = Dmg + rand(-4,8), name = "fire ball", cd = 0, lag = 1,Dir=d)
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


				Sword
					icon = 'Mobs_128x128.dmi'
					icon_state = "sword"
					iconSize = 4
					pixel_x = -48
					pixel_y = -24
					name = "The Black Blade"
					HPmodifier = 20
					DMGmodifier = 3
					layer = 5
					MoveDelay = 3
					AttackDelay = 1
					Range = 20
					level = 2000
					canBleed = FALSE
					var/tmp
						fired = 0
						diag  = 0
						obj/Shadow/s

					Move(newLoc)
						if(s)
							s.glide_size = glide_size
							s.loc = newLoc
						..()

					MapInit()
						set waitfor = 0
						..()

						s = new (loc)
						s.transform = matrix() * 4

						SetSize(4)

						animate(src, pixel_y = 0, time = 2, loop = -1)
						animate(pixel_y = 1, time = 2)
						animate(pixel_y = 0, time = 2)
						animate(pixel_y = -1, time = 2)

						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16)
						hpbar = new(src)

						while(loc)

							icon_state = "shield"
							MoveDelay = 40
							ChangeState(state)
							reflect = 2

							var/spawns = 4
							while(loc && spawns > 0)
								spawns--

								if("The Black Blade" in worldData.currentEvents)
									var/RandomEvent/Sword/e = locate() in worldData.events

									if(e.swords < 30)
										e.swords+=2
										new /mob/Enemies/Summoned/Sword (loc)
										new /mob/Enemies/Summoned/Sword (loc)

								sleep(50)

							icon_state = "sword"
							reflect = 0
							MoveDelay = 3
							ChangeState(state)

							sleep(600)

					Attack(mob/M)
						..()

						if(!fired && target && state == HOSTILE && icon_state == "sword")
							fired = 1
							spawn(30) fired = 0

							var/list/dirs
							if(diag == 0)
								dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								diag = 1
							else if(diag == 1)
								dirs = list(NORTH, SOUTH, EAST, WEST)
								diag = 2
							else if(diag == 2)
								dirs = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
								diag = 0
							for(var/d in dirs)
								castproj(icon_state = "sword", name = "flying sword", cd = 0, lag = 1,Dir=d)

					Attacked(obj/projectile/p)
						if(icon_state == "shield" || p.icon_state == "blood")
							emit(loc    = src,
								 ptype  = /obj/particle/green,
								 amount = 2,
								 angle  = new /Random(1, 359),
								 speed  = 2,
								 life   = new /Random(15,20))
						else
							..()

					Death(mob/Player/killer)
						if(s)
							s.loc = null
							s = null
						..()


				Golem
					icon = 'Mobs_128x128.dmi'
					icon_state = "golem"
					iconSize = 4
					pixel_x = -48
					pixel_y = -24
					name = "Stone Golem"
					HPmodifier = 20
					DMGmodifier = 2
					layer = 5
					MoveDelay = 3
					AttackDelay = 1
					Range = 15
					level = 2000
					canBleed = FALSE
					var/tmp/fired = 0

					MapInit()
						set waitfor = 0
						..()
						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16)
						hpbar = new(src)

					Attack(mob/M)
						..()
						if(!fired && target && state == HOSTILE)
							fired = 1
							spawn(rand(18,38)) fired = 0

							var/r = rand(3,8)
							var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

							for(var/i = 1 to r)
								var/d = pick(dirs)
								dirs -= d
								castproj(Type = /obj/projectile/Grav, icon_state = "grav", name = "Gravitate", cd = 0, lag = 1, Dir=d)
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
					HPmodifier = 20
					DMGmodifier = 0.8
					layer = 5
					MoveDelay = 3
					AttackDelay = 1
					Range = 15
					level = 2000
					var/tmp
						fired = 0
						extraDmg = 400
					element = WATER

					MapInit()
						set waitfor = 0
						..()
						namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16)
						hpbar = new(src)

					Death()
						..()
						SpawnPortal("teleportPointSnowman Dungeon")

					Attack(mob/M)
						..()
						if(!fired && target && state == HOSTILE)
							fired = 1
							spawn(40) fired = 0

							var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
							var/dmg = round(Dmg * 1.5 + rand(-4,8))
							for(var/d in dirs)
								castproj(icon_state = "snowball", damage = dmg, name = "snowball", cd = 0, lag = 1, Dir=d)
							sleep(AttackDelay)

					Attacked()
						..()
						if(HP > 0)
							var/percent = MHP / HP
							var/matrix/M = matrix() * min(percent, 8)
							transform = M

							Dmg = DMGmodifier * (level + 5) + (percent * 400)

							percent = (1 / percent) * 100

							if(percent <= 50 && MoveDelay == 3)
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


		Stickman
			icon = 'Mobs.dmi'
			icon_state = "stickman"
			level = 2200
			HPmodifier  = 3
			DMGmodifier = 1.4

			MoveDelay   = 2
			AttackDelay = 0

			prizePoolSize = 2

			var/tmp/fired = 0

			Range = 16
			respawnTime = 6000

			drops = "duelist"

			MapInit()
				set waitfor = 0
				..()
				SetSize(2)

				namefont.QuickName(src, "The [name]", "#eee", "#e00", top=1, py=16)
				hpbar = new(src)

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

				if(prob(20) && !fired)
					fired = 1
					spawn(100) fired = 0
					var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
					var/tmp_d = dir
					var/dmg = round(Dmg * 0.8) + rand(-4, 12)
					for(var/d in dirs)
						dir = d
						castproj(icon_state = "fireball", damage = dmg, name = "Incindia", cd = 0, lag = 1)
					dir = tmp_d
				else
					dir=get_dir(src, target)
					if(AttackDelay)	sleep(AttackDelay)
					castproj(icon_state = "gum", damage = Dmg + rand(-4, 12), name = "Waddiwasi")

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

				SpawnPortal("teleportPointCoS Floor 3", "CoSBoss2LockDoor", lava=1, timer=1)


		Rat
			icon_state  = "rat"
			level       = 50
			HPmodifier  = 0.2
			DMGmodifier = 0.1

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.6, null, /obj/items/wearable/pets/rat)


		Demon_Rat
			icon_state = "rat"
			level = 700

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.9, null, /obj/items/wearable/pets/rat)
				SpawnPortal("teleportPointSnowman Dungeon", chance=1)

		Pixie
			icon_state  = "pixie"
			level       = 100
			HPmodifier  = 0.4
			DMGmodifier = 0.2

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.3, null, /obj/items/wearable/pets/pixie)

		Dog
			icon_state  = "dog"
			level       = 150
			HPmodifier  = 0.8
			DMGmodifier = 0.4

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/dog)

		Snake
			icon_state  = "snake"
			level       = 200

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/snake)

		Wolf
			icon_state  = "wolf"
			level       = 300

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.1, null, /obj/items/wearable/pets/wolf)

		Pumpkin
			icon = 'Mobs.dmi'
			icon_state  = "pumpkin"
			canBleed    = FALSE
			level       = 750
			HPmodifier  = 3
			DMGmodifier = 1
			MoveDelay = 3
			AttackDelay = 2


			Attacked()
				..()
				if(HP > 0)
					var/percent = 1 + (1 - HP / MHP) * 2
					percent = min(3, percent)
					percent = max(1, percent)
					animate(src, SetSize(percent), time = 5, easing = ELASTIC_EASING)

			Death(mob/Player/killer)
				..()

				var/rr = rand(40, 240)
				var/gg = rand(40, 240)
				var/bb = rand(40, 240)

				if(abs(rr - gg) < 20)      rr = 255 - gg

				emit(loc    = loc,
					 ptype  = /obj/particle/smoke/green,
					 amount = 10,
					 angle  = new /Random(1, 359),
					 speed  = 2,
					 life   = new /Random(15,25),
					 color  = rgb(rr,gg,bb))

				for(var/mob/Player/p in oview(src, 2))
					var/d =  round((p.MHP) * 0.2, 1) + rand(-100, 100)
					p << errormsg("The pumpkin's explosion hit you for [d] damage.")

					p.HP -= d

					if(p.HP <= 0)
						p.Death_Check(src)
					else
						p.updateHP()

				SpawnPet(killer, 0.05, null, /obj/items/wearable/pets/pumpkin)


		The_Good_Snowman
			icon_state = "snowman"
			level = 2400
			HPmodifier = 10
			DMGmodifier = 3
			MoveDelay = 3
			AttackDelay = 1
			Range = 24
			respawnTime = 6000
			prizePoolSize = 2

			element = WATER

			ChangeState(var/i_State)
				..(i_State)

				if(state == 0 && origloc && HP > 0)
					loc = origloc

			MapInit()
				set waitfor = 0
				..()
				SetSize(3)

				namefont.QuickName(src, name, "#eee", "#e00", top=1, py=16)

				hpbar = new(src)

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

				if(target && !fired)
					fired = 1
					spawn(10)
						fired = 0

					var/obj/boss/death/d = new (target.loc, src, pick(3,5,7))
					d.density = 1
					for(var/i = 1 to rand(0,4))
						step_away(d, src)
					d.density = 0

			Attacked()
				..()
				if(HP > 0)
					var/percent = 1 + (HP / MHP)*2
					var/matrix/M = matrix() * percent
					transform = M
				else
					transform = matrix() * 3



			Kill(mob/Player/p)
				set waitfor = 0
				..(p)

				sleep(1)

				var/hudobj/teleport/t = new (null, p.client, null, show=1)
				t.dest = "teleportPointSnowman Dungeon"
				p << errormsg("Click the teleport stone on screen button at the bottom right to go back to the snowman dungeon.")



			Death(mob/Player/killer)
				set waitfor = 0
				..(killer)

				SpawnPortal("teleportPointSnowman Dungeon", timer=1)

		Snowman
			icon = 'Snowman.dmi'
			level = 750
			HPmodifier  = 3
			DMGmodifier = 0.8
			element = WATER

			Attacked()
				..()
				if(HP > 0)
					var/percent = 1 + (1 - HP / MHP)*2

					if(isElite) percent += 2

					var/matrix/M = matrix() * percent
					transform = M

					Dmg = round(DMGmodifier * (level + 5) * (percent))
				else
					transform = null
					Dmg = DMGmodifier * (level + 5)

		Acromantula
			icon = 'Mobs.dmi'

			icon_state = "spider"
			level = 850
			MoveDelay = 3

			HPmodifier = 1.4
			DMGmodifier = 0.6

			respawnTime = 900

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
					new /mob/Enemies/Summoned/Acromantula (loc)


				SpawnPet(killer, 0.03, null, /obj/items/wearable/pets/acromantula)
				SpawnPortal("teleportPointSnowman Dungeon", chance=2)

			MapInit()
				set waitfor = 0
				..()

				SetSize(rand(15,30) / 10)

		Vampire
			icon = 'FemaleVampire.dmi'
			level = 900
			HPmodifier  = 1.4
			DMGmodifier = 0.6
			MoveDelay   = 3
			respawnTime = 900

			drops = "Vampire"

			var/rep = 4
			var/tmp/areaName

			MapInit()
				set waitfor = 0
				..()
				if(prob(49))
					icon   = 'MaleVampire.dmi'
					gender = MALE
				else
					gender = FEMALE

				GenerateIcon(src)

				sleep(2)
				if(loc)
					areaName = "area_[loc.loc.name]"

			ShouldIBeActive()
				..()

				if(rep != 0)
					var/AreaData/data = worldData.areaData[areaName]

					if(data)
						if(data.rep > 0)
							rep = abs(rep)
						else if(data.rep < 0)
							rep = -abs(rep)
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

				if(killer && !killer.Immortal)

					var/r = rep
					if(prob(52)) r /= 2

					killer.addRep(r)

					var/obj/countdown/c = locate(areaName)
					if(c)
						c.add(1, killer.guild)

				..()

			Attacked(obj/projectile/p)
				p.damage = round(p.damage * rand(7, 9)/10)
				if(MoveDelay == 3 && p.owner && prob(55))
					MoveDelay = 1
					ChangeState(state)
					spawn(30)
						MoveDelay = 3
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
			icon = 'Mobs.dmi'

			icon_state = "wisp"
			level = 850

			HPmodifier  = 1.4
			DMGmodifier = 0.7
			MoveDelay = 3
			canBleed = FALSE
			var/tmp/fired = 0

			Attack(mob/M)
				..()
				if(!fired && target && state == HOSTILE)
					fired = 1
					spawn(90) fired = 0

					for(var/obj/redroses/S in oview(3, src))
						flick("burning", S)
						spawn(8) S.loc = null

					dir=get_dir(src, target)
					castproj(icon_state = "fireball", damage = Dmg + rand(-4,8), name = "fire ball")
					sleep(AttackDelay)

			Attacked(obj/projectile/p)
				if(p.element == GHOST || (p.icon_state == "blood" && prob(75)))
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

				if(!isElite)
					SetSize(1 + (rand(-5,15) / 50)) // -10% to +30% size change

				animate(src, color = color1, time = 10, loop = -1)
				animate(color = color2, time = 10)
				animate(color = color3, time = 10)


			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.02, "rand", /obj/items/wearable/pets/wisp)
				SpawnPortal("teleportPointSnowman Dungeon", chance=1)


		Floating_Eye
			icon = 'Mobs.dmi'

			icon_state = "eye1"
			level = 900
			HPmodifier  = 1.4
			DMGmodifier = 0.75
			var
				tmp/fired = 0
				cd = 120

			MoveDelay = 3

			Eye_of_The_Fallen
				level = 2400
				cd = 20
				HPmodifier = 10

				prizePoolSize = 2

				Range     = 20
				MoveDelay = 2
				AttackDelay = 3


				Death()
					..()

					SpawnPortal("@Hogwarts")

				MapInit()
					set waitfor = 0
					..()
					animate(src, color = rgb(255, 0, 0), time = 10, loop = -1)
					animate(color = rgb(255, 0, 255), time = 10)
					animate(color = rgb(rand(60,255), rand(60,255), rand(60,255)), time = 10)

					SetSize(3)

					namefont.QuickName(src, "The [name]", "#eee", "#e00", top=1, py=16)
					hpbar = new(src)

					origloc = null
			New()
				..()
				icon_state = "eye[rand(1,2)]"
				if(!isElite && prob(60))
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
				if(origloc)
					var/obj/eye_counter/count = locate("EyeCounter")
					if(count.add())
						Players << infomsg("The Eye of The Fallen has appeared somewhere in the desert!")
						new /mob/Enemies/Floating_Eye/Eye_of_The_Fallen (locate(rand(4,97), rand(4,97), 3))

					SpawnPet(killer, 0.02, null, /obj/items/wearable/pets/floating_eye)
					SpawnPortal("teleportPointSnowman Dungeon", chance=2)

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
					fired = 1
					spawn(cd) fired = 0

					var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
					var/tmp_d = dir
					var/dmg = round(Dmg * 1.5 + rand(-4,8))
					for(var/d in dirs)
						dir = d
						castproj(icon_state = "crucio2", damage = dmg, name = "death ball", cd = 0, lag = 1)

					dir = tmp_d

					sleep(AttackDelay)

		Troll
			icon = 'Mobs.dmi'
			icon_state = "troll"
			level = 750
			HPmodifier  = 4
			DMGmodifier = 0.6
			MoveDelay   = 4
			AttackDelay = 3

			MapInit()
				set waitfor = 0
				..()
				if(!isElite)
					SetSize(rand(10,20) / 10)

			Attack()
				var/reset = 0
				var/p = 15
				for(var/mob/Enemies/m in orange(1, src))
					p += 20

				if(prob(p))
					Dmg        += 1200
					level       = 1000
					MoveDelay   = 2
					AttackDelay = 2
					ChangeState(state)
					reset = 1
				..()
				if(reset)
					Dmg        -= 1200
					level       = initial(level)
					MoveDelay   = initial(MoveDelay)
					AttackDelay = initial(AttackDelay)
					ChangeState(state)

			Death(mob/Player/killer)
				..()

				SpawnPet(killer, 0.03, null, /obj/items/wearable/pets/troll)
				SpawnPortal("teleportPointSnowman Dungeon", chance=1)

			ChangeState(var/i_State)
				set waitfor = FALSE

				..(i_State)

				if(i_State == WANDER && origloc && HP > 0)
					HP = MHP
					while(state == WANDER && get_dist(loc, origloc) > 2)
						var/i = step_to(src, origloc)
						if(!i) break
						sleep(1)
		Bird_    ///SUMMONED///
			icon_state = "bird"
			level = 6

		Projectile
			var/tmp/fired = 0
			AttackDelay = 5
			MoveDelay = 5
			element = FIRE
			HPmodifier = 0.8

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

				if(!fired)
					fired = 1
					dir=get_dir(src, target)
					castproj(icon_state = "fireball", damage = Dmg + rand(-4,8), name = "fire ball")
					spawn(30) fired = 0
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

		Archangel
			icon_state = "archangel"
			level = 500
			element = EARTH
		Water_Elemental
			icon_state = "water elemental"
			level = 550
			canBleed = FALSE
			element = WATER
			respawnTime = 900
		Fire_Elemental
			icon_state = "fire elemental"
			level = 600
			canBleed = FALSE
			element = FIRE
		Wyvern
			icon_state = "wyvern"
			level = 650
		Basilisk
			icon = 'Mobs.dmi'
			icon_state = "basilisk"
			level = 2000
			HPmodifier = 10
			DMGmodifier = 3
			MoveDelay = 3
			AttackDelay = 1
			Range = 24
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

				namefont.QuickName(src, "The [name]", "#eee", "#e00", top=1, py=16)

				hpbar = new(src)

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

					fired = 1
					spawn()

						var/obj/warnWidth  = new /obj/custom { icon = 'dot.dmi'; icon_state = "circle"; color = "#8A0707"; alpha = 20; appearance_flags = PIXEL_SCALE; } (loc)
						var/obj/warnHeight = new /obj/custom { icon = 'dot.dmi'; icon_state = "circle"; color = "#8A0707"; alpha = 20; appearance_flags = PIXEL_SCALE; } (loc)

						walk_towards(warnWidth, src)
						walk_towards(warnHeight, src)

						var/matrix/mWidth = matrix()
						mWidth.Scale(17,1)

						var/matrix/mHeight = matrix()
						mHeight.Scale(1,17)

						animate(warnWidth,  alpha = 100, transform = mWidth, time = 7)
						animate(warnHeight, alpha = 100, transform = mHeight, time = 7)

						sleep(30)

						walk(warnWidth, 0)
						warnWidth.loc = null

						walk(warnHeight, 0)
						warnHeight.loc = null

						for(var/mob/Player/p in ohearers(8, src))
							if(p.x == x || p.y == y)
								if(!p.trnsed)
									p:StateChange()
								else
									p.nomove = 1
								spawn(rand(10,30))
									if(p && p.nomove)
										if(!p.trnsed)
											p.StateChange()
											p.ApplyOverlays()
										else
											p.nomove = 0

						sleep(rand(50,150))
						fired = 0


			Kill(mob/Player/p)
				set waitfor = 0
				..(p)

				sleep(1)

				var/hudobj/teleport/t = new (null, p.client, null, show=1)
				t.dest = "CoSBasOut"
				p << errormsg("Click the teleport stone on screen button at the bottom right to go back to the Basilisk.")



			Death(mob/Player/killer)
				..(killer)

				SpawnPortal("CoSFloor2", "CoSLockDoor", timer=1)


obj/corpse
	var/gold
	var/revive = 0
	canSave = 0
	Click()
		..()
		if(gold > 0)
			if(src in orange(1))
				var/gold/g = new(bronze=gold)
				usr << infomsg("You looted [g.toString()] from [name]'s corpse.")
				g.give(usr)

				gold = 0
				mouse_over_pointer = 0
			else
				usr << errormsg("You need to be closer.")

	New(turf/Loc, mob/dead, gold = 0)
		set waitfor = 0
		..()

		appearance         = dead.appearance
		dir                = dead.dir
		layer              = 3

		var/matrix/m = transform
		m.Turn(90 * pick(1, -1))
		animate(src, transform = m, time = 10, easing = pick(BOUNCE_EASING, BACK_EASING))

		if(ismonster(dead))
			var/mob/Enemies/e = dead
			if(e.level >= 1000)
				if(!e.respawnTime)
					sleep(300)
				else
					sleep(e.respawnTime / 2 + 10)
			else
				sleep(40)
		else if(isplayer(dead))
			sleep(20)
			var/area/a = Loc.loc
			src.gold = 0
			if(gold == -1)
				src.gold = -1
				animate(src, transform = null, time = 10)
				sleep(10)
				if(dead)
					dead:Transfer(loc)
					dead.dir = dir
				loc = null
				return

			else if(a.undead && a.undead < 30)
				src.gold = -1
				a.undead++
				var/mob/Player/p = dead
				if(p.Gender == "Female")
					icon = 'FemaleVampire.dmi'
				else
					icon = 'MaleVampire.dmi'

				animate(src, transform = null, time = 10)

				sleep(10)
				new /mob/Enemies/Summoned/Zombie (loc, p, src)
				loc = null
				return

			else if(gold > 0)
				mouse_over_pointer = MOUSE_HAND_POINTER
				src.gold = gold

			sleep(600)
		else
			sleep(40)

		if(revive) return

		animate(src, alpha = 0, time = 10)
		sleep(10)
		loc = null

area/var/undead = 0

mob/Enemies/Summoned/Zombie
	DMGmodifier = 0.8
	HPmodifier  = 1
	MoveDelay   = 2
	AttackDelay = 5

	New(Loc, mob/Player/p, obj/corpse/c)
		appearance = c.appearance
		level      = p.level

		..()

	MapInit()
		set waitfor = 0
		calcStats()
		sleep(2)
		state()

	Death(mob/Player/killer)
		var/area/a = loc.loc

		if(a && a.undead > 1)
			a.undead--

obj/boss/death

	icon       = 'dot.dmi'
	icon_state = "circle"
	color      = "#8A0707"
	alpha      = 20
	appearance_flags = PIXEL_SCALE

	var
		range = 3

	New(Loc, mob/Enemies/boss, r=3)
		set waitfor = 0
		..(Loc)

		range = r
		sleep(1)
		var/matrix/m = matrix()
		m.Scale(range + 0.5, range)

		animate(src,  alpha = 100, transform = m, time = 7)

		sleep(15)

		var/obj/o = new(loc)
		o.icon = 'Cow.dmi'
		o.transform = matrix()*range
		o.pixel_y = 160
		o.dir = pick(1,2,4,8)
		o.appearance_flags = PIXEL_SCALE

		animate(o, pixel_y = 0, time = 5)

		sleep(5)

		for(var/mob/Player/p in range((range-1)/2, loc))
			p << errormsg("A giant cow fell on you, oops.")
			p.HP = 0
			if(boss)
				boss.Kill(p)
			else
				p.Death_Check(boss)

		loc = null
		o.loc = null
