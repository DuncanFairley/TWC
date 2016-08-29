
enchanting

	scroll
		reqType = /obj/items/scroll
		chance  = 40
		prize   = list(/obj/items/wearable/title/Bookworm,
		               /obj/items/wearable/title/Lumberjack)

	teleport
		reqType = /obj/items/artifact
		chance  = 30
		prize   = /obj/items/magic_stone/teleport

	weather
		reqType = /obj/items/crystal/soul
		bonus   = 3
		chance  = 60
		prize   = list(/obj/items/weather/sun,
		               /obj/items/weather/rain,
		               /obj/items/weather/acid,
		               /obj/items/weather/snow)

	damage_lamp
		reqType = /obj/items/crystal/damage
		bonus   = 3
		chance  = 50
		prize   = /obj/items/lamps/damage_lamp

	defense_lamp
		reqType = /obj/items/crystal/defense
		bonus   = 3
		chance  = 50
		prize   = /obj/items/lamps/defense_lamp

	luck_lamps
		reqType = /obj/items/crystal/luck
		bonus   = 3
		chance  = 60
		prize   = list(/obj/items/lamps/double_gold_lamp,
		               /obj/items/lamps/double_exp_lamp,
		               /obj/items/lamps/double_drop_rate_lamp,
		               /obj/items/crystal/strong_luck)

	strong_luck_lamps
		reqType = /obj/items/crystal/strong_luck
		bonus   = 3
		chance  = 50
		prize   = list(/obj/items/lamps/triple_gold_lamp,
		               /obj/items/lamps/triple_exp_lamp,
		               /obj/items/lamps/triple_drop_rate_lamp)

	summon
		reqType = /obj/items/crystal/magic
		bonus   = 3
		chance  = 30
		souls   = 1
		prize   = /obj/items/magic_stone/summoning/random

	deathcoin
		reqType = /obj/items/crystal/magic
		bonus   = 3
		chance  = 30
		souls   = 2
		prize   = /obj/items/magic_stone/eye

	memory
		reqType = /obj/items/magic_stone/teleport
		bonus   = 3
		chance  = 20
		souls   = 3
		prize   = /obj/items/magic_stone/memory

	chest
		reqType = /obj/items/chest
		bonus   = 3
		chance  = 50
		prize   = list(/obj/items/chest/basic_chest            = 45,
		               /obj/items/chest/wizard_chest           = 15,
		               /obj/items/chest/pentakill_chest        = 15,
					   /obj/items/chest/prom_chest             = 10,
					   /obj/items/chest/summer_chest           = 10,
					   /obj/items/chest/winter_chest           = 10,
					   /obj/items/chest/pet_chest              = 10,
					   /obj/items/chest/blood_chest            = 8,
		               /obj/items/chest/sunset_chest           = 4,
		               /obj/items/chest/legendary_golden_chest = 1)

	key
		reqType = /obj/items/key
		bonus   = 3
		chance  = 50
		prize   = list(/obj/items/key/basic_key            = 46,
		               /obj/items/key/wizard_key           = 15,
		               /obj/items/key/pentakill_key        = 15,
					   /obj/items/key/prom_key             = 10,
					   /obj/items/key/summer_key           = 10,
					   /obj/items/key/winter_key           = 10,
					   /obj/items/key/blood_key            = 8,
		               /obj/items/key/sunset_key           = 4)

	power_lamp
		reqType = /obj/items/crystal/magic
		bonus   = 3
		chance  = 30
		prize   = /obj/items/lamps/power_lamp

	chaos_orb
		reqType = /obj/items/wearable/orb/chaos
		bonus   = 1
		chance  = 60
		prize   = /obj/items/wearable/orb/chaos/greater

	peace_orb
		reqType = /obj/items/wearable/orb/peace
		bonus   = 2
		chance  = 60
		prize   = /obj/items/wearable/orb/peace/greater

	colors
		reqType = /obj/items/colors
		chance  = 55
		prize   = list(/obj/items/colors/red_stone    = 15,
		               /obj/items/colors/green_stone  = 15,
		               /obj/items/colors/blue_stone   = 15,
					   /obj/items/colors/yellow_stone = 15,
					   /obj/items/colors/purple_stone = 10,
					   /obj/items/colors/pink_stone   = 10,
					   /obj/items/colors/teal_stone   = 10,
		               /obj/items/colors/orange_stone = 10)


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

		Attacked(obj/projectile/p)
			enchant(p.owner)

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

			enchant(mob/Player/attacker)
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

				if(attacker)
					attacker.checkQuestProgress("Enchant")

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
						o:title = "<span style=\"color:[o.color];\">" + o:title + "</span>"
					else if(istype(i3, /obj/items/wearable) && !(i3:bonus & 4))
						o:quality = i3:quality
						o:bonus   = i3:bonus
						o.name += " +[o:quality]"

				else
					new /obj/items/DarknessPowder (t)

				bonusChance = 0
				applyBonus  = 0
				ignoreItem  = 0


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