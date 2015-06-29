
var/ParticleEmitter/particle_emitter = new

ParticleEmitter
	var
		list/pool

		decay = FALSE
		const/DECAY_TIME = 3000
		const/DECAY_SIZE = 1000

	proc
		get_particle(ptype)
			var/obj/particle/p

			if(!pool || !("[ptype]" in pool))
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

			if(!pool) pool = list()

			if("[p.type]" in pool)
				pool["[p.type]"] += p

				decay()
			else
				pool["[p.type]"] = list(p)

		decay()
			set waitfor = 0
			if(decay) return
			decay = TRUE

			sleep(DECAY_TIME)

			var/size = 0
			for(var/t in pool)
				size += length(pool[t])

			if(size > DECAY_SIZE)
				pool = null

			decay = FALSE





/*mob/verb/Test_Particles()
	emit(loc    = loc,
						 ptype  = /obj/particle/fluid/blood,
					     amount = 80,
					     angle  = new /Random(0, 360),
					     speed  = 5,
					     life   = new /Random(1,15))*/

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

	smoke
		alpha = 50
		size  = 3
		loop  = 1
		color = "#bbb"

		red
			color = "#c60"
		blue
			color = "#0bc"
		pink
			color = "#ff69b4"
		brown
			color = "#8b4513"
		green
			size  = 4
			color = "#00f000"


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

proc/fadeText(turf/loc, text, offsetX = 0, offsetY = 0)
	if(istype(loc, /atom/movable))
		loc = loc.loc
	new /obj/fadeText (loc, text, offsetX, offsetY)

obj
	fadeText
		maptext_width  = 128
		maptext_height = 16
		mouse_opacity  = 0
		layer          = EFFECTS_LAYER

		New(i_Loc, i_Text, i_OffsetX, i_OffsetY)
			..()

			maptext = i_Text
			pixel_x = i_OffsetX
			pixel_y = i_OffsetY

			var/size   = abs(pixel_x * 2)
			var/offset = 16
			if(maptext_width < size)
				maptext_width = size
				offset = round(size / 8)

			var/ox = rand(-offset,offset)
			animate(src, pixel_x = pixel_x,        pixel_y = pixel_y,      alpha = 254, time = 0)
			animate(pixel_x = pixel_x + ox * 0.25, pixel_y = pixel_y + 16, alpha = 253, time = 3)
			animate(pixel_x = pixel_x + ox * 0.5,  pixel_y = pixel_y + 32, alpha = 196, time = 3)
			animate(pixel_x = pixel_x + ox,        pixel_y = pixel_y + 48, alpha = 128, time = 3)
			animate(pixel_x = pixel_x + ox * 2,    pixel_y = pixel_y + 64, alpha = 0,   time = 3)
			spawn(13)
				loc = null