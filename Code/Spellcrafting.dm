/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */


/*

6. construct name
7. add items that modify it

*/


#define PROJ 1
#define AREA 2
#define EXPLOSION 4

mob/Player/var/tmp/obj/items/wearable/spellbook/usedSpellbook

obj/items/wearable/spellbook
	var
		cd      = 0
		damage  = 0
		flags   = 0
		element = 0
		mpCost  = 0

		tmp/lastUsed = 0

	icon       = 'Books.dmi'
	icon_state = "spell"

	rarity = 4
	showoverlay = FALSE

	Compare(obj/items/i)
		. = ..()
		return flags == 0 ? . : 0

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		if(!forceremove && !overridetext && !(src in owner.Lwearing) && world.time - owner.lastCombat <= 100)
			owner << errormsg("You can't equip this while in combat.")
			return
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] equips \his [src.name].")
			if(owner.usedSpellbook)
				owner.usedSpellbook.Equip(owner,1,1)
			owner.usedSpellbook = src

			if(flags != PROJ && owner.lastAttack == "Spellbook")
				owner.lastAttack = "Inflamari"

		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] unequips \his [src.name].")
			owner.usedSpellbook = null

	MouseEntered(location,control,params)
		if((src in usr) && usr:infoBubble)

			if(flags == 0)
				winset(usr, null, "infobubble.labelTitle.text=\"[name]\";infobubble.labelInfo.text=\"Blank spell book, what spells can you come up with?\"")
				winshowRight(usr, "infobubble")
			else
				var/t

				switch(flags)
					if(EXPLOSION)
						t = "Explosion"
					if(AREA)
						t = "Aura"
					if(PROJ)
						t = "Projectile"
				var/e

				if(damage < 0)
					e = "Healing"
				else
					switch(element)
						if(FIRE)
							e = "Fire"
						if(WATER)
							e = "Water"
						if(EARTH)
							e = "Earth"
						if(GHOST)
							e = "Ghost"
				var/info = "Type: [t]\nElement: [e]\nPower: [damage]\nMP: [mpCost]\nCooldown:[cd/10] seconds"

				winset(usr, null, "infobubble.labelTitle.text=\"[name]\";infobubble.labelInfo.text=\"[info]\"")
				winshowRight(usr, "infobubble")


	verb/Cast()
		if(usr:usedSpellbook == src)
			cast(usr)
		else
			usr << errormsg("You have to equip this to cast.")

	proc/cast(mob/Player/p, mob/attacker)
		set waitfor = 0
		if(world.time - lastUsed <= cd)
			if(cd > 10)
				var/timeleft = ceil((lastUsed+cd - world.time)/10)
				p << "<b>This can't be used for another [timeleft] second[timeleft==1 ? "" : "s"].</b>"
			return

		if(!canUse(p,needwand=1,inarena=0,insafezone=0,inhogwarts=1,mpreq=mpCost,projectile=1))
			return

		p.MP-=mpCost
		p.updateMP()

		lastUsed = world.time

		var/dmg = damage

		var/state
		if(damage < 0)
			state = "heal"
		else
			dmg += p.Dmg
			switch(element)
				if(FIRE)
					state = "fireball"
					dmg += p.Fire.level
				if(WATER)
					state = "aqua"
					dmg += p.Water.level
				if(EARTH)
					state = "quake"
					dmg += p.Earth.level
				if(GHOST)
					state = "gum"
					dmg += p.Ghost.level

		if(flags & EXPLOSION)
			for(var/d in DIRS_LIST)
				p.castproj(icon_state = state, damage = dmg*0.75, name = name, cd = 0, lag = 1, element = element, Dir=d)
		else if(flags & PROJ)
			p.castproj(icon_state = state, damage = dmg, name = name, cd = cd, element = element)
			p.lastAttack = "Spellbook"
		else
			var/mutable_appearance/ma = new

			ma.icon = 'attacks.dmi'
			ma.icon_state = state

			var/list/images = list()

			for(var/d in list(0, 90, 180, 270))
				var/matrix/m = matrix()
				m.Translate(24, 0)
				ma.transform = turn(m, d)

				images += ma.appearance

			var/obj/o = new
			o.overlays = images
			p.vis_contents += o

			var/matrix/m = matrix()
			m.Turn(90)
			animate(o, transform = m, time = 10, loop = -1)
			m.Turn(90)
			animate(transform = m, time = 10)
			m.Turn(90)
			animate(transform = m, time = 10)
			animate(transform = null, time = 10)

			for(var/i = 1 to 10)
				for(var/mob/Enemies/e in range(1, p))
					e.onDamage(dmg, p, element)

				sleep(10)

			p.vis_contents -= o

obj/items/spellpage
	icon       = 'Scroll.dmi'
	icon_state = "magic"

	var
		cd      = 0
		damage  = 0
		flags   = 0
		element = 0
		mpCost  = 0

		multi = 0

	Click()
		if(src in usr)
			var/mob/Player/p = usr
			if(!p.usedSpellbook)
				p << errormsg("You need to have a spell book equipped.")
				return

			if(element)
				if(p.usedSpellbook.element == element)
					p << errormsg("This spell book is already using this page.")
					return

				p.usedSpellbook.element = element

			else if(damage == -1)
				if(p.usedSpellbook.damage < 0)
					p << errormsg("This spell book is already using this page.")
					return

				p.usedSpellbook.damage *= -1

			if(flags > 0)

				if(p.usedSpellbook.flags & flags)

					p << errormsg("This spell book is already using this page.")
					return

				p.usedSpellbook.flags |= flags

			if(multi)
				p.usedSpellbook.cd *= cd
				p.usedSpellbook.mpCost *= mpCost
				if(damage != -1)
					p.usedSpellbook.damage *= damage
			else
				p.usedSpellbook.cd += cd
				p.usedSpellbook.mpCost += mpCost
				if(damage != -1)
					p.usedSpellbook.damage += damage

		else
			..()



obj
	lootdrop
		canSave = 0
		density = 1
		mouse_over_pointer = MOUSE_HAND_POINTER

		icon       = 'turf.dmi'
		icon_state = "barrels"

		var
			origZ
			teleportNode/origRegion

		New(Loc, region)
			set waitfor = 0
			..()
			sleep(1)

			if(region)
				origRegion = region
			else
				origZ = z

			if(prob(60))
				step_rand(src)

		proc
			respawn()
				set waitfor = 0
				loc = null

				density = 1
				transform = null

				sleep(900)

				animate(src, alpha = 255, time = 5)

				if(prob(10))
					icon_state = "chest"
		//		else if(prob(5))
		//			icon_state = "spellcrafting"
				else
					icon_state = "barrels"

				if(origRegion)
					loc = pick(origRegion.lootSpawns)

					if(prob(60))
						step_rand(src)
				else
					loc = locate(rand(10, 90), rand(10, 90), origZ)

					if(!loc)
						spawn() respawn()

			drop(mob/Player/p)
				animate(src, transform = matrix()*2, alpha = 0, time = 5)
				density = 0
				var/sparks = 0

				var/rate        = 2 + p.dropRate/100
				var/rate_factor = worldData.DropRateModifier

				if(p.House == worldData.housecupwinner)
					rate += 0.25

				if(icon_state == "chest")
					rate += 0.5 + (p.TreasureHunting.level)/100

					p.TreasureHunting.add((p.level + p.TreasureHunting.level + rand(10)) * 60, p, 1)
				else if(icon_state == "spellcrafting")
					rate += 2

					p.Spellcrafting.add((p.level + p.Spellcrafting.level + rand(10)) * 60, p, 1)

				if(p.guild) rate += p.getGuildAreas() * 0.05

				var/StatusEffect/Lamps/DropRate/d = p.findStatusEffect(/StatusEffect/Lamps/DropRate)
				if(d)
					rate_factor *= d.rate

				var/StatusEffect/Potions/Luck/l = p.findStatusEffect(/StatusEffect/Potions/Luck)
				if(l)
					rate_factor *= l.factor

				rate *= rate_factor

				var/base = worldData.baseChance * clamp(p.level/100, 0.1, 20)

				if(icon_state == "spellcrafting" && prob(base * rate * 3))
					var/prize = pickweight(list(/obj/items/wearable/title/Airbender   = 10,
					                            /obj/items/wearable/title/Waterbender   = 10,
					                            /obj/items/wearable/title/Firebender   = 10,
					                            /obj/items/wearable/title/Earthbender   = 10))

					var/obj/items/i = new prize (loc)

					i.prizeDrop(p.ckey)

					p << infomsg("<i>You found \a [i.name].</i>")

				else if(prob(base * rate * 10))
					if(prob(5))
						var/prize = pickweight(list(/obj/items/wearable/title/Wrecker     = 5,
						                            /obj/items/bucket                     = 10,
						                            /obj/items/treats/berry               = 20,
						                            /obj/items/treats/sweet_berry         = 20,
						                            /obj/items/treats/grape_berry         = 20,
						                            /obj/items/seeds/daisy_seeds          = 15,
						                            /obj/items/seeds/aconite_seeds        = 15,
						                            /obj/items/treats/stick               = 10,))

						var/obj/items/i = new prize (loc)

						i.prizeDrop(p.ckey)

						p << infomsg("<i>You found \a [i.name].</i>")
					else
						var/gold/g = new (bronze=rand(10, 600)+p.level)
						p << infomsg("<i>You found [g.toString()].</i>")
						g.give(p)

				else if(prob(base * rate * 3))
					sparks = 1
					var/obj/items/prize = pickweight(list(/obj/items/crystal/defense = 1,
												/obj/items/crystal/damage  = 1,
												/obj/items/crystal/luck    = 1))

					prize = new prize (loc, round(p.level/50))
					prize.prizeDrop(p.ckey, decay=1)
					p << infomsg("<i>You found [prize.name]</i>")
					if(p.pet)
						p.pet.fetch(prize)
				else if(prob(base * rate))
					sparks = 1
					var/obj/items/prize = pick(drops_list["legendary"])
					prize = new prize (loc)
					prize.prizeDrop(p.ckey, decay=1)
					p << colormsg("<i>You found [prize.name]</i>", "#FFA500")
					p.pity = 0

				if(sparks)
					emit(loc    = loc,
					 	 ptype  = /obj/particle/star,
					 	 amount = 3,
					 	 angle  = new /Random(0, 360),
					 	 speed  = 5,
					 	 life   = new /Random(4,8))

				sleep(6)
				respawn()

		Click()
			drop(usr)

		Attacked(obj/projectile/p)
			if(icon_state == "barrels" && isplayer(p.owner))
				drop(p.owner)



obj/static_obj/walltorch
	MapInit()
		set waitfor = 0
		sleep(1)
		if(post_init && loc.density)
			var/area/a = loc.loc
			if(a.region)
				if((!a.region.lootSpawns || a.region.lootSpawns.len < 10) && prob(40))
					var/turf/t = locate(x, y-2, z)
					if(t && !t.density)
						if(!a.region.lootSpawns)
							a.region.lootSpawns = list()
						a.region.lootSpawns += t

		..()

teleportNode
	var
		list/lootSpawns


obj/manualLootSpawn
	post_init = 1
	MapInit()
		set waitfor = 0
		sleep(1)

		var/area/a = loc.loc
		if(a.region)
			if(!a.region.lootSpawns)
				a.region.lootSpawns = list()
			a.region.lootSpawns += loc

		loc = null

proc/InitLootDrop()
	set waitfor = 0
	sleep(10)
	for(var/i in worldData.TeleportMap.teleports)
		var/teleportNode/n = worldData.TeleportMap.teleports[i]
		if(n.lootSpawns)
			var/r = rand(1, n.lootSpawns.len)
			new /obj/lootdrop (n.lootSpawns[r])
			var/end = n.lootSpawns.len - r
			if(end == r) end = rand(1, n.lootSpawns.len)
			end = clamp(end, 1, n.lootSpawns.len)
			new /obj/lootdrop (n.lootSpawns[end], n)

			lagstopsleep()
