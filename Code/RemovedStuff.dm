
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
obj/sink
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
	Desk
		icon       ='desk.dmi'
		icon_state = "S1"
		density    = 1
		accioable  = 1
		wlable     = 1

mob/GM/verb
	Release_From_Detention(mob/Player/M in Players)
		set hidden = 1
	Give_Immortality(mob/Player/M in world)
		set hidden = 1