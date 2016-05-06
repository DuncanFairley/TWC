/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

obj
	ministrytable
		icon = 'Tables.dmi'
		icon_state = "23"
		density = 1
		Click()
			if(src in oview(1))
				var/choice
				var/mob/Player/p = usr
				if(p.Rank == "Minister of Magic")
					choice = input("What would you like to do?") as null|anything in list(
					"Make Ministry-wide announcement",
					"Lock/Unlock Ministry offices",
					"Open/Close Ministry entrance",
					"Ban person from entering",
					"Unban person")
				else if(p.House == "Ministry")
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
						var/newtaxrate = input("What will the new taxrate be? (%)","New Tax Rate",worldData.taxrate) as null|text
						if(!newtaxrate)return
						worldData.taxrate = newtaxrate
						p << "The tax rate is now [worldData.taxrate]"
					if("Make Ministry-wide announcement")
						var/announcement = input("What would you like to announce to anyone in the Ministry of Magic's premises?") as null|text
						if(!announcement)return
						var/area/A = locate(/area/ministry_of_magic)
						for(var/mob/Player/M in A)
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
						p << "[M] is now banned from entering the Ministry of Magic."
						worldData.ministrybanlist.Remove(M.name)
						worldData.ministrybanlist.Add(M.name)
					if("Unban person")
						var/M = input("Who would you like to unban from using the Ministry's entrance?") as null|anything in worldData.ministrybanlist
						if(!M)return
						worldData.ministrybanlist.Remove(M)
						p << "[M] is now unbanned from entering the Ministry of Magic."