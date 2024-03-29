

obj/minimap

	plane = 3
	appearance_flags = NO_CLIENT_COLOR|PIXEL_SCALE
	blend_mode = BLEND_OVERLAY

	plane
		screen_loc = "EAST-3,SOUTH+1"
		appearance_flags = PLANE_MASTER|NO_CLIENT_COLOR|PIXEL_SCALE

	visible
		blend_mode = BLEND_ADD
		icon = 'newMinimap.dmi'
		icon_state="black"

	player
		layer = 5
		icon = 'minimapDots.dmi'
		icon_state="player"
		pixel_x = 50
		pixel_y = 50
		mouse_opacity = 0

	dot
		layer = 5
		icon = 'minimapDots.dmi'
		icon_state="path"
		blend_mode = BLEND_INSET_OVERLAY
		pixel_x = -50
		pixel_y = -50
		mouse_opacity = 0
	enemy
		layer = 5
		icon = 'minimapDots.dmi'
		icon_state="enemy"
		blend_mode = BLEND_INSET_OVERLAY
		pixel_x = -50
		pixel_y = -50
		mouse_opacity = 0
	questMarker
		layer = 5
		icon = 'minimapQuestMarkers.dmi'
		icon_state="nonactive"
		blend_mode = BLEND_INSET_OVERLAY
		mouse_opacity = 0
		pixel_x = -50
		pixel_y = -50

	minimap
		icon = 'newMinimap.dmi'
		blend_mode = BLEND_INSET_OVERLAY
		layer=4
		screen_loc = "EAST-3,SOUTH+1"

	Click(location,control,params)

		var/list/prms = params2list(params)

		var/turf/t = locate(text2num(prms["icon-x"]),text2num(prms["icon-y"]), usr.z)
		if(t.density || t.skip) return

		var/mob/Player/p = usr

		p.pathTo(t)


hudobj
	MinimapView
		name       = "Minimap View"
		icon_state = "Treasure Hunting"
		anchor_x    = "EAST"
		screen_x    = -4
		screen_y    = 16
		anchor_y    = "SOUTH"

		mouse_opacity = 2

		alpha = 110
		MouseEntered()
			alpha = 255
		MouseExited()
			alpha = 110

		verb/Hide()
			set src in usr.client.screen

			var/mob/Player/p = usr

			p.miniMapMode = 0
			p.client.screen -= p.minimapPlane
			p.client.screen -= p.map


		Click()
			var/mob/Player/p = usr

			if(p.miniMapMode == 1)
				p.minimapPlane.screen_loc = "CENTER-1,CENTER-1"
				p.map.screen_loc = "CENTER-1,CENTER-1"
				p.minimapPlane.transform = matrix() * 3
				p.miniMapMode = 2
			else
				if(p.miniMapMode == 0)
					p.client.screen += p.minimapPlane
					p.client.screen += p.map

				p.minimapPlane.screen_loc = "EAST-3,SOUTH+1"
				p.map.screen_loc = "EAST-3,SOUTH+1"
				p.minimapPlane.transform = null
				p.miniMapMode = 1

mob/test/verb/zoomMinimap(var/z as num)

	var/mob/Player/p = src

	p.zoomFactor = z

	var/matrix/m = matrix()
	m.Translate(50 - x, 50 - y)
	m.Scale(p.zoomFactor, p.zoomFactor)

	p.map.transform = m

	if(p.miniMapMode)
		p.minimapPlane.screen_loc = "EAST-4,NORTH-4"
		p.map.screen_loc = "EAST-4,NORTH-4"
		p.minimapPlane.transform = null
	else
		p.minimapPlane.screen_loc = "CENTER-1,CENTER-1"
		p.map.screen_loc = "CENTER-1,CENTER-1"
		p.minimapPlane.transform = matrix() * 3

	p.miniMapMode = !p.miniMapMode

//	var/offset = 4 + round((100 * (z - 1)) / 12, 1)

//	p.minimapPlane.screen_loc = "EAST-[offset],NORTH-[offset]"
//	p.map.screen_loc = "EAST-[offset],NORTH-[offset]"


mob/Player

	var/tmp/obj/minimap/minimap/map
	var/tmp/obj/minimap/plane/minimapPlane
	var/zoomFactor = 2
	var/miniMapMode = 1

	proc/initMinimap()
		minimapPlane = new
		minimapPlane.overlays += /obj/minimap/visible
		minimapPlane.overlays += /obj/minimap/player

		map = new

		var/area/a = loc.loc
		if(a.region)
			map.icon_state = a.region.name

		var/matrix/m = matrix()
		m.Translate(50 - x, 50 - y)
		m.Scale(zoomFactor, zoomFactor)

		map.transform = m


	//	client.screen += minimapPlane
	//	client.screen += map

		if(miniMapMode)
			miniMapMode = 1
			client.screen += minimapPlane
			client.screen += map


	Move()
		.=..()

		if(map)

			var/matrix/m = matrix()
			m.Translate(50 - x, 50 - y)
			m.Scale(zoomFactor, zoomFactor)

			map.transform = m