/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

obj/var/tmp
	purpose = 0
mob/NPC/Enemies
	Grindylow
		icon = 'Mobs.dmi'
		icon_state = "grindylow"
		gold = 195
		HP = 2925
		MHP = 2925
		Dmg = 975
		Def=80
		Expg = 510
		level = 120// CHange them stats bitch tits.

mob
	//Grindylow
	//	icon = 'Mobs.dmi'
	//	icon_state = "Grindylow"
		//Not affected but any movement slowing effect
		//can hopefully target people through seaweed.
	Victims//These will be what players must rescue out of the water by either depulsoing or flippendoing them into
	//the starting teleporter. if the player dies or leaves the water, these mobs will respawn to their original position.
		Immortal=1
		Gryffindor_Victim
			icon = 'Victims.dmi'
			icon_state = "Gryffindor"
		Slytherin_Victim
			icon = 'Victims.dmi'
			icon_state = "Slytherin"
		Hufflepuff_Victim
			icon = 'Victims.dmi'
			icon_state = "Hufflepuff"
		Ravenclaw_Victim
			icon = 'Victims.dmi'
			icon_state = "Ravenclaw"
		New()
			..()
			overlays+=image('Victims.dmi',"Binding")

			//victims need to be bound.

/*
			Fire_Bat
				icon = 'Mobs.dmi'
				icon_state="firebat"
				gold = 111
				HP = 1667
				MHP = 1667
				Str = 555
				Def=35
				Expg = 89
				level = 60
				Attack(mob/M)
					while(get_dist(src,M)>5)
						if(!activated)
							spawn(rand(10,30))
								walk_rand(src,11)
							return
						if(!(M in oview(src)))
							spawn()Wander()
							return
						step_to(src,M)
						sleep(4)
					dir=get_dir(src,M)
					var/obj/S=new/obj/enemyfireball(src.loc)
					walk(S,dir,2)
					spawn(30)M.Death_Check(src)
					sleep(10)
					for(var/mob/A in oview(src)) if(A.client)
						walk(src,0)
						spawn()Attack(A)
						return

*/




obj
	Cloud
		icon = 'NCloud.dmi'
		icon_state = "White"
		opacity = 1
		density=1

	Evil_Cloud
		name="Cloud"
		icon = 'NCloud.dmi'
		icon_state = "Black"
		opacity = 1
		density=1
		var/state = "happy"
		New()
			. = ..()
			spawn()
				AI()
		proc/AI()
			while(src)
				switch(state)
					if("happy")
						density = 0
						icon_state = "White"
						sleep(rand(10,20))
						state = "unsure"
					if("unsure")
						density = 1
						icon_state = "Gray"
						sleep(rand(10,20))
						state = "angerz"
					if("angerz")
						var/attkrnd = rand(10,20)
						density = 1
						icon_state = "Black"
						spawn()
							Attack(attkrnd)
						sleep(attkrnd)
						state = "happy"
		proc/Attack(attkrnd)
			while(attkrnd>0)
				for(var/mob/M in view(1,src))
					if(M.client)
						hearers() << "<font color=red>[src] fires lightning at [M]!</font>"
						M << "<font color=red>[src] fires lightning at [M]!</font>"
						M.loc = locate(48,7,24)
				attkrnd-=3
				sleep(3)
/*
proc
	CloudCycle()
		for(var/obj/DynamicCloud1/X in world)
			var/sleeprand=rand(10,20)
			sleep(sleeprand)
			new/obj/DynamicCloud2(X.loc)
			del X
		for(var/obj/DynamicCloud2/X in world)
			var/sleeprand=rand(10,20)
			sleep(sleeprand)
			new/mob/DynamicCloud3(X.loc)
			del X
		for(var/mob/DynamicCloud3/X in world)
			var/sleeprand=rand(10,20)
			sleep(sleeprand)
			new/obj/DynamicCloud1(X.loc)
			del X
		CloudCycle()
*/


		//randomly changes icon states every 45 to 60 seconds
		//white cloud is undense
		//gray cloud is dense
		//black cloud is dense and will attempt to attack players with a 1 hit K.O lightning attack
		//the black cloud attack is not a projectile


area
	Underwater
		icon = 'Water.dmi'
		icon_state = "water"
		layer = 13
		alpha = 150
		//Will slow human movement by 50%
		//will slow inhuman movement by 25%
		//humans have 30 seconds before being teleported out (not affected by logout).
		//will not allow you to fly on a broom.
		//for the purposes of this event only, announce deaths, unless we can have them not go to the hospital wing.

	Sky
		//Anyone not on a broom will fall to the ground AKA the ground teleporters.
	Observe_Area1
		//for observing players in the desert area.
	Observe_Area2
		//for observing players in the Underwater area.
	Observe_Area3
		//for observing players in the sky area.

	//these should be easy, since we can just copy/paste/edit the code for how the quidditch observe_area works.
	//Observe.dmi as the icon to activate the areas

/mob/var/tmp/unslow = 0
mob/proc/unslow()
	spawn()
		unslow=1
		sleep(1200)
		usr << "<b>The effects wear off.</b>"
		unslow=0

obj/items/Underwater_Bean
	icon = 'Bean.dmi'
	icon_state = "Bean"
	name = "Mysterious Bean"
	desc = "It's a little wet."

	Click()
		if(src in usr)
			if(canUse(usr,cooldown=null,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstflying=0,againstcloaked=0))
				if(usr.unslow) return
				usr << "<b>You swallow the bean.</b>"
				flick("transfigure",usr)
				usr.trnsed = 1
				usr.overlays = null
				if(usr.Gender == "Female")
					usr.icon = 'FemaleFish.dmi'
				else
					usr.icon = 'MaleFish.dmi'
				usr.unslow()
				if(usr.away) usr.ApplyAFKOverlay()
				del(src)
		else
			..()

obj
	Pyramid_Bean
		icon = 'Bean.dmi'
		icon_state = "Bean"
		verb
			Pick_Up()
				set category = "Commands"
				set src in orange(1)
				if(count()>5)
					usr << "<b>You're already carrying the maximum of 5 pyramid beans!</b>"
				else
					usr.contents += src
					usr << "<b>You pick up the pyramid bean!</b>"
			Drop()
				set category = "Commands"
				src.loc = locate(usr.x,usr.y,usr.z)
			Eat()
				if(usr.unslow)
					usr << "<b>You're already using a pyramid bean.</b>"
				else
					usr << "<b>You swallow the bean.</b>"
					usr.icon_state="bl"
					if(usr.Gender=="Male")
						usr.underlays+=image('Fishpeople.dmi',icon_state="m")
					if(usr.Gender=="Female")
						usr.underlays+=image('Fishpeople.dmi',icon_state="f")
					usr.unslow()
					del(src)
		proc
			count()
				var/i=0
				for(var/obj/O in loc)
					if(O.type == src.loc)
						i++
				return i
		//set human var to 1 to make them inhuman.
		//effects will last 120 seconds.
		//if reverting back to human underwater, 30 seconds need to apply to them.
		//can only carry 5 at a time.
	TriwizardCup
		icon = 'Goblet.dmi'
		name = "Triwizard Cup"
		icon_state = "blue-idle"
		//This will have the same icon as the goblet of fire, but will teleport the first person who touches it to
		//the great hall, announce the winner, then delete itself.
		Click()
			if(usr in oview(1))
				usr << "You reach up and touch the Triwizard Cup."
				usr.loc = locate(38,37,21)
				Players << "<h2>Congratulations to <b>[usr]</b> who has reached the Triwizard Cup first! Assemble in the Great Hall for the 2011 Triwizard Tournament Closing Ceremony</h2>"
				del(src)
	Tiles
		//Players can only take one of each tile
		PTile1
			name = "Worn Tile"
			icon = 'PTiles.dmi'
			icon_state = "1"
		PTile2
			name = "Worn Tile"
			icon = 'PTiles.dmi'
			icon_state = "2"
		PTile3
			name = "Worn Tile"
			icon = 'PTiles.dmi'
			icon_state = "3"
		PTile4
			name = "Worn Tile"
			icon = 'PTiles.dmi'
			icon_state = "4"
		PTile5
			name = "Worn Tile"
			icon = 'PTiles.dmi'
			icon_state = "5"
		PTile6
			name = "Worn Tile"
			icon = 'PTiles.dmi'
			icon_state = "6"
		PTile7
			name = "Worn Tile"
			icon = 'PTiles.dmi'
			icon_state = "7"
		PTile8
			name = "Worn Tile"
			icon = 'PTiles.dmi'
			icon_state = "8"
		PTile9
			name = "Worn Tile"
			icon = 'PTiles.dmi'
			icon_state = "9"


mob/var/tmp/beansearching

obj
	Seaweed
		icon = 'Underwater.dmi'
		icon_state = "Seaweed"
		opacity = 1
		layer = 5
		verb
			Search()
				set src in oview(1)
				if(usr.beansearching)return
				var/i=0
				for(var/obj/O in loc)
					if(O.type == /obj/Pyramid_Bean)
						i++
				if(i>5)
					usr << "<b>You're already carrying the maximum of 5 pyramid beans!</b>"
					return
				usr.beansearching=1
				var/beanchance=rand(1,7)
				usr.GMFrozen=1
				usr << "<b>You begin searching in the seaweed.</b>"
				if(beanchance==1)
					sleep(50)
					usr.beansearching=0
					usr << "<b>You find a Pyramid Bean!</b>"
					new/obj/Pyramid_Bean(usr)
				else
					sleep(50)
					usr.beansearching=0
					usr << "<b>You find nothing.</b>"
				usr.GMFrozen=0
				//5% chance of finding a Pyramid Bean
				//must wait 5 seconds before searching again

turf
	Sky
		icon = 'sky.dmi'
		icon_state = "sky"
		layer = 1
		New()
			..()
			icon_state = "[rand(1,6)]"

	Sea_Floor
		icon = 'Underwater.dmi'
		icon_state = "Sand Floor"
		slow = 5


	Canyon
		Canyon
			icon = 'Underwater.dmi'
			icon_state = "Canyon"
			opacity = 1
			density = 1
		Canyon1
			icon = 'Underwater.dmi'
			icon_state = "C1"
			density = 1
		Canyon2
			icon = 'Underwater.dmi'
			icon_state = "C2"
			density = 1
		Canyon3
			icon = 'Underwater.dmi'
			icon_state = "C3"
			density = 1
		Canyon4
			icon = 'Underwater.dmi'
			icon_state = "C4"
			density = 1
		Canyon5
			icon = 'Underwater.dmi'
			icon_state = "C5"
			density = 1
		Canyon6
			icon = 'Underwater.dmi'
			icon_state = "C6"
			density = 1
		Canyon7
			icon = 'Underwater.dmi'
			icon_state = "C7"
		Canyon8
			icon = 'Underwater.dmi'
			icon_state = "C8"
			layer = 5
		Canyon9
			icon = 'Underwater.dmi'
			icon_state = "C9"
		Canyon10
			icon = 'Underwater.dmi'
			icon_state = "C10"
		Canyon11
			icon = 'Underwater.dmi'
			icon_state = "C11"
			layer = 5
		Canyon12
			icon = 'Underwater.dmi'
			icon_state = "C12"
			layer = 5
	Sand_Dune
		SDune1
			icon = 'PTiles.dmi'
			icon_state = "Dune"
			verb
				Search()
					set category = "Commands"
					set src in oview(1)
					if(locate(/obj/Tiles/PTile1) in usr.contents)
						usr << "\nYou find nothing."
						return
					if(locate(/obj/Tiles/PTile1)in usr.bank.items)
						usr << "\nYou find nothing."
						return

					var/obj/Tiles/PTile1/n = new
					usr.contents += n
		SDune2
			icon = 'PTiles.dmi'
			icon_state = "Dune"
			verb
				Search()
					set category = "Commands"
					set src in oview(1)
					if(locate(/obj/Tiles/PTile2) in usr.contents)
						usr << "\nYou find nothing."
						return
					if(locate(/obj/Tiles/PTile2)in usr.bank.items)
						usr << "\nYou find nothing."
						return
					var/obj/Tiles/PTile2/n = new
					usr.contents += n
		SDune3
			icon = 'PTiles.dmi'
			icon_state = "Dune"
			verb
				Search()
					set category = "Commands"
					set src in oview(1)
					if(locate(/obj/Tiles/PTile3) in usr.contents)
						usr << "\nYou find nothing."
						return
					if(locate(/obj/Tiles/PTile3)in usr.bank.items)
						usr << "\nYou find nothing."
						return
					var/obj/Tiles/PTile3/n = new
					usr.contents += n
		SDune4
			icon = 'PTiles.dmi'
			icon_state = "Dune"
			verb
				Search()
					set category = "Commands"
					set src in oview(1)
					if(locate(/obj/Tiles/PTile4) in usr.contents)
						usr << "\nYou find nothing."
						return
					if(locate(/obj/Tiles/PTile4)in usr.bank.items)
						usr << "\nYou find nothing."
						return
					var/obj/Tiles/PTile4/n = new
					usr.contents += n
		SDune5
			icon = 'PTiles.dmi'
			icon_state = "Dune"
			verb
				Search()
					set category = "Commands"
					set src in oview(1)
					if(locate(/obj/Tiles/PTile5) in usr.contents)
						usr << "\nYou find nothing."
						return
					if(locate(/obj/Tiles/PTile5)in usr.bank.items)
						usr << "\nYou find nothing."
						return
					var/obj/Tiles/PTile5/n = new
					usr.contents += n
		SDune6
			icon = 'PTiles.dmi'
			icon_state = "Dune"
			verb
				Search()
					set category = "Commands"
					set src in oview(1)
					if(locate(/obj/Tiles/PTile6) in usr.contents)
						usr << "\nYou find nothing."
						return
					if(locate(/obj/Tiles/PTile6)in usr.bank.items)
						usr << "\nYou find nothing."
						return
					var/obj/Tiles/PTile6/n = new
					usr.contents += n
		SDune7
			icon = 'PTiles.dmi'
			icon_state = "Dune"
			verb
				Search()
					set category = "Commands"
					set src in oview(1)
					if(locate(/obj/Tiles/PTile7) in usr.contents)
						usr << "\nYou find nothing."
						return
					if(locate(/obj/Tiles/PTile7)in usr.bank.items)
						usr << "\nYou find nothing."
						return
					var/obj/Tiles/PTile7/n = new
					usr.contents += n
		SDune8
			icon = 'PTiles.dmi'
			icon_state = "Dune"
			verb
				Search()
					set category = "Commands"
					set src in oview(1)
					if(locate(/obj/Tiles/PTile8) in usr.contents)
						usr << "\nYou find nothing."
						return
					if(locate(/obj/Tiles/PTile8)in usr.bank.items)
						usr << "\nYou find nothing."
						return
					var/obj/Tiles/PTile8/n = new
					usr.contents += n
		SDune9
			icon = 'PTiles.dmi'
			icon_state = "Dune"
			verb
				Search()
					set category = "Commands"
					set src in oview(1)
					if(locate(/obj/Tiles/PTile9) in usr.contents)
						usr << "\nYou find nothing."
						return
					if(locate(/obj/Tiles/PTile9)in usr.bank.items)
						usr << "\nYou find nothing."
						return
					var/obj/Tiles/PTile9/n = new
					usr.contents += n

obj/Tiles
	verb
		Drop()
			set category = "Commands"
			set src in usr.contents
			src.loc = locate(usr.x,usr.y,usr.z)