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
				set waitfor = 0
				sleep(1)
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
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=1,inarena=0,insafezone=0,inhogwarts=1,target=M,mpreq=0,againstocclumens=1))
		new /StatusEffect/UsedAnnoying(src, 30)
		usr:learnSpell("Furnunculus")
		hearers()<<"<font color=red><b>[usr]: </font></b>Furnunculus!</font>"
		hearers()<<"[usr] twirls \his wand towards [M], ever so lightly."
		M.Zitt=0
		sleep(50)
		hearers()<<"[M]'s face begins to produce pimples! Puss-filled, erupting, mountainous zits!"
		M.overlays+=image('attacks.dmi', icon_state = "pimple")
		M.Zitt=1
		src=null
		spawn(rand(200,600))M.Zitt = 0
		var/dmg
		while(M && M.Zitt)
			dmg = rand(5,100)
			M.HP-=dmg
			M.Death_Check()
			M << "<small>You suffered [dmg] damage from Furnunculus.</small>"
			sleep(rand(30,120))
		if(M)
			M<<"<b>The jinx has been lifted. You are no longer afflicted by furnunculus.</b>"
			M.overlays-=image('attacks.dmi', icon_state = "pimple")

mob/Spells/verb/Arania_Eximae()
	set category="Spells"
	set name = "Arania Exumai"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=50,againstocclumens=1))
		usr.MP-=50
		usr.updateHPMP()
		hearers()<<"<b><font color=red>[usr]</b></font>: <b><font size=2><font color=white> Arania Exumai!"
		usr:learnSpell("Arania Exumai")
		for(var/mob/NPC/Enemies/Acromantula/A in oview())
			A.overlays+=image('attacks.dmi', icon_state = "arania")
			spawn(20)
				if(A.removeoMob)
					var/tmpmob = A.removeoMob
					A.removeoMob = null
					spawn()tmpmob:Permoveo()

				A.overlays-=image('attacks.dmi', icon_state = "arania")
				A.loc = locate(1,1,1)
				Respawn(A)
		sleep(19)
		hearers()<<"A blast shoots out of [usr]'s wand."

mob/Spells/verb/Solidus()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,antiTeleport=1))
		var/obj/stone/p = new /obj/stone
		p:loc = locate(src.x,src.y-1,src.z)
		flick('teleboom.dmi',p)
		p:owner = "[usr.key]"
		hearers()<<"<b><font color=red>[usr]:</font> <font color=green>Solidus."
		usr:learnSpell("Solidus")

mob/Spells/verb/Densuago(mob/M in view()&Players)
	set category = "Spells"
	set name = "Densaugeo"
	hearers()<<"[usr]: <font color=white><b>Densaugeo [M]!"
	sleep(20)
	M.overlays += image('attacks.dmi', icon_state = "teeth")
	hearers()<<"[M]'s teeth begin to grow rapidly!"
	M<<"[src] placed a curse on you! Your teeth grew rapidly. They will return to normal in 3 minutes."
	usr:learnSpell("Densaugeo")
	src = null
	spawn(1800)
		if(M)
			M.overlays -= image('attacks.dmi', icon_state = "teeth")
			M<<"Your teeth have been reduced to normal size."

mob/Spells/verb/Levicorpus(mob/M in view()&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedLevicorpus,needwand=1,inarena=0,insafezone=0,inhogwarts=0,target=M,mpreq=800,againstocclumens=1))
		hearers()<<"<b><font color=red>[usr]:<font color=green> Levicorpus.</b></font>"
		hearers()<<"[M] is lifted off of \his feet and dangles upside down in the air."
		if(M && M.removeoMob)
			M << "Your Permoveo spell failed."
			M.client.eye=M
			M.client.perspective=MOB_PERSPECTIVE
			M.removeoMob:ReturnToStart()
			M.removeoMob:removeoMob = null
			M.removeoMob = null
		flick('mist.dmi',M)
		if(!M.trnsed) M.icon_state="levi"
		usr.MP-=800
		usr.updateHPMP()
		M.movable=1
		for(var/obj/items/scroll/S in M)
			S.Move(M.loc)
		M:Resort_Stacking_Inv()
		new /StatusEffect/UsedLevicorpus(src,60)
		hearers()<<"[M]'s scrolls fall out of \his robes and float gently to the floor beneath them."
		usr:learnSpell("Levicorpus")
		src = null
		spawn(100)
			if(M)
				M.movable=0
				if(!M.trnsed) M.icon_state=""

mob/Spells/verb/Crucio(mob/M in oview()&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedCrucio,needwand=1,inarena=0,insafezone=0,target=M,mpreq=400))
		hearers()<<"<b><font color=red>[usr]:</b></font> <font color= #7CFC00>Crucio!"
		new /StatusEffect/UsedCrucio(src,15)
		//var/obj/S=new/obj/Crucio  //MAIN CRUCIO
		M.overlays+=image(icon='attacks.dmi',icon_state="crucio")
		usr.MP-=400
		usr.updateHPMP()
		sleep(1)
		hearers()<<"[M] cringes in pain!"
		M.HP-=500
		M.Death_Check()
		sleep(20)
		M.overlays-=image(icon='attacks.dmi',icon_state="crucio")
		usr:learnSpell("Crucio")

mob/Spells/verb/Dementia()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=0,inhogwarts=0,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/Summoned(src,15)
		hearers()<<"<b><font color=red>[usr]</b></font>: <b><font size=3><font color=green> DEMENTIA!"
		sleep(20)
		hearers()<<"Thick black fog shoots out of [usr]'s wand."
		sleep(20)
		hearers()<<"A Dementor emerges from the smoke."
		if(!src.loc.loc:safezoneoverride && (istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/hogwarts/Duel_Arenas) || istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/Diagon_Alley)))
			src << "<b>You can't use this inside a safezone.</b>"
			return
		var/mob/NPC/Enemies/Summoned/Dementor/D = new (loc)
		flick('mist.dmi',D)
		usr:learnSpell("Dementia")
		src = null
		spawn(600)
			if(D && D.loc)
				flick('mist.dmi',D)
				view(D)<<"The Dementor fades into smoke and vanishes."
				sleep(8)
				Respawn(D)

obj/screenobj/conjunct
		mouse_opacity = 0
		icon = 'black50.dmi'
		icon_state = "conjunct"
proc/view2screenloc(view)
	//example result "1,1 to 33,29
	view = dd_replacetext(view,"x",",")
	return "1,1 to [view]"
mob/Spells/verb/Conjunctivis(mob/M in oview()&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		//M.sight|=BLIND
		new /StatusEffect/UsedAnnoying(src,15)
		var/obj/screenobj/conjunct/S = new(M.client)
		S.layer = 100
		S.screen_loc = view2screenloc(M.client.view)
		for(var/obj/screenobj/conjunct/P in M.client.screen)
			//Remove preexisting blindness
			del(P)
		M.client.screen += S
		hearers()<<"<b><font color=red>[usr]:</font> <font size=2><font color=green>Conjunctivis [M]."
		usr<<"You've casted Conjunctivis upon [M], sealing \his eyes shut!"
		M<<"[usr] used Conjunctivis on you! Your eyes have been sealed shut for 10 seconds!"
		usr:learnSpell("Conjunctivis")
		src=null
		spawn(100)
			if(S)
				usr<<"Your Conjunctivis jinx has been lifted from [M]."
				M<<"The conjunctivis jinx has expired."
				del(S)
mob/Spells/verb/Melofors(mob/M in oview()&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/UsedAnnoying(src,15)
		M.sight|=BLIND
		hearers()<<"<b><font color=red>[usr]:</font> <font size=2><font color=red>Melofors [M]."
		hearers()<<"<b>A giant pumpkin falls from the sky and lands upon [M.name]'s head.</b>"
		M.overlays += image('attacks.dmi', icon_state = "melofors")
		usr:learnSpell("Melofors")
		src = null
		spawn(100)
			if(M)
				M.sight&=~BLIND
				M.overlays -= image('attacks.dmi', icon_state = "melofors")
				M<<"[usr]'s Melofors jinx has subsided."
				if(usr)usr<<"Your Melofors jinx has subsided from [M]."

mob/Spells/verb/Rictusempra(mob/M in oview(2)&Players)
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=500,againstocclumens=1))
		spawn()
			hearers()<< " <b>[usr]:<i><font color=blue> Rictusempra [M.name]!</i>"
			hearers() << "<font color=white><b>[M.name] is tickled and begins to laugh hysterically."
			M.Rictusempra=1
			usr.MP-= 500
			usr.updateHPMP()
			usr:learnSpell("Rictusempra")
			src = null
			spawn(300)
				if(M.Rictusempra||M.Rictalk)
					hearers() << "<b>[usr]'s Rictusempra charm has lifted.</b>"
				M.Rictusempra=0
				M.Rictalk=0

mob/Spells/verb/Expecto_Patronum()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		hearers()<<"<b><font color=red>[usr]</b></font>: <b><font size=3><font color=white>EXPECTO PATRONUM!"
		sleep(20)
		overlays += image('attacks.dmi', icon_state = "expecto")
		for(var/mob/NPC/Enemies/Summoned/Dementor/D in view())
			D.loc = locate(1,1,1)
			spawn()	Respawn(D)
		for(var/mob/NPC/Enemies/Dementor/D in view())
			D.loc = locate(1,1,1)
			spawn() Respawn(D)
		overlays -= image('attacks.dmi', icon_state = "expecto")
		hearers()<<"Bright white light shoots out of [usr]'s wand."
		usr:learnSpell("Expecto Patronum")