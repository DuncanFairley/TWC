/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
var/EventScheduler/tempFix/scheduler = new()
atom/var/tmp/list/StatusEffect/LStatusEffects

EventScheduler/tempFix
	__iteration()
		src.__tick+=__sleep_delay
		var/list/execute = src.__shift_down_events()
		if (execute)
			QuickSort(execute, /EventScheduler/proc/__sort_priorities)
			for (var/__Trigger/T in execute)
				T.__event.fire()
				src.__trigger_mapping.Remove(T.__event)
		if (src.__tick == 16777216)
			src.__tick = 0

	__shift_down_events()
		var/list/result = null
		for (var/T in src.__scheduled_events)
			var/A = src.__scheduled_events[T]
			src.__scheduled_events.Remove(T)
			var/index = text2num(T) - __sleep_delay
			if (index > 0)
				src.__scheduled_events[num2text(index, 8)] = A
			else
				for (var/__Trigger/Tr in A)
					if (Tr.__scheduled_iterations > 0)
						Tr.__scheduled_iterations--
						var/new_index = Tr.__scheduled_iterations ? 16777216 : Tr.__scheduled_time
						var/list/S = src.__scheduled_events[text2num(new_index)]
						if (S)
							S += Tr
						else
							src.__scheduled_events[text2num(new_index)] = list(Tr)
					else
						if (result)
							result += Tr
						else
							result = list(Tr)

				result = A
		return result

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
			if(AttachedStatusEffect)AttachedStatusEffect.Deactivate()

	AFKCheck

		fire()
			set waitfor = 0
			spawn(600) scheduler.schedule(src, rand(9000, 12000) + 600) // 16 to 21 minutes
			AFK_Train_Scan()

	Auction

		fire()
			set waitfor = 0
			spawn() scheduler.schedule(src, 36000)
			auctionBidTime()

	DailyEvents

		fire()
			set waitfor = 0
			spawn() scheduler.schedule(src, 864000)

			worldData.loggedIn = null

	AutoClass

		fire()
			set waitfor = 0
			spawn()
				scheduler.schedule(src, 6048000) // 1 week
				var/RandomEvent/Class/auto_class = locate() in worldData.events
				auto_class.start()

	ClanWars

		fire()
			set waitfor = 0
			spawn()
				scheduler.schedule(src, 6048000) // 1 week
				toggle_clanwars()

	Weather
		fire()
			set waitfor = 0

			spawn() scheduler.schedule(src, rand(9000, 27000)) // // 15 to 45 minutes
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
			spawn() scheduler.schedule(src, 6048000) // 1 week
			RandomizeShop()
			rewardExpWeek()

			worldData.elderWand = null

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
					guilds[id] = g.Score()

				bubblesort_by_value(guilds)

				worldData.majorChaos = guilds[1]
				worldData.majorPeace = guilds[guilds.len]

			// rep/fame decay + clean player data
			cleanPlayerData(0)

	RandomEvents
		fire()
			set waitfor = 0

			if(classdest || clanwars)
				spawn(100) scheduler.schedule(src, rand(18000, 36000))  // 30 minutes to 1 hour

				if(classdest)
					for(var/mob/Player/p in Players)
						if(p.Gm)
							p << errormsg("<b>Automated event just skipped because class guidance is on, please turn it off if no classes are going on.</b>")
			else
				spawn(100) scheduler.schedule(src, rand(36000, 72000))  // 1 hour to 2 hours
				var/list/l = list()
				for(var/RandomEvent/e in worldData.events)
					if(e.chance == 0) continue
					l[e] = e.chance

				var/RandomEvent/e = pickweight(l)
				e.start()


WorldData/var/tmp/list/weather_effects = list("acid"        = 7,
											  "snow"        = 7,
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
	//	scheduler.set_sleep_delay(10)
		scheduler.start()
		init_books()
		init_weather()
		init_random_events()
		init_auction()

		spawn()
			RandomizeShop()
			var/date = time_until("Sunday", "00")
			if(date != -1)
				var/Event/WeeklyEvents/e = new
				scheduler.schedule(e, 10 * date)
		init_quests()

		var/Event/DailyEvents/e = new
		scheduler.schedule(e, 864000)

		worldData.TeleportMap = new
		worldData.TeleportMap.init()

atom/proc/findStatusEffect(var/type)
	return src.LStatusEffects ? locate(type) in src.LStatusEffects : 0
proc/issafezone(area/A, useOverride=1,useTimedProtection=1)
	if(useOverride) useOverride = A.safezoneoverride
	. = safemode && !useOverride && (!istype(A,/area/hogwarts/Duel_Arenas) && (istype(A,/area/hogwarts) || istype(A,/area/Diagon_Alley)|| istype(A,/area/safezone)))
	if(useTimedProtection)
		. = . || (A.timedProtection && safemode)
proc/canUse(mob/Player/M,var/StatusEffect/cooldown=null,var/needwand=1,var/inarena=1,var/insafezone=1,var/inhogwarts=1,var/mob/Player/target=null,var/mpreq=0,var/againstocclumens=1,var/againstflying=1,var/againstcloaked=1,var/projectile=0,var/antiTeleport=0,var/useTimedProtection=0)
	//Returns 1 if you can use the item/cast the spell. Also handles the printing of messages if you can't.
	if(!M.loc)
		M << "<b>You cannot use this in the void.</b>"
		return 0
	var/area/A = M.loc.loc
	if(M.z >= SWAPMAP_Z && !inhogwarts)
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
	if(target && !target.key)
		M << "<b>You can only use this on other players.</b>"
		return 0
	if(needwand && !(locate(/obj/items/wearable/wands) in M:Lwearing))
		M << "<b>You must have a drawn wand to cast this.</b>"
		return 0
	if(M.Detention)
		M << "<b>You can't use this in Detention.</b>"
		return 0
	if(mpreq && M.MP < mpreq)
		M << "<b>You require [mpreq] MP to cast this.</b>"
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
	Poisoned
	SteppedOnPoop
	Flying
	Apparate
	UsedEpiskey
	UsedImmobulus
	Summoned
	Decloaked
	Knockedfrombroom
	UsedFerulaToHeal
	UsedFerula
	UsedLevicorpus
	UsedEvanesco
	UsedEvanesca
	UsedLumos
	UsedClanAbilities
	UsedIncindia
	UsedStun
	UsedFlagrate
	UsedTransfiguration
	UsedAnnoying
	UsedPortus
	UsedHalloweenBucket
	UsedSonic
	UsedSnowRing
	UsedArcesso
	UsedProtego
	UsedShelleh
	UsedAggro
	Permoveo
	UsedDisperse
	SpellText
	DisableProjectiles
	KilledPlayer
	KilledPlayerQuest
	UsedRepel
	UsedRiddikulus
	UsedGMHelp
	DisplayedTrophy


	Potions
		var/obj/items/potions/potion
		New(atom/pAttachedAtom,t,cooldownname,obj/items/potions/p)
			potion = p
			.=..()

		Activate()
			..()

		Deactivate()
			var/mob/Player/p = AttachedAtom
			if(p)
				p << errormsg("Your potion's effect fades.")

				for(var/hudobj/Cooldown/c in p.client.screen)
					if(c.name == "Potion")
						c.maptext = null
						c.hide()
						break

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

					src=null
					spawn(6)
						if(p.followers && !p.flying)
							var/obj/Shadow/s = locate(/obj/Shadow) in p.followers
							if(s)
								s.Dispose()
								p.removeFollower(s)
								animate(p, flags = ANIMATION_END_NOW)

				..()

		Tame
			var/factor = 10

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
				factor = factor + (potion.quality - 4) * 0.1

				..()

		Speed
			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.superspeed = 1

				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.superspeed = 0

				..()

		Damage
			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.clothDmg += 40 + (potion.quality - 4) * 4

				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.clothDmg -= 40 + (potion.quality - 4) * 4

				..()

		Defense
			Activate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.clothDef += 120 + (potion.quality - 4) * 12
					p.resetMaxHP()

				..()

			Deactivate()
				var/mob/Player/p = AttachedAtom
				if(p)
					p.clothDef -= 120 + (potion.quality - 4) * 12
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

				amount += (potion.quality - 4) * 10

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


		Mana
			var/amount = 150

			Activate()
				set waitfor = 0
				..()
				var/mob/Player/p = AttachedAtom

				amount += (potion.quality - 4) * 10

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

		Farming

		DropRate
			var/rate
			Double
				rate = 2
			Triple
				rate = 3
			Quadaple
				rate = 4
			Penta
				rate = 5
			Sextuple
				rate = 6

		Exp
			var/rate
			Double
				rate = 2
			Triple
				rate = 3
			Quadaple
				rate = 4
			Penta
				rate = 5
			Sextuple
				rate = 6

		Gold
			var/rate
			Double
				rate = 2
			Triple
				rate = 3
			Quadaple
				rate = 4
			Penta
				rate = 5
			Sextuple
				rate = 6

		Damage
			Activate()
				..()
				var/mob/Player/p = AttachedAtom
				p.clothDmg += 30
			Deactivate()
				var/mob/Player/p = AttachedAtom
				p.clothDmg -= 30
				..()

		Defense
			Activate()
				..()
				var/mob/Player/p = AttachedAtom
				p.clothDef += 90
				p.resetMaxHP()
			Deactivate()
				var/mob/Player/p = AttachedAtom
				p.clothDef -= 90
				p.resetMaxHP()
				..()

		Power
			Activate()
				..()
				var/mob/Player/p = AttachedAtom
				p.clothDmg += 40
				p.clothDef += 120
				p.resetMaxHP()
			Deactivate()
				var/mob/Player/p = AttachedAtom
				p.clothDmg -= 40
				p.clothDef -= 120
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
			AttachedAtom << infomsg("[lamp]'s effect fades.")
			lamp.seconds = round(scheduler.time_to_fire(AttachedEvent)/10)
			if(lamp.seconds <= 0)
				AttachedAtom << errormsg("[lamp] disappears into thin air.")

				lamp.Unmacro(AttachedAtom)
				lamp.Dispose()
				AttachedAtom:Resort_Stacking_Inv()
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
						c.hide()
						break
			..()

		New(atom/pAttachedAtom,t,cooldownName,obj/items/lamps/p)
			lamp = p
			.=..(pAttachedAtom, t, cooldownName)

	var/Event/e_StatusEffect/AttachedEvent	//Not required - Contains /Event/e_StatusEffect to automatically cancel the StatusEffect
	var/atom/AttachedAtom	//Required - Contains the /atom which the StatusEffect is attached to
	proc
		cantUseMsg(M)
			//Return 1 if it's a genuine event
			var/timeleft = round(scheduler.time_to_fire(AttachedEvent)/10)
			if(timeleft <= 0)
				//scheduler.cancel(src.AttachedEvent)
				del(src)
				return 0
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
			while(maptext != null && roundedTime > 1)
				roundedTime--
				maptext = "<span style=\"color:[Client.mob:mapTextColor];font-size:2px;\"><b>[roundedTime]</b></span>"
				sleep(10)

			if(maptext != null)
				sleep(extraTicks*10)
			hide()