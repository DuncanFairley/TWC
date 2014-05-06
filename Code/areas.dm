/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
world
	//map_format=TILED_ICON_MAP

/************************************************
Common Room Areas
************************************************/
var/const
	GROUND_FLOOR = 1
	SEC_FLOOR_EAST = 2
	SEC_FLOOR_WEST = 3
	THIRD_FLOOR = 4
	FORTH_FLOOR = 5

proc/getFloor(destination)
	switch(destination)
		if("DADA")
			return GROUND_FLOOR
		if("Charms")
			return SEC_FLOOR_WEST
		if("COMC")
			return GROUND_FLOOR
		if("Trans")
			return THIRD_FLOOR
		if("Muggle Studdies")
			return GROUND_FLOOR
		if("HM Class East")
			return SEC_FLOOR_EAST
		if("HM Class West")
			return THIRD_FLOOR
		if("Duel Class")
			return FORTH_FLOOR
	world << "Error 3b07d"
var/curClass
area
	var/list/AI_directions
	var/location
	DEHQ
	AurorHQ
	hogwarts
		Entrance_Hall
			location = GROUND_FLOOR
			AI_directions = list(
							null,		// GROUND_FLOOR
							"vds3",		// SEC_FLOOR_EAST
							"dsa3",		// SEC_FLOOR_WEST
							"dsa3",		// THIRD_FLOOR
							"dsa3"		// FORTH_FLOOR
							)
		Great_Hall
			location = GROUND_FLOOR
			AI_directions = list(
							null,		// GROUND_FLOOR
							"vds3",		// SEC_FLOOR_EAST
							"dsa3",		// SEC_FLOOR_WEST
							"dsa3",		// THIRD_FLOOR
							"dsa3"		// FORTH_FLOOR
							)
		Defence_Against_the_Dark_Arts
			location = GROUND_FLOOR
			AI_directions = list(
							null,		// GROUND_FLOOR
							"vds3",		// SEC_FLOOR_EAST
							"dsa3",		// SEC_FLOOR_WEST
							"dsa3",		// THIRD_FLOOR
							"dsa3"		// FORTH_FLOOR
							)
		Charms
			location = SEC_FLOOR_WEST
			AI_directions = list(
							"4fsb4",		// GROUND_FLOOR
							"4fsb4",		// SEC_FLOOR_EAST
							null,		// SEC_FLOOR_WEST
							"gdf42",		// THIRD_FLOOR
							"gdf42"		// FORTH_FLOOR
							)
		Care_of_Magical_Creatures
			location = GROUND_FLOOR
			AI_directions = list(
							null,		// GROUND_FLOOR
							"vds3",		// SEC_FLOOR_EAST
							"dsa3",		// SEC_FLOOR_WEST
							"dsa3",		// THIRD_FLOOR
							"dsa3"		// FORTH_FLOOR
							)
		Transfiguration
			location = THIRD_FLOOR
			AI_directions = list(
							"fsdf24",		// GROUND_FLOOR
							"fsdf24",		// SEC_FLOOR_EAST
							"fsdf24",		// SEC_FLOOR_WEST
							null,		// THIRD_FLOOR
							"3fs45"		// FORTH_FLOOR
							)
		Bathroom
			location = THIRD_FLOOR
			AI_directions = list(
							"fsdf24",		// GROUND_FLOOR
							"fsdf24",		// SEC_FLOOR_EAST
							"fsdf24",		// SEC_FLOOR_WEST
							null,		// THIRD_FLOOR
							"3fs45"		// FORTH_FLOOR
							)
		Library
			location = GROUND_FLOOR
			AI_directions = list(
							null,		// GROUND_FLOOR
							"vds3",		// SEC_FLOOR_EAST
							"dsa3",		// SEC_FLOOR_WEST
							"dsa3",		// THIRD_FLOOR
							"dsa3"		// FORTH_FLOOR
							)
		Hufflepuff_Common_Room
			location = SEC_FLOOR_EAST
			AI_directions = list(
							"3fa3",		// GROUND_FLOOR
							null,		// SEC_FLOOR_EAST
							"3fa3",		// SEC_FLOOR_WEST
							"3fa3",		// THIRD_FLOOR
							"3fa3"		// FORTH_FLOOR
							)
		Ravenclaw_Common_Room
			location = SEC_FLOOR_WEST
			AI_directions = list(
							"4fsb4",		// GROUND_FLOOR
							"4fsb4",		// SEC_FLOOR_EAST
							null,		// SEC_FLOOR_WEST
							"gdf42",		// THIRD_FLOOR
							"gdf42"		// FORTH_FLOOR
							)
		Slytherin_Common_Room
			location = GROUND_FLOOR
			AI_directions = list(
							null,		// GROUND_FLOOR
							"vds3",		// SEC_FLOOR_EAST
							"dsa3",		// SEC_FLOOR_WEST
							"dsa3",		// THIRD_FLOOR
							"dsa3"		// FORTH_FLOOR
							)
		Gryffindor_Common_Room
			location = SEC_FLOOR_WEST
			AI_directions = list(
							"4fsb4",		// GROUND_FLOOR
							"4fsb4",		// SEC_FLOOR_EAST
							null,		// SEC_FLOOR_WEST
							"gdf42",		// THIRD_FLOOR
							"gdf42"		// FORTH_FLOOR
							)
		Dungeons
			location = GROUND_FLOOR
			AI_directions = list(
							null,		// GROUND_FLOOR
							"vds3",		// SEC_FLOOR_EAST
							"dsa3",		// SEC_FLOOR_WEST
							"dsa3",		// THIRD_FLOOR
							"dsa3"		// FORTH_FLOOR
							)
		Potions
			location = GROUND_FLOOR
			AI_directions = list(
							null,		// GROUND_FLOOR
							"vds3",		// SEC_FLOOR_EAST
							"dsa3",		// SEC_FLOOR_WEST
							"dsa3",		// THIRD_FLOOR
							"dsa3"		// FORTH_FLOOR
							)
		Hospital_Wing
			location = GROUND_FLOOR
			AI_directions = list(
							null,		// GROUND_FLOOR
							"vds3",		// SEC_FLOOR_EAST
							"dsa3",		// SEC_FLOOR_WEST
							"dsa3",		// THIRD_FLOOR
							"dsa3"		// FORTH_FLOOR
							)
		Muggle_Studdies
			location = GROUND_FLOOR
			AI_directions = list(
							null,		// GROUND_FLOOR
							"vds3",		// SEC_FLOOR_EAST
							"dsa3",		// SEC_FLOOR_WEST
							"dsa3",		// THIRD_FLOOR
							"dsa3"		// FORTH_FLOOR
							)
		Restricted_Section
			location = GROUND_FLOOR
			AI_directions = list(
							null,		// GROUND_FLOOR
							"vds3",		// SEC_FLOOR_EAST
							"dsa3",		// SEC_FLOOR_WEST
							"dsa3",		// THIRD_FLOOR
							"dsa3"		// FORTH_FLOOR
							)
		Detention
			location = GROUND_FLOOR
		Headmasters_Class_West
			name = "Headmaster's West-Wing Class"
			location = THIRD_FLOOR
			AI_directions = list(
							"fsdf24",		// GROUND_FLOOR
							"fsdf24",		// SEC_FLOOR_EAST
							"fsdf24",		// SEC_FLOOR_WEST
							null,		// THIRD_FLOOR
							"3fs45"		// FORTH_FLOOR
							)
		Headmasters_Class_East
			name = "Headmaster's East-Wing Class"
			location = SEC_FLOOR_EAST
			AI_directions = list(
							"vs35",		// GROUND_FLOOR
							null,		// SEC_FLOOR_EAST
							"vs35",		// SEC_FLOOR_WEST
							"vs35",		// THIRD_FLOOR
							"vs35"		// FORTH_FLOOR
							)
		East_Wing
			location = 0
			AI_directions = list(
							"3fa3",		// GROUND_FLOOR
							"2few",		// SEC_FLOOR_EAST
							"3fa3",		// SEC_FLOOR_WEST
							"3fa3",		// THIRD_FLOOR
							"3fa3"		// FORTH_FLOOR
							)
		West_Wing
			location = SEC_FLOOR_WEST
			AI_directions = list(
							"4fsb4",		// GROUND_FLOOR
							"4fsb4",		// SEC_FLOOR_EAST
							null,		// SEC_FLOOR_WEST
							"gdf42",		// THIRD_FLOOR
							"gdf42"		// FORTH_FLOOR
							)
		Meeting_Room
			location = SEC_FLOOR_EAST
			AI_directions = list(
							"3fa3",		// GROUND_FLOOR
							null,		// SEC_FLOOR_EAST
							"3fa3",		// SEC_FLOOR_WEST
							"3fa3",		// THIRD_FLOOR
							"3fa3"		// FORTH_FLOOR
							)
		Third_Floor
			location = THIRD_FLOOR
			AI_directions = list(
							"fsdf24",		// GROUND_FLOOR
							"fsdf24",		// SEC_FLOOR_EAST
							"fsdf24",		// SEC_FLOOR_WEST
							null,		// THIRD_FLOOR
							"3fs45"		// FORTH_FLOOR
							)
		Study_Hall
			location = THIRD_FLOOR
			AI_directions = list(
							"fsdf24",		// GROUND_FLOOR
							"fsdf24",		// SEC_FLOOR_EAST
							"fsdf24",		// SEC_FLOOR_WEST
							null,		// THIRD_FLOOR
							"3fs45"		// FORTH_FLOOR
							)
		Forth_Floor
			location = FORTH_FLOOR
			AI_directions = list(
							"fgd423",		// GROUND_FLOOR
							"fgd423",		// SEC_FLOOR_EAST
							"fgd423",		// SEC_FLOOR_WEST
							"fgd423",		// THIRD_FLOOR
							null		// FORTH_FLOOR
							)
		Duel_Class
			location = FORTH_FLOOR
			AI_directions = list(
							"fgd423",		// GROUND_FLOOR
							"fgd423",		// SEC_FLOOR_EAST
							"fgd423",		// SEC_FLOOR_WEST
							"fgd423",		// THIRD_FLOOR
							null		// FORTH_FLOOR
							)

		Duel_Arenas
			Gryffindor
				location = SEC_FLOOR_WEST
				AI_directions = list(
							"4fsb4",		// GROUND_FLOOR
							"4fsb4",		// SEC_FLOOR_EAST
							null,		// SEC_FLOOR_WEST
							"gdf42",		// THIRD_FLOOR
							"gdf42"		// FORTH_FLOOR
							)
			Hufflepuff
				location = SEC_FLOOR_EAST
				AI_directions = list(
							"3fa3",		// GROUND_FLOOR
							null,		// SEC_FLOOR_EAST
							"3fa3",		// SEC_FLOOR_WEST
							"3fa3",		// THIRD_FLOOR
							"3fa3"		// FORTH_FLOOR
							)
			Slytherin
				location = GROUND_FLOOR
				AI_directions = list(
							null,		// GROUND_FLOOR
							"vds3",		// SEC_FLOOR_EAST
							"dsa3",		// SEC_FLOOR_WEST
							"dsa3",		// THIRD_FLOOR
							"dsa3"		// FORTH_FLOOR
							)
			Ravenclaw
				location = SEC_FLOOR_WEST
				AI_directions = list(
							"4fsb4",		// GROUND_FLOOR
							"4fsb4",		// SEC_FLOOR_EAST
							null,		// SEC_FLOOR_WEST
							"gdf42",		// THIRD_FLOOR
							"gdf42"		// FORTH_FLOOR
							)
			Main_Arena_Lobby
				AI_directions = list(
							"zvsd32",		// GROUND_FLOOR
							"zvsd32",		// SEC_FLOOR_EAST
							"zvsd32",		// SEC_FLOOR_WEST
							"zvsd32",		// THIRD_FLOOR
							"zvsd32"		// FORTH_FLOOR
							)
			Main_Arena_Top
				AI_directions = list(
							"zvsd32",		// GROUND_FLOOR
							"zvsd32",		// SEC_FLOOR_EAST
							"zvsd32",		// SEC_FLOOR_WEST
							"zvsd32",		// THIRD_FLOOR
							"zvsd32"		// FORTH_FLOOR
							)
			Main_Arena_Bottom
				AI_directions = list(
							"zvsd32",		// GROUND_FLOOR
							"zvsd32",		// SEC_FLOOR_EAST
							"zvsd32",		// SEC_FLOOR_WEST
							"zvsd32",		// THIRD_FLOOR
							"zvsd32"		// FORTH_FLOOR
							)
				Entered(atom/movable/Obj,atom/OldLoc)
					if(ismob(Obj))
						Obj << infomsg("This section has an old form of dueling enabled. Each projectile will last a full 2 seconds regardless of whether it hits a wall or other blockage.")
			Duel_Class
				location = FORTH_FLOOR
				AI_directions = list(
							"fgd423",		// GROUND_FLOOR
							"fgd423",		// SEC_FLOOR_EAST
							"fgd423",		// SEC_FLOOR_WEST
							"fgd423",		// THIRD_FLOOR
							null		// FORTH_FLOOR
							)

		Entered(mob/M)
			..()
			if(ismob(M))
				if(M.key)
					if(classdest)
						if(classdest.loc.loc == src)
							M.client.images = list()
							M.classpathfinding = 0
							for(var/obj/O in M.client.screen)
								if(O.type == /obj/hud/class)
									M.client.screen.Remove(O)

var/mob/classdest = null
mob
	proc
		Class_Path_to()
			var/area/startarea = src.loc.loc
			var/area/destarea = classdest.loc.loc
			var/path[]
			if(startarea.location == destarea.location)
				path = AStar(loc,classdest.loc,/turf/proc/AdjacentTurfs,/turf/proc/Distance)
			else
				var/list/L = startarea.AI_directions //The methods of travel for the current area
				if(!length(L))
					usr << "A path cannot be mapped to the class from this area. Please go to a main area of Hogwarts and try again."
					var/obj/hud/class/C = null
					for(var/obj/O in usr.client.screen)
						if(O.type == /obj/hud/class)
							C = O
					usr.classpathfinding = 0
					if(!classdest)
						if(C) usr.client.screen.Remove(C)
					else
						if(C) C.icon_state = "0"
					usr.client.images = list()
					return 0
				var/turf/T = locate(L[getFloor(curClass)]) //the teleport turf on your current floor
				path = AStar(loc,T,/turf/proc/AdjacentTurfs,/turf/proc/Distance)
			client.images = list()
			sleep()
			if(length(path))
				for(var/i=1,i<length(path),i++)
					if(i % 4 == 0)
						var/turf/A = path[i]
						if(A.loc != classdest.loc.loc)
							var/image/arrow = image('arrows.dmi',A)
							arrow.layer = 6
							usr << arrow
				return 1
			else
				usr << "A path cannot be mapped to the class from this area. Please go to a main area of Hogwarts and try again."
				usr.classpathfinding = 0
				var/obj/hud/class/C = null
				for(var/obj/O in usr.client.screen)
					if(O.type == /obj/hud/class)
						C = O

				if(!classdest)
					if(C) usr.client.screen.Remove(C)
				else
					if(C) C.icon_state = "0"
				usr.client.images = list()
				return 0

area
	arenas
		MapTwo
			Auror/Exit(atom/movable/O)
				if(ismob(O))
					if(currentArena)
						if(currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
			DE/Exit(atom/movable/O)
				if(ismob(O))
					if(currentArena)
						if(currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
		MapThree
			WaitingArea
			PlayArea
		MapOne
			Gryff/Exit(atom/movable/O)
				if(ismob(O))
					if(currentArena)
						if(currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
			Raven/Exit(atom/movable/O)
				if(ismob(O))
					if(currentArena)
						if(currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
			Huffle/Exit(atom/movable/O)
				if(ismob(O))
					if(currentArena)
						if(currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
			Slyth/Exit(atom/movable/O)
				if(ismob(O))
					if(currentArena)
						if(currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
area
	CommonRooms/GryffindorCommon
		layer=6
		Entered(mob/Player/M)
			if(!isplayer(M)) return
			if(M.House=="Gryffindor")
				M.loc = locate(82,28,21)
				M << "<b>The Portrait swings open</b>"
				return
			else
				M.followplayer = 0
				M.loc = locate(82,22,21)
				alert("The Portrait pushes you back")
area
	CommonRooms/GryffindorCommon_Back
		layer=6
		Entered(mob/Player/M)
			if(!isplayer(M)) return
			M.loc = locate(82,22,21)
area
	DuelAreas
		Raven
			Entered(mob/Player/M)
				if(!isplayer(M)) return
				M.DuelRespawn = 4
			Exited(mob/Player/M)
				if(!isplayer(M)) return
				M.DuelRespawn = 0
		Gryff
			Entered(mob/Player/M)
				if(!isplayer(M)) return
				M.DuelRespawn = 3
			Exited(mob/Player/M)
				if(!isplayer(M)) return
				M.DuelRespawn = 0
		Slyth
			Entered(mob/Player/M)
				if(!isplayer(M)) return
				M.DuelRespawn = 5
			Exited(mob/Player/M)
				if(!isplayer(M)) return
				M.DuelRespawn = 0
		Huffle
			Entered(mob/Player/M)
				if(!isplayer(M)) return
				M.DuelRespawn = 6
			Exited(mob/Player/M)
				if(!isplayer(M)) return
				M.DuelRespawn = 0

area
	CommonRooms/RavenclawCommon
		layer=6
		Entered(mob/Player/M)
			if(!isplayer(M)) return
			if(M.House=="Ravenclaw")
				M.loc = locate(68,27,21)
				M << "<b>The Stone Wall shifts open</b>"
				return
			else
				M.followplayer = 0
				M.loc = locate(68,22,21)
				alert("The Neptune statue pushes you back")
area
	CommonRooms/RavenclawCommon_Back
		layer=6
		Entered(mob/Player/M)
			if(!isplayer(M)) return
			M.loc = locate(68,22,21)

area
	CommonRooms/HufflepuffCommon
		layer=6
		Entered(mob/Player/M)
			if(!isplayer(M)) return
			if(M.House=="Hufflepuff")
				M.loc = locate(70,86,21)
				M << "<b>The Stone Wall moves aside open</b>"
				return
			else
				M.followplayer = 0
				M.loc = locate(70,81,21)
				alert("A gust of wind pushes you back")
area
	CommonRooms/HufflepuffCommon_Back
		layer=6
		Entered(mob/Player/M)
			if(!isplayer(M)) return
			M.loc = locate(70,81,21)

area
	CommonRooms/SlytherinCommon
		layer=6
		Entered(mob/Player/M)
			if(!isplayer(M)) return
			if(M.House=="Slytherin")
				M.loc = locate(14,85,21)
				M << "<b>The Stone Floor opens and you fall downwards.</b>"
				return
			else
				M.followplayer = 0
				M.loc = locate(17,77,21)
				alert("The floor shifts and you stumble backwards.")
area
	CommonRooms/SlytherinCommon_Back
		layer=6
		Entered(mob/Player/M)
			if(!isplayer(M)) return
			M.loc=locate(17,77,21)



/************************************************
************************************************/


turf
	Barrels
		icon='turf.dmi'
		icon_state="barrels"
		density=1
		verb
			Examine()
				set src in oview(3)
				usr << "A big ol' pile of barrels."


obj


	bigbluechair
		name="Big Blue Chair"
		icon='Thrones.dmi'
		icon_state="blue"
		density=0
		dontsave=1
		wlable=0
	biggreenchair
		name="Big Green Chair"
		icon='Thrones.dmi'
		icon_state="green"
		density=0
		dontsave=1
		wlable=0
	bigtealchair
		name="Big Teal Chair"
		icon='Thrones.dmi'
		icon_state="teal"
		density=0
		dontsave=1
		wlable=0
	bigwhitechair
		name="Big White Chair"
		icon='Thrones.dmi'
		icon_state="white"
		density=0
		dontsave=1
		wlable=0
	bigblackchair
		name="Big Black Chair"
		icon='Thrones.dmi'
		icon_state="black"
		density=0
		wlable=0
		dontsave=1
	bigpurplechair
		name="Big Purple Chair"
		icon='Thrones.dmi'
		icon_state="purple"
		density=0
		dontsave=1
		wlable=0
	bigredchair
		name="Big Red Chair"
		icon='Thrones.dmi'
		icon_state="red"
		density=0
		dontsave=1
		wlable=0

//AREAS

mob/var/DuelRespawn

area
	OldAuror

turf
	Rabbit_Hole
		icon='hole.dmi'
		Entered(mob/Player/M)
			if(M.monster==1)
				return
			else
				M.loc=locate(26,70,7)

turf
	rift1
		name="Rift"
		icon='tele.dmi'
		icon_state="red"
		Entered(mob/Player/M)
			if(M.monster==1)
				return
			else
				M.loc=locate(26,70,7)

turf
	rift2
		name="Rift"
		icon='tele.dmi'
		icon_state="blue"
		Entered(mob/Player/M)
			if(M.monster==1)
				return
			else
				M.loc=locate(26,70,7)

turf
	rift3
		name="Rift"
		icon='tele.dmi'
		icon_state="gold"
		Entered(mob/Player/M)
			if(M.monster==1)
				return
			else
				M.loc=locate(26,70,7)

turf
	rift4
		name="Rift"
		icon='tele.dmi'
		icon_state="purple"
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(26,70,7)

turf
	rift5
		name="Rift"
		icon='tele.dmi'
		icon_state="green"
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(26,70,7)

turf
	rift6
		name="Rift"
		icon='tele.dmi'
		icon_state="orange"
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(26,70,7)

turf
	rift7
		name="Rift"
		icon='tele.dmi'
		icon_state="pink"
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(26,70,7)
area
	To_Fourth_Floor
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(45,89,23)

area
	Duel_Room
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.DuelRespawn=1

area
	Leave_Duel_Room
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.DuelRespawn=0

area
	From_Fourth_Floor
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(16,58,22)


area
	To_Owlery
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(42,11,23)

area
	From_Owlery
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(43,36,23)

turf
	lordcave
		name="Hole"
		icon='hole.dmi'
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				if(usr.foundlord==1)
					var/mob/Player/user = usr
					var/obj/items/wearable/brooms/B = locate() in user.Lwearing
					if(B)
						B.Equip(user,0)
					M.density = 0
					M.Move(locate(62,72,7))
					M.density = 1
					M.flying = 0
				else
					alert("A charm keeps you from going down the hole")

area
	Cave_entrance
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(16,23,3)





area
	To_Santa
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(74,3,7)

area
	From_Santa
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(31,98,18)

area
	fromfred
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(87,29,18)

turf
	ror1
		Enter(atom/movable/O)
			if(density && isplayer(O) && O:ror == 1)
				return 1
			else
				.=..()

		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(M.ror==1)
				M.loc=locate(39,59,7)
			else if(M.ror==4)
				M.loc=locate(70,60,7)
			else
				return

turf
	ror2
		Enter(atom/movable/O)
			if(density && isplayer(O) && O:ror == 2)
				return 1
			else
				.=..()

		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(M.ror==2)
				M.loc=locate(39,59,7)
			else if(M.ror==4)
				M.loc=locate(70,60,7)
			else
				return

turf
	ror3
		Enter(atom/movable/O)
			if(density && isplayer(O) && O:ror == 3)
				return 1
			else
				.=..()

		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(M.ror==3)
				M.loc=locate(39,59,7)
			else if(M.ror==4)
				M.loc=locate(70,60,7)
			else
				return

area
	tofred
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(M.talkedtofred==3)
				M.loc=locate(89,27,8)
			else
				M.loc=locate(30,12,8)

area
	fromauror
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(87,69,22)

area
	From_DA
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(99,4,25)

area
	To_Grin
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(30,60,20)

area
	From_Grin
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(45,82,26)

area
	Back_From_Quid
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(48,35,14)

area
	Gryff1
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(9,97,13)

area
	Raven1
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(12,57,13)

area
	Slyth1
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(83,62,13)

area
	Huffle1
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(47,97,13)

area
	Gryff2
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(65,63,14)

area
	Raven2
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(33,45,14)

area
	Slyth2
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(33,63,14)

area
	Huffle2
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(65,45,14)

area
	Desert
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.density = 0
				M.Move(locate(rand(4,97),rand(4,97),4))
				M.density = 1

area
	To_Owlery_Broom
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				if(M.flying==1)
					M.flying=0
					M.density=1
					M.icon_state=""
					M << "You land gently."
				M.loc=locate(42,5,23)

area
	To_SecondfloorRaven
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(95,20,22)

area
	From_SecondfloorRaven
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(35,19,21)

area
	Ander_To
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(89,36,22)

area
	Ander_To2
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(91,3,23)
area
	Ander_Back
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(93,91,21)
area
	IanHouse2
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(86,2,13)
area
	IanHouse1
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(71,38,17)


	Cave_exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(48,32,1)
	cave_exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(51,79,4)
	cave_entrance
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(69,14,3)

	Volcano
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(19,9,8)
	Volcano_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(56,84,9)
	Ice_Cavern
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(50,2,14)
	Ice_Cavern_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(45,20,13)

	Zydoc_End
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(94,usr.y,11)
	Zydoc_Land
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(7,usr.y,6)
	Forest_End
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(7,usr.y,11)
	Forest_Land
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(99,usr.y,12)
	Ice_End
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,7,11)
	Ice_Land
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,99,13)

	Dark_Elf_KD
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,6,17)
	Dark_Elf_KD_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,94,12)
	Mine
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(27,11,16)
	Mine_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(28,88,7)
	Tunder_Path
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,7,15)
	Thunder_Path_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,94,11)
	Tunder_Field
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,7,18)
	Azkaban_Enter
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(58,1,25)
	Sylar_Enter
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(75,11,1)
	ShriekingShack_Enter
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(46,1,13)
	ShriekingShack_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(11,89,15)


	Scorpion_Cave
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(69,10,19)
	Scorpion_Cave_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(16,70,18)
	SilverbloodLevel2
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(19,89,2)
	SilverbloodLevel1
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(32,22,2)
	SilverbloodEnter
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				if(M.flying==1)
					M.loc=locate(49,30,3)
					M<<"You may not fly inside Silverblood."
				else
					M.loc=locate(24,2,2)
	SilverbloodExit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(49,34,3)
	SilverbloodGroundExit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(14,97,18)

	Arena_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(50,1,15)
	Battle_Area
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(92,1,16)
	Battle_Area_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(1,21,15)

	mainhall2
		Entered(mob/Player/M)
			if(M.monster==1)
				return
			else
				M.loc=locate(22,62,21)

	Barn2
		Entered(mob/Player/M)
			M.loc=locate(48,2,21)


	HMG


	Desert1
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(2,55,5)
	Desert_back
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(99,50,4)
	Desert2
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(34,2,6)
	Desert2_back
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(41,99,4)
	Archangel_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,8,23)
	CoS_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(63,52,22)
				M<<"You climb back up the tunnel and into the Bathroom."

	Ghoul_Area_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(8,usr.y,23)
	DE_Enter
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(35,2,22)
	DE_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(57,98,22)

	Duel_Arena_Enter
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(12,26,22)
				M.DuelRespawn=2
	Duel_Arena_Enter2
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(13,26,22)
				M.DuelRespawn=2
	Duel_Arena_Exit1
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(2,35,21)
				M.DuelRespawn=0
	Duel_Arena_Exit2
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(2,34,21)
				M.DuelRespawn=0
	Holo_Room_Enter
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(74,25,22)
				alert(usr,"Welcome to the Holo-Room. The teacher of this class will be in control of the Holograms. Train carefully!","Holo-Room Computer")
	Holo_Room_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(69,45,21)
	Holoalert
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(41,62,21)

area
	Cata1_Enter
		Entered(mob/Player/M)
			if(!istype(M, /mob)) return
			if(M.monster==1)
				return
			else
				M.loc=locate(44,62,7)

	Cata1_Return
		Entered(mob/Player/M)
			if(!istype(M, /mob)) return
			if(M.monster==1)
				return
			else
				M.loc=locate(9,71,21)

mob
	var
		hogwarts

area
	Hogwarts_Enter
		Entered(mob/Player/M)
			if(!istype(M, /mob/Player)) return
			if(M.monster==1)
				return
			else
				M.loc=locate(13,25,21)

turf
	Hogwarts

		Entered(mob/Player/M)
			if(!istype(M, /mob/Player)) return
			M.loc=locate(13,25,21)
			if(usr.flying == 1)
				usr << "You land gently."
				usr.flying = 0
				usr.density = 1
				usr.icon_state="Blank"
	Hogwarts_Exit

		Entered(mob/Player/M)
			if(!istype(M, /mob)) return
			M.loc=locate(50,49,15)



mob/var/tmp
	flying = 0




turf
	Arena

	aurortrap
		Entered(mob/Player/M)
			if(istype(M,/mob))
				for(var/mob/A in world)
					if(A.Auror) A << "<i><font color=white>One of the Auror HQ entrance traps has been set off.</font></i>"
				M.Move(locate(38,78,26))
	detrap
		Entered(mob/Player/M)
			if(istype(M,/mob))
				for(var/mob/A in world)
					if(A.DeathEater) A << "<i><font color=white>One of the DE HQ entrance traps has been set off.</font></i>"
				M.Move(locate(37,17,13))





////First you could jst lay this turf on everything that you dont wont people to go
////through (fly through)

/*
area
	nofly
		Entered(mob/Player/M)
			if(M.flying==1)
				M.flying=0
				M<<"Some invisible force knocks you off your broom."
				M.density=100
				M.icon_state=""
				return
*/

area
	blindness
		layer=3
		Enter(mob/Player/M)
			if(istype(M, /mob))
				if(M.key)
					M.sight |= BLIND
					M.sight &= ~SEE_SELF
					for(var/mob/Player/A in world)
						if(A.key)
							if(A.client.eye == M)
								A.client.eye = A
			return 1
		Exited(mob/Player/M)
			if(istype(M, /mob))
				if(M.key)
					M.sight |= SEE_SELF
					M.sight &= ~BLIND
			return

area
	hogwarts
		DiagonAlley
		Azkaban
		DEHQ
		AurorHQ
		DuelArena
		Desert
		Pyramid
		CoS
		JulyMaze

		Class_Paths
			DADAClass

			COMCClass

			TransClass

			CharmsClass

			HMClass

			AnderClass

			DuelClass




//or jst put this at the end of the turf you dont wont peeps to go through
//		Enter(O)
//			if(istype(O,/mob))
//				if(O:Gm == 1)
//					return 1
//				else
//					return 0
