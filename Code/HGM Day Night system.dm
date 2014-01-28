/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
area
	mouse_opacity = 0
world
	//area = /area/outside	// make outside the default area

	New()									// When the world begins
		..()								// do the regular things
		for(var/area/outside/O in world)	// Look for outside areas
			spawn() O.daycycle()
						// begin the daycycle
		for(var/area/newareas/outside/O in world)	// Look for outside areas
			spawn() O.daycycle()


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
		Arena_Exit
			Entered(mob/Player/M)
				if(istype(M, /mob/Player))
					M.density = 0
					M.Move(locate(3,21,15))
					M.density = 1
		Arena
			Entered(mob/Player/M)
				if(!M || !istype(M, /mob/Player)) return
				if(M.monster==1)
					return
				else
					M.loc=locate(50,100,17)
		AzkabanGroundEnter
			Entered(mob/Player/M)
				if(!istype(M, /mob/Player))
					return
				else
					usr.density=1
					usr.flying=0
					usr.icon_state=""
					M << "<font color=red>Welcome to Diagon Alley. Ollivander's Wand Shop is the first shop on the right, after you move through the moving wall</font>"
					M.loc=locate(45,5,26)
		Dark_Forest
			Entered(mob/Player/M)
				if(!istype(M,/mob)) return
				if(M.monster==1)
					return
				else
					M.density = 0
					M.Move(locate(92,3,16))
					M.density = 1
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
		Student_Housing2/Entered(mob/Player/M)
			if(!istype(M,/mob)) return
			if(M.monster==1)
				return
			else
				M.loc=locate(2,25,17)

		Student_Housing3/Entered(mob/Player/M)
			if(!istype(M,/mob)) return
			if(M.monster==1)
				return
			else
				M.loc=locate(48,99,8)

		Student_Housing4/Entered(mob/Player/M)
			if(M.monster==1)
				return
			else
				M.loc=locate(47,2,19)
		Hogsmaede_Exit/Entered(mob/Player/M)
			if(!istype(M, /mob)) return
			if(M.monster==1)
				return
			else
				M.loc=locate(51,1,17)
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
		Student_Housing/Entered(mob/Player/M)
			if(M.monster==1)
				return
			else
				M.loc=locate(100,44,19)
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
	Change_Area()
		set category="Server"
		var/turf/T = loc
		if(!T) return	// for some reason, the mob is not on a turf.

		if(istype(T.loc,/area/outside))	// if the turf is in an outside area
			T.loc.contents -= T	// remove the turf from the outside area
								// This does NOT move the turf, only changes
								// the area it is associated with.

			var/area/inside/I
			for(I in world)		//find an inside area
				break
			if(!I) I = new()	// if there are no inside areas, create one

			I.contents += T		// add the turf location to the inside area
			usr << "This is an <b>inside</b> area now."

		else	// this turf isn't outside
			T.loc.contents -= T	// remove the turf from it's current area

			var/area/outside/O
			for(O in world)		// look for an outside area
				break
			if(!O) O = new()	// if there are no outside areas, create one

			O.contents += T		// place the turf in the outside area
			usr << "This is an <b>outside</b> area now."

	Rain()
		set category="Server"
		world<<"<B><font color=silver>Rain begins to pour from the sky."
		for(var/area/A in world)		// look for an outside area
			if( (A.type == /area/outside) || (A.parent_type == /area/outside) || (A.parent_type == /area/newareas/outside) )
				A:SetWeather(/obj/weather/rain)
	Acid()
		set category="Server"
		set hidden = 1

	Snow()
		set category="Server"
		world<<"<B><font color=silver>Snow begins to flurry from the sky."
		for(var/area/A in world)		// look for an outside area
			if( (A.type == /area/outside) || (A.parent_type == /area/outside) || (A.parent_type == /area/newareas/outside) )
				A:SetWeather(/obj/weather/snow)

	Clear_weather()
		set category="Server"
		world<<"<B><font color=silver>The weather has cleared."
		for(var/area/A in world)		// look for an outside area
			if( (A.type == /area/outside) || (A.parent_type == /area/outside) || (A.parent_type == /area/newareas/outside) )
				A:SetWeather()
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



