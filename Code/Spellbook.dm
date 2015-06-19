mob/Player
	var/tmp
		spellBookOpen = FALSE
		list/spells
	verb
		spellBookClosed()
			set name= ".spellBookClosed"
			spellBookOpen = 0
			toggle_actionbar(0)

	proc

		saveSpells()
			if(!UsedKeys) return

			for(var/k in UsedKeys)
				if(istype(UsedKeys[k], /obj/spells))
					var/obj/spells/s = UsedKeys[k]

					if((s.path in verbs) || !s.path)
						UsedKeys[k] = s.name
					else
						UsedKeys -= k

		loadSpells()

			client.screen += new/obj/hud/spellbook

			if(!UsedKeys || !spells) return

			for(var/k in UsedKeys)
				var/o = UsedKeys[k]
				if(istext(o))
					UsedKeys[k] = spells[o]

		updateSpellbook()

			var/list/s = list("Meditate",
							  /mob/Spells/verb/Aqua_Eructo,
							  /mob/Spells/verb/Chaotica,
							  /mob/Spells/verb/Episky,
							  /mob/Spells/verb/Flippendo,
							  /mob/Spells/verb/Glacius,
							  /mob/Spells/verb/Incendio,
							  /mob/Spells/verb/Incindia,
							  /mob/Spells/verb/Inflamari,
							  /mob/Spells/verb/Tremorio,
							  /mob/Spells/verb/Waddiwasi)

			if(!spells) spells = list()
			var/count = spells.len
			for(var/spell in s)
				if(istext(spell))
					if(!(spell in spells))
						count++
						var/obj/spells/o = new
						o.name       = spell
						o.icon_state = o.selectState()

						spells[spell] = o

						src << output(o, "SpellBook.gridSpellbook:[count]")

				else if(spell in verbs)
					var/spellName = spellList[spell]
					if(!(spellName in spells))
						count++
						var/obj/spells/o = new

						o.name       = spellName
						o.icon_state = o.selectState()
						o.path       = spell

						spells[spellName] = o

						src << output(o, "SpellBook.gridSpellbook:[count]")


obj/spells
	icon = 'Attacks.dmi'

	var/path
	var/obj/actionbar/key/macro

	proc/selectState()
		if(name == "Glacius")     return "iceball"
		if(name == "Waddiwasi")   return "gum"
		if(name == "Aqua Eructo") return "aqua"
		if(name == "Flippendo")   return "flippendo"
		if(name == "Tremorio")    return "quake"
		if(name == "Chaotica")    return "black"
		if(name == "Meditate")    return "meditate"
		if(name == "Episkey")     return "episkey"
		return "fireball"


	Click()
		var/mob/m = usr
		if(path && !(path in m.verbs))
			if(m:spells && (src in m:spells))
				m:spells -= src
				return
			if(m:UsedKeys)
				for(var/k in m:UsedKeys)
					var/obj/o = m:UsedKeys[k]
					if(o == src)
						m:UsedKeys -= k
		switch(name)
			if("Glacius")
				m:Glacius()
			if("Inflamari")
				m:Inflamari()
			if("Waddiwasi")
				m:Waddiwasi()
			if("Flippendo")
				m:Flippendo()
			if("Incindia")
				m:Incindia()
			if("Incendio")
				m:Incendio()
			if("Tremorio")
				m:Tremorio()
			if("Aqua Eructo")
				m:Aqua_Eructo()
			if("Chaotica")
				m:Chaotica()
			if("Meditate")
				m.Meditate()
			if("Episkey")
				m:Episky()

	MouseDrag()
		usr.client.mouse_pointer_icon = icon(icon,icon_state)

	MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
		..()
		usr.client.mouse_pointer_icon = 'pointer.dmi'
		if(istype(over_object, /obj/actionbar/keys))
			var/obj/actionbar/keys/k = over_object
			k.SetKey(src)

obj/hud/spellbook

	icon = 'HUD.dmi'
	icon_state = "spellbook"
	screen_loc = "EAST-2,1"
	mouse_over_pointer = MOUSE_HAND_POINTER

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
