/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

#define SOLID  0
#define POWDER 1
#define LIQUID 2


WorldData/var
	list/potions
	potionsAmount = 0

obj/items/ingredients
	icon      = 'potions_ingredients.dmi'
	accioable = 1
	var
		id

		form = 0

	Clone()
		var/obj/items/ingredients/i = ..()

		i.id   = id
		i.form = form

		return i

	Compare(obj/items/i)
		. = ..()

		return . && i:form == form && i:id == id

	Click()
		if(src in usr)

			var/obj/potions/p = locate() in get_step(usr, usr.dir)
			if(p)

				if(p.isBusy)
					usr << errormsg("The tool is busy.")
					return

				if(stack < p.req)
					usr << errormsg("You need [p.req] ingredients to extract.")
					return

				var/obj/items/i
				if(stack > p.req)
					i = Split(p.req)
				else
					i = src
					loc = null
					usr:Resort_Stacking_Inv()

				usr << infomsg("You added \a [i] to \the [p].")

				p.Process(usr, i)

		else
			..()


	MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
		if((src in usr) && istype(over_object, /obj/potions))
			var/obj/potions/p = over_object

			if(p.isBusy)
				usr << errormsg("The tool is busy.")
				return

			var/obj/items/i

			if(stack < p.req)
				usr << errormsg("You need [p.req] ingredients to extract.")
				return

			if(stack > p.req)
				i = Split(p.req)
			else
				i = src
				loc = null
				usr:Resort_Stacking_Inv()

			usr << infomsg("You added \a [i] to \the [p].")

			p.Process(usr, i)

		else
			..()

	daisy
		icon_state = "daisy"
		id         = 1
	aconite
		icon_state = "aconite"
		id         = 2
	eyes
		icon_state = "eye"
		id         = 3
	rat_tail
		icon_state = "rat_tail"
		id         = 4

proc/spawnHerbs()

	for(var/a = 1 to rand(4, 8))

		var/t = pick(/obj/items/ingredients/daisy, /obj/items/ingredients/aconite)
		var/obj/items/i = new t()

		var/retry = 3
		while(!i.loc || i.loc.density || retry > 0)
			i.loc = locate(rand(1,100), rand(1,100), rand(16,18))

			if(istype(i.loc, /turf/grass))
				retry = 0
			else
				retry--

		if(!istype(i.loc, /turf/grass))
			var/obj/spawner/spawn_loc = pick(worldData.spawners)

			i.loc = locate(spawn_loc.x + rand(-3, 3), spawn_loc.y + rand(-3, 3), spawn_loc.z)

			i.density = 1
			step_rand(i)
			i.density = 0

obj/smoke
	icon          = 'dot.dmi'
	icon_state    = "default"
	mouse_opacity = 0
	layer         = 5

	alpha         = 168
	pixel_x       = 0
	pixel_y       = 0

	New()
		..()

		setColor("#090")

	proc/setColor(c)
		color = c

		transform = matrix()/1.5
		pixel_x   = initial(pixel_x)
		pixel_y   = initial(pixel_y)
		alpha     = initial(alpha)
		animate(src, pixel_x = pixel_x + rand(-10, 10), pixel_y = pixel_y + 36, alpha = 50, transform = matrix()*3, time = 24, loop = -1)

obj/potions
	var
		tmp/isBusy = FALSE
		req = 1

	icon = 'potions_tools.dmi'

	mouse_over_pointer = MOUSE_HAND_POINTER
	mouse_opacity = 2

	Click()
		..()

		usr << infomsg("Drag and drop an ingredient here or face and click the ingredient.")

	cauldron
		icon_state = "cauldron"

		var/tmp
			list/smoke
			pool = 0
			flags = 0

		New()
			set waitfor = 0
			..()

			color = rgb(rand(140, 255), rand(140, 255), rand(140, 255))

			smoke = list()

			var/obj/o = new (loc)

			o.icon       = 'potions_tools.dmi'
			o.icon_state = "liquid"
			o.color      = "#090"

			smoke += o

			for(var/i = 1 to 6)
				smoke += new /obj/smoke (loc)
				sleep(4)

		Click()
			..()

			usr << infomsg("Shoot with Inflamari to heat up.")

		Attacked(obj/projectile/p)
			if(!isBusy && p.owner && isplayer(p.owner))

				var/c = 0

				if(isnum(pool)) c = countBits(pool)
				else
					for(var/poolId in pool)
						c += countBits(pool[poolId])

				if(c  < 1) return

				var/list/projs = list()

				projs["aqua"]     = 1
				projs["quake"]    = 2
				projs["iceball"]  = 3
				projs["gum"]      = 4
				projs["chaotica"] = 5
				projs["blood"]    = 6

				var/potion
				var/quality = countBits(flags) - 1
				var/potionId

				if(p.icon_state in projs)
					var/f = abs(projs[p.icon_state] - quality)

					if(f == 0)     quality++
					else if(f > 2) quality--

				quality = max(1, quality)
				quality = min(7, quality)

				if(c >= 4)

					if(!worldData.potions) worldData.potions = list()

					if(isnum(pool))
						potionId = "[pool]"
					else
						potionId = ""
						for(var/poolId in pool)
							potionId += "[poolId];"
						potionId = copytext(potionId, 1, length(potionId) - 1)

					potion = worldData.potions[potionId]
					if(potion==null)
						var/chance = max(5, 50 + POTIONS_AMOUNT - worldData.potionsAmount)

						if(prob(chance))
							potion = pick(childTypes(/obj/items/potions))

							if(ispath(potion, /obj/items/potions/super))
								if(prob(75))
									potion = null
							else
								worldData.potions[potionId] = potion
								worldData.potionsAmount++

						else
							chance = worldData.potionsAmount / (worldData.potions.len + 1)
							if(prob(chance * 70))
								potion = 0
								worldData.potions[potionId] = potion


				if(potion)
					var/obj/o = smoke[1]
					emit(loc    = loc,
						 ptype  = /obj/particle/smoke/green,
					     amount = 15,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25),
					     color  = o.color)

					p.owner:checkQuestProgress("Brew Potion")

					var/obj/items/potions/i = new potion (loc)
					i.prizeDrop(p.owner.ckey, 600, decay=FALSE)
					i.quality   = quality
					if(quality != 4)
						var/list/letters = list("T", "D", "P", null, "A", "E", "O")
						i.name += " - [letters[quality]]"
						if(i.seconds) i.seconds *= 1 + (quality - 4) * 0.1

				else
					emit(loc    = loc,
						 ptype  = /obj/particle/smoke/green,
					     amount = 15,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25),
					     color  = "#000")

					if(potion == 0 && prob(70))
						emit(loc    = loc,
							 ptype  = /obj/particle/smoke,
							 amount = 60,
							 angle  = new /Random(get_angle(p.owner, src) + 95, get_angle(p.owner, src) + 85),
							 speed  = 6,
							 life   = new /Random(1,50),
							 color  = "#c60")

						spawn(4)
							if(p.owner)
								hearers(src) << errormsg("[p.owner]'s mixture caused an explosion.")
								p.owner.HP = 0
								p.owner.Death_Check(p.owner)

				var/i = worldData.potions.Find(potionId)
				if(i)
					if(!p.owner:knownPotions) p.owner:knownPotions = list()
					if(!(i in p.owner:knownPotions))
						p.owner:knownPotions += i

				setColor("#090")
				pool    = 0
				flags   = 0

			..()


		Move()
			..()

			for(var/obj/o in smoke)
				o.loc = loc

		Process(mob/Player/p, obj/items/ingredients/i)
			if(isBusy) return

			var/id     = (i.id - 1) * 3 + i.form
			var/poolId = 0

			while(id > 15)
				poolId++
				id -= 16

			if(poolId > 0)
				if(isnum(pool))
					var/t = pool
					pool = list()
					pool["0"] = t

			if(isnum(pool))
				pool |= 2 ** id
			else
				if("[poolId]" in pool) pool["[poolId]"] = 0
				pool["[poolId]"] |= 2 ** id

			var/f = 2 ** (i.id + 2)
			if(!(flags & f))
				flags |= f
				flags |= 2 ** (i.form)

			if(worldData.potions && ("[pool]" in worldData.potions))
				var/potion = worldData.potions["[pool]"]

				if(ispath(potion, /obj/items/potions/health))
					setColor("#f00")

				else if(ispath(potion, /obj/items/potions/mana))
					setColor("#5af")

				else if(ispath(potion, /obj/items/potions/invisibility_potion))
					setColor("#ccc")
				else
					setColor(rgb(rand(0,255), rand(0,255), rand(0,255)))

			else
				setColor(rgb(rand(0,255), rand(0,255), rand(0,255)))

			i = null
			..()

		proc
			setColor(c)
				set waitfor = 0

				var/obj/o = smoke[1]
				o.color = c

				for(var/obj/smoke/s in smoke)
					s.setColor(c)
					sleep(4)


	grind
		name       = "pestle and mortar"
		icon_state = "pestle"
		req = 2

		Process(mob/Player/p, obj/items/ingredients/i)
			if(isBusy)          return
			if(i.form != SOLID) return

			i.stack      = 1
			i.UpdateDisplay()
			i.form       = POWDER
			i.name       = "powdered [i.name]"
			i.icon_state = "[i.icon_state]_powder"

			..()

	dropper
		icon_state = "dropper"
		req = 3

		Process(mob/Player/p, obj/items/ingredients/i)
			if(isBusy)          return
			if(i.form != SOLID) return

			i.stack      = 1
			i.UpdateDisplay()
			i.form       = LIQUID
			i.name       = "[i.name] extract"
			i.icon_state = "[i.icon_state]_liquid"

			..()


	proc/Process(mob/Player/p, obj/items/ingredients/i)
		set waitfor = 0

		isBusy = TRUE

		var/obj/bar/b = new (locate(x, y + 1, z))
		b.countdown(320)

		var/pCkey = p.ckey

		sleep(320)

		isBusy = FALSE

		if(i)
			i.loc = loc
			i.prizeDrop(pCkey, 600, decay=FALSE)

obj/bar
	icon          = 'dot.dmi'
	icon_state    = "square"
	layer         = 6
	mouse_opacity = 0
	pixel_y       = -14

	proc/countdown(time)
		set waitfor = 0

		var/matrix/m_from = matrix(2, 0, 0, 0, 0.5, 0)
		var/matrix/m_to   = matrix(0, 0, 0, 0, 0.5, 0)

		transform = m_from

		var/obj/o       = new /obj/custom { mouse_opacity = 0; } (loc)
		o.appearance    = appearance

		o.color = rgb(rand(0,   100), rand(100, 255), rand(100, 255))
		color   = rgb(rand(100, 255), rand(0,   100), rand(100, 255))

		layer   = 7

		animate(o,   transform = m_to, time = time)
		animate(src, transform = m_to, time = time * 0.5)


		var/obj/text = new /obj/custom { layer          = 8;\
		                                 mouse_opacity  = 0;\
		                                 pixel_y        = -14;\
		                                 maptext_x      = 8;\
		                                 maptext_y      = 8;\
		                                 maptext_width  = 64;\
		                                 maptext_height = 64; }(loc)

		var/t = time / 10
		while(t)
			if(t < 10)
				text.maptext_x = 11

			text.maptext = "<span style=\"color:[t * 10 < time * 0.6 ? color : o.color];\"><b>[t]</b></span>"

			t--
			sleep(10)

		text.loc = null
		o.loc    = null
		loc      = null


obj/items/potions

	icon = 'potions.dmi'

	var
		effect
		seconds
		quality = 1

	Clone()
		var/obj/items/potions/i = ..()

		i.quality = quality
		i.seconds = seconds

		return i

	Click()
		if((src in usr) && canUse(M=usr, inarena=0))
			var/StatusEffect/Potions/p = locate() in usr.LStatusEffects
			if(p)
				usr << errormsg("[name] washed out the previous potion you consumed.")
				p.Deactivate()

			Consume()

			usr << infomsg("You drink \a [src].")
			new effect (usr, seconds, src)
		else
			..()

	blackout_potion
		name       = "blackout express"
		icon_state = "gray"
		effect     = /StatusEffect/Potions/Blackout
		seconds    = 30

	rainbow_potion
		icon_state = "purple"
		effect     = /StatusEffect/Potions/Rainbow
		seconds    = 60

	frost_potion
		icon_state = "blue"
		effect     = /StatusEffect/Potions/Frost
		seconds    = 60

	heat_potion
		icon_state = "red"
		effect     = /StatusEffect/Potions/Heat
		seconds    = 60

	health
		icon_state = "red"
		effect     = /StatusEffect/Potions/Health

		small_health_potion
			seconds = 10

		health_potion
			seconds = 20

		large_health_potion
			seconds = 30

		greater
			effect = /StatusEffect/Potions/Health { amount = 200 }
			small_greater_health_potion
				seconds = 10

			greater_health_potion
				seconds = 20

			large_greater_health_potion
				seconds = 30

	mana
		icon_state = "blue"
		effect     = /StatusEffect/Potions/Mana

		small_mana_potion
			seconds = 10

		mana_potion
			seconds = 20

		large_mana_potion
			seconds = 30

		greater
			effect = /StatusEffect/Potions/Mana { amount = 200 }

			small_greater_mana_potion
				seconds = 10

			greater_mana_potion
				seconds = 20

			large_greater_mana_potion
				seconds = 30

	invisibility_potion
		icon_state = "gray"
		effect     = /StatusEffect/Potions/Invisibility
		seconds    = 45

	stone_body_potion
		icon_state = "gray"
		effect     = /StatusEffect/Potions/Stone
		seconds    = 45

	cat_eyes_potion
		icon_state = "purple"
		effect     = /StatusEffect/Potions/NightSight
		seconds    = 300

	defense
		icon_state = "green"
		effect     = /StatusEffect/Potions/Defense

		small_defense_potion
			seconds = 120

		defense_potion
			seconds = 240

		large_defense_potion
			seconds = 360

	damage
		icon_state = "red"
		effect     = /StatusEffect/Potions/Damage

		small_damage_potion
			seconds = 120

		damage_potion
			seconds = 240

		large_damage_potion
			seconds = 360

	luck
		name       = "felix felicis"
		icon_state = "gray"
		effect     = /StatusEffect/Potions/Luck
		seconds    = 180

	taming_potion
		icon_state = "orange"
		effect     = /StatusEffect/Potions/Tame
		seconds    = 600

	super
		luck
			name       = "super felix felicis"
			icon_state = "gray"
			effect     = /StatusEffect/Potions/Luck { factor = 10.3 }
			seconds    = 180

		immortality_potion
			icon_state = "green"
			effect = /StatusEffect/Potions/Health { amount = 99999 }
			seconds = 120

		speed_potion
			icon_state = "green"
			effect = /StatusEffect/Potions/Speed
			seconds = 120

		vampire
			name       = "ego sanguinare"
			icon_state = "red"
			seconds    = 600
			effect     = /StatusEffect/Potions/Vampire


	instant

		proc/Effect(mob/Player/p)

		Click()
			if((src in usr) && canUse(M=usr, inarena=0))

				var/mob/Player/p = usr

				if(Effect(p))
					Consume()
			else
				..()

		wisdom_potion
			icon_state = "green"

			var/exp = 50000

			Effect(mob/Player/p)
				if(p.level < lvlcap)
					p << infomsg("You receive [comma(exp)] experience.")
					p.addExp(exp)
					. = 1

	pets

		growth
			name = "pet growth potion"
			icon_state = "purple"

			Effect(mob/Player/p)

				if(p.pet.item.currentSize >= 3)
					p << errormsg("You can't make your pet grow further.")
					return

				var/obj/items/wearable/pets/item = p.pet.item
				item.currentSize  += 0.25

				animate(p.pet, transform = matrix() * (item.currentSize / p.pet.iconSize), time = 10)

				p.pet.refresh(10)

				. = 1

		shrink
			name = "pet shrink potion"
			icon_state = "orange"

			Effect(mob/Player/p)

				if(p.pet.item.currentSize <= 0.75 || p.pet.item.currentSize <= p.pet.item.minSize)
					p << errormsg("You can't make your pet shrink further.")
					return

				var/obj/items/wearable/pets/item = p.pet.item
				item.currentSize  -= 0.25

				animate(p.pet, transform = matrix() * (item.currentSize / 4), time = 10)

				p.pet.refresh(10)

				. = 1

		color
			name = "pet coloring potion"
			icon_state = "green"

			Effect(mob/Player/p)

				new /obj/click2confirm/petColor (p.pet.loc, p)

				p << infomsg("Click the preview to confirm color change.")

				. = 1

		decolor
			name = "pet decoloring potion"
			icon_state = "gray"

			Effect(mob/Player/p)

				if(!p.pet.color)
					p << errormsg("Your pet doesn't have a color.")
					return

				var/obj/items/wearable/pets/item = p.pet.item

				item.color = null

				animate(p.pet, color = null, time = 10)

				. = 1

		ghost
			name = "pet ghosting potion"
			icon_state = "gray"

			Effect(mob/Player/p)

				var/obj/items/wearable/pets/item = p.pet.item

				if(item.alpha == 255)
					item.alpha = 190
				else if(item.alpha == 190)
					item.alpha = 120
				else
					item.alpha = 255

				animate(p.pet, alpha = item.alpha, time = 10)

				p.pet.refresh(10)

				. = 1

		exp
			name = "pet experience potion"
			icon_state = "green"

			Effect(mob/Player/p)
				var/obj/items/wearable/pets/item = p.pet.item

				if(p.pet.item.quality < MAX_PET_LEVEL)
					. = 1
					var/e = 10000 + (quality - 4) * 1600
					p << infomsg("Your [item.name] gained [e] experience.")
					item.addExp(p, e)
				else
					p << errormsg("Your [item.name] already reached max level")

		proc/Effect(mob/Player/p)


		Click()
			if((src in usr) && canUse(M=usr, inarena=0))

				var/mob/Player/p = usr

				if(!p.pet)
					p << errormsg("You don't have an owned pet near you.")
					return

				if(Effect(p))
					Consume()
			else
				..()

obj/click2confirm
	canSave             = FALSE
	mouse_over_pointer  = MOUSE_HAND_POINTER

	var/tmp/isDisposing = 0

	proc
		onConfirm(mob/Player/p)

	New(Loc, mob/Player/p)
		..()

		owner = p.ckey

	petColor
		var/itemColor

		onConfirm(mob/Player/p)
			p.pet.item.color = itemColor
			animate(p.pet, color = color, time = 10)

			p.pet.refresh(10)

			Dispose()

		New(Loc, mob/Player/p)
			set waitfor = 0

			appearance = p.pet
			mouse_over_pointer = MOUSE_HAND_POINTER

			itemColor = rgb(rand(40, 200), rand(40, 200), rand(40, 200))
			var/ColorMatrix/c = new(itemColor, 0.75)

			var/offset = p.pet.item.currentSize * 32
			var/px     = pixel_x + rand(-offset, offset)
			var/py     = pixel_y + rand(-offset, offset)

			animate(src, pixel_x = px, pixel_y = py, color = c.matrix, time = 15)

			..()

			sleep(100)

			if(!isDisposing) Dispose()

		Dispose()
			isDisposing = 1

			animate(src, alpha = 0, time = 8)
			sleep(6)
			loc = null
	Click()
		..()

		if(!isDisposing && owner == usr.ckey) onConfirm(usr)



proc/childTypes(typesOf)
	. = list()

	var/lastType
	for(var/t in typesof(typesOf))
		if(ispath(lastType, t)) continue
		. += t
		lastType = t

proc/countBits(c)
	. = c - ((c >> 1) & 0x5555)
	. = (. & 0x3333) + ((. >> 2) & 0x3333)
	. = ((. + (. >> 4) & 0x0F0F) * 0x0101) >> 8


obj
	herb
		icon       = 'bucket.dmi'
		icon_state = "big"
		density    = 1

		var
			tier
			soil
			water
			ownerCkey
			tmp/wait

		New(Loc, ownerCkey)
			..(Loc)

			tier  = rand(1, 3)
			soil  = tier * 50 * (11 - tier) / 10
			water = tier * 25 * (11 - tier) / 10

			transform = matrix() * 0.5

			src.ownerCkey = ownerCkey

		Attacked(obj/projectile/p)
			set waitfor = 0

			if(wait) return

			var/animate = 0

			if(soil > 0 && p.icon_state == "quake")
				soil--
				animate = 1

			else if(water > 0 && p.icon_state == "aqua")
				water--
				animate = 1

			if(soil == 0 && water == 0)
				pixel_x = 0
				wait    = 1

				var/obj/bar/b = new (y == world.maxy ? locate(x, y - 1, z) : locate(x, y + 1, z))
				b.countdown(320)

				var/matrix/m1 = matrix() * 0.5
				var/matrix/m2 = matrix() * 0.5
				m1.Scale(1.3, 1)
				m2.Scale(1,   1.3)

				animate(src, transform = m1, time = 5, loop = 32)
				animate(transform = m2, time = 5)

				sleep(320)
				var/obj/items/ingredients/i = pick(/obj/items/ingredients/daisy, /obj/items/ingredients/aconite)
				i = new i (loc)
				i.stack = rand(2, 4) * tier
				i.UpdateDisplay()
				i.prizeDrop(ownerCkey, protection=600, decay=FALSE)
				loc = null

			else if(animate && pixel_x == 0)
				animate(src, pixel_x = 1, time = 1, loop = 5)
				animate(pixel_x = -1, time = 1)

				sleep(11)
				pixel_x   = 0

mob/Player/var/list/knownPotions

obj/items/potions_book
	icon       = 'Books.dmi'
	icon_state = "potion"
	dropable   = 0
	var/master = 0

	Click()
		if(src in usr)

			if((!usr:knownPotions && !master) || !worldData.potions)
				usr << errormsg("Your book is empty, go brew potions!")
				return

			display(usr)
		else
			..()

	Topic(href, href_list[])
		if(href_list["action"] == "All")
			display(usr)
		else
			display(usr, href_list["action"])
		..()

	proc
		display(mob/Player/i_Player, sort)

			var/const/HEADER = {"<html><head><title>Potion Book</title><style>
body
{
	background-image: url('http://www.wizardschronicles.com/dpbg.jpg');
	margin: 8px;
	padding:0px;
}

table.colored
{
	background-color: #FAFAFA;
	filter: alpha(opacity=56);
	border-collapse: collapse;
	text-align: left;
	width:100%;
	font: normal 13px/100% Verdana, Tahoma, sans-serif;
	border: solid 1px #E5E5E5;
	padding:3px;
	margin: 4px;
}
tr.white
{
	background-color:#FAFAFA;
	border: solid 1px #E5E5E5;
}
tr.black
{
	background-color:#DFDFDF;
	border: solid 1px #E5E5E5;
}
</style></head><body><table align="center" class="colored"><tr><td colspan="4"><center>"}
			var/const/BOOM = "Bad Mix"
			var/sortText = sort ? "<a href='?src=\ref[src];action=All'>All</a>" : "All"
			var/list/types = list("Health", "Mana", BOOM, "Taming", "Pets", "Luck", "Defense", "Damage")
			for(var/t in types)
				sortText += t == sort ? " | [t]" : " | <a href='?src=\ref[src];action=[t]'>[t]</a>"

			var/html = {"</center></td></tr><tr><td><b># &nbsp &nbsp &nbsp </b></td><td><b>Name</b></td><td><b>Ingredients</b></td></tr>"}
			var/c = 0

			var/list/kp
			if(master)
				kp = list()
				for(var/i = 1 to worldData.potions.len)
					kp += i
			else
				kp = i_Player.knownPotions

			for(var/i in kp)
				var/ing    = worldData.potions[i]
				var/potion = worldData.potions[ing]

				if(potion == 0)
					if(sort != BOOM) continue
					potion = BOOM
				else
					if(sort == BOOM) continue
					if(sort && !findtext("[potion]", sort)) continue

					var/list/t = splittext("[potion]", "/")
					potion = replacetext(t[t.len], "_", " ")

				ing = text2num(ing)
				var/ingredients = ""

				if(ing & 1)    ingredients += "daisy, "
				if(ing & 2)    ingredients += "powdered daisy, "
				if(ing & 4)    ingredients += "daisy extract, "

				if(ing & 8)    ingredients += "aconite, "
				if(ing & 16)   ingredients += "powdered aconite, "
				if(ing & 32)   ingredients += "aconite extract, "

				if(ing & 64)   ingredients += "eyes, "
				if(ing & 128)  ingredients += "powdered eyes, "
				if(ing & 256)  ingredients += "eyes extract, "

				if(ing & 512)  ingredients += "rat tail, "
				if(ing & 1024) ingredients += "powdered rat tail, "
				if(ing & 2048) ingredients += "rat tail extract, "
				c++
				html += "<tr class=[c % 2 == 0 ? "white" : "black"]><td>[c]</td><td>[potion]</td><td>[copytext(ingredients, 1, length(ingredients) - 1)].</td></tr>"

			i_Player << browse(HEADER + sortText + html + "</table></body></html>", "window=potions")


