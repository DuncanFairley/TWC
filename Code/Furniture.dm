/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

turf/gender_easter_egg
	var/tmp
		turf/gender_easter_egg/related
		obj/WTable/table

	New()
		..()
		spawn(1)
			related = locate() in (block(locate(x - 2, y, z),locate(x + 2, y, z)) - src)
			table   = locate() in oview(1, src)

	proc/trigger()
		if(!table || !related) return

		var/g1 = 0
		var/g2 = 0

		for(var/mob/Player/p in src)
			if(p.gender == "male")        g1 |= 1
			else if(p.gender == "female") g1 |= 2
			if(g1 == 3) break

		for(var/mob/Player/p in related)
			if(p.gender == "male")        g2 |= 1
			else if(p.gender == "female") g2 |= 2
			if(g2 == 3) break

		if(g1 != 0 && g1 == g2)
			animate(table, color = "#fff", time = 1, loop = -1)
			var/list/colors = list("#FF0000", "#FF7F00", "#FFFF00", "#00FF00", "#0000FF", "#4B0082", "#8B00FF")
			while(colors.len)
				var/c = pick(colors)
				colors -= c
				animate(color = c, time = 5)

		else
			animate(table, color = null, time = 10)

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(isplayer(Obj) && (Obj.gender == "male" || Obj.gender == "female"))
			trigger()

	Exited(atom/movable/Obj,atom/OldLoc)
		..()
		if(isplayer(Obj) && (Obj.gender == "male" || Obj.gender == "female"))
			trigger()

obj/Bar_Stuff
	icon = 'Bar Sign.dmi'
	Special_Offers
		icon_state = "Special Offers"
		density = 1
		opacity = 0
		layer   = 4

obj/Market_Stall
	icon       = 'Market Stall.dmi'
	icon_state = "market stall"
	layer      = 5