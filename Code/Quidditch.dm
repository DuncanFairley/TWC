/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

#define	CHANCETOSTEAL	13 //% chance of stealing quaffle from a player
#define CHANCETOBUMP	40 //% chance of knocking quaffle away from a player

#define CHANCEFORSNITCH	25 //% chance of catching the snitch

#define CHANCEFUMBLEQUAFFLE	10 //% chance of fumbling the quaffle when you try to pick it up

#define CHANCEBLUDGERDROP	85 //% chance of the bludger making you drop the quaffle
#define CHANCEBLUDGERSTUN	30 //% chance of the bludger stunning you


var/list/quidditchspectators = list()

area/Quidditch/goaliezone
	Enter(atom/movable/O)
		if(ismob(O))
			if(quidditchmatch) if(quidditchmatch.gameon && O:position != "Keeper")
				return 0
		return ..()
turf/quidHuffle/Entered(mob/M) M.loc = locate(69,49,14)
turf/quidSlyth/Entered(mob/M) M.loc = locate(28,58,14)
turf/quidRaven/Entered(mob/M) M.loc = locate(28,49,14)
turf/quidGryff/Entered(mob/M) M.loc = locate(69,58,14)
turf/quidEntrance/Entered(mob/M) M.loc = locate(49,29,14)
turf/quidExit/Entered(mob/Player/M) if(istype(M,/mob/Player))M.Say("Reception")

turf/quidditch
	icon = 'obj.dmi'
	density = 0
	left
		icon_state = "left"
	bleft
		icon_state = "bleft"
	bottom
		icon_state = "bottom"
	bright
		icon_state = "bright"
	tleft
		icon_state = "tleft"
	top
		icon_state = "top"
	tright
		icon_state = "tright"
	right
		icon_state = "right"
obj/underlays/QTeam
	icon = 'underlays.dmi'
	icon_state = "blue"
mob/Quidditch/verb
	Announce_To_Spectators(msg as text)
		set category = "Quidditch"
		if(!msg) return
		if(quidditchmatch)
			quidditchmatch.MsgAll("<b><font SIZE=2 COLOR=#c0c0c0>Quidditch Speakers&gt; </font></b>[src.name]<font SIZE=2 COLOR=#c0c0c0><b>:</b> [msg]")
		else
			src << "There's no quidditch match started yet."
	Add_Spectator(mob/Player/P as mob in world)
		set hidden = 1
		/*set category = "Quidditch"
		if(!istype(P, /mob/You/Player)) return
		quidditchspectators.Add(P)
		usr << "\white [P] has been added to the spectators list."*/

	Remove_Spectator()
		set hidden = 1
		/*
		set category = "Quidditch"
		var/blah = input("Remove who?", "Remove Spectator") as null|anything in quidditchspectators
		if(!blah)return
		quidditchspectators.Remove(blah)
		usr << "\white [blah] has been removed from the spectators list."*/


	/* This verb was just something to give a general idea of what you can do. You can do whatever the hell you
		want to do for setting up and starting a match. You will probably want to make it so you have variables coded in
		containing the different house teams, and have it so you can just pick that team instead of selecting people
		each time you want to start a new game.

		You also give out the necessary verbs after you choose the teams, just go through everyone in team1 + team2
		and give the verbs based on their postion. You could also remove them after the game...Although you might want to
		make sure you don't remove the verbs from actual house team players...

		Note: It's 6am so some of this shit might not be useful, or even make sense. */
	Setup_Match()
		set category = "Quidditch"
		var/obj/Hogwarts_Door/D = locate("door1")
		D.door = 0
		D = locate("door2")
		D.door = 0
		D = locate("door3")
		D.door = 0
		D = locate("door4")
		D.door = 0
		var
			inp
			teama
			teamb
			list/teamaplayers[0]
			list/teambplayers[0]
			list/players[0]
		for(var/mob/Player/P in world) players.Add(P)
		players.Add("Done")
		teama = input("What is team 1 called?", "Team 1") as null|text
		teamb = input("What is team 2 called?", "Team 2") as null|text
		if(!teama || !teamb) return
		var/list/positions = list("Chaser1", "Chaser2", "Chaser3", "Beater", "Beater", "Seeker", "Keeper")
		while (1)
			inp = input("Select a player for [teama]", "[teama]", "Done") as null|anything in players
			if(!inp) return
			else if(inp == "Done") break
			var/pos = input("What position are they playing?", "[teama]") as null|anything in positions
			if(!pos) continue
			var/mob/Player/P = inp
			P.position = pos
			teamaplayers.Add(P)
			players.Remove(inp)
			positions.Remove(pos)

		positions = list("Chaser1", "Chaser2", "Chaser3", "Beater", "Beater", "Seeker", "Keeper")

		while (1)
			inp = input("Select a player for [teamb]", "[teamb]", "Done") as null|anything in players
			if(!inp) return
			else if(inp == "Done") break
			var/pos = input("What position are they playing?", "[teamb]") as null|anything in list("Chaser1", "Chaser2", "Chaser3", "Beater", "Beater", "Seeker", "Keeper")
			if(!pos) continue
			var/mob/Player/P = inp
			P.position = pos
			teambplayers.Add(P)
			players.Remove(inp)
			positions.Remove(pos)

		quidditchspectators += teamaplayers
		quidditchspectators += teambplayers

		for(var/mob/Player/P in (teamaplayers + teambplayers))
			if(P.position in list("Chaser1", "Chaser2", "Chaser3","Keeper"))
				P.verbs += /mob/Player/quidditch/verb/Steal

		quidditchmatch = new (teama, teamb, teamaplayers, teambplayers)
		usr << "Match setup."

	Clear_Match()
		set category = "Quidditch"
		var/obj/Hogwarts_Door/D = locate("door1")
		D.door = 1
		D = locate("door2")
		D.door = 1
		D = locate("door3")
		D.door = 1
		D = locate("door4")
		D.door = 1
		if(!quidditchmatch)
			usr << "There is no match setup."
			return

		if(quidditchmatch.gameon)
			usr << "There is a game going on. End it before clearing match data."
			return

		for(var/mob/Player/P in (quidditchmatch.team1 + quidditchmatch.team1))
			if(P.Quaffle)
				var/obj/quidditch/quaffle/ball = P.Quaffle
				ball.loc = P.loc
				del ball
			P.Quaffle = null
			if(quidditchspectators) quidditchspectators.Remove(P)
		for(var/mob/Player/p)
			p.position = ""
			p.verbs -= /mob/Player/quidditch/verb/Steal
		for(var/obj/quidditch/quaffle/q in world) del q
		for(var/obj/quidditch/snitch/q in world) del q
		for(var/obj/quidditch/bludger/q in world) del q

		usr << "Match data cleared."
		del quidditchmatch


	Start_Match()
		set category = "Quidditch"
		if(!quidditchmatch)
			usr << "There is no match setup."
			return

		if(quidditchmatch.gameon)
			usr << "There is already a game going on. End it before starting a new one."
			return

		quidditchmatch.team1score = 0
		quidditchmatch.team2score = 0

		for(var/mob/Player/P in (quidditchmatch.team1 + quidditchmatch.team2))
			if(P.Quaffle)
				var/obj/quidditch/quaffle/ball = P.Quaffle
				ball.loc = P.loc
				del ball
			P.Quaffle = null

		//You'll probably want to teleport the people to some spot on the pitch, or have the go there. maybe freeze them as well.
		quidditchmatch.MsgAll("Quidditch match starting between [quidditchmatch.team1name] and [quidditchmatch.team2name] in 10 seconds!")
		sleep(100)
		var/beater = null
		var/obj/Quidditch/Q
		for(var/mob/Player/P in quidditchmatch.team1)
			//P.underlays = list()
			P.underlays.Add(icon('underlays.dmi',"red"))
			switch(P.position)
				if("Chaser1")
					Q = locate(/obj/Quidditch/team1/chaser1)
					P.loc = Q.loc
				if("Chaser2")
					Q = locate(/obj/Quidditch/team1/chaser2)
					P.loc = Q.loc
				if("Chaser3")
					Q = locate(/obj/Quidditch/team1/chaser3)
					P.loc = Q.loc
				if("Beater")
					if(!beater)
						beater = 1
						Q = locate(/obj/Quidditch/team1/beater1)
						P.loc = Q.loc
					else
						Q = locate(/obj/Quidditch/team1/beater2)
						P.loc = Q.loc
				if("Keeper")
					Q = locate(/obj/Quidditch/team1/keeper)
					P.loc = Q.loc
				if("Seeker")
					Q = locate(/obj/Quidditch/team1/seeker)
					P.loc = Q.loc
		beater = null
		for(var/mob/Player/P in quidditchmatch.team2)
			//P.underlays = list()
			P.underlays.Add(icon('underlays.dmi',"blue"))
			switch(P.position)
				if("Chaser1")
					Q = locate(/obj/Quidditch/team2/chaser1)
					P.loc = Q.loc
				if("Chaser2")
					Q = locate(/obj/Quidditch/team2/chaser2)
					P.loc = Q.loc
				if("Chaser3")
					Q = locate(/obj/Quidditch/team2/chaser3)
					P.loc = Q.loc
				if("Beater")
					if(!beater)
						beater = 1
						Q = locate(/obj/Quidditch/team2/beater1)
						P.loc = Q.loc
					else
						Q = locate(/obj/Quidditch/team2/beater2)
						P.loc = Q.loc
				if("Keeper")
					Q = locate(/obj/Quidditch/team2/keeper)
					P.loc = Q.loc
				if("Seeker")
					Q = locate(/obj/Quidditch/team2/seeker)
					P.loc = Q.loc
		quidditchmatch.gameon = 1
		quidditchmatch.MsgAll("Go!")

	End_Match()
		set category = "Quidditch"
		if(!quidditchmatch)
			usr << "There is no match setup."
			return
		if(quidditchmatch.gameon == 0)
			usr << "The game is already over."
			return
		quidditchmatch.MsgAll("[usr] has stopped the game.")
		quidditchmatch.EndGame(usr)

	Readd_Member(mob/M as mob in world, team in list("Team1", "Team2"))
		set category = "Quidditch"
		if(!M) return
		if(team == "Team1")
			quidditchmatch.team1.Add(M)
		else
			quidditchmatch.team2.Add(M)
		usr << "Re-added [M]."


obj/Quidditch
	team1
		icon = 'underlays.dmi'
		icon_state = "red"
		invisibility = 2
		chaser1
		chaser2
		chaser3
		seeker
		keeper
		beater1
		beater2
	team2
		icon = 'underlays.dmi'
		icon_state = "blue"
		invisibility = 2
		chaser1
		chaser2
		chaser3
		seeker
		keeper
		beater1
		beater2


var/quidditch_game/quidditchmatch
quidditch_game
	parent_type = /obj

	var
		team1score = 0
		team2score = 0
		team1name
		team2name
		list/team1
		list/team2
		gameon = 0

	New(nteam1name, nteam2name, list/nteam1, list/nteam2)
		team1name = nteam1name
		team2name = nteam2name
		team1 = nteam1
		team2 = nteam2

	proc
		MsgAll(msg)
			for(var/client/C)
				if(istype(C.mob.loc.loc,/area/Quidditch))
					C << "<b>[msg]</b>"
		EndGame(mob/Player/winner)
			var/obj/Hogwarts_Door/D = locate("door1")
			D.door = 1
			D = locate("door2")
			D.door = 1
			D = locate("door3")
			D.door = 1
			D = locate("door4")
			D.door = 1
			gameon = 0
			if(team1score > team2score)
				MsgAll("[team1name] wins the quidditch match with [team1score] to [team2name]'s [team2score]!")
			else if(team2score > team1score)
				MsgAll("[team2name] wins the quidditch match with [team2score] to [team1name]'s [team1score]!")
			else
				MsgAll("It is a draw! Both [team1name] and [team2name] received [team1score] points!")
			for(var/client/C)
				if(istype(C.mob.loc.loc,/area/Quidditch))
					C.mob.underlays = list()
					switch(C.mob.House)
						if("Hufflepuff")
							C.mob.GenerateNameOverlay(242,228,22)
						if("Slytherin")
							C.mob.GenerateNameOverlay(41,232,23)
						if("Gryffindor")
							C.mob.GenerateNameOverlay(240,81,81)
						if("Ravenclaw")
							C.mob.GenerateNameOverlay(13,116,219)
						if("Ministry")
							C.mob.GenerateNameOverlay(255,255,255)

		Score(mob/Player/scorer, type)
			if(gameon == 0) return
			if(type == "Snitch")
				if(scorer in team1)
					MsgAll("[scorer] has caught the snitch, scoring 150 points for [team1name] and ending the game!!!")
				else
					MsgAll("[scorer] has caught the snitch, scoring 150 points for [team2name] and ending the game!!!")

				if(scorer in team1)
					team1score += 150
				else if(scorer in team2)
					team2score += 150
				EndGame(scorer)
			else if(type == "Quaffle")
				if(scorer in team1)
					MsgAll("[scorer] has scored 10 points for [team1name]!")
					team1score += 10
				else if(scorer in team2)
					MsgAll("[scorer] has scored 10 points for [team2name]!")
					team2score += 10
mob/Player
	var/tmp/obj/Quaffle = null
	var/tmp/cancatch = 1
	var/tmp/canhit = 1
	var/position

obj/quidditch
	snitch
		icon = 'obj.dmi'
		icon_state = "snitch"
		density = 1

		var
			caught

		New()
			. = ..()
			spawn() Wander()

		proc/Wander()
			sleep(1)
			if(src.caught) return
			step_rand(src)
			if(prob(30)) step_rand(src)
			spawn() Wander()

		Bump(atom/movable/O)
			if(!istype(O, /mob/Player)) return
			src.density = 0
			O.Move(src.loc, get_dir(O.loc, src.loc))
			src.density = 1

		verb
			Catch_Snitch()
				set src in view(1)
				if(!usr.flying)
					usr << "<b>You must be flying to catch the snitch!</b>"
					return
				if(!istype(usr, /mob/Player) && !usr.client) return
				var/mob/Player/user = usr
				if(quidditchmatch && user.position != "Seeker")
					usr << "You are not allowed to catch the snitch now."
					return
				if(!istype(src, /obj/quidditch/snitch)) return
				if(src.caught || !user.cancatch) return
				if(prob(CHANCEFORSNITCH))
					user << "You caught the snitch!!"
					if(quidditchmatch)
						quidditchmatch.Score(user, "Snitch")
					else
						world << "[user] has caught the snitch!"
					del(src)
					return
				else
					var/message = pick(list("You reach as high as you can, but just miss the snitch.",
						"The snitch flies out of your reach as you try to grab it.",
						"You miss the snitch by a mile"))
					user.cancatch = 0
					spawn(15) user.cancatch = 1
					user << message
					return


	quaffle
		icon = 'obj.dmi'
		icon_state = "quaffle"
		density=1

		var
			caught
			mob/Player/catcher

		New()
			.=..()
			spawn()	Wander()

		proc/Wander()
			sleep(1)
			if(src.caught) return
			step_rand(src)
			sleep(1)
			spawn(2)
				Wander()


		verb
			/* For now this is accesible to everyone. When only chasers can use it, "set src in view(1)" will be removed
				and "if(user.position != "Chaser") return" will be uncommented. You'll then be able to give the Catch verb
				to whoever you want, and the captains will also be able to give it out in an indirect way.
				I added the chaser check in case they were removed as chaser, but still had the verb.

				Oh, and keepers can catch/throw too =) */
			Catch()
				set src in view(1)
				if(!usr.flying)
					usr << "<b>You must be flying to catch the quaffle!</b>"
					return
				if(!istype(usr, /mob/Player) && !usr.client) return
				var/mob/Player/user = usr
				if(quidditchmatch && !(user.position in list("Chaser1", "Chaser2", "Chaser3")) && user.position != "Keeper")
					usr << "You are not allowed to catch the quaffle now."
					return
				if(!istype(src, /obj/quidditch/quaffle)) return
				if(user.Quaffle)
					user << "You already have a quaffle!"
					return
				if(src.caught || !user.cancatch) return
				if(prob(CHANCEFUMBLEQUAFFLE))
					user << "You fumbled the quaffle!"
					return
				src.caught = 1
				walk(src, 0)
				user.Quaffle = src
				src.catcher = user
				src.loc = user
				user << "You caught the quaffle!"

			/* Anyone who's holding a quaffle is able to throw it, to avoid bugs. */

			Throw()
				set src in usr
				var/mob/Player/thrower = usr
				if(thrower.Quaffle)
					var/obj/quidditch/quaffle/ball = thrower.Quaffle
					thrower.Quaffle = null
					ball.loc = thrower.loc
					walk(ball, thrower.dir, 1)
					ball.caught = 0
					thrower.cancatch = 0
					spawn(3) thrower.cancatch = 1
					spawn(20)
						if(ball.catcher == thrower) ball.catcher = null
						else if(ball.catcher) return
						walk(src, 0)
						spawn() ball.Wander()
				else
					thrower << "You don't have a quaffle!"


	bludger
		icon='obj.dmi'
		icon_state="bludger"
		density=1
		var
			mob/target
			hit
			mob/hitter
			dontgettarget

		New()
			.=..()
			spawn()	Wander()

		proc/Wander()
			sleep(1)
			if(hit) return
			if(!target && !dontgettarget)
				for(var/mob/Player/p in view(6, src))
					target = p
					var/turf/t = get_step_towards(src,p)
					if(t.density)
						src.target = null
						src.dontgettarget = 1
						spawn(40) src.dontgettarget = 0
						break
					spawn(30)
						if(!hit)
							target = null
							walk(src, 0)
					break
			if(!target)
				step_rand(src)
			else if(target in view(1, src))
				walk(src, 0)
				//src.Move(target.loc)
				spawn(8) src.Bump(target)
			else
				walk_to(src, target, 0, 3)
			spawn(2)
				Wander()

		Bump(atom/movable/O)
			if(!istype(O,/mob/Player) || hit) return
			var/mob/Player/M = O
			if(M.position == "Keeper") return
			if(prob(CHANCEBLUDGERDROP) && M.Quaffle)
				var/obj/quidditch/quaffle/ball = M.Quaffle
				M.Quaffle = null
				ball.catcher = null
				ball.caught = 0
				ball.loc = M.loc

				src.target = null
				M << "A bludger hits you and knocks the quaffle out of your hand!"
			if(prob(CHANCEBLUDGERSTUN))
				var/time = rand(5,10)
				M.frozen = 1
				src.target = null
				src.dontgettarget = 1
				spawn(40)
					if(src)src.dontgettarget = 0
				M << "You are hit by a bludger and it stuns you for [time] seconds!"
				src = null
				spawn(time * 10)
					M.frozen = 0
					M << "You have been unfrozen."





		verb

			/* Same idea as chaser */
			Hit()
				set src in view(1)
				if(!usr.flying)
					usr << "<b>You must be flying to hit the bludger!</b>"
					return
				if(!istype(usr, /mob/Player) && !usr.client) return
				var/mob/Player/user = usr
				if(quidditchmatch && user.position != "Beater")
					usr << "You are not allowed to hit the bludger now."
					return
				if(!user.canhit) return
				user.canhit = 0
				spawn(6) user.canhit = 1
				var/obj/quidditch/bludger/ball
				var/turf
					T1 = get_step(user, turn(user.dir, 45))
					T2 = get_step(user, user.dir)
					T3 = get_step(user, turn(user.dir, -45))
					T4 = src.loc

				for(var/obj/quidditch/bludger/B in (T1.contents + T2.contents + T3.contents + T4.contents))
					if(B == src)
						ball = B
						break

				if(!ball) return
				hit = 1
				hitter = user
				ball.target = null
				walk(ball, user.dir)
				spawn(11)
					if(hitter != user) return
					hit = 0
					walk(src, 0)
					spawn() ball.Wander()

mob/Player/quidditch/verb/Steal()
	var/turf/T = get_step(usr, usr.dir)
	for(var/mob/Player/from in T)
		if(!from.Quaffle) continue
		if(prob(CHANCETOSTEAL))
			src << "You have stolen the quaffle from [from]"
			from << "[src] has stolen the quaffle from you!"
			src.Quaffle = from.Quaffle
			from.Quaffle = null
			src.Quaffle:catcher = usr
			Quaffle.Move(usr)
		else if(prob(CHANCETOBUMP))
			src << "You have bumped the quaffle away from [from]"
			from << "[src] has bumped the quaffle away from you!"
			var/obj/quidditch/quaffle/ball = from.Quaffle
			from.Quaffle.loc = from.loc
			from.Quaffle = null
			ball.catcher = null
			ball.caught = 0
			walk(ball, src.dir, 1)
			spawn(20)
				if(ball.catcher) return
				walk(src, 0)
				spawn() ball.Wander()
		else
			src << "You try to steal the quaffle from [from] but you fail."
		return
turf/Entered(atom/movable/M)
	if(M)
		for(var/atom/A in src)
			if(A == M) continue
			if(!M)break
			M.SteppedOn(A)
turf/Exited(atom/movable/M)
    for(var/atom/A in src)
        if(A == M) continue
        if(!M)break
        M.SteppedOff(A)



atom/movable/proc/SteppedOn(atom/movable/A)

atom/movable/proc/SteppedOff(atom/movable/A)



mob/Player/SteppedOn(atom/movable/A)
	if(istype(A,/obj/items/Whoopie_Cushion))
		if(A:isset)
			A:Fart(src)
	else if(istype(A,/obj/drop_on_death))
		A:take(src)
	else if(istype(A,/obj/mirror/base))
		A:mirror(src)
	else if(istype(A,/obj/teleport))
		A:Teleport(src)
	else if(istype(A,/obj/portkey))
		A:Teleport(src)
	else if(istype(A,/obj/shop))
		A:shop(src)

mob/Player/SteppedOff(atom/movable/A)
	..()
	if(istype(A,/obj/shop))
		A:unshop(src)


atom/movable/SteppedOn(atom/movable/A)
	if(istype(A,/obj/mirror/base))
		A:mirror(src)

atom/movable/SteppedOff(atom/movable/A)
	if(istype(A,/obj/mirror/base))
		A:unmirror(src)


turf
	Quidditch
		icon = 'obj.dmi'

		Q1
			icon_state = "Q1"
			layer = 6
			Entered(atom/movable/Obj, atom/OldLoc)
				if(!istype(Obj, /obj/quidditch/quaffle)) return
				if(quidditchmatch)
					if(!quidditchmatch.gameon)return //If there's a match setup and it's not started, exit
				/* Make sure the ball is going from the right direction (Not from back or sides) */
				if(src.dir == NORTH)
					if(Obj.dir != NORTHWEST && Obj.dir != NORTH && Obj.dir != NORTHEAST) return
				else
					if(Obj.dir != SOUTHWEST && Obj.dir != SOUTH && Obj.dir != SOUTHEAST) return

				/* Now that that's over with... */
				var/obj/quidditch/quaffle/ball = Obj
				if(!ball.catcher || !ismob(ball.catcher)) return
				if(ball.caught) return
				var/mob/Player/scorer = ball.catcher
				if(quidditchmatch)
					if(src.dir == NORTH)
						if(scorer in quidditchmatch.team1)
							quidditchmatch.MsgAll("[scorer] of <b>[quidditchmatch.team1name]</b> has scored 10 points for <b>[quidditchmatch.team2name]</b>!")
							quidditchmatch.team2score += 10
						else if(scorer in quidditchmatch.team2)
							quidditchmatch.MsgAll("[scorer] has scored 10 points for <b>[quidditchmatch.team2name]</b>!")
							quidditchmatch.team2score += 10
					else
						if(scorer in quidditchmatch.team2)
							quidditchmatch.MsgAll("[scorer] of <b>[quidditchmatch.team2name]</b> has scored 10 points for <b>[quidditchmatch.team1name]</b>!")
							quidditchmatch.team1score += 10
						else if(scorer in quidditchmatch.team1)
							quidditchmatch.MsgAll("[scorer] has scored 10 points for <b>[quidditchmatch.team1name]</b>!")
							quidditchmatch.team1score += 10
				else
					range() << "[scorer] has scored 10 points!"


		Q2
			icon_state = "Q2"
			density = 1
			Enter(atom/movable/O) {if(istype(O, /obj/quidditch/quaffle)) return 1; }
area/Quidditch
	no_broom_barrier
		Entered()
			return
	quidditch_field
	observe_area
		Entered(mob/Player/M)
			..()
			if(!istype(M, /mob/Player))return
			var/obj/hud/player/R = new()
			M.client.screen += R
			var/obj/hud/ball/B = new()
			M.client.screen += B
			var/obj/hud/cancel/C = new()
			M.client.screen += C
		Exited(mob/Player/M)
			..()
			if(!istype(M, /mob/Player))return
			M.client.eye=usr
			M.client.perspective=MOB_PERSPECTIVE
			for(var/obj/hud/player/R in M.client.screen)
				del(R)
			for(var/obj/hud/cancel/C in M.client.screen)
				del(C)
			for(var/obj/hud/ball/B in M.client.screen)
				del(B)
obj
	hud
		player
			name = "Observe a player"
			icon = 'HUD.dmi'
			icon_state = "obsplayer"
			screen_loc = "12,1"
			Click()
				var/list/players = list()
				for(var/mob/Player/M in locate(/area/Quidditch/quidditch_field))
					players += M
				var/obs = input("Which player would you like to observe?") as null|mob in players
				if(!obs) return
				usr.client.eye=obs
				usr.client.perspective=EYE_PERSPECTIVE
				usr << "You are now viewing [obs]. Click cancel on your HUD to return."
		ball
			name = "Observe a ball"
			icon = 'HUD.dmi'
			icon_state = "obsball"
			screen_loc = "13,1"
			Click()
				var/list/balls = list()
				for(var/obj/quidditch/bludger/Q in locate(/area/Quidditch/quidditch_field))
					balls.Add(Q)
				for(var/obj/quidditch/snitch/Q in locate(/area/Quidditch/quidditch_field))
					balls.Add(Q)
				for(var/obj/quidditch/quaffle/Q in locate(/area/Quidditch/quidditch_field))
					balls.Add(Q)
				var/obs = input("Which quidditch ball would you like to observe?") as null|obj in balls
				if(!obs) return
				usr.client.eye=obs
				usr.client.perspective=EYE_PERSPECTIVE
				usr << "You are now viewing [obs]. Click cancel on your HUD to return."
		cancel
			name = "Return to View"
			icon = 'HUD.dmi'
			icon_state = "obsself"
			screen_loc = "14,1"
			Click()
				usr.client.eye=usr
				usr.client.perspective=MOB_PERSPECTIVE