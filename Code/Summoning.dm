/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

mob/Player/var/tmp/list/Summons

obj/summon
	icon = 'Mobs.dmi'

	canSave = FALSE
	density = 1

	var
		level = 100
		HP
		MHP
		duration
		mob/Player/summoner
		mob/target
		obj/healthbar/hpbar
		cast


	snake
		icon_state = "snake"
	phoenix
		icon_state = "bird"
		level = 150
	stickman
		icon_state = "stickman"
		level = 200

	New(loc, mob/Player/p, spell, size=0)
		set waitfor = 0
		..()

		summoner = p
		cast = spell

		level   += p.level + p.Summoning.level
		MHP      = 4 * (level) + 200
		HP       = MHP
		duration = 450 + p.Summoning.level*10

		if(!p.Summons) p.Summons = list()
		p.Summons += src

		hpbar = new(src)

		if(size)
			size = min(3, size + p.Summoning.level/20)
			transform = matrix() * size

		sleep(4)
		state()

	Move(NewLoc)
		if(hpbar)
			hpbar.glide_size = glide_size
			hpbar.loc = NewLoc
		.=..()

	Dispose()
		duration = 0
		new /obj/corpse(loc, src)

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

			if(!resummon && summoner.client.inactivity < 100)
				winset(summoner, null, "command=\"[cast]\"")

			summoner.Summons -= src
			if(summoner.Summons.len == 0)
				summoner.Summons = null

			summoner = null

		if(hpbar)
			hpbar.loc = null
			hpbar = null

	Attacked(obj/projectile/p)
		if(isplayer(p.owner))

			var/dmg = p.damage + p.owner:Slayer.level

			if(p.owner:monsterDmg > 0)
				dmg *= 1 + p.owner:monsterDmg/100

			if(p.owner == summoner)
				dmg = round(dmg * 0.25)

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

				if(!target && p.owner != summoner)
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
					step_to(src, target, 1)
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

							var/dmg = level * 1.5

							if(summoner.monsterDmg > 0)
								dmg *= 1 + summoner.monsterDmg/100

							e.HP -= dmg
							if(e.hpbar)
								var/percent = e.HP / e.MHP
								e.hpbar.Set(percent, e)
							if(e.HP <= 0)
								e.Death_Check(summoner)
								target = null

								var/exp2give = (rand(6,14)/10)*e.Expg

								if(summoner.level > e.level && !summoner.findStatusEffect(/StatusEffect/Lamps/Farming))
									exp2give -= exp2give * ((summoner.level-e.level)/150)

								if(exp2give > 0)
									if(summoner.House == worldData.housecupwinner)
										exp2give *= 1.25

									var/StatusEffect/Lamps/Exp/exp_rate = summoner.findStatusEffect(/StatusEffect/Lamps/Exp)
									if(exp_rate) exp2give *= exp_rate.rate

									summoner.Summoning.add(exp2give, summoner, 1)
							else
								dmg = e.Dmg*0.6

								HP -= dmg
								if(HP <= 0)	break

								if(hpbar)
									var/percent = HP / MHP
									hpbar.Set(percent, src)

					else
						var/mob/Player/p = target
						var/dmg = p.onDamage(level - 100, summoner)
						target << "<span style='color:red'>[src] attacks you for [dmg] damage!</span>"
						if(p.HP <= 0)
							target = null
							p.Death_Check(summoner)
			else
				var/d = get_dist(src, summoner)
				if(d > 20)
					loc = summoner.loc
				else if(d > 5)
					step_to(src, summoner, 1)

					if(d > 10) delay = 1
					else delay = 2

				else
					step_rand(src)
					delay = 6

			glide_size = 32 / delay
			duration -= delay
			sleep(delay)

		if(loc) Dispose()