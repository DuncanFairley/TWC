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
			var/deatheaterWon = list("The deatheaters clan have successfully raided Auror clan HQ!","The aurors have been defeated by the deatheaters!","Deatheaters have defeated the aurors in the war of the clans!")
			var/aurorWon = list("The deatheaters have been defeated by the aurors!","The aurors have successfully held back the deatheaters!","The Aurors have emerged victorious in the war of the clans!")
			var/draw = list("Nobody did anything interesting in the clan war so it resulted in a draw!","The clan war has ended in a draw! How boring!","The clans managed to hold each other off! Clan Wars is a draw!")

			var/c
			if(deatheater > aurors)
				var/dewinner = pick(deatheaterWon)
				Players << "<span style=\"color:'#282C1B'; font-size:'3';\"><b>[dewinner]</b></span>"
				c = "#303A3A"
			else if(deatheater < aurors)
				var/aurorwinner = pick(aurorWon)
				Players << "<span style=\"color:'#66CCFF'; font-size:'3';\"><b>[aurorwinner]<b></span>"
				c = "#56859B"
			else
				var/wardraw = pick(draw)
				Players << "<span style=\"color:'#E5E4E2'; font-size:'3';\"><b>[wardraw]</b></span>"
				c = "#704F32"

			for(var/turf/t in world)
				if(t.z >= 4 && t.z <= 5)
					if(istype(t, /turf/woodenfloor) || istype(t, /turf/nofirezone) || istype(t, /turf/sideBlock))
						if(!findtext(t.icon_state, "wood")) continue
						t.color = c

		timeout()
			var/m = 0
			while(m < MINUTES && clanwars)
				m++
				sleep(600)

			if(!clanwars) return

			toggle_clanwars()

mob/test/verb/Toggle_Clanwars()
	set category = "Events"
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
			M << infomsg("<b>Clan wars is now disabled.</b>")
		for(var/obj/clanpillar/C in locate(/area/AurorHQ))
			C.disable()
		for(var/obj/clanpillar/C in locate(/area/DEHQ))
			C.disable()

mob/Player/proc/ClanwarsInfo()
	src << infomsg({"<b>Clan wars has now begun.</b><br>A special object called a "pillar" has spawned inside the deatheater and auror HQs.<br>\
				The goal during clan wars is to protect yours, and destroy the enemy's.<br>\
				Doors inside your enemy's HQ can be destroyed by firing at them with a projectile damage spell. Doors will respawn in 60 seconds.<br>\
				Your side will receive 1 point for each player you kill.<br>\
				Your side will receive 10 points for each time the enemy's pillar is destroyed.<br>"})

var/clanwars = 0
obj/brick2door
	icon = 'hogwartsbrick.dmi'
	icon_state = "closed"
	density = 1
	post_init = 1
	var
		door = 0
		MHP = 150
		tmp
			inuse = 0
			HP

	name = "brick"

	roofb
		icon = 'roofbdoor.dmi'
		MHP  = 20

		New()
			loc.name = "roofb"
			..()

		MapInit()

			..()

			var/turf/floor = loc
			var/n = 15 - floor.autojoin("name", "roofb")

			var/list
				dirs  = list(NORTH, SOUTH, EAST, WEST)
				edges = list()

			edges["4"] = /image/roofedge/east
			edges["8"] = /image/roofedge/west
			edges["1"] = /image/roofedge/north
			edges["2"] = /image/roofedge/south

			for(var/d in dirs)
				if((n & d) > 0)

					var/turf/t = get_step(src, d)
					if(!t || istype(t, /turf/blankturf)) continue
					t.overlays += edges["[d]"]

					n -= d

	clandoor
		name = "door"
		icon = 'Door.dmi'
		opacity = 1
		door = 1
		MHP = 100
		var/clan = "" //"DE" or "Auror"

		MapInit()
			..()
			if(istype(src.loc.loc, /area/AurorHQ))
				clan = "Auror"
			else if(istype(src.loc.loc, /area/DEHQ))
				clan = "DE"
		Bumped(mob/Player/M)
			if(!isplayer(M)) return
			if(!M.guild) return
			if(clan == "Auror" && M.guild != worldData.majorPeace)
				//If you're not the same clan as the door
				return
			if(clan == "DE" && M.guild != worldData.majorChaos)
				return
			..()
		Take_Hit(obj/projectile/p)
			if(!clanwars)return
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
		Take_Hit(obj/projectile/p)
			if(istype(p, /obj/projectile/Bomb))
				HP -= 10
			else
				HP--
			flick("hit",src)
			if(HP < 1)
				view(src) << "The door blows open."
				Bust_Open()
		Bust_Open()
			set waitfor = 0
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
	MapInit()
		HP = MHP
		var/turf/T = src.loc
		if(T)T.flyblock=2

obj
	Goblet_of_Fire
		icon = 'goblet.dmi'
		icon_state = "blue-idle"

obj
	MouseDrop(over_object,src_location,over_location)
		.=..()
		if(!isturf(over_location))return

		if(isplayer(usr) && usr:draganddrop)
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
		if(!isturf(over_location))return ..()
		if(isplayer(usr) && usr:draganddrop==1)
			if(density)
				density = 0
				src.Move(over_location)
				density = 1
			else
				src.Move(over_location)
