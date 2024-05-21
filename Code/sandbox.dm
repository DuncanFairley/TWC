WorldData/var/tmp/list/sandboxZ

WorldData/var
	list/buildableID


mob/test/verb/UploadMap(f as file)
	set category="Debug"
	if(isnull(f)) return

	var/filename = "[f]"
	var/file_ext = lowertext(copytext(filename, max(length(filename)-3,1)))
	if(file_ext != ".sav")
		src << errormsg("only .sav allowed")
		return

	var/path = "vaults/[filename]"
	if(fexists(path))
		fdel(path)

	fcopy(f,path)


mob/test/verb/SandboxStart()
	set category="Debug"

	InitSandbox()

proc
	InitSandbox(attempts=3)
		set waitfor = 0

		if(worldData.buildableID)
			for(var/i in worldData.buildableID)
				Loadbuildable(i)
		//		Loadbuildable("custom_buildable")
	//			Loadbuildable("custom_buildable2")

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
		for(var/z in worldData.sandboxZ)
			for(var/i = 1 to 30)
				var/x = rand(10, 90)
				var/y = rand(10, 90)

				var/turf/t = locate(x, y, z)

				#if WINTER
				if(t.icon_state == "snow" && !t.flyblock)
				#else
				if(t.icon_state == "grass1" && !t.flyblock)
				#endif
					new /obj/farm/tree (t)

				lagstopsleep()

			for(var/i = 1 to 10)
				var/x = rand(10, 90)
				var/y = rand(10, 90)

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
		density = 1

		var
			hp    = 20000
			maxhp = 20000
			amount = 25
			obj/healthbar/hpbar
			origZ

		New()
			set waitfor = 0
			..()
			sleep(1)
			origZ = z

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

					var/turf/t = locate(x, y, origZ)

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

					player.Gathering.add(s*50, player, 1)

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

			hp    = 40000
			maxhp = 40000
			amount = 15

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
		icon       = 'Wood Log.dmi'
		icon_state = "log1"
		accioable  = 1
		wlable     = 1
	stones
		icon       = 'Moss_Rocks.dmi'
		icon_state = "small"
		accioable  = 1
		wlable     = 1

	wearable/blueprint
		icon = 'blueprint.dmi'
		showoverlay = FALSE
		dropable = 0

		useTypeStack = 1
		stackName = "Blueprints"

		var/buildType

		basic_blueprint
			buildType = /hudobj/build/basic

		house_blueprint
			buildType = /hudobj/build/house

		book_blueprint
			buildType = /hudobj/build/book

		stone_blueprint
			buildType = /hudobj/build/stone

		utility_blueprint
			buildType = /hudobj/build/utility

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
					if(owner.buildItemDisplay.loc)
						owner.buildItemDisplay.loc.mouse_opacity = 1
						owner.buildItemDisplay.loc = null
					owner.buildItemDisplay = null

turf/buildable
	icon = 'turf.dmi'

	var/isVault = 0

	#if WINTER
	name       = "snow"
	icon_state = "snow"
	#else
	name       = "grass"
	icon_state = "grass1"
	#endif

	vault
		name = "floor"
		icon_state = "brick"
		isVault = 1

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

				if(!p.buildItem.inVault && isVault)
					p.buildItemDisplay.color = "#f00"
					return

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

			if(!p.buildItem.inVault && isVault)
				p << errormsg("You can't build this in a vault.")
				return

			if(p.buildItem.path)

				if(p.buildItem.reqWall)
					var/turf/t = locate(x,y+1,z)
					if(!t || !t.flyblock)
						return

				if((flyblock && !p.buildItem.reqWall) || (locate(p.buildItem.path) in src))
					if(!p.buildItem.replace || !(locate(p.buildItem.replace) in src))
						return

			for(var/obj/buildable/shield_totem/c in range(10, src))
				if(!c.allowed) continue
				if(usr.ckey in c.allowed) continue
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

				Clear(p.buildItem.clear, 1 + p.buildItem.reqWall)
				var/obj/buildable/wall/o = new p.buildItem.path(src)

				if(istype(o, /obj/buildable/wall) || istype(o, /obj/buildable/door/secret))
					if(o.density)
						o.hp = 10000
						if(!o.hpbar)
							o.hpbar = new(o)
						o.hpbar.Set(o.hp / o.maxhp, instant=1)

					spawn(2)
						for(var/obj/buildable/w in orange(1, src))
							if(istype(w, /obj/buildable/wall) || istype(w, /obj/buildable/door/secret))
								w:updateState()



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
		Clear(clear, all = 0) // 0 - all, 1 - only floor, 2 only wall
			for(var/obj/o in src)
				if(!o.canSave) continue
				if(istype(o, /obj/items)) continue
				if(istype(o, /obj/buildable) && !o:canClear) continue
				if(all == 1 && o.pixel_y > 20) continue
				if(all == 2 && o.pixel_y < 20) continue

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
		canClear = 0
		block = 0


	density = 1

	New()
		set waitfor = 0
		sleep(1)
		if(density && opacity || block)
			var/turf/t = loc
			t.flyblock = 2

		if(density)
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
		rate = 12000

		opacity = 1
		block = 1

		window
			opacity = 0
			alpha = 200
			wood
				icon = 'wood_wall.dmi'
				icon_state = "10"

			stone
				icon = 'stone.dmi'
				icon_state = "10"
				hp    = 120000
				maxhp = 120000
				rate = 22000

		wood
			icon = 'wood_wall.dmi'
			icon_state = "10"

		stone
			icon = 'stone.dmi'
			icon_state = "10"
			hp    = 120000
			maxhp = 120000
			rate = 22000

		fence
			opacity = 0
			icon = 'fence.dmi'
			icon_state = "10"
			hp    = 30000
			maxhp = 30000
			rate = 3000
			block = 1

		bricks
			opacity = 0
			icon = 'wall1.dmi'

			MouseEntered(location,control,params)
				loc.MouseEntered(location,control,params)

			Click(location,control,params)
				loc.Click(location,control,params)

		railing
			opacity = 0
			density = 0
			pixel_y = 40
			block   = 0
			icon = 'fence.dmi'
			icon_state = "10"
			canClear = 1

			updateState()
				..()

				var/num = text2num(icon_state)

				if(!(num & 4)) icon_state = "[num + 4]"

		New()
			set waitfor = 0
			..()
			sleep(2)

			updateState()

		proc
			updateState()
				var/turf/t = pixel_y >= 32 ? locate(x, y+1, z) : loc
				if(t)
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
		rate = 10000
		block = 1

		var/tmp/open = 0

		wood
			icon='Door.dmi'
			icon_state="closed"
		gate
			icon='gate.dmi'
			icon_state="closed"
			hp    = 100000
			maxhp = 100000
			rate = 20000

		secret
			wood
				icon = 'wood_wall.dmi'
				icon_state = "10"
			stone
				icon = 'stone.dmi'
				icon_state = "10"
				hp    = 100000
				maxhp = 100000
				rate = 20000
			bricks
				opacity = 0
				icon = 'wall1.dmi'

			New()
				set waitfor = 0
				..()
				sleep(2)

				alpha = 255
				opacity = initial(opacity)
				layer = 3
				density = 1
				updateState()

			Bumped(mob/Player/p)

				for(var/obj/buildable/shield_totem/c in range(10, src))
					if(!c.allowed) continue
					if(usr.ckey in c.allowed) continue
					return

				if(!open)
					open = 1
					opacity = 0
					animate(src, alpha = 150, time = 4)
					sleep(4)
					density=0
					layer = 5
					sleep(50)
					while(locate(/mob) in loc) sleep(10)
					animate(src, alpha = 255, time = 4)
					density=1
					layer = 3
					sleep(4)
					opacity = initial(opacity)
					open = 0

			proc
				updateState()
					var/turf/t = loc
					var/n = t.autojoin1("flyblock", 2)
					icon_state = "[n]"

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
		var/locked = 0

		canHeal = 1
		hp    = 75000
		maxhp = 75000
		rate = 13500

		mouse_over_pointer = MOUSE_HAND_POINTER
		icon = 'Totem.dmi'
		icon_state = "Shield"

		MouseEntered(location,control,params)
			Highlight(usr, "#00a5ff")

		MouseExited(location,control,params)
			var/mob/Player/p = usr
			if(p.highlight)
				p.client.images -= p.highlight
				p.highlight = null

		Click()
			if(src in range(1))

				if(locked && allowed && !(usr.ckey in allowed))
					usr << errormsg("This totem is locked.")
					return

				if(allowed)
					usr << infomsg("Allowed:")
					for(var/i in allowed)
						usr << infomsg(" - [i]")

				if(!IsInputOpen(usr, "BuildProtection"))
					var/Input/popup = new (usr, "BuildProtection")
					var/response = popup.Alert(usr, "Add yourself or clean the access list?", "Build Protection", "Add", "Clean", locked ? "Unlock" : "Lock")
					del popup
					if(response == "Add")
						if(!allowed)
							allowed = list()
						else if(usr.ckey in allowed)
							return

						allowed += usr.ckey
						usr << infomsg("You were added to the build list.")
					else if(response == "Lock")
						locked = 1
					else if(response == "Unlock")
						locked = 0
					else
						allowed = null
						usr << infomsg("You cleaned the build list.")


			else
				..()
	hammer_totem
		var/tmp/list/pets

		mouse_over_pointer = MOUSE_HAND_POINTER
		icon = 'Totem.dmi'
		icon_state = "Hammer"

		MouseEntered(location,control,params)
			Highlight(usr, "#00a5ff")

		MouseExited(location,control,params)
			var/mob/Player/p = usr
			if(p.highlight)
				p.client.images -= p.highlight
				p.highlight = null

		Click()
			if(src in range(1))
				if(tag == "pet_" + usr.ckey)
					usr << errormsg("Your unused pets will no longer appear here.")
					tag = null
					cleanPets()
				else if(tag)
					usr << errormsg("Someone else owns this totem.")
				else
					var/obj/buildable/hammer_totem/o = locate("pet_" + usr.ckey)
					if(o)
						o.tag = null
						o.cleanPets()
						usr << errormsg("Your previous totem is replaced by this one.")

					tag = "pet_" + usr.ckey
					usr << infomsg("Your unused pets will now appear here.")

					usr:DisplayPets()
			else
				..()
		proc/cleanPets()
			for(var/obj/items/i in pets)
				var/obj/pet/p = pets[i]
				p.Dispose()
			pets = null
	Bed
		icon       = 'turf.dmi'
		icon_state = "Bed"

		Click()
			if(src in range(1))
				if(tag == "respawn_" + usr.ckey)
					usr << errormsg("You will no longer respawn here.")
					tag = null
				else if(tag)
					usr << errormsg("Someone else owns this bed.")
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
			inVault = 1
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
				screen_y       = -96

				Click()

			clear
				icon = 'HUD.DMI'
				icon_state = "x"
				maptext = "Clear Decoration/Portkeys"

				screen_x = 32
				screen_y = -32

			#if WINTER
			snow
				icon_state = "snow"
			#else
			grass
				icon_state = "grass1"
			#endif
				icon = 'turf.dmi'

				screen_x = 32
				screen_y = 256

				maptext_x = 0
				maptext_width = 32

			dirt
				icon = 'turf.dmi'
				icon_state = "dirt"

				screen_x = 64
				screen_y = 256

				maptext_x = 0
				maptext_width = 32
			sand
				icon = 'turf.dmi'
				icon_state = "sand"

				screen_x = 96
				screen_y = 256

				maptext = "Floors: free"
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

			clock
				icon       ='General.dmi'
				icon_state = "tile79"

				price = 2
				path = /obj/static_obj/Clock { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1
				mouse_opacity = 2

				screen_x = 32
				screen_y = 32

				maptext_x = 0
				maptext_width = 32

			dual_swords
				icon       ='wallobjs.dmi'
				icon_state = "sword"

				price = 2
				path = /obj/static_obj/Dual_Swords { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1
				mouse_opacity = 2

				screen_x = 64
				screen_y = 32

				maptext_x = 0
				maptext_width = 32

			art_white_flower
				icon       ='Decoration.dmi'
				icon_state = "whiteflower"

				price = 2
				path = /obj/static_obj/art/Art_White_Flower { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1
				mouse_opacity = 2

				screen_x = 96
				screen_y = 32

				maptext_x = 0
				maptext_width = 32

			art_red_flower
				icon       ='Decoration.dmi'
				icon_state = "pinkflower"

				price = 2
				path = /obj/static_obj/art/Art_Pink_Flower { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1
				mouse_opacity = 2

				screen_x = 128
				screen_y = 32

				maptext_x = 0
				maptext_width = 32

			art_pink_flower
				icon       ='Decoration.dmi'
				icon_state = "pinkflower2"

				price = 2
				path = /obj/static_obj/art/Art_Pink_Flower2 { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1
				mouse_opacity = 2

				screen_x = 160
				screen_y = 32

				maptext_x = 0
				maptext_width = 32

			art_painting
				icon       ='Decoration.dmi'
				icon_state = "small"

				price = 2
				path = /obj/static_obj/art/Art_Small { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1
				mouse_opacity = 2

				screen_x = 192
				screen_y = 32

				maptext_x = 0
				maptext_width = 32

			art_tree
				icon       ='Decoration.dmi'
				icon_state = "tree"

				price = 2
				path = /obj/static_obj/art/Art_Tree { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1
				mouse_opacity = 2

				screen_x = 224
				screen_y = 32

				maptext_x = 0
				maptext_width = 32

			wall_torch
				icon       ='turf.dmi'
				icon_state = "walltorch"

				price = 2
				maptext = "Decoration: 2 wood logs"
				path = /obj/static_obj/walltorch { post_init = 0; pixel_y = 32 }
				reqWall = 1
				mouse_opacity = 2

				screen_x = 232
				screen_y = 64

			Bed
				icon       = 'turf.dmi'
				icon_state = "Bed"

				price = 20
				maptext = "Bed: 20 wood logs"
				path = /obj/buildable/Bed

				screen_x = 32
				screen_y = 96

				inVault = 0

			shield_totem
				icon = 'Totem.dmi'
				icon_state = "Shield"

				price = 100
				maptext = "Shield Totem: 100 wood logs"

				screen_x = 32
				screen_y = 128

				path = /obj/buildable/shield_totem

				inVault = 0

			door
				icon='Door.dmi'
				icon_state="closed"

				price = 30
				maptext = "Door: 30 wood logs"

				screen_x = 32
				screen_y = 160

				path = /obj/buildable/door/wood

			wood_wall
				icon = 'wood_wall.dmi'
				icon_state = "10"

				price = 20
				maptext = "Wood Wall: 20 wood logs"

				screen_x = 32
				screen_y = 192

				path = /obj/buildable/wall/wood
				replace = /obj/buildable/wall/fence

			woodfloor
				icon       = 'turf.dmi'
				icon_state = "wood"
				color      = "#704f32"

				price = 2

				screen_x = 32
				screen_y = 224

				maptext_x = 0
				maptext_width = 32

			woodfloorblack
				icon       = 'turf.dmi'
				icon_state = "wood"
				color      = "#303A3A"

				price = 2

				screen_x = 64
				screen_y = 224

				maptext_x = 0
				maptext_width = 32

			woodfloorteal
				icon       = 'turf.dmi'
				icon_state = "wood"
				color      = "#008eaa"

				price = 2

				screen_x = 96
				screen_y = 224

				maptext_x = 0
				maptext_width = 32

			stairs
				icon       = 'General.dmi'
				icon_state = "Stairs"

				price = 2
				path = /obj/static_obj/Hogwarts_Stairs { post_init = 0 }
				maptext = "Wood Floor: 2 wood logs"

				screen_x = 128
				screen_y = 224

		stone
			fireplace
				icon       = 'misc.dmi'
				icon_state = "fireplace"

				price = list(/obj/items/stones = 15)
				path = /obj/static_obj/Fireplace { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1

				screen_x = 32
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			black_throne
				icon       = 'Thrones.dmi'
				icon_state = "black"

				price = list(/obj/items/stones = 15)
				path = /obj/bigblackchair

				screen_x = 64
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			white_throne
				icon       = 'Thrones.dmi'
				icon_state = "white"

				price = list(/obj/items/stones = 15)
				path = /obj/bigwhitechair

				screen_x = 96
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			purple_throne
				icon       = 'Thrones.dmi'
				icon_state = "purple"

				price = list(/obj/items/stones = 15)
				path = /obj/bigpurplechair

				screen_x = 128
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

			teal_throne
				icon       = 'Thrones.dmi'
				icon_state = "teal"

				maptext = "Decor: 15 stones"
				price = list(/obj/items/stones = 15)
				path = /obj/bigtealchair

				screen_x = 160
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

			Column
				icon       = 'statues_64x64.dmi'
				icon_state = "columb"

				price = list(/obj/items/stones = 20)
				path = /obj/static_obj/Columb { post_init = 0; }

				screen_x = 128
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

			Armor
				icon       = 'statues_64x64.dmi'
				icon_state = "armor"

				maptext = "Statues: 20 stones"
				price = list(/obj/items/stones = 20)
				path = /obj/static_obj/Armor { post_init = 0; }

				screen_x = 160
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

			arch
				icon = 'wall1.dmi'
				icon_state = "arch"

				price = list(/obj/items/stones = 20)
				path = /obj/static_obj/Hogwarts_Stone_Arch { post_init = 0; }

				screen_x = 32
				screen_y = 192

				maptext_x = 0
				maptext_width = 32

			bricks
				icon = 'wall1.dmi'

				price = list(/obj/items/stones = 20)
				path = /obj/buildable/wall/bricks
				replace = /obj/buildable/wall/wood

				screen_x = 64
				screen_y = 192

				maptext_x = 0
				maptext_width = 32

			stone_wall
				icon = 'stone.dmi'
				icon_state = "10"

				price = list(/obj/items/stones = 20)
				maptext = "Stone Wall: 20 stones"

				screen_x = 96
				screen_y = 192

				path = /obj/buildable/wall/stone
				replace = /obj/buildable/wall/wood

			brickfloor
				icon       = 'turf.dmi'
				icon_state = "brick"

				price = list(/obj/items/stones = 2)

				screen_x = 32
				screen_y = 224

				maptext_x = 0
				maptext_width = 32

			blackfloor
				icon       = 'turf.dmi'
				icon_state = "blackfloor"

				price = list(/obj/items/stones = 2)

				screen_x = 64
				screen_y = 224

				maptext_x = 0
				maptext_width = 32

			road
				icon       = 'turf.dmi'
				icon_state = "stonefloor2"

				price = list(/obj/items/stones = 2)
				maptext = "Floors: 2 stones"

				screen_x = 96
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

				maptext = "Wood floors: 3 wood logs"
				price = 3

				screen_x = 128
				screen_y = 64

			red_carpet
				icon       = 'turf.dmi'
				icon_state = "carpet"
				color      = "#ff0000"

				price = 3

				screen_x = 32
				screen_y = 32

				maptext_x = 0
				maptext_width = 32

			green_carpet
				icon       = 'turf.dmi'
				icon_state = "carpet"
				color      = "#00ff00"

				price = 3

				screen_x = 64
				screen_y = 32

				maptext_x = 0
				maptext_width = 32

			yellow_carpet
				icon       = 'turf.dmi'
				icon_state = "carpet"
				color      = "#d5d500"

				price = 3

				screen_x = 96
				screen_y = 32

				maptext_x = 0
				maptext_width = 32

			blue_carpet
				icon       = 'turf.dmi'
				icon_state = "carpet"
				color      = "#0d74db"

				maptext = "Carpets: 3 wood logs"
				price = 3

				screen_x = 128
				screen_y = 32

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

				maptext = "Shields: 2 wood logs"
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

				maptext = "Banners: 2 wood logs"
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

				maptext = "Hogwarts Shield/Banner: 3 wood logs"
				price = 3
				path = /obj/static_obj/hogwartbanner { post_init = 0; pixel_y = 32; density = 0 }
				reqWall = 1

				screen_x = 64
				screen_y = 192

			railing
				icon = 'fence.dmi'
				icon_state = "10"

				price = 15

				screen_x = 32
				screen_y = 224

				reqWall = 1

				path = /obj/buildable/wall/railing

				maptext_x = 0
				maptext_width = 32

			fence
				icon = 'fence.dmi'
				icon_state = "10"

				price = 15
				maptext = "Railing/Fence: 15 wood logs"

				screen_x = 64
				screen_y = 224

				path = /obj/buildable/wall/fence
				replace = /obj/buildable/wall/wood

		book
			icon  = 'Books.dmi'
			clear = /obj/books/

			peacebook
				icon_state="peace"

				price = 100
				path = /obj/books/EXP_BOOK_lvl0 { life = 86400 }

				screen_x = 32
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

				inVault = 0

			chaosbook
				icon_state="chaos"

				price = 100
				path = /obj/books/EXP_BOOK_lvl1 { life = 86400 }

				screen_x = 64
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

				inVault = 0

			bankbook
				icon_state="bank"

				price = 100
				path = /obj/books/EXP_BOOK_lvl2 { life = 86400 }

				screen_x = 96
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

				inVault = 0

			magicbook
				icon_state="rmagic"

				maptext = "Books (1 day): 100 wood logs"
				price = 100
				path = /obj/books/EXP_BOOK_lvl3 { life = 86400 }

				screen_x = 128
				screen_y = 64

				inVault = 0

			hogwartsbook
				icon_state="Hogwarts"

				price = 200
				path = /obj/books/EXP_BOOK_lvl4 { life = 259200 }

				screen_x = 32
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

				inVault = 0

			herbbook
				icon_state="herb"

				price = 200
				path = /obj/books/EXP_BOOK_lvl5 { life = 259200 }

				screen_x = 64
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

				inVault = 0

			potionbook
				icon_state="potion"

				price = 200
				path = /obj/books/EXP_BOOK_lvl6 { life = 259200 }

				screen_x = 96
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

				inVault = 0

			successbook
				icon_state="key"

				maptext = "Books (3 days): 200 wood logs"
				price = 200
				path = /obj/books/EXP_BOOK_lvl7 { life = 259200 }

				screen_x = 128
				screen_y = 96

				inVault = 0

			slythbook
				icon_state="slyth"

				price = 300
				path = /obj/books/EXP_BOOK_lvlslytherin { life = 604800 }

				screen_x = 32
				screen_y = 128

				maptext_x = 0
				maptext_width = 32

				inVault = 0

			hufflebook
				icon_state="huffle"

				price = 300
				path = /obj/books/EXP_BOOK_lvlhufflepuff { life = 604800 }

				screen_x = 64
				screen_y = 128

				maptext_x = 0
				maptext_width = 32

				inVault = 0

			ravenbook
				icon_state="raven"

				price = 300
				path = /obj/books/EXP_BOOK_lvlravenclaw { life = 604800 }

				screen_x = 96
				screen_y = 128

				maptext_x = 0
				maptext_width = 32

				inVault = 0

			gryffbook
				icon_state="gryff"

				maptext = "Books (7 days): 300 wood logs"
				price = 300
				path = /obj/books/EXP_BOOK_lvlgryffindor { life = 604800 }

				screen_x = 128
				screen_y = 128

				inVault = 0

			bookshelf
				icon       ='Desk.dmi'
				icon_state = "1"

				maptext = "Bookshelf: 15 wood logs"
				price = 15
				path = /obj/Bookshelf
				reqWall = 1

				screen_x = 32
				screen_y = 160

			pinkflowers
				icon       ='Plants.dmi'
				icon_state = "Pink Flowers"

				price = 5
				path = /obj/static_obj/Pink_Flowers { post_init = 0; }

				screen_x = 32
				screen_y = 192

				maptext_x = 0
				maptext_width = 32

			blueflowers
				icon       ='Plants.dmi'
				icon_state = "Blue Flowers"

				price = 5
				path = /obj/static_obj/Blue_Flowers { post_init = 0; }

				screen_x = 64
				screen_y = 192

				maptext_x = 0
				maptext_width = 32

			redflowers
				icon       ='Plants.dmi'
				icon_state = "Rose Bush"

				maptext = "Plants: 5 wood logs"
				price = 5
				path = /obj/static_obj/Pink_Flowers { post_init = 0; icon_state = "Rose Bush"; name = "Rose Bush" }

				screen_x = 96
				screen_y = 192

			pet_totem
				icon = 'Totem.dmi'
				icon_state = "Hammer"

				maptext = "Pet Totem: 100 wood logs & 50 stones"
				price = list(/obj/items/stones = 50,
				             /obj/items/wood_log = 100)
				path = /obj/buildable/hammer_totem

				screen_x = 32
				screen_y = 224

				inVault = 0

		utility
			male_statue
				icon='MaleVampire.dmi'
		//		icon_state="cauldron"

				price = list(/obj/items/wood_log = 100,
				             /obj/items/stones = 100,
				             /obj/items/artifact = 5)

				screen_x = 32
				screen_y = 0

				maptext_x = 0
				maptext_width = 32

				path = /obj/statue/male

			female_statue
				icon='FemaleVampire.dmi'
		//		icon_state="cauldron"

				price = list(/obj/items/wood_log = 100,
				             /obj/items/stones = 100,
				             /obj/items/artifact = 5)

				screen_x = 64
				screen_y = 0

				maptext = "Statues: 100 stone & wood and 5 artifacts"

				path = /obj/statue/female

			fake_wood
				icon = 'wood_wall.dmi'
				icon_state = "10"

				price = 40

				screen_x = 32
				screen_y = 32

				maptext_x = 0
				maptext_width = 32

				path = /obj/buildable/wall/wood { density = 0; layer = 5; mouse_opacity = 0; block = 0; canClear = 1 }
				replace = /obj/buildable/wall/wood

			fake_bricks
				icon = 'wall1.dmi'

				price = list(/obj/items/stones = 40)

				screen_x = 64
				screen_y = 32

				path = /obj/buildable/wall/bricks { density = 0; layer = 5; mouse_opacity = 0; block = 0; canClear = 1 }
				replace = /obj/buildable/wall/bricks

				maptext_x = 0
				maptext_width = 32

			fake_stone
				icon = 'stone.dmi'
				icon_state = "10"

				price = list(/obj/items/stones = 40)
				maptext = "Fake wall: 40 wood/stone"

				screen_x = 96
				screen_y = 32

				path = /obj/buildable/wall/stone { density = 0; layer = 5; mouse_opacity = 0; block = 0; canClear = 1 }
				replace = /obj/buildable/wall/stone
			secret_wood_door
				icon = 'wood_wall.dmi'
				icon_state = "10"

				price = 40

				screen_x = 32
				screen_y = 64

				maptext_x = 0
				maptext_width = 32

				path = /obj/buildable/door/secret/wood
				replace = /obj/buildable/wall/wood

			secret_bricks_door
				icon = 'wall1.dmi'

				price = list(/obj/items/stones = 40)

				screen_x = 64
				screen_y = 64

				path = /obj/buildable/door/secret/bricks
				replace = /obj/buildable/wall/bricks

				maptext_x = 0
				maptext_width = 32

			secret_stone_door
				icon = 'stone.dmi'
				icon_state = "10"

				price = list(/obj/items/stones = 40)
				maptext = "Secret door: 40 wood/stone"

				screen_x = 96
				screen_y = 64

				path = /obj/buildable/door/secret/stone
				replace = /obj/buildable/wall/stone

			wood_window
				icon = 'wood_wall.dmi'
				icon_state = "10"

				price = 30

				screen_x = 32
				screen_y = 96

				maptext_x = 0
				maptext_width = 32

				path = /obj/buildable/wall/window/wood
				replace = /obj/buildable/wall/wood

			stone_window
				icon = 'stone.dmi'
				icon_state = "10"

				price = list(/obj/items/stones = 30)
				maptext = "Windows: 30 wood/stone"

				screen_x = 64
				screen_y = 96

				path = /obj/buildable/wall/window/stone
				replace = /obj/buildable/wall/stone

			toilet
				icon = 'toilet.dmi'

				price = 10
				path = /obj/toilet

				screen_x = 32
				screen_y = 128

				maptext_x = 0
				maptext_width = 32

			sink
				icon = 'sink.dmi'

				maptext = "Bathroom utility: 10 wood logs"
				price = 10
				path = /obj/sink

				screen_x = 64
				screen_y = 128

			stand_sign
				icon = 'statues.dmi'
				icon_state = "sign3"

				price = 10
				path = /obj/Signs/custom { icon_state = "sign3"; pixel_y = 0; density = 1 }

				screen_x = 32
				screen_y = 160

				maptext_x = 0
				maptext_width = 32

			sign
				icon = 'statues.dmi'
				icon_state = "sign"

				maptext = "Sign: 10 wood logs"
				price = 10
				path = /obj/Signs/custom
				reqWall = 1

				screen_x = 64
				screen_y = 160

			DiagonAlley_Portkey
				icon='portal.dmi'
				icon_state="portkey"

				price = list(/obj/items/artifact = 1,
				             /obj/items/magic_stone/teleport = 1)

				screen_x = 32
				screen_y = 192

				maptext_x = 0
				maptext_width = 32

				path = /obj/teleport/portkey { dest = "@DiagonAlley"}

			Silverblood_Portkey
				icon='portal.dmi'
				icon_state="portkey"

				price = list(/obj/items/artifact = 1,
				             /obj/items/magic_stone/teleport = 1)

				screen_x = 64
				screen_y = 192

				maptext_x = 0
				maptext_width = 32

				path = /obj/teleport/portkey { dest = "teleportPointSilverblood"}

			Hogwarts_Portkey
				icon='portal.dmi'
				icon_state="portkey"

				price = list(/obj/items/artifact = 1,
				             /obj/items/magic_stone/teleport = 1)

				screen_x = 96
				screen_y = 192

				maptext_x = 0
				maptext_width = 32

				path = /obj/teleport/portkey { dest = "@Hogwarts"}

			Courtyard_Portkey
				icon='portal.dmi'
				icon_state="portkey"

				price = list(/obj/items/artifact = 1,
				             /obj/items/magic_stone/teleport = 1)
				maptext = "Silverblood/Hogwarts/Courtyard Portkeys: 1 teleport stone & artifact"

				screen_x = 128
				screen_y = 192

				path = /obj/teleport/portkey { dest = "@Courtyard"}

			cauldron
				icon='potions_tools.dmi'
				icon_state="cauldron"

				price = list(/obj/items/artifact = 1)

				screen_x = 32
				screen_y = 224

				maptext_x = 0
				maptext_width = 32

				path = /obj/potions/cauldron

			dropper
				icon='potions_tools.dmi'
				icon_state = "dropper"

				price = list(/obj/items/artifact = 1)

				screen_x = 64
				screen_y = 224

				maptext_x = 0
				maptext_width = 32

				path = /obj/potions/dropper

			grind
				icon='potions_tools.dmi'
				icon_state="pestle"

				price = list(/obj/items/artifact = 1)
				maptext = "Potion Tools: 1 artifact"

				screen_x = 96
				screen_y = 224

				path = /obj/potions/grind


obj
	Bookshelf
		icon       ='Desk.dmi'
		icon_state = "1"
		pixel_y = 32

		New()
			..()


			var/turf/t = locate(x-1, y, z)

			if(t)
				var/obj/Bookshelf/b = locate() in t
				if(b && b.icon_state == "1")
					icon_state = "2"
					return

			t = locate(x+1, y, z)

			if(t)
				var/obj/Bookshelf/b = locate() in t
				if(b)

					var/turf/t2 = locate(x+2, y, z)
					if(t2)
						var/obj/Bookshelf/b2 = locate() in t2
						if(b2 && b2.icon_state == "2") return

					b.icon_state = "2"

obj
	statue

		mouse_over_pointer = MOUSE_HAND_POINTER
		density = 1

		verb/Turn()
			set src in view(1)

			dir = turn(dir, 90)

		var/effects

		MouseEntered(location,control,params)
			if(effects)
				Highlight(usr)

		MouseExited(location,control,params)
			var/mob/Player/p = usr
			if(p.highlight)
				p.client.images -= p.highlight
				p.highlight = null

		Highlight(mob/Player/p)
			set waitfor = 0
			if(!isplayer(p)) return

			var/image/i

			if(p.highlight)
				p.client.images -= p.highlight

			if(effects)

				i = image(src, src)
				i.layer = 5

				var/c = "#ffa500"
				i.filters = filter(type="drop_shadow", size=1, y=0, x=0, offset=2, color=c)

				i.maptext_x = 32
				i.maptext_y = 8
				i.maptext = effects
				var/size = splittext(p.client.MeasureText(effects), "x")
				i.maptext_width  = text2num(size[1])
				i.maptext_height = text2num(size[2])

				if(p.highlight)
					p.client.images -= p.highlight
				p.highlight = i

				p.client.images += i

		New()
			set waitfor = 0
			..()
			sleep(1)
			if(contents.len)
				var/images = list()
				for(var/obj/items/wearable/w in src)
					if(w.showoverlay)
						var/image/o = new
						o.icon = w.icon
						o.color = w.color
						o.layer = w.wear_layer

						images += o

				overlays = images

		Click()
			if(src in oview(1))
				var/mob/Player/p = usr

				if(contents.len)

					for(var/obj/items/wearable/w in src)
						w.Move(p)
						w.Equip(p)

					overlays = null
					effects = null

					if(p.highlight)
						p.client.images -= p.highlight
						p.highlight = null

				else

					var/images = list()
					for(var/obj/items/wearable/w in p.Lwearing)
						if(w.showoverlay)
							w.Equip(p)
							w.Move(src)

							var/image/o = new
							o.icon = w.icon
							o.color = w.color
							o.layer = w.wear_layer

							images += o

						else if(istype(w, /obj/items/wearable/sword))
							effects += "[w.name]\n"
							w.Equip(p)
							w.Move(src)
						else if(istype(w, /obj/items/wearable/ring))
							effects += "[w.name]\n"
							w.Equip(p)
							w.Move(src)
						else if(istype(w, /obj/items/wearable/shield))
							effects += "[w.name]\n"
							w.Equip(p)
							w.Move(src)


					overlays = images

					Highlight(p)

		male
			icon = 'MaleVampire.dmi'
		female
			icon = 'FemaleVampire.dmi'