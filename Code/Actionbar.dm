obj
	actionbar
		layer = 10

		icon       = 'HUD.dmi'
		icon_state = "actionbarbox"

		keys
			var
				key
				mob/Player/parent

			New(loc,pos)
				..()
				screen_loc = pos

			Click()
				Do()
			MouseDrag()
				if(parent.UsedKeys && (key in parent.UsedKeys))
					var/obj/o = parent.UsedKeys[key]
					usr.client.mouse_pointer_icon = icon(o.icon, o.icon_state)
			MouseDrop(over_object)
				if(parent.UsedKeys && parent.UsedKeys[key])
					usr.client.mouse_pointer_icon = 'pointer.dmi'
					var/swap
					if(istype(over_object, /obj/actionbar/keys/))
						var/obj/actionbar/keys/k = over_object

						swap = parent.UsedKeys[k.key]

						k.SetKey(parent.UsedKeys[key], icon_state)
					SetKey(swap)


			proc

				Do()
					if(!parent.UsedKeys) return

					var/action = parent.UsedKeys[key]
					if(action)
						if(isobj(action))
							var/obj/o = action
							usr=parent
							o.Click()

				SetKey(a)
					overlays = null
					if(!a)
						if(parent.UsedKeys && (key in parent.UsedKeys))
							parent.UsedKeys -= key

							if(!parent.UsedKeys.len) parent.UsedKeys = null

							if(!parent.displayActionbar)
								invisibility = 10
					else
						if(isobj(a))
							var/obj/o = a
							var/origLayer = o.layer
							o.layer = layer + 1
							overlays += o
							o.layer = origLayer

						if(!parent.UsedKeys) parent.UsedKeys = list()
						parent.UsedKeys[key] = a

mob/Player
	var
		tmp/displayActionbar = FALSE
		list/UsedKeys

	proc

		buildActionBar()
			updateSpellbook()
			loadSpells()
			var/list/ActionKeys = list("1","2","3","4","5","6","7","8","9","0","-","=")
			var/count = 0
			var/offset = round(ActionKeys.len/2)
			for(var/i in ActionKeys)
				count++
				var/obj/actionbar/keys/A = new (pos="CENTER+[count]-[offset],1")
				A.key = "[i]"
				A.maptext = "<font size=1 color=#800000>[i]</font>"
				A.parent = src
				client.screen+=A
				if(UsedKeys && UsedKeys[A.key])
					A.SetKey(UsedKeys[A.key])
				else A.invisibility = 10

				winset(src, "[i]Rep", "parent=macro;name=\"[i]+REP\";command=\"keyPress [i]\"")

		toggle_actionbar(on=0)
			if(displayActionbar == on) return

			if(on)
				displayActionbar = TRUE
				for(var/obj/actionbar/keys/k in client.screen)
					k.invisibility = 0
			else
				displayActionbar = FALSE
				for(var/obj/actionbar/keys/k in client.screen)
					if(!(k.key in UsedKeys)) k.invisibility = 10

	verb
		keyPress(k as text)
			set hidden  = 1
			if(!UsedKeys) return

			var/action = UsedKeys[k]
			if(action)
				if(isobj(action))
					var/obj/o = action
					usr=src
					o.Click()

obj/items

	MouseDrag()
		..()
		usr.client.mouse_pointer_icon = icon(icon,icon_state)

	MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
		..()
		usr.client.mouse_pointer_icon = 'pointer.dmi'
		if(istype(over_object, /obj/actionbar/keys))
			var/obj/actionbar/keys/k = over_object
			k.SetKey(src)

