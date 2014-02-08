/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob
	verb
		Save() // name the verb
			set category = "Commands"
			set hidden = 1
			set name = ".Save"
			src<<"Saving [name]..." // the the player its saving
			client.base_SaveMob()
			sql_update_ckey_in_table(src)
			if(src.xp4referer)
				sql_upload_refererxp(src.ckey,src.refererckey,src.xp4referer)
				src.xp4referer = 0
			//sleep(2) // sleep 1 second before displaying Saved
			src<<"Saved [src]."

obj
	egg1
		icon='Eggs.dmi'
		icon_state="1"
		density=1
		accioable=0

obj
	egg2
		icon='Eggs.dmi'
		icon_state="2"
		density=1
		accioable=0
obj
	egg3
		icon='Eggs.dmi'
		icon_state="3"
		density=1
		accioable=0
obj
	egg4
		icon='Eggs.dmi'
		icon_state="4"
		density=1
		accioable=0
obj
	egg5
		icon='Eggs.dmi'
		icon_state="5"
		density=1
		accioable=0
obj
	egg6
		icon='Eggs.dmi'
		icon_state="6"
		density=1
		accioable=0
obj
	egg7
		icon='Eggs.dmi'
		icon_state="7"
		density=1
		accioable=0
obj
	egg8
		icon='Eggs.dmi'
		icon_state="8"
		density=1
		accioable=0
obj
	egg9
		icon='Eggs.dmi'
		icon_state="9"
		density=1
		accioable=0
obj
	egg10
		icon='Eggs.dmi'
		icon_state="10"
		density=1
		accioable=0
obj
	egg11
		icon='Eggs.dmi'
		icon_state="11"
		density=1
		accioable=0
obj
	egg12
		icon='Eggs.dmi'
		icon_state="12"
		density=1
		accioable=0
obj
	egg13
		icon='Eggs.dmi'
		icon_state="13"
		density=1
		accioable=0
obj
	egg14
		icon='Eggs.dmi'
		icon_state="14"
		density=1
		accioable=0
obj
	egg15
		icon='Eggs.dmi'
		icon_state="15"
		density=1
		accioable=0
obj
	egg16
		icon='Eggs.dmi'
		icon_state="16"
		density=1
		accioable=0

obj
	sandwind
		layer = 8
		name = ""
		icon = 'misc.dmi'
		icon_state = "sandstorm"

turf

	pumpkin
		icon = 'pumpkin.dmi'

	pyramidmid
		layer = 6
		name = "pyramid"
		icon = 'pyramid.dmi'
		icon_state = "mid"

	pyramidleft
		layer = 6
		name = "pyramid"
		icon = 'pyramid.dmi'
		icon_state = "left"

	pyramidright
		layer = 6
		name = "pyramid"
		icon = 'pyramid.dmi'
		icon_state = "right"

	p_blackline
		layer = 6
		name = "pyramid"
		icon = 'pyramid.dmi'
		icon_state = "line"

	p_blacklinedown
		layer = 6
		name = "pyramid"
		icon = 'pyramid.dmi'
		icon_state = "down"

mob
	var
		ratpoints

var/housecupwinner = ""

mob/GM/verb
	Award_House_Cup()
		var/rspnse = alert("This verb, when activated on a house, will make that house gain a 25% increase to gold + EXP gained from monster kills. Are you sure you wish to proceed?",,"Yes","Cancel")
		if(rspnse == "Yes")
			switch(input("Which house do you want to apply the award to?") as null|anything in list("Gryffindor","Slytherin","Ravenclaw","Hufflepuff"))
				if("Gryffindor")
					housecupwinner = "Gryffindor"
				if("Slytherin")
					housecupwinner = "Slytherin"
				if("Ravenclaw")
					housecupwinner = "Ravenclaw"
				if("Hufflepuff")
					housecupwinner = "Hufflepuff"


mob/DblClick()
	usr<<"Right Click To bring Up the menu"
mob/Click()
	if(!usr.ClickEdit)
		usr<<"Right click to bring up the menu"
	else
		..()

mob/Headmasters_Office
	invisibility=2
obj/Magic_Sphere
	icon='misc.dmi'
	icon_state="black"
	density=1
obj/Beer
	icon='misc.dmi'
	icon_state="beer"
	name = "beer"
	verb
		Drink()
			set src in oview(1)
			hearers()<<"[usr] sips \his beer."
			sleep(1200)
			del src
			usr<<"Your beer dissolves."
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his beer."
	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
obj/Beer2
	icon='misc.dmi'
	icon_state="beer"
	accioable=0

obj/Tea
	icon='misc.dmi'
	icon_state="tea"
	name = "tea"
	verb
		Drink()
			set src in view(1)
			hearers()<<"[usr] sips \his tea."
			sleep(1200)
			if(src)usr<<"Your Tea dissolves."
			del src

	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his tea."
	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
obj/Blueberry_Pie
	icon='misc.dmi'
	icon_state="bbpie"
	name = "blueberry pie"
	verb
		Eat()
			set src in view(1)
			hearers()<<"[usr] eats \the [src]."
			usr.HP+=5
			if(usr.HP > (usr.MHP+usr.extraMHP)) usr.HP = usr.MHP+usr.extraMHP
			del src
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."
	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
obj/Apple_Pie
	icon='misc.dmi'
	icon_state="apie"
	name = "apple pie"
	verb
		Eat()
			set src in view(1)
			hearers()<<"[usr] eats \the [src]."
			usr.HP+=5
			if(usr.HP > (usr.MHP+usr.extraMHP)) usr.HP = usr.MHP+usr.extraMHP
			del src
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."
	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
obj/Cocoa_Nut_Cream_Pie
	icon='misc.dmi'
	icon_state="cccpie"
	name = "cocoa nut cream pie"
	verb
		Eat()
			set src in view(1)
			hearers()<<"[usr] eats \the [src]."
			usr.HP+=5
			if(usr.HP > (usr.MHP+usr.extraMHP)) usr.HP = usr.MHP+usr.extraMHP
			del src
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."
	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
obj/Fire_Orb
	icon='items.dmi'
	icon_state="fireorb"
	value=0
	verb

	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."



obj/Initial
	icon='misc.dmi'
	wlable=0

obj/Sold
	icon='items.dmi'
	icon_state="windorb"
	dontsave=0
	value=0

obj
	Trophy_Rack
		icon='trophy-rack.dmi'
		density=1
		verb
			Examine()
				usr << "This rack is to store the House Cup for the winning house!"

obj/Shadow_Orb
	icon='items.dmi'
	icon_state="shadoworb"
	accioable=1
	value=0
	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."

obj/pokeby
	icon='pokeby.dmi'
	verb
		Examine()
			set src in view(3)
			usr << "Aww, isn't it cute?"
	verb
		Take()
			set src in oview(1)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."
obj/Chest2
	name="Chest"
	icon='turf.dmi'
	icon_state="chest2"
	density=1
	value=0
	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			alert("You open the chest")
			sleep(10)
			del src
obj/Chest
	name="Chest"
	icon='turf.dmi'
	icon_state="chest"
	density=1
	value=0
	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			alert("You open the chest")
			del src

turf
	sand2
		icon='Turfs.dmi'
		icon_state="desert"
		name="sand"
	stonefloor
		icon='Gener.dmi'
		icon_state="blackfloor"
		name="floor"
//all
obj/arrowup
	icon='items.dmi'
	icon_state="arrowup"
obj/arrowdown
	icon='items.dmi'
	icon_state="arrowdown"
obj/arrowleft
	icon='items.dmi'
	icon_state="arrowleft"
obj/arrowright
	icon='items.dmi'
	icon_state="arrowright"
obj/ball
	icon='pointer.dmi'
obj/wholist
	icon='wholist.dmi'
	Gryffindor
		icon_state="g"
	Ravenclaw
		icon_state="r"
	Hufflepuff
		icon_state="h"
	Slytherin
		icon_state="s"
	Ministry
		icon_state="m"
	Empty
		icon_state="e"
var/list/wholist = list("Gryffindor" = new/obj/wholist/Gryffindor,
						"Ravenclaw" = new/obj/wholist/Ravenclaw,
						"Slytherin" = new/obj/wholist/Slytherin,
						"Hufflepuff" = new/obj/wholist/Hufflepuff,
						"Ministry" = new/obj/wholist/Ministry,
						"Empty" = new/obj/wholist/Empty)

obj/HM_Class
	icon='statues.dmi'
	icon_state="sign"
	density=1
	wlable=0
	verb
		Read_()
			set src in oview(1)
			usr<<"<b> This is the Headmasters Classroom. Classes held by the headmaster covers all subjects."

obj/Signage
	icon='statues.dmi'
	icon_state="sign"
	density=1
	dontsave=1
	wlable=0
	verb
		Read_()
			set src in oview(1)
			usr<< src.desc

obj/sign1
	icon='statues.dmi'
	icon_state="sign"
	dontsave=1
	density=1
	verb
		Read_sign()
			set src in oview(10)
			set name="Read"
			if(desc)
				usr<<desc
			else
				usr << "<font color=red><b>[name]</b></font>"
obj/sign2
	icon='statues.dmi'
	icon_state="sign3"
	dontsave=1
	density=1
	verb
		Read_sign()
			set src in oview(10)
			set name="Read"
			if(desc)
				usr<<desc
			else
				usr << "<font color=red><b>[name]</b></font>"

area/Block
area/Block
	density=1

obj
	GryffBox
		name="Quidditch Ball Box"
		icon='ballbox.dmi'
		icon_state="gryff"
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] picks up [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
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

obj
	SlythBox
		name="Quidditch Ball Box"
		icon='ballbox.dmi'
		icon_state="slyth"
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] picks up [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
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

obj
	HuffleBox
		name="Quidditch Ball Box"
		icon='ballbox.dmi'
		icon_state="huffle"
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] picks up [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
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

obj
	RavenBox
		name="Quidditch Ball Box"
		icon='ballbox.dmi'
		icon_state="raven"
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] picks up [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
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

obj
	GameBox
		name="Quidditch Ball Box"
		icon='ballbox.dmi'
		icon_state="game"
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] picks up [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
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
