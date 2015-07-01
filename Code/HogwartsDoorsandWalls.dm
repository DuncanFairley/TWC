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


obj
	Red_Carpet_Corners
		icon='floors2.dmi'
		name = "Red Carpet"
		icon_state="corner"
	Hogwarts_Stone_Arch
		bumpable = 0
		opacity = 0
		density = 0
		icon = 'wall1.dmi'
		icon_state = "arch"

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
	Hogwarts_Stone_Wall
		bumpable=0
		opacity=0
		density=1
		flyblock=1
		icon='wall1.dmi'
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
		icon='turf.dmi'
		icon_state="darkstairs"

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

			claimed
			vaultOwner


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

					var/turf/floor = loc
					var/n = 15 - floor.autojoin("name", "roofb")

					var/dirs = list(NORTH, SOUTH, EAST, WEST)
					for(var/d in dirs)
						if((n & d) > 0)

							var/obj/roofedge/o

							if(d == SOUTH)
								var/turf/t = locate(floor.x + 1, floor.y, floor.z)
								if(!t || istype(t, /turf/blankturf)) continue
								o = new (t)
								o.pixel_x = -32
							else if(d == EAST)
								var/turf/t = locate(floor.x, floor.y - 1, floor.z)
								if(!t || istype(t, /turf/blankturf)) continue
								o = new (t)
								o.pixel_y = 32
							else if(d == WEST)
								var/turf/t = locate(floor.x - 1, floor.y, floor.z)
								if(!t || istype(t, /turf/blankturf)) continue
								o = new (t)
								o.pixel_x = 32
							else
								var/turf/t = locate(floor.x, floor.y + 1, floor.z)
								if(!t || istype(t, /turf/blankturf)) continue
								o = new (t)
								o.pixel_y = -32

							o.layer = d == NORTH ? 6 : 7
							o.icon_state = "edge-[15 - d]"
							n -= d
		New()
			..()
			var/turf/T = src.loc
			if(T)T.flyblock=2

			spawn(1)
				density    = 1
				icon_state = "closed"
				bumpable   = 1
				door       = 1

				if(!vaultOwner)
					verbs -= /obj/Hogwarts_Door/verb/Claim
		verb/Claim()
			set src in oview(1)

			if(!claimed)
				claimed = usr.ckey
				usr << infomsg("This door will now open only to you")

			else if(vaultOwner == usr.ckey || claimed == usr.ckey)
				claimed = null
				usr << infomsg("This door is now unclaimed")


		proc/Bumped(mob/Player/p)

			if(pass != "" && owner != p.key)
				var/passtry = input(p, "This is a Secure Area. Please enter Authorization Code.","Incarcerous Charm","") as text
				passtry = copytext(passtry, 1, 500)
				if(passtry != pass)	return
				p << "<font color=green><b>Authorization Confirmed."

			if(vaultOwner && claimed && usr.ckey != claimed && usr.ckey != vaultOwner)
				return

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