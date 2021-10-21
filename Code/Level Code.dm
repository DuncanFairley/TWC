mob/Player
	var/tmp
		slow       = 0
		move_delay = 1
		reading    = 0
		nomove     = 0

turf
	Exit(atom/movable/O, atom/newloc)
		.=..()

		if(isplayer(O) && . && newloc)
			var/mob/Player/p = O
			if(p.teleporting) return
			if(isobj(newloc)) return

			if(!p.unslow)
				var/turf/t = newloc
				p.move_delay = t.slow + 1
			else
				p.move_delay = 1

turf/var/tmp/slow = 0


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
				if(Y.guild && Y.guild == worldData.majorPeace) return ..()

	Aurorblocker
		Enter(mob/Player/Y)
			if(istype(Y,/mob/Player))
				if(Y.guild && Y.guild == worldData.majorChaos) return ..()