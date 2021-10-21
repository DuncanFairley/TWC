obj
	Signs
		mouse_over_pointer = MOUSE_HAND_POINTER
		icon='statues.dmi'
		icon_state="sign"
		density=1

		verb
			read_sign()
				set src in oview(10)
				set name="Read"
				if(desc)
					usr << desc
				else
					usr << "<span style=\"color:red;\"><b>[name]</b></span>"

		Click()
			..()
			if(src in oview(10))
				read_sign()


		Diagon_Bank
			desc = "\n<span style=\"color:red;\"><b>Gringott's Wizard's Bank.</span><font color=blue><br>Main Branch - Diagon Alley.</b>"


		Museum
			desc = "<b>This is the Wizard Chronicles Museum."


		sign2
			icon_state = "sign3"

		custom
			density = 0
			pixel_y = 32

			name = "Right click -> write sign"

			verb
				write_sign(var/t as text)
					set src in oview(10)
					if(!t) return

					name = t

					verbs -= new/obj/Signs/custom/verb/write_sign()

			New()
				set waitfor = 0
				..()
				sleep(1)
				if(name != "Right click -> write sign")
					verbs -= new/obj/Signs/custom/verb/write_sign()