/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/TalkNPC/Zonko
	icon = 'NPCs.dmi'
	icon_state="zonko"
	name="Zonko the Prankster"
	NPC = 1
	Immortal=1
	item="Potion"

	Talk()
		set src in oview(3)
		if(usr.talkedtobunny==1)
			usr << "\n<font size=2><font color=red><b> <font color=red>Zonko</font> [GMTag]</b>:<font color=white> Yes? Can I help you?"
			sleep(10)
			switch(input("Your Response","Respond")in list("Anything new for sale?","No, I'm ok."))
				if("Anything new for sale?")
					usr << "\n<font size=2><font color=red><b> <font color=red>Zonko</font> [GMTag]</b>:<font color=white> Actually I have this batch of Chocolate Eggs here. But they're not for sale. This is the only batch I have."
					sleep(30)
					switch(input("Your Response","Respond")in list("Oh come on, I'll give you 50,000 gold.","Oh, ok."))
						if("Oh come on, I'll give you 50,000 gold.")
							usr << "\n<font size=2><font color=red><b> <font color=red>Zonko</font> [GMTag]</b>:<font color=white> 50,000! That's a lot of money..."
							if(usr.gold>=50000)
								usr.talkedtobunny=2
								sleep(30)
								usr << "\n<font size=2><font color=red><b> <font color=red>Zonko</font> [GMTag]</b>:<font color=white> Hm...Alright alright. Its a deal."
								usr.gold-=50000
								return
							else
								usr<<"\n<font size=2><font color=red><b> <font color=red>Zonko</font> [GMTag]</b>:<font color=white> Hm...Doesn't look like you have enough money. Sorry."
								return
						if("Oh, ok.")
							return
				if("No, I'm ok.")
					usr << "\n<font size=2><font color=red><b> <font color=red>Zonko</font> [GMTag]</b>:<font color=white>Stop wasting my time!"
					return

		else
			usr << "\n<font size=2><font color=red><b> <font color=red>Zonko</font> [GMTag]</b>:<font color=white> Excuse me kid, I'm quite busy."


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
mob/var/tmp/obj/items/Smoke_Pellet/smokepelletthrowing

atom/Click()
	. = ..()
	if(usr.smokepelletthrowing)
		if(usr.client.eye!=usr)return
		usr.smokepelletdest=src
		if(isobj(usr.smokepelletdest))usr.smokepelletdest = src.loc
		spawn()usr.smokepelletthrowing.Throwit()
obj
	hud
		cancelthrow
			name = "Cancel throw"
			icon = 'HUD.dmi'
			icon_state = "cancelthrow"
			screen_loc = "9,8"
			mouse_over_pointer = MOUSE_HAND_POINTER
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
					src.loc = usr.loc
					usr:Resort_Stacking_Inv()

					var/n = dir2angle(usr.dir)
					emit(loc    = usr,
						 ptype  = /obj/particle/balloon,
					     amount = 50,
					     angle  = new /Random(n - 35, n + 35),
					     speed  = 5,
					     life   = new /Random(20,60))

					hearers() << "[usr] opens a [src]"

					spawn(50)
						src.loc = null
				else
					..()

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
				Cancel(var/silent = FALSE)
					if(!silent) usr << "You put the [src] back into your robes."
					usr.smokepelletthrowing = null
					for(var/obj/hud/cancelthrow/R in usr.client.screen)
						del(R)
				Throwit()
					thrown=1
					Cancel(TRUE)
					hearers() << "[usr] throws a smoke pellet!"
					Move(usr.loc)
					usr:Resort_Stacking_Inv()
					var/turf/t = usr.smokepelletdest
					usr.smokepelletdest = null
					while(src && t && t != loc)
						var/turf/t_to = get_step_towards(src, t)
						if(!t_to||t_to.density) break
						Move(t_to)
						sleep(1)
					Explode()
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


mob/Player/var/tmp/Pooping
obj/items/U_No_Poo
	name = "U-No-Poo"
	desc = "It smells funny... There's 5 pills left."
	icon = 'PooPill.dmi'

	var/uses = 5;

	Click()
		if(src in usr)
			if(!usr:Pooping)
				usr:Pooping = 1
				uses--

				desc = uses == 1 ? "It smells funny..." : "It smells funny... There's [uses] pills left."

				if(uses<=0)
					src.loc = null
					usr:Resort_Stacking_Inv()

				src=null
				spawn()
					hearers() << infomsg("[usr] swallows a U-No-Poo pill.")
					sleep(rand(30,60))
					usr << "<i>You feel a little odd...</i>"
					sleep(rand(100,250))
					if(!usr || !usr:Pooping) return
					usr << errormsg("You need to get to a toilet, <b>fast.</b> Something isn't quite right.")
					sleep(rand(30,60))

					for(var/p=rand(5,10); p > 0; p--)
						if(!usr || !usr:Pooping) return
						var/r = rand(1,5)
						if(r < 4)
							var/txt = pick("A deep rumbling sound is heard from [usr]'s direction.", "There's a strained expression on [usr]'s face.", "[usr] looks a little more bloated than usual.", "You hear rumbling sounds from [usr]'s direction.")
							hearers() << "<font color=#FD857D size=2><b>[txt]</b></font>"
						else if(r == 5)
							var/txt = pick("You feel a great urge to run to the nearest toilet.", "You feel horrible.", "You silently fart.")
							usr << errormsg(txt)
						sleep(rand(40,80))

					if(usr && usr:Pooping)
						hearers() << errormsg("[usr] is unable to hold onto \his bowels and the blockage is cleared!")

						var
							_x=0
							_y=1

							const
								SPREAD_SPEED = 1

						for(var/d = 1; d <= rand(2,4); d++)
							for(_x = 0; _x <= d;  _x++)
								var/turf/t = locate(usr.x+_x,usr.y+_y,usr.z)
								if(!t) break
								if(t.density) continue
								var/obj/Poop/p = new(usr.loc)
								p.get_to(t)
								sleep(SPREAD_SPEED)
							for(_y = d; _y >= -d; _y--)
								var/turf/t = locate(usr.x+_x,usr.y+_y,usr.z)
								if(!t) break
								if(t.density) continue
								var/obj/Poop/p = new(usr.loc)
								p.get_to(t)
								sleep(SPREAD_SPEED)
							for(_x = d; _x >= -d; _x--)
								var/turf/t = locate(usr.x+_x,usr.y+_y,usr.z)
								if(!t) break
								if(t.density) continue
								var/obj/Poop/p = new(usr.loc)
								p.get_to(t)
								sleep(SPREAD_SPEED)
							for(_y = -d; _y <= d; _y++)
								var/turf/t = locate(usr.x+_x,usr.y+_y,usr.z)
								if(!t) break
								if(t.density) continue
								var/obj/Poop/p = new(usr.loc)
								p.get_to(t)
								sleep(SPREAD_SPEED)
						if(usr) usr:Pooping = null

			else
				usr << errormsg("You feel funny, perhaps it's not a good time to take this.")
		else
			..()

obj/Poop
	icon = 'Poop.dmi'

	accioable = 1
	wlable    = 1

	New()
		..()
		icon_state = pick(icon_states(icon))

		pixel_x = rand(-8,8)
		pixel_y = rand(-8,8)

		spawn(rand(400,1200))
			loc = null

	proc
		stepped(mob/Player/P)
			var/StatusEffect/S = P.findStatusEffect(/StatusEffect/SteppedOnPoop)
			if(!S)
				P << "<i><font color=yellow>Ewww... You just stepped in poop.</font></i>"
				new /StatusEffect/SteppedOnPoop(P,rand(5,10))

				if(prob(30))
					loc=null

		get_to(turf/t)
			spawn()
				while(src && t && t != loc)
					var/turf/t_to = get_step_towards(src, t)
					if(!t_to||t_to.density) break
					Move(t_to)
					sleep(1)



obj/items/fireworks
	icon = 'fireworks.dmi'

	New()
		..()
		icon_state = pick(icon_states(src.icon))

	Click()
		if(src in usr)
			spawn() boom(usr)
			loc = null
			usr:Resort_Stacking_Inv()
		else
			..()


	proc
		boom(atom/A)
			var/list/dirs = list(EAST,WEST,NORTH,SOUTH,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)
			for(var/i = 0 to rand(3,7))
				var/obj/firework/f = new (A.loc)

				var/d = pick(dirs)
				dirs -= d

				walk(f, d)

				sleep(1)


obj/firework

	icon = 'lights.dmi'
	density = 1

	New()
		..()
		icon_state = pick(icon_states(src.icon))

		spawn(rand(5,10))
			density = 0
			walk(src,0)
			var/t = rand(50,100)
			light(src, rand(2,4), rand(20,80), icon_state)
			spawn(t) loc = null

	Move()
		..()
		if(prob(20))
			step_rand(src)

