/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
var/list/clanwars_schedule = list()

proc/time_until(day, hour)

	var/http[] = world.Export("http://wizardschronicles.com/time_functions.php?day=[day]&hour=[hour]")

	if(!http) return -1

	var/F = http["CONTENT"]
	if(F)
		return text2num(file2text(F))

	return -1

var/DropRateModifier = 1
mob/GM/verb
	Clan_Wars_Schedule(var/Event/e in clanwars_schedule)
		set category = "Staff"
		switch(alert(src, "What do you want to do?", "Events", "Cancel Event", "Check Time", "Nothing"))
			if("Cancel Event")
				scheduler.cancel(clanwars_schedule[e])
				clanwars_schedule.Remove(e)
				src << infomsg("Event cancelled.")
			if("Check Time")
				var/ticks = scheduler.time_to_fire(clanwars_schedule[e])
				src << infomsg("[comma(ticks)] ticks until event starts.")

	Weather(var/effect in weather_effects, var/prob as num)
		set category = "Staff"
		weather_effects[effect] = prob
		bubblesort_by_value(weather_effects)
		src << infomsg("[effect] has [prob] probability to occur.")

	Events(var/RandomEvent/e in events, var/prob as num)
		set category = "Events"
		e.chance = prob
		bubblesort_by_value(events, "chance")
		src << infomsg("[e] has [e.chance] probability to occur.")

	Set_Drop_Rate(var/rate as num)
		set category = "Staff"
		DropRateModifier = rate
		src << infomsg("Drop rate modifier set to [rate]")

	Set_Price_Modifier(var/modifier as num)
		set category = "Staff"
		shopPriceModifier = modifier
		src << infomsg("Drop rate modifier set to [modifier]")

	Schedule_Clanwars(var/day as text, var/hour as text)
		set category = "Staff"
		var/date = add_clan_wars(day, hour)
		if(date != -1)
			usr << infomsg("Clan wars scheduled ([comma(date)])")
		else
			usr << errormsg("Could not schedule clan wars.")

	Start_Random_Event(var/RandomEvent/event in events+"random")
		if(event == "random")
			for(var/RandomEvent/e in events)
				if(prob(e.chance))
					e.start()
					break
		else
			event.start()

	Toggle_GiftOpening()
		set category = "Staff"
		allowGifts = !allowGifts
		usr << infomsg("Gifts [allowGifts ? "can" : "can't"] be opened.")

var/allowGifts = 1

proc/add_clan_wars(var/day, var/hour)
	var/date = time_until(day, hour)
	if(date != -1)
		var/Event/ClanWars/e = new
		clanwars_schedule["[day] - [hour]"] = e
		scheduler.schedule(e, world.tick_lag * 10 * date)
	return date


mob/test/verb/Movement_Queue()
	move_queue = !move_queue
	src << infomsg("Movement queue toggled [move_queue ? "on" : "off"].")