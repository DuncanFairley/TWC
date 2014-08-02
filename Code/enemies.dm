/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
area/var/safezoneoverride = 0
obj/statues
	icon = 'statues.dmi'
	acromantula/icon_state = "acromantula"
	firebat/icon_state = "firebat"
	fire_golem/icon_state = "firegolem"
	bird/icon_state = "bird"
	demon_rat/icon_state = "demon rat"
	troll/icon_state = "troll"
	dementor/icon_state = "dementor"
	pixie/icon_state = "pixie"
	wyvern/icon_state = "wyvern"
	fire_elemental/icon_state = "fire elemental"
	water_elemental/icon_state = "water elemental"
	basilisk/icon_state = "basilisk"
	floating_eye/icon_state = "eye"
	archangel/icon_state = "archangel"
	snake/icon_state = "snake"
	house_elf/icon_state = "houseelf"
	dragon/icon_state = "dragon"
	wolf/icon_state = "wolf"
	skeleton/icon_state = "skeleton"
	bat/icon_state = "bat"
	werewolf/icon_state = "werewolf"
	rat/icon_state = "rat"
	black_cat/icon_state = "blackcat"
	white_cat/icon_state = "whitecat"
	dog/icon_state = "dog"

proc
	isPathBlocked(mob/source, mob/target, dist=1, dense_override=0, dist_limit=10)
		if(!(source && source.loc)) return 1
		if(!(target && target.loc)) return 1
		if(!source.density && !dense_override) return 0

		var/obj/o = new (source.loc)
		o.density = 1

		var/STEPS_LIMIT = 15

		var/turf/t = get_step_to(o, target, dist)
		var/distance = get_dist(o, target)

		for(var/steps = 0 to STEPS_LIMIT)
			if(!t) break
			if(distance <= dist_limit) break

			o.loc    = t
			t        = get_step_to(o, target, dist)
			distance = get_dist(o, target)

		if(!t && get_dist(o, target) > dist)
			o.loc = null
			return 1
		o.loc = null
		if(distance > dist_limit)
			return 1
		return 0
area
	newareas
		var/tmp/active = 0
		outside
			Forbidden_ForestNE
			Forbidden_ForestNW
			Forbidden_ForestSE
			Forbidden_ForestSW
			Pixie_Pit
			Desert1
			Desert2
			Desert3
			Silverblood_Grounds
			Graveyard
			Hogsmeade
			layer = 6	// set this layer above everything else so the overlay obscures everything
			var
				lit = 1	// determines if the area is lit or dark.
				obj/weather/Weather	// what type of weather the area is having
			proc
				daycycle()
					lit = 1 - lit	// toggle lit between 1 and 0
					if(lit)
						overlays -= 'black50.dmi'	// remove the 50% dither
						//if(type == /area/outside)
							//world<<"<b>Event: <font color=blue>The sun rises over the forest. A new day begins."	// remove the dither
					else
						overlays += 'black50.dmi'	// add the 50% dither
					spawn(9000) daycycle()
		inside
			Silverblood_Maze

				Entered(atom/movable/Obj,atom/OldLoc)
					.=..()
					if(isplayer(Obj))
						Obj:nofly()


			Ratcellar
			Chamber_of_Secrets
		Entered(atom/movable/O)
			. = ..()
			if(isplayer(O))
				active = 1
				for(var/mob/NPC/Enemies/M in src)
					if(M.state == M.WANDER)
						M.state = M.SEARCH


		Exit(atom/movable/O)
			if(istype(O, /mob/NPC) && !O:removeoMob) return 0
			return 1

		Exited(atom/movable/O)
			. = ..()
			if(isplayer(O))
				var/isempty = 1
				for(var/mob/Player/M in src)
					if(M != O)
						isempty = 0
						break
				if(isempty)
					active = 0
					for(var/mob/NPC/Enemies/M in src)
						M.state = M.WANDER
mob
	test
		verb
			View_Error_Log()
				src << browse(file("Logs/[VERSION]-log.txt"))
			Reconnect_MySQL()
				connected = my_connection.Connect(DBI,mysql_username,mysql_password)
				src << "New connection started."
mob
	NPC
		see_invisible = 1
		var/activated = 0
		var/HPmodifier = 0.9
		var/DMGmodifier = 0.55
		var/tmp/turf/origloc

		Enemies
			player = 0
			Gm = 1
			monster = 1
			NPC = 1

			var
				const
					INACTIVE   = 0
					WANDER     = 1
					SEARCH     = 2
					HOSTILE    = 4
					CONTROLLED = 8

				tmp
					state = WANDER
					list/ignore

				Range = 10
				MoveDelay = 5
				AttackDelay = 5


			New()
				. = ..()
				spawn(1) // fix for monsters not setting their variables if loaded from swap maps
					Dmg = round(DMGmodifier * ((src.level -1) + 5))
					MHP = round(HPmodifier * (4 * (src.level - 1) + 200))
					gold = round(src.level / 2)
					Expg = round(src.level * 1.3)
					HP = MHP
					origloc = loc
					sleep(rand(10,60))
					state()
//NEWMONSTERS
			proc/Death(mob/Player/killer)

			proc/state()
				var/lag = 10
				while(src)
					switch(state)
						if(INACTIVE)
							lag = 42
						if(WANDER)
							Wander()
							lag = 27
						if(SEARCH)
							Search()
							lag = 15
						if(HOSTILE)
							Attack()
							lag = MoveDelay
						if(CONTROLLED)
							BlindAttack()
							lag = 12
					if(lag <= 0) lag = 1
					sleep(lag)
			var/tmp/mob/target


			proc
				Search()
					Wander()
					for(var/mob/Player/M in ohearers(src, Range))
						if(M.loc.loc != src.loc.loc) continue
						if(ignore && (M in ignore)) continue

						if(!isPathBlocked(M, src, 1, src.density))
							target = M
							state  = HOSTILE
							break
						else
							Ignore(M)

				Wander()
					step_rand(src)

				Ignore(mob/M)
					if(!ignore) ignore = list()
					ignore += M
					spawn(50)
						if(M && ignore)
							ignore -= M
							if(ignore.len == 0)
								ignore = null
						else
							ignore = null

			proc/ReturnToStart()
				state = INACTIVE
				if(loc.loc != origloc.loc)
					if(z == origloc.z)
						density = 0
						while(loc.loc != origloc.loc)
							sleep(1)
							step_towards(src, origloc)
						density = 1
					else
						src.loc = origloc
				ShouldIBeActive()

			proc/ShouldIBeActive()
				if(!loc)
					state = INACTIVE
					return 0

				if(istype(loc.loc, /area/newareas) && loc.loc:active)
					state = SEARCH
					return 1

				state = WANDER
				return 0


			proc/BlindAttack()//removeoMob
				var/mob/Player/M = locate() in ohearers(1, src)
				if(M)
					var/dmg = Dmg+extraDmg+rand(0,4)
					if(dmg<1)
						//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
					else
						M.HP -= dmg
						hearers(M)<<"<SPAN STYLE='color: red'>[src] attacks [M] and causes [dmg] damage!</SPAN>"
						if(src.removeoMob)
							spawn() M.Death_Check(src.removeoMob)
						else
							spawn() M.Death_Check(src)

			proc/Blocked()
				target = null
				ShouldIBeActive()

			proc/Attack()

				var/distance = get_dist(src,target)
				if(!target || !target.loc || target.loc.loc != loc.loc || distance > Range)
					target = null
					ShouldIBeActive()
					return

				if(prob(20))
					step_rand(src)
					sleep(2)

				if(distance > 1)
					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						step_rand(src)
						Blocked()
				else
					var/dmg = Dmg+extraDmg+rand(0,4)

					if(target.level > level && !target.findStatusEffect(/StatusEffect/Lamps/Farming))
						dmg -= dmg * ((target.level - level)/100)
					else if(target.level < level)
						dmg += dmg * ((level - target.level)/200)
					dmg = round(dmg)

					if(dmg<1)
						//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
					else
						target.HP -= dmg
						hearers(target)<<"<SPAN STYLE='color: red'>[src] attacks [target] and causes [dmg] damage!</SPAN>"
						spawn()target.Death_Check(src)
					sleep(AttackDelay)

//////Monsters///////

			Summoned
				state = SEARCH
				New()
					Dmg = round(DMGmodifier * ((src.level -1) + 5))
					MHP = round(HPmodifier * (4 * (src.level - 1) + 200))
					gold = round(src.level / 2)
					Expg = round(src.level * 1.3)
					HP = MHP
					spawn(1)
						state()

				ShouldIBeActive()
					if(!loc)
						state = INACTIVE
						return 0

					state = SEARCH
					return 1

				ReturnToStart()
					ShouldIBeActive()

				Death()

				Snake
					icon = 'Animagus.dmi'
					icon_state="Snake"
					level = 250

				Basilisk
					icon = 'bassy.dmi'
					HPmodifier = 3
					DMGmodifier = 3
					MoveDelay = 3
					level = 2000

					Attack()
						..()

					Search()
						Wander()
						for(var/mob/Player/M in ohearers(src, Range))
							if(M.loc.loc != src.loc.loc) continue
							if(ignore && (M in ignore)) continue

							if(!isPathBlocked(M, src, 1, src.density))
								target = M
								state  = HOSTILE

								spawn()
									var/time = 5
									while(src && state == HOSTILE && M == target && time > 0)
										sleep(30)
										time--

									if(M == target && state == HOSTILE)
										target = null
										state = SEARCH

								break
							else
								Ignore(M)

					Blocked()
						density = 0
						var/turf/t = get_step_to(src, target, 1)
						if(t)
							Move(t)
						else
							..()
						density = 1

				Phoenix
					icon = 'monsters2.dmi'
					icon_state = "bird"
					level = 6

					Attack()
						..()

					Search()
						Wander()

					New()
						light(src, 3, 600, "light")
						..()

						spawn()
							var/time = 600
							while(time > 0)
								for(var/mob/Player/M in ohearers(3, src))
									M.HP += ((M.HP/8)+rand(1,50))
									if(M.HP > M.MHP) M.HP = M.MHP
									M.updateHPMP()
								sleep(25)
								time--

			Rat
				icon = 'monsters.dmi'
				icon_state="demon rat"
				ratpoints = 1
				level = 10
			Demon_Rat
				icon = 'monsters.dmi'
				icon_state="demon rat"
				level = 50
			Pixie
				icon = 'monsters2.dmi'
				icon_state="pixie"
				level = 100
			Dog
				icon = 'NewMobs.dmi'
				icon_state="dog"
				level = 150
			Snake
				icon = 'Animagus.dmi'
				icon_state="Snake"
				level = 200
			Wolf
				icon = 'monsters2.dmi'
				icon_state="wolf"
				level = 300
			Acromantula
				icon = 'monster.dmi'
				icon_state="Spider"
				level = 700
			Floating_Eye
				icon = 'monsters.dmi'
				icon_state="eye"
				level = 800
				HPmodifier = 1.8
				var/tmp/fired = 0
				MoveDelay = 4
				AttackDelay = 1

				Search()
					Wander()
					for(var/mob/Player/M in ohearers(src, Range))
						if(M.loc.loc == src.loc.loc)
							target = M
							state  = HOSTILE
							break

				Blocked()
					density = 0
					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						..()
					density = 1

				Attack(mob/M)
					..()
					if(!fired && target)
						var/fire = 0
						if(prob(40))
							fire = 1
						else if(prob(10))
							fire = 2
						if(fire)
							fired = 1
							spawn(rand(30,50)) fired = 0

							var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
							if(fire == 1)
								var/tmp_d = dir
								var/dmg = round(Dmg * 1.5 + rand(-4,8))
								for(var/d in dirs)
									dir = d
									castproj(0, 'attacks.dmi', "crucio2", dmg, "death ball", 0, 1)
								dir = tmp_d
							else
								for(var/d in dirs)
									var/obj/Flippendo/S = new (src.loc)
									S.owner = src
									walk(S, d, 2)
									spawn(20) if(S) del S
							sleep(AttackDelay)
				Death(mob/Player/killer)

					var/rate = 1

					if(killer.House == housecupwinner)
						rate += 0.25

					var/StatusEffect/Lamps/DropRate/d = killer.findStatusEffect(/StatusEffect/Lamps/DropRate)
					if(d)
						rate *= d.rate

					rate *= DropRateModifier

					if(prob(0.6 * rate))
						new /obj/items/artifact(src.loc)
					else if(prob(1 * rate))
						var/t = pick(/obj/items/DarknessPowder, /obj/items/Whoopie_Cushion,/obj/items/U_No_Poo,/obj/items/Smoke_Pellet,/obj/items/Tube_of_fun,/obj/items/Swamp)
						new t(src.loc)

			Troll
				icon = 'monsters2.dmi'
				icon_state="troll"
				level = 350
			House_Elf
				icon = 'monsters2.dmi'
				icon_state="houseelf"
				level = 5
			Stone_Golem
				icon = 'monsters.dmi'
				icon_state="stonegolem"
				level = 6
			Dementor
				icon = 'monsters2.dmi'
				icon_state="Dementor"
				level = 750
			Dementor_ /////SUMMONED/////
				icon = 'monsters2.dmi'
				icon_state="Dementor"
				level = 300
			Stickman_ ///SUMMONED///
				icon = 'stickman.dmi'
				level = 500
			Bird_    ///SUMMONED///
				icon = 'monsters2.dmi'
				icon_state="bird"
				level = 6
			Fire_Bat
				icon = 'monsters.dmi'
				icon_state="firebat"
				level = 400
				var/tmp/fired = 0
				AttackDelay = 3
				Attack()
					if(!target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,10)))
						target = null
						ShouldIBeActive()
						return

					if(!fired && prob(80))
						fired = 1
						dir=get_dir(src, target)
						castproj(0, 'attacks.dmi', "fireball", Dmg + rand(-4,8), "fire ball")
						spawn(rand(15,30)) fired = 0
						sleep(AttackDelay)

					var/distance = get_dist(src, target)
					if(distance > 5)
						var/turf/t = get_step_to(src, target, 1)
						if(t)
							Move(t)
						else
							target = null
							ShouldIBeActive()
					else if(distance <= 3)
						step_away(src, target)
					else if(distance > 3)
						step_rand(src)
						sleep(2)
			Fire_Golem
				icon = 'monsters.dmi'
				icon_state="firegolem"
				level = 450
				AttackDelay = 3
				var/tmp/fired = 0
				Attack()
					if(!target || !target.loc || target.loc.loc != loc.loc || !(target in ohearers(src,10)))
						target = null
						ShouldIBeActive()
						return

					if(!fired && prob(80))
						fired = 1
						dir=get_dir(src, target)
						castproj(0, 'attacks.dmi', "fireball", Dmg + rand(-4,8), "fire ball")
						spawn(rand(15,30)) fired = 0
						sleep(AttackDelay)

					var/distance = get_dist(src, target)
					if(distance > 5)
						var/turf/t = get_step_to(src, target, 1)
						if(t)
							Move(t)
						else
							target = null
							ShouldIBeActive()
					else if(distance < 3)
						step_away(src, target)
					else if(distance >= 3)
						step_rand(src)
						sleep(2)

			Slug
				icon='NewMobs.dmi'
				icon_state="slug"
				monster=1
				player=0
				New()
					move()
				proc/move()
					spawn(5)
						while(src)
							walk_rand(src,15)
							sleep(100)
							del src
			ArchAngel
				icon = 'monsters.dmi'
				icon_state="archangel"
				level = 500
			Water_Elemental
				icon = 'monster.dmi'
				icon_state="water elemental"
				level = 550
			Fire_Elemental
				icon = 'monster.dmi'
				icon_state="fire elemental"
				level = 600
			Wyvern
				icon = 'monster.dmi'
				icon_state="wyvern"
				level = 650
			Basilisk
				icon = 'bassy.dmi'
				level = 2000
				HPmodifier = 3
				DMGmodifier = 3
				MoveDelay = 3

				var/tmp/fired = 0

				Blocked()
					density = 0
					var/turf/t = get_step_to(src, target, 1)
					if(t)
						Move(t)
					else
						..()
					density = 1

				Attack()
					..()

					if(!fired && target)
						var/d = get_dir(src, target)
						if(!(d & (d - 1)))

							fired = 1
							spawn(rand(50,150)) fired = 0

							var/mob/M = target
							M.movable    = 1
							M.icon_state = "stone"
							spawn(rand(10,30))
								if(M && M.movable)
									M.movable    = 0
									M.icon_state = ""

mob
	Dog
		icon = 'NewMobs.dmi'
		icon_state="dog"
		see_invisible = 1
		gold = 5
		HP = 10
		MHP = 10
		Def=0
		player = 0
		Dmg = 15
		Expg = 36
		level = 1
		monster = 1
		NPC = 0
		New()
			. = ..()

			spawn(rand(10,30))
				Wander()
				.
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+extraDmg+rand(0,4)-M.Def-M.extraDef
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)
	Wolf
		icon = 'monsters2.dmi'
		icon_state="wolf"
		gold = 10
		HP = 15
		see_invisible = 1
		MHP = 15
		Def=0
		player = 0
		Dmg = 19
		Expg = 40
		level = 1
		monster = 1
		NPC = 0
		New()
			. = ..()

			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+extraDmg+rand(0,5)-M.Def-M.extraDmg
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)
	Snake
		icon = 'Animagus.dmi'
		icon_state="Snake"
		HP = 300
		MHP = 500
		player = 0
		see_invisible = 1
		Dmg = 125
		gold = 10
		Def=60
		Expg = 75
		level = 15
		monster = 1
		NPC = 0
		New()
			. = ..()

			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,10)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)
	Snake_
		icon = 'Animagus.dmi'
		icon_state="Snake"
		HP = 300
		see_invisible = 1
		MHP = 500
		player = 0
		Dmg = 125
		Def=60
		level = 15
		monster = 1
		NPC = 0
		New()
			. = ..()

			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(10)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			if(!M)
				spawn()Wander()
				return
			var/dmg = Dmg+rand(0,10)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!M ||!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)if(M)Attack(M)

	Pixie
		icon = 'monsters2.dmi'
		icon_state="pixie"
		gold = 10
		HP = 50
		MHP = 50
		Def=0
		player = 0
		see_invisible = 1
		Dmg = 50
		Expg = 100
		level = 2
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,10)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] jabs [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)

	Demon_Rat
		icon = 'monsters.dmi'
		icon_state="demon rat"
		gold = 25
		HP = 100
		MHP = 100
		player = 0
		Dmg = 100
		see_invisible = 1
		Expg = 25
		level = 3
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,30)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)

	Rat
		icon = 'monsters.dmi'
		icon_state="demon rat"
		gold = 25
		HP = 100
		MHP = 100
		player = 0
		see_invisible = 1
		Dmg = 100
		Expg = 25
		ratpoints = 1
		level = 3
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,30)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)

	Troll
		icon = 'monsters2.dmi'
		icon_state="troll"
		gold = 50
		HP = 200
		MHP = 200
		player = 0
		Def=10
		Dmg = 150
		Expg = 250
		see_invisible = 1
		level = 5
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,30)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] attacks [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)

	House_Elf
		icon = 'monsters2.dmi'
		icon_state="houseelf"
		gold = 0
		HP = 200
		MHP = 200
		player = 0
		Def=10
		Dmg = 150
		Expg = 0
		level = 5
		monster = 1
		NPC = 1



	Stone_Golem
		icon = 'monsters.dmi'
		icon_state="stonegolem"
		gold = 75
		HP = 500
		MHP = 500
		player = 0
		Dmg = 200
		Def=20
		Expg = 75
		level = 6
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,30)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] attacks [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)

	Dementor
		icon = 'monsters2.dmi'
		icon_state="Dementor"
		gold = 75
		HP = 900
		see_invisible = 1
		MHP = 500
		player = 0
		Dmg = 290
		Def=29
		Expg = 375
		level = 6
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,50)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] attacks [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)
	Dementor_
		icon = 'monsters2.dmi'
		icon_state="Dementor"
		gold = 0
		Expg = 0
		HP = 500
		MHP = 500
		player = 0
		Dmg = 200
		see_invisible = 1
		Def=20
		level = 6
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(5,10))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(10)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			if(!M)
				spawn()Wander()
				return
			var/dmg = Dmg+rand(0,50)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] attacks [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)

	Stickman_
		icon = 'stickman.dmi'
		gold = 0
		HP = 50
		MHP = 50
		Def=0
		player = 0
		Dmg = 50
		see_invisible = 1
		Expg = 10
		level = 2
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(5,10))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(10)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			if(!M)
				spawn()Wander()
				return
			var/dmg = Dmg+rand(0,20)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s sticky stick-ness doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] sticks [M] with a stick and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)
	Bird_
		icon = 'monsters2.dmi'
		icon_state="bird"
		gold = 0
		HP = 10000
		MHP = 500
		player = 0
		Dmg = 200
		Def=20
		see_invisible = 1
		level = 6
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(5,10))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(10)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			if(!M)
				spawn()Wander()
				return
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(M.HP>=M.MHP)
				spawn()Wander()
				return
			else
				M.HP += ((M.HP/8)+rand(1,50))
				if(M.HP > M.MHP) M.HP = M.MHP
				M.updateHPMP()
				hearers()<<"<SPAN STYLE='color: red'>[src] heals [M]!</SPAN>"
			spawn(10)Attack(M)
	Fire_Bat
		icon = 'monsters.dmi'
		icon_state="firebat"
		gold = 80
		HP = 600
		MHP = 600
		player = 0
		Dmg = 300
		Def=35
		see_invisible = 1
		Expg = 300
		level = 7
		monster = 1
		NPC = 0
		var/activated = 1
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			activated = 1
			walk(src,0)
			walk_rand(src,11)
			while(activated)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/M)
			while(get_dist(src,M)>5)
				sleep(4)
				if(!activated)
					spawn(rand(10,30))
						walk_rand(src,11)
					return
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			dir=get_dir(src,M)
			var/obj/S=new/obj/enemyfireball(src.loc)
			walk(S,dir,2)
			spawn(30)M.Death_Check(src)
			sleep(10)
			for(var/mob/A in oview(src)) if(A.client)
				walk(src,0)
				if(rand(1,4) == 4)
					step_rand(src)
				spawn()Attack(A)
				return
	Fire_Golem
		icon = 'monsters.dmi'
		icon_state="firegolem"
		gold = 85
		HP = 1000
		MHP = 1000
		player = 0
		Dmg = 400
		Def=30
		Expg = 390
		see_invisible = 1
		level = 7
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			var/mob/Player/P
			while(src)
				sleep(20)
				if(P in oview(5))
					step_towards(src,P)
					var/obj/S=new/obj/enemyfireball
					S.loc=(usr.loc)
					walk(S,usr.dir,2)

	Slug
		icon='NewMobs.dmi'
		icon_state="slug"
		monster=1
		see_invisible = 1
		HP=25
		gold=0
		player=0
		New()
			move()
			..()
		proc/move()
			spawn(5)
				while(src)
					walk_rand(src,15)
					sleep(100)
					del src
			..()

	Acromantula
		icon = 'monster.dmi'
		icon_state="Spider"
		gold = 70
		HP = 500
		MHP = 500
		see_invisible = 1
		player = 0
		Dmg = 200
		Def=15
		Expg = 70
		level = 8
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,20)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)
	Ice_Muck
		icon = 'monsters.dmi'
		icon_state="icemuck"
		gold = 100
		HP = 1000
		MHP = 1000
		player = 0
		Dmg = 400
		see_invisible = 1
		Def=40
		Expg = 100
		level = 9
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander(var/mob/Player/P)
			while(src)
				if(P in oview(5))
					step_towards(src,P)
					for(P in oview(1))
						break
					for(P in oview(2))
						break
					for(P in oview(3))
						break
					for(P in oview(4))
						break
				else
					sleep(5)
					for(P in oview(5))
						break
				sleep(5)
			spawn(5)
				Wander()
		Bump(mob/M)
			if(!istype(M, /mob)) return
			if(M.player == 1)
				Fight(M)
			else
				return
		proc/Fight()
			for(var/mob/E in get_step(usr,usr.dir))
				var/damage = (src.Dmg+rand(0,3)-E.Def)
				if(damage<=0)
					hearers()<<"<SPAN STYLE='color: blue'>[src]'s bash doesnt even faze [E]</SPAN>"
				else
					E.HP -= damage
					hearers()<<"<SPAN STYLE='color: red'>[src] bashes [E] for [damage] damage!</SPAN>"
					E.Death_Check(src)
	Scorpion
		icon = 'monsters.dmi'
		icon_state="scorpion"
		gold = 125
		HP = 1500
		MHP = 1500
		player = 0
		see_invisible = 1
		Dmg = 600
		Def=50
		Expg = 125
		level = 10
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander(var/mob/Player/P)
			while(src)
				if(P in oview(5))
					step_towards(src,P)
					for(P in oview(1))
						break
					for(P in oview(2))
						break
					for(P in oview(3))
						break
					for(P in oview(4))
						break
				else
					step_rand(src)
					sleep(5)
					for(P in oview(5))
						break
				sleep(5)
			spawn(5)
				Wander()
		Bump(mob/M)
			if(!istype(M, /mob)) return
			if(M.player == 1)
				Fight(M)
			else
				return
		proc/Fight()
			for(var/mob/E in get_step(usr,usr.dir))
				var/damage = (src.Dmg+rand(0,3)-E.Def)
				if(damage<=0)
					hearers()<<"<SPAN STYLE='color: blue'>[src]'s sting doesnt even faze [E]</SPAN>"
				else
					E.HP -= damage
					hearers()<<"<SPAN STYLE='color: red'>[src] stings [E] for [damage] damage!</SPAN>"
					var/poisoning=rand(0,3)
					if(poisoning==3)
						hearers()<<"<SPAN STYLE='color: red'>[src]'s sting has poisoned [E]!</SPAN>"
						E.status="(Poison)"
					E.Death_Check(src)

	Floating_Eye
		icon = 'monsters.dmi'
		icon_state="eye"
		gold = 400
		HP = 3000
		MHP = 3000
		player = 0
		Dmg = 800
		see_invisible = 1
		Def=80
		Expg = 580
		level = 13
		monster = 1
		NPC = 0
		New()
			..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,20)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] attacks [M] for [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)

	Water_Elemental
		icon = 'monster.dmi'
		icon_state="water elemental"
		gold = 600
		HP = 5000
		MHP = 5000
		player = 0
		see_invisible = 1
		Dmg = 950
		Def=80
		Expg = 600
		level = 13
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,20)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				hearers()<<"<SPAN STYLE='color: blue'>[src]'s blasts don't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] blows win at [M] for [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)

	Wyvern
		icon = 'monster.dmi'
		icon_state="wyvern"
		gold = 670
		HP = 5000
		MHP = 5000
		player = 0
		see_invisible = 1
		Dmg = 950
		Def=80
		Expg = 620
		level = 13
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,20)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				hearers()<<"<SPAN STYLE='color: blue'>[src]'s blasts don't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] blows wind at [M] for [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)


	Fire_Elemental
		icon = 'monster.dmi'
		icon_state="fire elemental"
		gold = 650
		HP = 5000
		see_invisible = 1
		MHP = 5000
		player = 0
		Dmg = 950
		Def=80
		Expg = 600
		level = 13
		monster = 1
		NPC = 0

		New()
			spawn(rand(10,30))
				Wander()
			return
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,20)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				hearers()<<"<SPAN STYLE='color: blue'>[src]'s burns don't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] burns [M] for [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)

	ArchAngel
		icon = 'monsters.dmi'
		icon_state="archangel"
		gold = 300
		HP = 3000
		see_invisible = 1
		MHP = 3000
		player = 0
		Dmg = 1000
		Def=95
		Expg = 600
		level = 15
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,10)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] hits [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)
	Basilisk
		icon = 'bassy.dmi'
		gold = 1000
		HP = 150000
		MHP = 150000
		player = 0
		Dmg = 10000
		Def= 8500
		Expg = 9000
		level = 300
		see_invisible = 1
		monster = 1
		NPC = 0
		New()
			. = ..()
			spawn(rand(10,30))
				Wander()
		proc/Wander()
			walk_rand(src,6)
			while(1)
				sleep(30)
				for(var/mob/M in oview(src)) if(M.client)
					walk(src,0)
					spawn()Attack(M)
					return
		proc/Attack(mob/Player/M)
			var/dmg = Dmg+rand(0,50)-M.Def
			while(get_dist(src,M)>1)
				sleep(4)
				if(!(M in oview(src)))
					spawn()Wander()
					return
				step_to(src,M)
			if(dmg<1)
				//hearers()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				hearers()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)