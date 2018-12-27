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
		tmp/animagusOn = 0
		tmp/animagusPower = 0

	Bump(atom/movable/O)
		..()
		if(animagusOn && ismonster(O))
			if(world.time - lastproj < 2) return
			lastproj = world.time

			var/mob/Enemies/e = O

			var/dmg = round(rand(10) + (Dmg + Slayer.level) * (1 + Animagus.level/100), 1)

			if(passives & SWORD_SLAYER)
				dmg *= 1.1

			if(e.canBleed)
				var/n = dir2angle(get_dir(O, src))
				emit(loc    = e,
					 ptype  = /obj/particle/fluid/blood,
				     amount = 4,
				     angle  = new /Random(n - 25, n + 25),
				     speed  = 2,
				     life   = new /Random(15,25))

			src << "You do [dmg] damage to [e.name]."

			e.HP -= dmg

			var/tmp_ekills = ekills
			e.Death_Check(src)
			if(ekills > tmp_ekills)
				var/exp2give = (rand(6,14)/10)*e.Expg

				if(level > e.level && !findStatusEffect(/StatusEffect/Lamps/Farming))
					exp2give -= exp2give * ((level-e.level)/150)

					if(exp2give <= 0) return

				if(House == worldData.housecupwinner)
					exp2give *= 1.25

				var/StatusEffect/Lamps/Exp/exp_rate = findStatusEffect(/StatusEffect/Lamps/Exp)

				if(exp_rate) exp2give *= exp_rate.rate

				Animagus.add(exp2give, src, 1)

	proc
		AnimagusTick(hudobj/Animagus/a)
			set waitfor = 0

			if(animagusOn) return
			animagusOn = 1

			while(animagusOn)
				a.maptext = {"<span style=\"color:[mapTextColor];font-size:2px;\"><b>[--animagusPower]%</b></span>"}
				sleep(10 + Animagus.level)

				if(animagusPower <= 0)
					a.color = null
					flick("transfigure", src)
					BaseIcon()
					ApplyOverlays()
					AnimagusRecover(a)
					break

		AnimagusRecover(hudobj/Animagus/a, fromStart=0)
			set waitfor = 0

			if(!fromStart)
				if(!animagusOn) return
				animagusOn = 0

			while(!animagusOn && animagusPower < 100 + Animagus.level)
				a.maptext = {"<span style=\"color:[mapTextColor];font-size:2px;\"><b>[++animagusPower]%</b></span>"}
				sleep(50)

hudobj

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
				color = "#0c0"
				p.AnimagusTick(src)

				p.overlays = null
				if(p.away) p.ApplyAFKOverlay()

				flick("transfigure", p)

				p.icon       = 'Transfiguration.dmi'
				p.icon_state = p.animagusState
			else
				color = null
				flick("transfigure", p)
				p.AnimagusRecover(src)
				p.BaseIcon()
				p.ApplyOverlays()

		New(loc=null,client/Client,list/Params,show=1)
			..(loc,Client,Params,show)

			var/mob/Player/p = Client.mob
			icon_state = p.animagusState
			p.AnimagusRecover(src, 1)

area/hogwarts/Animagus

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
				a.Deactivate()

				p << infomsg("You unlocked [name] animagus.")

				var/hudobj/Animagus/hud = locate() in p.client.screen
				if(hud)
					hud.icon_state = name
				else
					new /hudobj/Animagus(null, p.client, null, show=1)