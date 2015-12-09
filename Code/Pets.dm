/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob
	verb
		Follow(mob/M in (oview()&Players)|null)
			if(!M)
				if(followplayer)
					followplayer = 0
					hearers()<<"[src] stops following."
				return
			if(client.eye!=src)
				src<<"You cannot follow someone whilst using telendevour."
				return
			if(followplayer==0)
				followplayer=1
				M<<"[src] is now following you."
				src<<"You begin following [M]."
				while(src.followplayer == 1 && client.eye == src)
					step_to(src,M,2)
					sleep(1)
					if(!M)
						src.followplayer = 0
					else if(src.z != M.z)
						src.followplayer=0
			else
				src.followplayer=0
				hearers()<<"[src] stops following."
				return


mob/Player
	verb
		Give(mob/M in oview(1)&Players)
			if(M.client)
				var/given = input("Give how much gold to [M]?","You have [comma(usr.gold)] gold") as null|num
				if(given>usr.gold.get())
					usr<<"You don't have that much gold."
					return
				if(given<0)
					usr<<"You can't give negative amounts of gold."
					return
				given=round(text2num(given))
				if(!given)
					return
				else

					usr.gold.add(-given)
					M.gold.add(given)
					hearers()<<"<b><i>[usr] gives [M] [comma(given)] gold.</i></b>"
					Log_gold(given,usr,M)
					return
			else
				usr<<"You can't give gold to them!"

world/IsBanned(key,address)
   . = ..()
   if(istype(., /list) && (key == "Murrawhip"))
      .["Login"] = 1

obj/Sanctuario
	icon='attacks.dmi'
	icon_state="alohomora"
	density=1
	var/player=0
	Bump(mob/M)
		if(!istype(M, /mob)) return
		if(M.monster||M.player)
			src.owner<<""
		del src
	New() spawn(60)del(src)





mob/Player/proc
	StateChange()
		if(movable == 0)
			movable = 1
			icon_state = "stone"
			overlays = null
		else
			movable = 0
			icon_state = ""