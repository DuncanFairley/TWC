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
				item.slot = null
				item.sx = null
				item.sy = null
				item.screen_loc = null
				if(item.screen_loc) Client.screen -= item
				item = null

				mouse_drag_pointer = MOUSE_INACTIVE_POINTER
				mouse_over_pointer = MOUSE_INACTIVE_POINTER

	MouseDrop(over_object,src_location,over_location,src_control,over_control,params)

		if(item)
			item.MouseDrop(over_object,src_location,over_location,src_control,over_control,params)

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

	//	var/backpack/tmpHover = usr.client.lastHover

	//	sleep(10)
//		if(usr.client.lastHover == tmpHover)
//			usr.client.lastHover.icon_state = "grid"
	//		usr.client.lastHover = null

//		icon_state = "grid"


obj/items/var/tmp/backpack/slot
obj/items/var/sx
obj/items/var/sy

client/var/tmp/backpack/lastHover

mob/Player

	var/tmp/list/backpack[15][15]

	proc/buildBackpack()
		var/const/size = 15

	//	backpack[size][size] = new

		var/list/colorList

		if(backColor != "#f0f0f0") colorList = list(backColor, backColor, backColor)

		for(var/r = 1 to size)
			for(var/c = 1 to size)
				var/backpack/b = new
				b.c = c
				b.r = r
				if(colorList) b.color = colorList
				backpack[c][r] = b
				b.screen_loc = "backpack:[c],[r]"
				b.Client = client
				client.screen += b

		for(var/obj/items/i in contents)
			var/backpack/b
			if(i.sx && i.sx <= size && i.sy <= size)
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
		var/const/size = 15
		for(var/r = size to 1 step -1)
			for(var/c = 1 to size)
				var/backpack/b = backpack[c][r]
				if(!b.item) return b