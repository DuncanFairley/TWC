
obj/secret/Elf
	canSave = FALSE
	New()
		..()
		spawn(1)
			loc=null

hudobj/secretSanta
	canSave = FALSE
	New()
		..()
		spawn(1)
			loc=null

obj/items/treasure/gift
	canSave = FALSE
	New()
		..()
		spawn(1)
			loc=null

obj/clock/Curse_Clock
	canSave = FALSE
	New()
		..()
		spawn(1)
			loc=null

mob/Enemies/Summoned/Boss/Snowman/Super
	New()
		..()
		spawn(1)
			loc=null

obj/christmas_tree
	canSave = FALSE
	New()
		..()
		spawn(1)
			loc=null

obj/christmas_tree_orig
	canSave = FALSE
	New()
		..()
		spawn(1)
			loc=null

obj/christmas_lights
	canSave = FALSE
	New()
		..()
		spawn(1)
			loc=null

obj/snow_counter
	canSave = FALSE
	New()
		..()
		spawn(1)
			loc=null


mob/Player
	verb
		Use_Statpoints()
			set hidden = 1


obj/items/herosbrace

	New()
		..()
		spawn(1)
			loc = null

obj/items/MonBookMon
	New()
		..()
		spawn(1)
			loc = null

obj/Beer
	New()
		..()
		spawn(1)
			loc = null

obj/items/COMCText
	New()
		..()
		spawn(1)
			loc = null

obj/roofedge/canSave = 0
obj/Flippendo/canSave = 0

obj/items/lamps/farmer_lamp
	New()
		..()
		spawn(1)
			loc = null

mob/verb/Meditate()
	set hidden = 1

mob/Player/verb/swapControls()
	set hidden  = 1

mob/AndersGoat
obj/Green_Mushroom
	New()
		..()
		spawn(1) loc = null


mob/verb/Convert()
	set hidden = 1

obj/Exit
	New()
		..()
		spawn(1)
			loc = null

obj/MonBookMon
	New()
		..()
		spawn(1)
			loc = null
obj/items/MonBookMon
	New()
		..()
		spawn(1)
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
			loc = null

obj/items/wearable/pimp_ring
	New()
		..()
		spawn(1)
			new /obj/items/wearable/afk/pimp_ring (loc)
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

obj/items/snowring
	New()
		..()
		spawn(1)
			new /obj/items/wearable/ring/snowring (loc)
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
	set category = "Debug"
	for(var/turf/t in world)
		if(t.z >= 4 && t.z <= 5)
			if(istype(t, /turf/woodenfloor) || istype(t, /turf/nofirezone) || istype(t, /turf/sideBlock))
				if(!findtext(t.icon_state, "wood")) continue
				t.color = c

mob/test/verb/pickColor(newColor as color)
	set category = "Debug"

	var/ColorMatrix/c = new(newColor, 0.75)

	for(var/mob/Player/p in Players)
		animate(p.client, color = c.matrix, time = 10)

mob/test/verb/pickColorSatContBright(s as num, c as num, b as num)
	set category = "Debug"

	var/ColorMatrix/cm = new(s, c, b)

	for(var/mob/Player/p in Players)
		animate(p.client, color = cm.matrix, time = 10)

mob/test/verb/pickColorPreset(newColor in list("Invert", "BGR", "Greyscale", "Sepia", "Black & White", "Polaroid", "GRB", "RBG", "BRG", "GBR", "Normal"))
	set category = "Debug"

	if(newColor == "Normal")
		for(var/mob/Player/p in Players)
			animate(p.client, color = null, time = 10)
		return

	var/ColorMatrix/c = new(newColor)

	for(var/mob/Player/p in Players)
		animate(p.client, color = c.matrix, time = 10)

obj/items/scroll/prize
	Name(msg as text)
		set hidden = 1
	write()
		set hidden = 1

obj/art
	Art_Tree
		canSave = FALSE
		New()
			..()
			spawn(1)
				new /obj/static_obj/art/Art_Tree (loc)
				loc=null
	Art_Tree2
		canSave = FALSE
		New()
			..()
			spawn(1)
				loc=null
	Art
		canSave = FALSE
		New()
			..()
			spawn(1)
				new /obj/static_obj/art/Art_Female (loc)
				loc=null
	Art1
		canSave = FALSE
		New()
			..()
			spawn(1)
				loc=null
	Art_Man
		canSave = FALSE
		New()
			..()
			spawn(1)
				new /obj/static_obj/art/Art_Male (loc)
				loc=null
	Art_Man2
		canSave = FALSE
		New()
			..()
			spawn(1)
				loc=null

obj/static_obj/art
	Art_Tree2
		canSave = FALSE
		New()
			..()
			spawn(1)
				loc=null
	Art
		canSave = FALSE
		New()
			..()
			spawn(1)
				new /obj/static_obj/art/Art_Female (loc)
				loc=null
	Art1
		canSave = FALSE
		New()
			..()
			spawn(1)
				loc=null
	Art_Man
		canSave = FALSE
		New()
			..()
			spawn(1)
				new /obj/static_obj/art/Art_Male (loc)
				loc=null
	Art_Man2
		canSave = FALSE
		New()
			..()
			spawn(1)
				loc=null
mob
	Player
		proc
			refundSpells1()
				var/list/removedSpells = list(/mob/Spells/verb/Conjunctivis,
											  /mob/Spells/verb/Expecto_Patronum,
											  /mob/Spells/verb/Rictusempra,
											  /mob/Spells/verb/Dementia,
											  /mob/Spells/verb/Melofors,
											  /mob/Spells/verb/Crucio,
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

				var/count = 0
				for(var/s in removedSpells)
					if(verbs.Remove(s))
						count++

				if(count)
					spellpoints += count * 2
					src << infomsg("[count] spells were refunded.")


mob/Spells/verb/Furnunculus()
	set hidden = 1
mob/Spells/verb/Arania_Eximae()
	set hidden = 1
mob/Spells/verb/Solidus()
	set hidden = 1
mob/Spells/verb/Densuago()
	set hidden = 1
mob/Spells/verb/Levicorpus()
	set hidden = 1
mob/Spells/verb/Dementia()
	set hidden = 1
mob/Spells/verb/Conjunctivis()
	set hidden = 1
mob/Spells/verb/Melofors()
	set hidden = 1
mob/Spells/verb/Rictusempra()
	set hidden = 1
mob/Spells/verb/Expecto_Patronum()
	set hidden = 1
mob/Spells/verb/Evanesco()
	set hidden = 1

mob/GM/verb
	Teach_Eparo_Evanesca()
		set hidden = 1
	Teach_Evanesco()
		set hidden = 1

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
	gryffindor
		icon       = 'shields.dmi'
		icon_state = "gryffindor"
		density    = 1
	slytherin
		icon       = 'shields.dmi'
		icon_state = "slytherin"
		density    = 1
	hufflepuff
		icon       = 'shields.dmi'
		icon_state = "hufflepuff"
		density    = 1
	ravenclaw
		icon       = 'shields.dmi'
		icon_state = "ravenclaw"
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
	hogwartbanner
		icon       = 'shields.dmi'
		icon_state = "hogwartsbanner"
		density    = 1
	Neptune
		icon       = 'statues.dmi'
		icon_state = "top6"
		density    = 1
	NeptuneBottom
		icon       = 'statues.dmi'
		icon_state = "bottom6"
		density    = 1
	Grave_Rip
		icon       = 'statues.dmi'
		icon_state = "rip"
	curtains
		icon       = 'turf.dmi'
		layer      = 5
		c1
			icon_state = "c1"
		c2
			icon_state = "c2"
		c3
			icon_state = "c3"
		c4
			icon_state = "c4"
	plate
		icon       ='turf.dmi'
		icon_state="plate"
	Desk
		icon       ='desk.dmi'
		icon_state = "S1"
		density    = 1
		accioable  = 1
		wlable     = 1
	Book_Shelf
		icon       ='Desk.dmi'
		icon_state = "1"
		density    = 1
	Book_Shelf1
		icon       ='Desk.dmi'
		icon_state = "2"
		density    = 1
	Blackboard_
		icon       = 'bb.dmi'
		icon_state = "1"
	Blackboard__
		icon       = 'bb.dmi'
		icon_state = "2"
	Blackboard___
		icon       = 'bb.dmi'
		icon_state = "3"
	Barrels
		icon       = 'turf.dmi'
		icon_state = "barrels"
		density    = 1
	sink
		icon       = 'sink.dmi'
		density    = 1
	Magic_Sphere
		icon       ='misc.dmi'
		icon_state = "black"
	Triple_Candle
		icon       = 'General.dmi'
		icon_state = "tile80"
		density    = 1

mob/GM/verb
	Release_From_Detention(mob/Player/M in Players)
		set hidden = 1
	Give_Immortality(mob/Player/M in world)
		set hidden = 1
