/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
//The 10 actionbarboxes must always be the first 10 elements in /mob/You/Player/HUD
HUDelement
	parent_type = /obj
	icon = 'HUD.dmi'
	layer = 10
	actionbarbox
		icon_state = "actionbarbox"
		screen_loc = "10,1"
		mouse_opacity = 2
		invisibility = 101
		var/obj/action //Contains the Spell/Potion/etc. to be activated when clicked on
		Click()
			if(action)
				action.Click()
		MouseDrop(HUDelement/actionbarbox/over_object)
			var/mob/You/Player/M = usr
			if(M.HUDLocked) return
			if(istype(over_object,/HUDelement/actionbarbox))
				over_object.overlays = list(src.action)
				over_object.action = src.action
				src.overlays = null
				src.action = null
mob
	You/Player
		var
			list/HUD = list()
			tmp/HUDLocked = 1
		Login()
			..()
			if(HUD.len)
				//Readd HUD contents to client's screen
				src.client.screen = src.HUD
			else createHUD()
			lockHUD()
		proc
			createHUD()
				var/xpos = round(17 / 2) - 4 //x-position of first box
				var/HUDelement/actionbarbox/elem
				for(var/i=1;i<10;i++)
					elem = new()
					elem.screen_loc = "[++xpos],1"
					elem.icon_state = "actionbarbox[i]"
					src.HUD += elem
				src.client.screen = HUD
			unlockHUD()
				//Allows editing of HUD and shows empty boxes
				var/HUDelement/actionbarbox/elem
				for(elem in src.HUD)
					if(istype(elem,/HUDelement/actionbarbox))
						elem.invisibility = 0
				var/Spell/S
				for(S in src.Spells)
					//Enables mouse icon change when dragged
					S.mouse_drag_pointer = S
				src.HUDLocked = 0
			lockHUD()
				//Prevents editing of HUD and hides empty boxes
				var/HUDelement/actionbarbox/elem
				for(elem in src.HUD)
					if(istype(elem,/HUDelement/actionbarbox))
						if(elem.action)
							//Hide if no attached spell/item/etc
							elem.invisibility = 0
						else
							elem.invisibility = 101
				var/Spell/S
				for(S in src.Spells)
					//Prevents mouse icon change when dragged
					S.mouse_drag_pointer = MOUSE_INACTIVE_POINTER
				src.HUDLocked = 1
		verb
			macroActionbar(N as num)
				if(N == 0)N = 10 //Compensate for 0 key being the 10th element in the HUD /list
				var/HUDelement/actionbarbox/box = src.HUD[N]
				if(box && istype(box,/HUDelement/actionbarbox))
					if(box.action)
						box.Click()