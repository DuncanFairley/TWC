/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/Player
	var/tmp
		slow       = 0
		move_delay = 1

turf
	Exit(atom/movable/O, atom/newloc)
		.=..()

		if(isplayer(O) && .)
			var/mob/Player/p = O
			if(p.frozen || p.stuned || p.GMFrozen || p.arcessoing) return 0
			if(p.teleporting) return
			if(isobj(newloc)) return

			if(!p.unslow)
				var/turf/t = newloc
				p.move_delay = t.slow + 1
			else
				p.move_delay = 1

turf/var/tmp/slow = 0

mob
	var
		reading=0
		frozen=0
		stuned=0

turf
	Huffleblocker
		Enter(mob/Player/Y)
			if(istype(Y,/mob/Player))
				if(Y.House == "Hufflepuff") return ..()
	Slythblocker
		Enter(mob/Player/Y)
			if(istype(Y,/mob/Player))
				if(Y.House == "Slytherin") return ..()
	Ravenblocker
		Enter(mob/Player/Y)
			if(istype(Y,/mob/Player))
				if(Y.House == "Ravenclaw") return ..()
	Gryffblocker
		Enter(mob/Player/Y)
			if(istype(Y,/mob/Player))
				if(Y.House == "Gryffindor") return ..()
	DEblocker
		Enter(mob/Player/Y)
			if(istype(Y,/mob/Player))
				if(Y.aurorrobe) return ..()
	Aurorblocker
		Enter(mob/Player/Y)
			if(istype(Y,/mob/Player))
				if(Y.derobe) return ..()