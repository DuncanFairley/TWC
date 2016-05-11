/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

mob
	Bump(var/atom/movable/a)
		.=..()

		if(istype(a, /obj/brick2door) || istype(a, /obj/Hogwarts_Door))
			var/obj/brick2door/o = a
			if(o.door)
				spawn()
					o.Bumped(src)

obj/static_obj
	Red_Carpet_Corners
		icon='floors2.dmi'
		name = "Red Carpet"
		icon_state="south"
	Hogwarts_Stone_Arch
		icon = 'wall1.dmi'
		icon_state = "arch"

turf
	Hogwarts_Stone_Wall
		opacity=0
		density=1
		flyblock=1
		icon='wall1.dmi'
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
		icon='Door.dmi'
		density=1
		icon_state="closed"
		opacity=1
		post_init = 1

		var
			pass=""
			tmp/lastopener
			door=1

			claimed
			vaultOwner


		gate
			icon = 'gate.dmi'
		toiletstall
			icon = 'Stall.dmi'
		roofb
			icon = 'roofbdoor.dmi'
			icon_state = "roof-15"

			New()
				loc.name = "roofb"
				..()

			MapInit()

				..()

				var/turf/floor = loc
				var/n = 15 - floor.autojoin("name", "roofb")

				var/list
					dirs  = list(NORTH, SOUTH, EAST, WEST)
					edges = list()

				edges["4"] = list(/image/roofedge/east)
				edges["8"] = list(/image/roofedge/west)
				edges["1"] = list(/image/roofedge/north)
				edges["2"] = list(/image/roofedge/south)

				for(var/d in dirs)
					if((n & d) > 0)

						var/turf/t = get_step(src, d)
						if(!t || istype(t, /turf/blankturf)) continue
						t.overlays = t.overlays.Copy() + edges["[d]"]

						n -= d

		MapInit()
			var/turf/T = src.loc
			if(T)T.flyblock=2

			density    = 1
			icon_state = "closed"

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
				p << infomsg("Authorization Confirmed.")

			if(vaultOwner && claimed && usr.ckey != claimed && usr.ckey != vaultOwner)
				return

			if(icon_state != "open")
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