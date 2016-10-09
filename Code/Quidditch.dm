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

turf/Entered(atom/movable/M)
	..()
	if(M)
		for(var/atom/A in src)
			if(A == M) continue
			if(!M || !M.loc)break
			M.SteppedOn(A)
turf/Exited(atom/movable/M)
	..()
	for(var/atom/A in src)
		if(A == M) continue
		if(!M)break
		M.SteppedOff(A)



atom/movable/proc/SteppedOn(atom/movable/A)

atom/movable/proc/SteppedOff(atom/movable/A)



mob/Player/SteppedOn(atom/movable/A)
	if(istype(A,/obj/items/Whoopie_Cushion))
		if(A:isset)
			A:Fart(src)
	else if(istype(A,/obj/drop_on_death))
		A:take(src)
	else if(istype(A,/obj/mirror/base))
		A:mirror(src)
	else if(istype(A,/obj/teleport))
		A:Teleport(src)
	else if(istype(A,/obj/portkey))
		A:Teleport(src)
	else if(istype(A,/obj/shop/base))
		A:shop(src)
	else if(istype(A,/obj/Poop))
		A:stepped(src)
	else if(istype(A,/obj/toilet))
		A:poop(src)

mob/Player/SteppedOff(atom/movable/A)
	..()
	if(istype(A,/obj/shop/base))
		A:unshop(src)


atom/movable/SteppedOn(atom/movable/A)
	if(istype(A,/obj/mirror/base))
		A:mirror(src)

atom/movable/SteppedOff(atom/movable/A)
	if(istype(A,/obj/mirror/base))
		A:unmirror(src)
