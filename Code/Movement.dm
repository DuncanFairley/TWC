atom
	movable
		appearance_flags = LONG_GLIDE|PIXEL_SCALE

mob/Player

	var/tmp
		moveKeys = 0
		moveDir  = 0
		GLIDE = GLIDE_SIZE

	proc
		MoveLoop(var/firstStep, var/wait=0)
			set waitfor = 0

			if(wait)
				sleep(1)

			if(client.moveStart == null)

				var/time = world.time
				client.moveStart = time
				client.moving = 1

				if(!moveKeys && onMoveEvents(firstStep))
					glide_size = GLIDE / (move_delay + slow)
					step(src, firstStep)
					sleep(move_delay + slow)

				var/diag
				while((moveKeys || client.movements) && client.moveStart == time)

					if(client.movements)
						var/d = client.movements[1]
						client.movements.Cut(1,2)

						if(client.movements.len == 0) client.movements = null

						if(onMoveEvents(d))
							glide_size = GLIDE / (move_delay + slow)
							step(src, d)
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
			mob:MoveLoop(NORTH)
		else
			if(!movements) movements = list(NORTH)
			else if(movements.len < 10) movements += NORTH

	South()
		if(moveStart == null)
			mob:MoveLoop(SOUTH)
		else
			if(!movements) movements = list(SOUTH)
			else if(movements.len < 10) movements += SOUTH
	East()
		if(moveStart == null)
			mob:MoveLoop(EAST)
		else
			if(!movements) movements = list(EAST)
			else if(movements.len < 10) movements += EAST
	West()
		if(moveStart == null)
			mob:MoveLoop(WEST)
		else
			if(!movements) movements = list(WEST)
			else if(movements.len < 10) movements += WEST
	Northeast()
		if(moveStart == null)
			mob:MoveLoop(NORTHEAST)
		else
			if(!movements) movements = list(NORTHEAST)
			else if(movements.len < 10) movements += NORTHEAST
	Southeast()
		if(moveStart == null)
			mob:MoveLoop(SOUTHEAST)
		else
			if(!movements) movements = list(SOUTHEAST)
			else if(movements.len < 10) movements += SOUTHEAST
	Northwest()
		if(moveStart == null)
			mob:MoveLoop(NORTHWEST)
		else
			if(!movements) movements = list(NORTHWEST)
			else if(movements.len < 10) movements += NORTHWEST
	Southwest()
		if(moveStart == null)
			mob:MoveLoop(SOUTHWEST)
		else
			if(!movements) movements = list(SOUTHWEST)
			else if(movements.len < 10) movements += SOUTHWEST

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