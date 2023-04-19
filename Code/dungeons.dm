#define MAP_INDOORS 1
#define MAP_DESERT 2
#define MAP_GRASS 3
#define MAP_LAVA 4

#define ROOM_BOSS 1
#define ROOM_SECRET 2

/*

to-do:
	* more room types (ice, lava)
	? boss key & door


	boss room key icon
	minimap icon, maybe a scroll-like-globe/radar, perhaps just a map, at the moment using treasure hunting skill icon
	wand holster - kole started on something but he lost it all i think
	(lowest prio since not in use atm) pet bag, basically a bulky bag, one of them fantastic beasts bags.


*/

var/list/generatedDungeons = list()

mob/Player/var/tmp/dungeon/dungeon

mob/test/verb/GenerateDungeon(var/num1=0 as num)

	world << "[world.time] [world.tick_usage]%"
	var/dungeon/d = new /dungeon(16, 100, 100, MAP_INDOORS)
	world << "[world.time] [world.tick_usage]%"

//	if (world.tick_usage > 80) lagstopsleep()
	d.ExitLoc = loc

	d.Enter(src)

	world << d.Z

	if(num1 == 1)
		sleep(100)
		d.Dispose()
		world << "deleted"

dungeon
	var/Type
	var/Width
	var/Height
	var/Z
	var/Split

	// indexes not rooms
	var/FirstRoom
	var/SecretRoom
	var/BossRoom

	var/ExitLoc
	var/QuestName
	var/QuestArgs
	var/list/Passives

	var/EdgeType
	var/FloorType
	var/NeedsWall = 0
	var/MonsterType

	var/list/rooms
	var/swapmap/fastdel/map
	var/rowSize
	var/disposing = 0
	var/list/Players
	var/obj/Hogwarts_Door/door

	var/puzzleType = 1


	New(split, width, height, type)

		generatedDungeons += src

		Width = width
		Height = height
		Type = type
		Split = split

		if(Type == MAP_INDOORS)
			NeedsWall = /turf/Hogwarts_Stone_Wall
			EdgeType = /turf/roofb
			FloorType = pick(/turf/woodenfloor, /turf/woodenfloorblack, /turf/woodenfloor { color="#008eaa" })

		else if(Type == MAP_GRASS)
			EdgeType = /turf/blankturf/edge
			FloorType = /turf/grass

		else if(Type == MAP_DESERT)
			EdgeType = /turf/blankturf/edge
			FloorType = /turf/sand

		if(Type)
			MonsterType = /mob/Enemies/Rat
			Generate()

	proc/Generate()
		map = new("dungeon_[type]_[world.maxz]")
		map.used = 1

		Z = map.z1

		if (world.tick_usage > 80) lagstopsleep()

		var/maxTiles = floor(sqrt((Width * Height) / Split))

		var/roomWidth  = maxTiles
		var/roomHeight = maxTiles

		rooms = list()

		var/startX = 1
		var/startY = 1

		for(var/i = 1 to Split)
			rooms += new /room (startX, startY, roomWidth, roomHeight, src)

			startX += roomWidth
			if(startX + roomWidth - 1 > 100)
				startX = 1
				startY += roomHeight

				if(!rowSize) rowSize = i


		var/entry = rand(1, Split)
		FirstRoom = entry

		var/room/r = rooms[entry]

		while(!r.connectsTo)
			var/list/options = GetNeighbours(entry)

			var/room/oldRoom = r

			while(options.len)
				entry = pick(options)
				r = rooms[entry]
				if(!r.connectsTo)
					oldRoom.connectsTo = entry

					break
				options -= entry

		var/list/used = list(FirstRoom)

		r = rooms[FirstRoom]
		r.Generate()
		while(r.connectsTo)

			var/room/oldRoom = r
			r = rooms[r.connectsTo]

			r.Generate()
			ConnectRooms(oldRoom, r)

			used += oldRoom.connectsTo

			if (world.tick_usage > 80) lagstopsleep()

		BossRoom = used[used.len]

		if(used.len < Split)
			var/list/notUsed = list()
			for(var/i = 1 to Split)
				if(i in used) continue

				notUsed += i

			while(notUsed.len)
				var/i = pick(notUsed)
				notUsed -= i
				var/found = 0
				var/list/options = GetNeighbours(i)
				while(options.len)
					var/option = pick(options)
					r = rooms[option]
					if(r.connectsTo)

						var/room/secret = rooms[i]
						SecretRoom = i
						secret.Generate(4)
						ConnectRooms(r, secret, ROOM_SECRET)
						found = 1
						break
					options -= option
				if(found) break

		if(puzzleType == 1)
			if(prob(70))
				var/room/key = rooms[used[rand(2, used.len-1)]]
				var/mob/Enemies/e = locate() in range(key.Width/2, locate(floor(key.X + key.Width / 2), floor(key.Y + key.Height / 2), Z))

				if(e) e.drops = /obj/items/dungeon_key
				else door.door=1
			else
				var/room/key = rooms[SecretRoom]
				new /obj/items/dungeon_key (locate(floor(key.X + key.Width / 2), floor(key.Y + key.Height / 2), Z))



	proc/GetEntry()
		var/room/r = rooms[FirstRoom]

		return locate(floor(r.left + (r.right - r.left) / 2), floor(r.bottom + (r.top - r.bottom) / 2), Z)

	proc/Enter(mob/Player/p)
		if(!Players) Players = list()
		Players += p

		p.dungeon = src

		disposing = 0

		p.Transfer(GetEntry())

		if(Passives)
			if(!p.passives) p.passives = list()

			for(var/e in Passives)
				p << infomsg("You gain the power of [e].")
				p.passives[e] += 1

	proc/Exit(mob/Player/p)

		if(p.dungeon.Passives)
			for(var/e in Passives)
				p.passives[e] -= 1

				if(p.passives[e] <= 0) p.passives -= e

				if(!p.passives.len)
					p.passives = null

		p.dungeon = null
		Players -= p
		if(!Players.len)
			Disposing()

	proc/Completed()
		var/room/r = rooms[BossRoom]

		var/turf/t = locate(floor(r.left + (r.right - r.left) / 2), floor(r.bottom + (r.top - r.bottom) / 2), Z)

		var/obj/teleport/portkey/port = new (t)
		port.dest = ExitLoc

		if(QuestName)
			for(var/mob/Player/p in Players)
				var/questPointer/pointer = p.questPointers[QuestName]
				if(pointer && p.questProgress(QuestName, QuestArgs, FALSE))
					p.Interface.Update()


	proc/GetNeighbours(var/room)
		. = list()
		if(room+rowSize <= rooms.len)   . += room+rowSize
		if(room-rowSize >= 1)       . += room-rowSize
		if((room+1) % rowSize != 1) . += room+1
		if((room-1) % rowSize != 0) . += room-1


	proc/ConnectRooms(var/room/r1, var/room/r2, var/type)

		var/turf/center1 = locate(floor(r1.X + r1.Width / 2), floor(r1.Y + r1.Height / 2), Z)
		var/turf/center2 = locate(floor(r2.X + r2.Width / 2), floor(r2.Y + r2.Height / 2), Z)

		var/dir = get_dir(center1, center2)

		var/shift, size1, size2

		if(!type && !r2.connectsTo) type = ROOM_BOSS

		if(type)
			size1 = 0
			size2 = 0
			shift = rand(-7, 7)
		else
			size1 = rand(1,7)
			size2 = rand(1,7)

			var/range = 7-max(size1, size2)
			shift = rand(-range, range)

		var/turf/bottomleft
		var/turf/topright

		switch(dir)
			if(EAST)
				bottomleft = locate(r1.right, center1.y+shift-size1, Z)
				topright   = locate(r2.left, center1.y+shift+size2, Z)

			if(WEST)
				bottomleft = locate(r2.right, center1.y+shift-size1, Z)
				topright   = locate(r1.left, center1.y+shift+size2, Z)

			if(NORTH)
				bottomleft = locate(center1.x+shift-size1, r1.top-1, Z)
				topright   = locate(center1.x+shift+size2, r2.bottom, Z)

			if(SOUTH)
				bottomleft = locate(center1.x+shift-size1, r2.top-1, Z)
				topright   = locate(center1.x+shift+size2, r1.bottom, Z)

		if(dir == EAST || dir == WEST)
			for(var/turf/t in block(locate(bottomleft.x, bottomleft.y-1, Z),\
			                        locate(topright.x, bottomleft.y-1, Z)))
				new EdgeType (t)

			if(NeedsWall)
				for(var/turf/t in block(locate(bottomleft.x, topright.y+2, Z),\
					                    locate(topright.x, topright.y+2, Z)))
					new EdgeType (t)

				for(var/turf/t in block(locate(bottomleft.x, topright.y+1, Z),\
					                    locate(topright.x, topright.y+1, Z)))
					new NeedsWall (t)
			else
				for(var/turf/t in block(locate(bottomleft.x, topright.y+1, Z),\
					                    locate(topright.x, topright.y+1, Z)))
					new EdgeType (t)
		else
			for(var/turf/t in block(locate(bottomleft.x-1, bottomleft.y+1, Z),\
			                        locate(bottomleft.x-1, topright.y, Z)))
				new EdgeType (t)

			for(var/turf/t in block(locate(topright.x+1, bottomleft.y+1, Z),\
			                        locate(topright.x+1, topright.y, Z)))
				new EdgeType (t)


		for(var/turf/t in block(bottomleft, topright))
			new /area/newareas/inside/GeneratedDungeon (t)
			new FloorType (t)

		if(type)

			var/turf/start

			if(dir == NORTH && NeedsWall)
				start = locate(bottomleft.x, bottomleft.y+1, Z)

				if(type == ROOM_SECRET)
					bottomleft = new /turf/Hogwarts_Stone_Wall (bottomleft)
					bottomleft.density = 0
				else
					door = new (bottomleft)
					door.door = 0
			else
				start = (dir == WEST || dir == SOUTH) ? topright : bottomleft

			if(type == ROOM_BOSS)
				if(dir != NORTH || !NeedsWall)
					door = new (start)
					door.door = 0
			else
				var/turf/t = new EdgeType (start)
				t.density = 0
				t.layer = 5

			if(dir == EAST || dir == WEST)
				new EdgeType (locate(start.x, start.y+1, Z))
				new EdgeType (locate(start.x, start.y-1, Z))
			else
				new EdgeType (locate(start.x+1, start.y, Z))
				new EdgeType (locate(start.x-1, start.y, Z))


	proc/Disposing()
		set waitfor = 0

		disposing = 1

		sleep(600)

		if(disposing)
			Dispose()

	proc/Dispose()

		for(var/mob/Player/p in Players)
			p.loc = ExitLoc
		Players = null

		for(var/room/r in rooms)
			r.parent = null
		rooms = null

		map.UnloadNoSave()
		map = null

		generatedDungeons -= src


room
	var
		X = 1
		Y = 1
		Width
		Height
		dungeon/parent

		left
		right
		bottom
		top

		connectsTo

	New(x=1, y=1, width, height, dungeon/dungeon)
		parent = dungeon
		X = x
		Y = y
		Width = width
		Height = height


	proc/Generate(size)

		var/paddingL, paddingR, paddingT, paddingB
		if(connectsTo)
			paddingL = rand(1, 4)
			paddingR = rand(1, 4)
			paddingB = rand(1, 4)
			paddingT = rand(1, 4)
		else if(size)
			paddingL = size
			paddingR = size
			paddingB = size
			paddingT = size
		else
			paddingL = 0
			paddingR = 0
			paddingB = 0
			paddingT = 0

		left   = X + paddingL
		bottom = Y + paddingB
		right  = X + Width-1 - paddingR
		top    = Y + Height-1 - paddingT

		var/turf/bottomleft = locate(left, bottom, parent.Z)
		var/turf/topright   = locate(right, top, parent.Z)

		for(var/turf/t in block(bottomleft, topright))

			if(t.x == left || t.x == right || t.y == bottom || t.y == top)
				new parent.EdgeType (t)
			else if(t.y == top-1 && parent.NeedsWall)
				new parent.NeedsWall (t)
			else
				new /area/newareas/inside/GeneratedDungeon (t)
				new parent.FloorType (t)

		//decor
		for(var/i = 1 to rand(1, 4))
			new /obj/lootdrop/norespawn (locate(rand(left+1, right-1), rand(bottom+1, top-2), parent.Z), 0)
		if(size) // secret
			var/obj/lootdrop/norespawn/chest = new (locate(rand(left+1, right-1), rand(bottom+1, top-2), parent.Z), 0)
			chest.extraChance = 3
			chest.transform = matrix() * 3
			chest.icon_state = pick("chest", "chest2")
			chest.name = "Chest"
			chest.lootType = 1

		if(connectsTo)
			for(var/i = 1 to rand(4, 8))
				var/mob/Enemies/e = new parent.MonsterType (locate(rand(left+1, right-1), rand(bottom+1, top-2), parent.Z), 0)
				e.origloc = null
		else if(!size) // boss room
			var/mob/Enemies/e = new parent.MonsterType (locate(rand(left+1, right-1), rand(bottom+1, top-2), parent.Z), 0)
			e.level *= 2
			e.isElite = 1
			e.MapInit()
			e.origloc = null




swapmap/fastdel

	Del()

		if(z1 < world.maxz)
			for(var/turf/T in block(locate(x1,y1,z1),locate(x2,y2,z2)))
				for(var/atom/movable/O in T)
					O.loc = null

		swapmaps_loaded-=src
		swapmaps_byname-=id

		CutXYZ()

		ischunk=1 // prevent default del()
		..()

	AllocateSwapMap()
		..()
/*		world.maxz++

		x1=1
		y1=1
		z1=world.maxz

		x2=100
		y2=100
		z2=z1

		if(!ischunk)
			swapmaps_loaded[src]=null
			swapmaps_byname[id]=src*/

	Save()

area/newareas/inside/GeneratedDungeon
	antiFly	  = TRUE
	antiTeleport = TRUE

	Exited(atom/movable/Obj, atom/newloc)
		.=..()

		if(isplayer(Obj))
			var/mob/Player/p = Obj
			if(p.dungeon)
				p.dungeon.Exit(p)

obj/lootdrop/norespawn
	New()
		..()
		pickType()
	respawn()
		set waitfor = 0
		loc = null

obj/items/dungeon_key
	icon = 'ChestKey.dmi'
	icon_state = "boss"
	max_stack  = 1
	canSave    = FALSE
	fetchable  = 0
	rarity     = 5

	Take()
		set src in oview(1)
		var/mob/Player/p = usr
		if(p.dungeon)
			p.dungeon.door.door = 1
			p << infomsg("Boss room is now unlocked!")
			loc = null

	Crossed(mob/Player/p)
		if(isplayer(p) && p.dungeon)
			p.dungeon.door.door = 1
			p << infomsg("Boss room is now unlocked!")
			loc = null