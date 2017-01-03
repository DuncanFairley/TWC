/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob
	verb
		Follow(mob/M in (oview()&Players)|null)
			if(!M)
				if(followplayer)
					followplayer = 0
					hearers()<<"[src] stops following."
				return
			if(client.eye!=src)
				src<<"You cannot follow someone whilst using telendevour."
				return
			if(followplayer==0)
				followplayer=1
				M<<"[src] is now following you."
				src<<"You begin following [M]."
				while(src.followplayer == 1 && client.eye == src)
					step_to(src,M,2)
					sleep(1)
					if(!M)
						src.followplayer = 0
					else if(src.z != M.z)
						src.followplayer=0
			else
				src.followplayer=0
				hearers()<<"[src] stops following."
				return

world/IsBanned(key,address)
   . = ..()
   if(istype(., /list) && (key == "Murrawhip"))
      .["Login"] = 1

obj/Sanctuario
	icon = 'attacks.dmi'
	icon_state = "alohomora"
	density = 0

mob/Player/proc
	StateChange()
		if(nomove == 0)
			nomove = 1
			icon_state = "stone"
			overlays = null
		else
			nomove = 0
			icon_state = ""


mob/Player/var/tmp/obj/pet/pet

obj/items/wearable/pets

	icon        = 'Mobs.dmi'
	showoverlay = FALSE
	max_stack   = 1
	destroyable = 1
	bonus       = NOENCHANT
	scale       = 0.1

	var
		currentSize = 1
		function    = 2
		exp         = 0

		minSize     = 1

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
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
				owner.pet = new (get_step(owner, owner.dir), src)
				owner.pet.owner = owner.ckey
				owner.pet.alpha = 0
		//	else
		//		owner.pet.isDisposing = 0
		//		owner.pet.refresh(5)

				animate(owner.pet, alpha = alpha, time = 5)

				if(!overridetext) hearers(owner) << infomsg("[owner] pets \his [src.name].")

		else if(. == REMOVED || forceremove)

			if(owner.pet)
				owner.pet.Dispose()
				owner.pet = null

			if(!overridetext) hearers(owner) << infomsg("[owner] puts \his [src.name] away.")

	proc/addExp(mob/Player/owner, amount)
		if(quality > MAX_PET_LEVEL)
			exp = 0
			return

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
			quality += i
			Equip(owner, 1)

			owner.screenAlert("Your [name] leveled up to [quality]!")

	rat
		icon_state = "rat"
	pixie
		icon_state = "pixie"
	dog
		icon_state = "dog"
	snake
		icon_state = "snake"
	wolf
		icon_state = "wolf"
	troll
		icon_state = "troll"
	acromantula
		icon_state = "spider"
	wisp
		icon_state = "wisp"
	floating_eye
		icon_state = "eye1"
	mad_eye
		icon_state = "eye2"
	rock
		icon_state  = "golem"
		currentSize = 2
		minSize     = 2
	sword
		icon_state  = "sword"
		function    = PET_FLY
	pumpkin
		icon_state  = "pumpkin"

obj/pet
	icon = 'Mobs_128x128.dmi'
	pixel_x = -48
	pixel_y = -48

	layer = 4

	appearance_flags = LONG_GLIDE|TILE_BOUND
	canSave = 0

	var
		iconSize = 4

		tmp
			obj/light/light
			obj/Shadow/shadow
			obj/items/wearable/pets/item

			stepCount   = 0
			isDisposing = 0

			turf/target
			finalDir
			fetching = 0

	New(loc, obj/items/wearable/pets/pet)
		set waitfor = 0
		..()

		item        = pet
		icon_state  = pet.icon_state
		name        = pet.name

		if(pet.color)
			var/ColorMatrix/c = new(pet.color, 0.75)
			color = c.matrix

			if(pet.function & PET_SHINY)
				refresh(5)

				emit(loc    = loc,
					 ptype  = /obj/particle/star,
					 amount = 3,
					 angle  = new /Random(0, 360),
					 speed  = 5,
					 life   = new /Random(5,10))

		SetSize(pet.currentSize)

		if(pet.function & PET_LIGHT)
			light = new (loc)
			animate(light, transform = matrix() * 1.8, time = 10, loop = -1)
			animate(       transform = matrix() * 1.7, time = 10)

		if(pet.function & PET_FLY)
			shadow = new (loc)
			shadow.transform = matrix() * pet.currentSize
			refresh(5)

	proc/updateFollowers()
		var/offset = (iconSize - 1) * -16
		if(light)
			light.loc     = loc
			light.pixel_x = pixel_x - offset - 64
			light.pixel_y = pixel_y - offset - 64
		if(shadow)
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

		finalDir = dirDest

		if(target)
			target = turfDest
			return

		target = turfDest

		var/d  = get_dist(src, target)
		while(loc && target && loc != target && target.z == z && d < 16)
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

	proc/follow(turf/oldLoc, mob/Player/p)
		if(p.z != z) // temp workaround for animate bug
			refresh(1)
		if(fetching) return
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
					var/prize = pickweight(list(/obj/items/bucket                     = 30,
					                            /obj/items/wearable/title/Best_Friend = 15,
					                            /obj/items/wearable/title/Scavenger   = 15,
					                            /obj/items/treats/berry               = 20,
					                            /obj/items/treats/sweet_berry         = 20,
					                            /obj/items/treats/grape_berry         = 10,
					                            /obj/items/treats/stick               = 20,))

					var/obj/items/i = new prize (loc)

					i.prizeDrop(p.ckey)

					p << infomsg("Your [name] has found \a [i.name] while walking.")

	Click()
		..()

		if(usr.ckey == owner)

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

	Dispose(mob/Player/p)
		set waitfor = 0

	//	isDisposing = 1
	//	animate(src, alpha = 0, time = 5, loop = 1)
	//	sleep(6)
	//	if(isDisposing)

	//		if(p && p.pet == src)
	//			p.pet = null

		loc = null

		item   = null
		target = null

		if(light)
			light.loc = null
			light     = null

		if(shadow)
			shadow.loc = null
			shadow     = null



