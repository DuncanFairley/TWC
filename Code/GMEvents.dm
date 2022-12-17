mob/TalkNPC
	Custom
		var/message

		Talk()
			set src in oview(3)

			if(!message) return

			if(istext(message))
				message = splittext(message, ";")

			var/ScreenText/s = new(usr, src)
			for(var/m in message)
				s.AddText(m)



	EventMob
		icon = 'NPCs.dmi'
		icon_state = "palmer"
		name = "Event Mob"
		Gm = 1

		var
			list
				AlreadyGiven = list()
				id = list()
			Message = "Hello."

		/*
		This mob gives an item once to everyone who talks to it.
		*/
		Item
			var/EventItem
			var/Unique

			Talk()
				set src in oview(3)
				if(!EventItem)
					usr << "<span style=\"font-size:2; color:red;\"><b>[src]</b> : </span>I have nothing to give you."
					return
				if(..())
					if(Unique && (locate(text2path(EventItem)) in usr))
						usr << "<span style=\"font-size:2; color:red;\"><b>[src]</b> : </span>You already have the item I'm giving, move along!"
						return

					var/obj/O = new EventItem(usr)
					usr << "<span style=\"font-size:2; color:red;\">[src] hands you their [O.name].</span>"

		/* This mob changes a var to everyone who talks to it.
		   It can add/remove/double for number values. (Adding also works for lists I guess)
		   For example, it can give everyone who talks to it 100 Gold once. */
		Variable
			var
				EventVar
				VarTo
				Function = "+"

			Talk()
				set src in oview(3)
				if(!EventVar)
					usr << " <span style=\"font-size:2; color:red;\"><b>[src]</b> : </span>I have nothing to give you."
					return
				if(..())
					if(Function == "=")
						usr.vars[EventVar] = VarTo
					else if(Function == "+")
						usr.vars[EventVar] += VarTo
					else if(Function == "*")
						usr.vars[EventVar] *= VarTo


		Talk()
			set src in oview(3)
			if(AlreadyGiven == "reset")
				AlreadyGiven = list()
				id = list()
			if((usr.ckey in AlreadyGiven) || (usr.client.computer_id in id))
				usr << " <span style=\"font-size:2; color:red;\"><b>[src]</b> : </span>Hello! I've seen you before!"
				return 0
			else
				usr << " <span style=\"font-size:2; color:red;\"><b>[src]</b> : </span>[Message]"
				AlreadyGiven.Add(usr.ckey)
				id.Add(usr.client.computer_id)
				return 1

mob/Player
	var/tmp
		EditVar
		EditVal
		ClickEdit = 0
		ClickCreate = 0
		CreatePath
		list/CreateVars
mob/GM
	verb
		Toggle_Click_Create()
			set category = "Events"
			var/mob/Player/p = src
			if(p.ClickCreate)
				p.ClickCreate = 0
				p.CreatePath = null
				p.CreateVars = null
				p << "Click Creating mode toggled off."
			else
				if(p.ClickEdit) Toggle_Click_Editing()
				p.ClickCreate = 1
				p << "Click Creating mode toggled on."
		Toggle_Click_Editing()
			set category = "Events"
			var/mob/Player/p = src
			if(p.ClickEdit)
				p.ClickEdit = 0
				p.EditVar = null
				p.EditVal = null
				p << "Click Editing mode toggled off."
			else
				if(p.ClickCreate) Toggle_Click_Create()
				p.ClickEdit = 1
				p << "Click Editing mode toggled on."
		CreatePath(Path as null|anything in typesof(/area,/turf,/obj,/mob) + list("Delete"))
			set category = "Events"
			var/mob/Player/p = src
			p.CreatePath = Path
			p << "Your CreatePath is now set to [Path]."
		CreateVars(var/text as null|message)
			set category = "Events"
			var/mob/Player/p = src
			p.CreateVars = splittext(text, "\n")
			p << "Your CreateVars is now set to [text]."
		MassEdit(Var as text)
			set category = "Events"
			var/mob/Player/p = src
			var/Type = input("What type?","Var Type") as null|anything in list("text","num","reference","null")
			if(Type)
				p.EditVar = Var
				switch(Type)
					if("text")
						p.EditVal = input("Value:","Text") as text
						p << "Your MassEdit variable is now [p.EditVar] with the text value [p.EditVal]."
					if("num")
						p.EditVal = input("Value:","Number") as num
						p << "Your MassEdit variable is now [p.EditVar] with the number value [p.EditVal]."
					if("reference")
						p.EditVal = input("Value:","Reference") as area|turf|obj|mob in world
						p << "Your MassEdit variable is now [p.EditVar] with the reference [p.EditVal]."
					if("null")
						p.EditVal = null
		FFA_Mode(var/dmg as num, var/os as anything in list("On", "Off"), var/scale as anything in list("Scale damage", "Normal damage"))
			set category = "Events"
			var/area/a = locate(/area/arenas/MapThree/PlayArea)
			if(scale == "Scale damage")
				a.scaleDamage = dmg
			else
				a.dmg = dmg
			a.oldsystem = os == "On"
			src << infomsg("Set dmg modifier to [dmg], old system is [os].")



atom/Click(location)
	..()

	if(isplayer(usr))
		var/mob/Player/p = usr
		if(p.ClickEdit)
			if(!p.EditVar)
				p << "Pick a var to edit using MassEdit verb."
			else if(p.EditVar in vars)

				if(!p.admin && (istype(src, /obj/items) || istype(src, /obj/pet) || isarea(src) || z < SWAPMAP_Z || p.z < SWAPMAP_Z || ismob(src)))
					return

				vars[p.EditVar] = p.EditVal
		else if(p.ClickCreate)
			if(!p.CreatePath)
				p << "Pick a path to create using CreatePath verb."
			else

				if(!p.admin && (p.z < SWAPMAP_Z || src.z < SWAPMAP_Z || ispath(p.CreatePath, /obj/items) || ispath(p.CreatePath, /mob)))
					p << errormsg("Can't use outside swap maps or create items/mobs.")
					return
				if(ispath(p.CreatePath, /obj/items/wearable/wigs/male_demonic_wig))
					p << errormsg("Nice try.")
					return

				if(p.CreatePath == "Delete" && !isplayer(src))
					del src
				else if(isturf(location))
					var/atom/a = new p.CreatePath (location)

					if(p.CreateVars)
						for(var/line in p.CreateVars)

							var/list/split = splittext(line, "=")

							if(split.len != 2 || !(split[1] in a.vars))
								p.CreateVars -= line
								continue

							if(findtext(split[2], "@"))
								var/ref = locate(copytext(split[2], 2))
								if(!ref)
									p.CreateVars -= line
									continue
								a.vars[split[1]] = ref
							else if(split[2] == "null")
								a.vars[split[1]] = null
							else
								var/n = text2num(split[2])
								if(isnum(n))
									a.vars[split[1]] = n
								else
									a.vars[split[1]] = split[2]



obj/push

	reset
		icon = 'stone_plate.dmi'
		icon_state = "plateround"

		var
			range = 10
			kill  = 0

		Crossed(atom/movable/a)
			.=..()
			if(isplayer(a) && !findtext(icon_state, "_pressed"))
				icon_state = "[icon_state]_pressed"
				for(var/obj/push/rock/r in orange(range, src))
					r.reset(src)

		Uncrossed(atom/movable/a)
			.=..()
			if(isplayer(a) && findtext(icon_state, "_pressed"))

				var/mob/Player/p = locate() in loc
				if(p) return

				icon_state = replacetext(icon_state, "_pressed", "")
				for(var/obj/push/rock/r in orange(range, src))
					r.moving &= ~2

	delegate
		canSave = FALSE
		density = 1
		var/tmp
			obj/push/rock/r
			relX
			relY

		Cross(atom/movable/a)
			if(istype(a, /obj/push/rock) && a == r)
				. = 1
			else if(istype(a, /obj/push/delegate))
				var/obj/push/delegate/d = a
				. = r == d.r
			else
				. = r.Cross(a)

	rock
		density = 1
		post_init = 1
		icon = 'Push Rock.dmi'

		two
			push = 2
		three
			push = 3
		four
			push = 4

		var
			push  = 1
			speed = 3
			tmp
				list
					dirs
					delegates
				moving = 0

		MapInit()

			transform = matrix() * (push / 4)
			var/offset = (4 - push) * -16
			pixel_x = offset
			pixel_y = offset

			glide_size = 32/(push + 4)

			if(push > 1 && !delegates)
				delegates = list()
				for(var/turf/t in block(loc, locate(x+push-1, y+push-1, z))-loc)
					var/obj/push/delegate/d = new(t)
					d.relX = t.x-x
					d.relY = t.y-y
					d.r = src
					delegates += d


		Move(NewLoc,Dir=0)
			. = 1

			for(var/turf/t in getBlock(Dir))
				if(t.density)
					. = 0
					break
				for(var/atom/movable/a in t)
					if(a.density)
						. = 0
						break

			if(.)
				.=..()

				for(var/obj/push/delegate/d in delegates)
					d.loc = locate(x+d.relX, y+d.relY, z)
		proc
			getBlock(d)
				. = list()
				if(d & EAST)
					. += block(locate(x + push, y, z), locate(x + push, y + push - 1, z))
				else if(d & WEST)
					. += block(locate(x - 1, y, z), locate(x - 1, y + push - 1, z))
				if(d & NORTH)
					. += block(locate(x, y + push, z), locate(x + push - 1, y + push, z))
				else if(d & SOUTH)
					. += block(locate(x, y - 1, z), locate(x + push - 1, y - 1, z))

			reset(var/obj/push/reset/spot)
				set waitfor = 0
				if(dirs && !(moving & 2))

					while(moving & 1)
						sleep(1)

					moving |= 2
					for(var/i = dirs.len to 1 step -1)
						var/turf/t = get_step(src, dirs[i])
						loc = t

						for(var/mob/Player/p in t)
							if(spot.kill)
								p.HP = 0
								p.Death_Check(p)
							else
								p.loc = spot.loc

						for(var/obj/push/delegate/d in delegates)
							t = locate(x+d.relX, y+d.relY, z)
							d.loc = t

							for(var/mob/Player/p in t)
								if(spot.kill)
									p.HP = 0
									p.Death_Check(p)
								else
									p.loc = spot.loc

						sleep(speed + push)

						if(!(moving & 2))
							if(i == 1)
								dirs = null
							else
								dirs.Cut(i)
							return
					moving &= ~2
					dirs = null
			push(d)
				set waitfor = 0
				if(moving) return
				moving |= 1

				var/opposite = turn(d, 180)

				if(push > 1)
					var/count = 0
					for(var/turf/t in getBlock(opposite))
						for(var/mob/Player/p in t)
							if(p.dir != d) continue
							if(p.client.moving)
								count++

					if(count < push)
						moving &= ~1
						return

				var/turf/t = get_step(src, d)
				if(t.loc == loc.loc && step(src, d))

					if(!dirs) dirs = list()

					dirs += opposite
					sleep(speed + push)

				moving &= ~1

		Cross(atom/movable/a)
			if(isplayer(a))
				var/mob/Player/p = a

				if((p.dir - 1) & p.dir) return

				if(p.client.moving)
					push(p.dir)

				. = 0

