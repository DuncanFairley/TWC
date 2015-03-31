/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

turf/var/pass
turf/var/door=0
turf/var/tmp/owner=""
turf/var/bumpable=0
obj/var/bumpable=0
mob/var/bumpable=0
area/var/bumpable=0

mob
	Bump(var/turf/T)
		if(T.bumpable==1)
			if(ismob(T))return
			if(T.door==1)
				if(istype(T,/obj/brick2door))
					var/obj/brick2door/O = T
					spawn()O.Bumped(src)
					return
				if(istype(T,/obj/Hogwarts_Door))
					var/obj/Hogwarts_Door/O = T
					spawn()O.Bumped(src)
					return


turf
	var/lastopener
	stonedoor1
		bumpable=1
		name="Hogwarts Stone Wall"
		flyblock=1
		door=1
		icon='door1.dmi'
		density=1
		icon_state="closed"
		opacity=1
		pass="Roar"
	secretdoor
		bumpable=0
		name="Hogwarts Stone Wall"
		flyblock=1
		door=1
		icon='door1.dmi'
		density=1
		icon_state="closed"
		opacity=1
	Hogwarts_Stone_Wall
		bumpable=0
		opacity=0
		density=1
		flyblock=1
		icon='wall1.dmi'
	/*	Enter(atom/movable/O)
			if(ismob(O))
				if(!density) return ..()
				if(!O:Gm) return ..()
				if(!O:key) return ..()
				else if(density)
					return 0
			return ..()*/
	Hogwarts_Stone_Wall_
		bumpable=0
		opacity=0
		name="Hogwarts Stone Wall"
		density=1
		icon='wall1.dmi'
		flyblock = 1
	/*	Enter(atom/movable/O)
			if(ismob(O))
				if(!density) return ..()
				if(!O:Gm) return ..()
				if(!O:key) return ..()
				else if(density)
					return 0
			return ..()*/
	Ministry_Red_Carpet
		name = "Red Carpet"
		icon='floors2.dmi'
		icon_state="carpet"
	Red_Carpet
		icon='floors2.dmi'
		icon_state="carpet"
	Red_Carpet_Corners
		icon='floors2.dmi'
		name = "Red Carpet"
		icon_state="corner"
	Black_Tile
		icon='floors2.dmi'
		icon_state="greycarpet"
	FlashTile
		icon='floors2.dmi'
		icon_state="greycarpet"



	Duel_Star
		icon='DuelArena.dmi'
		icon_state="d"
	Duel_1
		icon='DuelArena.dmi'
		icon_state="d1"
	Duel_2
		icon='DuelArena.dmi'
		icon_state="d2"
	Duel_3
		icon='DuelArena.dmi'
		icon_state="d3"
	Duel_4
		icon='DuelArena.dmi'
		icon_state="d4"
	Duel_5
		icon='DuelArena.dmi'
		icon_state="d5"
	Duel_6
		icon='DuelArena.dmi'
		icon_state="d6"
	Duel_7
		icon='DuelArena.dmi'
		icon_state="d7"
turf
	C2
		icon='COMC Icons.dmi'
		icon_state="C2"
	C1
		icon='COMC Icons.dmi'
		icon_state="C1"
	darkstairs
		icon='Turff.dmi'
		icon_state="stairs"

obj
	Hogwarts_Door
		bumpable=1
		dontsave=0
		icon='Door.dmi'
		density=1
		icon_state="closed"
		opacity=1

		var
			pass=""
			lastopener
			door=1


		gate
			icon = 'gate.dmi'
		toiletstall
			icon = 'Stall.dmi'
		roofb
			icon = 'roofbdoor.dmi'

			New()
				..()
				spawn()
					loc.name = "roofb"

					var/turf/t = loc
					var/n = 15 - t.autojoin("name", "roofb")

					var/dirs = list(NORTH, SOUTH, EAST, WEST)
					for(var/d in dirs)
						if((n & d) > 0)

							var/obj/roofedge/o = new (t)
							o.layer = d == NORTH ? 6 : 7

							if(d == SOUTH)
								o.pixel_x = -32
								o.x++
							else if(d == EAST)
								o.pixel_y = 32
								o.y--
							else if(d == WEST)
								o.pixel_x = 32
								o.x--
							else if(d == NORTH)
								o.pixel_y = -32
								o.y++

							o.icon_state = "edge-[15 - d]"
							n -= d
		New()
			..()
			var/turf/T = src.loc
			if(T)T.flyblock=2

			spawn()
				density = 1
				icon_state = "closed"

		proc/Bumped(mob/Player/p)

			if(pass != "" && owner != p.key)
				var/passtry = input(p, "This is a Secure Area. Please enter Authorization Code.","Incarcerous Charm","") as text
				passtry = copytext(passtry, 1, 500)
				if(passtry != pass)	return
				p << "<font color=green><b>Authorization Confirmed."

			if(icon_state != "open")
				bumpable = 0
				lastopener = usr.key
				flick("opening", src)
				opacity = 0
				sleep(4)
				icon_state="open"
				density=0
				sleep(50)
				while(locate(/mob) in loc) sleep(10)
				flick("closing", src)
				density=1
				sleep(4)
				opacity = initial(opacity)
				icon_state="closed"
				bumpable = 1