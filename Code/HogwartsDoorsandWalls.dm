/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

turf/var/pass
turf/var/door=0
turf/var/tmp/owner=""
turf/var/bumpable=0
obj/var/bumpable=0
mob/var/bumpable=0
area/var/bumpable=0

mob
	Bump(var/turf/T)
		if(T.bumpable==1)
			if(ismob(T))return
			if(T.door==1)
				if(istype(T,/obj/brick2door))
					var/obj/brick2door/O = T
					spawn()O:Bumped(src)
					return
				if(T.pass!="")
					if(!src.key)
						return
					if(src.removeoMob)
						return
					if(T.owner==usr.key)
					//	usr<<"<font color= #000099><b>Welcome back, [usr]."
						//hearers()<<sound('stdoor.wav')
						if(T.icon_state != "open")
							T.bumpable = 0
							flick("opening",T)
							var/temp_opacity = T.opacity
							T.opacity=0
							sleep(4)
							T.icon_state="open"
							T.density=0
							sleep(20)
							//hearers()<<sound('stdoor.wav')
							if(isturf(T))
								while(locate(/mob) in T) sleep(10)
							else
								while(locate(/mob) in T.loc) sleep(10)
							flick("closing",T)
							T.density=1
							sleep(4)
							T.opacity=temp_opacity
							T.icon_state="closed"
							T.bumpable = 1
					else if(T.owner!=usr.key)
						if(!src.key)
							return
						var/passtry=input("This is a Secure Area. Please enter Authorization Code.","Incarcerous Charm","")as text
						passtry=copytext(passtry,1,500)
						if(passtry==T.pass)
							usr<<"<font color=green><b>Authorization Confirmed."
							spawn()
								if(T.icon_state != "open")
									T.bumpable = 0
									src = null
									T:lastopener = usr.key
									//hearers()<<sound('stdoor.wav')
									flick("opening",T)
									var/temp_opacity = T.opacity
									T.opacity=0
									sleep(4)
									T.icon_state="open"
									T.density=0
									sleep(50)
									if(isturf(T))
										while(locate(/mob) in T) sleep(10)
									else
										while(locate(/mob) in T.loc) sleep(10)
									//hearers()<<sound('stdoor.wav')
									flick("closing",T)
									T.density=1
									sleep(4)
									T.opacity=temp_opacity
									T.icon_state="closed"
									T.bumpable = 1
						else if(passtry!=T.pass)

							usr<<"<font color=red><b>Authorization Denied. Incorrect Access Code."
				else if(T.pass=="")
					//NORMAL DOORS RIGHT HERRRRRRRRRREEEEEEEE
					//hearers()<<sound('stdoor.wav')
					spawn()
						if(T.icon_state != "open")
							T.bumpable = 0
							src = null
							T:lastopener = usr.key
							flick("opening",T)
							var/temp_opacity = T.opacity
							T.opacity=0
							sleep(4)
							T.icon_state="open"
							T.density=0
							sleep(50)
							if(isturf(T))
								while(locate(/mob) in T) sleep(10)
							else
								while(locate(/mob) in T.loc) sleep(10)
							//hearers()<<sound('stdoor.wav')
							flick("closing",T)
							T.density=1
							sleep(4)
							T.opacity=temp_opacity
							T.icon_state="closed"
							T.bumpable = 1


turf
	var/lastopener
	stonedoor1
		bumpable=1
		name="Hogwarts Stone Wall"
		flyblock=1
		door=1
		icon='door1.dmi'
		density=1
		icon_state="closed"
		opacity=1
		pass="Roar"
	secretdoor
		bumpable=0
		name="Hogwarts Stone Wall"
		flyblock=1
		door=1
		icon='door1.dmi'
		density=1
		icon_state="closed"
		opacity=1
	Hogwarts_Stone_Wall
		bumpable=0
		opacity=0
		density=1
		flyblock=1
		icon='wall1.dmi'
	/*	Enter(atom/movable/O)
			if(ismob(O))
				if(!density) return ..()
				if(!O:Gm) return ..()
				if(!O:key) return ..()
				else if(density)
					return 0
			return ..()*/
	Hogwarts_Stone_Wall_
		bumpable=0
		opacity=0
		name="Hogwarts Stone Wall"
		density=1
		icon='wall1.dmi'
		flyblock = 1
	/*	Enter(atom/movable/O)
			if(ismob(O))
				if(!density) return ..()
				if(!O:Gm) return ..()
				if(!O:key) return ..()
				else if(density)
					return 0
			return ..()*/
	Ministry_Red_Carpet
		name = "Red Carpet"
		icon='floors2.dmi'
		icon_state="carpet"
	Red_Carpet
		icon='floors2.dmi'
		icon_state="carpet"
	Red_Carpet_Corners
		icon='floors2.dmi'
		name = "Red Carpet"
		icon_state="corner"
	Black_Tile
		icon='floors2.dmi'
		icon_state="greycarpet"
	FlashTile
		icon='floors2.dmi'
		icon_state="greycarpet"



	Duel_Star
		icon='DuelArena.dmi'
		icon_state="d"
	Duel_1
		icon='DuelArena.dmi'
		icon_state="d1"
	Duel_2
		icon='DuelArena.dmi'
		icon_state="d2"
	Duel_3
		icon='DuelArena.dmi'
		icon_state="d3"
	Duel_4
		icon='DuelArena.dmi'
		icon_state="d4"
	Duel_5
		icon='DuelArena.dmi'
		icon_state="d5"
	Duel_6
		icon='DuelArena.dmi'
		icon_state="d6"
	Duel_7
		icon='DuelArena.dmi'
		icon_state="d7"
turf
	C2
		icon='COMC Icons.dmi'
		icon_state="C2"
	C1
		icon='COMC Icons.dmi'
		icon_state="C1"
	darkstairs
		icon='Turff.dmi'
		icon_state="stairs"

obj
	Hogwarts_Door
		bumpable=1
		dontsave=0
		var/lastopener
		var/door=1
		icon='Door.dmi'
		density=1
		icon_state="closed"
		opacity=1
		var/pass=""
		gate
			icon = 'gate.dmi'
			icon_state = "closed"
		toiletstall
			icon = 'Stall.dmi'
			icon_state = "closed"
		roofb
			icon = 'roofbdoor.dmi'
		New()
			..()
			var/turf/T = src.loc
			if(T)T.flyblock=2
		/*Del()
			var/turf/T = src.loc
			for(var/obj/Hogwarts_Door/D in T)
				if(D != src)
					return
			if(T)T.flyblock = 0
			..()*/