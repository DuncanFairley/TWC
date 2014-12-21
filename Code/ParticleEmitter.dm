
var/ParticleEmitter/particle_emitter = new

ParticleEmitter
	var
		list/pool = list()

		decay = FALSE
		const/DECAY_TIME = 3000
		const/DECAY_SIZE = 1000

	proc
		get_particle(type)
			var/obj/particle/p
			if(!("[type]" in pool))
				p = new type()
			else
				p = pool["[type]"][1]
				pool["[type]"] -= p
				p.reset()
				if(length(pool["[type]"]) == 0)
					pool -= "[type]"

			return p


		pool(obj/particle/p)
			p.loc = null

			if("[p.type]" in pool)
				pool["[p.type]"] += p

				if(length(pool["[type]"]) > DECAY_SIZE)
					decay()


			else
				pool["[p.type]"] = list(p)

		decay()
			if(decay) return
			decay = TRUE
			spawn(DECAY_TIME)
				for(var/t in pool)
					for(var/p in t)
						t -= p
					pool -= t
				decay = FALSE





/*mob/verb/Test_Particles()
	var/n = dir2angle(dir)
	emit(loc    = src,
		 type   = /obj/particle/blood,
	     amount = 5,
	     angle  = new /Random(n - 25, n + 25),
	     speed  = 2,
	     life   = new /Random(15,25))*/

proc/dir2angle(dir)
	if(dir == EAST)      return 0
	if(dir == SOUTHEAST) return 45
	if(dir == SOUTH)     return 90
	if(dir == SOUTHWEST) return 135
	if(dir == WEST)      return 180
	if(dir == NORTHWEST) return 225
	if(dir == NORTH)     return 270
	if(dir == NORTHEAST) return 315
	return 0

proc/emit(var/atom/loc, type, amount=10, Random/angle, speed, Random/life)
	if(isobj(loc) || ismob(loc)) loc = loc.loc

	for(var/i = 1 to amount)
		var/obj/particle/p = particle_emitter.get_particle(type)
		p.config(angle.get(), speed, life.get())
		p.loc = loc
		p.update()

obj/particle
	var/life
	var/velocity/v = new

	layer = 5

	proc
		config(angle, speed, life)
			src.life = life

			v.x =  speed * cos(angle)
			v.y = -speed * sin(angle)

		update()
			var/t = rand(5,10)
			var/l = 5
			spawn(t * l) die()

			animate(src,
					pixel_x = v.x * (life),
					pixel_y = v.y * (life),
				    time = t,
				    loop = l)

		reset()
			pixel_x = 0
			pixel_y = 0

		die()
			particle_emitter.pool(src)

	balloon
		icon       = 'balloon.dmi'
		icon_state = "white"

		config()
			..()

			color = rgb(rand(0,255), rand(0,255), rand(0,255))

	blood
		icon = 'dot.dmi'
		config()
			..()
			color = rgb(rand(200,255), 0, 0)
			transform = matrix()/2

		reset()
			..()
			alpha = 255
			transform = matrix()/2
			layer = 5

		update()
			var/t = 5
			var/l = 1
			spawn(t * l)
				layer = 3
				sleep(50)
				die()

			animate(src,
					transform = matrix()*2,
					pixel_x = v.x * (life),
					pixel_y = v.y * (life),
					alpha = 150,
				    time = t,
				    loop = l)


Random
	var/min
	var/max

	New(min, max)
		src.min = min
		src.max = max

	proc/get()
		return rand(min, max)



proc
	coinFlip()
		return pick(-1,1)
	random()
		return rand(1, 1000) / 1000

	tan(x) return sin(x)/cos(x)


var/const/PI = 3.14159265359

velocity
	var/x
	var/y