/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
obj/items
	AlyssaScroll
		name="Potion Ingredients"
		icon = 'scrolls.dmi'
		icon_state = "wrote"
		dropable = 0

		var
			content="<body bgcolor=black><u><font color=blue><b><font size=3>Scroll</u><p><font color=red><font size=1>by Alyssa <p><p><font size=2><font color=white><br>Onion Root<br>Indigo Seeds<br>Drop of Salamander<br>Silver Spider Legs <p>"
		verb
			Crumple()
				var/dels = alert("Do you wish to get rid of the scroll?",,"Yes","No")
				if(dels == "Yes")
					if(src in usr)
						src << "You crumple the scroll."
						loc = null
						usr:Resort_Stacking_Inv()
			read()
				set name = "Read"
				usr << browse(content)

		Click()
			if(src in usr)
				read()
			else
				..()

obj
	PyramidScroll1
		name="Scroll"
		icon = 'scrolls.dmi'
		icon_state = "wrote"
		dontsave = 1
		accioable=1
		wlable = 1
		var
			content
		verb
			Name(msg as text)
			//	var/name = input(src,"Please name this parchment.","Specify Name",Name This Parchment)
				set name = "Name Scroll"
				if(msg == "") return
				src.name = html_encode(msg)
				src.owner=usr.name
			//	name += "Scroll: [name]"
			read()
				set name = "Read"
				usr << browse("<body bgcolor=black><font color=white>Open now<br>What lies inside<br><br><br><i>The rest is torn off</i>")
			Take()
				set src in oview(1)
				hearers()<<"[usr] takes the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()

			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
			Examine()
				set src in view(3)
				usr << "This scroll is made of very old paper that is crumbling at the edges."

obj
	PyramidScroll2
		name="Scroll"
		icon = 'scrolls.dmi'
		icon_state = "wrote"
		dontsave = 1
		wlable = 1
		var
			content
		verb
			Name(msg as text)
			//	var/name = input(src,"Please name this parchment.","Specify Name",Name This Parchment)
				set name = "Name Scroll"
				if(msg == "") return
				src.name = html_encode(msg)
				src.owner=usr.name
			//	name += "Scroll: [name]"
			read()
				set name = "Read"
				usr << browse("<body bgcolor=black><font color=white>Let me in<br>Where the powers hide<br><br><br><i>The rest is torn off</i>")
			Take()
				set src in oview(1)
				hearers()<<"[usr] takes the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()

			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
			Examine()
				set src in view(3)
				usr << "This scroll is made of very old paper that is crumbling at the edges."

obj
	PyramidScroll3
		name="Scroll"
		icon = 'scrolls.dmi'
		icon_state = "wrote"
		dontsave = 1
		accioable=1
		wlable = 1
		var
			content
		verb
			Name(msg as text)
			//	var/name = input(src,"Please name this parchment.","Specify Name",Name This Parchment)
				set name = "Name Scroll"
				if(msg == "") return
				src.name = html_encode(msg)
				src.owner=usr.name
			//	name += "Scroll: [name]"
			read()
				set name = "Read"
				usr << browse("<body bgcolor=black><font color=white>So I can see<br>With my own two eyes<br><br><br><i>The rest is torn off</i>")
			Take()
				set src in oview(1)
				hearers()<<"[usr] takes the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()

			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
			Examine()
				set src in view(3)
				usr << "This scroll is made of very old paper that is crumbling at the edges."

obj
	PyramidScroll4
		name="Scroll"
		icon = 'scrolls.dmi'
		icon_state = "wrote"
		dontsave = 1
		wlable = 1
		accioable=1
		var
			content
		verb
			Name(msg as text)
			//	var/name = input(src,"Please name this parchment.","Specify Name",Name This Parchment)
				set name = "Name Scroll"
				if(msg == "") return
				src.name = html_encode(msg)
				src.owner=usr.name
			//	name += "Scroll: [name]"
			read()
				set name = "Read"
				usr << browse("<body bgcolor=black><font color=white>The place where even<br>Gods can die<br><br><br><i>The rest is torn off</i>")
			Take()
				set src in oview(1)
				hearers()<<"[usr] takes the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()

			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
			Examine()
				set src in view(3)
				usr << "This scroll is made of very old paper that is crumbling at the edges."








mob/GM/verb/Force_PM(mob/M in world)
		set category="Staff"
		set popup_menu = 0
		var/PM = input(src,"Input Message to Forcefully PM someone who has PM's blocked.","Message to [M]",src.key)
		M<<browse("<body bgcolor=black><p align=center><p><font size=3><font color=white><hr><b><font color=red><p align=center>Forced PM From [usr]<p align=center><b><font color=white>[PM]<hr>")

		usr<<"Sent."
mob/GM/verb
	Add_GM_To_List(message as message)
		set category = "Staff"
		set name = ""
		var/timestamp = world.realtime
		file("GMs.html") << "<b><u>[time2text(timestamp,"MMM DD - hh:mm:ss")]: [src.key]</b></u><br>[message]<BR>"
		src << "This person has been added to the GM List. Thank you."

mob/GM
	verb
		GM_List_Admin()
			set category = "Staff"
mob
	verb
		Help()
			set name = "Help/Rules"
			switch(input("Please make a selection","Help Menu") as null|anything in list("Guide","Rules","Talk to a GM","Report a Bug","How to get spells"))
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
											p << "<font color=red><b>GMHelp:</font> <b>User, <font color=blue>[usr]</font> , requests GM assistance."
				if("Report a Bug")
					usr << infomsg("Report bugs by PMing a GM.")
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
					housepointsGSRH[housenum] += points
					if(points==1)
						Players << "\red[points] point has been added to [house]!"
					else
						Players << "\red[points] points have been added to [house]!"
				if("Subtract")
					var/points = input("How many points do you wish to Subtract?","House Points") as null|num
					if(!points) return
					housepointsGSRH[housenum] -= points
					if(points==1)
						Players << "\red[points] point has been subtracted from [house]!"
					else
						Players << "\red[points] points have been subtracted from [house]!"
			Save_World()
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
			var/pos = findtext(txt, "\[AutoClassSchedule]")
			if(pos)
				var/class = ""

				var/list/classes = autoclass_schedule.Copy()

				var/current_day  = text2num(time2text(world.realtime, "DD"))
				var/current_hour = text2num(time2text(world.realtime, "hh"))

				var/count = 0
				while(classes.len && count < 5)
					count++
					var
						scheduled_hour2 = "&nbsp;"
						scheduled_hour3 = "&nbsp;"
						scheduled_hour4 = "&nbsp;"
						scheduled_hour5 = "&nbsp;"
						scheduled_hour6 = "&nbsp;"

					for(var/e in classes)
						var/ticks = scheduler.time_to_fire(classes[e])
						var/day   = (round(ticks / 10 / 60 / 60 / 24) + current_day)  % 7
						var/hour  = (round(ticks / 10 / 60 / 60)      + current_hour) % 24

						var/scheduled_hour = hour > 12 ? "[hour - 12] PM - [hour - 12]:35 PM" : "[hour] AM - [hour]:35 AM"
						if(day == 2 && scheduled_hour2 == "&nbsp;")
							scheduled_hour2 = scheduled_hour
						else if(day == 3 && scheduled_hour3 == "&nbsp;")
							scheduled_hour3 = scheduled_hour
						else if(day == 4 && scheduled_hour4 == "&nbsp;")
							scheduled_hour4 = scheduled_hour
						else if(day == 5 && scheduled_hour5 == "&nbsp;")
							scheduled_hour5 = scheduled_hour
						else if(day == 6 && scheduled_hour6 == "&nbsp;")
							scheduled_hour6 = scheduled_hour
						else
							continue

						classes -= e

					class += {"
	<tr style="color:yellow">
		<td class="name">Auto Class</td>
		<td>Random</td>
		<td class="time:sunday">&nbsp;</td>
		<td class="time">[scheduled_hour2]</td>
		<td class="time">[scheduled_hour3]</td>
		<td class="time">[scheduled_hour4]</td>
		<td class="time">[scheduled_hour5]</td>
		<td class="time">[scheduled_hour6]</td>
		<td class="time:saturday">&nbsp;</td>
	</tr>"}
					break
				txt = replace(txt, "\[AutoClassSchedule]", class, pos)

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
/*
mob/var/list/offering = list()


obj
	var
		amount


	gold

mob
	var
		istrading
		tradingd
		offer

mob/verb
	Trade(mob/src in world)
		if(src == usr)
			return
		else
			var/ask = input(src,"Do you wish to trade with [usr]?") in list("Yes","No")
			if(ask == "Yes")
				start_choice:
				var/ask2 = input("What do you want to do?") in list("Put up Item","Put up Gold","Remove something")
				if(ask2 == "Put up Item")
					var/obj/item = input("Which item?") in usr.contents
					usr.offering += item
					usr.contents -= item
					src << "[usr] has offered a [item]"
					var/cont = input("Offer more?") in list("Yes","No")
					if(cont == "Yes")
						goto start_choice
					else
						usr.tradingd = 1
						if(src.tradingd == 1)
							finishtrade(usr,src)
						else
							usr << "[src] is not done trading yet please wait."
				if(ask2 == "Remove something")
					var/obj/which = input("What would you like to remove?") in usr.offering
					if(istype(which,/obj/gold))
						usr.gold += which.amount
						del(which)
						goto start_choice
					else
						usr.offering -= which
						usr.contents += which
						goto start_choice
				if(ask2 == "Put up Gold")
					var/obj/gold/G = new/obj/gold
					var/amount = input("How much gold?") as num
					if(amount <= usr.gold&&amount >= 1)
						G.amount = amount
						G.name = "[amount] gold"
						usr.gold -= amount
						usr.offering += G
						src << "[usr] has put up [G]"
						var/cont = input("Offer more?") in list("Yes","No")
						if(cont == "Yes")
							goto start_choice
						else
							usr.tradingd = 1
							if(src.tradingd == 1)
								finishtrade(usr,src)
							else
								usr << "[src] is not done trading yet please wait."
					else
						usr << "You don't have that much gold!"
						goto start_choice
				start_choice2:
				var/ask3 = input(src,"What do you want to do?") in list("Put up Item","Put up Gold")
				if(ask3 == "Put up Item")
					var/obj/item2 = input(src,"Which item?") in src.contents
					src.offering += item2
					src.contents -= item2
					usr << "[src] has offered a [item2]"
					var/cont = input(src,"Offer more?") in list("Yes","No")
					if(cont == "Yes")
						goto start_choice2
					else
						src.tradingd = 1
						if(usr.tradingd == 1)
							finishtrade(usr,src)
						else
							src << "[usr] is not done trading yet please wait."
				if(ask3 == "Remove something")
					var/obj/which = input(src,"What would you like to remove?") in src.offering
					if(istype(which,/obj/gold))
						src.gold += which.amount
						del(which)
						goto start_choice2
					else
						src.offering -= which
						src.contents += which
						goto start_choice2
				if(ask3 == "Put up Gold")
					var/obj/gold/G = new/obj/gold
					var/amount = input(src,"How much gold?") as num
					if(amount <= src.gold&&amount >= 1)
						G.amount = amount
						G.name = "[amount] gold"
						src.gold -= amount
						src.offering += G
						usr << "[src] has put up [G]"
						var/cont = input("Offer more?") in list("Yes","No")
						if(cont == "Yes")
							goto start_choice2
						else
							usr.tradingd = 1
							if(usr.tradingd == 1)
								finishtrade(usr,src)
							else
								usr << "[usr] is not done trading yet please wait."
					else
						src << "You don't have that much gold!"
						goto start_choice2
			else
				usr << "[src] does not wish to trade with you."
mob
	proc
		finishtrade(mob/a,mob/b)
			for(var/l in b.offering)
				if(l == b.offering[length(b.offering)])
					b.offer += "[l]"
				else
					b.offer += "[l], "
			for(var/l in a.offering)
				if(l == a.offering[length(a.offering)])
					a.offer += "[l]"
				else
					a.offer += "[l], "
			a << "[b] is offering <b>[b.offer]</b> for your <b>[a.offer]"
			b << "[a] is offering <b>[a.offer]</b> for your <b>[b.offer]"
			b.offer = ""
			a.offer = ""
			sleep(10)
			var/agree1 = input(a,"Do you wish to finish the trade?") in list("Yes","No")
			if(agree1 == "Yes")
				var/agree2 = input(b,"Do you wish to finish the trade?") in list("Yes","No")
				if(agree2 == "Yes")
					for(var/obj/gold/G in a.offering)
						b.gold += G.amount
						del(G)
					for(var/obj/gold/G2 in b.offering)
						a.gold += G2.amount
						del(G2)
					a.contents += b.offering
					b.contents += a.offering
					a.offering -= a.offering
					b.offering -= b.offering
					a.tradingd = 0
					b.tradingd = 0
				else
					a << "[b] has disagreed to the trade"
					for(var/obj/gold/G in a.offering)
						a.gold += G.amount
						del(G)
					for(var/obj/gold/G2 in b.offering)
						b.gold += G2.amount
						del(G2)
					a.contents += a.offering
					b.contents += b.offering
					a.offering -= a.offering
					b.offering -= b.offering
					a.tradingd = 0
					b.tradingd = 0
					return
			else
				b << "[a] has disagreed to the trade."
				for(var/obj/gold/G in a.offering)
					a.gold += G.amount
					del(G)
				for(var/obj/gold/G2 in b.offering)
					b.gold += G2.amount
					del(G2)
				a.contents += a.offering
				b.contents += b.offering
				a.offering -= a.offering
				b.offering -= b.offering
				a.tradingd = 0
				b.tradingd = 0
				return

*/