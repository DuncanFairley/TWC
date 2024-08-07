mob/Player/var
	tmp
		list/Summons
		summons = 0
	summonsMode = 1

obj/summon
	icon = 'Mobs.dmi'

	canSave = FALSE
	density = 1

	mouse_opacity = 2

	var
		level = 100
		scale = 1
		extraDmg
		HP
		MHP
		duration
		mob/Player/summoner
		mob/target
		obj/healthbar/hpbar
		cast

		corpse = 1

		summonTier = 1

	snake
		icon_state = "snake"
	phoenix
		icon_state = "bird"

		Effect(var/damage)
			summoner.HP = min(round(summoner.HP + damage*0.05, 1), summoner.MHP)
			summoner.updateHP()

	stickman
		icon_state = "stickman"
		level = 200
		scale = 1.8
	corpse
		level = 300
		scale = 2
	imperio
		level = 400
		scale = 3
	basilisk
		level = 200
		scale = 1.8
		icon_state = "basilisk"
		summonTier = 2
	akalla
		level = 200
		scale = 2.2
		icon_state = "basilisk"
		summonTier = 2
	demon_snake
		level = 200
		scale = 2
		icon_state = "snake"

		New(loc, mob/Player/p, spell, size=0)
			set waitfor = 0

			icon_state = pick("snake", "white purple snake", "bg_snake", "red and black snake")

			..(loc, p, spell, size)

	water
		corpse = 0
		level = 200
		icon_state = "water elemental"

		New(loc, mob/Player/p, spell, size=0)
			set waitfor = 0

			level += p.Water.level*2

			..(loc, p, spell, size)

	fire
		corpse = 0
		level = 200
		icon_state = "fire elemental"

		New(loc, mob/Player/p, spell, size=0)
			set waitfor = 0

			level += p.Fire.level*2

			..(loc, p, spell, size)

	earth
		level = 200
		icon_state = "archangel"

		New(loc, mob/Player/p, spell, size=0)
			set waitfor = 0

			level += p.Earth.level*2

			..(loc, p, spell, size)

	ghost
		level = 200
		corpse = 0
		icon_state = "wisp"

		New(loc, mob/Player/p, spell, size=0)
			set waitfor = 0

			level += p.Ghost.level*2
			color = rgb(rand(20, 255), rand(20, 255), rand(20, 255), rand(190,255))

			..(loc, p, spell, size)

	cow
		level = 301
		scale = 2
		icon_state = "cow"

	heal
		icon_state = "slug"
		level = 200
		scale = 1.6

	nurse
		level = 100
		scale = 0.5
		icon = 'NPCs.dmi'
		icon_state = "nurse"
		corpse = 0

		Dispose()

			var/obj/corpse/c = new (loc, src, turn=0, time=0)
			flick("disappaear", c)
	//		c.FlickState("disappaear",8,'NPCs.dmi')

			..()

		Effect(var/damage)
			summoner.HP = min(round(summoner.HP + damage*0.25, 1), summoner.MHP)
			summoner.updateHP()


	New(turf/loc, mob/Player/p, spell, size=0, extraLevel=0)
		set waitfor = 0

		if(!src.loc || src.loc.density) src.loc = p.loc

		sleep(1)
		if(loc)
			var/area/a = loc.loc
			if(a.antiSummon)
				src.loc = null
				return
		if(!p)
			Dispose()
			return

		summoner = p
		cast = spell

		level   += p.level + p.Summoning.level*2 + extraLevel
		MHP      = 4 * (level) + 400
		HP       = MHP
		extraDmg = round(((p.Dmg + p.clothDmg) - (p.level + 4)) * 0.5)
		duration = 900 + p.Summoning.level*60

		if(p.summons + summonTier * p.summonsMode <= 1 + p.extraLimit + round(p.Summoning.level / 10))
			summonTier = summonTier * p.summonsMode


			if(p.summonsMode > 2)
				filters = filter(type="outline", size=1, color="#ffa500")
			else if(p.summonsMode > 1)
				filters = filter(type="outline", size=1, color="#00a5ff")

		if(!p.Summons) p.Summons = list()
		p.Summons += src
		p.summons += summonTier

		hpbar = new
		hpbar.appearance_flags |= RESET_TRANSFORM
		vis_contents += hpbar

		if(size)
			size = min(3, size + p.Summoning.level/40)
			transform = matrix() * size

		sleep(4)

		scale *= summonTier
		MHP   *= summonTier
		HP     = MHP

		state()

//	Move(NewLoc)
//		if(hpbar)
//			hpbar.glide_size = glide_size
//			hpbar.loc = NewLoc
//		.=..()

	Click()
		..()

		if(usr == summoner)
			cast = null
			Dispose()

	Dispose()
		duration = 0

		if(corpse)
			new /obj/corpse(loc, src, turn=0, time=0)

		..()

		var/resummon = 0

		if(target)
			if(ismonster(target))
				if(summoner)
					target:target = summoner
					target:ChangeState(target:HOSTILE)

					if(cast)
						if(cast == "Spellbook")
							summoner.usedSpellbook.cast(summoner)
						else
							winset(summoner, null, "command=\"[cast]\"")
						resummon = 1

				else
					target:ShouldIBeActive()
			target = null

		if(summoner)

			if(!resummon && cast && summoner.client.inactivity < 3000)
				winset(summoner, null, "command=\"[cast]\"")
			summoner.summons -= summonTier
			summoner.Summons -= src
			if(summoner.Summons.len == 0)
				summoner.Summons = null

			summoner = null

		if(hpbar)
			hpbar.loc = null
			hpbar = null

	Attacked(obj/projectile/p)
		if(isplayer(p.owner) && summoner && p.owner != summoner)

			if(summoner.party && (p.owner in summoner.party.members)) return

			var/dmg = p.damage + p.owner:Slayer.level

			dmg *= 1 + p.owner:monsterDmg/100

			var/n = dir2angle(get_dir(src, p))
			emit(loc    = src,
				 ptype  = /obj/particle/fluid/blood,
			     amount = 4,
			     angle  = new /Random(n - 25, n + 25),
			     speed  = 2,
			     life   = new /Random(15,25))

			p.owner << "Your [p] does [dmg] damage to [src]."

			HP -= dmg

			if(HP > 0)
				if(hpbar)
					var/percent = HP / MHP
					hpbar.Set(percent, src)

			// use if allowing summoner to damage
			//	if(!target && p.owner != summoner)
				if(!target)
					target = p.owner
			else
				p.owner << infomsg("<i>You killed [summoner]'s [name].</i>")
				Dispose()

	proc/Effect(var/damage)


	proc/state()
		set waitfor = 0

		while(duration > 0 && summoner)
			var/delay = 4
			if(target)
				var/d = get_dist(src, target)
				if(d > 15)
					target = null
				else if(d > 1)
					density = 0
					step_towards(src, target)
					density = 1

					if(isplayer(target))
						delay = 4
					else
						delay = 2

				else
					if(ismonster(target))
						var/mob/Enemies/e = target
						if(e.state < 2 || loc.loc != summoner.loc.loc)
							target = null
						else
							e.state = 16
							e.dir = get_dir(e, src)
							dir = turn(e.dir, 180)

							var/dmg = max(0, (level + extraDmg) * scale - ((e.level + e.hardmode*50) * 0.25)*summonTier)

							if(e.prizePoolSize > 1)
								dmg = round((dmg*0.75) / e.prizePoolSize)

							var/c
							if(summoner.holster && summoner.holster.selectedColors)
								c = pick(summoner.holster.selectedColors)
							else if(summoner.wand && summoner.wand.projColor)
								c = summoner.wand.projColor

							var/exp2give = e.onDamage(dmg, summoner, projColor=c)

							if(!summoner) break

							Effect(dmg)

							if(exp2give > 0)
								target = null
								summoner.Summoning.add(exp2give*0.8, summoner, 1)

							else
								dmg = e.Dmg
								if(e.hardmode)
									if(e.DMGmodifier < 0.7)
										var/perc = (e.DMGmodifier / 0.7) * 100
										dmg *= 100 / perc

									dmg = dmg * (1.1 + e.hardmode*0.5) + 60*e.hardmode

									if(e.hardmode > 5)
										dmg += 140*e.hardmode

								dmg = dmg*0.75

								if(level < e.level)
									dmg += dmg * ((51 + e.level - level)/200)


								var/monsterDefLimit = (SHIELD_SOUL in summoner.passives) ? 0.9 : 0.75

								dmg *= 1 - min((summoner.monsterDef + summonTier*5)/100, monsterDefLimit)

								HP -= dmg
								if(HP <= 0)	break

								if(hpbar)
									var/percent = HP / MHP
									hpbar.Set(percent, src)

					else if(isplayer(target))
						var/mob/Player/p = target

						var/dmg = round((level + extraDmg - 51)*0.4*scale, 1) - p.Slayer.level

						if(p.animagusOn)
							dmg = dmg * 0.75 - p.Animagus.level

						if(dmg >= 1)
							dmg = p.onDamage(dmg, summoner)
							if(dmg >= 1)
								target << "<span style='color:red'>[src] attacks you for [dmg] damage!</span>"
								if(p.HP <= 0)
									p.Death_Check(summoner)
									target = null
								else
									HP -= (p.Dmg + p.clothDmg + p.Slayer.level)*2
									if(HP <= 0)	break

									if(hpbar)
										var/percent = HP / MHP
										hpbar.Set(percent, src)
						delay = 5
					else
						target = null
			else
				var/d = get_dist(src, summoner)
				if(d > 20)
					loc = summoner.loc
				else if(d > 7)
					density = 0
					step_towards(src, summoner)
					density = 1

					if(d > 14) delay = 1
					else delay = 2

				else
					step_rand(src)
					delay = 8

			glide_size = 32 / delay
			duration -= delay
			sleep(delay)

		if(loc) Dispose()