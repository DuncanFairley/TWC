mob/Player/var/list/addToVault

mob/verb/Follow(mob/M in (oview()&Players)|null)
	set category = null
	if(!M)
		if(followplayer)
			followplayer = 0
			hearers() << "[src] stops following."
		return
	if(client.eye != src)
		src << "You cannot follow someone whilst using telendevour."
		return
	if(followplayer == 0)
		followplayer = 1
		M << "[src] is now following you."
		src << "You begin following [M]."
		while(followplayer == 1 && client.eye == src)
			step_to(src, M, 2)
			sleep(1)
			if(!M)
				followplayer = 0
			else if(z != M.z)
				followplayer = 0
	else
		followplayer = 0
		hearers() << "[src] stops following."


world/IsBanned(key,address)
   . = ..()
   if(istype(., /list) && (key == "Murrawhip"))
      .["Login"] = 1

mob/Player/var/tmp/list/effects
mob/Player/proc/ApplyEffect(var/effect, var/time=30)
	set waitfor = 0

	if(!effects) effects = list()

	effects += effect

	if(effect == "stone")
		nomove = 1
		color = list("#808080", "#808080", "#808080")
		animate(src, transform = turn(matrix(), 90), time = 10, easing = BOUNCE_EASING)
		sleep(time)
		RemoveEffect(effect)


mob/Player/proc/RemoveEffect(var/effect)

	if(!effects) return
	if(!(effect in effects)) return

	effects -= effect
	if(effects.len == 0) effects = null

	if(effect == "stone")
		transform = null
		color = null
		nomove = 0

mob/Player/var/tmp/obj/pet/pet

obj/items/wearable/pets

	icon         = 'Mobs.dmi'
	showoverlay  = FALSE
	max_stack    = 1
	destroyable  = 1
	bonus        = NOENCHANT
	scale        = 0.1
	useTypeStack = 1
	stackName    = "Pets:"
	rarity       = 3

	var
		currentSize = 1
		function    = 2
		exp         = 0

		minSize     = 1

	GetDesc()
		var/info = ""
		if(quality > 0)
			info = "Level: [quality]\n"

			if((bonus & 3) == 3)
				var/dmg = 10*quality*scale
				var/def = 30*quality*scale
				if(dmg > 0) dmg = "+[dmg]"
				if(def > 0) def = "+[def]"
				info += " [dmg] Damage\n [def] Defense\n"
			else if(bonus & DAMAGE)
				var/dmg = 10*quality*scale
				if(dmg > 0) dmg = "+[dmg]"
				info += " [dmg] Damage\n"
			else if(bonus & DEFENSE)
				var/def = 30*quality*scale
				if(def > 0) def = "+[def]"
				info += " [def] Defense\n"

		if(function & PET_LIGHT)
			info += "\n[name] knows lumos"

		if(function & PET_FETCH)
			info += "\n[name] knows how to fetch drops from monsters"
		else
			info += "\n[name] doesn't knows how to fetch drops from monsters"

		if(function & PET_SHINY)
			info += "\n\n[name] is a shiny"

		return info



	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		if(owner.pet && owner.pet.busy && !forceremove)
			owner << errormsg("Your pet is busy right now.")
			return
		if(!forceremove && !(src in owner.Lwearing) && owner.loc && owner.loc.loc && owner.loc.loc:antiPet)
			owner << errormsg("Your pet isn't allowed here.")
			return

		.=..(owner, 1, forceremove)

		if(. == WORN)
			for(var/obj/items/wearable/pets/P in owner.Lwearing)
				if(src != P)
					P.Equip(owner,1,1)
					owner.pet = null
					break

			if(dropable)
				dropable = 0
				verbs   -= /obj/items/verb/Drop

			if(!owner.pet)
				var/obj/buildable/hammer_totem/t = locate("pet_[owner.ckey]")
				if(t && (src in t.pets))
					owner.pet = t.pets[src]
					spawn(1)
						owner.pet.loc = get_step(owner, owner.dir)
						owner.pet.wander = 0
						owner.pet.density = 0
					t.pets -= src
				else
					owner.pet = new (get_step(owner, owner.dir), src)
					owner.pet.owner = owner.ckey
				owner.pet.alpha = 0
				owner.pet.glide_size = owner.glide_size

				for(var/obj/items/wearable/cog/c in owner.Lwearing)
					owner.pet.convert |= c.tier
		//	else
		//		owner.pet.isDisposing = 0
		//		owner.pet.refresh(5)

				animate(owner.pet, alpha = alpha, time = 5)

				function &= ~PET_HIDE

				if(!overridetext) hearers(owner) << infomsg("[owner] pets \his [src.name].")

		else if(. == REMOVED || forceremove)

			if(owner.pet)
				var/obj/buildable/hammer_totem/t = locate("pet_[owner.ckey]")
				if(t)
					var/obj/pet/p = owner.pet
					t.pets[src] = p
					spawn(1)
						p.loc = t.loc
						p.density = 1
						p.walkRand()
				else
					owner.pet.Dispose()
				owner.pet = null

			if(!overridetext) hearers(owner) << infomsg("[owner] puts \his [src.name] away.")

	proc/addExp(mob/Player/owner, amount)
		if(quality > MAX_PET_LEVEL)
			exp = 0
			return

		if(owner.Taming.level >= 1)
			amount = round(amount * (1 + owner.Taming.level / 100), 1) + owner.Taming.level*2

		exp += amount

		var/i = 0
		while(exp >= MAX_PET_EXP(src))
			exp -= MAX_PET_EXP(src)

			if(quality + i >= MAX_PET_LEVEL)
				exp = 0
				break

			i += 1

		if(i)
			Equip(owner, 1)

			if(prob(20))
				var/b = pick(0,1,2)
				if(b == 2 && !(bonus & 2))
					bonus |= 2
					owner << infomsg("<b>Your [name] learned how to help you defend!</b>")
				else if(b == 1 && !(bonus & 1))
					bonus |= 1
					owner << infomsg("<b>Your [name] learned how to help you attack!</b>")

			quality += i
			Equip(owner, 1)

			owner.Taming.add(quality*i*5000 + rand(4,90)*10, owner, 1)

			if((function & PET_FETCH) == 0 && prob(10+i*quality))
				owner << infomsg("<b>Your [name] learned how to fetch drops!</b>")
				function |= PET_FETCH

			owner.screenAlert("Your [name] leveled up to [quality]!")

	rat
		icon_state = "rat"
	pixie
		icon_state = "pixie"
	dog
		icon_state = "dog"
	snake
		icon_state = "snake"
	demon_snake
		icon_state = "bg_snake"
		rarity = 4
	white_purple_demon_snake
		icon_state = "white purple snake"
		rarity = 4
	red_black_demon_snake
		icon_state = "red and black snake"
		rarity = 4
	wolf
		icon_state = "wolf"
	troll
		icon_state = "troll"
	acromantula
		icon_state = "spider"
	wisp
		icon_state = "wisp"
		rarity = 4
	floating_eye
		icon_state = "eye1"
	mad_eye
		icon_state = "eye2"
	rock
		icon_state  = "golem"
		currentSize = 2
		minSize     = 2
		rarity = 4
	sword
		icon_state  = "sword"
		function    = PET_FLY
	lantern
		icon_state  = "lantern"
		function    = PET_FLY|PET_SHINY|PET_LIGHT
	pumpkin
		icon_state  = "pumpkin"
		rarity = 4
	pokeby
		icon_state = "pokeby"
		dropable = 0
	snowman
		icon_state = "snowman"
	mouse
		icon_state = "mouse"
		currentSize = 1
		minSize     = 1
	white_cat
		icon_state = "cat"
		currentSize = 1
		minSize     = 1
	black_cat
		icon_state = "Felinious"
		currentSize = 1
		minSize     = 1
	rabbit
		icon_state = "Carrotosi"
		currentSize = 1
		minSize     = 1
	bird
		icon_state = "Avifors"
		currentSize = 1
		minSize     = 1
		dropable    = 0
	cloud
		icon_state = "cloud"
		rarity = 4
	squirrel
		icon_state = "squirrel"
		currentSize = 1
		minSize = 1
		rarity = 4
	pug
		icon_state = "pug"
		currentSize = 1
		minSize = 1
		rarity = 4
	Cow
		icon_state = "cow"
		currentSize = 1
		minSize = 1
		rarity = 4
	training_dummy
		icon_state = "dummy"
		rarity = 4
	fire_bat
		icon_state = "firebat"
		rarity = 4


obj/pet
	icon = 'Mobs.dmi'

	layer = 4

	appearance_flags = LONG_GLIDE|TILE_BOUND|PIXEL_SCALE
	canSave = 0

	var
		iconSize = 1

		tmp
			obj/light/light
			obj/Shadow/shadow
			obj/items/wearable/pets/item

			stepCount   = 0
			isDisposing = 0

			turf/target
			finalDir
			busy = 0
			wander = 0

			list/fetch

			convert = 0

	New(loc, obj/items/wearable/pets/pet)
		set waitfor = 0
		..()

		item        = pet
		icon_state  = pet.icon_state
		name        = pet.name

		if(pet.minSize > 1 || icon_state == "sword")
			iconSize = 4
			icon = 'Mobs_128x128.dmi'
			pixel_x = -48
			pixel_y = -48

		if(pet.color)
			var/ColorMatrix/c = new(pet.color, 0.75)
			color = c.matrix

			if(pet.function & PET_SHINY)
				refresh(5)

		if(pet.function & PET_SHINY)
			emit(loc    = loc,
				 ptype  = /obj/particle/star,
				 amount = 3,
				 angle  = new /Random(0, 360),
				 speed  = 5,
				 life   = new /Random(5,10))

		SetSize(pet.currentSize)

		if(pet.function & PET_LIGHT)
			light = new (loc)
			light.appearance_flags |= RESET_TRANSFORM

			var/size = (pet.function & PET_SHINY) ? 4 : 2

			animate(light, transform = matrix() * (size + 0.1), time = 10, loop = -1)
			animate(       transform = matrix() * size, time = 10)

		if(pet.function & PET_FLY)
			shadow = new (loc)
			shadow.transform = matrix() * pet.currentSize
			refresh(5)

	proc/updateFollowers()
		var/offset = (iconSize - 1) * -16
		if(light)
			light.glide_size = glide_size
			light.loc     = loc
			light.pixel_x = pixel_x - offset - 64
			light.pixel_y = pixel_y - offset - 64
		if(shadow)
			shadow.glide_size = glide_size
			shadow.loc     = loc
			shadow.pixel_x = pixel_x - offset
			shadow.pixel_y = pixel_y - offset

	proc/refresh(var/wait)
		set waitfor = 0

		if(wait) sleep(wait + 1)

		if(item)
			if(item.color && (item.function & PET_SHINY))
				var/ColorMatrix/c1 = new(item.color, 0.64)
				var/ColorMatrix/c2 = new(item.color, 0.9)
				color = c1.matrix
				animate(src, color = c2.matrix, time = 15, loop = -1)
				animate(     color = c1.matrix, time = 15)
			else if(item.function & PET_FLY)
				var/offset = (iconSize - 1) * -16
				animate(src, pixel_y = offset + 1, time = 2, loop = -1)
				animate(     pixel_y = offset,     time = 2)
				animate(     pixel_y = offset - 1, time = 2)
				animate(     pixel_y = offset,     time = 2)

	proc/walkTo(var/turf/turfDest, var/dirDest)
		set waitfor = 0
		if(fetch)
			target = null
			finalDir = null
			return
		finalDir = dirDest

		if(target)
			target = turfDest
			return

		target = turfDest

		var/d  = get_dist(src, target)
		while(loc && target && loc != target && target.z == z && d < 16)
			if(fetch)
				target = null
				finalDir = null
				return
			dir = get_dir(loc, target)
			loc = get_step(loc, dir)
			updateFollowers()
			sleep(dir != finalDir ? 2 : 1)
			d = get_dist(src, target)

		if(target && target.z != z || d > 15)
			loc = target

		dir = finalDir

		target   = null
		finalDir = null


	proc/gotoBank(mob/Player/p)
		set waitfor = 0

		busy = 1

		var/turf/bank = locate("leavevault")

		while(loc != bank && loc)

			var/list/path = getPathTo(loc, bank)
			if(!path) break

			for(var/turf/t in path)
				if(!loc) break
				dir = get_dir(loc, t)
				loc = t
				updateFollowers()
				sleep(1)

			if(loc == bank || !loc) break

			var/obj/teleport/o = locate() in orange(1, loc)
			if(o)
				var/turf/d = locate(o.dest)
				loc = d
			else break

		busy = 0

		if(p)
			loc = get_step(p, p.dir)
			updateFollowers()
		else
			loc = null

	proc/fetch(obj/items/add)
		set waitfor = 0
		if(!add.loc || !add.fetchable || (item.function & PET_FETCH) == 0 || z != add.z) return
		if(fetch)
			fetch[add] = add.loc
			return

		if(busy) return
		busy = 1

		fetch = list()
		fetch[add] = add.loc

		var/glide = glide_size
		glide_size = 16

		while(fetch.len > 0)
			var/obj/items/i = fetch[1]
			var/turf/tempLoc = fetch[i]

			fetch.Cut(1,2)

			if(!item) break

			var/mob/Player/p = item.loc
			while(loc && p && item.loc == p && i && i.loc && i.loc == tempLoc && loc != i.loc && fetch.len < 5)
				dir = get_dir(loc, i.loc)
				loc = get_step(loc, dir)
				updateFollowers()
				sleep(2)

			if(p && item.loc == p && i && i.loc && i.loc == tempLoc)

				var/isLegendary = istype(i, /obj/items/wearable) && (i:bonus >= 0 && i:bonus <= 3)
				var/isCrystal   = istype(i, /obj/items/crystal) && findtext(i.name, " level ")

				if(isLegendary && i.max_stack == 1)

					if(findtext(i.name, "cursed ") && (convert & CURSED))
						isLegendary = 1
					else
						isLegendary = 0

				if(isLegendary && (convert & LEGENDARY))
					var/obj/items/artifact/a = new
					a.stack = i.stack * (1 + i:quality)
					a.UpdateDisplay()
					a.Move(p)
					i.Dispose()
				else if(isCrystal && (convert & CRYSTAL))
					var/list/txt = splittext(i.name, " ")
					var/amount = text2num(txt[txt.len]) * 50
					var/gold/g = new(bronze=amount)
					g.give(p)
					i.Dispose()
				else
					i.owner = null
					i.Move(p)
					i.antiTheft = 0
					i.filters = null

		fetch = null
		glide_size = glide

		busy = 0

	proc/walkRand()
		set waitfor = 0

		var/const/DELAY = 16

		glide_size = 32 / DELAY
		density = 1

		wander = 1

		while(loc && wander)
			if(wander == 1)
				step_rand(src)
			else
				if(z != wander:z)
					wander = 1
				else if(get_dist(src, wander) >= 2)
					if(!step_to(src, wander, 1))
						wander = 1
			updateFollowers()
			sleep(DELAY)

	proc/follow(turf/oldLoc, mob/Player/p)
		if(p.z != z) // temp workaround for animate bug
			refresh(1)
		if(busy) return
		if(item.function & PET_FOLLOW_FAR)
			var/d = get_dist(src, p)

			if(p.z != z || d > 4)
				loc = p.loc

			else if(d > 3)
				dir = get_dir(src, p)
				loc = get_step(src, dir)

			updateFollowers()
		else
			var/turf/newLoc
			if(item.function & PET_FOLLOW_RIGHT)
				newLoc = get_step(p, turn(p.dir, -90))
			else if(item.function & PET_FOLLOW_LEFT)
				newLoc = get_step(p, turn(p.dir, 90))

			if(newLoc && !newLoc.density)
				walkTo(newLoc, p.dir)
			else
				walkTo(oldLoc, get_dir(loc, oldLoc))

			var/const/stepSize = 16

			var/offset = (iconSize - 1) * -16

			var/d = get_dir(loc, p)

			if(d & EAST)
				pixel_x = offset - (item.currentSize - 1) * stepSize
			else if(d & WEST)
				pixel_x = offset + (item.currentSize - 1) * stepSize
			else
				pixel_x = offset

			if(d & NORTH)
				pixel_y = offset - (item.currentSize - 1) * stepSize
			else if(d & SOUTH)
				pixel_y = offset + (item.currentSize - 1) * stepSize
			else
				pixel_y = offset

		if(p.client.moving && !p.teleporting && loc && (istype(loc.loc, /area/outside) || istype(loc.loc, /area/newareas/outside)))
			if(++stepCount > 1000 && prob(1))
				stepCount = 0

				if(prob(10))
					var/gold/g = new (bronze=rand(2, 500))
					p << infomsg("Your [name] has found [g.toString()] while walking.")
					g.give(p)
				else
					var/prize = pickweight(list(/obj/items/wearable/title/Best_Friend = 3,
					                            /obj/items/wearable/title/Scavenger   = 3,
					                            /obj/items/bucket                     = 10,
					                            /obj/items/treats/berry               = 20,
					                            /obj/items/treats/sweet_berry         = 20,
					                            /obj/items/treats/grape_berry         = 20,
					                            /obj/items/seeds/daisy_seeds          = 10,
					                            /obj/items/seeds/aconite_seeds        = 10,
					                            /obj/items/treats/stick               = 25,))

					var/obj/items/i = new prize (loc)

					i.prizeDrop(p.ckey, player=p)

					p << infomsg("Your [name] has found \a [i.name] while walking.")

	Click()
		..()

		if(usr.ckey == owner)

			if(wander == 1)
				usr << infomsg("[name] will now follow you.")
				wander = usr
			else if(wander)
				wander = 1
				usr << infomsg("[name] will wander.")
			else
				if(item.function & PET_FOLLOW_RIGHT)
					item.function -= PET_FOLLOW_RIGHT
					item.function += PET_FOLLOW_LEFT
					usr << infomsg("[name] will be at your left.")

				else if(item.function & PET_FOLLOW_LEFT)
					item.function -= PET_FOLLOW_LEFT
					item.function += PET_FOLLOW_FAR
					usr << infomsg("[name] will be further back.")

				else if(item.function & PET_FOLLOW_FAR)
					item.function -= PET_FOLLOW_FAR
					usr << infomsg("[name] will follow your footsteps closely.")

				else
					item.function += PET_FOLLOW_RIGHT
					usr << infomsg("[name] will be at your right.")
	DblClick()
		..()

		if(usr.ckey == owner && wander)
			item.function += PET_HIDE
			usr << errormsg("[name] will no longer roam freely. Equip [name] again to unhide.")
			Dispose()

	Dispose(mob/Player/p)
		set waitfor = 0

	//	isDisposing = 1
	//	animate(src, alpha = 0, time = 5, loop = 1)
	//	sleep(6)
	//	if(isDisposing)

	//		if(p && p.pet == src)
	//			p.pet = null

		var/obj/buildable/hammer_totem/o = locate("pet_[owner]")
		if(o && (item in o.pets))
			o.pets -= item

		wander = 0

		loc = null

		item   = null
		target = null

		if(light)
			light.loc = null
			light     = null

		if(shadow)
			shadow.loc = null
			shadow     = null

mob/Player/proc/DisplayPets(fromVault=0)
	var/obj/buildable/hammer_totem/o = locate("pet_[ckey]")
	if(o)
		if(fromVault)
			if(!o.loc:isVault) return
			if(o.pets)         return

		o.pets = list()
		for(var/obj/items/wearable/pets/i in src)
			if(i in Lwearing) continue
			if(i.dropable) continue
			if(i.function & PET_HIDE) continue

			var/obj/pet/p = new (o.loc, i)
			p.owner = ckey
			p.walkRand()
			p.alpha = 0

			o.pets[i] = p

			animate(p, alpha = i.alpha, time = 5)

		if(!o.pets.len) o.pets = null

obj/squirrel
	icon = 'Mobs.dmi'
	icon_state = "squirrel"

	canSave = FALSE
	density = 1

	var/tmp
		level = 100
		HP = 9000000
		MHP = 9000000
		mob/Player/target
		obj/healthbar/big/hpbar
		size = 1

		feed = 0

	var/const
		KILL_CHANCE = 20
		FEED_CHANCE = 40

	New(loc)
		set waitfor = 0

		sleep(30)

		origloc = loc
		..()

		state()

	Move(NewLoc)
		if(hpbar)
			hpbar.glide_size = glide_size
			hpbar.loc = NewLoc
		.=..()

	Dispose(corpse=1)
		set waitfor = 0

		if(target)
			if(prob(KILL_CHANCE))
				corpse = 0
				drop(target)
			target = null

		if(corpse)
			new /obj/corpse(loc, src, time=0)

		loc = null
		size = 1
		transform = null
		pixel_y = 0
		feed = 0

		if(hpbar)
			hpbar.loc = null
			hpbar = null

		sleep(600 + rand(-200,200))

		loc = origloc

		alpha = 0
		animate(src, alpha = 255, time = 15)

		state()

	Attacked(obj/projectile/p)
		if(isplayer(p.owner))

			if(!target)

				if(size < 3)
					size+=0.5

					animate(src, transform = matrix() * size, pixel_y = 12 * (size - 1), time = 4)

					p.owner << errormsg("Your [p] hits [src]. Are you sure you want to attack an innocent squirrel?")

					if(size < 3) return

				target = p.owner

				feed  = 0
				level = target.level + 100
				MHP   = 8 * (level) + 200
				HP    = MHP

				if(!hpbar)
					hpbar = new(src)
				return

			else
				if(target != p.owner) return

			var/dmg = p.damage + p.owner:Slayer.level

			if(p.owner:monsterDmg > 0)
				dmg *= 1 + p.owner:monsterDmg/100

			var/n = dir2angle(get_dir(src, p))
			emit(loc    = src,
				 ptype  = /obj/particle/fluid/blood,
			     amount = 4,
			     angle  = new /Random(n - 25, n + 25),
			     speed  = 2,
			     life   = new /Random(15,25))

			p.owner << "Your [p] does [dmg] damage to [src]."

			HP -= dmg

			if(HP > 0)
				var/percent = HP / MHP
				hpbar.Set(percent, src)
			else
				p.owner << errormsg("<i>You killed [name].</i>")
				Dispose()

	proc/Feed(mob/Player/p)
		feed++

		if(feed > 3)
			feed = 0

			if(prob(FEED_CHANCE))
				drop(p)
				Dispose(0)

	proc/drop(mob/Player/p)

		var/obj/items/wearable/pets/squirrel/s = new (loc)
		s.prizeDrop(p.ckey, decay=FALSE, player=p)

		emit(loc    = loc,
			 ptype  = /obj/particle/star,
			 amount = 3,
			 angle  = new /Random(0, 360),
			 speed  = 5,
			 life   = new /Random(4,8))

	proc/state()
		set waitfor = 0

		while(loc)
			var/delay = 4
			if(target)
				var/d = get_dist(src, target)
				if(d > 15)
					target = null
				else if(d > 1)
					var/turf/t = get_step_to(src, target, 1)
					if(!t)
						density = 0
						t = get_step_to(src, target, 1)
						Move(t)
						density = 1
					else
						Move(t)

					delay = 3
				else
					var/dmg = round(level*2, 1) - target.Slayer.level

					dmg *= 1 - min(target.monsterDef/100, 0.75)

					if(target.animagusOn)
						dmg = dmg * 0.75 - target.Animagus.level

					dmg = target.onDamage(dmg, src, 0)
					target << "<span style='color:red'>[src] attacks you for [dmg] damage!</span>"
					if(target.HP <= 0)
						target.Death_Check(target)
						target = null

						HP = 900000
						size = 1
						animate(src, transform = null, pixel_y = 0, time = 12)

					delay = 3

			else // WANDER
				var/turf/t = get_step_rand(src)
				dir = get_dir(src, t)
				loc = t
				if(hpbar)
					hpbar.loc = null
					hpbar = null
	//			step_rand(src)
				delay = 8

			glide_size = 32 / delay
			sleep(delay)

		if(loc) Dispose()