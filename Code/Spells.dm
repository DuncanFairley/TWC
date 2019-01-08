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
	/mob/Spells/verb/Serpensortia = "Serpensortia",
	/mob/Spells/verb/Accio = "Accio",
	/mob/Spells/verb/Accio_Maxima = "Accio Maxima",
	/mob/Spells/verb/Reparo = "Reparo",
	/mob/Spells/verb/Herbificus = "Herbificus",
	/mob/Spells/verb/Herbivicus = "Herbivicus",
	/mob/Spells/verb/Bombarda = "Bombarda",
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

mob/Spells/verb/Accio(obj/M in oview(15,usr))
	set category = "Spells"
	set waitfor = 0
	if(canUse(src,cooldown=null,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))

		if(!M.accioable && M.owner != usr.ckey)
			src << errormsg("This object cannot be moved.")
			return

		hearers(usr.client.view,usr)<< " <b>[usr]:<i><font color=aqua> Accio [M.name]!</i>"
		usr:learnSpell("Accio")

		var/turf/dest = locate(x, y-1, z)
		if(!dest) dest = loc
		var/turf/t = M.loc

		while(M.loc == t && t != dest)
			t = get_step_towards(M, dest)
			if(!t) break
			M.loc = t
			sleep(2)

		if(istype(M,/obj/candle) || istype(M,/obj/books) || istype(M,/obj/Cauldron)) M:respawn()

mob/Spells/verb/Accio_Maxima()
	set category = "Spells"
	set waitfor = 0
	if(canUse(src,cooldown=/StatusEffect/UsedAccio,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		var/mob/Player/p = src
		new /StatusEffect/Summoned(src,10*p.cooldownModifier)
		hearers(client.view, p)<< " <b>[p]:<i><font color=aqua> Accio Maxima!</i>"
		p.learnSpell("Accio Maxima")

		for(var/obj/items/i in range(p, 10))
			if((!i.accioable && i.owner != ckey) || i.loc.density) continue
			i.walkTo(src, 1)



obj/items/proc/walkTo(atom/movable/a, pickup=0)
	set waitfor = 0
	while(a && loc && a.loc && a.loc != loc)
		loc = get_step_towards(src, a.loc)
		sleep(1)
	if(pickup && fetchable)
		Move(a)
		a:Resort_Stacking_Inv()


mob/Spells/verb/Eat_Slugs(var/n as text)
	set category = "Spells"
	set hidden = 1
	if(IsInputOpen(src, "Eat Slugs"))
		del _input["Eat Slugs"]
	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=100,againstocclumens=1))
		var/list/people = ohearers(client.view)&Players
		var/mob/Player/M
		var/mob/Player/p = src
		if(n)
			for(var/mob/Player/i in people)
				if(findtext(n, i.name) && length(i.name) + 2 >= length(n))
					M = i
					break
		if(!M && people.len)
			var/Input/popup = new (src, "Eat Slugs")
			M = popup.InputList(src, "Cast this curse on?", "Eat Slugs", people[1], people)
			del popup
		if(!M) return
		if(!(M in ohearers(client.view))) return
		new /StatusEffect/Summoned(src,15*p.cooldownModifier)
		p.MP = max(p.MP - 100, 0)
		p.updateMP()
		if(p.prevname)
			hearers() << "<span style=\"font-size:2;\"><font color=red><b><font color=red>[usr]</span></b> :<font color=white> Eat Slugs, [M.name]!"
		else
			hearers() << "<span style=\"font-size:2;\"><font color=red><b>[p.Tag]<font color=red>[usr]</span> [p.GMTag]</b>:<font color=white> Eat Slugs, [M.name]!"

		M << errormsg("[usr] has casted the slug vomiting curse on you.")
		p.learnSpell("Eat Slugs")
		src=null
		spawn()
			var/slugs = rand(4,12)
			while(M && slugs > 0 && M.MP > 0)
				M.MP -= rand(20,60) * round(M.level/100)
				new/mob/Enemies/Summoned/Slug(M.loc)
				if(M.MP < 0)
					M.MP = 0
					M.updateMP()
					M << errormsg("You feel drained from the slug vomiting curse.")
					break
				else
					M.updateMP()
				slugs--
				sleep(rand(20,90))
		return TRUE

mob/Spells/verb/Disperse()
	set category = "Spells"
	set hidden = 1

	if(canUse(src,cooldown=/StatusEffect/UsedDisperse,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/UsedDisperse(src,10*usr:cooldownModifier)
		usr:learnSpell("Disperse")
		for(var/obj/smokeeffect/S in oview(client.view))
			del(S)
		for(var/turf/T in oview())
			if(T.specialtype & SWAMP)
				T.slow -= 5
				T.specialtype -= SWAMP
				var/image/i = image('Effects.dmi',icon_state = "m-black",layer=10)
				T.overlays += i
				var/list/decor = list()
				for(var/obj/o in T)
					if(o.name == "swamp")
						decor += o
						animate(o, alpha = 0, time = 8)

				spawn(9)
					T.overlays -= i

					for(var/obj/o in decor)
						o.loc = null
		src = null

mob/Spells/verb/Herbificus()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,antiTeleport=1))
		var/obj/redroses/p = new
		p:loc = locate(src.x,src.y-1,src.z)
		p.FlickState("Orb",12,'Effects.dmi')
		p:owner = "[usr.key]"
		if(!findStatusEffect(/StatusEffect/SpellText))
			new /StatusEffect/SpellText(src,5)
			hearers()<<"<b><span style=\"color:red;\">[usr]:</span> Herbificus."
			usr:learnSpell("Herbificus")

mob/Spells/verb/Herbivicus()
	set category = "Spells"
	if(canUse(src,needwand=1,insafezone=1,inhogwarts=1))
		hearers()<<"<b><span style=\"color:red;\">[usr]:</span> Herbivicus."

		for(var/obj/herb/h in oview(15, src))
			if(h.wait) continue

			var/image/i = image('attacks.dmi',icon_state="heal")
			h.overlays += i
			sleep(10)
			h.overlays -= i

			if(h.lastUsed)
				if(h.water == 1)
					h.water = 2
				else if(h.water == -1)
					h.water = 0
				else if(h.water == 2 && world.realtime - h.lastUsed >= h.delay*0.75)
					h.grow(src)
			else
				h.grow(src)

		usr:learnSpell("Herbivicus")

mob/Spells/verb/Protego()
	set category = "Spells"
	var/mob/Player/p = src
	if(!p.reflect)
		if(canUse(src,cooldown=/StatusEffect/UsedProtego,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
			new /StatusEffect/UsedProtego(src,40*p.cooldownModifier,"Protego")
			p.overlays += /obj/Shield
			hearers()<< "<b><span style=\"color:red;\">[usr]</b></span>: PROTEGO!"
			p << "You shield yourself magically"
			p.reflect = 0.5
			p.learnSpell("Protego")
			sleep(30)
			if(p.reflect)
				p.reflect = 0
				p.overlays -= /obj/Shield
				p<<"You are no longer shielded!"

mob/Spells/verb/Valorus(mob/Player/M in view())
	set category="Spells"
	var/mob/Player/user = usr
	if(locate(/obj/items/wearable/wands) in user.Lwearing)
		M.followplayer=0
		hearers() << "[usr] flicks \his wand towards [M]"
		usr:learnSpell("Valorus")
		if(M.flying)
			var/obj/items/wearable/brooms/B = locate() in M.Lwearing
			if(B)
				B.protection--
				if(B.protection <= 0)
					B.Equip(M,1)
				//M.flying=0
				//M.icon_state=""
				//M.density=1
					hearers()<<"[M] is knocked off \his broom!"
					new /StatusEffect/Knockedfrombroom(M, max(1, 16 - B.protection*2))
	else
		usr << "You must hold a wand to cast this spell."
mob/Spells/verb/Depulso()
	set category="Spells"

	var/found = FALSE
	for(var/mob/Player/M in get_step(usr,usr.dir))
		if(!M.findStatusEffect(/StatusEffect/Potions/Stone))
			var/turf/t = get_step_away(M,usr,15)
			if(!t || (issafezone(M.loc.loc, 0) && !issafezone(t.loc, 0))) return
			M.Move(t)

		if(!findStatusEffect(/StatusEffect/SpellText))
			new /StatusEffect/SpellText(src,5)
			hearers()<<"<b><span style=\"color:red;\">[usr]:</span></b> Depulso!"

		if(isplayer(M))
			found = TRUE
			M<<"You were pushed backwards by [usr]'s Depulso Charm."
			if(M.flying)
				var/obj/items/wearable/brooms/B = locate() in M.Lwearing
				if(B)
					B.protection--
					if(B.protection <= 0)
						B.Equip(M,1)
						hearers()<<"[usr]'s Depulso knocked [M] off \his broom!"
						new /StatusEffect/Knockedfrombroom(M, max(1, 16 - B.protection*2))
	if(found)
		usr:learnSpell("Depulso")

mob/Spells/verb/Deletrius()
	set category="Spells"
	var/mob/Player/user = usr
	if(locate(/obj/items/wearable/wands) in user.Lwearing)
		usr:learnSpell("Deletrius")
		for(var/obj/redroses/S in oview(usr.client.view,usr))
			if(!S.GM_Made || (S.GM_Made && usr.Gm))
				S.FlickState("Orb",12,'Effects.dmi')
				S.Dispose()
		hearers(usr.client.view,usr)<<"[usr] flicks \his wand, causing the roses to dissolve into the air."
	else
		usr << errormsg("This spell requires a wand.")
mob/Spells/verb/Expelliarmus(mob/Player/M in view())
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1))
		var/obj/items/wearable/wands/W = locate(/obj/items/wearable/wands) in M:Lwearing
		if(W)
			W.Equip(M,1)
			hearers()<<"<span style=\"color:red;\"><b>[usr]</b></span>: <font color=white>Expelliarmus!"
			hearers()<<"<b>[M] loses \his wand.</b>"
			new /StatusEffect/UsedAnnoying(src,15*usr:cooldownModifier)
			usr:learnSpell("Expelliarmus")
			M.nowand()
		else
			usr << "[M] doesn't have \his wand drawn."

mob/Player/proc/nowand()
	if(client.eye != src && Interface.SetDarknessColor(TELENDEVOUR_COLOR))
		src << "Your Telendevour wears off."
		client.eye = src
		client.perspective = EYE_PERSPECTIVE

	if(removeoMob)
		src << "Your Permoveo spell failed.."
		client.eye = src
		client.perspective = MOB_PERSPECTIVE
		removeoMob:ReturnToStart()
		removeoMob:removeoMob = null
		removeoMob = null
	else if(Wingardiumleviosa)
		src << "You let go of the object you were holding."
		wingobject = null
		Wingardiumleviosa = null

mob/Spells/verb/Eparo_Evanesca()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedEvanesca,needwand=1,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedEvanesca(src,10*usr:cooldownModifier)
		hearers()<<"<b><font color=red>[usr] <font color=blue> Eparo Evanesca!"
		usr:learnSpell("Eparo Evanesca")
		for(var/mob/Player/M in hearers())
			if(M.key&&(M.invisibility==1))
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
				new /StatusEffect/Decloaked(M,15*usr:cooldownModifier)

mob/Spells/verb/Imitatus(mob/M in view()&Players, T as text)
	set category = "Spells"
	var/mob/Player/p = src
	if(p.mute==1){src<<"You cannot cast this spell while muted.";return}
	hearers()<<"<span style=\"color:red;\">[p]:</span> Imitatus."
	hearers() << "<span style=\"color:red;\"><b>[M]</b> : </span>[html_encode(T)]"
	p.learnSpell("Imitatus")
mob/Spells/verb/Morsmordre()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedClanAbilities,inarena=0, insafezone=0, needwand=1))
		var/obj/The_Dark_Mark/D = locate("DarkMark")
		if(D && D.loc)
			src << errormsg("A dark mark already exists in the sky.")
			return

		new /StatusEffect/UsedClanAbilities(src, 600)
		D = new (locate(src.x,src.y+1,src.z))
		D.density=0
		D.owner = ckey
		D.FlickState("m-black",8,'Effects.dmi')
		hearers() <<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=green>MORSMORDRE!"
		Players<<"The sky darkens as a sneering skull appears in the clouds with a snake slithering from its mouth."

mob/Spells/verb/Repellium()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedRepel,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=100,againstocclumens=1))
		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=white>Repellium!"
		var/mob/Player/p = src
		p.MP -= 100
		p.updateMP()
		light(src, 3, 300, "light")
		p.learnSpell("Repellium")
		new /StatusEffect/UsedRepel(src, 90*p.cooldownModifier)
		new /StatusEffect/DisableProjectiles(src, 30)
		var/time = 75
		while(time > 0)
			for(var/mob/Enemies/D in ohearers(3, src))
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
		var/mob/Player/p = src
		p.MP -= 100
		p.updateMP()

		p.learnSpell("Lumos")
		new /StatusEffect/UsedLumos(src, 60*p.cooldownModifier)

		var/obj/light/l = new(loc)

		animate(l, transform = matrix() * 1.6, time = 10, loop = -1)
		animate(   transform = matrix() * 1.5,   time = 10)

		p.addFollower(l)

		src = null
		spawn(600)
			if(p && l)
				p.removeFollower(l)
				l.loc = null

mob/Spells/verb/Lumos_Maxima()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedLumos,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=300,againstocclumens=1))
		var/mob/Player/p = src
		hearers()<<"<b><span style=\"color:red;\">[p]</b></span>: <b><font size=3><font color=white>Lumos Maxima!"

		new /StatusEffect/UsedLumos(src, 90*p.cooldownModifier)

		castproj(MPreq = 300, Type = /obj/projectile/Lumos, icon_state = "light", name = "Lumos Maxima", lag = 2)

mob/Spells/verb/Aggravate()
	set category = "Spells"
	if(!loc) return
	if(canUse(src,cooldown=/StatusEffect/UsedAggro,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=150,againstocclumens=1))
		var/mob/Player/p = src
		hearers()<<"<b><span style=\"color:red;\">[p]</b></span>: <b><font size=3><font color=white>Aggravate!"
		p.MP -= 150
		p.updateMP()

		new /StatusEffect/UsedAggro(src, 30*p.cooldownModifier)

		var/area/pArea = loc.loc
		light(src, range=13, ticks=10, state = "red")
		for(var/mob/Enemies/e in ohearers(13))
			var/area/eArea = loc.loc

			if(eArea != pArea) continue
			if(e.state == 0)   continue

			e.ChangeState(e.HOSTILE)
			e.target = src


mob/Spells/verb/Basilio()
	set category = "Spells"
	hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=green> Basilio!"
	sleep(20)
	hearers()<<"[usr]'s wand emits a bright flash of light."
	sleep(20)
	if(!src.loc.loc:safezoneoverride && (istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/hogwarts/Duel_Arenas) || istype(src.loc.loc,/area/hogwarts) || istype(src.loc.loc,/area/Diagon_Alley)))
		src << "<b>You can't use this inside a safezone.</b>"
		return
	hearers()<<"A Black Basilisk, emerges from [usr]'s wand."
	hearers()<<"<b>Basilisk</b>: Hissssssss!"
	var/mob/Enemies/Summoned/Boss/Basilisk/D = new (locate(src.x,src.y-1,src.z))
	D.FlickState("m-black",8,'Effects.dmi')

mob/Spells/verb/Serpensortia()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=0,inhogwarts=0,target=null,mpreq=0,againstocclumens=1))
		var/mob/Player/p = src
		if(p.Summons && p.Summons.len >= 1 + round(p.Summoning.level / 10))
			p << errormsg("You need higher summoning level to summon more.")
			return

		new /StatusEffect/Summoned(src,15*p.cooldownModifier)

		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=green> Serpensortia!"
		hearers()<<"A Red-Spotted Green Snake, emerges from the wand."
		var/obj/summon/snake/s = new  (loc, src)
		s.FlickState("m-black",8,'Effects.dmi')
		p.learnSpell("Serpensortia")

mob/Spells/verb/Herbificus_Maxima()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,antiTeleport=1))
		var/obj/redroses/a = new
		var/obj/redroses/b = new
		var/obj/redroses/c = new
		a.loc = get_step(usr,turn(usr.dir,-45))
		b.loc = get_step(usr,usr.dir)
		c.loc = get_step(usr,turn(usr.dir,45))
		a.FlickState("Orb",12,'Effects.dmi')
		b.FlickState("Orb",12,'Effects.dmi')
		c.FlickState("Orb",12,'Effects.dmi')
		a:owner = "[usr.key]"
		b:owner = "[usr.key]"
		c:owner = "[usr.key]"
		if(!findStatusEffect(/StatusEffect/SpellText))
			new /StatusEffect/SpellText(src,5)
			hearers()<<"<b><span style=\"color:red;\">[usr]:</span> Herbificus MAXIMA!"
mob/Spells/verb/Shelleh()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedShelleh,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=50,againstocclumens=1))
		new /StatusEffect/UsedShelleh(src,60*usr:cooldownModifier)
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
		new /StatusEffect/UsedFerula(src, 60*usr:cooldownModifier)
		var/obj/Madame_Pomfrey/p = new /obj/Madame_Pomfrey (loc, 500)

		var/turf/t = locate(x,y+1,z)
		if(t)
			p.loc = t

		p.FlickState("Orb",12,'Effects.dmi')
		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=aqua> Ferula!"
		hearers()<<"[usr] has summoned Madame Pomfrey!"
		usr:learnSpell("Ferula")

mob/Spells/verb/Avis()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		var/mob/Player/p = src
		if(p.Summons && p.Summons.len >= 1 + round(p.Summoning.level / 10))
			p << errormsg("You need higher summoning level to summon more.")
			return

		new /StatusEffect/Summoned(src,15*p.cooldownModifier)

		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=yellow> Avis!"
		hearers()<<"A Phoenix emerges."
		var/obj/summon/phoenix/s = new  (loc, src)
		s.FlickState("m-black",8,'Effects.dmi')
		p.learnSpell("Avis")

mob/Spells/verb/Crapus_Sticketh()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=0,inhogwarts=0,useTimedProtection=1,target=null,mpreq=0,againstocclumens=1))
		var/mob/Player/p = src
		if(p.Summons && p.Summons.len >= 1 + round(p.Summoning.level / 10))
			p << errormsg("You need higher summoning level to summon more.")
			return

		new /StatusEffect/Summoned(src,15*p.cooldownModifier)

		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=green> Crapus...Sticketh!!"
		hearers()<<"A stick figure appears."
		var/obj/summon/stickman/s = new  (loc, src)
		s.FlickState("m-black",8,'Effects.dmi')

mob/Spells/verb/Permoveo() // [your level] seconds - monster's level, but, /at least 30 seconds/?
	set category = "Spells"
	var/mob/Player/p = src
	if(p.removeoMob)
		p << "You release your hold of the monster you were controlling."
		var/mob/Enemies/E = p.removeoMob
		if(E.removeoMob)
			spawn()
				E.ReturnToStart()
				E.removeoMob = null
		p.removeoMob = null
		client.eye=src
		client.perspective=MOB_PERSPECTIVE
		return
	var/list/enemies = list()
	for(var/mob/Enemies/M in ohearers())
		enemies.Add(M)
	if(!enemies.len)
		src << "There are no monsters in your view"
	else
		if(canUse(src,cooldown=/StatusEffect/Permoveo,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=300,againstocclumens=1))
			var/mob/Enemies/selmonster = input("Which monster do you cast Permoveo on?","Permoveo") as null|anything in enemies
			if(!selmonster) return
			if(!(selmonster in view())) return
			if(p.removeoMob) return
			if(p.level < selmonster.level)
				src << errormsg("The monster is level [selmonster.level]. You need to be a higher level.")
				return
			new /StatusEffect/Permoveo(src, max(400-(usr.level/2), 30)*p.cooldownModifier)

			hearers() << "[usr]: <i>Permoveo!</i>"
			if(selmonster.removeoMob)
				var/mob/B = selmonster.removeoMob
				B << "[src] took possession of the monster you were controlling."
				B.client.eye=B
				B.client.perspective=MOB_PERSPECTIVE
				B.removeoMob = null
			p.MP -= 300
			p.updateMP()

			p.removeoMob = selmonster
			client.eye = selmonster
			client.perspective = EYE_PERSPECTIVE
			selmonster.removeoMob = src
			selmonster.ChangeState(selmonster.CONTROLLED)
			selmonster.target = null
			p.learnSpell("Permoveo")

mob/Spells/verb/Incarcerous()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedStun,needwand=1,inarena=1,insafezone=1,inhogwarts=1,mpreq=50,againstocclumens=1))
		new /StatusEffect/UsedStun(src,15*usr:cooldownModifier,"Incarcerous")
		hearers(usr.client.view, usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b> Incarcerous!</b>"

		castproj(MPreq = 50, Type = /obj/projectile/Bind { time = 1 }, icon_state = "bind", name = "Incarcerous", lag = 1)

mob/Spells/verb/Anapneo(var/mob/Player/M in view())
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1))
		if(!M.flying == 0){src<<"<b><span style=\"color:red;\">Error:</b></span> You can't cast this spell on someone who is flying.";return}
		hearers()<<"<B><span style=\"color:red;\">[usr]:</span><font color=blue> <I>Anapneo!</I>"
		M.silence=0
		M.muff=0
		sleep(20)
		hearers(usr.client.view,usr)<<"[usr] flicks \his wand, clearing the airway of [M]."
		usr:learnSpell("Anapneo")
mob/Spells/verb/Reducto()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,mpreq=0,againstocclumens=1))
		var/mob/Player/p = src
		if(flying)
			src << "<b><span style=\"color:red;\">Error:</b></span> You can't cast this spell while flying."
			return
		if(p.GMFrozen) return
		hearers(client.view, src) << "<B><span style=\"color:red;\">[src]:</span><font color=white> <I>Reducto!</I>"
		if(p.nomove < 2) p.nomove = 0
		if(!trnsed) p.ApplyOverlays()
		FlickState("apparate",8,'Effects.dmi')
		p.learnSpell("Reducto")
mob/Spells/verb/Reparo()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedReparo,needwand=1,insafezone=1,inhogwarts=1,mpreq=150))
		var/mob/Player/p = src
		new /StatusEffect/UsedReparo(src,10*p.cooldownModifier,"Reparo")
		hearers(client.view,src) << "[src]: <b>Reparo!</b>"
		p.MP -= 150
		p.updateMP()
		p.learnSpell("Reparo")

		for(var/obj/o in oview(15, src))
			if(!o.rubbleable || !o.rubble) continue

			var/image/i = image('attacks.dmi',icon_state="heal")
			o.overlays += i
			sleep(10)
			o.overlays -= i

			o.icon=o.picon
			o.name=o.pname
			o.icon_state=o.piconstate
			o.rubble=0

mob/Spells/verb/Bombarda()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,mpreq=100,projectile=1))
		var/mob/Player/p = src
		p.lastAttack = "Bombarda"
		var/dmg = p.Dmg + p.clothDmg
		castproj(MPreq = 100, Type = /obj/projectile/Bomb, icon_state = "bombarda", damage = dmg, name = "Bombarda", cd=3)

mob/Spells/verb/Petreficus_Totalus()
	set category="Spells"
	set name = "Petrificus Totalus"
	if(canUse(src,cooldown=/StatusEffect/UsedStun,needwand=1,inarena=1,insafezone=1,inhogwarts=1,mpreq=50,againstocclumens=1))
		new /StatusEffect/UsedStun(src,15*usr:cooldownModifier,"Petrificus Totalus")
		hearers(usr.client.view, usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b> Petrificus Totalus!</b>"

		castproj(MPreq = 50, Type = /obj/projectile/Bind { min_time = 0.4; max_time = 2.4 }, icon_state = "stone", name = "Petrificus Totalus", lag = 1)

mob
	Player/var/tmp/antifigura = 0
	proc
		CanTrans(mob/Player/p)
			if(p.animagusOn)
				src << errormsg("You can't transfigure [p].")
				return 0
			if(p.antifigura > 0)
				p.antifigura--
				src << errormsg("Your spell failed, [p] is protected from transfiguring spells.")
				if(p.antifigura==0)
					p << errormsg("You were forced to release the shield around your body.")
					new /StatusEffect/UsedTransfiguration(p,15*p.cooldownModifier)
				return 0
			return 1

mob/Spells/verb/Antifigura()
	set category="Spells"
	var/mob/Player/p = src
	if(p.antifigura > 0)
		new /StatusEffect/UsedTransfiguration(usr,15*p.cooldownModifier)
		src << infomsg("You release the shield around your body.")
		p.antifigura = 0
	else if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=50,againstocclumens=1))
		hearers() << "<b><span style=\"color:red;\">[usr]</span></b>: <span style=\"color:white;\"><i>Antifigura!</i></span>"
		p.antifigura = max(round((p.MMP) / rand(500,1500)), 1)
		p.MP -= 50
		p.updateMP()
		usr:learnSpell("Antifigura")


mob/Spells/verb/Chaotica()
	set category="Spells"

	var/mob/Player/p = src
	var/dmg = ((p.passives & SWORD_FIRE) ? Dmg + clothDmg : round(level * 1.15 + clothDmg/3, 1)) + p.Fire.level

	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=30,againstocclumens=1,projectile=1))
		p.lastAttack = "Chaotica"
		castproj(MPreq = 30, Type = /obj/projectile/NoImpact, icon_state = "chaotica", damage = dmg, name = "Chaotica", element = FIRE)
mob/Spells/verb/Aqua_Eructo()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,projectile=1))
		var/mob/Player/p = src
		p.HP -= 50
		p.updateHP()
		Death_Check()

		var/dmg = round(p.Def / 3 + p.Water.level, 1)

		usr:lastAttack = "Aqua Eructo"
		castproj(icon_state = "aqua", damage = dmg, name = "Aqua Eructo", element = WATER)


mob/Spells/verb/Sanguinis_Iactus()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=5,againstocclumens=1,projectile=1))

		usr:lastAttack = "Sanguinis Iactus"
		castproj(Type = /obj/projectile/Blood, MPreq = 5, icon_state = "blood", damage = usr.Dmg + clothDmg, name = "Blood")

mob/Spells/verb/Gravitate()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,projectile=1))


		castproj(Type = /obj/projectile/Grav, icon_state = "grav", name = "Gravitate")

mob/Spells/verb/Inflamari()
	set category="Spells"

	var/mob/Player/p = src
	var/dmg
	if(p.passives & SWORD_FIRE)
		dmg = Dmg + clothDmg
	else
		dmg = level * 0.9 + clothDmg

		if(level < 200)
			dmg *= 1 + (200 - level)/100

		if(dmg <= 10)
			dmg = 10 + rand(1,5)
		else
			dmg = round(dmg, 1)

	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,projectile=1))
		p.lastAttack = "Inflamari"
		castproj(icon_state = "fireball", damage = dmg + p.Fire.level, name = "Inflamari", element = FIRE)
mob/Spells/verb/Glacius()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=10,againstocclumens=1,projectile=1))
		usr:lastAttack = "Glacius"
		castproj(MPreq = 10, icon_state = "iceball", damage = usr.Dmg + clothDmg + usr:Water.level, name = "Glacius", element = WATER)
mob/Spells/verb/Waddiwasi()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=10,againstocclumens=1,projectile=1))
		usr:lastAttack = "Waddiwasi"
		castproj(MPreq = 10, icon_state = "gum", damage = usr.Dmg + clothDmg + usr:Ghost.level, name = "Waddiwasi", element = GHOST)
mob/Spells/verb/Tremorio()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=5,againstocclumens=1,projectile=1))
		usr:lastAttack = "Tremorio"
		castproj(MPreq = 5, icon_state = "quake", damage = usr.Dmg + clothDmg + usr:Earth.level, name = "Tremorio", element = EARTH)

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
			new /StatusEffect/UsedArcesso(src,15*usr:cooldownModifier)
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
			var/mob/Player/summonee = popup.InputList(arcessoing,"Who would you like to summon?", "Arcesso", null, Players(list(src, arcessoing)))
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
									var/mob/Player/p1 = src
									var/mob/Player/p2 = arcessoing
									p1.MP -= 400
									p2.MP -= 800

									p1.learnSpell("Arcesso")
									p2.learnSpell("Arcesso")

									p1.updateMP()
									p2.updateMP()
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
									if(summonee.removeoMob)
										spawn()
											var/mob/m = summonee
											m:Permoveo()
									sleep(5)
									summonee << "You've been summoned by [src] and [src.arcessoing]."
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
				new /StatusEffect/UsedArcesso(src,15*usr:cooldownModifier)
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
	var/mob/Player/p = src
	if(canUse(src,cooldown=/StatusEffect/UsedFlagrate,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=300,againstocclumens=1))
		if(p.mute==0)
			if(str_count(message,"\n") > 20)
				p << errormsg("Flagrate can only use up to 20 lines of text.")
			else
				message = copytext(message,1,500)
				new /StatusEffect/UsedFlagrate(src,10*p.cooldownModifier)
				hearers(client.view)<<"<span style=\"color:red;\"><b>[usr]:</span> Flagrate!"
				sleep(10)
				hearers(client.view)<<"<span style=\"color:red;\"><b>[usr]:</span> <span style=\"color:#FF9933;\"><font size=3><font face='Comic Sans MS'> [html_encode(message)]</span>"
				p.MP-=300
				p.updateMP()
				p.learnSpell("Flagrate")
		else
			alert("You cannot cast this while muted.")
mob/Spells/verb/Langlock(mob/Player/M in oview())
	set category = "Spells"
	set name = "Langlock"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=600,againstocclumens=1))
		if(!M.silence)
			M.silence=1
			var/mob/Player/p = src
			p.MP -= 600
			p.updateMP()
			hearers()<<"[usr] flicks \his wand towards [M] and mutters, 'Langlock'"
			hearers() << "<b>[M]'s tongue has been stuck to the roof of \his mouth. They are unable to speak.</b>"
			p.learnSpell("Langlock")
			src = null
			spawn(300)
				if(M && M.silence)
					M<<"<b>Your tongue unsticks from the roof of your mouth.</b>"
					M.silence=0
mob/Spells/verb/Muffliato(mob/Player/M in view())
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1))
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
	if(inOldArena()) return
	if(canUse(src,cooldown=/StatusEffect/UsedIncindia,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=450,againstocclumens=1,projectile=1))
		var/mob/Player/p = src
		hearers()<<"[src] raises \his wand into the air. <font color=red><b><i>INCINDIA!</b></i>"
		p.MP-=450
		p.updateMP()
		new /StatusEffect/UsedIncindia(src,15*p.cooldownModifier,"Incindia")
		var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		var/damage = round((p.Dmg + p.clothDmg + p.Fire.level) * 0.75)
		p.learnSpell("Incindia")
		for(var/d in dirs)
			castproj(icon_state = "fireball", damage = damage, name = "incindia", cd = 0, lag = 1, element = FIRE, Dir=d)
mob/Spells/verb/Replacio(mob/Player/M in oview())
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=500,againstocclumens=1))
		if(issafezone(M.loc.loc, 0) && !issafezone(loc.loc, 0))
			src << "<b>[M] is inside a safezone.</b>"
			return
		var/mob/Player/p = src
		hearers()<<"<b><span style=\"color:red;\">[usr]:</b></span> <font color=blue><B> <i>Replacio Duo.</i></B>"
		var/startloc = usr.loc
		M.FlickState("Orb",12,'Effects.dmi')
		usr.FlickState("Orb",12,'Effects.dmi')
		p.Transfer(M.loc)
		M.Transfer(startloc)
		usr.FlickState("Orb",12,'Effects.dmi')
		M.FlickState("Orb",12,'Effects.dmi')
		hearers()<<"[usr] trades places with [M]"
		p.MP-=500
		p.updateMP()
		p.learnSpell("Replacio")
mob/Spells/verb/Occlumency()
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=1,againstocclumens=1))
		var/mob/Player/p = src
		if(p.occlumens == 0)
			for(var/mob/Player/c in Players)
				if(c == p) continue
				if(c.client.eye == p && c.Interface.SetDarknessColor(TELENDEVOUR_COLOR))
					c << errormsg("Your Telendevour wears off.")
					c.client.eye = c
			hearers() << "<b><span style=\"color:red;\">[usr]</span></b>: <span style=\"color:white;\"><i>Occlumens!</i></span>"
			p << "You can no longer be viewed by Telendevour."
			p.occlumens = p.MMP
			p.OcclumensCounter()
			p.learnSpell("Occlumency")
		else if(p.occlumens > 0)
			src << "You release the barriers around your mind."
			p.occlumens = -1

mob/Spells/verb/Obliviate(mob/Player/M in oview())
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=700,againstocclumens=0))
		hearers()<<"<b><span style=\"color:red;\">[usr]:<font color=green> Obliviate!</b></span>"
		var/mob/Player/p = src
		if(prob(15))
			p << output(null,"output")
			hearers()<<"[usr]'s spell has backfired."
			if(prob(70)) p.learnSpell("Obliviate", -1)
		else
			if(!M.admin || p == M) M << output(null,"output")
			hearers()<<"[usr] wiped [M]'s memory!"
			p.learnSpell("Obliviate")
		p.MP-=700
		new /StatusEffect/UsedAnnoying(src,30*p.cooldownModifier)
		p.updateMP()
mob/Spells/verb/Tarantallegra(mob/Player/M in view())
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=100,againstocclumens=1))
		if(M.dance) return
		hearers()<<"<b>[usr]:</B><font color=green> <i>Tarantallegra!</i>"
		new /StatusEffect/UsedAnnoying(src,15*usr:cooldownModifier)
		var/mob/Player/p = src
		p.MP-=100
		p.updateMP()
		if(key != "Murrawhip")
			M.dance=1
		p.learnSpell("Tarantallegra")
		src=null
		spawn()
			view(M)<<"[M] begins to dance uncontrollably!"
			var/timer = 0
			var/dirs = list(NORTH,EAST,SOUTH,WEST,NORTHWEST,NORTHEAST,SOUTHWEST,SOUTHEAST)
			while(M && timer < 24)
				timer++
				if(!M.nomove)
					var/turf/t = get_step_rand(M)
					if(t && !(issafezone(M.loc.loc, 0) && !issafezone(t.loc, 0)))
						M.Move(t)
				M.dir = pick(dirs)
				sleep(5)
			if(M) M.dance = 0
mob/Spells/verb/Immobulus()
	set category = "Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedImmobulus,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=500,againstocclumens=1))
		var/mob/Player/player = src

		new /StatusEffect/UsedImmobulus(src, 20*usr:cooldownModifier)
		player.MP-=500
		player.updateMP()

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
		var/mob/Player/p = src
		p.MP-=750
		p.updateMP()
		new /StatusEffect/UsedStun(src,20*p.cooldownModifier)
		var/turf/lt = list()
		for(var/turf/T in view(7))
			lt += T
			T.overlays += image('black50.dmi',"impedimenta")
			T.slow += 1
		p.learnSpell("Impedimenta")
		src = null
		spawn(100)
			for(var/turf/T in lt)
				T.overlays -= image('black50.dmi',"impedimenta")
				if(T.slow >= 1)
					T.slow -= 1
mob/Spells/verb/Incendio()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=10,againstocclumens=1))

		var/mob/Player/p = src
		var/dmg = ((p.passives & SWORD_FIRE) ? Dmg + clothDmg : round(level * 1.15 + clothDmg/3, 1)) + p.Fire.level

		p.lastAttack = "Incendio"
		castproj(Type = /obj/projectile/BurnRoses, damage = dmg, MPreq = 10, icon_state = "fireball", name = "Incendio", element = FIRE)

mob/proc/Haha()

mob/Player/proc/BaseIcon()

	if(animagusOn) return

	if(icon_state == "Crocodile")
		transform = null

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

mob/Spells/verb/Reddikulus(mob/Player/M in view())
	set category="Spells"
	set name = "Riddikulus"
	if(canUse(src,cooldown=/StatusEffect/UsedRiddikulus,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1))
		if(M.trnsed == 1)
			usr << "That person is already transfigured."
			return
		if(!M) return
		new /StatusEffect/UsedRiddikulus(src,30*usr:cooldownModifier)
		hearers()<<"<b><span style=\"color:red;\">[usr]</span>: <span style=\"color:red;\"><font size=3>Riddikulus!</span></font>, [M].</b>"

		M.Gender = M.Gender == "Male" ? "Female" : "Male"
		M.BaseIcon()
		M.Gender = M.Gender == "Male" ? "Female" : "Male"
		flick("transfigure",src)
		usr:learnSpell("Riddikulus")
		src=null
		spawn(1200)
			if(M)
				M << "<b>You turn back to Normal</b>."
				M.BaseIcon()
				flick("transfigure",src)

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
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier,"Delicio")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Delicio!</b>"
		usr:learnSpell("Delicio")

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Delicio", lag = 0)

mob/Spells/verb/Avifors()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier,"Avifors")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:gray;\">[usr]</span>: <b>Avifors!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Avifors", lag = 0)

mob/Spells/verb/Ribbitous()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier,"Ribbitous")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b><span style=\"color:green;\"> Ribbitous!</b></span>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Ribbitous", lag = 0)

mob/Spells/verb/Carrotosi()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier,"Carrotosi")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b><span style=\"color:red;\"> Carrotosi!</b></span>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Carrotosi", lag = 0)

mob/Spells/verb/Self_To_Dragon()
	set name = "Personio Draconum"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier,"Personio Draconum")
		if(CanTrans(src))
			var/mob/Player/p = src
			p<<"You transformed yourself into a fearsome Dragon!"
			flick("transfigure",src)
			p.trnsed = 1
			p.overlays = null
			if(p.away)p.ApplyAFKOverlay()
			p.icon = 'Dragon.dmi'
mob/Spells/verb/Self_To_Mushroom()
	set name = "Personio Musashi"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier,"Personio Musashi")
		if(CanTrans(src))
			var/mob/Player/p = src
			p<<"You transformed yourself into a Mushroom!"
			flick("transfigure",src)
			p.overlays = null
			if(p.away) p.ApplyAFKOverlay()
			p.trnsed = 1
			p.learnSpell("Personio Musashi")
			switch(p.House)
				if("Gryffindor")
					p.icon = 'Red_Mushroom.dmi'
				if("Slytherin")
					p.icon = 'Green_Mushroom.dmi'
				if("Ravenclaw")
					p.icon = 'Blue_Mushroom.dmi'
				if("Hufflepuff")
					p.icon = 'Yellow_Mushroom.dmi'
				else
					p.icon = 'Yellow_Mushroom.dmi'
mob/Spells/verb/Self_To_Skeleton()
	set name = "Personio Sceletus"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier,"Personio Sceletus")
		if(CanTrans(src))
			var/mob/Player/p = src
			p<<"You transformed yourself into a Skeleton!"
			flick("transfigure",p)
			p.trnsed = 1
			p.overlays = null
			if(p.away)p.ApplyAFKOverlay()
			p.icon = 'Skeleton.dmi'
			p.learnSpell("Personio Sceletus")
mob/Spells/verb/Other_To_Human(mob/Player/M in oview())
	set name = "Transfiguro Revertio"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b><span style=\"color:green;\"> Transfiguro Revertio, [M].</b></span>"
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier)
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
	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		if(CanTrans(src))
			var/mob/Player/p = src
			flick("transfigure",p)
			p.trnsed = 0
			p.BaseIcon()
			p.ApplyOverlays()
			p<<"You reversed your transfiguration."
mob/Spells/verb/Harvesto()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier,"Harvesto")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b> Harvesto!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Harvesto", lag = 0)

mob/Spells/verb/Felinious()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier,"Felinious")
		hearers(usr.client.view, usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b> Felinious!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Felinious", lag = 0)

mob/Spells/verb/Scurries()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier,"Scurries")
		hearers(usr.client.view, usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Scurries!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Scurries", lag = 0)

mob/Spells/verb/Seatio()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier,"Seatio")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Seatio!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Seatio", lag = 0)

mob/Spells/verb/Nightus()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier,"Nightus")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Nightus!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Nightus", lag = 0)

mob/Spells/verb/Peskipixie_Pesternomae()
	set category="Spells"
	set name = "Peskipiksi Pestermi"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*usr:cooldownModifier,"Peskipiksi Pestermi")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Peskipiksi Pestermi!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Peskipiksi Pestermi", lag = 0)

mob/Spells/verb/Telendevour()
	set category="Spells"
	set popup_menu = 0
	var/mob/Player/p = usr
	if(usr.client.eye == usr)
		if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
			var/mob/Player/M = input("Which person would you like to view?") as null|anything in Players(list(src))
			if(!M) return
			if(usr.client.eye != usr) return
			if(istext(M) || M.occlumens>0 || istype(M.loc.loc, /area/ministry_of_magic))
				src<<"<b>You feel magic repelling your spell.</b>"
			else
				p.Interface.SetDarknessColor(TELENDEVOUR_COLOR, 2)
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
	else if(p.Interface.SetDarknessColor(TELENDEVOUR_COLOR))
		usr.client.eye = usr
		usr.client.perspective = EYE_PERSPECTIVE
		hearers() << "[usr]'s eyes appear again."


//AVADA//

mob/Spells/verb/Avada_Kedavra()
	set category="Spells"
	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,projectile=1))

		castproj(icon_state = "avada", name = "Avada Kedavra", damage = 10000, lag = 1)

mob/Spells/verb/Apparate()
	set category="Spells"
	var/mpCost = (usr:passives & RING_APPARATE) ? 350 : 150
	if(canUse(src,cooldown=/StatusEffect/Apparate,needwand=1,mpreq=mpCost))

		var/area/a = loc.loc
		if(a.antiApparate)
			src << errormsg("Strong charms are stopping you.")
			return

		var/turf/t

		var/obj/o = new (loc)
		o.density = 1

		var/steps = 15
		while(o.loc != src && steps > 0)
			steps--
			if(!step(o, dir) || o.loc.loc:antiApparate) break
			t = o.loc

		o.loc = null

		if(t)
			var/mob/Player/p = src
			p.Apparate(t)

mob/Spells/verb/Episky()
	set name = "Episkey"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedEpiskey,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		var/mob/Player/p = src

		var/obj/The_Dark_Mark/D = locate("DarkMark")
		if(get_dist(p, D) <= 10)
			p << errormsg("You can't use this near such evil presence.")
			return

		if(world.time - p.lastCombat <= 100)
			p << errormsg("You can't use while in combat.")
			return

		hearers()<<"<span style=\"color:red;\"><b>[p]:</span></b> <font color=aqua>Episkey!"
		new /StatusEffect/UsedEpiskey(src,15*p.cooldownModifier,"Episkey")

		p.HP = p.MHP

		p.updateHP()
		overlays+=image('attacks.dmi', icon_state = "heal")
		sleep(10)
		hearers()<<"<font color=aqua>[usr] heals \himself."
		usr.overlays-=image('attacks.dmi', icon_state = "heal")

mob/Spells/verb/Confundus(mob/Player/M in oview())
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=300,againstocclumens=1))
		new /StatusEffect/UsedAnnoying(src,20*usr:cooldownModifier)
		hearers()<<"<b><span style=\"color:red;\">[usr]:</b></span> <font color= #7CFC00>Confundus, [M]!"
		var/mob/Player/p = src
		p.MP-=300
		p.updateMP()
		p.learnSpell("Confundus")
		M << errormsg("You feel confused...")

		var/matrix/m = M.Interface.mapplane.transform
		m.Turn(90 * rand(-2, 2))
		m.Scale(1.25,1.25)
		M.client.screen += M.Interface.mapplane
		animate(M.Interface.mapplane, transform = m, time = 10)

		src=null
		spawn(200)
			if(M)
				animate(M.Interface.mapplane, transform = null, time = 10)
				sleep(11)
				if(M) M.client.screen -= M.Interface.mapplane

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
				if(istype(other, /obj/candle) || istype(other, /obj/books)) other:respawn()
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

mob/Spells/verb/Imperio(mob/Player/other in oview())
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
	if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=25,antiTeleport=1,useTimedProtection=1))

		if(IsInputOpen(src, "Portus"))
			del _input["Portus"]

		var/Input/popup = new (src, "Portus")
		var/locations = list("Hogsmeade", "Hogwarts Courtyard", "The Dark Forest Entrance")
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
				if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=25,useTimedProtection=1))
					var/obj/portkey/P1 = new(loc)
					var/obj/portkey/P2 = new(locate(39,53,18))
					P1.partner = P2
					P2.partner = P1
			if("Hogwarts Courtyard")
				if(src.loc.density)
					src << errormsg("Portus can't be used on top of something else.")
					return
				for(var/atom/A in src.loc)
					if(A.density && !ismob(A))
						src << errormsg("Portus can't be used on top of something else.")
						return
				if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=25,useTimedProtection=1))
					var/obj/target = locate("@Courtyard")
					var/obj/portkey/P1 = new(loc)
					var/obj/portkey/P2 = new(target.loc)
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
				if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=25,useTimedProtection=1))
					var/obj/target = locate("@Forest")
					var/obj/portkey/P1 = new(loc)
					var/obj/portkey/P2 = new(target.loc)
					P1.partner = P2
					P2.partner = P1
			if(null)
				return
		new /StatusEffect/UsedPortus(src,30*usr:cooldownModifier)
		hearers()<<"[usr]: <span style=\"color:aqua;\"><font size=2>Portus!</span>"
		hearers()<<"A portkey flys out of [usr]'s wand, and opens."
		var/mob/Player/p = src
		p.MP-=25
		p.updateMP()
		p.learnSpell("Portus")
mob/Spells/verb/Sense(mob/Player/M in view())
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=0))
		hearers() << "[usr]'s eyes flicker."
		usr<<errormsg("[M.name]'s Kills: [M.pkills]<br>[M.name]'s Deaths: [M.pdeaths]")
		usr:learnSpell("Sense")
mob/Spells/verb/Scan(mob/Player/M in view())
	set category = "Spells"
	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=M,mpreq=0,againstocclumens=0))
		hearers() << "[usr]'s eyes glint."
		var/mob/Player/p = src
		if((p.Dmg)>=1000)
			p<<"\n<b>[M.name]'s Max HP:</b> [M.MHP] - <b>Current HP:</b> [M.HP]<br><b>[M.name]'s Max MP:</b> [M.MMP] - <b>Current MP:</b> [M.MP]"
		else
			p<<"\n<b>[M.name]'s Max HP:</b> [M.MHP]<br><b>[M.name]'s Max MP:</b> [M.MMP]"
		p.learnSpell("Scan")

mob/Spells/verb/Inferius()
	var/mob/Player/p = src

	var/limit = 1 + round(p.Summoning.level / 10)

	if(p.Summons && p.Summons.len >= limit)
		p << errormsg("You need higher summoning level to summon more.")
		return

	hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=silver> Inferius!"

	for(var/obj/corpse/c in view(15, src))
		c.revive = 1
		animate(c, transform = null, time = 10)

		sleep(10)
		var/obj/summon/s = new  (c.loc, src)
		c.loc = null
		s.appearance = c.appearance
		s.dir = c.dir

		if(p.Summons.len >= limit) break

var/safemode = 1
mob/var/tmp
	lastproj = 0
	lastHostile = 0
mob
	proc/castproj(Type = /obj/projectile, MPreq = 0, icon = 'attacks.dmi', icon_state = "", damage = 0, name = "projectile", cd = 2, lag = 2, element = 0, Loc = loc, Dir = dir)
		if(cd && (world.time - lastproj) < cd && !inOldArena()) return
		if(!loc) return
		lastproj = world.time

		damage *= loc.loc:dmg
		damage = round(damage)

		if(damage > 0)
			lastHostile = world.time

		var/obj/projectile/P = new Type (Loc,Dir,src,icon,icon_state,damage,name,element)
		P.shoot(lag)
		. = P
		if(client)

			var/mob/Player/p = src
			p.MP -= MPreq
			p.updateMP()

			if(p.passives & SHIELD_SELFDAMAGE)
				P.selfDamage = 0

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

obj/clanpillar

	Attacked(obj/projectile/p)
		if(density)
			HP -= 1
			flick("[clan]-V", src)
			Death_Check(p.owner)

obj/brick2door
	Attacked(obj/projectile/p)
		if(density)
			Take_Hit(p)

area/var
	friendlyFire = TRUE
	timedProtection = FALSE
	selfDamage = TRUE
	scaleDamage = 0


mob/Player/var/element
	Fire
	Water
	Earth
	Ghost
	Gathering
	Taming
	Alchemy
	Slayer
	Animagus
	Summoning


element
	var
		name
		level = 0
		exp = 0
		maxExp = 2000


		const
			MAX  = 150 // soft cap

	New(n)
		name = n
		..()

	proc
		add(amount, mob/Player/parent, msg=0)

			if(level >= MAX)
				amount *= max(1 - (level - MAX) / MAX, 0.1)

				var/r = (level - MAX)*10
				if(amount > r)
					amount -= r
				else if(amount > 10)
					amount = 10

			amount = round(amount/10, 1)

			exp += amount
			if(msg)
				parent << infomsg("You gained [amount] [name] experience.")

			while(exp > maxExp)
				exp -= maxExp
				level++
				maxExp = 2000 + (level * 2500)

				var/t
				if(name in list("Water", "Fire", "Earth", "Ghost"))
					t = "element"
				else
					t = "profession"

				parent.screenAlert("[name] [t] leveled up to [level]!")

mob/Player
	var/tmp/lastCombat = 0
	proc/onDamage(dmg, mob/attacker)

		if((passives & SHIELD_MP) && MP < MMP)
			var/regen = round(dmg / 10, 1)
			MP = min(MP + regen, MMP)
			updateMP()

		if(monsterDef > 0 && ismonster(attacker))
			dmg *= 1 - monsterDef/100

		dmg = round(dmg, 1)
		HP -= dmg
		updateHP()

		for(var/obj/summon/s in Summons)
			if(!s.target)
				s.target = attacker

		return dmg


	Attacked(obj/projectile/p, isReflected=0)
		..()

		var/area/a = loc.loc
		if(p.owner)
			if(isplayer(p.owner))

				if(p.owner == src && !isReflected && (!p.selfDamage || !a.selfDamage)) return

				if(!a.friendlyFire) return

				if(a.timedProtection && (lastHostile == 0 || world.time - lastHostile > 600)) return

				if(src != p.owner)
					lastCombat = world.time
					p.owner:lastCombat = world.time


		var/dmg = p.damage

		if(p.element == FIRE)
			dmg -= round(Fire.level / 2)

		else if(p.element == WATER)
			dmg -= round(Water.level / 2)

		else if(p.element == EARTH)
			dmg -= round(Earth.level / 2)

		else if(p.element == GHOST)
			dmg -= round(Ghost.level / 2)

		if(dmg <= 0) return

		if(a.scaleDamage && p.owner != src)
			dmg = round(MHP / a.scaleDamage, 1)

		dmg = onDamage(dmg, p.owner)

		p.owner << "Your [p] does [dmg] damage to [src]."
		src << "[p.owner] hit you for [dmg] with their [p]."

		var/n = dir2angle(get_dir(src, p))
		emit(loc    = src,
			 ptype  = /obj/particle/fluid/blood,
		     amount = 4,
		     angle  = new /Random(n - 25, n + 25),
		     speed  = 2,
		     life   = new /Random(15,25))

		if(HP <= 0)
			if(isplayer(p.owner))
				p.owner:learnSpell(p.name, 300)
				Death_Check(p.owner)

				if(p.owner:passives & SWORD_HEALONKILL)
					p.owner.HP = min( round(p.owner.HP + MHP/10, 1), p.owner.MHP)
					p.owner:updateHP()

			else if(ismonster(p.owner))
				p.owner:Kill(src)

		return src

mob/Enemies
	var/canBleed = TRUE
	var/element

	Attacked(obj/projectile/p)

		if(isplayer(p.owner))

			var/dmg = p.damage + p.owner:Slayer.level

			if(p.owner:monsterDmg > 0)
				dmg *= 1 + p.owner:monsterDmg/100

			if(p.icon_state == "blood")
				dmg += round(p.damage / 10, 1)
			else if(element && p.element)
				if(element == p.element)
					dmg -= round(p.damage / 10, 1)

				else if(element == FIRE && p.element == WATER)
					dmg += round(p.damage / 2, 1)

				else if((element & (EARTH|FIRE)) && (p.element & (WATER|GHOST)))
					dmg += round(p.damage / 10, 1)

				else if((element & WATER))
					if(p.element & EARTH)
						dmg += round(p.damage / 10, 1)
					else if(p.element & FIRE)
						dmg += round(p.damage / 2, 1)

			if(canBleed)
				var/n = dir2angle(get_dir(src, p))
				emit(loc    = src,
					 ptype  = /obj/particle/fluid/blood,
				     amount = 4,
				     angle  = new /Random(n - 25, n + 25),
				     speed  = 2,
				     life   = new /Random(15,25))

			p.owner << "Your [p] does [dmg] damage to [src]."

			HP -= dmg

			var/tmp_ekills = p.owner:ekills
			Death_Check(p.owner)

			if(p.owner:ekills > tmp_ekills)

				if(p.owner:passives & SWORD_HEALONKILL)
					p.owner.HP = min( round(p.owner.HP + MHP/10, 1), p.owner.MHP)
					p.owner:updateHP()

				p.owner:learnSpell(p.name, 30)

				if(p.element != 0)

					var/exp2give  = (rand(6,14)/10)*Expg

					if(p.owner.level > src.level && !p.owner.findStatusEffect(/StatusEffect/Lamps/Farming))
						exp2give  -= exp2give  * ((p.owner.level-src.level)/150)

						if(exp2give <= 0) return

					if(p.owner:House == worldData.housecupwinner)
						exp2give  *= 1.25

					var/StatusEffect/Lamps/Exp/exp_rate   = p.owner.findStatusEffect(/StatusEffect/Lamps/Exp)

					if(exp_rate)  exp2give  *= exp_rate.rate

					if(p.element == FIRE) p.owner:Fire.add(exp2give, p.owner)

					else if(p.element == WATER) p.owner:Water.add(exp2give, p.owner)

					else if(p.element == EARTH) p.owner:Earth.add(exp2give, p.owner)

					else if(p.element == GHOST) p.owner:Ghost.add(exp2give, p.owner)
			else
				for(var/obj/summon/s in p.owner:Summons)
					if(!s.target)
						s.target = src

			..()

obj
	projectile
		layer = 4
		density = 1
		var
			velocity = 0
			const/MAX_VELOCITY = 10
			life = 20
			damage = 0
			element = 0

			steps = 0
			impact = 1
			selfDamage = 1

		Move()
			.=..()

			steps++

			for(var/atom/movable/a in loc)
				if(a == src) continue

				if(!a.density && (isplayer(a) || istype(a, /mob/Enemies)))
					Bump(a)
				else if(damage && istype(a, /obj/portkey) && a:canDamage)
					Bump(a)

		New(loc,dir,mob/mob,icon,icon_state,damage,name,element)
			..()

			src.element = element
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
				lag = max(1, lag)
				glide_size = 32/lag
				walk(src, dir, lag)

		Bump(atom/movable/a)
			var/turf/t    = isturf(a.loc) ? a.loc : a
			if(!t || istype(t, /turf/nofirezone)) return

			var/oldSystem = inOldArena()
			if(oldSystem && !istype(a, /mob)) return

			if(a.density && owner == a && !steps)
				loc = a.loc
				steps++
				return

			var/count = 0
			for(var/atom/movable/O in t)
				if(O.invisibility >= 2) continue
				if(O.reflect)
					Effect(owner)
					if(damage)
						damage = round(O.reflect * damage, 1)
						owner.Attacked(src, 1)
				else
					Effect(O)
					if(damage)
						O.Attacked(src)
				count++

			if(Impact(a, t) || (count > 1 && impact))
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

		Bomb
			var/tmp/mob/dontHit
			Effect(atom/movable/a)
				if(isobj(a))
					var/obj/o = a
					if(o.rubbleable && !o.rubble)
						o.picon = o.icon
						o.pname = o.name
						o.piconstate = o.icon_state
						o.name = "Pile of Rubble"
						o.icon = 'rubble.dmi'
						o.icon_state = ""
						o.rubble = 1
				else
					dontHit = a


			Dispose()

				for(var/mob/M in orange(1, src))
					if(M == dontHit) continue
					if(M == owner)
						var/d = damage
						damage = damage*0.5
						M.Attacked(src)
						damage = d
					else
						M.Attacked(src)

				dontHit = null

				emit(loc    = loc,
					 ptype  = /obj/particle/smoke,
				     amount = 5,
				     angle  = new /Random(1, 359),
				     speed  = 2,
				     life   = new /Random(15,25),
				     color  = null)

				..()

		Grav
			life = 15

			shoot()
				..()
				velocity+=100

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
					for(var/mob/Player/p in oview(DIST, src))
						step_towards(p, src)

					sleep(1)

				var/b = FALSE
				for(var/mob/Player/p in oview(DIST, src))
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

			shoot(lag=2)
				set waitfor = 0
				velocity = MAX_VELOCITY - lag - 1

				if(lag > 1)
					var/obj/projectile/p = locate() in get_step(src, dir)
					if(p && p.owner == owner && p.type != type)
						step(src, dir)
						sleep(lag)
						if(!loc) return
				walk(src, dir, lag)

			Attacked(obj/projectile/p)

				p.dir = turn(p.dir, pick(45, -45))
				walk(p, p.dir, MAX_VELOCITY - p.velocity)

				if(Impact(p))
					Dispose()

			Effect(atom/movable/a)

				if(isplayer(a) || istype(a, /mob/Enemies))

					owner << "Your [src] hit [a]!"

					if(!a.findStatusEffect(/StatusEffect/Potions/Stone))
						var/turf/t = get_step_away(a, src)
						if(t && !(issafezone(a.loc.loc, 0) && !issafezone(t.loc, 0)))
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

					p.nomove=1
					if(!p.trnsed)
						p.icon_state = icon_state
						p.overlays   = null

					src.owner:learnSpell(name, 10)

					spawn()
						var/t = round(time * 10)
						while(p && p.nomove && t > 0)
							t--
							sleep(1)

						if(p)
							p.nomove = 0
							if(!p.trnsed)
								p.icon_state = ""
								p.ApplyOverlays()

		BurnRoses

			Effect(atom/movable/a)
				set waitfor = 0
				if(istype(a, /obj/redroses))
					var/obj/redroses/r = a
					flick("burning", r)
					if(!r.GM_Made)
						sleep(4)
						r.Dispose()
				else if(istype(a, /obj/Torch_/Torch))
					if(a.icon_state == "torch_off")
						a:lit()

		NoImpact
			var/list/bumped
			impact = 0
			selfDamage = 0
			Impact(atom/movable/a, turf/oldloc)

				if(ismonster(a) || isplayer(a))
					loc = oldloc
					. = 0
				else
					. = ..(a, oldloc)

			Bump(atom/movable/a)

				if(a == owner)
					loc = a.loc
					return

				if(isplayer(a) || ismonster(a))
					if(bumped)
						if(a in bumped)
							loc = a.loc
							return
					else
						bumped = list()

					bumped += a

				.=..(a)

			Effect(atom/movable/a)
				if(owner && (isplayer(a) || istype(a, /mob/Enemies)))
					var/mob/m = a
					if(m.HP - damage <= 0 && prob(40))
						var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						for(var/d in dirs)
							owner.castproj(Type = /obj/projectile/NoImpact, icon_state = "chaotica", damage = round(damage/2), name = "Chaotica", cd = 0, Loc = a.loc, Dir = d, element = FIRE)

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

mob/Player/proc/OcclumensCounter()
	set waitfor = 0
	while(occlumens > 0)
		occlumens--
		sleep(10)
	src << "Your Occlumency has worn off."
	occlumens = 0

mob/var/tmp/mob/Player/arcessoing
mob/Player/var/tmp
	dance = 0
	silence
	muff
	occlumens = 0

mob/var/tmp/trnsed = 0
mob
	mouse_drag_pointer = MOUSE_DRAG_POINTER

mob/GM/verb/Remote_View(mob/M in world)
	set category="Staff"
	set popup_menu = 0
	if(M.loc == null) return
	if(istype(M.loc.loc, /area/ministry_of_magic))
		src << errormsg("You cannot use remote view on this person.")
		return
	client.eye=M
	client.perspective=EYE_PERSPECTIVE
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

obj/var
	wlable = 0

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
	var
		HP = 15
		canDamage = 1
	icon='portal.dmi'
	icon_state="portkey"
	accioable = 1
	wlable = 1
	canSave = FALSE

	New(Loc, dmg=1, iconState="random", time=300)
		set waitfor = 0
		..()

		canDamage = dmg

		if(iconState == "random")
			switch(rand(1,4))
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
		else
			icon_state = iconState
		sleep(time)
		view(src) << "The portkey collapses and closes."
		Dispose()

	Crossed(mob/Player/p)
		if(isplayer(p))
			Teleport(p)

	Move(atom/NewLoc)
		if(NewLoc.density && get_dist(loc, NewLoc) == 1) return

		.=..()

	proc/Teleport(mob/Player/M)
		if(!partner) return

		if(!(!M.client.moving && issafezone(M.loc.loc, 0)) && M.Transfer(partner.loc, 0))
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

atom/movable/var/tmp/reflect

obj/Shield
	icon='portal.dmi'
	icon_state = "shield"
	layer = 5
	density = 1

mob/Player
	var/lastAttack = "Inflamari"
	verb/Attack()
		var/mob/m = src
		switch(lastAttack)
			if("Glacius")
				m:Glacius()
			if("Inflamari")
				m:Inflamari()
			if("Waddiwasi")
				m:Waddiwasi()
			if("Tremorio")
				m:Tremorio()
			if("Aqua Eructo")
				m:Aqua_Eructo()
			if("Chaotica")
				m:Chaotica()
			if("Sanguinis Iactus")
				m:Sanguinis_Iactus()
			if("Incendio")
				m:Incendio()
			if("Bombarda")
				m:Bombarda()


mob/Player/var/cooldownModifier = 1
mob/Player/var/tmp/passives = 0