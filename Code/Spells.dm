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

obj
	Click()
		var/mob/Player/p = usr

		var/d = get_dist(usr, src)
		if(accioable && d > 1 && d <= 15)

			if(/mob/Spells/verb/Accio in p.verbs)
				call(p, /mob/Spells/verb/Accio)(src)


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
		var/turf/origLoc = M.loc
		var/turf/t = M.loc

		var/obj/Shadow/s = new
		s.pixel_y -= 16
		M.vis_contents += s

		M.pixel_y += 16

		while(M.loc == t && t != dest)
			t = get_step_towards(M, dest)
			if(!t) break
			M.loc = t
			sleep(2)

		M.pixel_y -= 16
		M.vis_contents -= s

		if(!istype(M,/obj/items))
			M.backToPos(origLoc)

mob/Spells/verb/Accio_Maxima()
	set category = "Spells"
	set waitfor = 0
	if(canUse(src,cooldown=/StatusEffect/UsedAccio,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		var/mob/Player/p = src
		new /StatusEffect/UsedAccio(src,20*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, "Accio Maxima")
		hearers(client.view, p)<< " <b>[p]:<i><font color=aqua> Accio Maxima!</i>"
		p.learnSpell("Accio Maxima")

		for(var/obj/items/i in orange(10, p))
			if(!i.accioable && i.owner != ckey) continue
			i.walkTo(src, 1)



obj/items/proc/walkTo(atom/movable/a, pickup=0)
	set waitfor = 0
	while(a && loc && a.loc && a.loc != loc)
		loc = get_step_towards(src, a.loc)
		sleep(1)
	if(pickup && fetchable)
		owner = null
		if(antiTheft)
			antiTheft = 0
			filters = null
		Move(a)

proc/Eat_Slugs(mob/Player/p, var/n)

	var/mpCost = 100
	var/spellName = "Eat Slugs"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(n)
		var/mob/Player/M
		var/list/people = hearers(p.client.view)&Players
		for(var/mob/Player/i in people)
			if(findtext(n, i.name) && length(i.name) + 2 >= length(n))
				M = i

		if(M)
			if(p.prevname)
				hearers() << "<span style=\"font-size:2;\"><font color=red><b><font color=red>[usr]</span></b> :<font color=white> Eat Slugs, [M.name]!"
			else
				hearers() << "<span style=\"font-size:2;\"><font color=red><b>[p.Tag]<font color=red>[usr]</span> [p.GMTag]</b>:<font color=white> Eat Slugs, [M.name]!"

			M << errormsg("[usr] has casted the slug vomiting curse on you.")

			spawn()
				var/slugs = rand(4,12)
				while(M && slugs > 0 && M.MP > 0)
					M.MP -= rand(20,60) * round(M.level/100)
					new/mob/Enemies/Summoned/Slug(M.loc)
					if(M.key)
						if(M.MP < 0)
							M.MP = 0
							M.updateMP()
							M << errormsg("You feel drained from the slug vomiting curse.")
							break
						else
							M.updateMP()
					slugs--
					sleep(rand(20,90))


		new /StatusEffect/Summoned(p,10*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)
		p.MP = max(p.MP - mpCost, 0)
		p.updateMP()

		p.learnSpell(spellName)

		return TRUE

mob/Spells/verb/Eat_Slugs()
	set category = "Spells"
//	set hidden = 1

	var/mob/Player/p = src
	var/mpCost = 100
	var/spellName = "Eat Slugs"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))

		castproj(MPreq = 0, Type = /obj/projectile/Slugs, icon_state = "slug", name = "Slug", lag = 1, learn=0)

		new /StatusEffect/Summoned(src,10*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)
		p.MP = max(p.MP - mpCost, 0)
		p.updateMP()

		p.learnSpell(spellName)

mob/Spells/verb/Disperse()
	set category = "Spells"
	set hidden = 1

	if(canUse(src,cooldown=/StatusEffect/UsedDisperse,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
		new /StatusEffect/UsedDisperse(src,10*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, "Disperse")
		usr:learnSpell("Disperse")
		for(var/obj/smokeeffect/S in oview(client.view))
			del(S)
		for(var/turf/T in oview())
			if(T.specialtype & SWAMP)
				T.slow -= 1
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
		var/text = 0
		for(var/obj/herb/h in oview(15, src))
			if(h.wait) continue

			text = 1

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

		if(text)
			hearers()<<"<b><span style=\"color:red;\">[usr]:</span> Herbivicus."

		usr:learnSpell("Herbivicus")

mob/Spells/verb/Protego()
	set category = "Spells"
	var/mob/Player/p = src

	var/mpCost = 100
	var/spellName = "Protego"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(!p.reflect)
		if(canUse(src,cooldown=/StatusEffect/UsedProtego,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))
			new /StatusEffect/UsedProtego(src,40*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)
			p.overlays += /obj/Shield
			hearers()<< "<b><span style=\"color:red;\">[usr]</b></span>: PROTEGO!"
			p << "You shield yourself magically"
			p.reflect = 0.5
			p.learnSpell(spellName)
			p.MP -= mpCost
			p.updateMP()
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

	var/mob/Player/p = src
	var/mpCost = 300
	var/spellName = "Expelliarmus"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=mpCost,againstocclumens=1))

		if(!M.key) // practice dummy
			hearers()<<"<span style=\"color:red;\"><b>[usr]</b></span>: <font color=white>Expelliarmus!"
			hearers()<<"<b>[M] loses \his wand.</b>"
			new /StatusEffect/UsedAnnoying(src,30*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, spellName)

			p.MP -= mpCost
			p.updateMP()

			p.learnSpell(spellName)
			return

		var/obj/items/wearable/wands/W = locate(/obj/items/wearable/wands) in M:Lwearing
		if(W)
			W.Equip(M,1)
			hearers()<<"<span style=\"color:red;\"><b>[usr]</b></span>: <font color=white>Expelliarmus!"
			hearers()<<"<b>[M] loses \his wand.</b>"
			new /StatusEffect/UsedAnnoying(src,30*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, spellName)

			p.MP -= mpCost
			p.updateMP()

			p.learnSpell(spellName)
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
		new /StatusEffect/UsedEvanesca(src,10*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, "Eparo Evanesca")
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
				new /StatusEffect/Decloaked(M,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier)

mob/Spells/verb/Imitatus(mob/Player/M in view(), T as text)
	set category = "Spells"
	if(!isplayer(M)) return
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

		new /StatusEffect/UsedClanAbilities(src, 600, "Morsmordre")
		D = new (locate(src.x,src.y+1,src.z))
		D.density=0
		D.owner = ckey
		D.FlickState("m-black",8,'Effects.dmi')
		hearers() <<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=green>MORSMORDRE!"
		Players<<"The sky darkens as a sneering skull appears in the clouds with a snake slithering from its mouth."

mob/Spells/verb/Repellium()
	set category = "Spells"

	var/mob/Player/p = src
	var/mpCost = 100
	var/spellName = "Repellium"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedRepel,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))
		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=white>Repellium!"
		p.MP -= mpCost
		p.updateMP()
		light(src, 3, 300, "light")
		p.learnSpell(spellName)
		new /StatusEffect/UsedRepel(src, 90*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)
		new /StatusEffect/DisableProjectiles(src, 30)
		var/time = 75
		while(time > 0)
			for(var/mob/Enemies/D in ohearers(3, src))
				step_away(D, src)
			time--
			sleep(4)

obj/squareLight
	icon             = 'lights.dmi'
	icon_state       = "light"
	mouse_opacity    = 0
	appearance_flags = PIXEL_SCALE
	layer            = 8

proc/light(atom/movable/a, range=3, ticks=100, state = "light", color)
	var/obj/squareLight/o = new
	o.icon_state = state
	o.transform *= range * 2 + 1
	if(color) o.color = color

	a.vis_contents += o
	if(ticks != 0)
		spawn(ticks)
			if(a) a.vis_contents -= o

mob/Spells/verb/Lumos()
	set category = "Spells"

	var/mob/Player/p = src
	var/mpCost = 100
	var/spellName = "Lumos"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedLumos,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))
		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=white>Lumos!"
		p.MP -= mpCost
		p.updateMP()

		p.learnSpell(spellName)
		new /StatusEffect/UsedLumos(src, 60*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)

		var/obj/light/l = new(loc)

		animate(l, transform = matrix() * (1.6 + tier / 10), time = 10, loop = -1)
		animate(   transform = matrix() * (1.5 + tier / 10), time = 10)

		p.addFollower(l)

		src = null
		spawn(600)
			if(p && l)
				p.removeFollower(l)
				l.loc = null

mob/Spells/verb/Lumos_Maxima()
	set category = "Spells"

	var/mob/Player/p = src
	var/mpCost = 300
	var/spellName = "Lumos Maxima"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedLumos,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))
		hearers()<<"<b><span style=\"color:red;\">[p]</b></span>: <b><font size=3><font color=white>Lumos Maxima!"

		new /StatusEffect/UsedLumos(src, 90*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)

		castproj(MPreq = mpCost, Type = /obj/projectile/Lumos, icon_state = "light", name = spellName, lag = 2)

mob/Spells/verb/Aggravate()
	set category = "Spells"
	if(!loc) return

	var/mob/Player/p = src
	var/mpCost = 150
	var/spellName = "Aggravate"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedAggro,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))
		hearers()<<"<b><span style=\"color:red;\">[p]</b></span>: <b><font size=3><font color=white>Aggravate!"
		p.MP -= mpCost

		new /StatusEffect/UsedAggro(src, 20*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)

		p.monsterDef += 10
		p.HP = min(p.MHP, p.HP + 500)
		p.updateHPMP()

		p.learnSpell(spellName)

	//	var/area/pArea = loc.loc
		light(src, range=14, ticks=10, state = "red")
		for(var/mob/Enemies/e in ohearers(14))
		//	var/area/eArea = loc.loc

		//	if(eArea != pArea) continue
			if(e.state == 0)   continue

			e.target = src
			e.ChangeState(e.HOSTILE)

		spawn(100)
			p.monsterDef -= 10
			p.HP = min(p.MHP, p.HP + 500)
			p.updateHP()


mob/Spells/verb/Basilio()
	set category = "Spells"

	var/mob/Player/p = src
	var/mpCost = 200
	var/spellName = "Basilio"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=0,inhogwarts=0,target=null,mpreq=mpCost,againstocclumens=1))
		if(p.summons + 1 >= 1 + p.extraLimit + round(p.Summoning.level / 10))
			p << errormsg("You need higher summoning level to summon more.")
			return

		new /StatusEffect/Summoned(src,30*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)

		p.MP -= mpCost
		p.updateMP()

		p.learnSpell(spellName)

		if(SWORD_SNAKE in p.passives)
			hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=4><font color=#FF8C00> Basilio!"
			var/obj/summon/akalla/s = new  (get_step(p, p.dir), src, "Basilio", 1, tier)
			s.FlickState("m-black",8,'Effects.dmi')
		else
			hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=green> Basilio!"
			var/obj/summon/basilisk/s = new  (get_step(p, p.dir), src, "Basilio", 0.5, tier)
			s.FlickState("m-black",8,'Effects.dmi')

mob/Spells/verb/Serpensortia()
	set category = "Spells"

	var/mob/Player/p = src
	var/mpCost = 100
	var/spellName = "Serpensortia"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=0,inhogwarts=0,target=null,mpreq=mpCost,againstocclumens=1))
		if(p.summons >= 1 + p.extraLimit + round(p.Summoning.level / 10))
			p << errormsg("You need higher summoning level to summon more.")
			return

		new /StatusEffect/Summoned(src,15*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)

		p.MP -= mpCost
		p.updateMP()

		if(SWORD_SNAKE in p.passives)
			hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=4 color=#FF8C00>Serpensortia!"
			var/obj/summon/demon_snake/s = new  (loc, src, "Serpensortia", 1, tier)
			s.FlickState("m-black",8,'Effects.dmi')
		else
			hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3 color=green>Serpensortia!"
			var/obj/summon/snake/s = new  (loc, src, "Serpensortia", 0.5, tier)
			s.FlickState("m-black",8,'Effects.dmi')

		p.learnSpell(spellName)

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

	var/mob/Player/p = src
	var/mpCost = 100
	var/spellName = "Shelleh"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedShelleh,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))
		new /StatusEffect/UsedShelleh(src,60*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, spellName)
		hearers()<<"<b><span style=\"color:red;\">[usr]:</span> <font color=white>Shelleh."

		p.MP -= mpCost
		p.updateMP()

		p.learnSpell(spellName)

		for(var/turf/t in oview(rand(1,3)))
			if(t.density) continue
			if(prob(40))  continue
			if(t == loc)  continue
			new /obj/egg (t)
			sleep(1)

mob/Spells/verb/Ferula()
	set category = "Spells"

	var/mob/Player/p = src
	var/mpCost = 100
	var/spellName = "Ferula"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=100,againstocclumens=1))

		if(p.summons >= 1 + p.extraLimit + round(p.Summoning.level / 10))
			p << errormsg("You need higher summoning level to summon more.")
			return

		new /StatusEffect/Summoned(src, 15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, spellName)

		p.MP -= mpCost
		p.updateMP()

		if(SWORD_NURSE in p.passives)
			hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=4 color=#FF8C00>Ferula!</font>"
			var/obj/summon/nurse/s = new  (get_step(p, p.dir), src, "Ferula", 0, tier + 400)
			flick("summon", s)
	//		s.FlickState("summon",8,'NPCs.dmi')
		else
			hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=aqua> Ferula!"
			var/obj/summon/nurse/s = new  (get_step(p, p.dir), src, "Ferula", 0, tier)
			flick("summon", s)
	//		s.FlickState("summon",8,'NPCs.dmi')

		usr:learnSpell(spellName)

mob/Spells/verb/Avis()
	set category = "Spells"

	var/mob/Player/p = src
	var/mpCost = 100
	var/spellName = "Avis"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))
		if(p.summons >= 1 + p.extraLimit + round(p.Summoning.level / 10))
			p << errormsg("You need higher summoning level to summon more.")
			return

		new /StatusEffect/Summoned(src,15*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)

		p.MP -= mpCost
		p.updateMP()

		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=yellow> Avis!"
		hearers()<<"A Phoenix emerges."
		var/obj/summon/phoenix/s = new  (get_step(p, p.dir), src, "Avis", 0.5, tier)
		s.FlickState("m-black",8,'Effects.dmi')
		p.learnSpell(spellName)

mob/Spells/verb/Crapus_Sticketh()
	set category = "Spells"

	var/mob/Player/p = src
	var/mpCost = 100
	var/spellName = "Crapus Sticketh"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=0,inhogwarts=0,useTimedProtection=1,target=null,mpreq=mpCost,againstocclumens=1))
		if(p.summons >= 1 + p.extraLimit + round(p.Summoning.level / 10))
			p << errormsg("You need higher summoning level to summon more.")
			return

		new /StatusEffect/Summoned(src,15*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)

		p.MP -= mpCost
		p.updateMP()

		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=green> Crapus...Sticketh!!"
		hearers()<<"A stick figure appears."
		var/obj/summon/stickman/s = new  (loc, src, "Crapus-Sticketh", 0.5)
		s.FlickState("m-black",8,'Effects.dmi')

		p.learnSpell(spellName)

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

		var/mpCost = 300
		var/spellName = "Permoveo"

		var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
		var/tier = round(log(10, uses)) - 1
		mpCost = round(mpCost * (100 - tier*2) / 100, 1)

		if(canUse(src,cooldown=/StatusEffect/Permoveo,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))
			var/mob/Enemies/selmonster = input("Which monster do you cast Permoveo on?","Permoveo") as null|anything in enemies
			if(!selmonster) return
			if(!(selmonster in view())) return
			if(p.removeoMob) return
			if(p.level < selmonster.level)
				src << errormsg("The monster is level [selmonster.level]. You need to be a higher level.")
				return
			new /StatusEffect/Permoveo(src, max(400-(usr.level/2), 30)*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)

			hearers() << "[usr]: <i>Permoveo!</i>"
			if(selmonster.removeoMob)
				var/mob/B = selmonster.removeoMob
				B << "[src] took possession of the monster you were controlling."
				B.client.eye=B
				B.client.perspective=MOB_PERSPECTIVE
				B.removeoMob = null
			p.MP -= mpCost
			p.updateMP()

			p.removeoMob = selmonster
			client.eye = selmonster
			client.perspective = EYE_PERSPECTIVE
			selmonster.removeoMob = src
			selmonster.ChangeState(selmonster.CONTROLLED)
			selmonster.target = null
			p.learnSpell(spellName)

mob/Spells/verb/Incarcerous()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 50
	var/spellName = "Incarcerous"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedStun,needwand=1,inarena=1,insafezone=1,inhogwarts=1,mpreq=mpCost,againstocclumens=1))
		new /StatusEffect/UsedStun(src,10*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, spellName)
		hearers(usr.client.view, usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b> Incarcerous!</b>"

		castproj(MPreq = mpCost, Type = /obj/projectile/Bind { time = 3 }, icon_state = "bind", name = "Incarcerous", lag = 1)

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

	var/mob/Player/p = src
	var/mpCost = 400
	var/spellName = "Reducto"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedReducto,needwand=1,inarena=0,insafezone=1,inhogwarts=1,mpreq=mpCost,againstocclumens=1))
		if(flying)
			src << "<b><span style=\"color:red;\">Error:</b></span> You can't cast this spell while flying."
			return
		if(p.GMFrozen) return

		new /StatusEffect/UsedReducto(src,15*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)

		p.MP -= mpCost
		p.updateMP()

		hearers(client.view, src) << "<B><span style=\"color:red;\">[src]:</span><font color=white> <I>Reducto!</I>"
		if(p.nomove < 2)
			p.nomove = 0
			p.RemoveEffect("stone")
		if(!trnsed) p.ApplyOverlays()
		FlickState("apparate",8,'Effects.dmi')
		p.learnSpell(spellName)

mob/Spells/verb/Reparo()
	set category = "Spells"

	var/mob/Player/p = src
	var/mpCost = 150
	var/spellName = "Reparo"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedReparo,needwand=1,insafezone=1,inhogwarts=1,mpreq=mpCost))
		new /StatusEffect/UsedReparo(src,10*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)
		hearers(client.view,src) << "[src]: <b>Reparo!</b>"
		p.MP -= mpCost
		p.updateMP()
		p.learnSpell(spellName)

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
			o.density = 1

mob/Spells/verb/Bombarda()
	set category = "Spells"

	var/mob/Player/p = src
	var/mpCost = 100
	var/spellName = "Bombarda"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,mpreq=mpCost,projectile=1))
		p.lastAttack = "Bombarda"
		var/dmg = p.Dmg + p.clothDmg
		castproj(MPreq = mpCost, Type = /obj/projectile/Bomb, icon_state = "bombarda", damage = dmg * ((100 + tier*2) / 100), name = spellName, cd=3)

mob/Spells/verb/Petreficus_Totalus()
	set category="Spells"
	set name = "Petrificus Totalus"

	var/mob/Player/p = src
	var/mpCost = 50
	var/spellName = "Petrificus Totalus"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedStun,needwand=1,inarena=1,insafezone=1,inhogwarts=1,mpreq=mpCost,againstocclumens=1))
		new /StatusEffect/UsedStun(src,10*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, spellName)
		hearers(usr.client.view, usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b> Petrificus Totalus!</b>"

		castproj(MPreq = mpCost, Type = /obj/projectile/Bind { min_time = 1; max_time = 10 }, icon_state = "stone", name = spellName, lag = 1)

mob
	Player/var/tmp/antifigura = 0
	proc
		CanTrans(mob/Player/p)
			if(p.noOverlays)
				src << errormsg("You can't transfigure [p].")
				return 0
			if(p.antifigura > 0)
				p.antifigura--
				src << errormsg("Your spell failed, [p] is protected from transfiguring spells.")
				if(p.antifigura==0)
					p << errormsg("You were forced to release the shield around your body.")
					new /StatusEffect/UsedTransfiguration(p,15*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier)
				return 0
			return 1

mob/Spells/verb/Antifigura()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 50
	var/spellName = "Antifigura"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(p.antifigura > 0)
		new /StatusEffect/UsedTransfiguration(usr,15*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)
		src << infomsg("You release the shield around your body.")
		p.antifigura = 0
	else if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))
		hearers() << "<b><span style=\"color:red;\">[usr]</span></b>: <span style=\"color:white;\"><i>Antifigura!</i></span>"
		p.antifigura = max(round((p.MMP) / rand(500,1500)), 1)
		p.MP -= mpCost
		p.updateMP()
		usr:learnSpell(spellName)


mob/Spells/verb/Chaotica()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 30
	var/spellName = "Chaotica"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	var/dmg = ((SWORD_FIRE in p.passives) ? (Dmg + clothDmg)*1.1 : round(level * 1.15 + clothDmg/3, 1)) + p.Fire.level

	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1,projectile=1))
		p.lastAttack = "Chaotica"
		castproj(MPreq = mpCost, Type = /obj/projectile/NoImpact, icon_state = "chaotica", damage = dmg * ((100 + tier*2) / 100), name = spellName, element = FIRE)
mob/Spells/verb/Aqua_Eructo()
	set category="Spells"

	if(world.time - lastproj < 2) return

	var/mob/Player/p = src
	var/mpCost = 5 + p.MHP * 0.01
	var/spellName = "Aqua Eructo"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,projectile=1))

		p.onDamage(mpCost, p)
		Death_Check()

		var/dmg = round(p.Def / 3 + p.Water.level, 1)

		usr:lastAttack = "Aqua Eructo"
		castproj(icon_state = "aqua", damage = dmg * ((100 + tier*2) / 100), name = spellName, element = WATER)


mob/Spells/verb/Sanguinis_Iactus()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 10
	var/spellName = "Blood"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1,projectile=1))

		usr:lastAttack = "Sanguinis Iactus"
		castproj(Type = /obj/projectile/Blood, MPreq = mpCost, icon_state = "blood", element = COW, damage = (usr.Dmg + clothDmg) * ((100 + tier*2) / 100), name = spellName)

mob/Spells/verb/Illusio()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 600
	var/spellName = "Illusio"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedIllusio,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1,projectile=1))
		new /StatusEffect/UsedIllusio (src,30*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, spellName)

		p.Blur()
		p.learnSpell(spellName)


mob/Player
	proc/Blur()
		set waitfor = 0

		var/offsetX = rand(-1, 1)
		var/offsetY = rand(-1, 1)

		var/const/RANGE = 1

		animate(src, alpha = 0, time = 4)
		sleep(4)

		alpha = 255

		var/list/blurs = list()

		var/obj/standIn = new (loc)

		addFollower(standIn)

		var/obj/o = new
		o.appearance = appearance
		o.alpha = 150

		if(prob(35))
			o.pixel_x = 128 * pick(1, -1)
			o.pixel_y = 128 * pick(1, -1)
		else if(prob(45))
			o.pixel_x = 128 * pick(1, -1)
		else
			o.pixel_y = 128 * pick(1, -1)

		blurs += o.appearance

		for(var/i = -RANGE + offsetX to RANGE + offsetX)
			for(var/j = -RANGE + offsetY to RANGE + offsetY)
				if(i == 0 && j == 0) continue

				if(prob(30)) continue

				o.pixel_x = i*32
				o.pixel_y = j*32

				if(prob(10))
					o.pixel_x *= 2

				if(prob(10))
					o.pixel_y *= 2

				if(prob(50)) o.alpha = rand(120, 200)
				else o.alpha = 255

				blurs += o.appearance

		standIn.overlays += blurs

		standIn.alpha = 0
		animate(standIn, alpha = 255, time = 4)

		alpha = 0
		animate(src, alpha = 255, time = 4)

		sleep(100)

		animate(standIn, alpha = 0, time = 4)
		sleep(4)

		removeFollower(standIn)
		standIn.loc = null


mob/Spells/verb/Gravitate()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 300
	var/spellName = "Gravitate"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=null,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1,projectile=1))


		castproj(Type = /obj/projectile/Grav, MPreq = mpCost, icon_state = "grav", name = spellName)

mob/Spells/verb/Inflamari()
	set category="Spells"

	var/mob/Player/p = src
	var/spellName = "Inflamari"
	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1

	var/dmg
	if(SWORD_FIRE in p.passives)
		dmg = (Dmg + clothDmg)*1.1
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
		castproj(icon_state = "fireball", damage = (dmg + p.Fire.level) * ((100 + tier*2)/ 100), name = spellName, element = FIRE)
mob/Spells/verb/Glacius()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 20
	var/spellName = "Glacius"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1,projectile=1))
		usr:lastAttack = "Glacius"
		castproj(MPreq = mpCost, icon_state = "iceball", damage = (usr.Dmg + clothDmg + usr:Water.level) * ((100 + tier*2) / 100), name = spellName, element = WATER)
mob/Spells/verb/Waddiwasi()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 20
	var/spellName = "Waddiwasi"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1,projectile=1))
		usr:lastAttack = "Waddiwasi"
		castproj(MPreq = mpCost, icon_state = "gum", damage = (usr.Dmg + clothDmg + usr:Ghost.level) * ((100 + tier*2) / 100), name = spellName, element = GHOST)

mob/Spells/verb/Gladius()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 30
	var/spellName = "Gladius"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1,projectile=1))
		p.lastAttack = "Gladius"
		castproj(MPreq = mpCost, Type = /obj/projectile/NoImpact/Dir, icon_state = "sword", damage = (usr.Dmg + clothDmg + usr:Ghost.level) * ((100 + tier*2) / 100), name = spellName, element = GHOST)

mob/Spells/verb/Tremorio()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 10
	var/spellName = "Tremorio"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1,projectile=1))
		usr:lastAttack = "Tremorio"
		castproj(MPreq = mpCost, icon_state = "quake", damage = (usr.Dmg + clothDmg + usr:Earth.level) * ((100 + tier*2) / 100), name = spellName, element = EARTH)

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
			new /StatusEffect/UsedArcesso(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, "Arcesso")
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
				new /StatusEffect/UsedArcesso(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, "Arcesso")
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
	var/mpCost = 300
	var/spellName = "Flagrate"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedFlagrate,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))
		if(p.mute==0)
			if(str_count(message,"\n") > 20)
				p << errormsg("Flagrate can only use up to 20 lines of text.")
			else
				message = copytext(message,1,500)
				new /StatusEffect/UsedFlagrate(src,10*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)
				hearers(client.view)<<"<span style=\"color:red;\"><b>[usr]:</span> Flagrate!"
				sleep(10)
				hearers(client.view)<<"<span style=\"color:red;\"><b>[usr]:</span> <span style=\"color:#FF9933;\"><font size=3><font face='Comic Sans MS'> [html_encode(message)]</span>"
				p.MP-=mpCost
				p.updateMP()
				p.learnSpell(spellName)
		else
			alert("You cannot cast this while muted.")
mob/Spells/verb/Langlock(mob/Player/M in oview())
	set category = "Spells"

	var/mob/Player/p = src
	var/mpCost = 600
	var/spellName = "Langlock"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=mpCost,againstocclumens=1))
		if(!M.silence)
			M.silence=1
			p.MP -= mpCost
			p.updateMP()
			hearers()<<"[usr] flicks \his wand towards [M] and mutters, 'Langlock'"
			hearers() << "<b>[M]'s tongue has been stuck to the roof of \his mouth. They are unable to speak.</b>"
			p.learnSpell(spellName)
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

	var/mob/Player/p = src
	var/mpCost = 450
	var/spellName = "Incindia"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedIncindia,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1,projectile=1))
		hearers()<<"[src] raises \his wand into the air. <font color=red><b><i>INCINDIA!</b></i>"
		p.MP-=mpCost
		p.updateMP()
		new /StatusEffect/UsedIncindia(src,15*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)
		var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		var/damage = round((p.Dmg + p.clothDmg + p.Fire.level) * 0.75)
		p.learnSpell(spellName)
		for(var/d in dirs)
			castproj(icon_state = "incindia", damage = damage * ((100 + tier*2) / 100), name = "Incindia", cd = 0, lag = 1, element = FIRE, Dir=d, canClone=0)
mob/Spells/verb/Replacio(mob/Player/M in oview())
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 500
	var/spellName = "Replacio"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=mpCost,againstocclumens=1))
		if(issafezone(M.loc.loc, 0) && !issafezone(loc.loc, 0))
			src << "<b>[M] is inside a safezone.</b>"
			return
		hearers()<<"<b><span style=\"color:red;\">[usr]:</b></span> <font color=blue><B> <i>Replacio Duo.</i></B>"
		var/startloc = usr.loc
		M.FlickState("Orb",12,'Effects.dmi')
		usr.FlickState("Orb",12,'Effects.dmi')
		p.Transfer(M.loc)
		M.Transfer(startloc)
		usr.FlickState("Orb",12,'Effects.dmi')
		M.FlickState("Orb",12,'Effects.dmi')
		hearers()<<"[usr] trades places with [M]"
		p.MP-=mpCost
		p.updateMP()
		p.learnSpell(spellName)
mob/Spells/verb/Occlumency()
	set category = "Spells"

	var/mob/Player/p = src
	var/spellName = "Occlumency"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1

	if(SHIELD_SPY in p.passives) tier++

	if(p.occlumens == 0)
		if(canUse(src,cooldown=/StatusEffect/UsedOcclumency,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=1,againstocclumens=1))

			new /StatusEffect/UsedOcclumency(src,5*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)

			for(var/mob/Player/c in Players)
				if(c == p) continue
				if(c.client.eye == p && c.Interface.SetDarknessColor(TELENDEVOUR_COLOR))

					var/otherUses = ("Telendevour" in c.SpellUses) ? c.SpellUses["Telendevour"] : 1
					var/otherTier = round(log(10, otherUses)) - 1

					if(otherTier <= tier)
						c << errormsg("Your Telendevour wears off.")
						c.client.eye = c

			hearers() << "<b><span style=\"color:red;\">[usr]</span></b>: <span style=\"color:white;\"><i>Occlumens!</i></span>"
			p << "You can no longer be viewed by Telendevour."
			p.occlumens = p.MMP
			p.OcclumensCounter()
			p.learnSpell(spellName)
	else if(p.occlumens > 0)
		src << "You release the barriers around your mind."
		p.occlumens = -1

mob/Spells/verb/Obliviate(mob/Player/M in oview())
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 700
	var/spellName = "Obliviate"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=mpCost,againstocclumens=0))
		hearers()<<"<b><span style=\"color:red;\">[usr]:<font color=green> Obliviate!</b></span>"
		if(prob(15 - tier*2))
			p << output(null,"output")
			hearers()<<"[usr]'s spell has backfired."
			if(prob(70)) p.learnSpell("Obliviate", -1)
		else
			if(!M.admin || p == M) M << output(null,"output")
			hearers()<<"[usr] wiped [M]'s memory!"
			p.learnSpell(spellName)
		p.MP-=mpCost
		new /StatusEffect/UsedAnnoying(src,30*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)
		p.updateMP()
mob/Spells/verb/Tarantallegra(mob/Player/M in view())
	set category = "Spells"

	var/mob/Player/p = src
	var/mpCost = 200
	var/spellName = "Tarantallegra"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=mpCost,againstocclumens=1))
		if(M.dance) return
		hearers()<<"<b>[usr]:</B><font color=green> <i>Tarantallegra!</i>"
		new /StatusEffect/UsedAnnoying(src,30*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, spellName)
		p.MP-=mpCost
		p.updateMP()
		if(key != "Murrawhip")
			M.dance=1
		p.learnSpell(spellName)
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

	var/mob/Player/p = src
	var/mpCost = 500
	var/spellName = "Immobulus"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedImmobulus,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))
		new /StatusEffect/UsedImmobulus(src, 20*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, spellName)
		p.MP-=mpCost
		p.updateMP()

		p.learnSpell(spellName)

		hearers()<<"<b>[usr]:</b> <font color=blue>Immobulus!"
		hearers()<<"A sudden wave of energy emits from [usr]'s wand, immobilizing every projectile in sight."

		var/const/RANGE = 6
		var/const/TICKS = 80
		var/const/STEP  = 3

		var/obj/o = new(loc)
		o.alpha = 0
		o.layer = 6
		light(o, range=RANGE, ticks=TICKS, state = "rand")

		if(p.holster && p.holster.selectedColors)
			o.color = pick(p.holster.selectedColors)
		else if(p.wand && p.wand.projColor)
			o.color = p.wand.projColor

		animate(o, alpha = 255, time = 10)

		for(var/time = 0 to TICKS step STEP)
			for(var/obj/projectile/proj in oview(RANGE, o))
				if(proj.overlays.len)	continue

				proj.overlays += image('attacks.dmi', icon_state = "immobulus")
				proj.velocity = 0
				walk(proj, 0)

			sleep(STEP)

		o.Dispose()

mob/Spells/verb/Impedimenta()
	set category = "Spells"

	var/mob/Player/p = src
	var/mpCost = 750
	var/spellName = "Impedimenta"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedStun,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))
		hearers()<<"<b>[usr]:</b> <font color=red>Impedimenta!"
		hearers()<<"A sharp blast of energy emits from [usr]'s wand, slowing down everything in the area."
		p.MP-=mpCost
		p.updateMP()
		new /StatusEffect/UsedStun(src,20*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)
		var/turf/lt = list()
		for(var/turf/T in view(7))
			lt += T
			T.overlays += image('black50.dmi',"impedimenta")
			T.slow += 1
		p.learnSpell(spellName)
		src = null
		spawn(100)
			for(var/turf/T in lt)
				T.overlays -= image('black50.dmi',"impedimenta")
				if(T.slow >= 1)
					T.slow -= 1
mob/Spells/verb/Incendio()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 20
	var/spellName = "Incendio"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=null,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))

		var/dmg = ((SWORD_FIRE in p.passives) ? (Dmg + clothDmg)*1.2 : round(level * 1.15 + clothDmg/3, 1)) + p.Fire.level

		p.lastAttack = "Incendio"
		castproj(Type = /obj/projectile/BurnRoses, damage = dmg * ((100 + tier*2) / 100), MPreq = mpCost, icon_state = "fireball", name = spellName, element = FIRE)

mob/Player/proc/BaseIcon()

	if(noOverlays) return

	if(icon_state == "Crocodile")
		transform = null
		icon_state = null

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
			icon ='MaleGryffindor.dmi'
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
		new /StatusEffect/UsedRiddikulus(src,30*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, "Riddikulus")
		hearers()<<"<b><span style=\"color:red;\">[usr]</span>: <span style=\"color:red;\"><font size=3>Riddikulus!</span></font>, [M].</b>"

		M.Gender = M.Gender == "Male" ? "Female" : "Male"
		M.BaseIcon()
		M.Gender = M.Gender == "Male" ? "Female" : "Male"
		flick("transfigure",M)
		usr:learnSpell("Riddikulus")
		src=null
		spawn(1200)
			if(M)
				M << "<b>You turn back to Normal</b>."
				M.BaseIcon()
				flick("transfigure",M)

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
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier,"Delicio")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Delicio!</b>"
		usr:learnSpell("Delicio")

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Delicio", lag = 0)

mob/Spells/verb/Avifors()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier,"Avifors")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:gray;\">[usr]</span>: <b>Avifors!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Avifors", lag = 0)

mob/Spells/verb/Ribbitous()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier,"Ribbitous")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b><span style=\"color:green;\"> Ribbitous!</b></span>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Ribbitous", lag = 0)

mob/Spells/verb/Carrotosi()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier,"Carrotosi")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b><span style=\"color:red;\"> Carrotosi!</b></span>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Carrotosi", lag = 0)

mob/Spells/verb/Self_To_Dragon()
	set name = "Personio Draconum"
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=1))
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier,"Personio Draconum")
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
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier,"Personio Musashi")
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
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier,"Personio Sceletus")
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
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier)
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
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier,"Harvesto")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b> Harvesto!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Harvesto", lag = 0)

mob/Spells/verb/Felinious()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier,"Felinious")
		hearers(usr.client.view, usr)<<"<b><span style=\"color:red;\">[usr]</span>:<b> Felinious!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Felinious", lag = 0)

mob/Spells/verb/Scurries()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier,"Scurries")
		hearers(usr.client.view, usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Scurries!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Scurries", lag = 0)

mob/Spells/verb/Seatio()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier,"Seatio")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Seatio!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Seatio", lag = 0)

mob/Spells/verb/Nightus()
	set category="Spells"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier,"Nightus")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Nightus!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Nightus", lag = 0)

mob/Spells/verb/Peskipixie_Pesternomae()
	set category="Spells"
	set name = "Peskipiksi Pestermi"
	if(canUse(src,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1))
		new /StatusEffect/UsedTransfiguration(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier,"Peskipiksi Pestermi")
		hearers(usr.client.view,usr)<<"<b><span style=\"color:red;\">[usr]</span>: <b>Peskipiksi Pestermi!</b>"

		castproj(Type = /obj/projectile/Transfiguration, icon_state = "trans", name = "Peskipiksi Pestermi", lag = 0)

mob/Spells/verb/Telendevour()
	set category="Spells"
	set popup_menu = 0

	var/mob/Player/p = src
	var/mpCost = 50
	var/spellName = "Telendevour"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(usr.client.eye == usr)
		if(canUse(src,cooldown=/StatusEffect/UsedTelendevour,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))

			if(IsInputOpen(src, spellName))
				del _input[spellName]

			var/Input/popup = new (src, spellName)
			var/list/l = Players(list(src))
			if(!l.len) return
			var/mob/Player/M = popup.InputList(src, "Which person would you like to view?", spellName, l[1], l)
			del popup

			if(!M) return
			if(usr.client.eye != usr) return

			if(istext(M) || istype(M.loc.loc, /area/ministry_of_magic))
				src << errormsg("<b>You feel magic repelling your spell.</b>")
			else
				var/otherUses = ("Occlumency" in M.SpellUses) ? M.SpellUses["Occlumency"] : 1
				var/otherTier = round(log(10, otherUses)) - 1

				var/spycraft = (SHIELD_SPY in M.passives)
				if(spycraft) otherTier++

				new /StatusEffect/UsedTelendevour(src,5*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier,spellName)
				p.learnSpell(spellName)
				p.MP -= mpCost
				p.updateMP()

				if(tier <= otherTier && M.occlumens>0)
					src << errormsg("<b>You feel magic repelling your spell.</b>")
				else
					p.Interface.SetDarknessColor(TELENDEVOUR_COLOR, 2)
					p.client.eye = M
					p.client.perspective = EYE_PERSPECTIVE
					file("Logs/Telenlog.text") << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] telendevoured [M]"
					var/randnum = rand(1,7)
					hearers() << "[usr]:<span style=\"font-size:2;\"><font color=blue><b> Telendevour!</b></span>"
					if(spycraft || randnum == 1)
						M << "You feel that <b>[usr]</b> is watching you."
					else
						M << "The hair on the back of your neck tingles."
	else if(p.Interface.SetDarknessColor(TELENDEVOUR_COLOR))
		usr.client.eye = usr
		usr.client.perspective = EYE_PERSPECTIVE
		hearers() << "[usr]'s eyes appear again."


//AVADA//

bolt/boltFix

	New(vector/source, vector/dest, fade = 50)
		..(source, dest, fade)

		src.fade = fade

obj/segment/segmentFix
	appearance_flags = PIXEL_SCALE

mob/Spells/verb/Avada_Kedavra()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 800
	var/spellName = "Avada Kedavra"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedAvada,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1,projectile=1))
		var/min_dist = 5

		var/mob/Player/target

		for(var/mob/Player/M in oview(5))
			var/dist = get_dist(src, M)
			if(min_dist > dist)
				target = M
				min_dist = dist

		if(target)
			var/area/a = target.loc.loc
			if(a.timedProtection && (lastHostile == 0 || world.time - lastHostile > 600)) target = null

		if(target)
			if(target.HP < target.MHP * 0.3)

				new /StatusEffect/UsedAvada(src,5*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier,spellName)

				var/___vector/start = new (p.x      * world.icon_size + world.icon_size / 2, p.y      * world.icon_size + world.icon_size / 2)
				var/___vector/dest  = new (target.x * world.icon_size + world.icon_size / 2, target.y * world.icon_size + world.icon_size / 2)

				start.X += (EAST & dir) ? 7 : -7
				start.Y -= 6

				var/bolt/boltFix/b = new(start, dest, 35)
				b.Draw(z, /obj/segment/segmentFix, color = "#30ff30", thickness = 1)

				light(b.lastCreatedBolt, 3, 10, "circle", "#30ff30")

				emit(loc    = target.loc,
					 ptype  = /obj/particle/smoke/proj,
				     amount = 28,
				     angle  = new /Random(0, 360),
				     speed  = 2,
				     life   = new /Random(20,35),
				     color  = "#0c0")

				if(target.reflect)
					var/d = p.onDamage(target.MHP * target.reflect, p, triggerSummons=0)
					p << errormsg("Your spell got reflected, you inflicted [d] to yourself.")
					p.Death_Check(p)
				else
					target.onDamage(target.MHP, p)
					target.Death_Check(p)

					p.HP = min(round(p.HP + target.MHP*0.3, 1), p.MHP)
					p.updateHP()
			else
				var/dmg = p.onDamage(p.MHP * 0.3, target, triggerSummons=0)
				p << infomsg("[target] soul wasn't weakened enough, you took [dmg] damage!")
				p.Death_Check(target)
		else
			var/dmg = usr.Dmg + clothDmg + usr:Ghost.level
			dmg = round(dmg + dmg * 0.35, 1)

			castproj(MPreq = mpCost, Type = /obj/projectile/Avada, damage = dmg * ((100 + tier*2) / 100), icon_state = "avada", name = spellName, element = GHOST, lag = 1, cd=4)


mob/Spells/verb/Apparate()
	set category="Spells"
	var/mpCost = (RING_APPARATE in usr:passives) ? 350 : 150
	if(canUse(src,cooldown=/StatusEffect/Apparate,needwand=1,mpreq=mpCost))

		var/area/a = loc.loc
		if(a.antiApparate)
			src << errormsg("Strong charms are stopping you.")
			return

		var/turf/t

		var/mob/Enemies/e = locate() in oview(15, src)

		if(e)
			t = get_step_towards(e, src)

		if(!t)
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
			if(e)
				p.dir = get_dir(p, e)

mob/Spells/verb/Episky()
	set name = "Episkey"
	set category="Spells"

	var/mob/Player/p = src
	var/spellName = "Episkey"
	var/mpCost = 50

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedEpiskey,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1))

		var/obj/The_Dark_Mark/D = locate("DarkMark")
		if(get_dist(p, D) <= 10)
			p << errormsg("You can't use this near such evil presence.")
			return

		if(world.time - p.lastCombat <= COMBAT_TIME)
			p << errormsg("You can't use this while in combat.")
			return

		hearers()<<"<span style=\"color:red;\"><b>[p]:</span></b> <font color=aqua>Episkey!"
		var/cd
		if(level < 100)
			cd = 10
		else if(level < 200)
			cd = 15
		else
			cd = 20
		new /StatusEffect/UsedEpiskey(src,cd*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, spellName)

		var/percent = 0

		if(tier >= 1) percent += tier * 2
		if(SHIELD_NURSE in p.passives)	percent += 24 + p.passives[SHIELD_NURSE]

		if(percent > 0)
			p.Shield = round(p.MHP * (percent / 100), 1)

		p.HP = p.MHP
		p.updateHP()

		p.MP-=mpCost
		p.updateMP()

		p.learnSpell(spellName)

		overlays+=image('attacks.dmi', icon_state = "heal")

		var/list/removeOverlays

		if(SWORD_NURSE in p.passives)

			removeOverlays = list()
			for(var/mob/Player/other in range(2))
				if(other == p) continue
				other.HP = other.MHP

				if(percent > 0)
					other.Shield = round(p.MHP * (percent / 100), 1)

				other.updateHP()

				removeOverlays += other

				other.overlays+=image('attacks.dmi', icon_state = "heal")

		sleep(10)

		usr.overlays-=image('attacks.dmi', icon_state = "heal")

		if(removeOverlays)
			for(var/mob/Player/other in removeOverlays)
				other.overlays-=image('attacks.dmi', icon_state = "heal")


mob/Spells/verb/Confundus(mob/Player/M in oview())
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 400
	var/spellName = "Confundus"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedAnnoying,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=M,mpreq=mpCost,againstocclumens=1))
		new /StatusEffect/UsedAnnoying(src,40*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, spellName)
		hearers()<<"<b><span style=\"color:red;\">[usr]:</b></span> <font color= #7CFC00>Confundus, [M]!"
		p.MP-=mpCost
		p.updateMP()
		p.learnSpell("Confundus")
		M << errormsg("You feel confused...")

		if(!M.key) return

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

	var/mob/Player/p = src
	var/mpCost = 10
	var/spellName = "Flippendo"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=null,needwand=1,inarena=1,insafezone=1,target=null,mpreq=mpCost))
		castproj(Type = /obj/projectile/Flippendo, MPreq = mpCost, icon_state = "flippendo", name = spellName)

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
				if(!istype(other, /obj/items/)) other.backToPos(other.loc)
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



mob/Spells/verb/Imperio()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 400
	var/spellName = "Imperio"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedImperio,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1,projectile=1))
		new /StatusEffect/UsedImperio(src,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, spellName)
		castproj(MPreq = mpCost, Type = /obj/projectile/Imperio, icon_state = "avada", name = spellName, lag = 1, cd=4)

mob/Spells/verb/Crucio()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 400
	var/spellName = "Crucio"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedImperio,needwand=1,inarena=1,insafezone=0,inhogwarts=1,target=null,mpreq=mpCost,againstocclumens=1,projectile=1))
		castproj(MPreq = mpCost, Type = /obj/projectile/StatusEffect { effect = /StatusEffect/Crucio; effectName = "Crucio" }, icon_state = "avada", name = spellName, lag = 1, cd=4)

obj/debuff

	crucio

	New()
		set waitfor = 0
		..()

		sleep(150)
		loc = null

	Crossed(mob/Enemies/e)
		if(ismonster(e))

			if(!e.findStatusEffect(/StatusEffect/Crucio)) new /StatusEffect/Crucio (e,15)

			loc=null

mob/Spells/verb/Portus()
	set category="Spells"

	var/mob/Player/p = src
	var/mpCost = 50
	var/spellName = "Portus"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1
	mpCost = round(mpCost * (100 - tier*2) / 100, 1)

	if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=mpCost,antiTeleport=1,useTimedProtection=1))

		if(IsInputOpen(src, "Portus"))
			del _input["Portus"]

		var/Input/popup = new (src, "Portus")
		var/locations = list("Hogsmeade", "Hogwarts Courtyard", "The Dark Forest Entrance")

		if(tier > 1) locations += "Diagon Alley"
		if(tier > 2) locations += "Pixie Pit"
		if(tier > 3) locations += "Enchanter"

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
				if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=mpCost,useTimedProtection=1))
					var/obj/target = locate("@Hogsmeade")
					var/obj/portkey/P1 = new(loc)
					var/obj/portkey/P2 = new(target.loc)
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
				if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=mpCost,useTimedProtection=1))
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
				if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=mpCost,useTimedProtection=1))
					var/obj/target = locate("@Forest")
					var/obj/portkey/P1 = new(loc)
					var/obj/portkey/P2 = new(target.loc)
					P1.partner = P2
					P2.partner = P1
			if("Diagon Alley")
				if(src.loc.density)
					src << errormsg("Portus can't be used on top of something else.")
					return
				for(var/atom/A in src.loc)
					if(A.density && !ismob(A))
						src << errormsg("Portus can't be used on top of something else.")
						return
				if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=mpCost,useTimedProtection=1))
					var/obj/target = locate("@DiagonAlley")
					var/obj/portkey/P1 = new(loc)
					var/obj/portkey/P2 = new(target.loc)
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
				if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=mpCost,useTimedProtection=1))
					var/obj/target = locate("@Pixie Pit")
					var/obj/portkey/P1 = new(loc)
					var/obj/portkey/P2 = new(target.loc)
					P1.partner = P2
					P2.partner = P1
			if("Enchanter")
				if(src.loc.density)
					src << errormsg("Portus can't be used on top of something else.")
					return
				for(var/atom/A in src.loc)
					if(A.density && !ismob(A))
						src << errormsg("Portus can't be used on top of something else.")
						return
				if(canUse(src,cooldown=/StatusEffect/UsedPortus,needwand=1,inarena=0,insafezone=1,inhogwarts=0,target=null,mpreq=mpCost,useTimedProtection=1))
					var/obj/target = locate(" wisp enchanter")
					var/obj/portkey/P1 = new(loc)
					var/obj/portkey/P2 = new(target.loc)
					P1.partner = P2
					P2.partner = P1
			if(null)
				return
		new /StatusEffect/UsedPortus(src,30*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier, spellName)
		hearers()<<"[usr]: <span style=\"color:aqua;\"><font size=2>Portus!</span>"
		hearers()<<"A portkey flys out of [usr]'s wand, and opens."
		p.MP-=mpCost
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
	set category = "Spells"

	var/mob/Player/p = src
	var/spellName = "Inferius"

	var/uses = (spellName in p.SpellUses) ? p.SpellUses[spellName] : 1
	var/tier = round(log(10, uses)) - 1

	if(canUse(src,cooldown=/StatusEffect/Summoned,needwand=1,inarena=0,insafezone=0,inhogwarts=0,target=null,mpreq=0,againstocclumens=1))

		var/limit = 1 + p.extraLimit + round(p.Summoning.level / 10)

		if(p.summons >= limit)
			p << errormsg("You need higher summoning level to summon more.")
			return

		new /StatusEffect/Summoned(src,15*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier, "Inferius")

		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=silver> Inferius!"

		p.learnSpell(spellName)

		for(var/obj/corpse/c in view(15, src))
			if(c.gold == -1 || c.revive == 1) continue

			c.revive = 1
			animate(c, transform = null, alpha = 255, time = 10)

			sleep(10)
			var/obj/summon/corpse/s = new  (c.loc, src, "Inferius", 1, tier)
			c.loc = null
			s.appearance = c.appearance
			s.dir = c.dir

			if(c.gold >= 0 && c.gold != null)
				if(c.gender == FEMALE)
					s.icon = 'FemaleVampire.dmi'
				else
					s.icon = 'MaleVampire.dmi'

			if(!p.Summons || p.Summons.len >= limit) break

mob/Spells/verb/Inferius_Maxima()
	set category = "Spells"

	if(canUse(src,needwand=0))

		hearers()<<"<b><span style=\"color:red;\">[usr]</b></span>: <b><font size=3><font color=silver> Inferius Maxima!"

		for(var/obj/corpse/c in view(15, src))
			if(c.gold == -1 || c.revive == 1) continue

			if(c.owner && isplayer(c.owner))
				c.revive = 1
				animate(c, transform = null, alpha = 255, time = 10)
				sleep(10)
				if(c.owner)
					c.owner << infomsg("[usr] resurrected you.")
					var/gold/g = new(bronze=c.gold)
					g.give(c.owner)
					c.owner:Transfer(c.loc)
					c.owner.dir = c.dir
					c.loc = null
					c.owner = null

var/safemode = 1
mob/var/tmp
	lastproj = 0
	lastHostile = 0
mob
	proc/castproj(Type = /obj/projectile, MPreq = 0, icon = 'attacks.dmi', icon_state = "", damage = 0, name = "projectile", cd = 2, lag = 2, element = 0, Loc = loc, Dir = dir, learn=1, canClone=1)
		if(cd && (world.time - lastproj) < cd && !inOldArena()) return
		if(!loc) return
		lastproj = world.time

		damage *= loc.loc:dmg
		damage = round(damage)

		if(damage > 0)
			lastHostile = world.time

		var/obj/projectile/P = new Type (Loc,Dir,src,icon,icon_state,damage,name,element)
		if(lag != -1) P.shoot(lag)
		. = P

		if(client)

			var/mob/Player/p = src

			if(SWORD_MANA in p.passives)
				var/dmg = round(p.MMP * 1)
				var/cost = round(dmg * 0.5, 1)

				if(cd == 0)
					P.damage = 10 + dmg + rand(0, 10)
					p.MP = 0
				else if(p.MP >= cost)
					P.damage = 10 + dmg + rand(0, 10)
					p.MP -= cost
				else
					P.damage = 10 + p.MP*2 + rand(0, 10)
					p.MP = 0
				lag -= 1
				if(lag != -1) P.shoot(lag)

			else
				p.MP -= MPreq
			p.updateMP()

			if(SHIELD_CLOWN in p.passives)
				P.selfDamage = 0

			if(SWORD_GHOST in p.passives)
				if(P.element == GHOST)
					P.damage *= 1.2
				else
					P.element = GHOST

			if(RING_CLOWN in p.passives)
				P.element = pick(GHOST,FIRE,WATER,EARTH)

			if(p.wand)
				if(cd != 0 && lag != 0 && learn) p.learnSpell(name)

				if(!P.color)
					var/c
					if(p.holster && p.holster.selectedColors)

						if(p.holster.selectedColors.len > 1)
							c = pick(p.holster.selectedColors)
						else
							c = p.holster.selectedColors[1]
					else if(p.wand.projColor)
						c = p.wand.projColor

					if(c)
						if(c == "blood" || c == "#880808")
							P.color      = "#16d0d0"
							P.blend_mode = BLEND_SUBTRACT
						else
							P.color = list(c, c, c)

			if((SWORD_CLOWN in p.passives) && canClone)

				var/amount = 1 + round(p.passives[SWORD_CLOWN] / 10)

				var/list/dirs = DIRS_LIST

				P.dir = pick(dirs)
				dirs -= P.dir

				if(lag != -1)
					P.shoot(lag)
				else
					P.loc = get_step_rand(get_step(Loc, P.dir))

				for(var/i = 1 to amount)
					var/dir2 = pick(dirs)

					dirs -= dir2

					var/obj/projectile/P2 = new Type (Loc,dir2,src,icon,icon_state,P.damage,name,P.element)
					if(lag != -1)
						P2.shoot(lag)
					else
						P2.loc = get_step_rand(get_step(Loc, dir2))
					P2.appearance = P.appearance

atom/movable/proc
	Attacked(obj/projectile/p)

	Dispose()
		loc = null


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
	Spellcrafting
	TreasureHunting

element
	var
		name
		level = 0
		exp = 0
		maxExp = 4000


		const
			MAX  = 50 // soft cap

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

			if(amount < 10) return
			amount = round(amount/10, 1)

			exp += amount
			parent.expAlert(amount, name)

			while(exp > maxExp)
				exp -= maxExp
				level++
				maxExp = 4000 + (level * 4000)

				parent.screenAlert("[name] leveled up to [level]!")

		adjustExp()
			for(var/i = 0 to level-1)
				exp += 2000 + (i * 2500)

			level = 0
			maxExp = 4000

			while(exp > maxExp)
				exp -= maxExp
				level++
				maxExp = 4000 + (level * 4000)


mob/Player
	var
		tmp/lastCombat = -COMBAT_TIME
		tmp/wandCharge = 0
		wandLock = 0

	proc/wandPowerTick()
		var/gain = 1

		if(RING_TUNGRAD in passives)
			gain += (passives[RING_TUNGRAD] - 1) / 4

		wandCharge = min(wandCharge + gain, 100)
		wand.wandPower.setCharge(wandCharge)

	proc/wandPower()
		set waitfor = 0

		var/obj/o = new
		o.appearance = wand.appearance
		o.maptext = null
		o.layer = 5
		o.appearance_flags = PIXEL_SCALE

		var/obj/Shadow/s = new

		s.pixel_y = - 16
		s.appearance_flags |= RESET_TRANSFORM|PIXEL_SCALE
		var/matrix/m = matrix()
		m.Scale(1.6, 1)
		s.transform = m

		o.vis_contents += s

		m = matrix()
		m.Turn(90)
		animate(o, transform = m, time = 6, loop = -1)
		m.Turn(90)
		animate(transform = m, time = 6)
		m.Turn(90)
		animate(transform = m, time = 6)
		animate(transform = null, time = 6)

		var/totalTime = 10
		animate(o, pixel_x = pixel_x, pixel_y = pixel_y + 64, time = totalTime, loop = 1, flags = ANIMATION_PARALLEL)
		var/t = rand(10, 30)
		totalTime += t
		animate(time = t)

		var/list/time = list()

		var/lastPx = 0
		var/lastPy = 64
		for(var/i = 1 to 4)
			var/px = rand(-128, 128)
			var/py = rand(-128, 128)

			time["[totalTime + 5 - (totalTime % 5)]"] = "[(px+lastPx)/2],[(py+lastPy)/2]"
			time["[totalTime + 10 - (totalTime % 5)]"] = "[px],[py]"

			lastPx = px
			lastPy = py

			t = rand(20, 40)
			totalTime += t + 10

			animate(pixel_x = pixel_x + px, pixel_y = pixel_y + py, time = 10)
			animate(time = t)

		time["[totalTime + 5 - (totalTime % 5)]"] = "[(lastPx)/2],[(64+lastPy)/2]"
		time["[totalTime + 10 - (totalTime % 5)]"] = "0,64"

		animate(pixel_x = 0, pixel_y = 64, time = 10)
		t = rand(10, 30)
		totalTime += t + 10
		animate(time = t)
		animate(pixel_y = 0, time = 10)

		vis_contents += o
		// wand animation ends here

		var/px = 0
		var/py = 64
		for(var/i = 0 to totalTime step 5)
			if(!wand) break
			var/index = time.Find("[i]")
			if(index)
				var/txt = splittext(time["[i]"], ",")
				px = text2num(txt[1])
				py = text2num(txt[2])

			if(wand.test==2)
				for(var/mob/Player/e in view(6, src))
					var/___vector/start = new (  x * 32 + 16,   y * 32 + 16)
					var/___vector/dest  = new (e.x * 32 + 16, e.y * 32 + 16)

					start.X += px
					start.Y += py

					var/bolt/boltFix/b = new(start, dest, 35)
					b.Draw(z, /obj/segment/segmentFix, color = "#00eb73", thickness = 1)

					e.onDamage(e.MHP*0.25, src, elem=HEAL|COW)
			else
				var/dmg = 100 + (level + 100) * wand.scale * wand.quality
				for(var/mob/Enemies/e in view(5, src))
					if(e.level > 1500) continue
					if(!e.loc || e.HP <= 0 || e.dead) continue

					var/___vector/start = new (  x * 32 + 16,   y * 32 + 16)
					var/___vector/dest  = new (e.x * 32 + 16, e.y * 32 + 16)

					start.X += px
					start.Y += py

					var/bolt/boltFix/b = new(start, dest, 35)
					b.Draw(z, /obj/segment/segmentFix, color = "#E4CCFF", thickness = 1)

					e.onDamage(max(dmg, e.MHP + 100), src, projColor="#3393ff")

			sleep(5)


		sleep((totalTime-2) % 5)


		animate(o, time = 0, flags = ANIMATION_END_NOW)
		vis_contents -= o
		o.vis_contents -= s

	proc/onDamage(dmg, mob/attacker, triggerSummons=1, elem=0)

		if(elem & HEAL)

			if((HP + dmg > MHP) && (elem & COW))
				var/diff = HP + dmg - MHP
				HP = MHP
				Shield = min(Shield + diff, MHP*2)

			else
				HP = min(HP + dmg, MHP)

			updateHP()
			return 0

		if(loginProtection)
			dmg = 1


		if((SHIELD_NINJA in passives) && prob(29 + passives[SHIELD_NINJA]/2))
			dmg = 0

			var/turf/t = get_step(attacker, turn(attacker.dir, 180))

			if(t != loc && !away && t)
				var/obj/o = new (loc)
				o.appearance = appearance
				o.dir = dir
				var/px = (x - t.x) * -32
				var/py = (y - t.y) * -32

				animate(o, alpha = 0, pixel_x = pixel_x + px, pixel_y = pixel_y + py, time = 4)
				spawn(4) o.loc = null

				Move(t)

			if(usedSpellbook && (usedSpellbook.flags & PAGE_ONDASH))
				usedSpellbook.cast(src, attacker)

			dir = get_dir(src, attacker)

			return 0

		if(ismonster(attacker))
			var/monsterDefLimit = (SHIELD_SOUL in passives) ? 0.9 : 0.75

			var/mdef = monsterDef

			if(hardmode > 5)
				mdef -= (hardmode - 5) * 5

			dmg *= 1 - min(mdef/100, monsterDefLimit)

			if(INCREASED_DAMAGE in attacker:passives)
				var/rate = min(attacker:passives[INCREASED_DAMAGE], 75)
				dmg *= 1 + (rate / 100)

		if((SHIELD_MP in passives) && MP < MMP)
			var/regen = round(dmg * (0.5 + ((passives[SHIELD_MP] - 1) / 100)) , 1)
			MP = min(MP + regen, MMP)
			updateMP()

		if(SHIELD_MPDAMAGE in passives)
			var/r = min(round(dmg * (0.35 + ((passives[SHIELD_MPDAMAGE] - 1) / 100)), 1), MP)
			dmg -= r
			MP -= r
			updateMP()

		if(usedSpellbook && (usedSpellbook.flags & PAGE_DAMAGETAKEN))
			usedSpellbook.cast(src, attacker)

		dmg = round(dmg, 1)

		var/shieldDmg = 0
		if(Shield > 0)
			Shield = Shield - dmg
			if(Shield <= 0)
				shieldDmg = dmg - abs(Shield)
				dmg = abs(Shield)
				Shield = 0
			else
				shieldDmg = dmg
				dmg = 0

		if((RING_NURSE in passives) && HP - dmg <= 0)
			usr = src
			usr:Episky()

			if(!findStatusEffect(/StatusEffect/DodgedDeath))
				dmg = 0
				new /StatusEffect/DodgedDeath(src, 150)

		HP -= dmg
		updateHP()

		if(shieldDmg > 0)
			var/offset = 15 - (length("[shieldDmg]") * 5)
			fadeText(src, "<b><span style=\"color:#32a4a8;font-size:8px\">[shieldDmg] </span></b>", offset, 20, 32)

		if(dmg > 0)
			var/offset = 15 - (length("[dmg]") * 5)
			fadeText(src, "<b><span style=\"color:#DC143C;font-size:8px\">[dmg] </span></b>", offset, 20, 32)

		if(wand && wand.test && !isplayer(attacker) && attacker != src)
			if(HP <= 0 && ((wandCharge >= 100 && prob(50)) || (wandCharge >= 50 && wandCharge < 100 && prob(25))))
				new /StatusEffect/WandPower(src, 120)

				wandCharge -= wandCharge >= 100 ? 100 : 50
				wand.wandPower.setCharge(wandCharge)

				resurrect = 1
				spawn() src << infomsg("Your wand resurrected you.")
			else if(prob(25))

				wandPowerTick()

				if(!wandLock && wandCharge >= 100 && !findStatusEffect(/StatusEffect/WandPower))
					wandCharge = 0
					wand.wandPower.setCharge(wandCharge)
					new /StatusEffect/WandPower(src, 30)
					wandPower()

		if(triggerSummons && attacker != src)
			for(var/obj/summon/s in Summons)
				if(!s.target)
					s.target = attacker

					if(isplayer(attacker)) break

		return dmg


	Attacked(obj/projectile/p, isReflected=0)
		..()

		if(p.element == HEAL)

			HP = min(HP + p.damage, MHP)
			updateHP()

			p.owner << "Your [p] heals [src] for [p.damage]."
			src << "[p.owner] heals you for [p.damage]."
			return src

		var/area/a = loc.loc
		if(p.owner)

			if(a.timedProtection && (lastHostile == 0 || world.time - lastHostile > 600)) return

			if(isplayer(p.owner))

				if(p.owner == src && !isReflected && (!p.selfDamage || !a.selfDamage)) return

				if(!a.friendlyFire) return

				if(party && (p.owner in party.members)) return

				if(src != p.owner)
					lastCombat = world.time
					p.owner:lastCombat = world.time

				if((level < 200 || p.owner.level < 200) && (abs(p.owner.level - level) >= 200))
					if(!istype(a, /area/arenas) && !a.respawnPoint) return

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

		if(ismonster(p.owner))
			if(Armor)
				var/armor = Armor * 0.5
				if(SHIELD_THORN in passives)
					armor *= 1 + (30 + passives[SHIELD_THORN] - 1) / 100
					dmg = max(dmg - armor, 1)


		dmg = onDamage(dmg, p.owner)

		if(p.canBleed)
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

				if(SWORD_HEALONKILL in p.owner:passives)
					p.owner.HP = min(round(p.owner.HP + MHP*(0.20 + ((p.owner:passives[SWORD_HEALONKILL] - 1) / 100)), 1), p.owner.MHP)
					p.owner:updateHP()

			else if(ismonster(p.owner))
				p.owner:Kill(src)
			else
				Death_Check(src)

		return src

mob/Enemies
	var/canBleed = TRUE
	var/tmp/dead = 0
	var/element

	var/damageMod = 1

	var/tmp/list/totalDamage

	proc/onDamage(dmg, mob/Player/p, elem = 0, projColor=null)

		if(dead) return 0

		if(totalDamage && p in totalDamage)
			totalDamage[p] += dmg
			return
		else
			if(!totalDamage) totalDamage = list()
			totalDamage[p] = dmg
			sleep(0)

		dmg = totalDamage[p]
		totalDamage -= p
		if(!totalDamage.len) totalDamage = null

		var/monsterDmgLimit = (SHIELD_SOUL in p.passives) ? 3 : 2

		dmg += p.Slayer.level
		dmg *= 1 + min(p.monsterDmg/100, monsterDmgLimit)
		dmg *= damageMod

		if(INCREASED_DEFENSE in passives)
			var/rate = min(passives[INCREASED_DEFENSE], 75)
			dmg *= 1 - (rate / 100)

		if(hardmode > 5)
			dmg *= 1 - ((hardmode - 5) * 5 / 100)

		if(elem == FIRE && (SWORD_FIRE in p.passives))
			var/perc = 5 + (p.passives[SWORD_FIRE] - 1) / 2
			var/leech = round(dmg * (perc / 100), 1)

			p.Shield = min(p.Shield + leech, p.MHP*0.5)
			p.updateHP()

		if(CRYSTAL_BLOOD in p.passives)
			var/obj/items/crystal/passive = p.passives[CRYSTAL_BLOOD]
			var/leech = round(dmg * ((passive.passivePower + 3) / 100), 1)

			p.HP = min(p.HP + leech, p.MHP)
			p.updateHP()

		if(LStatusEffects && (CRYSTAL_CC in p.passives))
			var/obj/items/crystal/passive = p.passives[CRYSTAL_CC]
			dmg *= 1 + ((passive.passivePower + 3) / 100)

		if(elem == COW)
			dmg += element == EARTH ? round(dmg *0.25, 1) : round(dmg / 10, 1)
		else if(element && elem)

			if(element == elem)
				dmg -= round(dmg / 10, 1)
			else if("[elem]" in resistances)
				dmg = round(dmg*resistances["[elem]"], 1)

		if(prizePoolSize > 1 && p && dmg && HP > 0)
			if(!damage) damage = list()

			var/perc = (dmg / MHP) * 100

			if(p.ckey in damage)
				damage[p.ckey] += perc
			else
				damage[p.ckey] = perc


		dmg = round(dmg, 1)
		HP -= dmg

		if((SWORD_SOUL in p.passives) && (HP / MHP) * 100 <= 10)
			dmg += HP
			HP = 0

		if(dmg > 0)
			var/offset = 15 - (length("[dmg]") * 5)
			fadeText(src, "<b><span style=\"color:#f00;font-size:8px\">[dmg]</span></b>", offset, 20, 32)

		if(HP > 0)
			if((state == WANDER || state == SEARCH) && p)
				target = p
				ChangeState(HOSTILE)

			if(elem == WATER && (RING_LAVAWALK in p.passives) && !findStatusEffect(/StatusEffect/Slow))
				new /StatusEffect/Slow (src,5)

		else
			dead = 1

			if(p.wand && p.wand.test && prob(20))
				p.wandPowerTick()

			var/explode = (p && ((SWORD_EXPLODE in p.passives))) ? round(dmg*(0.74 + p.passives[SWORD_EXPLODE] / 100), 1) : 0

			if(findStatusEffect(/StatusEffect/Crucio))
				for(var/mob/Enemies/e in orange(3, src))
					if(!e.findStatusEffect(/StatusEffect/Crucio)) new /StatusEffect/Crucio (e,15)

				if(!explode && prob(30))
					explode = round(dmg * 0.75, 1)

				if(explode)
					new /obj/debuff/crucio (loc)

			LStatusEffects = null

			var/restoreBleed = FALSE
			if(p && explode)
				if(canBleed)
					canBleed = FALSE
					restoreBleed = TRUE

				var/c
				if(projColor)
					c = projColor
				else if(elem != 0)
					if(elem == FIRE) c = "#c60"
					else if(elem == WATER) c = "#0bc"
					else if(elem == EARTH) c = "#8b4513"
					else if(elem == GHOST) c = "#ff69b4"
				else c = color

				var/obj/o = new /obj/custom { canSave = 0; icon = 'Effects.dmi'; icon_state = "explode" } (loc)
				o.color = list(c, c, c)
				o.transform = turn(matrix()*(1.25 + (rand(0, 25) / 100)), 90 * rand(0, 3))
				spawn(6)
					o.loc = null

				for(var/mob/Enemies/a in range(2, loc))
					if(a==src) continue
					if(a.HP > 0)
						spawn() a.onDamage(explode, p, elem, c)


			Death_Check(p)

			if(restoreBleed)
				canBleed = TRUE

			if(SWORD_HEALONKILL in p.passives)
				p.HP = min(round(p.HP + MHP*(0.20 + ((p.passives[SWORD_HEALONKILL] - 1) / 100)), 1), p.MHP)
				p.updateHP()

			var/exp2give  = (rand(6,14)/10)*Expg

			if(p.level > src.level && !p.hardmode)
				exp2give  -= exp2give  * ((p.level-src.level)/150)

				if(exp2give <= 0) return 1

			if(p.House == worldData.housecupwinner)
				exp2give  *= 1.5

			var/StatusEffect/Lamps/Exp/exp_rate   = p.findStatusEffect(/StatusEffect/Lamps/Exp)

			if(exp_rate)  exp2give  *= exp_rate.rate

			if(elem != 0)

				if(elem == FIRE) p.Fire.add(exp2give, p)

				else if(elem == WATER) p.Water.add(exp2give, p)

				else if(elem == EARTH) p.Earth.add(exp2give, p)

				else if(elem == GHOST) p.Ghost.add(exp2give, p)

			return exp2give

		if(hpbar)
			var/maxHP = getHardmodeHealth()
			var/percent = HP / maxHP
			hpbar.Set(percent, src)

		return 0


	Attacked(obj/projectile/p, silent=0)

		if(isplayer(p.owner) && p.element != HEAL)

			var/dmg = p.damage

			if(canBleed && p.canBleed)
				var/n = dir2angle(get_dir(src, p))
				emit(loc    = src,
					 ptype  = /obj/particle/fluid/blood,
				     amount = 4,
				     angle  = new /Random(n - 25, n + 25),
				     speed  = 2,
				     life   = new /Random(15,25))

			if(SWORD_NINJA in p.owner:passives)
				var/angleDiff = abs(dir2angle(p.owner.dir) - dir2angle(dir))

				if(angleDiff <= 45)
					dmg *= 1.5
				else if(angleDiff <= 90)
					dmg *= 1.25

			var/exp2give = onDamage(dmg, p.owner, p.element, p.color)
			if(exp2give > 0)

				p.owner:learnSpell(p.name, 30)
			else
				for(var/obj/summon/s in p.owner:Summons)
					if(!s.target)
						s.target = src

			..()

obj
	projectile
		layer = 4
		density = 1
		icon = 'attacks.dmi'
		var
			velocity = 0
			const/MAX_VELOCITY = 10
			life = 20
			damage = 0
			element = 0

			steps = 0
			impact = 1
			selfDamage = 1
			canBleed = 1

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

			if(element == FIRE)
				var/obj/light/l = new
				l.transform = matrix() * 0.5
				vis_contents += l

			spawn(life)
				Dispose()

		Dispose()
			vis_contents = null
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
						if("avada")
							particle = /obj/particle/smoke/proj
							c = "#0b0"
						if("fireball")
							particle = /obj/particle/smoke/proj
							c = "#c60"
						if("gum")
							particle = /obj/particle/smoke/proj
							c = "#ff69b4"
						if("flippendo","potion")
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

		Meteor
			density    = 0
			icon       = 'dot.dmi'
			icon_state = "circle"
			color      = "#8A0707"
			alpha      = 20
			appearance_flags = PIXEL_SCALE
			canBleed   = 0
			selfDamage = 0

			var
				range = 4

			New(loc,dir,mob/mob,icon,icon_state,damage,name,element)
				set waitfor = 0
				src.loc=loc
				src.element = element
				src.damage = damage
				src.owner = mob
				src.name = name

		//		sleep(1)
				var/matrix/m = matrix()
				m.Scale(range + 0.5, range)

				animate(src,  alpha = 100, transform = m, time = 4)

				sleep(3)

				var/obj/dropObj/o = new(loc)
				o.icon_state = icon_state

				var/d = rand(0,2)
				if(d == 1)
					o.pixel_x = -80
					m.Turn(-45)
					o.transform = m
				else if(d == 2)
					o.pixel_x = 80
					m.Turn(45)
					o.transform = m
				else
					o.transform = m

				animate(o, pixel_y = 0, pixel_x = 0, time = 4)

				sleep(3)

				for(var/atom/movable/a in range((range-1)/2, src.loc))
					spawn() a.Attacked(src)

				src.loc = null
				o.loc = null
		Avada

			Effect(atom/movable/a)

				if(owner && isplayer(a))
					var/mob/Player/p = a

					if(p.HP < p.MHP * 0.3)
						emit(loc    = p.loc,
							 ptype  = /obj/particle/smoke/proj,
						     amount = 28,
						     angle  = new /Random(0, 360),
						     speed  = 2,
						     life   = new /Random(20,35),
						     color  = "#0c0")

						damage = p.MHP

						owner.HP = min(round(owner.HP + p.MHP*0.3, 1), owner.MHP)
						owner:updateHP()

					else
						damage = 0
						var/dmg = owner:onDamage(owner.MHP * 0.3, p, triggerSummons=0)
						owner << infomsg("[p] soul wasn't weakened enough, you took [dmg] damage!")
						owner:Death_Check(p)

		StatusEffect
			var/effect
			var/effectName

			Effect(atom/movable/a)

				if(owner)
					if(ismonster(a))
						new effect (a,15)
					else if(isplayer(a))
						new effect (a,15,effectName)

		Slugs

			Effect(atom/movable/a)
				set waitfor = 0
				..()
				if(isplayer(a))
					var/mob/Player/M = a
					var/slugs = rand(4,12)
					while(M && slugs > 0 && M.MP > 0)
						M.MP -= rand(20,60) * round(M.level/100)
						new/mob/Enemies/Summoned/Slug(M.loc)
						if(M.key)
							if(M.MP < 0)
								M.MP = 0
								M.updateMP()
								M << errormsg("You feel drained from the slug vomiting curse.")
								break
							else
								M.updateMP()
						slugs--
						sleep(rand(20,90))
				else if(ismonster(a))
					if(!a.findStatusEffect(/StatusEffect/Slugs))
						new /StatusEffect/Slugs (a,10,owner=owner)


		Imperio
			Effect(atom/movable/a)
				set waitfor = 0

				if(owner && ismonster(a))
					var/mob/Enemies/e = a
					var/mob/Player/p = owner

					var/limit = 1 + p.extraLimit + round(p.Summoning.level / 10)

					if(p.summons >= limit) return

					var/obj/summon/imperio/s = new  (e.loc, p)
					s.appearance = e.appearance
					s.dir = e.dir

					e.HP = 0
					e.Death_Check(e)

				else if(owner && owner.admin && isplayer(a))
					var/mob/Player/e = a
					var/mob/Player/p = owner

					var/obj/summon/imperio/s = new  (e.loc, p)
					s.appearance = e.appearance
					s.dir = e.dir

					e.nomove = 1
					e.invisibility = 100
					while(s.loc)
						e.loc = s.loc
						e.dir = s.dir
						sleep(1)
					e.nomove = 0
					e.invisibility = 0



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
						o.density = 0
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

		Potion
			var
				effect
				seconds
			Effect(atom/movable/a)

				if(src.owner && isplayer(a))
					var/mob/Player/p = a
					owner << "Your [src] hit [p]!"

					if(SHIELD_ALCHEMY in p.passives) return

					var/StatusEffect/Potions/s = locate() in p.LStatusEffects
					if(s)
						owner << "[p] already is under the influence of a potion."
						return

					p << infomsg("[src] splashes on you.")
					new effect (p, seconds, "Potion", src)



		Transfiguration

			Effect(atom/movable/a)
				set waitfor = 0
				if(src.owner)
					if(isplayer(a))
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
					else if(isobj(a) && !istype(a, /obj/items))

						var/tmpIcon  = a.icon
						var/tmpState = a.icon_state

						src.owner:learnSpell(name, 10)

						if(a.trnsed)
							a.trnsed = 0
							animate(a, icon = a.icon, icon_state = a.icon_state, time = 0, flags = ANIMATION_END_NOW)
						else
							a.trnsed = 1
							animate(a, icon = 'Transfiguration.dmi', icon_state = name, time = 100)
							animate(icon = tmpIcon, icon_state = tmpState, time = 0)

							for(var/i = 1 to 100)
								if(!a || !a.trnsed) return
								sleep(1)
							a.trnsed = 0



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

				var/step = 20 / max(MAX_VELOCITY - velocity, 1)

				time += (max_time - min_time) / step

			Effect(atom/movable/a)

				if(src.owner)
					if(isplayer(a))
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
					else if(ismonster(a))
						var/mob/Enemies/e = a
						var/t = time
						if(e.isElite) t *= 0.5
						if(e.level > owner.level) t *= 0.5
						if(e.level >= 1000) t *= 0.5

						if(!a.findStatusEffect(/StatusEffect/Bind))
							new /StatusEffect/Bind (a,t,time=t*10)

							owner:learnSpell(name, 10)

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

			Dir

				Tornado
					New(loc,dir,mob/mob,icon,icon_state,damage,name,element)
						set waitfor = 0
						..(loc,dir,mob,icon,icon_state,damage,name,element)

						var/mutable_appearance/ma = new

						ma.icon = icon
						ma.icon_state = icon_state

						var/list/layers = list()
						var/range = 4

						for(var/i = 1 to range)

							var/list/images = list()
							for(var/d = 0 to 359 step (52 + (range - i) * 2))
								var/matrix/m = matrix()
								m.Translate(28 - (range - i) * 4, 0)
						//		m.Translate(24, 0)
								ma.transform = turn(m, d)

								images += ma.appearance

							var/obj/o = new
							o.overlays = images
							o.layer = 5

							o.pixel_y = 16 * (i - 1)

							layers += o

							var/matrix/m = matrix()
							m.Turn(90)
							animate(o, transform = m, time = 10, loop = -1)
							m.Turn(90)
							animate(transform = m, time = 10)
							m.Turn(90)
							animate(transform = m, time = 10)
							animate(transform = null, time = 10)

						vis_contents += layers

						if(ismonster(mob))
							while(loc)
								for(var/mob/Player/e in range(1, src))
									e.onDamage(damage*0.9, mob, elem=element)
								sleep(10)
						else
							while(loc)
								for(var/mob/Enemies/e in range(1, src))
									e.onDamage(damage*0.9, mob, elem=element)
								sleep(5)

					Dispose()
						..()
						vis_contents = null


				Effect(atom/movable/a)
					if(owner && (isplayer(a) || istype(a, /mob/Enemies)))
						dir = pick(list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST) - dir)
						walk(src, dir, 2)


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
					if(m.HP - damage <= 0 && prob(60))
						var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						for(var/d in dirs)
							owner.castproj(Type = type, icon_state = icon_state, damage = round(damage/2), name = name, cd = 0, Loc = a.loc, Dir = d, element = element)

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

atom/movable/var/tmp/trnsed = 0
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
	Log_admin("[src] remote views [M]")
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

	usr:Interface.SetDarknessColor(TELENDEVOUR_COLOR)

	usr<<"You return to your body."

obj/var
	wlable = 0

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

		list/Players
		obj/clock/timed = 0

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

			if(timed)
				if(timed == 2)

					var/hudobj/Timer/t = locate() in M.client.screen

					if(t)
						t.hide()
						partner.timed.related -= t
						if(partner.timed.related.len == 0)
							partner.timed.related = null


					partner.Players -= M
					if(partner.Players.len == 0)
						partner.Players = null

				else
					if(!Players) Players = list()
					Players += M

					var/hudobj/Timer/t = new(null, M.client, null, show=1)

					t.maptext = timed.maptext

					if(!timed.related)
						timed.related = list()
					timed.related += t


	Dispose()
		if(Players)
			for(var/mob/Player/p in Players)
				var/area/playerArea = p.loc.loc
				if(playerArea.timedArea)
					p.Transfer(loc)

			Players = null

		if(timed && timed != 2)

			for(var/hudobj/h in timed.related)
				h.hide()

			timed.related = null

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

		if(dash && wand && wandCharge >= 10 && !wandLock)
			wandCharge -= 10
			wand.wandPower.setCharge(wandCharge)
			dash = 5
			return

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
			if("Gladius")
				m:Gladius()
			if("Spellbook")
				if(!m:usedSpellbook)
					lastAttack = "Inflamari"
				else
					m:usedSpellbook.cast(m)

mob/Player/var/cooldownModifier = 1
mob/Player/var/tmp/extraCDR = 0
mob/Player/var/tmp/list/passives


obj/wand

	icon_state = "item"

	var/obj/Shadow/s

	New()
		..()

		icon = pick('ash_wand.dmi', 'birch_wand.dmi', 'blood_wand.dmi', 'cedar_wand.dmi', 'dragonhorn_wand.dmi', 'duel_wand.dmi', 'elder_wand.dmi', 'interruption_wand.dmi', 'light_wand.dmi', 'mahogany_wand.dmi',\
		 'maple_wand.dmi', 'mithril_wand.dmi', 'mulberry_wand.dmi', 'oak_wand.dmi', 'royale_wand.dmi', 'salamander_wand.dmi', 'willow_wand.dmi')


		s = new

		s.pixel_y = - 16
		s.appearance_flags |= RESET_TRANSFORM|PIXEL_SCALE
		var/matrix/m = matrix()
		m.Scale(1.6, 1)
		s.transform = m

		vis_contents += s

		m = matrix()
		m.Turn(90)
		animate(src, transform = m, time = 6, loop = -1)
		m.Turn(90)
		animate(transform = m, time = 6)
		m.Turn(90)
		animate(transform = m, time = 6)
		animate(transform = null, time = 6)