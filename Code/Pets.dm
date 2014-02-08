/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob
	verb
		Follow(mob/M in view()&Players)
			if(usr.client.eye!=usr)
				src<<"You cannot follow someone whilst using telendevour."
				return
			if(M.monster==1)
				src<<"You cannot follow a monster."
				return
			if(src.followplayer==0)
				src.followplayer=1
				if(src.followplayer==1)
					M<<"[src] is now following you."
					src<<"You begin following [M]."
					while(src.followplayer==1)
						step_to(src,M,2)
						sleep(1)
						if(!M)src.followplayer = 0
						if(src.z!=M.z)
							src.followplayer=0
					return
			if(src.followplayer==1)
				src.followplayer=0
				hearers()<<"[src] stops following."
				return