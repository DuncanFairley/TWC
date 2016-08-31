/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

hudobj
	actionbar
		icon_state = "actionbarbox"

		keys
			var
				key
				mob/Player/parent

			Click()
				Do()

			MouseDrop(over_object)
				if(parent.UsedKeys && parent.UsedKeys[key])
					var/swap
					if(istype(over_object, /hudobj/actionbar/keys/))
						var/hudobj/actionbar/keys/k = over_object

						swap = parent.UsedKeys[k.key]

						k.SetKey(parent.UsedKeys[key], icon_state)
					if(!swap)
						winset(parent, "[key]Rep", "parent=")
					SetKey(swap)

			proc
				invisible()
					animate(src, alpha = 0, time = 5)
					mouse_opacity = 0
				visible()
					animate(src, alpha = 255, time = 5)
					mouse_opacity = 1
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
								invisible()
					else
						var/origLayer = a.layer
						a.layer = layer + 1
						a.plane = plane
						mouse_drag_pointer = a
						overlays += a
						a.layer = origLayer

						if(!parent.UsedKeys) parent.UsedKeys = list()
						parent.UsedKeys[key] = a

						if(istype(a, /obj/spells))
							var/m = replacetext(a.name, " ", "-")
							winset(parent, "[key]Rep", "parent=macro;name=\"[key]+REP\";command=\"[m]\"")
						else
							winset(parent, "[key]Rep", "parent=macro;name=\"[key]+REP\";command=\"keyPress [key]\"")


mob/Player
	var
		tmp/displayActionbar = FALSE
		tmp/list/UsedKeys

	proc
		removeKey(var/k)
			for(var/hudobj/actionbar/keys/o in client.screen)
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

				var/hudobj/actionbar/keys/A = new (null, client, list(anchor_x = "CENTER", anchor_y = "SOUTH", screen_x = (count - offset)*32), show=1)

				A.key = "[i]"
				A.maptext = "<span style=\"font-size:1; color:#800000;\">[i]</span>"
				A.parent = src

				if(UsedKeys && UsedKeys[A.key])
					A.SetKey(UsedKeys[A.key])
				else A.invisible()

		toggle_actionbar(on=0)
			if(displayActionbar == on) return

			if(on)
				displayActionbar = TRUE
				for(var/hudobj/actionbar/keys/k in client.screen)
					if(k.alpha == 0) k.visible()
			else
				displayActionbar = FALSE
				for(var/hudobj/actionbar/keys/k in client.screen)
					if(!(k.key in UsedKeys) && alpha == 255) k.invisible()

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
		if(istype(over_object, /hudobj/actionbar/keys) && (src in usr))
			var/hudobj/actionbar/keys/k = over_object
			k.SetKey(src)

	Write()
		var/pointer = mouse_drag_pointer
		mouse_drag_pointer = null
		..()
		mouse_drag_pointer = pointer

