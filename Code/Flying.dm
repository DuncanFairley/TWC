/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

obj/Broom3
	icon='icons.dmi'
	icon_state="nimbus"
obj/DeskFilled
	icon='desk.dmi'
	icon_state="TD2"
	density=1
obj/DeskEmpty
	icon='desk.dmi'
	icon_state="S1"
	density=1
obj/Desk3
	icon='desk.dmi'
	icon_state="S3"
	density = 1
obj/Chair
	icon='desk.dmi'
	icon_state="Chair"
	accioable=1
	wlable=1
obj/Lantern
	icon='Decoration.dmi'
	icon_state="lantern"
	density=1
obj/lineR
	icon='table house lines.dmi'
	icon_state="r"
obj/lineS
	icon='table house lines.dmi'
	icon_state="s"
obj/lineG
	icon='table house lines.dmi'
	icon_state="g"
obj/lineH
	icon='table house lines.dmi'
	icon_state="h"
obj/Armor_Head
	icon='statues.dmi'
	icon_state="head"
	layer = MOB_LAYER + 1
obj/gargoylerighttop
	icon='statues.dmi'
	icon_state="top3"
	layer = MOB_LAYER + 1
obj/gargoylelefttop
	icon='statues.dmi'
	icon_state="top2"
	layer = MOB_LAYER + 1
obj/gargoylerightbottom
	icon='statues.dmi'
	icon_state="bottom3"
	density=1
obj/gargoyleleftbottom
	icon = 'statues.dmi'
	icon_state = "bottom2"
	density = 1
obj/statuebody
	icon='statues.dmi'
	icon_state="stat"
	density=1
obj/statuehead
	icon='statues.dmi'
	icon_state="sh"
	layer = MOB_LAYER + 1
obj/Grave
	icon='statues.dmi'
	icon_state="grave5"
obj/Grave_Rip
	icon='statues.dmi'
	icon_state="rip"
obj/Ghost_Top
	icon='statues.dmi'
	icon_state="stat1a"
	layer = MOB_LAYER + 1
obj/Ghost_Bottom
	icon='statues.dmi'
	icon_state="stat2a"
	layer = MOB_LAYER + 1
obj/Ghost_Top2
	icon='statues.dmi'
	icon_state="stat1b"
	density = 1
obj/Ghost_Bottom2
	icon='statues.dmi'
	icon_state="stat2b"
	density=1
obj/Torch_
	icon='misc.dmi'
	icon_state="torch"
obj/Angel_Bottom
	icon='statues.dmi'
	icon_state="bottom1"
	density=1
obj/Angel_Top
	icon='statues.dmi'
	icon_state="top1"
	layer = MOB_LAYER + 1
obj/redroses
	var/GM_Made = 0
	icon='attacks.dmi'
	icon_state="herbificus"
	density=1
	layer = 6
obj/Armor_Feet
	icon='statues.dmi'
	icon_state="feet"
	density=1
obj/Fountain_
	icon='statues.dmi'
	icon_state="foun1"
	density=1
obj/Fountain__
	icon='statues.dmi'
	icon_state="foun2"
	density=1
obj/Fountain___
	icon='statues.dmi'
	icon_state="foun3"
	density=1
obj/Fountain____
	icon='statues.dmi'
	icon_state="foun4"
	density=1
obj/Force_Field
	icon='teleport2.dmi'
	icon_state="shield"
	density=1
	appearance_flags = RESET_COLOR

obj
	candle
		var/tmp/turf/origloc
		icon = 'turf.dmi'
		icon_state = "candle"
		layer = 7
		accioable = 1
		wlable = 1
		New()
			set waitfor = 0
			..()
			pixel_x = rand(-7,7)
			pixel_y = rand(-7,7)

			sleep(1)
			origloc = loc

		proc/respawn()
			set waitfor = 0
			sleep(rand(700, 2400))
			if(origloc)
				if(z == origloc.z)
					accioable = 0
					wlable    = 0
					while(loc != origloc)
						var/t = get_step_towards(src, origloc)
						if(!t)
							loc = origloc
							break
						loc = t
						sleep(2)
					accioable = 1
					wlable    = 1
				else
					loc = origloc

obj
	tree
		name       = "Tree"
		icon       = 'BigTree.dmi'
		icon_state = "stump"

		density    = 1
		pixel_x    = -64


		New()
			..()

			var/obj/tree_top/t = new(loc)
			t.y++

			#if WINTER

			invisibility = 100

			#else

			if(prob(60))
				var/r = rand(160, 255)
				var/g = rand(82, r)
				var/b = rand(45, g)
				color = rgb(r, g, b)

			#endif




	tree_top
		name       = "Tree"
		icon       = 'BigTree.dmi'
		icon_state = "top"
		density = 1
		pixel_x = -64
		pixel_y = -32
		layer   = 5

		New()
			..()

			#if WINTER

			if(prob(70)) color = rgb(170, rand(170, 240), 170)

			var/r = rand(1,3)
			icon_state = "stump[r]_winter"

			if(prob(75))
				var/image/i = new('BigTree.dmi', "snow[r]")
				i.appearance_flags = RESET_COLOR
				overlays += i

			#else

			if(prob(80)) color = rgb(0, rand(150, 220), 0)

			#endif

	flyblock
		invisibility = 10
		New()
			..()
			var/turf/t = loc
			t.flyblock = 1
			t.density  = 1
			loc = null


turf
	dirt_south
		icon_state="dirt south"
	dirt_north
		icon_state="dirt north"
	dirt_east
		icon_state="dirt east"
	dirt_west
		icon_state="dirt west"

obj/Golden_Candles
	icon='Decoration.dmi'
	icon_state="gcandle"
	density=1
	pixel_y = -16
obj/Golden_Candles_
	icon='Decoration.dmi'
	icon_state="gcandle1"
	density=1
	pixel_y = -16

obj/plate
	icon='turf.dmi'
	icon_state="plate"
	density=1

obj/Cauldron
	icon = 'cau.dmi'
	icon_state = "C1"
	density = 1
	rubbleable = 1
	New()
		..()
		icon_state = "C[rand(1,8)]"

obj/gryffindor
	icon='shields.dmi'
	icon_state="gryffindor"
	density=1
obj/slytherin
	icon='shields.dmi'
	icon_state="slytherin"
	density=1
obj/hufflepuff
	icon='shields.dmi'
	icon_state="hufflepuff"
	density=1
obj/ravenclaw
	icon='shields.dmi'
	icon_state="ravenclaw"
	density=1
obj/gryffindorbanner
	icon='shields.dmi'
	icon_state="gryffindorbanner"
	density=1
obj/slytherinbanner
	icon='shields.dmi'
	icon_state="slytherinbanner"
	density=1
obj/hufflepuffbanner
	icon='shields.dmi'
	icon_state="hufflepuffbanner"
	density=1
obj/ravenclawbanner
	icon='shields.dmi'
	icon_state="ravenclawbanner"
	density=1
obj/hogwartshield
	icon='shields.dmi'
	icon_state="hogwartsshield"
	density=1
obj/hogwartbanner
	icon='shields.dmi'
	icon_state="hogwartsbanner"
	density=1
obj/Fountain
	icon='shields.dmi'
	icon_state="fountain"
	density=1
	accioable=1
	wlable = 1
	rubbleable=1
obj/Lamp_Table_Top
	icon='house.dmi'
	icon_state="Lamp Table Top"
	density=1
	pixel_y=-10

obj/Lamp_Table_Bottom
	icon='house.dmi'
	icon_state="Table Bottom"
	density=1
	pixel_y=-10

obj/Cabinet1
	name="Cabinet"
	icon='house.dmi'
	icon_state="dress1"
	density=1

obj/Cabinet2
	name="Cabinet"
	icon='house.dmi'
	icon_state="dress2"
	density=1

obj/Lamp1
	name="Lamp"
	icon='house.dmi'
	icon_state="lamp"
	density=1

obj/Desk
	icon='desk.dmi'
	icon_state="S1"
	density=1

obj/Book_Shelf
	icon='Desk.dmi'
	icon_state="1"
	density=1

obj/Book_Shelf1
	icon='Desk.dmi'
	icon_state="2"
	density=1

obj/Wand_Shelf
	icon='Desk.dmi'
	icon_state="3"
	density=1

obj/stone
	icon='turf.dmi'
	icon_state="stone"
	density=1

	New()
		set waitfor = 0
		sleep(600)
		loc = null

obj/Dual_Swords
	icon='wallobjs.dmi'
	icon_state="sword"
	density=1

obj/Fireplace
	icon='misc.dmi'
	icon_state="fireplace"
	density=1

turf
	Fireplace
		icon='misc.dmi'
		icon_state="fireplace"
		green
			icon_state="floo fireplace"
			Entered(mob/M)
				.=..()
				if(isplayer(M))
					emit(loc    = M,
						 ptype  = /obj/particle/smoke/green,
					     amount = 10,
					     angle  = new /Random(1, 359),
					     speed  = 2,
					     life   = new /Random(15,25))

obj/Microphone
	icon='Microphone.dmi'

	verb
		Speak()
			set src in oview(1)
			var/Reason = input(usr,"What do you want to say?","Microphone")
			view(50)<<"<span style=\"color:silver\"><b>Microphone> [usr]:</b> [html_encode(Reason)]</span>"

obj/Reserved
	icon='misc.dmi'
	icon_state="reserved"
	density=1

obj/Exit
	icon='misc.dmi'
	icon_state="exit"
	density=1
obj/Blackboard_
	icon='bb.dmi'
	icon_state="1"
	density=1
obj/Blackboard__
	icon='bb.dmi'
	icon_state="2"
	density=1
obj/Blackboard___
	icon='bb.dmi'
	icon_state="3"
	density=1
obj
	air1
		name = "Sign"
		icon = 'dj.dmi'
		icon_state="1off"
		verb
			Turn_On()
				set src in oview(1)
				src.icon_state="on"
				for(var/obj/air2/X in world)
					X.icon_state="off"
			Turn_Off()
				set src in oview(1)
				src.icon_state="1off"
				for(var/obj/air2/X in world)
					X.icon_state="2off"
obj
	air2
		name = "Sign"
		icon = 'dj.dmi'
		icon_state="2off"
turf
	blackblock
		icon='turf.dmi'
		icon_state="blackz"
mob
	Anderoffice
		invisibility = 2
		name = "Marker1"
		density = 0
	Marker2
		name = "Marker2"
		invisibility = 2
		density = 0
	Marker3
		name = "Marker3"
		invisibility = 2
		density = 0
obj
	Barrels
		icon='turf.dmi'
		icon_state="barrels"
		density=1
obj
	bigbluechair
		name="Big Blue Chair"
		icon='Thrones.dmi'
		icon_state="blue"
	biggreenchair
		name="Big Green Chair"
		icon='Thrones.dmi'
		icon_state="green"
	bigtealchair
		name="Big Teal Chair"
		icon='Thrones.dmi'
		icon_state="teal"
	bigwhitechair
		name="Big White Chair"
		icon='Thrones.dmi'
		icon_state="white"
	bigblackchair
		name="Big Black Chair"
		icon='Thrones.dmi'
		icon_state="black"
	bigpurplechair
		name="Big Purple Chair"
		icon='Thrones.dmi'
		icon_state="purple"
	bigredchair
		name="Big Red Chair"
		icon='Thrones.dmi'
		icon_state="red"
	bigyellowchair
		name="Big Yellow Chair"
		icon='Thrones.dmi'
		icon_state="yellow"
turf
	ror
		var
			n
			dest = "ror"
		ror1
			n=1
		ror2
			n=2
		ror3
			n=3
		Enter(atom/movable/O)
			if(density && isplayer(O) && O:ror == n)
				return 1
			else
				.=..()

		Entered(mob/Player/M)
			if(isplayer(M))
				if(M.ror==n || M.ror==-1)
					M.Transfer(locate(dest))
turf
	bathroomstall
		icon = 'Stall.dmi'
		name = "Stall"
		density = 1
		opacity = 1
		s1
			icon_state = "1"
		s2
			icon_state = "2"
		s3
			icon_state = "3"
		s4
			icon_state = "4"
		s5
			icon_state = "5"

obj
	sink
		icon = 'sink.dmi'
		density = 1
		opacity = 0
obj
	toilet
		name = "toilet"
		icon = 'toilet.dmi'

		proc
			poop(mob/Player/P)
				if(P.Pooping)
					P.Pooping = 0
					P << infomsg("You feel a lot better.")

obj
	pumpkin
		icon='pumpkin.dmi'
		density=1
obj
	egg1
		icon='Eggs.dmi'
		icon_state="1"
		density=1
obj
	egg2
		icon='Eggs.dmi'
		icon_state="2"
		density=1
obj
	egg3
		icon='Eggs.dmi'
		icon_state="3"
		density=1
obj
	egg4
		icon='Eggs.dmi'
		icon_state="4"
		density=1
obj
	egg5
		icon='Eggs.dmi'
		icon_state="5"
		density=1
obj
	egg6
		icon='Eggs.dmi'
		icon_state="6"
		density=1
obj
	egg7
		icon='Eggs.dmi'
		icon_state="7"
		density=1
obj
	egg8
		icon='Eggs.dmi'
		icon_state="8"
		density=1
obj
	egg9
		icon='Eggs.dmi'
		icon_state="9"
		density=1
obj
	egg10
		icon='Eggs.dmi'
		icon_state="10"
		density=1
obj
	egg11
		icon='Eggs.dmi'
		icon_state="11"
		density=1
obj
	egg12
		icon='Eggs.dmi'
		icon_state="12"
		density=1
obj
	egg13
		icon='Eggs.dmi'
		icon_state="13"
		density=1
obj
	egg14
		icon='Eggs.dmi'
		icon_state="14"
		density=1
obj
	egg15
		icon='Eggs.dmi'
		icon_state="15"
		density=1
obj
	egg16
		icon='Eggs.dmi'
		icon_state="16"
		density=1
obj
	sandwind
		layer = 8
		name = ""
		icon = 'misc.dmi'
		icon_state = "sandstorm"
obj/Magic_Sphere
	icon='misc.dmi'
	icon_state="black"
	density=1

obj
	Trophy_Rack
		icon='trophy-rack.dmi'
		density=1
turf
	stonefloor
		icon='Gener.dmi'
		icon_state="blackfloor"
		name="floor"
obj/items/quidditchbox
	verb
		Withdraw_Quaffle()
			set category = "Quidditch"
			usr<<"You remove the quaffle from the box."
			new/obj/quidditch/quaffle(usr)
		Withdraw_Bludger()
			set category = "Quidditch"
			usr<<"You release the restraints on the bludger and it flies from the box."
			new/obj/quidditch/bludger(usr.loc)
		Withdraw_Snitch()
			set category = "Quidditch"
			usr<<"You release the Snitch from the box, and it flies away."
			new/obj/quidditch/snitch(usr.loc)

	GryffBox
		name="Quidditch Ball Box"
		icon='ballbox.dmi'
		icon_state="gryff"

	SlythBox
		name="Quidditch Ball Box"
		icon='ballbox.dmi'
		icon_state="slyth"

	HuffleBox
		name="Quidditch Ball Box"
		icon='ballbox.dmi'
		icon_state="huffle"

	RavenBox
		name="Quidditch Ball Box"
		icon='ballbox.dmi'
		icon_state="raven"

	GameBox
		name="Quidditch Ball Box"
		icon='ballbox.dmi'
		icon_state="game"

mob/Cow
	icon = 'Cow.dmi'
	appearance_flags = LONG_GLIDE
	glide_size = 4
	New()
		..()
		walk_rand(src, 8)
		Moo()
	proc/Moo()
		set waitfor = 0
		while(src)
			hearers(src) << "Cow: [pick("MooooooOOOoOo!","Moo!","MOOOOOOOOOOOOOOOOOOOOOOOOO","Moooooo!","Moo moo moo!")]"
			sleep(600 * rand(1, 5))
obj/Speaker1
	name="Speaker"
	icon='dj.dmi'
	icon_state="1"
	pixel_y=-15

obj/Speaker2
	name="Speaker"
	icon='dj.dmi'
	icon_state="2"
	pixel_y=-15

obj/stage
	icon='stage.dmi'

obj/stage1
	icon='stage.dmi'
	icon_state="1"

obj/stage2
	icon='stage.dmi'
	icon_state="2"

obj/stage3
	icon='stage.dmi'
	icon_state="3"

obj/stage4
	icon='stage.dmi'
	icon_state="4"

obj/stage5
	icon='stage.dmi'
	icon_state="5"

obj/stage6
	icon='stage.dmi'
	icon_state="6"

obj/stage7
	icon='stage.dmi'
	icon_state="7"

obj/stage8
	icon='stage.dmi'
	icon_state="8"

obj/stage9
	icon='stage.dmi'
	icon_state="9"

obj/WTable
	icon='stage.dmi'
	icon_state="w"
	density=1
turf
	tables
		icon = 'Tables.dmi'
		name = "Table"
		density = 1
		normaltable
			icon_state = "22"
		detable
			icon_state = "d22"
obj
	redballoon
		icon='balloon.dmi'
		icon_state="red"

	orangeballoon
		icon='balloon.dmi'
		icon_state="orange"
	blackballoon
		icon='balloon.dmi'
		icon_state="black"

	blueballoon
		icon='balloon.dmi'
		icon_state="blue"

	yellowballoon
		icon='balloon.dmi'
		icon_state="yellow"

	greenballoon
		icon='balloon.dmi'
		icon_state="green"

obj/Stable
	icon='General.dmi'
	icon_state="tile73"
	density=1

obj/Stable_
	icon='General.dmi'
	icon_state="tile74"
	density=1

obj/Stable__
	icon='General.dmi'
	icon_state="tile75"
	density=1

obj/Triple_Candle
	icon='General.dmi'
	icon_state="tile80"
	density=1

obj/Couch
	icon='General.dmi'
	icon_state="tile83"

obj/Couch2
	icon='General.dmi'
	icon_state="tile84"

obj/housecouch
	name = "Couch"
	icon = 'couch.dmi'
	icon_state = "green"

turf/Staircase
	icon='General.dmi'
	icon_state="tile85"

turf/Staircase3
	icon='misc.dmi'
	icon_state="blank"

obj/Hogwarts_Stairs
	icon = 'General.dmi'
	icon_state = "Stairs"

turf/Staircase2
	icon='General.dmi'
	icon_state="tile86"

obj/Clock
	icon='General.dmi'
	icon_state="tile79"
	density=1

obj/Quidditch_Sign
	icon='quidditch.png'
	pixel_x = -10
	pixel_y = -5

obj/Neptune
	icon='statues.dmi'
	icon_state="top6"
	density=1

obj/NeptuneBottom
	icon='statues.dmi'
	icon_state="bottom6"
	density=1

obj/Column
	icon='General.dmi'
	icon_state="tile93"
	density=1

obj/Columb
	icon='General.dmi'
	icon_state="tile94"
	layer = MOB_LAYER + 1

obj/Endtable
	icon='General.dmi'
	icon_state="tile72"
	density=1

obj/Pink_Flowers
	icon='Plants.dmi'
	icon_state="Pink Flowers"
	density=1

obj/Blue_Flowers
	icon = 'Plants.dmi'
	icon_state = "Blue Flowers"
	density = 1
obj/drop_on_death
	var
		announceToWorld = 1
		showicon
		slow = 0

	verb
		Drop()
			var/dense = density
			density = 0
			Move(usr.loc)
			density = dense
			usr:Resort_Stacking_Inv()
			if(announceToWorld)
				Players<<"<b>[usr] drops \the [src].</b>"
			else
				hearers()<<"[usr] drops \the [src]."

			if(showicon == 1) usr.overlays -= icon
			else if(showicon) usr.overlays -= showicon

			if(slow) usr:slow -= slow

	proc
		take(mob/Player/M)
			if(locate(type) in M) return
			if(slow) M.slow += slow
			if(announceToWorld)
				Players << "<b>[M] takes \the [src].</b>"
			else
				hearers()<<"[M] takes \the [src]."
			var/dense = density
			density = 0
			Move(M)
			density = dense
			M:Resort_Stacking_Inv()

			if(showicon == 1) M.overlays += icon
			else if(showicon) M.overlays += showicon

turf
	floo_aurorhosp
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(mob/M)
			if(ismob(M))
				flick('mist.dmi',usr)
				var/obj/O = locate("hogshospital")
				M.loc = O.loc
				flick('mist.dmi',usr)
	floo_dehosp
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(mob/M)
			if(ismob(M))
				flick('mist.dmi',usr)
				var/obj/O = locate("DEspawn[rand(1,3)]")
				M.loc = O.loc
				flick('mist.dmi',usr)
	floo_dada
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			if(usr.key != "Murrawhip")
				usr << "You burn your feet in the fireplace. Ouch!"
				return
			flick('mist.dmi',usr)
			usr.loc = locate(29,58,21)
			flick('mist.dmi',usr)
			usr << "You step into the fireplace, and are wooshed away."
	floo_shirou
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			if(A:key != "Murrawhip")
				usr << "You burn your feet in the fireplace. Ouch!"
				return
			usr.loc = locate(80,26,1)
			flick('mist.dmi',usr)
			usr << "You step into the fireplace, and are wooshed away."

turf
	floo_slythern_class
		icon = 'misc.dmi'
		icon_state="blue fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			if(!A:key) return
			switch(input("Which class would you like to go to?","Select a classroom")in list("Defense Against the Dark Arts","Charms","Care of Magical Creatures","Transfiguration","General Course of Magic","Cancel"))
				if("Defense Against the Dark Arts")
					usr.loc = locate(24,54,21)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("Charms")
					usr.loc = locate(70,11,21)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("Care of Magical Creatures")
					usr.loc = locate(52,48,21)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("Transfiguration")
					usr.loc = locate(12,83,22)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("General Course of Magic")
					usr.loc = locate(41,73,22)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)

turf
	floo_charms
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			flick('mist.dmi',usr)
			usr.loc = locate(70,10,21)
			flick('mist.dmi',usr)
			usr << "You step into the fireplace, and are wooshed away in a blaze of green fire."

obj/Bed
	icon='turf.dmi'
	icon_state="Bed"
obj/Table
	icon = 'desk.dmi'
	icon_state="S1"
	density=1

obj
	chairleft
		icon='turf.dmi'
		icon_state="cleft"

	chairright
		icon='turf.dmi'
		icon_state="cright"

	chairback
		icon='turf.dmi'
		icon_state="cback"
		layer = MOB_LAYER +1
	chairfront
		icon='turf.dmi'
		icon_state="cfront"

obj/BFrontChair
	icon='turf.dmi'
	icon_state="cfront"
turf
	sideBlock

		var/blockDir

		icon_state = "wood"
		color = "#704f32"

		New()
			..()
			icon_state = "wood[rand(1,8)]"

		Enter(atom/movable/O)
			.=..()

			if(O.density && (get_dir(src, O) & blockDir))
				O.Bump(src)
				return 0

		Exit(atom/movable/O, atom/newloc)
			.=..()

			if(O.density && (get_dir(O, newloc) & blockDir))
				O.Bump(src)
				return 0

		East
			blockDir = EAST
		West
			blockDir = WEST

obj
	fence
		icon='turf.dmi'
		icon_state="hpfence"
		density=1
	downfence
		icon='turf.dmi'
		icon_state = "post"
		density = 1
	halffence
		icon='turf.dmi'
		icon_state="halffence"
		layer = 5

	curtains
		icon='turf.dmi'
		layer = 5
		c1
			icon_state="c1"
		c2
			icon_state="c2"
		c3
			icon_state="c3"
		c4
			icon_state="c4"

turf
	icon='turf.dmi'
	grass
		#if WINTER
		name       = "snow"
		icon_state = "snow"
		#else
		name       = "grass"
		icon_state = "grass1"
		#endif

		edges
			#if !WINTER
			icon='GrassEdge.dmi'
			#endif
			north
				dir = NORTH
			west
				dir = WEST
			east
				dir = EAST
			south
				dir = SOUTH
			northeast
				dir = NORTHEAST
			northwest
				dir = NORTHWEST
			southeast
				dir = SOUTHEAST
			southwest
				dir = SOUTHWEST


	woodenfloorblack
		icon_state = "wood"
		color = "#303A3A"
		density = 0
		New()
			..()
			icon_state = "wood[rand(1,8)]"

	woodenfloor
		icon_state = "wood"
		color = "#704f32"
		New()
			..()
			icon_state = "wood[rand(1,8)]"


	longtable1
		icon='longtables.dmi'
		icon_state="x"
		density=1
	longtable2
		icon='longtables.dmi'
		icon_state="y"
		density=1
	longtable3
		icon='longtables.dmi'
		icon_state="z"
		density=1
	water/ice
		isice = 1
	water
		icon='Water.dmi'
		icon_state="water"
		name = "water"
		layer=4
		var
			tmp/obj/rain
			isice = 0

		New()
			..()

			#if WINTER
			isice = 1
			#endif

			if(isice)  ice()

		Enter(atom/movable/O, atom/oldloc)
			if(icon_state == "water")
				if(isplayer(O) && O.density) return 0
				if(istype(O, /obj/projectile) && O.icon_state == "iceball")
					if(prob(20))
						for(var/turf/water/w in range(prob(10) ? 2 : 1,O))
							w.ice()
						walk(O,0)
						O.loc = null
					else
						ice()
						O:damage -= round(O:damage / 10)
					if(O:damage <= 0)
						walk(O,0)
						O.loc = null
			else if(icon_state == "ice")
				if(istype(O, /obj/projectile) && O.icon_state == "fireball")
					water()
			return ..()

		proc
			ice()
				if(icon_state == "ice") return
				name       = "ice"
				icon_state = "ice"
				layer      = 2
				if(rain)
					rain.layer = 0
				if(!isice)
					spawn()
						var/time = rand(40,120)
						while(time > 0 && icon_state == "ice")
							time--
							sleep(10)
						if(istype(src, /turf/water)) water()
			water()
				if(icon_state == "water") return
				name       = "water"
				icon_state = "water"
				layer      = 4
				if(rain)
					rain.layer = 4
				if(isice)
					spawn()
						var/time = rand(40,120)
						while(time > 0 && icon_state == "water")
							time--
							sleep(10)
						if(istype(src, /turf/water)) ice()
			rain()
				if(rain) return
				rain = new (src)

				spawn(rand(1,150))
					if(rain)
						rain.icon = 'water_drop.dmi'
						rain.layer = name == "ice" ? 0 : 4
						rain.icon_state = pick(icon_states(rain.icon))
						rain.pixel_x = rand(-12,12)
						rain.pixel_y = rand(-13,14)
			clear()
				if(rain)
					rain.loc = null
					rain = null

	lava
		icon_state="hplava"

		Enter(atom/movable/O, atom/oldloc)
			if(isplayer(O) && O.density) return 0
			return ..()

	blankturf/edge
		icon       = null
		icon_state = null
		density    = 1
		flyblock   = 1
		opacity    = 1

	roofb
		icon       = 'StoneRoof.dmi'
		icon_state = "roof-15"
		density    = 1
		opacity    = 1
		flyblock   = 1

		proc/init()
			set waitfor = 0
			sleep(1)
			if(icon_state != "broof" && icon_state != "broofr" && icon_state != "broofl")

				var/n = 15 - autojoin("name", "roofb")

				var/dirs = list(NORTH, SOUTH, EAST, WEST)
				for(var/d in dirs)
					if((n & d) > 0)

						var/obj/static_obj/roofedge/o

						if(d == SOUTH)
							var/turf/t = locate(x + 1, y, z)
							if(!t || istype(t, /turf/blankturf)) continue
							o = new (t)
							o.pixel_x = -32
						else if(d == EAST)
							var/turf/t = locate(x, y - 1, z)
							if(!t || istype(t, /turf/blankturf)) continue
							o = new (t)
							o.pixel_y = 32
						else if(d == WEST)
							var/turf/t = locate(x - 1, y, z)
							if(!t || istype(t, /turf/blankturf)) continue
							o = new (t)
							o.pixel_x = 32
						else
							var/turf/t = locate(x, y + 1, z)
							if(!t || istype(t, /turf/blankturf)) continue
							o = new (t)
							o.pixel_y = -32

						o.layer = (d == NORTH ? 4 : 5) + layer
						o.icon_state = "edge-[15 - d]"
						n -= d
				icon_state = "roof-15"

		New()
			init()

	roofa
		icon_state = "broof"
		density=1
		opacity=1
		flyblock=1

	diamondt
		icon_state="tf2"
	blackfloor
		icon_state="blackfloor"
	blankturf
		icon_state="black"
	road
		icon_state="road"
	wfloor
		icon_state="wfloor"
	wall
		icon='wall1.dmi'
		density=1
	black
		icon_state="black"
	floor
		icon_state="brick"
	brick
		icon='hogwartsbrick.dmi'
		icon_state="brick2"
		density=1
	bush
		icon_state="bush"
		layer=MOB_LAYER+1
	ice
		icon_state="ice"
	snow
		icon='turf.dmi'
		icon_state="snow"
	dirt
		icon_state="dirt"
	sand
		icon_state="sand"
	bigchair
		icon = 'turf.dmi'
		icon_state="bc"
		density=1
obj
	static_obj
		appearance_flags = RESET_COLOR|RESET_ALPHA
		New()
			loc.overlays += src
			loc = null

		walltorch
			icon = 'turf.dmi'
			icon_state="walltorch"

		roofedge
			icon = 'StoneRoof.dmi'
			canSave = FALSE
			appearance_flags = TILE_BOUND|RESET_COLOR|RESET_ALPHA

			New()
				set waitfor = 0
				sleep(1)
				..()

obj
	tabletop
		icon='turf.dmi'
		icon_state="t1"
		density=1
		layer=2
	tableleft
		icon='turf.dmi'
		icon_state="t2"
		density=1
		layer=2
	tablemiddle2
		icon='turf.dmi'
		icon_state="mid2"
		density=1
		layer=2
	tablemiddle
		icon='turf.dmi'
		icon_state="middle"
		density=1
		layer=2
	tablecornerL
		icon='turf.dmi'
		icon_state="t2"
		density=1
		layer=2
	tablecornerR
		icon='turf.dmi'
		icon_state="t3"
		density=1
		layer=2
	tableright
		icon='turf.dmi'
		icon_state="bottomright"
		density=1
		layer=2
	tableleft
		icon='turf.dmi'
		icon_state="bottom1"
		density=1
		layer=2
	tablebottom
		icon='turf.dmi'
		icon_state="bottom"
		density=1
		layer=2
	tablemid3
		icon='turf.dmi'
		icon_state="mid3"
		density=1
		layer=2
obj
	snowman
		icon='snowman.dmi'
		name="Snow Man"

	art
		icon    = 'Decoration.dmi'
		density = 1

		Art_Tree
			icon_state="tree top"
		Art_Tree2
			icon_state="tree"
		Art
			icon_state="royal top1"
		Art1
			icon_state="royal1"
		Art_Man
			icon_state="royal top"
		Art_Man2
			icon_state="royal"

		painting
			density = 0
			p1
				icon_state="big tl"
			p2
				icon_state="big tr"
			p3
				icon_state="big bl"
			p4
				icon_state="big br"