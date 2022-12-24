#define PROJ 1
#define ARUA 2
#define EXPLOSION 4
#define SUMMON 8
#define METEOR 16


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
		if(!forceremove && !overridetext && !(src in owner.Lwearing) && world.time - owner.lastCombat <= COMBAT_TIME)
			owner << errormsg("You can't equip this while in combat.")
			return
		if(!forceremove && !(src in owner.Lwearing) && owner.loc && owner.loc.loc && owner.loc.loc:antiSpellbook)
			owner << errormsg("You can not use it here.")
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
			if(COW)
				e = "Moo"
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
			if(METEOR)
				t = "Meteor"

		if(t == null && e == null)
			name = "spellbook \[Incomplete]"
		else if	(t == null)
			name = "spellbook \[Incomplete - [e]]"
		else if	(e == null)
			name = "spellbook \[Incomplete - [t]]"
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

		if(world.time - lastUsed <= cd*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier)
			if(cd > 10 && !attacker)
				var/timeleft = ceil((lastUsed+cd*(p.cooldownModifier+p.extraCDR)*worldData.cdrModifier - world.time)/10)
				p << "<b>This can't be used for another [timeleft] second[timeleft==1 ? "" : "s"].</b>"
			return

		if(spellType == SUMMON && p.summons >= 1 + p.extraLimit + round(p.Summoning.level / 10))
			if(!(flags & PAGE_DAMAGETAKEN))
				p << errormsg("You need higher summoning level to summon more.")
			return

		if(!canUse(p,needwand=1,inarena=0,insafezone=0,inhogwarts=1,mpreq=mpCost,projectile=1,silent=(flags & PAGE_DAMAGETAKEN)))
			return

		p.MP-=mpCost
		p.updateMP()

		lastUsed = world.time

		var/dmg = (p.Dmg + p.clothDmg) * damage

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
			if(COW)
				state = "cow"

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
					s = new /obj/summon/fire (p.loc, p, command, 0.5)
				if(WATER)
					s = new /obj/summon/water (p.loc, p, command, 0.5)
				if(EARTH)
					s = new /obj/summon/earth (p.loc, p, command, 0.5)
				if(GHOST)
					s = new /obj/summon/ghost (p.loc, p, command, 0.5)
				if(HEAL)
					s = new /obj/summon/heal (p.loc, p, command, 0.5)
				if(COW)
					s = new /obj/summon/cow (p.loc, p, command, 0.5)

			s.scale = damage
		else if(spellType == METEOR)
			new /obj/projectile/Meteor (attacker ? attacker.loc : p.loc, p, dmg, state, name, element)
		else
			if(element == HEAL)

				var/d = dmg
				if(world.time - p.lastCombat <= COMBAT_TIME)
					d *= 0.5

				p.HP = min(p.MHP, p.HP + d)
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

				for(var/i = 1 to 20)
					for(var/mob/Enemies/e in range(1, p))
						e.onDamage(dmg, p, element)

					sleep(5)

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

				else
					if(!p.usedSpellbook.spellType)
						p << errormsg("This spell book needs a spell type first.")
						return

				if(flags > 0)

					if(p.usedSpellbook.flags & flags)

						p << errormsg("This spell book is already using this page.")
						return

					p.usedSpellbook.flags |= flags

				p.usedSpellbook.cd *= cd
				p.usedSpellbook.mpCost *= mpCost
				p.usedSpellbook.damage *= damage

			p.usedSpellbook.fixName()
			if(p.usedSpellbook.stack > 1)
				var/obj/items/wearable/spellbook/book = new
				book.stack = p.usedSpellbook.stack - 1
				book.UpdateDisplay()
				book.Move(p)
				p.usedSpellbook.stack = 1
				p.usedSpellbook.UpdateDisplay()
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
		mpCost = 400
	meteor
		name = "Spell Page: \[Meteor]"
		spellType = METEOR
		damage = 4
		cd = 100
		mpCost = 250
	aura
		name = "Spell Page: \[Aura]"
		spellType = ARUA
		damage = 2
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
	cow
		name = "Spell Page: \[Cow]"
		element = COW
	damagetaken
		name = "Spell Page: \[Cast On Damage Taken]"
		flags = PAGE_DAMAGETAKEN
	damage1
		name = "Spell Page: \[Strong]"
		flags = PAGE_DMG1
		damage = 2
		cd = 1.5

obj
	cookiedrop
		canSave = 0
		density = 1
		mouse_over_pointer = MOUSE_HAND_POINTER

		icon       = 'Food.dmi'
		icon_state = "Pizza"
		name = "Santa's cookie"

		accioable = 1
		wlable = 1

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

			if(prob(65))
				step(src, SOUTH)
				for(var/i = 1 to rand(2,4))
					if(!step(src, pick(SOUTH,SOUTHEAST,SOUTHWEST,EAST,WEST)))
						step_rand(src)
						break

		proc
			respawn()
				set waitfor = 0
				loc = null

				density = 1
				transform = null

				sleep(500)

				animate(src, alpha = 255, time = 5)

				if(origRegion)
					loc = pick(origRegion.lootSpawns)

					if(prob(65))
						step(src, SOUTH)
						for(var/i = 1 to rand(2,4))
							if(!step(src, pick(SOUTH,SOUTHEAST,SOUTHWEST,EAST,WEST)))
								step_rand(src)
								break

				else
					loc = locate(rand(10, 90), rand(10, 90), origZ)

					if(!loc)
						spawn() respawn()

			drop(mob/Player/p)
				if(density == 0) return
				animate(src, transform = matrix()*2, alpha = 0, time = 5)
				density = 0
				var/sparks = 1

				if(sparks)

					p << infomsg("Yummy a cookie!")

					if(!(locate(/RandomEvent/Wizard) in worldData.currentEvents) && prob(3))


						var/turf/t = locate("@Hogwarts")
						if(!t.findStatusEffect(/StatusEffect/SantaSpawned))

							var/RandomEvent/e = locate(/RandomEvent/Wizard) in worldData.events
							e.start()

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
				usr.dir = get_dir(usr, src)
				drop(usr)

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

			if(prob(65))
				step(src, SOUTH)
				for(var/i = 1 to rand(2,4))
					if(!step(src, pick(SOUTH,SOUTHEAST,SOUTHWEST,EAST,WEST)))
						step_rand(src)
						break

		proc
			respawn()
				set waitfor = 0
				loc = null

				density = 1
				transform = null

				sleep(500)

				animate(src, alpha = 255, time = 5)

				if(prob(20))
					icon_state = pick("chest", "chest2")
					name = "Chest"
				else if(prob(15))
					icon_state = "spellcrafting"
					name = "Magic Chest"
				else if(prob(20))
					icon_state = "gift"
					name = "gift"
				else
					icon_state = "barrels"
					name = "Barrels"

				if(origRegion)
					loc = pick(origRegion.lootSpawns)

					if(prob(65))
						step(src, SOUTH)
						for(var/i = 1 to rand(2,4))
							if(!step(src, pick(SOUTH,SOUTHEAST,SOUTHWEST,EAST,WEST)))
								step_rand(src)
								break

				else
					loc = locate(rand(10, 90), rand(10, 90), origZ)

					if(!loc)
						spawn() respawn()

			drop(mob/Player/p)
				if(density == 0) return
				animate(src, transform = matrix()*2, alpha = 0, time = 5)
				density = 0
				var/sparks = 0

				var/rate        = 4 + p.dropRate/100
				var/rate_factor = worldData.DropRateModifier

				if(p.House == worldData.housecupwinner)
					rate += 0.5

				var/isChest = icon_state == "chest" || icon_state == "chest2" || icon_state == "gift"

				if(isChest)
					rate += 4 + (p.TreasureHunting.level*4)/100

					p.TreasureHunting.add((p.level + p.TreasureHunting.level + rand(12)) * 50, p, 1)
				else if(icon_state == "spellcrafting")
					rate += 4 + (p.Spellcrafting.level*4)/100

					p.Spellcrafting.add((p.level + p.Spellcrafting.level + rand(12)) * 50, p, 1)

				if(p.guild) rate += p.getGuildAreas() * 0.1

				var/StatusEffect/Lamps/DropRate/d = p.findStatusEffect(/StatusEffect/Lamps/DropRate)
				if(d)
					rate_factor *= d.rate

				var/StatusEffect/Potions/Luck/l = p.findStatusEffect(/StatusEffect/Potions/Luck)
				if(l)
					rate_factor *= l.factor

				rate *= rate_factor

				var/base = worldData.baseChance * clamp(p.level/100, 0.2, 20)

				if(icon_state == "spellcrafting" && prob(base * rate * 20))
					var/prize = pick(/obj/items/wearable/title/Airbender,
					                 /obj/items/wearable/title/Waterbender,
					                 /obj/items/wearable/title/Firebender,
					                 /obj/items/wearable/title/Earthbender,
					                 /obj/items/spellpage/proj,
									 /obj/items/spellpage/explosion,
									 /obj/items/spellpage/aura,
									 /obj/items/spellpage/summon,
									 /obj/items/spellpage/meteor,
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

				else if(isChest && prob(base * rate * 30))
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

					prize = new prize (loc, round(p.level/50) + rand(1,4))
					prize.prizeDrop(p.ckey, decay=1)
					p << infomsg("<i>You found [prize.name]</i>")
					if(p.pet)
						p.pet.fetch(prize)

				if(prob(base * rate))
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
				usr.dir = get_dir(usr, src)
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
				if((!a.region.lootSpawns || a.region.lootSpawns.len <= 12) && prob(40))
					var/turf/t = locate(x, y-2, z)
					if(t && !t.density)
						if(!a.region.lootSpawns)
							a.region.lootSpawns = list()
						a.region.lootSpawns += t

				if((!a.region.cookieSpawns || a.region.cookieSpawns.len < 5) && prob(40))
					var/turf/t = locate(x, y-2, z)
					if(t && !t.density)
						if(!a.region.cookieSpawns)
							a.region.cookieSpawns = list()
						a.region.cookieSpawns += t


		..()

teleportNode
	var
		list/lootSpawns
		list/cookieSpawns

mob/test/verb/Show_ROR()
	set category="Debug"
	set popup_menu = 0
	usr.client.eye=locate(/obj/teleport/rorEntrance)
	usr.client.perspective=EYE_PERSPECTIVE

obj/teleport/rorEntrance
	post_init = 1
	invisibility = 0
	icon = 'wall1.dmi'
	icon_state = "missing"

	dest = "rorEntrance"

	MapInit()
		set waitfor = 0
		sleep(10)

		animate(src, alpha = 180, time = 8, loop = -1)
		animate(alpha = 0, time = 8)
		animate(alpha = 0, time = 50)

		rotate()

	proc/rotate()
		set waitfor = 0

		var/area/a = loc.loc

		if(!a.region || !a.region.lootSpawns)
			var/turf/t = locate("@Hogwarts")
			a = t.loc

		var/teleportNode/newRegion
		if(prob(55))
			var/timeout = 5
			newRegion = pick(a.region.nodes)
			while(timeout-- > 0 && (!newRegion.lootSpawns || !istype(newRegion.areas[1], /area/hogwarts)))
				newRegion = pick(a.region.nodes)
			if(timeout <= 0)
				newRegion = a.region
		else
			newRegion = a.region

		var/turf/newLoc = pick(newRegion.lootSpawns)

		loc.density = 1
		loc = locate(newLoc.x, newLoc.y+1, newLoc.z)
		loc.density = 0

		spawn(9000)
			rotate()



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

	//		lagstopsleep()

		if(n.cookieSpawns)
			var/r = rand(1, n.cookieSpawns.len)
			new /obj/cookiedrop (n.cookieSpawns[r], n)

			var/end = n.cookieSpawns.len - r
			if(end == r) end = rand(1, n.cookieSpawns.len)
			end = clamp(end, 1, n.cookieSpawns.len)
			new /obj/cookiedrop (n.cookieSpawns[end], n)


		lagstopsleep()