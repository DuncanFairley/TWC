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
			. = list()
			for(var/turf/t in orange(1, src))
				if(skip) continue
				if(!t.density)
					. += t

		Distance(turf/t)
			return abs(x - t.x) + abs(y - t.y)

turf
	blankturf/skip = 1
	sideBlock/skip = 1


mob/Player
	var
		animagusState
		animagusOn = 0
		animagusPower = 0

	Bump(atom/movable/O)
		set waitfor = 0
		..()
		if(O in Summons)
			var/tmpLoc = O.loc
			O.density = 0
			O.Move(loc)
			Move(tmpLoc)
			O.density = 1
		else if(istype(O, /obj/lootdrop))
			if(O.icon_state == "barrels")
				O:drop(src)
		else if(ismonster(O))

			if(RING_DISPLACEMENT in passives)
				var/tmpLoc = O.loc
				O.density = 0
				O.Move(loc)
				Move(tmpLoc)
				O.density = 1
			else
				if(world.time - lastproj < 2) return
				lastproj = world.time

				var/mob/Enemies/e = O

				var/dmg = Dmg + clothDmg + Slayer.level

				if(animagusOn)
					dmg *= 1.25 + Animagus.level/100
				else if(level > 50)
					dmg *= 0.5

				if(e.canBleed)
					var/n = dir2angle(get_dir(O, src))
					emit(loc    = e,
						 ptype  = /obj/particle/fluid/blood,
					     amount = 4,
					     angle  = new /Random(n - 25, n + 25),
					     speed  = 2,
					     life   = new /Random(15,25))

				var/angle = dir2angle(dir)
				var/px = round(6  * cos(angle), 1)
				var/py = round(-6 * sin(angle), 1)
				pixel_x += px
				pixel_y += py
				sleep(2)
				pixel_x -= px
				pixel_y -= py

				var/exp2give = e.onDamage(dmg, src)
				if(exp2give > 1 && animagusOn)
					Animagus.add(exp2give, src, 1)

	proc
		AnimagusTick(hudobj/Animagus/a)
			set waitfor = 0

			animagusOn = 1
			dashDistance = 4

			if(tickers & ANIMAGUS_TICK) return
			tickers |= ANIMAGUS_TICK

			noOverlays++

			HPRegen()

			while(animagusOn)
				a.maptext = {"<span style=\"color:[mapTextColor];font-size:2px;\"><b>[--animagusPower]%</b></span>"}
				sleep(20 + Animagus.level*2)

				if(animagusPower <= 0)
					noOverlays--
					a.color = null
					AnimagusRecover(a)
					BaseIcon()
					flick("transfigure", src)
					ApplyOverlays()
					break

			tickers &= ~ANIMAGUS_TICK

		AnimagusRecover(hudobj/Animagus/a)
			set waitfor = 0

			if(animagusOn)
				dashDistance = 0
			animagusOn = 0


			if((tickers & ANIMAGUS_RECOVER) > 0) return
			tickers |= ANIMAGUS_RECOVER

			while(!animagusOn && animagusPower < 100 + Animagus.level)
				a.maptext = {"<span style=\"color:[mapTextColor];font-size:2px;\"><b>[++animagusPower]%</b></span>"}
				sleep(50)

			tickers &= ~ANIMAGUS_RECOVER


mob/Player/proc

	findGroundTile()
		var/ny
		var/nz
		var/nx = clamp(x, 1, 99)

		ny = 1 + (y % 25) * 4

		if(y >= 75)
			nz = 16
		else if(y >= 50)
			nz = 6

			nx = clamp(nx, 1, 82)


		else if(y >= 25)
			nz = 15
			nx = clamp(nx, 16, 99)
			ny = clamp(ny, 11, 99)
		else
			nz = 9

			nx = clamp(nx, 1, 82)
			ny = clamp(ny, 16, 99)

		var/turf/dest = locate(nx, ny, nz)
		var/area/a = dest.loc
		while(!(istype(a, /area/outside) || istype(a, /area/newareas/outside)) || dest.flyblock || dest.skip)
			ny--
			if(ny <= 0) ny = 100
			dest = locate(nx, ny, nz)
			a = dest.loc
		return dest

	findSkyTile()
		var/ny
		var/nz
		var/nx = clamp(x, 1, 99)

		ny = round(y / 4)
		if(z == 16) ny += 75
		else if(z == 6) ny += 50
		else if(z == 15) ny += 25

		nz = 22

		var/turf/dest = locate(nx, ny, nz)
		while(!istype(dest, /turf/sky))
			ny--
			if(ny < 0) ny = 100
			dest = locate(nx, ny, nz)

		return dest

hudobj

	Fly
		name       = "Fly Up"
		icon_state = "fly up"
		anchor_x   = "WEST"
		screen_x   = 156
		screen_y   = -48
		anchor_y   = "NORTH"

		maptext_x = 32
		maptext_y = 8

		mouse_opacity = 2

		MouseEntered()
			transform *= 1.25
		MouseExited()
			transform = null

		New(loc=null,client/Client,list/Params,show=1)
			..(loc,Client,Params,show)

			var/mob/Player/p = Client.mob

			if(p.z == 22)
				name = "Fly Down"
				icon_state = "fly down"

		Click()
			set waitfor = 0

			var/mob/Player/p = client.mob

			if(p.nomove) return

			var/area/a = p.loc.loc

			if(p.z == 22)
				if(!istype(p.loc, /turf/sky))
					p << errormsg("You can't dive down into the ground.")
					return
			else if(!a || !(istype(a, /area/outside) || istype(a, /area/newareas/outside)))
				p << errormsg("You need to be outside.")
				return

			var/flyup = name == "Fly Up"

			if(flyup)
				name = "Fly Down"
				icon_state = "fly down"

				animate(p, pixel_z = 448, time = 20)
				animate(pixel_z = 0, time = 0)

				var/turf/dest = p.findSkyTile()

				p.nomove = 2
				sleep(20)
				p.nomove = 0

				var/d = p.dir
				p.Move(dest)
				p.dir = d

			else
				name = "Fly Up"
				icon_state = "fly up"

				animate(p, pixel_z = 448, time = 0)
				animate(pixel_z = 0, time = 20)

				var/turf/dest = p.findGroundTile()

				var/d = p.dir
				p.Move(dest)
				p.dir = d

				p.nomove = 2
				sleep(20)
				p.nomove = 0


	WandPower
		name       = "Wand"
		anchor_x   = "WEST"
		screen_x   = 188
		screen_y   = -48
		anchor_y   = "NORTH"

		maptext_x = 32
		maptext_y = 8

		mouse_opacity = 2

		MouseEntered()
			transform *= 1.25
		MouseExited()
			transform = null

		Click()
			if(alpha == 0) return
			var/mob/Player/p = usr

			if(p.wandLock)
				p.wandLock = 0
				p << infomsg("Unlocked wand power.")
			else
				p.wandLock = 1
				p << infomsg("Locked wand power.")
			setCharge(p.wandCharge)

		proc/setCharge(var/n)
			var/mob/Player/p = client.mob

			var/c = p.wandLock ? "#c00" : p.mapTextColor

			maptext = {"<span style=\"color:[c];font-size:2px;\"><b>[n]%</b></span>"}

		New(loc=null,client/Client,list/Params,show=1)
			..(loc,Client,Params,show)

			var/mob/Player/p = Client.mob
			icon = p.wand.icon
			icon_state = p.wand.icon_state

			var/c = p.wandLock ? "#c00" : p.mapTextColor

			maptext = {"<span style=\"color:[c];font-size:2px;\"><b>0%</b></span>"}


	Animagus
		name       = "Animagus"
		icon_state = "lvlup"
		anchor_x   = "WEST"
		screen_x   = 18
		screen_y   = -48
		anchor_y   = "NORTH"

		maptext_x = 32
		maptext_y = 8

		mouse_opacity = 2

		MouseEntered()
			transform *= 1.25
		MouseExited()
			transform = null

		Click()
			if(alpha == 0) return
			var/mob/Player/p = usr

			if(!p.animagusOn)
				if(p.animagusPower < 5) return
				if(istype(p.loc.loc, /area/arenas)) return

				var/obj/items/wearable/brooms/b = locate() in p.Lwearing
				if(b)
					b.Equip(p, 1)

				color = "#0c0"
				p.AnimagusTick(src)

				p.overlays = null
				if(p.away) p.ApplyAFKOverlay()

				if(p.animagusState == "Crocodile")
					p.icon    = 'Transfiguration_64x64.dmi'
					var/matrix/m = matrix()
					m.Translate(-16,-16)
					p.transform = m
				else
					p.icon    = 'Transfiguration.dmi'
				p.icon_state = p.animagusState

				flick("transfigure", p)
			else
				if(p.noOverlays > 0 && (p.tickers & ANIMAGUS_TICK))
					p.noOverlays--
				color = null
				p.AnimagusRecover(src)
				p.BaseIcon()
				flick("transfigure", p)
				p.ApplyOverlays()

		New(loc=null,client/Client,list/Params,show=1)
			..(loc,Client,Params,show)

			var/mob/Player/p = Client.mob
			icon_state = p.animagusState

			if(!p.animagusOn)
				p.AnimagusRecover(src)

area/hogwarts/Animagus
	antiFly = 1
	antiTeleport = 1

obj/animagus

	pixel_y = 16

	Crossed(atom/movable/O)
		if(isplayer(O))
			var/mob/Player/p = O
			if(p.animagusState == name) return

			var/StatusEffect/Potions/Animagus/a = locate() in p.LStatusEffects
			if(a)
				p.animagusState = name
				if(!p.Animagus) p.Animagus = new("Animagus")

				p << infomsg("You unlocked [name] animagus.")
				p.animagusPower = 100

				var/hudobj/Animagus/hud = locate() in p.client.screen
				if(hud)
					hud.icon_state = name
				else
					new /hudobj/Animagus(null, p.client, null, show=1)