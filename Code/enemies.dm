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

area
	newareas
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
			Ratcellar
			Chamber_of_Secrets
		Enter(atom/movable/O)
			. = ..()
			if(.)
				if(istype(O,/mob))
					if(O:client)
						for(var/mob/NPC/Enemies/M in locate(type))
							if(!M:activated)spawn()M:Wander()
							//if(istype(M,/mob/NPC/Enemies))
							//	if(M.loc.loc.type == type)


		//If you run into a wall and aren't ACTUALLY out've the area, Exit() still stops all the monsterz
		Exit(atom/movable/O)
			if(istype(O,/mob/NPC))
				if(O:removeoMob)
					return ..()
				return 0
			if(ismob(O))
				if(O:client)
					var/turf/t = get_step(O,O.dir)
					if(!(t.density && O.density))
						var/isempty = 1
						for(var/mob/M in locate(type))
							if(M.client && M != O)
								isempty = 0
						if(isempty)
							for(var/mob/M in locate(type))
								if(istype(M,/mob/NPC/Enemies))
									M:activated = 0
						return ..()
			else
				return ..()
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
		Enemies
			player = 0
			Gm = 1
			monster = 1
			NPC = 1
//////Monsters///////
			Rat
				icon = 'monsters.dmi'
				icon_state="demon rat"
				gold = 12
				HP = 180
				MHP = 180
				Dmg = 60
				Expg = 36
				ratpoints = 1
				level = 1
			Demon_Rat
				icon = 'monsters.dmi'
				icon_state="demon rat"
				gold = 24
				HP = 360
				MHP = 360
				Dmg = 120
				Expg = 37
				level = 35
			Pixie
				icon = 'monsters2.dmi'
				icon_state="pixie"
				gold = 60
				HP = 900
				MHP = 900
				Def=0
				Dmg = 300
				Expg = 65
				level = 70
			Dog
				icon = 'NewMobs.dmi'
				icon_state="dog"
				gold = 42
				HP = 630
				MHP = 630
				Def = 0
				Dmg = 210
				Expg = 40
				level = 105
			Snake
				icon = 'Animagus.dmi'
				icon_state="Snake"
				HP = 540
				MHP = 540
				Dmg = 180
				gold = 36
				Def=60
				Expg = 39
				level = 140
			Snake_  //SUMMONED
				icon = 'Animagus.dmi'
				icon_state="Snake"
				HP = 300
				MHP = 500
				Dmg = 125
				Def=60
				level = 15
			Wolf
				icon = 'monsters2.dmi'
				icon_state="wolf"
				gold = 51
				HP = 765
				MHP = 765
				Def=0
				Dmg = 255
				Expg = 50
				level = 175
			Acromantula
				icon = 'monster.dmi'
				icon_state="Spider"
				gold = 90
				HP = 1350
				MHP = 1350
				Dmg = 450
				Def=15
				Expg = 76
				level = 210
			Floating_Eye
				icon = 'monsters.dmi'
				icon_state="eye"
				gold = 165
				HP = 2475
				MHP = 2475
				Dmg = 825
				Def=80
				Expg = 209
				level = 305
			Troll
				icon = 'monsters2.dmi'
				icon_state="troll"
				gold = 175
				HP = 3000
				MHP = 3000
				Def=10
				Dmg = 930
				Expg = 310
				level = 85
			House_Elf
				icon = 'monsters2.dmi'
				icon_state="houseelf"
				gold = 0
				HP = 200
				MHP = 200
				Def=10
				Dmg = 150
				Expg = 0
				level = 5
			Stone_Golem
				icon = 'monsters.dmi'
				icon_state="stonegolem"
				gold = 75
				HP = 500
				MHP = 500
				Dmg = 200
				Def=20
				Expg = 75
				level = 6
			Dementor
				icon = 'monsters2.dmi'
				icon_state="Dementor"
				gold = 255
				HP = 3825
				MHP = 3825
				Dmg = 1275
				Def=29
				Expg = 840
				level = 300
			Dementor_ /////SUMMONED/////
				icon = 'monsters2.dmi'
				icon_state="Dementor"
				gold = 0
				Expg = 0
				HP = 500
				MHP = 500
				Dmg = 200
				Def=20
				level = 6
			Stickman_ ///SUMMONED///
				icon = 'stickman.dmi'
				gold = 0
				HP = 50
				MHP = 50
				Def=0
				Dmg = 50
				Expg = 10
				level = 2
			Bird_    ///SUMMONED///
				icon = 'monsters2.dmi'
				icon_state="bird"
				gold = 0
				HP = 10000
				MHP = 500
				Dmg = 200
				Def=20
				level = 6
				Wander()
					walk_rand(src,6)
					while(1)
						sleep(30)
						for(var/mob/M in oview(src)) if(M.client)
							walk(src,0)
							spawn()Attack(M)
							return
				Attack(mob/Player/M)
					while(get_dist(src,M)>1)
						sleep(4)
						if(!(M in oview(src)))
							spawn()Wander()
							return
						step_to(src,M)
					if(M.HP>=(M.MHP+M.extraMHP))
						return
					else
						M.HP += ((M.HP/8)+rand(1,50))
						M.updateHPMP()
						if(M.HP > (M.MHP+M.extraMHP)) M.HP = M.MHP+M.extraMHP
						view()<<"<SPAN STYLE='color: red'>[src] heals [M]!</SPAN>"
					spawn(10)Attack(M)
			Fire_Bat
				icon = 'monsters.dmi'
				icon_state="firebat"
				density = 0
				gold = 111
				HP = 1667
				MHP = 1667
				Dmg = 555
				Def=35
				Expg = 89
				level = 240
				Attack(mob/M)
					while(get_dist(src,M)>5)
						if(!activated)
							spawn(rand(10,30))
								walk_rand(src,11)
							return
						if(!(M in oview(src)))
							spawn()Wander()
							return
						step_to(src,M)
						sleep(4)
					dir=get_dir(src,M)
					var/obj/enemyfireball/S=new(src.loc)
					S.caster = src
					walk(S,dir,2)
					//spawn(30)M.Death_Check(src)
					sleep(10)
					for(var/mob/A in oview(src)) if(A.client)
						walk(src,0)
						if(rand(1,4) == 4)step_rand(src)
						spawn()Attack(A)
						return
			Fire_Golem
				icon = 'monsters.dmi'
				icon_state="firegolem"
				gold = 132
				HP = 1980
				MHP = 1980
				Dmg = 660
				Def=30
				Expg = 115
				level = 275
				Attack(mob/M)
					while(get_dist(src,M)>5)
						sleep(4)
						if(!activated)
							spawn()
								walk_rand(src,11)
							return
						if(!(M in oview(src)))
							spawn()Wander()
							return
						step_to(src,M)
					dir=get_dir(src,M)
					var/obj/enemyfireball/S=new(src.loc)
					S.caster = src
					walk(S,dir,2)
					//spawn(30)M.Death_Check(src)
					sleep(10)
					for(var/mob/A in oview(src)) if(A.client)
						walk(src,0)
						if(rand(1,4) == 4)step_rand(src)
						spawn()Attack(A)
						return
			Slug
				icon='NewMobs.dmi'
				icon_state="slug"
				monster=1
				HP=25
				gold=0
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
				gold = 189
				HP = 2835
				MHP = 2835
				Dmg = 945
				Def=95
				Expg = 420
				level = 375
			Water_Elemental
				icon = 'monster.dmi'
				icon_state="water elemental"
				gold = 195
			//	HP = 2925
				//MHP = 2925
				//Dmg = 300//975
				//Def=80
				Expg = 510
				level = 405
			Fire_Elemental
				icon = 'monster.dmi'
				icon_state="fire elemental"
				gold = 204
				HP = 3060
				MHP = 3060
				Dmg = 1020
				Def=80
				Expg = 530
				level = 440
			Wyvern
				icon = 'monster.dmi'
				icon_state="wyvern"
				gold = 222
				HP = 3330
				MHP = 3330
				Dmg = 1110
				Def=80
				Expg = 620
				level = 475
				monster = 1
				NPC = 0
			Basilisk
				icon = 'bassy.dmi'
				gold = 6000
				HP = 90000
				MHP = 90000
				Dmg = 30000
				Def= 8500
				Expg = 12000
				level = 2000
				HPmodifier = 3
				DMGmodifier = 3
		New()
			. = ..()
			Dmg = round(DMGmodifier * ((src.level -1) + 5))
			MHP = round(HPmodifier * (4 * (src.level - 1) + 200))
			gold = round(src.level / 2)
			Expg = round(src.level * 1.3)
			HP = MHP
			spawn(rand(10,30))
				walk_rand(src,11)
//NEWMONSTERS	.
		proc/Wander()
			if(removeoMob)
				return
			activated=1
			walk_rand(src,11)
			while(activated)
				sleep(4)
				if(!activated) return
				sleep(4)
				if(!activated) return
				sleep(4)
				if(!activated) return
				sleep(4)
				if(!activated) return
				sleep(3)
				if(!activated) return
				for(var/mob/M in ohearers(src)) if(M.key && M.loc.loc == src.loc.loc)
					//walk(src,0)
					Attack(M)
					return
		proc/ReturnToStart()
			var/turf/origloc = initial(src.loc)
			if(src.loc.loc == origloc.loc)
				ShouldIBeActive()
			else
				if(src.z == origloc.z)
					src.density = 0
					while(src.loc.loc != origloc.loc)
						sleep(1)
						step_towards(src,origloc)
					src.density = 1
				else
					src.loc = origloc
				ShouldIBeActive()
		proc/ShouldIBeActive()
			for(var/mob/M in src.loc.loc)
				if(M.key)
					src.activated = 0
					sleep(6)
					src.Wander()
					return
			walk_rand(src,11)
		proc/BlindAttack()//removeoMob
			if(!src.removeoMob)
				return
			for(var/mob/M in view(1,src))
				if(M.key)
					var/dmg = Dmg+extraDmg+rand(0,4)
					if(dmg<1)
						//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
					else
						M.HP -= dmg
						view(M)<<"<SPAN STYLE='color: red'>[src] attacks [M] and causes [dmg] damage!</SPAN>"
						if(src.removeoMob)
							spawn() M.Death_Check(src.removeoMob)
						else
							spawn() M.Death_Check(src)
					break
			sleep(15)
			BlindAttack()
		proc/Attack(mob/M)
			var/dmg = Dmg+extraDmg+rand(0,4)
			if(M.level > src.level)
				dmg -= dmg * ((M.level-src.level)/100)
			else if(M.level < src.level)
				dmg += dmg * ((src.level-M.level)/200)
			dmg = round(dmg)
			while(get_dist(src,M)>1)
				sleep(5)
				if(!activated)
					walk(src,0)
					if(!removeoMob)
						walk_rand(src,11)
					else
						spawn()BlindAttack()
					return
				if(!(M in oview(src)))
					sleep(6)
					spawn()Wander()
					return
				if(!step_to(src,M))
					for(var/mob/A in view())
						if(A.client&& A.loc.loc == src.loc.loc && A != M)
							spawn()Attack(A)
							return
					sleep(5)
					walk(src,0)
					step_towards(src,M)
			if(dmg<1)
				//view(M)<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view(M)<<"<SPAN STYLE='color: red'>[src] attacks [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			sleep(10)
			for(var/mob/A in oview(src))
				if(A.client)
					spawn()Attack(A)
					return
			if(activated)
				sleep(2)
				Wander()
			else
				walk(src,0)
				walk_rand(src,11)

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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] jabs [M] and causes [dmg] damage!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] attacks [M] and causes [dmg] damage!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] attacks [M] and causes [dmg] damage!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] attacks [M] and causes [dmg] damage!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] attacks [M] and causes [dmg] damage!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s sticky stick-ness doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] sticks [M] with a stick and causes [dmg] damage!</SPAN>"
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
				view()<<"<SPAN STYLE='color: red'>[src] heals [M]!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
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
					view()<<"<SPAN STYLE='color: blue'>[src]'s bash doesnt even faze [E]</SPAN>"
				else
					E.HP -= damage
					view()<<"<SPAN STYLE='color: red'>[src] bashes [E] for [damage] damage!</SPAN>"
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
					view()<<"<SPAN STYLE='color: blue'>[src]'s sting doesnt even faze [E]</SPAN>"
				else
					E.HP -= damage
					view()<<"<SPAN STYLE='color: red'>[src] stings [E] for [damage] damage!</SPAN>"
					var/poisoning=rand(0,3)
					if(poisoning==3)
						view()<<"<SPAN STYLE='color: red'>[src]'s sting has poisoned [E]!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] attacks [M] for [dmg] damage!</SPAN>"
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
				view()<<"<SPAN STYLE='color: blue'>[src]'s blasts don't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] blows win at [M] for [dmg] damage!</SPAN>"
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
				view()<<"<SPAN STYLE='color: blue'>[src]'s blasts don't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] blows wind at [M] for [dmg] damage!</SPAN>"
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
				view()<<"<SPAN STYLE='color: blue'>[src]'s burns don't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] burns [M] for [dmg] damage!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s attack doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] hits [M] and causes [dmg] damage!</SPAN>"
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
				//view()<<"<SPAN STYLE='color: blue'>[src]'s bite doesn't even faze [M]</SPAN>"
			else
				M.HP -= dmg
				view()<<"<SPAN STYLE='color: red'>[src] bites [M] and causes [dmg] damage!</SPAN>"
				spawn()M.Death_Check(src)
			spawn(10)Attack(M)