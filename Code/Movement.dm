atom
	movable
		appearance_flags = LONG_GLIDE|PIXEL_SCALE

#define FACE_NORTH 16
#define FACE_SOUTH 32
#define FACE_EAST 64
#define FACE_WEST 128

#define FACE_NORTHEAST 80
#define FACE_NORTHWEST 144
#define FACE_SOUTHEAST 96
#define FACE_SOUTHWEST 160

mob/proc/MoveLoop()

mob/Player

	var/tmp
		moveKeys = 0
		moveDir  = 0
		GLIDE = GLIDE_SIZE

	MoveLoop(var/firstStep, var/wait=0, var/isDir=0)
		set waitfor = 0

		if(wait)
			sleep(1)

		if(client.moveStart == null)

			var/time = world.time
			client.moveStart = time
			client.moving = 1

			if(isDir)
				dir = firstStep
				sleep(move_delay + slow)
			else if(!moveKeys && onMoveEvents(firstStep))
				glide_size = GLIDE / (move_delay + slow)
				step(src, firstStep)

				if(move_delay + slow > 1)
					sleep(move_delay + slow - 1)

			var/diag
			while((moveKeys || client.movements) && client.moveStart == time)

				if(client.movements)
					var/d = client.movements[1]
					client.movements.Cut(1,2)

					if(d >= 16)
						switch(d)
							if(FACE_NORTH)     dir = NORTH
							if(FACE_SOUTH)     dir = SOUTH
							if(FACE_EAST)      dir = EAST
							if(FACE_WEST)      dir = WEST
							if(FACE_NORTHEAST) dir = NORTHEAST
							if(FACE_NORTHWEST) dir = NORTHWEST
							if(FACE_SOUTHEAST) dir = SOUTHEAST
							if(FACE_SOUTHWEST) dir = SOUTHWEST
					else if(onMoveEvents(d))
						glide_size = GLIDE / (move_delay + slow)
						step(src, d)

					if(client.movements.len == 0)
						client.movements = null

				else
					if(onMoveEvents(moveDir))
						diag = moveDir & moveDir-1
						glide_size = GLIDE / (move_delay + slow)
						if(!step(src, moveDir) && diag)
							step(src, diag) || step(src, moveDir - diag)

				sleep(move_delay + slow)

			glide_size = GLIDE
			client.moving = 0
			client.moveStart = null

	verb
		MoveKey(dir as num,state as num)
			set hidden  = 1
			set instant = 1

			var/okeys = moveKeys
			var/odir  = turn(dir, 180)

			if(state)
				moveKeys |= dir
				moveDir  |= dir

				if(moveKeys & odir)
					moveDir &= ~odir
			else
				moveKeys &= ~dir
				moveDir  &= ~dir

				if(moveKeys & odir)
					moveDir |= odir

			if(moveKeys && !okeys)
				MoveLoop(moveDir, 1)
mob
	var/tmp
		obj/wingobject
		Wingardiumleviosa

	Player
		var/tmp/atom/movable/control
		proc/onMoveEvents(newDir)
			if(nomove || GMFrozen || arcessoing) return

			if(wingobject)
				var/turf/t = get_step(wingobject, newDir)
				if(istype(wingobject.loc, /mob))
					src << infomsg("You let go of the object you were holding.")
					wingobject.overlays = null
					wingobject		  = null
					Wingardiumleviosa   = null
				else if(t && (t in view(client.view, src)))
					wingobject.Move(t)
				return

			if(removeoMob)
				step(removeoMob, newDir)
				return

			if(control)
				var/diag = newDir & newDir-1
				if(!step(control, newDir) && diag)
					step(control, diag) || step(control, newDir - diag)
				return

			if(away)
				away   = 0
				status = here
				RemoveAFKOverlay()

			if(auctionInfo)
				auctionClosed()
				winshow(src, "Auction", 0)

			if(screen_text)
				screen_text.Dispose()

			if(questionius == 1)
				overlays   -= icon('hand.dmi')
				questionius = 0

			. = 1

client
	var/tmp
		moving = 0
		list/movements
		moveStart

	North()
		if(moveStart == null)
			mob.MoveLoop(NORTH)
		else
			if(!movements) movements = list(NORTH)
			else if(movements.len < 10) movements += NORTH

	South()
		if(moveStart == null)
			mob.MoveLoop(SOUTH)
		else
			if(!movements) movements = list(SOUTH)
			else if(movements.len < 10) movements += SOUTH
	East()
		if(moveStart == null)
			mob.MoveLoop(EAST)
		else
			if(!movements) movements = list(EAST)
			else if(movements.len < 10) movements += EAST
	West()
		if(moveStart == null)
			mob.MoveLoop(WEST)
		else
			if(!movements) movements = list(WEST)
			else if(movements.len < 10) movements += WEST
	Northeast()
		if(moveStart == null)
			mob.MoveLoop(NORTHEAST)
		else
			if(!movements) movements = list(NORTHEAST)
			else if(movements.len < 10) movements += NORTHEAST
	Southeast()
		if(moveStart == null)
			mob.MoveLoop(SOUTHEAST)
		else
			if(!movements) movements = list(SOUTHEAST)
			else if(movements.len < 10) movements += SOUTHEAST
	Northwest()
		if(moveStart == null)
			mob.MoveLoop(NORTHWEST)
		else
			if(!movements) movements = list(NORTHWEST)
			else if(movements.len < 10) movements += NORTHWEST
	Southwest()
		if(moveStart == null)
			mob.MoveLoop(SOUTHWEST)
		else
			if(!movements) movements = list(SOUTHWEST)
			else if(movements.len < 10) movements += SOUTHWEST

obj/moveChecker
	density = 1
	canSave = FALSE

	var
		allowMobs  = 1
		allowObjs  = 1
		allowTurfs = 1

		stop = 0


	Bump(atom/a)
		var/turf/t
		if(isturf(a))
			t = a
			if(!allowTurfs) return
		else
			t = a.loc

		if(t.flyblock) return

		if(!allowMobs && ismob(a)) 	return

		if(!allowObjs && isobj(a)) return

		loc = t


mob
	Player
		var/tmp
			dash = 0
			dashDistance = 0
		verb
			dash(var/down as num)
				set hidden = 1
				set instant = 1

				if(down)
					if(dash||nomove||!dashDistance||GMFrozen||arcessoing||inOldArena()) return
					dash = 1

					var/obj/moveChecker/o = new
					while(dash)
						var/d = dir

						o.loc = loc
						for(var/s = 1 to dashDistance)
							step(o, d)
							if(o.stop) break

						var/turf/t = o.loc
						o.loc = null

						if(t == loc)
							dash = 0
							break

						var/px = (x * 32) - (t.x * 32)
						var/py = (y * 32) - (t.y * 32)

						var/time = round((((abs(px) + abs(py)) / 32) * 0.5) / (dashDistance / 4))
						time = max(1, time)

						if(o.stop)
							Move(t)
							dir = d
							dash = 0
							break
						else
							jumpTo(t, time)

						sleep(time)

				else
					dash = 0

			anorth()
				set hidden = 1
				set instant = 1
				if(GMFrozen||arcessoing||inOldArena()) return

				if(client.moveStart == null)
					MoveLoop(NORTH, isDir=1)
				else
					if(!client.movements) client.movements = list(FACE_NORTH)
					else if(client.movements.len < 10) client.movements += FACE_NORTH
			asouth()
				set hidden = 1
				if(GMFrozen||arcessoing||inOldArena()) return

				if(client.moveStart == null)
					MoveLoop(SOUTH, isDir=1)
				else
					if(!client.movements) client.movements = list(FACE_SOUTH)
					else if(client.movements.len < 10) client.movements += FACE_SOUTH
			awest()
				set hidden = 1
				if(GMFrozen||arcessoing||inOldArena()) return

				if(client.moveStart == null)
					MoveLoop(WEST, isDir=1)
				else
					if(!client.movements) client.movements = list(FACE_WEST)
					else if(client.movements.len < 10) client.movements += FACE_WEST
			aeast()
				set hidden = 1
				if(GMFrozen||arcessoing||inOldArena()) return

				if(client.moveStart == null)
					MoveLoop(EAST, isDir=1)
				else
					if(!client.movements) client.movements = list(FACE_EAST)
					else if(client.movements.len < 10) client.movements += FACE_EAST
			anorthwest()
				set hidden = 1
				if(GMFrozen||arcessoing||inOldArena()) return

				if(client.moveStart == null)
					MoveLoop(NORTHWEST, isDir=1)
				else
					if(!client.movements) client.movements = list(FACE_NORTHWEST)
					else if(client.movements.len < 10) client.movements += FACE_NORTHWEST
			anortheast()
				set hidden = 1
				if(GMFrozen||arcessoing||inOldArena()) return

				if(client.moveStart == null)
					MoveLoop(NORTHEAST, isDir=1)
				else
					if(!client.movements) client.movements = list(FACE_NORTHEAST)
					else if(client.movements.len < 10) client.movements += FACE_NORTHEAST
			asouthwest()
				set hidden = 1
				if(GMFrozen||arcessoing||inOldArena()) return

				if(client.moveStart == null)
					MoveLoop(SOUTHWEST, isDir=1)
				else
					if(!client.movements) client.movements = list(FACE_SOUTHWEST)
					else if(client.movements.len < 10) client.movements += FACE_SOUTHWEST
			asoutheast()
				set hidden = 1
				if(GMFrozen||arcessoing||inOldArena()) return

				if(client.moveStart == null)
					MoveLoop(SOUTHEAST, isDir=1)
				else
					if(!client.movements) client.movements = list(FACE_SOUTHEAST)
					else if(client.movements.len < 10) client.movements += FACE_SOUTHEAST

mob/Player
	var/tmp/image/reflection

	proc
		CleanReflection()
			set waitfor = 0

			sleep(100)

			while(loc && loc:reflect)
				sleep(100)

			if(reflection)
				underlays -= reflection
				reflection = null

		GenerateReflection(var/d = SOUTH)

			if(reflection)
				underlays -= reflection

			reflection = new

			reflection.appearance = src
			reflection.underlays = list()

			reflection.alpha = 100
			reflection.layer = 1.5
			reflection.appearance_flags = KEEP_TOGETHER
			reflection.transform *= matrix(1, 0, 0, 0, -1, -32)

			underlays += reflection

turf
	var/reflect = 0

	Enter(atom/movable/O, atom/oldloc)
		.=..()

		if(reflect && isplayer(O) && !O:reflection)
			O:GenerateReflection(reflect)

			src=null
			O:CleanReflection()