/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
proc
	bubblesort(list/L)
		var i, j
		for(i=L.len,i>0,i--)
			for(j=1,j<i,j++)
				if(L[j]>L[j+1])
					L.Swap(j,j+1)
		return L
	bubblesort_atom_name(list/L)
	//Looks awful, but seems to work
		var i, j
		for(i=L.len,i>0,i--)
			for(j=1,j<i,j++)
				var/mob/j1 = L[j]
				var/mob/j2 = L[j+1]
				if(j1 && j2)
					if(j1.name == "Deatheater" && j2.name != "Deatheater")
						if(j1.prevname>j2.name) L.Swap(j,j+1)
					else if(j1.name == "Deatheater" && j2.name == "Deatheater")
						if(j1.prevname>j2.prevname) L.Swap(j,j+1)
					if(j1.name != "Deatheater" && j2.name == "Deatheater")
						if(j1.name>j2.prevname) L.Swap(j,j+1)
					else if(j1.name != "Deatheater" && j2.name != "Deatheater")
						if(j1.name>j2.name) L.Swap(j,j+1)
turf
	duelmat_gryff
		name = "Duel mat"
		icon = 'DuelArena.dmi'
	duelmat_raven
		name = "Duel mat"
		icon = 'DuelArena.dmi'
	duelmat_slyth
		name = "Duel mat"
		icon = 'DuelArena.dmi'
	duelmat_huffle
		name = "Duel mat"
		icon = 'DuelArena.dmi'
var/list/turf/duelsystemcenter/duelsystems = list()
#define DUEL_DISTANCE 9

Duel
	var/mob/player1 = null
	var/mob/player2 = null
	var/ready1 = 0
	var/ready2 = 0
	var/countdown = 5
	var/atom/duelcenter
	New(var/atom/duelcenter)
		..()
		src.duelcenter = duelcenter
	Del()
		for(var/turf/duelblock/B in block(locate(duelcenter.x-5,duelcenter.y,duelcenter.z),locate(duelcenter.x+5,duelcenter.y,duelcenter.z)))
			B.density = 0
		player1.movable = 0
		if(player2)player2.movable = 0
		..()
	proc
		Pre_Duel()
			player1.followplayer = 0
			player2.followplayer = 0
			sleep(100)
			if(!(ready1 && ready2))
				range(9,duelcenter) << errormsg("<i>The players did not ready themselves within the time limit. Duel cancelled.</i>")
				player1.movable = 0
				player2.movable = 0
				del src
			else
				player1.followplayer = 0
				player2.followplayer = 0
				range(9,duelcenter) << "<i><font size = 3>The duel will now start in [countdown] seconds!"
				var/obj/o = new
				o.pixel_y = 32
				for(var/i=5;i>0;i--)
			//		range(9,duelcenter) << i
					duelcenter.overlays -= o
					o.maptext = "<b><font size=4 color=#FF4500> [i]</font></b>"
					duelcenter.overlays += o
					sleep(10)
				duelcenter.overlays -= o
				range(9,duelcenter) << "GO!"
				for(var/turf/duelblock/B in block(locate(duelcenter.x-5,duelcenter.y,duelcenter.z),locate(duelcenter.x+5,duelcenter.y,duelcenter.z)))
					B.density = 0
				player1.movable = 0
				player2.movable = 0
				View_Check_Ticker()
		View_Check_Ticker()
			spawn() while(src)
				sleep(5)
				if(get_dist(player1,duelcenter) > DUEL_DISTANCE)
					range(DUEL_DISTANCE,duelcenter) << infomsg("<font size=3>[player1] has left the duel area. [player2] wins!</font>")
					player1 << errormsg("<font size=3>You have left the duel area. [player2] wins.</font>")
					del(src)
				else if(get_dist(player2,duelcenter) > DUEL_DISTANCE)
					range(DUEL_DISTANCE,duelcenter) << infomsg("<font size=3>[player2] has left the duel area. [player1] wins!</font>")
					player2 << errormsg("<font size=3>You have left the duel area. [player1] wins.</font>")
					del(src)
turf/duelblock/density=0
obj
	portduelsystemtiles
		icon = 'DuelArena.dmi'
		name = "Portable Duel"
		layer = 2
		c1/icon_state = "c1"
		c2/icon_state = "c2"
		c3/icon_state = "c3"
		c5/icon_state = "c5"
		c6/icon_state = "c6"
		c7/icon_state = "c7"
obj
	duelblock
		name = ""
obj
	portduelsystem
		name = "Portable Duel System"
		icon = 'DuelArena.dmi'
		icon_state = "c4"
		var/tmp/Duel/D
		var/unpacked = 0
		var/ckeyowner
		var/list/obj/dueltiles = list()
		verb/Disown()
			var/input = alert("Are you sure you wish to allow anyone to pick this system up?",,"Yes","No")
			if(input == "Yes")
				ckeyowner = null
				usr << "Your Portable Duel System can now be picked up by anyone."
		verb/Take()
			set src in oview(0)
			if(ckeyowner == usr.ckey)
				if(!D)
					if(!unpacked)
						usr << "System is not completely deployed yet."
						return
					hearers()<<"[usr] takes the Portable Dueling System"
					if(unpacked)Packup()
					Move(usr)
					usr:Resort_Stacking_Inv()
				else
					usr << "There is currently a duel taking place."
			else if(!ckeyowner)
				ckeyowner = usr.ckey
				if(!D)
					hearers()<<"[usr] takes the Portable Dueling System"
					if(unpacked)Packup()
					Move(usr)
					usr:Resort_Stacking_Inv()
				else
					usr << "There is currently a duel taking place."
			else
				usr << "You do not have permission to pick this up."
		verb/Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his Portable Dueling System"
			if(ckeyowner)Unpack()
		proc/Packup()
			duelsystems.Remove(src)
			unpacked = 0
			var/obj/portduelsystemtiles/c1
			var/obj/portduelsystemtiles/c2
			var/obj/portduelsystemtiles/c3
			var/obj/portduelsystemtiles/c5
			var/obj/portduelsystemtiles/c6
			var/obj/portduelsystemtiles/c7
			for(var/obj/portduelsystemtiles/c1/c in dueltiles)
				c1 = c
			for(var/obj/portduelsystemtiles/c2/c in dueltiles)
				c2 = c
			for(var/obj/portduelsystemtiles/c3/c in dueltiles)
				c3 = c
			for(var/obj/portduelsystemtiles/c5/c in dueltiles)
				c5 = c
			for(var/obj/portduelsystemtiles/c6/c in dueltiles)
				c6 = c
			for(var/obj/portduelsystemtiles/c7/c in dueltiles)
				c7 = c
			for(var/obj/duelblock/t in view())
				del(t)
			spawn()step(c1,EAST)
			spawn()step(c7,WEST)
			spawn()step(c2,EAST)
			spawn()step(c6,WEST)
			spawn()step(c3,EAST)
			spawn()step(c5,WEST)
			sleep(6)
			spawn()step(c1,EAST)
			spawn()step(c7,WEST)
			spawn()step(c2,EAST)
			spawn()step(c6,WEST)
			spawn()step(c3,EAST)
			spawn()step(c5,WEST)
			sleep(6)
			del(c3)
			del(c5)
			spawn()step(c1,EAST)
			spawn()step(c7,WEST)
			spawn()step(c2,EAST)
			spawn()step(c6,WEST)
			sleep(6)
			del(c2)
			del(c6)
			spawn()step(c1,EAST)
			spawn()step(c7,WEST)
			sleep(6)
			del(c1)
			del(c7)
			dueltiles=list()
		proc/Unpack()
			duelsystems.Add(src)
			var/obj/portduelsystemtiles/c1/c1 = new(src.loc)
			var/obj/portduelsystemtiles/c7/c7 = new(src.loc)
			src.dueltiles.Add(c1)
			c1.density = 1
			src.dueltiles.Add(c7)
			c7.density = 1
			sleep(6)
			spawn()step(c1,WEST)
			spawn()step(c7,EAST)
			sleep(6)
			var/obj/portduelsystemtiles/c2/c2 = new(src.loc)
			var/obj/portduelsystemtiles/c6/c6 = new(src.loc)
			src.dueltiles.Add(c2)
			c2.density = 1
			src.dueltiles.Add(c6)
			c6.density = 1

			spawn()step(c1,WEST)
			spawn()step(c7,EAST)
			spawn()step(c2,WEST)
			spawn()step(c6,EAST)
			sleep(6)
			var/obj/portduelsystemtiles/c3/c3 = new(src.loc)
			var/obj/portduelsystemtiles/c5/c5 = new(src.loc)
			src.dueltiles.Add(c3)
			c3.density = 1
			src.dueltiles.Add(c5)
			c5.density = 1
			var/obj/duelblock/t1 = new(src.loc)
			var/obj/duelblock/t2 = new(src.loc)
			spawn()step(c1,WEST)
			spawn()step(c7,EAST)
			spawn()step(c2,WEST)
			spawn()step(c6,EAST)
			spawn()step(c3,WEST)
			spawn()step(c5,EAST)
			sleep(6)
			spawn()step(c1,WEST)
			spawn()step(c7,EAST)
			spawn()step(c2,WEST)
			spawn()step(c6,EAST)
			spawn()step(c3,WEST)
			spawn()step(c5,EAST)
			sleep(6)
			spawn()
				step(t1,WEST)
				step(t1,WEST)
				step(t2,EAST)
				step(t2,EAST)
			c1.density = 0
			c7.density = 0
			c2.density = 0
			c6.density = 0
			c3.density = 0
			c5.density = 0
			if(get_dist(c1,c7)<8)
				view() << "Portable Duel System: <i>ERROR</i>. Duel path must be clear of obstacles to deploy."
				Packup()
				Move(usr)
				usr:Resort_Stacking_Inv()
			else
				unpacked = 1
		Click()
			if(src in usr.contents)return
			if( !(usr in hearers(src)) )return
			if(!unpacked)
				usr << "System is not completely deployed yet."
				return
			if(D)
				if(!D.player1 && D.player2 != usr)
					D.player1 = usr
					D.player1.loc = locate(x-3,y,z)
					D.player1.dir = EAST
					D.player1.movable = 1
					range(9) << "[usr] enters the duel."
				else if(!D.player2 && D.player1 != usr)
					D.player2 = usr
					D.player2.loc = locate(x+3,y,z)
					D.player2.dir = WEST
					D.player2.movable = 1
					range(9) << "[usr] enters the duel."
					for(var/obj/duelblock/B in range(5))
						B.density = 1
					range(9) << "<i>Duelists now have 10 seconds to click on the duel control center.</i>"
					D.Pre_Duel()

				else if(D.player1 == usr)
					if(!D.player2)
						range(9) << "[usr] withdraws."
						usr.movable = 0
						del D
					else
						if(!D.ready1)
							range(9) << "<i>[usr] bows.</i>"
							usr << "You are now ready."
							D.ready1 = 1
						else
							var/input = alert("Do you wish to forfeit the duel?","Forfeit Duel","Yes","No")
							if(input == "Yes")
								usr << "Duel will end in 10 seconds."
								sleep(100)
								range(9) << "The duel has been forfeited by [usr]."
								D.player1.movable = 0
								D.player2.movable = 0
								spawn(60)
									for(var/obj/duelblock/B in range(5))
										B.density = 0
								del D
				else if(D.player2 == usr)
					if(!D.player1)
						range(9) << "[usr] withdraws."
						usr.movable = 0
						del D
					else
						if(!D.ready2)
							range(9) << "<i>[usr] bows.</i>"
							usr << "You are now ready."
							D.ready2 = 1
						else
							var/input = alert("Do you wish to forfeit the duel?","Forfeit Duel","Yes","No")
							if(input == "Yes")
								usr << "Duel will end in 10 seconds."
								sleep(100)
								range(9) << "The duel has been forfeited by [usr]."
								spawn(60)
									for(var/obj/duelblock/B in range(5))
										B.density = 0
								del D

				else
					usr << "Both player positions are already occupied."
			else
				D = new(src)
				D.countdown = 5//input("Select count-down timer, for when both players have readied. (between 3 and 10 seconds)","Count-down Timer",D.countdown) as null|num
				if(D.countdown>10) D.countdown = 10
				if(D.countdown<3) D.countdown = 3
				range(9) << "[usr] initiates a duel."
				D.player1 = usr
				D.player1.loc = locate(x-3,y,z)
				D.player1.dir = EAST
				D.player1.movable = 1
turf
	duelsystemcenter
		name = "Duel Controls"
		icon='DuelArena.dmi'
		icon_state="d4"
		var/Duel/D
		Click()
			if( !(usr in hearers(src)) )return
			if(D)
				if(!D.player1 && D.player2 != usr)
					D.player1 = usr
					D.player1.loc = locate(x-3,y,z)
					D.player1.dir = EAST
					D.player1.movable = 1
					range(9) << "[usr] enters the duel."
				else if(!D.player2 && D.player1 != usr)
					D.player2 = usr
					D.player2.loc = locate(x+3,y,z)
					D.player2.dir = WEST
					D.player2.movable = 1
					range(9) << "[usr] enters the duel."
					for(var/turf/duelblock/B in block(locate(x-5,y,z),locate(x+5,y,z)))
						B.density = 1
					range(9) << "<i>Duelists now have 10 seconds to click on the duel control center.</i>"
					D.Pre_Duel()

				else if(D.player1 == usr)
					if(!D.player2)
						range(9) << "[usr] withdraws."
						usr.movable = 0
						del D
					else
						if(!D.ready1)
							range(9) << "<i>[usr] bows.</i>"
							usr << "You are now ready."
							D.ready1 = 1
						else
							var/input = alert("Do you wish to forfeit the duel?","Forfeit Duel","Yes","No")
							if(input == "Yes")
								usr << "Duel will end in 10 seconds."
								sleep(100)
								range(9) << "The duel has been forfeited by [usr]."
								if(D.player1)D.player1.movable = 0
								if(D.player2)D.player2.movable = 0
								spawn(60)
									for(var/turf/duelblock/B in block(locate(x-5,y,z),locate(x+5,y,z)))
										B.density = 0
								del D
				else if(D.player2 == usr)
					if(!D.player1)
						range(9) << "[usr] withdraws."
						usr.movable = 0
						del D
					else
						if(!D.ready2)
							range(9) << "<i>[usr] bows.</i>"
							usr << "You are now ready."
							D.ready2 = 1
						else
							var/input = alert("Do you wish to forfeit the duel?","Forfeit Duel","Yes","No")
							if(input == "Yes")
								usr << "Duel will end in 10 seconds."
								sleep(100)
								range(9) << "The duel has been forfeited by [usr]."
								spawn(60)
									for(var/turf/duelblock/B in block(locate(x-5,y,z),locate(x+5,y,z)))
										B.density = 0
								del D

				else
					usr << "Both player positions are already occupied."
			else
				D = new(src)
				D.countdown = 5//input("Select count-down timer, for when both players have readied. (between 3 and 10 seconds)","Count-down Timer",D.countdown) as null|num
				range(9) << "[usr] initiates a duel."
				D.player1 = usr
				D.player1.loc = locate(x-3,y,z)
				D.player1.dir = EAST
				D.player1.movable = 1