
mob/Player/proc/getName()
	if(pname) return pname
	if(prevname) return prevname
	return name

proc
	sortedInsert(list/L, item, variable = null, associated = FALSE, isPlayer = FALSE)

		if(L.len == 0)
			L += item
			return 1

		if(isPlayer)
			var/mob/Player/player = item
			var/name = player.getName()

			for(var/i = 1 to L.len)
				var/mob/Player/p = L[i]
				if(p.getName() > name)
					return L.Insert(i, item)
		else
			for(var/i = 1 to L.len)
				if(L[i] > item)
					return L.Insert(i, item)

		return L.Insert(L.len+1, item)

	quicksortPlayers(list/L)
		var/low = 1
		var/high = L.len
		var/top = 2
		var/list/stack[high - low + 1]
		stack[1] = low
		stack[2] = high

		while (top >= 1)
			high = stack[top--]
			low = stack[top--]

			var/mob/Player/pivot = L[high]
			var/playerName = pivot.getName()

			var/i = (low - 1)
			for (var/j = low to high - 1)
				var/mob/Player/jPlayer = L[j]
				if (jPlayer.getName() <= playerName)
					i++

					L.Swap(i,j)

			L.Swap(i+1,high)

			var/p = i + 1

			if (p - 1 > low)
				stack[++top] = low
				stack[++top] = p - 1

			if (p + 1 < high)
				stack[++top] = p + 1
				stack[++top] = high

	quicksortValue(list/L, variable = null, associated = FALSE)
		var/low = 1
		var/high = L.len
		var/top = 2
		var/list/stack[high - low + 1]
		stack[1] = low
		stack[2] = high

		if(!variable && !associated) associated = TRUE

		while (top >= 1)
			high = stack[top--]
			low = stack[top--]

			var/datum/pivot = associated ? L[L[high]] : L[high]

			var/i = (low - 1)
			for (var/j = low to high - 1)
				var/datum/jDatum = associated ? L[L[j]] : L[j]
				if ((variable && jDatum.vars[variable] <= pivot.vars[variable]) ||\
				    (!variable && jDatum <= pivot))
					i++

					L.Swap(i,j)

			L.Swap(i+1,high)

			var/p = i + 1

			if (p - 1 > low)
				stack[++top] = low
				stack[++top] = p - 1

			if (p + 1 < high)
				stack[++top] = p + 1
				stack[++top] = high

	quicksort(list/L)
		if(L.len <= 1) return
		var/low = 1
		var/high = L.len
		var/top = 2
		var/list/stack[high - low + 1]
		stack[1] = low
		stack[2] = high

		while (top >= 1)
			high = stack[top--]
			low = stack[top--]

			var/pivot = L[high]

			var/i = (low - 1)
			for (var/j = low to high - 1)
				if (L[j] <= pivot)
					i++

					L.Swap(i,j)

			L.Swap(i+1,high)

			var/p = i + 1

			if (p - 1 > low)
				stack[++top] = low
				stack[++top] = p - 1

			if (p + 1 < high)
				stack[++top] = p + 1
				stack[++top] = high


	bubblesort(list/L)
		var i, j
		for(i=L.len,i>0,i--)
			for(j=1,j<i,j++)
				if(L[j]>L[j+1])
					L.Swap(j,j+1)
		return L
	bubblesort_by_value(list/L, variable = null, associated = FALSE)
		var i, j
		for(i=L.len,i>0,i--)
			for(j=1,j<i,j++)
				if(variable)
					if(associated)
						var/datum/d  = L[L[j]]
						var/datum/d1 = L[L[j+1]]
						if(d.vars[variable] > d1.vars[variable])
							L.Swap(j,j+1)
					else
						var/datum/d  = L[j]
						var/datum/d1 = L[j + 1]
						if(d.vars[variable] > d1.vars[variable])
							L.Swap(j,j+1)
				else
					if(L[L[j]]>L[L[j+1]])
						L.Swap(j,j+1)
		return L
	bubblesort_atom_name(list/L)
	//Looks awful, but seems to work
		var i, j
		for(i=L.len,i>0,i--)
			for(j=1,j<i,j++)
				var/mob/Player/j1 = L[j]
				var/mob/Player/j2 = L[j+1]
				if(j1 && j2)
					if(j1.prevname && !j2.prevname)
						if(j1.prevname>j2.name) L.Swap(j,j+1)
					else if(j1.prevname && j2.prevname)
						if(j1.prevname>j2.prevname) L.Swap(j,j+1)
					if(!j1.prevname && j2.prevname)
						if(j1.name>j2.prevname) L.Swap(j,j+1)
					else if(!j1.prevname && !j2.prevname)
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
	var/mob/Player/player1
	var/mob/Player/player2
	var/ready1 = 0
	var/ready2 = 0
	var/atom/duelcenter
	New(var/atom/duelcenter)
		..()
		src.duelcenter = duelcenter
	proc/Dispose()

		for(var/i = 2 to -2 step -4)
			var/turf/t = locate(duelcenter.x + i, duelcenter.y, duelcenter.z)

			if(istype(t, /turf/duelblock))
				t.density = 0
			else
				var/obj/duelblock/o = locate() in t
				o.density = 0

		if(player1)
			player1.nomove = 0
			player1 = null
		if(player2)
			player2.nomove = 0
			player2 = null

		duelcenter.overlays = list()
		duelcenter:D = null
		duelcenter = null
		..()

	proc
		Pre_Duel()
			player1.followplayer = 0
			player2.followplayer = 0
			sleep(100)
			if(!(ready1 && ready2))
				range(9,duelcenter) << errormsg("<i>The players did not ready themselves within the time limit. Duel cancelled.</i>")
				Dispose()
			else
				player1.followplayer = 0
				player2.followplayer = 0
				range(9,duelcenter) << "<i><span style=\"font-size:3\">The duel will now start in 5 seconds!</span></i>"
				var/obj/o = new
				o.pixel_y = 32
				for(var/i=5;i>0;i--)
					duelcenter.overlays -= o
					o.maptext = "<b><span style=\"font-size:4; color:#FF4500;\"> [i]</span></b>"
					duelcenter.overlays += o
					sleep(10)
				duelcenter.overlays -= o
				range(9,duelcenter) << "GO!"
				if(isobj(duelcenter))
					var/obj/duelblock/B1 = locate(/obj/duelblock) in locate(duelcenter.x-2,duelcenter.y,duelcenter.z)
					var/obj/duelblock/B2 = locate(/obj/duelblock) in locate(duelcenter.x+2,duelcenter.y,duelcenter.z)
					B1.density = 0
					B2.density = 0
				else
					for(var/turf/duelblock/B in block(locate(duelcenter.x-5,duelcenter.y,duelcenter.z),locate(duelcenter.x+5,duelcenter.y,duelcenter.z)))
						B.density = 0
				player1.nomove = 0
				player2.nomove = 0
				View_Check_Ticker()
		View_Check_Ticker()
			set waitfor = 0
			sleep(5)
			while(duelcenter)
				if(get_dist(player1,duelcenter) > DUEL_DISTANCE)
					range(DUEL_DISTANCE,duelcenter) << infomsg("<span style=\"font-size:3;\">[player1] has left the duel area. [player2] wins!</span>")
					player1 << errormsg("<span style=\"font-size:3;\">You have left the duel area. [player2] wins.</span>")
					Dispose()
				else if(get_dist(player2,duelcenter) > DUEL_DISTANCE)
					range(DUEL_DISTANCE,duelcenter) << infomsg("<span style=\"font-size:3;\">[player2] has left the duel area. [player1] wins!</span>")
					player2 << errormsg("<span style=\"font-size:3;\">You have left the duel area. [player1] wins.</span>")
					Dispose()
				sleep(5)
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
turf
	duelsystemcenter
		name = "Duel Controls"
		icon='DuelArena.dmi'
		icon_state="d4"
		mouse_over_pointer = MOUSE_HAND_POINTER
		var/Duel/D
		Click()
			if( !(usr in hearers(src)) )return
			if(D)
				if(!D.player1 && D.player2 != usr)
					D.player1 = usr
					D.player1:Transfer(locate(x-3,y,z))
					D.player1.dir = EAST
					D.player1.nomove = 1
					range(9) << "[usr] enters the duel."
				else if(!D.player2 && D.player1 != usr)
					D.player2 = usr
					D.player2:Transfer(locate(x+3,y,z))
					D.player2.dir = WEST
					D.player2.nomove = 1
					range(9) << "[usr] enters the duel."
					for(var/turf/duelblock/B in block(locate(x-5,y,z),locate(x+5,y,z)))
						B.density = 1
					range(9) << "<i>Duelists now have 10 seconds to click on the duel control center.</i>"
					D.Pre_Duel()

				else if(D.player1 == usr)
					if(!D.player2)
						range(9) << "[usr] withdraws."
						D.Dispose()
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
								if(D) D.Dispose()
				else if(D.player2 == usr)
					if(!D.player1)
						range(9) << "[usr] withdraws."
						D.Dispose()
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
								D.Dispose()
				else
					usr << "Both player positions are already occupied."
			else
				D = new(src)
				range(9) << "[usr] initiates a duel."
				D.player1 = usr
				D.player1:Transfer(locate(x-3,y,z))
				D.player1.dir = EAST
				D.player1.nomove = 1