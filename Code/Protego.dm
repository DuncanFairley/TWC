/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/GM
	verb
		Delete(S as turf|obj|mob in view(17))
			set category = "Staff"
			if(clanrobed())return
			del S



obj/Shield
	icon='teleport2.dmi'
	icon_state = "shield"
	density = 1
	layer = 10
	dontsave=1
	wlable=0
	accioable=0


mob/var/shielded
mob/var/prevname = ""
mob/var/shieldamount