/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

WorldData/var/tmp/list/sandboxZ

proc
	InitSandbox(attempts=3)
		set waitfor = 0

		Loadbuildable("custom_buildable")
		Loadbuildable("custom_buildable2")

		if(!worldData.sandboxZ)
			spawnFarmable()

	Loadbuildable(name, attempts=3)
		set waitfor = 0

		var/swapmap/map = SwapMaps_Load(name)
		if(!map)
			if(attempts > 0)
				spawn(10)
					lagstopsleep()
					Loadbuildable(name, attempts-1)
			return

		if(!worldData.sandboxZ)
			worldData.sandboxZ = list()
		worldData.sandboxZ += map.z1
		map.used = 1

	spawnFarmable()
		set waitfor = 0
		sleep(100)
		for(var/i = 1 to 50)
			var/x = rand(10, 90)
			var/y = rand(10, 90)
			var/z = pick(worldData.sandboxZ)

			var/turf/t = locate(x, y, z)

			#if WINTER
			if(t.icon_state == "snow" && !t.flyblock)
			#else
			if(t.icon_state == "grass1" && !t.flyblock)
			#endif
				new /obj/farm/tree (t)

			lagstopsleep()

		for(var/i = 1 to 16)
			var/x = rand(10, 90)
			var/y = rand(10, 90)
			var/z = pick(worldData.sandboxZ)

			var/turf/t = locate(x, y, z)

			#if WINTER
			if(t.icon_state == "snow" && !t.flyblock)
			#else
			if(t.icon_state == "grass1" && !t.flyblock)
			#endif
				new /obj/farm/rocks (t)

			lagstopsleep()

obj
	farm
		appearance_flags = PIXEL_SCALE|TILE_BOUND
		canSave = 0

		var
			hp    = 25000
			maxhp = 25000
			amount = 16
			obj/healthbar/hpbar

		proc
			respawn()
				set waitfor = 0

				sleep(600)
				density    = 1
				pixel_x = initial(pixel_x)
				pixel_y = initial(pixel_y)
				layer   = initial(layer)
				transform = null
				amount = initial(amount)

				hp = maxhp

				for(var/i = 1 to 10)
					var/x = rand(10, 90)
					var/y = rand(10, 90)
					var/z = pick(worldData.sandboxZ)

					var/turf/t = locate(x, y, z)

					#if WINTER
					if(t.icon_state == "snow" && !t.flyblock)
					#else
					if(t.icon_state == "grass1" && !t.flyblock)
					#endif
						loc = t
						hpbar.loc = t
						hpbar.Set(1, instant=1)
						hpbar.alpha = 0
						animate(src, alpha = 255, time = 10)
						break
				if(!loc)
					spawn() respawn()

			drops(stack)
			dead()

		Attacked(obj/projectile/p)
			set waitfor = 0
			if(!density) return

			hp -= p.damage
			hp = max(0, hp)

			var/perc = clamp(hp / maxhp, 0, 1)

			if(!hpbar)
				hpbar = new(src)
				hpbar.alpha = 0

			var/s = round((maxhp - hp) / (maxhp / amount))
			if(s >= 1)
				amount -= s

				if(isplayer(p.owner))
					var/mob/Player/player = p.owner
					if(player.Gathering.level >= 1)
						var/r = rand(1, player.Gathering.level)
						if(prob(player.Gathering.level + player.Gathering.level - r))
							s += r

					player.Gathering.add(s*20, player)

				drops(p, s)

			if(hp <= 0)
				dead(p)
				loc = null
				respawn()

			else
				hpbar.Set(perc)
				animate(src, pixel_x = pixel_x-1, time = 1)
				animate(pixel_x = pixel_x+1, time = 2)
				animate(pixel_x = pixel_x, time = 1)

		rocks
			name       = "Rocks"
			icon       = 'Moss_Rocks.dmi'
			icon_state = "1"
			density    = 1

			hp    = 40000
			maxhp = 40000
			amount = 6

			respawn()
				set waitfor = 0
				icon_state = "1"
				..()

			drops(obj/projectile/p, s)

				if(amount <= 3)
					icon_state = "3"
				else if(amount <= 6)
					icon_state = "2"

				var/px = rand(-1,1)
				var/py = rand(-1,1)
				if(px == 0 && py == 0) py = -1
				var/obj/items/stones/w = new(locate(x + px, y + py, z))
				w.stack = s
				w.UpdateDisplay()
				w.pixel_y = -py*32
				w.pixel_x = -px*32
				w.transform = turn(matrix(), 90 * pick(1, -1))
				animate(w, pixel_x = 0, pixel_y = 0, transform = null, time = 10)

			dead(obj/projectile/p)
				var/obj/items/stones/w = new(loc)
				w.stack = amount + rand(2,4)
				w.UpdateDisplay()

				var/matrix/m = matrix()*2
				animate(src, transform = m, alpha=0, time = 5)
				animate(hpbar, alpha = 0, time = 5)

				density = 0

				if(p.owner && isplayer(p.owner))
					p.owner:checkQuestProgress("Smash Rock")

				sleep(6)
				hpbar.loc = null

		tree
			name       = "Tree"
			icon       = 'BigTree.dmi'
			density    = 1
			pixel_x    = -64
			pixel_y    = 0
			layer      = 5

			New()
				icon_state = "stump[rand(2,3)]_winter"

				..()

			drops(obj/projectile/p, s)
				var/px = rand(-2,2)
				var/py = rand(-2,0)
				if(px == 0 && py == 0) py = -1
				var/obj/items/wood_log/w = new(locate(x + px, y + py, z))
				w.stack = s
				w.UpdateDisplay()
				w.pixel_y = 64 - py*32
				w.pixel_x = -px*32
				w.transform = turn(matrix(), 90 * pick(1, -1))
				w.layer = 6
				animate(w, pixel_x = 0, pixel_y = 0, transform = null, time = 20, easing = BOUNCE_EASING)
				animate(layer = 3, time = 0)

			dead(obj/projectile/p)
				layer = 2
				var/obj/items/wood_log/w = new(loc)
				w.stack = amount + rand(2,6)
				w.UpdateDisplay()
				w.pixel_y = 64
				w.transform = turn(matrix(), 90 * pick(1, -1))
				animate(w, pixel_y = 0, transform = null, time = 20, easing = BOUNCE_EASING)

				var/matrix/m = transform
				if(prob(50))
					m.Turn(-90)
					animate(src, pixel_x = -128, pixel_y = -64, transform = m, time = 50, easing = BOUNCE_EASING)
				else
					m.Turn(90)
					animate(src, pixel_x = 0, pixel_y = -64, transform = m, time = 50, easing = BOUNCE_EASING)
				density = 0

				if(p.owner && isplayer(p.owner))
					p.owner:checkQuestProgress("Chop Tree")

				animate(hpbar, alpha = 0, time = 5)
				sleep(6)
				hpbar.loc = null
				sleep(100)
				animate(src, alpha = 0, time = 10)
				sleep(11)



obj/items
	wood_log
		icon = 'Wood Log.dmi'
		icon_state = "log1"
	stones
		icon = 'Moss_Rocks.dmi'
		icon_state = "small"


	wearable/blueprint
		icon = 'blueprint.dmi'
		showoverlay = FALSE
		dropable = 0

		var/buildType

		basic_blueprint
			buildType = /hudobj/build/basic

		portkey_blueprint
			buildType = /hudobj/build/portkey

		house_blueprint
			buildType = /hudobj/build/house

		book_blueprint
			buildType = /hudobj/build/book

		stone_blueprint
			buildType = /hudobj/build/stone

		Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
			if(!overridetext && !forceremove && !(src in owner.Lwearing) && !istype(owner.loc, /turf/buildable))
				owner << errormsg("You can't use this here.")
				return
			. = ..(owner)
			if(forceremove) return
			if(. == WORN)
				src.gender = owner.gender
				if(!overridetext)viewers(owner) << infomsg("[owner] looks at \his [src.name].")
				for(var/obj/items/wearable/blueprint/W in owner.Lwearing)
					if(W != src)
						W.Equip(owner,1,0)

				for(var/t in (typesof(buildType)-buildType+typesof(/hudobj/build/shared)-/hudobj/build/shared))
					var/obj/o = new t (null, owner.client, null, 1)
					o.maptext = {"<span style=\"color:[owner.mapTextColor]\">[o.maptext]</span>"}

			else if(. == REMOVED)
				if(!overridetext)viewers(owner) << infomsg("[owner] puts away \his [src.name].")

				for(var/hudobj/build/b in owner.client.screen)
					owner.client.screen -= b

				if(owner.buildItemDisplay)
					owner.buildItemDisplay.loc.mouse_opacity = 1
					owner.buildItemDisplay.loc = null
					owner.buildItemDisplay = null

turf/buildable
	icon = 'turf.dmi'

	#if WINTER
	name       = "snow"
	icon_state = "snow"
	#else
	name       = "grass"
	icon_state = "grass1"
	#endif

	Exited(atom/movable/Obj, atom/newloc)
		..()

		if(isplayer(Obj) && !istype(newloc, /turf/buildable))
			var/obj/items/wearable/blueprint/W = locate() in Obj:Lwearing
			if(W)
				W.Equip(Obj,1)


	MouseEntered()
		var/mob/Player/p = usr
		if(p.buildItemDisplay)
			if(z == p.z && get_dist(src, p) < 30)
				p.buildItemDisplay.loc = src

				if(p.buildItem.reqWall)
					var/turf/t = locate(x,y+1,z)
					if(!t || !t.flyblock)
						p.buildItemDisplay.color = "#f00"
						return

				var/found = 0
				for(var/obj/buildable/shield_totem/c in range(10, src))
					if(!c.allowed) continue
					if(usr.ckey in c.allowed) continue
					found = 1
					break

				if(!found)
					p.buildItemDisplay.loc = src
					p.buildItemDisplay.color = "#0f0"
				else
					p.buildItemDisplay.color = "#f00"
			else
				p.buildItemDisplay.loc = null

	Click()
		var/mob/Player/p = usr
		if(p.buildItemDisplay && z == p.z && get_dist(src, p) < 30)

			for(var/obj/buildable/shield_totem/c in range(10, src))
				if(!c.allowed) continue
				if(usr.ckey in c.allowed) continue
				return

			if(p.buildItem.path && (flyblock || (locate(p.buildItem.path) in src)))
				if(!p.buildItem.replace || !(locate(p.buildItem.replace) in src))
					return

			if(islist(p.buildItem.price))
				var/list/items = list()
				for(var/t in p.buildItem.price)
					var/obj/items/i = locate(t) in p

					if(!i || i.stack < p.buildItem.price[t])
						p << errormsg("You don't have enough resources.")
						return

					items += i

				for(var/obj/items/i in items)
					i.Consume(p.buildItem.price[i.type])

			else if(p.buildItem.price > 0)
				var/obj/items/wood_log/w = locate() in p

				if(!w || w.stack < p.buildItem.price)
					p << errormsg("You don't have enough resources.")
					return

				w.Consume(p.buildItem.price)

			if(p.buildItem.path)

				if(p.buildItem.replace)
					var/obj/o = locate(p.buildItem.replace) in src
					if(o) o.Dispose()

				Clear(p.buildItem.clear)
				var/obj/buildable/wall/o = new p.buildItem.path(src)

				if(istype(o, /obj/buildable/wall))
					o.hp = 10000
					if(!o.hpbar)
						o.hpbar = new(o)
					o.hpbar.Set(o.hp / o.maxhp, instant=1)

					spawn(2)
						for(var/obj/buildable/wall/w in orange(1, src))
							w.updateState()

			else if(p.buildItem.name == "clear")
				Clear()
			else
				name = p.buildItem.name
				if(p.buildItem.icon_state == "wood")
					icon_state = "wood[rand(1,8)]"
				else
					icon_state = p.buildItem.icon_state
				color = initial(p.buildItem.color)

		else
			..()

	proc
		Clear(clear)
			for(var/obj/o in src)
				if(!o.canSave) continue
				if(istype(o, /obj/items)) continue
				if(istype(o, /obj/buildable)) continue

				if(clear)
					if(istype(o, clear))
						o.Dispose()
				else
					o.Dispose()

/*	post_init = 1  // in case GMs use delete on walls
	MapInit()
		set waitfor = 0
		sleep(1)

		if(flyblock)
			var/obj/o = locate() in src
			if(!o || !o.density)
				flyblock = 0*/

mob/Player/var/tmp
	hudobj/build/buildItem
	obj/buildItemDisplay

obj/buildable
	var
		tmp
			obj/healthbar/hpbar
			regen = 0

		hp    = 50000
		maxhp = 50000

		onFire = 0
		rate = 5000

		canHeal = 0

		block = 0

	density = 1

	New()
		set waitfor = 0
		sleep(1)
		if(density && opacity || block)
			var/turf/t = loc
			t.flyblock = 2

		if(!hpbar)
			var/perc = clamp(hp / maxhp, 0, 1)
			if(perc < 1)
				hpbar = new(src)
				hpbar.Set(perc)

		if(canHeal && hp < maxhp)
			regen()
		..()

	Dispose()
		if(opacity || block)
			var/turf/t = loc
			t.flyblock = 0

		if(hpbar)
			hpbar.loc = null
			hpbar = null
		..()

	MouseEntered()
		var/mob/Player/p = usr
		if(p.buildItemDisplay)
			if(z == p.z && get_dist(loc, p) < 30)

				if(!p.buildItem.replace || !istype(src, p.buildItem.replace)) return

				p.buildItemDisplay.loc = loc

				var/found = 0
				for(var/obj/buildable/shield_totem/c in range(10, loc))
					if(!c.allowed) continue
					if(usr.ckey in c.allowed) continue
					found = 1
					break

				if(!found)
					p.buildItemDisplay.loc = loc
					p.buildItemDisplay.color = "#0f0"
				else
					p.buildItemDisplay.color = "#f00"
			else
				p.buildItemDisplay.loc = null

	Attacked(obj/projectile/p)
		set waitfor = 0
		if(!density) return

		if(p.element == EARTH)
			hp += p.damage
			if(hp > maxhp)
				hp = maxhp
		else
			hp -= p.damage

		var/perc = clamp(hp / maxhp, 0, 1)

		if(!hpbar)
			hpbar = new(src)
			hpbar.alpha = 0

		hpbar.Set(perc)

		if(perc >= 1 && hpbar.alpha == 255)
			animate(hpbar, alpha = 0, time = 5)

		else if(hp <= 0)
			density = 0
			animate(hpbar, alpha = 0, time = 5)
			animate(src, alpha = 0, transform = matrix()*2, time = 5)
			sleep(6)
			Dispose()
		else
			animate(src, pixel_x = pixel_x-1, time = 1)
			animate(pixel_x = pixel_x+1, time = 2)
			animate(pixel_x = pixel_x, time = 1)

		if(canHeal)
			if(!regen && hp > 0 && hp < maxhp)
				regen()
			else if(!onFire && hp / maxhp < 0.3)
				onFire = 1

				var/px = rand(-6,6) * 2
				var/py = rand(-4,4) * 2
				var/obj/o = new /obj/custom { icon = 'attacks.dmi'; icon_state = "flame" }

				for(var/i = -1 to 1 step 2)
					o.pixel_x = px * i
					o.pixel_y = py * i
					overlays += o

	proc
		regen()
			set waitfor = 0
			if(regen) return
			regen = 1
			sleep(50)
			while(hp > 0 && hp < maxhp)
				hp += rate
				if(hp >= maxhp)
					hp = maxhp
					animate(hpbar, transform = null, alpha = 0, time = 5)
				else
					var/perc = clamp(hp / maxhp, 0, 1)
					hpbar.Set(perc)

				if(onFire && hp / maxhp > 0.35)
					overlays = list()
					onFire = 0

				sleep(50)

			if(hp >= maxhp)
				hpbar.loc = null
				hpbar = null
				hp = maxhp
			regen = 0


	wall
		canHeal = 1
		hp    = 60000
		maxhp = 60000
		rate = 10000

		opacity = 1

		wood
			icon = 'wood_wall.dmi'
			icon_state = "10"

		stone
			icon = 'stone.dmi'
			icon_state = "10"
			hp    = 120000
			maxhp = 120000
			rate = 20000

		fence
			opacity = 0
			icon = 'fence.dmi'
			icon_state = "10"
			hp    = 30000
			maxhp = 30000
			rate = 3000
			block = 1

		New()
			set waitfor = 0
			..()
			sleep(2)

			updateState()

		proc
			updateState()
				var/turf/t = loc
				var/n = t.autojoin1("flyblock", 2)
				icon_state = "[n]"

		Dispose()
			var/turf/t = loc
			..()
			for(var/obj/buildable/wall/w in orange(1, t))
				w.updateState()


	door
		canHeal = 1
		hp    = 50000
		maxhp = 50000
		rate = 9000

		wood
			icon='Door.dmi'
			icon_state="closed"
		gate
			icon='gate.dmi'
			icon_state="closed"
			hp    = 100000
			maxhp = 100000
			rate = 19000

		opacity=1

		var/door = 1

		proc/Bumped(mob/Player/p)

			for(var/obj/buildable/shield_totem/c in range(10, src))
				if(!c.allowed) continue
				if(usr.ckey in c.allowed) continue
				return

			if(icon_state != "open")
				flick("opening", src)
				opacity = 0
				sleep(4)
				icon_state="open"
				density=0
				sleep(50)
				while(locate(/mob) in loc) sleep(10)
				flick("closing", src)
				density=1
				sleep(4)
				opacity = initial(opacity)
				icon_state="closed"

		Dispose()
			var/turf/t = loc
			..()
			for(var/obj/buildable/wall/w in orange(1, t))
				w.updateState()

		New()
			set waitfor = 0
			..()
			sleep(2)
			density    = 1
			icon_state = "closed"
			opacity    = 1

	shield_totem
		var/list/allowed

		mouse_over_pointer = MOUSE_HAND_POINTER
		icon = 'Totem.dmi'
		icon_state = "Shield"

		Click()
			if(src in range(1))
				if(!IsInputOpen(usr, "BuildProtection"))
					var/Input/popup = new (usr, "BuildProtection")
					var/response = popup.Alert(usr, "Add yourself or clean the access list?", "Build Protection", "Add", "Clean")
					del popup
					if(response == "Add")
						if(!allowed)
							allowed = list()
						else if(usr.ckey in allowed)
							return

						allowed += usr.ckey
						usr << infomsg("You were added to the build list.")
					else
						allowed = null
						usr << infomsg("You cleaned the build list.")


			else
				..()
	Bed
		icon       = 'turf.dmi'
		icon_state = "Bed"

		Click()
			if(src in range(1))
				if(tag == "respawn_" + usr.ckey)
					usr << errormsg("You will no longer respawn here.")
				else
					var/obj/o = locate("respawn_" + usr.ckey)
					if(o)
						o.tag = null
						usr << errormsg("Your previous bed is replaced by this one.")

					tag = "respawn_" + usr.ckey
					usr << infomsg("You can now respawn here. Click \"Respawn at bed\" on death screen.")
			else
				..()

obj/preview

	Click()
		var/turf/t = loc
		t.Click()

hudobj
	respawn
		anchor_x    = "CENTER"
		anchor_y    = "CENTER"
		screen_y    = 64

		maptext        = "<center><span style=\"color:#e50000;\">Respawn at bed</span></center>"
		maptext_height = 128
		alpha          = 0

		mouse_opacity  = 2

		Click()
			var/mob/Player/p = usr
			var/turf/d = locate("respawn_" + p.ckey)
			if(d)
				p.Transfer(d)

			hide()
	build
		anchor_x    = "WEST"
		anchor_y    = "CENTER"

		maptext_y = 8
		maptext_x = 34
		maptext_width = 256

		mouse_opacity  = 2

		var
			path
			price = 0
			reqWall = 0
			clear
			replace

		MouseEntered()
			transform *= 1.25
			layer++
		MouseExited()
			transform = null
			layer = initial(layer)

		Click()
			var/mob/Player/M = usr

			if(M.buildItemDisplay)
				M.buildItemDisplay.loc = null
				M.buildItem.color = initial(M.buildItem.color)

				if(M.buildItem == src)
					M.buildItem = null
					M.buildItemDisplay = null
					return


			var/obj/preview/o = new
			o.appearance = appearance
			o.color = "#0f0"
			o.mouse_opacity = 2
			o.maptext = null
			o.canSave = 0
			o.mouse_over_pointer = 0
			o.transform = null
			if(reqWall)
				o.pixel_y += 32

			M.buildItem = src
			M.buildItemDisplay = o
			color = "#0f0"

		shared
			guide
				maptext = "Click on the item you'd like to create then click to place where the green highlighted preview is."
				maptext_width  = 256
				maptext_height = 64
				screen_x       = 32
				screen_y       = -32

				Click()

			clear
				icon = 'HUD.DMI'
				icon_state = "x"
				maptext = "Clear Decoration/Portkeys"

				screen_x = 32
				screen_y = 32

			#if WINTER
			snow
				icon_state = "snow"
				maptext = "Snow: free"
			#else
			grass
				icon_state = "grass1"
				maptext = "Grass: free"
			#endif
				icon = 'turf.dmi'

				screen_x = 32
				screen_y = 256
		basic
			chairleft
				icon       = 'desk.dmi'
				icon_state = "cleft"

				price = 2
				path = /obj/chairleft

				screen_x = 32
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			chairright
				icon       = 'desk.dmi'
				icon_state = "cright"

				price = 2
				path = /obj/chairright

				screen_x = 64
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			chairback
				icon       = 'desk.dmi'
				icon_state = "cback"
				layer      = MOB_LAYER +1

				price = 2
				path = /obj/chairback

				screen_x = 96
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			chairfront
				icon       ='desk.dmi'
				icon_state = "cfront"

				price = 2
				path = /obj/chairfront

				screen_x = 128
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			WTable
				icon       ='stage.dmi'
				icon_state = "w"

				price = 2
				path = /obj/WTable

				screen_x = 160
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			Torch
				icon       ='misc.dmi'
				icon_state = "torch"

				price = 2
				path = /obj/Torch_

				screen_x = 192
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			wall_torch
				icon       ='turf.dmi'
				icon_state = "walltorch"

				price = 2
				maptext = "Decoration: 2 wooden logs"
				path = /obj/static_obj/walltorch { post_init = 0; pixel_y = 32 }
				reqWall = 1
				mouse_opacity = 2

				screen_x = 232
				screen_y = 64

			Bed
				icon       = 'turf.dmi'
				icon_state = "Bed"

				price = 20
				maptext = "Bed: 20 wooden logs"
				path = /obj/buildable/Bed

				screen_x = 32
				screen_y = 96

			shield_totem
				icon = 'Totem.dmi'
				icon_state = "Shield"

				price = 100
				maptext = "Shield Totem: 100 wooden logs"

				screen_x = 32
				screen_y = 128

				path = /obj/buildable/shield_totem

			door
				icon='Door.dmi'
				icon_state="closed"

				price = 30
				maptext = "Door: 30 wooden logs"

				screen_x = 32
				screen_y = 160

				path = /obj/buildable/door/wood

			wood_wall
				icon = 'wood_wall.dmi'
				icon_state = "10"

				price = 20
				maptext = "Wood Wall: 20 wooden logs"

				screen_x = 32
				screen_y = 192

				path = /obj/buildable/wall/wood
				replace = /obj/buildable/wall/fence

			woodenfloor
				icon       = 'turf.dmi'
				icon_state = "wood"
				color      = "#704f32"

				price = 2
				maptext = "Wood Floor: 2 wooden logs"

				screen_x = 32
				screen_y = 224

		stone
			black_throne
				icon       = 'Thrones.dmi'
				icon_state = "black"

				price = list(/obj/items/stones = 15)
				path = /obj/bigblackchair

				screen_x = 32
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			white_throne
				icon       = 'Thrones.dmi'
				icon_state = "white"

				price = list(/obj/items/stones = 15)
				path = /obj/bigwhitechair

				screen_x = 64
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			purple_throne
				icon       = 'Thrones.dmi'
				icon_state = "purple"

				price = list(/obj/items/stones = 15)
				path = /obj/bigpurplechair

				screen_x = 96
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			teal_throne
				icon       = 'Thrones.dmi'
				icon_state = "teal"

				maptext = "Thrones: 15 stones"
				price = list(/obj/items/stones = 15)
				path = /obj/bigtealchair

				screen_x = 128
				screen_y = 64

			Angel
				icon       = 'statues_64x64.dmi'
				icon_state = "angel"

				price = list(/obj/items/stones = 20)
				path = /obj/static_obj/Angel { post_init = 0; }

				screen_x = 32
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

			Gargoyleleft
				icon       = 'statues_64x64.dmi'
				icon_state = "grag left"

				price = list(/obj/items/stones = 20)
				path = /obj/static_obj/Gargoyleleft { post_init = 0; }

				screen_x = 64
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

			Gargoyleright
				icon       = 'statues_64x64.dmi'
				icon_state = "grag right"

				price = list(/obj/items/stones = 20)
				path = /obj/static_obj/Gargoyleright { post_init = 0; }

				screen_x = 96
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

			Armor
				icon       = 'statues_64x64.dmi'
				icon_state = "armor"

				maptext = "Statues: 20 stones"
				price = list(/obj/items/stones = 20)
				path = /obj/static_obj/Armor { post_init = 0; }

				screen_x = 128
				screen_y = 96

			door
				icon = 'gate.dmi'
				icon_state = "closed"

				price = list(/obj/items/stones = 30)
				maptext = "Gate: 30 stones"

				screen_x = 32
				screen_y = 160

				path = /obj/buildable/door/gate
				replace = /obj/buildable/door/wood

			stone_wall
				icon = 'stone.dmi'
				icon_state = "10"

				price = list(/obj/items/stones = 20)
				maptext = "Stone Wall: 20 stones"

				screen_x = 32
				screen_y = 192

				path = /obj/buildable/wall/stone
				replace = /obj/buildable/wall/wood

			road
				icon       = 'turf.dmi'
				icon_state = "stonefloor2"

				price = list(/obj/items/stones = 2)
				maptext = "Road: 2 stones"

				screen_x = 32
				screen_y = 224
		house
			red
				icon       = 'turf.dmi'
				icon_state = "wood"
				color      = "#990000"

				price = 3

				screen_x = 32
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			green
				icon       = 'turf.dmi'
				icon_state = "wood"
				color      = "#009900"

				price = 3

				screen_x = 64
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			yellow
				icon       = 'turf.dmi'
				icon_state = "wood"
				color      = "#d5d500"

				price = 3

				screen_x = 96
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			blue
				icon       = 'turf.dmi'
				icon_state = "wood"
				color      = "#0d74db"

				maptext = "Wood floors: 3 wooden logs"
				price = 3

				screen_x = 128
				screen_y = 64

			gryffindor
				icon       = 'shields.dmi'
				icon_state = "gryffindor"

				price = 2
				path = /obj/static_obj/gryffindor { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1

				screen_x = 32
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

			slytherin
				icon       = 'shields.dmi'
				icon_state = "slytherin"

				price = 2
				path = /obj/static_obj/slytherin { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1

				screen_x = 64
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

			hufflepuff
				icon       = 'shields.dmi'
				icon_state = "hufflepuff"

				price = 2
				path = /obj/static_obj/hufflepuff { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1

				screen_x = 96
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

			ravenclaw
				icon       = 'shields.dmi'
				icon_state = "ravenclaw"

				maptext = "Shields: 2 wooden logs"
				price = 2
				path = /obj/static_obj/ravenclaw { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1

				screen_x = 128
				screen_y = 96

			gryffindor_banner
				icon       = 'shields.dmi'
				icon_state = "gryffindorbanner"

				price = 2
				path = /obj/static_obj/gryffindorbanner { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1

				screen_x = 32
				screen_y = 128

				maptext_x = 0
				maptext_width = 32

			slytherin_banner
				icon       = 'shields.dmi'
				icon_state = "slytherinbanner"

				price = 2
				path = /obj/static_obj/slytherinbanner { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1

				screen_x = 64
				screen_y = 128

				maptext_x = 0
				maptext_width = 32

			hufflepuff_banner
				icon       = 'shields.dmi'
				icon_state = "hufflepuffbanner"

				price = 2
				path = /obj/static_obj/hufflepuffbanner { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1

				screen_x = 96
				screen_y = 128

				maptext_x = 0
				maptext_width = 32

			ravenclaw_banner
				icon       = 'shields.dmi'
				icon_state = "ravenclawbanner"

				maptext = "Banners: 2 wooden logs"
				price = 2
				path = /obj/static_obj/ravenclawbanner { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1

				screen_x = 128
				screen_y = 128

			red_throne
				icon       = 'Thrones.dmi'
				icon_state = "red"

				price = list(/obj/items/stones = 15)
				path = /obj/bigredchair

				screen_x = 32
				screen_y = 160

				maptext_x = 0
				maptext_width = 32

			green_throne
				icon       = 'Thrones.dmi'
				icon_state = "green"

				price = list(/obj/items/stones = 15)
				path = /obj/biggreenchair

				screen_x = 64
				screen_y = 160

				maptext_x = 0
				maptext_width = 32

			yellow_throne
				icon       = 'Thrones.dmi'
				icon_state = "yellow"

				price = list(/obj/items/stones = 15)
				path = /obj/bigyellowchair

				screen_x = 96
				screen_y = 160

				maptext_x = 0
				maptext_width = 32

			blue_throne
				icon       = 'Thrones.dmi'
				icon_state = "blue"

				maptext = "Thrones: 15 stones"
				price = list(/obj/items/stones = 15)
				path = /obj/bigbluechair

				screen_x = 128
				screen_y = 160

			hogwarts_shield
				icon = 'shields.dmi'
				icon_state = "hogwartsshield"

				price = 3
				path = /obj/static_obj/hogwartshield { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1

				screen_x = 32
				screen_y = 192

				maptext_x = 0
				maptext_width = 32

			hogwarts_banner
				icon = 'shields.dmi'
				icon_state = "hogwartsbanner"

				maptext = "Hogwarts Shield/Banner: 3 wooden logs"
				price = 3
				path = /obj/static_obj/hogwartbanner { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1

				screen_x = 64
				screen_y = 192

			fence
				icon = 'fence.dmi'
				icon_state = "10"

				price = 15
				maptext = "Fence: 15 wooden logs"

				screen_x = 32
				screen_y = 224

				path = /obj/buildable/wall/fence
				replace = /obj/buildable/wall/wood

		book
			icon  = 'Books.dmi'
			clear = /obj/books/

			peacebook
				icon_state="peace"

				price = 100
				path = /obj/books/EXP_BOOK_lvl0 { life = 14400 }

				screen_x = 32
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			chaosbook
				icon_state="chaos"

				price = 100
				path = /obj/books/EXP_BOOK_lvl1 { life = 14400 }

				screen_x = 64
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			bankbook
				icon_state="bank"

				price = 100
				path = /obj/books/EXP_BOOK_lvl2 { life = 14400 }

				screen_x = 96
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			magicbook
				icon_state="rmagic"

				maptext = "Books (4 hours): 100 wooden logs"
				price = 100
				path = /obj/books/EXP_BOOK_lvl3 { life = 14400 }

				screen_x = 128
				screen_y = 64

			hogwartsbook
				icon_state="Hogwarts"

				price = 180
				path = /obj/books/EXP_BOOK_lvl4 { life = 28800 }

				screen_x = 32
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

			herbbook
				icon_state="herb"

				price = 180
				path = /obj/books/EXP_BOOK_lvl5 { life = 28800 }

				screen_x = 64
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

			potionbook
				icon_state="potion"

				price = 180
				path = /obj/books/EXP_BOOK_lvl6 { life = 28800 }

				screen_x = 96
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

			successbook
				icon_state="key"

				maptext = "Books (8 hours): 180 wooden logs"
				price = 180
				path = /obj/books/EXP_BOOK_lvl7 { life = 28800 }

				screen_x = 128
				screen_y = 96

		portkey
			icon='portal.dmi'
			icon_state="portkey"

			Hogwarts
				price = 1
				maptext = "Hogwarts: 1 wooden logs"

				screen_x = 32
				screen_y = 224

				path = /obj/teleport/portkey { dest = "@Hogwarts"}

			Courtyard

				price = 1
				maptext = "Courtyard: 1 wooden logs"

				screen_x = 32
				screen_y = 192

				path = /obj/teleport/portkey { dest = "@Courtyard"}

