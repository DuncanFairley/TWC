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