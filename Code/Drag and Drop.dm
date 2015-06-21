/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

var/clan_wars/clanwars_event

clan_wars

	var
		deatheater = 0
		aurors     = 0

		const
			POINTS_FOR_WIN = 100
			MINUTES        = 20

	proc
		add_auror(num)

			aurors += num
			if(aurors >= POINTS_FOR_WIN)
				toggle_clanwars()

		add_de(num)

			deatheater += num
			if(deatheater >= POINTS_FOR_WIN)
				toggle_clanwars()

		end()
			var/deatheaterWon = list("The Death Eaters have successfully raided Auror HQ!","The Aurors have been defeated by the Death Eaters!","Death Eaters have defeated the Aurors in the war of the clans!")
			var/aurorWon = list("The Death Eaters have been defeated by the Aurors!","The Aurors have successfully held back the Death Eaters!","The Aurors have emerged victorious in the war of the clans!")
			var/draw = list("Nobody did anything interesting in the clan war so it resulted in a draw!","The clan war has ended in a draw! How boring!","The clans managed to hold each other off! Clan Wars is a draw!")

			var/c
			if(deatheater > aurors)
				var/dewinner = pick(deatheaterWon)
				Players << "<font color='#282C1B' size='3'><b>[dewinner]</b></font>"
				c = "#303A3A"
			else if(deatheater < aurors)
				var/aurorwinner = pick(aurorWon)
				Players << "<font color='#66CCFF' size='3'><b>[aurorwinner]<b></font>"
				c = "#c9c9c9"
			else
				var/wardraw = pick(draw)
				Players << "<font color='#E5E4E2' size='3'><b>[wardraw]</b></font>"
				c = "#704f32"

			for(var/turf/woodenfloor/t in world)
				if(t.z >= 21 && t.z <= 22)
					t.color = c
			for(var/turf/nofirezone/t in world)
				if(t.z >= 21 && t.z <= 22 && findtext(t.icon_state, "wood"))
					t.color = c
			for(var/turf/sideBlock/t in world)
				if(t.z >= 21 && t.z <= 22)
					t.color = c

		timeout()
			var/m = 0
			while(m < MINUTES && clanwars)
				m++
				sleep(600)

			if(!clanwars) return

			toggle_clanwars()

mob/test/verb/Toggle_Clanwars()
	toggle_clanwars()
	if(clanwars)
		usr << "Clan wars enabled."
	else
		usr << "Clan wars disabled."

proc/toggle_clanwars()
	clanwars = !clanwars
	if(clanwars)
		clanwars_event = new
		spawn() clanwars_event.timeout()
		for(var/mob/Player/M in Players)
			if(M.Auror || M.DeathEater)
				M.ClanwarsInfo()
				M.beep()

		for(var/obj/clanpillar/C in locate(/area/AurorHQ))
			C.enable(100)
		for(var/obj/clanpillar/C in locate(/area/DEHQ))
			C.enable(100)
	else
		clanwars_event.end()
		clanwars_event = null
		for(var/mob/Player/M in Players)
			if(M.Auror || M.DeathEater)
				M << infomsg("<b>Clan wars is now disabled.</b>")
		for(var/obj/clanpillar/C in locate(/area/AurorHQ))
			C.disable()
		for(var/obj/clanpillar/C in locate(/area/DEHQ))
			C.disable()

mob/Player/proc/ClanwarsInfo()
	src << infomsg({"<b>Clan wars has now begun.</b><br>A special object called a "pillar" has spawned inside the Deatheater and Auror HQs.<br>\
				The goal during clan wars is to protect yours, and destroy the enemy's.<br><br>\
				Your clan will receive 1 point for each [src.Auror ? "Deatheater" : "Auror"] you kill.<br>\
				Your clan will receive 10 points for each time the enemy's pillar is destroyed.<br>\
				Doors inside your enemy's HQ can be destroyed by firing at them with a projectile damage spell. Doors will respawn in 60 seconds.<br>\
				Some clan members may have access to "The Clan Store", and are able to spend points to perform actions such as doubling Door max HP, restoring Door HP to full, uncloaking enemies in your HQ, etc.<br>\
				<b>You must be robed in order to earn points/destroy doors/destroy pillars.<br>"})
var/clanwars = 0
obj/brick2door
	icon = 'hogwartsbrick.dmi'
	icon_state = "closed"
	density = 1
	var/door = 0
	var/HP
	var/MHP = 150
	bumpable = 1
	var/inuse = 0
	name = "brick"

	roofb
		icon = 'roofbdoor.dmi'
		MHP  = 20
		New()
			..()
			spawn()
				loc.name = "roofb"

				var/turf/floor = loc
				var/n = 15 - floor.autojoin("name", "roofb")

				var/dirs = list(NORTH, SOUTH, EAST, WEST)
				for(var/d in dirs)
					if((n & d) > 0)

						var/obj/roofedge/o

						if(d == SOUTH)
							var/turf/t = locate(floor.x + 1, floor.y, floor.z)
							if(!t || istype(t, /turf/blankturf)) continue
							o = new (t)
							o.pixel_x = -32
						else if(d == EAST)
							var/turf/t = locate(floor.x, floor.y - 1, floor.z)
							if(!t || istype(t, /turf/blankturf)) continue
							o = new (t)
							o.pixel_y = 32
						else if(d == WEST)
							var/turf/t = locate(floor.x - 1, floor.y, floor.z)
							if(!t || istype(t, /turf/blankturf)) continue
							o = new (t)
							o.pixel_x = 32
						else
							var/turf/t = locate(floor.x, floor.y + 1, floor.z)
							if(!t || istype(t, /turf/blankturf)) continue
							o = new (t)
							o.pixel_y = -32

						o.layer = d == NORTH ? 6 : 7
						o.icon_state = "edge-[15 - d]"
						n -= d

	clandoor
		name = "door"
		icon = 'Door.dmi'
		opacity = 1
		door = 1
		MHP = 100
		var/clan = "" //"DE" or "Auror"
		New()
			..()
			if(istype(src.loc.loc, /area/AurorHQ))
				clan = "Auror"
			else if(istype(src.loc.loc, /area/DEHQ))
				clan = "DE"
		Bumped(mob/M)
			if(clan == "Auror" && !M.Auror)
				//If you're not the same clan as the door
				return
			if(clan == "DE" && !M.DeathEater)
				return
			..()
		Take_Hit(mob/M)
			if(!clanwars)return
			if(clan == "Auror" && M.derobe)
				return ..()
			else if(clan == "DE" && M.aurorrobe)
				return ..()

	proc
		Bumped(mob/M)
			if(!inuse)
				//closed
				inuse = 1
				Open()
				sleep(40)
				Close()
				inuse = 0
		Take_Hit(mob/M)
			HP--
			flick("hit",src)
			if(HP < 1)
				view(src) << "The door blows open."
				Bust_Open()
		Bust_Open()
			density = 0
			icon_state = "brokeopen"
			opacity = 0
			inuse = 0
			sleep(600)
			HP = MHP
			Close()
		Open()
			opacity = 0
			spawn(4)density = 0
			inuse = 1
			icon_state = "open"
			flick("opening",src)
		Close()
			while(locate(/mob) in loc) sleep(10)
			icon_state = "closed"
			flick("closing",src)
			density = 1
			opacity = initial(opacity)
	New()
		HP = MHP
		var/turf/T = src.loc
		if(T)T.flyblock=2
		..()
obj
	Goblet_of_Fire
		icon = 'goblet.dmi'
		icon_state = "blue-idle"
		var/list/names = list()
		var/started = 0
		var/Gpicked = 0
		var/Rpicked = 0
		var/Spicked = 0
		var/Hpicked = 0
		verb
			Enter_Name()
				set src in oview(1)
				if(usr.level < 101)
					alert("You need to be at least a 4th year (level 101) to enter the Triwizard Tournament")
					return
				if(started)
					alert("The Goblet is no longer taking names.")
					return
				if(usr.name in names)
					alert("You've already entered your name in the Goblet")
				else
					var/reply = alert("Are you sure you wish to drop your slip of parchment into the Goblet of Fire?",,"Yes","No")
					if(reply == "Yes")
						if(!(usr.name in names))
							names.Add(usr.name)
							icon_state = "blue-large"
							spawn(40)
							icon_state = "blue-idle"
							hearers() << "<b>The Goblet of Fire burns ferociously as [usr]'s piece of parchment falls in.</b>"

		Click()
			if(usr.Gm)
				if(started==0)
					var/reply = alert("Do you wish to start the ceremony? The goblet will turn red, and wait for you to click it again.",,"Yes","No")
					if(reply == "Yes")
						started = 1
						hearers() << "<h3>The Goblet of Fire changes its colour to a firey red.</h3>"
						icon_state = "red-idle"
					return
				else
					var/list/options = list()
					if(Gpicked == 0) options.Add("Gryffindor")
					if(Spicked == 0) options.Add("Slytherin")
					if(Rpicked == 0) options.Add("Ravenclaw")
					if(Hpicked == 0) options.Add("Hufflepuff")
					var/house = input("Which House is the Goblet drawing?") as null|anything in options
					if(!house)return
					var/list/mob/onlineplayers = list()
					for(var/mob/M in world) if(M.key) onlineplayers.Add(M)
					for(var/mob/M in onlineplayers)
						if(!(M.name in names))
							onlineplayers.Remove(M)
					//onlineplayers now contains only players that are online, and have entered the goblet
					for(var/mob/M in onlineplayers)
						if(M.House != house)
							onlineplayers.Remove(M)
					//onlineplayers now only contains players from the house
					var/mob/winner = pick(onlineplayers)
					icon_state = "red-large"
					hearers() << "<b>The Goblet of Fire burns ferociously</b>"
					sleep(50)
					if(winner)
						hearers() << "<h2>A thin sliver of charred parchment with <u>[winner.name]<u>  written on it flies out of the Goblet.</h2>"
					else
						hearers() << "<h3>The Goblet fizzles out</h3>"
					sleep(10)
					icon_state = "red-idle"

obj
	MouseDrop(over_object,src_location,over_location)
		.=..()
		if(usr.clanrobed())return
		if(!isturf(over_location))return
		if(usr.draganddrop)
			if(istype(src, /obj/items/wearable))
				var/mob/Player/user = usr
				if(src in user.Lwearing)
					src:Equip(user)
			if(density)
				density = 0
				src.Move(over_location)
				density = 1
			else
				src.Move(over_location)
mob
	MouseDrop(over_object,src_location,over_location)
		if(usr.clanrobed())return
		if(!isturf(over_location))return ..()
		if(usr.draganddrop==1)
			if(density)
				density = 0
				src.Move(over_location)
				density = 1
			else
				src.Move(over_location)
