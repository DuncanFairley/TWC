/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
#define WORN 1
#define REMOVED 2
mob/Player/var/list/Lwearing

area
	var/tmp
		antiTheft    = FALSE
		antiTeleport = FALSE
		antiFly      = FALSE

	inside
		antiTheft
			antiTheft = TRUE
			antiFly   = TRUE
		antiTeleport
			antiTeleport = TRUE
			antiFly      = TRUE

	Entered(atom/movable/Obj,atom/OldLoc)
		.=..()
		if(antiFly && isplayer(Obj))
			Obj:nofly()

obj/items
	var
		dropable      = 1
		takeable      = 1
		destroyable   = 0
		price         = 0
		tmp/antiTheft = 0

		stack     = 1
		max_stack = 0

	mouse_over_pointer = MOUSE_HAND_POINTER

	New()
		..()
		Sort()

	Move(NewLoc,Dir=0)
		.=..()

		Sort()

	proc
		Sort()
			if(istype(loc, /atom))
				for(var/obj/items/i in loc)
					if(i != src && Compare(i))
						Stack(i)
						if(!loc) return
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
				suffix  = "<font color=#c00>(x[stack])</font>"
				maptext = "<font size=1 color=#c00><b>[stack]</b></font>"
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
				Dispose()
			else
				Refresh()

		Split(size)
			if(max_stack)
				size = min(stack, max_stack)

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

			if(owner.splitSize || owner.splitItem)
				owner.splitSize = null
				owner.splitItem = null
				winset(owner, null, "splitStack.is-visible=false;")

			if(stack > 1 && amount < stack)
				var/obj/items/i = Split(amount)
				var/area/a = getArea(loc)
				if(a.antiTheft) i.owner = owner.ckey
				i.Move(owner.loc)
			else
				var/area/a = getArea(loc)
				if(a.antiTheft) src.owner = owner.ckey
				Move(owner.loc)

				if(owner.UsedKeys)
					for(var/k in owner.UsedKeys)
						if(owner.UsedKeys[k] == src)
							owner.removeKey(k)
							break

			owner.Resort_Stacking_Inv()

		Drop_All()
			set src in usr

			hearers(owner) << infomsg("[usr] drops all of \his [src.name] items.")
			drop(usr, stack)

obj/items/Click()
	if((src in oview(1)) && takeable)
		Take()
	..()
obj/items/verb/Take()
	set src in oview(1)

	if((antiTheft || loc.loc:antiTheft) && owner && owner != usr.ckey)
		usr << errormsg("This item isn't yours, a charm prevents you from picking it up.")
		return

	antiTheft = 0

	viewers() << infomsg("[usr] takes \the [src.name].")

	owner = null
	Move(usr)//loc = usr

	usr.Resort_Stacking_Inv()

obj/items/verb
	Drop()
		set src in usr

		hearers(owner) << infomsg("[usr] drops \his [src.name].")
		drop(usr, 1)

obj/items/MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
	if(isturf(over_object))
		if(src in usr)
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
	..()

mob/Player
	var/tmp
		obj/items/splitItem
		splitSize

	proc/split(obj/items/i_Item, loc)

		winset(src, null, "splitStack.is-visible=true;splitStack.splitPercent.value=100;splitStack.splitBar.value=100;splitButton.text=[i_Item.stack];")
		splitItem = i_Item

		while(splitItem && (i_Item in src) && i_Item && splitItem == i_Item)
			sleep(1)

		if(i_Item && splitItem == null && splitSize && (i_Item in src))
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




	verb/updateSplitStack()
		set hidden = 1
		if(!splitItem) return

		var/val = text2num(winget(src, "splitStack.splitPercent", "value"))
		var/s   = round(splitItem.stack * val / 100, 1)

		winset(src, null, "splitStack.splitButton.text=\"[s]\";splitStack.splitBar.value=[val];")

		s = min(s, splitItem.stack)
		s = max(s, 1)

		splitSize = s

obj/items/verb/Examine()
	set src in view(3)
	usr << infomsg("<i>[desc]</i>")
obj/items/proc/Destroy(var/mob/Player/owner)
	if(alert(owner,"Are you sure you wish to destroy your [src.name]?",,"Yes","Cancel") == "Yes")
		var/obj/item = src
		src = null
		del(item)
		owner.Resort_Stacking_Inv()
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

		showoverlay = TRUE
		wear_layer  = FLOAT_LAYER - 5

	Compare(obj/items/i)
		. = ..()

		return . && i:bonus == bonus && i:quality == quality

	Clone()
		var/obj/items/wearable/w = ..()

		w.bonus   = bonus
		w.quality = quality

		return w

	UpdateDisplay()
		var/const/WORN_TEXT = "<font color=blue>(Worn)</font>"
		var/worn = findtext(suffix, "worn")

		if(stack > 1)
			suffix  = "<font color=#c00>(x[stack])</font>"
			maptext = "<font size=1 color=#c00><b>[stack]</b></font>"

			if(worn)
				suffix  = "[suffix] [WORN_TEXT]"
		else
			maptext = null
			if(worn)
				suffix = WORN_TEXT
			else
				suffix  = null

obj/items/wearable/Destroy(var/mob/Player/owner)
	if(alert(owner,"Are you sure you wish to destroy your [src.name]?",,"Yes","Cancel") == "Yes")
		if(src in owner.Lwearing)
			Equip(owner)
		var/obj/item = src
		src = null
		del(item)
		owner.Resort_Stacking_Inv()
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
			o.layer = wear_layer

			owner.overlays -= o
		suffix = null
		UpdateDisplay()
		if(bonus != -1)
			if(bonus & DAMAGE)
				owner.clothDmg -= 10 * quality * scale
			if(bonus & DEFENSE)
				owner.clothDef -= 30 * quality * scale
				owner.resetMaxHP()
		return REMOVED
	else
		if(showoverlay && !owner.trnsed)
			var/image/o = new
			o.icon = src.icon
			o.layer = wear_layer

			owner.overlays += o

		if(!owner.Lwearing) owner.Lwearing = list()
		owner.Lwearing.Add(src)
		suffix = "worn"
		UpdateDisplay()
		if(bonus != -1)
			if(bonus & DAMAGE)
				owner.clothDmg += 10 * quality * scale
			if(bonus & DEFENSE)
				owner.clothDef += 30 * quality * scale
				owner.resetMaxHP()
		return WORN

obj/items/food
	canAuction = FALSE
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
obj/items/herosbrace
	name = "Hero's brace"
	icon = 'herosbrace.dmi'
	Click()
		if(src in usr)
			if(canUse(M=usr, needwand=0, inarena=0, inhogwarts=0, antiTeleport=1))
				if(usr.bracecharges>=1)
					var/turf/t
					switch(input("Where would you like to teleport to?","Teleport to?") as null|anything in list("Diagon Alley","Forbidden Forest","Graveyard"))
						if("Diagon Alley")
							t = locate("@DiagonAlley")
						if("Forbidden Forest")
							t = locate("@Forest")
						if("Graveyard")
							t = locate("@Graveyard")
					if(t && canUse(M=usr, needwand=0, inarena=0, inhogwarts=0) && usr.bracecharges>0)
						if(usr.bracecharges<1) return
						flick('tele2.dmi',usr)
						usr.bracecharges--
						usr:Transfer(t)
					if(usr.removeoMob) spawn()usr:Permoveo()
					for(var/obj/hud/player/R in usr.client.screen)
						del(R)
					for(var/obj/hud/cancel/C in usr.client.screen)
						del(C)

				else
					alert("Your brace is too drained to teleport. Try recharging it at Gringotts Wizarding Bank.")
		else
			..()

obj/items/snowring
	icon='ammy.dmi'
	icon_state="snow"
	name="Ring of Snow"
	desc="A magical ring that can manipulate snow."

	Click()
		if(src in usr)

			if(canUse(usr,cooldown=/StatusEffect/UsedSnowRing,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
				new /StatusEffect/UsedSnowRing(usr,60)
				var/obj/snowman/O = new(usr.loc)
				O.owner = "[usr.key]"

				src = null
				spawn(600)
					hearers(O) << "The snowman melts away."
					del O
		else
			..()


obj/items/Zombie_Head
	icon='halloween.dmi'
	icon_state="head"
	desc = "The zombie's head stares at you."

	Click()
		if(src in usr)
			if(canUse(usr,cooldown=/StatusEffect/UsedTransfiguration,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=100,againstocclumens=1,againstflying=0,againstcloaked=1))
				new /StatusEffect/UsedTransfiguration(usr,15)
				if(usr.CanTrans(usr))
					flick("transfigure",usr)
					hearers()<<"<b><font color=red>[usr]</font>:<b><font color=green> Personio Inter vivos.</b></font>"
					usr.trnsed = 1
					usr.overlays = null
					if(usr.away)usr.ApplyAFKOverlay()
					if(usr.Gender=="Female")
						usr.icon = 'FemaleZombie.dmi'
					else
						usr.icon = 'MaleZombie.dmi'
		else
			..()

obj/items/Whoopie_Cushion
	icon='jokeitems.dmi'
	icon_state = "Whoopie_Cushion"
	var/isset = 0
	canAuction = FALSE
	proc
		Fart(sitter)
			hearers() << "<font color=#FD857D size=3><b>A loud fart is heard from [sitter]'s direction.</b></font>"
			del(src)
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

obj/items/scroll
	icon = 'Scroll.dmi'
	destroyable = 1
	accioable=1
	wlable = 1
	canAuction = FALSE
	var/content
	var/tmp/inuse = 0
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
				usr << "<font color=white>The scroll is currently being used.</font>"
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
			msg = dd_replacetext(msg,"\n","<br>")

			var/obj/items/scroll/s = stack > 1 ? Split(1) : src
			s.content += "<body bgcolor=black><u><font color=blue><b><font size=3>[name]</u><p><font color=red><font size=1>by [usr] <p><p><font size=2><font color=white>[msg] <p>"
			s.icon_state = "wrote"
			s.loc = usr
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
			loc = null
			usr:Resort_Stacking_Inv()

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
				s.loc  = src.loc
				s.name = "gift wrappings"

			usr:Resort_Stacking_Inv()

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
						fadeText(usr, "<font color=[c]>[msg]</font>", offset, 20)
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
	canAuction = FALSE
obj/items/freds_key
	name = "Fred's key"
	icon = 'key.dmi'
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

obj/items/wearable/brooms
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		if(!forceremove && !(src in owner.Lwearing) && owner.loc && owner.loc.loc && (owner.loc.loc:antiFly||istype(owner.loc.loc,/area/ministry_of_magic)))
			owner << errormsg("You cannot fly here.")
			return
		if(!forceremove && !(src in owner.Lwearing) && owner.findStatusEffect(/StatusEffect/Knockedfrombroom))
			owner << errormsg("You can't get back on your broom right now because you were recently knocked off.")
			return
		if(!(src in owner.Lwearing) && owner.trnsed)
			owner << errormsg("You can't fly while transfigured.")
			return
		if(locate(/obj/items/wearable/invisibility_cloak) in owner.Lwearing)
			owner << errormsg("Your cloak isn't big enough to cover you and your broom.")
			return
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] jumps on \his [src.name].")
			owner.density = 0
			owner.flying = 1
			owner.icon_state = "flying"
			for(var/obj/items/wearable/brooms/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] dismounts from \his [src.name].")
			owner.density = 1
			owner.flying = 0
			owner.icon_state = ""
obj/items/wearable/brooms/firebolt
	icon = 'firebolt_broom.dmi'
obj/items/wearable/brooms/nimbus_2000
	icon = 'nimbus_2000_broom.dmi'
obj/items/wearable/brooms/cleansweep_seven
	icon = 'cleansweep_seven_broom.dmi'

obj/items/wearable/brooms/vampire_wings
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

			animate(owner, pixel_y = owner.pixel_y,    time = 2, loop = -1)
			animate(       pixel_y = owner.pixel_y + 1,time = 2)
			animate(       pixel_y = owner.pixel_y,    time = 2)
			animate(       pixel_y = owner.pixel_y - 1,time = 2)

			if(!overridetext)viewers(owner) << infomsg("[owner] puts on \his [src.name].")

		else if(. == REMOVED || forceremove)
			var/image/i = new('VampireWings.dmi', "flying")
			i.layer = FLOAT_LAYER - 3
			i.pixel_x = -16
			i.pixel_y = -16
			i.color = color
			i.alpha = alpha
			owner.overlays -= i
			owner.pixel_y = 0

			animate(owner)

			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] away.")

obj/items/wearable/brooms/floating_rock
	showoverlay = FALSE

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

			animate(owner, pixel_y = owner.pixel_y,    time = 2, loop = -1)
			animate(       pixel_y = owner.pixel_y + 1,time = 2)
			animate(       pixel_y = owner.pixel_y,    time = 2)
			animate(       pixel_y = owner.pixel_y - 1,time = 2)

			if(!overridetext)viewers(owner) << infomsg("[owner] climbs on \his [src.name].")

		else if(. == REMOVED || forceremove)
			var/image/i = new('floating_rock.dmi', "flying")
			i.layer = 3
			i.pixel_y = -21
			i.color = color
			i.alpha = alpha

			owner.overlays -= i
			owner.pixel_y = 0

			animate(owner)

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

	desc = "When equipped, your equipped wand will earn experience and level up by killing monsters."

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
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


	var
		exp
		modifier = 1

	Consume()
		exp = initial(exp)

		..()

	max_stack = 1

	chaos
		name       = "orb of chaos"
		bonus      = 5
		exp   	   = 15000
		icon_state = "chaos"

		greater
			name     = "greater orb of chaos"
			exp      = 60000
			modifier = 1.5
			quality  = -2

	peace
		name       = "orb of peace"
		bonus      = 6
		exp        = 15000
		icon_state = "peace"

		greater
			name     = "greater orb of peace"
			exp      = 60000
			modifier = 1.5
			quality  = -2

mob/Player/var/tmp/obj/items/wearable/wands/wand

obj/items/wearable/wands
	scale = 3
	var
		track
		displayColor
		projColor
		killCount        = 0
		monsterKillCount = 0
		exp              = 0
		tmp/display = FALSE

		lastused

		const
			MAX = 3

	bonus = NOENCHANT
	max_stack = 1

	proc
		maxExp()
			return round((1 + (quality * 10)) * 20000)
		addExp(mob/Player/owner, amount)
			if(quality >= MAX)
				exp = 0
				return

			var/obj/items/wearable/orb/o = locate() in owner.Lwearing
			if(o)
				amount = round(amount * o.modifier, 1)

				if(o.exp < amount) amount = o.exp

				o.exp -= amount
				if(o.exp == 0)
					o.Equip(owner)
					o.Consume()
					owner << errormsg("[o.name] shatters.")

				exp += amount

				var/i = 0
				while(exp >= maxExp())
					exp -= maxExp()

					if(quality + i >= MAX)
						exp = 0
						break

					i += 0.1

				if(i)
					Equip(owner, 1)

					quality += i
					bonus = o.bonus|bonus

					Equip(owner, 1)

					var/list/s = split(name, " +")
					name = "[s[1]] +[quality * 10]"

					owner << infomsg("[s[1]] leveled up to [quality * 10]!")

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

				var/list/s = split(name, " +")
				name = s[1]

			lastused = owner.ckey
			owner.wand = src

			if(!overridetext)
				if(track)
					displayKills(owner, 0, 1)
					displayKills(owner, 0, 2)
				if(track && displayColor)
					viewers(owner) << infomsg({"[owner] draws \his <font color="[displayColor]">[src.name]</font>."})
				else
					viewers(owner) << infomsg("[owner] draws \his [src.name].")
		else if(. == REMOVED)
			owner.wand = null
			if(!overridetext)
				if(track && displayColor)
					viewers(owner) << infomsg({"[owner] puts \his <font color="[displayColor]">[src.name]</font> away."})
				else
					viewers(owner) << infomsg("[owner] puts \his [src.name] away.")

proc/displayKills(mob/Player/i_Player, count=0, countType=1)
	set waitfor = 0

	if(i_Player.wand && i_Player.wand.track)
		var/obj/items/wearable/wands/w = i_Player.wand
		while(w.display)
			sleep(1)

		w.display = TRUE
		spawn(3) w.display = FALSE

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
			fadeText(i_Player, "<b><font color=\"[w.displayColor]\">[num] </font></b>", offset, 20)
		else
			fadeText(i_Player, "<b>[num]</b>", offset, 20)

obj/items/wearable/wands/cedar_wand //Thanksgiving
	icon = 'cedar_wand.dmi'
	displayColor = "#c86426"
	dropable = 0
	verb/Delicio_Maxima()
		set category = "Spells"
		if(src in usr:Lwearing)
			if(canUse(usr,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
				new /StatusEffect/UsedTransfiguration(usr,30)
				hearers()<<"<b><font color=red>[usr]</font>:<b><font color=white> Delicio Maxima.</b></font>"
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
						M<<"<b><font color=#D6952B>Delicio Charm:</b></font> [usr] turned you into some Thanksgiving awesome-ness."
					sleep(1)
		else
			usr << errormsg("You need to be using this wand to cast this.")
obj/items/wearable/wands/maple_wand //Easter
	icon = 'maple_wand.dmi'
	displayColor = "#D6968F"
	dropable = 0
	verb/Carrotosi_Maxima()
		set category = "Spells"
		if(src in usr:Lwearing)
			if(canUse(usr,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
				new /StatusEffect/UsedTransfiguration(usr,30)
				hearers()<<"<b><font color=red>[usr]</font>:<b><font color=white> Carrotosi Maxima.</b></font>"
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
						M<<"<b><font color=red>Carrotosi Charm:</b></font> [usr] turned you into a Rabbit."
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
	icon = 'interruption_wand.dmi'
obj/items/wearable/wands/salamander_wand //Bag of goodies
	icon = 'salamander_wand.dmi'
	displayColor = "#FFa500"
obj/items/wearable/wands/mithril_wand
	icon = 'mithril_wand.dmi'
obj/items/wearable/wands/mulberry_wand
	icon = 'mulberry_wand.dmi'
	displayColor = "#f39"
obj/items/wearable/wands/royale_wand //Royal event reward?
	icon = 'royale_wand.dmi'
	displayColor = "#8560b3"
obj/items/wearable/wands/pimp_cane //Sylar's wand thing
	icon = 'pimpcane_wand.dmi'
obj/items/wearable/wands/birch_wand
	icon = 'birch_wand.dmi'
	displayColor = "#fff"
obj/items/wearable/wands/oak_wand
	icon = 'oak_wand.dmi'
	displayColor = "#960"
obj/items/wearable/wands/mahogany_wand
	icon = 'mahogany_wand.dmi'
	displayColor = "#966"
obj/items/wearable/wands/elder_wand
	icon = 'elder_wand.dmi'
	displayColor = "#ff0"
obj/items/wearable/wands/willow_wand
	icon = 'willow_wand.dmi'
	displayColor = "#f00"
obj/items/wearable/wands/ash_wand
	icon = 'ash_wand.dmi'
	displayColor = "#cab5b5"
obj/items/wearable/wands/duel_wand
	icon = 'duel_wand.dmi'
	displayColor = "#088"
obj/items/wearable/wands/blood_wand
	icon = 'blood_wand.dmi'
	displayColor = "#9A1010"
obj/items/wearable/wands/dragonhorn_wand
	icon = 'dragonhorn_wand.dmi'
	displayColor = "#037800"
obj/items/wearable/wands/light_wand
	icon = 'light_wand.dmi'
	displayColor = "#64c8ff"

obj/items/wearable/wigs
	price = 500000
	bonus = 0
	desc = "A wig to hide those dreadful split ends."
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
/*obj/items/wearable/wigs/male_demonic_wig
	icon = 'male_demonic_wig.dmi'
	name = "Demonic's wig"*/
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

/////////

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
obj/items/wearable/magic_eye
	icon = 'MoodyEye.dmi'
	desc = "This magical eye allows the wearer to see through basic and intermediate invisibility magic."
	wear_layer = FLOAT_LAYER - 6
	Equip(var/mob/Player/owner,var/overridetext=0)
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] jams \his magical eye into \his eye socket.")
			if(!owner.Gm)owner.see_invisible = 1
			for(var/obj/items/wearable/magic_eye/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes out \his magical eye from its socket.")
			if(!owner.Gm)owner.see_invisible = 0
obj/items/wearable/invisibility_cloak
	icon = 'invis_cloak.dmi'
	showoverlay=0
	desc = "This magical cloak renders the wearer invisible."
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
			var/wascloaked = 0
			for(var/obj/items/wearable/invisibility_cloak/W in owner.Lwearing)
				if(W != src)
					wascloaked = 1
					W.Equip(owner,1,1)
			if(!wascloaked)
				owner<<"You put on the cloak and become invisible to others."
				flick('mist.dmi',owner)
				owner.invisibility=1
				owner.sight |= SEE_SELF
				owner.alpha = 125

		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] appears from nowhere as \he removes \his [src.name].")
			owner.invisibility=0
			owner.sight &= ~SEE_SELF
			owner.alpha = 255

obj/items/wearable/title
	var/title = ""
	icon = 'scrolls.dmi'
	icon_state = "title"
	desc = ""

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
var/arenaSummon = 0
	//0 = off
	//1 = mapOne	House Wars
	//2 = mapTwo	Clan Wars
	//3 = MapThree	FFA
mob/GM/verb/Arena_Summon()
	if(currentArena)
		src << "Arena summon can't be used while a match has already started."
		return
	if(arenaSummon == 0)
		var/map = input("Which Map do you want to allow teleportation to?") as null|anything in list("House Wars", "Clan Wars", "Free-For-All")
		if(!map) return
		switch(map)
			if("House Wars")
				arenaSummon = 1
			if("Clan Wars")
				arenaSummon = 2
			if("Free-For-All")
				arenaSummon = 3
		for(var/client/C)
			if(arenaSummon == 2)
				if(C.mob.DeathEater || C.mob.Auror)
					C << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a></h3>"
			else
				C << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a></h3>"
	else
		var/ans = alert("Do you want to re-announce the teleport message, or disable it?",,"Re-announce","Disable","Cancel")
		switch(ans)
			if("Re-announce")
				var/map
				switch(arenaSummon)
					if(1)
						map = "House Wars"
					if(2)
						map = "Clan Wars"
					if(3)
						map = "Free-For-All"
				for(var/client/C)
					if(arenaSummon == 2)
						if(C.mob.DeathEater || C.mob.Auror)
							C << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a></h3>"
					else
						C << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a></h3>"
			if("Disable")
				arenaSummon = 0
mob/GM/verb/Arena()
	if(currentArena)
		del currentArena
		src << "Previous round deleted."
		return
	var/list/plyrs = list()
	currentArena = new()
	switch(alert("Teams or Free For All?","Game type","Team","FFA","Cancel"))
		if("Team")
			switch(alert("How many teams?","Number of teams","2 (Auror vs DE)","4 (House wars)","Cancel"))
				if("2 (Auror vs DE)")
					alert("Players (and you) must be on MapTwo when you click OK to be loaded into the round. Arena Summon is disabled when you press OK")
					arenaSummon = 0
					currentArena.roundtype = CLAN_WARS
					for(var/mob/M in locate(/area/arenas/MapTwo/Auror))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapTwo/DE))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapTwo))
						plyrs.Add(M)
					for(var/mob/Player/M in plyrs)
						M.DuelRespawn = 0
				if("4 (House wars)")
					alert("Players (and you) must be on MapOne when you click OK to be loaded into the round. Arena Summon is disabled when you press OK")
					arenaSummon = 0
					currentArena.roundtype = HOUSE_WARS
					for(var/mob/M in locate(/area/arenas/MapOne/Gryff))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapOne/Slyth))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapOne/Huffle))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapOne/Raven))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapOne))
						plyrs.Add(M)
					for(var/mob/Player/M in plyrs)
						M.DuelRespawn = 0
				if("Cancel")
					del currentArena
					return
		if("FFA")
			alert("Players (and you) must be on MapThree when you click OK to be loaded into the round. Arena Summon is disabled when you press OK")
			arenaSummon = 0
			currentArena.roundtype = FFA_WARS
			for(var/mob/M in locate(/area/arenas/MapThree/WaitingArea))
				if(M.client)
					M.DuelRespawn = 0
					plyrs.Add(M)
		if("Cancel")
			del currentArena
			return
	currentArena.players.Add(plyrs)
	switch(currentArena.roundtype)
		if(FFA_WARS)
			if(!currentArena) return
			src << "FFA map selected"
			for(var/mob/M in currentArena.players)
				M << "<u>Preparing arena round...</u>"
			alert("Prizes are not automatically given in this Arena Mode. Round will start when you press OK.")
			currentArena.players << "<center><font size = 4>The arena mode is <u>Free For All</u>. Everyone is your enemy.<br>The last person standing wins!</center>"
			sleep(30)
			if(!currentArena) return
			currentArena.players << "<h5>Round starting in 10 seconds</h5>"
			sleep(50)
			if(!currentArena) return
			currentArena.players << "<h5>5 seconds</h5>"
			sleep(50)
			if(!currentArena) return
			currentArena.players << "<h4>Go!</h5>"
			currentArena.started = 1
			var/list/rndturfs = list()
			for(var/turf/T in locate(/area/arenas/MapThree/PlayArea))
				rndturfs.Add(T)
			currentArena.speaker = pick(MapThreeWaitingAreaTurfs)
			for(var/mob/M in currentArena.players)
				var/turf/T = pick(rndturfs)
				M.loc = T
				M.density = 1
				M.HP = M.MHP+M.extraMHP
				M.MP = M.MMP+M.extraMMP
				M.updateHPMP()
		if(CLAN_WARS)
			if(!currentArena) return
			src << "Clan wars map selected"
			for(var/mob/M in currentArena.players)
				M << "<u>Preparing arena round...</u>"
			switch(alert("Do you want to enable clan pillars?","Enable Clan Pillars","Yes","No"))
				if("Yes")
					clanevent1 = 1
					clanevent1_respawntime = input("Seconds before respawn of destroyed pillar?",,60)
					clanevent1_pointsgivenforpillarkill = input ("Number of points given for destroyed pillar?",,5)
					var/MHP = input("Hits required to destroy pillar?",,100)
					for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/Auror))
						C.enable(MHP)
					for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/DE))
						C.enable(MHP)
				if("No")
					clanevent1 = 0
					for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/Auror))
						C.disable(MHP)
					for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/DE))
						C.disable(MHP)
			var/killsreq = input("How many points must a team have to win?",,10) as num
			currentArena.goalpoints = killsreq
			currentArena.teampoints = list("Aurors" = 0, "Deatheaters" = 0)
			currentArena.plyrSpawnTime = input("How long must a player wait to respawn (in seconds)?",,10) as num
			currentArena.amountforwin = input("How many clan points does the winning team receive?",,10) as num
			for(var/mob/M in currentArena.players)
				if(M.aurorrobe)
					var/obj/Bed/B = pick(Map2Aurorbeds)
					M.loc = B.loc
				else if(M.derobe)
					var/obj/Bed/B = pick(Map2DEbeds)
					M.loc = B.loc
				M.HP = M.MHP+M.extraMHP
				M.MP = M.MMP+M.extraMMP
				M.updateHPMP()
				M.dir = SOUTH
			currentArena.players << "<center><font size = 4>The arena mode is <u>Clan Wars</u>. Aurors vs Deatheaters.<br>The first clan to reach [currentArena.goalpoints] points wins!</center>"
			sleep(30)
			if(!currentArena) return
			currentArena.players << "<h5>Round starting in 10 seconds</h5>"
			sleep(100)
			if(!currentArena) return
			currentArena.players << "<h4>Go!</h5>"
			currentArena.started = 1
		if(HOUSE_WARS)
			if(!currentArena) return
			src << "House wars map selected"
			for(var/mob/M in currentArena.players)
				M << "<u>Preparing arena round...</u>"
			var/killsreq = input("How many kills must a team have to win?",,10) as num
			currentArena.goalpoints = killsreq
			currentArena.teampoints = list("Gryffindor" = 0, "Ravenclaw" = 0, "Slytherin" = 0,"Hufflepuff" = 0)
			currentArena.plyrSpawnTime = input("How long must a player wait to respawn (in seconds)?",,10) as num
			currentArena.amountforwin = input("How many house points does the winning team receive?",,10) as num
			for(var/mob/M in currentArena.players)
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
				M.HP = M.MHP+M.extraMHP
				M.MP = M.MMP+M.extraMMP
				M.updateHPMP()
			currentArena.players << "<center><font size = 4>The arena mode is <u>House Wars</u>.<br>The first house to reach [currentArena.goalpoints] arena points wins [currentArena.amountforwin] house points!"
			sleep(30)
			if(!currentArena) return
			currentArena.players << "<h5>Round starting in 10 seconds</h5>"
			sleep(100)
			if(!currentArena) return
			currentArena.players << "<h4>Go!</h5>"
			currentArena.started = 1
mob/NPC/var/walkingBack = 0

mob/Del()
	Players -= src
	..()

mob/Player/Logout()
	Players<<"<B><font size=2 color=red><I>[usr] <b>logged out.</b></I></font></B>"
	if(arcessoing)
		stop_arcesso()
	if(rankedArena)
		rankedArena.disconnect(src)
	else if(currentMatches.queue && (src in currentMatches.queue))
		currentMatches.removeQueue(src)
	if(currentArena)
		if(src in currentArena.players)
			//currentArena.players.Remove(src)
			src.HP = 0
			src.Death_Check(src)
			src.loc = locate(50,49,15)
			src.GMFrozen = 0
	if(loc && loc.loc)
		loc.loc.Exit(src)
		loc.loc.Exited(src)
	if(removeoMob)
		var/tmpmob = removeoMob
		removeoMob:removeoMob = null
		src = null
		spawn()
			tmpmob:ReturnToStart()
	..()
var/const
	HOUSE_WARS = 1
		//First team to get to a specific number of kills, wins.
	CLAN_WARS = 2
		//Teams are eliminated if they lose all of their players. Players get set amount of lives. Last team standing wins.
	FFA_WARS = 3
		//First player to get a specific number of kills, wins.
	REWARD_GOLD = 1
	REWARD_POINTS = 2
var/arena_round/currentArena = null

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
		for(var/mob/M in players)
			M.GMFrozen = 0
		clanevent1 = 0
		for(var/obj/clanpillar/C in world)
			C.disable()
	proc
		handleSpawnDelay(mob/Player/M)
			sleep(plyrSpawnTime*10)
			M.GMFrozen = 0
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
					if("Aurors")
						worldData.housepointsGSRH[5] += amountforwin
					if("Deatheaters")
						worldData.housepointsGSRH[6] += amountforwin
				Players << "<font color = red>[team] have earned [amountforwin] points.</font>"
				Save_World()
				del(currentArena)

		Reward(var/mob/Player/plyr,amount)
			//ONly used in Arena
			if(rewardforwin == REWARD_GOLD)
				plyr.gold.add(amount)
				plyr << "You have been awarded [amount] gold."
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
	var/HP = 50
	var/MHP = 50
	density = 0
	invisibility = 101
	var/clan = "Auror"
	name = "Peace headquarters"
	icon = 'clanpillar.dmi'
	icon_state = "Auror"
	proc
		Death_Check(mob/Player/attacker)
			if(HP<1)
				if(currentArena)
					currentArena.players << "[attacker] has destroyed [name]."
					if(attacker.DeathEater)
						currentArena.Add_Point("Deatheaters",clanevent1_pointsgivenforpillarkill)
					else if(attacker.Auror)
						currentArena.Add_Point("Aurors",clanevent1_pointsgivenforpillarkill)
				else
					//If world ClanWars
					if(clan == "Deatheater")
				//		worldData.housepointsGSRH[5] += 10
						clanwars_event.add_auror(10)

						attacker.addRep(8)
					else if(clan == "Auror")
				//		worldData.housepointsGSRH[6] += 10
						clanwars_event.add_de(10)

						attacker.addRep(-8)


					Players << "[attacker] has destroyed [name] and earned 10 points for the [clan == "Deatheater" ? "peace" : "chaos"] clan."

				density = 0
				invisibility = 101
				spawn()respawn_count()
			..()
		enable(MHP2)
			density = 1
			invisibility = 0
			MHP = MHP2
			HP = MHP
			if(currentArena)
				if(clan == "Auror")
					for(var/mob/Player/M in currentArena.players)
						if(M.Auror)M << "Aurors - <font color = white><i>\The [src] has respawned."
				else if(clan == "Deatheater")
					for(var/mob/Player/M in currentArena.players)
						if(M.DeathEater)M << "Deatheaters - <font color = white><i>\The [src] has respawned."
			else
				//If world ClanWars
				for(var/mob/Player/M in Players)
					if(clan == "Deatheater" && M.getRep() < -100)
						M << infomsg("Chaos: <i>\The [src] has respawned.</i>")
					else if(clan == "Auror" && M.getRep() > 100)
						M << infomsg("Peace: <i>\The [src] has respawned.</i>")
		disable()
			density = 0
			invisibility = 101
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
				HP = MHP
				if(currentArena)
					if(clan == "Auror")
						for(var/mob/Player/M in currentArena.players)
							if(M.Auror)M << "Aurors - <font color = white><i>\The [src] has respawned."
					else if(clan == "Deatheater")
						for(var/mob/Player/M in currentArena.players)
							if(M.DeathEater)M << "Deatheaters - <font color = white><i>\The [src] has respawned."
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

	var
		spell

		r = 0
		g = 0
		b = 0

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

				usr<<"<b><font color=white><font size=3>You learned [generic.name]."
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

	peace
		name = "Book of Peace: Vol II"
		icon_state = "peace"
		spell = /mob/Spells/verb/Immobulus
		b = 0.6
		g = 0.5


obj/items/stickbook
	name="The Crappy Artist's Guide to Stick Figures"
	icon='Books.dmi'
	icon_state="stick"
	desc = "Remind me why I bought this?"
	Click()
		if(src in usr)
			usr<<"<b><font color=white><font size=3>You learned Crapus Sticketh."
			usr.verbs += /mob/Spells/verb/Crapus_Sticketh
			Consume()
		else
			..()

obj/items/easter_egg
	icon='Eggs.dmi'
	desc="A colored easter egg! How nice!"


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
	dontsave=1
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

		flick('magic.dmi',src)

		pixel_x = rand(-6,6)
		pixel_y = rand(-6,6)

		spawn(rand(600,1200))
			loc=null

obj/items/artifact
	name = "Artifact"
	icon = 'trophies.dmi'

	max_stack = 1

	New()
		..()
		spawn(1)
			if(name == "Artifact")
				name = ""
				var/time = pick("Ancient","Old","")
				var/prop = pick("Magical", "Shiny", "Mysterious", "")
				if(time) name += time + " "
				if(prop) name += prop + " "
				name += "Artifact"
			if(!icon_state) icon_state = pick(icon_states(icon))


obj/items/lamps
	icon       = 'lamp.dmi'
	icon_state = "inactive"
	var
		effect
		seconds
		tmp/StatusEffect/S

	max_stack = 1

	double_drop_rate_lamp
		desc    = "Doubles your drop rate."
		effect  = /StatusEffect/Lamps/DropRate/Double
		seconds = 1800
	triple_drop_rate_lamp
		desc    = "Triples your drop rate."
		effect  = /StatusEffect/Lamps/DropRate/Triple
		seconds = 1800
	quadaple_drop_rate_lamp
		desc    = "Quadaples your drop rate."
		effect  = /StatusEffect/Lamps/DropRate/Quadaple
		seconds = 1800
	penta_drop_rate_lamp
		desc    = "Increases your drop rate x5."
		effect  = /StatusEffect/Lamps/DropRate/Penta
		seconds = 900
	sextuple_drop_rate_lamp
		desc    = "Increases your drop rate x6."
		effect  = /StatusEffect/Lamps/DropRate/Sextuple
		seconds = 600

	double_exp_lamp
		desc    = "Doubles your exp gain rate."
		effect  = /StatusEffect/Lamps/Exp/Double
		seconds = 1800
	triple_exp_lamp
		desc    = "Triples your exp gain rate."
		effect  = /StatusEffect/Lamps/Exp/Triple
		seconds = 1800
	quadaple_exp_lamp
		desc    = "Quadaples your exp gain rate."
		effect  = /StatusEffect/Lamps/Exp/Quadaple
		seconds = 1800
	penta_exp_lamp
		desc    = "Increases your exp x5."
		effect  = /StatusEffect/Lamps/Exp/Penta
		seconds = 900
	sextuple_exp_lamp
		desc    = "Increases your exp x6."
		effect  = /StatusEffect/Lamps/Exp/Sextuple
		seconds = 600

	double_gold_lamp
		desc    = "Doubles your gold gain rate."
		effect  = /StatusEffect/Lamps/Gold/Double
		seconds = 1800
	triple_gold_lamp
		desc    = "Triples your gold gain rate."
		effect  = /StatusEffect/Lamps/Gold/Triple
		seconds = 1800
	quadaple_gold_lamp
		desc    = "Quadaples your gold gain rate."
		effect  = /StatusEffect/Lamps/Gold/Quadaple
		seconds = 1800
	penta_gold_lamp
		desc    = "Increases your gold x5."
		effect  = /StatusEffect/Lamps/Gold/Penta
		seconds = 900
	sextuple_gold_lamp
		desc    = "Increases your gold x6."
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

	farmer_lamp
		desc    = "Removes damage, gold and exp level reductions allowing you to farm gold and exp from lower level monsters."
		effect  = /StatusEffect/Lamps/Farming
		seconds = 3600
	Click()
		if(src in usr)
			if(S)
				S.Deactivate()
			else
				S = new effect (usr, seconds, src)
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
				usr:Resort_Stacking_Inv()
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
						D.player1.movable = 1
						range(9) << "[usr] enters the duel."
					else if(!D.player2 && D.player1 != usr)
						var/turf/t = locate(x+3,y,z)
						if(istype(t, /turf/teleport) || (locate(/obj/teleport) in t))
							return

						D.player2 = usr
						D.player2:Transfer(t)
						D.player2.dir = WEST
						D.player2.movable = 1
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
							usr.movable = 0
							del D
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
									D.player1.movable = 0
									D.player2.movable = 0
									spawn(60)
										var/obj/duelblock/B1 = locate(/obj/duelblock) in locate(x-2,y,z)
										var/obj/duelblock/B2 = locate(/obj/duelblock) in locate(x+2,y,z)
										B1.density = 0
										B2.density = 0
									del D
					else if(D.player2 == usr)
						if(!D.player1)
							range(9) << "[usr] withdraws."
							usr.movable = 0
							del D
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
									spawn(60)
										var/obj/duelblock/B1 = locate(/obj/duelblock) in locate(x-2,y,z)
										var/obj/duelblock/B2 = locate(/obj/duelblock) in locate(x+2,y,z)
										B1.density = 0
										B2.density = 0
									del D

					else
						usr << "Both player positions are already occupied."
				else
					var/turf/t = locate(x-3,y,z)
					if(istype(t, /turf/teleport) || (locate(/obj/teleport) in t))
						return

					D = new(src)
					D.countdown = 5//input("Select count-down timer, for when both players have readied. (between 3 and 10 seconds)","Count-down Timer",D.countdown) as null|num
					range(9) << "[usr] initiates a duel."
					D.player1 = usr
					D.player1:Transfer(t)
					D.player1.dir = EAST
					D.player1.movable = 1

obj/items/crystal
	icon = 'Crystal.dmi'

	var
		bonus      = 0 // 1 for damage, 2 for defense, 3 for both
		luck       = 0 // bonus chance
		ignoreItem = FALSE// ignores fourth item

	Click()
		if(src in usr)
			var/obj/enchanter/e = locate() in oview(2, usr)
			if(e)
				usr << errormsg("You hold [src.name] suddenly it disappears as it is absorbed within the magic circle.")
				e.applyBonus  |= bonus
				e.bonusChance += luck
				if(ignoreItem) e.ignoreItem++
				e.showBonus()
				Consume()
			else
				usr << errormsg("You hold [src.name] but nothing happens.")

		else
			..()
	damage
		name  = "red crystal"
		icon_state = "damage"
		bonus = 1
	defense
		name  = "green crystal"
		icon_state = "defense"
		bonus = 2
	magic
		name  = "magic crystal"
		icon_state = "magic"
		bonus = 3
		luck  = 5
	luck
		name  = "luck crystal"
		icon_state = "luck"
		luck  = 5
	strong_luck
		name  = "strong luck crystal"
		icon_state = "luck2"
		luck  = 10
	soul
		name = "soul crystal"
		icon_state = "soul"
		luck = 5
		ignoreItem = TRUE

obj/items/magic_stone
	var
		tmp/inUse = FALSE


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
		icon = 'Crystal.dmi'
		name = "teleport stone"
		var/dest

		desc = "Used for teleportation."

		Clone()
			var/obj/items/magic_stone/teleport/t = ..()

			t.dest       = dest
			t.name       = name
			t.icon_state = icon_state

			return t

		Compare()


		circle(mob/Player/p)
			if(dest)
				..(p)
			else
				var/turf/t = p.loc
				if(findtext(t.tag, "teleportPoint"))

					var/obj/items/magic_stone/teleport/s = stack > 1 ? Split(1) : src

					s.dest = copytext(t.tag, 14)
					s.name = "teleport stone \[[s.dest]]"
					s.icon_state = "teleport"

					if(s != src)
						s.Move(p)
						p.Resort_Stacking_Inv()

					p << infomsg("You charged your teleport stone to [dest].")
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

	weather
		acid
			name = "acid stone"
			icon_state = "Emerald"

			effect()
				weather.acid()

		snow
			name = "snow stone"
			icon_state = "Sapphire2"

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
			if(currentEvents)
				P << errormsg("You can't use this while an event is running.")
				return
			..(P)

		random
			name = "lucky coin"
			icon_state = "Coin"
			effect()
				var/random_type = pick(/RandomEvent/TheEvilSnowman, /RandomEvent/WillytheWhisp, /RandomEvent/Invasion)
				var/RandomEvent/event = locate(random_type) in events
				spawn() event.start()

		snowman
			name = "snowy coin"
			icon_state = "Coin"
			effect()
				var/RandomEvent/TheEvilSnowman/event = locate() in events
				spawn() event.start()
		willy
			name = "mysterious coin"
			icon_state = "Coin"
			effect()
				var/RandomEvent/WillytheWhisp/event = locate() in events
				spawn() event.start()

		blood
			name = "blood coin"
			icon_state = "Coin"

			circle(mob/Player/p)
				if(!(p.loc && (istype(p.loc.loc, /area/outside) || istype(p.loc.loc, /area/newareas/outside))))
					p << errormsg("You can only use this outside.")
					return

				var/area/outside/a = p.loc.loc
				if(a.lit)
					p << errormsg("You can only use this at night.")
					return

				..(p)

			effect()
				var/RandomEvent/VampireLord/event = locate() in events
				spawn() event.start()

		monsters
			name = "stinky coin"
			icon_state = "Coin"
			effect()
				var/RandomEvent/Invasion/event = locate() in events
				spawn() event.start()

	eye
		name = "death coin"
		icon_state = "Coin"

		circle(mob/Player/p)
			if(p.loc && p.loc.loc)
				var/area/a = p.loc.loc
				if(istype(a, /area/newareas/outside/Desert1) || istype(a, /area/newareas/outside/Desert2) || istype(a, /area/newareas/outside/Desert3))
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

		if(!canUse(p,cooldown=null,needwand=1,inarena=0,insafezone=0,inhogwarts=0,target=null,mpreq=3000))
			return
		if(!(p.loc && (istype(p.loc.loc, /area/outside) || istype(p.loc.loc, /area/newareas/outside))))
			p << errormsg("You can only use this outside.")
			return
		p.MP -= 3000
		p.updateHPMP()

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
			var/secs = 10

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



enchanting
	var
		reqType
		souls        = 0
		bonus        = 0
		chance       = 100
		prize

	proc
		check(obj/items/i, bonus, souls)
			if(istype(i, reqType) && (src.bonus & bonus) >= src.bonus && src.souls <= souls) return 1
			return 0

		getPrize()
			if(islist(prize)) return pickweight(prize)

			return prize

obj
	enchanter

		density = 1
		icon='Circle_magic.dmi'

		pixel_x = -65
		pixel_y = -64

		New()
			..()
			colors()

		var
			tmp
				inUse       = FALSE
				bonusChance = 0
				applyBonus  = 0
				ignoreItem  = 0
			max_upgrade = 3

		proc
			colors()
				animate(src, color = "#cc2aa2", time = 10, loop = -1)
				animate(color = "#55f933", time = 10)
				animate(color = "#0aa2df", time = 10)

			showBonus()
				if(applyBonus & 2)
					emit(loc    = src,
						 ptype  = /obj/particle/green,
					     amount = 3,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25))
				if(applyBonus & 1)
					emit(loc    = src,
						 ptype  = /obj/particle/red,
					     amount = 3,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25))

			bigcolor(var/c)
				animate(src, transform = matrix()*1.75, color = "[c]",   alpha = 150, time = 2,  easing = LINEAR_EASING)
				animate(transform = null,               color = "white", alpha = 255, time = 10, easing = BOUNCE_EASING)

			getRecipe(obj/items/i, bonus, souls)
				for(var/t in typesof(/enchanting) - /enchanting)
					var/enchanting/e = new t

					if(e.check(i, bonus, souls))
						return e

			enchant()
				if(inUse) return
				inUse = TRUE
				spawn(13)
					inUse = FALSE
					colors()

				animate(src)
				sleep(1)

				var/const/DISTANCE = 3
				var/obj/items/artifact/i1 = locate() in locate(x+DISTANCE,y,z)
				var/obj/items/artifact/i2 = locate() in locate(x-DISTANCE,y,z)
				var/obj/items/i3 = locate() in locate(x,y+DISTANCE,z)
				var/obj/items/i4 = ignoreItem ? i3 : locate() in locate(x,y-DISTANCE,z)

				if(!i1 || !i2)
					bigcolor("red")
					return

				if(!i3 || !i4 || i3.type != i4.type)
					bigcolor("blue")
					if(i3) step_rand(i3)
					if(i4) step_rand(i4)
					return

				var/chance = 100
				var/enchanting/e = getRecipe(i3, applyBonus, ignoreItem)
				var/prize
				if(e)
					prize  = e.getPrize()
					chance = e.chance
				else if(istype(i3, /obj/items/wearable/))
					if(istype(i3, /obj/items/wearable/title) && i3.name == i4.name)
						chance -= 40
						prize = i3.type

						var/red   = rand(80,240)
						var/green = rand(80,240)
						var/blue  = rand(80,240)

						if(applyBonus & 1) red   = min(255, red   + 50)
						if(applyBonus & 2) green = min(255, green + 50)
						if(ignoreItem)     blue  = min(255, blue  + 50)

						i3.color = rgb(red, green, blue)

					else if(i3:bonus != -1 && i3:quality < max_upgrade && i3:quality == i4:quality && !(i3:bonus & 4))
						var/flags = applyBonus|i3:bonus|i4:bonus

						if(ignoreItem && ignoreItem < i3:quality + 1) flags = 0

						if(flags)
							i3:bonus = applyBonus|i3:bonus|i4:bonus
							prize = i3.type
							i3:quality++
							chance -= i3:quality * 20

				if(!prize)
					bigcolor("black")
					if(i3) step_rand(i3)
					if(i4 && !ignoreItem) step_rand(i4)
					return

				i1.Consume()
				i2.Consume()
				i3.Consume()
				i4.Consume()

				bigcolor("#f84b7a")

				spawn(1)
					emit(loc    = src,
						 ptype  = /obj/particle/magic,
					     amount = 50,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25))

				sleep(12)
				var/turf/t = locate(x+rand(-1,1),y+rand(-1,1),z)
				if(prob(chance + bonusChance))
					var/obj/items/o = new prize (t)
					o.owner = i3.owner

					if(istype(i3, /obj/items/wearable/title))
						o.name = i3.name
						o:title = copytext(i3.name, 8)
						o.color = i3.color
						o:title = "<font color=\"[o.color]\">" + o:title + "</font>"
					else if(istype(i3, /obj/items/wearable) && !(i3:bonus & 4))
						o:quality = i3:quality
						o:bonus   = i3:bonus
						o.name += " +[o:quality]"

				else
					new /obj/items/DarknessPowder (t)

				bonusChance = 0
				applyBonus  = 0
				ignoreItem  = 0

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

		var/drops

		Click()
			if(src in usr)
				Open()
			else
				..()

		verb
			Open()
				set src in usr

				var/obj/items/chestKey = locate(text2path("/obj/items/key/[split(name, " ")[1]]_key")) in usr

				if(!chestKey)
					chestKey = locate(/obj/items/key/master_key) in usr

				if(chestKey)

					var/obj/roulette/r = new (usr.loc)
					r.getPrize(drops, usr.name, usr.ckey)

					usr << infomsg("You opened a [name]!")

					chestKey.Consume()
					Consume()
				else
					usr << errormsg("You don't have a [name] key to open this!")

		legendary_golden_chest
			icon_state = "golden"

		duel_chest
			icon_state = "duel"
			drops      = "duel"

		wizard_chest
			icon_state = "blue"
			drops      = "wizard"

		pentakill_chest
			icon_state = "red"
			drops      = "pentakill"

		basic_chest
			icon_state = "green"
			drops      = "basic"

		sunset_chest
			icon_state = "purple"
			drops      = "sunset"

		summer_chest
			icon_state = "orange"
			drops      = "summer"


			limited_edition
				name  = "special summer 2015 chest"
				drops = "2015 sum"

		winter_chest
			icon_state = "blue"
			drops      = "winter"


			limited_edition
				name  = "special winter 2015 chest"
				drops = "2015 winter"

		prom_chest
			icon_state = "pink"
			drops      = "prom"

			limited_edition
				name = "special prom 2015 chest"
				drops = "2015 prom"

		blood_chest
			icon_state = "red"
			drops      = "blood"

		community1_chest
			name = "community #1 chest"
			icon_state = "blue"
			drops      = "community1"

	key
		icon = 'ChestKey.dmi'

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
		special_key
			icon_state = "master"
		community_key
			icon_state = "blue"

var/list/chest_prizes = list("duel"      = list(/obj/items/wearable/scarves/duel_scarf       = 50,
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

							 "2015 sum"  = list(/obj/items/wearable/hats/orange_earmuffs     = 9,
							                    /obj/items/wearable/hats/yellow_earmuffs     = 9,
												/obj/items/wearable/shoes/orange_shoes       = 13,
							                    /obj/items/wearable/shoes/yellow_shoes       = 23,
							                    /obj/items/wearable/shoes/red_shoes          = 23,
							                    /obj/items/wearable/shoes/blue_shoes         = 23),

	                     	 "prom"      = list(/obj/items/wearable/scarves/pink_scarf       = 40,
							                    /obj/items/wearable/shoes/pink_shoes         = 30,
							                    /obj/items/wearable/shoes/darkpink_shoes     = 10,
							                    /obj/items/wearable/scarves/darkpink_scarf   = 20),

							 "2015 prom" = list(/obj/items/wearable/hats/darkpink_earmuffs   = 5,
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

							 "2015 winter"  = list(/obj/items/wearable/hats/red_earmuffs        = 10,
							                       /obj/items/wearable/hats/white_earmuffs      = 10,
							                       /obj/items/wearable/shoes/candycane_shoes    = 35,
							                       /obj/items/wearable/scarves/candycane_scarf  = 39,
												   /obj/items/snowring                          = 6),

							 "blood"     = list(/obj/items/wearable/scarves/blood_scarf = 50,
							 					/obj/items/wearable/shoes/blood_shoes   = 30,
							 					/obj/items/wearable/wands/blood_wand    = 20),

							 "community1"     = list(/obj/items/wearable/scarves/heartscarf    = 16,
							 					     /obj/items/wearable/scarves/alien_scarf   = 22,
							 					     /obj/items/wearable/scarves/snake_scarf   = 11,
							 					     /obj/items/wearable/scarves/booster_scarf = 25,
							 					     /obj/items/wearable/scarves/sunrise_scarf = 10,
							 					     /obj/items/wearable/scarves/icarus_scarf  = 16),

							 "gold only" = list(/obj/items/magic_stone/memory     = 10,
							                    /obj/items/herosbrace             = 20,
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

	proc/getPrize(drops, pname, pckey)
		set waitfor = FALSE

		playerName = pname
		playerCkey = pckey

		var/list/L
		if(!drops)
			L = list()
			var/amount = rand(3, 6)

			for(var/i = 1 to amount)
				var/category = pick(chest_prizes)

				if(category == "duel")
					i--
					continue

				L += pickweight(chest_prizes[category])

		else if(istext(drops) && (drops in chest_prizes))
			L = chest_prizes[drops]
		else if(islist(drops))
			L = chest_prizes[drops]
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
		ohearers(src) << infomsg("<b>[playerName] opened a chest and won \a [i]!</b>")

		i.antiTheft = 1
		i.owner     = playerCkey

		goldlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm")]: [playerName]([playerCkey]) got a [i.name] from a chest.<br />"

		spawn(600)
			if(i)
				i.antiTheft = 0
				i.owner     = null

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
			if(p.wand.quality * 10 < reqLevel)
				p << errormsg("Your wand has to be at least level [reqLevel].")
				return

			if(p.wand.projColor && alert("Are you sure you want to override this wand's color?", "Override Wand Color", "Yes", "No") == "No")
				return

			if(locate(/obj/wand_desk) in oview(1))
				p << infomsg("You applied new <font color=\"[projColor == "blood" ? "#a00" : projColor]\">magical color</font> to your equipped wand.")
				p.wand.projColor = projColor
				Dispose()
				p.Resort_Stacking_Inv()
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
	pink_stone
		reqLevel   = 10
		icon_state = "pink"
		projColor  = "#993f6c"
	teal_stone
		reqLevel   = 10
		icon_state = "teal"
		projColor  = "#226666"
	orange_stone
		reqLevel   = 10
		icon_state = "orange"
		projColor  = "#994422"
	blood_stone
		reqLevel   = 15
		icon_state = "red"
		projColor  = "blood"

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

	New()
		if(prob(10))
			rep *= 2
			name = "greater [name]"
		else if(prob(55))
			rep /= 2
			name = "small [name]"

		..()

	proc/Add(mob/Player/i_Player)
		var/r1 = i_Player.getRep()
		var/r2 = i_Player.addRep(rep)

		if(r1 == r2)
			i_Player << errormsg("You are at max reputation for your rank.")

		else if(Consume())
			i_Player.Resort_Stacking_Inv()

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

	Click()
		if(src in usr)

			var/obj/Hogwarts_Door/d = locate() in oview(1)
			if(d && d.vaultOwner == usr.ckey)
				usr << errormsg("You unlocked the door.")
				flick('Alohomora.dmi', d)
				d.door     = 1
				d.bumpable = 1
				Consume()
			else
				usr << errormsg("You need to use this near a locked vault door.")

		else
			..()