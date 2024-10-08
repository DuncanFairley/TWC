obj/Chair
	icon='desk.dmi'
	icon_state="Chair"
	accioable=1
	wlable=1
obj/Lantern
	icon='Decoration.dmi'
	icon_state="lantern"
	density=1

	flying
		density   = 0
		post_init = 1
		layer     = 5

		var/tmp
			obj/light/light
			obj/Shadow/shadow

		MapInit()
			light  = new(loc)
			shadow = new(loc)

			var/const/HEIGHT = 16
			animate(src, pixel_y = HEIGHT, time = 2, loop = -1)
			animate(pixel_y = HEIGHT + 1,  time = 2)
			animate(pixel_y = HEIGHT,      time = 2)
			animate(pixel_y = HEIGHT - 1,  time = 2)

		Dispose()
			..()

			if(light) light.loc = null
			if(shadow) shadow.loc = null

		Del()
			Dispose()
			..()

		Move()
			..()

			if(light)
				light.loc = loc
			if(shadow)
				shadow.loc = loc
obj/redroses
	var/GM_Made = 0
	var/respawn = 0
	icon='attacks.dmi'
	icon_state="herbificus"
	density=1
	layer = 6

	Cross(atom/movable/O)
		if(istype(O, /mob/Enemies))
			return 1
		.=..()

	Dispose()
		set waitfor = 0
		if(respawn)
			if(invisibility == 2) return
			density = 0
			invisibility = 2
			sleep(300)
			density = 1
			invisibility = 0
		else
			..()

obj/Force_Field
	icon='portal.dmi'
	icon_state="shield"
	density=1
	appearance_flags = RESET_COLOR

obj
	candle
		icon = 'turf.dmi'
		icon_state = "candle"
		layer = 7
		accioable = 1
		wlable = 1
		glide_size = 32
		New()
			set waitfor = 0
			..()
			pixel_x = rand(-7,7)
			pixel_y = rand(-7,7)

	var/tmp/turf/origloc
	proc/backToPos(turf/origSpot)
		set waitfor = 0

		if(!origloc && origSpot)
			origloc = origSpot
			do
				sleep(rand(700, 2400))
			while (locate(/mob/Player) in range(1, src))

			if(z == origloc.z)
				accioable = 0
				wlable    = 0
				glide_size = 16
				while(loc != origloc)
					var/t = get_step_towards(src, origloc)
					if(!t)
						loc = origloc
						break
					loc = t
					sleep(2)
				accioable = 1
				wlable    = 1
				glide_size = 32
			else
				loc = origloc

			origloc = null


	flyblock
		invisibility = 10
		post_init = 1
		MapInit()
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

obj/Cauldron
	icon = 'cau.dmi'
	icon_state = "C1"
	density = 1
	rubbleable = 1
	wlable = 1
	accioable = 1

	New()
		set waitfor = 0
		..()
		icon_state = "C[rand(1,8)]"


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
	toilet
		name = "toilet"
		icon = 'toilet.dmi'

		Crossed(mob/Player/p)
			if(isplayer(p) && p.Pooping)
				p.Pooping = 0
				p << infomsg("You feel a lot better.")

obj
	pumpkin
		icon='pumpkin.dmi'
		density=1
obj
	egg
		icon='Eggs.dmi'
		icon_state="1"
		density=1
		New()
			..()
			icon_state = "[rand(1, 16)]"

obj
	Trophy_Rack
		icon='trophy-rack.dmi'
		density=1
turf
	stonefloor
		icon='turf.dmi'
		icon_state="blackfloor2"
		name="floor"

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
		while(src && name == "Cow")
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

obj/static_obj
	tables
		icon = 'Tables.dmi'
		name = "Table"
		density = 1
		normaltable
			icon_state = "22"
		detable
			icon_state = "d22"

obj/Stable
	icon='General.dmi'
	icon_state="tile73"
	density=1

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

turf/Staircase2
	icon='General.dmi'
	icon_state="tile86"

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

obj/drop_on_death
	var
		announceToWorld = 1
		showicon
		slow = 0

	Crossed(mob/Player/p)
		if(isplayer(p))
			if(locate(type) in p) return
			if(slow) p.slow += slow
			if(announceToWorld)
				Players << "<b>[p] takes \the [src].</b>"
			else
				hearers()<<"[p] takes \the [src]."
			var/dense = density
			density = 0
			Move(p)
			density = dense

			if(showicon == 1) p.overlays += icon
			else if(showicon) p.overlays += showicon

	verb
		Drop()
			var/dense = density
			density = 0
			Move(usr.loc)
			density = dense
			if(announceToWorld)
				Players<<"<b>[usr] drops \the [src].</b>"
			else
				hearers()<<"[usr] drops \the [src]."

			if(showicon == 1) usr.overlays -= icon
			else if(showicon) usr.overlays -= showicon

			if(slow) usr:slow -= slow

turf
	floo_dehosp
		icon = 'misc.dmi'
		icon_state="floo fireplace"
		name = "Fireplace"
		Entered(mob/Player/M)
			if(isplayer(M))
				M.FlickState("m-black",8,'Effects.dmi')
				var/obj/O = pick(worldData.spawners)
				M.Transfer(O.loc)
				M.FlickState("m-black",8,'Effects.dmi')

obj
	Bed
		icon       = 'turf.dmi'
		icon_state = "Bed"
	chairleft
		accioable  = 1
		wlable     = 1
		icon       = 'desk.dmi'
		icon_state = "cleft"
		name       = "chair"
	chairright
		accioable  = 1
		wlable     = 1
		icon       = 'desk.dmi'
		icon_state = "cright"
		name       = "chair"
	chairback
		accioable  = 1
		wlable     = 1
		icon       = 'desk.dmi'
		icon_state = "cback"
		layer      = MOB_LAYER +1
		name       = "chair"
	chairfront
		accioable  = 1
		wlable     = 1
		icon       ='desk.dmi'
		icon_state = "cfront"
		name       = "chair"

turf
	sideBlock

		var/blockDir

		wood
			icon_state = "wood"
			color = "#704f32"

			New()
				..()
				icon_state = "wood[rand(1,8)]"

			East
				blockDir = EAST
			West
				blockDir = WEST

		Enter(atom/movable/O)
			.=..()

			if(O.density && (get_dir(src, O) & blockDir) && isplayer(O))
				O.Bump(src)
				return 0

		Exit(atom/movable/O, atom/newloc)
			.=..()

			if(O.density && (get_dir(O, newloc) & blockDir) && isplayer(O))
				O.Bump(src)
				return 0

		East
			blockDir = EAST
		West
			blockDir = WEST
		South
			blockDir = SOUTH

obj/static_obj
	road
		icon = 'turf.dmi'
		SE
			icon_state = "stoneSE"
		SW
			icon_state = "stoneSW"
		NE
			icon_state = "stoneNE"
		NW
			icon_state = "stoneNW"

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
	water/water
		isice = 0
	water
		icon       = 'Water.dmi'
		icon_state = "water"
		name       = "water"
		layer      = 2
		post_init  = 1
		reflect    = 1

		#if HALLOWEEN
		color = "#f15802"
		icon_state = "water_white"
		#else
		icon_state = "water"
		#endif

		var
			tmp/rain = 0
			isice    = 0

		#if WINTER
		isice = 1
		#endif

		MapInit()
			if(isice)
				ice()
			else
				layer = 1

			var/turf/t = locate(x, y + 1, z)
			if(t && !istype(t, /turf/water))
				#if !WINTER
				if(istype(t, /turf/grass))
					t.overlays += /image/grassedge/south
				#endif
				t.reflect = 1

			#if !WINTER

			t = locate(x, y - 1, z)
			if(t && istype(t, /turf/grass))
				t.overlays += /image/grassedge/north

			t = locate(x + 1, y, z)
			if(t && istype(t, /turf/grass))
				t.overlays += /image/grassedge/west

			t = locate(x - 1, y, z)
			if(t && istype(t, /turf/grass))
				t.overlays += /image/grassedge/east

			#endif

			#if HALLOWEEN
			if(loc)
				if(!(loc.name in worldData.waterColors))
					var/c = pick("#f15802", "#1ba52c", "#7c10ad", "#e50000")
					worldData.waterColors[loc.name] = c

				color = worldData.waterColors[loc.name]
			#endif

		Enter(atom/movable/O, atom/oldloc)
			if(name == "water")
				if(isplayer(O) && O.density)
					if(RING_WATERWALK in O:passives)
						ice()
					else if(O.icon_state == "Crocodile") return 1
					return 0
				else if(istype(O, /obj/projectile) && O.icon_state == "iceball")
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
			else if(name == "ice")
				if(istype(O, /obj/projectile) && O:element == FIRE)
					water()
			return ..()

		proc
			ice()
				set waitfor = 0
				if(name == "ice") return

				new /obj/fadeOut/water (src)

				name       = "ice"
				icon_state = "ice"
				layer      = 2
				if(rain)
					underlays = list()
				if(!isice)
					var/time = rand(40,120)
					while(time > 0 && name == "ice")
						time--
						sleep(10)
					if(istype(src, /turf/water)) water()
			water()
				set waitfor = 0
				if(name == "water") return

				new /obj/fadeOut/ice (src)

				name       = "water"
				#if HALLOWEEN
				icon_state = "water_white"
				#else
				icon_state = "water"
				#endif
				layer      = 1

				if(rain && prob(50))
					rain()
				if(isice)
					var/time = rand(40,120)
					while(time > 0 && name == "water")
						time--
						sleep(10)
					if(istype(src, /turf/water)) ice()
			rain()
				set waitfor = 0
				if(rain) return
				rain = 1

				sleep(rand(1,150))
				if(rain)
					var/image/i = new ('water_drop.dmi', icon_state = "drop[rand(1, 12)]", layer = 4)
					i.pixel_x = rand(-12,12)
					i.pixel_y = rand(-13,14)
					underlays += i

	lava
		icon_state="hplava"
		var/burn = 1

		Enter(atom/movable/O, atom/oldloc)
			if(isplayer(O) && O.density)

				if(burn)
					if(RING_LAVAWALK  in O:passives) return ..()

					if(!O.LStatusEffects || !(locate(/StatusEffect/Lava) in O.LStatusEffects))
						new /StatusEffect/Lava(O, 3, "Inflamari")

				return 0
			return ..()

	sky
		icon_state="sky"
		Enter(atom/movable/O, atom/oldloc)
			if(isplayer(O) && O.density)

				if(O.loc == src)
					var/mob/Player/p = O

					var/turf/t = p.findGroundTile()

					animate(p, pixel_z = 448, time = 0)
					animate(pixel_z = 0, time = 10)

					p.Move(t)

					p.nomove = 2
					sleep(10)
					p.nomove = 0

					p.HP = 0
					p.Death_Check(p)

				return 0
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
		post_init  = 1

		var/hole = 0

		Enter(atom/movable/O, atom/oldloc)

			if(hole && (O.icon_state == "Scurries" || findtext(O.icon_state, "snake"))) return 1
			.=..()

		MapInit()
			set waitfor = 0
			sleep(0)
			if(icon_state == "roof-15")

				var/n = 15 - autojoin("name", "roofb")

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
		appearance_flags = RESET_COLOR|RESET_ALPHA|PIXEL_SCALE
		post_init = 1

		MapInit()
			if(!post_init || !loc) return
			if(density)
				loc.density = 1
			if(opacity)
				loc.opacity = 1

			loc.overlays += src
			loc = null

		walltorch
			icon       = 'turf.dmi'
			icon_state = "walltorch"

		Pink_Flowers
			icon       = 'Plants.dmi'
			icon_state = "Pink Flowers"
			density    = 1

		Blue_Flowers
			icon       = 'Plants.dmi'
			icon_state = "Blue Flowers"
			density    = 1

		jailbar
			icon       = 'Jail.dmi'
			icon_state = "1"
			layer      = 5

			MapInit()

				icon_state = "[rand(1,6)]"

				..()

		jailtip
			icon       = 'Jail.dmi'
			icon_state = "tip"
			layer      = 5

		tabletop
			icon       = 'turf.dmi'
			icon_state = "t1"
			density    = 1
			layer      = 2
		tableleft
			icon       = 'turf.dmi'
			icon_state = "t2"
			density    = 1
			layer      = 2
		tablemiddle2
			icon       = 'turf.dmi'
			icon_state = "mid2"
			density    = 1
			layer      = 2
		tablemiddle
			icon       = 'turf.dmi'
			icon_state = "middle"
			density    = 1
			layer      = 2
		tablecornerL
			icon       = 'turf.dmi'
			icon_state = "t2"
			density    = 1
			layer      = 2
		tablecornerR
			icon       = 'turf.dmi'
			icon_state = "t3"
			density    = 1
			layer      = 2
		tableright
			icon       = 'turf.dmi'
			icon_state = "bottomright"
			density    = 1
			layer      = 2
		tableleft
			icon       = 'turf.dmi'
			icon_state = "bottom1"
			density    = 1
			layer      = 2
		tablebottom
			icon       = 'turf.dmi'
			icon_state = "bottom"
			density    = 1
			layer      = 2
		tablemid3
			icon       = 'turf.dmi'
			icon_state = "mid3"
			density    = 1
			layer      = 2
		art
			icon    = 'Decoration.dmi'
			density = 1

			Art_Tree
				icon_state = "tree"
				pixel_y = -16
			Art_Female
				icon_state = "royal"
				pixel_y = -16
			Art_Male
				icon_state = "royal2"
				pixel_y = -16
			Art_White_Flower
				icon_state = "whiteflower"
				pixel_y = -16
			Art_Pink_Flower
				icon_state = "pinkflower"
				pixel_y = -16
			Art_Pink_Flower2
				icon_state = "pinkflower2"
				pixel_y = -16
			Art_Small
				icon_state = "small"
				pixel_y = -16



			painting
				density = 0
				p1
					icon_state = "big tl"
				p2
					icon_state = "big tr"
				p3
					icon_state = "big bl"
				p4
					icon_state = "big br"

		tree
			name       = "Tree"
			#if !WINTER
			icon       = 'BigTree.dmi'
			icon_state = "stump"
			#endif
			density    = 1
			pixel_x    = -64

			MapInit()
				new /obj/static_obj/tree_top (locate(x, y+1, z))

				#if !WINTER

				if(prob(60))
					var/r = rand(160, 255)
					var/g = rand(82, r)
					var/b = rand(45, g)
					color = rgb(r, g, b)

				#endif

				..()


		tree_top
			name       = "Tree"
			icon       = 'BigTree.dmi'
			#if WINTER
			icon_state = "stump1_winter"
			#elif AUTUMN
			icon_state = "top_autumn"
			#else
			icon_state = "top"
			#endif
			density = 1
			pixel_x = -64
			pixel_y = -32
			layer   = 5

			MapInit()
				#if WINTER

				if(prob(70)) color = rgb(170, rand(170, 240), 170)

				var/r = rand(1,3)
				icon_state = "stump[r]_winter"

				if(prob(75))
					var/image/i = new('BigTree.dmi', "snow[r]")
					i.appearance_flags = RESET_COLOR
					overlays += i

				#else

				if(prob(80)) color = rgb(rand(150, 220), rand(100, 150), 0)

				if(prob(45))
					pixel_y -= 4
					var/matrix/m = matrix()
					m.Scale(rand(7,11)/10,1)
					transform = m

				#endif

				..()


		Hogwarts_Stairs
			icon       = 'General.dmi'
			icon_state = "Stairs"

		lineR
			icon       = 'table house lines.dmi'
			icon_state = "r"
		lineS
			icon       = 'table house lines.dmi'
			icon_state = "s"
		lineG
			icon       = 'table house lines.dmi'
			icon_state = "g"
		lineH
			icon	   = 'table house lines.dmi'
			icon_state = "h"
		Armor_Head
			icon       = 'statues.dmi'
			icon_state = "head"
			layer      = MOB_LAYER + 1
		gargoylerighttop
			icon       = 'statues.dmi'
			icon_state = "top3"
			layer      = MOB_LAYER + 1
		gargoylelefttop
			icon       = 'statues.dmi'
			icon_state = "top2"
			layer      = MOB_LAYER + 1
		gargoylerightbottom
			icon       = 'statues.dmi'
			icon_state = "bottom3"
			density    = 1
		gargoyleleftbottom
			icon       = 'statues.dmi'
			icon_state = "bottom2"
			density    = 1
		Armor
			icon       = 'statues_64x64.dmi'
			icon_state = "armor"
			density    = 1
			layer      = MOB_LAYER + 1
		Gargoyleleft
			icon       = 'statues_64x64.dmi'
			icon_state = "grag left"
			density    = 1
			layer      = MOB_LAYER + 1
		Gargoyleright
			icon       = 'statues_64x64.dmi'
			icon_state = "grag right"
			density    = 1
			layer      = MOB_LAYER + 1
		Angel
			icon       = 'statues_64x64.dmi'
			icon_state = "angel"
			density    = 1
			layer      = MOB_LAYER + 1
		Columb
			icon       = 'statues_64x64.dmi'
			icon_state = "columb"
			density    = 1
			layer      = MOB_LAYER + 1
		NeptuneStatue
			icon       = 'statues_64x64.dmi'
			icon_state = "neptune"
			density    = 1
			layer      = MOB_LAYER + 1
		statuebody
			icon       = 'statues.dmi'
			icon_state = "stat"
			density    = 1
		statuehead
			icon       = 'statues.dmi'
			icon_state = "sh"
			layer      = MOB_LAYER + 1
		Grave
			icon       = 'statues.dmi'
			icon_state = "grave5"
		Grave_Rip
			icon       = 'statues.dmi'
			icon_state = "rip"
		Ghost_Top
			icon       = 'statues.dmi'
			icon_state = "stat1a"
			layer      = MOB_LAYER + 1
		Ghost_Bottom
			icon       ='statues.dmi'
			icon_state ="stat2a"
			layer      = MOB_LAYER + 1
		Ghost_Top2
			icon       = 'statues.dmi'
			icon_state = "stat1b"
			density    = 1
		Ghost_Bottom2
			icon       = 'statues.dmi'
			icon_state = "stat2b"
			density    = 1
		Torch_
			icon       = 'misc.dmi'
			icon_state = "torch"
		Angel_Bottom
			icon       = 'statues.dmi'
			icon_state = "bottom1"
			density    = 1
		Angel_Top
			icon       = 'statues.dmi'
			icon_state = "top1"
			layer      = MOB_LAYER + 1
		Armor_Feet
			icon       = 'statues.dmi'
			icon_state = "feet"
			density    = 1
		Fountain_
			icon       = 'statues.dmi'
			icon_state = "foun1"
			density    = 1
		Fountain__
			icon       = 'statues.dmi'
			icon_state = "foun2"
			density    = 1
		Fountain___
			icon       = 'statues.dmi'
			icon_state = "foun3"
			density    = 1
		Fountain____
			icon       = 'statues.dmi'
			icon_state = "foun4"
			density    = 1
		Wand_Shelf
			icon       = 'Desk.dmi'
			icon_state = "3"
			density    = 1
		Dual_Swords
			icon       = 'wallobjs.dmi'
			icon_state = "sword"
			density    = 1
		Fireplace
			icon       = 'misc.dmi'
			icon_state = "fireplace"
			density    = 1
		gryffindor
			icon       = 'shields.dmi'
			icon_state = "gryffindor"
			density    = 1
		slytherin
			icon       = 'shields.dmi'
			icon_state = "slytherin"
			density    = 1
		hufflepuff
			icon       = 'shields.dmi'
			icon_state = "hufflepuff"
			density    = 1
		ravenclaw
			icon       = 'shields.dmi'
			icon_state = "ravenclaw"
			density    = 1
		gryffindorbanner
			icon       = 'shields.dmi'
			icon_state = "gryffindorbanner"
			density    = 1
		slytherinbanner
			icon       = 'shields.dmi'
			icon_state = "slytherinbanner"
			density    = 1
		hufflepuffbanner
			icon       = 'shields.dmi'
			icon_state = "hufflepuffbanner"
			density    = 1
		ravenclawbanner
			icon       = 'shields.dmi'
			icon_state = "ravenclawbanner"
			density    = 1
		hogwartshield
			icon       = 'shields.dmi'
			icon_state = "hogwartsshield"
			density    = 1
		hogwartbanner
			icon       = 'shields.dmi'
			icon_state = "hogwartsbanner"
			density    = 1
		fence
			icon       = 'turf.dmi'
			icon_state = "fence"
			density    = 1
			pixel_y    = 16
		downfence
			icon       = 'turf.dmi'
			icon_state = "fence side"
			density    = 1
		halffence
			icon       = 'turf.dmi'
			icon_state = "fence"
			layer      = 5
			pixel_y    = -2
		curtains
			icon       = 'turf.dmi'
			layer      = 5
			c1
				icon_state = "c1"
			c2
				icon_state = "c2"
			c3
				icon_state = "c3"
			c4
				icon_state = "c4"
		Neptune
			icon       = 'statues.dmi'
			icon_state = "top6"
			density    = 1
		NeptuneBottom
			icon       = 'statues.dmi'
			icon_state = "bottom6"
			density    = 1
		Clock
			icon       = 'General.dmi'
			icon_state = "tile79"
			density    = 1
		Golden_Candles
			icon       = 'Decoration.dmi'
			icon_state = "gcandle"
			pixel_y    = -16
		plate
			icon       ='turf.dmi'
			icon_state="plate"
		Book_Shelf
			icon       ='Desk.dmi'
			icon_state = "1"
			density    = 1
		Book_Shelf1
			icon       ='Desk.dmi'
			icon_state = "2"
			density    = 1
		Reserved
			icon       = 'misc.dmi'
			icon_state = "reserved"
			density    = 1
		Exit
			icon       = 'misc.dmi'
			icon_state = "exit"
			density    = 1
		Blackboard_
			icon       = 'bb.dmi'
			layer = 4
		Barrels
			icon       = 'turf.dmi'
			icon_state = "barrels"
			density    = 1
		sink
			icon       = 'sink.dmi'
			density    = 1
		Magic_Sphere
			icon       ='misc.dmi'
			icon_state = "black"
			density    = 1
		WTable
			icon       = 'stage.dmi'
			icon_state = "w"
			density    = 1
		Broom3
			icon       = 'nimbus_2000_broom.dmi'
			icon_state = "item"
			icon_state = "item"
		Triple_Candle
			icon       = 'General.dmi'
			icon_state = "tile80"
			density    = 1
obj
	snowman
		icon = 'snowman.dmi'
		name = "Snow Man"
	Desk
		icon       = 'desk.dmi'
		icon_state = "S1"
		density    = 1
		rubbleable = 1
	WTable
		icon       = 'stage.dmi'
		icon_state = "w"
		density    = 1
		layer      = 2
		rubbleable = 1

obj
	fadeIn
		alpha = 0

		flame
			icon='attacks.dmi'
			icon_state="fireball"
			layer = 6

			var/tmp/obj/light/light

			Dispose()
				set waitfor = 0

				var/t = rand(5, 15)
				animate(src, alpha = 0, time = t)
				animate(light, transform = matrix() * 0.1, time = t)

				sleep(t + 1)

				loc       = null
				light.loc = null
				light     = null

			New()
				set waitfor = 0
				..()

				light = new (loc)
				animate(light, transform = matrix() * 1.3, time = 10, loop = -1)
				animate(       transform = matrix() * 1.2, time = 10)

		New()
			set waitfor = 0
			..()
			animate(src, alpha = 255, time = 30)

	fadeOut
		layer = 4

		water
			icon='Water.dmi'
			icon_state="water"
			name = "water"
		ice
			icon='Water.dmi'
			icon_state="ice"
			name = "ice"

		New()
			set waitfor = 0
			..()
			animate(src, alpha = 0, time = 5)
			sleep(6)
			loc = null

obj
	Torch_
		icon       = 'misc.dmi'
		icon_state = "torch"

		Torch
			icon_state = "torch_off"
			density = 1

			var
				dest
				tmp/obj/light/light

			New()
				set waitfor = 0
				..()
				sleep(1)
				if(dest)
					var/obj/Hogwarts_Door/d = locate(dest)
					if(d) d.lightLock++

			proc/lit()
				set waitfor = 0

				icon_state = "torch"

				var/obj/Hogwarts_Door/d
				if(dest)
					d = locate(dest)
					if(d.lightLock > 0)
						d.lightLock--
						if(d.lightLock == 0)
							d.lightOpen()

					var/area/a = loc.loc
					if(a.planeColor)
						light = new (loc)
						animate(light, transform = matrix() * 1.3, time = 10, loop = -1)
						animate(       transform = matrix() * 1.2, time = 10)

				sleep(300)
				icon_state = "torch_off"

				if(d)
					d.lightLock++

					if(light)
						var/t = rand(5, 15)
						animate(light, transform = matrix() * 0.1, time = t)
						sleep(t + 1)
						light.loc = null
						light = null


	Trashcan
		icon       = 'Trash.dmi'
		icon_state = "Lid On"
		density    = 1

		mouse_over_pointer = MOUSE_HAND_POINTER

		MouseEntered(location,control,params)
			Highlight(usr, "#00a5ff")

		MouseExited(location,control,params)
			var/mob/Player/p = usr
			if(p.highlight)
				p.client.images -= p.highlight
				p.highlight = null

		var/tmp
			list/cleaning
			timer = 0

		post_init = 1
		MapInit()
			verbs -= /obj/Trashcan/verb/Take_Out
			if(prob(45))
				icon_state = "Lid Off"

			pixel_x = rand(-4,4)
			pixel_y = rand(-4,4)

		Click()
			if(usr in oview(1, src))
				EmptyTrash()

		proc/EmptyTrash()
			set waitfor = 0

			var/start = 0
			if(!cleaning)
				cleaning = list()
				start = 1

			var/count = 0
			for(var/obj/items/i in oview(1, src))
				i.loc = null
				cleaning += i

				count++

			if(count)

				timer = 30

				usr << infomsg("You put [count] items in the bin.")

				if(start)
					verbs += /obj/Trashcan/verb/Take_Out

					while(timer-- > 0)
						sleep(10)

					verbs -= /obj/Trashcan/verb/Take_Out
					cleaning = null
			else
				usr << infomsg("Drop items and click to throw them in the trash.")

		verb/Take_Out()
			set src in oview(1)

			for(var/obj/items/i in cleaning)
				cleaning -= i
				i.loc = usr.loc
			verbs -= /obj/Trashcan/verb/Take_Out
