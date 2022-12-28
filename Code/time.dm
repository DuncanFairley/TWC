var/list/clanwars_schedule  = list()
var/list/autoclass_schedule = list()

WorldData/var/tmp
	shopPriceModifier = 1
	DropRateModifier  = 1
	expModifier       = 1
	expBookModifier   = 1
	cdrModifier       = 1

WorldData/var/list/passives

mob/GM/verb
	Clan_Wars_Schedule(var/Event/e in clanwars_schedule)
		set category = "Server"
		switch(alert(src, "What do you want to do?", "Events", "Cancel Event", "Check Time", "Nothing"))
			if("Cancel Event")
				scheduler.cancel(clanwars_schedule[e])
				clanwars_schedule -=e
				src << infomsg("Event cancelled.")
			if("Check Time")
				var/ticks = scheduler.time_to_fire(clanwars_schedule[e])
				src << infomsg("[comma(ticks)] ticks until event starts.")

	AutoClass_Schedule(var/Event/e in autoclass_schedule)
		set category = "Server"
		switch(alert(src, "What do you want to do?", "Events", "Cancel Event", "Check Time", "Nothing"))
			if("Cancel Event")
				scheduler.cancel(autoclass_schedule[e])
				autoclass_schedule -= e
				src << infomsg("Event cancelled.")
			if("Check Time")
				var/ticks = scheduler.time_to_fire(autoclass_schedule[e])
				src << infomsg("[comma(ticks)] ticks until event starts.")

				var/Event/event = autoclass_schedule[e]
				var/__Trigger/T = scheduler.__trigger_mapping[event]
				if(T)
					src << infomsg("found event, vars:")
					for(var/v in event.vars)
						src << "[v] = [event.vars[v]]"
				else
					src << infomsg("didn't found event, mapping:")

					for(var/E in scheduler.__trigger_mapping)
						src << "[E]"

						T = scheduler.__trigger_mapping[E]

						for(var/v in T.vars)
							src << "[v] = [T.vars[v]]"

	Weather(var/effect in worldData.weather_effects, var/prob as num)
		set category = "Server"
		worldData.weather_effects[effect] = prob
		src << infomsg("[effect] has [prob] probability to occur.")

	Events(var/RandomEvent/e in worldData.events, var/prob as num)
		set category = "Events"
		e.chance = prob
		src << infomsg("[e] has [e.chance] probability to occur.")

	Set_Drop_Rate(var/rate as num)
		set category = "Server"
		worldData.DropRateModifier = rate
		src << infomsg("Drop rate modifier set to [rate]")

	Set_Price_Modifier(var/modifier as num)
		set category = "Server"
		worldData.shopPriceModifier = modifier
		src << infomsg("Drop rate modifier set to [modifier]")

	Set_Exp_Modifier(var/modifier as num)
		set category = "Server"
		worldData.expModifier = modifier
		src << infomsg("Exp modifier set to [modifier]")

	Set_Book_Exp_Modifier(var/modifier as num)
		set category = "Server"
		worldData.expBookModifier = modifier
		src << infomsg("Book exp modifier set to [modifier]")

	Schedule_Clanwars(var/datetime as text)
		set category = "Server"
		set desc = "Enter date in YYYY-MM-DD hh:mm:ss format"
		var/secs_until = add_clan_wars(datetime)
		if(secs_until)
			usr << infomsg("Clan wars scheduled to start in [comma(secs_until)] seconds.")
		else
			usr << errormsg("Could not schedule clan wars.")
	Schedule_AutoClass(var/datetime as text)
		set category = "Server"
		set desc = "Enter date in YYYY-MM-DD hh:mm:ss format"
		var/secs_until = add_autoclass(datetime)
		if(secs_until)
			usr << infomsg("Auto class scheduled to start in [comma(secs_until)] seconds.")
		else
			usr << errormsg("Could not schedule auto class.")
	Start_Random_Event(var/RandomEvent/event in worldData.events+"random")
		set category = "Events"
		if(event == "random")
			var/list/l = list()
			for(var/RandomEvent/e in worldData.events)
				if(e.chance == 0) continue
				l[e] = e.chance

			var/RandomEvent/e = pickweight(l)
			e.start()
		else if(istype(event, /RandomEvent/Class))
			var/list/spells = spellList ^ list(/mob/Spells/verb/Self_To_Dragon, /mob/Spells/verb/Self_To_Human, /mob/Spells/verb/Episky, /mob/Spells/verb/Inflamari)
			var/spell = input(src, "Which spell? (Cancel for random)", "Start Auto Class", "Random") as null|anything in spells

			var/time = input(src, "How long? (in minutes)", "Start Auto Class", 30) as num|null
			if(!time || time <= 0) return

			event.start(spell, time)
		else if(istype(event, /RandomEvent/LegendaryEffect))
			var/list/effects = list(RING_WATERWALK, RING_APPARATE, RING_DISPLACEMENT, RING_LAVAWALK, RING_ALCHEMY, RING_CLOWN, RING_FAIRY, RING_NINJA, RING_NURSE, SHIELD_ALCHEMY, SHIELD_NINJA, SHIELD_NURSE, SHIELD_CLOWN, SHIELD_MPDAMAGE, SHIELD_GOLD, SWORD_ALCHEMY, SWORD_NINJA, SWORD_NURSE, SWORD_CLOWN, SWORD_EXPLODE, SWORD_FIRE,SWORD_MANA, SWORD_HEALONKILL, SWORD_ANIMAGUS, SWORD_GHOST, SWORD_SNAKE)

			var/effect = input(src, "Which effect? (Cancel for random)", "Start Event", "Random") as null|anything in effects

			var/time = input(src, "How long? (in minutes)", "Start Event", 30) as num|null
			if(!time || time <= 0) return

			event.start(effect, time)
		else if(istype(event, /RandomEvent/FFA))
			var/gameMode = input(src, "Game Mode? (Cancel for random)", "Start FFA", "Random") as null|anything in list("Normal","One Hit Kill", "Undying", "4 Hit Kill", "Survival")
			event.start(gameMode)
		else if(istype(event, /RandomEvent/HouseWars))
			var/gameMode = input(src, "Game Mode? (Cancel for random)", "Start House Wars", "Random") as null|anything in list("Normal","One Hit Kill","4 Hit Kill")
			event.start(gameMode)
		else
			event.start()

	Toggle_GiftOpening()
		set category = "Server"
		worldData.allowGifts = !worldData.allowGifts
		usr << infomsg("Gifts [worldData.allowGifts ? "can" : "can't"] be opened.")

proc
	add_clan_wars(var/datetime)
		var/secs_until = rustg_seconds_until(datetime)
		var/Event/ClanWars/e = new
		clanwars_schedule["[datetime]"] = e
		scheduler.schedule(e, 10 * secs_until)
		return secs_until
	add_autoclass(var/datetime)
		var/secs_until = rustg_seconds_until(datetime)
		var/Event/AutoClass/e = new
		autoclass_schedule["[datetime]"] = e
		scheduler.schedule(e, 10 * secs_until)
		return secs_until


mob/test/verb/populateSchedule()
	set category = "Server"

	var/list/days = list("monday", "tuesday", "wednesday", "thursday", "friday")
	var/list/hours = list("3pm", "6pm", "3am", "6am")

	for(var/d in days)
		for(var/h in hours)
			add_clan_wars("[d] [h]")



