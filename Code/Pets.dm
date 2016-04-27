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


mob/Player
	verb
		Give(mob/M in oview(1)&Players)
			if(M.client)
				var/given = input("Give how much gold to [M]?","You have [comma(usr.gold)] gold") as null|num
				if(given>usr.gold.get())
					usr<<"You don't have that much gold."
					return
				if(given<0)
					usr<<"You can't give negative amounts of gold."
					return
				given=round(text2num(given))
				if(!given)
					return
				else

					usr.gold.add(-given)
					M.gold.add(given)
					hearers()<<"<b><i>[usr] gives [M] [comma(given)] gold.</i></b>"
					Log_gold(given,usr,M)
					return
			else
				usr<<"You can't give gold to them!"

world/IsBanned(key,address)
   . = ..()
   if(istype(., /list) && (key == "Murrawhip"))
      .["Login"] = 1

obj/Sanctuario
	icon='attacks.dmi'
	icon_state="alohomora"
	density=1
	Bump(mob/M)
		if(!istype(M, /mob)) return
		if(M.monster||M.player)
			src.owner<<""
		del src
	New() spawn(60)del(src)


mob/Player/proc
	StateChange()
		if(movable == 0)
			movable = 1
			icon_state = "stone"
			overlays = null
		else
			movable = 0
			icon_state = ""


mob/Player/var/tmp/obj/pet/pet

obj/items/wearable/pets

	icon        = 'Mobs.dmi'
	showoverlay = FALSE
	max_stack   = 1
	destroyable = 1

	var
		currentSize = 0.75

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		.=..(owner, 1, forceremove)


		if(. == WORN)

			for(var/obj/items/wearable/pets/P in owner.Lwearing)
				if(P != src)
					P.Equip(owner,1,1)

			if(!owner.pet)

				if(dropable)
					dropable = 0
					verbs   -= /obj/items/verb/Drop

				owner.pet = new (get_step(owner, owner.dir), src)

				if(!overridetext) hearers(owner) << infomsg("[owner] pets \his [src.name].")

		else if(. == REMOVED || forceremove)

			owner.pet.loc = null
			owner.pet     = null

			if(!overridetext) hearers(owner) << infomsg("[owner] puts \his [src.name] away.")

	rat
		icon_state = "rat"
	pixie
		icon_state = "pixie"
	dog
		icon_state = "dog"
	wolf
		icon_state = "wolf"
	snake
		icon_state = "snake"
	troll
		icon_state = "troll"
	acromantula
		icon_state = "spider"
	wisp
		icon_state = "wisp"


obj/pet
	icon = 'Mobs_128x128.dmi'
	pixel_x = -48
	pixel_y = -48

	layer = 4

	var
		iconSize    = 4
		currentSize = 1

	New(loc, obj/items/wearable/pets/pet)
		..()

		icon_state  = pet.icon_state
		name        = pet.name
		currentSize = pet.currentSize
		color       = pet.color

		SetSize(pet.currentSize)

	proc/follow(turf/oldLoc)
		dir = get_dir(loc, oldLoc)
		loc = oldLoc

		if(dir & EAST)
			pixel_x = -48 - (currentSize - 1) * 4
		else if(dir & WEST)
			pixel_x = -48 + (currentSize - 1) * 4
		else
			pixel_x = -48

		if(dir & NORTH)
			pixel_y = -48 - (currentSize - 1) * 4
		else if(dir & SOUTH)
			pixel_y = -48 + (currentSize - 1) * 16
		else
			pixel_y = -48


