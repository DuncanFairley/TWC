/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/Player
	var/tmp/slow = 0
	Move(newloc, newdir)
		if(teleporting)
			..()
			return
		if(frozen||stuned||moving||arcessoing||GMFrozen)return
		if(isobj(newloc))
			..()
		else if(loc)
			if((loc:slow && !unslow) || slow)
				var/delay = slow == 0 ? loc:slow : slow
				moving=1
				..()
				sleep(delay)
				moving=0
			else
				..()
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