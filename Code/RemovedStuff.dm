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
			set hidden = 1
		Take_Scan()
			set hidden = 1
		Take_Crucio()
			set hidden = 1
		Take_Serpensortia()
			set hidden = 1
		Take_Dementia()
			set hidden = 1
		Teach_Immobulus()
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
		derobe
		aurorrobe
		DeathEater
		HA
		HDE
		Auror
		DE

	GM/verb
		Auror_Robes()
			set hidden = 1
		DErobes()
			set hidden = 1
		DE_chat(var/messsage as text)
			set hidden = 1

		Auror_chat(var/messsage as text)
			set hidden = 1

mob/test/verb/FloorColor(c as color)
	for(var/turf/t in world)
		if(t.z >= 21 && t.z <= 22)
			if(istype(t, /turf/woodenfloor) || istype(t, /turf/nofirezone) || istype(t, /turf/sideBlock))
				if(!findtext(t.icon_state, "wood")) continue
				t.color = c

mob/test/verb/pickColor(newColor as color)
	set category = "colors"

	var/ColorMatrix/c = new(newColor, 0.75)

	for(var/mob/Player/p in Players)
		animate(p.client, color = c.matrix, time = 10)

mob/test/verb/pickColorSatContBright(s as num, c as num, b as num)
	set category = "colors"

	var/ColorMatrix/cm = new(s, c, b)

	for(var/mob/Player/p in Players)
		animate(p.client, color = cm.matrix, time = 10)

mob/test/verb/pickColorPreset(newColor in list("Invert", "BGR", "Greyscale", "Sepia", "Black & White", "Polaroid", "GRB", "RBG", "BRG", "GBR", "Normal"))
	set category = "colors"

	if(newColor == "Normal")
		for(var/mob/Player/p in Players)
			animate(p.client, color = null, time = 10)
		return

	var/ColorMatrix/c = new(newColor)

	for(var/mob/Player/p in Players)
		animate(p.client, color = c.matrix, time = 10)

obj/items/scroll/prize

	icon = 'Scroll.dmi'
	icon_state = "wrote"
	destroyable = 0
	accioable = 0
	wlable = 0
	name = "Prize Ticket"
	content = "<body bgcolor=black><u><span style=\"color:blue; font-size:3;\"><b>Prize Ticket</b></u></span><br><p><span style=\"color:white; font-size:2;\">Turn this scroll to an admin+ to recieve a prize decided by the admin+.</span></p></body>"


	Name(msg as text)
		set hidden = 1

	write()
		set hidden = 1

mob/var/onionroot
mob/var/indigoseeds
mob/var/silverspiderlegs
mob/var/salamanderdrop
mob/var/talkedtosanta
mob/var/talkedtoalyssa

mob
	longap/verb
		Apparate_To_Three_Broomsticks()
			set hidden = 1
	longap/verb
		Apparate_To_Diagon_Alley()
			set hidden = 1
	longap/verb
		Apparate_To_Crossroads()
			set hidden = 1


mob
	Player
		proc
			refundSpells1()
				var/list/removedSpells = list(/mob/Spells/verb/Conjunctivis,
											  /mob/Spells/verb/Expecto_Patronum,
											  /mob/Spells/verb/Rictusempra,
											  /mob/Spells/verb/Dementia,
											  /mob/Spells/verb/Crucio,
											  /mob/Spells/verb/Melofors,
											  /mob/Spells/verb/Levicorpus,
											  /mob/Spells/verb/Densuago,
											  /mob/Spells/verb/Solidus,
											  /mob/Spells/verb/Arania_Eximae,
											  /mob/Spells/verb/Furnunculus)

				refundSpells(removedSpells)


			refundSpells2()
				var/list/removedSpells = list(/mob/Spells/verb/Immobulus)

				refundSpells(removedSpells)

			refundSpells(list/removedSpells)
				set waitfor = 0
				sleep(1)

				var/obj/items/wearable/wands/practice_wand/w = locate() in src
				if(w)
					if(w in Lwearing)
						w.Equip(src, 1)

					w.Dispose()
					Resort_Stacking_Inv()

				var/count = 0
				for(var/s in removedSpells)
					if(verbs.Remove(s))
						count++

				if(count)
					spellpoints += count * 2
					src << infomsg("[count] spells were refunded.")


mob/Spells/verb/Furnunculus(mob/M in view()&Players)
	set hidden = 1

mob/Spells/verb/Arania_Eximae()
	set hidden = 1

mob/Spells/verb/Solidus()
	set hidden = 1

mob/Spells/verb/Densuago(mob/M in view()&Players)
	set hidden = 1

mob/Spells/verb/Levicorpus(mob/M in view()&Players)
	set hidden = 1

mob/Spells/verb/Crucio(mob/M in oview()&Players)
	set hidden = 1

mob/Spells/verb/Dementia()
	set hidden = 1

obj/screenobj/conjunct
		mouse_opacity = 0
		icon = 'black50.dmi'
		icon_state = "conjunct"
proc/view2screenloc(view)
	//example result "1,1 to 33,29
	view = dd_replacetext(view,"x",",")
	return "1,1 to [view]"
mob/Spells/verb/Conjunctivis(mob/M in oview()&Players)
	set hidden = 1
mob/Spells/verb/Melofors(mob/M in oview()&Players)
	set hidden = 1
mob/Spells/verb/Rictusempra(mob/M in oview(2)&Players)
	set hidden = 1
mob/Spells/verb/Expecto_Patronum()
	set hidden = 1


obj/Food/Candy_Cane
	New()
		..()
		spawn(1)
			loc = null
obj/Beer
	New()
		..()
		spawn(1)
			loc = null
obj/Tea
	New()
		..()
		spawn(1)
			loc = null
obj/Blueberry_Pie
	New()
		..()
		spawn(1)
			loc = null
obj/Apple_Pie
	New()
		..()
		spawn(1)
			loc = null
obj/Cocoa_Nut_Cream_Pie
	New()
		..()
		spawn(1)
			loc = null
obj
	Pyramid_Bean
		New()
			..()
			spawn(1)
				loc = null

mob/GM
	verb
		Teach_Crucio()
			set hidden = 1
		Teach_Arania_Eximae()
			set hidden = 1
		Teach_Rictusempra()
			set hidden = 1
		Teach_Melofors()
			set hidden = 1
		Teach_Densuago()
			set hidden = 1
		Teach_Dementia()
			set hidden = 1
		Teach_Conjunctivis()
			set hidden = 1
		Teach_Aero()
			set hidden = 1
		Teach_Solidus()
			set hidden = 1
		Teach_Furnunculus()
			set hidden = 1
		Teach_Levicorpus()
			set hidden = 1
		Teach_Expecto_Patronum()
			set hidden = 1

		DayNight()
			set hidden = 1
		/*	set category = "Server"
			return
			for(var/area/outside/O in world)
				spawn() O.daycycle()
		Night()
			set category = "Server"
			for(var/area/outside/O in world)
				spawn() O.nightcycle()*/

obj/pokeby
	icon='pokeby.dmi'
	New()
		..()
		spawn(1)
			loc = null

obj/PyramidScroll1
	New()
		..()
		spawn(1)
			loc = null
obj/PyramidScroll2
	New()
		..()
		spawn(1)
			loc = null
obj/PyramidScroll3
	New()
		..()
		spawn(1)
			loc = null
obj/PyramidScroll4
	New()
		..()
		spawn(1)
			loc = null