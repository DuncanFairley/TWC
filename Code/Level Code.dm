/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/Player
	var/tmp/slow = 0

turf
	Exit(atom/movable/O, atom/newloc)
		.=..()

		if(isplayer(O) && .)
			var/mob/Player/p = O
			if(p.teleporting) return
			if(p.frozen || p.stuned || p.moving || p.arcessoing || p.GMFrozen)
				return 0
			if(isobj(newloc)) return

			var/turf/t = newloc
			if(((t && t.slow) || p.slow) && !p.unslow)
				var/delay = p.slow + t.slow
				p.moving=1
				sleep(delay)
				p.moving=0

turf/var/tmp/slow=0
mob
   var/tmp
      moving
mob
	var
		reading=0
		frozen=0
		stuned=0

turf
/*	DEblocker
		Enter(mob/You/Y)
			if(istype(Y,/mob/You))
				if(Y.Auror) return ..()

	Aurorblocker
		Enter(mob/You/Y)
			if(istype(Y,/mob/You))
				if(Y.DeathEater) return ..()*/
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