
area/var/safezoneoverride = 0

mob/Player/var/hardmode = 0

WorldData
	var
		counters
		list/areaData

obj
	kill_counter
		var/marks     = 0
		maptext_width = 64
		pixel_x       = 8
		post_init      = 1

		MapInit()
			set waitfor = 0
			sleep(1)
			tag = "Counter_" + name

			if(!worldData.counters) worldData.counters = list()

			if(!(tag in worldData.counters)) worldData.counters[tag] = 0

			maptext = "<b><span style=\"font-size:4; color:#FF4500;\">[worldData.counters[tag]]</span></b>"

		proc
			add()
				worldData.counters[tag]++
				if(worldData.counters[tag] >= 1000)
					worldData.counters[tag] = 0
					marks++
					. = 1
				updateDisplay()

			updateDisplay()
				if(worldData.counters[tag] >= 100)
					pixel_x = -5
				else if(worldData.counters[tag] >= 10)
					pixel_x = -4
				else
					pixel_x = 8

				maptext = "<b><span style=\"font-size:4; color:#FF4500;\">[worldData.counters[tag]]</span></b>"

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
			MHP = 100
			tmp/obj/healthbar/hpbar
			tmp/warn = 1

		Attacked(obj/projectile/p)
			if(HP > 0 && p.owner && isplayer(p.owner))

				var/mob/Player/player = p.owner
				if(!player.guild) return

				var/AreaData/data = worldData.areaData[tag]

				if(warn && HP <= 95)
					warn = 0
					var/areaName = replacetext(tag, "area_", "")
					for(var/mob/Player/pl in Players)
						if(pl.guild == data.guild)
							pl << errormsg("Your [areaName] pillar is being attacked.")

				flick("[icon_state]-V", src)

				if(player.guild == data.guild)
					HP++
				else
					HP--

				if(HP <= 0)
					data.guild = player.guild

					updateDisplay()
					respawn()
				else
					var/percent = HP / initial(HP)
					hpbar.Set(percent, src)

					if(HP >= MHP) warn = 1


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

							var/area/a = loc.loc
							for(var/mob/Player/p in Players)
								if(p.guild)
									p << infomsg("[a.name] pillar can be attacked in one hour.")

							continue

						sleep(600)
					else
						sleep(10)

				timer.loc = null
				var/area/a = loc.loc
				for(var/mob/Player/p in Players)
					if(p.guild)
						p << infomsg("[a.name] pillar can be attacked.")

				HP = initial(HP)
				warn = 1
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

					if(!g) return

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

		var/const/STEPS_LIMIT = 14

		var/turf/t = get_step_to(o, target, dist)
		var/distance = get_dist(o, target)

		var/startingDistance = distance

		for(var/steps = 0 to STEPS_LIMIT)
			if(!t)
				break
			if(distance > dist_limit)
				break

			o.loc    = t
			t        = get_step_to(o, target, dist)
			distance = get_dist(o, target)

		if(!t && distance > dist)
			o.loc = null
			return 1
		o.loc = null
		if(distance >= dist_limit / 2 || distance >= startingDistance)
			return 1
		return 0
area
	var
		containsMonsters = 0
		timedArea = 0
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
				var/c = data.rep > 0 ? "#60060670" : "#00ccff70"

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

		sky
		hogwarts_roof

		inside
			Pixie_Pit
			Pumpkin_Pit
				planeColor = NIGHTCOLOR;
			Pumpkin_Entrance
				planeColor = NIGHTCOLOR;
			Silverblood_Maze
				antiTeleport = TRUE
				antiFly      = TRUE

				Bottom
				Top

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

			TrainingDummy
				antiTeleport = TRUE
				antiFly      = TRUE
				antiApparate = TRUE

			Dungeon
				antiTeleport = FALSE
				antiFly      = TRUE
				SnowmmanEntrance
				Snowman
				SnowmanBoss
					antiTeleport = TRUE
				SnakeEntrance
				Snake
				SnakeBoss
					antiTeleport = TRUE
				LibraryEntrance
				Library
				LibraryBoss
					antiTeleport = TRUE
				Cow
					antiTeleport = TRUE
					timedArea    = TRUE

		Entered(atom/movable/O)
			. = ..()

			if(isplayer(O) && Players)
				active = Players.len
				for(var/mob/Enemies/M in src)
					if(M.state == M.WANDER || M.state == M.INACTIVE)
						M.ChangeState(M.SEARCH)

		Exited(atom/movable/O)
			set waitfor = 0
			. = ..()
			sleep(1)
			if(isplayer(O) && !Players)
				active = 0
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

			var/list/dirs = DIRS_LIST
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
				set category = "Debug"
				src << browse(file("Logs/[VERSION].[SUB_VERSION]-log.txt"))
			Reconnect_MySQL()
				set category = "Server"
				connected = my_connection.Connect(DBI,mysql_username,mysql_password)
				src << "New connection started."


mob
	Enemies
		icon = 'Mobs.dmi'
		see_invisible = 1
		var/active = 0
		var/HPmodifier = 2
		var/DMGmodifier = 0.8
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

				FIRED_PROJ        = 1
				FIRED_PROJ_SPREAD = 2
				FIRED_METEOR      = 4
				FIRED_TORNADO     = 8
				FIRED_AURA        = 16

			tmp
				state = INACTIVE
				list
					ignore
					damage
				hardmode = 0
				slow = 0
				stun = 0
				cooldowns = 0

				revenge

				resistances

			Range         = 12
			MoveDelay     = 4
			AttackDelay   = 4
			respawnTime   = 600

			prizePoolSize = 1
			damageReq     = 15

			iconSize      = 1

			isElite       = 0

			extraDropRate = 0

			list/passives

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
			if(!loc || !p.owner || !p.owner.loc) return
			if(!origloc && p.owner.loc.loc != loc.loc) return

			..()

		Move(NewLoc)
			if(hpbar)
				hpbar.glide_size = glide_size
				hpbar.loc = NewLoc
			.=..()
			/*if(minimapDot)
				var/matrix/m = matrix()
				m.Translate(x, y)
				minimapDot.transform = m*/

		MapInit()
			set waitfor = 0
			calcStats()
			origloc = loc

			if(isElite)
				SetSize(3)

				namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16)
				hpbar = new(src)

			if(element)
				resistances = list()
				if(element == FIRE)
					resistances["[WATER]"] = 1.25
					resistances["[EARTH]"] = 1.1

				else if(element == WATER)
					resistances["[FIRE]"] = 1.25
					resistances["[EARTH]"] = 1.1

				else if(element == EARTH)
					resistances["[GHOST]"] = 0.9
					resistances["[WATER]"] = 0.9
					resistances["[FIRE]"]  = 0.9
				else if(element == GHOST)
					resistances["[WATER]"] = 0
					resistances["[FIRE]"]  = 0
					resistances["[EARTH]"]  = 0

			ShouldIBeActive()


		proc/calcStats()
			Dmg = DMGmodifier * (    (src.level)  + 5)
			MHP = HPmodifier  * (4 * (src.level)  + 210)

			Dmg = round(Dmg * (rand(10,15)/10), 1)
			MHP = round(MHP * (rand(10,15)/10), 1)

			gold = round(src.level / 2)
			Expg = src.level * 5

			if(isElite)
				Dmg  *= 2
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
					w.prizeDrop(killer.ckey, 300,player=killer)
			else
				if(killer.findStatusEffect(/StatusEffect/Potions/Tame))
					chance *= 3

				if(prob(chance))
					if(defaultColor == "rand")
						animate(src)

					if(prob(1))
						color = pick(shinyList)
					else
						color = "#d00"

		proc/SpawnPortal(dest, var/obj/Hogwarts_Door/gate/door, chance = 100, lava=0, timer=0, timedInstance=0)
			set waitfor = 0

			if(dest == "cow dungeon level 1")
				timedInstance = 1
				timer = 18000

			if(isElite) chance *= 5

			if(prob(100 - chance)) return

			if(door)
				door = locate(door)
				if(door)
					door.door = 1

			var/turf/target = locate(dest)
			if(istype(target, /atom/movable)) target = target.loc

			var/timeToRespawn = timer > 1 ? timer : respawnTime

			var/obj/portkey/P1 = new(loc, 0, "portkey", timeToRespawn)
			var/obj/portkey/P2 = new(target, 0, "portkey", timeToRespawn)
			P1.partner = P2
			P2.partner = P1

			P1.density = 1

			sleep(4)

			step_rand(P1)

			if(lava)
				var/limit = 3
				while(istype(P1.loc, /turf/lava) && limit--)
					sleep(1)
					step_rand(P1)

			P1.density = 0

			if(timer)
				var/obj/clock/c = new(get_step(P1, SOUTH))

				var/min = round(timeToRespawn/600)
				var/sec = round(timeToRespawn/10) - min*600

				c.setTime(min,sec)

				if(timedInstance)
					P2.timed = 2
					P1.timed = c

				while(!c.countdown())
					sleep(10)

				c.loc = null
			else
				sleep(timeToRespawn)

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
				rate += 0.5

			if(killer.guild) rate += killer.getGuildAreas() * 0.1

			var/knowledge = monsterkills[name] + 1
			if(knowledge)
				rate += round(log(10, knowledge)) * 0.1

			rate += extraDropRate

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
				e.prizeDrop(killer.ckey, decay=1,player=killer)

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
				t.prizeDrop(killer.ckey, decay=FALSE, player=killer)
				sparks = 1

				if(killer.pet)
					killer.pet.fetch(t)

			var/base = worldData.baseChance * clamp(1 + (level - killer.level) / 200, 0.1, 20) * clamp(level/200, 0.1, 20)
			if(level < killer.level) base *= (level / 800) * 0.75

			if(hardmode)
				rate += hardmode * 0.5

			if(passives)
				rate += passives.len * 0.3

			if(killer.dungeon)
				rate += killer.dungeon.DropRate

			if(prize)
				sparks = 1
				if(prizePoolSize > 1 && damage && damage.len > 1)
					if(!(killer.ckey in damage) || damage[killer.ckey] < damageReq)
						damage[killer.ckey] = damageReq

					quicksortValue(damage)

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
					prize.prizeDrop(killer.ckey, decay=1, player=killer)
					if(killer.pet)
						killer.pet.fetch(prize)

			else if(prob(base*rate*4))
				sparks = 1
				prize = pickweight(list(/obj/items/crystal/defense         = 1,
										/obj/items/crystal/damage          = 1,
										/obj/items/crystal/defense_monster = 1,
										/obj/items/crystal/damage_monster  = 1,
										/obj/items/crystal/luck            = 1))

				prize = new prize (loc, round(level/50))
				prize.prizeDrop(killer.ckey, decay=1, player=killer)
				if(killer.pet)
					killer.pet.fetch(prize)

			if(extraDropRate == 0 && prob(base*rate*8))

				var/event = killer.level >= 750 ? pick(1,2,3) : pick(1,2)

				if(event==3)
					var/auto = (RING_AFK in killer.passives)
					new /obj/monster_portal (loc, auto)
				else if(event==2)
					new /mob/Enemies/Summoned/Boss/Treasure_Chest (loc)
				else if(event==1)
					new /mob/Enemies/Summoned/Boss/Scared_Ghost (loc)

			if(prob(base * rate + killer.pity))
				sparks = 1
				prize = pick(drops_list["legendary"])
				prize = new prize (loc)

				var/isLegendary = istype(prize, /obj/items/wearable) && prize:bonus == 0
				var/textColor = "#FFA500"

				if(isLegendary)
					if(prob(hardmode*2))

						if(hardmode >= 10 && prob(1))
							prize:Upgrade(20, 4)
							textColor = "#db7093"
						else if(hardmode > 5 && prob(hardmode*2))
							prize:Upgrade(10 + rand(0, 5), 3)
							textColor = "#660000"
						else
							prize:Upgrade(5 + rand(0, 5))
							textColor = "#551a8b"

					if(prob(10))
						prize:bonus = 3
						var/lvl = pick(1,2,3)
						prize:quality = lvl
						prize.name += " +[lvl]"
						prize.UpdateDisplay()

				prize.prizeDrop(killer.ckey, decay=1, player=killer)
				killer << colormsg("<i>[name] dropped [prize.name]</i>", textColor)
				killer.pity = 0

				if(killer.pet)
					killer.pet.fetch(prize)

			else if(hardmode == 10 && prob(base * rate * 0.1))
				sparks = 1
				prize = new /obj/items/chest/wigs/hardmode_chest (loc)

				killer << colormsg("<i><b>[name] dropped [prize.name]. It's too big for your pet to fetch, pick it up!</b></i>", "#FFC0CB")
				prize.prizeDrop(killer.ckey, decay=1, player=killer)

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

			if(killer.dungeon)
				if(isElite)
					killer.dungeon.Completed()
			else if(revenge)

				if(revenge == killer.name)
					killer << "An eye for an eye... Vengeance is yours."

				revenge = null
				underlays = null
				isElite = 0
				calcStats()

				name = initial(name)
				hpbar.Dispose()
				hpbar = null
				SetSize(1)

		proc/state()
			set waitfor = 0
			if(active) return
			active = 1
			while(src.loc && state != 0)
				switch(state)
					if(WANDER)
	//					var/turf/t = get_step_rand(src)
	//					if(t.loc != loc.loc)
	//						t = get_step_away(src, t)
	//					dir = get_dir(src, t)
	//					loc = t
	//					if(hpbar)
	//						hpbar.glide_size = glide_size
	//						hpbar.loc = t
						step_rand(src)

					if(SEARCH)
						if(!stun) Search()
					if(HOSTILE)
						if(!stun)
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
			getHardmodeHealth()

				var/health = MHP * (1 + hardmode) + (200 * hardmode * HPmodifier)
				if(HPmodifier < 2)
					health *= 200 / (HPmodifier * 100)
				if(hardmode > 5) health += 2000 + (2000 * hardmode)

				return health

			getHardmodeDamage(var/dmg)

				if(DMGmodifier < 0.8)
					var/perc = (DMGmodifier / 0.8) * 100
					dmg *= 100 / perc
				dmg = dmg * (1.1 + hardmode*0.5) + 100*hardmode

				if(hardmode > 5)
					dmg += 200 + 200*hardmode

				return dmg

			ChangeState(var/i_State)
				set waitfor = 0

				if(state == i_State) return
				state = i_State

				if(state != HOSTILE && hardmode)
					HP = MHP
					filters = null
					hardmode = 0

				if(state != 0)
					switch(state)
						if(WANDER)
							lag    = 10
							target = null
						if(SEARCH)
							lag = 10
						if(HOSTILE)
							lag = max(MoveDelay, 1)

							if(target.hardmode && !hardmode && level <= 1500 && level >= 50)
								hardmode = target.hardmode

								switch(hardmode)
									if(1)
										filters = filter(type="outline", size=1, color="#0e0")
									if(2)
										filters = filter(type="outline", size=1, color="#00a5ff")
									if(3)
										filters = filter(type="outline", size=1, color="#ffa500")
									if(4)
										filters = filter(type="outline", size=1, color="#551a8b")
									if(5)
										filters = filter(type="outline", size=1, color="#ff0000")
									if(6)
										filters = filter(type="drop_shadow", size=2, y=0, x=0, offset=2, color="#0e0")
									if(7)
										filters = filter(type="drop_shadow", size=2, y=0, x=0, offset=2, color="#00a5ff")
									if(8)
										filters = filter(type="drop_shadow", size=2, y=0, x=0, offset=2, color="#ffa500")
									if(9)
										filters = filter(type="drop_shadow", size=2, y=0, x=0, offset=2, color="#551a8b")
									if(10)
										filters = filter(type="drop_shadow", size=2, y=0, x=0, offset=2, color="#ff0000")

								HP = getHardmodeHealth()

						if(CONTROLLED)
							target = null
							lag = 12

					lag += slow
					glide_size = 32/lag

					state()
				else
					target = null
					if(loc && origloc && origloc.loc != loc.loc)
						loc = origloc

			Search()
	//			step_rand(src)
				var/area/a = loc.loc
	//			for(var/mob/Player/M in ohearers(src, Range))

				var/min_dist = Range
				for(var/mob/Player/M in a.Players)
	//				if(M.loc.loc != src.loc.loc) continue
					if(M.Immortal) continue
					if(M.level > level && (RING_NINJA in M.passives)) continue
					if(ignore && (M in ignore)) continue

					var/dist = get_dist(src, M)
					if(dist > Range) continue
					if(min_dist > dist)
						if(!isPathBlocked(M, src, 1, src.density, dist_limit=Range))
							target = M
							min_dist = dist
			//				ChangeState(HOSTILE)
			//			break
						else
							Ignore(M)
				if(target)
					ChangeState(HOSTILE)
				else
					step_rand(src)

			ChangeTarget()
				if(!loc) return
				var/min_dist = Range
				var/area/a = loc.loc
				for(var/mob/Player/M in a.Players)
		//		for(var/mob/Player/M in ohearers(src, Range))
		//			if(M.loc.loc != src.loc.loc) continue
					if(M.Immortal) continue
					if(ignore && (M in ignore)) continue

					var/dist = get_dist(src, M)
					if(min_dist > dist)
						if(!isPathBlocked(M, src, 1, src.density, dist_limit=Range))
							target = M

							if(target.hardmode > hardmode && level <= 1500 && level >= 50)
								hardmode = target.hardmode

								switch(hardmode)
									if(1)
										filters = filter(type="outline", size=1, color="#0e0")
									if(2)
										filters = filter(type="outline", size=1, color="#00a5ff")
									if(3)
										filters = filter(type="outline", size=1, color="#ffa500")
									if(4)
										filters = filter(type="outline", size=1, color="#551a8b")
									if(5)
										filters = filter(type="outline", size=1, color="#ff0000")
									if(6)
										filters = filter(type="drop_shadow", size=2, y=0, x=0, offset=2, color="#0e0")
									if(7)
										filters = filter(type="drop_shadow", size=2, y=0, x=0, offset=2, color="#00a5ff")
									if(8)
										filters = filter(type="drop_shadow", size=2, y=0, x=0, offset=2, color="#ffa500")
									if(9)
										filters = filter(type="drop_shadow", size=2, y=0, x=0, offset=2, color="#551a8b")
									if(10)
										filters = filter(type="drop_shadow", size=2, y=0, x=0, offset=2, color="#ff0000")

								HP = getHardmodeHealth()

						else
							Ignore(M)

			Ignore(mob/M)
				set waitfor = 0
				if(!ignore) ignore = list()
				ignore += M
				sleep(30)
		//		while(M && ignore && ignore[M] == M.loc)
	//				sleep(30)
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

		var/tmp/overlapped = 0
		proc/overlap()
			var/angle_change = 360 / (overlapped + 1)
			var/angle = dir2angle(get_dir(src, target)) + 90
			for(var/mob/Enemies/e in loc)
				e.pixel_x = 10 * cos(angle)
				e.pixel_y = 10 * sin(angle)
				angle = (360 + angle + angle_change) % 360

		Cross(atom/movable/O)
			if(istype(O, /mob/Enemies))
				return 1
			.=..()

		Crossed(atom/movable/O)
			if(istype(O, /mob/Enemies))

				overlapped++
				O:overlapped = overlapped

				overlap()

		Uncrossed(atom/movable/O)
			if(istype(O, /mob/Enemies))
				overlapped--
				O:overlapped=0
				O.pixel_x = 0
				O.pixel_y = 0

				if(overlapped <= 0)
					overlapped = 0
					pixel_x = 0
					pixel_y = 0
				else
					overlap()

		proc/BlindAttack()//removeoMob
			for(var/mob/Player/p in range(1, src))
				if(p.loc.loc != loc.loc) continue

				var/dmg = Dmg+rand(0,4)
				if(dmg<1)
					//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
				else
					dmg = p.onDamage(dmg, src)
					p << "<SPAN STYLE='color: red'>[src] attacks [p] and causes [dmg] damage!</SPAN>"
					if(src.removeoMob)
						spawn() p.Death_Check(src.removeoMob)
					else
						spawn() p.Death_Check(src)
				break

		proc/Blocked()
			blockCount++
			if(blockCount > 5)
				Ignore(target)
				target = null
				ShouldIBeActive()
			else
				var/turf/tmpLoc = loc
				step_towards(src, target)
				if(loc == tmpLoc)
					var/mob/Enemies/e = locate() in oview(1, target)
					step_towards(src, e)

		proc/Kill(mob/Player/p)
			set waitfor = 0

			if(!isElite && HP > 0 && !revenge && !hpbar && level <= 1500 && level > 200 && prob(20))

				var/newName = "Big \"[p.name] Slayer\" [name]"
				p << infomsg("[name] has distinguished themselves killing you, they are now named [newName]")
				name = newName

				revenge = p.name

				isElite = 1
				calcStats()

				SetSize(3)

				namefont.QuickName(src, "[name]", "#eee", "#e00", top=1, py=16, size=4)
				hpbar = new(src)


			p.Death_Check(src)


		proc/CastProj(cd=20, min=20, max=100)
			set waitfor = 0
			if(cooldowns & FIRED_PROJ) return
			if(prob(35)) return
			cooldowns |= FIRED_PROJ

			var/dmg = Dmg + rand(-4,8)

			if(hardmode)
				dmg = getHardmodeDamage(dmg)

			dir=get_dir(src, target)
			castproj(icon_state = pick("fireball", "quake", "aqua", "iceball", "gum"), damage = dmg, name = "spell")

			cd = ,min + (max - min) * (cd / 100)

			sleep(cd)
			cooldowns &= ~FIRED_PROJ

		proc/CastProjSpread(cd=40, min=30, max=100)
			set waitfor = 0
			if(cooldowns & FIRED_PROJ_SPREAD) return
			if(prob(35)) return
			cooldowns |= FIRED_PROJ_SPREAD

			var/dmg = Dmg + rand(-4,8)

			if(hardmode)
				dmg = getHardmodeDamage(dmg)

			for(var/di in DIRS_LIST)
				castproj(icon_state = pick("fireball", "quake", "aqua", "iceball", "gum"), damage = Dmg, name = "spell", cd = 0, lag = 1, Dir=di)

			cd = ,min + (max - min) * (cd / 100)

			sleep(cd)
			cooldowns &= ~FIRED_PROJ_SPREAD

		proc/CastMeteor(cd=40, min=50, max=100)
			set waitfor = 0

			if(cooldowns & FIRED_METEOR) return
			if(prob(35)) return
			cooldowns |= FIRED_METEOR

			var/dmg = Dmg + rand(-4,8)

			if(hardmode)
				dmg = getHardmodeDamage(dmg)

			var/state = pick("fireball", "quake", "aqua", "iceball", "gum")
			var/obj/projectile/Meteor/m = new (target ? target.loc : loc, src, dmg*0.75, state, "spell", element)
			m.range = pick(3,5)

			cd = ,min + (max - min) * (cd / 100)

			sleep(cd)
			cooldowns &= ~FIRED_METEOR

		proc/CastTornado(cd=40, min=40, max=100)
			set waitfor = 0

			if(cooldowns & FIRED_TORNADO) return
			if(prob(35)) return
			cooldowns |= FIRED_TORNADO

			var/dmg = Dmg + rand(-4,8)

			if(hardmode)
				dmg = getHardmodeDamage(dmg)

			var/state = pick("fireball", "quake", "aqua", "iceball", "gum")
			castproj(Type = /obj/projectile/NoImpact/Dir/Tornado, name = "[state] tornado", icon_state = state, damage = dmg*0.9, element = element, Dir = target ? get_dir(src, target) : dir, cd = 0, lag = 3, learn=0)

			cd = ,min + (max - min) * (cd / 100)

			sleep(cd)
			cooldowns &= ~FIRED_TORNADO

		proc/CastAura(cd=50, min=50, max=100)
			set waitfor = 0

			if(cooldowns & FIRED_AURA) return
			if(prob(35)) return
			cooldowns |= FIRED_AURA

			var/mutable_appearance/ma = new

			ma.icon = 'attacks.dmi'
			ma.icon_state = pick("fireball", "quake", "aqua", "iceball", "gum")

			var/range = rand(1, 3)
			var/dmg = Dmg + rand(-4,8)

			if(hardmode)
				dmg = getHardmodeDamage(dmg)

			var/list/images = list()
			for(var/i = 1 to range)

				for(var/d = 0 to 359 step (90 / i))
					var/matrix/m = matrix()
					m.Translate(24 * i, 0)
					ma.transform = turn(m, d)

					images += ma.appearance

			var/obj/o = new
			o.overlays = images

			var/matrix/m = matrix()
			m.Turn(90)
			animate(o, transform = m, time = 10, loop = -1)
			m.Turn(90)
			animate(transform = m, time = 10)
			m.Turn(90)
			animate(transform = m, time = 10)
			animate(transform = null, time = 10)

			vis_contents += o

			for(var/i = 1 to 10)
				for(var/mob/Player/e in range(range, src))
					e.onDamage(dmg*0.9, src, elem=element)

				sleep(10)

			vis_contents -= o

			cd = ,min + (max - min) * (cd / 100)

			sleep(cd)
			cooldowns &= ~FIRED_AURA

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

			if(CAST_PROJ in passives)
				CastProj(passives[CAST_PROJ])

			if(CAST_PROJ_SPREAD in passives)
				CastProjSpread(passives[CAST_PROJ_SPREAD])

			if(CAST_METEOR in passives)
				CastMeteor(passives[CAST_METEOR])

			if(CAST_TORNADO in passives)
				CastTornado(passives[CAST_TORNADO])

			if(CAST_AURA in passives)
				CastTornado(passives[CAST_AURA])

			if(distance > 1)
				var/area/newareas/a = loc.loc
				if(a.Players && a.Players.len > 1 && distance > 4 && prob(25))
					ChangeTarget()

				var/turf/t = get_step_to(src, target, 1)
				if(t)
					blockCount = 0
					Move(t)
				else
					Blocked()
			else
				var/dmg = Dmg + rand(0, 20)

		//		if(isElite)
		//			dmg = dmg * 1.5 + 100

				if(hardmode)
					dmg = getHardmodeDamage(dmg)

				if(target.level < level)
					dmg += dmg * ((1 + level - target.level)/200)
				else if(target.level > level && !isElite && !hardmode)
					dmg -= dmg * ((target.level - (level + 1))/150)

				dmg = round(dmg - target.Slayer.level)

				if(target.animagusOn)
					dmg = dmg * 0.75 - target.Animagus.level

				if(target.Armor)
					var/armor = target.Armor
					if(SHIELD_THORN in target.passives)
						armor *= 1 + (30 + target.passives[SHIELD_THORN] - 1) / 100
					dmg -= armor

					if(SWORD_THORN in target.passives)
						onDamage(armor, target)

				if(!target)
					ShouldIBeActive()
					return

				if(dmg > 0)
					dmg = target.onDamage(dmg, src)
					if(target && dmg > 0)
						if(target.HP <= 0)
							Kill(target)
				else
					for(var/obj/summon/s in target.Summons)
						if(!s.target) s.target = src

				dir = get_dir(src, target)
				var/angle = dir2angle(dir)
				var/px = round(6  * cos(angle), 1)
				var/py = round(-6 * sin(angle), 1)
		//		animate(src, pixel_x = pixel_x + px, pixel_y = pixel_y + py, time = AttackDelay+slow/2, easing=BACK_EASING)
		//		animate(pixel_x = pixel_x - px, pixel_y = pixel_y - py, time = AttackDelay+slow/2, easing=BACK_EASING)
				pixel_x += px
				pixel_y += py
				sleep(AttackDelay+slow)
				pixel_x -= px
				pixel_y -= py




obj/corpse
	var/gold
	var/revive = 0
	canSave = 0
	Click()
		..()
		if(gold > 0 && !revive)
			if(src in orange(1))
				var/gold/g = new(bronze=gold)
				usr << infomsg("You looted [g.toString()] from [name]'s corpse.")
				g.give(usr)

				gold = 0
				mouse_over_pointer = 0
			else
				usr << errormsg("You need to be closer.")

	New(turf/Loc, mob/dead, gold = 0, turn=1, time=40)
		set waitfor = 0
		..()

		appearance         = dead.appearance
		dir                = dead.dir
		layer              = 3
		owner              = dead

		if(turn)
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
			sleep(time)

		if(revive)
			owner = null
			return

		animate(src, alpha = 0, time = 10)
		sleep(10)
		owner = null
		loc = null

area/var/undead = 0

mob/Enemies/Summoned/Zombie
	DMGmodifier = 1
	HPmodifier  = 2
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


obj/dropObj
	icon = 'attacks.dmi'
	pixel_y = 160
	appearance_flags = PIXEL_SCALE
	layer = 5

	cow
		icon = 'Cow.dmi'

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

		var/obj/dropObj/cow/o = new(loc)
		o.transform = matrix()*range
		o.dir = pick(1,2,4,8)

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

obj/boss/deathDOTControl
	var
		active = 0
		radius = 20

	proc
		Start()
			set waitfor = 0
			if(active) return

			active = 1
			var/list/dotList = list()
			var/highest = 0
			for(var/obj/boss/deathdot/d in range(radius, src))

				var/distance = get_dist(d, src)
				if(!("[distance]" in dotList))
					dotList["[distance]"] = list()

				dotList["[distance]"] += d

				highest = max(highest, distance)

			sleep(40)
			for(var/i = highest to 0 step -1)
				if(!active) break
				for(var/obj/boss/deathdot/d in dotList["[i]"])
					d.active = 1
					animate(d, alpha  = 140, time = 40)

				sleep(80)

			while(active)
				sleep(10)

			for(var/i = highest to 0 step -1)
				for(var/obj/boss/deathdot/d in dotList["[i]"])
					d.active = 0
					d.alpha  = 0

		Stop()
			active = 0


obj/monster_portal

	icon = 'attacks.dmi'
	layer = 10
	alpha = 160

	var/tmp
		opened = 0
		elem

	mouse_over_pointer = MOUSE_HAND_POINTER

	Click()
		if(opened) return

		if(src in view(15))

			expand()

	New(Loc, open=0)
		set waitfor = 0
		..(Loc)
		elem = pick("Fire", "Water")

		if(open)
			expand()
			return

		icon_state = elem == "Fire" ? "flame" : "frost"
		transform *= 3

		sleep(600)
		if(!opened) loc = null

	proc/expand()
		set waitfor = 0

		opened = 1

		icon = 'spotlight.dmi'
		blend_mode = BLEND_MULTIPLY

		mouse_over_pointer = MOUSE_INACTIVE_POINTER
		transform = null

		pixel_x = -64
		pixel_y = -64
		mouse_opacity = 0

		if(elem == "Fire") color = "#c60"
		else               color = "#0bc"

		transform = matrix() * 0.2


		var/const/RANGE = 10
		animate(src, transform = matrix() * (RANGE * 0.4), time = RANGE * 5)

		sleep(5)

		var/list/mobs = list()

		for(var/i = 1 to RANGE - 1)

			var/offsetX = pick(i, -i, 0)
			var/offsetY = pick(i, -i, 0)

			if(offsetX == 0 && offsetY == 0)
				if(prob(50))
					offsetX = pick(i, -i)
				else
					offsetY = pick(i, -i)

			var/turf/t = locate(x + offsetX, y + offsetY, z)

			if(!t || t.skip) t = loc

			var/mob/Enemies/Summoned/monster = new (t)

			monster.alpha = 0
			monster.DMGmodifier = 1
			monster.HPmodifier  = 2.5
			monster.MoveDelay   = 3
			monster.AttackDelay = 3
			monster.level       = 800
			monster.transform   = matrix() * (1.5 + (rand(0, 50) / 100))
			monster.name        = "[elem] Elemental"
			monster.icon_state  = "[lowertext(elem)] elemental"
			monster.element     = elem == "Fire" ? FIRE : WATER
			monster.canBleed    = FALSE
			monster.calcStats()

			if(elem == "Fire")
				monster.drops = list("2" = /obj/items/ember_of_despair)
			else
				monster.drops = list("2" = /obj/items/ember_of_frost)

			animate(monster, alpha = 255, time = 5)
			mobs += monster

			sleep(5)

		sleep(30)
		animate(src, transform = matrix() * 0.2, time = 20)
		sleep(20)
		loc = null

		for(var/mob/Enemies/Summoned/mon in mobs)
			mon.Dispose()
			mon.ChangeState(mon.INACTIVE)
			mobs -= mon
		mobs = null


obj/boss/deathdot
	var
		active = 0

	layer      = 6
	icon       = 'turf.dmi'
	icon_state = "hplava"
	alpha      = 0

	Crossed(atom/movable/O)
		if(active && isplayer(O))
			if(!O.LStatusEffects || !(locate(/StatusEffect/Lava) in O.LStatusEffects))
				new /StatusEffect/Lava(O, 3, "Inflamari")


var/list/dungeons = list(
"teleportPointSnake Dungeon" = 10,
"teleportPointSnowman Dungeon" = 10,
"teleportPointForbidden Library" = 9,
"cow dungeon level 1" = 8,
"PumpkinEntrance" = 5,
"teleportPointCoS Floor 3" = 10)