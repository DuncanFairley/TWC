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

	Talk()
		set src in oview(3)
		var/mob/Player/p = usr
		var/questPointer/pointer = p.questPointers["Sweet Easter"]
		if(pointer && pointer.stage == 1)
			usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Zonko</span></b>:<font color=white> Yes? Can I help you?"
			sleep(10)
			switch(input("Your Response","Respond")in list("Anything new for sale?","No, I'm ok."))
				if("Anything new for sale?")
					usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Zonko</span></b>:<font color=white> Actually I have this batch of Chocolate Eggs here. But they're not for sale. This is the only batch I have."
					sleep(30)
					switch(input("Your Response","Respond")in list("Oh come on, I'll give you 5 gold coins.","Oh, ok."))
						if("Oh come on, I'll give you 5 gold coins.")
							usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Zonko</span></b>:<font color=white> 5 gold coins! That's a lot of money..."
							var/gold/g = new (usr)
							if(g.have(50000))
								usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Zonko</span></b>:<font color=white> Hm...Alright alright. Its a deal."
								g.change(usr, gold=-5)
								p.checkQuestProgress("Zonko")
								return
							else
								usr<<"\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Zonko</span></b>:<font color=white> Hm...Doesn't look like you have enough money. Sorry."
								return
						if("Oh, ok.")
							return
				if("No, I'm ok.")
					usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Zonko</span></b>:<font color=white>Stop wasting my time!"
					return

		else
			usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Zonko</span></b>:<font color=white> Excuse me kid, I'm quite busy."


obj
	effect/darkness
		mouse_opacity = 0
		layer = 8

		icon='jokeitems.dmi'
		icon_state="DarknessPowderEffect"

turf/var/tmp/specialtype = 0
obj
	items
		DarknessPowder
			canAuction = FALSE
			name = "Peruvian Instant Darkness Powder"
			icon='jokeitems.dmi'
			icon_state="DarknessPowder"
			Click()
				if(src in usr)
					if(canUse(M=usr, inarena=0))
						hearers() << "[usr] throws some Peruvian Instant Darkness Powder into the air!"

						var/obj/items/DarknessPowder/d = Split(1)

						d.verbs.Remove(/obj/items/verb/Take)
						d.invisibility = 10
						d.loc = usr.loc

						sleep(20)
						var/list/turf/Lt = d.getArea()
						for(var/turf/T in Lt)
							new/obj/effect/darkness(T)
						src=null
						spawn(300)
							for(var/turf/T in Lt)
								for(var/obj/effect/darkness/D in T)
									del D
							d.Dispose()
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
			canAuction = FALSE
			Click()
				if(src in usr)
					if(canUse(M=usr, inarena=0))
						hearers() << "[usr] drops a [src]"

						var/obj/items/Swamp/s = Split(1)

						s.verbs.Remove(/obj/items/verb/Take)
						s.loc = usr.loc
						s.name = "swamp"
						flick("swampopen", s)
						sleep(20)
						var/list/turf/Lt = s.getArea()
						var/list/decor = list()
						for(var/turf/T in Lt)
							if(!(T.specialtype & SWAMP))
								var/obj/o = new (T)
								o.name = "swamp"
								var/image/i = image('jokeitems.dmi',"swamp")
								i.appearance_flags = RESET_COLOR
								T.slow += 1
								T.specialtype |= SWAMP
								if(rand(1,4)==1)
									i.icon_state = pick("swamp1","swamp2","swamp3","swamp4","swamp5","swamp6","swamp7")
								decor += o
								o.overlays += i
							else
								Lt -= T

						src = null
						spawn(600)
							for(var/turf/T in Lt)
								if(T.specialtype & SWAMP)
									T.specialtype -= SWAMP
									T.slow -= 1
							for(var/obj/o in decor)
								o.loc = null
							s.Dispose()

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

mob/Player/var/tmp
	atom/smokepelletdest=null
	obj/items/Smoke_Pellet/smokepelletthrowing

atom/Click()
	. = ..()

	if(isplayer(usr))
		var/mob/Player/p = usr
		if(p.smokepelletthrowing)
			if(p.client.eye!=p)return
			p.smokepelletdest=src
			if(isobj(p.smokepelletdest))p.smokepelletdest = src.loc
			spawn()p.smokepelletthrowing.Throwit(p)
obj
	hud
		cancelthrow
			name = "Cancel throw"
			icon = 'HUD.dmi'
			icon_state = "cancelthrow"
			screen_loc = "9,8"
			mouse_over_pointer = MOUSE_HAND_POINTER
			Click()
				var/mob/Player/p = usr
				p.smokepelletthrowing.Cancel(p)

obj
	smokeeffect
		icon='jokeitems.dmi'
		icon_state="smoke1"
		opacity = 1
		layer = MOB_LAYER+1
		New()
			. = ..()
			icon_state = pick("smoke1","smoke2","smoke3","smoke4")
			smoke_about_the_place()

		proc
			smoke_about_the_place()
				set waitfor = 0
				while(loc)
					if(prob(25))
						loc = null
					else
						loc = get_step(src, pick(NORTH,SOUTH,WEST,EAST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST))
					sleep(15)
obj
	ballooneffect
		icon='balloon.dmi'
		icon_state="blue"
		opacity = 0
		layer = MOB_LAYER+1
		New()
			. = ..()
			icon_state = pick("blue","red","black","yellow","green","orange")
			float_about_the_place()

		proc
			float_about_the_place()
				set waitfor = 0
				walk_rand(src,rand(9,13))
				sleep(rand(75,180))
				src.loc = null
obj
	items
		Tube_of_fun
			icon='jokeitems.dmi'
			icon_state="Tube_of_fun"
			canAuction = FALSE
			var/thrown=0
			Click()
				if(src in usr)

					var/obj/items/Tube_of_fun/t = Split(1)

					t.verbs.Remove(/obj/items/verb/Take)
					t.loc = usr.loc
					spawn(50)
						t.Dispose()

					var/n = dir2angle(usr.dir)
					emit(loc    = usr,
						 ptype  = /obj/particle/balloon,
					     amount = 60,
					     angle  = new /Random(n - 40, n + 40),
					     speed  = 3,
					     life   = new /Random(40,80))

					hearers() << "[usr] opens a [src]"
				else
					..()

		Smoke_Pellet
			icon='jokeitems.dmi'
			icon_state="smokepellet"
			canAuction = FALSE
			var/thrown=0
			Click()
				if(src in usr)
					var/mob/Player/p = usr
					if(p.smokepelletthrowing)
						Cancel(p)
					else if(canUse(M=p, inarena=0))
						p.smokepelletthrowing = src
						var/obj/hud/cancelthrow/C = new()
						p.client.screen += C
						p << infomsg("You have five seconds to click where you would like to throw the [src].")
						var/obj/items/Smoke_Pellet/P = src
						src = null
						spawn(50)
							if(!P.thrown&&p.smokepelletthrowing)P.Cancel(p)
				else
					..()

			proc
				Cancel(mob/Player/p, var/silent = FALSE)
					if(!silent) p << "You put the [src] back into your robes."
					p.smokepelletthrowing = null
					for(var/obj/hud/cancelthrow/R in p.client.screen)
						del(R)
				Throwit(mob/Player/p)
					thrown=1
					Cancel(p, TRUE)
					hearers() << "[usr] throws a smoke pellet!"

					var/obj/items/Smoke_Pellet/s = Split(1)

					s.verbs.Remove(/obj/items/verb/Take)
					s.loc = usr.loc

					var/turf/t = p.smokepelletdest
					p.smokepelletdest = null
					src=null
					spawn()
						while(s && t && t != s.loc)
							var/turf/t_to = get_step_towards(s, t)
							if(!t_to||t_to.density) break
							s.Move(t_to)
							sleep(1)
						if(s) s.Explode()
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
					src.loc = null


mob/Player/var/tmp/Pooping
obj/items/U_No_Poo
	name = "U-No-Poo"
	desc = "It smells funny..."
	icon = 'PooPill.dmi'
	canAuction = FALSE

	Click()
		if(src in usr)
			if(!usr:Pooping)
				usr:Pooping = 1

				Consume()

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
							hearers() << "<span style=\"color:#FD857D; font-size:2;\"><b>[txt]</b></span>"
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

	Crossed(mob/Player/p)
		if(isplayer(p))
			var/StatusEffect/S = p.findStatusEffect(/StatusEffect/SteppedOnPoop)
			if(!S)
				p << "<i><span style=\"color:yellow;\">Ewww... You just stepped in poop.</span></i>"
				new /StatusEffect/SteppedOnPoop(p, rand(5,10))

				if(prob(30))
					loc=null
	proc
		get_to(turf/t)
			set waitfor = 0
			while(src && t && t != loc)
				var/turf/t_to = get_step_towards(src, t)
				if(!t_to||t_to.density) break
				loc = t_to
				sleep(1)



obj/items/fireworks
	icon = 'fireworks.dmi'

	New()
		..()
		icon_state = pick(icon_states(src.icon))

	Click()
		if(src in usr)
			spawn() boom(usr)
			stack--
			if(stack <= 0)
				Dispose()
				usr:Resort_Stacking_Inv()
			else
				UpdateDisplay()
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

