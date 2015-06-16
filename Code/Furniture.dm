/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
obj/Turntable
	icon='dj.dmi'
	pixel_y=-15
	layer=99
	Click()
		usr.dir = SOUTH

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

turf/gender_easter_egg
	var/tmp
		turf/gender_easter_egg/related
		obj/WTable/table

	New()
		..()
		spawn(1)
			related = locate() in (block(locate(x - 2, y, z),locate(x + 2, y, z)) - src)
			table   = locate() in oview(1, src)

	proc/trigger()
		if(!table || !related) return

		var/g1 = 0
		var/g2 = 0

		for(var/mob/Player/p in src)
			if(p.gender == "male")        g1 |= 1
			else if(p.gender == "female") g1 |= 2
			if(g1 == 3) break

		for(var/mob/Player/p in related)
			if(p.gender == "male")        g2 |= 1
			else if(p.gender == "female") g2 |= 2
			if(g2 == 3) break

		if(g1 != 0 && g1 == g2)
			animate(table, color = "#fff", time = 1, loop = -1)
			var/list/colors = list("#FF0000", "#FF7F00", "#FFFF00", "#00FF00", "#0000FF", "#4B0082", "#8B00FF")
			while(colors.len)
				var/c = pick(colors)
				colors -= c
				animate(color = c, time = 5)

		else
			animate(table, color = null, time = 10)

	Entered(atom/movable/Obj,atom/OldLoc)
		..()
		if(isplayer(Obj) && (Obj.gender == "male" || Obj.gender == "female"))
			trigger()

	Exited(atom/movable/Obj,atom/OldLoc)
		..()
		if(isplayer(Obj) && (Obj.gender == "male" || Obj.gender == "female"))
			trigger()

obj/Ani/I
	icon='ian.dmi'
	icon_state="i"
	accioable=0

obj/Ani/A
	icon='ian.dmi'
	icon_state="a"
	accioable=0

obj/Ani/N
	icon='ian.dmi'
	icon_state="n"
	accioable=0

obj/Ani/T
	icon='ian.dmi'
	icon_state="t"
	accioable=0

obj/Ani/M
	icon='ian.dmi'
	icon_state="m"
	accioable=0

obj/Ani/O
	icon='ian.dmi'
	icon_state="o"
	accioable=0

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
	accioable=0
	wlable=0
	density=1
	dontsave=1

obj/Stable_
	icon='General.dmi'
	icon_state="tile74"
	accioable=0
	wlable=0
	density=1
	dontsave=1

obj/Stable__
	icon='General.dmi'
	icon_state="tile75"
	accioable=0
	wlable=0
	density=1
	dontsave=1

obj/Triple_Candle
	icon='General.dmi'
	icon_state="tile80"
	accioable=0
	wlable=0
	density=1
	luminosity = 7
	dontsave=1

obj/Couch
	icon='General.dmi'
	icon_state="tile83"
	accioable=0
	wlable=0
	dontsave=1

obj/Couch2
	icon='General.dmi'
	icon_state="tile84"
	accioable=0
	wlable=0
	dontsave=1

obj/housecouch
	name = "Couch"
	dontsave=1
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
	accioable=0
	wlable=0
	density=1
	dontsave=1

obj/Quidditch_Sign
	icon='quidditch.png'
	pixel_x = -10
	pixel_y = -5

obj/Neptune
	icon='statues.dmi'
	icon_state="top6"
	accioable=0
	wlable=0
	density=1
	dontsave=1

obj/NeptuneBottom
	icon='statues.dmi'
	icon_state="bottom6"
	accioable=0
	wlable=0
	density=1
	dontsave=1

obj/Column
	icon='General.dmi'
	icon_state="tile93"
	accioable=0
	wlable=0
	density=1
	dontsave=1

obj/Columb
	icon='General.dmi'
	icon_state="tile94"
	accioable=0
	wlable=0
	layer = MOB_LAYER + 1
	density=0
	dontsave=1

obj/Endtable
	icon='General.dmi'
	icon_state="tile72"
	accioable=0
	wlable=0
	density=1
	dontsave=1

obj/Pink_Flowers
	icon='General.dmi'
	icon_state="tile114"
	accioable=0
	wlable=0
	density=1
	dontsave=1
