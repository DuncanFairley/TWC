/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/GM/verb
	Change_Area()
		set hidden = 1
	// Daily Prophet verbs
	Your_Job()
		set hidden = 1
	Hire_Reporter()
		set hidden = 1
	Fire_DPSM()
		set hidden = 1
	Hire_Editor()
		set hidden = 1
	New_Story()
		set hidden = 1
	Clear_Stories()
		set hidden = 1
	Draft()
		set hidden = 1
	Edit_DP()
		set hidden = 1


mob/Quidditch/verb
	Add_Spectator()
		set hidden = 1
	Remove_Spectator()
		set hidden = 1

mob/verb/Convert()
	set hidden = 1


obj/MonBookMon
	New()
		..()
		spawn(1)
			new /obj/items/MonBookMon (loc)
			loc = null
obj/COMCText
	New()
		..()
		spawn(1)
			new /obj/items/COMCText (loc)
			loc = null