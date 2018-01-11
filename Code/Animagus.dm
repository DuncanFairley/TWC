/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

turf
	teleport
		var/turf/dest //tag referring to turf/destination

		Entered(atom/movable/E)
			if(dest)
				if(isplayer(E))
					var/mob/Player/p = E
					var/atom/A = locate(dest) //can be some turf, or some obj
					if(isobj(A))
						A = A.loc
					p.Transfer(A)

					p.removePath()
					if(p.classpathfinding)
						p.Class_Path_to()
					else if(p.pathdest)
						p.pathTo()
	destination

turf/gotoministry
	Entered()
		if(usr)
			if(!worldData.ministrypw || worldData.ministryopen)
				if(usr.name in worldData.ministrybanlist)
					view(src) << "<b>Toilet</b>: <i>The Ministry of Magic is not currently open to you. Sorry!</i>"
				else
					viewers() << "[usr] disappears."
					var/atom/t = locate("ministryentrance")
					var/obj/dest = isturf(t) ? t : t.loc
					if(usr.flying)
						var/mob/Player/user = usr
						for(var/obj/items/wearable/brooms/Broom in user.Lwearing)
							Broom.Equip(user,1)
					for(var/mob/Player/p in Players)
						if(p.client.eye == usr && p != usr && p.Interface.SetDarknessColor(TELENDEVOUR_COLOR))
							p << errormsg("Your Telendevour wears off.")
							p.client.eye = p
					usr:Transfer(dest)
			else
				view(src) << "<b>Toilet</b>: <i>The Ministry of Magic is not currently open to visitors. Sorry!</i>"

turf
	var/tmp/skip = 0
	proc
		AdjacentTurfs()
			var/L = list()
			for(var/turf/t in orange(1, src))
				if(skip) continue
				if(!t.density)
					L += t
			return L

		Distance(turf/t)
			return abs(x - t.x) + abs(y - t.y)

turf
	blankturf/skip = 1
	sideBlock/skip = 1
