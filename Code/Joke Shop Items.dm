/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/Zonko
	icon = 'NPCs.dmi'
	icon_state="zonko"
	name="Zonko the Prankster"
	NPC = 1
	Immortal=1
	item="Potion"
	verb
		Talk()
			set src in oview(3)
			if(usr.talkedtobunny==1)
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Zonko</font> [GMTag]</b>:<font color=white> Yes? Can I help you?"
				sleep(10)
				switch(input("Your Response","Respond")in list("Anything new for sale?","No, i'm ok"))
					if("Anything new for sale?")
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Zonko</font> [GMTag]</b>:<font color=white> Actually I have this batch of Chocolate Eggs here. But they're not for sale. This is the only batch I have."
						sleep(30)
						switch(input("Your Response","Respond")in list("Oh come on, i'll give you 5,000 gold.","Oh, ok."))
							if("Oh come on, i'll give you 5,000 gold.")
								usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Zonko</font> [GMTag]</b>:<font color=white> 5,000! That's a lot of money..."
								if(usr.gold>=5000)
									usr.talkedtobunny=2
									sleep(30)
									usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Zonko</font> [GMTag]</b>:<font color=white> Hm...Alright alright. Its a deal."
									usr.gold-=5000
									return
								else
									usr<<"\n<font size=2><font color=red><b>[Tag] <font color=red>Zonko</font> [GMTag]</b>:<font color=white> Hm...Doesn't look like you have enough money. Sorry."
									return
							if("Oh, ok.")
								return

			else
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Zonko</font> [GMTag]</b>:<font color=white> Excuse me kid, I'm quite busy."


obj
	effect/darkness
		mouse_opacity = 0
		layer = 8

		icon='jokeitems.dmi'
		icon_state="DarknessPowderEffect"

turf/var/tmp/specialtype
obj
	items
		DarknessPowder
			name = "Peruvian Instant Darkness Powder"
			icon='jokeitems.dmi'
			icon_state="DarknessPowder"
			Click()
				if(src in usr)
					src.verbs.Remove(/obj/items/verb/Take)
					hearers() << "[usr] throws some Peruvian Instant Darkness Powder into the air!"
					src.invisibility = 10
					Move(usr.loc)
					usr:Resort_Stacking_Inv()
					sleep(20)
					var/list/turf/Lt = getArea()
					for(var/turf/T in Lt)
						new/obj/effect/darkness(T)
					var/obj/items/DarknessPowder/S = src
					src.invisibility = 2
					src = null
					spawn(300)
						for(var/turf/T in Lt)
							for(var/obj/effect/darkness/D in T)
								del D
						del(S)
				else
					..()

			proc
				getArea()
					var/list/turf/Lt = list()
					var/turf/C = src.loc
					Lt.Add(C)
					for(var/turf/T in C.AdjacentTurfs())
						Lt.Remove(T)
						Lt.Add(T)
					for(var/turf/T in Lt)
						for(var/turf/A in T.AdjacentTurfs())
							Lt.Remove(A)
							Lt.Add(A)
					for(var/turf/T in Lt)
						for(var/turf/A in T.AdjacentTurfs())
							Lt.Remove(A)
							Lt.Add(A)
					for(var/turf/T in Lt)
						for(var/turf/A in T.AdjacentTurfs())
							Lt.Remove(A)
							Lt.Add(A)
					for(var/turf/T in Lt)
						for(var/turf/A in T.AdjacentTurfs())
							Lt.Remove(A)
							Lt.Add(A)
					for(var/turf/T in Lt)
						for(var/turf/A in T.AdjacentTurfs())
							if(rand(1,4)==1)
								Lt.Remove(A)
								Lt.Add(A)
					return Lt
		Swamp
			name = "Swamp in ya pocket"
			icon='jokeitems.dmi'
			icon_state="swampbox"
			Click()
				if(src in usr)
					src.verbs.Remove(/obj/items/verb/Take)
					hearers() << "[usr] drops a [src]"
					Move(usr.loc)
					usr:Resort_Stacking_Inv()
					flick("swampopen",src)
					sleep(20)
					var/list/turf/Lt = getArea()
					for(var/turf/T in Lt)
						if(T.specialtype != "Swamp")
							T.overlays.Add(icon('jokeitems.dmi',"swamp"))
							T.slow += 5
							T.specialtype = "Swamp"
							if(rand(1,4)==1)
								T.overlays.Add(icon('jokeitems.dmi',pick("swamp1","swamp2","swamp3","swamp4","swamp5","swamp6","swamp7")))
						else
							Lt -= T
					var/obj/items/Swamp/S = src
					src.invisibility = 2
					src = null
					spawn(600)
						for(var/turf/T in Lt)
							if(T.specialtype == "Swamp")
								T.overlays = list()
								T.specialtype = null
								T.slow -= 5
						del(S)
				else
					..()

			proc
				getArea()
					var/list/turf/Lt = list()
					var/turf/C = src.loc
					Lt.Add(C)
					for(var/turf/T in C.AdjacentTurfs())
						Lt.Remove(T)
						Lt.Add(T)
					for(var/turf/T in Lt)
						for(var/turf/A in T.AdjacentTurfs())
							Lt.Remove(A)
							Lt.Add(A)
					for(var/turf/T in Lt)
						for(var/turf/A in T.AdjacentTurfs())
							Lt.Remove(A)
							Lt.Add(A)
					for(var/turf/T in Lt)
						for(var/turf/A in T.AdjacentTurfs())
							if(rand(1,4)==1)
								Lt.Remove(A)
								Lt.Add(A)


					return Lt

mob/var/tmp/atom/smokepelletdest=null
mob/var/tmp/obj/items/Smoke_Pellet/smokepelletthrowing=0

atom/Click()
	. = ..()
	if(usr.smokepelletthrowing)
		if(usr.client.eye!=usr)return
		usr.smokepelletdest=src
		if(isobj(usr.smokepelletdest))usr.smokepelletdest = src.loc
		usr.smokepelletthrowing.Throwit()
		usr.smokepelletthrowing=0
obj
	hud
		cancelthrow
			name = "Cancel throw"
			icon = 'HUD.dmi'
			icon_state = "cancelthrow"
			screen_loc = "9,8"
			Click()
				usr.smokepelletthrowing.Cancel()

obj
	smokeeffect
		icon='jokeitems.dmi'
		icon_state="smoke1"
		opacity = 1
		layer = MOB_LAYER+1
		New()
			. = ..()
			icon_state = pick("smoke1","smoke2","smoke3","smoke4")
			spawn()smoke_about_the_place()
		Click()
			usr << desc

		proc
			smoke_about_the_place()
				while(1)
					step(src,pick(NORTH,SOUTH,WEST,EAST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST))
					sleep(15)
					if(rand(1,4)==1)
						//del(src)
						src.loc = null
						break
obj
	ballooneffect
		icon='balloon.dmi'
		icon_state="blue"
		opacity = 0
		layer = MOB_LAYER+1
		New()
			. = ..()
			icon_state = pick("blue","red","black","yellow","green","orange")
			spawn()float_about_the_place()
		Click()
			usr << desc

		proc
			float_about_the_place()
				walk_rand(src,rand(9,13))
				sleep(rand(75,180))
				src.loc = null
obj
	items
		Tube_of_fun
			icon='jokeitems.dmi'
			icon_state="Tube_of_fun"
			var/thrown=0
			Click()
				if(src in usr)
					src.verbs.Remove(/obj/items/verb/Take)
					hearers() << "[usr] opens a [src]"
					var/obj/items/Tube_of_fun/T = src
					spawn() Explode(T)
					src = null
				else
					..()
			proc
				Explode(obj/items/Tube_of_fun/T)
					var/obj/ballooneffect/S
					S = new(T.loc.loc)
					S.desc = "moo"
					if(usr.key=="Murrawhip")
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)
						S = new(T.loc.loc)

					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					S = new(T.loc.loc)
					T.loc = null
					if(usr)usr:Resort_Stacking_Inv()
					del(T)




		Smoke_Pellet
			icon='jokeitems.dmi'
			icon_state="smokepellet"
			var/thrown=0
			Click()
				if(src in usr)
					if(usr.smokepelletthrowing)
						Cancel()
					else
						usr.smokepelletthrowing = src
						var/obj/hud/cancelthrow/C = new()
						usr.client.screen += C
						usr << "<font size=3>You have five seconds to click where you would like to throw the [src]."
						var/obj/items/Smoke_Pellet/P = src
						src = null
						spawn(50)
							if(!P.thrown&&usr.smokepelletthrowing)P.Cancel()
				else
					..()

			proc
				Cancel()
					usr << "You put the [src] back into your robes."
					usr.smokepelletthrowing = 0
					for(var/obj/hud/cancelthrow/R in usr.client.screen)
						del(R)
				Throwit()
					thrown=1
					usr.smokepelletthrowing = 0
					for(var/obj/hud/cancelthrow/R in usr.client.screen)
						del(R)
					hearers() << "[usr] throws a smoke pellet!"
					Move(usr.loc)
					usr:Resort_Stacking_Inv()
					walk_towards(src,usr.smokepelletdest,1)
					while(src)
						sleep(1)
						if(src.loc == usr.smokepelletdest)
							Explode()
							break
				Explode()
					flick("smokepelletland",src)
					sleep(14)
					src.icon = null
					src.invisibility = 2
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					sleep(2)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					new /obj/smokeeffect (src.loc)
					var/rnd = rand(30,50)
					for(var/i=0; i<rnd; i++)
						sleep(rand(1,3))
						new /obj/smokeeffect (src.loc)
					//del(src)
					src.loc = null