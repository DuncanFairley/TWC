/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

obj/roofedge/canSave = 0
obj/Flippendo/canSave = 0

mob/AndersGoat
obj/Green_Mushroom
	New()
		..()
		spawn(1) loc = null
obj/Red_Mushroom
	New()
		..()
		spawn(1) loc = null
obj/Blue_Mushroom
	New()
		..()
		spawn(1) loc = null

obj/Stupid/Blessed_Torch
	New()
		..()
		spawn(1) loc = null
obj/Stupid/silver_knife
	New()
		..()
		spawn(1) loc = null
obj/Stupid/Holy_Grenade
	New()
		..()
		spawn(1) loc = null


mob/GM/verb
	Change_Area()
		set hidden = 1
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
	GM/verb
		Auror_Robes()
			set hidden = 1
		DErobes()
			set hidden = 1
		DE_chat(var/messsage as text)
			set hidden = 1

		Auror_chat(var/messsage as text)
			set hidden = 1
		Clan_store()
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

			refundSpells3()
				var/list/removedSpells = list(/mob/Spells/verb/Evanesco, /mob/Spells/verb/Eparo_Evanesca)
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
	view = replacetext(view,"x",",")
	return "1,1 to [view]"
mob/Spells/verb/Conjunctivis()
	set hidden = 1
mob/Spells/verb/Melofors()
	set hidden = 1
mob/Spells/verb/Rictusempra()
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
		Teach_Eparo_Evanesca()
			set hidden = 1
		Teach_Evanesco()
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

mob/verb/DisableBetaMapMode()
	set hidden = 1
mob/verb/EnableBetaMapMode()
	set hidden = 1
mob/verb/ToggleBetaMapMode()
	set hidden = 1
mob/verb/Mapmodetoggle()
	set hidden = 1

mob/Player/verb/Give()
	set hidden = 1

gold
	proc
		convert(mob/Player/p)
			var/nBronze = bronze + (silver * 100) + (gold * 10000) + (plat * 1000000)

			if(nBronze > 0)
				var/nPlat = round(nBronze / 1000000)
				nBronze -= nPlat * 1000000

				var/nGold = round(nBronze / 10000)
				nBronze -= nGold * 10000

				var/nSilver = round(nBronze / 10)
				nBronze -= nSilver * 1000000

				if(nPlat > 0)
					var/obj/items/money/iPlat = new (p)
					iPlat.stack = nPlat
					iPlat.UpdateDisplay()

				if(nGold > 0)
					var/obj/items/money/iGold = new (p)
					iGold.stack = nGold
					iGold.UpdateDisplay()

				if(nSilver > 0)
					var/obj/items/money/iSilver = new (p)
					iSilver.stack = nSilver
					iSilver.UpdateDisplay()

				if(nBronze > 0)
					var/obj/items/money/iBronze = new (p)
					iBronze.stack = nBronze
					iBronze.UpdateDisplay()

obj
	Pink_Flowers
		icon       = 'Plants.dmi'
		icon_state = "Pink Flowers"
		density    = 1
	Blue_Flowers
		icon       = 'Plants.dmi'
		icon_state = "Blue Flowers"
		density    = 1
	tabletop
		icon       = 'turf.dmi'
		icon_state = "t1"
		density    = 1
		layer      = 2
	tableleft
		icon       = 'turf.dmi'
		icon_state = "t2"
		density    = 1
		layer      = 2
	tablemiddle2
		icon       = 'turf.dmi'
		icon_state = "mid2"
		density    = 1
		layer      = 2
	tablemiddle
		icon       = 'turf.dmi'
		icon_state = "middle"
		density    = 1
		layer      = 2
	tablecornerL
		icon       = 'turf.dmi'
		icon_state = "t2"
		density    = 1
		layer      = 2
	tablecornerR
		icon       = 'turf.dmi'
		icon_state = "t3"
		density    = 1
		layer      = 2
	tableright
		icon       = 'turf.dmi'
		icon_state = "bottomright"
		density    = 1
		layer      = 2
	tableleft
		icon       = 'turf.dmi'
		icon_state = "bottom1"
		density    = 1
		layer      = 2
	tablebottom
		icon       = 'turf.dmi'
		icon_state = "bottom"
		density    = 1
		layer      = 2
	tablemid3
		icon       = 'turf.dmi'
		icon_state = "mid3"
		density    = 1
		layer      = 2

	art
		icon    = 'Decoration.dmi'
		density = 1

		Art_Tree
			icon_state = "tree top"
		Art_Tree2
			icon_state = "tree"
		Art
			icon_state = "royal top1"
		Art1
			icon_state = "royal1"
		Art_Man
			icon_state = "royal top"
		Art_Man2
			icon_state = "royal"

		painting
			density = 0
			p1
				icon_state = "big tl"
			p2
				icon_state = "big tr"
			p3
				icon_state = "big bl"
			p4
				icon_state = "big br"

	Hogwarts_Stairs
		icon = 'General.dmi'
		icon_state = "Stairs"

	tree
		name       = "Tree"
		icon       = 'BigTree.dmi'
		icon_state = "stump"

		density    = 1
		pixel_x    = -64


		New()
			..()

			var/obj/tree_top/t = new(loc)
			t.y++

			#if WINTER

			invisibility = 100

			#else

			if(prob(60))
				var/r = rand(160, 255)
				var/g = rand(82, r)
				var/b = rand(45, g)
				color = rgb(r, g, b)

			#endif

	tree_top
		name       = "Tree"
		icon       = 'BigTree.dmi'
		icon_state = "top"
		density = 1
		pixel_x = -64
		pixel_y = -32
		layer   = 5

		New()
			..()

			#if WINTER

			if(prob(70)) color = rgb(170, rand(170, 240), 170)

			var/r = rand(1,3)
			icon_state = "stump[r]_winter"

			if(prob(75))
				var/image/i = new('BigTree.dmi', "snow[r]")
				i.appearance_flags = RESET_COLOR
				overlays += i

			#else

			if(prob(80)) color = rgb(rand(150, 220), rand(100, 150), 0)

			#endif

	Armor_Head
		icon       = 'statues.dmi'
		icon_state = "head"
		layer      = MOB_LAYER + 1
	gargoylerighttop
		icon       = 'statues.dmi'
		icon_state = "top3"
		layer      = MOB_LAYER + 1
	gargoylelefttop
		icon       = 'statues.dmi'
		icon_state = "top2"
		layer      = MOB_LAYER + 1
	gargoylerightbottom
		icon       = 'statues.dmi'
		icon_state = "bottom3"
		density    = 1
	gargoyleleftbottom
		icon       = 'statues.dmi'
		icon_state = "bottom2"
		density    = 1
	Torch_
		icon       = 'misc.dmi'
		icon_state = "torch"
	Angel_Bottom
		icon       = 'statues.dmi'
		icon_state = "bottom1"
		density    = 1
	Angel_Top
		icon       = 'statues.dmi'
		icon_state = "top1"
		layer      = MOB_LAYER + 1
	Armor_Feet
		icon       = 'statues.dmi'
		icon_state = "feet"
		density    = 1
	Dual_Swords
		icon       = 'wallobjs.dmi'
		icon_state = "sword"
		density    = 1
	Fireplace
		icon       = 'misc.dmi'
		icon_state = "fireplace"
		density    = 1
	fence
		icon       = 'turf.dmi'
		icon_state = "fence"
		density    = 1
		pixel_y    = 16
	downfence
		icon       = 'turf.dmi'
		icon_state = "fence side"
		density    = 1
	halffence
		icon       = 'turf.dmi'
		icon_state = "fence"
		layer      = 5
		pixel_y    = -2
	Clock
		icon       = 'General.dmi'
		icon_state = "tile79"
		density    = 1
	gryffindorbanner
		icon       = 'shields.dmi'
		icon_state = "gryffindorbanner"
		density    = 1
	slytherinbanner
		icon       = 'shields.dmi'
		icon_state = "slytherinbanner"
		density    = 1
	hufflepuffbanner
		icon       = 'shields.dmi'
		icon_state = "hufflepuffbanner"
		density    = 1
	ravenclawbanner
		icon       = 'shields.dmi'
		icon_state = "ravenclawbanner"
		density    = 1
	hogwartshield
		icon       = 'shields.dmi'
		icon_state = "hogwartsshield"
		density    = 1