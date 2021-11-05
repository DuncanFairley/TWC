mob/TalkNPC

	level = 1000

	var
		tmp
			mob/Player/target
			obj/healthbar/hpbar
			turf/origloc

		melee = 0
		canFight = 1

	New(loc)
		origloc = loc
		..()

	Move(NewLoc)
		if(hpbar)
			hpbar.glide_size = glide_size
			hpbar.loc = NewLoc
		.=..()

	Dispose(corpse=1)
		set waitfor = 0
		if(target)
//			if(prob(10))
//				drop(target)
			target = null
		if(HP > 0) return
		new /obj/corpse(loc, src, time=0)

		loc = null

		if(hpbar)
			hpbar.loc = null
			hpbar = null

		sleep(300 + rand(-200,200))

		loc = origloc

		alpha = 0
		animate(src, alpha = 255, time = 15)


	Attacked(obj/projectile/p)
		if(canFight && isplayer(p.owner))

			if(!target)

				target = p.owner

				MHP   = 8 * (level) + 200 + p.damage + p.owner:Slayer.level
				HP    = MHP

				if(!hpbar)
					hpbar = new(src)
				state()

			else
				if(target != p.owner) return

			var/dmg = p.damage + p.owner:Slayer.level

			if(p.owner:monsterDmg > 0)
				dmg *= 1 + p.owner:monsterDmg/100

			var/n = dir2angle(get_dir(src, p))
			emit(loc    = src,
				 ptype  = /obj/particle/fluid/blood,
			     amount = 4,
			     angle  = new /Random(n - 25, n + 25),
			     speed  = 2,
			     life   = new /Random(15,25))

			p.owner << "Your [p] does [dmg] damage to [src]."

			HP -= dmg

			if(HP > 0)
				var/percent = HP / MHP
				hpbar.Set(percent, src)
			else
				p.owner << errormsg("<i>You killed [name].</i>")
				Dispose()


	proc/drop(mob/Player/p)

//		var/obj/items/wearable/pets/squirrel/s = new (loc)
//		s.prizeDrop(p.ckey, decay=FALSE)

		emit(loc    = loc,
			 ptype  = /obj/particle/star,
			 amount = 3,
			 angle  = new /Random(0, 360),
			 speed  = 5,
			 life   = new /Random(4,8))


	proc/state()
		set waitfor = 0

		while(target || loc != origloc)
			var/delay = 4
			if(target)
				var/d = get_dist(src, target)
				if(d > 15)
					target = null
					continue

				if(melee)
					if(d > 1)
						var/turf/t = get_step_to(src, target, 1)
						if(!t)
							density = 0
							t = get_step_to(src, target, 1)
							Move(t)
							density = 1
						else
							Move(t)

						delay = 3
					else
						var/dmg = round(level*2, 1) - target.Slayer.level

						if(target.monsterDef > 0)
							dmg *= 1 - min(target.monsterDef/100, 0.75)

						if(target.animagusOn)
							dmg = dmg * 0.75 - target.Animagus.level

						dmg = target.onDamage(dmg, src, 0)
						target << "<span style='color:red'>[src] attacks you for [dmg] damage!</span>"
						if(target.HP <= 0)
							target.Death_Check(target)
							target = null

						delay = 3
				else
					var/dmg = round(level*2, 1) - target.Slayer.level

					if(prob(10))
						step_rand(src)
					else if(prob(15))

						for(var/i = 1 to rand(1,8))
							dir=get_dir(src, target)
							castproj(icon_state = "fireball", damage = dmg, name = "Inflamari")
							sleep(2)
							if(!target)
								break
						if(!target) continue

					else if(d > 7)
						var/turf/t = get_step_to(src, target, 1)
						if(!t)
							density = 0
							t = get_step_to(src, target, 1)
							Move(t)
							density = 1
						else
							Move(t)

					else if(d < 5)
						step_away(src, target)
					else
						step_rand(src)

					if(prob(5))
						var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						for(var/di in dirs)
							castproj(icon_state = "fireball", damage = dmg, name = "Incindia", cd = 0, lag = 1, Dir=di)
					else
						dir=get_dir(src, target)
						castproj(icon_state = "fireball", damage = dmg, name = "Inflamari")

					delay = 2

			else // return to spot
				density = 0
				var/t = get_step_towards(src, origloc)
				if(t)
					Move(t)
				else
					loc = origloc
				density = 1
				delay = 5

				if(loc == origloc)
					if(hpbar)
						hpbar.loc = null
						hpbar = null
					dir = initial(dir)

			glide_size = 32 / delay
			sleep(delay)

		if(loc) Dispose()

	Student

		icon = 'FemaleStaff.dmi'
		density = 1
		gender = FEMALE

		post_init = 1

		Dispose()
			set waitfor = 0

			if(loc && HP > 0)
				route()
			else
				..()

		MapInit()
			set waitfor = 0

			if(prob(51))
				name   = pick("Shana", "Shakira", "Valeri", "Elodia", "Marilu", "Shenna", "Coreen", "Debera", "Marlo", "Aracely", "Romana", "Dona", "Tobi", "Kathern", "Majorie", "Dierdre", "Angla", "Judith", "Johnetta", "Lennie", "Kelli")
			else
				name   = pick("Palmer", "Bob", "Jorge", "Davis", "Shayne", "Clayton", "Olin", "Ty", "Jayson", "Owen", "Ned", "Benito", "Prince", "Cyrus", "Art", "Ben", "Derek", "Kendrick", "Frances", "Garry", "Man", "Federico", "Clifford")
				icon   = 'MaleStaff.dmi'
				gender = MALE
			GenerateIcon(src)

			sleep(40)

			route()

	proc/route()
		set waitfor = 0

		var/list/targets = list("GCOM Class", "@Hogwarts", "Transfiguration Class", "Headmaster Class", "Charms Class", "COMC Class", "DADA Class", "Great Hall")
		var/txtTarget = pick(targets)
		var/turf/goal = locate(txtTarget)
		if(!isturf(goal)) goal = goal.loc

		var/const/DELAY = 4
		glide_size = 32 / DELAY

		while(loc)

			var/list/path = getPathTo(loc, goal)
			if(!path)
				break

			for(var/turf/t in path)
				if(!loc || target) break
				dir = get_dir(loc, t)
				loc = t

				sleep(DELAY)


				if(prob(1))
					var/obj/sitTarget
					for(var/obj/o in range(src, 5))
						if(o.canSit)
							sitTarget = o
							break
					if(sitTarget)
						var/list/steps = list()
						while(loc != sitTarget.loc)
							if(!loc || target) break
							dir = get_dir(loc, sitTarget)
							loc = get_step(loc, dir)
							steps += loc
							sleep(DELAY)
						if(loc == sitTarget.loc)
							dir = sitTarget.canSit
							sleep(150)

							while(loc != t)
								if(!loc || target) break
								dir = get_dir(loc, t)
								loc = get_step(loc, dir)

				else if(prob(1))
					dir = SOUTH
					sleep(50)

			if(target) break

			if(loc.loc == goal.loc)
				txtTarget = pick(targets-txtTarget)
				goal = locate(txtTarget)
				if(!isturf(goal)) goal = goal.loc

				continue

			var/obj/teleport/o = locate() in orange(1, loc)
			if(o)
				var/turf/d = locate(o.dest)
				loc = d



obj
	var/canSit = 0

	housecouch
		canSit = SOUTH
	chairright
		canSit = EAST
	chairleft
		canSit = WEST
	chairback
		canSit = NORTH
	chairfront
		canSit = SOUTH