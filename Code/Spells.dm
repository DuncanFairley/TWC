/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
var/list/spellList = list(
	/mob/Spells/verb/Lumos = "Lumos",
	/mob/Spells/verb/Petreficus_Totalus = "Petrificus Totalus",
	/mob/Spells/verb/Scurries = "Scurries",
	/mob/Spells/verb/Portus = "Portus",
	/mob/Spells/verb/Deletrius = "Deletrius",
	/mob/Spells/verb/Evanesco = "Evanesco",
	/mob/Spells/verb/Serpensortia = "Serpensortia",
	/mob/Spells/verb/Accio = "Accio",
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
	/mob/Spells/verb/Ribbitous = "Ribbitous",
	/mob/Spells/verb/Avis = "Avis",
	/mob/Spells/verb/Reducto = "Reducto",
	/mob/Spells/verb/Glacius = "Glacius",
	/mob/Spells/verb/Confundus = "Confundus",
	/mob/Spells/verb/Self_To_Skeleton = "Personio Sceletus",
	/mob/Spells/verb/Self_To_Mushroom = "Personio Musashi",
	/mob/Spells/verb/Anapneo = "Anapneo",
	/mob/Spells/verb/Aqua_Eructo = "Aqua Eructo",
	/mob/Spells/verb/Self_To_Human = "Personio Humaium",
	/mob/Spells/verb/Other_To_Human = "Transfiguro Revertio",
	/mob/Spells/verb/Depulso = "Depulso",
	/mob/Spells/verb/Occlumency = "Occlumency",
	/mob/Spells/verb/Flagrate = "Flagrate",
	/mob/Spells/verb/Incendio = "Incendio",
	/mob/Spells/verb/Imitatus = "Imitatus",
	/mob/Spells/verb/Felinious = "Felinious",
	/mob/Spells/verb/Permoveo = "Permoveo",
	/mob/Spells/verb/Reddikulus = "Riddikulus",
	/mob/Spells/verb/Replacio = "Replacio",
	/mob/Spells/verb/Incarcerous = "Incarcerous",
	/mob/Spells/verb/Peskipixie_Pesternomae = "Peskipiksi Pestermi",
	/mob/Spells/verb/Obliviate = "Obliviate",
	/mob/Spells/verb/Avifors = "Avifors",
	/mob/Spells/verb/Ferula = "Ferula",
	/mob/Spells/verb/Waddiwasi = "Waddiwasi",
	/mob/Spells/verb/Tarantallegra = "Tarantallegra",
	/mob/Spells/verb/Sense = "Sense",
	/mob/Spells/verb/Nightus = "Nightus",
	/mob/Spells/verb/Harvesto = "Harvesto",
	/mob/Spells/verb/Scan = "Scan",
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
		if(!M.accioable){src<<"<b><span style=\"color:red;\">Error:</b></span> This object cannot be teleported.";return}
		hearers(usr.client.view,usr)<< " <b>[usr]:<i><font color=aqua> Accio [M.name]!</i>"
		sleep(3)
		flick('Dissapear.dmi',M)
		sleep(20)
		if(M in oview(usr.client.view,usr))
			usr:learnSpell("Accio")
			M.x = src:x
			M.y = src:y-1
			M.z = src:z
			flick('Appear.dmi',M)
			if(istype(M,/obj/candle)) M:respawn()
		else
			usr << "The object is no longer in your view."

mob/Spells/verb/Eat_Slugs(var/n as text)
	set category = "Spells"
	set hidden = 1
	if(IsInputOpen(src, "Eat Slugs"))
		del _input["Eat Slugs"]
	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=100,againstocclumens=1))
		var/list/people = ohearers(client.view)&Players
		var/mob/M

		if(n)
			for(var/mob/Player/p in people)
				if(findtext(n, p.name) && length(p.name) + 2 >= length(n))
					M = p
					break
		if(!M && people.len)
			var/Input/popup = new (src, "Eat Slugs")
			M = popup.InputList(src, "Cast this curse on?", "Eat Slugs", people[1], people)
			del popup
		if(!M) return
		if(!(M in ohearers(client.view))) return
		new /StatusEffect/Summoned(src,15)
		MP = max(MP - 100, 0)
		updateHPMP()
		if(prevname)
			hearers() << "<span style=\"font-size:2;\"><font color=red><b><font color=red>[usr]</span></b> :<font color=white> Eat Slugs, [M.name]!"
		else
			hearers() << "<span style=\"font-size:2;\"><font color=red><b>[Tag]<font color=red>[usr]</span> [GMTag]</b>:<font color=white> Eat Slugs, [M.name]!"

		M << errormsg("[usr] has casted the slug vomiting curse on you.")
		usr:learnSpell("Eat Slugs")
		src=null
		spawn()
			var/slugs = rand(4,12)
			while(M && slugs > 0 && M.MP > 0)
				M.MP -= rand(20,60) * round(M.level/100)
				new/mob/Slug(M.loc)
				if(M.MP < 0)
					M.MP = 0
					M.updateHPMP()
					M << errormsg("You feel drained from the slug vomiting curse.")
					break
				else
					M.updateHPMP()
				slugs--
				sleep(rand(20,90))
		return TRUE

mob/Spells/verb/Disperse()
	set category = "Spells"
	set hidden = 1

	if(canUse(src,cooldown=/StatusEffect/UsedDisperse,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/UsedDisperse(src,10)
		usr:learnSpell("Disperse")
		for(var/obj/smokeeffect/S in oview(client.view))
			del(S)
		for(var/turf/T in oview())
			if(T.specialtype == "Swamp")
				T.slow -= 5
				T.specialtype = null
				T.overlays += image('mist.dmi',layer=10)
				spawn(9)
					T.overlays = null


		var/obj/The_Dark_Mark/dm = locate() in oview(5, src)

		if(dm)
			dm.counter(src)
			movable = 1
			var/mob/Player/p = src
			p << errormsg("Dispersing the dark mark took a bit of effort, you stand still for a bit.")
			spawn(15)
				if(p) p.movable = 0
		src = null

mob/Spells/verb/Herbificus()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,antiTeleport=1))
		var/obj/redroses/p = new
		p:loc = locate(src.x,src.y-1,src.z)
		flick('dlo.dmi',p)
		p:owner = "[usr.key]"
		if(!findStatusEffect(/StatusEffect/SpellText))
			new /StatusEffect/SpellText(src,5)
			hearers()<<"<b><span style=\"color:red;\">[usr]:</span> Herbificus."
			usr:learnSpell("Herbificus")
mob/Spells/verb/Protego()
	set category = "Spells"
	if(!usr.shielded)
		if(canUse(src,cooldown=/StatusEffect/UsedProtego,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
			new /StatusEffect/UsedProtego(src,60)
			usr.overlays += /obj/Shield
			hearers()<< "<b><span style=\"color:red;\">[usr]</b></span>: PROTEGO!"
			usr << "You shield yourself magically"
			usr.shielded = 1
			usr.shieldamount = (usr.Def+usr.extraDef) * 2.5
			usr:learnSpell("Protego")
			sleep(100)
			if(usr.shielded==1)
				usr.shielded = 0
				usr.shieldamount = 0
				usr.overlays -= /obj/Shield
				usr<<"You are no longer shielded!"
			else return
	else
		if(shielded)
			usr.shielded = 0
			usr.shieldamount = 0
			usr << "You are no longer shielded!"
		usr.overlays -= /obj/Shield
mob/Spells/verb/Valorus(mob/Player/M in view()&Players)
	set category="Spells"
	var/mob/Player/user = usr
	if(locate(/obj/items/wearable/wands) in user.Lwearing)
		M.followplayer=0
		hearers() << "[usr] flicks \his wand towards [M]"
		usr:learnSpell("Valorus")
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
	var/found = FALSE
	for(M in get_step(usr,usr.dir))
		if(!M.key && !istype(M,/mob/Victims)) return

		if(!M.findStatusEffect(/StatusEffect/Potions/Stone))
			var/turf/t = get_step_away(M,usr,15)
			if(!t || (issafezone(M.loc.loc) && !issafezone(t.loc))) return
			M.Move(t)

		if(!findStatusEffect(/StatusEffect/SpellText))
			new /StatusEffect/SpellText(src,5)
			hearers()<<"<b><span style=\"color:red;\">[usr]:</span></b> Depulso!"

		if(isplayer(M))
			found = TRUE
			M<<"You were pushed backwards by [usr]'s Depulso Charm."
			if(M.flying)
				for(var/obj/items/wearable/brooms/B in M:Lwearing)
					B.Equip(M,1)
					hearers()<<"[usr]'s Depulso knocked [M] off \his broom!"
					new /StatusEffect/Knockedfrombroom(M,15)
	if(found)
		usr:learnSpell("Depulso")

mob/Spells/verb/Deletrius()
	set category="Spells"
	var/mob/Player/user = usr
	if(locate(/obj/items/wearable/wands) in user.Lwearing)
		usr:learnSpell("Deletrius")
		for(var/obj/redroses/S in oview(usr.client.view,usr))
			if(!S.GM_Made || (S.GM_Made && usr.Gm))
				flick('GMOrb.dmi',S)
				S.Dispose()
		hearers(usr.client.view,usr)<<"[usr] flicks \his wand, causing the roses to dissolve into the air."
	else
		usr << errormsg("This spell requires a wand.")
mob/Spells/verb/Expelliarmus(mob/M in view()&Players)
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1))
		var/obj/items/wearable/wands/W = locate(/obj/items/wearable/wands) in M:Lwearing
		if(W)
			W.Equip(M,1)
			hearers()<<"<span style=\"color:red;\"><b>[usr]</b></span>: <font color=white>Expelliarmus!"
			hearers()<<"<b>[M] loses \his wand.</b>"
			new /StatusEffect/UsedAnnoying(src,15)
			usr:learnSpell("Expelliarmus")
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
		usr:learnSpell("Eparo Evanesca")
		for(var/mob/Player/M in hearers())
			if(M.key&&(M.invisibility==1))
				flick('teleboom.dmi',M)
				M.invisibility = 0
				M.alpha = 255
				var/obj/items/wearable/invisibility_cloak/C = locate(/obj/items/wearable/invisibility_cloak) in M.Lwearing
				if(C)
					C.Equip(M,1)
				else
					M.invisibility=0
					M.sight &= ~SEE_SELF
					M.alpha = 255
				M<<"You have been revealed!"
				new /StatusEffect/Decloaked(M,15)
mob/Spells/verb/Evanesco(mob/M in Players&oview())
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedEvanesco,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
		new /StatusEffect/UsedEvanesco(src,15)
		flick('teleboom.dmi',M)
		M.invisibility=1
		M.sight |= SEE_SELF
		M.alpha = 125
		hearers(usr.client.view,usr)<<"<b><font color=red>[usr]: <font color=blue>Evanesco!"
		M<<"You have been hidden!"
		usr:learnSpell("Evanesco")
mob/Spells/verb/Imitatus(mob/M in view()&Players, T as text)
	set category = "Spells"
	if(src.mute==1){src<<"You cannot cast this spell while muted.";return}
	hearers()<<"</font><span style=\";\">[usr]: Imitatus.</span>"
	hearers() << " <b><span style=\";\">[M]</B> <font color = red>:</span> </font> [html_encode(T)]"
	usr:learnSpell("Imitatus")
mob/Spells/verb/Morsmordre()
	set category = "Clan"
	if(canUse(src,cooldown=/StatusEffect/UsedClanAbilities,inarena=0, insafezone=0, needwand=1))
		var/obj/The_Dark_Mark/D = locate("DarkMark")
		if(D && D.loc)
			src << errormsg("A dark mark already exists in the sky.")
			return

		new /StatusEffect/UsedClanAbilities(src, 300)
		D = new (locate(src.x,src.y+1,src.z))
		D.density=0
		D.owner = ckey
		flick('mist.dmi',D)
		hearers() <<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=green>MORSMORDRE!"
		Players<<"The sky darkens as a sneering skull appears in the clouds with a snake slithering from its mouth."

mob/Spells/verb/Repellium()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedRepel,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=100,againstocclumens=1))
		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=white>Repellium!"
		MP -= 100
		updateHPMP()
		light(src, 3, 300, "light")
		usr:learnSpell("Repellium")
		new /StatusEffect/UsedRepel(src, 90)
		new /StatusEffect/DisableProjectiles(src, 30)
		var/time = 75
		while(time > 0)
			for(var/mob/NPC/Enemies/D in ohearers(3, src))
				step_away(D, src)
			time--
			sleep(4)

proc/light(atom/a, range=3, ticks=100, state = "light")
	var/image/img = image('lights.dmi',state)
	img.transform *= range * 2 + 1
	img.layer = 8

	a.underlays += img
	if(ticks != 0)
		spawn(ticks)
			if(a) a.underlays -= img

mob/Spells/verb/Lumos()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedLumos,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=100,againstocclumens=1))
		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=white>Lumos!"
		MP -= 100
		updateHPMP()

		usr:learnSpell("Lumos")
		new /StatusEffect/UsedLumos(src, 60)

		var/obj/light/l = new(loc)

		animate(l, transform = matrix() * 1.6, time = 10, loop = -1)
		animate(   transform = matrix() * 1.5,   time = 10)

		var/mob/Player/p = src
		p.addFollower(l)

		src = null
		spawn(600)
			if(p && l)
				p.removeFollower(l)
				l.loc = null

mob/Spells/verb/Lumos_Maxima()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedLumos,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=300,againstocclumens=1))
		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=white>Lumos Maxima!"
		MP -= 300
		updateHPMP()

		new /StatusEffect/UsedLumos(src, 90)

		castproj(MPreq = 300, Type = /obj/projectile/Lumos, icon_state = "light", name = "Lumos Maxima", lag = 2)

mob/Spells/verb/Aggravate()
	set category = "Spells"
	if(!loc) return
	if(canUse(src,cooldown=/StatusEffect/UsedAggro,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=150,againstocclumens=1))
		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=white>Aggravate!"
		MP -= 150
		updateHPMP()

		new /StatusEffect/UsedAggro(src, 30)

		var/area/pArea = loc.loc

		for(var/mob/NPC/Enemies/e in ohearers(13))
			var/area/eArea = loc.loc

			if(eArea != pArea) continue
			if(e.state == 0)   continue

			e.state  = e.HOSTILE
			e.target = src


mob/Spells/verb/Basilio()
	set category = "Staff"
	if(clanrobed())return
	hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=green> Basilio!"
	sleep(20)
	hearers()<<"[usr]'s wand emits a bright flash of light."
	sleep(20)
	if(!src.loc.loc:safezoneoverride && (istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/hogwarts/Duel_Arenas) || istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/Diagon_Alley)))
		src << "<b>You can't use this inside a safezone.</b>"
		return
	hearers()<<"A Black Basilisk, emerges from [usr]'s wand."
	hearers()<<"<b>Basilisk</b>: Hissssssss!"
	var/mob/NPC/Enemies/Summoned/Boss/Basilisk/D = new (locate(src.x,src.y-1,src.z))
	flick('mist.dmi',D)

mob/Spells/verb/Serpensortia()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=0,inhogwarts=0,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/Summoned(src,15)
		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=green> Serpensortia!"
		sleep(20)
		hearers()<<"[usr]'s wand emits a bright flash of light."
		sleep(20)
		if(!src.loc.loc:safezoneoverride && (istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/hogwarts/Duel_Arenas) || istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/Diagon_Alley)))
			src << "<b>You can't use this inside a safezone.</b>"
			return
		hearers()<<"A Red-Spotted Green Snake, emerges from the wand."
		hearers()<<"<b>Snake</b>: Hissssssss!"
		var/mob/NPC/Enemies/Summoned/Snake/D = new (loc)
		D.Ignore(src)
		flick('mist.dmi',D)
		usr:learnSpell("Serpensortia")
		src = null
		spawn(600)
			flick('mist.dmi',D)
			if(D)
				view(D)<<"The snake disappears."
				Respawn(D)
mob/Spells/verb/Herbificus_Maxima()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,antiTeleport=1))
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
		if(!findStatusEffect(/StatusEffect/SpellText))
			new /StatusEffect/SpellText(src,5)
			hearers()<<"<b><span style=\"color:red;\">[usr]:</span> Herbificus MAXIMA!"
mob/Spells/verb/Shelleh()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedShelleh,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=50,againstocclumens=1))
		new /StatusEffect/UsedShelleh(src,60)
		hearers()<<"<b><span style=\"color:red;\">[usr]:</span> <font color=white>Shelleh."

		for(var/turf/t in oview(rand(1,3)))
			if(t.density) continue
			if(prob(40))  continue
			if(t == loc)  continue
			new /obj/egg (t)
			sleep(1)

mob/Spells/verb/Ferula()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedFerula,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/UsedFerula(src, 60)
		var/obj/Madame_Pomfrey/p = new /obj/Madame_Pomfrey
		p:loc = locate(src.x,src.y+1,src.z)
		flick('teleboom.dmi',p)
		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=aqua> Ferula!"
		hearers()<<"[usr] has summoned Madame Pomfrey!"
		usr:learnSpell("Ferula")

mob/Spells/verb/Avis()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/Summoned(src, 15)
		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=yellow> Avis!"
		sleep(20)
		hearers()<<"A bright white flash shoots out of [usr]'s wand."
		sleep(20)
		hearers()<<"A Phoenix emerges."
		var/mob/NPC/Enemies/Summoned/Phoenix/D = new (loc)
		flick('mist.dmi',D)
		usr:learnSpell("Avis")
		src = null
		spawn(600)
			flick('mist.dmi',D)
			if(D)
				view(D)<<"The Phoenix flies away."
				Respawn(D)
mob/Spells/verb/Crapus_Sticketh()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=0,inhogwarts=0,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/Summoned(src,15)
		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=green> Crapus...Sticketh!!"
		sleep(20)
		hearers()<<"A flash of black light shoots from [usr]'s wand."
		sleep(20)
		if(!src.loc.loc:safezoneoverride && (istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/hogwarts/Duel_Arenas) || istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/Diagon_Alley)))
			src << "<b>You can't use this inside a safezone.</b>"
			return
		hearers()<<"A stick figure appears."
		var/mob/NPC/Enemies/Summoned/Boss/Stickman/D = new (loc)
		flick('mist.dmi',D)
		src = null
		spawn(600)
			flick('mist.dmi',D)
			if(D)
				view(D)<<"The Stickman fades away."
				Respawn(D)
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
			selmonster.ChangeState(selmonster.CONTROLLED)
			selmonster.target = null
			usr:learnSpell("Permoveo")

mob/Spells/verb/Incarcerous()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedStun,needwand=1,inarena=1,insafezone=1,inhogwarts=1,mpreq=50,againstocclumens=1))
		new /StatusEffect/UsedStun(src,15)
		hearers(usr.client.view, usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b> Incarcerous!</b>"

		castproj(MPreq = 50, Type = /obj/projectile/Bind { time = 1 }, icon_state = "bind", name = "Incarcerous", lag = 1)

mob/Spells/verb/Anapneo(var/mob/M in view(usr.client.view,usr)&Players)
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		if(!M.flying == 0){src<<"<b><span style=\"color:red;\">Error:</b></span> You can't cast this spell on someone who is flying.";return}
		hearers()<<"<B><span style=\"color:red;\">[usr]:</span><font color=blue> <I>Anapneo!</I>"
		M.Rictusempra=0
		M.Rictalk=0
		M.silence=0
		M.muff=0
		sleep(20)
		hearers(usr.client.view,usr)<<"[usr] flicks \his wand, clearing the airway of [M]."
		usr:learnSpell("Anapneo")
mob/Spells/verb/Reducto(var/mob/M in (view(usr.client.view,usr)&Players)|src)
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1))
		if(M.flying){src<<"<b><span style=\"color:red;\">Error:</b></span> You can't cast this spell on someone who is flying.";return}
		if(M.GMFrozen){alert("You can't free [M]. They have been frozen by a Game Master.");return}
		hearers(usr.client.view,usr)<<"<B><span style=\"color:red;\">[usr]:</span><font color=white> <I>Reducto!</I>"
		M.movable=0
		if(!M.trnsed) M:ApplyOverlays()
		hearers(usr.client.view,usr)<<"White light emits from [usr]'s wand, freeing [M]."
		flick('Reducto.dmi',M)
		if(!M.trnsed) M.icon_state=""
		usr:learnSpell("Reducto")
mob/Spells/verb/Reparo(obj/M in oview(src.client.view,src))
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		if(!M.rubbleable == 1){src<<"<b><span style=\"color:red;\">Error:</b></span> This object has Protection Charms placed upon it.";return}
		if(M.rubble==1)
			hearers(src.client.view,src) << "[src]: <b>Reparo!</b>"
			M.icon=M.picon
			M.name=M.pname
			M.icon_state=M.piconstate
			M.rubble=0
			usr:learnSpell("Reparo")
mob/Spells/verb/Bombarda(obj/M in oview(src.client.view,src))
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		if(istype(M,/obj/items/wearable/wands/salamander_wand))
			if(M.accioable==1)
				return
			else
				var/mob/Player/p = usr
				if(p.checkQuestProgress("Salamander Drop"))
					hearers(src.client.view,src) << "[src]: <b>Bombarda!</b>"
					usr << "You get some Salamander Drop!"
					new/obj/items/Alyssa/Salamander_Drop(usr)
					M.loc = null
					p.Resort_Stacking_Inv()
				else
					usr << "There's no reason to ruin a perfectly good wand."
		else
			if(!M.rubbleable == 1){src<<"<b><span style=\"color:red;\">Error:</b></span> This object has Protection Charms placed upon it.";return}
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
				usr:learnSpell("Bombarda")
mob/Spells/verb/Petreficus_Totalus()
	set category="Spells"
	set name = "Petrificus Totalus"
	if(canUse(src,cooldown=/StatusEffect/UsedStun,needwand=1,inarena=1,insafezone=1,inhogwarts=1,mpreq=50,againstocclumens=1))
		new /StatusEffect/UsedStun(src,15)
		hearers(usr.client.view, usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b> Petrificus Totalus!</b>"

		castproj(MPreq = 50, Type = /obj/projectile/Bind { min_time = 0.4; max_time = 2.4 }, icon_state = "stone", name = "Petrificus Totalus", lag = 1)

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
		hearers() << "<b><span style=\"color:red;\">[usr]</span></b>: <span style=\"color:white;\"><i>Antifigura!</i></span>"
		p.antifigura = max(round((p.MMP+p.extraMMP) / rand(500,1500)), 1)
		p.MP -= 50
		p.updateHPMP()
		usr:learnSpell("Antifigura")


mob/Spells/verb/Chaotica()
	set category="Spells"
	var/dmg = round(usr.level * 1.1) + round(clothDmg/5)
	if(dmg<20)dmg=20
	else if(dmg>2000)dmg = 2000
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=30,againstocclumens=1,projectile=1))
		castproj(MPreq = 30, icon_state = "chaotica", damage = dmg, name = "Chaotica")
mob/Spells/verb/Aqua_Eructo()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,projectile=1))
		HP -= 45
		Death_Check()

		var/dmg = usr.Def + (usr.extraDef / 3) + (clothDmg / 5)
		dmg *= 0.8

		castproj(icon_state = "aqua", damage = dmg, name = "Aqua Eructo")


mob/Spells/verb/Sanguinis_Iactus()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=5,againstocclumens=1,projectile=1))


		castproj(Type = /obj/projectile/Blood, MPreq = 5, icon_state = "blood", damage = usr.Dmg + usr.extraDmg + clothDmg, name = "Blood")

mob/Spells/verb/Gravitate()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,projectile=1))


		castproj(Type = /obj/projectile/Grav, icon_state = "grav", name = "Gravitate")

mob/Spells/verb/Inflamari()
	set category="Spells"
	var/dmg = usr.level * 0.9 + clothDmg

	if(usr.level < 200)
		dmg *= 1 + (200 - usr.level)/100

	if(dmg <= 10)
		dmg = 10 + rand(1,5)
	else if(dmg > 1000)
		dmg = 1000
	else
		dmg = round(dmg, 1)

	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,projectile=1))
		castproj(icon_state = "fireball", damage = dmg, name = "Inflamari")
mob/Spells/verb/Glacius()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=10,againstocclumens=1,projectile=1))
		castproj(MPreq = 10, icon_state = "iceball", damage = usr.Dmg+usr.extraDmg + clothDmg, name = "Glacius")
mob/Spells/verb/Waddiwasi()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=10,againstocclumens=1,projectile=1))
		castproj(MPreq = 10, icon_state = "gum", damage = usr.Dmg+usr.extraDmg + clothDmg, name = "Waddiwasi")
mob/Spells/verb/Tremorio()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=5,againstocclumens=1,projectile=1))
		castproj(MPreq = 5, icon_state = "quake", damage = usr.Dmg+usr.extraDmg + clothDmg, name = "Tremorio")

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

	else if(canUse(src,cooldown=/StatusEffect/UsedArcesso,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=400,againstocclumens=1,antiTeleport=1))
		var/list/obj/circles = list(new/obj/circle/c1_1,new/obj/circle/c2_1,new/obj/circle/c3_1,new/obj/circle/c4_1,new/obj/circle/c5_1,
									new/obj/circle/c1_2,new/obj/circle/c2_2,new/obj/circle/c3_2,new/obj/circle/c4_2,new/obj/circle/c5_2,
									new/obj/circle/c1_3,new/obj/circle/c2_3,new/obj/circle/c3_3,new/obj/circle/c4_3,new/obj/circle/c5_3,
									new/obj/circle/c1_4,new/obj/circle/c2_4,new/obj/circle/c3_4,new/obj/circle/c4_4,new/obj/circle/c5_4,
									new/obj/circle/c1_5,new/obj/circle/c2_5,new/obj/circle/c3_5,new/obj/circle/c4_5,new/obj/circle/c5_5)

		var/turf/middle = get_step(src,dir)
		var/turf/opposite = get_step(middle,dir)
		for(var/mob/Player/M in opposite)
			if(istype(M,/mob/Player) && M.arcessoing && M.dir == turn(dir, 180))
				src.arcessoing = M
				break
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

									arcessoing:learnSpell("Arcesso")
									arcessoing.arcessoing:learnSpell("Arcesso")

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
				hearers(client.view)<<"<span style=\"color:red;\"><b>[usr]:</span> Flagrate!"
				sleep(10)
				hearers(client.view)<<"<span style=\"color:red;\"><b>[usr]:</span> <span style=\"color:#FF9933;\"><font size=3><font face='Comic Sans MS'> [html_encode(message)]</span>"
				usr.MP-=300
				usr.updateHPMP()
				usr:learnSpell("Flagrate")
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
			usr:learnSpell("Langlock")
			src = null
			spawn(300)
				if(M && M.silence)
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
			usr:learnSpell("Muffliato")
			src = null
			spawn(300)
				if(M.muff)
					if(caster)
						view(caster,3)<<"[caster]'s Muffliato Charm has lifted."
				M.muff=0
mob/Spells/verb/Incindia()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedIncindia,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=450,againstocclumens=1,projectile=1))
		hearers()<<"[src] raises \his wand into the air. <font color=red><b><i>INCINDIA!</b></i>"
		usr.MP-=450
		usr.updateHPMP()
		new /StatusEffect/UsedIncindia(src,15)
		var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		var/damage = round((Dmg + extraDmg + clothDmg) * 0.75)
		var/t = dir
		usr:learnSpell("Incindia")
		for(var/d in dirs)
			dir = d
			castproj(icon_state = "fireball", damage = damage, name = "incindia", cd = 0, lag = 1)
		dir = t
mob/Spells/verb/Replacio(mob/M in oview()&Players)
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=500,againstocclumens=1))
		if(issafezone(M.loc.loc) && !issafezone(loc.loc))
			src << "<b>[M] is inside a safezone.</b>"
			return
		hearers()<<"<b><span style=\"color:red;\">[usr]:</b></span> <font color=blue><B> <i>Replacio Duo.</i></B>"
		var/startloc = usr.loc
		flick('GMOrb.dmi',M)
		flick('GMOrb.dmi',usr)
		usr:Transfer(M.loc)
		M:Transfer(startloc)
		flick('GMOrb.dmi',usr)
		flick('GMOrb.dmi',M)
		hearers()<<"[usr] trades places with [M]"
		usr.MP-=500
		usr.updateHPMP()
		usr:learnSpell("Replacio")
mob/Spells/verb/Occlumency()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=1,againstocclumens=1))
		if(!usr.occlumens)
			for(var/client/C)
				if(C.eye)
					if(C.eye == usr && C.mob != usr)
						C << errormsg("Your Telendevour wears off.")
						C.eye=C.mob
			hearers() << "<b><span style=\"color:red;\">[usr]</span></b>: <span style=\"color:white;\"><i>Occlumens!</i></span>"
			usr << "You can no longer be viewed by Telendevour."
			usr.occlumens = usr.MMP+usr.extraMMP
			usr:OcclumensCounter()
			usr:learnSpell("Occlumency")
		else
			src << "You release the barriers around your mind."
			usr.occlumens = 0

mob/Spells/verb/Obliviate(mob/M in oview()&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=700,againstocclumens=0))
		hearers()<<"<b><span style=\"color:red;\">[usr]:<font color=green> Obliviate!</b></span>"
		if(prob(15))
			usr << output(null,"output")
			hearers()<<"[usr]'s spell has backfired."
			if(prob(70)) usr:learnSpell("Obliviate", -1)
		else
			M << output(null,"output")
			hearers()<<"[usr] wiped [M]'s memory!"
			usr:learnSpell("Obliviate")
		usr.MP-=700
		new /StatusEffect/UsedAnnoying(src,30)
		usr.updateHPMP()
mob/Spells/verb/Tarantallegra(mob/M in view()&Players)
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=100,againstocclumens=1))
		if(M.dance) return
		hearers()<<"<b>[usr]:</B><font color=green> <i>Tarantallegra!</i>"
		new /StatusEffect/UsedAnnoying(src,15)
		usr.MP-=100
		usr.updateHPMP()
		if(key != "Murrawhip")
			M.dance=1
		usr:learnSpell("Tarantallegra")
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
	if(canUse(src,cooldown=/StatusEffect/UsedImmobulus,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=500,againstocclumens=1))
		var/mob/Player/player = src

		new /StatusEffect/UsedImmobulus(src, 20)
		usr.MP-=500
		usr.updateHPMP()

		hearers()<<"<b>[usr]:</b> <font color=blue>Immobulus!"
		hearers()<<"A sudden wave of energy emits from [usr]'s wand, immobilizing every projectile in sight."

		var/const/RANGE = 6
		var/const/TICKS = 60
		var/const/STEP  = 3

		var/obj/o = new(loc)
		o.alpha = 0
		o.layer = 6
		light(o, range=RANGE, ticks=TICKS, state = "rand")

		if(player.wand && player.wand.projColor)
			o.color = player.wand.projColor

		animate(o, alpha = 255, time = 10)

		for(var/time = 0 to TICKS step STEP)
			for(var/obj/projectile/p in oview(RANGE, o))
				if(p.overlays.len)	continue

				p.overlays += image('attacks.dmi', icon_state = "immobulus")
				p.velocity = 0
				walk(p, 0)

			sleep(STEP)

		o.Dispose()

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
			T.slow += 1
		usr:learnSpell("Impedimenta")
		src = null
		spawn(100)
			for(var/turf/T in lt)
				T.overlays -= image('black50.dmi',"impedimenta")
				if(T.slow >= 1)
					T.slow -= 1
mob/Spells/verb/Incendio()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=20,againstocclumens=1))
		castproj(Type = /obj/projectile/BurnRoses, MPreq = 10, icon_state = "fireball", name = "Incendio")

mob/proc/BaseIcon()
	if(Gender == "Female")
		if(Gm)
			icon = 'FemaleStaff.dmi'
		else if(House == "Gryffindor")
			icon = 'FemaleGryffindor.dmi'
		else if(House == "Ravenclaw")
			icon = 'FemaleRavenclaw.dmi'
		else if(House == "Slytherin")
			icon = 'FemaleSlytherin.dmi'
		else if(House == "Hufflepuff")
			icon = 'FemaleHufflepuff.dmi'
	else
		if(Gm)
			icon = 'MaleStaff.dmi'
		else if(House == "Gryffindor")
			icon = 'MaleGryffindor.dmi'
		else if(House == "Ravenclaw")
			icon = 'MaleRavenclaw.dmi'
		else if(House == "Slytherin")
			icon = 'MaleSlytherin.dmi'
		else if(House == "Hufflepuff")
			icon = 'MaleHufflepuff.dmi'

mob/Spells/verb/Reddikulus(mob/M in view()&Players)
	set category="Spells"
	set name = "Riddikulus"
	if(canUse(src,cooldown=/StatusEffect/UsedRiddikulus,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=100,againstocclumens=1))
		if(M.trnsed == 1)
			usr << "That person is already transfigured."
			return
		if(!M) return
		new /StatusEffect/UsedRiddikulus(src,30)
		hearers()<<"<b><span style=\"color:red;\">[usr]</span>: <span style=\"color:red;\"><font size=3>Riddikulus!</span></font>, [M].</b>"
		sleep(20)
		flick('teleboom.dmi',M)
		M.Gender = M.Gender == "Male" ? "Female" : "Male"
		M.BaseIcon()
		M.Gender = M.Gender == "Male" ? "Female" : "Male"
		usr:learnSpell("Riddikulus")
		src=null
		spawn(1200)
			if(M)
				M << "<b>You turn back to Normal</b>."
				flick('teleboom.dmi',M)
				M.BaseIcon()

mob/Spells/verb/Ecliptica()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		hearers()<<"<b><span style=\"color:red;\">[usr]</span></b>: Ecliptica!"
		light(src, 3, 300, "light")
		var/time = 150
		while(time > 0)
			for(var/mob/Player/M in ohearers(3, src))
				step_away(M, src)
			time--
			sleep(2)
mob/Spells/verb/Delicio()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Delicio!</b>"
		usr:learnSpell("Delicio")

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Delicio", lag = 0)

mob/Spells/verb/Avifors()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><span style=\"color:gray;\">[usr]</span>: <b>Avifors!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Avifors", lag = 0)

mob/Spells/verb/Ribbitous()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b><span style=\"color:green;\"> Ribbitous!</b></span>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Ribbitous", lag = 0)

mob/Spells/verb/Carrotosi()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b><span style=\"color:red;\"> Carrotosi!</b></span>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Carrotosi", lag = 0)

mob/Spells/verb/Self_To_Dragon()
	set name = "Personio Draconum"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,15)
		if(CanTrans(src))
			usr<<"You transformed yourself into a fearsome Dragon!"
			flick("transfigure",src)
			usr.trnsed = 1
			usr.overlays = null
			if(usr.away)usr.ApplyAFKOverlay()
			usr.icon = 'Dragon.dmi'
mob/Spells/verb/Self_To_Mushroom()
	set name = "Personio Musashi"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,15)
		if(CanTrans(src))
			usr<<"You transformed yourself into a Mushroom!"
			flick("transfigure",src)
			usr.overlays = null
			if(usr.away)usr.ApplyAFKOverlay()
			usr.trnsed = 1
			usr:learnSpell("Personio Musashi")
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
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,15)
		if(CanTrans(src))
			usr<<"You transformed yourself into a Skeleton!"
			flick("transfigure",usr)
			usr.trnsed = 1
			usr.overlays = null
			if(usr.away)usr.ApplyAFKOverlay()
			usr.icon = 'Skeleton.dmi'
			usr:learnSpell("Personio Sceletus")
mob/Spells/verb/Other_To_Human(mob/Player/M in oview(usr.client.view,usr)&Players)
	set name = "Transfiguro Revertio"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b><span style=\"color:green;\"> Transfiguro Revertio, [M].</b></span>"
		new /StatusEffect/UsedTransfiguration(src,15)
		if(CanTrans(M))
			flick("transfigure",M)
			M.trnsed = 0
			M.BaseIcon()
			M.ApplyOverlays()
			usr<<"You reversed [M]'s transfiguration."
			M<<"[usr] reversed your transfiguration."
			usr:learnSpell("Transfiguro Revertio")
mob/Spells/verb/Self_To_Human()
	set name = "Personio Humaium"
	set category="Spells"
	var/mob/Player/user = usr
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		if(CanTrans(src))
			flick("transfigure",usr)
			usr.trnsed = 0
			usr.BaseIcon()
			user.ApplyOverlays()
			usr<<"You reversed your transfiguration."
mob/Spells/verb/Harvesto()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b> Harvesto!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Harvesto", lag = 0)

mob/Spells/verb/Felinious()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view, usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b> Felinious!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Felinious", lag = 0)

mob/Spells/verb/Scurries()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view, usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Scurries!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Scurries", lag = 0)

mob/Spells/verb/Seatio()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Seatio!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Seatio", lag = 0)

mob/Spells/verb/Nightus()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Nightus!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Nightus", lag = 0)

mob/Spells/verb/Peskipixie_Pesternomae()
	set category="Spells"
	set name = "Peskipiksi Pestermi"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15)
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Peskipiksi Pestermi!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Peskipiksi Pestermi", lag = 0)

mob/Spells/verb/Telendevour()
	set category="Spells"
	set popup_menu = 0
	if(usr.client.eye == usr)
		if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
			var/mob/M = input("Which person would you like to view?") as null|anything in Players(list(src))
			if(!M) return
			if(usr.client.eye != usr) return
			if(istext(M) || istype(M.loc.loc, /area/blindness) || M.occlumens>0 || istype(M.loc.loc, /area/ministry_of_magic))
				src<<"<b>You feel magic repelling your spell.</b>"
			else
				usr.client.eye = M
				usr.client.perspective = EYE_PERSPECTIVE
				file("Logs/Telenlog.text") << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] telendevoured [M]"
				var/randnum = rand(1,7)
				hearers() << "[usr]:<span style=\"font-size:2;\"><font color=blue><b> Telendevour!</b></span>"
				usr:learnSpell("Telendevour")
				if(randnum == 1)
					M << "You feel that <b>[usr]</b> is watching you."
				else
					M << "The hair on the back of your neck tingles."
	else
		usr.client.eye = usr
		usr.client.perspective = EYE_PERSPECTIVE
		hearers() << "[usr]'s eyes appear again."

//AVADA//

obj/Avada_Kedavra
	icon='attacks.dmi'
	icon_state="avada"
	density=1
	var/player=0
	layer = 4
	Bump(mob/M)
		if(inOldArena())if(!istype(M, /mob)) return
		if(isturf(M)||isobj(M))
			del src
			return
		if(M.monster||M.player)
			src.owner<<"Your [src] hit [M]!"
			M.HP=0
			M.Death_Check(src.owner)
		del src

mob/Spells/verb/Avada_Kedavra()
	set category="Spells"
	if(clanrobed())return
	if(key != "Murrawhip")
		hearers()<<"<b><span style=\"color:red;\">[src]:</b></span> <font color= #00FF33>Avada Kedavra !"
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
		hearers()<<"<span style=\"color:red;\"><b>[usr]:</span></b> <font color=aqua>Episkey!"
		new /StatusEffect/UsedEpiskey(src,15)

		var/maxHP = MHP + extraMHP
		if(level <= 300 || (Immortal && HP < 0))
			HP = maxHP
		else
			HP = min(maxHP, round(HP + maxHP * 0.35 + rand(-15, 15), 1))

		usr.updateHPMP()
		usr.overlays+=image('attacks.dmi', icon_state = "heal")
		sleep(10)
		hearers()<<"<font color=aqua>[usr] heals \himself."
		usr.overlays-=image('attacks.dmi', icon_state = "heal")

mob/Spells/verb/Confundus(mob/Player/M in oview()&Players)
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=300,againstocclumens=1))
		new /StatusEffect/UsedAnnoying(src,20)
		hearers()<<"<b><span style=\"color:red;\">[usr]:</b></span> <font color= #7CFC00>Confundus, [M]!"
		usr.MP-=300
		usr.updateHPMP()
		usr:learnSpell("Confundus")
		M << errormsg("You feel confused...")

		var/matrix/m = M.Interface.mapplane.transform
		m.Turn(90 * rand(-2, 2))
		m.Scale(1.25,1.25)
		animate(M.Interface.mapplane, transform = m, time = 10)

		src=null
		spawn(200)
			if(M)
				animate(M.Interface.mapplane, transform = null, time = 10)

mob/Spells/verb/Flippendo()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=1,target=null,mpreq=10))
		castproj(Type = /obj/projectile/Flippendo, MPreq = 10, icon_state = "flippendo", name = "Flippendo")

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
				usr:learnSpell("Wingardium Leviosa")
				if(istype(other,/obj/candle)) other:respawn()
				src=null
				spawn()
					var/seconds = 60
					while(other && other.loc && usr && usr.Wingardiumleviosa && seconds > 0)
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
					usr<< "You release possession of the person you were controlling."
					usr.client.eye=usr
					usr.client.perspective=MOB_PERSPECTIVE
		else
			usr << errormsg("You can not control [other] because \his mind is elsewhere.")
	else
		Imperio = 0
		usr.wingobject=null
		usr.Wingardiumleviosa = null
		usr<< "You release possession of the person you were controlling."
		usr.client.eye=usr
		usr.client.perspective=MOB_PERSPECTIVE
mob/Spells/verb/Portus()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=25,antiTeleport=1))

		if(IsInputOpen(src, "Portus"))
			del _input["Portus"]

		var/Input/popup = new (src, "Portus")
		var/locations = list("Hogsmeade", "Pixie Pit", "The Dark Forest Entrance")
		var/d = popup.InputList(src, "Create a Portkey to Where?", "Portus Charm", locations[1], locations)
		del popup

		switch(d)
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
		hearers()<<"[usr]: <span style=\"color:aqua;\"><font size=2>Portus!</span>"
		hearers()<<"A portkey flys out of [usr]'s wand, and opens."
		usr.MP-=25
		usr.updateHPMP()
		usr:learnSpell("Portus")
mob/Spells/verb/Sense(mob/M in view()&Players)
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=0))
		hearers() << "[usr]'s eyes flicker."
		usr<<errormsg("[M.name]'s Kills: [M.pkills]<br>[M.name]'s Deaths: [M.pdeaths]")
		usr:learnSpell("Sense")
mob/Spells/verb/Scan(mob/M in view()&Players)
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=0))
		hearers() << "[usr]'s eyes glint."
		if((usr.Dmg+usr.extraDmg)>=1000)
			usr<<"\n<b>[M.name]'s Max HP:</b> [M.MHP+M.extraMHP] - <b>Current HP:</b> [M.HP]<br><b>[M.name]'s Max MP:</b> [M.MMP+M.extraMMP] - <b>Current MP:</b> [M.MP]"
		else
			usr<<"\n<b>[M.name]'s Max HP:</b> [M.MHP+M.extraMHP]<br><b>[M.name]'s Max MP:</b> [M.MMP+M.extraMMP]"
		usr:learnSpell("Scan")
mob/var/Zitt

var/safemode = 1
mob/var/tmp/lastproj = 0
mob
	proc/castproj(Type = /obj/projectile, MPreq = 0, icon = 'attacks.dmi', icon_state = "", damage = 0, name = "projectile", cd = 1, lag = 2)
		if(cd && (world.time - lastproj) < 2 && !inOldArena()) return
		if(!loc) return
		lastproj = world.time

		damage *= loc.loc:dmg
		damage = round(damage)

		var/obj/projectile/P = new Type (src.loc,src.dir,src,icon,icon_state,damage,name)
		P.shoot(lag)
		. = P
		if(client)
			//Used in monsters as well
			src.MP -= MPreq
			src.updateHPMP()

			var/mob/Player/p = src
			if(p.wand)
				p.learnSpell(name)

				if(!P.color && p.wand.projColor)
					if(p.wand.projColor == "blood")
						P.color      = "#16d0d0"
						P.blend_mode = BLEND_SUBTRACT
					else
						P.color = list(p.wand.projColor, p.wand.projColor, p.wand.projColor)

atom/movable/proc
	Attacked(obj/projectile/p)

	Dispose()
		loc = null


obj/portkey
	Dispose()
		partner = null
		..()
	Attacked(obj/projectile/p)
		HP--
		p.owner << "You hit the [name]."
		if(HP < 1)
			hearers(partner) << infomsg("The portkey has been destroyed from the other end.")
			hearers(src)     << infomsg("The portkey has been destroyed.")

			p.Dispose()
			partner.Dispose()
			Dispose()

obj/egg
	Attacked()
		Hit()

obj/enchanter
	Attacked()
		enchant()

obj/clanpillar

	Attacked(obj/projectile/p)
		if(density)
			HP -= 1
			flick("[clan]-V", src)
			Death_Check(p.owner)

obj/brick2door
	Attacked(obj/projectile/p)
		if(density)
			Take_Hit(p.owner)

area/var/friendlyFire = TRUE

mob/Player

	Attacked(obj/projectile/p)
		..()

		if(p.owner)
			if(isplayer(p.owner))

				var/area/a = loc.loc
				if(!a.friendlyFire) return

				p.owner << "Your [p] does [p.damage] damage to [src]."
			else
				src << "[p.owner] hit you for [p.damage] with their [p]."

		if(shielded)
			var/tmpdmg = shieldamount - p.damage
			if(tmpdmg < 0)
				HP += tmpdmg
				src << "You are no longer shielded!"
				overlays    -= /obj/Shield
				shielded     = 0
				shieldamount = 0
				Death_Check(p.owner)
			else
				shieldamount -= p.damage
		else
			HP -= p.damage

			var/n = dir2angle(get_dir(src, p))
			emit(loc    = src,
				 ptype  = /obj/particle/fluid/blood,
			     amount = 5,
			     angle  = new /Random(n - 25, n + 25),
			     speed  = 2,
			     life   = new /Random(15,25))

			if(isplayer(p.owner))
				var/tmp_pkills = p.owner.pkills
				Death_Check(p.owner)

				if(p.owner.pkills > tmp_pkills)
					p.owner:learnSpell(p.name, 100)
			else
				Death_Check(p.owner)

			return src



mob/NPC/Enemies
	var/canBleed = TRUE

	Attacked(obj/projectile/p)

		if(isplayer(p.owner))

			if(p.icon_state == "blood")
				p.damage += round(p.damage / 20, 1)

			if(canBleed)
				var/n = dir2angle(get_dir(src, p))
				emit(loc    = src,
					 ptype  = /obj/particle/fluid/blood,
				     amount = 5,
				     angle  = new /Random(n - 25, n + 25),
				     speed  = 2,
				     life   = new /Random(15,25))

			if(p.owner.MonsterMessages)
				p.owner << "Your [p] does [p.damage] damage to [src]."

			HP -= p.damage

			var/tmp_ekills = p.owner.ekills
			Death_Check(p.owner)

			if(p.owner.ekills > tmp_ekills)
				p.owner:learnSpell(p.name, 5)

			..()

obj
	projectile
		layer = 4
		density = 1
		var
			velocity = 0
			const/MAX_VELOCITY = 10
			life = 20

		SteppedOn(atom/movable/A)
			if(!A.density && (isplayer(A) || istype(A,/mob/NPC/Enemies)))
				src.Bump(A)
			else if(damage && istype(A,/obj/portkey))
				src.Bump(A)

		New(loc,dir,mob/mob,icon,icon_state,damage,name)
			..()

			src.dir = dir
			src.icon = icon
			src.icon_state = icon_state
			src.damage = damage
			src.owner = mob
			src.name = name

			spawn(life)
				Dispose()

		Dispose()
			walk(src,0)
			..()
		proc
			Impact(atom/movable/a, turf/oldloc)
				var/effect = TRUE
				. = 1
				if(istype(a, /obj/projectile))
					. = a:velocity >= velocity

					effect = a:owner != owner && .

				if(effect && (!damage || !ismob(a)))
					var/particle
					var/c

					switch(icon_state)
						if("snowball")
							particle = /obj/particle/fluid/snow
						if("iceball")
							particle = /obj/particle/smoke/proj
							c = "#0bc"
						if("fireball")
							particle = /obj/particle/smoke/proj
							c = "#c60"
						if("gum")
							particle = /obj/particle/smoke/proj
							c = "#ff69b4"
						if("flippendo")
							particle = /obj/particle/smoke
						if("quake")
							particle = /obj/particle/smoke/proj
							c = "#8b4513"
						if("blood")
							particle = /obj/particle/fluid/blood
							color = null

					if(particle)

						if(!oldloc) oldloc = isturf(a) ? a : a.loc
						if(!oldloc) oldloc = loc

						var/n = dir2angle(get_dir(oldloc, src))

						if(blend_mode == BLEND_SUBTRACT)
							color = null
							c     = "#c00"

						emit(loc    = oldloc,
							 ptype  = particle,
						     amount = 4,
						     angle  = new /Random(n - 25, n + 25),
						     speed  = 2,
						     life   = new /Random(15,20),
						     color  = color ? color : c)

			Effect(atom/movable/a)

		Attacked(obj/projectile/p)

			if(p.owner != owner)
				if(Impact(p))
					Dispose()

		proc
			shoot(lag=2)
				velocity = MAX_VELOCITY - lag
				walk(src, dir, lag)

		Bump(atom/movable/a)
			var/turf/t    = isturf(a.loc) ? a.loc : a
			if(!t || istype(t, /turf/nofirezone)) return

			var/oldSystem = inOldArena()
			if(oldSystem && !istype(a, /mob)) return

			var/count = 0
			for(var/atom/movable/O in t)
				if(O.invisibility >= 2) continue
				Effect(O)
				if(damage)
					O.Attacked(src)
				count++

			if(Impact(a, t) || count > 1)
				Dispose()

		Blood
			New()
				..()

				color      = "#08ffff"
				blend_mode = BLEND_SUBTRACT

		Lumos
			New()
				..()

				overlays += /obj/light

				animate(src, transform = matrix() * 3.2, time = 10, loop = -1)
				animate(     transform = matrix() * 3.3, time = 10)

			Dispose()
				density = 0
				walk(src, 0)

				sleep(600)

				..()

		Grav
			life = 15

			shoot()
				..()
				velocity+=2

			New()
				..()

				blend_mode = BLEND_SUBTRACT

				animate(src, color = rgb(rand(0,255), rand(0,255), rand(0,255)), time = 4, loop = -1)
				for(var/i = 1 to 3)
					animate(color = rgb(rand(0,255), rand(0,255), rand(0,255)), time = 5, loop = -1)

			Dispose()
				dir = SOUTH
				density = 0
				walk(src, 0)

				var/const/DIST  = 2
				var/const/TICKS = 15

				light(src, DIST, TICKS)

				for(var/t = TICKS to 0 step -1)
					for(var/mob/p in oview(DIST, src))
						if(istype(p, /mob/NPC/Enemies) || isplayer(p))
							step_towards(p, src)

					sleep(1)

				var/b = FALSE
				for(var/mob/p in oview(DIST, src))
					if(istype(p, /mob/NPC/Enemies) || isplayer(p))
						p.HP = 0
						p.Death_Check(owner)
						b = TRUE

				if(b)
					emit(loc    = loc,
						 ptype  = /obj/particle/fluid/blood,
					     amount = 125,
					     angle  = new /Random(0, 360),
					     speed  = 6,
					     life   = new /Random(1,25))

				..()

		Flippendo

			shoot()
				..()
				velocity--

			Attacked(obj/projectile/p)

				p.dir = turn(p.dir, pick(45, -45))
				walk(p, p.dir, MAX_VELOCITY - p.velocity)

				if(Impact(p))
					Dispose()

			Effect(atom/movable/a)

				if(isplayer(a) || istype(a, /mob/NPC/Enemies))

					owner << "Your [src] hit [a]!"

					if(!a.findStatusEffect(/StatusEffect/Potions/Stone))
						var/turf/t = get_step_away(a, src)
						if(t && !(issafezone(a.loc.loc) && !issafezone(t.loc)))
							a.Move(t)
							a << "You were pushed backwards by [owner]'s Flippendo!"

				else if(istype(a,/obj/projectile))
					a.dir = turn(a.dir, pick(45, -45))
					walk(a, a.dir, MAX_VELOCITY - a:velocity)

		Transfiguration

			Effect(atom/movable/a)

				if(src.owner && isplayer(a))
					var/mob/Player/p = a
					owner << "Your [src] hit [a]!"

					if(owner.CanTrans(p))
						p.nofly()

						flick("transfigure", p)
						p.trnsed = 1
						p.overlays = null
						if(p.away) p.ApplyAFKOverlay()

						p.icon       = 'Transfiguration.dmi'
						p.icon_state = name

						src.owner:learnSpell(name, 10)
					else
						src.owner:learnSpell(name, 5)

		Bind
			var/max_time
			var/min_time
			var/time

			New()
				..()

				if(min_time)
					time = min_time

			Move()
				..()

				var/step = 20 / (MAX_VELOCITY - velocity)

				time += (max_time - min_time) / step

			Effect(atom/movable/a)

				if(src.owner && isplayer(a))
					var/mob/Player/p = a
					owner << "Your [src] hit [a]!"


					if(p.removeoMob)
						p << errormsg("Your Permoveo spell failed.")
						p.client.eye = p
						p.client.perspective=MOB_PERSPECTIVE
						p.removeoMob:ReturnToStart()
						p.removeoMob:removeoMob = null
						p.removeoMob = null

					p << errormsg("You were hit by [owner]'s [name].")

					p.movable=1
					if(!p.trnsed)
						p.icon_state = icon_state
						p.overlays   = null

					src.owner:learnSpell(name, 10)

					spawn()
						var/t = round(time * 10)
						while(p && p.movable && t > 0)
							t--
							sleep(1)

						if(p)
							p.movable = 0
							if(!p.trnsed)
								p.icon_state = ""
								p.ApplyOverlays()

		BurnRoses

			Effect(atom/movable/a)
				if(istype(a, /obj/redroses))
					var/obj/redroses/r = a

					flick("burning", r)
					if(!r.GM_Made)
						spawn(4) r.Dispose()

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
	if(clanrobed())return
	if(M.loc == null) return
	if(istype(M.loc.loc, /area/ministry_of_magic||istype(M.loc.loc, /area/blindness))){src<<"<b>You cannot use remote view on this person.";return}
	usr.client.eye=M
	usr.client.perspective=EYE_PERSPECTIVE
	hearers()<<"[usr] sends \his view elsewhere."
mob/GM/verb/HM_Remote_View(mob/M in world)
	set category="Staff"
	set popup_menu = 0
	if(clanrobed())return
	usr.client.eye=M
	usr.client.perspective=EYE_PERSPECTIVE
mob/GM/verb/Return_View()
	set category="Staff"
	usr.client.eye=usr
	usr.client.perspective=MOB_PERSPECTIVE
	usr<<"You return to your body."

mob/var/tmp/episkying = 0
mob/var/tmp/meditating = 0
obj/var
	wlable = 0

var/move_queue = FALSE

mob
	var
		tmp/obj/wingobject
		tmp/Wingardiumleviosa

client
	var/tmp
		moving = 0
		list/movements

	Move(loc,dir)

		if(mob.wingobject)
			var/turf/t = get_step(mob.wingobject,dir)
			if(istype(mob.wingobject.loc,/mob))
				src << infomsg("You let go of the object you were holding.")
				mob.wingobject.overlays = null
				mob.wingobject=null
				mob.Wingardiumleviosa = null
			else if(t && (t in view(view)))
				mob.wingobject.Move(t)
			return

		if(mob.removeoMob)
			step(mob.removeoMob,dir)
			return

		if(mob.away)
			mob.away = 0
			mob.status=usr.here
			mob.RemoveAFKOverlay()

		if(isplayer(mob))
			var/mob/Player/p = mob

			if(p.auctionInfo)
				p.auctionClosed()
				winshow(src, "Auction", 0)

			if(p.screen_text)
				p.screen_text.Dispose()

		if(mob.questionius==1)
			mob.overlays-=icon('hand.dmi')
			mob.questionius=0

		if(move_queue)
			if(!movements) movements = list()
			if(movements.len < 10)
				movements += dir
			if(moving) return
			moving = 1

			var/index = 0
			while(movements && index < movements.len)
				index++
				var/d = movements[index]
				..(get_step(mob, d), d)
				sleep(mob:move_delay + mob:slow)
			movements = null
			moving = 0
		else
			..()

obj/var
	controllable = 0
mob/var/Imperio = 0
mob/GM
	var
		controlobject
obj/overlay
	flash
		icon = 'attacks.dmi'
		icon_state = "leviosa"
		layer = MOB_LAYER


obj/portkey
	var/obj/portkey/partner
	var/HP = 15
	icon='portal.dmi'
	icon_state="portkey"
	New()
		..()
		switch(rand(1,3))
			if(1)
				icon='bucket.dmi'
				icon_state="bucket"
			if(2)
				icon='misc.dmi'
				icon_state="tea"
			if(3)
				icon = 'scrolls.dmi'
				icon_state = "blank"
			if(4)
				icon = 'turf.dmi'
				icon_state="candle"
		spawn(300)
			view(src) << "The portkey collapses and closes."
			del(src)
	proc/Teleport(mob/Player/M)
		if(!partner) return

		if(!(!M.client.moving && issafezone(M.loc.loc)) && M.Transfer(partner.loc))
			M << "You step through the portkey."
			..()

mob/Player
	var/tmp/teleporting = 0

	proc/Transfer(turf/t)
		if(teleporting) return 0

		if(istype(t, /atom/movable))
			t = t.loc

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