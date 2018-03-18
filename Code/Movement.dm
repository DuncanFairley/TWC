atom
	movable
		appearance_flags = LONG_GLIDE

mob/Player

	var/tmp
		moveKeys = 0
		moveDir  = 0

		loopedMove = 0

		pauseMove = 0

	proc
		MoveLoop(var/firstStep)
			set waitfor = 0
			if(client.moveStart == null)

				var/time = world.time
				client.moveStart = time
				client.moving = 1

				sleep(1)

				if(!moveKeys && onMoveEvents(firstStep))
					glide_size = 32 / (move_delay + slow)
					step(src, firstStep)
					sleep(move_delay + slow)

				var/diag
				while(moveKeys && client.moveStart == time)

					if(pauseMove)
						pauseMove--

					else if(onMoveEvents(moveDir))

						diag = moveDir & moveDir-1
						glide_size = 32 / (move_delay + slow)
						if(!step(src, moveDir) && diag)
							step(src, diag) || step(src, moveDir - diag)

					sleep(move_delay + slow)

				glide_size = 32
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
				MoveLoop(moveDir)

		swapControls()
	//		set instant = 1
			set hidden  = 1

		/*	if(loopedMove)
				winset(src, "north", "parent=")
				winset(src, "south", "parent=")
				winset(src, "east",  "parent=")
				winset(src, "west",  "parent=")

				winset(src, "north+up", "parent=")
				winset(src, "south+up", "parent=")
				winset(src, "east+up",  "parent=")
				winset(src, "west+up",  "parent=")

				moveKeys = 0

				loopedMove = 0
			else
				winset(src, "north", "parent=macro;name=\"north\";command=\"MoveKey 1 1\"")
				winset(src, "south", "parent=macro;name=\"south\";command=\"MoveKey 2 1\"")
				winset(src, "east",  "parent=macro;name=\"east\";command=\"MoveKey 4 1\"")
				winset(src, "west",  "parent=macro;name=\"west\";command=\"MoveKey 8 1\"")

				winset(src, "north+up", "parent=macro;name=\"north+up\";command=\"MoveKey 1 0\"")
				winset(src, "south+up", "parent=macro;name=\"south+up\";command=\"MoveKey 2 0\"")
				winset(src, "east+up",  "parent=macro;name=\"east+up\";command=\"MoveKey 4 0\"")
				winset(src, "west+up",  "parent=macro;name=\"west+up\";command=\"MoveKey 8 0\"")

				moveKeys = 0

				loopedMove = 1*/


var/move_queue = FALSE

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
			.=..()
	South()
		if(moveStart == null)
			.=..()
	East()
		if(moveStart == null)
			.=..()
	West()
		if(moveStart == null)
			.=..()
	Northeast()
		if(moveStart == null)
			.=..()
	Southeast()
		if(moveStart == null)
			.=..()
	Northwest()
		if(moveStart == null)
			.=..()
	Southwest()
		if(moveStart == null)
			.=..()

	Move(loc,dir)

		if(isplayer(mob))
			var/mob/Player/p = mob

			if(!p.onMoveEvents(dir)) return

			if(move_queue || p.move_delay > 1)
				if(!movements) movements = list()
				if(movements.len < 10)
					movements += dir
				if(moving) return
				moving = 1

				var/index = 0
				while(movements && index < movements.len)
					index++
					var/d = movements[index]
					.=..(get_step(p, d), d)
					sleep(p.move_delay + p.slow)
				movements = null
				moving = 0
			else
				moving = 1
				.=..(loc, dir)
				moving = 0

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