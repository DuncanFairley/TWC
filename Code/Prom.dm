/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob
	PromMan
		icon = 'PromMan.dmi'
		name = "Mr Prom"
		mouse_over_pointer = MOUSE_HAND_POINTER
		var/details = {"The date is set! Prom will be held June 23!<br>
Make sure you have your costume worked out well in advance. You can try out custom clothes up in the Prom Changeroom on the 4th floor - right by Duel Class.<br>
Once you enter the room, you'll have a new verb tab labelled, "Prom".<br>
Use Change Prom Icon to choose the icon you'll use for Prom. Once you're happy with the icon, leave the room. Your icon will be kept in storage until Prom.<br>
If you change your mind about using a custom icon for Prom, use Clear Prom Icon."}
		var/list/sayings = list(
		"Hey there! Have you heard about prom yet? Come talk to me.",
		"Are you ready for prom?",
		"I heard there's going to be butterbeer at this prom!",
		"I can't decide what I'm going to wear...",
		"I know all about prom! Talk to me about it!",
		"Does this hat make me look fat?",
		"Are you going to prom?",
		"You'd better come to prom.",
		"I really, really, REALLY like prom.",
		"Is is classier to pick up my date by flying limousine, or thestral-drawn carriage?",
		"I can't wait to hear who sings for TWC Idol this year...",
		"I have all the information for prom! Ask me! Please! I'm bored!",
		"I'm going to be prom King this year!",
		"The 23rd is also Murrawhip's birthday!",
		"I heard prom entrants get a crazy amount of gold just for entering.",
		"I wonder if Sylar will agree to come with me to prom..."
		)//Why are you reading this, Ander... :/
		New()
			..()
			overlays += new/image('PromMan.dmi',"top",pixel_y=32)
			Advertise()
		proc
			Advertise()
				spawn()while(src)
					sleep(3600)
					speak()
			speak()
				hearers() << "<i><b>Mr Prom</b>: [pick(sayings)]</i>"
		Click()
			Talk()
		verb
			Talk()
				set src in oview(3)
				usr << npcsay("Mr Prom: [details]")
obj/reflection
	layer = 4
	pixel_y = 16
	var/atom/movable/parent
	New(loc,parent)
		src.loc = loc
		src.parent = parent
		..()
		checkforparent()
	proc/checkforparent()
		spawn()while(src)
			sleep(1)
			if(!parent)
				del(src)

obj/mirror
	icon = 'mirror.dmi'
	glass
		icon_state = "glass"
		layer = 5
		density = 1
		var/obj/mirror/frame/frame
		var/obj/mirror/base/base
		var/list/obj/reflection/reflections = list() //associative
		New()
			..()
			frame = new(src)
			base = new(src)
			action()
		proc
			action()
				spawn()while(src)
					sleep(1)
					for(var/atom/movable/V in reflections)
						var/obj/reflection/ref = reflections[V]
						if(ref)
							if(V.loc != base.loc)
								//was killed or something
								base.unmirror(V)
							else
								ref.overlays = V.overlays
								ref.icon = V.icon
								ref.icon_state = V.icon_state
								var/newdir
								newdir = V.dir
								if(V.dir == NORTH)
									newdir = SOUTH
								else if(V.dir == SOUTH)
									newdir = NORTH
								ref.dir = newdir
					/*
						if(istype(V,/atom/movable))
							var/atom/movable/user = V
							var/obj/reflection/ref = reflections[user]
							ref.overlays = user.overlays
							ref.icon_state = user.icon_state
							var/newdir
							newdir = user.dir
							if(user.dir == NORTH)
								newdir = SOUTH
							else if(user.dir == SOUTH)
								newdir = NORTH
							ref.dir = newdir
						else
							world << "try to deletttee"
							var/obj/reflection/ref = reflections[V]
							if(ref)world << "Exists"
							else world << "Doesn't"
							del(ref)
							if(ref)world << "Exists"
							else world << "Doesn't"
							reflections.Remove(V)
							users.Remove(V)
					world << "users: [users.len] reflections: [reflections.len]"*/

		shop
			var/shoppath
			name = "glass"

			male_wig_shop
				shoppath = /obj/shop/base/malewigshop

			female_wig_shop
				shoppath = /obj/shop/base/femalewigshop

			random
				shoppath = /obj/shop/base/random

			New()
				..()
				new shoppath (src,0,-1)

	frame
		icon_state = "frame"
		layer = 7
		density = 1
		New(obj/mirror/parent)
			loc = parent.loc
	base
		var/obj/mirror/glass/parent
		proc
			mirror(atom/movable/M)

				var/newdir
				newdir = M.dir
				if(M.dir == NORTH)
					newdir = SOUTH
				else if(M.dir == SOUTH)
					newdir = NORTH
				var/obj/reflection/newref = new (locate(x,y+1,z),M)
				newref.icon = M.icon
				newref.icon_state = M.icon_state
				newref.layer = 6
				newref.pixel_y = 16
				newref.dir = newdir
				newref.overlays = M.overlays
				parent.reflections[M] = newref
			unmirror(atom/movable/M)
				del(parent.reflections[M])
				parent.reflections.Remove(M)
		New(obj/mirror/glass/parent)
			loc = locate(parent.x,parent.y-1,parent.z)
			src.parent = parent




/*

obj/reflection
	layer = 4
	pixel_y = 16
obj/mirror
	icon = 'mirror.dmi'
	glass
		icon_state = "glass"
		layer = 3
		density = 1
		var/obj/mirror/frame/frame
		var/obj/mirror/base/base
		var/obj/reflection
		var/atom/movable/user
		New()
			..()
			frame = new(src)
			base = new(src)
			action()
		proc
			action()
				spawn()while(src)
					sleep(1)
					if(user)
						reflection.overlays = user.overlays
						reflection.icon_state = user.icon_state
						var/newdir
						newdir = user.dir
						if(user.dir == NORTH)
							newdir = SOUTH
						else if(user.dir == SOUTH)
							newdir = NORTH
						reflection.dir = newdir
					else if(reflection)
						del(reflection)

	frame
		icon_state = "frame"
		layer = 5
		density = 1
		New(obj/mirror/parent)
			loc = parent.loc
	base
		var/obj/mirror/glass/parent
		proc
			mirror(atom/movable/M)
				del(parent.reflection)
				parent.user = M
				var/newdir
				newdir = M.dir
				if(M.dir == NORTH)
					newdir = SOUTH
				else if(M.dir == SOUTH)
					newdir = NORTH
				parent.reflection = new(locate(x,y+1,z))
				parent.reflection.icon = M.icon
				parent.reflection.icon_state = M.icon_state
				parent.reflection.layer = 4
				parent.reflection.pixel_y = 16
				parent.reflection.dir = newdir
				parent.reflection.overlays = M.overlays
			unmirror(atom/movable/M)
				parent.user = null

		New(obj/mirror/glass/parent)
			loc = locate(parent.x,parent.y-1,parent.z)
			src.parent = parent

obj/mirror
	icon = 'mirror.dmi'
	glass
		icon_state = "glass"
		layer = 3
		var/obj/mirror/frame/frame
		var/obj/mirror/base/base
		var/obj/reflection
		New()
			..()
			frame = new(src)
			base = new(src)

	frame
		icon_state = "frame"
		layer = 5
		New(obj/mirror/parent)
			loc = parent.loc
	base
		var/obj/mirror/glass/parent
		proc
			mirror(mob/M)
				var/newdir
				newdir = M.dir
				if(M.dir == NORTH)
					newdir = SOUTH
				else if(M.dir == SOUTH)
					newdir = NORTH
				var/image/i = image(M.icon,M.icon_state,dir=newdir,pixel_y=16,layer=4)
				i.overlays = M.overlays
				parent.overlays = list(i)
			unmirror(mob/M)
				parent.overlays = list()

		New(obj/mirror/glass/parent)
			loc = locate(parent.x,parent.y-1,parent.z)
			src.parent = parent*/

mob/var/tmp/baseicon
area/hogwarts/promChangeRoom
	Exited(atom/movable/Obj)
		. = ..()
		if(Obj && isplayer(Obj) && prom == 1)
			var/mob/Player/p = Obj
			if(p && p.mprevicon)
				p.icon = p.mprevicon
				p.mprevicon = null
	Entered(atom/movable/O)
		. = ..()
		if(O && isplayer(O) && prom)
			var/mob/Player/p = O
			if(promicons[p.ckey] && !p.mprevicon)
				if(promicons[usr.ckey] != usr.icon)
					p.mprevicon = usr.icon
				p.icon = promicons[usr.ckey]

	New()
		..()
		init()

	proc
		init()
			if(prom != 0)
				verbs += typesof(/area/hogwarts/promChangeRoom/verb/)
			else
				verbs -= typesof(/area/hogwarts/promChangeRoom/verb/)
	verb
		Clear_Prom_Icon()
			set category = "Prom"
			if(usr.loc.loc != src)return
			if(alert("This will remove any uploaded icon of yours. Do this if you decide against having a custom icon for Prom. Do you wish to clear your prom icon?",,"Yes","No")=="Yes")
				var/mob/Player/p = usr
				p.mprevicon = null
				promicons[p.ckey] = null
				if(usr.Gender=="Male")
					if(p.Gm)
						p.icon = 'MaleStaff.dmi'
						p.icon_state = ""
					else if(p.House == "Gryffindor")
						p.icon = 'MaleGryffindor.dmi'
						p.icon_state = ""
					else if(p.House == "Ravenclaw")
						p.icon = 'MaleRavenclaw.dmi'
						p.icon_state = ""
					else if(p.House == "Slytherin")
						p.icon = 'MaleSlytherin.dmi'
						p.icon_state = ""
					else if(p.House == "Hufflepuff")
						p.icon = 'MaleHufflepuff.dmi'
						p.icon_state = ""
				else
					if(p.Gm)
						p.icon = 'FemaleStaff.dmi'
						p.icon_state = ""
					else if(p.House == "Gryffindor")
						p.icon = 'FemaleGryffindor.dmi'
						p.icon_state = ""
					else if(p.House == "Ravenclaw")
						p.icon = 'FemaleRavenclaw.dmi'
						p.icon_state = ""
					else if(p.House == "Slytherin")
						p.icon = 'FemaleSlytherin.dmi'
						p.icon_state = ""
					else if(p.House == "Hufflepuff")
						p.icon = 'FemaleHufflepuff.dmi'
						p.icon_state = ""

		Change_Prom_Icon()
			set category = "Prom"
			if(usr.loc.loc != src)return
			alert("Any icon you choose must be no larger than 32 pixels wide by 32 pixels high. There is no tolerance here for any person who uploads an icon which isn't appropriate for a child's eyes.")
			var/icon/I = new(input("Select an icon to try:") as icon|null)
			if(!I)return
			if(!istype(usr.loc.loc,/area/hogwarts/promChangeRoom))return
			if(I.Width() <= 32 && I.Height() <= 32)
				var/mob/Player/p = usr
				promicons[p.ckey] = I
				if(!p.mprevicon)
					p.mprevicon = p.icon
				//usr.loc.loc.Enter(usr)
				p.icon = promicons[p.ckey]
			else
				alert("Uploaded icons must be no larger than 32 pixels wide and 32 pixels high.")

var/list/icon/promicons = list()

var/prom = 0

mob/test/verb/Toggle_Prom()
	set category = "Staff"

	switch(alert("Toggle to?", "Toggle Prom", "Active", "Inactive", "Changeroom"))
		if("Active")
			prom = 2
			src << infomsg("Toggled prom on.")
		if("Inactive")
			prom = 0
			src << infomsg("Toggled prom off.")

			for(var/mob/Player/p in Players)
				if(p.mprevicon)
					p.icon = p.mprevicon
					p.mprevicon = null

		if("Changeroom")
			prom = 1
			src << infomsg("Toggled prom changeroom on.")

	var/area/hogwarts/promChangeRoom/prom_area = locate(/area/hogwarts/promChangeRoom)
	prom_area.init()
