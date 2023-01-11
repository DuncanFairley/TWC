
enchanting

	scroll
		reqType = /obj/items/scroll
		chance  = 45
		prize   = list(/obj/items/wearable/title/Bookworm,
		               /obj/items/wearable/title/Lumberjack,
		               /obj/items/riddle_scroll)

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

	memory_teleport
		reqType = /obj/items/magic_stone/memory
		bonus   = 3
		chance  = 40
		souls   = 2
		prize   = /obj/items/magic_stone/teleport/memory

	resurrection
		reqType = /obj/items/magic_stone/summoning/resurrection
		chance  = 40
		prize   = /obj/items/wearable/resurrection_stone

	chest
		reqType = /obj/items/chest
		bonus   = 3
		chance  = 50
		prize   = list(/obj/items/chest/basic_chest            = 15,
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
		prize   = list(/obj/items/key/basic_key            = 15,
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

	magic_orb
		reqType = /obj/items/wearable/orb/magic
		bonus   = 3
		chance  = 60
		prize   = /obj/items/wearable/orb/magic/greater

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
			max_upgrade = 10

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
					attacker.Alchemy.add(rand(9,12)*200, attacker, 1)

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
					else if(istype(i3, /obj/items/wearable/orb))
						var/perc = ((i3:exp + i4:exp) / 2) / initial(i3:exp)
						perc *= o:exp
						o:exp = min(round(perc), o:exp)
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

		Dmg = 0
		Def = 0
		monsterDmg = 0
		monsterDef = 0
		MP = 0
		power = 0

	useTypeStack = 1
	stackName = "Crystals:"
	rarity = 2

	desc = "Drag and drop to item with a empty socket."

	proc/ToString()

		var/list/lines = list()

		if(Dmg) lines += "+[Dmg] Damage"
		if(Def) lines += "+[Def] Defense"
		if(luck) lines += "+[luck]% Drop Rate"
		if(monsterDmg) lines += "+[monsterDmg]% Damage"
		if(monsterDef) lines += "+[monsterDef]% Defense"
		if(MP) lines += "+[MP] MP"
		if(power) lines += "+[power] Legendary Effect"

		return jointext(lines, "\n")

	Clone()
		var/obj/items/crystal/i = new type

		i.owner      = owner
		i.name       = name
		i.icon_state = icon_state
		i.ignoreItem = ignoreItem
		i.luck       = luck
		i.Dmg        = Dmg
		i.Def        = Def
		i.monsterDmg = monsterDmg
		i.monsterDef = monsterDef

		return i

	Compare(obj/items/crystal/i)
		return i.name == name && i.type == type && i.owner == owner && i.icon_state == icon_state && i.ignoreItem == ignoreItem && i.luck == luck && i.Dmg == Dmg && i.Def == Def && i.monsterDmg == monsterDmg && i.monsterDef == monsterDef

	New(Loc, tier)
		..(Loc)

		if(tier)
			tier = clamp(tier, 1, 20)

			if(prob(10))
				tier += rand(0, 5)

			name = "[name]: level [tier]"

			if(Dmg)
				Dmg = tier
			if(Def)
				Def = tier*3
			if(luck)
				luck = tier
			if(monsterDmg)
				monsterDmg = tier
			if(monsterDef)
				monsterDef = tier * 0.2

	MouseDrop(over_object)

		if(istype(over_object, /backpack))
			var/backpack/b = over_object
			if(b.item)
				over_object = b.item

		if(desc != null && istype(over_object, /obj/items/wearable) && (src in usr) && (over_object in usr) && over_object:socket != null)
			var/obj/items/wearable/w = over_object
			var/mob/Player/p = usr
			var/obj/items/crystal/s = stack > 1 ? Split(1) : src

			var/worn = 0
			if(w in p.Lwearing)
				worn = 1
				w.Equip(p, 1)

			var/addBack = 0
			if(w.stack > 1)
				addBack = 1
				w = w.Split(1)

			w.socket = s
			if(addBack)
				w.Move(p)
			if(worn)
				w.Equip(p, 1)

			if(s == src)
				Dispose()
			usr << infomsg("You insert [name] in [w.name]")
		else
			..()

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
		Dmg = 10
	defense
		name  = "green crystal"
		icon_state = "defense"
		bonus = 2
		Def = 30
	damage_monster
		name  = "red monster crystal"
		icon_state = "damage"
		bonus = 1
		monsterDmg = 1
	defense_monster
		name  = "green monster crystal"
		icon_state = "defense"
		bonus = 2
		monsterDef = 1
	magic
		name  = "magic crystal"
		icon_state = "magic"
		bonus = 3
		Dmg = 10
		Def = 30
		MP = 240
	luck
		name  = "luck crystal"
		icon_state = "luck"
		luck  = 5
	strong_luck
		name  = "strong luck crystal"
		icon_state = "luck2"
		luck  = 20
	soul
		name = "soul crystal"
		icon_state = "soul"
		ignoreItem = TRUE
		rarity = 3
		power = 5


obj/blacksmith
	icon               = 'Anvil.dmi'

	mouse_over_pointer = MOUSE_HAND_POINTER
	mouse_opacity      = 2
	layer              = 4
	density            = 1

	proc/smith(obj/item/i, mob/Player/p)

	proc/checkPrice(mob/Player/p, price)

	Click()

		if(src in oview(3))

			var/mob/Player/p = usr
			p.dir = get_dir(p, src)

			var/obj/items/wearable/i = locate() in locate(x, y-1, z)

			if(i)
				smith(i, p)
			else
				p << errormsg(desc)


	extract
		desc = "Place an item to extract (5 artifacts per extracted item)"

		smith(obj/items/wearable/i, mob/Player/p)
			var/slots = 0

			if(istype(i.socket, /obj/items/))
				slots = 1
			else if(istype(i, /obj/items/wearable/spellbook))
				var/obj/items/wearable/spellbook/s = i

				if(s.spellType) slots++
				if(s.element) slots++

				slots += countBits(s.flags)

			if(!slots)
				p << errormsg("Nothing to extract.")
				return

			if(checkPrice(p, slots * 5, 1))

				p << infomsg("You extracted everything from [i.name] for [slots * 5] artifacts.")

				if(istype(i.socket, /obj/items/))
					i.socket.loc = i.loc
					i.socket.owner = i.owner
					i.socket = initial(i.socket)

				else if(istype(i, /obj/items/wearable/spellbook))

					var/obj/items/wearable/spellbook/s = i

					var/list/pages = list()

					if(s.spellType == PROJ)           pages += /obj/items/spellpage/proj
					else if(s.spellType == ARUA)      pages += /obj/items/spellpage/aura
					else if(s.spellType == EXPLOSION) pages += /obj/items/spellpage/explosion
					else if(s.spellType == SUMMON)    pages += /obj/items/spellpage/summon
					else if(s.spellType == METEOR)    pages += /obj/items/spellpage/meteor
					else if(s.spellType == ARC)       pages += /obj/items/spellpage/arc

					if(s.element == GHOST)      pages += /obj/items/spellpage/ghost
					else if(s.element == EARTH) pages += /obj/items/spellpage/earth
					else if(s.element == WATER) pages += /obj/items/spellpage/water
					else if(s.element == FIRE)  pages += /obj/items/spellpage/fire
					else if(s.element == COW)   pages += /obj/items/spellpage/cow

					if(s.flags & PAGE_DAMAGETAKEN) pages += /obj/items/spellpage/damagetaken
					if(s.flags & PAGE_DMG1)        pages += /obj/items/spellpage/damage1
					if(s.flags & PAGE_DMG2)        pages += /obj/items/spellpage/damage2
					if(s.flags & PAGE_CD)          pages += /obj/items/spellpage/cd
					if(s.flags & PAGE_RANGE)       pages += /obj/items/spellpage/range

					s.name      = initial(s.name)
					s.cd        = initial(s.cd)
					s.damage    = initial(s.damage)
					s.range     = initial(s.range)
					s.spellType = initial(s.spellType)
					s.flags     = initial(s.flags)
					s.element   = initial(s.element)
					s.mpCost    = initial(s.mpCost)

					for(var/t in pages)
						var/obj/items/recovered = new t (i.loc)
						recovered.owner = i.owner

		checkPrice(mob/Player/p, price, consume=0)
			. = 1
			var/obj/items/artifact/a = locate() in p

			if(!a || a.stack < price)
				p << errormsg("You need [price] artifacts to extract. You have [a ? a.stack : "0"].")
				. = 0

			if(. && consume)
				a.Consume(price)

	stat_randomizer

		desc = "Place an item (cursed items) you wish to randomize stats of in the red square. (5 artifacts)"

		smith(obj/items/wearable/i, mob/Player/p)
			if(!i.effects)
				p << errormsg("[i.name] has no stats that can be randomized.")
				return


			if(checkPrice(p, 5, 1))

				if(findtext(i.name, "cursed "))
					i.name = initial(i.name)
					i.scale = initial(i.scale)
					i.Upgrade(5 + rand(0, 5))

				p << infomsg("New stats of [i.name]:\n+[i.power] Legendary Effect")

				for(var/e in i.effects)
					p << infomsg("+[i.effects[e]] [getStatName(e)]")

				emit(loc    = src,
					 ptype  = /obj/particle/magic,
				     amount = 50,
				     angle  = new /Random(1, 359),
				     speed  = 2,
				     life   = new /Random(15,25))

		checkPrice(mob/Player/p, price, consume=0)
			. = 1
			var/obj/items/artifact/a = locate() in p

			if(!a || a.stack < price)
				p << errormsg("You need [price] artifacts to randomize. You have [a ? a.stack : "0"].")
				. = 0

			if(. && consume)
				a.Consume(price)

	upgrade

		desc = "Place an item you wish to upgrade in the red square."

		var/max_upgrade = 15

		smith(obj/items/wearable/i, mob/Player/p)
			if(i.bonus == -1 || i.quality >= max_upgrade || (i.bonus & 4))
				p << errormsg("[i.name] can not be upgraded.")
			else
				var/priceFactor

				if(i.quality >= 5)
					priceFactor = 2
				else if(i.quality >= 10)
					priceFactor = 3
				else
					priceFactor = 1

				var/price = i.quality*priceFactor + 2 + priceFactor

				var/chanceFactor
				if(findtext(i.name, "cursed "))
					chanceFactor = 5
				else
					chanceFactor = 4

				var/ScreenText/s = new(p, src)
				var/chanceToFail = i.quality >= 5 ? (i.quality+1)*chanceFactor + chanceFactor*3 : 0

				var/msg = "Do you wish to attempt upgrading [i.name]?\nSuccess chance [100 - chanceToFail]%\nCost: [price] embers of frost and despair"
				if(i.quality >= 10)
					msg = "Item will downgrade a level on failure!\n"

				if(checkPrice(p, price))
					s.SetButtons(0, 0, "No", "#ff0000", "Yes", "#00ff00")

				s.AddText(msg)

				if(!s.Wait()) return

				if(s.Result != "Yes") return

				if(!checkPrice(p, price, 1)) return

				if(i.quality >= 5 && prob(chanceToFail))
					p << infomsg("Failure! You could not upgrade [i.name]. ([100 - chanceToFail]%)")

					if(i.quality >= 10)
						i.quality--
						i.name = "[splittext(i.name, " +")[1]] +[i.quality]"
						i.UpdateDisplay()

						p << errormsg("Your item downgraded to [i.name].")
					return

				i.bonus |= 3
				i.quality++
				i.name = "[splittext(i.name, " +")[1]] +[i.quality]"
				i.UpdateDisplay()

				p << infomsg("Success! You crafted [i.name].")

				emit(loc    = src,
					 ptype  = /obj/particle/magic,
				     amount = 50,
				     angle  = new /Random(1, 359),
				     speed  = 2,
				     life   = new /Random(15,25))


		checkPrice(mob/Player/p, price, consume=0)
			. = 1
			var/obj/items/ember_of_despair/despair = locate() in p
			var/obj/items/ember_of_frost/frost = locate() in p

			if(!despair || despair.stack < price)
				p << errormsg("You need [price] embers of despair to upgrade. You have [despair ? despair.stack : "0"].")
				. = 0

			if(!frost || frost.stack < price)
				p << errormsg("You need [price] embers of frost to upgrade. You have [frost ? frost.stack : "0"].")
				. = 0

			if(. && consume)
				despair.Consume(price)
				frost.Consume(price)

