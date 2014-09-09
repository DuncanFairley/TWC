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
			Read_()

		verb
			Examine_Statue()

		Click()
			..()
			Examine_Statue()
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

	Signs/Tasuki
		icon='MaleRavenclaw.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("Tasuki, one of the best duelists in The Wizard Chronicle's history.")

	Signs/Demonic
		icon='MaleSlytherin.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("Demonic, one of the strongest characters and most advanced duelists in The Wizard's Chronicle's history.")


	Signs/Ice
		icon='MaleSlytherin.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("Ice Dragon, one of the most consistantly victorious and most humble in The Wizard's Chronicle's history.")


	Signs/Dion
		icon='MaleHufflepuff.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("Dion has created the following things for TWC. \n -Scarves\n-Auror Robes")

	Signs/Princess
		icon='FemaleGryffindor.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("Princess has created the following things for TWC. \n -Easter bunny")


	Signs/Lion
		icon='MaleGryffindor.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Lion, The Gryffindor who was the champion of the 2006 Halloween event.")

	Signs/Slyth
		icon='Slytherin.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of the classic Slytherin player icon.")

	Signs/Gryff
		icon='Gryffindor.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of the classic Gryffindor player icon.")

	Signs/Ravenclaw
		icon='Ravenclaw.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of the classic Ravenclaw player icon.")

	Signs/Huffle
		icon='Hufflepuff.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of the classic Hufflepuff player icon.")

	Signs/Rag
		icon='statues.dmi'
		icon_state = "blue"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Ragnarok. He will live on forever, as an example of how not to be.")


	Signs/Ander
		icon='statues.dmi'
		icon_state = "green"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Headmaster Ander.")

	Signs/Uchiha
		icon='statues.dmi'
		icon_state = "teal"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of a former Co-Headmaster Uchiha Itachi.")

	Signs/Firefly
		icon='statues.dmi'
		icon_state = "darkgreen"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of a former Co-Headmaster Firefly.")

	Signs/Atomic
		icon='statues.dmi'
		icon_state = "red"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of former Co-Headmaster Atomic.")

	Signs/Ian
		icon='statues.dmi'
		icon_state = "black"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Professor Ian, Transfiguration Professor.")

	Signs/Thasotus
		icon='MaleGryffindor.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Thasotus, one of the founding Aurors and exceptional TWC players. He was a great pleasure to have on The Wizard Chronicles, always being a positive influence. Unfortunately he was forced to leave because of his personal life. The Aurors will always remember his name, and what he did for the game. We all, as a community, await the day he will return.")

	Signs/LionAuror
		name="Lion"
		icon='MaleGryffindor.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Lion, one of the founding Aurors. He has left TWC to pursue further interests. We'll miss him until his return...")

	Signs/Dark
		icon='statues.dmi'
		icon_state = "red"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Professor Dark, Administrator and Charms Professor.")

	Signs/Linshon
		icon='misc.dmi'
		icon_state="yellow"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Former Headmaster Linshon.")


	Signs/Bustah
		icon='statues.dmi'
		icon_state = "black"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Professor BusTaH, Care of Magical Creatures Professor.")

	Signs/Neo
		icon='statues.dmi'
		icon_state = "black"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Professor Neo, Former Muggle Studies Professor.")

	Signs/Zero
		icon='statues.dmi'
		icon_state = "black"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Professor Neo, Former Muggle Studies Professor.")

	Signs/Charming
		icon='statues.dmi'
		icon_state = "black"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Professor Charming, Charms Professor.")

	Signs/Shirou
		icon='statues.dmi'
		icon_state = "lightblue"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Deputy Headmaster Shirou, former Headmaster.")

	Signs/Grahm
		icon='statues.dmi'
		icon_state = "black"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Professor Grahm, the former Care of Magical Creatures Professor.")

	Signs/Katsie
		icon='statues.dmi'
		icon_state = "black"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Professor Katsie, currently a Transfiguration Professor.")

	Signs/Amber
		icon='statues.dmi'
		icon_state = "black"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Professor Amber, a former Transfiguration Professor.")

	Signs/Sampola
		icon='statues.dmi'
		icon_state = "black"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Professor Sampola, currently a Care of Magical Creatures Professor.")

	Signs/Joe
		icon='statues.dmi'
		icon_state = "black"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Professor Joe, currently a Care of Magical Creatures Professor.")


	Signs/Jared
		icon='statues.dmi'
		icon_state = "black"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This a statue of Professor Jared, currently a Charms Professor.")

	Signs/Zaveltia
		icon='MaleGryffindor.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This is a statue of the former host, Zaveltia.")

	Signs/Deathflash
		icon='MaleSlytherin.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This is a statue of the current host, Deathflash.")

	Signs/GandleHost
		icon='MaleGryffindor.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This is a statue of the former host, Gandledorf Stormcrow.")

	Signs/ShirouHost
		icon='MaleRavenclaw.dmi'
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This is a statue of the former host, Shirou.")

	Signs/Gandle
		icon='statues.dmi'
		icon_state = "red"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This is a statue of Gandledorf Stormcrow, Former Devout Administrator.")

	Signs/Norn
		icon='statues.dmi'
		icon_state = "red"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		Examine_Statue()
			set src in oview(10)
			alert("This is a statue of Nornamort, Former Devout Administrator.")
