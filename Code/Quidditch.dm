#define BLUDGER_SPEED 1

area
	Quidditch
		timedProtection = 1
		friendlyFire = 0
		Team1
		Team2

		Entered(atom/movable/Obj,atom/OldLoc)
			..()

			if(isplayer(Obj))
				var/mob/Player/p = Obj
				new /hudobj/Quidditch(null, p.client, null, 1)


		Exited(atom/movable/Obj, atom/newloc)
			..()

			if(isplayer(Obj))
				var/mob/Player/p = Obj
				if(p.client)
					var/hudobj/Quidditch/o = locate(/hudobj/Quidditch) in p.client.screen
					if(o)
						o.hide()

hudobj
	Quidditch
		icon_state = "quidditch"

		anchor_x   = "WEST"
		screen_x   = 306
		screen_y   = -16
		anchor_y   = "NORTH"

		mouse_opacity = 2

		Click()
			if(alpha == 0) return

			var/mob/Player/p = usr
			if(color == "#00ff00")
				color = null
				p.control:uncontrol(p)
			else
				var/mob/Quidditch/q = locate("QuidditchMob")

				for(var/obj/quidditch/player/c in (istype(p.loc.loc, /area/Quidditch/Team1) ? q.team1 : q.team2))
					if(c.control) continue
					c.control(p)
					color = "#00ff00"
					return
				p << errormsg("No available spots on the team.")

mob/Player/var/tmp/eyeMoving = 0
obj/stepSpectate
	invisibility = 2
	var/dest

	Crossed(atom/movable/O)
		set waitfor = 0
		..()

		if(dest && isplayer(O))
			var/turf/t = locate(dest)
			if(t)
				if(ismovable(O)) t = t.loc
				var/mob/Player/p = O

				if(p.client.eye != p || p.eyeMoving) return

				p.client.eye=t
				p.client.perspective=EYE_PERSPECTIVE

				if(t.z == p.z && get_dist(p, t) < 20)
					p.eyeMoving = 1
					p.client.pixel_x = (p.x - t.x) * 32
					p.client.pixel_y = (p.y - t.y) * 32

					animate(p.client, pixel_x = 0, pixel_y = 0, time = 10)
					sleep(10)
					if(p) p.eyeMoving = 0

	Uncrossed(atom/movable/O)
		set waitfor = 0
		if(dest && isplayer(O))
			var/mob/Player/p = O

			var/obj/stepSpectate/s = locate() in p.loc
			if(s && s.dest == dest) return

			p.client.eye=p
			p.client.perspective=MOB_PERSPECTIVE

			if(p.eyeMoving)
				p.eyeMoving = 0
				animate(p.client, pixel_x = 0, pixel_y = 0, time = 0)


mob/Quidditch
	density = 0
	var
		tmp
			list
				team1
				team2

			score1 = 0
			score2 = 0

			players = 0

			scored = 0

			obj
				clock
					score
					time
				quidditch/quaffle/ball



	proc
		names(team)
			. = ""
			for(var/obj/quidditch/player/p in (team == 1 ? team1 : team2))
				if(p.control)
					if(. == "")
						. += "[p.control.name]"
					else
						. += ", [p.control.name]"

			if(. == "") . = "Bots"

		score(team)
			if(scored) return
			scored = 1
			if(team == 2)
				if(++score1 >= 5)
					for(var/mob/Player/p in hearers(20, src))
						p << infomsg("<b>Team 1 ([names(1)]) won! [score1]:[score2]</b>")
					start()
					scored = 0
					return
				else
					for(var/mob/Player/p in hearers(20, src))
						p << infomsg("<b>Team 1 scored!</b>")

			else
				if(++score2 >= 5)
					for(var/mob/Player/p in hearers(20, src))
						p << infomsg("<b>Team 2 ([names(2)]) won! [score1]:[score2]</b>")
					start()
					scored = 0
					return
				else
					for(var/mob/Player/p in hearers(20, src))
						p << infomsg("<b>Team 2 scored!</b>")

			reset()
			countdown()
			scored = 0

		countdown()
			ball.stop = 1
			ball.caught = null
			ball.loc = loc
			if(ball.shadow)
				ball.shadow.loc = loc
			walk(ball, 0)

			for(var/obj/quidditch/bludger/b in range(25, src))
				b.stop = 1
				walk(b, 0)

			for(var/i = 1 to 3)
				team1[i].nomove++
				team1[i].flying = 0

				team2[i].nomove++
				team2[i].flying = 0

			for(var/i = 3 to 1 step -1)
				maptext = "<b><span style=\"font-size:4; color:#FF4500;\">[i]</span></b>"
				sleep(10)
			maptext = null

			for(var/i = 1 to 3)
				team1[i].nomove = 0
				team1[i].flying = 1

				team2[i].nomove = 0
				team2[i].flying = 1

				if(team1[i].pixel_y == 8)
					animate(team1[i], pixel_y = 64, time = 2, loop = -1)
					animate(     pixel_y = 65, time = 2)
					animate(     pixel_y = 64, time = 2)
					animate(     pixel_y = 63, time = 2)

				if(team2[i].pixel_y == 8)
					animate(team2[i], pixel_y = 64, time = 2, loop = -1)
					animate(     pixel_y = 65, time = 2)
					animate(     pixel_y = 64, time = 2)
					animate(     pixel_y = 63, time = 2)

			if(players == 0) return

			ball.stop = 0
			walk(ball, pick(NORTH, SOUTH), 2)

			for(var/obj/quidditch/bludger/b in range(25, src))
				b.stop = 0
				walk(b, b.dir, BLUDGER_SPEED)

		reset(afterStop = 0)
			score.maptext = "<b><span style=\"font-size:4; color:#FF4500;\">[score1]:[score2]</span></b>"

			for(var/i = 1 to 3)
				team1[i].loc = locate("qPlayer1[i]").loc
				team2[i].loc = locate("qPlayer2[i]").loc

				team1[i].shadow.loc = team1[i].loc
				team2[i].shadow.loc = team2[i].loc

				if(afterStop)
					team1[i].start()
					team2[i].start()


		start(afterStop = 0)
			set waitfor = 0
			score1 = 0
			score2 = 0
			reset(afterStop)
			countdown()

		stop()
			walk(ball, 0)

			for(var/obj/quidditch/bludger/b in range(20, src))
				walk(b, 0)

			for(var/i = 1 to 3)
				team1[i].stop()
				team2[i].stop()


	New()
		set waitfor = 0
		..()

		tag = "QuidditchMob"

		sleep(2)

		var/obj/quidditch/player/p
		team1 = list()
		team2 = list()
		for(var/i = 1 to 3)
			p = new (locate("qPlayer1[i]").loc, src, 1)
			team1 += p

			p = new (locate("qPlayer2[i]").loc, src, 2)
			team2 += p

		score = locate("qScore")
		score.maptext_width = 64
		score.maptext = "<b><span style=\"font-size:4; color:#FF4500;\">0:0</span></b>"

		ball = locate("qQuaffle")

obj/goal
	icon = 'obj.dmi'
	icon_state = "hop"
	pixel_y = 64
	layer = 4

	var/team
	var/tmp/mob/Quidditch/ref

	New()
		set waitfor = 0
		..()

		var/image/i = new('obj.dmi', "Q2")
		i.pixel_y = -64
		i.layer = 3
		overlays += i

		i = new('obj.dmi', "Q2")
		i.pixel_y = -32
		i.layer = 3
		overlays += i

		sleep(1)
		ref = locate("QuidditchMob")

	Crossed(atom/movable/O)
		if(istype(O, /obj/quidditch/quaffle))
			ref.score(team)


obj/quidditch/player
	var
		tmp
			nomove = 0
			mob/Player/control
			mob/Quidditch/quidditch
			bot = 1
		flying = 1
		team = 1

	float = 1
	icon_state = "flying"

	New(Loc, mob/Quidditch/q, t)
		..()
		if(prob(51))
			icon   = 'FemaleStaff.dmi'
			gender = FEMALE
		else
			icon   = 'MaleStaff.dmi'
			gender = MALE

		GenerateIcon(src)

		var/image/i = new('nimbus_2000_broom.dmi', "flying")
		i.layer = FLOAT_LAYER - 3
		overlays += i

		animate(src, pixel_y = pixel_y,      time = 2, loop = -1)
		animate(     pixel_y = pixel_y + 1,  time = 2)
		animate(     pixel_y = pixel_y,      time = 2)
		animate(     pixel_y = pixel_y - 1,  time = 2)

		quidditch = q
		team = t

	proc/control(mob/Player/p)
		if(p.control)
			p.control:underlays = list()
			p.control:control = null

		p.control = src
		p.client.eye=src
		p.client.perspective=EYE_PERSPECTIVE

		underlays = p.underlays
		control = p

		if(++quidditch.players == 1)
			quidditch.start(1)
		else
			stop()

	proc/uncontrol(mob/Player/p)
		control = null
		underlays = list()

		p.control = null
		p.client.eye=p
		p.client.perspective=MOB_PERSPECTIVE

		if(--quidditch.players == 0)
			quidditch.stop()
		else
			start()

	proc/start()
		set waitfor = 0
		bot = 1
		while(!control && bot)
			var/d
			if(quidditch.ball.caught == src)

				var/obj/goal/g
				for(g in range(30, src))
					if((g.team == 1 && team == 2) || (g.team == 2 && team == 1)) break

				if(g)
					step_towards(src, g)
					d = 2
				else
					step_rand(src)
					d = 4
			else if(loc == quidditch.ball.loc || prob(35))
				step_rand(src)
				d = rand(2,4)
			else
				step_towards(src, quidditch.ball)

			if(!d) d = rand(1,4)
			glide_size = 32 / d
			sleep(d)

		glide_size = 0


	proc/stop()
		bot = 0

	Move(var/turf/NewLoc, Dir)
		if(NewLoc.density) return

		if(nomove == 0 || Dir == -1) .=..()

		if(nomove && flying)
			animate(src, pixel_y = 8, time = 10)
			flying = 0
		else if(!nomove && !flying)
			animate(src, pixel_y = 64, time = 10)
			sleep(10)
			animate(src, pixel_y = 64, time = 2, loop = -1)
			animate(     pixel_y = 65, time = 2)
			animate(     pixel_y = 64, time = 2)
			animate(     pixel_y = 63, time = 2)
			flying = 1

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

	var/float = 0
	var/tmp/obj/Shadow/shadow

	New()
		..()

		if(float)
			pixel_y = 64

			shadow = new (loc)
			shadow.glide_size = glide_size

	Move(turf/newLoc)
		if(!newLoc.density)
			shadow?.loc = newLoc
		.=..()

	bludger
		icon = 'obj.dmi'
		icon_state = "bludger"
		density = 1

		glide_size = 16

		var/tmp
			cd = 0
			stop = 0

		New()
			..()

			if(!float) walk(src, dir, BLUDGER_SPEED)

		proc/hit(mob/Player/p)
			set waitfor = 0
			p.nomove++
			var/count = rand(6,12)
			var/d = pick(dir, turn(dir, 90), turn(dir, -90))
			while(p && count-- > 0 && !stop)
				var/turf/t = get_step(p, d)
				p.Move(t, -1)
				p.dir = pick(1,2,4,8)
				sleep(1)
			p.nomove--

			emit(loc    = p.loc,
				 ptype  = /obj/particle/smoke,
			     amount = 15,
			     angle  = new /Random(1, 359),
			     speed  = 2,
			     life   = new /Random(15,25),
			     color  = null)

		Move()
			.=..()

			if(!cd && !stop && prob(20))
				cd = 1
				walk(src, 0)
				spawn()
					walk(src, pick(EAST,WEST,NORTH,SOUTH,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST), BLUDGER_SPEED)
					sleep(20)
					cd = 0

			for(var/atom/movable/a in loc)
				if(isplayer(a) || istype(a, /obj/quidditch/player))
					var/mob/Player/p = a
					if(!p.flying || p.nomove > 0) continue
					hit(a)

		Bump(atom/movable/O)
			if(stop) return
			var/d = turn(dir, 90 * pick(1,-1))
			var/turf/t = get_step(src, d)
			if(!t || t.density)
				d = turn(d, 180)
				t = get_step(src, d)
				if(!t || t.density)
					d = turn(dir, 180)
					t = get_step(src, d)

			if(t && !t.density)
				Move(t)

			walk(src, d, BLUDGER_SPEED)

		Crossed(atom/movable/O)
			if(isplayer(O) || istype(O, /obj/quidditch/player))
				var/mob/Player/p = O
				if(!p.flying || p.nomove > 0 || stop) return
				hit(p)

	quaffle
		icon = 'obj.dmi'
		icon_state = "quaffle"
		density = 1

		var/tmp
			caught
			stop = 0

		New()
			..()

			if(!float) walk(src, dir, 2)

		Bump(atom/movable/O)
			if(stop) return
			var/d = turn(dir, 90 * pick(1,-1))
			var/turf/t = get_step(src, d)
			if(!t || t.density)
				d = turn(d, 180)
				t = get_step(src, d)
				if(!t || t.density)
					d = turn(dir, 180)
					t = get_step(src, d)

			if(t && !t.density)
				Move(t)

			walk(src, d, 2)


		Crossed(atom/movable/O)
			set waitfor = 0
			if(isplayer(O) || istype(O, /obj/quidditch/player))
				var/mob/Player/p = O
				if(!p.flying || caught) return

				caught = p
				walk(src, 0)
				p.nomove++
				p.flying = 0
				sleep(6)
				p.nomove--
				p.flying = 1

		Uncrossed(atom/movable/O)
			set waitfor = 0
			if(O == caught && !stop)
				caught = 1
				Move(O.loc)
				walk(src, O.dir, 2)
				sleep(6)
				caught = null


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







