#define SOLID  0
#define POWDER 1
#define LIQUID 2


WorldData/var
	list/potions
	potionsAmount = 0

obj/items/ingredients
	icon      = 'potions_ingredients.dmi'
	accioable = 1
	rarity    = 0
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

				if(stack < p.req*p.mass)
					usr << errormsg("You need [p.req*p.mass] ingredients to extract.")
					return

				var/obj/items/i
				if(stack > p.req*p.mass)
					i = Split(p.req*p.mass)
				else
					i = src
					Dispose()

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

			if(stack < p.req*p.mass)
				usr << errormsg("You need [p.req*p.mass] ingredients to extract.")
				return

			if(stack > p.req*p.mass)
				i = Split(p.req*p.mass)
			else
				i = src
				Dispose()

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
	canSave       = FALSE

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
		animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), transform = null, alpha = initial(alpha), time = 0)

obj/potions
	var
		tmp/isBusy = FALSE
		req = 1
		tmp/mass = 1

	icon = 'potions_tools.dmi'

	mouse_over_pointer = MOUSE_HAND_POINTER
	mouse_opacity = 2

	density = 1

	Click()
		..()
		if(mass==1)
			mass = 10
			usr << infomsg("Mass brew on. (x10)")
		else
			usr << infomsg("Mass brew off. (x1)")
			mass = 1

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

			var/obj/o = new /obj/custom { canSave = 0 } (loc)

			o.icon       = 'potions_tools.dmi'
			o.icon_state = "liquid"
			o.color      = "#090"

			smoke += o

			for(var/i = 1 to 6)
				smoke += new /obj/smoke (loc)
				sleep(4)

		Click()
			if(isBusy) return
			..()

			usr << infomsg("Cauldron reset.")
			pool = 0
			flags = 0


		Attacked(obj/projectile/p)
			if(!isBusy && p.owner && isplayer(p.owner))

				if(!worldData.potions) worldData.potions = list()

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
				var/mob/Player/player = p.owner

				if(p.icon_state in projs)
					var/f = abs(projs[p.icon_state] - quality)

					if(f == 0)     quality++
					else if(f > 2) quality--

				if(RING_ALCHEMY in player.passives)
					quality++

				quality = max(1, quality)
				quality = min(7, quality)

				if(c >= 4)
					player.Alchemy.add(((quality*12 + rand(9,12))*300)*mass, player, 1)

					if(isnum(pool))
						potionId = "[pool]"
					else
						potionId = ""
						for(var/poolId in pool)
							potionId += "[poolId];"
						potionId = copytext(potionId, 1, length(potionId) - 1)

					potion = worldData.potions[potionId]
					if(potion==null)
						var/chance = clamp(50 + POTIONS_AMOUNT - worldData.potionsAmount + player.Alchemy.level, 10, 90)

						if(prob(chance))
							potion = pick(childTypes(/obj/items/potions, list(/obj/items/potions/health, /obj/items/potions/mana)))

							if(ispath(potion, /obj/items/potions/super))
								if(prob(max(75 - player.Alchemy.level, 25)))
									potion = null
							else
								worldData.potions[potionId] = potion
								worldData.potionsAmount++

						else
							chance = clamp((worldData.potionsAmount / (worldData.potions.len + 1))*50 - player.Alchemy.level, 1, 90)
							if(prob(chance))
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
						if(i.seconds) i.seconds *= 1 + (quality - 4) * 0.3

					var/quanChance = player.Alchemy.level
					var/maxProc = 4
					if(SWORD_ALCHEMY in player.passives)
						quanChance += 10 + player.passives[SWORD_ALCHEMY]
						maxProc = 6

					if(prob(quanChance*0.1))
						i.stack = maxProc*mass
						i.UpdateDisplay()
					else if(prob(quanChance))
						i.stack = rand(2,maxProc)*mass
						i.UpdateDisplay()
					else if(mass > 1)
						i.stack *= mass
						i.UpdateDisplay()

				else
					emit(loc    = loc,
						 ptype  = /obj/particle/smoke/green,
					     amount = 15,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25),
					     color  = "#000")

					if(potion == 0)
						emit(loc    = loc,
							 ptype  = /obj/particle/smoke,
							 amount = 60,
							 angle  = new /Random(get_angle(p.owner, src) + 95, get_angle(p.owner, src) + 85),
							 speed  = 6,
							 life   = new /Random(1,50),
							 color  = "#c60")

				/*		spawn(4)
							if(p.owner)
								hearers(src) << errormsg("[p.owner]'s mixture caused an explosion.")
								p.owner.HP = 0
								p.owner.Death_Check(p.owner)*/

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

			if(p)
				p.Alchemy.add(rand(3,9)*50*mass, p, 1)

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

			i.stack      = mass
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

			i.stack      = mass
			i.UpdateDisplay()
			i.form       = LIQUID
			i.name       = "[i.name] extract"
			i.icon_state = "[i.icon_state]_liquid"

			..()


	proc/Process(mob/Player/p, obj/items/ingredients/i)
		set waitfor = 0

		isBusy = TRUE

		var/time = 320

		if(p)
			time = max(time - round(p.Alchemy.level/5)*10, 50)

		var/obj/bar/b = new (locate(x, y + 1, z))
		b.countdown(time)

		var/pCkey = p.ckey

		sleep(time)

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
	canSave       = FALSE

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

mob/Player/var/tmp/potionsMode = 0
obj/items/potions

	icon = 'potions.dmi'
	icon_state = "red"

	var
		effect
		seconds
		quality = 1

		canThrow = 1

	Clone()
		var/obj/items/potions/i = ..()

		i.quality = quality
		i.seconds = seconds

		return i

	useTypeStack = /obj/items/potions
	stackName = "Potions:"

	Click(location,control,params,fairy=0)
		if((src in usr) && canUse(M=usr, inarena=0,needwand=0))

			if(usr:potionsMode == THROW && canThrow)
				var/obj/projectile/Potion/proj = usr.castproj(Type = /obj/projectile/Potion, icon_state = "potion", name = src.name, lag = 0)
				proj.effect  = effect
				proj.seconds = seconds
			else

				if(!fairy)
					var/StatusEffect/Potions/p = locate() in usr.LStatusEffects
					if(p)
						usr << errormsg("[name] washed out the previous potion you consumed.")
						p.Deactivate(0)

					usr << infomsg("You drink \a [src].")
				else
					usr << infomsg("You drink \a [src] (Fairy's ring).")

				if(!(SHIELD_ALCHEMY in usr:passives))
					new effect (usr, seconds, "Potion", src)

			if((SWORD_ALCHEMY in usr:passives) && prob(14 + usr:passives[SWORD_ALCHEMY])) return

			Consume()
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
		seconds    = 900

	heat_potion
		icon_state = "red"
		effect     = /StatusEffect/Potions/Heat
		seconds    = 900

	black_fire_potion
		icon_state = "red"
		effect     = /StatusEffect/Potions/LegendaryEffect { passives = list(SWORD_FIRE, RING_LAVAWALK, SWORD_THORN) }
		seconds    = 900

	confusing_concoction
		icon_state = "green"
		effect     = /StatusEffect/Potions/Confusion
		seconds    = 30

	draught_of_living_dead
		icon_state = "gray"
		effect     = /StatusEffect/Potions/FakeDead
		seconds    = 30

	pompion_potion
		icon_state = "red"
		effect     = /StatusEffect/Potions/Pumpkin
		seconds    = 30

	brain_elixir
		icon_state = "purple"
		effect     = /StatusEffect/Potions/LegendaryEffect { passives = list(RING_ALCHEMY, SHIELD_SPY, SWORD_ALCHEMY) }
		seconds    = 900

	health
		icon_state = "red"
		effect     = /StatusEffect/Potions/Health

		small_health_potion
			seconds = 1

		health_potion
			seconds = 2

		large_health_potion
			seconds = 3

		greater
			effect = /StatusEffect/Potions/Health { amount = 2000 }
			small_greater_health_potion
				seconds = 1

			greater_health_potion
				seconds = 2

			large_greater_health_potion
				seconds = 3


	mana
		icon_state = "blue"
		effect     = /StatusEffect/Potions/Mana

		small_mana_potion
			seconds = 5

		mana_potion
			seconds = 10

		large_mana_potion
			seconds = 15

		greater
			effect = /StatusEffect/Potions/Mana { amount = 300 }

			small_greater_mana_potion
				seconds = 5

			greater_mana_potion
				seconds = 10

			large_greater_mana_potion
				seconds = 15

	invisibility_potion
		icon_state = "gray"
		effect     = /StatusEffect/Potions/Invisibility
		seconds    = 900

	stone_body_potion
		icon_state = "gray"
		effect     = /StatusEffect/Potions/Stone
		seconds    = 900

	cat_eyes_potion
		icon_state = "purple"
		effect     = /StatusEffect/Potions/NightSight
		seconds    = 1200

	defense
		icon_state = "green"
		effect     = /StatusEffect/Potions/Defense

		small_defense_potion
			seconds = 900

		defense_potion
			seconds = 1200

		large_defense_potion
			seconds = 1800

	damage
		icon_state = "red"
		effect     = /StatusEffect/Potions/Damage

		small_damage_potion
			seconds = 900

		damage_potion
			seconds = 1200

		large_damage_potion
			seconds = 1800

	luck
		name       = "felix felicis"
		icon_state = "gray"
		effect     = /StatusEffect/Potions/Luck
		seconds    = 600

	taming_potion
		icon_state = "orange"
		effect     = /StatusEffect/Potions/Tame
		seconds    = 1200

	giant
		name       = "giant's draught"
		icon_state = "red"
		effect     = /StatusEffect/Potions/Size { size=2 }
		seconds    = 300

	dwarf
		name       = "dwarf's draught"
		icon_state = "green"
		effect     = /StatusEffect/Potions/Size { size=0.5 }
		seconds    = 300

	animagus_potion
		icon_state = "orange"
		effect     = /StatusEffect/Potions/Animagus
		seconds    = 300
		canThrow   = 0

		Click()
			if(src in usr)

				var/area/a = usr.loc.loc
				if(!istype(a, /area/hogwarts/Animagus))
					usr << errormsg("You can only drink this in Animagus Chamber.")
					return

				..()
			else
				..()

	polyjuice_potion
		icon_state = "orange"
		effect     = /StatusEffect/Potions/Polyjuice
		seconds    = 900
		canThrow   = 0

		Click()
			if(src in usr)

				var/obj/corpse/c = locate() in range(1, usr)
				if(c.gold >= 0 && c.gold != null)
					var/mutable_appearance/ma = new(usr)
					ma.icon = c.icon
					ma.icon_state = c.icon_state
					ma.overlays = c.overlays
					ma.underlays = c.underlays

					usr.appearance = ma

					..()
				else
					usr << errormsg("You need a player corpse nearby to transform.")
			else
				..()

	super
		luck
			name       = "super felix felicis"
			icon_state = "gray"
			effect     = /StatusEffect/Potions/Luck { factor = 10.3 }
			seconds    = 300

		immortality_potion
			icon_state = "green"
			effect = /StatusEffect/Potions/Health { amount = 99999 }
			seconds = 600

		speed_potion
			icon_state = "green"
			effect = /StatusEffect/Potions/Speed
			seconds = 1200

		vampire
			name       = "ego sanguinare"
			icon_state = "red"
			seconds    = 1200
			effect     = /StatusEffect/Potions/Vampire


	instant
		canThrow = 0
		proc/Effect(mob/Player/p)

		Click()
			if(src in usr)
				if(canUse(M=usr, inarena=0, needwand=0))
					var/mob/Player/p = usr

					if(Effect(p))
						Consume()
			else
				..()

		wisdom_potion
			icon_state = "green"

			var/exp = 60000

			Effect(mob/Player/p)
				if(p.level < lvlcap)
					var/e = exp * (1 + (quality - 4) * 0.3) + rand(exp * 0.1)
					p << infomsg("You receive [comma(e)] experience.")
					p.addExp(e)
					. = 1
				else
					p << errormsg("You can't use this, you're already super smart.")

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
					var/e = 30000 + (quality - 4) * 9000
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



proc/childTypes(typesOf, exclude)
	. = list()

	var/list/types = typesof(typesOf)
	var/lastType
	for(var/i = types.len to 1 step -1)
		var/t = types[i]
		if(ispath(lastType, t)) continue
		if(exclude)
			var/skip = 0
			for(var/p in exclude)
				if(ispath(t, p))
					skip =  1
					break
			if(skip) continue
		. += t
		lastType = t

proc/parentTypes(typesOf, exclude)
	. = list()

	var/lastType
	for(var/t in typesof(typesOf)-typesOf)
		if(ispath(t, lastType))	continue
		if(exclude)
			var/skip = 0
			for(var/p in exclude)
				if(ispath(t, p))
					skip =  1
					break
			if(skip) continue
		. += t
		lastType = t

proc/countBits(c)
	. = c - ((c >> 1) & 0x555555)
	. = (. & 0x333333) + ((. >> 2) & 0x333333)
	. = ((. + (. >> 4) & 0x0F0F0F) * 0x010101) >> 16


obj
	herb
		icon       = 'bucket.dmi'
		icon_state = "plant"
		density    = 1

		var
			plantType
			yields = 4
			delay
			lastUsed
			ownerCkey
			water = 0
			amount = 1
			cap = 0
			tmp/wait

		New(Loc, ownerCkey, plantType, delay, yields, amount, seedName, cap=0)
			..(Loc)

			src.plantType = plantType
			src.delay     = delay
			src.yields    = yields
			src.amount    = amount
			src.cap       = cap

			src.ownerCkey = ownerCkey

			if(istype(Loc, /turf/buildable))
				lastUsed = world.realtime

			if(seedName)
				name = splittext(seedName, " ")[1]

		MouseEntered(location,control,params)
			var/info = "Water helps with plant growth."

			if(lastUsed)
				if(water == 1)
					info = "Magic helps with plant growth."
				else if(water == -1)
					info = "This seems too wet."
				else if(water == 2)
					info = "Looks perfect!"

			winset(usr, null, "infobubble.labelTitle.text=\"[name]\";infobubble.labelInfo.text=\"[info]\"")
			winshowRight(usr, "infobubble")

		MouseExited(location,control,params)
			winshow(usr, "infobubble", 0)

		proc/grow(mob/Player/player)
			set waitfor = 0
			if(wait) return
			pixel_x = 0
			wait    = 1

			var/matrix/m1 = matrix()
			var/matrix/m2 = matrix()
			m1.Scale(1.3, 1)
			m2.Scale(1,   1.3)

			animate(src, transform = m1, time = 5, loop = 32)
			animate(transform = m2, time = 5)

			var/time = 320
			var/improvedAmount = amount

			if(isplayer(player))

				if(cap)

					improvedAmount += round(player.Gathering.level / (1 + rand(1, cap * 4) + cap))

					improvedAmount = min(improvedAmount, amount*cap)
				else
					improvedAmount += player.Gathering.level
				player.Gathering.add((improvedAmount*10 + rand(6,8))*100, player, 1)

				time = max(time - round(player.Gathering.level/5)*10, 50)

				if(lastUsed)
					var/chance = max(100 - water - yields - player.Gathering.level, 25)
					if(prob(chance))
						yields--

					improvedAmount += water

			var/obj/bar/b = new (y == world.maxy ? locate(x, y - 1, z) : locate(x, y + 1, z))
			b.countdown(time)

			sleep(time)
			var/obj/items/ingredients/i = new plantType (loc)
			i.stack = improvedAmount
			i.UpdateDisplay()
			i.prizeDrop(ownerCkey, protection=600, decay=FALSE)

			if(!lastUsed || --yields <= 0)
				loc = null
			else
				transform = null
				wait = 0
				lastUsed = world.realtime

		Click()
			if(lastUsed && (usr in range(1, src)) && !wait)
				if(world.realtime - lastUsed >= delay)
					grow(usr)
				else
					usr << errormsg("[name] is not ready for harvest")



		Attacked(obj/projectile/p)
			set waitfor = 0

			if(wait) return

			var/animate = 0

			if(p.icon_state == "aqua")
				if(lastUsed)
					if(water == 0)
						water = 1
					else if(water >= 1)
						water = -1
				else
					water++

				animate = 1

				if(water >= 25 && !lastUsed)
					grow(p.owner)
					return

			if(animate && pixel_x == 0)
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
	background-image: url('https://www.onlygfx.com/wp-content/uploads/2015/10/old-paper-texture-1.jpg');
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
				if(i > worldData.potions.len) continue
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


obj/plant
	icon = 'Plants.dmi'

	canSave = FALSE
	density = 1

	var/tmp
		level = 100
		HP = 1000
		MHP = 1000
		duration
		obj/healthbar/hpbar
		delay = 4

	New(loc, mob/Player/p, size=0)
		set waitfor = 0

		p.plants++

		..()

		owner = p

		level    = round(p.level/2 + p.Gathering.level*4)
		MHP      = 4 * (level) + 200
		HP       = MHP
		duration = 450 + p.Gathering.level*10


		hpbar = new(src)

		if(size)
			size = min(2, size + p.Gathering.level/30)

			var/matrix/m1 = matrix() * size
			var/matrix/m2 = matrix() * size
			m1.Scale(1.3, 1)
			m2.Scale(1,   1.3)

			animate(src, transform = m1, time = 5, loop = -1)
			animate(transform = m2, time = 5)

		sleep(4)
		state()

	Move(NewLoc)
		if(hpbar)
			hpbar.glide_size = glide_size
			hpbar.loc = NewLoc
		.=..()

	Dispose()
		set waitfor = 0

		density = 0
		animate(src, alpha = 0, time = 4)

		if(owner)
			owner:plants--
			owner = null

		if(hpbar)
			hpbar.loc = null
			hpbar = null

		sleep(5)
		loc = null

	Attacked(obj/projectile/p)
		if(isplayer(p.owner) && alpha != 0)

			var/dmg = p.damage + p.owner:Slayer.level

			if(p.owner:monsterDmg > 0)
				dmg *= 1 + p.owner:monsterDmg/100


			p.owner << "Your [p] does [dmg] damage to [src]."

			HP -= dmg

			if(HP > 0)
				var/percent = HP / MHP
				hpbar.Set(percent, src)
			else
				p.owner << errormsg("You destroyed [src].")
				Dispose()

	proc/state()
		set waitfor = 0

		while(duration > 0 && owner && get_dist(owner, src) < 30)

			effect()

			if(delay)
				glide_size = 32 / delay
				duration -= delay
				sleep(delay)

		if(loc) Dispose()

	proc/effect()


	firebreath
		icon_state = "Orange Flower"
		delay = 0

		effect()

			var/list/dirs = list(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH, SOUTHWEST, WEST, NORTHWEST)

			for(var/d in dirs)
				var/obj/projectile/P = new (src.loc,d,owner,'attacks.dmi',"fireball",level,"fire spit",FIRE)
				P.shoot(3)
				sleep(2)

			duration -= 16
	grumpy_hogweed
		icon_state = "Pink Flower"
		delay = 10

		New(loc, mob/Player/p, size=0)
			set waitfor = 0
			..(loc, p, size)

			var/image/img = image('lights.dmi',"green")
			img.transform *= 3
			img.layer = 8
			img.appearance_flags = RESET_TRANSFORM
			underlays += img

		effect()

			for(var/mob/Player/p in range(1, src))
				p.HP = min(p.MHP, p.HP + round(level, 1))
				p.updateHP()

	magicflow
		icon_state = "White Flower"
		delay = 10

		New(loc, mob/Player/p, size=0)
			set waitfor = 0
			..(loc, p, size)

			var/image/img = image('lights.dmi',"blue")
			img.transform *= 3
			img.layer = 8
			img.appearance_flags = RESET_TRANSFORM
			underlays += img

		effect()

			for(var/mob/Player/p in range(1, src))
				p.MP = min(p.MMP, p.MP + round(level, 1))
				p.updateMP()


mob/Player/var/tmp/plants = 0

obj/items/plant
	icon = 'Plants.dmi'
	rarity  = 2

	var/plantType

	Click()
		if(src in usr)

			if(usr.loc && usr.loc.loc && usr.loc.loc:antiSummon)
				owner << errormsg("You can not use it here.")
				return

			if(locate(/obj/plant) in range(2, usr))
				usr << errormsg("You can't grow a plant so close to another.")
				return

			var/mob/Player/p = usr
			if(p.plants >= 1 + p.extraLimit + round(p.Gathering.level / 10))
				p << errormsg("You need higher gathering level to plant more.")
				return

			usr << infomsg("You feed [src] a bit of magic, it sprouts to life.")

			new plantType (usr.loc, usr, 0.5)
			Consume()

		else
			..()

	grumpy_hogweed
		icon_state = "Pink Flower"
		plantType = /obj/plant/grumpy_hogweed
	magicflow
		icon_state = "White Flower"
		plantType = /obj/plant/magicflow
	firebreath
		icon_state = "Orange Flower"
		plantType = /obj/plant/firebreath


obj/items/seeds
	grumpy_hogweed_seeds
		plantType = /obj/items/plant/grumpy_hogweed
		delay = 36000
		cycles = 4
		amount = 3
	magicflow_seeds
		plantType = /obj/items/plant/magicflow
		delay = 36000
		cycles = 4
		amount = 3
	firebreath_seeds
		plantType = /obj/items/plant/firebreath
		delay = 36000
		cycles = 4
		amount = 3