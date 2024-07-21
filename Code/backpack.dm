backpack
	icon = 'grid.dmi'
	icon_state = "grid"
	parent_type = /obj

	mouse_opacity = 2


	var
		c
		r
		obj/items/item
		client/Client

	proc
		place(obj/items/i)

			if(i)
				item = i
				item.slot = src
				if(item.screen_loc) Client.screen -= item
				item.sx = c
				item.sy = r
				item.screen_loc = "backpack:[c],[r]"
				Client.screen += item

				mouse_drag_pointer = item
				mouse_over_pointer = MOUSE_HAND_POINTER
			else
				if(item)
					icon_state = "grid"
					item.slot = null
					item.sx = null
					item.sy = null
					Client.screen -= item
					item.screen_loc = null
					item = null

					mouse_drag_pointer = MOUSE_INACTIVE_POINTER
					mouse_over_pointer = MOUSE_INACTIVE_POINTER

	MouseDrop(over_object,src_location,over_location,src_control,over_control,params)

		if(item)
			item.MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
		if(over_object != src)
			icon_state = "grid"

	Click(location,control,params)
		if(item)
			item.Click(location,control,params)
	DblClick(location,control,params)
		if(item)
			item.DblClick(location,control,params)
	MouseEntered(location,control,params)
		if(item)
			item.MouseEntered(location,control,params)
		else
			icon_state = "grid_highlight"

//		if(usr.client.lastHover != src)
//			icon_state = "grid_highlight"

//			if(usr.client.lastHover)
//				usr.client.lastHover.icon_state = "grid"
//			usr.client.lastHover = src
//		icon_state = "grid_highlight"
//		lastHover = src
	MouseExited(location,control,params)
		if(item)
			item.MouseExited(location,control,params)
		else
			icon_state = "grid"


obj/items/var/tmp/backpack/slot
obj/items/var/sx
obj/items/var/sy
obj/items/var/ignoreBackpack = 0

mob/Player

	var/tmp/list/backpack[BACKPACK_COLS][BACKPACK_ROWS]

	proc/buildBackpack()

	//	backpack[size][size] = new

//		var/list/colorList

	//	colorList = list(backColor, backColor, backColor)
		var/ColorMatrix/cm = new(backColor, 0.75)

		for(var/r = 1 to BACKPACK_ROWS)
			for(var/c = 1 to BACKPACK_COLS)
				var/backpack/b = new
				b.c = c
				b.r = r
				b.color = cm.matrix
				backpack[c][r] = b
				b.screen_loc = "backpack:[c],[r]"
				b.Client = client
				client.screen += b

		for(var/obj/items/i in contents)
			if(i.ignoreBackpack) continue
			var/backpack/b
			if(i.sx && i.sx <= BACKPACK_COLS && i.sy <= BACKPACK_ROWS)
				b = backpack[i.sx][i.sy]
				if(b.item)
					b = findSlot()
			else
				b = findSlot()

			if(b)
				b.place(i)
			else
				break

	proc/findSlot()
		for(var/r = BACKPACK_ROWS to 1 step -1)
			for(var/c = 1 to BACKPACK_COLS)
				var/backpack/b = backpack[c][r]
				if(!b.item) return b