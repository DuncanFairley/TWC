/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
var/list/spellList = list(
//	/mob/Spells/verb/Cugeo = "Cugeo",
	/mob/Spells/verb/Petreficus_Totalus = "Petrificus Totalus",
	/mob/Spells/verb/Scurries = "Scurries",
	/mob/Spells/verb/Conjunctivis = "Conjunctivis",
	/mob/Spells/verb/Portus = "Portus",
	/mob/Spells/verb/Expecto_Patronum = "Expecto Patronum",
	/mob/Spells/verb/Rictusempra = "Rictusempra",
	/mob/Spells/verb/Dementia = "Dementia",
	/mob/Spells/verb/Deletrius = "Deletrius",
	/mob/Spells/verb/Evanesco = "Evanesco",
	/mob/Spells/verb/Crucio = "Crucio",
	/mob/Spells/verb/Serpensortia = "Serpensortia",
	/mob/Spells/verb/Accio = "Accio",
	///mob/Spells/verb/Herbificus_Maxima = "Herbificus Maxima",
	/mob/Spells/verb/Reparo = "Reparo",
	/mob/Spells/verb/Herbificus = "Herbificus",
	/mob/Spells/verb/Bombarda = "Bombarda",
	/mob/Spells/verb/Eparo_Evanesca = "Eparo Evanesca",
	/mob/Spells/verb/Carrotosi = "Carrotosi",
	/mob/Spells/verb/Flippendo = "Flippendo",
	/mob/Spells/verb/Langlock = "Langlock",
	/mob/Spells/verb/Tremorio = "Tremorio",
	/mob/Spells/verb/Arcesso = "Arcesso",
	/mob/Spells/verb/Telendevour = "Telendevour",
	/mob/Spells/verb/Incindia = "Incindia",
	/mob/Spells/verb/Repellium = "Repellium",
	/mob/Spells/verb/Delicio = "Delicio",
	/mob/Spells/verb/Muffliato = "Muffliato",
	/mob/Spells/verb/Seatio = "Seatio",
	/mob/Spells/verb/Protego = "Protego",
	/mob/Spells/verb/Impedimenta = "Impedimenta",
	/mob/Spells/verb/Self_To_Dragon = "Personio Draconum",
	/mob/Spells/verb/Episky = "Episkey",
	/mob/Spells/verb/Chaotica = "Chaotica",
	/mob/Spells/verb/Valorus = "Valorus",
	/mob/Spells/verb/Inflamari = "Inflamari",
	/mob/Spells/verb/Immobulus = "Immobulus",
	/mob/Spells/verb/Ribbitous = "Ribbitous",
	/mob/Spells/verb/Avis = "Avis",
	/mob/Spells/verb/Reducto = "Reducto",
	/mob/Spells/verb/Glacius = "Glacius",
	/mob/Spells/verb/Confundus = "Confundus",
	/mob/Spells/verb/Self_To_Skeleton = "Personio Skelenum",
	/mob/Spells/verb/Self_To_Mushroom = "Personio Mushashi",
	/mob/Spells/verb/Anapneo = "Anapneo",
	/mob/Spells/verb/Melofors = "Melofors",
	/mob/Spells/verb/Aqua_Eructo = "Aqua Eructo",
	/mob/Spells/verb/Self_To_Human = "Personio Humaium",
	/mob/Spells/verb/Other_To_Human = "Transfiguro Revertio",
	/mob/Spells/verb/Levicorpus = "Levicorpus",
	/mob/Spells/verb/Depulso = "Depulso",
	/mob/Spells/verb/Occlumency = "Occlumency",
	/mob/Spells/verb/Flagrate = "Flagrate",
	/mob/Spells/verb/Incendio = "Incendio",
	/mob/Spells/verb/Imitatus = "Imitatus",
	/mob/Spells/verb/Felinious = "Felinious",
	/mob/Spells/verb/Permoveo = "Permoveo",
	/mob/Spells/verb/Reddikulus = "Riddikulus",
	/mob/Spells/verb/Densuago = "Densaugeo",
	/mob/Spells/verb/Replacio = "Replacio",
	/mob/Spells/verb/Incarcerous = "Incarcerous",
	/mob/Spells/verb/Peskipixie_Pesternomae = "Peskipiksi Pestermi",
	/mob/Spells/verb/Obliviate = "Obliviate",
	/mob/Spells/verb/Avifors = "Avifors",
	/mob/Spells/verb/Ferula = "Ferula",
	/mob/Spells/verb/Waddiwasi = "Waddiwasi",
	/mob/Spells/verb/Tarantallegra = "Tarantallegra",
	/mob/Spells/verb/Solidus = "Solidus",
	/mob/Spells/verb/Arania_Eximae = "Arania Exumai",
	/mob/Spells/verb/Sense = "Sense",
	/mob/Spells/verb/Nightus = "Nightus",
	/mob/Spells/verb/Harvesto = "Harvesto",
	/mob/Spells/verb/Scan = "Scan",
	/mob/Spells/verb/Furnunculus = "Furnunculus",
	/mob/Spells/verb/Expelliarmus = "Expelliarmus",
	/mob/Spells/verb/Eat_Slugs = "Eat Slugs",
	/mob/Spells/verb/Disperse = "Disperse",
	/mob/Spells/verb/Wingardium_Leviosa = "Wingardium Leviosa",
	/mob/Spells/verb/Antifigura = "Antifigura")
proc/name2spellpath(name)
	for(var/V in spellList)
		if(spellList[V] == name)
			return V
	world.log << "Was unable to find a spellpath in proc/name2spellpath with name=[name]"

mob/Spells/verb/Accio(obj/M in oview(usr.client.view,usr))
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		if(!M.accioable){src<<"<b><font color=red>Error:</b></font> This object cannot be teleported.";return}
		hearers(usr.client.view,usr)<< " <b>[usr]:<i><font color=aqua> Accio [M.name]!</i>"
		sleep(3)
		flick('Dissapear.dmi',M)
		sleep(20)
		if(M in oview(usr.client.view,usr))
			M.x = src:x
			M.y = src:y-1
			M.z = src:z
			flick('Appear.dmi',M)
		else
			usr << "The object is no longer in your view."

mob/Spells/verb/Eat_Slugs(var/n as text)
	set category = "Spells"
	set hidden = 1
	if(IsInputOpen(src, "Eat Slugs"))
		del _input["Eat Slugs"]
	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=100,againstocclumens=1))
		var/list/people = view(client.view)&Players
		var/mob/M

		if(n)
			for(var/mob/Player/p in people)
				if(findtext(n, p.name) && length(p.name) + 2 >= length(n))
					M = p
					break
		if(!M)
			var/Input/popup = new (src, "Eat Slugs")
			M = popup.InputList(src, "Cast this curse on?", "Eat Slugs", people[1], people)
			del popup
		if(!M) return
		new /StatusEffect/Summoned(src,15)
		MP = max(MP - 100, 0)
		if(derobe)
			hearers() << "<font size=2><font color=red><b><font color=red> [usr]</font></b> :<font color=white> Eat Slugs, [M.name]!"
		else
			hearers() << "<font size=2><font color=red><b>[Tag] <font color=red>[usr]</font> [GMTag]</b>:<font color=white> Eat Slugs, [M.name]!"

		M << errormsg("[usr] has casted the slug vomiting curse on you.")

		src=null
		spawn()
			var/slugs = rand(4,12)
			while(M && slugs > 0 && M.MP > 0)
				M.MP -= rand(20,60) * round(M.level/100)
				new/mob/Slug(M.loc)
				if(M.MP < 0)
					M.MP = 0
					M << errormsg("You feel drained from the slug vomiting curse.")
					break
				slugs--
				sleep(rand(20,90))

mob/Spells/verb/Disperse()
	set category = "Spells"
	set hidden = 1
	if(canUse(src,cooldown=/StatusEffect/UsedDisperse,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/UsedDisperse(src,10)
		for(var/obj/smokeeffect/S in view(client.view))
			del(S)
		for(var/turf/T in view())
			if(T.specialtype == "Swamp")
				T.slow -= 5
				T.overlays += image('mist.dmi',layer=10)
				spawn(9)
					T.overlays = null
		for(var/obj/The_Dark_Mark/dm in view())
			dm.counter(src)

mob/Spells/verb/Herbificus()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		var/obj/redroses/p = new
		p:loc = locate(src.x,src.y-1,src.z)
		flick('dlo.dmi',p)
		p:owner = "[usr.key]"
		hearers()<<"<b><Font color=red>[usr]:</font> Herbificus."
mob/Spells/verb/Protego()
	set category = "Spells"
	if(!usr.shielded)
		if(canUse(src,cooldown=/StatusEffect/UsedProtego,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
			new /StatusEffect/UsedProtego(src,10)
			usr.overlays += /obj/Shield
			hearers()<< "<b><font color=red>[usr]</b></font>: PROTEGO!"
			usr << "You shield yourself magically"
			usr.shielded = 1
			usr.shieldamount = (usr.Def+usr.extraDef) * 2.5
			sleep(100)
			if(usr.shielded==1)
				usr.shielded = 0
				usr.shieldamount = 0
				usr.overlays -= /obj/Shield
				usr.overlays -= /obj/Shield
				usr<<"You are no longer shielded!"
			else return
	else
		if(shielded)
			usr.shielded = 0
			usr.shieldamount = 0
			usr << "You are no longer shielded!"
		usr.overlays -= /obj/Shield
		usr.overlays -= /obj/Shield
mob/Spells/verb/Valorus(mob/Player/M in view()&Players)
	set category="Spells"
	var/mob/Player/user = usr
	if(locate(/obj/items/wearable/wands) in user.Lwearing)
		M.followplayer=0
		hearers() << "[usr] flicks \his wand towards [M]"
		if(M.flying)
			for(var/obj/items/wearable/brooms/B in M.Lwearing)
				B.Equip(M,1)
				//M.flying=0
				//M.icon_state=""
				//M.density=1
				hearers()<<"[M] is knocked off \his broom!"
				new /StatusEffect/Knockedfrombroom(M,15)
	else
		usr << "You must hold a wand to cast this spell."
mob/Spells/verb/Depulso()
	set category="Spells"
	var/mob/M
	for(M in get_step(usr,usr.dir))
		if(!M.key && !istype(M,/mob/Victims)) return
		var/turf/t = get_step_away(M,usr,15)
		if(!t || (issafezone(M.loc.loc) && !issafezone(t.loc))) return
		M.Move(t)

		if(!findStatusEffect(/StatusEffect/DepulsoText))
			new /StatusEffect/DepulsoText(src,5)
			hearers()<<"<b><font color=red>[usr]:</font></b> Depulso!"

		if(isplayer(M))
			M<<"You were pushed backwards by [usr]'s Depulso Charm."
			if(M.flying)
				for(var/obj/items/wearable/brooms/B in M:Lwearing)
					B.Equip(M,1)
					hearers()<<"[usr]'s Depulso knocked [M] off \his broom!"
					new /StatusEffect/Knockedfrombroom(M,15)
mob/Spells/verb/Deletrius()
	set category="Spells"
	var/mob/Player/user = usr
	if(locate(/obj/items/wearable/wands) in user.Lwearing)
		for(var/obj/redroses/S in oview(usr.client.view,usr))
			if(!S.GM_Made || (S.GM_Made && usr.Gm))
				flick('GMOrb.dmi',S)
				del S
		hearers(usr.client.view,usr)<<"[usr] flicks \his wand, causing the roses to dissolve into the air."
	else
		usr << errormsg("This spell requires a wand.")
mob/Spells/verb/Expelliarmus(mob/M in view()&Players)
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1))
		var/obj/items/wearable/wands/W = locate(/obj/items/wearable/wands) in M:Lwearing
		if(W)
			W.Equip(M,1)
			hearers()<<"<font color=red><b>[usr]</b></font>: <font color=white>Expelliarmus!"
			hearers()<<"<b>[M] loses \his wand.</b>"
			if(M.removeoMob)
				M << "Your Permoveo spell failed.."
				M.client.eye=M
				M.client.perspective=MOB_PERSPECTIVE
				M.removeoMob:ReturnToStart()
				M.removeoMob:removeoMob = null
				M.removeoMob = null
		else
			usr << "[M] doesn't have \his wand drawn."
mob/Spells/verb/Eparo_Evanesca()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedEvanesca,needwand=1,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedEvanesca(src,10)
		hearers()<<"<b><font color=red>[usr] <font color=blue> Eparo Evanesca!"
		for(var/mob/Player/M in hearers())
			if(M.key&&(M.invisibility==1))
				flick('teleboom.dmi',M)
				M.invisibility=0
				M.icon_state = ""
				var/obj/items/wearable/invisibility_cloak/C = locate(/obj/items/wearable/invisibility_cloak) in M.Lwearing
				if(C)
					C.Equip(M,1)
				else
					M.ApplyOverlays()
					M.invisibility=0
					M.sight &= ~SEE_SELF
					M.icon_state = ""
				M<<"You have been revealed!"
				new /StatusEffect/Decloaked(M,15)
mob/Spells/verb/Evanesco(mob/M in Players&oview())
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedEvanesco,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedEvanesco(src,15)
		flick('teleboom.dmi',M)
		M.invisibility=1
		M.sight |= SEE_SELF
		M.overlays = list()
		M.icon_state = "invis"
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]: <font color=blue>Evanesco!"
		M<<"You have been hidden!"
mob/Spells/verb/Imitatus(mob/M in view()&Players, T as text)
	set category = "Spells"
	if(src.mute==1){src<<"You cannot cast this spell while muted.";return}
	hearers()<<"</font><font color = #001E15>[usr]: Imitatus.</font>"
	hearers() << " <b><font color = red>[M]</B> <font color = red>:</font> </font> [html_encode(T)]"
mob/Spells/verb/Densuago(mob/M in view()&Players)
	set category = "Spells"
	set name = "Densaugeo"
	hearers()<<"[usr]: <font color=white><b>Densaugeo [M]!"
	sleep(20)
	M.overlays+=('teeth.dmi')
	hearers()<<"[M]'s teeth begin to grow rapidly!"
	M<<"[src] placed a curse on you! Your teeth grew rapidly. They will return to normal in 5 minutes."
	src = null
	spawn(3000)
		if(M)
			M.overlays-=('teeth.dmi')
			M<<"Your teeth have been reduced to normal size."
mob/Spells/verb/Morsmordre()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedClanAbilities, needwand=1))
		new /StatusEffect/UsedClanAbilities(src,300)
		var/obj/The_Dark_Mark/D = new /obj/The_Dark_Mark
		D:loc = locate(src.x,src.y+1,src.z)
		D.density=0
		flick('mist.dmi',D)
		hearers() <<"<b><font color=red>[usr]</b></font>: <b><font size=3><font color=green>MORSMORDRE!"
		world<<"The sky darkens as a sneering skull appears in the clouds with a snake slithering from its mouth."
		src = null
		spawn(600)
			if(D)
				world<<"The Dark Mark fades back into the clouds."
mob/Spells/verb/Repellium()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		usr.overlays+=image('expecto.dmi')
		hearers()<<"<b><font color=red>[usr]</b></font>: <b><font size=3><font color=white>Repellium!"
		sleep(20)
		for(var/mob/Snake/D in view())
			spawn()Respawn(D)
		for(var/mob/Snake_/D in view())
			spawn()Respawn(D)
		for(var/mob/NPC/Enemies/Snake/S in view())
			S.loc = locate(1,1,1)
			spawn()Respawn(S)
		hearers()<<"Bright white light shoots out of [usr]'s wand."
		usr.overlays-=image('expecto.dmi')

mob/Spells/verb/Basilio()
	set category = "Staff"
	hearers()<<"<b><font color=red>[usr]</b></font>: <b><font size=3><font color=green> Basilio!"
	sleep(20)
	hearers()<<"[usr]'s wand emits a bright flash of light."
	sleep(20)
	if(!src.loc.loc:safezoneoverride && (istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/hogwarts/Duel_Arenas) || istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/Diagon_Alley)))
		src << "<b>You can't use this inside a safezone.</b>"
		return
	hearers()<<"A Black Basilisk, emerges from [usr]'s wand."
	hearers()<<"<b>Basilisk</b>: Hissssssss!"
	var/mob/Basilisk/D = new /mob/Basilisk
	D:loc = locate(src.x,src.y-1,src.z)
	flick('mist.dmi',D)

mob/Spells/verb/Serpensortia()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=0,inhogwarts=0,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/Summoned(src,15)
		hearers()<<"<b><font color=red>[usr]</b></font>: <b><font size=3><font color=green> Serpensortia!"
		sleep(20)
		hearers()<<"[usr]'s wand emits a bright flash of light."
		sleep(20)
		if(!src.loc.loc:safezoneoverride && (istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/hogwarts/Duel_Arenas) || istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/Diagon_Alley)))
			src << "<b>You can't use this inside a safezone.</b>"
			return
		hearers()<<"A Red-Spotted Green Snake, emerges from the wand."
		hearers()<<"<b>Snake</b>: Hissssssss!"
		var/mob/Snake_/D = new /mob/Snake_
		D:loc = locate(src.x,src.y-1,src.z)
		flick('mist.dmi',D)
		src = null
		spawn(600)
			flick('mist.dmi',D)
			if(D)
				view(D)<<"The snake disappears."
				del D
mob/Spells/verb/Herbificus_Maxima()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		var/obj/redroses/a = new
		var/obj/redroses/b = new
		var/obj/redroses/c = new
		a.loc = get_step(usr,turn(usr.dir,-45))
		b.loc = get_step(usr,usr.dir)
		c.loc = get_step(usr,turn(usr.dir,45))
		flick('dlo.dmi',a)
		flick('dlo.dmi',b)
		flick('dlo.dmi',c)
		a:owner = "[usr.key]"
		b:owner = "[usr.key]"
		c:owner = "[usr.key]"
		hearers()<<"<b><Font color=red>[usr]:</font> Herbificus MAXIMA!"
mob/Spells/verb/Shelleh()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedShelleh,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=50,againstocclumens=1))
		new /StatusEffect/UsedShelleh(src,60)
		hearers()<<"<b><font color=red>[usr]:</font> <font color=white>Shelleh."

		for(var/turf/t in oview(rand(1,3)))
			if(t.density) continue
			if(prob(40))  continue
			if(t == loc)  continue
			new /obj/egg (t)
			sleep(1)

mob/Spells/verb/Solidus()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		var/obj/stone/p = new /obj/stone
		p:loc = locate(src.x,src.y-1,src.z)
		flick('teleboom.dmi',p)
		p:owner = "[usr.key]"
		hearers()<<"<b><font color=red>[usr]:</font> <font color=green>Solidus."
		src = null
mob/Spells/verb/Ferula()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		var/obj/Madame_Pomfrey/p = new /obj/Madame_Pomfrey
		p:loc = locate(src.x,src.y+1,src.z)
		flick('teleboom.dmi',p)
		hearers()<<"<b><font color=red>[usr]</b></font>: <b><font size=3><font color=aqua> Ferula!"
		hearers()<<"[usr] has summoned Madame Pomfrey!"
		spawn()
			src = null
			sleep(10)
			view(p)<<"<b>Madame Pomfrey</b>: Hello. Need healing? Click me."
			sleep(400)
			flick('dlo.dmi',p)
			p.icon = null
			sleep(10)
			if(p)
				view(p)<<"The nurse orbs out."
mob/Spells/verb/Expecto_Patronum()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		hearers()<<"<b><font color=red>[usr]</b></font>: <b><font size=3><font color=white>EXPECTO PATRONUM!"
		sleep(20)
		overlays += image('expecto.dmi')
		for(var/mob/Dementor/D in view())
			spawn() Respawn(D)
		for(var/mob/Dementor_/D in view())
			spawn() Respawn(D)
		for(var/mob/NPC/Enemies/Dementor/D in view())
			D.loc = locate(1,1,1)
			spawn() Respawn(D)
		overlays-=image('expecto.dmi')
		hearers()<<"Bright white light shoots out of [usr]'s wand."

mob/Spells/verb/Avis()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/Summoned(src,15)
		hearers()<<"<b><font color=red>[usr]</b></font>: <b><font size=3><font color=yellow> Avis!"
		sleep(20)
		hearers()<<"A bright white flash shoots out of [usr]'s wand."
		sleep(20)
		hearers()<<"A bird emerges."
		var/mob/Bird_/D = new /mob/Bird_
		D:loc = locate(src.x,src.y+1,src.z)
		flick('mist.dmi',D)
		src = null
		spawn(600)
			flick('mist.dmi',D)
			if(D)
				view(D)<<"The Bird flies away."
				del D
mob/Spells/verb/Crapus_Sticketh()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=0,inhogwarts=0,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/Summoned(src,15)
		hearers()<<"<b><font color=red>[usr]</b></font>: <b><font size=3><font color=green> Crapus...Sticketh!!"
		sleep(20)
		hearers()<<"A flash of black light shoots from [usr]'s wand."
		sleep(20)
		if(!src.loc.loc:safezoneoverride && (istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/hogwarts/Duel_Arenas) || istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/Diagon_Alley)))
			src << "<b>You can't use this inside a safezone.</b>"
			return
		hearers()<<"A stick figure appears."
		var/mob/Stickman_/D = new /mob/Stickman_
		D:loc = locate(src.x,src.y+1,src.z)
		flick('mist.dmi',D)
		src = null
		spawn(600)
			flick('mist.dmi',D)
			if(D)
				view(D)<<"The Stickman fades away."
				del D
mob/Spells/verb/Permoveo() // [your level] seconds - monster's level, but, /at least 30 seconds/?
	set category = "Spells"
	if(src.removeoMob)
		src << "You release your hold of the monster you were controlling."
		var/mob/NPC/Enemies/E = src.removeoMob
		if(E.removeoMob)
			spawn()
				E.ReturnToStart()
				E.removeoMob = null
		src.removeoMob = null
		src.client.eye=src
		src.client.perspective=MOB_PERSPECTIVE
		return
	var/list/enemies = list()
	for(var/mob/NPC/Enemies/M in ohearers())
		enemies.Add(M)
	if(!enemies.len)
		src << "There are no monsters in your view"
	else
		if(canUse(src,cooldown=/StatusEffect/Permoveo,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=300,againstocclumens=1))
			var/mob/NPC/Enemies/selmonster = input("Which monster do you cast Permoveo on?","Permoveo") as null|anything in enemies
			if(!selmonster) return
			if(!(selmonster in view())) return
			if(src.removeoMob) return
			if(usr.level < selmonster.level)
				src << errormsg("The monster is level [selmonster.level]. You need to be a higher level.")
				return
			new /StatusEffect/Permoveo(src, max(400-(usr.level/2), 30))

			hearers() << "[usr]: <i>Permoveo!</i>"
			if(selmonster.removeoMob)
				var/mob/B = selmonster.removeoMob
				B << "[src] took possession of the monster you were controlling."
				B.client.eye=B
				B.client.perspective=MOB_PERSPECTIVE
				B.removeoMob = null
			src.MP -= 300
			src.updateHPMP()

			src.removeoMob = selmonster
			src.client.eye = selmonster
			src.client.perspective = EYE_PERSPECTIVE
			selmonster.removeoMob = src
			selmonster.state = selmonster.CONTROLLED

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
		var/mob/Dementor_/D = new /mob/Dementor_
		D:loc = locate(src.x,src.y+1,src.z)
		flick('mist.dmi',D)
		src = null
		spawn(600)
			flick('mist.dmi',D)
			if(D)
				view(D)<<"The Dementor fades into smoke and vanishes."
				del D
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
	if(canUse(src,cooldown=/StatusEffect/UsedConjunctivis,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		//M.sight|=BLIND
		new /StatusEffect/UsedConjunctivis(src,15)
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
		src=null
		spawn(100)
			if(S)
				usr<<"Your Conjunctivis jinx has been lifted from [M]."
				M<<"The conjunctivis jinx has expired."
				del(S)
mob/Spells/verb/Melofors(mob/M in oview()&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedMelofors,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/UsedMelofors(src,15)
		M.sight|=BLIND
		hearers()<<"<b><font color=red>[usr]:</font> <font size=2><font color=red>Melofors [M]."
		hearers()<<"<b>A giant pumpkin falls from the sky and lands upon [M.name]'s head.</b>"
		M.overlays+=icon('pumpkinhead.dmi')
		src = null
		spawn(100)
			if(M)
				M.sight&=~BLIND
				M.overlays-=icon('pumpkinhead.dmi')
				M<<"[usr]'s Melofors jinx has subsided."
				if(usr)usr<<"Your Melofors jinx has subsided from [M]."
mob/Spells/verb/Incarcerous(var/mob/M in oview()&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedStun,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1))
		new /StatusEffect/UsedStun(src,15)
		M.movable=1
		M.icon_state="bind"
		hearers()<<"[usr]: <font color=aqua>Incarcerous, [M]!"
		sleep(20)
		hearers()<<"With a sudden spark, [usr]'s wand emits a stream of ropes which bind around [M]."
		if(M && M.removeoMob)
			M << "Your Permoveo spell failed.."
			M.client.eye=M
			M.client.perspective=MOB_PERSPECTIVE
			M.removeoMob:ReturnToStart()
			M.removeoMob:removeoMob = null
			M.removeoMob = null
		M<<"You are binded."
		src = null
		spawn(300)
			if(M && M.movable)
				M<<"<font color= #999900><b>[usr]'s curse has been dispelled. You can move again!"
				M.movable=0
				M.icon_state=""
				if(usr)usr<<"<font color= #999900><b>Your curse upon [M] has been lifted."
mob/Spells/verb/Anapneo(var/mob/M in view(usr.client.view,usr)&Players)
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		if(!M.flying == 0){src<<"<b><font color=red>Error:</b></font> You can't cast this spell on someone who is flying.";return}
		hearers()<<"<B><font color=red>[usr]:</font><font color=blue> <I>Anapneo!</I>"
		M.Rictusempra=0
		M.Rictalk=0
		M.silence=0
		M.muff=0
		sleep(20)
		hearers(usr.client.view,usr)<<"[usr] flicks \his wand, clearing the airway of [M]."
mob/Spells/verb/Reducto(var/mob/M in (view(usr.client.view,usr)&Players)|src)
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1))
		if(M.flying){src<<"<b><font color=red>Error:</b></font> You can't cast this spell on someone who is flying.";return}
		if(M.GMFrozen){alert("You can't free [M]. They have been frozen by a Game Master.");return}
		hearers(usr.client.view,usr)<<"<B><font color=red>[usr]:</font><font color=white> <I>Reducto!</I>"
		M.movable=0
		if(M.confused)M.confused=0
		hearers(usr.client.view,usr)<<"White light emits from [usr]'s wand, freeing [M]."
		flick('Reducto.dmi',M)
		M.icon_state=""
mob/Spells/verb/Reparo(obj/M in oview(src.client.view,src))
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		if(!M.rubbleable == 1){src<<"<b><font color=red>Error:</b></font> This object has Protection Charms placed upon it.";return}
		if(M.rubble==1)
			hearers(src.client.view,src) << "[src]: <b>Reparo!</b>"
			M.icon=M.picon
			M.name=M.pname
			M.icon_state=M.piconstate
			M.rubble=0
mob/Spells/verb/Bombarda(obj/M in oview(src.client.view,src))
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		if(istype(M,/obj/items/wearable/wands/salamander_wand))
			if(M.accioable==1)
				return
			else
				if(usr.salamanderdrop==1)
					usr << "There's no reason to ruin a perfectly good wand."
				else
					hearers(src.client.view,src) << "[src]: <b>Bombarda!</b>"
					usr << "You get some Salamander Drop!"
					new/obj/Alyssa/Salamander_Drop(usr)
					usr.salamanderdrop=1
					del M
		else
			if(!M.rubbleable == 1){src<<"<b><font color=red>Error:</b></font> This object has Protection Charms placed upon it.";return}
			if(M.rubble==1)
				return
			else
				hearers(src.client.view,src) << "[src]: <b>Bombarda!</b>"
				M.picon=M.icon
				M.pname=M.name
				M.piconstate=M.icon_state
				M.name="Pile of Rubble"
				M.icon='rubble.dmi'
				M.icon_state=""
				M.rubble=1
mob/Spells/verb/Rictusempra(mob/M in oview(2)&Players)
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=500,againstocclumens=1))
		spawn()
			hearers()<< " <b>[usr]:<i><font color=blue> Rictusempra [M.name]!</i>"
			hearers() << "<font color=white><b>[M.name] is tickled and begins to laugh hysterically."
			M.Rictusempra=1
			usr.MP-= 500
			usr.updateHPMP()
			src = null
			spawn(300)
				if(M.Rictusempra||M.Rictalk)
					hearers() << "<b>[usr]'s Rictusempra charm has lifted.</b>"
				M.Rictusempra=0
				M.Rictalk=0
mob/Spells/verb/Petreficus_Totalus(var/mob/M in oview()&Players)
	set category="Spells"
	set name = "Petrificus Totalus"
	if(canUse(src,cooldown=/StatusEffect/UsedStun,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1))
		new /StatusEffect/UsedStun(src,15)
		if(M && M.removeoMob)
			M << "Your Permoveo spell failed."
			M.client.eye=M
			M.client.perspective=MOB_PERSPECTIVE
			M.removeoMob:ReturnToStart()
			M.removeoMob:removeoMob = null
			M.removeoMob = null
		M<<"<font color= #999900>[usr] <b>uses <font color= #990099><b>Petrificus Totalus<font color= #999900> on you, <font color= #000099>turning you into stone for 10 seconds."

		M.movable=1
		M.icon_state="stone"
		hearers()<<"[usr]: <font color=blue>Petrificus Totalus!"
		src = null
		spawn(100)
			if(usr && M)
				usr<<"<font color= #999900><b>Your curse upon [M] has been lifted."
				M<<"<font color= #999900><b>[usr]'s curse has been dispelled. You can move again!"
			M.movable=0
			M.icon_state=""

mob
	Player/var/tmp/antifigura = 0
	proc
		CanTrans(mob/Player/p)
			if(p.antifigura > 0)
				p.antifigura--
				src << errormsg("Your spell failed, [p] is protected from transfiguring spells.")
				if(p.antifigura==0)
					p << errormsg("You were forced to release the shield around your body.")
					new /StatusEffect/UsedTransfiguration(p,15)
				return 0
			return 1

mob/Spells/verb/Antifigura()
	set category="Spells"
	var/mob/Player/p = src
	if(p.antifigura > 0)
		new /StatusEffect/UsedTransfiguration(usr,15)
		src << infomsg("You release the shield around your body.")
		p.antifigura = 0
	else if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=50,againstocclumens=1))
		hearers() << "<b><font color=red>[usr]</font></b>: <font color=white><i>Antifigura!</i></font>"
		p.antifigura = max(round((p.MMP+p.extraMMP) / rand(500,1500)), 1)
		p.MP -= 50


mob/Spells/verb/Chaotica()
	set category="Spells"
	var/dmg = round(usr.level * 1.1)
	if(dmg<20)dmg=20
	else if(dmg>2000)dmg = 2000
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=30,againstocclumens=1))
		castproj(30,'misc.dmi',"black",dmg,"chaotica")
mob/Spells/verb/Aqua_Eructo()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		HP -= 30
		Death_Check()
		castproj(0,'Aqua Eructo.dmi',"",usr.Def+(usr.extraDef/3),"aqua eructo")
mob/Spells/verb/Inflamari()
	set category="Spells"
	var/dmg = round(usr.level * 0.9)
	if(dmg<10)dmg=10
	else if(dmg>1000)dmg = 1000
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		castproj(0,'attacks.dmi',"fireball",dmg,"inflamari")
mob/Spells/verb/Glacius()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=10,againstocclumens=1))
		castproj(10,'attacks.dmi',"iceball",usr.Dmg+usr.extraDmg,"glacius")
mob/Spells/verb/Waddiwasi()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=10,againstocclumens=1))
		castproj(10,'attacks.dmi',"gum",usr.Dmg+usr.extraDmg,"waddiwasi")
mob/Spells/verb/Tremorio()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=5,againstocclumens=1))
		castproj(5,'attacks.dmi',"quake",usr.Dmg+usr.extraDmg,"tremorio")
mob/Spells/verb/Furnunculus(mob/M in oview()&Players)
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=0,inhogwarts=1,target=M,mpreq=0,againstocclumens=1))
		hearers()<<"<font color=red><b>[usr]: </font></b>Furnunculus!</font>"
		hearers()<<"[usr] twirls \his wand towards [M], ever so lightly."
		M.Zitt=0
		sleep(50)
		hearers()<<"[M]'s face begins to produce pimples! Puss-filled, erupting, mountainous zits!"
		M.overlays+=image('pimple.dmi')
		M.Zitt=1
		src=null
		spawn(rand(200,600))M.Zitt = 0
		var/dmg
		while(M.Zitt)
			sleep(rand(30,120))
			dmg = rand(5,100)
			M.HP-=dmg
			M.Death_Check()
			M << "<small>You suffered [dmg] damage from Furnunculus.</small>"
		M<<"<b>The jinx has been lifted. You are no longer afflicted by furnunculus.</b>"
		M.overlays-=image('pimple.dmi')

mob/var/tmp/list/_input

mob/proc/stop_arcesso()
	if(IsInputOpen(src, "Arcesso")) del _input["Arcesso"]
	if(ismob(arcessoing))
		if(IsInputOpen(arcessoing, "Arcesso")) del arcessoing._input["Arcesso"]
		arcessoing.arcessoing = 0
	arcessoing = 0

mob/Spells/verb/Arcesso()
	set category = "Spells"

	if(src.arcessoing == 1)
		hearers() << "[src] stops waiting for a partner."
		src.arcessoing = 0
	else if(ismob(arcessoing))
		hearers() << "[src] pulls out of the spell."
		stop_arcesso()

	else if(canUse(src,cooldown=/StatusEffect/UsedArcesso,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=400,againstocclumens=1))
		var/list/obj/circles = list(new/obj/circle/c1_1,new/obj/circle/c2_1,new/obj/circle/c3_1,new/obj/circle/c4_1,new/obj/circle/c5_1,
									new/obj/circle/c1_2,new/obj/circle/c2_2,new/obj/circle/c3_2,new/obj/circle/c4_2,new/obj/circle/c5_2,
									new/obj/circle/c1_3,new/obj/circle/c2_3,new/obj/circle/c3_3,new/obj/circle/c4_3,new/obj/circle/c5_3,
									new/obj/circle/c1_4,new/obj/circle/c2_4,new/obj/circle/c3_4,new/obj/circle/c4_4,new/obj/circle/c5_4,
									new/obj/circle/c1_5,new/obj/circle/c2_5,new/obj/circle/c3_5,new/obj/circle/c4_5,new/obj/circle/c5_5)

		var/turf/middle = get_step(src,dir)
		var/turf/opposite = get_step(middle,dir)
		for(var/mob/Player/M in opposite)
			if(istype(M,/mob/Player))
				if(M.arcessoing) src.arcessoing = M
		if(arcessoing)
			//partner found
			new /StatusEffect/UsedArcesso(src,15)
			arcessoing.arcessoing = src
			for(var/A in circles)
				if(A:owner2) return
				A:owner2 = arcessoing
			src << "You have joined [arcessoing]'s summoning."
			arcessoing << "[src] has joined your summoning."
			if(!arcessoing||!arcessoing.arcessoing)
				stop_arcesso()
			if(middle.density)
				//Summon location is dense, so cancel
				src << "<i>The teleport area is blocked.</i>"
				arcessoing << "<i>The teleport is blocked.</i>"
				stop_arcesso()
				return
			if(Players.len == 2)
				// noone to summon
				src << "<i>There is noone to summon.</i>"
				arcessoing << "<i>There is noone to summon.</i>"
				stop_arcesso()
				return
			var/Input/popup = new(arcessoing, "Arcesso")
			var/mob/summonee = popup.InputList(arcessoing,"Who would you like to summon?", "Arcesso", null, Players(list(src, arcessoing)))
			if(!summonee||!arcessoing)
				stop_arcesso()
				return
			src << "[arcessoing] has asked [summonee] to be summoned."
			arcessoing << "You have asked [summonee] to be summoned."
			if(arcessoing.arcessoing)
				if(arcessoing)
					if(istext(summonee) || istype(summonee.loc.loc,/area/hogwarts) || istype(summonee.loc.loc, /area/arenas) || summonee.Detention)
						src << "[summonee] can't be summoned from this location."
						arcessoing << "[summonee] can't be summoned from this location."
						stop_arcesso()
					else
						var/response = popup.Alert(summonee,"[src] and [arcessoing] would like to summon you. Do you accept?","Summon Request","Yes","No")
						if(response == "Yes")
							if(arcessoing)
								if(arcessoing.arcessoing)
									src.MP -= 400
									arcessoing.MP -= 800
									src.updateHPMP()
									arcessoing.updateHPMP()
									spawn()
										var/obj/circle/c3_3/C = new (middle)
										flick("a",C)
										sleep(1)
										flick("b",C)
										sleep(1)
										flick("c",C)
										sleep(1)
										flick("b",C)
										sleep(1)
										flick("a",C)
										sleep(1)
										flick("b",C)
										sleep(1)
										flick("c",C)
										sleep(1)
										flick("b",C)
										sleep(1)
										flick("a",C)
										sleep(1)
										del(C)
									spawn()
										summonee.stuned = 1
										var/obj/circle/c3_3/D = new (summonee.loc)
										flick("a",D)
										sleep(1)
										flick("b",D)
										sleep(1)
										flick("c",D)
										sleep(1)
										flick("b",D)
										sleep(1)
										flick("a",D)
										sleep(1)
										flick("b",D)
										sleep(1)
										flick("c",D)
										sleep(1)
										del(D)
									if(summonee.removeoMob) spawn()summonee:Permoveo()
									sleep(5)
									summonee << "You've been summoned by [src] and [src.arcessoing]."
									summonee.stuned = 0
									summonee:Transfer(middle)
									stop_arcesso()
									summonee.icon_state = ""

								else
									hearers() << "The invitation is no longer active."
							else
								hearers() << "The invitation is no longer active."
						else
							if(arcessoing && arcessoing.arcessoing)
								src << "[summonee] has not accepted your request to be summoned."
								arcessoing << "[summonee] has not accepted your request to be summoned."
								stop_arcesso()

		else
			//start waiting
			if(src.MP>=800)
				new /StatusEffect/UsedArcesso(src,15)
				arcessoing = 1
				hearers() << "[src] is waiting for a partner. Face [src] on the opposite side of the circle and cast Arcesso to participate."
				for(var/A in circles)
					A:loc = locate((middle.x+A:xoffset),(middle.y+A:yoffset),middle.z)
					A:owner1 = src
				src = null
				spawn()
					for(var/time = 0; time < 40;time++)
						if(!usr) break
						if(!usr.arcessoing) break
						sleep(10)
					for(var/A in circles)
						del(A)
					if(usr)
						usr.stop_arcesso()
			else
				src << "You require 800 MP to initiate this spell."


mob/Spells/verb/Flagrate(message as message)
	set category = "Spells"
	if(!message) return
	if(canUse(src,cooldown=/StatusEffect/UsedFlagrate,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=300,againstocclumens=1))
		if(usr.mute==0)
			if(str_count(message,"\n") > 20)
				usr << errormsg("Flagrate can only use up to 20 lines of text.")
			else
				message = copytext(message,1,500)
				new /StatusEffect/UsedFlagrate(src,10)
				hearers(client.view)<<"<font color=red><b>[usr]:</font> Flagrate!"
				sleep(10)
				hearers(client.view)<<"<font color=red><b>[usr]:</font> <font color=#FF9933><font size=3><font face='Comic Sans MS'> [html_encode(message)]</font>"
				usr.MP-=300
				usr.updateHPMP()
		else
			alert("You cannot cast this while muted.")
mob/Spells/verb/Langlock(mob/M in oview()&Players)
	set category = "Spells"
	set name = "Langlock"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=600,againstocclumens=1))
		if(!M.silence)
			M.silence=1
			src.MP -= 600
			src.updateHPMP()
			hearers()<<"[usr] flicks \his wand towards [M] and mutters, 'Langlock'"
			hearers() << "<b>[M]'s tongue has been stuck to the roof of \his mouth. They are unable to speak.</b>"
			src = null
			spawn(300)
				if(M.silence)
					M<<"<b>Your tongue unsticks from the roof of your mouth.</b>"
					M.silence=0
mob/Spells/verb/Muffliato(mob/M in view()&Players)
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		if(M.muff==1)
			usr << "This person already has been charmed with Muffliato."
			return
		else
			var/mob/caster = src
			M.muff=1
			view(2)<<"[usr] flicks \his wand towards [M] and mutters the word, 'Muffliato.'"
			src = null
			spawn(300)
				if(M.muff)
					if(caster)
						view(caster,3)<<"[caster]'s Muffliato Charm has lifted."
				M.muff=0
mob/Spells/verb/Incindia()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedIncindia,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=400,againstocclumens=1))
		hearers()<<"[src] raises \his wand into the air. <font color=red><b><i>INCINDIA!</b></i>"
		usr.MP-=400
		usr.updateHPMP()
		new /StatusEffect/UsedIncindia(src,10)
		var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		var/damage = round((Dmg + extraDmg) * 0.8)
		var/t = dir
		for(var/d in dirs)
			dir = d
			castproj(0, 'attacks.dmi', "fireball", damage, "Incindia", 0)
		dir = t
mob/Spells/verb/Replacio(mob/M in oview()&Players)
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=500,againstocclumens=1))
		if(issafezone(M.loc.loc) && !issafezone(loc.loc))
			src << "<b>[M] is inside a safezone.</b>"
			return
		hearers()<<"<b><Font color=red>[usr]:</b></font> <font color=blue><B> <i>Replacio Duo.</i></B>"
		var/startloc = usr.loc
		flick('GMOrb.dmi',M)
		flick('GMOrb.dmi',usr)
		usr:Transfer(M.loc)
		sleep(2)
		if(!(startloc in view(M.client.view)))
			M << errormsg("The replacio failed.")
			usr << errormsg("The replacio failed.")
			var/dense = density
			Move(startloc)
			density = dense
			return
		M:Transfer(startloc)
		flick('GMOrb.dmi',usr)
		flick('GMOrb.dmi',M)
		hearers()<<"[usr] trades places with [M]"
		usr.MP-=500
		usr.updateHPMP()
mob/Spells/verb/Occlumency()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=1,againstocclumens=1))
		if(!usr.occlumens)
			for(var/client/C)
				if(C.eye)
					if(C.eye == usr && C.mob != usr)
						C << "<b><font color = white>Your Telendevour wears off."
						C.eye=C.mob
			hearers() << "<b><font color=red>[usr]</font></b>: <font color=white><i>Occlumens!</i></font>"
			usr << "You can no longer be viewed by Telendevour."
			usr.occlumens = usr.MMP+usr.extraMMP
			usr:OcclumensCounter()
		else
			src << "You release the barriers around your mind."
			usr.occlumens = 0
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
		M.icon_state="levi"
		usr.MP-=800
		usr.updateHPMP()
		M.movable=1
		for(var/obj/items/scroll/S in M)
			S.Move(M.loc)
		M:Resort_Stacking_Inv()
		new /StatusEffect/UsedLevicorpus(src,60)
		hearers()<<"[M]'s scrolls fall out of \his robes and float gently to the floor beneath them."
		src = null
		spawn(100)
			M.movable=0
			M.icon_state=""
mob/Spells/verb/Obliviate(mob/M in view()&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedObliviate,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=700,againstocclumens=0))
		hearers()<<"<b><font color=red>[usr]:<font color=green> Obliviate!</b></font>"
		//M<<"<p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p><p>"
		//M<<"<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>"
		M << output(null,"output")
		hearers()<<"[usr] wiped [M]'s memory!"
		usr.MP-=700
		new /StatusEffect/UsedObliviate(src,30)
		usr.updateHPMP()
mob/Spells/verb/Tarantallegra(mob/M in view()&Players)
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=100,againstocclumens=1))
		if(M.dance) return
		hearers()<<"<b>[usr]:</B><font color=green> <i>Tarantallegra!</i>"
		usr.MP-=100
		usr.updateHPMP()
		if(key != "Murrawhip")
			M.dance=1
		src=null
		spawn()
			view(M)<<"[M] begins to dance uncontrollably!"
			var/timer = 0
			var/dirs = list(NORTH,EAST,SOUTH,WEST,NORTHWEST,NORTHEAST,SOUTHWEST,SOUTHEAST)
			while(M && timer < 24)
				timer++
				if(!M.movable)
					var/turf/t = get_step_rand(M)
					if(t && !(issafezone(M.loc.loc) && !issafezone(t.loc)))
						M.Move(t)
				M.dir = pick(dirs)
				sleep(5)
			if(M) M.dance = 0
mob/Spells/verb/Immobulus()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedStun,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=600,againstocclumens=1))
		new /StatusEffect/UsedStun(src,15)
		hearers()<<"<b>[usr]:</b> <font color=blue>Immobulus!"
		hearers()<<"A sudden wave of energy emits from [usr]'s wand, immobilizing everything in sight."
		usr.MP-=600
		usr.updateHPMP()
		for(var/mob/M in oview())
			if(M.key!=usr.key)
				if(M.key)
					if(!M.Gm)
						if(M && M.removeoMob)
							M << "Your Permoveo spell failed.."
							M.client.eye=M
							M.client.perspective=MOB_PERSPECTIVE
							M.removeoMob:ReturnToStart()
							M.removeoMob:removeoMob = null
							M.removeoMob = null
						M.movable=1
						M.Immobile=1
						M.overlays.Remove(image('Immobulus.dmi'))
						M.overlays += image('Immobulus.dmi')
		src=null
		spawn(100)
			for(var/client/C)
				if(C.mob)if(C.mob.Immobile==1)
					C.mob.overlays -= image('Immobulus.dmi')
					C.mob.movable=0
					C.mob.Immobile=0
					if(usr)C<<"[usr]'s Immobulus curse wore off. You can move again."
mob/Spells/verb/Impedimenta()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedStun,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=750,againstocclumens=1))
		hearers()<<"<b>[usr]:</b> <font color=red>Impedimenta!"
		hearers()<<"A sharp blast of energy emits from [usr]'s wand, slowing down everything in the area."
		usr.MP-=750
		usr.updateHPMP()
		new /StatusEffect/UsedStun(src,20)
		var/turf/lt = list()
		for(var/turf/T in view(7))
			lt += T
			T.overlays += image('black50.dmi',"impedimenta")
			T.slow += 5
		src = null
		spawn(100)
			for(var/turf/T in lt)
				T.overlays -= image('black50.dmi',"impedimenta")
				if(T.slow >= 5)
					T.slow -= 5
mob/Spells/verb/Incendio()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=20,againstocclumens=1))
		var/obj/S=new/obj/Incendio
		usr.MP-=20
		usr.updateHPMP()
		S.loc=(usr.loc)
		S.owner="[usr]"
		walk(S,usr.dir,2)
		sleep(20)
		del S
/*mob/Spells/verb/Cugeo(mob/Player/M in view()&Players)
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=10,againstocclumens=1))
		hearers()<<"<b><font color=red>[usr]</font>:<FONT COLOR=#dda0dd>C</FONT><FONT COLOR=#ef736f>u</FONT><FONT COLOR=#ff4500>g</FONT><FONT COLOR=#bea100>e</FONT><FONT COLOR=#7cfc00>o</FONT></FONT>, [M].</b>"
		sleep(20)
		flick('fireworks.dmi',M)
		M.overlays+=image('hair.dmi',icon_state="black")*/
mob/Spells/verb/Reddikulus(mob/M in view()&Players)
	set category="Spells"
	set name = "Riddikulus"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=100,againstocclumens=1))
		hearers()<<"<b><font color=red>[usr]</font>: <font color=red><font size=3>Riddikulus!</font></font>, [M].</b>"
		sleep(20)
		if(!M) return
		flick('fireworks.dmi',M)
		if(M.derobe) return
		if(M.Gender=="Male")
			if(M.Gm)
				M.icon='FemaleStaff.dmi'
				M.icon_state=""
				sleep(600)
				if(!M) return
				M << "<b>You turn back to Normal</b>"
				flick('teleboom.dmi',M)
				M.icon='MaleStaff.dmi'
				M.icon_state=""
				return
			if(M.aurorrobe)
				M.icon='FemaleAuror.dmi'
				M.icon_state=""
				sleep(600)
				if(!M) return
				M << "<b>You turn back to Normal</b>"
				flick('teleboom.dmi',M)
				M.icon='MaleAuror.dmi'
				M.icon_state=""
				return
			if(M.House=="Gryffindor")
				M.icon='FemaleGryffindor.dmi'
				M.icon_state=""
				sleep(600)
				if(!M) return
				M << "<b>You turn back to Normal</b>"
				flick('teleboom.dmi',M)
				M.icon='MaleGryffindor.dmi'
				M.icon_state=""
				return
			if(M.House=="Ravenclaw")
				M.icon='FemaleRavenclaw.dmi'
				M.icon_state=""
				sleep(600)
				if(!M) return
				M << "<b>You turn back to Normal</b>"
				flick('teleboom.dmi',M)
				M.icon='MaleRavenclaw.dmi'
				M.icon_state=""
				return
			if(M.House=="Slytherin")
				M.icon='FemaleSlytherin.dmi'
				M.icon_state=""
				sleep(600)
				if(!M) return
				M << "<b>You turn back to Normal</b>"
				flick('teleboom.dmi',M)
				M.icon='MaleSlytherin.dmi'
				M.icon_state=""
				return
			if(M.House=="Hufflepuff")
				M.icon='FemaleHufflepuff.dmi'
				M.icon_state=""
				sleep(600)
				if(!M) return
				M << "<b>You turn back to Normal</b>"
				flick('teleboom.dmi',M)
				M.icon='MaleHufflepuff.dmi'
				M.icon_state=""
				return
		else
			if(M.Gm)
				M.icon='MaleStaff.dmi'
				M.icon_state=""
				sleep(600)
				if(!M) return
				M << "<b>You turn back to Normal</b>"
				flick('teleboom.dmi',M)
				M.icon='FemaleStaff.dmi'
				M.icon_state=""
				return
			if(M.aurorrobe)
				M.icon='MaleAuror.dmi'
				M.icon_state=""
				sleep(600)
				if(!M) return
				M << "<b>You turn back to Normal</b>"
				flick('teleboom.dmi',M)
				M.icon='FemaleAuror.dmi'
				M.icon_state=""
				return
			if(M.House=="Gryffindor")
				M.icon='MaleGryffindor.dmi'
				M.icon_state=""
				sleep(600)
				if(!M) return
				M << "<b>You turn back to Normal</b>"
				flick('teleboom.dmi',M)
				M.icon='FemaleGryffindor.dmi'
				M.icon_state=""
				return
			if(M.House=="Ravenclaw")
				M.icon='MaleRavenclaw.dmi'
				M.icon_state=""
				sleep(600)
				if(!M) return
				M << "<b>You turn back to Normal</b>"
				flick('teleboom.dmi',M)
				M.icon='FemaleRavenclaw.dmi'
				M.icon_state=""
				return
			if(M.House=="Slytherin")
				M.icon='MaleSlytherin.dmi'
				M.icon_state=""
				sleep(600)
				if(!M) return
				M << "<b>You turn back to Normal</b>"
				flick('teleboom.dmi',M)
				M.icon='FemaleSlytherin.dmi'
				M.icon_state=""
				return
			if(M.House=="Hufflepuff")
				M.icon='MaleHufflepuff.dmi'
				M.icon_state=""
				sleep(600)
				if(!M) return
				M << "<b>You turn back to Normal</b>"
				flick('teleboom.dmi',M)
				M.icon='FemaleHufflepuff.dmi'
				M.icon_state=""
				return
mob/Spells/verb/Ecliptica()
	set category="Spells"
	var/mob/M
	for(M in get_step(usr,usr.dir))
		step_away(M,usr,75)
		hearers()<<"<b><font color=red>[usr]:</font></b> Ecliptica!"
		M<<"You were pushed back!"
mob/Spells/verb/Delicio(mob/Player/M in oview(usr.client.view,usr)&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>: <b>Delicio, [M].</b>"
		if(CanTrans(M))
			flick("transfigure",M)
			M<<"<b><font color=red>Delicio Charm:</b></font>[usr] turned you into a delicious Turkey."
			M.trnsed = 1
			M.overlays = null
			if(M.away)M.ApplyAFKOverlay()
			M.icon = 'Turkey.dmi'
mob/Spells/verb/Avifors(mob/Player/M in oview(usr.client.view,usr)&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><font color=gray>[usr]</font>: <b>Avifors, [M].</b>"
		if(CanTrans(M))
			flick("transfigure",M)
			M<<"<b><font color=gray>Avifors Charm:</b></font>[usr] turned you into a black crow."
			M.trnsed = 1
			M.overlays = null
			if(M.away)M.ApplyAFKOverlay()
			M.icon = 'Bird.dmi'
mob/Spells/verb/Ribbitous(mob/Player/M in oview(usr.client.view,usr)&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>:<b><font color=green> Ribbitous, [M].</b></font>"
		if(CanTrans(M))
			flick("transfigure",M)
			M<<"<b><font color=green>Ribbitous Charm:</b></font> [usr] turned you into a Frog."
			M.trnsed = 1
			M.overlays = null
			if(M.away)M.ApplyAFKOverlay()
			M.icon = 'Frog.dmi'
mob/Spells/verb/Carrotosi(mob/Player/M in oview(usr.client.view,usr)&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>:<b><font color=red> Carrotosi, [M].</b></font>"
		if(CanTrans(M))
			flick("transfigure",M)
			M<<"<b><font color=red>Carrotosi Charm:</b></font> [usr] turned you into a Rabbit."
			M.trnsed = 1
			M.overlays = null
			if(M.away)M.ApplyAFKOverlay()
			M.icon = 'Rabbit.dmi'
mob/Spells/verb/Self_To_Dragon()
	set name = "Personio Draconum"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedTransfiguration(src,15)
		if(CanTrans(src))
			flick("transfigure",src)
			usr.trnsed = 1
			usr.overlays = null
			if(usr.away)usr.ApplyAFKOverlay()
			usr.icon = 'Dragon.dmi'
mob/Spells/verb/Self_To_Mushroom()
	set name = "Personio Musashi"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedTransfiguration(src,15)
		if(CanTrans(src))
			flick("transfigure",src)
			usr.overlays = null
			if(usr.away)usr.ApplyAFKOverlay()
			usr.trnsed = 1
			switch(usr.House)
				if("Gryffindor")
					usr.icon = 'Red_Mushroom.dmi'
				if("Slytherin")
					usr.icon = 'Green_Mushroom.dmi'
				if("Ravenclaw")
					usr.icon = 'Blue_Mushroom.dmi'
				if("Hufflepuff")
					usr.icon = 'Yellow_Mushroom.dmi'
				else
					usr.icon = 'Yellow_Mushroom.dmi'
mob/Spells/verb/Self_To_Skeleton()
	set name = "Personio Sceletus"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedTransfiguration(src,15)
		if(CanTrans(src))
			flick("transfigure",usr)
			usr.trnsed = 1
			usr.overlays = null
			if(usr.away)usr.ApplyAFKOverlay()
			usr.icon = 'Skeleton.dmi'
mob/Spells/verb/Other_To_Human(mob/Player/M in oview(usr.client.view,usr)&Players)
	set name = "Transfiguro Revertio"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>:<b><font color=green> Transfiguro Revertio, [M].</b></font>"
		new /StatusEffect/UsedTransfiguration(src,15)
		if(CanTrans(M))
			flick("transfigure",M)
			if(M.derobe)
				M.icon = 'Deatheater.dmi'
			else if(M.aurorrobe)
				M.trnsed = 0
				if(M.Gender == "Female")
					M.icon = 'FemaleAuror.dmi'
				else
					M.icon = 'MaleAuror.dmi'
			else
				M.trnsed = 0
				M.icon = M.baseicon
			M.ApplyOverlays()
			M<<"[usr] reversed your transfiguration."
mob/Spells/verb/Self_To_Human()
	set name = "Personio Humaium"
	set category="Spells"
	var/mob/Player/user = usr
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		if(CanTrans(src))
			flick("transfigure",usr)
			if(usr.aurorrobe)
				usr.trnsed = 0
				if(usr.Gender == "Female")
					usr.icon = 'FemaleAuror.dmi'
				else
					usr.icon = 'MaleAuror.dmi'
			else if(usr.derobe)
				usr.icon = 'Deatheater.dmi'
			else
				usr.trnsed = 0
				usr.icon = usr.baseicon
			user.ApplyOverlays()
			usr<<"You reversed your transfiguration."
mob/Spells/verb/Harvesto(mob/Player/M in oview(usr.client.view,usr)&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>:<b> Harvesto, [M].</b>"
		if(CanTrans(M))
			flick("transfigure",M)
			if(!M)return
			M<<"<b><font color=red>Harvesto Charm:</b></font> [usr] turned you into an Onion."
			M.trnsed = 1
			M.overlays = null
			if(M.away)M.ApplyAFKOverlay()
			M.icon = 'Onion.dmi'
mob/Spells/verb/Felinious(mob/Player/M in oview(usr.client.view,usr)&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>:<b> Felinious, [M].</b>"
		if(CanTrans(M))
			if(!M)return
			M<<"<b><font color=blue>Felinious Charm:</b></font> [usr] turned you into a Black Cat."
			flick("transfigure",M)
			M.trnsed = 1
			M.overlays = null
			if(M.away)M.ApplyAFKOverlay()
			M.icon = 'BlackCat.dmi'
mob/Spells/verb/Scurries(mob/Player/M in oview(usr.client.view,usr)&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>: <b>Scurries, [M].</b>"
		if(CanTrans(M))
			if(!M)return
			flick("transfigure",M)
			M<<"<b><font color=blue>Scurries Charm:</b></font> [usr] turned you into a Mouse."
			M.trnsed = 1
			M.overlays = null
			if(M.away)M.ApplyAFKOverlay()
			M.icon = 'Mouse.dmi'
mob/Spells/verb/Seatio(mob/Player/M in oview(usr.client.view,usr)&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>: <b>Seatio, [M].</b>"
		if(CanTrans(M))
			if(!M)return
			flick("transfigure",M)
			M<<"<b><font color=red>Seatio Charm:</b></font> [usr] turned you into a Chair."
			M.trnsed = 1
			M.overlays = null
			if(M.away)M.ApplyAFKOverlay()
			M.icon = 'Chair.dmi'
mob/Spells/verb/Nightus(mob/Player/M in oview(usr.client.view,usr)&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>: <b>Nightus, [M].</b>"
		if(CanTrans(M))
			if(!M)return
			flick("transfigure",M)
			M<<"<b><font color=red>Nightus Charm:</b></font> [usr] turned you into a Bat."
			M.trnsed = 1
			M.overlays = null
			if(M.away)M.ApplyAFKOverlay()
			M.icon = 'Bat.dmi'
mob/Spells/verb/Peskipixie_Pesternomae(mob/Player/M in oview(usr.client.view,usr)&Players)
	set category="Spells"
	set name = "Peskipiksi Pestermi"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]</font>: <b>Peskipiksi Pestermi, [M].</b>"
		if(CanTrans(M))
			if(!M)return
			flick("transfigure",M)
			M<<"<b><font color=blue>Peskipixie Pestermae Charm:</b></font> [usr] turned you into a Pixie."
			M.trnsed = 1
			M.overlays = null
			if(M.away)M.ApplyAFKOverlay()
			M.icon = 'Pixie.dmi'
mob/Spells/verb/Telendevour()
	set category="Spells"
	set popup_menu = 0
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		if(usr.client.eye==usr)
			var/mob/M = input("Which person would you like to view?") as null|anything in Players(list(src))
			if(!M)return
			if(usr.client.eye != usr) return
			if(istext(M) || istype(M,/mob/fakeDE) || istype(M.loc.loc, /area/blindness) || M.occlumens>0 || M.derobe || M.aurorrobe || istype(M.loc.loc, /area/ministry_of_magic))
				src<<"<b>You feel magic repelling your spell.</b>"
			else
				usr.client.eye=M
				usr.client.perspective=EYE_PERSPECTIVE
				file("Logs/Telenlog.txt") << "[time2text(world.realtime,"MMM DD - hh:mm:ss")]: [usr] telendevoured [M]"
				var/randnum = rand(1,7)
				hearers()<<"[usr]:<font color=blue><b><font size=2> Telendevour!</font>"
				if(randnum == 1)
					M<<"You feel that <b>[usr]</b> is watching you."
				else
					M<<"The hair on the back of your neck tingles."
		else
			if(usr.client.perspective == EYE_PERSPECTIVE)
				usr.client.eye=usr
				usr.client.perspective=EYE_PERSPECTIVE
				hearers()<<"[usr]'s eyes appear again."
mob/Spells/verb/Arania_Eximae()
	set category="Spells"
	set name = "Arania Exumai"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=50,againstocclumens=1))
		usr.MP-=50
		usr.updateHPMP()
		hearers()<<"<b><font color=red>[usr]</b></font>: <b><font size=2><font color=white> Arania Exumai"
		for(var/mob/NPC/Enemies/Acromantula/A in oview())
			A.overlays+=image('arania.dmi')
			spawn(20)
				if(A.removeoMob)
					var/tmpmob = A.removeoMob
					A.removeoMob = null
					spawn()tmpmob:Permoveo()

				A.overlays-=image('arania.dmi')
				A.loc = locate(1,1,1)
				Respawn(A)
		sleep(19)
		hearers()<<"A blast shoots out of [usr]'s wand."
mob/Spells/verb/Avada_Kedavra()
	set category="Spells"
	if(clanrobed())return
	if(key != "Murrawhip")
		hearers()<<"<b><font color=red>[src]:</b></font> <font color= #00FF33>Avada Kedavra !"
	var/obj/S=new/obj/Avada_Kedavra

	S.loc=(src.loc)
	S.damage=src.Dmg+extraDmg
	S.owner=usr
	walk(S,src.dir,2)
	sleep(20)
	del S
	return
mob/Spells/verb/Episky()
	set name = "Episkey"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedEpiskey,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		hearers()<<"<font color=red><b>[usr]:</font></b> <font color=aqua>Episkey!"
		new /StatusEffect/UsedEpiskey(src,15)
		usr.HP=usr.MHP+usr.extraMHP
		usr.updateHPMP()
		usr.overlays+=image('Heal.dmi')
		sleep(10)
		hearers()<<"<font color=aqua>[usr] heals \himself."
		usr.overlays-=image('Heal.dmi')
mob/Spells/verb/Confundus(mob/Player/M in oview()&Players)
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=30,againstocclumens=1))
		hearers()<<"<b><font color=red>[usr]:</b></font> <font color= #7CFC00>Confundus, [M]!"
		usr.MP-=30
		usr.updateHPMP()
		sleep(1)
		if(M.confused>0)
			M.confused = 20
			M << "<font color = #A2A4A4><small>You feel more confused...</small></font>"
		else
			M.confused = 20
			M << "<font color = #A2A4A4><small>You feel confused...</small></font>"
			src = null
			spawn()
				while(M.confused>0)
					if(M.confused == 1|| M.confused == 0)M << "<font color = #A2A4A4><small>You shake off your confusion.</small></font>"
					M.confused--
					sleep(10)
mob/Spells/verb/Crucio(mob/M in oview()&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedCrucio,needwand=1,inarena=0,insafezone=0,target=M,mpreq=400))
		hearers()<<"<b><font color=red>[usr]:</b></font> <font color= #7CFC00>Crucio!"
		new /StatusEffect/UsedCrucio(src,15)
		//var/obj/S=new/obj/Crucio  //MAIN CRUCIO
		M.overlays+=image(icon='attacks.dmi',icon_state="kill")
		usr.MP-=400
		usr.updateHPMP()
		sleep(1)
		hearers()<<"[M] cringes in Pain!"
		M.HP-=500
		M.Death_Check()
		sleep(20)
		M.overlays-=image(icon='attacks.dmi',icon_state="kill")
mob/Spells/verb/Flippendo()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=1,target=null,mpreq=10))
		var/obj/S=new/obj/Flippendo
		usr.MP-=10
		usr.updateHPMP()
		S.damage=10
		S.owner = usr
		S.loc=(usr.loc)
		walk(S,usr.dir,2)
		sleep(20)
		del S
mob/Spells/verb/Wingardium_Leviosa()
	set category="Spells"
	if(!Wingardiumleviosa)
		if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,target=null,mpreq=0))
			var/obj/other=input("What do you wish to levitate?") as null|obj in oview()
			if(isnull(other))return
			if(other.wlable == 1)
				Wingardiumleviosa = 1
				wingobject=other
				hearers(client.view)<<"<B>[usr.name]: <I>Wingardium Leviosa.</I>"
				other.overlays += new /obj/overlay/flash

				src=null
				spawn()
					var/seconds = 60
					while(other && usr && usr.Wingardiumleviosa && seconds > 0)
						seconds--
						sleep(10)
					if(usr)
						usr.wingobject=null
						usr.Wingardiumleviosa = null
					if(other)
						other.overlays=null
			else
				src << errormsg("That object is not movable.")
	else
		src << infomsg("You let go of the object you were holding.")
		wingobject.overlays = null
		wingobject=null
		Wingardiumleviosa = null

mob/Spells/verb/Imperio(mob/other in oview()&Players)
	set category="Spells"
	if(!Imperio)

		if(!other.Imperio)
			usr.Wingardiumleviosa = 1
			usr.wingobject=other
			Imperio = 1
			hearers(usr.client.view,usr)<<"<B>[usr.name]:<font color=red> Imperio!"
			usr.client.eye=other
			usr.client.perspective=EYE_PERSPECTIVE
			spawn(600)
				if(Imperio)
					usr.wingobject=null
					other.overlays=null
					if(other.away)other.ApplyAFKOverlay()
					usr.Wingardiumleviosa = null
					usr<< "You release possesion of the person you were controlling."
					usr.client.eye=usr
					usr.client.perspective=MOB_PERSPECTIVE
		else
			usr << errormsg("You can not control [other] because his mind is elsewhere.")
	else
		Imperio = 0
		usr.wingobject=null
		usr.Wingardiumleviosa = null
		usr<< "You release possesion of the person you were controlling."
		usr.client.eye=usr
		usr.client.perspective=MOB_PERSPECTIVE
mob/Spells/verb/Portus()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=25))
		switch(input("Create a PortKey to Where?","Portus Charm")as null|anything in list("Hogsmeade","Pixie Pit","The Dark Forest Entrance"))
			if("Hogsmeade")
				if(src.loc.density)
					src << errormsg("Portus can't be used on top of something else.")
					return
				for(var/atom/A in src.loc)
					if(A.density && !ismob(A))
						src << errormsg("Portus can't be used on top of something else.")
						return
				if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=25))
					var/obj/portkey/P1 = new(src.loc)
					var/obj/portkey/P2 = new(locate(39,53,18))
					P1.partner = P2
					P2.partner = P1
			if("Pixie Pit")
				if(src.loc.density)
					src << errormsg("Portus can't be used on top of something else.")
					return
				for(var/atom/A in src.loc)
					if(A.density && !ismob(A))
						src << errormsg("Portus can't be used on top of something else.")
						return
				if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=25))
					var/obj/portkey/P1 = new(src.loc)
					var/obj/portkey/P2 = new(locate(86,26,15))
					P1.partner = P2
					P2.partner = P1
			if("The Dark Forest Entrance")
				if(src.loc.density)
					src << errormsg("Portus can't be used on top of something else.")
					return
				for(var/atom/A in src.loc)
					if(A.density && !ismob(A))
						src << errormsg("Portus can't be used on top of something else.")
						return
				if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=25))
					var/obj/portkey/P1 = new(src.loc)
					var/obj/portkey/P2 = new(locate(13,22,15))
					P1.partner = P2
					P2.partner = P1
			if(null)
				return
		new /StatusEffect/UsedPortus(src,30)
		hearers()<<"[usr]: <font color=aqua><font size=2>Portus!</font>"
		hearers()<<"A PortKey flys out of [usr]'s wand, and opens."
		usr.MP-=25
		usr.updateHPMP()
mob/Spells/verb/Sense(mob/M in view()&Players)
	set category = "Spells"
	hearers() << "[usr]'s eyes flicker."
	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=0))
		usr<<errormsg("[M.name]'s Kills: [M.pkills]<br>[M.name]'s Deaths: [M.pdeaths]")
mob/Spells/verb/Scan(mob/M in view()&Players)
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=0))
		hearers() << "[usr]'s eyes glint."
		if((usr.Dmg+usr.extraDmg)>=1000)
			usr<<"\n<b>[M.name]'s Max HP:</b> [M.MHP+M.extraMHP] - <b>Current HP:</b> [M.HP]<br><b>[M.name]'s Max MP:</b> [M.MMP+M.extraMMP] - <b>Current MP:</b> [M.MP]"
		else
			usr<<"\n<b>[M.name]'s Max HP:</b> [M.MHP+M.extraMHP]<br><b>[M.name]'s Max MP:</b> [M.MMP+M.extraMMP]"
mob/var/Zitt

var/safemode = 1
mob/var/tmp/lastproj = 0
mob
	proc/castproj(MPreq,icon,icon_state,damage,name,cd=1)
		if(cd && (world.time - lastproj) < 2) return
		lastproj = world.time
		var/obj/projectile/P = new(src.loc,src.dir,src,icon,icon_state,damage,name)
		P.shoot()
		if(client)
			//Used in fire bats and fire golems as well
			src.MP -= MPreq
			src.updateHPMP()

obj
	projectile
		layer = 4
		density = 1
		SteppedOn(atom/movable/A)
			//world << "[src] stepped on [A]"
			//			projectile stood on candle
			if(ismob(A))
				if(!A.density && (A:key || istype(A,/mob/NPC/Enemies)))
					src.Bump(A)
			else if(isobj(A))
				if(istype(A,/obj/portkey))
					A:HP--
					owner << "You hit the [A.name]."
					if(A:HP < 1)
						hearers(A:partner) << infomsg("The port key has been destroyed from the other end.")
						del(A:partner)
						hearers(A) << infomsg("The port key has been destroyed.")
						del(A)
					del(src)
		New(loc,dir,mob/mob,icon,icon_state,damage,name)
			src.dir = dir
			src.icon = icon
			src.icon_state = icon_state
			src.damage = damage
			src.owner = mob
			src.name = "\proper [name]"
			//..()
			spawn(20)
				walk(src,0)
				src.loc = null
			//src = null
		proc
			shoot()
				walk(src,dir,2)
				//sleep(20)
				//src.loc = null
		var/player=0
		Bump(mob/M)
			if(istype(M.loc, /turf/nofirezone)) return
			if(!loc || oldduelmode||istype(loc.loc,/area/hogwarts/Duel_Arenas/Main_Arena_Bottom))if(!istype(M, /mob)) return
			if(istype(M, /obj/stone) || istype(M, /obj/redroses) || istype(M, /mob/Madame_Pomfrey) || istype(M,/obj/egg) || istype(M,/obj/clanpillar))
				for(var/atom/movable/O in M.loc)
					if(O == M)continue
					if(ismob(O))
						src.Bump(O)
					else if(istype(O,/obj/portkey))
						src.SteppedOn(O)
					else if(istype(O,/obj/clanpillar))
						src.SteppedOn(O)
				if(istype(M,/obj/egg))
					var/obj/egg/E = M
					E.Hit()
				else if(istype(M, /obj/clanpillar))
					var/obj/clanpillar/C = M
					if(1)
						switch(C.clan)
							if("Auror")
								if(src.owner.derobe)
									C.HP -= 1
									flick("Auror-V",C)
									C.Death_Check(src.owner)
							if("Deatheater")
								if(src.owner.aurorrobe)
									C.HP -= 1
									flick("Deatheater-V",C)
									C.Death_Check(src.owner)
							if("Gryff")
								if(src.owner.House!="Gryffindor")
									C.HP -= 1
									flick("Gryff-V",C)
									C.Death_Check(src.owner)
							if("Slyth")
								if(src.owner.House!="Slytherin")
									C.HP -= 1
									flick("Slyth-V",C)
									C.Death_Check(src.owner)
							if("Raven")
								if(src.owner.House!="Ravenclaw")
									C.HP -= 1
									flick("Raven-V",C)
									C.Death_Check(src.owner)
							if("Huffle")
								if(src.owner.House!="Hufflepuff")
									C.HP -= 1
									flick("Huffle-V",C)
									C.Death_Check(src.owner)
					walk(src,0)
					src.loc = null
			else if(istype(M,/obj/brick2door))
				var/obj/brick2door/D = M
				D.Take_Hit(owner)
			else
				var/turf/L = isturf(M.loc) ? M.loc : M
				for(var/mob/A in L)
					if(A.invisibility == 2) continue
					if(damage)
						if(A.monster)
							if(src.owner && src.owner.MonsterMessages)
								src.owner<<"Your [src] does [src.damage] damage to [A]."
						else
							if(owner.monster)
								A << "[owner] hit you for [damage] with their [src]."
							else
								src.owner<<"Your [src] does [src.damage] damage to [A]."

					if(A.shielded)
						var/tmpdmg = A.shieldamount - src.damage
						if(tmpdmg < 0)
							A.HP += tmpdmg
							A << "You are no longer shielded!"
							A.overlays -= /obj/Shield
							A.shielded = 0
							A.shieldamount = 0
						else
							A.shieldamount -= src.damage
					else
						if(!(owner.monster&&A.monster))
							A.HP-=src.damage
							if(src.damage)
								A.Death_Check(src.owner)
			walk(src,0)
			src.loc = null




mob
	GM
		verb
			Toggle_Safemode()
				set category = "Staff"
				if(safemode)
					src << "<b>Players can now use offensive spells in <u>all</u> safezones.</b>"
					safemode = 0
				else
					src << "<b>Players can no longer use offensive spells in <u>all</u> safezones.</b>"
					safemode = 1
			Toggle_Area_Safemode()
				set category = "Staff"
				var/area/A = loc.loc
				if(!A.safezoneoverride)
					src << "<b>Players can now use offensive spells in [loc.loc].</b>"
					A.safezoneoverride = 1
				else
					src << "<b>Players can no longer use offensive spells in [loc.loc].</b>"
					A.safezoneoverride = 0

obj/circle
	icon = 'circle1.dmi'
	icon_state = "1_1"
	name = ""
	mouse_opacity = 0

	var/xoffset = 0
	var/yoffset = 0
	var/owner1
	var/owner2
	c1_1
		icon_state = "1_1"
		xoffset = -2
		yoffset = -2
	c2_1
		icon_state = "2_1"
		xoffset = -1
		yoffset = -2
	c3_1
		icon_state = "3_1"
		yoffset = -2
	c4_1
		icon_state = "4_1"
		xoffset = 1
		yoffset = -2
	c5_1
		icon_state = "5_1"
		xoffset = 2
		yoffset = -2

	c1_2
		icon_state = "1_2"
		xoffset = -2
		yoffset = -1
	c2_2
		icon_state = "2_2"
		xoffset = -1
		yoffset = -1
	c3_2
		icon_state = "3_2"
		yoffset = -1
	c4_2
		icon_state = "4_2"
		xoffset = 1
		yoffset = -1
	c5_2
		icon_state = "5_2"
		xoffset = 2
		yoffset = -1

	c1_3
		icon_state = "1_3"
		xoffset = -2
	c2_3
		icon_state = "2_3"
		xoffset = -1
	c3_3
		icon_state = "3_3"
	c4_3
		icon_state = "4_3"
		xoffset = 1
	c5_3
		icon_state = "5_3"
		xoffset = 2

	c1_4
		icon_state = "1_4"
		xoffset = -2
		yoffset = 1
	c2_4
		icon_state = "2_4"
		xoffset = -1
		yoffset = 1
	c3_4
		icon_state = "3_4"
		yoffset = 1
	c4_4
		icon_state = "4_4"
		xoffset = 1
		yoffset = 1
	c5_4
		icon_state = "5_4"
		xoffset = 2
		yoffset = 1

	c1_5
		icon_state = "1_5"
		xoffset = -2
		yoffset = 2
	c2_5
		icon_state = "2_5"
		xoffset = -1
		yoffset = 2
	c3_5
		icon_state = "3_5"
		yoffset = 2
	c4_5
		icon_state = "4_5"
		xoffset = 1
		yoffset = 2
	c5_5
		icon_state = "5_5"
		xoffset = 2
		yoffset = 2

mob/var/tmp/mob/arcessoing = 0

mob/var/tmp/silence
mob/var/tmp/muff

mob/Player/proc/OcclumensCounter()
	while(occlumens > 0)
		sleep(10)
		occlumens --
	src << "Your Occlumency has worn off."
	occlumens = 0
mob/var/occlumens = 0
mob/var/dance=0

mob/var/Immobile=0
mob/var/IImmobile=0
obj/Vanishing_Cabnet
	icon='blue2.dmi'
	icon_state="portkey"
	verb
		Open()
			set src in oview(1)
			step_towards(usr,src)
			sleep(10)
			if(usr.followplayer==1){alert("You cannot use the vanishing cabnet while following a player.");return}
			if(usr.removeoMob) spawn()usr:Permoveo()
			hearers() << "[usr] walks into the cabnet and disappears."


obj/Port_Key
	icon='blue2.dmi'
	icon_state="portkey"
	verb
		Touch()
			set src in oview(1)
			step_towards(usr,src)
			sleep(10)
			if(usr.followplayer==1){alert("You cannot use a portkey while following a player.");return}
			if(usr.removeoMob) spawn()usr:Permoveo()
			hearers()<<"[usr] touches the portkey and vanishes."
			for(var/obj/hud/player/R in usr.client.screen)
				del(R)
			for(var/obj/hud/cancel/C in usr.client.screen)
				del(C)
			usr.loc=locate(src.lastx,src.lasty,src.lastz)
			step(usr,SOUTH)
			return
	New()
		..()
		spawn(300)
			del(src)
mob/var/tmp/list/stoverlays = list()
proc/overlaylist(var/list/overlays)
	var/list/returnlist = list()
	for(var/X in overlays)
		returnlist.Add(X)
	return returnlist
mob/var/tmp/trnsed = 0
mob
	mouse_drag_pointer = MOUSE_DRAG_POINTER
mob/GM/verb/Remote_View(mob/M in world)
	set category="Staff"
	set popup_menu = 0
	if(M.derobe||M.aurorrobe||M.type == /mob/fakeDE ||istype(M.loc.loc, /area/ministry_of_magic||istype(M.loc.loc, /area/blindness))){src<<"<b>You cannot use remote view on this person.";return}
	usr.client.eye=M
	usr.client.perspective=EYE_PERSPECTIVE
	hearers()<<"[usr] sends \his view elsewhere."
mob/GM/verb/HM_Remote_View(mob/M in world)
	set category="Staff"
	set popup_menu = 0
	usr.client.eye=M
	usr.client.perspective=EYE_PERSPECTIVE
mob/GM/verb/Return_View()
	set category="Staff"
	usr.client.eye=usr
	usr.client.perspective=MOB_PERSPECTIVE
	usr<<"You return to your body."
mob/var/tmp/episkying = 0
mob/var/tmp/meditating = 0
mob/var/tmp/confused = 0
obj/var
	wlable = 0
mob
	var
		tmp/obj/wingobject
		tmp/Wingardiumleviosa
mob/Player
	Move(loc,dir)
		if(wingobject)
			var/turf/t = get_step(wingobject,dir)
			if(istype(wingobject.loc,/mob))
				src << infomsg("You let go of the object you were holding.")
				wingobject.overlays = null
				wingobject=null
				Wingardiumleviosa = null
			else if(t && (t in view(client.view)))
				wingobject.Move(t)
			return
		if(src.questionius==1)
			src.overlays-=icon('hand.dmi')
			src.questionius=0
		if(removeoMob)
			step(removeoMob,dir)
			return
		..()

client
	var/tmp/moving = 0
	Move(loc,dir)
		if(moving) return
		moving = 1

		if(mob.confused && dir)
			dir = turn(dir,180)
			loc = get_step(mob, dir)

		if(src.mob.away)
			src.mob.away = 0
			src.mob.status=usr.here
			src.mob.overlays-=image('AFK.dmi',icon_state="GM")
			src.mob.overlays-=image('AFK.dmi',icon_state="AFK2")
			src.mob.overlays-='AFK.dmi'
		..()
		sleep(0)
		moving = 0


obj/var
	controllable = 0
mob/var/Imperio = 0
mob/GM
	var
		controlobject
obj/overlay
	flash
		icon = 'flash.dmi'
		icon_state = "flash"
		layer = MOB_LAYER


obj/portkey
	var/obj/portkey/partner
	var/HP = 15
	icon='blue2.dmi'
	icon_state="portkey"
	New()
		..()
		switch(rand(1,3))
			if(1)
				icon='cau.dmi'
				icon_state="bucket"
			if(2)
				icon='misc.dmi'
				icon_state="beer"
			if(3)
				icon = 'scrolls.dmi'
				icon_state = "blank"
			if(4)
				icon = 'turfZ.dmi'
				icon_state="candle"
		spawn(300)
			view(src) << "The portkey collapses and closes."
			del(src)
	proc/Teleport(mob/Player/M)
		if(M.Transfer(partner.loc))
			M << "You step through the portkey."
			..()

mob/Player
	var/tmp/teleporting = 0

	proc/Transfer(turf/t)
		if(teleporting) return 0
		teleporting = 1

		var/tmp_dir = dir
		var/dense = density
		density = 0
		Move(t)
		if(!density)
			density = dense
		dir = tmp_dir
		teleporting = 0

		return 1
