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
	New()									// When the world begins
		..()								// do the regular things
		for(var/area/O in outside_areas)	// Look for outside areas
			spawn() O:daycycle()

Weather
	var/list/clouds = list()
	proc
		clouds(p=0, color=null)
			generate_clouds(15, p, color)
			generate_clouds(16, p, color)

		rain()
			clouds(100, "rain")
			for(var/area/A in outside_areas)
				for(var/turf/water/w in A)
					if(prob(10)) continue
					w.rain()
				A:SetWeather(/obj/weather/rain)
				A.dmg = 1
		acid()
			clouds(100, "rain")
			for(var/area/A in outside_areas)
				for(var/turf/water/w in A)
					if(prob(10)) continue
					w.rain()
				A:SetWeather(/obj/weather/acid)
				A.dmg = 2

		snow()
			clouds(100)
			for(var/area/A in outside_areas)
				A:SetWeather(/obj/weather/snow)
				A.dmg = 0.75

		clear(p = 10)
			clouds(p)
			for(var/area/A in outside_areas)
				for(var/turf/water/w in A)
					w.clear()
				A:SetWeather()
				A.dmg = 1

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
					if(c.shadow)
						c.shadow.loc = c.loc
						c.shadow.y -= rand(6,10)
					c.set_color(color)
			else
				clouds["[z]"] = list()

			var/list/z_clouds = clouds["[z]"]
			if(z_clouds.len < p)
				var/count = p - z_clouds.len
				while(count > 0)
					count--
					var/obj/cloud/c = new (locate(rand(10,world.maxx), rand(10,world.maxy), z))
					c.set_color(color)

var/Weather/weather

proc/init_weather()
	weather = new()
	scheduler.schedule(new/Event/Weather, world.tick_lag * 1)

obj/cloud
	icon  = 'clouds.dmi'
	layer = 8
	mouse_opacity = 0
	var/obj/shadow
	glide_size = 6
	New()
		..()
		if(!("[z]" in weather.clouds))
			weather.clouds["[z]"] = list()
		weather.clouds["[z]"] += src

		pixel_y    = rand(1,10)
		icon_state = "[pixel_y]"

		shadow               = new
		shadow.icon          = icon
		shadow.icon_state    = "[icon_state]_shadow"
		shadow.layer         = 6
		shadow.mouse_opacity = 0
		shadow.loc           = locate(x, y - rand(6,10), z)

		loop()

	proc
		dispose()
			loc        = null
			if(shadow)
				shadow.loc = null
				shadow     = null

		set_color(color=null)
			icon_state = "[pixel_y]"
			if(color)
				icon_state = "[icon_state]_[color]"


		loop()
			spawn()
				while(src && src.loc)
					if(y == 1 || x == world.maxx)
						var/new_x = 1
						var/new_y = world.maxy

						if(prob(50))
							new_x = rand(1, world.maxx)
						else
							new_y = rand(1, world.maxy)

						loc = locate(new_x, new_y, z)
						if(shadow) shadow.loc = locate(new_x, new_y - rand(6,10), z)
					else
						var/turf/t = get_step(src, SOUTHEAST)
						loc = t
						if(shadow && shadow.loc)
							t = get_step(shadow, SOUTHEAST)
							shadow.loc = t
					sleep(8)

var/list/outside_areas = list()
area
	outside	// lay this area on the map anywhere you want it to change from night to day
		layer = 7	// set this layer above everything else so the overlay obscures everything
		var
			lit = 1	// determines if the area is lit or dark.
			obj/weather/Weather	// what type of weather the area is having

		New()
			..()
			outside_areas += src

		proc
			daycycle()
				lit = 1 - lit	// toggle lit between 1 and 0
				var/icon/I = 'black50.dmi'
				if(lit)
					overlays -= I	// remove the 50% dither
					//if(type == /area/outside)
						//world<<"<b>Event: <font color=blue>The sun rises over the forest. A new day begins."	// remove the dither
				else
					overlays += I	// add the 50% dither
				spawn(9000) daycycle()

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
	dontsave=1
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



