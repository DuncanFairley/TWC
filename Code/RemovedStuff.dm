/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

obj/Green_Mushroom
	icon='items.dmi'
	icon_state="greenmushroom"
	wlable = 1
	accioable=1
	rubbleable=1
	verb
		Examine()
			set src in view(3)
			if(src.rubble==1)
				usr << "A pile of rubble."
			else
				usr<<"A green mushroom, yummy."
	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."
obj/Red_Mushroom
	icon='items.dmi'
	icon_state="redmushroom"
	wlable = 1
	rubbleable=1
	accioable=1
	verb
		Examine()
			set src in view(3)
			if(src.rubble==1)
				usr << "A pile of rubble."
			else
				usr<<"A red mushroom, yummy."
	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."
obj/Blue_Mushroom
	icon='items.dmi'
	icon_state="bluemushroom"
	wlable = 1
	accioable=1
	dontsave=1
	rubbleable=1
	verb
		Examine()
			set src in view(3)
			if(src.rubble==1)
				usr << "A pile of rubble."
			else
				usr<<"A blue mushroom, yummy."
	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."

mob/GM/verb
	Change_Area()
		set hidden = 1
	// Daily Prophet verbs
	Your_Job()
		set hidden = 1
	Hire_Reporter()
		set hidden = 1
	Fire_DPSM()
		set hidden = 1
	Hire_Editor()
		set hidden = 1
	New_Story()
		set hidden = 1
	Clear_Stories()
		set hidden = 1
	Draft()
		set hidden = 1
	Edit_DP()
		set hidden = 1


mob/Quidditch/verb
	Add_Spectator()
		set hidden = 1
	Remove_Spectator()
		set hidden = 1

mob/verb/Convert()
	set hidden = 1


obj/MonBookMon
	New()
		..()
		spawn(1)
			new /obj/items/MonBookMon (loc)
			loc = null

obj/questbook
	New()
		..()
		spawn(1)
			new /obj/items/questbook (loc)
			loc = null

obj/AlyssaScroll
	New()
		..()
		spawn(1)
			new /obj/items/AlyssaScroll (loc)
			loc = null

obj/Alyssa
	Onion_Root
		New()
			..()
			spawn(1)
				new /obj/items/Alyssa/Onion_Root (loc)
				loc = null
	Salamander_Drop
		New()
			..()
			spawn(1)
				new /obj/items/Alyssa/Salamander_Drop (loc)
				loc = null
	Indigo_Seeds
		New()
			..()
			spawn(1)
				new /obj/items/Alyssa/Indigo_Seeds (loc)
				loc = null
	Silver_Spider_Legs
		New()
			..()
			spawn(1)
				new /obj/items/Alyssa/Silver_Spider_Legs (loc)
				loc = null

obj/COMCText
	New()
		..()
		spawn(1)
			new /obj/items/COMCText (loc)
			loc = null

obj/items/wearable/pimp_ring
	New()
		..()
		spawn(1)
			new /obj/items/wearable/afk/pimp_ring (loc)
			loc = null

mob/GM
	verb
		Take_Sense()
			set category = "Teach"
			set hidden = 1

		Take_Scan()
			set category = "Teach"
			set hidden = 1

		Take_Crucio()
			set category = "Teach"
			set hidden = 1

		Take_Serpensortia()
			set category = "Teach"
			set hidden = 1

		Take_Dementia()
			set category = "Teach"
			set hidden = 1


obj/Signage
	New()
		..()
		spawn(1)
			var/obj/Signs/s = new(loc)

			s.icon       = icon
			s.icon_state = icon_state
			s.name       = name
			s.desc       = desc

			loc = null
obj/sign1
	New()
		..()
		spawn(1)
			var/obj/Signs/s = new(loc)

			s.icon       = icon
			s.icon_state = icon_state
			s.name       = name
			s.desc       = desc

			loc = null
obj/sign2
	New()
		..()
		spawn(1)
			var/obj/Signs/sign2/s = new(loc)

			s.icon       = icon
			s.icon_state = icon_state
			s.name       = name
			s.desc       = desc

			loc = null

obj/items/weather/acid
	New()
		..()
		spawn(1)
			new /obj/items/magic_stone/weather/acid (loc)
			loc = null

obj/items/weather/rain
	New()
		..()
		spawn(1)
			new /obj/items/magic_stone/weather/rain (loc)
			loc = null

obj/items/weather/snow
	New()
		..()
		spawn(1)
			new /obj/items/magic_stone/weather/snow (loc)
			loc = null

obj/items/weather/sun
	New()
		..()
		spawn(1)
			new /obj/items/magic_stone/weather/sun (loc)
			loc = null
obj/MasterBed
	New()
		..()
		loc = null

obj/MasterBed_
	New()
		..()
		loc = null

obj/MasterBed__
	New()
		..()
		loc = null

obj/MasterBed___
	New()
		..()
		loc = null

obj/items
	key
		Master
			New()
				..()
				spawn(1)
					new /obj/items/key/master_key (loc)
					loc = null
		Wizard
			New()
				..()
				spawn(1)
					new /obj/items/key/wizard_key (loc)
					loc = null
		Pentakill
			New()
				..()
				spawn(1)
					new /obj/items/key/pentakill_key (loc)
					loc = null
		Basic
			New()
				..()
				spawn(1)
					new /obj/items/key/basic_key (loc)
					loc = null
		Sunset
			New()
				..()
				spawn(1)
					new /obj/items/key/sunset_key (loc)
					loc = null

	chest
		New()
			..()
			spawn(1)
				if(drops && islist(drops))
					drops = initial(drops)

		Wizard
			New()
				..()
				spawn(1)
					new /obj/items/chest/wizard_chest (loc)
					loc = null
		Pentakill
			New()
				..()
				spawn(1)
					new /obj/items/chest/pentakill_chest (loc)
					loc = null
		Basic
			New()
				..()
				spawn(1)
					new /obj/items/chest/basic_chest (loc)
					loc = null
		Sunset
			New()
				..()
				spawn(1)
					new /obj/items/chest/sunset_chest (loc)
					loc = null

obj/items/questbook
	New()
		..()
		spawn(1)
			loc = null


mob/GM/verb
	Add_GM_To_List()
		set hidden = 1
	GM_List_Admin()
		set hidden = 1

mob
	var
		derobe    = 0
		aurorrobe = 0

	BaseIcon()
		if(derobe)
			icon   = 'Deatheater.dmi'
			trnsed = 1
		else if(aurorrobe)
			if(Gender == "Female")
				icon = 'FemaleAuror.dmi'
			else
				icon = 'MaleAuror.dmi'
		else ..()

	GM/verb
		Auror_Robes()
			set category = "Clan"
			set name = "Auror Robes"
			if(usr.aurorrobe==1)
				usr.aurorrobe=0
				usr.icon = usr.baseicon
				usr:ApplyOverlays()
				usr.underlays = list()
				switch(usr.House)
					if("Hufflepuff")
						GenerateNameOverlay(242,228,22)
					if("Slytherin")
						GenerateNameOverlay(41,232,23)
					if("Gryffindor")
						GenerateNameOverlay(240,81,81)
					if("Ravenclaw")
						GenerateNameOverlay(13,116,219)
					if("Ministry")
						GenerateNameOverlay(255,255,255)
				if(locate(/mob/GM/verb/GM_chat) in usr.verbs) usr.Gm = 1
			else
				for(var/client/C)
					if(C.eye)
						if(C.eye == usr && C.mob != usr)
							C << "<b><font color = white>Your Telendevour wears off."
							C.eye=C.mob
				usr.aurorrobe=1
				usr.density=1
				usr.underlays = list()
				GenerateNameOverlay(196,237,255)
				usr.Immortal = 0
				usr.Gm = 0
				var/mob/Player/user = usr
				if(usr.trnsed)
					usr.trnsed = 0
					user.ApplyOverlays()
				if(usr.Gender == "Female")
					usr.icon = 'FemaleAuror.dmi'
				else
					usr.icon = 'MaleAuror.dmi'
		DErobes()
			set category = "Clan"
			set name = "Wear DE Robes"
			if(usr.derobe==1)
				usr.icon = usr.baseicon
				usr.trnsed = 0
				usr.derobe=0
				usr:ApplyOverlays()
				if(locate(/mob/GM/verb/GM_chat) in usr.verbs) usr.Gm = 1
				usr << "You slip off your Death Eater robes."
				usr.name = usr.prevname
				usr.prevname = null
				usr.underlays = list()
				if(usr.Gender == "Male")
					usr.gender = MALE
				else if(usr.Gender == "Female")
					usr.gender = FEMALE
				else
					usr.gender = MALE
				switch(usr.House)
					if("Hufflepuff")
						GenerateNameOverlay(242,228,22)
					if("Slytherin")
						GenerateNameOverlay(41,232,23)
					if("Gryffindor")
						GenerateNameOverlay(240,81,81)
					if("Ravenclaw")
						GenerateNameOverlay(13,116,219)
					if("Ministry")
						GenerateNameOverlay(255,255,255)
			else
				for(var/client/C)
					if(C.eye)
						if(C.eye == usr && C.mob != usr)
							C << "<b><font color = white>Your Telendevour wears off."
							C.eye=C.mob
				usr.trnsed = 1
				usr.derobe=1
				usr.icon = 'Deatheater.dmi'
				usr.overlays = null
				if(usr.away)usr.ApplyAFKOverlay()
				usr.gender = NEUTER
				usr.Immortal = 0
				usr.density=1
				usr.Gm = 0
				usr << "You slip on your Death Eater robes."
				usr.prevname = usr.name
				usr.name = "Robed Figure"
				usr.underlays = list()
				usr.GenerateNameOverlay(77,77,77,1)


mob/test/verb/FloorColor(c as color)
	for(var/turf/woodenfloor/t in world)
		if(t.z >= 21 && t.z <= 22)
			t.color = c
	for(var/turf/nofirezone/t in world)
		if(t.z >= 21 && t.z <= 22 && findtext(t.icon_state, "wood"))
			t.color = c
	for(var/turf/sideBlock/t in world)
		if(t.z >= 21 && t.z <= 22)
			t.color = c

obj/items/scroll/prize

	icon = 'Scroll.dmi'
	icon_state = "wrote"
	destroyable = 0
	accioable = 0
	wlable = 0
	name = "Prize Ticket"
	content = "<body bgcolor=black><u><font color=blue size=3><b>Prize Ticket</b></u></font><br><p><font color=white size=2>Turn this scroll to an admin+ to recieve a prize decided by the admin+.</font></p></body>"


	Name(msg as text)
		set hidden = 1

	write()
		set hidden = 1