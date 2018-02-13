/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

#define CHANCEFORSNITCH	25 //% chance of catching the snitch

turf/quidditch
	icon = 'obj.dmi'
	density = 0
	left
		icon_state = "left"
	bleft
		icon_state = "bleft"
	bottom
		icon_state = "bottom"
	bright
		icon_state = "bright"
	tleft
		icon_state = "tleft"
	top
		icon_state = "top"
	tright
		icon_state = "tright"
	right
		icon_state = "right"

obj/quidditch
	snitch
		icon = 'obj.dmi'
		icon_state = "snitch"
		density = 1

		var
			caught
			prize

			tmp
				canCatch = 0

		New()
			..()
			Wander()

		proc/Wander()
			set waitfor = 0
			sleep(1)
			while(loc)
				step_rand(src)
				if(prob(30)) step_rand(src)
				sleep(world.tick_lag)

		Bump(atom/movable/O)
			if(!istype(O, /mob/Player)) return
			density = 0
			O.Move(loc, get_dir(O.loc, loc))
			density = 1

		verb
			Take()
				set waitfor = 0
				set src in oview(1)
				if(!usr.flying)
					usr << "<b>You must be flying to catch the snitch!</b>"
					return
				var/mob/Player/user = usr

				if(prob(CHANCEFORSNITCH))
					user << infomsg("You caught the snitch!")
					if(prize)
						if(prob(50)) // gold prize
							var/gold/g = new (bronze=rand(5000,10000))
							g.give(user)
							user << infomsg("You won [g.toString()].")
						else // house points prize
							var/housenum = 1
							var/points = rand(1,2)
							switch(user.House)
								if("Gryffindor")
									housenum = 1
								if("Slytherin")
									housenum = 2
								if("Ravenclaw")
									housenum = 3
								if("Hufflepuff")
									housenum = 4

							worldData.housepointsGSRH[housenum] += points

							user << infomsg("You won [points] house point[points != 1 ? "s" : ""].")
							Players << "\red[points] point[points != 1 ? "s have" : " has"] been added to [user.House]!"

					else
						Players << infomsg("[user] has caught the [name]!")
					loc = null
					walk(src, 0)
				else
					var/message = pick("You reach as high as you can, but just miss the snitch.",
						"The snitch flies out of your reach as you try to grab it.",
						"You miss the snitch by a mile")
					canCatch = 0
					user << errormsg(message)
					sleep(15)
					canCatch = 1






