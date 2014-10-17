/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
obj
	Signs
		mouse_over_pointer = MOUSE_HAND_POINTER

		verb
			Read_()

		Click()
			..()
			if(src in oview(10))
				Read_()

obj
	Signs/Diagon_Bank
		icon='statues.dmi'
		icon_state="sign"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Read_()
			set src in oview(10)
			usr<<"\n<font color=red><b>Gringott's Wizard's Bank.</font><font color=blue><br>Main Branch - Diagon Alley.</b>"
	Signs/Santa
		icon='statues.dmi'
		icon_state="sign"
		name="Sign"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Read_()
			set src in oview(10)
			usr<<"<b>Until next year!"

	Signs/Owlery
		icon='statues.dmi'
		icon_state="sign"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Read_()
			set src in oview(10)
			alert("The Owlery")

	Signs/Museum
		icon='statues.dmi'
		icon_state="sign"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Read_()
			set src in oview(10)
			usr<<"<b>This is the Wizard Chronicles Museum."

	Signs/HolidayMuseum
		icon='statues.dmi'
		icon_state="sign"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Read_()
			set src in oview(10)
			usr<<"<b>This is the Holiday Event section of the Museum."

	Signs/Quidditch
		icon='statues.dmi'
		icon_state="sign"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Read_()
			set src in oview(10)
			usr<<"<b>Welcome to Shirou Stadium. Est. January 7th, 2007."

	Signs/HostsMuseum
		icon='statues.dmi'
		icon_state="sign"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Read_()
			set src in oview(10)
			usr<<"<b>This is the Hosts section of the Museum, where we give thanks to all of our devoted hosts for donating their computers to us! Thank you!!!"