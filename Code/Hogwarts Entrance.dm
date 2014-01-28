/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob
	Player
		verb
			anorth()
				set hidden = 1
				if(usr.stuned||usr.frozen||usr.GMFrozen||usr.arcessoing) return
				else dir = NORTH
			/*	for(var/atom/A in src.loc)
					if(istype(A,/obj/mirror/base))
						M.SteppedOn(A)
						break*/
			asouth()
				set hidden = 1
				if(usr.stuned||usr.frozen||usr.GMFrozen||usr.arcessoing) return
				else dir = SOUTH
			awest()
				set hidden = 1
				if(usr.stuned||usr.frozen||usr.GMFrozen||usr.arcessoing) return
				else dir = WEST
			aeast()
				set hidden = 1
				if(usr.stuned||usr.frozen||usr.GMFrozen||usr.arcessoing) return
				else dir = EAST
			anorthwest()
				set hidden = 1
				if(usr.stuned||usr.frozen||usr.GMFrozen||usr.arcessoing) return
				else dir = NORTHWEST
			anortheast()
				set hidden = 1
				if(usr.stuned||usr.frozen||usr.GMFrozen||usr.arcessoing) return
				else dir = NORTHEAST
			asouthwest()
				set hidden = 1
				if(usr.stuned||usr.frozen||usr.GMFrozen||usr.arcessoing) return
				else dir = SOUTHWEST
			asoutheast()
				set hidden = 1
				if(usr.stuned||usr.frozen||usr.GMFrozen||usr.arcessoing) return
				else dir = SOUTHEAST
turf
	rightcorner
		icon_state = "rightcorner"
		density = 1
		layer = TURF_LAYER + 2
	leftcorner
		icon_state = "leftcorner"
		density = 1
		layer = TURF_LAYER + 2
	tope
		icon_state = "top"
		density = 1
		layer = TURF_LAYER + 2
	right2
		icon_state = "right2"
		density = 1
		layer = TURF_LAYER + 2
	left2
		icon_state = "left2"
		density = 1
		layer = TURF_LAYER + 2