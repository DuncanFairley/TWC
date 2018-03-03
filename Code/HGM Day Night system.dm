/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
area
	mouse_opacity = 0

	var/dmg = 1

world
	New()
		..()

		global_loops()

proc/global_loops()
	set waitfor = 0


	var/day = TRUE
	while(1)
		day = !day

		for(var/area/O in outside_areas)
			O.planeColor = day ? null : NIGHTCOLOR

		for(var/mob/Player/p in Players)
			if(!p.loc) continue

			var/area/a = p.loc.loc
			if(istype(a, /area/outside) || istype(a, /area/newareas/outside))
				p.Interface.SetDarknessColor()

		sleep(9000)

Weather
	var/list/clouds = list()
	proc
		clouds(p=0, color=null)
			generate_clouds(15, p, color)
			generate_clouds(16, p, color)
			generate_clouds(23, p, color)

		rain()
			clouds(20, "rain")
			for(var/area/A in outside_areas)
				for(var/turf/water/w in A)
					if(prob(30)) continue
					w.rain()
				A:SetWeather(/obj/weather/rain)
				A.dmg = 1

				if (world.tick_usage > 80) lagstopsleep()
		acid()
			clouds(20, "rain")
			for(var/area/A in outside_areas)
				for(var/turf/water/w in A)
					if(prob(30)) continue
					w.rain()
				A:SetWeather(/obj/weather/acid)
				A.dmg = 2

				if (world.tick_usage > 80) lagstopsleep()

		snow()
			clouds(20)
			for(var/area/A in outside_areas)
				A:SetWeather(/obj/weather/snow)
				A.dmg = 0.75

		clear(p = 5)
			clouds(p)
			for(var/area/A in outside_areas)
				for(var/turf/water/w in A)
					w.underlays = list()
					w.rain     = 0
				A:SetWeather()
				A.dmg = 1

				if (world.tick_usage > 80) lagstopsleep()

		// relocates / removes / adds existing clouds according to requirement per z level
		generate_clouds(z, p=0, color=null)
			p = max(0,p)
			if("[z]" in clouds)
				var/list/z_clouds = clouds["[z]"]
				if(z_clouds.len > p)
					var/count = z_clouds.len - p
					while(count > 0)
						count--
						var/obj/cloud/c = z_clouds[1]
						z_clouds  -= c
						c.dispose()

				if(p == 0)
					clouds -= "[z]"
					return

				for(var/obj/cloud/c in z_clouds)
					c.loc = locate(rand(10,world.maxx), rand(20,world.maxy), z)
			else
				clouds["[z]"] = list()

			var/list/z_clouds = clouds["[z]"]
			if(z_clouds.len < p)
				var/count = p - z_clouds.len
				while(count > 0)
					count--
					new /obj/cloud (locate(rand(10,world.maxx), rand(10,world.maxy), z))

var/Weather/weather

proc/init_weather()
	weather = new()
	scheduler.schedule(new/Event/Weather, 1)

obj/cloud
	icon  = 'clouds.dmi'
	layer = 6
	mouse_opacity = 0
	glide_size = 2
	post_init = 1

	var/const/SIZE = 5

	MapInit()

		if(!("[z]" in weather.clouds))
			weather.clouds["[z]"] = list()
		weather.clouds["[z]"] += src

		pixel_y = rand(1,4)
		icon_state = "[pixel_y]"
		transform *= SIZE

		loop()

	proc
		dispose()
			loc        = null

		loop()
			set waitfor = 0

			while(loc)
				if(y == 1 || x == world.maxx)
					var/new_x = 1
					var/new_y = world.maxy

					if(prob(50))
						new_x = rand(1, world.maxx)
					else
						new_y = rand(1, world.maxy)

					animate(src, pixel_x = 64 * SIZE, pixel_y = -64 * SIZE, time = 32 * SIZE)

					sleep(32 * SIZE + 1)

					loc = locate(new_x, new_y, z)
					pixel_x = -64 * SIZE
					pixel_y = 64 * SIZE

					animate(src, pixel_x = 0, pixel_y = 0, time = 32 * SIZE)

					sleep(32 * SIZE + 1)
				else
					var/turf/t = get_step(src, SOUTHEAST)
					loc = t

				sleep(16)

var/list/outside_areas = list()
area
	var/planeColor

	Entered(atom/movable/a, atom/OldLoc)
		..()

		if(isplayer(a))
			var/mob/Player/p = a

			p.Interface.SetDarknessColor()

	outside	// lay this area on the map anywhere you want it to change from night to day
		layer = 7	// set this layer above everything else so the overlay obscures everything

		var
			obj/weather/Weather	// what type of weather the area is having

		New()
			..()
			outside_areas += src

		proc
			SetWeather(WeatherType)
				if(Weather)	// see if this area already has a weather effect
					if(istype(Weather,WeatherType)) return	// no need to reset it
					overlays -= Weather	// remove the weather display
					del(Weather)	// destroy the weather object
				if(WeatherType)	// if WeatherType is null, it just removes the old settings
					Weather = new WeatherType()	// make a new obj/weather of the right type
					overlays += Weather	// display it as an overlay for the area

	inside	// a sample area not affected by the daycycle or weather
		luminosity = 1

area
	newareas
		outside
			proc
				SetWeather(WeatherType)
					if(Weather)	// see if this area already has a weather effect
						if(istype(Weather,WeatherType)) return	// no need to reset it
						overlays -= Weather	// remove the weather display
						del(Weather)	// destroy the weather object
					if(WeatherType)	// if WeatherType is null, it just removes the old settings
						Weather = new WeatherType()	// make a new obj/weather of the right type
						overlays += Weather	// display it as an overlay for the area

			var
				obj/weather/Weather	// what type of weather the area is having

			New()
				..()
				outside_areas += src

mob/GM/verb
	Rain()
		set category="Server"
		Players << infomsg("Rain begins to pour from the sky.")
		weather.rain()

	Acid()
		set category="Server"
		Players << infomsg("Acid rain begins to pour from the sky.")
		weather.acid()

	Snow()
		set category="Server"
		Players << infomsg("Snow begins to flurry from the sky.")
		weather.snow()

	Clear_weather()
		set category="Server"
		Players << infomsg("The weather has cleared.")
		weather.clear()


obj/weather
	layer = 7	// weather appears over the darkness because I think it looks better that way
	rain
		icon = 'weather.dmi'
		icon_state = "rain"
		New()
			src.overlays += image('weather.dmi')
			..()

	snow
		icon = 'weather.dmi'
		icon_state = "snow"

	acid
		icon = 'weather.dmi'
		icon_state = "acid"




obj
	lightplane
		plane            = 1
		blend_mode       = BLEND_MULTIPLY
		appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
		color            = list(null,null,null,"#0000","#000f")
		mouse_opacity    = 0

		screen_loc = "CENTER"

	darkness
		plane            = 1
		blend_mode       = BLEND_OVERLAY
		layer            = BACKGROUND_LAYER
		icon             = 'darkness.dmi'

		screen_loc = "CENTER"

	mapplane
		plane            = 0
		appearance_flags = PLANE_MASTER
		mouse_opacity    = 1

		screen_loc = "1,1"


interface
	var
		obj
			lightplane/lightplane
			mapplane/mapplane
			darkness/darkness


		list/lightStates

	New(client/c)
		darkness   = new
		lightplane = new
		mapplane   = new

		c.screen += lightplane
		c.screen += darkness

	proc/SetDarknessColor(c, priorty=0, t = 5)

		if(c)
			if(priorty)
				if(!lightStates)
					lightStates = list()
				lightStates[c] = priorty
				. = 1

			else if(lightStates && (c in lightStates))
				lightStates -= c
				. = 1

				if(!lightStates.len)
					lightStates = null

			if(lightStates)
				var/highest = 0
				var/index = 1
				for(var/i = 1 to lightStates.len)
					var/indexColor = lightStates[i]
					if(lightStates[indexColor] > highest)
						highest = lightStates[indexColor]
						index = i
				animate(darkness, color = lightStates[index], time = t)

		if(!lightStates)
			var/area/a = parent.loc.loc
			animate(darkness, color = a.planeColor, time = 5)


obj/light
	plane = 1
	blend_mode = BLEND_ADD
	icon = 'spotlight.dmi'

	pixel_x = -64
	pixel_y = -64

	canSave = FALSE