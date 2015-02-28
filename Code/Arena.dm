
area/hogwarts/Duel_Arenas/Main_Arena_Top

	Entered(atom/movable/Obj,atom/OldLoc)
		..()

		if(isplayer(Obj))
			var/mob/Player/p = Obj
			p.client.screen += new /obj/hud/Find_Duel


	Exited(atom/movable/Obj, atom/newloc)
		..()

		if(isplayer(Obj))
			var/mob/Player/p = Obj
			var/obj/hud/Find_Duel/o = locate(/obj/hud/Find_Duel) in p.client.screen
			p.client.screen -= o

			if(p in currentMatches.queue)
				currentMatches.removeQueue(p)


obj/hud/Find_Duel
	icon = 'HUD.dmi'
	icon_state = "duel"
	screen_loc = "EAST-1,2"
	mouse_over_pointer = MOUSE_HAND_POINTER

	Click()
		if(usr in currentMatches.queue)
			currentMatches.removeQueue(usr)
			color = null
			usr << infomsg("You were removed from the matchmaking queue.")
		else
			currentMatches.addQueue(usr)
			color = "#00ff00"
			usr << infomsg("You were added to the matchmaking queue.")
		currentMatches.addQueue(usr)

//mob/verb/LoadIt()
//	set category = "MATCHMAKING"
//	SwapMaps_Load("arena1")

var/matchmaking/currentMatches = new
matchmaking
	var/list/arenas
	var/list/queue

	proc

		addQueue(mob/Player/p)
			if(!queue) queue = list()
			queue += p

			matchup()

		removeQueue(mob/Player/p)
			queue -= p

			if(!queue.len) queue = null

		addArena(mob/Player/p1, mob/Player/p2)
			if(!arenas) arenas = list()
			arenas += new /arena (p1, p2)

		removeArena(arena/a)
			arenas -= a
			if(!arenas.len) arenas = null

		isReconnect(mob/Player/p)

			if(!arenas) return

			for(var/arena/a in arenas)
				if(a.reconnect(p)) return 1

		matchup()
			if(queue.len >= 2)
				var/mob/Player/p1 = pick(queue)
				removeQueue(p1)
				var/mob/Player/p2 = pick(queue)
				removeQueue(p2)

				p1 << infomsg("Match found")
				p2 << infomsg("Match found")

				addArena(p1, p2)


var/list/skill_rating

mob/Player/var/tmp/arena/rankedArena

arena
	var/swapmap/arena
	var/obj/clock/timer
	var/obj/scoreboard

	var/team/team1
	var/team/team2
	var/state = 0
	var/const
		COUNTDOWN = 1
		STARTED = 2

	New(var/mob/Player/p1, var/mob/Player/p2)
		team1 = new /team(p1)
		team2 = new /team(p2)
		loadArena()

		team1.player.rankedArena = src
		team2.player.rankedArena = src

		spawn()
			countdown()

	proc
		loadArena()
			arena = SwapMaps_CreateFromTemplate("arena1")
			arena.used = 1

			timer       = locate("arenaTimer")
			team1.timer = locate("arenaTeam1Timer")
			team2.timer = locate("arenaTeam2Timer")
			scoreboard  = locate("arenaScoreboard")

			timer.tag       = null
			team1.timer.tag = null
			team1.timer.tag = null
			scoreboard.tag  = null

			scoreboard.pixel_x       = -1
			scoreboard.maptext_width = 48
			scoreboard.maptext       = "<b><font size=4 color=#FF4500>[team1.score]:[team2.score]</font></b>"

		countdown()
			state = COUNTDOWN
			team1.reset()
			team2.reset()

			var/turf/loc1 = locate(arena.x1 + 9,  arena.y1 + 8, arena.z1)
			var/turf/loc2 = locate(arena.x1 + 15,  arena.y1 + 8, arena.z1)

			if(team1.player)
				team1.player.Transfer(loc1)
				team1.player.dir = EAST
			if(team2.player)
				team2.player.Transfer(loc2)
				team1.player.dir = WEST

			var/list/shields = list()
			for(var/turf/t in orange(1, loc1))
				shields += new /obj/Shield(t)
			for(var/turf/t in orange(1, loc2))
				shields += new /obj/Shield(t)

			timer.setTime(0, 10)

			while(!timer.countdown())
				sleep(10)

			if(team1.player)
				team1.player.HP = team1.player.MHP
				team1.player.MP = team1.player.MMP
			if(team2.player)
				team2.player.HP = team2.player.MHP
				team2.player.MP = team2.player.MMP

			for(var/obj/i in shields)
				shields -= i
				i.loc = null
			shields = null

			start()

		start()
			if(state == COUNTDOWN)
				state = STARTED

				timer.setTime(5)

				while((state & STARTED) && !timer.countdown() && !team1.lost && !team2.lost)
					team1.reconnect()
					team2.reconnect()

					sleep(10)
			end()


		end()
			if(team1.lost && team2.lost)
				team1.score++
				team2.score++

				if(team1.score > team2.score)      team1.lost = FALSE
				else if(team1.score < team2.score) team2.lost = FALSE


			if(!team1.lost && team1.won())
				world << "team1 - [team1.name] won"
				state = 0
			else if(!team2.lost && team2.won())
				world << "team2 - [team2.name] won"
				state = 0

			scoreboard.maptext = "<b><font size=4 color=#FF4500>[team1.score]:[team2.score]</font></b>"

			if(state)
				spawn()
					countdown()
			else
				dispose()

		death(mob/Player/p)
			if(team1.id == p.ckey)
				team1.lost = TRUE
			else if(team2.id == p.ckey)
				team2.lost = TRUE

		reconnect(mob/Player/p)
			if(team1.isReconnecting && p.ckey == team1.id)
				team1.isReconnecting = FALSE
				team1.player = p
				team1.player.rankedArena = src

				if(!istype(team1.player.loc.loc, /area/arenas))
					team1.player.Transfer(locate(arena.x1 + 9,  arena.y1 + 8, arena.z1))

				return 1

			else if(team2.isReconnecting && p.ckey == team2.id)
				team2.isReconnecting = FALSE
				team2.player = p
				team2.player.rankedArena = src

				if(!istype(team2.player.loc.loc, /area/arenas))
					team2.player.Transfer(locate(arena.x1 + 15,  arena.y1 + 8, arena.z1))

				return 1
			return 0

		disconnect(mob/Player/p)
			if(state == COUNTDOWN)
				state = 0
				return

			if(team1.player == p)
				team1.isReconnecting = TRUE
				team1.player = null
				team1.timer.invisibility = 0

			else if(team2.player == p)
				team2.isReconnecting = TRUE
				team2.player = null
				team1.timer.invisibility = 0

		dispose()
			if(team1.player)
				team1.player.loc = locate("@Hogwarts")
				team1.player     = null
			if(team2.player)
				team2.player.loc = locate("@Hogwarts")
				team2.player     = null

			arena.used   = null
			arena        = null
			timer        = null
			scoreboard   = null
			team1.timer  = null
			team2.timer  = null
			team1        = null
			team2        = null

			currentMatches.removeArena(src)
			unload_vault()



team
	var/id
	var/mob/Player/player
	var/name
	var/isReconnecting
	var/obj/clock/timer
	var/lost
	var/score

	New(mob/Player/p)
		..()
		player = p
		name   = p.name
		id     = p.ckey
		score  = 0

	proc
		won()
			score++
			return score >= 2
		reset()
			isReconnecting = FALSE
			lost           = FALSE
			timer.setTime(0, 45)

		reconnect()
			if(isReconnecting && timer.countdown())
				lost = TRUE



obj
	clock
		var/seconds
		var/minutes

		maptext_width = 64

		proc
			setTime(var/min = 0, var/sec = 0)
				minutes = min
				seconds = sec

				if(seconds >= 60)
					minutes += round(seconds / 60)
					seconds -= minutes * 60

				pixel_x = minutes ? -16 : 2

				updateDisplay()

			countdown()
				seconds--

				if(seconds < 0 && minutes > 0)
					minutes--
					seconds = 59

					pixel_x = minutes ? -16 : 2

				updateDisplay()

				return seconds < 0

			updateDisplay()
				if(minutes)
					maptext = "<b><font size=4 color=#FF4500>[minutes]:[seconds < 10 ? "0" : ""][seconds]</font></b>"
				else
					maptext = "<b><font size=4 color=#FF4500>[seconds]</font></b>"

