var/EventScheduler/tempFix/scheduler = new()
var/EventScheduler/tempFix/schedulerMin = new()
atom/var/tmp/list/StatusEffect/LStatusEffects

EventScheduler/tempFix

	var/last_world_time

	schedule(var/Event/E, var/ticks as num, var/priority = 0)

		var/elapsed = world.time - last_world_time

		var/__Trigger/T = new(E, src.__tick + elapsed, ticks, 0)

		// we have to add elapsed because next iteration it'll attempt to remove sleep delay including elapsed
		ticks += elapsed

		if (T.__scheduled_iterations > 0)
			ticks = num2text(16777216, 8)
		else
			ticks = num2text(ticks, 8)
		var/list/A = src.__scheduled_events[ticks]
		if (A)
			A += T
		else
			src.__scheduled_events[ticks] = list(T)
		src.__trigger_mapping[E] = T

	time_to_fire(var/Event/E)
		var/__Trigger/T = src.__trigger_mapping[E]
		if (T)
			var/elapsed = world.time - last_world_time
			return ((T.__scheduled_iterations * 16777216) + T.__scheduled_time) - src.__tick - elapsed
		return -1

	__iteration()
		__tick+=__sleep_delay
		last_world_time = world.time
//		__tick++
		if(__tick > 16777216) __tick = 16777216
		var/list/execute = __shift_down_events()
		if (execute)
//			QuickSort(execute, /EventScheduler/proc/__sort_priorities)
			for (var/__Trigger/T in execute)
				spawn() T.__event.fire()
				__trigger_mapping.Remove(T.__event)
		if (__tick >= 16777216)
			__tick = 0

	__shift_down_events()
		var/list/result = null
		for (var/T in src.__scheduled_events)
			var/A = src.__scheduled_events[T]
			src.__scheduled_events.Remove(T)
			var/index = text2num(T)
			index -= __sleep_delay
			if (index > 0)
				src.__scheduled_events[num2text(index, 8)] = A
			else
				for (var/__Trigger/Tr in A)
					if (Tr.__scheduled_iterations > 0)
						Tr.__scheduled_iterations--
						var/new_index = Tr.__scheduled_iterations ? 16777216 : Tr.__scheduled_time
						var/list/S = src.__scheduled_events[num2text(new_index, 8)]
						if (S)
							S += Tr
						else
							src.__scheduled_events[num2text(new_index, 8)] = list(Tr)
					else
						if (result)
							result += Tr
						else
							result = list(Tr)
		//		result = A
		return result


mob/test/verb/totalScheduler()
	var/c = 0
	var/t = 0
	for (var/T in scheduler.__scheduled_events)
		var/A = scheduler.__scheduled_events[T]
		c++
		for (var/__Trigger/Tr in A)
			src << "[T] - [Tr.__event.type]"
			t++
	src << "total: [c],[t]"

mob/test/verb/totalSchedulerMin()
	var/c = 0
	var/t = 0
	for (var/T in schedulerMin.__scheduled_events)
		var/A = schedulerMin.__scheduled_events[T]
		c++
		for (var/__Trigger/Tr in A)
			src << "[T] - [Tr.__event.type]"
			t++
	src << "total: [c],[t]"


atom/proc/AddStatusEffect(StatusEffect/pStatusEffect)
	if(src.LStatusEffects)
		src.LStatusEffects += pStatusEffect
	else
		src.LStatusEffects = list(pStatusEffect)

atom/proc/RemoveStatusEffect(StatusEffect/pStatusEffect)
	if(src.LStatusEffects)
		src.LStatusEffects -= pStatusEffect
		if(!LStatusEffects.len)
			LStatusEffects = null
Event
	e_StatusEffect
		var/StatusEffect/AttachedStatusEffect

		New(StatusEffect/pStatusEffect)
			//Set Event's parent to the StatusEffect
			..()
			src.AttachedStatusEffect = pStatusEffect

		fire()
			set waitfor = 0
			if(AttachedStatusEffect)AttachedStatusEffect.Deactivate()

	AFKCheck

		fire()
			set waitfor = 0
			spawn(600) schedulerMin.schedule(src, 12000)
			AFK_Train_Scan()

	SaveWorld
		fire()
			set waitfor = 0
			spawn() schedulerMin.schedule(src, 36000)
			for(var/mob/Player/p in Players)
				p.Save()
				sleep(1)
			Save_World()
	Auction

		fire()
			set waitfor = 0
			spawn() schedulerMin.schedule(src, 36000)
			auctionBidTime()


			var/max = 0
			var/house = 0

			for(var/i = 1 to 4)
				if(worldData.housepointsGSRH[i] > max)
					max = worldData.housepointsGSRH[i]
					house = i

			switch(house)
				if(1) house = "Gryffindor"
				if(2) house = "Slytherin"
				if(3) house = "Ravenclaw"
				if(4) house = "Hufflepuff"
				if(0) return

			if(house != worldData.housecupwinner)
				worldData.housecupwinner = house
				Players << "<b><span style=\"color:#CF21C0;\">[worldData.housecupwinner] moved to the top and gained favour. They receive +50% drop rate/gold/XP from monster kills.</span></b>"


	DailyEvents

		fire()
			set waitfor = 0
			schedulerMin.schedule(src, 864000)

			worldData.loggedIn = null

	AutoClass

		fire()
			set waitfor = 0

			schedulerMin.schedule(src, 6048000) // 1 week
			var/RandomEvent/Class/auto_class = locate() in worldData.events
			auto_class.start()

	ClanWars

		fire()
			set waitfor = 0

			schedulerMin.schedule(src, 6048000) // 1 week
			toggle_clanwars()

	Weather
		fire()
			set waitfor = 0

			schedulerMin.schedule(src, rand(9000, 27000)) // // 15 to 45 minutes
			var/i = pickweight(worldData.weather_effects)
			switch(i)
				if("acid")        weather.acid()
				if("snow")        weather.snow()
				if("rain")        weather.rain()
				if("cloudy")      weather.clear(10)
				if("sunny")       weather.clear()

	WeeklyEvents
		fire()
			set waitfor = 0
			schedulerMin.schedule(src, 6048000) // 1 week
			RandomizeShop()
			rewardExpWeek()

			worldData.elderWand = null

			awardcup()

			for(var/i = 1 to 4)
				worldData.housepointsGSRH[i] = 0

			// player shops
			if(worldData.playerShops)
				for(var/shopId in worldData.playerShops)
					var/playerShop/shop = worldData.playerShops[shopId]

					if(!shop.loaded && !shop.owner && !shop.bidCkey)
						worldData.playerShops -= shopId
						continue

					if(shop.owner != shop.bidCkey)
						if(shop.owner)
							shop.reset()

					if(shop.bidCkey)
						shop.owner = shop.bidCkey
						mail(shop.owner, "You won the bid on [shop.id] shop.")

					shop.bidCkey  = null
					shop.bidCount = 0

			// elects major guilds
			if(worldData.guilds && worldData.guilds.len >= 2)

				var/list/guilds = list()
				for(var/id in worldData.guilds)
					var/guild/g = worldData.guilds[id]

					var/isActive = 0
					for(var/member in g.members)
						var/PlayerData/p = worldData.playersData[member]
						if(world.realtime - p.time <= 12096000)
							isActive = 1
							break

					if(isActive)
						guilds[id] = g.Score()

				quicksortValue(guilds)

				if(guilds[guilds[1]] <= -100)
					worldData.majorChaos = guilds[1]
				else
					worldData.majorChaos = null

				if(guilds[guilds[guilds.len]] >= 100)
					worldData.majorPeace = guilds[guilds.len]
				else
					worldData.majorPeace = null

			// rep/fame decay + clean player data
			cleanPlayerData(1)

			Save_World()

	RandomEvents
		fire()
			set waitfor = 0

			if(classdest || clanwars)
				schedulerMin.schedule(src, rand(6000, 9000))  // 10 minutes to 15 minutes

				if(classdest)
					for(var/mob/Player/p in Players)
						if(p.Gm)
							p << errormsg("<b>Automated event just skipped because class guidance is on, please turn it off if no classes are going on.</b>")
			else
				spawn(100)
					while(worldData.currentEvents)
						sleep(600)
					schedulerMin.schedule(src, 6000)
				var/list/l = list()
				for(var/RandomEvent/e in worldData.events)
					if(e.chance == 0) continue
					l[e] = e.chance

				var/RandomEvent/e = pickweight(l)
				e.start()


WorldData/var/tmp/list/weather_effects = list("acid"        = 5,
											  "snow"        = 5,
										  	  "rain"        = 15,
											  "cloudy"      = 25,
											  "sunny"       = 60)

proc/cleanPlayerData(decay = 0)
	for(var/ckey in worldData.playersData)

		var/PlayerData/p = worldData.playersData[ckey]

		if(abs(p.fame) <= 100)
			if(p.mmWins != initial(p.mmWins) ||\
			   p.mmRating != initial(p.mmRating) ||\
			   p.guild) continue

			if(p.mmTime == initial(p.mmTime) || world.realtime - p.mmTime < 25920000)
				if(p.time == initial(p.time) || world.realtime - p.time < 25920000)
					worldData.playersData -= ckey

			continue

		if(decay)
			if(world.realtime - p.time < 2592000) continue
			p.fame -= round(p.fame * 0.01) // temp reduced from 0.05

		if (world.tick_usage > 80) lagstopsleep()

proc
	init_events()
		scheduler.set_sleep_delay(10)
		scheduler.start()
		schedulerMin.set_sleep_delay(600)
		schedulerMin.start()
		init_books()
		init_weather()
		init_random_events()
		init_auction()

		var/Event/SaveWorld/s = new
		schedulerMin.schedule(s, 36000)

		spawn()
			RandomizeShop()
			var/Event/WeeklyEvents/w = new
			schedulerMin.schedule(w, 10 * rustg_seconds_until("sunday"))

			var/Event/DailyEvents/d = new
			schedulerMin.schedule(d, 10 * rustg_seconds_until("tomorrow"))

		init_quests()

		worldData.TeleportMap = new
		worldData.TeleportMap.init()

atom/proc/findStatusEffect(var/type)
	return src.LStatusEffects ? locate(type) in src.LStatusEffects : 0
proc/issafezone(area/A, useOverride=1,useTimedProtection=1)
	if(useOverride) useOverride = A.safezoneoverride
	. = safemode && !useOverride && (!istype(A,/area/hogwarts/Duel_Arenas) && (istype(A,/area/hogwarts) || istype(A,/area/Diagon_Alley)|| istype(A,/area/safezone)))
	if(useTimedProtection)
		. = . || (A.timedProtection && safemode)
proc/canUse(mob/Player/M,var/StatusEffect/cooldown=null,var/needwand=1,var/inarena=1,var/insafezone=1,var/inhogwarts=1,var/mob/Player/target=null,var/mpreq=0,var/againstocclumens=1,var/againstflying=1,var/againstcloaked=1,var/projectile=0,var/antiTeleport=0,var/useTimedProtection=0,var/silent=0)
	//Returns 1 if you can use the item/cast the spell. Also handles the printing of messages if you can't.
	if(!M.loc)
		M << "<b>You cannot use this in the void.</b>"
		return 0
	if(target && !isplayer(target))
		M << "<b>You can only use this on other players.</b>"
		return 0
	var/area/A = M.loc.loc
	if(M.z >= SWAPMAP_Z && !inhogwarts && !(M.z in  worldData.sandboxZ))
		M << "<b>You cannot use this in a vault.</b>"
		return 0
	if(target && !insafezone && issafezone(target.loc.loc, 1, useTimedProtection))
		M << "<b>[target] is inside a safezone.</b>"
		return 0
	if(antiTeleport && M.loc.loc:antiTeleport)
		M << "<b>You can't use this here.</b>"
		return 0
	if(!A.safezoneoverride || (useTimedProtection && A.timedProtection))
		if(!inhogwarts && istype(M.loc.loc,/area/hogwarts))
			M << "<b>You can't use this inside hogwarts.</b>"
			return 0
		if(!insafezone && issafezone(M.loc.loc))
			M << "<b>You can't use this inside a safezone.</b>"
			return 0
		if(!inarena && istype(M.loc.loc,/area/arenas))
			M << "<b>You can't use this inside an arena.</b>"
			return 0
	if(target && !againstflying && target.flying)
		M << "<b>[target]'s broom is enhanced with anti-tampering charms.</b>"
		return 0
	if(!target && !againstflying && M.flying)
		M << "<b>Your broom is enhanced with anti-tampering charms.</b>"
		return 0
	if(target && !againstcloaked && (locate(/obj/items/wearable/invisibility_cloak) in target.Lwearing))
		M << "<b>Your spell doesn't manage to break the charms surrounding [target]'s cloak.</b>"
		return 0
	if(!target && !againstcloaked && (locate(/obj/items/wearable/invisibility_cloak) in M.Lwearing))
		M << "<b>Your cloak prevents this spell from being cast.</b>"
		return 0
	if(!againstocclumens && (target.occlumens || target.prevname))
		M << "<b>A charm blocks your spell.</b>"
		return 0
	if(needwand && !(locate(/obj/items/wearable/wands) in M:Lwearing))
		M << "<b>You must have a drawn wand to cast this.</b>"
		return 0
	if(M.Detention)
		M << "<b>You can't use this in Detention.</b>"
		return 0
	if(mpreq && M.MP < mpreq)
		if(!silent) M << "<b>You require [mpreq] MP to cast this.</b>"
		return 0
	if(cooldown)
		var/StatusEffect/S = M.findStatusEffect(cooldown)
		if(S)
			if(S.cantUseMsg(M))	//Says how long you need to wait to use the item/spell again
				return 0
	if(projectile)
		var/StatusEffect/S = M.findStatusEffect(/StatusEffect/DisableProjectiles)
		if(S)
			return 0
	return 1

mob/Player/var/tmp/lastCDMsg = -1#INF

StatusEffect
/*	ClanWars
		ReinforcedDoors
			Activate()
				..()
				if(!isarea(AttachedAtom))
					world.log << "[AttachedAtom] is supposed to be an /area - /StatusEffect/ClanWars/ReinforcedDoors/Activate()"
				else
					if(istype(AttachedAtom,/area/DEHQ))
						for(var/mob/M in Players)if(M.DeathEater)
							M << "<span style=\"color:#E0E01D;\"><b>The Deatheater HQ doors have been reinforced.</b></span>"
					else if(istype(AttachedAtom,/area/AurorHQ))
						for(var/mob/M in Players)if(M.Auror)
							M << "<span style=\"color:#E0E01D;\"><b>The Auror HQ doors have been reinforced.</b></span>"
					for(var/obj/brick2door/clandoor/D in AttachedAtom)//An /area
						D.MHP = 2*initial(D.MHP)
			Deactivate()
				if(!isarea(AttachedAtom))
					world.log << "[AttachedAtom] is supposed to be an /area - /StatusEffect/ClanWars/ReinforcedDoors/Deactivate()"
				else
					for(var/obj/brick2door/clandoor/D in AttachedAtom)//An /area
						D.MHP = initial(D.MHP)
						if(D.HP > D.MHP) D.HP = D.HP
				..()*/
	GotSpellpoint
	SteppedOnPoop
	Flying
	Apparate
	UsedEpiskey
	UsedImmobulus
	UsedReducto
	Summoned
	Decloaked
	Knockedfrombroom
	UsedLevicorpus
	UsedEvanesco
	UsedEvanesca
	UsedLumos
	UsedClanAbilities
	UsedIncindia
	UsedStun
	UsedReparo
	UsedFlagrate
	UsedTransfiguration
	UsedAnnoying
	UsedPortus
	UsedHalloweenBucket
	UsedSonic
	UsedArcesso
	UsedProtego
	UsedShelleh
	UsedAggro
	UsedAccio
	UsedTelendevour
	UsedOcclumency
	UsedAvada
	UsedImperio
	Permoveo
	UsedDisperse
	SpellText
	DisableProjectiles
	KilledPlayer
	KilledPlayerQuest
	UsedRepel
	UsedRiddikulus
	UsedIllusio
	UsedGMHelp
	DisplayedTrophy
	DodgedDeath
	SantaSpawned
	WandPower

	Slugs
		var/filter
		var/mob/Player/owner

		New(atom/pAttachedAtom,t,cooldownname,mob/Player/owner)
			src.owner = owner
			.=..()

		Activate()
			set waitfor = 0
			..()
			var/mob/Enemies/e = AttachedAtom

			var/c = "#080"

			e.filters += filter(type="color", color=list(c, c, c))
			filter = e.filters[e.filters.len]

			var/dmg = (owner.Dmg + owner.clothDmg) * 0.2

			while(e)

				if(prob(15))
					for(var/mob/Enemies/spread in range(1, e))
						if(e == spread) continue
						if(!spread.findStatusEffect(/StatusEffect/Slugs))
							new /StatusEffect/Slugs (spread, 10, owner=owner)
							break

				e.onDamage(dmg, owner)
				sleep(10)



		Deactivate()
			var/mob/Enemies/e = AttachedAtom
			if(e)
				e.filters -= filter
				filter = null

			..()


	Bind
		var/filter
		var/time

		New(atom/pAttachedAtom,t,cooldownname,time)
			src.time = time
			.=..()

		Activate()
			..()
			var/mob/Enemies/e = AttachedAtom
			var/c = "#aaa"

			e.filters += filter(type="color", color=list(c, c, c))
			filter = e.filters[e.filters.len]

			e.slow+=time
			e.lag+=time
			e.glide_size = 32
			e.stun = 1

		Deactivate()
			var/mob/Enemies/e = AttachedAtom
			if(e)
				e.filters -= filter
				filter = null

				e.slow-=time
				e.lag-=time
				e.glide_size = 32/e.lag
				e.stun = 0
			..()

	Slow
		var/filter

		Activate()
			..()
			var/mob/Enemies/e = AttachedAtom
			var/c = "#acd5f3"

			e.filters += filter(type="color", color=list(c, c, c))
			filter = e.filters[e.filters.len]

			e.slow+=3
			e.lag+=3
			e.glide_size = 32/e.lag

		Deactivate()
			var/mob/Enemies/e = AttachedAtom
			if(e)
				e.filters -= filter
				filter = null

				e.slow-=3
				e.lag-=3
				e.glide_size = 32/e.lag
			..()

	Crucio
		var/filter

		Activate()
			..()
			var/mob/m = AttachedAtom
			var/c = "#663a82"

			m.filters += filter(type="color", color=list(c, c, c))
			filter = m.filters[m.filters.len]

			if(ismonster(m))
				m:damageMod += 0.3
			else
				m:monsterDef -= 30

		Deactivate()
			var/mob/m = AttachedAtom
			if(m)
				m.filters -= filter
				filter = null

				if(ismonster(m))
					m:damageMod -= 0.3
				else
					m:monsterDef += 30
			..()
	Lava
		Activate()
			set waitfor = 0
			..()
			var/mob/Player/p = AttachedAtom

			p.filters += filter(type="outline", size=1, color="#ffa500")

			p.filters += filter(type="wave", x=60*rand() - 30, y=60*rand() - 30, size=rand()*2.5+0.5, offset=rand())

			var/f = p.filters[p.filters.len]
			animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
			animate(offset=f:offset-1, time=rand()*20+2)

			var/lavawalk = (RING_LAVAWALK in p.passives) ? p.passives[RING_LAVAWALK] : 0

			var/dmg = lavawalk ? 201 - lavawalk : (450 + rand(-50, 50))

			while(p)

				var/reducedDamage = 0
				if(p.Shield > 0)
					var/tShield = p.Shield
					p.Shield = max(p.Shield - dmg*2, 0)

					reducedDamage = abs(tShield - p.Shield)

				if((RING_NURSE in p.passives) && p.HP - (dmg - reducedDamage) <= 0)
					usr = p
					usr:Episky()

					if(!p.findStatusEffect(/StatusEffect/DodgedDeath))
						reducedDamage = dmg
						new /StatusEffect/DodgedDeath(p, 150)

				p.HP -= dmg - reducedDamage
				if(p.HP <= 0)
					p.Death_Check(p)
					break
				else
					p.updateHP()


				dmg *= lavawalk ? 1.51 - (lavawalk / 100) : 2

				sleep(10)

		Deactivate()
			var/mob/Player/p = AttachedAtom
			if(p)

				var/onLava = 0

				if(istype(p.loc, /turf/lava))
					onLava = 1
				else
					var/obj/boss/deathdot/d = locate() in p.loc
					if(d && d.active) onLava = 1

				if(onLava)
					scheduler.schedule(AttachedEvent,30)
					new /hudobj/Cooldown (null, p.client, null, "Inflamari", 3, show=1)
					return

				p.filters = null

			..()

	Potions
		var/obj/items/potions/potion
		var/quality
		New(atom/pAttachedAtom,t,cooldownname,obj/items/potions/p)
			potion = p
			quality = p.quality
			.=..()

		Activate()
			..()

		Deactivate(var/expire=1)
			var/mob/Player/p = AttachedAtom
			if(p)
				for(var/hudobj/Cooldown/c in p.client.screen)
					if(c.name == "Potion")
						c.maptext = null
						c.hide(1)
						break

				if(expire && p.potionsMode != THROW && (RING_FAIRY in p.passives))
					usr=p
					potion.Click(fairy=1)
				else
					p << errormsg("Your potion's effect fades.")

			..()


		Blackout
			Activate()
				set waitfor = 0
				var/mob/Player/p = AttachedAtom
				if(p)
					animate(p.client, color = "#222", time = 30)
				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					animate(p.client, color = null, time = 30)

				..()

		Polyjuice
			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.noOverlays++
				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.BaseIcon()
					p.ApplyOverlays()
					p.underlays = list()
					p.addNameTag()
					p.noOverlays--

				..()

		Confusion
			Activate()
				set waitfor = 0
				var/mob/Player/p = AttachedAtom
				..()

				p << errormsg("You feel confused...")

				var/matrix/m = p.Interface.mapplane.transform
				m.Turn(90 * rand(-2, 2))
				m.Scale(1.25,1.25)
				p.client.screen += p.Interface.mapplane
				animate(p.Interface.mapplane, transform = m, time = 10)

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					animate(p.Interface.mapplane, transform = null, time = 10)
					sleep(11)
					if(p) p.client.screen -= p.Interface.mapplane

				..()

		Pumpkin
			var/tmp/image/i
			Activate()
				set waitfor = 0
				var/mob/Player/p = AttachedAtom
				..()
				i = image('attacks.dmi',icon_state="melofors")
				p.overlays += i
				animate(p.client, color = "#FFA500", time = 20)


			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p && i)
					p.overlays -= i
					animate(p.client, color = null, time = 20)
				..()

		FakeDead
			Activate()
				set waitfor = 0
				var/mob/Player/p = AttachedAtom
				..()
				var/matrix/m = p.transform
				m.Turn(90 * pick(1, -1))
				animate(p, transform = m, time = 10, easing = pick(BOUNCE_EASING, BACK_EASING))


			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					animate(p, transform = null, time = 10)
				..()

		LegendaryEffect
			var/passives
			Activate()
				set waitfor = 0
				var/mob/Player/p = AttachedAtom
				..()

				for(var/passive in passives)
					if(!p.passives) p.passives = list()
					p.passives[passive] += quality


			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)

					for(var/passive in passives)

						p.passives[passive] -= quality
						if(p.passives[passive] <= 0) p.passives -= passive
						if(!p.passives.len) p.passives = null

				..()

		Rainbow
			Activate()
				set waitfor = 0
				..()
				var/mob/Player/p = AttachedAtom
				if(p)
					var/list/colors = list("#ff0000", "#ff7f00", "#ffff00", "#00ff00", "#0000ff", "#4b0082", "8f00ff")
					for(var/i = 1 to 7)
						var/ColorMatrix/c = new(colors[i], 0.7)
						colors[i] = c.matrix

					while(p)
						for(var/i = 1 to 7)
							animate(p.client, color = colors[i], time = 24)
							sleep(25)


			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					animate(p.client, color = null, time = 10)

				..()

		Animagus
			Activate()
				set waitfor = 0
				AttachedAtom << infomsg("Walk on animal statue you wish to select as your animagus, you can change while this potion is in effect.")
				..()

		Vampire
			var/tmp/c
			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)

					p.density = 0
					p.flying = 1
					p.icon_state = "flying"

					for(var/obj/items/wearable/brooms/W in p.Lwearing)
						if(W != src)
							W.Equip(p,1,1)

					p.layer   = 5
					animateFly(p)

					if(!p.followers || !(locate(/obj/Shadow) in p.followers))
						var/obj/Shadow/s = new (p.loc)
						p.addFollower(s)

					var/image/i = new('VampireWings.dmi', "flying")
					i.layer = FLOAT_LAYER - 3
					i.pixel_x = -16
					i.pixel_y = -16
					i.color = rgb(rand(20,240), rand(20,240), rand(20,240))
					c = i.color

					p.overlays += i

				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)

					p.density = 1
					p.flying = 0
					p.icon_state = ""

					animate(p, pixel_y = 0, time = 5)
					p.layer   = 4

					var/image/i = new('VampireWings.dmi', "flying")
					i.layer = FLOAT_LAYER - 3
					i.pixel_x = -16
					i.pixel_y = -16
					i.color = c

					p.overlays -= i

					spawn(6)
						if(p.followers && !p.flying)
							var/obj/Shadow/s = locate(/obj/Shadow) in p.followers
							if(s)
								s.Dispose()
								p.removeFollower(s)
								animate(p, flags = ANIMATION_END_NOW)

				..()

		Tame
			var/factor = 15

			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)

					p.clothDmg -= 160
					p.clothDef -= 480
					p.resetMaxHP()

					if(p.Def - 480 <= 0)
						p.HP = 0
						p.Death_Check()
						Deactivate()

				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.clothDmg += 160
					p.clothDef += 480
					p.resetMaxHP()

				..()

		Luck
			var/factor = 3

			Activate()
				factor = factor * max(1 + (quality - 6) * 0.2, 0.1)

				..()

		Speed
			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.superspeed = 1
					p.dashDistance += 8

				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.superspeed = 0
					p.dashDistance -= 8

				..()

		Size
			var/size = 1
			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)
					animate(p, transform = matrix()*size, time=10)

				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					animate(p, transform = null, time=10)

				..()

		Armor
			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.Armor += 400 + max(1 + (quality - 6) * 0.2, 0.1)

				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.Armor -= 400 + max(1 + (quality - 6) * 0.2, 0.1)

				..()

		Damage
			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.clothDmg += 270 + (quality - 6) * 60

				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.clothDmg -= 270 + (quality - 6) * 60

				..()

		Defense
			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.clothDef += 810 + (quality - 6) * 180
					p.resetMaxHP()

				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.clothDef -= 810 + (quality - 6) * 180
					p.resetMaxHP()

				..()

		Stone
			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.slow += 1
					p << infomsg("You feel heavy.")

				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.slow -= 1

				..()

		Frost
			Activate()
				set waitfor = 0
				..()
				var/mob/Player/p = AttachedAtom
				var/i = 0
				while(p)
					if(i == 4) i = 0
					for(var/turf/water/t in oview(i, p))
						if(prob(40)) continue
						if(t.icon_state == "water") t.ice()

					i++

					emit(loc    = p,
						 ptype  = /obj/particle/smoke,
						 amount = 2,
						 angle  = new /Random(1, 359),
					     speed  = 4,
						 life   = new /Random(4, 8),
						 color  = "#6bc")

					sleep(10)


		Heat
			Activate()
				set waitfor = 0
				..()
				var/mob/Player/p = AttachedAtom
				var/i = 0
				while(p)
					if(i == 4) i = 0
					for(var/turf/water/t in oview(i, p))
						if(prob(40)) continue
						if(t.icon_state == "ice") t.water()

					i++

					emit(loc    = p,
						 ptype  = /obj/particle/smoke,
						 amount = 2,
						 angle  = new /Random(1, 359),
					     speed  = 4,
						 life   = new /Random(4, 8),
						 color  = "#c60")

					sleep(10)


		Health
			var/amount = 1000

			Activate()
				set waitfor = 0
				..()
				var/mob/Player/p = AttachedAtom

				if(amount >= 90000) p.monsterDef += 100

				amount += (quality - 6) * 10

				while(p)
					p.HP = min(p.HP + amount + rand(-10, 10), p.MHP)
					p.updateHP()

					emit(loc    = p,
						 ptype  = /obj/particle,
						 amount = 1,
						 angle  = new /Random(1, 359),
					     speed  = 4,
						 life   = new /Random(4, 8),
						 color  = "green")

					sleep(10)

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					if(amount >= 90000) p.monsterDef -= 100

				..()


		Mana
			var/amount = 150

			Activate()
				set waitfor = 0
				..()
				var/mob/Player/p = AttachedAtom

				amount += (quality - 6) * 10

				while(p)
					p.MP = min(p.MP + amount + rand(-10, 10), p.MMP)
					p.updateMP()

					emit(loc    = p,
						 ptype  = /obj/particle,
						 amount = 1,
						 angle  = new /Random(1, 359),
					     speed  = 4,
						 life   = new /Random(4, 8),
						 color  = "#7bf")

					sleep(10)


		Invisibility

			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.FlickState("m-black",8,'Effects.dmi')
					p.invisibility = 2
					p.sight |= SEE_SELF
					p.alpha = 125

				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)

					if(locate(/obj/items/wearable/invisibility_cloak) in p.Lwearing)
						p.invisibility = 1
					else
						p.invisibility = 0
						p.sight &= ~SEE_SELF
						p.alpha = 255

				..()


		NightSight

			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.Interface.SetDarknessColor("#dd9", 1)

				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.Interface.SetDarknessColor("#dd9")

				..()

	Lamps
		var/tmp/obj/items/lamps/lamp

		DropRate
			var/rate
			Double
				rate = 2
			Triple
				rate = 3
			Quadruple
				rate = 4
			Quintuple
				rate = 5
			Sextuple
				rate = 6

		Exp
			var/rate
			Double
				rate = 2
			Triple
				rate = 3
			Quadruple
				rate = 4
			Quintuple
				rate = 5
			Sextuple
				rate = 6

		Gold
			var/rate
			Double
				rate = 2
			Triple
				rate = 3
			Quadruple
				rate = 4
			Quintuple
				rate = 5
			Sextuple
				rate = 6

		Damage
			Activate()
				..()
				var/mob/Player/p = AttachedAtom
				p.clothDmg += 120
			Deactivate()
				var/mob/Player/p = AttachedAtom
				p.clothDmg -= 120
				..()

		Defense
			Activate()
				..()
				var/mob/Player/p = AttachedAtom
				p.clothDef += 360
				p.resetMaxHP()
			Deactivate()
				var/mob/Player/p = AttachedAtom
				p.clothDef -= 360
				p.resetMaxHP()
				..()

		Power
			Activate()
				..()
				var/mob/Player/p = AttachedAtom
				p.clothDmg += 120
				p.clothDef += 360
				p.resetMaxHP()
			Deactivate()
				var/mob/Player/p = AttachedAtom
				p.clothDmg -= 120
				p.clothDef -= 360
				p.resetMaxHP()
				..()

		Activate()
			for(var/StatusEffect/Lamps/s in AttachedAtom.LStatusEffects)
				if(s != src && istype(s, /StatusEffect/Lamps))
					s.Deactivate()
					break
			AttachedAtom << infomsg("You feel the warmth of [lamp]'s magical light.")
			lamp.icon_state = "active"
			..()

		Deactivate()
			if(lamp)
				AttachedAtom << infomsg("[lamp]'s effect fades.")
				lamp.seconds = round(scheduler.time_to_fire(AttachedEvent)/10)
				if(lamp.seconds <= 0)
					AttachedAtom << errormsg("[lamp] disappears into thin air.")

					lamp.Dispose()
				else
					var/min = round(lamp.seconds / 60)
					var/sec = lamp.seconds-(min*60)
					var/time = ""
					if(min) time = "[min] minutes"
					if(sec)
						if(min) time += " and "
						time += "[sec] seconds."
					lamp.desc = "[initial(lamp.desc)] Time Remaining: [time]"
					lamp.icon_state = "inactive"
			if(isplayer(AttachedAtom))
				for(var/hudobj/Cooldown/c in AttachedAtom:client.screen)
					if(c.name == "Lamp")
						c.maptext = null
						c.hide(1)
						break
			..()

		New(atom/pAttachedAtom,t,cooldownName,obj/items/lamps/p)
			lamp = p
			.=..(pAttachedAtom, t, cooldownName)

	var/Event/e_StatusEffect/AttachedEvent	//Not required - Contains /Event/e_StatusEffect to automatically cancel the StatusEffect
	var/atom/AttachedAtom	//Required - Contains the /atom which the StatusEffect is attached to
	proc
		cantUseMsg(mob/Player/M)
			//Return 1 if it's a genuine event

			var/timeleft = round(scheduler.time_to_fire(AttachedEvent)/10)
			if(timeleft <= 0)
				//scheduler.cancel(src.AttachedEvent)
				del(src)
				return 0
			if(world.time - M.lastCDMsg > 10)
				M.lastCDMsg = world.time
				M << "<b>This can't be used for another [timeleft] second[timeleft==1 ? "" : "s"].</b>"
			return 1
	New(atom/pAttachedAtom,t,cooldownName)
		//Attaches a StatusEffect to an atom - if t is specified, an /Event is attached also
		src.AttachedAtom = pAttachedAtom
		src.AttachedAtom.AddStatusEffect(src)
		if(t)
			src.AttachedEvent = new(src)
			scheduler.schedule(src.AttachedEvent,t * 10)
			if(cooldownName)
				var/mob/Player/p = AttachedAtom
				new /hudobj/Cooldown (null, p.client, null, cooldownName, t, show=1)
		Activate()

	Del()
		//Deletes AttachedEvent if exists
		if(src.AttachedEvent)
			scheduler.cancel(src.AttachedEvent)
		..()

	proc
		Activate()
			//Called when /StatusEffect is setup
		Deactivate()
			//Called when the timer in an AttachedEvent runs out
			if(AttachedAtom)//If they're still logged in
				src.AttachedAtom.RemoveStatusEffect(src)
			del(src)

proc
	lagstopsleep()
		var/tickstosleep = 1
		do
			sleep(world.tick_lag*tickstosleep)
			tickstosleep *= 2
		while(world.tick_usage > 75 && (tickstosleep*world.tick_lag) < 32)

hudobj
	Cooldown
		mouse_over_pointer = MOUSE_INACTIVE_POINTER

		anchor_x    = "CENTER"
		screen_x    = -80
		screen_y    = -16
		anchor_y    = "NORTH"
		maptext_y   = -4
		maptext_x   = -4

		icon = 'SpellbookIcons.dmi'

		var/count = 0

		New(loc=null,client/Client,list/Params, name, time, show=1)
			set waitfor = 0

			src.name = name
			icon_state = name

			var/list/l = list()
			for(var/hudobj/Cooldown/c in Client.screen)
				if(count == c.count)
					count++
				else
					l += c.count
			while(count in l)
				count++

			screen_x += (count % 5) * 36
			screen_y -= round(count / 5) * 36

			..(loc,Client,Params,show)

			var/roundedTime = round(time, 1)
			var/extraTicks = abs(roundedTime - time)

			maptext = "<span style=\"color:[Client.mob:mapTextColor];font-size:2px;\"><b>[roundedTime]</b></span>"
			while(maptext != null && roundedTime > 1 && Client)
				roundedTime--
				maptext = "<span style=\"color:[Client.mob:mapTextColor];font-size:2px;\"><b>[roundedTime]</b></span>"
				sleep(10)

			if(Client)
				if(maptext != null)
					sleep(extraTicks*10)
				hide()