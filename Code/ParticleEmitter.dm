
var/ParticleEmitter/particle_emitter = new

ParticleEmitter
	var
		list/pool = list()

		decay = FALSE
		const/DECAY_TIME = 3000
		const/DECAY_SIZE = 1000

	proc
		get_particle(ptype)
			var/obj/particle/p
			if(!("[ptype]" in pool))
				p = new ptype()
			else
				p = pool["[ptype]"][1]
				pool["[ptype]"] -= p
				p.reset()
				if(length(pool["[ptype]"]) == 0)
					pool -= "[ptype]"

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
		 ptype  = /obj/particle/magic,
	     amount = 50,
	     angle  = new /Random(1, 359),
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

proc/emit(var/atom/loc, ptype, amount=10, Random/angle, speed, Random/life)
	if(isobj(loc) || ismob(loc)) loc = loc.loc
	for(var/i = 1 to amount)
		var/obj/particle/p = particle_emitter.get_particle(ptype)
		p.config(angle.get(), speed, life.get())
		p.loc = loc
		p.update()

obj/particle
	icon       = 'dot.dmi'
	icon_state = "default"

	var/life
	var/afterlife = 0
	var/velocity/v = new
	var/loop = 5
	var/size = 1
	var/Random/time = new /Random(5, 10)
	mouse_opacity = 0

	layer = 5

	proc
		config(angle, speed, life)
			src.life = life

			v.x =  speed * cos(angle)
			v.y = -speed * sin(angle)

		impact()


		update()
			set waitfor = 0

			var/t = time.get()
			var/l = loop

			var/alphaDest = alpha
			alpha = 255

			animate(src,
					transform = matrix() * size,
					pixel_x = v.x * (life),
					pixel_y = v.y * (life),
					alpha = alphaDest,
				    time = t,
				    loop = l)

			sleep(t * l + 1)
			impact()
			sleep(afterlife)
			die()
			alpha = alphaDest

		reset()
			pixel_x = 0
			pixel_y = 0
			transform = null

		die()
			particle_emitter.pool(src)

	balloon
		icon       = 'balloon.dmi'
		icon_state = "white"
		blend_mode = 0

		config()
			..()

			color = rgb(rand(0,255), rand(0,255), rand(0,255))

	fluid
		alpha     = 130
		loop      = 1
		afterlife = 100
		size      = 2

		config()
			..()

		reset()
			..()
			alpha = 150
			layer = 5

		impact()
			layer = 3

		snow

		blood
			afterlife  = 200
			color      = "#e00000"

			impact()
				..()
				color      = "#08ffff"
				blend_mode = BLEND_SUBTRACT

			reset()
				..()
				color      = "#e00000"
				blend_mode = 0

	magic
		loop = 2

		config()
			..()
			color = rgb(rand(20,240), rand(20,240), rand(20,240))

	green
		loop = 2
		color = "green"

	red
		loop = 2
		color = "red"


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