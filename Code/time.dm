var/list/events = list()

proc/time_until(day, hour)

	var/http[] = world.Export("http://wizardschronicles.com/time_functions.php?day=[day]&hour=[hour]")

	if(!http) return -1

	var/F = http["CONTENT"]
	if(F)
		return text2num(file2text(F))

	return -1

mob/GM/verb
	Events(var/Event/e in events)
		switch(alert(src, "What do you want to do?", "Events", "Cancel Event", "Check Time", "Nothing"))
			if("Cancel Event")
				scheduler.cancel(events[e])
				events.Remove(e)
				src << infomsg("Event cancelled.")
			if("Check Time")
				var/ticks = scheduler.time_to_fire(events[e])
				src << infomsg("[comma(ticks)] ticks until event starts.")

	Schedule_Clanwars(var/hour as text, var/day as text)
		var/date = time_until(day, hour)
		if(date != -1)
			var/Event/ClanWars/e = new
			events["[day] - [hour]"] = e
			scheduler.schedule(e, world.tick_lag * 10 * date)
			usr << infomsg("Clan wars scheduled ([comma(date)])")
		else
			usr << errormsg("Could not schedule clan wars.")