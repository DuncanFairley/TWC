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
						//view()<<sound('stdoor.wav')
						if(T.icon_state != "open")
							flick("opening",T)
							T.opacity=0
							sleep(4)
							T.icon_state="open"
							T.density=0
							sleep(20)
							//view()<<sound('stdoor.wav')
							if(isturf(T))
								while(locate(/mob) in T) sleep(10)
							else
								while(locate(/mob) in T.loc) sleep(10)
							flick("closing",T)
							T.density=1
							sleep(4)
							T.opacity=1
							T.icon_state="closed"
					else if(T.owner!=usr.key)
						if(!src.key)
							return
						var/passtry=input("This is a Secure Area. Please enter Authorization Code.","Incarcerous Charm","")as text
						passtry=copytext(passtry,1,500)
						if(passtry==T.pass)
							usr<<"<font color=green><b>Authorization Confirmed."
							spawn()
								if(T.icon_state != "open")
									src = null
									T:lastopener = usr.key
									//view()<<sound('stdoor.wav')
									flick("opening",T)
									T.opacity=0
									sleep(4)
									T.icon_state="open"
									T.density=0
									sleep(50)
									if(isturf(T))
										while(locate(/mob) in T) sleep(10)
									else
										while(locate(/mob) in T.loc) sleep(10)
									//view()<<sound('stdoor.wav')
									flick("closing",T)
									T.density=1
									sleep(4)
									T.opacity=1
									T.icon_state="closed"
						else if(passtry!=T.pass)

							usr<<"<font color=red><b>Authorization Denied. Incorrect Access Code."
				else if(T.pass=="")
					//NORMAL DOORS RIGHT HERRRRRRRRRREEEEEEEE
					//view()<<sound('stdoor.wav')
					spawn()
						if(T.icon_state != "open")
							src = null
							T:lastopener = usr.key
							flick("opening",T)
							T.opacity=0
							sleep(4)
							T.icon_state="open"
							T.density=0
							sleep(50)
							if(isturf(T))
								while(locate(/mob) in T) sleep(10)
							else
								while(locate(/mob) in T.loc) sleep(10)
							//view()<<sound('stdoor.wav')
							flick("closing",T)
							T.density=1
							sleep(4)
							T.opacity=1
							T.icon_state="closed"
		else if(T.bumpable==0)
			return

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
	Gate
		bumpable=1
		door=1
		icon='gate.dmi'
		density=1
		icon_state="closed"
		opacity=1
		pass=""

	Rag_Door
		icon='Door.dmi'
		density=1
		icon_state="never"
		flyblock=1
		opacity=0
		verb
			Examine()
				set src in oview(3)
				usr << "\nYou see a large black 'X' painted onto the door, and a small inscription saying 'Never Again'."
	Iandoor
		name = "Lord Xioshen's Door"
		icon = 'Door.dmi'
		flyblock=1
		icon_state = "closed"
		density = 1
		opacity=1
		pass=""
		door=0
		bumpable=0
	Amberdoor
		name = "Door"
		icon = 'Door.dmi'
		flyblock=1
		icon_state = "closed"
		density = 1
		opacity=1
		pass=""
		door=0
		bumpable=0
	Diablodoor
		name = "Door"
		icon = 'Door.dmi'
		flyblock=1
		icon_state = "closed"
		density = 1
		opacity=1
		pass=""
		door=0
		bumpable=0
	AmberDiablodoor
		name = "Door"
		icon = 'Door.dmi'
		flyblock=1
		icon_state = "closed"
		density = 1
		opacity=1
		pass=""
		door=0
		bumpable=0
	Shiroudoor
		name = "Wooden Door"
		icon = 'Door.dmi'
		flyblock=1
		icon_state = "closed"
		density = 1
		opacity=1
		pass=""
		door=0
		bumpable=0
		Enter()
			if(bumpable==0)
				return 0
			else return ..()
	IanOfficeDoor
		name = "Ian's Office Door"
		flyblock=1
		icon = 'Door.dmi'
		icon_state = "closed"
		density = 1
		opacity=1
		pass=""
		door=0
		bumpable=0
	Voyager_Door
		bumpable=1
		flyblock=1
		door=1
		icon='ADoor.dmi'
		density=1
		icon_state="closed"
		opacity=1
		pass=""
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
	WaterReal
		icon='turf.dmi'
		name = "Water"
		icon_state="waterreal"
		density=1
	Holoroom_Door
		bumpable=1
		door=0
		icon='Door.dmi'
		density=1
		icon_state="closed"
		opacity=1
		pass=""
turf

	basementpole
		icon='COMC Icons.dmi'
		icon_state="pole"
		density=1
	basementrail
		icon='COMC Icons.dmi'
		icon_state="rail"
		density=1
	C2
		icon='COMC Icons.dmi'
		icon_state="C2"
	C1
		icon='COMC Icons.dmi'
		icon_state="C1"
	DarkAngelTop
		icon='Objects.dmi'
		icon_state="top"
		density=1
	DarkAngelBottom
		icon='Objects.dmi'
		icon_state="bottom"
		density=1
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