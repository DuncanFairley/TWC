/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
var/EventHandler/EventHandler = new
//Events cannot be scheduled at the exact same time
EventHandler
	var/list/Event/Events = list()
	var/tmp/list/eventstarttimes = list()
	proc
		Print_Event_Details()
			//Output your event schedule for debugging purposes
			for(var/Event/E in Events)
				. += "[time2text(E.starttime)] - [E.name] calling [E.procname]<br>"
			return
		Prime_Next_Event()
			//This proc determines how long it will have to wait until the next event, and then starts waiting.
			//The Events /list may be empty
			Flush_Old_Events()
			if(Events.len)
				Order_Queue()
				var/Event/nextEvent
				while(!nextEvent)
					for(var/Event/E in Events)
						if(E.starttime == eventstarttimes[1])
							nextEvent = E
					if(!nextEvent)
						eventstarttimes.Remove(eventstarttimes[1])
				sleep(nextEvent.starttime - world.realtime)
				Start_Event(nextEvent)

			else
				// /list is empty, so wait until new Event is added
		Recycle_Event(Event/E)
			//If an event is intended to start again, reset its start time and leave it in the Events /list
			E.starttime += E.timebeforerestart
		Flush_Old_Events()
			//Remove any events that are older than 30 seconds.
			//Eg: Events that were supposed to execute while the server was down
			for(var/Event/E in Events)
				if((world.realtime - E.starttime) > 300)
					Events.Remove(E)
		Start_Event(Event/E)
			spawn()call(E.procname)(E.procargs)
			world.log << "[time2text(E.starttime)] - [E.name] calling [E.procname]<br>"
			if(E.timebeforerestart)
				Recycle_Event(E)
			else
				Events.Remove(E)
			Prime_Next_Event()
		Order_Queue()
			eventstarttimes = list()
			for(var/Event/E in Events)
				eventstarttimes.Add(E.starttime)
			eventstarttimes = bubblesort(eventstarttimes)

	New()
		..()
		Prime_Next_Event()
mob/test/verb/Clear_Event_Schedule()
	set category = "TEST"
	del(EventHandler)
mob/test/verb/Print_Event_Details()
	set category = "TEST"
	src << EventHandler.Print_Event_Details()
mob/test/verb/Create_FFA_Event()
	set category = "TEST"
	src << num2text(world.realtime,13)
	var/tmpname = input("Event name")
	var/tmpstarttime = text2num(input("start time","Start time","[num2text(world.realtime,14)]"))
	var/tmpprocname = "/proc/start_FFA"
	var/tmpprocargs = 3
	var/tmptimebeforerestart = text2num(input("restart time","Restart period","6048000"))
	spawn()new/Event(tmpname,tmpstarttime,tmpprocname,tmpprocargs,tmptimebeforerestart)
	src << "New event set up at [time2text(tmpstarttime)], the next time it will occur will be [time2text(tmpstarttime+tmptimebeforerestart)]<br>"

mob/test/verb/Create_CW_Event()
	set category = "TEST"
	src << num2text(world.realtime,13)
	var/tmpname = input("Event name")
	var/tmpstarttime = text2num(input("start time","Start time","[num2text(world.realtime,14)]"))
	var/tmpprocname = "/proc/start_CW"
	var/tmpprocargs = 3
	var/tmptimebeforerestart = text2num(input("restart time","Restart period","6048000"))
	spawn()new/Event(tmpname,tmpstarttime,tmpprocname,tmpprocargs,tmptimebeforerestart)
	src << "New event set up at [time2text(tmpstarttime)], the next time it will occur will be [time2text(tmpstarttime+tmptimebeforerestart)]<br>"

Event
	//If an event exists, it hasn't been used.
	var/name = "Unnamed Event"
	var/starttime				//Start time of event in realtime format which isn't entirely accurate- still enough for me though.
	var/procname				//The proc to call when the event occurs
	var/procargs				//Optional arguments to above proc
	var/timebeforerestart
	New(tmpname, tmpstarttime, tmpprocname, tmpprocargs, tmptimebeforerestart)
		..()
		name = tmpname
		starttime = tmpstarttime
		procname = tmpprocname
		procargs = tmpprocargs
		timebeforerestart = tmptimebeforerestart

		//If there isn't already an EventHandler for whatever reason, make one and add the Event
		if(!EventHandler)
			EventHandler = new
		EventHandler.Events.Add(src)
		var/EventHandler/newHandler = new
		newHandler.Events = EventHandler.Events
		del(EventHandler)
		EventHandler = newHandler
		EventHandler.Prime_Next_Event()


proc/start_FFA(rounds)
	if(currentArena)
		world.log << "[time2text(world.timeofday)]-start_FFA couldn't take place as there was already an arena match"
		return
	arenaSummon = 3
	for(var/client/C)
		C << "<h3>An automated FFA is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a> The first round will start in 2 minutes.</h3>"
	sleep(1200)
	while(rounds)
		rounds--
		arenaSummon = 3
		for(var/client/C)
			C << "<h3>An automated FFA is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a> The [rounds==0 ? "last" : ""] round will start in 1 minute.</h3>"
		sleep(600)
		currentArena = new()
		arenaSummon = 0
		currentArena.roundtype = FFA_WARS
		for(var/mob/M in locate(/area/arenas/MapThree/WaitingArea))
			if(M.client)
				M.DuelRespawn = 0
				currentArena.players.Add(M)
		if(currentArena.players.len < 2)
			currentArena.players << "There isn't enough players to start the round."
			for(var/mob/Player/M in currentArena.players)
				M << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[M];action=arena_leave\">clicking here.</a></b>"
			del(currentArena)
		else
			currentArena.players << "<center><font size = 4>The arena mode is <u>Free For All</u>. Everyone is your enemy.<br>The last person standing wins!</center>"
			sleep(30)
			currentArena.players << "<h5>Round starting in 10 seconds</h5>"
			sleep(50)
			currentArena.players << "<h5>5 seconds</h5>"
			sleep(50)
			currentArena.players << "<h4>Go!</h5>"
			currentArena.started = 1
			var/list/rndturfs = list()
			for(var/turf/T in locate(/area/arenas/MapThree/PlayArea))
				rndturfs.Add(T)
			currentArena.speaker = pick(MapThreeWaitingAreaTurfs)
			for(var/mob/M in currentArena.players)
				var/turf/T = pick(rndturfs)
				M.loc = T
				M.density = 1
			while(currentArena)
				sleep(20)

proc/start_CW(rounds)
	if(currentArena)
		world.log << "[time2text(world.timeofday)]-start_CW couldn't take place as there was already an arena match"
		return
	arenaSummon = 2
	for(var/client/C)
		if(C.mob)
			if(C.mob.Auror||C.mob.DeathEater)
				C << "<h3>An automated Clan Wars is beginning soon. If you wish to participate, robe up(and stay robed for the ENTIRE event) then <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a> The round will start in 3 minutes.</h3>"
	sleep(1200)
	while(rounds)
		rounds--
		for(var/client/C)
			if(C.mob)
				if(C.mob.Auror||C.mob.DeathEater)
					C << "<h3>An automated Clan Wars is beginning soon. If you wish to participate, robe up(and stay robed for the ENTIRE event) then <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a> The round will start in 1 minute.</h3>"
		sleep(600)
		currentArena = new()
		arenaSummon = 0
		currentArena.roundtype = CLAN_WARS
		var/list/plyrs = list()
		for(var/mob/M in locate(/area/arenas/MapTwo/Auror))
			plyrs.Add(M)
		for(var/mob/M in locate(/area/arenas/MapTwo/DE))
			plyrs.Add(M)
		for(var/mob/M in locate(/area/arenas/MapTwo))
			plyrs.Add(M)
		var/countDE = 0
		var/countAuror = 0
		for(var/mob/Player/M in plyrs)
			if(M.Auror)countAuror++
			else if(M.DeathEater)countDE++
			M.DuelRespawn = 0
			currentArena.players.Add(M)
		if( !(countDE>0&&countAuror>0) )
			currentArena.players << "<h3>There isn't enough players to start the round.</h3>"
			del(currentArena)
		else
			clanevent1 = 1
			clanevent1_respawntime = 40 //Time before pillar respawns
			clanevent1_pointsgivenforpillarkill = 5
			var/MHP = 100
			for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/Auror))
				C.enable(MHP)
			for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/DE))
				C.enable(MHP)

			currentArena.goalpoints = 20 //Points required to win
			currentArena.teampoints = list("Aurors" = 0, "Deatheaters" = 0)
			currentArena.plyrSpawnTime = 5
			currentArena.amountforwin = 15
			for(var/mob/M in currentArena.players)
				if(M.aurorrobe)
					var/obj/Bed/B = pick(Map2Aurorbeds)
					M.loc = B.loc
				else if(M.derobe)
					var/obj/Bed/B = pick(Map2DEbeds)
					M.loc = B.loc
				M.dir = SOUTH

			currentArena.players << "<center><font size = 4>The arena mode is <u>Clan Wars</u>. Aurors vs Deatheaters.<br>The first clan to reach [currentArena.goalpoints] points wins!</center>"
			sleep(30)
			currentArena.players << "<h5>Round starting in 10 seconds. STAY ROBED FOR THE ENTIRE EVENT.</h5>"
			sleep(50)
			currentArena.players << "<h5>5 seconds</h5>"
			sleep(50)
			currentArena.players << "<h4>Go!</h5>"
			currentArena.started = 1
			while(currentArena)
				sleep(20)

/*
Rounds to play
How long to wait for players


LET  PEOPLE TELEPORT IN



*/