mob/TalkNPC

	level = 1000

	var
		tmp
			mob/Player/target
			obj/healthbar/hpbar
			turf/origloc

		canFight   = 1
		melee      = 0
		dropAttack = 0

		holdAttackChance = 15
		incindiaChance   = 5
		bombChance   = 0
		depulso = 0
		dashChance = 0

	New(loc)
		origloc = loc
		..()

	Move(NewLoc)
		if(hpbar)
			hpbar.glide_size = glide_size
			hpbar.loc = NewLoc
		.=..()

	Dispose()
		set waitfor = 0

		if(target)
			target.checkQuestProgress("Kill [src.name]")
			target.checkQuestProgress("Kill Player")
			target = null

		new /obj/corpse(loc, src, time=0)

		loc = null

		if(hpbar)
			hpbar.loc = null
			hpbar = null

		sleep(300)

		loc = origloc
		dir = initial(dir)

		alpha = 0
		animate(src, alpha = 255, time = 15)
		sleep(16)
		reset()


	Attacked(obj/projectile/p)
		if(canFight && isplayer(p.owner))

			if(!target)

				target = p.owner

				MHP   = 8 * (level) + 200 + (p.damage + p.owner:Slayer.level)*2
				HP    = MHP

				if(!hpbar)
					hpbar = new(src)
				state()

			else
				if(target != p.owner) return

			var/dmg = p.damage + p.owner:Slayer.level

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

		var/attack = pick("fireball", "quake", "aqua", "iceball", "gum")

		while(loc && (target || loc != origloc))
			var/delay = 4
			if(target)
				var/d = get_dist(src, target)
				if(d > 15)
					target = null
					continue

				if(dropAttack && prob(10))
					var/obj/boss/death/drop = new (target.loc, null, pick(3,5,7))
					drop.density = 1
					for(var/i = 1 to rand(0,4))
						step_away(drop, src)
					drop.density = 0

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

					var/ic
					var/attackType
					var/n
					if(prob(bombChance))
						n = "Bombarda"
						ic = "bombarda"
						attackType = /obj/projectile/Bomb
					else
						attackType = /obj/projectile

					if(prob(10))
						step_rand(src)
					else if(prob(holdAttackChance))

						for(var/i = 1 to rand(1,8))
							dir=get_dir(src, target)
							castproj(Type = attackType, icon_state = ic ? ic : attack, damage = dmg, name = n ? n : "Spell")
							sleep(2)
							if(!target)
								break
						if(!target) continue
					else if(prob(dashChance))

						var/turf/back = get_step(target, turn(target.dir, 180))
						Dash(back)

					else if(depulso)
						var/turf/back = get_step(target, turn(target.dir, 180))

						if(back == loc)
							var/turf/away = get_step_away(target,src,15)
							target << "<b><span style=\"color:red;\">[src]:</span></b> Depulso!"
							target.Move(away)
						else
							var/turf/t = get_step_to(src, back)
							if(t)
								Move(t)
							else
								var/turf/away = get_step_away(target,src,15)
								target << "<b><span style=\"color:red;\">[src]:</span></b> Depulso!"
								target.Move(away)

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

					if(prob(incindiaChance))
						var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
						for(var/di in dirs)
							castproj(Type = attackType, icon_state = ic ? ic : "fireball", damage = dmg, name = n ? n : "Incindia", cd = 0, lag = 1, Dir=di)
					else
						dir=get_dir(src, target)
						castproj(Type = attackType, icon_state = ic ? ic : attack, damage = Dmg, name = n ? n : "Spell")

					delay = 2

			else // return to spot
				density = 0
				var/t = get_step_towards(src, origloc)
				if(t && origloc.z == z)
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

		if(loc && HP > 0) reset()

	proc/reset()

	Student

		icon = 'FemaleStaff.dmi'
		density = 1
		gender = FEMALE

		post_init = 1


		Talk()
			set src in oview(3)
			var/mob/Player/p = usr

			var/ScreenText/s = new(p, src)
			s.AddText(pick("Hello there [p.name].", "How about that new hot DADA Professor?", "Have you seen my frog?"))


		reset()
			set waitfor = 0
			route()

		MapInit()
			set waitfor = 0

			if(prob(51))
				name   = pick("Shana", "Shakira", "Valeri", "Elodia", "Marilu", "Shenna", "Coreen", "Debera", "Marlo", "Aracely", "Romana", "Dona", "Tobi", "Kathern", "Majorie", "Dierdre", "Angla", "Judith", "Johnetta", "Lennie", "Kelli")
			else
				name   = pick("Palmer", "Bob", "Jorge", "Davis", "Shayne", "Clayton", "Olin", "Ty", "Jayson", "Owen", "Ned", "Benito", "Prince", "Cyrus", "Art", "Ben", "Derek", "Kendrick", "Frances", "Garry", "Man", "Federico", "Clifford")
				icon   = 'MaleStaff.dmi'
				gender = MALE
			GenerateIcon(src)

			namefont.QuickName(src, src.name, rgb(255,255,255), "#000", top=1)

			sleep(40)

			route()

	proc/Dash(turf/t)
//		set waitfor = 0

		var
			px = (x * 32) - (t.x * 32)
			py = (y * 32) - (t.y * 32)

		dir = get_dir(src, t)

		var/time = round(((abs(px) + abs(py)) / 32) * 0.5)

		var/list/ghosts = list()
		for(var/i = 1 to 4)
			var/image/o = new
			o.appearance = appearance
			o.alpha = 255 - i * 50

			o.pixel_x = px * 0.1 * i
			o.pixel_y = py * 0.1 * i

			ghosts += o

		var/underlaysTmp = underlays.Copy()
		underlays += ghosts

		animate(src, pixel_x = -px,
		             pixel_y = -py, time = time)


		sleep(time)
		pixel_x = 0
		pixel_y = 0

		density = 0
		Move(t)
		density = 1

		underlays = underlaysTmp

	proc/route()
		set waitfor = 0

		var/list/targets = list("GCOM Class", "@Hogwarts", "Transfiguration Class", "Headmaster Class", "Charms Class", "DADA Class", "Great Hall", "COMC Class", "leavevault")

		var/const/DELAY = 3
		var/const/COOLDOWN = 80
		glide_size = 32 / DELAY

		var/cooldown = COOLDOWN

		var/txtTarget = pick(targets)
		var/turf/goal = locate(txtTarget)
		if(!isturf(goal)) goal = goal.loc

		while(loc)

			var/list/path = getPathTo(loc, goal)
			if(!path)
				break

			for(var/turf/t in path)
				if(!loc || target) break
				dir = get_dir(loc, t)
				loc = t

				sleep(DELAY)

				if(cooldown <= 0)
					if(prob(5))
						var/obj/sitTarget
						for(var/obj/o in view(5, src))
							if(o.canSit)
								sitTarget = o
								break
						if(sitTarget)
							density = 0
							walk_towards(src,sitTarget,DELAY)
							var/timeReq = (1 + get_dist(src,sitTarget))*DELAY
							sleep(timeReq)
							walk(src,0)
							dir = sitTarget.canSit
							density = 1
							sleep(150)
							density = 0
							walk_towards(src, t,DELAY)
							sleep(timeReq)
							density = 1
							walk(src,0)

							cooldown = COOLDOWN
				//			break

					else if(prob(1))
						dir = SOUTH
						sleep(50)

						cooldown = COOLDOWN
				//		break
				else
					cooldown--

			if(target) break

			if(loc.loc == goal.loc)
				txtTarget = pick(targets)
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