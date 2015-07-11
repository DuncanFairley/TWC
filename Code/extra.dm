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
	pumpkin
		icon='pumpkin.dmi'
		density=1
		accioable=0
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
	usr<<"Right click to bring up the menu."
mob/Click()
	if(!usr.ClickEdit)
		usr<<"Right click to bring up the menu."
	else
		..()
mob/Headmasters_Office
	invisibility=2

obj/Magic_Sphere
	icon='misc.dmi'
	icon_state="black"
	density=1

obj
	Trophy_Rack
		icon='trophy-rack.dmi'
		density=1
		verb
			Examine()
				usr << "This rack is to store the House Cup for the winning house!"

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
	stonefloor
		icon='Gener.dmi'
		icon_state="blackfloor"
		name="floor"
//all
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
