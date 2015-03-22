var/const
	WINS_REQ   = 10
	RANK_LIMIT = 300

var/list/duel_chairs = list()

obj/duel_chair
	invisibility = 10
	New()
		..()
		duel_chairs += src

area/hogwarts/Duel_Arenas/Matchmaking
	Main_Arena_Top
	Duel_Class

	Entered(atom/movable/Obj,atom/OldLoc)
		..()

		if(isplayer(Obj))
			var/mob/Player/p = Obj
			if(p.level < lvlcap || (p.ckey in competitiveBans)) return
			p.client.screen += new /obj/hud/Find_Duel


	Exited(atom/movable/Obj, atom/newloc)
		..()

		if(isplayer(Obj))
			var/mob/Player/p = Obj
			if(!p.client || p.level < lvlcap || (p.ckey in competitiveBans)) return

			var/obj/hud/Find_Duel/o = locate(/obj/hud/Find_Duel) in p.client.screen
			if(o)
				p.client.screen -= o

				if(p in currentMatches.queue)
					currentMatches.removeQueue(p)

			p.matchmaking_ready = 0
			for(var/obj/hud/duel/d in p.client.screen)
				p.client.screen -= d

mob/Player
	var/tmp
		matchmaking_ready = 0

obj/hud

	duel
		layer = 20
		Background
			icon = 'MMBackground.dmi'
			screen_loc = "CENTER:28-4,CENTER-2"
			layer = 19
			color = "#1199FF"

		Text
			icon = 'Matchmaking.dmi'
			screen_loc = "CENTER-2,CENTER+1"

		Warning
			screen_loc = "CENTER:2-3,CENTER:16-2"
			maptext_width  = 256
			maptext_height = 64
			maptext = "<b><font color=white>Competitive matches can last up to 15 minutes, only accept if you have enough time to play.</font></b>"

		Timer
			screen_loc = "CENTER:16,CENTER"

			var/seconds = 15

			New()
				..()
				spawn()
					while(seconds)
						maptext = "<b><font size=4 color=#FF4500> [seconds]</font></b>"
						seconds--
						sleep(10)

		Accept
			icon = 'MMButtons.dmi'
			icon_state = "accept"
			screen_loc = "CENTER:16-3,CENTER"
			mouse_over_pointer = MOUSE_HAND_POINTER
			Click()
				usr:matchmaking_ready = 2

				for(var/obj/hud/duel/d in usr.client.screen)
					usr.client.screen -= d

		Decline
			icon = 'MMButtons.dmi'
			icon_state = "decline"
			screen_loc = "CENTER+2,CENTER"
			mouse_over_pointer = MOUSE_HAND_POINTER
			Click()
				usr:matchmaking_ready = 0

				for(var/obj/hud/duel/d in usr.client.screen)
					usr.client.screen -= d

	Find_Duel
		icon = 'HUD.dmi'
		icon_state = "duel"
		screen_loc = "EAST-1,2"
		mouse_over_pointer = MOUSE_HAND_POINTER

		Click()
			if(usr:matchmaking_ready) return

			if(usr in currentMatches.queue)
				currentMatches.removeQueue(usr)
				color = null
				usr << infomsg("You were removed from the matchmaking queue.")
			else
				currentMatches.addQueue(usr)
				color = "#00ff00"
				usr << infomsg("You were added to the matchmaking queue.")


var/matchmaking/currentMatches = new
matchmaking
	var/list/arenas
	var/list/queue
	var/matchmaking = FALSE

	proc

		addQueue(mob/Player/p)
			if(!queue) queue = list()

			if(!(p.ckey  in skill_rating)) skill_rating[p.ckey]  = new /skill_stats

			var/skill_stats/s = skill_rating[p.ckey]
			queue[p] = s.rating

			if(!matchmaking && queue.len >= 2)
				matchmaking = TRUE
				spawn(rand(50,100))
					bubblesort_by_value(queue)
					var/i = 0
					while(queue && queue.len - i >= 2)
						i += matchup(i)
					matchmaking = FALSE


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

		matchup(skip = 0)
			if(queue && queue.len >= 2+skip)
				var/mob/Player/p1 = queue[queue.len - skip]
				var/mob/Player/p2 = queue[queue.len - 1 - skip]

				if(queue[p1] - queue[p2] >= RANK_LIMIT) return 1

				removeQueue(p1)
				removeQueue(p2)

				p1.beep()
				p2.beep()

				for(var/d in typesof(/obj/hud/duel) - /obj/hud/duel)
					p1.client.screen += new d
					p2.client.screen += new d

				p1.matchmaking_ready = 1
				p2.matchmaking_ready = 1

				var/time = 15
				while(time && p1 && p2 && (p1.matchmaking_ready == 1 || p2.matchmaking_ready == 1) && p1.matchmaking_ready && p2.matchmaking_ready)
					time--
					sleep(10)

				var/p1_accepted = p1 && (p1.matchmaking_ready == 2 || (p1.matchmaking_ready == 1 && time > 0))
				var/p2_accepted = p2 && (p2.matchmaking_ready == 2 || (p2.matchmaking_ready == 1 && time > 0))

				if(p1_accepted && p2_accepted)
					addArena(p1, p2)
				else if(p1_accepted)
					addQueue(p1)
					p1 << errormsg("Match cancelled, your opponent didn't accept the duel.")
				else if(p2_accepted)
					addQueue(p2)
					p2 << errormsg("Match cancelled, your opponent didn't accept the duel.")

				if(p1)
					p1.matchmaking_ready = 0
					for(var/obj/hud/duel/d in p1.client.screen)
						p1.client.screen -= d

					if(!p1_accepted)
						var/obj/hud/Find_Duel/o = locate(/obj/hud/Find_Duel) in p1.client.screen
						if(o)
							o.color = null
						p1 << errormsg("You were removed from the matchmaking queue because you failed to accept.")

				if(p2)
					p2.matchmaking_ready = 0
					for(var/obj/hud/duel/d in p2.client.screen)
						p2.client.screen -= d
					if(!p2_accepted)
						var/obj/hud/Find_Duel/o = locate(/obj/hud/Find_Duel) in p2.client.screen
						if(o)
							o.color = null
						p2 << errormsg("You were removed from the matchmaking queue because you failed to accept.")

		reward(team/winTeam, team/loseTeam)
			var/skill_stats/winner = skill_rating[winTeam.id]
			var/skill_stats/loser  = skill_rating[loseTeam.id]

			winner.name = winTeam.name
			loser.name  = loseTeam.name

			winner.wins++

			var/origRank
			if(winTeam.player && winner.wins > WINS_REQ)
				origRank = getSkillGroup(winTeam.id)

			var/const/factor = 32

			var/winnerExpectedScore = 1 / (1 + 10 ** ((loser.rating  - winner.rating) / 400))
			var/loserExpectedScore  = 1 / (1 + 10 ** ((winner.rating - loser.rating)  / 400))

			winner.rating = round(winner.rating + factor * (1 - winnerExpectedScore), 1)
			loser.rating  = round(loser.rating  + factor * (0 - loserExpectedScore), 1)
			loser.rating  = max(100, loser.rating)

			bubblesort_by_value(skill_rating, "rating", TRUE)

			if(winner.wins == WINS_REQ)
				Players << infomsg("<b>Matchmaking:</b> [winTeam.name] is now ranked!")
			else if(origRank)
				var/rank = getSkillGroup(winTeam.id)
				if(origRank != rank) Players << infomsg("<b>Matchmaking:</b> [winTeam.name] ranked up to [rank]!")

			var/list/L = list(winTeam.player, loseTeam.player)
			for(var/mob/Player/p in L)
				if(p && prob(5))
					var/prize
					if(loser.rating > 600 && winner.rating > 600 && prob(15))
						prize = pick(/obj/items/wearable/shoes/duel_shoes,
									 /obj/items/wearable/scarves/duel_scarf,
									 /obj/items/wearable/wands/duel_wand)
					else
						prize = pick(/obj/items/wearable/title/Duelist,
									 /obj/items/wearable/title/Wizard,
									 /obj/items/wearable/title/Determined,
									 /obj/items/wearable/title/Battlemage)

						var/obj/o = new prize (p)
						p.Resort_Stacking_Inv()
						p << infomsg("You receive [o.name]! How lucky!")


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

	var/tmp/list/spectators

	var/tmp/obj/spectate/spectateObj

	New(var/mob/Player/p1, var/mob/Player/p2)
		team1 = new /team(p1)
		team2 = new /team(p2)
		loadArena()

		team1.player.rankedArena = src
		team2.player.rankedArena = src

		spectateObj = new(src)

		spawn()
			countdown()

	proc
		addSpectator(mob/Player/p)
			for(var/arena/a in currentMatches.arenas)
				if(a == src)    continue
				if(!a.spectators) continue
				if(p in a.spectators)
					a.removeSpectator(p)
					break

			var/turf/t = locate(arena.x1 + 12,  arena.y1 + 8, arena.z1)
			p.client.eye=t
			p.client.perspective = EYE_PERSPECTIVE

			if(!spectators) spectators = list()
			spectators += p

			spectateObj.updateName()

		removeSpectator(mob/Player/p)
			p.client.eye=p
			p.client.perspective = EYE_PERSPECTIVE

			spectators -= p
			if(!spectators.len) spectators = null

			spectateObj.updateName()

		loadArena()
			arena = SwapMaps_CreateFromTemplate("arena1")
			arena.used = 1

			timer       = locate("arenaTimer")
			team1.timer = locate("arenaTeam1Timer")
			team2.timer = locate("arenaTeam2Timer")
			scoreboard  = locate("arenaScoreboard")

			timer.tag       = null
			team1.timer.tag = null
			team2.timer.tag = null
			scoreboard.tag  = null

			team1.timer.invisibility = 3
			team2.timer.invisibility = 3

			scoreboard.pixel_x       = -1
			scoreboard.maptext_width = 48
			scoreboard.maptext       = "<b><font size=4 color=#FF4500>[team1.score]:[team2.score]</font></b>"

		countdown()
			state = COUNTDOWN

			var/turf/loc1 = locate(arena.x1 + 9,  arena.y1 + 8, arena.z1)
			var/turf/loc2 = locate(arena.x1 + 15,  arena.y1 + 8, arena.z1)

			if(team1.player)
				team1.player.Transfer(loc1)
				team1.player.dir = EAST
			if(team2.player)
				team2.player.Transfer(loc2)
				team2.player.dir = WEST

			var/list/shields = list()
			for(var/turf/t in orange(1, loc1))
				shields += new /obj/Shield(t)
			for(var/turf/t in orange(1, loc2))
				shields += new /obj/Shield(t)

			timer.setTime(0, 10)

			while(!timer.countdown())
				sleep(10)

			team1.reset()
			team2.reset()

			if(team1.player)
				team1.player.HP = team1.player.MHP
				team1.player.MP = team1.player.MMP+team1.player.extraMMP
				team1.player.updateHPMP()
			if(team2.player)
				team2.player.HP = team2.player.MHP
				team2.player.MP = team2.player.MMP+team2.player.extraMMP
				team2.player.updateHPMP()

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

					for(var/i = 1 to 10)
						if(team1.lost || team2.lost) break
						sleep(1)
			end()


		end()
			if(team1.isReconnecting) team1.lost = TRUE
			if(team2.isReconnecting) team2.lost = TRUE

			var/skip = FALSE
			if((team1.lost && team2.lost) || (!team1.lost && !team2.lost))
				team1.score++
				team2.score++

				if(team1.score > team2.score)
					team2.lost = TRUE
					team1.lost = FALSE
				else if(team1.score < team2.score)
					team1.lost = TRUE
					team2.lost = FALSE
				else
					skip = TRUE
					if(team1.score == 3)
						team1.player << infomsg("You drew the match against [team2.name]")
						team2.player << infomsg("You drew the match against [team1.name]")
						state = 0

						if(spectators) spectators << infomsg("[spectateObj.name] ended in a draw.")
			if(!skip)
				if(!team1.lost && team1.won())
					team1.player << infomsg("You won the match against [team2.name]")
					team2.player << errormsg("You lost the match against [team1.name]")

					currentMatches.reward(team1, team2)
					state = 0

					if(spectators) spectators << infomsg("[spectateObj.name] - [team1.name] won.")
				else if(!team2.lost && team2.won())
					team2.player << infomsg("You won the match against [team1.name]")
					team1.player << errormsg("You lost the match against [team2.name]")

					currentMatches.reward(team2, team1)
					state = 0

					if(spectators) spectators << infomsg("[spectateObj.name] - [team2.name] won.")
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

				spawn()
					if(team1.player.loc && !istype(team1.player.loc.loc, /area/arenas))
						team1.player.Transfer(locate(arena.x1 + 9,  arena.y1 + 8, arena.z1))
				return 1

			else if(team2.isReconnecting && p.ckey == team2.id)
				team2.isReconnecting = FALSE
				team2.player = p
				team2.player.rankedArena = src

				spawn()
					if(team2.player.loc && !istype(team2.player.loc.loc, /area/arenas))
						team2.player.Transfer(locate(arena.x1 + 15,  arena.y1 + 8, arena.z1))
				return 1
			return 0

		disconnect(mob/Player/p)
			if(team1.player == p)
				team1.isReconnecting = TRUE
				team1.player = null
				team1.timer.invisibility = 0

			else if(team2.player == p)
				team2.isReconnecting = TRUE
				team2.player = null
				team2.timer.invisibility = 0

		dispose()
			arena.used = 0
			currentMatches.removeArena(src)
			if(spectators)
				var/arena/a
				if(currentMatches.arenas) a = pick(currentMatches.arenas)
				for(var/mob/Player/p in spectators)
					removeSpectator(p)

					if(a) a.addSpectator(p)

				spectators = null

			spectateObj.dispose()
			spectateObj = null

			if(team1.player)
				var/obj/o = pick(duel_chairs)
				team1.player.Transfer(o.loc)
				team1.player.rankedArena = null
				team1.player = null
			if(team2.player)
				var/obj/o = pick(duel_chairs)
				team2.player.Transfer(o.loc)
				team2.player.rankedArena = null
				team2.player = null

			arena.used   = null
			arena        = null
			timer        = null
			scoreboard   = null
			team1.timer  = null
			team2.timer  = null
			team1        = null
			team2        = null

			unload_vault(FALSE)


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
		name   = p.pname ? p.pname : p.name
		id     = p.ckey
		score  = 0

		isReconnecting = FALSE

	proc
		won()
			score++
			return score >= 2
		reset()
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

				pixel_x = minutes ? -8 : 2

				updateDisplay()

			countdown()
				seconds--

				if(seconds < 0 && minutes > 0)
					minutes--
					seconds = 59

					pixel_x = minutes ? -8 : 2

				updateDisplay()

				return seconds < 0

			updateDisplay()
				if(minutes)
					maptext = "<b><font size=4 color=#FF4500>[minutes]:[seconds < 10 ? "0" : ""][seconds]</font></b>"
				else
					maptext = "<b><font size=4 color=#FF4500>[seconds]</font></b>"



var/list/skill_rating

skill_stats
	var/wins   = 0
	var/rating = 200
	var/name

proc
	getSkillGroup(var/ckey)
		var/skill_stats/s = skill_rating[ckey]
		if(s && s.wins >= WINS_REQ)
			var/pos = skill_rating.Find(ckey, skill_rating.len - 2)
			if(s.rating >= 1800 && pos) return "<font color=#9f0419>Champion</font>"
			if(s.rating >= 1600) return "<font color=#aa2fbd>Grandmaster</font>"
			if(s.rating >= 1400) return "<font color=#01e4ac>Master</font>"
			if(s.rating >= 1200) return "<font color=#ff0000>Archwizard</font>"
			if(s.rating >= 1000) return "<font color=#E5E4E2>Battlewizard</font>"
			if(s.rating >= 800)  return "<font color=#FFD700>Wizard</font>"
			if(s.rating >= 600)  return "<font color=#C0C0C0>Sorcerer</font>"
			if(s.rating >= 400)  return "<font color=#CD7F32>Journeyman</font>"
			if(s.rating >= 200)  return "Apprentice"
			return "Novice"
		return "Unranked"



obj/spectate
	var/tmp/arena/parent
	mouse_over_pointer = MOUSE_HAND_POINTER

	New(arena/parent)
		src.parent = parent
		updateName()

	Click()
		if(!parent) return
		if(parent.spectators && (usr in parent.spectators))
			parent.removeSpectator(usr)
		else
			parent.addSpectator(usr)

	proc
		dispose()
			parent = null
			loc    = null
		updateName()
			name = "[parent.team1.name] VS [parent.team2.name][parent.spectators ? " - Viewers: [parent.spectators.len]" : ""]"


obj/scoreboard
	icon = 'Rock.dmi'
	mouse_over_pointer = MOUSE_HAND_POINTER

	Click()
		..()
		if(skill_rating)

			var/const/SCOREBOARD_HEADER = {"<html><head><title>Season 1 Leaderboard</title><style>body
{
	background-color:#FAFAFA;
	font-size:large;
	margin: 0;
	padding:0px;
	color:#404040;
}
table.file
{
	background-color:#FAFAFA;
	border-collapse: collapse;
	text-align: left;
	width:103%;
	font: normal 13px/100% Verdana, Tahoma, sans-serif;
	border: solid 1px #E5E5E5;
	margin: 3px;
	padding:3px;
}
tr.file_white
{
	background-color:#FAFAFA;
	border: solid 1px #E5E5E5;
}
tr.file_black
{
	background-color:#DFDFDF;
	border: solid 1px #E5E5E5;
}
}</style></head><body><center><table align="center" class="file"><tr><td colspan="4"><center>Season 1</center></td></tr><tr><td colspan="4"><center><br>*Note: Ranks are based on your skill rating and not just amount of wins.<br></center></td></tr><tr><td>#</td><td>Name</td><td>Rank</td><td>Wins</td></tr>"}

			var/html = ""
			var/rankNum = 1
			var/isWhite = TRUE
			for(var/i = skill_rating.len to 1 step -1)
				var/skill_stats/s = skill_rating[skill_rating[i]]
				if(s.wins < WINS_REQ) continue
				var/seconderySkillGroup
				if(s.rating >= 1800 && skill_rating.len - i <= 2)
					seconderySkillGroup = " [1 + skill_rating.len - i]"
				else if(s.rating >= 200)
					seconderySkillGroup = " [5 - round((s.rating % 200) / 40)]"
				html += "<tr class=[isWhite ? "file_white" : "file_black"]><td>[rankNum]</td><td>[s.name]</td><td>[getSkillGroup(skill_rating[i])][seconderySkillGroup]</td><td>[s.wins]</td></tr>"
				isWhite = !isWhite
				rankNum++
			usr << browse(SCOREBOARD_HEADER + html + "</table></center></html>","window=scoreboard")

area/arenas
	Entered(atom/movable/Obj)
		..()
		if(isplayer(Obj))
			var/mob/Player/user = Obj
			var/obj/items/wearable/brooms/Broom = locate() in user.Lwearing
			if(Broom) Broom.Equip(user,1)
			var/obj/items/wearable/invisibility_cloak/Cloak = locate() in user.Lwearing
			if(Cloak) Cloak.Equip(user,1)
