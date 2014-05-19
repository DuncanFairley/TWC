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
				if(moving||stuned||frozen||GMFrozen||arcessoing) return
				dir = NORTH
				moving = 1
				sleep(0)
				moving = 0

			/*	for(var/atom/A in src.loc)
					if(istype(A,/obj/mirror/base))
						M.SteppedOn(A)
						break*/
			asouth()
				set hidden = 1
				if(moving||stuned||frozen||GMFrozen||arcessoing) return
				dir = SOUTH
				moving = 1
				sleep(0)
				moving = 0
			awest()
				set hidden = 1
				if(moving||stuned||frozen||GMFrozen||arcessoing) return
				dir = WEST
				moving = 1
				sleep(0)
				moving = 0
			aeast()
				set hidden = 1
				if(moving||stuned||frozen||GMFrozen||arcessoing) return
				dir = EAST
				moving = 1
				sleep(0)
				moving = 0
			anorthwest()
				set hidden = 1
				if(moving||stuned||frozen||GMFrozen||arcessoing) return
				dir = NORTHWEST
				moving = 1
				sleep(0)
				moving = 0
			anortheast()
				set hidden = 1
				if(moving||stuned||frozen||GMFrozen||arcessoing) return
				dir = NORTHEAST
				moving = 1
				sleep(0)
				moving = 0
			asouthwest()
				set hidden = 1
				if(moving||stuned||frozen||GMFrozen||arcessoing) return
				dir = SOUTHWEST
				moving = 1
				sleep(0)
				moving = 0
			asoutheast()
				set hidden = 1
				if(moving||stuned||frozen||GMFrozen||arcessoing) return
				dir = SOUTHEAST
				moving = 1
				sleep(0)
				moving = 0
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