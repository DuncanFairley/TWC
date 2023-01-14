mob/Player/var
	list
		Lwearing
		Lfavorites
	tmp
		monsterDmg = 0
		monsterDef = 0
		dropRate   = 0
		extraLimit = 0
		noOverlays = 0
		Armor     = 0


area
	var
		antiTheft     = FALSE
		antiTeleport  = FALSE
		antiFly       = FALSE
		antiEffect    = FALSE
		antiSpellbook = FALSE
		antiPet       = FALSE
		antiAnimagus  = FALSE
		antiSummon    = FALSE
		antiMask      = FALSE
		antiCloak     = FALSE
		antiPotion    = FALSE

	arenas
		antiFly       = TRUE
		antiTeleport  = TRUE
		antiEffect    = TRUE
		antiSpellbook = TRUE
		antiPet       = TRUE
		antiAnimagus  = TRUE
		antiSummon    = TRUE
		antiMask      = TRUE
		antiCloak     = TRUE
		antiPotion    = TRUE
	hogwarts
		antiMask      = TRUE

	inside
		antiTheft
			antiTheft = TRUE
			antiFly   = TRUE
		antiTeleport
			antiTeleport = TRUE
			antiFly      = TRUE

	Entered(atom/movable/Obj,atom/OldLoc)
		.=..()
		if(isplayer(Obj))
			var/mob/Player/p = Obj
			if(antiFly)
				p.nofly()

			if(antiEffect && ((p.passives && p.passives.len) || p.monsterDmg || p.monsterDef || p.dropRate || p.extraLimit || p.extraCDR))
				var/obj/items/wearable/sword/s = locate() in p.Lwearing
				if(s) s.Equip(p, 1)

				var/obj/items/wearable/ring/r = locate() in p.Lwearing
				if(r) r.Equip(p, 1)

				var/obj/items/wearable/shield/i = locate() in p.Lwearing
				if(i) i.Equip(p, 1)

				if(worldData.passives) p.passives = null
			else if(!antiEffect && worldData.passives && !p.passives)

				p.passives = list()
				for(var/e in worldData.passives)
					p.passives[e] += 1

			if(antiSpellbook)
				if(p.usedSpellbook) p.usedSpellbook.Equip(p, 1)

			if(antiPet && p.pet)
				p.pet.item.Equip(p,1)

			if(antiAnimagus && p.animagusOn)
				if(p.noOverlays > 0)
					p.noOverlays--

				var/hudobj/Animagus/a = locate() in p.client.screen
				a.color = null

				p.AnimagusRecover(a)
				p.BaseIcon()
				flick("transfigure", p)
				p.ApplyOverlays()

			if(antiCloak && p.alpha < 255)
				var/obj/items/wearable/invisibility_cloak/Cloak = locate() in p.Lwearing
				if(Cloak) Cloak.Equip(p,1)

			if(antiPotion && p.LStatusEffects)
				var/StatusEffect/Potions/pot = locate() in p.LStatusEffects
				if(pot)
					pot.Deactivate(0)

			if(antiSummon && p.Summons)
				for(var/obj/summon/s in p.Summons)
					s.Dispose()

			if(antiMask && p.prevname)

				var/obj/items/wearable/masks/m = locate() in p.Lwearing
				if(m) m.Equip(p, 1)


obj/items
	var
		dropable      = 1
		takeable      = 1
		destroyable   = 0
		price         = 0
		fetchable     = 1
		tmp/antiTheft = 0

		stack     = 1
		max_stack = 0
		rarity    = 1

	mouse_over_pointer = MOUSE_HAND_POINTER

	New()
		..()

//		if(!loc) return
		Sort()

		if(isplayer(loc) && !slot)
			var/mob/Player/p = loc
			var/backpack/b = p.findSlot()
			if(b)
				b.icon_state = "grid_new"
				b.place(src)

/*		var/T
		if(useTypeStack == 0)
			T = type
		else if(useTypeStack == 1)
			T = parent_type
		else
			T = useTypeStack

		if(Sort(loc))
			var/mob/Player/p = loc
			if(p.stackobjects && p.stackobjects[T])
				var/obj/stackobj/stackObj = p.stackobjects[T]
				stackObj.count += stack
				stackObj.suffix = "<span style=\"color:red;\">(x[stackObj.count])</span>"
		else
			if(isplayer(loc))
				var/mob/Player/p = loc

				var/obj/stackobj/stackObj

				if(p.stackobjects && p.stackobjects[T])
					stackObj = p.stackobjects[T]

				if(!stackObj)
					var/list/items = list()
					var/c = 0
					for(var/obj/items/same in p)
						if(same.useTypeStack == useTypeStack && (useTypeStack > 1 || istype(same, T)))
							items += same
							c += same.stack

					if(items.len > 0)
						stackObj = new
						var/obj/tmpV = new T
						stackObj.containstype = T
						stackObj.icon = tmpV.icon
						stackObj.icon_state = tmpV.icon_state
						stackObj.name = tmpV.stackName ? tmpV.stackName : tmpV.name
						stackObj.loc = p
						stackObj.contains = items
						stackObj.suffix = "<span style=\"color:red;\">(x[c])</span>"

						if(!p.stackobjects)
							p.stackobjects = list()
						p.stackobjects[T] = stackObj
				else
					stackObj.contains += src
					stackObj.count += stack
					stackObj.suffix = "<span style=\"color:red;\">(x[stackObj.count])</span>"*/


	Move(NewLoc,Dir=0)
//		var/T
//		if(useTypeStack == 0)
//			T = type
//		else if(useTypeStack == 1)
//			T = parent_type
//		else
//			T = useTypeStack

		if(isplayer(loc) && loc != NewLoc)

			var/mob/Player/p = loc

			Unmacro(p)

			if(p.Lfavorites && (src in p.Lfavorites))
				p.Lfavorites -= src
				if(p.Lfavorites.len == 0) p.Lfavorites = null

			if(slot)
				slot.place(null)

/*			if(p.stackobjects && p.stackobjects[T])
				var/obj/stackobj/stackObj = p.stackobjects[T]
				stackObj.contains -= src
				stackObj.count -= stack
				if(stackObj.contains.len > 0)
					stackObj.suffix = "<span style=\"color:red;\">(x[stackObj.count])</span>"
				else
					stackObj.loc = null
					p.stackobjects -= stackObj
					if(!p.stackobjects.len)
						p.stackobjects = null*/

		.=..()

		Sort()

		if(loc && isplayer(loc))
			var/mob/Player/p = loc
			var/backpack/b = p.findSlot()
			if(b)
				b.icon_state = "grid_new"
				b.place(src)

//		if(!NewLoc)
//			loc = null
//			return

/*		if(Sort(NewLoc))
			var/mob/Player/p = loc
			if(p.stackobjects && p.stackobjects[T])
				var/obj/stackobj/stackObj = p.stackobjects[T]
				stackObj.count += stack
				stackObj.suffix = "<span style=\"color:red;\">(x[stackObj.count])</span>"

		else
			.=..()
			if(isplayer(loc))
				var/mob/Player/p = loc

				var/obj/stackobj/stackObj

				if(p.stackobjects && p.stackobjects[T])
					stackObj = p.stackobjects[T]

				if(!stackObj)
					var/list/items = list()
					var/c = 0
					for(var/obj/items/same in p)
						if(same.useTypeStack == useTypeStack && (useTypeStack > 1 || istype(same, T)))
							items += same
							c += same.stack

					if(items.len > 0)
						stackObj = new
						var/obj/tmpV = new T
						stackObj.containstype = T
						stackObj.icon = tmpV.icon
						stackObj.icon_state = tmpV.icon_state
						stackObj.name = tmpV.stackName ? tmpV.stackName : tmpV.name
						stackObj.loc = p
						stackObj.contains = items
						stackObj.suffix = "<span style=\"color:red;\">(x[c])</span>"

						if(!p.stackobjects)
							p.stackobjects = list()
						p.stackobjects[T] = stackObj
				else
					stackObj.contains += src
					stackObj.count += stack
					stackObj.suffix = "<span style=\"color:red;\">(x[stackObj.count])</span>"*/



	Dispose(sort=1)

		if(sort && isplayer(loc))

			var/mob/Player/p = loc

			Unmacro(p)

			if(p.Lfavorites && (src in p.Lfavorites))
				p.Lfavorites -= src
				if(p.Lfavorites.len == 0) p.Lfavorites = null

	/*		var/T
			if(useTypeStack == 0)
				T = type
			else if(useTypeStack == 1)
				T = parent_type
			else
				T = useTypeStack

			if(p.stackobjects && p.stackobjects[T])
				var/obj/stackobj/stackObj = p.stackobjects[T]

				stackObj.contains -= src
				stackObj.count -= stack
				if(stackObj.contains.len > 0)
					stackObj.suffix = "<span style=\"color:red;\">(x[stackObj.count])</span>"
				else
					stackObj.loc = null
					p.stackobjects -= stackObj
					if(!p.stackobjects.len)
						p.stackobjects = null*/

		loc = null

		if(slot)
			slot.place(null)


	MouseEntered(location,control,params)
		if((src in usr) && usr:infoBubble)
			winset(usr, null, "infobubble.labelTitle.text=\"[name]\";infobubble.labelInfo.text=\"[desc]\"")
			winshowRight(usr, "infobubble")

			if(slot)
				slot.icon_state = "grid_highlight"

	MouseExited(location,control,params)
		if(src in usr)
			winshow(usr, "infobubble", 0)

			if(slot)
				slot.icon_state = "grid"

	proc
		Sort()
			if(istype(loc, /atom))
				for(var/obj/items/i in loc)
					if(i != src && Compare(i))
						Stack(i)
						if(!loc) return 1

		Clone()
			var/obj/items/i = new type

			i.owner      = owner
			i.name       = name
			i.icon_state = icon_state

			return i

		Compare(obj/items/i)
			return i.name == name && i.type == type && i.owner == owner && i.icon_state == icon_state

		UpdateDisplay()
			if(stack > 1)
				suffix  = "<span style=\"color:#c00;\">(x[stack])</span>"
				maptext = "<span style=\"font-size:1; color:#c00;\"><b>[stack]</b></span>"
			else
				suffix  = null
				maptext = null

		Stack(obj/items/i)
			var/change
			if(max_stack)
				change = min(stack, i.max_stack - i.stack)
			else
				change = stack

			stack   -= change
			i.stack += change

			i.Refresh()

			if(stack <= 0)
				Dispose(0)
			else
				Refresh()

		Split(size)
			if(max_stack)
				size = min(size, max_stack)

			if(size)
				var/obj/items/i = Clone()

				i.stack = size
				stack  -= size

				i.Refresh()

				if(stack <= 0)
					Dispose()
				else
					Refresh()

				return i

			return null

		Consume(amount = 1)
			stack -= amount
			if(stack <= 0)
				Dispose()
				. = 1
			else
				UpdateDisplay()
				. = 0

		Refresh()
			UpdateDisplay()

			if(stack > 1 && dropable)
				verbs += new/obj/items/proc/Drop_All()
			else
				verbs -= new/obj/items/proc/Drop_All()

		drop(mob/Player/owner, amount = 1)

			if(owner.screen_text)
				owner.screen_text.Dispose()

			if(owner.splitSize || owner.splitItem)
				owner.splitSize = null
				owner.splitItem = null
				winset(owner, null, "splitStack.is-visible=false;")

			if(!loc || loc != owner) return

			var/obj/items/i = src
			if(stack > 1 && amount < stack)
				i = Split(amount)
				var/area/a = getArea(owner)
				if(a.antiTheft) i.owner = owner.ckey
				i.Move(owner.loc)
			else
				var/area/a = getArea(owner)
				if(a.antiTheft) src.owner = owner.ckey
				Move(owner.loc)

			if(!("ckeyowner" in i.vars) || !src:ckeyowner)
				var/obj/playerShop/stand/s = locate() in owner.loc
				if(s)
					var/playerShop/shop = worldData.playerShops[s.shopID]
					if(shop.owner == owner.ckey)
						if(!shop.items || !(s.standID in shop.items))
							i.price = -1
							s.add(i)
						else
							var/obj/items/shopItem = shop.items[s.standID]
							if(i.Compare(shopItem))
								i.Stack(shopItem)


		Unmacro(mob/Player/p)
			if(p.UsedKeys)
				for(var/k in p.UsedKeys)
					if(p.UsedKeys[k] == src)
						p.removeKey(k)
						break


		Drop_All()
			set src in usr

			hearers(usr) << infomsg("[usr] drops all of \his [src.name] items.")
			drop(usr, stack)

		prizeDrop(ownerCkey, protection=300, decay=TRUE)
			set waitfor = 0

			antiTheft = 1
			owner     = ownerCkey

			if(rarity != 0)
				var/c
				switch(rarity)
					if(1)
						c = "#0e0"
					if(2)
						c = "#00a5ff"
					if(3)
						c = "#ffa500"
					if(4)
						c = "#551a8b"
					if(5)
						c = "#660000"


				if(c)
					filters = filter(type="outline", size=1, color=c)

			sleep(protection)

			if(isturf(loc) && antiTheft)

				if(decay)
					Dispose()
				else
					antiTheft = 0
					owner = null
					filters = null

obj/items/Click()
	if((src in oview(1)) && takeable)
		Take()
	..()
obj/items/verb/Take()
	set src in oview(1)

	if((antiTheft || loc.loc:antiTheft) && owner && owner != usr.ckey)
		usr << errormsg("This item isn't yours, a charm prevents you from picking it up.")
		return

	var/amount = -1
	if(args.len == 1)
		amount = clamp(round(args[1]), 1, stack)

	var/obj/items/i = amount > 0 && amount < stack ? Split(amount) : src

	if(i.antiTheft)
		i.antiTheft = 0
		i.filters = null

	viewers() << infomsg("[usr] takes \the [name].")

	i.owner = null
	i.Move(usr)


obj/items/verb
	Drop()
		set src in usr
		hearers(usr) << infomsg("[usr] drops \his [src.name].")
		drop(usr, 1)

obj/items/MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
	var/default = 1
	if(src in usr)
		var/mob/Player/p = usr
		if(istype(over_object, /obj/favorites))

			if(!p.Lfavorites || !(src in p.Lfavorites))

				if(!p.Lfavorites)
					p.Lfavorites = list()
				p.Lfavorites += src
				p << infomsg("[name] added to favorites.")

			else if(src in p.Lfavorites)
				p.Lfavorites -= src

				if(p.Lfavorites.len == 0) p.Lfavorites = null

				p << infomsg("[name] removed from favorites.")
			default = 0
		if(istype(over_object, /backpack) || (istype(over_object, /obj/items/) && (over_object in usr)))
			var/backpack/b

			if(istype(over_object, /obj/items/))
				var/obj/items/i = over_object
				b = i.slot
			else
				b = over_object

			slot.icon_state = "grid"

			if(b.item)
				slot.place(b.item)
			else
				slot.place(null)

			b.place(src)

		else if(istype(over_object, /obj/items/) && (over_object in usr))
			var/list/C = usr.contents.Copy()
			C.Swap(usr.contents.Find(src),usr.contents.Find(over_object))
			usr.contents = C
			default = 0

		else if(isturf(over_object))
			default = 0
			if(dropable && destroyable)
				switch(alert("Do you wish to drop or destroy this item?","","Drop","Destroy","Cancel"))
					if("Drop")
						if(src in usr)Drop(usr)
					if("Destroy")
						if(src in usr)Destroy(usr)
			else if(dropable)
				if(stack > 1)
					var/s = usr:split(src, over_object)
					if(s)
						if(s > 1)
							hearers(owner) << infomsg("[usr] drops \his [name]x[s].")
						else
							hearers(owner) << infomsg("[usr] drops \his [name].")
						drop(usr, s)

				else
					Drop(usr)
			else if(destroyable)
				Destroy(usr)
		else if(dropable)
			if(p.pet && over_object == p.pet)

				var/area/a = p.loc.loc
				if(!a.region)
					p << errormsg("Your pet doesn't know how to get to the bank from here.")
					return

				if(p.pet.busy)
					p << errormsg("Your pet is busy right now.")
					return

				if(!p.addToVault)
					p.addToVault = list(src)
				else
					p.addToVault += src

				if(src in p.Lwearing)
					src:Equip(p,1,1)

				Dispose()


				p.pet.gotoBank(p)

				default = 0
	else
		if(stack > 1 && takeable && over_location == "Items" && (src in view(1, usr)))
			var/s = usr:split(src, over_object)
			if(s)
				Take(s)

	if(default)
		..()

mob/Player
	var/tmp
		obj/items/splitItem
		splitSize

	proc/split(obj/items/i_Item, loc)
		if(splitItem) return
		src << output("[i_Item.stack]","browser1:ShowSplitStack")
		splitItem = i_Item

		var/tmpLoc = i_Item.loc
		var/tmpAmount = i_Item.stack

		while(splitItem && i_Item.loc == tmpLoc && i_Item && splitItem == i_Item && tmpAmount == i_Item.stack)
			sleep(1)

		if(i_Item && splitItem == null && splitSize && i_Item.loc == tmpLoc && tmpAmount == i_Item.stack)
			var/s = splitSize
			splitSize = null
			return s
		return 0

	verb/splitStack()
		set hidden = 1
		winset(src, null, "splitStack.is-visible=false;")
		if(!splitItem) return

		if(!splitSize)
			splitSize = splitItem.stack

		splitItem = null


	verb/updateSplitStack(var/n=0 as num)
		set hidden = 1
		if(!splitItem) return

		var/val = clamp(text2num(winget(src, "splitStack.splitPercent", "value")) + n, 1, 100)
		if(!splitItem) return
		var/s   = round(splitItem.stack * val / 100, 1)

		if(n != 0)
			winset(src, null, "splitStack.splitButton.text=\"[s]\";splitStack.splitBar.value=[val];splitStack.splitPercent.value=[val];")
		else
			winset(src, null, "splitStack.splitButton.text=\"[s]\";splitStack.splitBar.value=[val]")

		s = min(s, splitItem.stack)
		s = max(s, 1)

		splitSize = s

obj/items/verb/Examine()
	set src in view(3)
	usr << infomsg("<i>[desc]</i>")
obj/items/proc/Destroy(var/mob/Player/owner)
	if(alert(owner,"Are you sure you wish to destroy your [src.name]?",,"Yes","Cancel") == "Yes")
		Dispose()
		return 1

obj/items/New()


	spawn(1) // spawn will ensure this works on edited items as well
		if(!src.desc)
			src.verbs -= /obj/items/verb/Examine

		if(!src.dropable)
			src.verbs -= /obj/items/verb/Drop
		else if(stack > 1)
			verbs += new/obj/items/proc/Drop_All()
		if(!src.takeable)
			src.verbs -= /obj/items/verb/Take
	..()

proc/getStatName(var/s)
	if(s == "clothDmg")     return "Damage"
	if(s == "clothDef")     return "Defense"
	if(s == "extraMP")      return "MP"
	if(s == "dropRate")     return "Drop Rate"
	if(s == "monsterDmg")   return "% Monster Damage"
	if(s == "monsterDmg")   return "% Monster Defense"
	if(s == "extraCDR")     return "CDR"
	if(s == "extraLimit")   return "Limit"
	if(s == "extraMPRegen") return "MP Regeneration"
	if(s == "extraHPRegen") return "HP Regeneration"
	return s

proc/getStatFactor(var/s, var/gain)
	if(s == "clothDmg")     return 10  * gain
	if(s == "clothDef")     return 30  * gain
	if(s == "extraMP")      return 120 * gain
	if(s == "extraMPRegen") return 20  * gain
	if(s == "extraHPRegen") return 10  * gain
	if(s == "extraLimit")   return 1
	if(s == "Armor")        return 5 * gain
	return 1 * gain
	/*if(s == "dropRate")   return 1
	if(s == "monsterDmg") return 1
	if(s == "monsterDmg") return 1
	if(s == "extraCDR")   return 1
	if(s == "extraLimit") return 1
	return 1*/


obj/items/wearable
	icon_state = "item"

	var
		const
			NOUPGRADE = -1 // -1 can't be upgraded
			UPGRADE   = 0  // 0  can be upgraded
			DAMAGE    = 1  // 1 damage
			DEFENSE   = 2  // 2 defense
			NOENCHANT = 4

		bonus   = NOUPGRADE
		quality = 0
		scale   = 1
		passive = 0
		power   = 1
		monsterDef = 0
		monsterDmg = 0
		dropRate = 0
		extraLimit = 0
		extraCDR = 0
		extraMP = 0
		Armor = 0
		obj/items/crystal/socket

		list/effects

		tmp
			clothDmg
			clothDef

		showoverlay = TRUE
		wear_layer  = FLOAT_LAYER - 5

	Compare(obj/items/i)
		. = ..()

		return . && i:bonus == bonus && i:quality == quality && i:socket == socket && i:power == power

	Clone()
		var/obj/items/wearable/w = ..()

		w.bonus   = bonus
		w.quality = quality

		return w

	MouseEntered(location,control,params)
		if((src in usr) && usr:infoBubble)

			var/list/info = list()

			if(quality)
				if(bonus & DAMAGE)
					var/dmg = 10*quality*scale

					if(dmg != 0)
						info["Damage"] = dmg

				if(bonus & DEFENSE)
					var/def = 30*quality*scale

					if(def != 0)
						info["Defense"] = def

			if(Armor)
				info["Armor"] = Armor * scale * (quality + 1)

			var/s
			if(socket)
				s = "[socket.name] [socket.ToString()]"
			else if(socket == 0)
				s = "Empty Socket"

			if(effects)
				for(var/e in effects)
					info[getStatName(e)] += effects[e]

			var/list/lines = list()

			for(var/i in info)
				if(findtext(i, "%"))
					lines += "+[info[i]][i]"
				else
					lines += "+[info[i]] [i]"

			if(power > 1)
				lines += "+[power] Legendary Effect"

			if(s) lines += s

			if(desc) lines += desc

			winset(usr, null, "infobubble.labelTitle.text=\"[name]\";infobubble.labelInfo.text=\"[jointext(lines, "\n")]\"")
			winshowRight(usr, "infobubble")

			if(slot)
				slot.icon_state = "grid_highlight"


	UpdateDisplay()
		var/const/WORN_TEXT = "<span style=\"color:blue;\">(Worn)</span>"
		var/const/EQUIP = {"<span style="font-family:arial;font-size:8px;color:#fff;text-align:left;vertical-align:top;-dm-text-outline:1px #000000"><b>E</b></span>"}

		var/worn = findtext(suffix, "worn")
		var/txt  = initial(suffix)

		var/lvl
		if(quality > 0 && scale > 0)
			lvl = {"<span style="font-family:arial;font-size:8px;color:#fff;text-align:center;vertical-align:middle;-dm-text-outline:1px #ff0000"><b>+[quality]</b></span>"}

		if(stack > 1)
			suffix  = "<span style=\"color:#c00;\">(x[stack])</span>"


			if(worn)
				suffix = "[suffix] [WORN_TEXT]"
				maptext = "[EQUIP][lvl]"
			else
				maptext = "[lvl]<span style=\"font-size:1px; color:#c00;text-align:left;vertical-align:bottom;\"><b>[stack]</b></span>"

			if(txt)
				suffix = "[suffix] [txt]"
		else
			if(worn)
				maptext = "[EQUIP][lvl]"
				suffix = WORN_TEXT

				if(txt)
					suffix = "[suffix] [txt]"
			else
				maptext = lvl
				suffix = txt

	proc
		calcBonus(mob/Player/owner, reset=1)
			if(bonus & DAMAGE)
				clothDmg = round(10 * quality * scale, 1)
				owner.clothDmg += clothDmg

			if(bonus & DEFENSE)
				clothDef = round(30 * quality * scale, 1)
				owner.clothDef += clothDef
				if(reset) owner.resetMaxHP()

		Upgrade(var/basePower, var/stats=2, var/random=1)

			if(stats == 2)
				rarity = 4
				name   = "cursed [name]"

				scale += 0.3 * scale

			max_stack = 1
			power = basePower

			effects = list()

			for(var/s = 1 to stats)
				var/stat = pick("monsterDef", "monsterDmg",	"dropRate",	"clothDmg", "clothDef", "extraMP", "extraLimit", "extraMPRegen", "Armor", "extraHPRegen")
				effects[stat] = getStatFactor(stat, (random ? rand(stats, basePower) : basePower))


obj/items/wearable/Destroy(var/mob/Player/owner)
	if(alert(owner,"Are you sure you wish to destroy your [src.name]?",,"Yes","Cancel") == "Yes")
		if(src in owner.Lwearing)
			Equip(owner)
		Dispose()
		return 1

obj/items/wearable/drop(mob/Player/owner, amount = 1)
	if(stack <= amount && (src in owner.Lwearing))
		Equip(owner)
	..()

obj/items/wearable/verb/Wear()
	if(src in usr)
		Equip(usr)
obj/items/wearable/Click()
	if(src in usr)
		Equip(usr)
	..()
obj/items/wearable/proc/Equip(var/mob/Player/owner)
	src.gender = owner.gender

	if(src in owner.Lwearing)
		owner.Lwearing.Remove(src)
		if(!owner.Lwearing) owner.Lwearing = null// deinitiliaze the list if not in use
		if(showoverlay)
			var/image/o = new
			o.icon = src.icon
			o.color = src.color
			o.layer = wear_layer

			owner.overlays -= o

			if(owner.reflection)
				owner.GenerateReflection()
			if(owner.cloakReflection)
				owner.cloakReflection.appearance = owner.appearance
				owner.cloakReflection.alpha = 200
				owner.cloakReflection.mouse_opacity = 0
				owner.cloakReflection.invisibility = 1

		suffix = initial(suffix)
		UpdateDisplay()
		if(clothDmg)
			owner.clothDmg -= clothDmg
			clothDmg        = null

		var/tmpDef = owner.clothDef
		var/tmpMP = owner.extraMP

		if(clothDef)
			owner.clothDef -= clothDef
			clothDef        = null
		if(socket)
			owner.clothDmg   -= socket.Dmg
			owner.clothDef   -= socket.Def
			owner.dropRate   -= socket.luck
			owner.monsterDmg -= socket.monsterDmg
			owner.monsterDef -= socket.monsterDef
			owner.extraMP    -= socket.MP
		owner.dropRate -= dropRate
		owner.monsterDmg -= monsterDmg
		owner.monsterDef -= monsterDef
		owner.extraLimit -= extraLimit
		owner.extraCDR -= extraCDR
		owner.Armor -= Armor * (quality + 1) * scale

		if(extraMP)
			owner.extraMP -= extraMP

		if(effects)
			for(var/e in effects)
				owner.vars[e] -= effects[e]

		if(tmpMP != owner.extraMP)
			owner.resetMaxMP()

		if(tmpDef != owner.clothDef)
			owner.resetMaxHP()

		if(passive)
			owner.passives[passive] -= power
			if(socket && !isnum(socket))
				owner.passives[passive] -= socket.power
			if(owner.passives[passive] <= 0) owner.passives -= passive
			if(!owner.passives.len) owner.passives = null

		return REMOVED
	else
		if(showoverlay && !owner.trnsed && !owner.noOverlays)
			var/image/o = new
			o.icon = src.icon
			o.color = src.color
			o.layer = wear_layer

			owner.overlays += o

			if(owner.reflection)
				owner.GenerateReflection()
			if(owner.cloakReflection)
				owner.cloakReflection.appearance = owner.appearance
				owner.cloakReflection.alpha = 200
				owner.cloakReflection.mouse_opacity = 0
				owner.cloakReflection.invisibility = 1

		if(!owner.Lwearing) owner.Lwearing = list()
		owner.Lwearing.Add(src)
		suffix = "worn"
		UpdateDisplay()
		var/tmpDef = owner.clothDef
		var/tmpMP = owner.extraMP
		if(bonus != -1)
			calcBonus(owner, 0)
		if(socket)
			owner.clothDmg   += socket.Dmg
			owner.clothDef   += socket.Def
			owner.dropRate   += socket.luck
			owner.monsterDmg += socket.monsterDmg
			owner.monsterDef += socket.monsterDef
			owner.extraMP    += socket.MP

		owner.dropRate += dropRate
		owner.monsterDmg += monsterDmg
		owner.monsterDef += monsterDef
		owner.extraLimit += extraLimit
		owner.extraCDR += extraCDR
		owner.Armor += Armor * (quality + 1) * scale

		if(extraMP)
			owner.extraMP += extraMP

		if(effects)
			for(var/e in effects)
				owner.vars[e] += effects[e]

		if(tmpDef != owner.clothDef)
			owner.resetMaxHP()

		if(tmpMP != owner.extraMP)
			owner.resetMaxMP()

		if(passive)
			if(!owner.passives) owner.passives = list()
			owner.passives[passive] += power
			if(socket && !isnum(socket))
				owner.passives[passive] += socket.power

		return WORN

obj/items/food
	canAuction = FALSE
	canSave    = FALSE
	Click()
		if(src in usr)
			Eat()
		..()
	proc/Eat()
		Consume()

	chocolate_bar
		icon = 'chocolate_bar.dmi'
		Eat()
			viewers(usr) << infomsg("[usr] eats a deliciously nutty chocolate bar.")
			..()
	caramel_apple
		icon = 'caramel_apple.dmi'
		Eat()
			viewers(usr) << infomsg("[usr] chomps down on a caramel apple.")
			..()
	candy_corn
		icon = 'candy_corn.dmi'
		Eat()
			viewers(usr) << infomsg("[usr] snacks on some candy corn.")
			..()
	tootsie_roll
		icon = 'tootsie_roll.dmi'
		Eat()
			viewers(usr) << infomsg("[usr] pops a tootsie roll into \his mouth.")
			..()

obj/items/Zombie_Head
	icon='halloween.dmi'
	icon_state="head"
	desc = "The zombie's head stares at you."

	Click()
		if(src in usr)
			if(canUse(usr,cooldown=/StatusEffect/UsedTransfiguration,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=100,againstocclumens=1,againstflying=0,againstcloaked=1))
				new /StatusEffect/UsedTransfiguration(usr,15*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier)
				if(usr.CanTrans(usr))
					var/mob/Player/p = usr
					flick("transfigure",p)
					hearers()<<"<b><span style=\"color:red;\">[usr]</span>:<b><span style=\"color:green;\"> Personio Inter vivos.</b></span>"
					p.trnsed = 1
					p.overlays = null
					if(p.away)p.ApplyAFKOverlay()
					if(p.Gender=="Female")
						p.icon = 'FemaleVampire.dmi'
					else
						p.icon = 'MaleVampire.dmi'
		else
			..()

obj/items/Whoopie_Cushion
	icon='jokeitems.dmi'
	icon_state = "Whoopie_Cushion"
	var/isset = 0
	canAuction = FALSE
	proc
		Fart(sitter)
			hearers() << "<span style=\"color:#FD857D; font-size:3;\"><b>A loud fart is heard from [sitter]'s direction.</b></span>"
			loc = null
	Click()
		if(src in usr)
			hearers() << "[usr] sets a [src]."

			var/obj/items/Whoopie_Cushion/w = Split(1)
			w.isset = 1
			w.verbs.Remove(/obj/items/verb/Take)
			w.loc = usr.loc

		else
			..()

	Compare()
		. = ..()

		return isset ? 0 : .

	Crossed(mob/Player/p)
		if(isset && isplayer(p))
			Fart(p)

obj/items/scroll
	icon = 'Scroll.dmi'
	destroyable = 1
	accioable=1
	wlable = 1
	canAuction = FALSE
	var/content
	var/tmp/inuse = 0

	book
		accioable = 0
		wlable = 0
		icon = 'Books.dmi'
		icon_state = "COMC"

	New()
		..()
		pixel_x = rand(-5,5)
		pixel_y = rand(-5,5)
	Click()
		if(src in usr)
			usr << browse(content)
		else ..()

	Compare(obj/items/i)
		. = ..()

		return content ? 0 : .


	verb
		Name(msg as text)
			set name = "Name Scroll"
			if(msg == "") return
			if(inuse)
				usr << errormsg("The scroll is currently being used.")
				return
			src.name = copytext(html_encode(msg),1,25)
		write()
			set name = "Write"
			inuse = 1
			var/msg = input("What would you like to write on the scroll?","Write on scroll") as null|message
			if(!msg)
				inuse = 0
				return
			msg = copytext(msg,1,1000)
			msg = replacetext(msg,"\n","<br>")

			var/obj/items/scroll/s = stack > 1 ? Split(1) : src
			s.content += "<body style=\"background-color:black; color:white\"><b><span style=\"color:blue; font-size:large; \"><u>[name]</u></span><br><span style=\"color:red; font-size:xx-small;\">by [usr]</span></b><br><p><span style=\"font-size:small;\">[msg]</span></p></body>"
			s.icon_state = "wrote"
			s.Move(usr)
			name = initial(name)
			inuse = 0
obj/items/bagofsnow
	name="Bag 'o Sno"
	icon = 'bagosnow.dmi'
	desc = "It's a bag filled with the finest of snow."
	destroyable = 1
	var/tmp/lastproj = 0

	Click()
		if(src in usr)
			Throw_Snowball()
		else ..()

	verb/Throw_Snowball()
		usr.castproj(icon_state = "snowball", name = "Snowball")

obj/items/gift
	icon = 'present.dmi'
	desc = "Lovely gift wrappings, drag and drop on an item to wrap up a gift!"
	icon_state = "wrappings"
	name = "gift wrappings"
	var/ckeyowner

	proc/changeShape()
		desc = "Gift from [usr.name]"
		name = "gift"
		icon_state = "[rand(1,4)]"

	valentine

		changeShape()
			desc = "A lovely Valentine from [usr.name]"
			name = "Valentine"
			icon_state = "heart"

	Click()
		if(src in usr)
			Open()
		else ..()

	verb
		Open()
			if(!contents.len) return
			if(!worldData.allowGifts)
				usr << errormsg("You can't open your gift... yet...")
				return

			var/obj/o = contents[1]
			usr << infomsg("You opened your present and recieved [o.name]!")
			o.loc = loc
			Dispose()


		Disown()
			var/input = alert("Are you sure you wish to allow anyone to pick this gift up?",,"Yes","No")
			if(input == "Yes")
				ckeyowner = null
				usr << "Your gift can now be picked up by anyone."

	Take()
		if(ckeyowner == usr.ckey || !ckeyowner || !contents.len)
			..()
			if(src in usr)
				ckeyowner = usr.ckey
		else
			usr << errormsg("You do not have permission to pick this up.")

	New()
		..()
		color = rgb(rand(0,255), rand(0,255), rand(0,255))

		spawn()
			if(!contents.len)
				verbs -= /obj/items/gift/verb/Open
				verbs -= /obj/items/gift/verb/Disown

	Compare(obj/items/i)
		. = ..()

		return contents.len ? 0 : .

	MouseDrop(over_object)
		..()

		if(!contents.len && istype(over_object, /obj/items) && !istype(over_object, /obj/items/gift) && (over_object in usr) && (src in usr))
			var/obj/items/i = over_object

			if(!i.dropable)
				usr << errormsg("This item can't be dropped.")
				return

			if(i in usr:Lwearing)
				i:Equip(usr)
			else if(istype(i, /obj/items/lamps) && i:S)
				var/obj/items/lamps/lamp = i
				lamp.S.Deactivate()

			if(i.stack > 1)
				var/obj/items/s = i.Split(1)
				s.loc = src
			else
				i.loc = src

			changeShape()
			verbs += /obj/items/gift/verb/Disown
			verbs += /obj/items/gift/verb/Open

			pixel_y = rand(-4,4)
			pixel_x = rand(-4,4)

			ckeyowner = usr.ckey

			if(stack > 1)
				var/obj/items/s = Split(stack - 1)
				s.Move(loc)
				s.name = "gift wrappings"


obj/items/bagofgoodies
	name = "bag of goodies"
	icon = 'bagofgoodies.dmi'

	Click()
		if(src in usr)
			Open()
		else ..()

	verb
		Open()
			if(src in usr)
				usr << "You open the bag of goodies..."
				var/rnd = rand(1,4)
				if(rnd==1)
					usr << "Inside you find a Bucket."
					new/obj/items/bucket(usr)
				else if(rnd==2)
					rnd=rand(1,4)
					if(rnd==1)
						usr << "Inside you find a Blue Scarf."
						new/obj/items/wearable/scarves/blue_scarf(usr)
					else if(rnd==2)
						usr << "Inside you find a Yellow Scarf."
						new/obj/items/wearable/scarves/yellow_scarf(usr)
					else if(rnd==3)
						usr << "Inside you find a Orange Scarf."
						new/obj/items/wearable/scarves/orange_scarf(usr)
					else if(rnd==4)
						usr << "Inside you find a Bling."
						new/obj/items/wearable/bling(usr)
				else if(rnd==3)
					usr << "Inside you find a Salamander Drop Wand."
					new/obj/items/wearable/wands/salamander_wand(usr)
				else if(rnd==4)
					usr << "Inside you find a Scroll"
					new/obj/items/scroll(usr)

				Consume()

obj/items/pokeby
	icon = 'pokeby.dmi'
	desc = "Aww, isn't it cute?"

obj/items/trophies
	name = "Trophy"
	icon = 'trophies.dmi'
	Gold
		icon_state = "Gold"
	Yellow
		icon_state = "Yellow"
	Silver
		icon_state = "Silver"
	Bronze
		icon_state = "Bronze"
	desc = "It's blank!"

	Compare(obj/items/i)
		. = ..()

		return . && desc == i.desc

	Click()
		if(src in usr)
			if(canUse(M=usr, cooldown=/StatusEffect/DisplayedTrophy, needwand=0))
				new /StatusEffect/DisplayedTrophy(usr, 30)

				var/msg = "[icon_state] Trophy: [desc]"
				var/offset = 15 - (length(msg) * 4)

				src = null
				spawn()
					for(var/i = 1 to rand(10,20))
						if(!usr) break
						var/c = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
						fadeText(usr, "<span style=\"color:[c];\">[msg]</span>", offset, 20)
						sleep(3)
		else
			..()

	New()
		..()
		spawn(1)
			if(desc != initial(desc))
				src.verbs -= /obj/items/trophies/verb/Inscribe

	verb/Inscribe()
		var/input = input("This trophy can only be written on once. What do you want it to say?") as null|text
		if(!input)return
		desc = input
		src.verbs.Remove(/obj/items/trophies/verb/Inscribe)


obj/items/bucket
	icon = 'bucket.dmi'

	var/filled = 0

	Clone()
		var/obj/items/bucket/b = ..()

		b.filled     = filled
		b.name       = name
		b.icon_state = icon_state

		return b

	Click()
		if(src in usr)
			if(filled == 0)
				var/turf/water/w = get_step(usr, usr.dir)
				if(!w || !istype(w, /turf/water))
					usr << errormsg("You need to face water to fill the bucket.")
					return
				if(w.name != "water")
					usr << errormsg("You have to melt nearby ice.")
					return

				var/obj/items/bucket/s = stack > 1 ? Split(1) : src

				s.name = "bucket \[Water]"
				s.icon_state = "water"
				s.filled = WATER

				var/mob/Player/p = usr
				s.Move(p)

				usr << errormsg("You fill a bucket with water.")
			else
				var/mob/Player/p = usr
				p.castproj(icon_state = "aqua", name = "Water", damage = 1, element = WATER)
				if(prob(5))
					var/obj/items/bucket/s = stack > 1 ? Split(1) : src

					s.name = "bucket"
					s.icon_state = null
					s.filled = 0

					s.Move(p)
					p << errormsg("You ran out of water.")
		else
			..()

obj/items/seeds
	var
		plantType
		delay = 36000
		cycles = 4
		amount = 4

		cap = 0

	icon = 'potions_ingredients.dmi'
	icon_state = "seeds"

	Click()
		if(src in usr)

			var/obj/items/bucket/b
			for(b in usr)
				if(b.filled == 0)
					break
			if(!b)
				usr << errormsg("You need an empty bucket to plant this in.")
				return
			var/turf/t = usr.loc

			if(!t || issafezone(t.loc, 1, 0))
				usr << errormsg("You can't plant here.")
				return

			if(locate(/obj/herb) in t)
				usr << errormsg("There's a bucket placed here already.")
				return

			#if WINTER
			if(t.icon_state != "snow")
			#else
			if(t.icon_state != "grass1")
			#endif
				usr << errormsg("Place this bucket at a place with grass.")
				return

			b.Consume()
			Consume()

			new /obj/herb (t, usr.ckey, plantType, delay, cycles, amount, name, cap)

			var/list/dirs = DIRS_LIST
			var/opDir
			for(var/d in dirs)
				if(step(usr, d))
					opDir = turn(d, 180)
					break

			sleep(3)
			usr.dir = opDir
			sleep(1)
		else
			..()

	daisy_seeds
		plantType = /obj/items/ingredients/daisy
		delay = 72000
		cycles = 4
		amount = 8
	aconite_seeds
		plantType = /obj/items/ingredients/aconite
		delay = 72000
		cycles = 4
		amount = 8
	berry_seeds
		plantType = /obj/items/treats/berry
		delay = 36000
		cycles = 4
		amount = 6
	sweet_berry_seeds
		plantType = /obj/items/treats/sweet_berry
		delay = 18000
		cycles = 4
		amount = 6
	grape_berry_seeds
		plantType = /obj/items/treats/grape_berry
		delay = 36000
		cycles = 4
		amount = 6
	artifact_seeds
		plantType = /obj/items/artifact
		delay = 144000
		cycles = 3
		amount = 1
		cap = 3


obj/items/freds_key
	name = "Fred's key"
	icon = 'ChestKey.dmi'
	icon_state = "master"
	destroyable = 1
	dropable = 0
	Destroy()
		var/mob/Player/user = usr
		var/questPointer/pointer = user.questPointers["On House Arrest"]
		if(pointer.stage == 1)
			user << errormsg("You still need to take this key to Gringott's Bank.")
		else
			..()

obj/items/wearable/halloween_bucket
	icon = 'halloween_bucket.dmi'
	dropable = 0
	desc = "A bucket of candy from halloween!"
	wear_layer = FLOAT_LAYER - 4
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] pulls out \his [src.name].")
			for(var/obj/items/wearable/halloween_bucket/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] away.")
	Click()
		if(src in usr)
			var/StatusEffect/S = usr.findStatusEffect(/StatusEffect/UsedHalloweenBucket)
			if(S && S.cantUseMsg(usr))
				return
			new /StatusEffect/UsedHalloweenBucket(usr,30)
			var/newtype = pick(typesof(/obj/items/food) - /obj/items/food)
			var/obj/O = new newtype (usr)
			O.gender = usr.gender
			viewers(usr) << infomsg("[usr] pulls \a [O] out of \his halloween bucket.")
		else
			..()

proc/animateFly(mob/Player/p)
	set waitfor = 0

	var/max = 10

	if(p.loc.density)
		max = 26
	else
		for(var/atom/movable/a in p.loc)
			if(!a.density) continue
			max = 26
			break

	if(p.pixel_y != max)
		animate(p, pixel_y = max, time = 5)
		sleep(5)

		if(p && p.flying)
			animate(p, pixel_y = p.pixel_y,    time = 2, loop = -1)
			animate(   pixel_y = p.pixel_y + 1,time = 2)
			animate(   pixel_y = p.pixel_y,    time = 2)
			animate(   pixel_y = p.pixel_y - 1,time = 2)

obj/items/wearable/brooms
	var/tmp/protection = 1
	useTypeStack = 1
	stackName = "Brooms:"
	icon = 'firebolt_broom.dmi'

	var/speed = 2

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		if(!forceremove && !(src in owner.Lwearing) && owner.loc && owner.loc.loc && owner.loc.loc:antiFly)
			owner << errormsg("You can not fly here.")
			return
		if(!forceremove && !(src in owner.Lwearing) && owner.findStatusEffect(/StatusEffect/Knockedfrombroom))
			owner << errormsg("You can't get back on your broom right now because you were recently knocked off.")
			return
		if(!(src in owner.Lwearing) && (owner.trnsed || owner.noOverlays))
			owner << errormsg("You can't fly while transfigured.")
			return
		if(owner.findStatusEffect(/StatusEffect/Potions/Vampire))
			owner << errormsg("You are already flying.")
			return
		if(locate(/obj/items/wearable/invisibility_cloak) in owner.Lwearing)
			owner << errormsg("Your cloak isn't big enough to cover you and your broom.")
			return
		if(forceremove && (src in owner.Lwearing) && speed)
			owner.dashDistance -= speed
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] jumps on \his [src.name].")
			owner.density = 0
			owner.flying = 1
			owner.icon_state = "flying"
			owner.dashDistance += speed
			protection = initial(protection)

			new /hudobj/Fly (null, owner.client, null, 1)

			for(var/obj/items/wearable/brooms/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)

			owner.layer   = 5
			animateFly(owner)

			if(!owner.followers || !(locate(/obj/Shadow) in owner.followers))
				var/obj/Shadow/s = new (owner.loc)
				owner.addFollower(s)

		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] dismounts from \his [src.name].")
			owner.density = 1
			owner.flying = 0
			owner.icon_state = ""

			owner.dashDistance -= speed

			var/hudobj/Fly/f = locate() in owner.client.screen
			if(f)
				f.hide()

			animate(owner, pixel_y = 0, time = 5)
			owner.layer   = 4

			spawn(6)
				if(owner.followers && !owner.flying)
					var/obj/Shadow/s = locate(/obj/Shadow) in owner.followers
					if(s)
						s.Dispose()
						owner.removeFollower(s)
						animate(owner, flags = ANIMATION_END_NOW)
				owner.loc.Enter(owner, owner.loc)

obj/items/wearable/brooms/firebolt
	icon = 'firebolt_broom.dmi'
	protection = 3
	speed = 6
obj/items/wearable/brooms/nimbus_2000
	icon = 'nimbus_2000_broom.dmi'
	protection = 2
	speed = 4
obj/items/wearable/brooms/levitate

	icon = 'Books.dmi'
	icon_state = "raven"
	showoverlay = FALSE

	protection = 6
	speed = 4

obj/items/wearable/brooms/cleansweep_seven
	icon = 'cleansweep_seven_broom.dmi'

obj/items/wearable/brooms/vampire_wings
	protection = 99
	showoverlay = FALSE
	color = "#ff0000"

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		.=..(owner, 1, forceremove)

		if(. == WORN)
			var/image/i = new('VampireWings.dmi', "flying")
			i.layer = FLOAT_LAYER - 3
			i.pixel_x = -16
			i.pixel_y = -16
			i.color = color
			i.alpha = alpha

			owner.overlays += i

			if(!overridetext)viewers(owner) << infomsg("[owner] puts on \his [src.name].")

		else if(. == REMOVED || forceremove)
			var/image/i = new('VampireWings.dmi', "flying")
			i.layer = FLOAT_LAYER - 3
			i.pixel_x = -16
			i.pixel_y = -16
			i.color = color
			i.alpha = alpha
			owner.overlays -= i

			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] away.")

obj/items/wearable/brooms/floating_rock
	showoverlay = FALSE
	protection = 99

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		.=..(owner, 1, forceremove)

		if(. == WORN)
			var/image/i = new('floating_rock.dmi', "flying")
			i.layer = 3
			i.pixel_y = -21
			i.color = color
			i.alpha = alpha

			owner.overlays += i
			owner.pixel_y = 24

			if(!overridetext)viewers(owner) << infomsg("[owner] climbs on \his [src.name].")

		else if(. == REMOVED || forceremove)
			var/image/i = new('floating_rock.dmi', "flying")
			i.layer = 3
			i.pixel_y = -21
			i.color = color
			i.alpha = alpha

			owner.overlays -= i

			if(!overridetext)viewers(owner) << infomsg("[owner] gets off \his [src.name] away.")


obj/items/wearable/hats
	wear_layer = FLOAT_LAYER - 3
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] puts on \his [src.name].")
			for(var/obj/items/wearable/hats/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] away.")
obj/items/wearable/hats/crown
	icon = 'crown.dmi'
	dropable = 0
obj/items/wearable/hats/tiara
	icon = 'tiara.dmi'
	dropable = 0
obj/items/wearable/hats/christmas_hat
	icon = 'xmas_hat.dmi'
	dropable = 0
obj/items/wearable/hats/bunny_ears
	icon = 'bunny_ears_hat.dmi'
	dropable = 0
obj/items/wearable/hats/yellow_earmuffs
	icon = 'yellow_earmuffs_hat.dmi'
obj/items/wearable/hats/blue_earmuffs
	icon = 'lightblue_earmuffs_hat.dmi'
	name = "light blue earmuffs"
obj/items/wearable/hats/white_earmuffs
	icon = 'white_earmuffs_hat.dmi'
obj/items/wearable/hats/green_earmuffs
	icon = 'green_earmuffs_hat.dmi'
obj/items/wearable/hats/red_earmuffs
	icon = 'red_earmuffs_hat.dmi'
obj/items/wearable/hats/black_earmuffs
	icon = 'black_earmuffs_hat.dmi'
obj/items/wearable/hats/cyan_earmuffs
	icon = 'cyan_earmuffs_hat.dmi'
obj/items/wearable/hats/darkblue_earmuffs
	icon = 'darkblue_earmuffs_hat.dmi'
	name = "dark blue earmuffs"
obj/items/wearable/hats/darkpurple_earmuffs
	icon = 'darkpurple_earmuffs_hat.dmi'
	name = "dark purple earmuffs"
obj/items/wearable/hats/darkpink_earmuffs
	icon = 'darkpink_earmuffs_hat.dmi'
	name = "dark pink earmuffs"
obj/items/wearable/hats/grey_earmuffs
	icon = 'grey_earmuffs_hat.dmi'
obj/items/wearable/hats/lightpurple_earmuffs
	icon = 'lightpurple_earmuffs_hat.dmi'
	name = "light purple earmuffs"
obj/items/wearable/hats/lightpink_earmuffs
	icon = 'lightpink_earmuffs_hat.dmi'
	name = "light pink earmuffs"
obj/items/wearable/hats/orange_earmuffs
	icon = 'orange_earmuffs_hat.dmi'
obj/items/wearable/hats/teal_earmuffs
	icon = 'teal_earmuffs_hat.dmi'

obj/items/wearable/orb

	useTypeStack = /obj/items/wearable/orb
	rarity = 2

	desc = "When equipped, your equipped wand will earn experience and level up by killing monsters."

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)

		if(stack > 1)
			var/obj/items/wearable/orb/o = Split(1)
			o.max_stack = 1
			o.Equip(owner)
			o.Move(owner)

			return

		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] uses \his [src.name].")
			for(var/obj/items/wearable/orb/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] stops using \his [src.name].")

	icon = 'orbs.dmi'
	showoverlay = FALSE
	quality = -1
	scale   = 3

	Clone()
		var/obj/items/wearable/orb/i = new type

		i.owner      = owner
		i.name       = name
		i.icon_state = icon_state
		i.exp        = exp
		i.modifier   = modifier
		i.bonus      = bonus
		i.quality    = quality

		return i

	Compare(obj/items/wearable/orb/i)

		if(i.name == name && i.type == type && i.owner == owner && i.icon_state == icon_state && i.exp == exp && i.modifier == modifier && i.bonus == bonus && i.quality == quality)

			if(i.max_stack == max_stack)
				return 1

			if(isplayer(loc))
				var/mob/Player/p = loc
				if((i in p.Lwearing) || (src in p.Lwearing))
					return 0

				i.max_stack = 0
				max_stack = 0
				return 1

		return 0

	//	return i.name == name && i.type == type && i.owner == owner && i.icon_state == icon_state && i.exp == exp && i.modifier == modifier && i.bonus == bonus && i.quality == quality && i.max_stack == max_stack


	var
		exp
		modifier = 2

	Consume()
		exp = initial(exp)
		desc = initial(desc)

		..()

	chaos
		name       = "orb of chaos"
		bonus      = 5
		exp   	   = 100000
		icon_state = "chaos"

		greater
			name     = "greater orb of chaos"
			exp      = 300000
			modifier = 4
			quality  = -2

	peace
		name       = "orb of peace"
		bonus      = 6
		exp        = 100000
		icon_state = "peace"

		greater
			name     = "greater orb of peace"
			exp      = 300000
			modifier = 4
			quality  = -2

	magic
		name       = "orb of magic"
		bonus      = 7
		exp   	   = 300000
		modifier   = 3
		rarity     = 3

		greater
			name     = "greater orb of magic"
			exp      = 1000000
			modifier = 6
			quality  = -2

mob/Player/var/tmp/obj/items/wearable/wands/wand
mob/Player/var/tmp/obj/items/wearable/wand_holster/holster

obj/items/wearable/wands
	scale = 0.6
	var
		track
		displayColor
		projColor
		killCount        = 0
		monsterKillCount = 0
		exp              = 0
		tmp/display = FALSE

		lastused

		test = 1

		tmp/hudobj/WandPower/wandPower

	bonus = NOENCHANT
	max_stack = 1
	socket = 0

	calcBonus(mob/Player/owner, reset=1)
		var/s = worldData.elderWand == owner.ckey ? scale + 0.1 : scale
		if(bonus & DAMAGE)
			clothDmg = round(10 * quality * s, 1)
			owner.clothDmg += clothDmg

		if(bonus & DEFENSE)
			clothDef = round(30 * quality * s, 1)
			owner.clothDef += clothDef
			if(reset) owner.resetMaxHP()

	proc
		addExp(mob/Player/owner, amount)
			if(istype(src, /obj/items/wearable/wands/practice_wand)) return
			if(quality >= MAX_WAND_LEVEL)
				exp = 0
				return

			var/exp2give = 0

			if(quality < 10)
				exp2give = amount / 2

			var/obj/items/wearable/orb/o = locate() in owner.Lwearing
			if(o)
				amount = round(amount * o.modifier, 1)

				if(o.exp < amount) amount = o.exp

				o.exp -= amount

				var/dura = round((o.exp / initial(o.exp)) * 100, 1)
				o.desc = "When equipped, your equipped wand will earn experience and level up by killing monsters. Durability: [dura]%"

				if(dura <= 10 && round(((o.exp + amount) / initial(o.exp)) * 100, 1) > 10)
					owner << errormsg("Your equipped orb is about to break.")

				if(o.exp == 0)
					o.Equip(owner)
					o.Consume()

					owner << errormsg("[o.name] shatters.")

				exp2give += amount

			if(exp2give > 0)

				exp += max(round(exp2give, 1), 1)

				var/i = 0
				while(exp >= MAX_WAND_EXP(src))
					exp -= MAX_WAND_EXP(src)

					if(quality + i >= MAX_WAND_LEVEL)
						exp = 0
						break

					i += 1

				if(i)
					Equip(owner, 1)

					quality += i

					var/b = pick(0,1,2)
					if(o)
						b |= o.bonus
					bonus = b|bonus

					Equip(owner, 1)

					var/list/s = splittext(name, " +")
					name = "[s[1]] +[quality]"

					owner.screenAlert("[s[1]] leveled up to [quality]!")

	Compare(obj/items/i)
		. = ..()

		if(track)				    return FALSE
		if(exp || bonus || quality) return FALSE

		return TRUE

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			for(var/obj/items/wearable/wands/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)

			if(lastused && lastused != owner.ckey && (bonus || quality || exp))
				bonus   = NOENCHANT
				quality = 0
				exp     = 0

				var/list/s = splittext(name, " +")
				name = s[1]

			lastused = owner.ckey
			owner.wand = src

			if(test)
				wandPower = new (null, owner.client, null, 1)

			if(!overridetext)
				if(track)
					displayKills(owner, 0, 1)
					displayKills(owner, 0, 2)
				var/n = worldData.elderWand == owner.ckey ? "[name] (elder)" : name
				if(track && displayColor)
					viewers(owner) << infomsg({"[owner] draws \his <span style=\"color:[displayColor];\">[n]</span>."})
				else
					viewers(owner) << infomsg("[owner] draws \his [n].")
		else if(. == REMOVED)
			owner.wand = null

			if(wandPower)
				wandPower.hide()
				wandPower = null

			if(!overridetext)
				var/n = worldData.elderWand == owner.ckey ? "[name] (elder)" : name
				if(track && displayColor)
					viewers(owner) << infomsg({"[owner] puts \his <span style=\"color:[displayColor];\">[n]</span> away."})
				else
					viewers(owner) << infomsg("[owner] puts \his [n] away.")
				owner.nowand()

proc/displayKills(mob/Player/i_Player, count=0, countType=1)
	set waitfor = 0

	if(i_Player.wand && i_Player.wand.track)
		var/obj/items/wearable/wands/w = i_Player.wand
		while(w.display)
			sleep(1)

		w.display = TRUE

		var/num
		if(!countType)
			num = count
		else if(countType == 1)
			w.killCount += count
			num = w.killCount
		else if(countType == 2)
			w.monsterKillCount += count
			num = w.monsterKillCount

		var/offset = 15 - (length("[num]") * 5)

		if(w.displayColor)
			fadeText(i_Player, "<b><span style=\"color:[w.displayColor];\">[num] </span></b>", offset, 20)
		else
			fadeText(i_Player, "<b>[num]</b>", offset, 20)
		sleep(3)
		w?.display = FALSE

obj/items/wearable/wands/cedar_wand //Thanksgiving
	icon = 'cedar_wand.dmi'
	displayColor = "#c86426"
	dropable = 0
	verb/Delicio_Maxima()
		set category = "Spells"
		if(src in usr:Lwearing)
			if(canUse(usr,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
				new /StatusEffect/UsedTransfiguration(usr,30*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier)
				hearers()<<"<b><span style=\"color:red;\">[usr]</span>:<b><span style=\"color:white;\"> Delicio Maxima.</b></span>"
				sleep(20)
				for(var/mob/Player/M in ohearers(usr.client.view,usr))
					if(M.flying) continue
					if((locate(/obj/items/wearable/invisibility_cloak) in M.Lwearing)) continue
					if(prob(20)) continue
					if(usr.CanTrans(M))
						flick("transfigure",M)
						M.overlays = null
						M.trnsed = 1
						if(M.away) M.ApplyAFKOverlay()
						M.icon = 'Turkey.dmi'
						M<<"<b><span style=\"color:#D6952B;\">Delicio Charm:</b></span> [usr] turned you into some Thanksgiving awesome-ness."
					sleep(1)
		else
			usr << errormsg("You need to be using this wand to cast this.")
obj/items/wearable/wands/maple_wand //Easter
	icon = 'maple_wand.dmi'
	displayColor = "#D6968F"
	dropable = 0

	useTypeStack = 1

	verb/Carrotosi_Maxima()
		set category = "Spells"
		if(src in usr:Lwearing)
			if(canUse(usr,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
				new /StatusEffect/UsedTransfiguration(usr,30*(usr:cooldownModifier+usr:extraCDR)*worldData.cdrModifier)
				hearers()<<"<b><span style=\"color:red;\">[usr]</span>:<b><span style=\"color:white;\"> Carrotosi Maxima.</b></span>"
				sleep(20)
				for(var/mob/Player/M in ohearers(usr.client.view,usr))
					if(M.flying) continue
					if((locate(/obj/items/wearable/invisibility_cloak) in M.Lwearing)) continue
					if(prob(20)) continue
					if(usr.CanTrans(M))
						flick("transfigure",M)
						M.overlays = null
						M.trnsed = 1
						if(M.away) M.ApplyAFKOverlay()
						M.icon = 'PinkRabbit.dmi'
						M<<"<b><span style=\"color:red;\">Carrotosi Charm:</b></span> [usr] turned you into a Rabbit."
					sleep(1)
		else
			usr << errormsg("You need to be using this wand to cast this.")

obj/items/wearable/wands/sonic_wand
	dropable = 0
	icon = 'sonic_wand.dmi'
	displayColor = "#8BEAAF"

	verb/Sound_Wave()
		set category = "Spells"
		if(src in usr:Lwearing)
			if(!usr.loc || usr.loc.loc:disableEffects)
				usr << errormsg("You can't use this here.")
				return
			if(canUse(usr,cooldown=/StatusEffect/UsedSonic,needwand=1,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
				new /StatusEffect/UsedSonic(usr, 30)
				spawn()
					light(usr, 0, 10, "teal")
					sleep(3)
					light(usr, 1, 12, "blue")
					sleep(3)
					light(usr, 2, 15, "purple")
				for(var/obj/Hogwarts_Door/d in oview(2))
					if(prob(20) || d.pass) continue
					usr.Bump(d)
					sleep(1)

		else
			usr << errormsg("You need to be using this wand to cast this.")

area/var/disableEffects = FALSE

obj/items/wearable/wands/interruption_wand //Fred's quest
	canAuction = FALSE
	icon = 'interruption_wand.dmi'
	displayColor = "#fff"
	scale = 0.55
obj/items/wearable/wands/salamander_wand //Bag of goodies
	icon = 'salamander_wand.dmi'
	displayColor = "#FFa500"
	scale = 0.55
obj/items/wearable/wands/mithril_wand
	icon = 'mithril_wand.dmi'
obj/items/wearable/wands/mulberry_wand
	icon = 'mulberry_wand.dmi'
	displayColor = "#f39"
obj/items/wearable/wands/royale_wand
	icon = 'royale_wand.dmi'
	displayColor = "#8560b3"
obj/items/wearable/wands/pimp_cane //Sylar's wand thing
	icon = 'pimpcane_wand.dmi'
obj/items/wearable/wands/birch_wand
	icon = 'birch_wand.dmi'
	displayColor = "#fff"
	scale = 0.5
obj/items/wearable/wands/oak_wand
	icon = 'oak_wand.dmi'
	displayColor = "#960"
	scale = 0.5
obj/items/wearable/wands/mahogany_wand
	icon = 'mahogany_wand.dmi'
	displayColor = "#966"
	scale = 0.5
obj/items/wearable/wands/elder_wand
	icon = 'elder_wand.dmi'
	displayColor = "#ff0"
	scale = 0.5
obj/items/wearable/wands/willow_wand
	icon = 'willow_wand.dmi'
	displayColor = "#f00"
	scale = 0.5
obj/items/wearable/wands/ash_wand
	icon = 'ash_wand.dmi'
	displayColor = "#cab5b5"
	scale = 0.5
obj/items/wearable/wands/duel_wand
	icon = 'duel_wand.dmi'
	displayColor = "#088"
obj/items/wearable/wands/blood_wand
	icon = 'blood_wand.dmi'
	displayColor = "#9A1010"
	test = 2
obj/items/wearable/wands/dragonhorn_wand
	icon = 'dragonhorn_wand.dmi'
	displayColor = "#037800"
obj/items/wearable/wands/light_wand
	icon = 'light_wand.dmi'
	displayColor = "#64c8ff"

obj/items/wearable/wigs
	price = 2000000
	bonus = 0
	desc = "A wig to hide those dreadful split ends."
	Armor = 3
	wear_layer = FLOAT_LAYER - 4
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] attaches \his [src.name] to \his scalp.")
			for(var/obj/items/wearable/wigs/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")

obj/items/wearable/wigs/hairclip
	showoverlay = FALSE
	icon = 'Hair_Clip.dmi'
	name = "hairclip"
obj/items/wearable/wigs/male_lightgreen_wig
	icon = 'male_lightgreen_wig.dmi'
	name = "male light green wig"
obj/items/wearable/wigs/male_black_wig
	icon = 'male_black_wig.dmi'
obj/items/wearable/wigs/male_blond_wig
	icon = 'male_yellow_wig.dmi'
	name = "male yellow wig"
obj/items/wearable/wigs/male_blue_wig
	icon = 'male_lightblue_wig.dmi'
	name = "male light blue wig"
obj/items/wearable/wigs/male_brown_wig
	icon = 'male_brown_wig.dmi'
obj/items/wearable/wigs/male_darkgreen_wig
	icon = 'male_darkgreen_wig.dmi'
	name = "male dark green wig"
obj/items/wearable/wigs/male_green_wig
	icon = 'male_green_wig.dmi'
obj/items/wearable/wigs/male_grey_wig
	icon = 'male_grey_wig.dmi'
obj/items/wearable/wigs/male_pink_wig
	icon = 'male_lightpink_wig.dmi'
	name = "male light pink wig"
obj/items/wearable/wigs/male_purple_wig
	icon = 'male_lightpurple_wig.dmi'
	name = "male light purple wig"
obj/items/wearable/wigs/male_silver_wig
	icon = 'male_silver_wig.dmi'
obj/items/wearable/wigs/male_red_wig
	icon = 'male_red_wig.dmi'
	name = "male red wig"
obj/items/wearable/wigs/male_teal_wig
	icon = 'male_teal_wig.dmi'
	name = "male teal wig"
obj/items/wearable/wigs/male_demonic_wig
	icon = 'male_demonic_wig.dmi'
	name = "Demonic's wig"
obj/items/wearable/wigs/male_bluebrown_wig
	icon = 'male_bluebrown_wig.dmi'
	name = "male blue and brown wig"
obj/items/wearable/wigs/male_blackgreen_wig
	icon = 'male_blackgreen_wig.dmi'
	name = "male black and green wig"
obj/items/wearable/wigs/male_royale_wig
	icon = 'male_royale_wig.dmi'
obj/items/wearable/wigs/male_apollo_wig
	icon = 'male_apollo_wig.dmi'
	name = "male blond wig"
obj/items/wearable/wigs/male_cyan_wig
	icon = 'male_cyan_wig.dmi'
obj/items/wearable/wigs/male_darkblue_wig
	icon = 'male_darkblue_wig.dmi'
	name = "male dark blue wig"
obj/items/wearable/wigs/male_darkpurple_wig
	icon = 'male_darkpurple_wig.dmi'
	name = "male dark purple wig"
obj/items/wearable/wigs/male_darkpink_wig
	icon = 'male_darkpink_wig.dmi'
	name = "male dark pink wig"
obj/items/wearable/wigs/male_orange_wig
	icon = 'male_orange_wig.dmi'
obj/items/wearable/wigs/male_chess_wig
	icon = 'male_chess_wig.dmi'
obj/items/wearable/wigs/male_redblack_wig
	icon = 'male_redblack_wig.dmi'
	name = "male red and black wig"

//Holiday//
obj/items/wearable/wigs/male_christmas_wig
	icon = 'male_christmas_wig.dmi'
	dropable = 0
obj/items/wearable/wigs/male_halloween_wig
	icon = 'male_halloween_wig.dmi'
/////////

obj/items/wearable/wigs/female_black_wig
	icon = 'female_black_wig.dmi'
obj/items/wearable/wigs/female_blonde_wig
	icon = 'female_yellow_wig.dmi'
	name = "female yellow wig"
obj/items/wearable/wigs/female_blue_wig
	icon = 'female_lightblue_wig.dmi'
	name = "female light blue wig"
obj/items/wearable/wigs/female_brown_wig
	icon = 'female_brown_wig.dmi'
obj/items/wearable/wigs/female_blackgreen_wig
	icon = 'female_blackgreen_wig.dmi'
obj/items/wearable/wigs/female_green_wig
	icon = 'female_green_wig.dmi'
obj/items/wearable/wigs/female_grey_wig
	icon = 'female_grey_wig.dmi'
obj/items/wearable/wigs/female_pink_wig
	icon = 'female_lightpink_wig.dmi'
	name = "female light pink wig"
obj/items/wearable/wigs/female_purple_wig
	icon = 'female_lightpurple_wig.dmi'
	name = "female light purple wig"
obj/items/wearable/wigs/female_darkpurple_wig
	icon = 'female_darkpurple_wig.dmi'
	name = "female dark purple wig"
obj/items/wearable/wigs/female_silver_wig
	icon = 'female_silver_wig.dmi'
obj/items/wearable/wigs/female_redblack_wig
	icon = 'female_redblack_wig.dmi'
	name = "female red and black wig"
obj/items/wearable/wigs/female_soleil_wig
	icon = 'female_soleil_wig.dmi'
	name = "female blonde wig"
obj/items/wearable/wigs/female_rainbow_wig
	icon = 'female_rainbow_wig.dmi'
	name = "female rainbow wig"
obj/items/wearable/wigs/female_cyan_wig
	icon = 'female_cyan_wig.dmi'
obj/items/wearable/wigs/female_darkblue_wig
	icon = 'female_darkblue_wig.dmi'
	name = "female dark blue wig"
obj/items/wearable/wigs/female_darkpink_wig
	icon = 'female_darkpink_wig.dmi'
	name = "female dark pink wig"
obj/items/wearable/wigs/female_orange_wig
	icon = 'female_orange_wig.dmi'
obj/items/wearable/wigs/female_red_wig
	icon = 'female_red_wig.dmi'
obj/items/wearable/wigs/female_teal_wig
	icon = 'female_teal_wig.dmi'
obj/items/wearable/wigs/female_royale_wig
	icon = 'female_royale_wig.dmi'
obj/items/wearable/wigs/female_chess_wig
	icon = 'female_chess_wig.dmi'

//Holiday//
obj/items/wearable/wigs/female_christmas_wig
	icon = 'female_christmas_wig.dmi'
	dropable = 0
obj/items/wearable/wigs/female_halloween_wig
	icon = 'female_halloween_wig.dmi'
/////////

obj/items/wearable/shoes
	desc   = "A pair of shoes. They look comfy!"
	bonus  = 0
	gender = PLURAL
	Armor = 3

	Equip(var/mob/Player/owner, var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] throws \his pair of [src.name] on.")
			for(var/obj/items/wearable/shoes/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")
obj/items/wearable/shoes/green_shoes
	icon = 'green_shoes.dmi'
obj/items/wearable/shoes/blue_shoes
	icon = 'lightblue_shoes.dmi'
	name = "light blue shoes"
obj/items/wearable/shoes/darkblue_shoes
	icon = 'darkblue_shoes.dmi'
	name = "dark blue shoes"
obj/items/wearable/shoes/red_shoes
	icon = 'red_shoes.dmi'
obj/items/wearable/shoes/yellow_shoes
	icon = 'yellow_shoes.dmi'
obj/items/wearable/shoes/white_shoes
	icon = 'white_shoes.dmi'
obj/items/wearable/shoes/orange_shoes
	icon = 'orange_shoes.dmi'
obj/items/wearable/shoes/teal_shoes
	icon = 'teal_shoes.dmi'
obj/items/wearable/shoes/cyan_shoes
	icon = 'cyan_shoes.dmi'
obj/items/wearable/shoes/purple_shoes
	icon = 'lightpurple_shoes.dmi'
	name = "light purple shoes"
obj/items/wearable/shoes/darkpurple_shoes
	icon = 'darkpurple_shoes.dmi'
	name = "dark purple shoes"
obj/items/wearable/shoes/black_shoes
	icon = 'black_shoes.dmi'
obj/items/wearable/shoes/grey_shoes
	icon = 'grey_shoes.dmi'
obj/items/wearable/shoes/royale_shoes
	icon = 'royale_shoes.dmi'
obj/items/wearable/shoes/pink_shoes
	icon = 'lightpink_shoes.dmi'
	name = "light pink shoes"
obj/items/wearable/shoes/darkpink_shoes
	icon = 'darkpink_shoes.dmi'
	name = "dark pink shoes"
obj/items/wearable/shoes/candycane_shoes
	icon = 'candycane_shoes.dmi'
	name = "candy cane shoes"
obj/items/wearable/shoes/duel_shoes
	icon = 'duel_shoes.dmi'
obj/items/wearable/shoes/blood_shoes
	icon = 'blood_shoes.dmi'


obj/items/wearable/scarves
	bonus = 0
	desc = "A finely knit scarf designed to keep your neck toasty warm."
	Armor = 3

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] wraps \his [src.name] around \his neck.")
			for(var/obj/items/wearable/scarves/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")
obj/items/wearable/scarves/yellow_scarf
	icon = 'scarf_yellow.dmi'
obj/items/wearable/scarves/black_scarf
	icon = 'scarf_black.dmi'
obj/items/wearable/scarves/blue_scarf
	icon = 'scarf_lightblue.dmi'
	name = "light blue scarf"
obj/items/wearable/scarves/darkblue_scarf
	icon = 'scarf_darkblue.dmi'
	name = "dark blue scarf"
obj/items/wearable/scarves/cyan_scarf
	icon = 'scarf_cyan.dmi'
obj/items/wearable/scarves/green_scarf
	icon = 'scarf_green.dmi'
obj/items/wearable/scarves/grey_scarf
	icon = 'scarf_grey.dmi'
obj/items/wearable/scarves/orange_scarf
	icon = 'scarf_orange.dmi'
obj/items/wearable/scarves/pink_scarf
	icon = 'scarf_lightpink.dmi'
	name = "light pink scarf"
obj/items/wearable/scarves/darkpink_scarf
	icon = 'scarf_darkpink.dmi'
	name = "dark pink scarf"
obj/items/wearable/scarves/purple_scarf
	icon = 'scarf_lightpurple.dmi'
	name = "light purple scarf"
obj/items/wearable/scarves/darkpurple_scarf
	icon = 'scarf_darkpurple.dmi'
	name = "dark purple scarf"
obj/items/wearable/scarves/red_scarf
	icon = 'scarf_red.dmi'
obj/items/wearable/scarves/teal_scarf
	icon = 'scarf_teal.dmi'
obj/items/wearable/scarves/white_scarf
	icon = 'scarf_white.dmi'
obj/items/wearable/scarves/duel_scarf
	icon = 'scarf_duel.dmi'
obj/items/wearable/scarves/sunset_scarf
	icon = 'scarf_sunset.dmi'
obj/items/wearable/scarves/blood_scarf
	icon = 'scarf_blood.dmi'

obj/items/wearable/scarves/lucifer_scarf
	icon = 'scarf_lucifer.dmi'
	name = "Lucifer's Scarf"
obj/items/wearable/scarves/lucifer2_scarf
	icon = 'scarf_lucifer2.dmi'
	name = "Lucifer's Scarf"
obj/items/wearable/scarves/casimir_scarf
	icon = 'scarf_casimir.dmi'
	name = "Casimir's Scarf"
obj/items/wearable/scarves/royale_scarf
	icon = 'scarf_royale.dmi'

//Holiday//
obj/items/wearable/scarves/candycane_scarf
	icon = 'scarf_candycane.dmi'
obj/items/wearable/scarves/american_scarf
	icon = 'scarf_american.dmi'
obj/items/wearable/scarves/halloween_scarf
	icon = 'scarf_halloween.dmi'
obj/items/wearable/scarves/pastel_scarf
	icon = 'scarf_pastel.dmi'

// Community Scarves //

// #1
obj/items/wearable/scarves/heartscarf
	icon = 'scarf_heart.dmi'
obj/items/wearable/scarves/snake_scarf
	icon = 'scarf_snake.dmi'
obj/items/wearable/scarves/booster_scarf
	icon = 'scarf_booster.dmi'
obj/items/wearable/scarves/alien_scarf
	icon = 'scarf_alien.dmi'
obj/items/wearable/scarves/icarus_scarf
	icon = 'scarf_icarus.dmi'
obj/items/wearable/scarves/sunrise_scarf
	icon = 'scarf_sunrise.dmi'

// #2
obj/items/wearable/scarves/party_scarf
	icon = 'scarf_party.dmi'
obj/items/wearable/scarves/hello_scarf
	icon = 'scarf_hello.dmi'
obj/items/wearable/scarves/sky_scarf
	icon = 'scarf_sky.dmi'

/////////

mob/Player/var/tmp/resurrect = 0

obj/items/wearable/resurrection_stone
	showoverlay=0
	icon = 'trophies.dmi'
	icon_state = "res"
	var/chance = 40

	Equip(var/mob/Player/owner,var/overridetext=0, var/forceremove=0)
		. = ..(owner, overridetext, forceremove)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] holds onto \his [src.name].")
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] into \his pocket.")

obj/items/wearable/afk
	showoverlay=0
	Equip(var/mob/Player/owner, var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			owner.ApplyAFKOverlay()
			src.gender = owner.gender
			for(var/obj/items/wearable/afk/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			owner.ApplyAFKOverlay()

	pimp_ring
		icon = 'pimpring.dmi'

		Equip(var/mob/Player/owner,var/overridetext=0, var/forceremove=0)
			. = ..(owner, overridetext, forceremove)
			if(. == WORN)
				if(!overridetext)viewers(owner) << infomsg("[owner] hangs \his [src.name] onto \his finger.")
			else if(. == REMOVED)
				if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] into \his pocket.")

	heart_ring
		icon = 'heartring.dmi'

		Equip(var/mob/Player/owner,var/overridetext=0, var/forceremove=0)
			. = ..(owner, overridetext, forceremove)
			if(. == WORN)
				if(!overridetext)viewers(owner) << infomsg("[owner] hangs \his [src.name] onto \his finger.")
			else if(. == REMOVED)
				if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] into \his pocket.")

	hot_chocolate
		icon = 'hotchoco.dmi'

		Equip(var/mob/Player/owner,var/overridetext=0, var/forceremove=0)
			. = ..(owner, overridetext, forceremove)
			if(. == WORN)
				if(!overridetext)viewers(owner) << infomsg("[owner] picks up \his [src.name] and holds it in \his hands.")
			else if(. == REMOVED)
				if(!overridetext)viewers(owner) << infomsg("[owner] puts down \his [src.name].")


obj/items/wearable/bling
	icon = 'bling.dmi'
	Equip(var/mob/Player/owner,var/overridetext=0)
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] hangs \his [src.name] around his neck.")
			for(var/obj/items/wearable/bling/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] stuffs \his copious amounts of [src.name] into \his pocket.")

mob/Player/var/tmp/obj/cloakReflection

obj/items/wearable/magic_eye
	icon = 'MoodyEye.dmi'
	desc = "This magical eye allows the wearer to see through basic and intermediate invisibility magic."
	wear_layer = FLOAT_LAYER - 6
	Equip(var/mob/Player/owner,var/overridetext=0)
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] jams \his magical eye into \his eye socket.")
//			if(!owner.see_invisible)owner.see_invisible = 1
			for(var/obj/items/wearable/magic_eye/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
//			owner.Interface.SetDarknessColor(MAGICEYE_COLOR, 1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes out \his magical eye from its socket.")
//			if(owner.see_invisible < 2)owner.see_invisible = 0
//			owner.Interface.SetDarknessColor(MAGICEYE_COLOR)

	silly_eye
		desc = "A silly eye that has no purpose but has a long history."


obj/items/wearable/invisibility_cloak
	icon = 'invis_cloak.dmi'
	showoverlay=0
	desc = "This magical cloak renders the wearer invisible."
	max_stack = 1
	dropable = 0

	var/time

	New()
		..()

		time = world.realtime

	Equip(var/mob/Player/owner,var/overridetext=0)
		if(owner.findStatusEffect(/StatusEffect/Decloaked))
			owner << errormsg("You are unable to cloak right now.")
			return
		if(locate(/obj/items/wearable/brooms) in owner.Lwearing)
			owner << errormsg("Your cloak isn't big enough to cover you and your broom.")
			return
		if(istype(owner.loc.loc,/area/arenas) && !(locate(/obj/items/wearable/invisibility_cloak) in owner.Lwearing))
			owner << errormsg("You cannot wear a cloak here.")
			return
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] fastens \the [src.name] around \his shoulders and disappears.")
			for(var/obj/items/wearable/invisibility_cloak/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)

			var/a = clamp(round((world.realtime - time) / 432000), 0, 255)
			if(!overridetext) owner << infomsg("You put on the cloak and become invisible to others.")

			if(!owner.cloakReflection)
				owner.cloakReflection = new
				owner.cloakReflection.loc = owner.loc
				owner.cloakReflection.appearance = owner.appearance
				owner.cloakReflection.alpha = 200
				owner.cloakReflection.mouse_opacity = 0
				owner.cloakReflection.invisibility = 1
				owner.addFollower(owner.cloakReflection)

			owner.FlickState("m-black",8,'Effects.dmi')
			owner.alpha = a

		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] appears from nowhere as \he removes \his [src.name].")

			owner.alpha = 255
			if(owner.cloakReflection)
				owner.removeFollower(owner.cloakReflection)
				owner.cloakReflection.loc = null
				owner.cloakReflection = null

obj/items/wearable/title
	var/title = ""
	icon = 'Scroll.dmi'
	icon_state = "title"
	desc = ""

	showoverlay = FALSE

	stackName = "Titles:"

	useTypeStack = 1

	Compare(obj/items/i)
		. = ..()

		return . && i:title == title

	Clone()
		var/obj/items/wearable/title/t = ..()

		t.title = title
		t.name  = name

		return t

	Equip(var/mob/Player/owner,var/overridetext=0)
		if(owner.level < 501)
			owner << errormsg("You need to be a Hogwarts Graduate to wear this.")
			return
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] wears \his \"[title]\" title.")
			for(var/obj/items/wearable/title/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
			if(owner.Rank == "Player") owner.Rank = title
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] removes \his title.")
			if(owner.Rank == title) owner.Rank = "Player"

	Custom
	Slayer
	Rich
		title = "Rich"
		name  = "Title: Rich"
	Treasure_Hunter
		title = "Treasure Hunter"
		name  = "Title: Treasure Hunter"
	Genie
		title = "Genie's Friend"
		name  = "Title: Genie's Friend"
	Warmonger
		title = "Warmonger"
		name  = "Title: Warmonger"
	Warrior
		title = "Warrior"
		name  = "Title: Warrior"
	Snowflakes
		title = "Snowflakes Collector"
		name  = "Title: Snowflakes Collector"
	Petrified
		title =  "Petrified Victim"
		name  =  "Title: Petrified Victim"
	Bookworm
		title =  "Bookworm"
		name  =  "Title: Bookworm"
	Lumberjack
		title =  "Lumberjack"
		name  =  "Title: Lumberjack"
	Eye
		title =  "One Eyed"
		name  =  "Title: One Eyed"
	Magic
		title =  "Magical"
		name  =  "Title: Magical"
	Ghost
		title =  "Ghost"
		name  =  "Title: Ghost"
	Troll
		title =  "Face of Troll"
		name  =  "Title: Face of Troll"
	Duelist
		title =  "Duelist"
		name  =  "Title: Duelist"
	Wizard
		title =  "Wizard"
		name  =  "Title: Wizard"
	Determined
		title =  "Determined"
		name  =  "Title: Determined"
	Battlemage
		title =  "Battlemage"
		name  =  "Title: Battlemage"
	Hunter
		title = "Hunter"
		name  = "Title: Hunter"
	Pest
		title = "Pest Control"
		name  = "Title: Pest Control"
	Exterminator
		title = "Exterminator"
		name  = "Title: Exterminator"
	Surf
		title = "Surfer"
		name  = "Title: Surfer"
	Fallen
		title = "The Fallen"
		name  = "Title: The Fallen"
	Gambler
		title = "The Gambler"
		name  = "Title: The Gambler"
	Crawler
		title = "Crawler"
		name  = "Title: Crawler"
	Pirate
		title = "Pirate"
		name  = "Title: Pirate"
	TWC
		title = "I <3 TWC"
		name  = "Title: I <3 TWC"
	Earthbender
		title = "Earthbender"
		name  = "Title: Earthbender"
	Airbender
		title = "Airbender"
		name  = "Title: Airbender"
	Firebender
		title = "Firebender"
		name  = "Title: Firebender"
	Waterbender
		title = "Waterbender"
		name  = "Title: Waterbender"
	Legionnaire
		title = "Legionnaire"
		name  = "Title: Legionnaire"
	Myrmidon
		title = "Myrmidon"
		name  = "Title: Myrmidon"
	Myrmidon
		title = "Myrmidon"
		name  = "Title: Myrmidon"
	Best_Friend
		title = "Best Friend"
		name  = "Title: Best Friend"
	Scavenger
		title = "Scavenger"
		name  = "Title: Scavenger"
	Samurai
		title = "Samurai"
		name  = "Title: Samurai"
	Undead
		title = "Undead"
		name  = "Title: Undead"
	Frozen
		title = "Frozen"
		name  = "Title: Frozen"
	Demonic
		title = "Demonic"
		name  = "Title: Demonic"
	Wrecker
		title = "Wrecker"
		name  = "Title: Wrecker"
	Illusionist
		title = "Illusionist"
		name  = "Title: Illusionist"

mob/Bump(obj/ball/B)
	if(istype(B,/obj/ball))
		B.Roll(dir)
		return
	else
		..()
obj
	ball
		icon='balloon.dmi'
		icon_state="blue"
		density = 1
		var/velocity = 0
		Bump(atom/A)
			if(A.density)
				velocity--
				dir = turn(dir, pick(45,-45) + 180)
			else
				..()
		proc
			Roll(dire)
				dir = dire
				if(velocity <= 0)
					velocity = 5
				while(velocity > 0)
					velocity--
					step(src,dir)
					sleep(2)

turf/nofirezone
	Enter(obj/o)
		if(istype(o, /obj/projectile))
			o.Dispose()
		else
			.=..()
	Exit(obj/o)
		if(istype(o, /obj/projectile))
			o.Dispose()
		else
			.=..()
turf/DynamicArena
	name = "Arena"
	icon = 'turf.dmi'
	icon_state = "grass1"
WorldData/var/tmp/arenaSummon = 0
	//0 = off
	//1 = mapOne	House Wars
	//2 = mapTwo	Clan Wars
	//3 = MapThree	FFA
mob/GM/verb/Arena_Summon()
	set category = "Events"
	if(worldData.currentArena)
		src << "Arena summon can't be used while a match has already started."
		return
	if(worldData.arenaSummon == 0)
		var/map = input("Which Map do you want to allow teleportation to?") as null|anything in list("House Wars", "Free-For-All")
		if(!map) return
		switch(map)
			if("House Wars")
				worldData.arenaSummon = 1
			if("Free-For-All")
				worldData.arenaSummon = 3
		for(var/mob/Player/p in Players)
			p << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[p];action=arena_teleport\">click here to teleport.</a></h3>"
	else
		var/ans = alert("Do you want to re-announce the teleport message, or disable it?",,"Re-announce","Disable","Cancel")
		switch(ans)
			if("Re-announce")
				var/map
				switch(worldData.arenaSummon)
					if(1)
						map = "House Wars"
					if(3)
						map = "Free-For-All"
				for(var/mob/Player/p in Players)
					p << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[p];action=arena_teleport\">click here to teleport.</a></h3>"
			if("Disable")
				worldData.arenaSummon = 0
mob/GM/verb/Arena()
	set category = "Events"
	if(worldData.currentArena)
		del worldData.currentArena
		src << "Previous round deleted."
		return
	var/list/plyrs = list()
	worldData.currentArena = new()
	switch(alert("House Wars or Free For All?","Game type","House Wars","FFA","Cancel"))
		if("House Wars")
			alert("Players (and you) must be on MapOne when you click OK to be loaded into the round. Arena Summon is disabled when you press OK")
			worldData.arenaSummon = 0
			worldData.currentArena.roundtype = HOUSE_WARS
			for(var/mob/Player/M in locate(/area/arenas/MapOne/Gryff))
				plyrs.Add(M)
			for(var/mob/Player/M in locate(/area/arenas/MapOne/Slyth))
				plyrs.Add(M)
			for(var/mob/Player/M in locate(/area/arenas/MapOne/Huffle))
				plyrs.Add(M)
			for(var/mob/Player/M in locate(/area/arenas/MapOne/Raven))
				plyrs.Add(M)

			var/mob/m = locate("MapOne")
			for(var/mob/Player/M in m.loc.loc)
				plyrs.Add(M)
		if("FFA")
			alert("Players (and you) must be on MapThree when you click OK to be loaded into the round. Arena Summon is disabled when you press OK")
			worldData.arenaSummon = 0
			worldData.currentArena.roundtype = FFA_WARS
			for(var/mob/M in locate(/area/arenas/MapThree/WaitingArea))
				if(M.client)
					plyrs.Add(M)
		if("Cancel")
			del worldData.currentArena
			return
	worldData.currentArena.players.Add(plyrs)
	switch(worldData.currentArena.roundtype)
		if(FFA_WARS)
			if(!worldData.currentArena) return
			src << "FFA map selected"
			for(var/mob/M in worldData.currentArena.players)
				M << "<u>Preparing arena round...</u>"
			alert("Prizes are not automatically given in this Arena Mode. Round will start when you press OK.")
			worldData.currentArena.players << "<center><font size = 4>The arena mode is <u>Free For All</u>. Everyone is your enemy.<br>The last person standing wins!</center>"
			sleep(30)
			if(!worldData.currentArena) return
			worldData.currentArena.players << "<h5>Round starting in 10 seconds</h5>"
			sleep(50)
			if(!worldData.currentArena) return
			worldData.currentArena.players << "<h5>5 seconds</h5>"
			sleep(50)
			if(!worldData.currentArena) return
			worldData.currentArena.players << "<h4>Go!</h5>"
			worldData.currentArena.started = 1
			var/list/rndturfs = list()
			for(var/turf/T in locate(/area/arenas/MapThree/PlayArea))
				rndturfs.Add(T)
			worldData.currentArena.speaker = pick(MapThreeWaitingAreaTurfs)
			for(var/mob/Player/M in worldData.currentArena.players)
				var/turf/T = pick(rndturfs)
				M.loc = T
				M.density = 1
				M.HP = M.MHP
				M.MP = M.MMP
				M.updateHPMP()
		if(HOUSE_WARS)
			if(!worldData.currentArena) return
			src << "House wars map selected"
			worldData.currentArena.players << "<u>Preparing arena round...</u>"
			var/killsreq = input("How many kills must a team have to win?",,10) as num
			worldData.currentArena.goalpoints = killsreq
			worldData.currentArena.teampoints = list("Gryffindor" = 0, "Ravenclaw" = 0, "Slytherin" = 0,"Hufflepuff" = 0)
			worldData.currentArena.plyrSpawnTime = input("How long must a player wait to respawn (in seconds)?",,5) as num
			worldData.currentArena.amountforwin = input("How many house points does the winning team receive?",,10) as num
			for(var/mob/Player/M in worldData.currentArena.players)
				switch(M.House)
					if("Hufflepuff")
						var/obj/Bed/B = pick(Map1Hbeds)
						M.loc = B.loc
					if("Gryffindor")
						var/obj/Bed/B = pick(Map1Gbeds)
						M.loc = B.loc
					if("Ravenclaw")
						var/obj/Bed/B = pick(Map1Rbeds)
						M.loc = B.loc
					if("Slytherin")
						var/obj/Bed/B = pick(Map1Sbeds)
						M.loc = B.loc
				M.dir = SOUTH
				M.HP = M.MHP
				M.MP = M.MMP
				M.updateHPMP()
			worldData.currentArena.players << "<center><font size = 4>The arena mode is <u>House Wars</u>.<br>The first house to reach [worldData.currentArena.goalpoints] arena points wins [worldData.currentArena.amountforwin] house points!"
			sleep(30)
			if(!worldData.currentArena) return
			worldData.currentArena.players << "<h5>Round starting in 10 seconds</h5>"
			sleep(100)
			if(!worldData.currentArena) return
			worldData.currentArena.players << "<h4>Go!</h5>"
			worldData.currentArena.started = 1

mob/Del()
	Players -= src
	..()

mob/Player/Logout()
	Players<<"<B><span style=\"font-size:2; color:red;\"><I>[src] <b>logged out.</b></I></span></B>"
	if(arcessoing)
		stop_arcesso()
	if(rankedArena)
		rankedArena.disconnect(src)
	else if(worldData.currentMatches.queue && (src in worldData.currentMatches.queue))
		worldData.currentMatches.removeQueue(src)
	if(worldData.currentArena)
		if(src in worldData.currentArena.players)
			//currentArena.players.Remove(src)
			src.HP = 0
			src.Death_Check(src)
			src.loc = locate(50,49,15)
			src.GMFrozen = 0
	if(loc && loc.loc)
		var/area/a = loc.loc
		if(a.region)
			a.Exited(src)
			a.region.Exited(src)
		else
			loc.loc.Exited(src)
	if(removeoMob)
		var/tmpmob = removeoMob
		removeoMob:removeoMob = null
		src = null
		spawn()
			tmpmob:ReturnToStart()
	if(control)
		control:uncontrol(src)
	..()
var/const
	HOUSE_WARS = 1
		//First team to get to a specific number of kills, wins.
	FFA_WARS = 3
		//First player to get a specific number of kills, wins.
	REWARD_GOLD = 1
	REWARD_POINTS = 2
WorldData/var/tmp/arena_round/currentArena = null

arena_round


	var
		turf/speaker
		rewardforwin = REWARD_GOLD
		amountforwin = 10
		roundtype = HOUSE_WARS
		started = 0
		list/players = list()
		list/teampoints = list()
		goalpoints //	points/kills needed to win
		plyrSpawnTime = 0
	Del()
		for(var/mob/Player/M in players)
			M.GMFrozen = 0
		clanevent1 = 0
		for(var/obj/clanpillar/C in world)
			C.disable()
	proc
		handleSpawnDelay(mob/Player/M)
			set waitfor = 0
			M.nomove = 2
			sleep(plyrSpawnTime*10)
			M.nomove = 0
			M << "<i><u>You can now move again.</u></i>"
		Add_Point(team,amount)
			//Only used in Arena
			teampoints["[team]"] += amount
			if(teampoints["[team]"] >= goalpoints)
				players << "<h4>[team] win!</h4>"
				for(var/mob/M in players)
					M << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[M];action=arena_leave\">clicking here.</a></b>"
				switch(team)
					if("Gryffindor")
						worldData.housepointsGSRH[1] += amountforwin
					if("Slytherin")
						worldData.housepointsGSRH[2] += amountforwin
					if("Ravenclaw")
						worldData.housepointsGSRH[3] += amountforwin
					if("Hufflepuff")
						worldData.housepointsGSRH[4] += amountforwin
				Players << "\red[team] have earned [amountforwin] points."
				Save_World()
				del(worldData.currentArena)

		Reward(var/mob/Player/plyr,amount)
			//ONly used in Arena
			if(rewardforwin == REWARD_GOLD)
				var/gold/g = new(bronze=amount)
				g.give(plyr)
				plyr << "You have been awarded [g.toString()]."
			else if(rewardforwin == REWARD_POINTS)
				plyr << "You have earnt [amount] points for [plyr.House]"
				switch(plyr.House)
					if("Gryffindor")
						worldData.housepointsGSRH[1] += amount
					if("Slytherin")
						worldData.housepointsGSRH[2] += amount
					if("Ravenclaw")
						worldData.housepointsGSRH[3] += amount
					if("Hufflepuff")
						worldData.housepointsGSRH[4] += amount
obj/clanpillar
	density = 0
	invisibility = 101
	name = "Peace headquarters"
	icon = 'clanpillar.dmi'
	icon_state = "Auror"

	var
		HP = 50
		MHP = 50
		clan = "Auror"
		tmp/obj/healthbar/hpbar

	proc
		Death_Check(mob/Player/attacker)
			if(HP<1)
				if(clan == "Deatheater")
					clanwars_event.add_auror(10)
					attacker.addRep(10)
				else if(clan == "Auror")
					clanwars_event.add_de(10)
					attacker.addRep(-10)

				Players << "[attacker] has destroyed [name] and earned 10 points for the [clan == "Deatheater" ? "peace" : "chaos"] clan."

				density = 0
				invisibility = 100
				hpbar.invisibility = 100
				spawn() respawn_count()
			else
				var/percent = HP / MHP
				hpbar.Set(percent, src)
			..()
		enable(MHP2)
			density = 1
			invisibility = 0
			MHP = MHP2
			HP = MHP

			hpbar = new(src)

			for(var/mob/Player/M in Players)
				if(clan == "Deatheater" && M.getRep() < -100)
					M << infomsg("Chaos: <i>\The [src] has respawned.</i>")
				else if(clan == "Auror" && M.getRep() > 100)
					M << infomsg("Peace: <i>\The [src] has respawned.</i>")
		disable()
			density = 0
			invisibility = 100
			if(hpbar)
				hpbar.loc = null
				hpbar = null
		respawn_count()
			spawn()
				if(clanwars)
					for(var/mob/Player/M in Players)
						if(clan == "Deatheater" && M.getRep() < -100)
							M << "<font color = white><i>\The [src] will respawn in 2 minutes."
						else if(clan == "Auror" && M.getRep() > 100)
							M << "<font color = white><i>\The [src] will respawn in 2 minutes."
					sleep(1200)

				if(!clanwars) return
				density = 1
				invisibility = 0
				hpbar.invisibility = 0
				HP = MHP

				if(clanwars)
					for(var/mob/Player/M in Players)
						if(clan == "Auror" && M.getRep() > 100)
							M << infomsg("Peace: <i>\The [src] has respawned.</i>")
						else if(clan == "Deatheater" && M.getRep() < -100)
							M << infomsg("Chaos: <i>\The [src] has respawned.</i>")
var
	clanevent1 = 0
	clanevent1_respawntime
	clanevent1_pointsgivenforpillarkill
	clanevent1_pointsgivenforkill
var/oldduelmode = 0
mob/test/verb/Old_duel_mode()
	set category = "Events"
	oldduelmode = !oldduelmode
	if(oldduelmode)
		src << "Old duel mode is now on."
	else
		src << "Old duel mode is now off."



obj/items/easterbook
	name="The Easter Bunnies Guide to Magic"
	icon='Books.dmi'
	icon_state="easter"
	desc = "Who would of thought the Easter bunny wrote a book..."
	rarity = 2
	Click()
		if(src in usr)
			usr.verbs += /mob/Spells/verb/Shelleh
			usr<<"<b><font color=white><font size=3>You learned Shelleh."
			Consume()
		else
			..()

obj/items/rosesbook
	name="The Book of Roses"
	icon='Books.dmi'
	icon_state="roses"
	desc = "The cover is so pretty!"
	rarity = 2
	Click()
		if(src in usr)
			usr<<"<b><font color=red><font size=3>You learned Herbificus Maxima."
			usr.verbs += /mob/Spells/verb/Herbificus_Maxima
			Consume()
		else
			..()


obj/items/spellbook
	icon       = 'Books.dmi'
	icon_state = "spell"
	rarity = 2

	var
		spell

		r = 0
		g = 0
		b = 0

	projectile
		g = 0.5
		b = 0.5
		New()

			spell = pick(/mob/Spells/verb/Glacius, /mob/Spells/verb/Tremorio, /mob/Spells/verb/Waddiwasi)
			name  = spellList[spell]

			name = pick("All about [name]", "Book of [name]", "Mystery of [name]", "[name]: 101")

			..()

	New()
		..()

		if(!spell)
			spell = pick(spellList)
			name  = spellList[spell]

			name = pick("All about [name]", "Book of [name]", "Mystery of [name]", "[name]: 101")

	Click()
		if(src in usr)

			if(usr.client.color) return

			usr << infomsg("You attempt to read [name]")

			var/mob/Spells/verb/generic = spell

			if(spell in usr.verbs)
				animate(usr.client, color = list(1.5,1.5,1.5,
		                						 1.5,1.5,1.5,
		                          				 1.5,1.5,1.5,
		                         				 -1,-1,-1), time = 10)

				usr << errormsg("You already know [generic.name].")
			else

				animate(usr.client, color = list(1 + r,1 + g,1 + b,
		                          				 1 + r,1 + g,1 + b,
		                          				 1 + r,1 + g,1 + b,
		                         				 -1,-1,-1), time = 10)

				usr << infomsg("You learned [generic.name].")
				usr.verbs += spell
				Consume()

			sleep(15)
			animate(usr.client, color = null, time = 10)

		else
			..()

	blood
		name = "Book of Chaos: Vol II"
		icon_state = "chaos"
		spell = /mob/Spells/verb/Sanguinis_Iactus
		r = 0.6

	avada
		name = "Book of The Noseless"
		icon_state = "de"
		spell = /mob/Spells/verb/Avada_Kedavra
		g = 0.6

	basilio
		name = "Demonic's Journal"
		icon_state = "slyth"
		spell = /mob/Spells/verb/Basilio
		g = 0.6

	felinious
		name = "Book of Bad Luck"
		icon_state = "spell"
		spell = /mob/Spells/verb/Felinious
		g = 0.5
		b = 0.5

	illusion
		name = "A Trick of the Light"
		icon_state = "rmagic"
		spell = /mob/Spells/verb/Illusio
		g = 0.5
		b = 0.5

	gladius
		name = "Confused Swords and How to Conjure Them"
		icon_state = "spell"
		spell = /mob/Spells/verb/Gladius
		r = 0.5
		b = 0.5

	inferi
		name = "Book of The Dead"
		icon_state = "de"
		spell = /mob/Spells/verb/Inferius
		r = 0.6

	aggravate
		name = "Book of Chaos: Vol III"
		icon_state = "chaos"
		spell = /mob/Spells/verb/Aggravate
		r = 0.6

	darkmark
		name = "Book of Loyality"
		icon_state = "de"
		r = 0.6
		g = 0.6
		b = 0.6
		spell = /mob/Spells/verb/Morsmordre

	peace
		name = "Book of Peace: Vol II"
		icon_state = "peace"
		spell = /mob/Spells/verb/Immobulus
		b = 0.6
		g = 0.5

	lumos
		name = "Book of Peace: Vol III"
		icon_state = "peace"
		spell = /mob/Spells/verb/Lumos_Maxima
		b = 0.6
		g = 0.5


obj/items/stickbook
	name="The Crappy Artist's Guide to Stick Figures"
	icon='Books.dmi'
	icon_state="stick"
	desc = "Remind me why I bought this?"
	rarity = 2
	Click()
		if(src in usr)
			usr << infomsg("You learned Crapus Sticketh.")
			usr.verbs += /mob/Spells/verb/Crapus_Sticketh
			Consume()
		else
			..()

obj/items/easter_egg
	icon='Eggs.dmi'
	desc="A colored easter egg! How nice!"
	rarity  = 2

	New()
		..()
		spawn(1)
			if(!icon_state) icon_state = pick(icon_states(icon))

	Click()
		if(src in usr)
			new/obj/egg(usr.loc)
			Consume()

		else
			..()
obj/egg
	icon='Eggs.dmi'
	icon_state="egg"
	density=1
	var/HP

	proc
		Hit()
			HP--
			if(HP <= 0)
				if(prob(10))
					new /obj/items/easter_egg(loc)
				loc=null

			pixel_y++
			spawn(1)
				pixel_y--



	New()
		..()
		HP=rand(5,10)

		src.FlickState("Orb",12,'Effects.dmi')

		pixel_x = rand(-6,6)
		pixel_y = rand(-6,6)

		spawn(rand(600,1200))
			loc=null

obj/items/artifact
	icon       = 'trophies.dmi'
	icon_state = "Ring"
	rarity     = 3

obj/items/ember_of_despair
	icon       = 'attacks.dmi'
	icon_state = "flame"
	rarity     = 3

obj/items/ember_of_frost
	icon       = 'attacks.dmi'
	icon_state = "frost"
	rarity     = 3


obj/items/lamps
	icon       = 'lamp.dmi'
	icon_state = "inactive"
	var
		effect
		seconds
		tmp/StatusEffect/S

	useTypeStack = 1
	stackName = "Lamps:"

	rarity  = 2

	Clone()
		var/obj/items/lamps/i = new type

		i.owner      = owner
		i.name       = name
		i.icon_state = icon_state
		i.seconds    = seconds

		return i

	Compare(obj/items/lamps/i)
		return i.name == name && i.type == type && i.owner == owner && i.icon_state == icon_state && i.seconds == seconds && i.max_stack == max_stack

	double_drop_rate_lamp
		desc    = "Increases your drop rate x2."
		effect  = /StatusEffect/Lamps/DropRate/Double
		seconds = 1800
	triple_drop_rate_lamp
		desc    = "Increases your drop rate x3."
		effect  = /StatusEffect/Lamps/DropRate/Triple
		seconds = 1800
	quadaple_drop_rate_lamp
		name = "quadruple drop rate lamp"
		desc    = "Increases your drop rate x4."
		effect  = /StatusEffect/Lamps/DropRate/Quadruple
		seconds = 1800
	penta_drop_rate_lamp
		name = "quintuple drop rate lamp"
		desc    = "Increases your drop rate x5."
		effect  = /StatusEffect/Lamps/DropRate/Quintuple
		seconds = 900
	sextuple_drop_rate_lamp
		desc    = "Increases your drop rate x6."
		effect  = /StatusEffect/Lamps/DropRate/Sextuple
		seconds = 600

	double_exp_lamp
		desc    = "Increases your exp gain x2."
		effect  = /StatusEffect/Lamps/Exp/Double
		seconds = 1800
	triple_exp_lamp
		desc    = "Increases your exp gain x3."
		effect  = /StatusEffect/Lamps/Exp/Triple
		seconds = 1800
	quadaple_exp_lamp
		name = "quadruple exp lamp"
		desc    = "Increases your exp gain x4."
		effect  = /StatusEffect/Lamps/Exp/Quadruple
		seconds = 1800
	penta_exp_lamp
		name = "quintuple exp lamp"
		desc    = "Increases your exp gain x5."
		effect  = /StatusEffect/Lamps/Exp/Quintuple
		seconds = 900
	sextuple_exp_lamp
		desc    = "Increases your exp gain x6."
		effect  = /StatusEffect/Lamps/Exp/Sextuple
		seconds = 600

	double_gold_lamp
		desc    = "Increases your gold gain x2."
		effect  = /StatusEffect/Lamps/Gold/Double
		seconds = 1800
	triple_gold_lamp
		desc    = "Increases your gold gain x3."
		effect  = /StatusEffect/Lamps/Gold/Triple
		seconds = 1800
	quadaple_gold_lamp
		name = "quadruple gold lamp"
		desc    = "Increases your gold gain x4."
		effect  = /StatusEffect/Lamps/Gold/Quadruple
		seconds = 1800
	penta_gold_lamp
		name = "quintuple gold lamp"
		desc    = "Increases your gold gain x5."
		effect  = /StatusEffect/Lamps/Gold/Quintuple
		seconds = 900
	sextuple_gold_lamp
		desc    = "Increases your gold gain x6."
		effect  = /StatusEffect/Lamps/Gold/Sextuple
		seconds = 600

	damage_lamp
		desc    = "Increases your damage."
		effect  = /StatusEffect/Lamps/Damage
		seconds = 600
	defense_lamp
		desc    = "Increases your defense."
		effect  = /StatusEffect/Lamps/Defense
		seconds = 600
	power_lamp
		desc    = "Increases your overall power."
		effect  = /StatusEffect/Lamps/Power
		seconds = 300

	Click()
		if(src in usr)
			if(S)
				S.Deactivate()
			else

				if(findtext(name, " exp ") && (locate(/obj/items/wearable/seal_bracelet) in usr:Lwearing))
					usr << errormsg("You can't use this while wearing a seal bracelet.")
					return

				if(stack > 1)
					var/obj/items/lamps/l = Split(1)
					l.max_stack = 1
					l.Move(src)
					S = new effect (usr, l.seconds, "Lamp", l)
				else
					S = new effect (usr, seconds, "Lamp", src)
		else
			..()

	Drop()
		if(S)
			S.Deactivate()
		..()
obj/items
	portduelsystem
		name = "Portable Duel System"
		icon = 'DuelArena.dmi'
		icon_state = "c4"
		max_stack = 1
		var/tmp/Duel/D
		var/unpacked = 0
		var/ckeyowner
		var/list/obj/dueltiles = list()
		verb/Disown()
			var/input = alert("Are you sure you wish to allow anyone to pick this system up?",,"Yes","No")
			if(input == "Yes")
				ckeyowner = null
				usr << "Your Portable Duel System can now be picked up by anyone."

		Take()
			if(ckeyowner == usr.ckey)
				if(!D)
					if(!unpacked)
						usr << errormsg("System is not completely deployed yet.")
						return
					if(unpacked)Packup()
					..()
				else
					usr << errormsg("There is currently a duel taking place.")
			else if(!ckeyowner)
				ckeyowner = usr.ckey
				if(!D)
					if(unpacked)Packup()
					..()
				else
					usr << errormsg("There is currently a duel taking place.")
			else
				usr << errormsg("You do not have permission to pick this up.")
		Drop()
			..()
			if(ckeyowner)Unpack()
		proc/Packup()
			duelsystems.Remove(src)
			unpacked = 0
			var/obj/portduelsystemtiles/c1
			var/obj/portduelsystemtiles/c2
			var/obj/portduelsystemtiles/c3
			var/obj/portduelsystemtiles/c5
			var/obj/portduelsystemtiles/c6
			var/obj/portduelsystemtiles/c7
			for(var/obj/portduelsystemtiles/c1/c in dueltiles)
				c1 = c
			for(var/obj/portduelsystemtiles/c2/c in dueltiles)
				c2 = c
			for(var/obj/portduelsystemtiles/c3/c in dueltiles)
				c3 = c
			for(var/obj/portduelsystemtiles/c5/c in dueltiles)
				c5 = c
			for(var/obj/portduelsystemtiles/c6/c in dueltiles)
				c6 = c
			for(var/obj/portduelsystemtiles/c7/c in dueltiles)
				c7 = c
			for(var/obj/duelblock/t in view())
				del(t)
			spawn()step(c1,EAST)
			spawn()step(c7,WEST)
			spawn()step(c2,EAST)
			spawn()step(c6,WEST)
			spawn()step(c3,EAST)
			spawn()step(c5,WEST)
			sleep(6)
			spawn()step(c1,EAST)
			spawn()step(c7,WEST)
			spawn()step(c2,EAST)
			spawn()step(c6,WEST)
			spawn()step(c3,EAST)
			spawn()step(c5,WEST)
			sleep(6)
			del(c3)
			del(c5)
			spawn()step(c1,EAST)
			spawn()step(c7,WEST)
			spawn()step(c2,EAST)
			spawn()step(c6,WEST)
			sleep(6)
			del(c2)
			del(c6)
			spawn()step(c1,EAST)
			spawn()step(c7,WEST)
			sleep(6)
			del(c1)
			del(c7)
			dueltiles=list()
		proc/Unpack()
			duelsystems.Add(src)
			var/obj/portduelsystemtiles/c1/c1 = new(src.loc)
			var/obj/portduelsystemtiles/c7/c7 = new(src.loc)
			src.dueltiles.Add(c1)
			c1.density = 1
			src.dueltiles.Add(c7)
			c7.density = 1
			sleep(6)
			spawn()step(c1,WEST)
			spawn()step(c7,EAST)
			sleep(6)
			var/obj/portduelsystemtiles/c2/c2 = new(src.loc)
			var/obj/portduelsystemtiles/c6/c6 = new(src.loc)
			src.dueltiles.Add(c2)
			c2.density = 1
			src.dueltiles.Add(c6)
			c6.density = 1

			spawn()step(c1,WEST)
			spawn()step(c7,EAST)
			spawn()step(c2,WEST)
			spawn()step(c6,EAST)
			sleep(6)
			var/obj/portduelsystemtiles/c3/c3 = new(src.loc)
			var/obj/portduelsystemtiles/c5/c5 = new(src.loc)
			src.dueltiles.Add(c3)
			c3.density = 1
			src.dueltiles.Add(c5)
			c5.density = 1
			spawn()step(c1,WEST)
			spawn()step(c7,EAST)
			spawn()step(c2,WEST)
			spawn()step(c6,EAST)
			spawn()step(c3,WEST)
			spawn()step(c5,EAST)
			sleep(6)
			spawn()step(c1,WEST)
			spawn()step(c7,EAST)
			spawn()step(c2,WEST)
			spawn()step(c6,EAST)
			spawn()step(c3,WEST)
			spawn()step(c5,EAST)
			sleep(6)
			c1.density = 0
			c7.density = 0
			c2.density = 0
			c6.density = 0
			c3.density = 0
			c5.density = 0
			if(get_dist(c1,c7)<8)
				hearers() << "Portable Duel System: <i>ERROR</i>. Duel path must be clear of obstacles to deploy."
				Packup()
				Move(usr)
			else
				new/obj/duelblock (c3.loc)
				new/obj/duelblock (c5.loc)
				unpacked = 1
		Click()

			if((src in usr) && ckeyowner)
				Drop()
			else
				if(!ckeyowner)
					..()
					return

				if( !(usr in hearers(src)) )return
				if(!unpacked)
					usr << "System is not completely deployed yet."
					return
				if(D)
					if(!D.player1 && D.player2 != usr)
						var/turf/t = locate(x-3,y,z)
						if(istype(t, /turf/teleport) || (locate(/obj/teleport) in t))
							return

						D.player1 = usr
						D.player1:Transfer(t)
						D.player1.dir = EAST
						D.player1.nomove = 1
						range(9) << "[usr] enters the duel."
					else if(!D.player2 && D.player1 != usr)
						var/turf/t = locate(x+3,y,z)
						if(istype(t, /turf/teleport) || (locate(/obj/teleport) in t))
							return

						D.player2 = usr
						D.player2:Transfer(t)
						D.player2.dir = WEST
						D.player2.nomove = 1
						range(9) << "[usr] enters the duel."
						var/obj/duelblock/B1 = locate(/obj/duelblock) in locate(x-2,y,z)
						var/obj/duelblock/B2 = locate(/obj/duelblock) in locate(x+2,y,z)
						B1.density = 1
						B2.density = 1
						range(9) << "<i>Duelists now have 10 seconds to click on the duel control center.</i>"
						D.Pre_Duel()

					else if(D.player1 == usr)
						if(!D.player2)
							range(9) << "[usr] withdraws."
							D.Dispose()
						else
							if(!D.ready1)
								range(9) << "<i>[usr] bows.</i>"
								usr << "You are now ready."
								D.ready1 = 1
							else
								var/input = alert("Do you wish to forfeit the duel?","Forfeit Duel","Yes","No")
								if(input == "Yes")
									usr << "Duel will end in 10 seconds."
									sleep(100)
									range(9) << "The duel has been forfeited by [usr]."
									D.Dispose()
					else if(D.player2 == usr)
						if(!D.player1)
							range(9) << "[usr] withdraws."
							D.Dispose()
						else
							if(!D.ready2)
								range(9) << "<i>[usr] bows.</i>"
								usr << "You are now ready."
								D.ready2 = 1
							else
								var/input = alert("Do you wish to forfeit the duel?","Forfeit Duel","Yes","No")
								if(input == "Yes")
									usr << "Duel will end in 10 seconds."
									sleep(100)
									range(9) << "The duel has been forfeited by [usr]."
									D.Dispose()
					else
						usr << "Both player positions are already occupied."
				else
					var/turf/t = locate(x-3,y,z)
					if(istype(t, /turf/teleport) || (locate(/obj/teleport) in t))
						return

					D = new(src)
					range(9) << "[usr] initiates a duel."
					D.player1 = usr
					D.player1:Transfer(t)
					D.player1.dir = EAST
					D.player1.nomove = 1

obj/items/magic_stone
	var
		tmp/inUse   = FALSE
		seconds     = 10
		onlyOutside = 1
		antiTp = 1


	icon = 'trophies.dmi'

	Drop()
		set src in usr
		if(inUse)
			usr << errormsg("You can't drop it right now.")
		else
			..()

	memory
		icon = 'Crystal.dmi'
		name = "memory stone"
		icon_state = "memory"


		circle(mob/Player/p)
			var/turf/t = p.loc
			if(!findtext(t.tag, "teleportPoint"))
				p << errormsg("You can't use it here, memories are too powerful to manipulate without external help.")
				return
			..(p)



		effect(mob/Player/p)
			var/obj/items/wearable/wands/w = locate() in p.Lwearing

			if(!w)
				p << errormsg("This stone enchants your equipped wand, please equip a wand.")
				return 1

			if(w.track)
				p << errormsg("Your wand already has a memory enchantment.")
				return 1

			if(w.stack > 1)
				w = w.Split(1)
				w.Equip(p, 1)

			w.track = 1

			var/origname = initial(w.name)
			if(origname != w.name)
				var/pos = findtext(w.name, origname)
				if(pos)
					w.name = copytext(w.name, 1, pos) + "memory " + copytext(w.name, pos)
			else
				w.name = "memory [w.name]"

			src=null
			spawn()
				for(var/i = 0 to 10)
					displayKills(p, rand(1, 9999), 1)
					w.killCount = 0
					sleep(3)


	teleport
		icon        = 'Crystal.dmi'
		name        = "teleport stone"
		seconds     = 1
		onlyOutside = 0
		var/dest

		desc = "Used for teleportation."

		Clone()
			var/obj/items/magic_stone/teleport/t = ..()

			t.dest       = dest
			t.name       = name
			t.icon_state = icon_state

			return t

		circle(mob/Player/p)
			if(dest)
				..(p)
			else
				var/turf/t = p.loc
				if(findtext(t.tag, "teleportPoint"))

					var/obj/items/magic_stone/teleport/s = stack > 1 ? Split(1) : src

					s.dest = copytext(t.tag, 14)
					s.name = "[name] \[[s.dest]]"
					s.icon_state = "teleport"

					if(s != src)
						s.Move(p)

					p << infomsg("You charged your teleport stone to [s.dest].")
				else
					p << errormsg("You can't use it here, find a memory rune to charge this teleport stone.")

		effect(mob/Player/p)

			var/turf/t
			if(dest == "Vault")
				var/swapmap/map = SwapMaps_Find("[usr.ckey]")
				if(!map)
					map = SwapMaps_Load("[usr.ckey]")
				if(!map)
					usr << errormsg("You do not have a vault.")
				else
					var/width = (map.x2+1) - map.x1
					t = locate(map.x1 + round((width)/2), map.y1+1, map.z1 )

			else
				t = locate("teleportPoint[dest]")
			if(t)
				hearers(p) << infomsg("[p.name] disappears in a flash of light.")
				p.Transfer(t)
				hearers(p) << infomsg("[p.name] appears in a flash of light.")

		memory
			name = "memory teleport stone"

			effect(mob/Player/p)
				..()
				. = 1

	weather
		seconds = 5
		acid
			name = "acid stone"
			icon_state = "Emerald"

			effect()
				weather.acid()

		snow
			name = "snow stone"
			icon_state = "Sapphire"

			effect()
				weather.snow()

		rain
			name = "rain stone"
			icon_state = "Sapphire"

			effect()
				weather.rain()

		sun
			name = "sun stone"
			icon_state = "Topaz"

			effect()
				weather.clear()

	summoning
		circle(mob/Player/P)
			if(worldData.currentEvents && worldData.currentEvents.len > 5)
				P << errormsg("You can't use this while an event is running.")
				return
			..(P)

		random
			name = "lucky coin"
			icon_state = "Coin"
			effect()
				var/random_type = pick(/RandomEvent/TheEvilSnowman, /RandomEvent/WillytheWhisp, /RandomEvent/Invasion)
				var/RandomEvent/event = locate(random_type) in worldData.events
				spawn() event.start()

		snowman
			name = "snowy coin"
			icon_state = "Coin"
			effect()
				var/RandomEvent/TheEvilSnowman/event = locate() in worldData.events
				spawn() event.start()
		willy
			name = "mysterious coin"
			icon_state = "Coin"
			effect()
				var/RandomEvent/WillytheWhisp/event = locate() in worldData.events
				spawn() event.start()

		resurrection
			name = "resurrection stone fragment"
			icon_state = "fragment"
			effect()
				var/RandomEvent/Zombie/event = locate() in worldData.events
				spawn() event.start()

		blood
			name = "blood coin"
			icon_state = "Coin"

			circle(mob/Player/p)
				if(!(p.loc && (istype(p.loc.loc, /area/outside) || istype(p.loc.loc, /area/newareas/outside))))
					p << errormsg("You can only use this outside.")
					return

				var/area/outside/a = p.loc.loc
				if(a.planeColor != NIGHTCOLOR)
					p << errormsg("You can only use this at night.")
					return

				..(p)

			effect()
				var/RandomEvent/VampireLord/event = locate() in worldData.events
				spawn() event.start()

		monsters
			name = "stinky coin"
			icon_state = "Coin"
			effect()
				var/RandomEvent/Invasion/event = locate() in worldData.events
				spawn() event.start()

	eye
		name = "death coin"
		icon_state = "Coin"
		antiTp = 0

		circle(mob/Player/p)
			if(p.loc && p.loc.loc)
				var/area/a = p.loc.loc
				if(istype(a, /area/newareas/outside/Desert))
					..(p)
				else
					p << errormsg("The coin glows, nothing else happens.")


		effect(mob/Player/p)
			var/obj/eye_counter/count = locate("EyeCounter")
			worldData.eyesKilled = min(999, worldData.eyesKilled + 200)
			count.updateDisplay()


	Click()
		if(src in usr)
			circle(usr)
		else
			..()

	proc/effect(mob/Player/p)
	proc/circle(mob/Player/p)

		if(!canUse(p,cooldown=null,needwand=1,inarena=0,insafezone=0,inhogwarts=0,target=null,mpreq=500,antiTeleport=antiTp))
			return

		if(onlyOutside)
			if(!(p.loc && (istype(p.loc.loc, /area/outside) || istype(p.loc.loc, /area/newareas/outside))))
				p << errormsg("You can only use this outside.")
				return

		p.MP -= 500
		p.updateMP()

		if(inUse) return
		inUse = TRUE

		var/obj/o = new(usr.loc)
		o.name = "magic circle"
		o.icon='Circle_magic.dmi'
		o.pixel_x = -65
		o.pixel_y = -64

		animate(o, color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10, loop = -1)
		animate(color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10)
		animate(color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10)

		hearers(p) << infomsg("[p.name] holds their [name] up in the air")

		var/obj/items/magic_stone/source = src
		src=null
		spawn()
			var/tmploc = p.loc
			var/secs = source.seconds

			while(secs > 0 && p && p.loc == tmploc)
				secs--
				sleep(10)
			if(p && source)
				if(p.loc == tmploc)
					if(!source.effect(p))
						source.Consume()
				else
					p << errormsg("The ritual failed.")
				source.inUse = FALSE
			o.loc = null

obj/items/wearable/wands/practice_wand
	icon = 'oak_wand.dmi'
	var/learnSpell/spell
	dropable = 0
	destroyable = 1

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner, overridetext, forceremove)
		var/mob/Player/p = owner
		if(. == WORN)
			p.verbs   += spell.path
			p.learning = spell

			if(!overridetext) p << infomsg("Use [spell.name] [spell.uses] time[spell.uses > 1 ? "s" : ""] to learn it!")

		else if(. == REMOVED || forceremove)
			p.verbs   -= spell.path
			p.learning = null


obj/memory_rune

	icon = 'Rune.dmi'

	New()
		..()

		spawn(1)
			var/matrix/m = matrix()
			m.Turn(60)
			animate(src, transform = m, color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10, loop = -1)
			m.Turn(60)
			animate(transform = m, color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10)
			m.Turn(60)
			animate(transform = m, color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10)
			m.Turn(60)
			animate(transform = m, color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10)
			m.Turn(60)
			animate(transform = m, color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10)

			animate(transform = null, color = rgb(rand(80,255), rand(80,255), rand(80,255)), time = 10)

			loc.tag = "teleportPoint[name]"

	Snowman_Dungeon
	Snake_Dungeon
	Silverblood
	CoSFloor1
		name = "CoS Floor 1"
	CoSFloor2
		name = "CoS Floor 2"
	CoSFloor3
		name = "CoS Floor 3"
	Vault


obj/items


	chest
		icon = 'Chest.dmi'
		icon_state = "golden"
		stackName = "Chests:"

		useTypeStack = 1
		rarity     = 2

		var
			drops
			keyType

		Click()
			if(src in usr)
				Open()
			else
				..()

		MouseEntered(location,control,params)
			if((src in usr) && usr:infoBubble)

				if(!desc)
					var/info = ""
					for(var/d in chest_prizes[drops])
						var/list/split = splittext ("[d]", "/")
						info += "[split[split.len]]\n"
					winset(usr, null, "infobubble.labelTitle.text=\"[name]\";infobubble.labelInfo.text=\"[replacetext(info, "_", " ")]\"")
				else
					winset(usr, null, "infobubble.labelTitle.text=\"[name]\";infobubble.labelInfo.text=\"[desc]\"")

				winshowRight(usr, "infobubble")

		verb
			Open()
				set src in usr

				if(!drops) // if golden chest
					var/obj/roulette/r = new (usr.loc)
					r.getPrize(drops, usr.name, usr.ckey, usr.Gender)

					usr << infomsg("You opened a [name]!")
					Consume()
				else
					var/obj/items/chestKey = locate(keyType) in usr

					if(!chestKey)
						chestKey = locate(/obj/items/key/master_key) in usr

					if(chestKey)

						var/obj/roulette/r = new (usr.loc)
						r.getPrize(drops, usr.name, usr.ckey, usr.Gender)

						usr << infomsg("You opened a [name]!")

						chestKey.Consume()
						Consume()
					else
						usr << errormsg("You don't have a [name] key to open this!")

		legendary_golden_chest
			icon_state = "golden"
			desc = "3 to 6 random items from every chest."

		duel_chest
			icon_state = "duel"
			drops      = "(limited)duel"
			keyType = /obj/items/key/duel_key

		wizard_chest
			icon_state = "blue"
			drops      = "wizard"
			keyType = /obj/items/key/wizard_key

		pentakill_chest
			icon_state = "red"
			drops      = "pentakill"
			keyType = /obj/items/key/pentakill_key

		basic_chest
			icon_state = "green"
			drops      = "basic"
			keyType = /obj/items/key/basic_key

		sunset_chest
			icon_state = "purple"
			drops      = "sunset"
			keyType = /obj/items/key/sunset_key

		summer_chest
			icon_state = "orange"
			drops      = "summer"
			keyType = /obj/items/key/summer_key

			limited_edition
				name  = "special summer 2015 chest"
				drops = "(limited)2015 sum"

		winter_chest
			icon_state = "blue"
			drops      = "winter"
			keyType = /obj/items/key/winter_key


			limited_edition
				name  = "special winter 2015 chest"
				drops = "(limited)2015 winter"

		prom_chest
			icon_state = "pink"
			drops      = "prom"
			keyType = /obj/items/key/prom_key

			limited_edition
				name = "special prom 2015 chest"
				drops = "(limited)2015 prom"

		blood_chest
			icon_state = "red"
			drops      = "blood"
			keyType = /obj/items/key/blood_key

		pet_chest
			icon_state = "green"
			drops      = "treats"
			keyType = /obj/items/key/pet_key

		community1_chest
			name = "community #1 chest"
			icon_state = "blue"
			drops      = "community1"
			keyType = /obj/items/key/community_key

		community2_chest
			name = "community #2 chest"
			icon_state = "blue"
			drops      = "community2"
			keyType = /obj/items/key/community_key

		wigs
			useTypeStack = /obj/items/chest
			MouseEntered(location,control,params)
				if((src in usr) && usr:infoBubble)

					if(!desc)
						var/info = ""

						var/id = usr.Gender == "Female" ? "female_[drops]" : "male_[drops]"

						for(var/d in chest_prizes[id])
							var/list/split = splittext ("[d]", "/")
							info += "[split[split.len]]\n"
						winset(usr, null, "infobubble.labelTitle.text=\"[name]\";infobubble.labelInfo.text=\"[replacetext(info, "_", " ")]\"")
					else
						winset(usr, null, "infobubble.labelTitle.text=\"[name]\";infobubble.labelInfo.text=\"[desc]\"")

					winshowRight(usr, "infobubble")

			Open()
				set src in usr

				var/d = drops

				if(usr.Gender == "Female")
					drops = "female_[drops]"
				else
					drops = "male_[drops]"

				..()

				drops = d

			basic_wig_chest
				icon_state = "green"
				drops      = "basic"
				keyType = /obj/items/key/basic_key

			sunset_wig_chest
				icon_state = "purple"
				drops      = "sunset"
				keyType = /obj/items/key/sunset_key

			chess_chest
				icon_state = "red"
				drops      = "chess"
				keyType = /obj/items/key/chess_key
			demon_chest
				icon_state = "green"
				drops      = "demon"
				keyType = /obj/items/key/demon_key

			holiday_chest
				name = "holiday chest"
				icon_state = "red"
				drops      = "holiday"
				keyType = /obj/items/key/holiday_key

			hardmode_chest
				icon_state = "red"
				drops      = "hardmode"
				keyType = /obj/items/key/master_key

	mystery_key
		icon = 'ChestKey.dmi'
		icon_state = "master"
		rarity = 3

		desc = "Click to get a random key."

		Click()
			if(src in usr)
				var/obj/items/key/k = pick(/obj/items/key/basic_key,
		               			  /obj/items/key/wizard_key,
		               			  /obj/items/key/pentakill_key,
					   			  /obj/items/key/prom_key,
					  			  /obj/items/key/summer_key,
					   			  /obj/items/key/winter_key,
					  			  /obj/items/key/blood_key,
								  /obj/items/key/pet_key,
								  /obj/items/key/chess_key,
								  /obj/items/key/demon_key,
							      /obj/items/key/community_key,
		              			  /obj/items/key/sunset_key)
				k = new k (usr)
				usr << infomsg("You received [k.name].")
				Consume()
			else
				..()

	mystery_artifact
		icon = 'trophies.dmi'
		icon_state = "Ring"
		rarity = 3

		desc = "Click to get a random artifact."

		Click()
			if(src in usr)

				var/list/l = (drops_list["legendary"]).Copy(LEGENDARY_INDEX)

				var/obj/items/wearable/prize = pick(l)
				prize = new prize (usr)

				usr << colormsg("<i>You received [prize.name].</i>", "#FFA500")
				Consume()
			else
				..()

	mystery_chest
		icon = 'Chest.dmi'
		icon_state = "golden"
		rarity = 3

		desc = "Click to get a random chest."

		Click()
			if(src in usr)
				var/obj/items/key/k = pick(/obj/items/chest/basic_chest,
		               			  /obj/items/chest/wizard_chest,
		               			  /obj/items/chest/pentakill_chest,
					   			  /obj/items/chest/prom_chest,
					  			  /obj/items/chest/summer_chest,
					   			  /obj/items/chest/winter_chest,
					  			  /obj/items/chest/blood_chest,
								  /obj/items/chest/pet_chest,
								  /obj/items/chest/wigs/chess_chest,
								  /obj/items/chest/wigs/demon_chest,
							      /obj/items/chest/community1_chest,
							      /obj/items/chest/community2_chest,
		              			  /obj/items/chest/sunset_chest,
		              			  /obj/items/chest/wigs/sunset_wig_chest,
		              			  /obj/items/chest/wigs/basic_wig_chest)
				k = new k (usr)
				usr << infomsg("You received [k.name].")
				Consume()
			else
				..()
	key
		icon = 'ChestKey.dmi'
		icon_state = "master"
		stackName  = "Keys:"
		rarity     = 2

		useTypeStack = 1

		master_key
			icon_state = "master"
		wizard_key
			icon_state = "blue"
		duel_key
			icon_state = "duel"
		pentakill_key
			icon_state = "red"
		blood_key
			icon_state = "red"
		basic_key
			icon_state = "green"
		sunset_key
			icon_state = "purple"
		summer_key
			icon_state = "orange"
		winter_key
			icon_state = "blue"
		prom_key
			icon_state = "pink"
		pet_key
			icon_state = "green"
		special_key
			icon_state = "master"
		community_key
			icon_state = "blue"
		chess_key
			icon_state = "red"
		demon_key
			icon_state = "green"
		holiday_key
			icon_state = "red"

var/list/chest_prizes = list("(limited)duel" = list(/obj/items/wearable/scarves/duel_scarf       = 50,
					                            /obj/items/wearable/shoes/duel_shoes         = 30,
					                            /obj/items/wearable/wands/duel_wand          = 20),

							 "wizard"    = list(/obj/items/wearable/scarves/teal_scarf       = 50,
					                            /obj/items/wearable/shoes/teal_shoes         = 30,
					                            /obj/items/wearable/scarves/cyan_scarf       = 20),

					         "pentakill" = list(/obj/items/wearable/scarves/black_scarf      = 40,
							                    /obj/items/wearable/scarves/white_scarf      = 25,
							                    /obj/items/wearable/shoes/black_shoes        = 20,
							                    /obj/items/wearable/shoes/white_shoes        = 10,
							                    /obj/items/wearable/scarves/grey_scarf       = 5),

	                     	 "basic"     = list(/obj/items/wearable/scarves/black_scarf      = 10,
							                    /obj/items/wearable/scarves/green_scarf      = 15,
							                    /obj/items/wearable/scarves/red_scarf        = 15,
							                    /obj/items/wearable/scarves/blue_scarf       = 15,
							                    /obj/items/wearable/scarves/yellow_scarf     = 20,
							                    /obj/items/wearable/scarves/orange_scarf     = 25),

	                     	 "sunset"    = list(/obj/items/wearable/scarves/sunset_scarf     = 4,
												/obj/items/wearable/shoes/cyan_shoes         = 30,
							                    /obj/items/wearable/shoes/darkblue_shoes     = 12,
							                    /obj/items/wearable/scarves/darkblue_scarf   = 21,
							                    /obj/items/wearable/shoes/darkpurple_shoes   = 12,
							                    /obj/items/wearable/scarves/darkpurple_scarf = 21),


	                     	 "summer"    = list(/obj/items/wearable/shoes/orange_shoes       = 8,
							                    /obj/items/wearable/shoes/yellow_shoes       = 21,
							                    /obj/items/wearable/shoes/green_shoes        = 21,
							                    /obj/items/wearable/shoes/red_shoes          = 21,
							                    /obj/items/wearable/shoes/blue_shoes         = 21),

							 "(limited)2015 sum" = list(/obj/items/wearable/hats/orange_earmuffs     = 9,
							                    /obj/items/wearable/hats/yellow_earmuffs     = 9,
												/obj/items/wearable/shoes/orange_shoes       = 13,
							                    /obj/items/wearable/shoes/yellow_shoes       = 23,
							                    /obj/items/wearable/shoes/red_shoes          = 23,
							                    /obj/items/wearable/shoes/blue_shoes         = 23),

	                     	 "prom"      = list(/obj/items/wearable/scarves/pink_scarf       = 40,
							                    /obj/items/wearable/shoes/pink_shoes         = 30,
							                    /obj/items/wearable/shoes/darkpink_shoes     = 10,
							                    /obj/items/wearable/scarves/darkpink_scarf   = 20),

							 "(limited)2015 prom" = list(/obj/items/wearable/hats/darkpink_earmuffs   = 5,
												/obj/items/wearable/hats/lightpink_earmuffs  = 5,
												/obj/items/wearable/scarves/pink_scarf       = 35,
							                    /obj/items/wearable/shoes/pink_shoes         = 25,
							                    /obj/items/wearable/shoes/darkpink_shoes     = 10,
							                    /obj/items/wearable/scarves/darkpink_scarf   = 20),

	                     	 "winter"    = list(/obj/items/wearable/shoes/candycane_shoes    = 6,
							                    /obj/items/wearable/scarves/candycane_scarf  = 10,
							                    /obj/items/wearable/scarves/red_scarf        = 27,
							                    /obj/items/wearable/scarves/white_scarf      = 24,
							                    /obj/items/wearable/shoes/red_shoes          = 18,
							                    /obj/items/wearable/shoes/white_shoes        = 15),

	                     	 "male_hardmode"    = list(/obj/items/wearable/scarves/orange_scarf   = 25,
				                                       /obj/items/wearable/scarves/darkpink_scarf = 25,
							                           /obj/items/wearable/shoes/orange_shoes     = 20,
							                           /obj/items/wearable/shoes/darkpink_shoes   = 20,
							                           /obj/items/wearable/hats/darkpink_earmuffs = 10,
							                           /obj/items/wearable/hats/orange_earmuffs   = 10,
							                           /obj/items/wearable/wigs/male_orange_wig   = 10,
							                           /obj/items/wearable/wigs/male_darkpink_wig = 10),

	                     	 "female_hardmode"  = list(/obj/items/wearable/scarves/orange_scarf     = 25,
				                                       /obj/items/wearable/scarves/darkpink_scarf   = 25,
							                           /obj/items/wearable/shoes/orange_shoes       = 20,
							                           /obj/items/wearable/shoes/darkpink_shoes     = 20,
							                           /obj/items/wearable/hats/darkpink_earmuffs   = 10,
							                           /obj/items/wearable/hats/orange_earmuffs     = 10,
							                           /obj/items/wearable/wigs/female_orange_wig   = 10,
							                           /obj/items/wearable/wigs/female_darkpink_wig = 10),

	                     	 "male_holiday"    = list(/obj/items/wearable/shoes/candycane_shoes       = 15,
							                          /obj/items/wearable/scarves/candycane_scarf     = 20,
							                          /obj/items/wearable/scarves/red_scarf           = 30,
							                          /obj/items/wearable/scarves/white_scarf         = 30,
							                          /obj/items/wearable/shoes/red_shoes             = 25,
							                          /obj/items/wearable/shoes/white_shoes           = 25,
							                          /obj/items/wearable/hats/red_earmuffs           = 10,
							                          /obj/items/wearable/hats/white_earmuffs         = 10,
							                          /obj/items/wearable/wigs/male_red_wig           = 6),

	                     	 "female_holiday"    = list(/obj/items/wearable/shoes/candycane_shoes       = 15,
							                            /obj/items/wearable/scarves/candycane_scarf     = 20,
							                            /obj/items/wearable/scarves/red_scarf           = 30,
							                            /obj/items/wearable/scarves/white_scarf         = 30,
							                            /obj/items/wearable/shoes/red_shoes             = 25,
							                            /obj/items/wearable/shoes/white_shoes           = 25,
							                            /obj/items/wearable/hats/red_earmuffs           = 10,
							                            /obj/items/wearable/hats/white_earmuffs         = 10,
							                            /obj/items/wearable/wigs/female_red_wig           = 6),

							 "(limited)2015 winter" = list(/obj/items/wearable/hats/red_earmuffs        = 10,
							                       /obj/items/wearable/hats/white_earmuffs      = 10,
							                       /obj/items/wearable/shoes/candycane_shoes    = 35,
							                       /obj/items/wearable/scarves/candycane_scarf  = 39),

							 "blood"     = list(/obj/items/wearable/scarves/blood_scarf = 50,
							 					/obj/items/wearable/shoes/blood_shoes   = 30,
							 					/obj/items/wearable/wands/blood_wand    = 20),

							 "male_basic" = list(/obj/items/wearable/wigs/male_black_wig   = 32,
							 					   /obj/items/wearable/wigs/male_blond_wig = 32,
							 					   /obj/items/wearable/wigs/male_grey_wig  = 32,
							 					   /obj/items/wearable/wigs/male_brown_wig = 4),

							 "female_basic" = list(/obj/items/wearable/wigs/female_black_wig    = 32,
							 					     /obj/items/wearable/wigs/female_blonde_wig = 32,
							 					     /obj/items/wearable/wigs/female_grey_wig   = 32,
							 					     /obj/items/wearable/wigs/female_brown_wig  = 4),

							 "male_sunset" = list(/obj/items/wearable/wigs/male_darkpurple_wig = 15,
							 					   /obj/items/wearable/wigs/male_darkblue_wig  = 15,
							 					   /obj/items/wearable/wigs/male_cyan_wig      = 15,
							 					   /obj/items/key/sunset_key     = 30,
							 					   /obj/items/chest/sunset_chest = 30),

							 "female_sunset" = list(/obj/items/wearable/wigs/female_darkpurple_wig = 15,
							 					    /obj/items/wearable/wigs/female_darkblue_wig   = 15,
							 					    /obj/items/wearable/wigs/female_cyan_wig       = 15,
							 					    /obj/items/key/sunset_key     = 30,
							 					    /obj/items/chest/sunset_chest = 30),

							 "male_chess" = list(/obj/items/wearable/wigs/male_chess_wig = 15,
							                     /obj/items/wearable/hats/grey_earmuffs  = 15,
							                     /obj/items/wearable/shoes/white_shoes   = 25,
							                     /obj/items/wearable/shoes/black_shoes   = 25,
							                     /obj/items/wearable/scarves/white_scarf = 35,
							                     /obj/items/wearable/scarves/black_scarf = 35),

							 "female_chess" = list(/obj/items/wearable/wigs/female_chess_wig = 15,
							                       /obj/items/wearable/hats/grey_earmuffs  = 15,
							                       /obj/items/wearable/shoes/white_shoes   = 25,
							                       /obj/items/wearable/shoes/black_shoes   = 25,
							                       /obj/items/wearable/scarves/white_scarf = 35,
							                       /obj/items/wearable/scarves/black_scarf = 35),

							 "male_demon" = list(/obj/items/wearable/wigs/male_blackgreen_wig = 15,
							                     /obj/items/wearable/hats/green_earmuffs  = 15,
							                     /obj/items/wearable/shoes/grey_shoes   = 15,
							                     /obj/items/wearable/shoes/black_shoes   = 25,
							                     /obj/items/wearable/scarves/grey_scarf = 35,
							                     /obj/items/wearable/scarves/green_scarf = 35),

							 "female_demon" = list(/obj/items/wearable/wigs/female_blackgreen_wig = 15,
							                       /obj/items/wearable/hats/green_earmuffs  = 15,
							                       /obj/items/wearable/shoes/grey_shoes   = 15,
							                       /obj/items/wearable/shoes/green_shoes   = 25,
							                       /obj/items/wearable/scarves/grey_scarf = 35,
							                       /obj/items/wearable/scarves/green_scarf = 35),

							 "community1"     = list(/obj/items/wearable/scarves/heartscarf    = 16,
							 					     /obj/items/wearable/scarves/alien_scarf   = 22,
							 					     /obj/items/wearable/scarves/snake_scarf   = 11,
							 					     /obj/items/wearable/scarves/booster_scarf = 25,
							 					     /obj/items/wearable/scarves/sunrise_scarf = 10,
							 					     /obj/items/wearable/scarves/icarus_scarf  = 16),

							 "community2"     = list(/obj/items/wearable/scarves/sky_scarf     = 20,
							 					     /obj/items/wearable/scarves/hello_scarf   = 20,
							 					     /obj/items/wearable/scarves/party_scarf   = 20,
							 					     /obj/items/bucket                         = 30),

							 "treats"         = list(/obj/items/potions/pets/exp = 35,
							                         /obj/items/treats/red       = 25,
							 					     /obj/items/treats/green     = 25,
							 					     /obj/items/treats/pink      = 20,
							 					     /obj/items/treats/yellow    = 10,
							 					     /obj/items/treats/blue      = 5),


							 "gold only" = list(/obj/items/magic_stone/memory     = 10,
							                    /obj/items/wearable/afk/pimp_ring = 30,
							                    /obj/items/wearable/title/Gambler = 40))

obj/roulette
	icon = 'roulette.dmi'

	var/playerName
	var/playerCkey

	proc/getAngle(angle)

		if(angle < 0)         angle += 360
		else if(angle >= 360)  angle -= 360

		return angle

	proc/getPrize(drops, pname, pckey, Gender)
		set waitfor = FALSE

		playerName = pname
		playerCkey = pckey

		var/list/L
		if(!drops)
			L = list()
			var/amount = rand(3, 6)

			for(var/i = 1 to amount)
				var/category = pick(chest_prizes)

				if(findtext(category, "(limited)"))
					i--
					continue

				if(findtext(category, "male_"))
					var/list/s = splittext(category, "_")
					category = "[lowertext(Gender)]_[s[2]]"

				L += pickweight(chest_prizes[category])

		else if(istext(drops) && (drops in chest_prizes))
			L = chest_prizes[drops]
		else if(islist(drops))
			L = drops
		else
			return

		var/prize = pickweight(L)
		var/prize_angle

		var/angle = 0
		var/angle_change = 360 / L.len

		for(var/item in L)
			if(!prize_angle && item == prize)
				prize_angle = angle

			var/obj/o = new (loc)
			o.overlays += item

			o.pixel_x = 68 * cos(angle)
			o.pixel_y = 68 * sin(angle)

			animate(o, pixel_x = 68 * cos(getAngle(angle + angle_change)),
			           pixel_y = 68 * sin(getAngle(angle + angle_change)), time = 10, loop = 4)

			for(var/i = 2 to L.len)
				animate(pixel_x = 68 * cos(getAngle(angle + (angle_change*i))),
				        pixel_y = 68 * sin(getAngle(angle + (angle_change*i))), time = 10)

			angle += angle_change

			spawn(L.len * 30 + (L.len + 4) * 12)
				o.loc = null

		angle = rand(0, L.len - 1) * angle_change
		pixel_x = 64 * cos(angle)
		pixel_y = 64 * sin(angle)

		animate(src, pixel_x = 64 * cos(getAngle(angle - angle_change)),
		             pixel_y = 64 * sin(getAngle(angle - angle_change)), time = 5, loop = 6)

		for(var/i = 2 to L.len)
			animate(pixel_x = 64 * cos(getAngle(angle - (angle_change*i))),
			        pixel_y = 64 * sin(getAngle(angle - (angle_change*i))), time = 5)

		sleep(L.len * 30)
		animate(src, pixel_x = 64 * cos(getAngle(angle - angle_change)),
		             pixel_y = 64 * sin(getAngle(angle - angle_change)), time = 10, loop = 1)

		for(var/i = 2 to L.len + 1)
			animate(pixel_x = 64 * cos(getAngle(angle - (angle_change*i))),
			        pixel_y = 64 * sin(getAngle(angle - (angle_change*i))), time = 10)

			if(getAngle(angle - (angle_change*i)) == prize_angle) break

		sleep((L.len + 2) * 10)

		emit(loc    = src,
			 ptype  = /obj/particle/magic,
		     amount = 50,
		     angle  = new /Random(1, 359),
		     speed  = 2,
		     life   = new /Random(15,25))

		var/obj/items/i = new prize (loc)

		if(istype(i, /obj/items/wearable) && i:bonus == 0)

			var/chance = clamp(L[prize], 10, 25)
			if(prob(chance))
				i:bonus   = 3

				var/lvl = pick(1,2,3)
				i:quality = lvl
				i.name += " +[lvl]"
				i.UpdateDisplay()

		ohearers(src) << infomsg("<b>[playerName] opened a chest and won \a [i]!</b>")

		i.prizeDrop(playerCkey, 600, decay=FALSE)

		goldlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm")]: [playerName]([playerCkey]) got a [i.name] from a chest.<br />"

		loc = null


proc/pickweight(list/L)
	var/totweight = 0
	var/item
	for(item in L)
		var/weight = L[item]
		if(isnull(weight))
			weight = 1; L[item] = 1
		totweight += weight
	totweight *= rand()
	for(var/i=1, i<=L.len, ++i)
		var/weight = L[L[i]]
		totweight -= weight
		if(totweight < 0)
			return L[i]

obj/wand_desk
	mouse_opacity = 2

	Click()
		..()

		if(usr in oview(1, src))
			usr << infomsg("If you have any wand coloring stones, click them to apply the color effect.")

obj/items/colors

	icon = 'Colors.dmi'

	var
		reqLevel = 5
		projColor

	Click()
		if(src in usr)

			var/mob/Player/p = usr

			if(!(locate(/obj/wand_desk) in oview(1)))
				p << errormsg("You need some tools in order to apply this to your equipped wand. Maybe you'll find some tools at the wand shop.")
				return
			if(!p.wand)
				p << errormsg("You have to have a wand equipped.")
				return
			if(p.wand.quality < reqLevel)
				p << errormsg("Your wand has to be at least level [reqLevel].")
				return

			if(p.holster)

				if(projColor in p.holster.colors)
					p << errormsg("Your holster already has this color.")
					return

				if(!p.holster.colors) p.holster.colors = list()
				p.holster.colors += projColor

			//	if(!p.holster.projColor) p.holster.projColor = projColor

				p << infomsg("You added a new <span style=\"color:[projColor == "blood" ? "#880808" : projColor];\">magical color</span> to your equipped holster.")

				Consume()


			else
				if(p.wand.projColor && alert("Are you sure you want to override this wand's color?", "Override Wand Color", "Yes", "No") == "No")
					return

				if(locate(/obj/wand_desk) in oview(1))
					p << infomsg("You applied new <span style=\"color:[projColor == "blood" ? "#880808" : projColor];\">magical color</span> to your equipped wand.")
					p.wand.projColor = projColor
					Consume()
		else
			..()

	green_stone
		icon_state = "green"
		projColor  = "#006600"
	red_stone
		icon_state = "red"
		projColor  = "#660000"
	blue_stone
		icon_state = "blue"
		projColor  = "#000066"
	yellow_stone
		icon_state = "yellow"
		projColor  = "#666600"

	purple_stone
		reqLevel   = 10
		icon_state = "purple"
		projColor  = "#662690"
		rarity     = 2
	pink_stone
		reqLevel   = 10
		icon_state = "pink"
		projColor  = "#993f6c"
		rarity     = 2
	teal_stone
		reqLevel   = 10
		icon_state = "teal"
		projColor  = "#226666"
		rarity     = 2
	orange_stone
		reqLevel   = 10
		icon_state = "orange"
		projColor  = "#994422"
	blood_stone
		reqLevel   = 15
		icon_state = "red"
		projColor  = "blood"
		rarity     = 2

obj/items/reputation
	var/rep
	icon = 'reputation.dmi'

	Click()
		if(src in usr)
			Add(usr)
		else
			..()

	Clone()
		var/obj/items/reputation/i = new type

		i.owner      = owner
		i.name       = name
		i.icon_state = icon_state
		i.rep        = rep

		return i

	Compare(obj/items/reputation/i)
		return i.name == name && i.type == type && i.owner == owner && i.icon_state == icon_state && i.rep == rep


	New()
		if(prob(10))
			rep *= 2
			name = "greater [name]"
		else if(prob(55))
			rep /= 2
			name = "small [name]"
		else
			name = "medium [name]"

	proc/Add(mob/Player/i_Player)
		var/r1 = i_Player.getRep()
		var/r2 = i_Player.addRep(rep)

		if(r1 == r2)
			i_Player << errormsg("You are at max reputation for your rank.")

		else
			Consume()

	chaos_tablet
		icon_state = "chaos"
		rep        = -4
		Add(mob/Player/i_Player)

			if(!(locate(/mob/TalkNPC/quest/vampires/Chaos_Vampire) in oview(1)))
				i_Player << errormsg("Someone might want this, maybe someone that likes chaos.")
				return

			..()

	peace_tablet
		icon_state = "peace"
		rep        = 4
		Add(mob/Player/i_Player)

			if(!(locate(/mob/TalkNPC/quest/vampires/Peace_Vampire) in oview(1)))
				i_Player << errormsg("Someone might want this, maybe someone that likes peace.")
				return

			..()

obj/color_lamp
	icon       = 'lamp.dmi'
	icon_state = "inactive"

	mouse_over_pointer = MOUSE_HAND_POINTER

	var
		vaultOwner

	Click()
		if(vaultOwner == usr.ckey && (src in oview()))

			var/c = input("What color floors would you like?", "Wooden Floor Color") as null|color

			if(c)
				var/swapmap/map = SwapMaps_Find(vaultOwner)
				for(var/turf/woodenfloor/w in map.AllTurfs())
					w.color = c

		..()

obj/items/vault_key

	icon       = 'ChestKey.dmi'
	icon_state = "master"
	desc       = "Unlocks doors in high end vaults like wizard vault."

	rarity     = 3

	Click()
		if(src in usr)

			var/obj/Hogwarts_Door/d = locate() in oview(1)
			if(d && d.vaultOwner == usr.ckey)
				usr << errormsg("You unlocked the door.")
				d.FlickState("alohomora",20,'Effects.dmi')
				d.door     = 1
				Consume()
			else
				usr << errormsg("You need to use this near a locked vault door.")

		else
			..()

obj/items/treats
	icon = 'candy.dmi'

	var/levelReq = 1
	var/message  = 1

	red
		name       = "fire candy"
		icon_state = "red"
		levelReq   = 6

		Feed(mob/Player/p)
			. = 1

			var/obj/items/wearable/pets/i = p.pet.item

			if(!(i.bonus & 1))
				i.Equip(p, 1)
				i.bonus |= 1
				i.Equip(p, 1)

			var/c = rand(40, 80)
			p.pet.stepCount += 10 * c
			p << infomsg("Your [p.pet.name] enjoys the candy.")

			if(i.quality < MAX_PET_LEVEL)
				var/e = rand(5000, 10000)
				p << infomsg("Your [p.pet.name] gained [e] experience.")
				i.addExp(p, e)

	green
		name       = "leaf candy"
		icon_state = "green"
		levelReq   = 6

		Feed(mob/Player/p)
			. = 1
			var/obj/items/wearable/pets/i = p.pet.item
			if(!(i.bonus & 2))
				i.Equip(p, 1)
				i.bonus |= 2
				i.Equip(p, 1)

			var/c = rand(40, 80)
			p.pet.stepCount += 10 * c
			p << infomsg("Your [p.pet.name] enjoys the candy.")

			if(i.quality < MAX_PET_LEVEL)
				var/e = rand(5000, 10000)
				p << infomsg("Your [p.pet.name] gained [e] experience.")
				i.addExp(p, e)

	blue
		name       = "rare candy"
		icon_state = "blue"

		Feed(mob/Player/p)
			if(p.pet.item.quality < MAX_PET_LEVEL)
				. = 1
				p.pet.item.addExp(p, MAX_PET_EXP(p.pet.item) - p.pet.item.exp)
			else
				p << errormsg("Your [p.pet.name] already reached max level")

	yellow
		name       = "sun candy"
		icon_state = "yellow"
		levelReq   = 15

		Feed(mob/Player/p)
			. = 1

			if(p.pet.item.function & PET_LIGHT)
				p.pet.item.function &= ~PET_LIGHT

				p.pet.light.Dispose()
				p.pet.light = null
			else
				p.pet.item.function |= PET_LIGHT

				p.pet.light = new (loc)
				animate(p.pet.light, transform = matrix() * 1.8, time = 10, loop = -1)
				animate(             transform = matrix() * 1.7, time = 10)


	pink
		name       = "love candy"
		icon_state = "pink"
		levelReq   = 3

		Feed(mob/Player/p)
			var/mob/create_character/c = new
			var/desiredname = input("What name would you like? (Keep in mind that you cannot use a popular name from the Harry Potter franchise, nor numbers or special characters)") as text|null
			if(!desiredname)
				del c
				return
			var/passfilter = c.name_filter(desiredname)
			while(passfilter)
				alert("Your desired name is not allowed as it [passfilter].")
				desiredname = input("Please select a name that does not use a popular name from the Harry Potter franchise, nor numbers or special characters.") as text|null
				if(!desiredname)
					del c
					return
				passfilter = c.name_filter(desiredname)
			del c
			if(name == desiredname) return
			. = 1
			desiredname = uppertext(copytext(desiredname, 1, 2)) + copytext(desiredname, 2)

			p.pet.item.name = desiredname
			p.pet.name = desiredname

	berry
		icon_state = "berry"
		levelReq   = 0

		Feed(mob/Player/p)
			if(p.pet.item.quality < MAX_PET_LEVEL)
				. = 1
				var/e = rand(1800, 2200)
				p << infomsg("Your [p.pet.name] gained [e] experience.")
				p.pet.item.addExp(p, e)
			else
				p << errormsg("Your [p.pet.name] already reached max level")

	sweet_berry
		icon_state = "sweet"
		levelReq   = 0

		Feed(mob/Player/p)
			. = 1

			var/c = rand(20, 40)
			p.pet.stepCount += 10 * c

			p << infomsg("Your [p.pet.name] enjoys the berry.")

	grape_berry
		icon_state = "grape"
		levelReq   = 0

		Feed(mob/Player/p)
			. = 1

			var/c = rand(30, 60)
			p.pet.stepCount += 10 * c
			p << infomsg("Your [p.pet.name] enjoys the berry.")


			if(p.pet.item.quality < MAX_PET_LEVEL)
				var/e = rand(2000, 2400)
				p << infomsg("Your [p.pet.name] gained [e] experience.")
				p.pet.item.addExp(p, e)

	stick
		icon_state = "stick"
		levelReq   = 0
		message    = 0

		var/chance = 8

		ball
			icon_state = "ball"
			chance = 1

		Feed(mob/Player/p)

			if(p.pet.busy)
				p << errormsg("Your [p.pet.name] is already busy.")
				return

			var/turf/target = get_step(p, p.dir)
			for(var/dist = 1 to 8)
				var/turf/t = get_step(target, p.dir)
				if(!t || (dist < 6 && t.density))
					p << errormsg("You don't have enough space to throw the [name] here.")
					return

				if(t.density) break

				target = t

			p.pet.busy = 1

			p << infomsg("You threw \a [name] for your [p.pet.name] to fetch.")

			var/obj/throwStick/o = new (p.loc)
			o.icon_state = icon_state
			while(o.loc && o.loc != target)
				o.loc = get_step_towards(o, target)
				sleep(2)

				if(!p || !p.loc)
					o.loc = null
					return

			p.pet.walkTo(target, p.dir)
			sleep(15)
			o.loc = null
			target = get_step(p, p.dir)
			if(!target) target = p.loc
			p.pet.walkTo(target, get_dir(p.pet, p))
			sleep(10)

			if(prob(chance))
				. = 1
				p << errormsg("Your [p.pet.name] couldn't find your [name]")

			var/c = rand(5, 15)
			p.pet.stepCount += 10 * c
			p << infomsg("Your [p.pet.name] enjoys playing with you.")

			if((p.pet.item.function & PET_FETCH) == 0 && prob(10+p.pet.item.quality))
				p << infomsg("<b>Your [p.pet.name] learned how to fetch drops!</b>")
				p.pet.item.function |= PET_FETCH

			if(p.pet.item.quality < MAX_PET_LEVEL)
				var/e = rand(100, 500)
				p << infomsg("Your [p.pet.name] gained [e] experience.")
				p.pet.item.addExp(p, e)

			p.pet.busy = 0

	proc/Feed(mob/Player/p)


	Click()
		if(src in usr)
			var/mob/Player/p = usr

			if(!p.pet)

				if(message)
					var/obj/squirrel/s = locate() in orange(2, usr)
					if(s && !s.target)
						s.Feed(usr)
						p << "You fed the [s] a [name]."
						Consume()
						return

				p << errormsg("Equip a pet first in order to feed or play with it.")
				return

			if(p.pet.item.quality < levelReq)
				p << errormsg("Your [p.pet.name] needs to be level [levelReq] to eat [name].")
				return

			if(Feed(p))
				if(message) p << "You fed your [p.pet.name] a [name]."
				Consume()

		else
			..()

obj/throwStick
	icon = 'candy.dmi'
	icon_state = "stick"

	New()
		set waitfor = 0
		..()

		sleep(35)
		loc = null

obj/items/monster_book
	name       = "Monster book of Monsters"
	icon       = 'Books.dmi'
	icon_state = "monsters"

	canAuction = FALSE
	dropable   = FALSE

	Click()
		if(src in usr)
			var/mob/Player/p = usr

			if(!p.monsterkills || !p.monsterkills.len)
				p << errormsg("You didn't kill any monsters.")
				return

			p << errormsg("Monster kills:")

			var/total = 0
			for(var/m in p.monsterkills)
				p << errormsg("[m]: [p.monsterkills[m]]")
				total += p.monsterkills[m]

			p << errormsg("You killed total of [total] monsters.")

		else
			..()

obj/items/money
	icon = 'Gold.dmi'

	canAuction = FALSE

	var/factor = 1

	platinum
		icon_state = "platinum"
		factor = 1000000
	gold
		icon_state = "gold"
		factor = 10000
	silver
		icon_state = "silver"
		factor = 100
	bronze
		icon_state = "bronze"

	Compare(obj/items/i)
		return i.name == name && i.type == type && i.owner == owner

	UpdateDisplay()
		..()

		var/s = log(stack)

		s = max(s, 1)
		s = min(s, 3)
		s = round(s)

		icon_state = "[initial(icon_state)][s]"


obj/items/elite
	icon       = 'trophies.dmi'
	icon_state = "Sword"

	name = "sword of might"

	var/level = 1


obj/items/wearable/ring
	bonus  = 0
	socket = 0
	rarity = 3
	Armor  = 5
	showoverlay = FALSE

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		if(!forceremove && !overridetext && !(src in owner.Lwearing) && world.time - owner.lastCombat <= COMBAT_TIME)
			owner << errormsg("You can't equip this while in combat.")
			return
		if(!forceremove && !(src in owner.Lwearing) && owner.loc && owner.loc.loc && owner.loc.loc:antiEffect)
			owner << errormsg("You can not use it here.")
			return
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] hangs \his [src.name] onto \his finger.")
			for(var/obj/items/wearable/ring/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] into \his pocket.")


obj/items/wearable/ring/snowring
	icon='ammy.dmi'
	icon_state="snow"
	name="Ring of Snow"
	desc="A magical ring that can manipulate water."
	suffix = "<span style=\"color:#ffa500;\">Allows you to walk on water.</span>"
	passive = RING_WATERWALK
	monsterDmg = 3
	monsterDef = 3

obj/items/wearable/ring/mana
	icon='ammy.dmi'
	icon_state="snow"
	name="mage's ring"
	desc="Expands your maximum magic ability."
	suffix = "<span style=\"color:#ffa500;\">Expands your maximum magic ability.</span>"
	monsterDmg = 3
	monsterDef = 3
	extraMP    = 2400

obj/items/wearable/ring/aetherwalker_ring
	icon='ammy.dmi'
	icon_state="snow"
	desc="A magical ring that allows you apparate without cooldown."
	suffix = "<span style=\"color:#ffa500;\">Apparate's cooldown will be replaced with increased mana cost.</span>"
	passive = RING_APPARATE
	monsterDmg = 3
	monsterDef = 3

obj/items/wearable/ring/ring_of_displacement
	icon='ammy.dmi'
	icon_state="snow"
	desc="A magical ring that allows you to walk through monsters."
	suffix = "<span style=\"color:#ffa500;\">Allows you to walk through monsters.</span>"
	passive = RING_DISPLACEMENT
	monsterDmg = 3
	monsterDef = 3

obj/items/wearable/ring/demonic_ring
	icon='ammy.dmi'
	icon_state="snow"
	desc="A magical ring that allows you to control 3 extra summon/plant."
	suffix = "<span style=\"color:#ffa500;\">Allows you control 3 extra summon/plant.</span>"
	extraLimit = 3

obj/items/wearable/ring/time_ring
	icon='ammy.dmi'
	icon_state="snow"
	desc="A magical ring that grants you 10% additional cooldown reduction."
	suffix = "<span style=\"color:#ffa500;\">10% cooldown reduction.</span>"
	extraCDR = -0.1

obj/items/wearable/ring/slayer
	name="Todd's ring"
	icon='ammy.dmi'
	icon_state="snow"
	desc="A magical ring that grants you 10% additional monster damage and defense."
	suffix = "<span style=\"color:#ffa500;\">10% monster damage/defense.</span>"
	monsterDef = 10
	monsterDmg = 10

obj/items/wearable/ring/alchemy
	name="Alchemist's ring"
	icon='ammy.dmi'
	icon_state="snow"
	desc="Brewed potions are one tier higher."
	suffix = "<span style=\"color:#ffa500;\">Brewed potions are one tier higher.</span>"
	passive = RING_ALCHEMY
	monsterDef = 3
	monsterDmg = 3

obj/items/wearable/ring/fairy
	name="Fairy's ring"
	icon='ammy.dmi'
	icon_state="snow"
	desc="Re-uses potions at the end of their effect."
	suffix = "<span style=\"color:#ffa500;\">Re-uses potions at the end of their effect.</span>"
	passive = RING_FAIRY
	monsterDef = 3
	monsterDmg = 3

obj/items/wearable/ring/clown
	name="clown's ring"
	icon='ammy.dmi'
	icon_state="snow"
	desc="Projectiles element is randomized."
	suffix = "<span style=\"color:#ffa500;\">Projectiles element is randomized.</span>"
	passive = RING_CLOWN
	monsterDef = 3
	monsterDmg = 3

obj/items/wearable/ring/ninja
	name="ninja's ring"
	icon='ammy.dmi'
	icon_state="snow"
	desc="Low level monsters ignore you."
	suffix = "<span style=\"color:#ffa500;\">Low level monsters ignore you.</span>"
	passive = RING_NINJA
	monsterDef = 3
	monsterDmg = 3

obj/items/wearable/ring/nurse
	name="nurse's ring"
	icon='ammy.dmi'
	icon_state="snow"
	desc="Auto-cast Episkey."
	suffix = "<span style=\"color:#ffa500;\">Auto-cast Episkey.</span>"
	passive = RING_NURSE
	monsterDef = 3
	monsterDmg = 3

obj/items/wearable/ring/titan
	icon='ammy.dmi'
	icon_state="snow"
	name="Titan's Ring"
	desc="Stat gain from this ring is doubled."
	suffix = "<span style=\"color:#ffa500;\">Stat gain from this ring is doubled.</span>"
	monsterDef = 3
	monsterDmg = 3
	scale = 2

obj/items/wearable/ring/thorn
	icon='ammy.dmi'
	icon_state="snow"
	name="ring of thorns"
	desc="High armor value."
	suffix = "<span style=\"color:#ffa500;\">High armor value.</span>"
	monsterDef = 2
	monsterDmg = 2
	Armor = 30

obj/items/wearable/ring/cooling_shoes
	icon='trophies.dmi'
	icon_state="cooling shoes"
	desc="magical shoes that keep you cool enough to walk on lava."
	suffix = "<span style=\"color:#ffa500;\">Allows you to walk on lava.</span>"
	passive = RING_LAVAWALK
	monsterDef = 3

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner, 1)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] throws \his pair of [src.name] on.")
			for(var/obj/items/wearable/ring/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")

			if(istype(owner.loc, /turf/lava))
				owner.loc.Enter(owner, owner.loc)

obj/items/wearable/ring/berserker_ring
	icon='ammy.dmi'
	icon_state="snow"
	desc="A magical ring that allows you to wield two swords instead of a shield."
	suffix = "<span style=\"color:#ffa500;\">Allows you to wield two swords but no shield.</span>"
	passive = RING_DUAL_SWORD
	monsterDmg = 3

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner,overridetext,forceremove)
		if(. == WORN)
			for(var/obj/items/wearable/shield/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			var/i = 0
			for(var/obj/items/wearable/sword/W in owner.Lwearing)
				i++
				if(i >= 2)
					W.Equip(owner,1,1)

obj/items/wearable/ring/guardian_ring
	icon='ammy.dmi'
	icon_state="snow"
	desc="A magical ring that allows you to wield two shields instead of a sword."
	suffix = "<span style=\"color:#ffa500;\">Allows you to wield two shields but no sword.</span>"
	passive = RING_DUAL_SHIELD
	monsterDef = 3

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner,overridetext,forceremove)
		if(. == WORN)
			for(var/obj/items/wearable/sword/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			var/i = 0
			for(var/obj/items/wearable/shield/W in owner.Lwearing)
				i++
				if(i >= 2)
					W.Equip(owner,1,1)

obj/items/wearable/shield
	bonus  = 0
	socket = 0
	rarity = 3
	Armor  = 5
	showoverlay = FALSE

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		if(!forceremove && !overridetext && !(src in owner.Lwearing) && world.time - owner.lastCombat <= COMBAT_TIME)
			owner << errormsg("You can't equip this while in combat.")
			return
		if(!forceremove && !(src in owner.Lwearing) && owner.loc && owner.loc.loc && owner.loc.loc:antiEffect)
			owner << errormsg("You can not use it here.")
			return
		if(!forceremove && !(src in owner.Lwearing) && (RING_DUAL_SWORD in owner.passives))
			owner << errormsg("You can not use this.")
			return
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] hangs \his [src.name] onto \his arm.")
			var/allowed = (RING_DUAL_SHIELD in owner.passives) ? 2 : 1
			for(var/obj/items/wearable/shield/W in owner.Lwearing)
				if(W != src && --allowed <= 0)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] into \his pocket.")

obj/items/wearable/shield/mana
	icon='ammy.dmi'
	icon_state="snow"
	name="Emperor's bracelet"
	desc="A magical bracelet that converts 50% of damage taken into mana."
	suffix = "<span style=\"color:#ffa500;\">50% of damage taken will turn to mana.</span>"
	passive = SHIELD_MP
	monsterDef = 2

obj/items/wearable/shield/slayer
	icon='trophies.dmi'
	icon_state="Shield"
	name="Todd's shield"
	desc="Todd's magical shield, provides 15% damage reduction from monsters."
	suffix = "<span style=\"color:#ffa500;\">15% damage reduction from monsters.</span>"
	monsterDef = 15

obj/items/wearable/shield/selfdamage
	icon='trophies.dmi'
	icon_state="Shield"
	name="clown's shield"
	desc="A clown's shield, provides protection against accidents."
	suffix = "<span style=\"color:#ffa500;\">No damage from your own projectiles.</span>"
	passive = SHIELD_CLOWN
	monsterDef = 3

obj/items/wearable/shield/psychic
	icon='trophies.dmi'
	icon_state="Shield"
	name="psychic's shield"
	desc="Psychic's shield, 40% of damage is taken to mana before health."
	suffix = "<span style=\"color:#ffa500;\">40% of damage is taken to mana before health.</span>"
	passive = SHIELD_MPDAMAGE
	monsterDef = 2

obj/items/wearable/shield/gold
	icon='trophies.dmi'
	icon_state="Shield"
	name="golden shield"
	desc="You no longer suffer gold loss on death."
	suffix = "<span style=\"color:#ffa500;\">You no longer suffer gold loss on death.</span>"
	passive = SHIELD_GOLD
	monsterDef = 2

obj/items/wearable/shield/titan
	icon='trophies.dmi'
	icon_state="Shield"
	name="titan's shield"
	desc="Stat gain from this shield is doubled."
	suffix = "<span style=\"color:#ffa500;\">Stat gain from this shield is doubled.</span>"
	monsterDef = 5
	scale = 2

obj/items/wearable/shield/alchemy
	icon='trophies.dmi'
	icon_state="Shield"
	name="alchemist's shield"
	desc="You are immune to potions."
	suffix = "<span style=\"color:#ffa500;\">You are immune to potions.</span>"
	passive = SHIELD_ALCHEMY
	monsterDef = 3

obj/items/wearable/shield/ninja
	icon='trophies.dmi'
	icon_state="Shield"
	name="ninja's shield"
	desc="Enables dodge. (25%)"
	suffix = "<span style=\"color:#ffa500;\">Enables dodge. (25%)</span>"
	passive = SHIELD_NINJA
	monsterDef = 5

obj/items/wearable/shield/nurse
	icon='trophies.dmi'
	icon_state="Shield"
	name="Nurse's Shield"
	desc="Episkey provides 25% health shield on use."
	suffix = "<span style=\"color:#ffa500;\">Episkey provides 25% health shield on use.</span>"
	passive = SHIELD_NURSE
	monsterDef = 5

obj/items/wearable/shield/tank
	icon='trophies.dmi'
	icon_state="Shield"
	name="phalanx"
	desc="You are the tank."
	suffix = "<span style=\"color:#ffa500;\">You are the tank.</span>"
	monsterDef = 60
	monsterDmg = -100

obj/items/wearable/shield/spy
	icon='trophies.dmi'
	icon_state="Shield"
	name="spy's shield"
	desc="Occlumency is one tier higher. Always reveal who is watching you"
	suffix = "<span style=\"color:#ffa500;\">Occlumency is one tier higher. Always reveal who is watching you.</span>"
	passive = SHIELD_SPY
	monsterDef = 5

obj/items/wearable/shield/thorn
	icon='trophies.dmi'
	icon_state="Shield"
	name="shield of thorns"
	desc="Increases armor by 30%"
	suffix = "<span style=\"color:#ffa500;\">Increases armor by 30%.</span>"
	passive = SHIELD_THORN

obj/items/wearable/sword
	bonus  = 0
	socket = 0
	rarity = 3
	Armor  = 5
	showoverlay = FALSE

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		if(!forceremove && !overridetext && !(src in owner.Lwearing) && world.time - owner.lastCombat <= COMBAT_TIME)
			owner << errormsg("You can't equip this while in combat.")
			return
		if(!forceremove && !(src in owner.Lwearing) && owner.loc && owner.loc.loc && owner.loc.loc:antiEffect)
			owner << errormsg("You can not use it here.")
			return
		if(!forceremove && !(src in owner.Lwearing) && (RING_DUAL_SHIELD in owner.passives))
			owner << errormsg("You can not use this.")
			return
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] wields \his [src.name].")

			var/allowed = (RING_DUAL_SWORD in owner.passives) ? 2 : 1
			for(var/obj/items/wearable/sword/W in owner.Lwearing)
				if(W != src && --allowed <= 0)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] into \his pocket.")

obj/items/wearable/sword/slayer
	icon='trophies.dmi'
	icon_state="Sword"
	name="Todd's sword"
	desc="Todd's magical sword, granting the wielder 15% damage to monsters."
	suffix = "<span style=\"color:#ffa500;\">15% bonus damage to monsters.</span>"
	monsterDmg = 15

obj/items/wearable/sword/dragon
	icon='trophies.dmi'
	icon_state="dragon"
	name="Dragon's breath"
	desc="Dragon's breath allows you to use fire spells with full damage."
	suffix = "<span style=\"color:#ffa500;\">Fire spells now use full damage.</span>"
	passive = SWORD_FIRE

obj/items/wearable/sword/titan
	icon='trophies.dmi'
	icon_state="Sword"
	name="Titan's Sword"
	desc="Stat gain from this sword is doubled."
	suffix = "<span style=\"color:#ffa500;\">Stat gain from this sword is doubled.</span>"
	monsterDmg = 5
	scale = 2

obj/items/wearable/sword/vladmir
	icon='trophies.dmi'
	icon_state="Sword"
	name="Vladmir's Cutlass"
	desc="Lifesteal 20% of max HP on kill."
	suffix = "<span style=\"color:#ffa500;\">Lifesteal 20% of max HP on kill.</span>"
	passive = SWORD_HEALONKILL

obj/items/wearable/sword/wolf
	icon='trophies.dmi'
	icon_state="Sword"
	name="Wolf's Claw"
	desc="40% Chance to gain animagus charge on kill."
	suffix = "<span style=\"color:#ffa500;\">40% Chance to gain animagus charge on kill.</span>"
	passive = SWORD_ANIMAGUS

obj/items/wearable/sword/snake
	icon='trophies.dmi'
	icon_state="Sword"
	name="Akalla's Fang"
	desc="Serpensortia summons stronger snakes."
	suffix = "<span style=\"color:#ffa500;\">Serpensortia summons stronger snakes.</span>"
	passive = SWORD_SNAKE

obj/items/wearable/sword/gold
	icon='Scroll.dmi'
	icon_state="gold"
	name="Golden Scroll"
	desc="50% drop rate bonus."
	suffix = "<span style=\"color:#ffa500;\">50% drop rate bonus.</span>"
	dropRate = 50

obj/items/wearable/sword/ghost
	icon='trophies.dmi'
	icon_state="ghostblade"
	name="Ghostblade"
	desc="Changes all projectiles element to ghost."
	suffix = "<span style=\"color:#ffa500;\">Your projectiles element will be ghost.</span>"
	passive = SWORD_GHOST

obj/items/wearable/sword/explode
	icon='trophies.dmi'
	icon_state="boomblade"
	name="Boomblade"
	desc="Monsters you kill explode."
	suffix = "<span style=\"color:#ffa500;\">Monsters you kill explode.</span>"
	passive = SWORD_EXPLODE

obj/items/wearable/sword/mana
	icon='trophies.dmi'
	icon_state="ghostblade"
	name="Mageblade"
	desc="Drains all your mana for higher damage output."
	suffix = "<span style=\"color:#ffa500;\">Spells are empowered by mana.</span>"
	passive = SWORD_MANA
	monsterDmg = 2

obj/items/wearable/sword/alchemy
	icon='trophies.dmi'
	icon_state="Sword"
	name="Alchemist's blade"
	desc="15% chance to not consume potions.<br>Grants a chance to produce more than one potion."
	suffix = "<span style=\"color:#ffa500;\">15% chance to not consume potions.</span>"
	passive = SWORD_ALCHEMY
	monsterDmg = 3

obj/items/wearable/sword/clown
	icon='trophies.dmi'
	icon_state="Sword"
	name="clown's blade"
	desc="projectile spells fire 2 projectiles but at random direction."
	suffix = "<span style=\"color:#ffa500;\">projectile spells fire 2 projectiles but at random direction.</span>"
	passive = SWORD_CLOWN
	monsterDmg = 3

obj/items/wearable/sword/ninja
	icon='trophies.dmi'
	icon_state="Sword"
	name="ninja blade"
	desc="Enables back attack damage."
	suffix = "<span style=\"color:#ffa500;\">Enables back attack damage.</span>"
	passive = SWORD_NINJA

obj/items/wearable/sword/nurse
	icon='trophies.dmi'
	icon_state="Sword"
	name="nurse's sword"
	desc="Episkey is now area of effect ability."
	suffix = "<span style=\"color:#ffa500;\">Episkey is now area of effect ability.</span>"
	passive = SWORD_NURSE

obj/items/wearable/sword/thorn
	icon='trophies.dmi'
	icon_state="Sword"
	name="sword of thorns"
	desc="Reflects armor damage back."
	suffix = "<span style=\"color:#ffa500;\">Reflects armor damage back.</span>"
	passive = SWORD_THORN

obj/items/wearable/gm_robes
	icon = 'trims.dmi'
	dropable = 0
	wear_layer = FLOAT_LAYER - 6
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)

		. = ..(owner)
		if(. == WORN)
			for(var/obj/items/wearable/gm_robes/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)

obj/items/wearable/seal_bracelet

	rarity = 3
	showoverlay = FALSE

	icon = 'Season_bracelet.dmi'
	icon_state = "inactive"

	desc = "Equipping this will set your level back to 1, all exp earned will be added back upon reaching level cap again."

	var
		exp = 0
		level = lvlcap
		time

	Compare(obj/items/i)
		. = ..()

		return . && i:exp == exp && i:level == level && i:time == time

	Drop()
		set src in usr

		if((src in usr:Lwearing) && usr.level < lvlcap)
			usr << errormsg("You can't unequip this until level cap.")
			return

		hearers(usr) << infomsg("[usr] drops \his [src.name].")
		drop(usr, 1)

	drop(mob/Player/owner, amount = 1)

		if((src in owner.Lwearing) && owner.level < lvlcap)
			owner << errormsg("You can't unequip this until level cap.")
			return

		.=..(owner,amount)

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)

		if(!overridetext)
			if((src in owner.Lwearing) && owner.level < lvlcap)
				owner << errormsg("You can't unequip this until level cap.")
				return

			for(var/obj/items/wearable/seal_bracelet/S in owner.Lwearing)
				if(S != src)
					owner << errormsg("You can only wear one.")
					return

			if(!(src in owner.Lwearing))

				var/ScreenText/s = new(owner, src)

				s.AddText("Equipping this will set your level back to 1, are you sure you want to? (Experience will added back as experience rank upon reaching level cap again)")
				s.AddButtons(0, 0, "No", "#ff0000", "Yes", "#00ff00")

				if(!s.Wait()) return

				if(s.Result != "Yes") return

		. = ..(owner)
		if(. == WORN)

			if(!overridetext)
				icon_state = "ongoing"
				level = owner.level
				time  = world.realtime
				exp   = 0

				src.gender = owner.gender
				viewers(owner) << infomsg("[owner] wields \his [src.name].")

				owner.MMP = 200
				owner.MP = 200
				owner.level = 1
				owner.Mexp = 50
				owner.Exp = 0
				owner.resetStatPoints()
				owner.Year = "1st Year"

				owner << infomsg("Your base power has been sealed, you need to reach level cap to unequip this.")

		else if(. == REMOVED)


			if(!overridetext)
				var/seconds = round((world.realtime - time) / 10)
				var/minutes = round(seconds / 60)

				seconds -= minutes * 60

				var/hours = round(minutes / 60)

				minutes -= hours * 60

				var/days = round(hours / 24)

				hours -= days * 24

				name = "seal bracelet: \[[days] Days [hours]:[minutes]:[seconds]]"

				icon_state = "complete"

				viewers(owner) << infomsg("[owner] puts \his [src.name] into \his pocket.")

				owner.SendDiscord("[owner.ckey] completed sealing bracelet challenge in [days] Days [hours]:[minutes]:[seconds].", discord_event_hook)

obj/items/wearable/cog

	rarity = 3
	showoverlay = FALSE

	icon = 'trophies.dmi'
	icon_state = "cog"

	desc = "Converts legendries to artifacts when picked up by pets."

	var/tier = LEGENDARY

	crystal_cog
		tier = CRYSTAL
		icon_state = "crystal cog"
		desc = "Converts crystals to currency coins when picked up by pets."

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender

			if(owner.pet) owner.pet.convert |= tier

			for(var/obj/items/wearable/cog/W in owner.Lwearing)
				if(W != src && W.name == name)
					W.Equip(owner,1,1)

			if(!overridetext)
				viewers(owner) << infomsg("[owner] equips \his [name].")

		else if(. == REMOVED)

			if(owner.pet) owner.pet.convert &= ~tier

			if(!overridetext)
				viewers(owner) << infomsg("[owner] puts \his [name] away.")

obj/items/requirement_stone

	icon = 'trophies.dmi'
	icon_state = "Ruby"

	Click()
		if(src in usr)
			var/mob/Player/p = usr
			if(p.pathdest && istype(p.pathdest, /obj/teleport/rorEntrance))
				p.pathdest = null
				p.removePath()
			else
				p.classpathfinding = 0

				p.pathdest = locate(/obj/teleport/rorEntrance)
				if(!p.pathTo(p.pathdest))
					p.pathdest = null
					p << errormsg("You don't know where you are, pathfinding magic is impossible here.")
		..()

obj/items/wearable/wand_holster

	rarity = 3
	showoverlay = FALSE

	icon = 'Season_bracelet.dmi'
	icon_state = "inactive"

	desc = "holster for your wand!"

	max_stack = 1

	var
		list/selectedColors
		list/colors

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			for(var/obj/items/wearable/wand_holster/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)

			owner.holster = src

			new /hudobj/holster  (null, owner.client, null, 1)

			if(!overridetext)
				viewers(owner) << infomsg("[owner] equips \his [name].")

		else if(. == REMOVED)
			owner.holster = null

			var/hudobj/holster/o = locate() in owner.client.screen
			if(o)
				o.hide()
			for(var/hudobj/color_pick/c in owner.client.screen)
				c.hide()

			if(!overridetext)
				viewers(owner) << infomsg("[owner] puts \his [name] away.")
