/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
var/obj/ministrybox/ministrybox
mob/New()
	if(client)
		winset(src,"rpane.btnPotions","is-visible=true")
	..()

turf
	teleport
		var/turf/dest //tag referring to turf/destination
		//layer = 5
		//icon = 'x.dmi'
		//icon_state = "red"
		Entered(atom/movable/E)
			if(dest)
				if(isplayer(E))
					var/mob/Player/p = E
					var/atom/A = locate(dest) //can be some turf, or some obj
					if(isobj(A))
						A = A.loc

						//E.loc = locate(src.dest)
					p.Transfer(A)

					p.client.images = list()
					if(p.classpathfinding)
						p.Class_Path_to()
	destination
		//layer = 5
		//icon = 'x.dmi'
		//icon_state = "green"

turf/gotoministry
	Entered()
		if(usr)
			if(!ministrypw || ministryopen)
				if(usr.name in ministrybanlist)
					view(src) << "<b>Toilet</b>: <i>The Ministry of Magic is not currently open to you. Sorry!</i>"
				else
					viewers() << "[usr] disappears."
					var/atom/t = locate("ministryentrance")
					var/obj/dest = isturf(t) ? t : t.loc
					if(usr.flying)
						var/mob/Player/user = usr
						for(var/obj/items/wearable/brooms/Broom in user.Lwearing)
							Broom.Equip(user,1)
					for(var/client/C)
						if(C.eye)
							if(C.eye == usr && C.mob != usr)
								C << "<b><font color = white>Your Telendevour wears off.</font></b>"
								C.eye=C.mob
					usr:Transfer(dest)
			else
				view(src) << "<b>Toilet</b>: <i>The Ministry of Magic is not currently open to visitors. Sorry!</i>"

var/ministrypw = "ketchup"
var/ministryopen = 0
var/ministrybank = 0
var/taxrate = 0

turf
	proc
		AdjacentTurfs()
			var/L[] = new()
			for(var/turf/t in oview(src,1))
			//for(var/turf/t in block(locate(x-1,y-1,z),locate(x+1,y+1,z)))
				if(!t.density||t.door)
					L.Add(t)
			return L
		Distance(turf/t)
			return get_dist(src,t)
