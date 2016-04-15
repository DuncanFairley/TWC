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

				var/obj/items/i
				if(stack > 1)
					i = Split(1)
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
			if(stack > 1)
				i = Split(1)
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

	for(var/a = 1 to rand(4, 10))

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
			var/obj/spawner/spawn_loc = pick(spawners)

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
	var/tmp/isBusy = FALSE

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
			if(!isBusy && p.owner && p.icon_state == "fireball" && isplayer(p.owner))

				var/c = pool

				c = c - ((c >> 1) & 0x5555)
				c = (c & 0x3333) + ((c >> 2) & 0x3333)
				c = ((c + (c >> 4) & 0x0F0F) * 0x0101) >> 8

				if(c  < 1) return

				var/potion

				if(c >= 4)

					if(!worldData.potions) worldData.potions = list()

					potion = worldData.potions["[pool]"]
					if(!potion)
						var/chance = max(5, 100 - (worldData.potionsAmount * 5))

						if(prob(chance))
							potion = pick(childTypes(/obj/items/potions))
							worldData.potions["[pool]"] = potion
							worldData.potionsAmount++

						else
							chance = worldData.potionsAmount / (worldData.potions.len + 1)
							if(prob(chance * 75))
								potion = 0
								worldData.potions["[pool]"] = potion


				if(potion)
					var/obj/o = smoke[1]
					emit(loc    = loc,
						 ptype  = /obj/particle/smoke/green,
					     amount = 15,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25),
					     color  = o.color)

					var/obj/items/i = new potion (loc)
					i.antiTheft = 1
					i.owner     = p.owner.ckey
					spawn(600)
						if(i)
							i.antiTheft = 0
							i.owner     = null

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

						spawn(4)
							if(p.owner)
								hearers(src) << errormsg("[p.owner]'s mixture caused an explosion.")
								p.owner.HP = 0
								p.owner.Death_Check(p.owner)

				setColor("#090")
				pool = 0

			..()


		Move()
			..()

			for(var/obj/o in smoke)
				o.loc = loc

		Process(mob/Player/p, obj/items/ingredients/i)
			if(isBusy) return


			pool |= 2 ** ((i.id - 1) * 3 + i.form)

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

		Process(mob/Player/p, obj/items/ingredients/i)
			if(isBusy)          return
			if(i.form != SOLID) return

			i.form       = POWDER
			i.name       = "powdered [i.name]"
			i.icon_state = "[i.icon_state]_powder"

			..()

	dropper
		icon_state = "dropper"

		Process(mob/Player/p, obj/items/ingredients/i)
			if(isBusy)          return
			if(i.form != SOLID) return

			i.form       = LIQUID
			i.name       = "[i.name] extract"
			i.icon_state = "[i.icon_state]_liquid"

			..()


	proc/Process(mob/Player/p, obj/items/ingredients/i)
		set waitfor = 0

		isBusy = TRUE

		var/obj/bar/b = new (locate(x, y + 1, z))
		b.countdown(320)

		sleep(320)

		isBusy = FALSE

		if(i)
			i.loc = loc
			i.antiTheft = 1
			i.owner     = p.ckey

			sleep(600)

			if(i)
				i.antiTheft = 0
				i.owner     = null

obj/custom
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

	Click()
		if((src in usr) && canUse(M=usr, inarena=0))
			var/StatusEffect/Potions/p = locate() in usr.LStatusEffects
			if(p)
				usr << errormsg("[name] washed out the previous potion you consumed.")
				p.Deactivate()

			Consume()
			new effect (usr, seconds, src)
		else
			..()

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
		seconds    = 30

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


proc/childTypes(var/typesOf)
	. = list()

	var/lastType
	for(var/t in typesof(typesOf))
		if(ispath(lastType, t)) continue
		. += t
		lastType = t