mob/Player/var/tmp/list/Summons

obj/summon
	icon = 'Mobs.dmi'

	canSave = FALSE
	density = 1

	var
		level = 50
		scale = 1
		HP
		MHP
		duration
		mob/Player/summoner
		mob/target
		obj/healthbar/hpbar
		cast

		corpse = 1


	snake
		icon_state = "snake"
	phoenix
		icon_state = "bird"
		level = 100
		scale = 1.2
	stickman
		icon_state = "stickman"
		level = 150
		scale = 1.6
	corpse
		level = 200
		scale = 1.8
	demon_snake
		level = 200
		scale = 2
		icon_state = "snake"

		New(loc, mob/Player/p, spell, size=0)
			set waitfor = 0

			icon_state = pick("snake", "wp_snake", "bg_snake", "rbo_snake")

			..(loc, p, spell, size)

	water
		corpse = 0
		icon_state = "water elemental"

		New(loc, mob/Player/p, spell, size=0)
			set waitfor = 0

			level += p.Water.level*2

			..(loc, p, spell, size)

	fire
		corpse = 0
		level = 110
		icon_state = "fire elemental"

		New(loc, mob/Player/p, spell, size=0)
			set waitfor = 0

			level += p.Fire.level*2

			..(loc, p, spell, size)

	earth
		level = 110
		icon_state = "archangel"

		New(loc, mob/Player/p, spell, size=0)
			set waitfor = 0

			level += p.Earth.level*2

			..(loc, p, spell, size)

	ghost
		level = 110
		corpse = 0
		icon_state = "wisp"

		New(loc, mob/Player/p, spell, size=0)
			set waitfor = 0

			level += p.Ghost.level*2
			color = rgb(rand(20, 255), rand(20, 255), rand(20, 255), rand(190,255))

			..(loc, p, spell, size)
	heal
		icon_state = "slug"
		level = 160
		scale = 1.6

	New(loc, mob/Player/p, spell, size=0)
		set waitfor = 0
		..()

		summoner = p
		cast = spell

		level   += p.level + p.Summoning.level*2
		MHP      = 4 * (level) + 200
		HP       = MHP
		duration = 600 + p.Summoning.level*10

		if(!p.Summons) p.Summons = list()
		p.Summons += src

		hpbar = new(src)

		if(size)
			size = min(3, size + p.Summoning.level/25)
			transform = matrix() * size

		sleep(4)
		state()

	Move(NewLoc)
		if(hpbar)
			hpbar.glide_size = glide_size
			hpbar.loc = NewLoc
		.=..()

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
						winset(summoner, null, "command=\"[cast]\"")
						resummon = 1

				else
					target:ShouldIBeActive()
			target = null

		if(summoner)

			if(!resummon && cast && summoner.client.inactivity < 300)
				winset(summoner, null, "command=\"[cast]\"")

			summoner.Summons -= src
			if(summoner.Summons.len == 0)
				summoner.Summons = null

			summoner = null

		if(hpbar)
			hpbar.loc = null
			hpbar = null

	Attacked(obj/projectile/p)
		if(isplayer(p.owner) && p.owner != summoner)

			var/dmg = p.damage + p.owner:Slayer.level

			if(p.owner:monsterDmg > 0)
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

							var/dmg = level * scale

							if(summoner.monsterDmg > 0)
								dmg *= 1 + summoner.monsterDmg/100


							var/exp2give = e.onDamage(dmg, summoner)

							if(exp2give > 0)
								target = null
								summoner.Summoning.add(exp2give*0.8, summoner, 1)

							else
								dmg = e.Dmg*0.7

								if(level < e.level)
									dmg += dmg * ((51 + e.level - level)/200)

								HP -= dmg
								if(HP <= 0)	break

								if(hpbar)
									var/percent = HP / MHP
									hpbar.Set(percent, src)

					else
						var/mob/Player/p = target

						var/dmg = round((level - 51)*0.4, 1) - p.Slayer.level

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