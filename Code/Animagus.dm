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
			if(animagusOn)
				if(world.time - lastproj < 2) return
				lastproj = world.time

				var/mob/Enemies/e = O

				var/dmg = round(rand(10) + (Dmg + clothDmg + Slayer.level) * (1.25 + Animagus.level/100), 1)

				dmg *= 1 + monsterDmg/100

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

				if(MonsterMessages)
					src << "You do [dmg] damage to [e.name]."

				var/exp2give = e.onDamage(dmg, src)
				if(exp2give > 1)
					Animagus.add(exp2give, src, 1)
			else if(RING_DISPLACEMENT in passives)
				var/tmpLoc = O.loc
				O.density = 0
				O.Move(loc)
				Move(tmpLoc)
				O.density = 1
	proc
		AnimagusTick(hudobj/Animagus/a)
			set waitfor = 0

			animagusOn = 1

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

			animagusOn = 0

			if((tickers & ANIMAGUS_RECOVER) > 0) return
			tickers |= ANIMAGUS_RECOVER

			while(!animagusOn && animagusPower < 100 + Animagus.level)
				a.maptext = {"<span style=\"color:[mapTextColor];font-size:2px;\"><b>[++animagusPower]%</b></span>"}
				sleep(50)

			tickers &= ~ANIMAGUS_RECOVER
hudobj

	WandPower
		name       = "Wand"
		icon_state = "lvlup"
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

		proc/setCharge(var/n)
			var/mob/Player/p = client.mob
			maptext = {"<span style=\"color:[p.mapTextColor];font-size:2px;\"><b>[n]%</b></span>"}

		New(loc=null,client/Client,list/Params,show=1)
			..(loc,Client,Params,show)

			var/mob/Player/p = Client.mob
			icon = p.wand.icon
			icon_state = p.wand.icon_state

			maptext = {"<span style=\"color:[p.mapTextColor];font-size:2px;\"><b>0%</b></span>"}

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