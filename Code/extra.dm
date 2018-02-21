/*
 * Copyright � 2014 Duncan Fairley
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

mob/GM/verb
	Award_House_Cup()
		var/rspnse = alert("This verb, when activated on a house, will make that house gain a 25% increase to gold + EXP gained from monster kills. Are you sure you wish to proceed?",,"Yes","Cancel")
		if(rspnse == "Yes")
			switch(input("Which house do you want to apply the award to?") as null|anything in list("Gryffindor","Slytherin","Ravenclaw","Hufflepuff"))
				if("Gryffindor")
					worldData.housecupwinner = "Gryffindor"
				if("Slytherin")
					worldData.housecupwinner = "Slytherin"
				if("Ravenclaw")
					worldData.housecupwinner = "Ravenclaw"
				if("Hufflepuff")
					worldData.housecupwinner = "Hufflepuff"

mob/Headmasters_Office
	invisibility=2

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