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
	//area = /area/outside	// make outside the default area

	New()									// When the world begins
		..()								// do the regular things
		for(var/area/outside/O in world)	// Look for outside areas
			spawn() O.daycycle()
						// begin the daycycle
		for(var/area/newareas/outside/O in world)	// Look for outside areas
			spawn() O.daycycle()

Weather
	var/list/clouds = list()
	proc
		clouds(p=0)
			generate_clouds(14, p)
			generate_clouds(15, p)
			generate_clouds(16, p)

		rain()
			clouds(150)
			for(var/area/A in world) // look for an outside area
				if( (A.type == /area/outside) || (A.parent_type == /area/outside) || (A.parent_type == /area/newareas/outside) )
					for(var/turf/water/w in A)
						if(prob(10)) continue
						w.rain()
					A:SetWeather(/obj/weather/rain)
					A.dmg = 1
		acid()
			clouds(150)
			for(var/area/A in world) // look for an outside area
				if( (A.type == /area/outside) || (A.parent_type == /area/outside) || (A.parent_type == /area/newareas/outside) )
					for(var/turf/water/w in A)
						if(prob(10)) continue
						w.rain()
					A:SetWeather(/obj/weather/acid)
					A.dmg = 2

		clear(p = 10)
			clouds(p)
			for(var/area/A in world) // look for an outside area
				if( (A.type == /area/outside) || (A.parent_type == /area/outside) || (A.parent_type == /area/newareas/outside) )
					for(var/turf/water/w in A)
						w.clear()
					A:SetWeather()
					A.dmg = 1


		// relocates / removes / adds existing clouds according to requirement per z level
		generate_clouds(z, p=0)
			p = max(0,p)
			if("[z]" in clouds)
				var/list/z_clouds = clouds["[z]"]
				if(z_clouds.len > p)
					var/count = z_clouds.len - p
					while(count > 0)
						count--
						var/obj/c = z_clouds[1]
						z_clouds  -= c
						c.loc     = null

				if(p == 0)
					clouds -= "[z]"
					return

				for(var/obj/cloud/c in z_clouds)
					c.loc = locate(rand(10,world.maxx), rand(10,world.maxy), z)
			else
				clouds["[z]"] = list()

			var/list/z_clouds = clouds["[z]"]
			if(z_clouds.len < p)
				var/count = p - z_clouds.len
				while(count > 0)
					count--
					new/obj/cloud/ (locate(rand(10,world.maxx), rand(10,world.maxy), z))

var/Weather/weather

proc/init_weather()
	weather = new()
	scheduler.schedule(new/Event/Weather, world.tick_lag * 100)

obj/cloud
	icon  = 'clouds.dmi'
	layer = 8

	New()
		..()
		if(!("[z]" in weather.clouds))
			weather.clouds["[z]"] = list()
		weather.clouds["[z]"] += src

		pixel_x    = rand(32, -32)
		pixel_y    = rand(32, -32)
		icon_state = "[rand(1,10)]"
		pixel_z    = rand(192, 320)

		var/obj/o    = new
		o.icon       = icon
		o.icon_state = "[icon_state]_shadow"
		o.pixel_z    = -pixel_z

		underlays += o

		loop()

	proc
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

					else
						step(src, SOUTHEAST)

					sleep(8)

area
	outside	// lay this area on the map anywhere you want it to change from night to day
		layer = 6	// set this layer above everything else so the overlay obscures everything
		var
			lit = 1	// determines if the area is lit or dark.
			obj/weather/Weather	// what type of weather the area is having
		Entered(mob/Player/M)
			if(!istype(M, /mob/Player)) return
		AzkabanGroundExit
			Entered(mob/Player/M)
				if(!istype(M, /mob)) return
				if(M.monster==1)
					return
				else
					M.loc=locate(98,22,15)
		To_DA/Entered(mob/Player/M)
			if(!istype(M,/mob)) return
			if(M.monster==1)
				return
			else
				if(usr.flying==1)
					M.icon_state=""
					M.density=1
					M.flying=0
					M.loc=locate(45,5,26)
				else
					M.loc=locate(45,5,26)
		SilverbloodGroundEnter/Entered(mob/Player/M)
			M.loc=locate(49,2,3)
				//M<<"<b><font size=3><font color=green>You are not a Death Eater. You may not pass. Be gone!"
				//sleep(20)
				//M<<"<B>You are suddenly blasted with a strange energy, and teleported back to Hogsmeade."
				//flick('apparate.dmi',M)
				//M.loc=locate(51,1,18)
				//flick('apparate.dmi',M)

		SilverbloodAurorPrevent/Entered(mob/Player/M)
			..()
		//	sleep(8)
			//if(M.Auror==1)
			//	return
			//	M<<"<b><font size=2><font color=green>Ugh! An Auror! You may not pass! All Death Eaters have been alerted to your attempted intrusion."
			//	sleep(20)
			//	M<<"<B>You are suddenly blasted with a strange energy, and teleported back to Hogsmeade."
			//	flick('apparate.dmi',M)
			//	M.loc=locate(51,1,18)
			//	flick('apparate.dmi',M)
		HogwartsGroundEnter/Entered(mob/Player/M)
			if(!istype(M, /mob)) return
			if(M.key)
			//	M<<"<b><font size=3><font color=green>Your aura reeks of evil and hatred. You are a Death Eater! You may not pass into Hogwarts. Be gone!"
			//	sleep(20)
			//	M<<"<B>You are suddenly blasted with a strange energy, and teleported back to Hogsmeade."
			//	flick('apparate.dmi',M)
				//M.loc=locate(51,1,18)
				M.loc=locate(50,3,15)
			//	flick('apparate.dmi',M)
			//else
			//	M.loc=locate(51,3,15)
		Hogsmaede_Enter/Entered(mob/Player/M)
			if(M.monster==1)
				return
			else
				M.density = 0
				M.Move(locate(51,3,18))
				M.density = 1
				M.flying = 0
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
		proc
			nightcycle()
				lit = 0 - lit	// toggle lit between 1 and 0
				world<<"<b>Event: <font color=blue>[usr] has commanded the sun to set over the lake. Night has fallen."
				overlays += 'black50.dmi'	// add the 50% dither
				sleep(9000)
				for(var/area/outside/O in world)
					O.daycycle()





/*
	If you prefer real darkness (luminosity = 0), replace the daycycle() proc
	with the one below. Using luminosity for outside darkness is better if
	you want to use other light sources like torches.

			daycycle()
				luminosity = 1 - luminosity	// toggle between 1 and 0
				spawn(20) daycycle()	// change the 20 to make longer days and nights
*/

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




mob/GM/verb
	Rain()
		set category="Server"
		world<<"<B><font color=silver>Rain begins to pour from the sky."
		weather.rain()

	Acid()
		set category="Server"
		world<<"<B><font color=silver>Acid rain begins to pour from the sky."
		weather.acid()

	Snow()
		set category="Server"
		world<<"<B><font color=silver>Snow begins to flurry from the sky."
		for(var/area/A in world)		// look for an outside area
			if( (A.type == /area/outside) || (A.parent_type == /area/outside) || (A.parent_type == /area/newareas/outside) )
				A:SetWeather(/obj/weather/snow)

	Clear_weather()
		set category="Server"
		world<<"<B><font color=silver>The weather has cleared."
		weather.clear()

	DayNight()
		set category = "Server"
		return
		for(var/area/outside/O in world)
			spawn() O.daycycle()
/*	Night()
		set category = "Server"
		for(var/area/outside/O in world)
			spawn() O.nightcycle()
*/

obj/weather
	layer = 7	// weather appears over the darkness because I think it looks better that way
	dontsave=1
	rain
		icon = 'misc.dmi'
		icon_state = "rain"
		New()
			src.overlays += image('weather.dmi')
			..()

	snow
		icon = 'misc.dmi'
		icon_state = "snow"

	acid
		icon = 'misc.dmi'
		icon_state = "acid"



