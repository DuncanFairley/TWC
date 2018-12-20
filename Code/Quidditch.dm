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

	quaffle
		icon = 'obj.dmi'
		icon_state = "quaffle"
		density = 1

		New()
			..()

			walk(src, dir, 2)

		Bump(atom/movable/O)
			if(isplayer(O))
				density = 0
				O.Move(loc, get_dir(O.loc, loc))
				density = 1
			else
				var/d = turn(dir, 90 * pick(1,-1))
				var/turf/t = get_step(src, d)
				if(!t || t.density)
					d = turn(d, 180)
					t = get_step(src, d)
					if(!t || t.density)
						d = turn(dir, 180)
						t = get_step(src, d)

				if(t && !t.density)
					loc = t

				walk(src, d, 2)


		Crossed(atom/movable/O)
			if(isplayer(O))
				var/mob/Player/p = O
				if(!p.flying) return

				walk(src, p.dir, 2)


	snitch
		icon = 'obj.dmi'
		icon_state = "snitch"
		density = 1

		var
			caught
			prize

		New()
			..()
			Wander()

		Bump(atom/movable/O)
			density = 0
			O.Move(loc, get_dir(O.loc, loc))
			density = 1

		proc/Wander()
			set waitfor = 0
			sleep(1)

			var/const/RANGE = 20

			var/min_dist = RANGE
			var/mob/Player/target
			var/turf/lastLoc = loc
			var/alt = 0
			var/sprint = 0

			while(loc)
				var/count = 0
				for(var/mob/Player/M in ohearers(src, RANGE))
					count++
					var/dist = get_dist(src, M)
					if(min_dist > dist)
						target = M

				if(!count) target = null

				if(target)
					var/delay = 1

					if(sprint<=0)
						if(prob(40))
							sprint = rand(4,8)
							glide_size = 32
					else
						sprint--

					if(sprint<=0)
						glide_size = 16
						delay = 2

					var/turf/newLoc = get_step_away(src, target, RANGE)

					if(lastLoc == newLoc)
						loc = target.loc
					else
						loc = newLoc

					alt = !alt
					if(alt)	lastLoc = loc
					sleep(delay)

				else
					lastLoc = null
					step_rand(src)
					glide_size = 8
					sleep(3)

		Crossed(atom/movable/O)
			if(isplayer(O))
				var/mob/Player/p = O
				if(!p.flying) return

				p << infomsg("You caught the snitch!")
				if(prize)
					if(prob(50)) // gold prize
						var/gold/g = new (bronze=rand(5000,10000))
						g.give(p)
						p << infomsg("You won [g.toString()].")
					else // house points prize
						var/housenum = 1
						var/points = rand(1,2)
						switch(p.House)
							if("Gryffindor")
								housenum = 1
							if("Slytherin")
								housenum = 2
							if("Ravenclaw")
								housenum = 3
							if("Hufflepuff")
								housenum = 4

						worldData.housepointsGSRH[housenum] += points

						p << infomsg("You won [points] house point[points != 1 ? "s" : ""].")
						Players << "\red[points] point[points != 1 ? "s have" : " has"] been added to [p.House]!"

				else
					Players << infomsg("[p] has caught the [name]!")

				loc = null







