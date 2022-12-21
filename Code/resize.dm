
#define TILE_WIDTH 32
#define TILE_HEIGHT 32
#define MAX_VIEW_TILES 2000
#define HUD_LAYER 10

#define BROWSER_VERSION 3

obj/hud
	plane = 2

hudobj
	parent_type = /obj
	layer = HUD_LAYER

	var
		client/client
		anchor_x = "WEST"
		anchor_y = "SOUTH"
		screen_x = 0
		screen_y = 0
		width = TILE_WIDTH
		height = TILE_HEIGHT
	proc
		setSize(W,H)
			width = W
			height = H
			if(anchor_x!="WEST"||anchor_y!="SOUTH")
				updatePos()

		setPos(X,Y,AnchorX="WEST",AnchorY="SOUTH")
			screen_x = X
			anchor_x = AnchorX
			screen_y = Y
			anchor_y = AnchorY
			updatePos()

		updatePos()
			var/ax
			var/ay
			var/ox
			var/oy
			switch(anchor_x)
				if("WEST")
					ax = "WEST+0"
					ox = screen_x + client.buffer_x
				if("EAST")
					if(width>TILE_WIDTH)
						var/tx = ceil(width/TILE_WIDTH)
						ax = "EAST-[tx-1]"
						ox = tx*TILE_WIDTH - width - client.buffer_x + screen_x
					else
						ax = "EAST+0"
						ox = TILE_WIDTH - width - client.buffer_x + screen_x
				if("CENTER")
					ax = "CENTER+0"
					ox = floor((TILE_WIDTH - width)/2) + screen_x
			switch(anchor_y)
				if("SOUTH")
					ay = "SOUTH+0"
					oy = screen_y + client.buffer_y
				if("NORTH")
					if(height>TILE_HEIGHT)
						var/ty = ceil(height/TILE_HEIGHT)
						ay = "NORTH-[ty-1]"
						oy = ty*TILE_HEIGHT - height - client.buffer_y + screen_y
					else
						ay = "NORTH+0"
						oy = TILE_HEIGHT - height - client.buffer_y + screen_y
				if("CENTER")
					ay = "CENTER+0"
					oy = floor((TILE_HEIGHT - height)/2) + screen_y
			screen_loc = "[ax]:[ox],[ay]:[oy]"

		show(instant=0)
			updatePos()
			if(client.hideHud)
				alpha = 0
			else if(!instant)
				alpha = 0
				animate(src, alpha = initial(alpha), time = 5)
			client.screen += src

		hide(instant=0)
			set waitfor = 0
			if(instant)
				client.screen -= src
			else
				animate(src, alpha = 0, time = 5)
				sleep(6)
				if(client)
					client.screen -= src


	New(loc=null,client/Client,list/Params,show=1)
		client = Client
		for(var/v in Params)
			vars[v] = Params[v]
		if(show) show(show-1)

mob/Player
	var/MapZoom = 1

	verb/SetZoom(var/z as num)
		set category = null

		MapZoom = z
		src << output(MapZoom,"browser1:SetZoom")

client
	var
		view_width
		view_height
		buffer_x
		buffer_y
		map_zoom

		browser_loaded = 0
		hideHud = 0
	verb
		onLoad(var/n as num)
			set hidden = 1

			if(!browser_loaded)
				browser_loaded = n

			//	src << output(null,"browser1:CenterWindow")

				if(isplayer(mob)) // if mapbrowser loaded after login()
					src << output(mob:MapZoom, "browser1:SetZoom")
					src << output(mob:House,"browser1:Login")

					if(mob:foreColor != "#000000")
						src << output("[mob:foreColor]","browser1:ForeColor")
					if(mob:backColor != "#f0f0f0")
						src << output("[mob:backColor]","browser1:BackColor")

		onResize(VW as num,VH as num,BX as num,BY as num,Z as num)
			set hidden = 1
			if(VW*VH>MAX_VIEW_TILES) return

			view_width = VW
			view_height = VH
			buffer_x = BX
			buffer_y = BY
			map_zoom = Z
			view = "[VW]x[VH]"

			var/obj/darkness/d = locate() in screen
			if(d)
				d.transform = matrix(VW, 0, 0, 0, VH, 0)

			for(var/hudobj/h in screen)
				h.updatePos()

	New()
		..()
		initMapBrowser()

	proc
		initMapBrowser()
			set waitfor = 0
			sleep(2)
			while(!browser_loaded)
				src << browse('mapbrowser.html',"window=browser1")
				sleep(50)


hudobj
	icon               = 'HUD.dmi'
	mouse_over_pointer = MOUSE_HAND_POINTER
	appearance_flags   = NO_CLIENT_COLOR|PIXEL_SCALE
	plane              = 2

	UseStatpoints
		name       = "Use Statpoints"
		icon_state = "lvlup"
		anchor_x   = "WEST"
		screen_x   = 274
		screen_y   = -16
		anchor_y   = "NORTH"

		mouse_opacity = 2

		var/tmp/on = 0

		MouseEntered()
			transform *= 1.25
		MouseExited()
			transform = null

		Click()
			if(alpha == 0) return
			var/mob/Player/p = usr

			if(on)
				for(var/hudobj/statpoints/b in p.client.screen)
					b.hide()

				on = 0
				icon_state = "lvlup"
			else
				for(var/t in (typesof(/hudobj/statpoints)-/hudobj/statpoints))
					var/hudobj/o = new t (null, p.client, null, 1)
					o.maptext = {"<span style=\"color:[p.mapTextColor]\">[o.maptext]</span>"}
					new /obj/background(o, 6, 1)

				on = 1
				icon_state = "lvlup_red"

	statpoints

		anchor_x    = "CENTER"
		anchor_y    = "CENTER"

		maptext_y = 8
		maptext_x = 34
		maptext_width = 256

		mouse_opacity  = 2

		MouseEntered()
			transform *= 1.25
		MouseExited()
			transform = null

		Damage
			icon = 'trophies.dmi'
			icon_state = "Sword"
			maptext = "Damage"

			screen_x = -64
			screen_y = 128

			Click()
				var/mob/Player/p = usr
				if(alpha == 0) return
				if(p.StatPoints > 0)
					var/SP = round(input("How many stat points do you want to put into Damage?","You have [p.StatPoints]",p.StatPoints) as num|null)
					if(!SP || SP <= 0) return
					SP = min(p.StatPoints, SP)

					var/addstat = 1*SP
					p.Dmg += addstat
					p << infomsg("You gained [addstat] damage!")
					p.StatPoints -= SP

				if(p.StatPoints == 0)
					for(var/hudobj/statpoints/b in p.client.screen)
						b.hide()

					for(var/hudobj/UseStatpoints/b in p.client.screen)
						b.hide()

		Defense
			icon = 'trophies.dmi'
			icon_state = "Shield"
			maptext = "Defense"

			screen_x = -64
			screen_y = 96

			Click()
				var/mob/Player/p = usr
				if(alpha == 0) return
				if(p.StatPoints > 0)
					var/SP = round(input("How many stat points do you want to put into Defense?","You have [p.StatPoints]",p.StatPoints) as num|null)
					if(!SP || SP <= 0) return
					SP = min(p.StatPoints, SP)

					var/addstat = 3*SP
					p.Def += addstat
					p << infomsg("You gained [addstat] defense!")
					p.StatPoints -= SP
					p.resetMaxHP()

				if(p.StatPoints == 0)
					for(var/hudobj/statpoints/b in p.client.screen)
						b.hide()

					for(var/hudobj/UseStatpoints/b in p.client.screen)
						b.hide()

		Cooldown_Reduction
			icon = 'HUD.DMI'
			icon_state = "cdr"
			maptext = "Cooldown Reduction"

			screen_x = -64
			screen_y = 64

			Click()
				var/mob/Player/p = usr
				if(alpha == 0) return

				var/remaining = round((p.cooldownModifier * 100 - 50)*2, 1)

				if(remaining <= 0)
					p << errormsg("Cooldown Reduction is already at max of 50%.")
					return

				if(p.StatPoints > 0)
					var/SP = round(input("How many stat points do you want to put into Cooldown Reduction?","You have [p.StatPoints]",p.StatPoints) as num|null)
					if(!SP || SP <= 0) return

					SP = min(p.StatPoints, SP)
					SP = min(remaining, SP)

					var/addstat = 0.005*SP
					p.cooldownModifier -= addstat
					p << infomsg("You now have [round(1000 - p.cooldownModifier*1000, 1)/10]% cooldown reduction.")
					p.StatPoints -= SP

				if(p.StatPoints == 0)
					for(var/hudobj/statpoints/b in p.client.screen)
						b.hide()

					for(var/hudobj/UseStatpoints/b in p.client.screen)
						b.hide()

		MP_Regeneration
			icon = 'HUD.DMI'
			icon_state = "mp"
			maptext = "MP Regeneration"

			screen_x = -64
			screen_y = 32

			Click()
				var/mob/Player/p = usr
				if(alpha == 0) return

				if(p.StatPoints > 0)
					var/SP = round(input("How many stat points do you want to put into MP regeneration?","You have [p.StatPoints]",p.StatPoints) as num|null)
					if(!SP || SP <= 0) return
					SP = min(p.StatPoints, SP)

					var/addstat = 2*SP
					p.MPRegen += addstat
					p << infomsg("You gained [addstat] MP regeneration!")
					p.StatPoints -= SP

				if(p.StatPoints == 0)
					for(var/hudobj/statpoints/b in p.client.screen)
						b.hide()

					for(var/hudobj/UseStatpoints/b in p.client.screen)
						b.hide()

	teleport
		name       = "Teleport Back"
		icon_state = "teleport"
		anchor_x   = "WEST"
		screen_x   = 306
		screen_y   = -16
		anchor_y   = "NORTH"

		mouse_opacity = 2

		var
			dest
			cost = 1

		MouseEntered()
			transform *= 1.25
		MouseExited()
			transform = null

		Click()
			var/mob/Player/p = usr
			if(alpha == 0) return
			if(!color)
				color = "#0f0"
				p << infomsg("Click again to confirm, this will teleport you back and cost [cost] teleport crystal[cost > 1 ? "s" : ""].")
			else
				var/obj/items/magic_stone/teleport/t
				for(var/obj/items/magic_stone/teleport/i)
					if(istype(i, /obj/items/magic_stone/teleport/memory)) continue
					if(!i.dest)
						t = i
						break

				if(!t || t.stack < cost)
					p << errormsg("You don't have [cost] teleport crystal[cost > 1 ? "s" : ""] to teleport back.")
					return

				t.Consume(cost)

				var/turf/d = locate(dest)
				if(d)
					hearers(p) << infomsg("[p.name] disappears in a flash of light.")
					p.Transfer(d)
					hearers(p) << infomsg("[p.name] appears in a flash of light.")

				hide()


	PMHome

		name        = "Private Messaging"
		icon_state  = "PM"

		anchor_x    = "EAST"
		screen_x    = -4
		screen_y    = -16
		anchor_y    = "NORTH"

		mouse_opacity = 2

		var/tmp/unread = 0

		Click()
			var/mob/Player/M = usr

			if(unread)
				unread = 0
				maptext = null
				alpha = 255
				animate(src)

			M.PMHome()

		alpha = 110
		MouseEntered()
			if(!unread) alpha = 255
		MouseExited()
			if(!unread) alpha = 110

		New(loc=null,client/Client,list/Params,show=1)
			..(loc,Client,Params,show)

			for(var/atom/movable/PM/A in client.mob:pmsRec)
				if(!A.read) unread++

			if(unread)
				maptext = "<span style=\"color:[client.mob:mapTextColor];font-size:2px;\">[unread]</span>"
				animate(src, alpha = 250, time = 10, loop = -1)
				animate(alpha = 150, time = 10)

	spellbook

		icon       = 'Books.dmi'
		icon_state = "spell"

		anchor_x   = "EAST"
		screen_x   = -4
		screen_y   = -48
		anchor_y   = "NORTH"

		mouse_opacity = 2

		Click()
			..()
			var/mob/Player/p = usr
			if(p.spellBookOpen)
				p.spellBookOpen = 0
				winshow(p, "SpellBook", 0)
			else
				p.spellBookOpen = 1
				p.updateSpellbook()
				winshowCenter(p, "SpellBook")

			p.toggle_actionbar(p.spellBookOpen)

		alpha = 110
		MouseEntered()
			alpha = 255
		MouseExited()
			alpha = 110


	questbook
		name        = "Quest Book"
		icon        = 'Books.dmi'
		icon_state  = "quest"

		anchor_x    = "EAST"
		screen_x    = -4
		screen_y    = -80
		anchor_y    = "NORTH"

		mouse_opacity = 2

		Click()
			..()
			var/mob/Player/p = usr
			if(p.questBookOpen)
				p.questBookOpen = FALSE
				winshow(p, "Quests", 0)
			else
				p.questBookOpen = TRUE
				p.buildQuestBook()

		alpha = 110
		MouseEntered()
			alpha = 255
		MouseExited()
			alpha = 110

	monsterbook
		name        = "Monster Book"
		icon        = 'Books.dmi'
		icon_state  = "monsters"

		anchor_x    = "EAST"
		screen_x    = -4
		screen_y    = -112
		anchor_y    = "NORTH"

		mouse_opacity = 2

		Click()
			..()
			var/mob/Player/p = usr
			if(p.monsterBookOpen)
				p.monsterBookOpen = FALSE
				winshow(p, "Monsters", 0)
			else
				p.monsterBookOpen = TRUE
				p.buildMonsterBook()

		alpha = 110
		MouseEntered()
			alpha = 255
		MouseExited()
			alpha = 110

	holster
		name        = "Holster"
		icon        = 'Season_bracelet.dmi'
		icon_state  = "inactive"

		anchor_x    = "EAST"
		screen_x    = -4
		screen_y    = -176
		anchor_y    = "NORTH"

		mouse_opacity = 2

		Click()
			var/mob/Player/p = usr

			if(!p.holster.colors) return

			var/hudobj/color_pick/o = locate() in p.client.screen
			if(o)
				for(var/hudobj/color_pick/c)
					c.hide()
			else
				var/offset = -36
				for(var/c in p.holster.colors)

					var/list/params = list("screen_x" = offset, "color" = c == "blood" ? "#a00" : c)

					new /hudobj/color_pick (null, p.client, params, 1)

					offset -= 32

				if(p.holster.colors.len > 1)

					var/list/params = list("screen_x" = offset, "icon_state" = "random")

					new /hudobj/color_pick (null, p.client, params, 1)


		alpha = 110
		MouseEntered()
			alpha = 255
		MouseExited()
			alpha = 110

	color_pick
		name        = "Pick Color"
		icon        = 'Colors.dmi'
		icon_state  = "pick"

		anchor_x    = "EAST"
		screen_x    = -36
		screen_y    = -176
		anchor_y    = "NORTH"

		mouse_opacity = 2

		alpha = 255

		MouseEntered()
			transform *= 1.25
		MouseExited()
			transform = null

		Click()
			var/mob/Player/p = usr

			if(!color)
				p.holster.projColor = "random"
				p << infomsg("Random color selected.")
				return
			else if(color == "#a00")
				p.holster.projColor = "blood"
			else
				p.holster.projColor = color

			p << infomsg("New <span style=\"color:[color];\">magical color</span> selected.")

	reading
		icon_state         = "reading"
		mouse_over_pointer = MOUSE_INACTIVE_POINTER

		anchor_x    = "WEST"
		screen_x    = 240
		screen_y    = -44
		anchor_y    = "NORTH"

	Timer
		icon = 'HUD.DMI'
		icon_state = "cdr"

		anchor_x    = "CENTER"
		anchor_y    = "CENTER"

		maptext_width = 128
		maptext_x = 32

		screen_x = -32
		screen_y = 128

obj/background
	icon = 'black50.dmi'
	color = "#000"
	appearance_flags = RESET_TRANSFORM|PIXEL_SCALE

	New(atom/Loc,x,y)
		if(!Loc) return
		var/matrix/m = matrix()
		m.Scale(x,y)
		m.Translate((x - 1) * 16, (y - 1) * -16)
		transform = m
		Loc.underlays += src

		loc = null

