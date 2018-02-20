
#define TILE_WIDTH 32
#define TILE_HEIGHT 32
#define MAX_VIEW_TILES 2000
#define HUD_LAYER 10

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

		show()
			updatePos()
			alpha = 0
			animate(src, alpha = 255, time = 5)
			client.screen += src

		hide()
			set waitfor = 0
			animate(src, alpha = 0, time = 5)
			sleep(6)
			if(client)
				client.screen -= src

	New(loc=null,client/Client,list/Params,show=1)
		client = Client
		for(var/v in Params)
			vars[v] = Params[v]
		if(show) show()

client
	var
		view_width
		view_height
		buffer_x
		buffer_y
		map_zoom

		browser_loaded = 0
	verb
		onLoad()
			set hidden = 1
			browser_loaded = 1
		//	src << output(null,"browser1:CenterWindow")
			src << output(null,"browser1:Resize")

			if(isplayer(mob)) // if mapbrowser loaded after login()
				src << output(null,"browser1:Login")

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

	proc
		initMapBrowser()
			set waitfor = 0
			while(!browser_loaded)
				src << browse('mapbrowser.html',"window=browser1")
				sleep(40)

hudobj
	icon               = 'HUD.dmi'
	mouse_over_pointer = MOUSE_HAND_POINTER
	appearance_flags   = NO_CLIENT_COLOR
	plane              = 2

	teleport
		name       = "Teleport Back"
		icon_state = "teleport"
		anchor_x   = "EAST"
		screen_x   = -48
		screen_y   = -16
		anchor_y   = "NORTH"

		mouse_opacity = 2

		var
			dest
			cost = 1

		Click()
			var/mob/Player/p = usr
			if(alpha == 0) return
			if(!color)
				color = "#0f0"
				p << infomsg("Click again to confirm, this will teleport you back and cost [cost] teleport crystal[cost > 1 ? "s" : ""].")
			else
				var/obj/items/magic_stone/teleport/t = locate() in p

				if(!t)
					p << errormsg("You don't have [cost] teleport crystal[cost > 1 ? "s" : ""] to teleport back.")
					return

				if(t.Consume())
					p.Resort_Stacking_Inv()

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
		screen_x    = -16
		screen_y    = -16
		anchor_y    = "NORTH"

		mouse_opacity = 2

		Click()
			var/mob/Player/M = usr
			M.PMHome()


	spellbook

		icon_state = "spellbook"

		anchor_x   = "EAST"
		screen_x   = -16
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
				winshow(p, "SpellBook", 1)

			p.toggle_actionbar(p.spellBookOpen)


	questbook
		name        = "Quest Book"
		icon_state  = "questbook"

		anchor_x    = "EAST"
		screen_x    = -16
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

	reading
		icon_state         = "reading"
		mouse_over_pointer = MOUSE_INACTIVE_POINTER

		anchor_x    = "WEST"
		screen_x    = 240
		screen_y    = -44
		anchor_y    = "NORTH"

	potion
		icon_state         = "potions"
		mouse_over_pointer = MOUSE_INACTIVE_POINTER

		anchor_x    = "WEST"
		screen_x    = 208
		screen_y    = -44
		anchor_y    = "NORTH"
