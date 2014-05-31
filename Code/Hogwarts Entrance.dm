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
				if(client.moving||stuned||frozen||GMFrozen||arcessoing) return
				client.moving = 1
				dir = NORTH
				sleep(0)
				client.moving = 0

			/*	for(var/atom/A in src.loc)
					if(istype(A,/obj/mirror/base))
						M.SteppedOn(A)
						break*/
			asouth()
				set hidden = 1
				if(client.moving||stuned||frozen||GMFrozen||arcessoing) return
				client.moving = 1
				dir = SOUTH
				sleep(0)
				client.moving = 0
			awest()
				set hidden = 1
				if(client.moving||stuned||frozen||GMFrozen||arcessoing) return
				client.moving = 1
				dir = WEST
				sleep(0)
				client.moving = 0
			aeast()
				set hidden = 1
				if(client.moving||stuned||frozen||GMFrozen||arcessoing) return
				client.moving = 1
				dir = EAST
				sleep(0)
				client.moving = 0
			anorthwest()
				set hidden = 1
				if(client.moving||stuned||frozen||GMFrozen||arcessoing) return
				client.moving = 1
				dir = NORTHWEST
				sleep(0)
				client.moving = 0
			anortheast()
				set hidden = 1
				if(client.moving||stuned||frozen||GMFrozen||arcessoing) return
				client.moving = 1
				dir = NORTHEAST
				sleep(0)
				client.moving = 0
			asouthwest()
				set hidden = 1
				if(client.moving||stuned||frozen||GMFrozen||arcessoing) return
				client.moving = 1
				dir = SOUTHWEST
				sleep(0)
				client.moving = 0
			asoutheast()
				set hidden = 1
				if(client.moving||stuned||frozen||GMFrozen||arcessoing) return
				client.moving = 1
				dir = SOUTHEAST
				sleep(0)
				client.moving = 0
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