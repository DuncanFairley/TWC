mob/GM/verb/Force_PM(mob/M in world)
		set category="Staff"
		set popup_menu = 0
		var/PM = input(src,"Input Message to Forcefully PM someone who has PM's blocked.","Message to [M]",src.key)
		M<<browse("<body bgcolor=black><p align=center><p><font size=3><font color=white><hr><b><font color=red><p align=center>Forced PM From [usr]<p align=center><b><font color=white>[PM]<hr>")

		usr<<"Sent."

mob
	verb
		Help()
			set name = "Help/Rules"
			switch(input("Please make a selection","Help Menu") as null|anything in list("Rules","Talk to a GM","Report a Bug","How to get spells"))
				if("Guide")
					usr<<infomsg("The player guide is located <a href=\"http://guide.wizardschronicles.com\">here</a>.")
				if("Rules")
					usr<<browse(rules,"window=1")
				if("Talk to a GM")
					if(canUse(src,cooldown=/StatusEffect/UsedGMHelp, needwand=0))
						switch(alert("Call for a Game Master?","GM Help","Yes","No"))
							if("Yes")
								if(canUse(src,cooldown=/StatusEffect/UsedGMHelp, needwand=0))
									new /StatusEffect/UsedGMHelp(src,10)
									usr<<infomsg("The GM's have been alerted that you need help, and should be with you shortly.")
									for(var/mob/Player/p in Players)
										if(p.Gm)
											p.beep()
											p << "<span style=\"color:red;\"><b>GMHelp:</span> <b>User, <span style=\"color:blue;\">[usr]</span> , requests GM assistance."
				if("Report a Bug")
					usr << infomsg("You can report a bug/issue to the developers by going <a href=\"https://github.com/DuncanFairley/TWC/issues\">here</a>.")
				if("How to get spells")
					usr << infomsg("Go to classes. Classes will be announced when they are going to start, and the times each class are going to start can be viewed by pressing the Class Schedule verb in your 'Commands' tab.")
mob/GM
	verb
		House_Points()
			set category = "Teach"
			set name = "House Points"
			var/house = input("Select which house to modify the points of","House Points") as null|anything in list("Gryffindor","Slytherin","Hufflepuff","Ravenclaw")
			if(!house)return
			var/housenum
			switch(house)
				if("Gryffindor")
					housenum = 1
				if("Slytherin")
					housenum = 2
				if("Ravenclaw")
					housenum = 3
				if("Hufflepuff")
					housenum = 4
			switch(alert("Do you wish to Add points to [house] or Subtract?","House Points","Add","Subtract"))
				if("Add")
					var/points = input("How many points do you wish to Add?","House Points") as null|num
					if(!points) return
					worldData.housepointsGSRH[housenum] += points
					if(points==1)
						Players << "\red[points] point has been added to [house]!"
					else
						Players << "\red[points] points have been added to [house]!"
				if("Subtract")
					var/points = input("How many points do you wish to Subtract?","House Points") as null|num
					if(!points) return
					worldData.housepointsGSRH[housenum] -= points
					if(points==1)
						Players << "\red[points] point has been subtracted from [house]!"
					else
						Players << "\red[points] points have been subtracted from [house]!"
			Save_World()
		Edit_Schedule()
			set category = "Staff"

			var/input = input("Class Schedule - Make sure you back up the contents of this window in notepad before making changes.","Class Schedule", worldData.GMSchedule) as null|message

			if(input != null)
				worldData.GMSchedule = input
				src << infomsg("Changed schedule.")

		Schedule_Admin()
			set category = "Staff"
			set name = "Class Scheduler"
			switch(input("What would you like to do to the class schedule?","Class Scheduler")as null|anything in list ("Clear Schedule","Edit Schedule"))
				if("Edit Schedule")
					var/input = input("Class Schedule - Make sure you back up the contents of this window in notepad before making changes.","Class Schedule",file2text(Sched)) as null|message
					if(!input) return
					fdel("Sched.html")
					file("Sched.html") << "[input]"
					src << "Schedule posted. Thanks."
				if("Clear Schedule")
					fdel("Sched.html")
mob
	verb
		Class_Schedule()
			var/txt = file2text(Sched)

			txt = replacetext(txt, "\[GMSchedule]", worldData.GMSchedule)

			var/Event/RandomEvents/re = locate() in scheduler.__trigger_mapping
			txt = replacetext(txt, "\[Random Event]", scheduler.time_to_fire(re))

			var/list/tags = list("Auto Class", "Clan Wars")

			var/offset_pos_start = findtext(txt, "\[Offset=")
			var/offset = 0
			if(offset_pos_start)
				var/const/NEEDLE = 8

				var/offset_pos_end = findtext(txt, "]", offset_pos_start + NEEDLE)

				offset = text2num(copytext(txt, offset_pos_start + NEEDLE, offset_pos_end))
				txt = replacetext(txt, "\[Offset=[offset]]", "", offset_pos_start)

			for(var/t in tags)
				var/pos = findtext(txt, "\[[t]]")
				if(pos)
					var/html = ""

					var/list/events = t == "Auto Class" ? autoclass_schedule.Copy() : clanwars_schedule.Copy()
					var/count = 0
					while(events.len && count < 10)
						count++

						var/list/days[5]
						for(var/i = 1 to 5)
							days[i] = "&nbsp;"

						for(var/e in events)
							var/time2fire = scheduler.time_to_fire(events[e])
							if(time2fire == -1) continue
							var/ticks = time2fire + world.realtime + 600 + (offset*36000)// + world.timeofday
							var/day  = time2text(ticks, "DDD")
							var/hour = text2num(time2text(ticks, "hh"))

							if(day == "Mon") day = 2
							else if(day == "Tue") day = 3
							else if(day == "Wed") day = 4
							else if(day == "Thu") day = 5
							else if(day == "Fri") day = 6
							else day = 0

							var/ampm = hour >= 12 ? "PM" : "AM"
							if(hour > 12) hour -= 12
							else if(hour == 0) hour = 12

							if(day != 0)
								if(days[day - 1] != "&nbsp;") continue
								days[day - 1] = "[hour] [ampm] - [hour]:35 [ampm]"

							events -= e

						html += {"
		<tr style="color:yellow">
			<td class="name">[t]</td>
			<td>&nbsp;</td>
			<td class="time:sunday">&nbsp;</td>
			<td class="time">[days[1]]</td>
			<td class="time">[days[2]]</td>
			<td class="time">[days[3]]</td>
			<td class="time">[days[4]]</td>
			<td class="time">[days[5]]</td>
			<td class="time:saturday">&nbsp;</td>
		</tr>"}

					txt = replacetext(txt, "\[[t]]", html, pos)

			src << browse(txt)
mob/verb/Use_Spellpoints()
	if(spellpoints < 5)
		alert("You require at least 5 spell points before you can learn spells with them. Spell points are earned by going to a class and learning a spell that you've already learnt.")
	else
		var/list/unlearntSpells = global.spellList.Copy()
		unlearntSpells.Remove(usr.verbs)
		if(length(unlearntSpells))
			var/list/txtunlearntSpells = list()
			for(var/V in unlearntSpells)
				txtunlearntSpells += unlearntSpells[V]

			var/spellname = input("Which spell would you like to learn for 5 spell points?") as null|anything in txtunlearntSpells
			if(spellname)
				if(spellpoints >= 5)
					var/newspell = name2spellpath(spellname)
					if(newspell in verbs) return
					verbs += newspell
					src << "You learnt [spellname]!"
					spellpoints -= 5
		else
			src << "<b>You've already learnt all of the available spells.</b>"
var
	Sched = file("Sched.html")

mob/var/CustomIcon

mob/GM/verb/Change_Robe_Trim(mob/Player/M in Players)
	set category = "Staff"
	var/icon/m = input("Pick Gender") in list ("Male","Female")
	switch(m)
		if("Male")
			m = new('MaleStaff.dmi')
		if("Female")
			m = new('FemaleStaff.dmi')
	var/icon/t = new('trims.dmi')
	var/color_ = input("Choose Color") as color
	var/colorr = GetRedPart(color_)
	var/colorg = GetGreenPart(color_)
	var/colorb = GetBluePart(color_)
	t.Blend(rgb(colorr,colorg,colorb),ICON_MULTIPLY)
	m.Blend(t,ICON_OVERLAY)
	M.CustomIcon = m
	M.BaseIcon()

proc
    GetRedPart(hex)
        hex = uppertext(hex)
        var
            hi = text2ascii(hex, 2)
            lo = text2ascii(hex, 3)
        return ( ((hi >= 65 ? hi-55 : hi-48)<<4) | (lo >= 65 ? lo-55 : lo-48) )

    GetGreenPart(hex)
        hex = uppertext(hex)
        var
            hi = text2ascii(hex, 4)
            lo = text2ascii(hex, 5)
        return ( ((hi >= 65 ? hi-55 : hi-48)<<4) | (lo >= 65 ? lo-55 : lo-48) )

    GetBluePart(hex)
        hex = uppertext(hex)
        var
            hi = text2ascii(hex, 6)
            lo = text2ascii(hex, 7)
        return ( ((hi >= 65 ? hi-55 : hi-48)<<4) | (lo >= 65 ? lo-55 : lo-48) )

    GetColors(hex)
        hex = uppertext(hex)
        var
            hi1 = text2ascii(hex, 2)
            lo1 = text2ascii(hex, 3)
            hi2 = text2ascii(hex, 4)
            lo2 = text2ascii(hex, 5)
            hi3 = text2ascii(hex, 6)
            lo3 = text2ascii(hex, 7)
        return list(((hi1>= 65 ? hi1-55 : hi1-48)<<4) | (lo1 >= 65 ? lo1-55 : lo1-48),
            ((hi2 >= 65 ? hi2-55 : hi2-48)<<4) | (lo2 >= 65 ? lo2-55 : lo2-48),
            ((hi3 >= 65 ? hi3-55 : hi3-48)<<4) | (lo3 >= 65 ? lo3-55 : lo3-48))

