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

			MouseDrop(over_object)
				if(parent.UsedKeys && parent.UsedKeys[key])
					var/swap
					if(istype(over_object, /obj/actionbar/keys/))
						var/obj/actionbar/keys/k = over_object

						swap = parent.UsedKeys[k.key]

						k.SetKey(parent.UsedKeys[key], icon_state)
					if(!swap)
						winset(parent, "[key]Rep", "parent=")
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

				SetKey(obj/a)
					overlays = null
					if(!a)
						if(parent.UsedKeys && (key in parent.UsedKeys))
							parent.UsedKeys -= key

							if(!parent.UsedKeys.len) parent.UsedKeys = null

							if(!parent.displayActionbar)
								invisibility = 10
					else
						var/origLayer = a.layer
						a.layer = layer + 1
						mouse_drag_pointer = a
						overlays += a
						a.layer = origLayer

						if(!parent.UsedKeys) parent.UsedKeys = list()
						parent.UsedKeys[key] = a

						if(istype(a, /obj/spells))
							var/m = replace(a.name, " ", "-")
							winset(parent, "[key]Rep", "parent=macro;name=\"[key]+REP\";command=\"[m]\"")
						else
							winset(parent, "[key]Rep", "parent=macro;name=\"[key]+REP\";command=\"keyPress [key]\"")


mob/Player
	var
		tmp/displayActionbar = FALSE
		tmp/list/UsedKeys

	proc
		removeKey(var/k)
			for(var/obj/actionbar/keys/o in client.screen)
				if(o.key == k)
					o.SetKey()
					break

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
	New()
		..()
		mouse_drag_pointer = src

	MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
		..()
		if(istype(over_object, /obj/actionbar/keys) && (src in usr))
			var/obj/actionbar/keys/k = over_object
			k.SetKey(src)

	Write()
		var/pointer = mouse_drag_pointer
		mouse_drag_pointer = null
		..()
		mouse_drag_pointer = pointer

