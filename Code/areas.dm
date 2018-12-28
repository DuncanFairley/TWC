/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

teleportNode
	var
		list/nodes
		list/areas
		name
		active = FALSE

	proc
		AdjacentNodes()
			return nodes
		Distance(teleportNode/t)
			if(t in nodes) return 1
			return 10

		Entered(atom/movable/Obj, area/area)
			active++

			if(active==1)
				for(var/area/a in areas)
					if(!a.containsMonsters || a.active || area == a) continue

					for(var/mob/Enemies/M in a)
						if(M.state == M.INACTIVE)
							M.ChangeState(M.origloc ? M.WANDER : M.SEARCH)

		Exited(atom/movable/Obj, area/area)
			if(active <= 0) return

			if(--active <= 0)
				for(var/area/a in areas)
					if(!a.containsMonsters) continue
					a.active = 0
					for(var/mob/Enemies/M in a)
						M.ChangeState(M.INACTIVE)


area
	Entered(atom/movable/O, atom/oldloc)
		if(isplayer(O))
			var/area/a
			if(oldloc && isturf(oldloc)) a = oldloc.loc

			if(a && a != src &&  a.region)
				if(!(src in a.region.areas))
					if(region)
						region.Entered(O, src)
					a.region.Exited(O, a)
			else if(region)
				region.Entered(O, src)
		.=..()

proc
	AccessibleAreas(turf/t)
		var/ret[] = block(locate(max(t.x-1,1),max(t.y-1,1),t.z),locate(min(t.x+1,world.maxx),min(t.y+1,world.maxy),t.z)) - t
		for(var/turf/i in ret)
			if(i.density || istype(i, /turf/blankturf) || (locate(/obj/teleport) in i))
				ret -= i

			else
				var/area/a = i.loc
				if(a.name == "area" || a.name == "hogwarts")
					ret -= i
		return ret

teleportMap
	var/list/teleports

	proc/init()
		var/count = 0
		teleports = list()

		var/list/teleportPaths = list()

		for(var/obj/teleportPath/p in world)
			teleportPaths += p

		while(teleportPaths.len > 0)

			var/obj/teleportPath/path = teleportPaths[1]
			teleportPaths -= path

			var/teleportNode/node = new
			node.name = "[++count]"

			node.nodes = list()
			node.areas = list()

			var/Region/r = new(path.loc, /proc/AccessibleAreas)
			for(var/turf/t in r.contents)
				var/area/a = t.loc
				a.region = node

				if(!(a in node.areas)) node.areas += a

				var/obj/teleportPath/p = locate() in t
				if(p)
					teleportPaths -= p
					node.nodes += p

			teleports["[count]"] = node


		for(var/n in teleports)
			var/teleportNode/node = teleports[n]

			for(var/obj/teleportPath/p in node.nodes)
				node.nodes -= p

				var/turf/t = locate("[p.dest]_to_[p.name]:0")
				if(!t) continue
				var/area/a = t.loc
				if(a.region == node) continue
				node.nodes[a.region] = "[p.name]_to_[p.dest]:0"

WorldData/var/tmp/teleportMap/TeleportMap

obj/teleportPath
	var
		tmp/dest
		axisY = FALSE
		house
	New()
		..()
		var/area/a = loc.loc
		if(!a) return

		name = a.name

		for(var/turf/t in oview(2, src))
			if(t == loc)  continue
			if(t.density) continue
			if(t.opacity) continue

			var/area/nearby_area = t.loc
			if(nearby_area && nearby_area != a)
				dest = nearby_area.name

				var/obj/teleport/tele

				if(house)
					tele = new /obj/teleport/house (t)
					tele:house = house
				else
					tele = new (t)

				var/offset = axisY ? y - t.y : x - t.x
				var/turf/tagTurf = axisY ? locate(x, tele.y, z) : locate(tele.x, y, z)

				tagTurf.tag = "[name]_to_[nearby_area.name]:[offset]"
				tele.dest   = "[nearby_area.name]_to_[name]:[offset]"

	Side
		axisY = TRUE

area/var/tmp/teleportNode/region

/*mob/test/verb/testMap()
	for(var/i in worldData.TeleportMap.teleports)
		world << i

		var/teleportNode/n = worldData.TeleportMap.teleports[i]
		var/nodes = ""
		for(var/node in n.nodes)
			nodes += "[node], "
		world << "Nodes: [nodes]"

		var/textareas = ""
		for(var/t in n.areas)
			textareas += "[t], "
		world << "Areas: [textareas]"*/


var/curClass
area
	inside/ToWisps
	inside/Pixie_Pit

	outsideHogwarts           // pathfinding related
		name = "Hogwarts"
	outside/insideHogwarts
		name = "Entrance Hall"
	outside/insidePorchLeft
		name = "West Wing"
	outside/insidePorchRight
		name = "Third Floor"
	outsideDEHQ
		name = "Hogwarts Grounds"
	outside/insideDEHQ
		name = "DEHQ"
	outside
		Forbidden_Forest
		Desert
			antiTeleport = TRUE
		Hogsmeade
		Hogwarts
		PorchLeft
		PorchRight
		Hogwarts_Grounds
		Quidditch
			icon         = 'black50.dmi'
			icon_state   = "white"
			antiTeleport = 1
	DEHQ
	AurorHQ

	safezone
		DEHQ
		AurorHQ

		Exited(atom/movable/Obj, atom/newloc)
			..()

			if(Obj && newloc && isplayer(Obj))
				var/mob/Player/p = Obj

				var/hudobj/teleport/o = locate() in p.client.screen
				if(o)
					o.hide()

	hogwarts
		safezoneoverride = 1
		timedProtection = 1

		TrophyRoom
		Entrance_Hall
		Great_Hall
		PorchLeft
		PorchRight
		Bathroom
		Library
		Hufflepuff_Common_Room
		Ravenclaw_Common_Room
			SecondFloor
		Slytherin_Common_Room
		Gryffindor_Common_Room
		Dungeons
		Potions
			antiTeleport = 1
		Hospital_Wing
			safezoneoverride = 0
			Exited(atom/movable/Obj, atom/newloc)
				..()

				if(Obj && newloc && isplayer(Obj))
					var/mob/Player/p = Obj

					var/hudobj/teleport/o = locate() in p.client.screen
					if(o)
						o.hide()

		Detention
		East_Wing
		West_Wing
		Third_Floor
		Study_Hall
		Greenhouse
			antiTeleport     = 1
			friendlyFire     = 0
			safezoneoverride = 1
			timedProtection  = 0
		Forth_Floor
		Matchmaking
			timedProtection = 0
			Duel_Class
		Duel_Arenas
			timedProtection = 0
			Gryffindor
			Hufflepuff
			Slytherin
			Ravenclaw
			Main_Arena_Lobby
			Matchmaking/Main_Arena_Top
			Main_Arena_Bottom

				Entered(atom/movable/Obj,atom/OldLoc)
					if(ismob(Obj))
						Obj << infomsg("This section has an old form of dueling enabled. Each projectile will last a full 2 seconds regardless of whether it hits a wall or other blockage.")
			Defence_Against_the_Dark_Arts
			Matchmaking/Duel_Class

		Entered(mob/Player/M)
			..()
			if(isplayer(M))
				if(M.classpathfinding && classdest)
					if(classdest.loc.loc == src)
						M:removePath()
						M.classpathfinding = 0
						for(var/obj/O in M.client.screen)
							if(O.type == /obj/hud/class)
								M.client.screen.Remove(O)

var/mob/classdest = null

proc/getPathTo(turf/source, atom/target)
	var/turf/t

	if(istype(target, /atom/movable))
		t = target.loc
	else
		t = target

	var/area/startarea = source.loc
	var/area/destarea  = t.loc

	if(!startarea.region || !destarea.region) return

	if(destarea in startarea.region.areas)
		. = AStar(source, t, /turf/proc/AdjacentTurfs, /turf/proc/Distance)
	else
		var/teleport_path[]
		teleport_path = AStar(startarea.region, destarea.region, /teleportNode/proc/AdjacentNodes, /teleportNode/proc/Distance)

		if(teleport_path && teleport_path.len >= 2)
			var/teleportNode/nextNode = teleport_path[2]
			t = locate(startarea.region.nodes[nextNode]) //the teleport turf on your current floor
			. = AStar(source, t, /turf/proc/AdjacentTurfs, /turf/proc/Distance)

mob
	Player
		var/tmp/pathdest
		proc

			removePath()
				for(var/image/C in client.images)
					if(C.icon == 'arrows.dmi')
						client.images.Remove(C)
			pathTo(atom/target)
				if(!loc) return

				var/turf/t
				if(istype(target, /atom/movable))
					t = target.loc
				else
					t = target

				var/area/startarea = loc.loc
				var/area/destarea  = t.loc
				var/path[]

				if(!startarea.region || !destarea.region) return

				if(destarea in startarea.region.areas)
					path = AStar(loc, t, /turf/proc/AdjacentTurfs, /turf/proc/Distance)
				else
					var/teleport_path[]
					teleport_path = AStar(startarea.region, destarea.region, /teleportNode/proc/AdjacentNodes, /teleportNode/proc/Distance)

					if(teleport_path && teleport_path.len >= 2)
						var/teleportNode/nextNode = teleport_path[2]
						t = locate(startarea.region.nodes[nextNode]) //the teleport turf on your current floor
						path = AStar(loc, t, /turf/proc/AdjacentTurfs, /turf/proc/Distance)
				sleep()

				if(path && length(path))
					removePath()
					var/length = length(path)
					var/gap    = min(max(round(length / 7, 1), 2), 4)
					for(var/i=1, i < length, i++)
						if(i % gap == 0)
							var/turf/A = path[i]
							var/image/arrow = image('arrows.dmi', A, icon_state = "d")
							arrow.appearance_flags = NO_CLIENT_COLOR|RESET_COLOR
							arrow.layer = 10

							var/j = min(path.len - i, gap)
							if(path.len >= i + j)
								arrow.transform = turn(matrix(), get_angle(path[i], path[i + j]))
							else
								arrow.icon_state = "0"

							src << arrow
					return 1

		proc
			Class_Path_to()
				pathdest = null

				. = pathTo(classdest)
				if(!.)
					removePath()
					src << "A path cannot be mapped to the class from this area. Please go to a main area of Hogwarts and try again."
					var/obj/hud/class/C = null
					for(var/obj/O in client.screen)
						if(O.type == /obj/hud/class)
							C = O
					classpathfinding = 0
					if(!classdest)
						if(C) client.screen.Remove(C)
					else
						if(C) C.icon_state = "0"


area
	arenas
		scaleDamage = 4
		MapTwo
			Auror/Exit(atom/movable/O)
				if(ismob(O))
					if(worldData.currentArena)
						if(worldData.currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
			DE/Exit(atom/movable/O)
				if(ismob(O))
					if(worldData.currentArena)
						if(worldData.currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
		MapThree
			scaleDamage = 0
			WaitingArea
			PlayArea
		MapOne
			scaleDamage = 0
			selfDamage = 0
			antiApparate = 1
			Gryff/Exit(atom/movable/O)
				if(ismob(O))
					if(worldData.currentArena)
						if(worldData.currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
			Raven/Exit(atom/movable/O)
				if(ismob(O))
					if(worldData.currentArena)
						if(worldData.currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
			Huffle/Exit(atom/movable/O)
				if(ismob(O))
					if(worldData.currentArena)
						if(worldData.currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
			Slyth/Exit(atom/movable/O)
				if(ismob(O))
					if(worldData.currentArena)
						if(worldData.currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()

area
	FredHouseTrap
	FredHouse
	tofred
		Entered(mob/Player/M)
			if(!isplayer(M))
				return

			if("On House Arrest" in M.questPointers)
				var/questPointer/pointer = M.questPointers["On House Arrest"]
				if(!pointer.stage)
					M.Transfer(locate("@Fred"))
					return
			M.Transfer(locate("@FredTrap"))

mob/var/tmp/flying = 0

area
	Diagon_Alley
		safezoneoverride = 1
		timedProtection = 1

		HogsmeadeSafeZone
		Bank
		TomsCellar
		SlayerGuild
			antiTheft = 1
		Artifacts
			antiTheft = 1
	hogwarts
		DuelArena
		CoS

	Enter(atom/movable/o, atom/oldloc)
		if(istype(o, /obj/projectile))
			if(issafezone(src, 1, 0))
				o.Dispose()
				return
		return ..()

	Exit(atom/movable/o, atom/newloc)
		if(istype(o, /obj/projectile))
			if(issafezone(newloc.loc, 1, 0))
				o.Dispose()
				return
		return ..()


turf
	var/clientColor

	Entered(atom/movable/Obj, atom/oldLoc)
		..()
		if(isplayer(Obj))
			var/mob/Player/p = Obj

			if(clientColor)
				p.stepColor = 1

				var/ColorMatrix/c = new(clientColor)

				animate(p.client, color = c.matrix, time = 10)

			if(p.flying)
				animateFly(p)

			if(p.followers)
				for(var/obj/o in p.followers)
					o.glide_size = p.glide_size
					o.dir = p.dir
					o.loc = src

			if(p.pet && p.pet.loc)
				p.pet.follow(oldLoc, p)

	Exited(atom/movable/Obj, atom/newloc)

		if(isplayer(Obj) && Obj:stepColor)
			var/mob/Player/p = Obj
			p.stepColor = 0
			spawn(1)
				if(p && !p.stepColor)
					animate(p.client, color = null, time = 10)

		..()

obj/Shadow
	icon             = 'shadow.dmi'
	mouse_opacity    = 0
	canSave          = FALSE
	appearance_flags = LONG_GLIDE|TILE_BOUND|PIXEL_SCALE


mob/Player
	var/tmp
		list/followers
		stepColor = 0

	proc
		addFollower(obj/o)
			if(!followers) followers = list()
			followers += o

		removeFollower(obj/o)
			followers -= o

			if(!followers.len)
				followers = null