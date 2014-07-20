/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/var/delinterwand
mob/var/easterwand

obj/Broom3
	icon='icons.dmi'
	icon_state="nimbus"
obj/DeskFilled
	icon='desk.dmi'
	icon_state="TD2"
	dontsave=1
	density=1
	verb
		Examine()
			set src in oview(3)
			usr << "An ordinary desk filled with various papers and such."
obj/DeskEmpty
	icon='desk.dmi'
	icon_state="S1"
	dontsave=1
	verb
		Examine()
			set src in oview(3)
			usr << "An ordinary wooden desk."
obj/Desk3
	icon='desk.dmi'
	icon_state="S3"
	density = 1
	dontsave=1
obj/Chair
	icon='desk.dmi'
	icon_state="Chair"
	dontsave=1
	accioable=1
	wlable=1
obj/Lantern
	icon='Decoration.dmi'
	icon_state="lantern"
	dontsave=1
	wlable=0
	luminosity=4
	density=1
obj/lineR
	icon='table house lines.dmi'
	icon_state="r"
	dontsave=1
	wlable=0
	luminosity=1
	density=0
obj/lineS
	icon='table house lines.dmi'
	icon_state="s"
	dontsave=1
	wlable=0
	luminosity=1
	density=0
obj/lineG
	icon='table house lines.dmi'
	icon_state="g"
	dontsave=1
	wlable=0
	luminosity=1
	density=0
obj/lineH
	icon='table house lines.dmi'
	icon_state="h"
	dontsave=1
	wlable=0
	luminosity=1
	density=0
