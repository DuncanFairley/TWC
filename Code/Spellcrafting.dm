/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

#define PROJ 1
#define ARUA 2
#define EXPLOSION 4
#define SUMMON 8


#define PAGE_DAMAGETAKEN 64

#define PAGE_DMG1 4096

mob/Player/var/tmp/obj/items/wearable/spellbook/usedSpellbook

obj/items/wearable/spellbook
	var
		cd        = 1
		damage    = 1
		spellType = 0
		flags     = 0
		element   = 0
		mpCost    = 1

		tmp/lastUsed = 0

	icon       = 'Books.dmi'
	icon_state = "spell"

	rarity = 4
	showoverlay = FALSE

	name = "spellbook \[Incomplete]"

	Compare(obj/items/i)
		. = ..()

		return (flags == 0 && element == 0 && spellType == 0) ? . : 0

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

			if(spellType != PROJ && owner.lastAttack == "Spellbook")
				owner.lastAttack = "Inflamari"

		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] unequips \his [src.name].")
			owner.usedSpellbook = null

	MouseEntered(location,control,params)
		if((src in usr) && usr:infoBubble)

			if(spellType == 0)
				winset(usr, null, "infobubble.labelTitle.text=\"[name]\";infobubble.labelInfo.text=\"Blank spell book, what spells can you come up with?\"")
				winshowRight(usr, "infobubble")
			else
				var/t

				switch(spellType)
					if(EXPLOSION)
						t = "Explosion"
					if(ARUA)
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
				var/info = "Type: [t]\nElement: [e]\nPower: [damage*100]%\nMP: [mpCost]\nCooldown:[cd/10] seconds"

				winset(usr, null, "infobubble.labelTitle.text=\"[name]\";infobubble.labelInfo.text=\"[info]\"")
				winshowRight(usr, "infobubble")


	verb/Cast()
		if(usr:usedSpellbook == src)
			cast(usr)
		else
			usr << errormsg("You have to equip this to cast.")

	proc/fixName()

		var/e
		switch(element)
			if(FIRE)
				e = "Fire"
			if(WATER)
				e = "Water"
			if(EARTH)
				e = "Earth"
			if(GHOST)
				e = "Ghost"
			if(HEAL)
				e = "Healing"
		var/t

		switch(spellType)
			if(EXPLOSION)
				t = "Explosion"
			if(ARUA)
				t = "Aura"
			if(PROJ)
				t = "Projectile"
			if(SUMMON)
				t = "Summon"

		if(t == null || e == null)
			name = "spellbook \[Incomplete]"

		else
			name = "[e] [t]"

			if(flags & PAGE_DMG1)
				name = "Strong [name]"

			if(flags & PAGE_DAMAGETAKEN)
				name = "Defensive [name]"

	proc/cast(mob/Player/p, mob/attacker)
		set waitfor = 0

		if(element == 0 || spellType == 0)
			p << errormsg("This spell book is incomplete.")
			return

		if((flags & PAGE_DAMAGETAKEN) && !attacker)
			p << errormsg("You can't directly cast this spell, you have to be attacked.")
			return

		if(world.time - lastUsed <= cd*p.cooldownModifier)
			if(cd > 10 && !attacker)
				var/timeleft = ceil((lastUsed+cd - world.time)/10)
				p << "<b>This can't be used for another [timeleft] second[timeleft==1 ? "" : "s"].</b>"
			return

		if(spellType == SUMMON && p.Summons && p.Summons.len >= 1 + round(p.Summoning.level / 10))
			if(!(flags & PAGE_DAMAGETAKEN))
				p << errormsg("You need higher summoning level to summon more.")
			return

		if(!canUse(p,needwand=1,inarena=0,insafezone=0,inhogwarts=1,mpreq=mpCost,projectile=1))
			return

		p.MP-=mpCost
		p.updateMP()

		lastUsed = world.time

		var/dmg = p.Dmg * damage

		var/state
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
			if(HEAL)
				state = "healing"

		if(spellType == EXPLOSION)
			for(var/d in DIRS_LIST)
				p.castproj(icon_state = state, damage = dmg*0.75, name = name, cd = 0, lag = 1, element = element, Dir=d)
		else if(spellType == PROJ)
			p.castproj(icon_state = state, damage = dmg, name = name, cd = cd, element = element, Dir = attacker ? get_dir(p, attacker) : p.dir)
			if(!attacker) p.lastAttack = "Spellbook"
		else if(spellType == SUMMON)

			var/obj/summon/s
			var/command = (flags & PAGE_DAMAGETAKEN) ? null : "Spellbook"
			switch(element)
				if(FIRE)
					s = new /obj/summon/fire (loc, p, command, 1)
				if(WATER)
					s = new /obj/summon/water (loc, p, command, 1)
				if(EARTH)
					s = new /obj/summon/earth (loc, p, command, 1)
				if(GHOST)
					s = new /obj/summon/ghost (loc, p, command, 1)
		//		if(HEAL)

			s.scale = damage

		else
			if(element == HEAL)
				p.HP = min(p.MHP, p.HP + dmg)
				p.updateHP()
				p.overlays+=image('attacks.dmi', icon_state = "heal")
				sleep(10)
				p.overlays-=image('attacks.dmi', icon_state = "heal")
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
		cd      = 1
		damage  = 1
		spellType = 0
		flags   = 0
		element = 0
		mpCost  = 1

	Click()
		if(src in usr)
			var/mob/Player/p = usr
			if(!p.usedSpellbook)
				p << errormsg("You need to have a spell book equipped.")
				return

			if(spellType)
				p.usedSpellbook.spellType = spellType

				p.usedSpellbook.flags = 0
				p.usedSpellbook.cd = cd
				p.usedSpellbook.mpCost = mpCost
				p.usedSpellbook.damage = damage
			else
				if(element)
					if(p.usedSpellbook.element == element)
						p << errormsg("This spell book is already using this page.")
						return

					p.usedSpellbook.element = element

				if(flags > 0)

					if(p.usedSpellbook.flags & flags)

						p << errormsg("This spell book is already using this page.")
						return

					p.usedSpellbook.flags |= flags

				p.usedSpellbook.cd *= cd
				p.usedSpellbook.mpCost *= mpCost
				p.usedSpellbook.damage *= damage

			p.usedSpellbook.fixName()

			Consume()

		else
			..()

	proj
		name = "Spell Page: \[Projectile]"
		spellType = PROJ
		cd = 2
		mpCost = 10
		damage = 1.1
	explosion
		name = "Spell Page: \[Explosion]"
		spellType = EXPLOSION
		cd = 100
		mpCost = 450
	aura
		name = "Spell Page: \[Aura]"
		spellType = ARUA
		cd = 150
		mpCost = 300
	summon
		name = "Spell Page: \[Summon]"
		spellType = SUMMON
		cd = 100
		mpCost = 100
	fire
		name = "Spell Page: \[Fire]"
		element = FIRE
	water
		name = "Spell Page: \[Water]"
		element = WATER
	ghost
		name = "Spell Page: \[Ghost]"
		element = GHOST
	earth
		name = "Spell Page: \[Earth]"
		element = EARTH
	heal
		name = "Spell Page: \[Heal]"
		element = HEAL
	damagetaken
		name = "Spell Page: \[Cast On Damage Taken]"
		flags = PAGE_DAMAGETAKEN
	damage1
		name = "Spell Page: \[Strong]"
		flags = PAGE_DMG1
		damage = 2
		cd = 1.5

obj
	lootdrop
		canSave = 0
		density = 1
		mouse_over_pointer = MOUSE_HAND_POINTER

		icon       = 'turf.dmi'
		icon_state = "barrels"
		name = "Barrels"

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

				sleep(500)

				animate(src, alpha = 255, time = 5)

				if(prob(20))
					icon_state = "chest"
					name = "Chest"
				else if(prob(15))
					icon_state = "spellcrafting"
					name = "Magic Chest"
				else
					icon_state = "barrels"
					name = "Barrels"

				if(origRegion)
					loc = pick(origRegion.lootSpawns)

					if(prob(60))
						step_rand(src)
				else
					loc = locate(rand(10, 90), rand(10, 90), origZ)

					if(!loc)
						spawn() respawn()

			drop(mob/Player/p)
				if(density == 0) return
				animate(src, transform = matrix()*2, alpha = 0, time = 5)
				density = 0
				var/sparks = 0

				var/rate        = 3 + p.dropRate/100
				var/rate_factor = worldData.DropRateModifier

				if(p.House == worldData.housecupwinner)
					rate += 0.25

				if(icon_state == "chest")
					rate += 1 + (p.TreasureHunting.level*2)/100

					p.TreasureHunting.add((p.level + p.TreasureHunting.level + rand(10)) * 50, p, 1)
				else if(icon_state == "spellcrafting")
					rate += 1 + (p.Spellcrafting.level*2)/100

					p.Spellcrafting.add((p.level + p.Spellcrafting.level + rand(10)) * 50, p, 1)

				if(p.guild) rate += p.getGuildAreas() * 0.05

				var/StatusEffect/Lamps/DropRate/d = p.findStatusEffect(/StatusEffect/Lamps/DropRate)
				if(d)
					rate_factor *= d.rate

				var/StatusEffect/Potions/Luck/l = p.findStatusEffect(/StatusEffect/Potions/Luck)
				if(l)
					rate_factor *= l.factor

				rate *= rate_factor

				var/base = worldData.baseChance * clamp(p.level/100, 0.2, 20)

				if(icon_state == "spellcrafting" && prob(base * rate * 30))
					var/prize = pick(/obj/items/wearable/title/Airbender,
					                 /obj/items/wearable/title/Waterbender,
					                 /obj/items/wearable/title/Firebender,
					                 /obj/items/wearable/title/Earthbender,
					                 /obj/items/spellpage/proj,
									 /obj/items/spellpage/explosion,
									 /obj/items/spellpage/aura,
									 /obj/items/spellpage/fire,
									 /obj/items/spellpage/water,
									 /obj/items/spellpage/ghost,
									 /obj/items/spellpage/earth,
									 /obj/items/spellpage/heal,
									 /obj/items/spellpage/damagetaken,
									 /obj/items/spellpage/damage1,
									 /obj/items/wearable/spellbook)

					var/obj/items/i = new prize (loc)

					i.prizeDrop(p.ckey)

					p << infomsg("<i>You found \a [i.name].</i>")

				else if(icon_state == "chest" && prob(base * rate * 40))
					if(prob(20))
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

				else if(prob(base * rate * 10))
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
			if(src in range(3))
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
			new /obj/lootdrop (n.lootSpawns[r], n)

			var/end = n.lootSpawns.len - r
			if(end == r) end = rand(1, n.lootSpawns.len)
			end = clamp(end, 1, n.lootSpawns.len)
			new /obj/lootdrop (n.lootSpawns[end], n)

			lagstopsleep()
