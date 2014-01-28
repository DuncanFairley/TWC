/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
var/list/ministrybanlist = list()
obj
	ministrytable
		icon = 'Tables.dmi'
		icon_state = "23"
		density = 1
		Click()
			if(src in oview(1))
				var/choice
				if(usr.Rank == "Minister of Magic")
					choice = input("What would you like to do?") as null|anything in list(
					"Make Ministry-wide announcement",
					"Lock/Unlock Ministry offices",
					"Open/Close Ministry entrance",
					"Ban person from entering",
					"Unban person")
				else if(usr.House == "Ministry")
					choice = input("What would you like to do?") as null|anything in list(
					"Make Ministry-wide announcement",
					"Lock/Unlock Ministry offices",
					"Open/Close Ministry entrance",
					"Ban person from entering",
					"Unban person")
				else
					return
				switch(choice)
					if("Change tax rate")
						var/newtaxrate = input("What will the new taxrate be? (%)","New Tax Rate",taxrate) as null|text
						if(!newtaxrate)return
						taxrate = newtaxrate
						usr << "The tax rate is now [taxrate]"
					if("Make Ministry-wide announcement")
						var/announcement = input("What would you like to announce to anyone in the Ministry of Magic's premises?") as null|text
						if(!announcement)return
						var/area/A = locate(/area/ministry_of_magic)
						for(var/mob/M in A)
							M << "<i><b>Ministry Announcement: [html_encode(announcement)]</b></i>"
					if("Lock/Unlock Ministry offices")
						var/obj/brick2door/door = locate("ministryoffice")
						if(door.door)//if unlocked
							door.door = 0
							view(door) << "<i>You hear a door lock.</i>"
						else
							door.door = 1
							view(door) << "<i>You hear a door unlock.</i>"
					if("Open/Close Ministry entrance")
						if(ministryopen)
							ministryopen = 0
							usr << "<u>The Ministry's entrance is now closed.</u>"
						else
							ministryopen = 1
							usr << "<u>The Ministry's entrance is now open.</u>"
					if("Ban person from entering")
						var/mob/M = input("Who would you like to ban from using the Ministry's entrance?") as null|mob in Players
						if(!M)return
						usr << "[M] is now banned from entering the Ministry of Magic."
						ministrybanlist.Remove(M.name)
						ministrybanlist.Add(M.name)
					if("Unban person")
						var/M = input("Who would you like to unban from using the Ministry's entrance?") as null|anything in ministrybanlist
						if(!M)return
						ministrybanlist.Remove(M)
						usr << "[M] is now unbanned from entering the Ministry of Magic."
mob
	longap/verb
		Apparate_To_Three_Broomsticks()
			set category = "Skills"
			if(istype(usr.loc.loc,/area/hogwarts))
				usr << "Teleportation is not possible within Hogwarts' walls."
				return
			if(src.Detention)
				alert("You cannot apparate inside detention.")
				return
			if(usr.removeoMob) spawn()usr:Permoveo()
			usr.picon_state=usr.icon_state
			flick('ex.dmi',usr)
			oview() << "<i><b>There is a loud crack.</b></i>."
			sleep(4)
			usr.loc = locate(38,59,18)
			usr.Move(usr.loc)
			flick('ex.dmi',usr)
			oview() << "<i><b>There is a loud crack.</b></i>."
			usr.icon_state=usr.picon_state

mob
	longap/verb
		Apparate_To_Diagon_Alley()
			set category = "Skills"
			if(istype(usr.loc.loc,/area/hogwarts))
				usr << "Teleportation is not possible within Hogwarts' walls."
				return
			if(src.Detention)
				alert("You cannot apparate inside detention.")
				return
			if(usr.removeoMob) spawn()usr:Permoveo()
			usr.picon_state=usr.icon_state
			flick('ex.dmi',usr)
			oview() << "<i><b>There is a loud crack.</b></i>."
			sleep(4)
			usr.loc = locate(45,47,26)
			flick('ex.dmi',usr)
			view() << "<i><b>There is a loud crack.</b></i>."
			usr.icon_state=usr.picon_state

mob
	longap/verb
		Apparate_To_Crossroads()
			set category = "Skills"
			if(istype(usr.loc.loc,/area/hogwarts))
				usr << "Teleportation is not possible within Hogwarts' walls."
				return
			if(src.Detention)
				alert("You cannot apparate inside detention.")
				return
			else
				if(usr.removeoMob) spawn()usr:Permoveo()
				usr.picon_state=usr.icon_state
				flick('ex.dmi',usr)
				oview() << "<i><b>There is a loud crack.</b></i>."
				sleep(4)
				usr.loc = locate(50,22,15)
				usr.Move(usr.loc)
				flick('ex.dmi',usr)
				view() << "<i><b>There is a loud crack.</b></i>."
				usr.icon_state=usr.picon_state
