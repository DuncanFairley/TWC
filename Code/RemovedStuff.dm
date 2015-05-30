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
		Wizard
		Pentakill
		Basic
		Sunset
		New()
			..()
			spawn(1)
				var/t = text2path("/obj/items/key/[lowertext(name)]_key")
				new t (loc)
				loc = null

	chest
		Wizard
		Pentakill
		Basic
		Sunset

		New()
			..()
			spawn(1)
				var/t = text2path("/obj/items/chest/[lowertext(name)]_chest")
				new t (loc)
				loc = null

mob
	GM/verb
		Auror_Robes()
			set hidden = 1
		DErobes()
			set hidden = 1