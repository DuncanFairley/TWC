/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

obj/museum

	density = 1
	var/robes

	icon = 'statues.dmi'

	New()
		..

		if(robes == "MaleStaff")
			icon = 'MaleStaff.dmi'
		if(robes == "FemaleStaff")
			icon = 'FemaleStaff.dmi'
		else
			icon_state = robes
	verb
		Examine()
			set src in oview(10)
			usr<<"This is [name]: [desc]"

	Murrawhip
		desc  = "Owner of TWC & Minister of Magic."
		robes = "MaleStaff"

	Ander
		desc  = "Former Headmaster of TWC,"
		robes = "green"

	Ragnarok
		desc = "Original owner of TWC."
		robes = "blue"

	Lucifer
		desc = "Creator of TWC radio. Former Co-Owner & Transfiguration Professor."
		robes = "MaleStaff"

	Linshon
		desc = "Former Headmaster of TWC."
		robes = "yellow"

	Shirou
		desc = "Former Headmaster of TWC & DADA Professor."
		robes = "lightblue"

	Kozu
		desc = "Former Headmaster of TWC."
		robes = "MaleStaff"

	Ash
		desc = "Former Headmaster of TWC,"
		robes = "MaleStaff"

	Rotem
		desc = "Not A Player. Former Headmistress, Deputy Headmistress, Administrator, DADA, COMC, Transfiguration and GCOM Professor"
		robes = "FemaleStaff"

	Tobias
		desc = "Former Headmaster of TWC."
		robes = "teal"

	Justin
		name = "Justin (Demonic)"
		desc = "Former Headmaster, Deputy Headmaster, Professor of every class at different points. Former Slytherin Prefect and Host."
		robes = "white"

	Sylar
		desc = "Headmaster of TWC. Former Deputy Headmaster, Administrator, Chat Moderator. Previous GCOM, DADA, and Charms Professor."
		robes = "orange"

	Chrissy
		desc = "Former Headmistress, Deputy Headmistress, Administrator, and Professor."
		robes = "pink"

	Firefly
		desc = "Former Deputy Headmaster of TWC."
		robes = "darkgreen"

	Uchiha
		desc = "Former Deputy Headmaster of TWC."
		robes = "cyan"

	Atomic
		desc = "Former Deputy Headmaster of TWC."
		robes = "white"

	Jared
		desc = "Former Deputy Headmaster of TWC."
		robes = "cyan"

	Spitfire
		desc = "Administrator & DADA Professor"
		robes = "MaleStaff"

	Nornamort
		desc = "Former Administrator."
		robes = "MaleStaff"

	Dark
		desc = "Former Administrator & DADA Professor."
		robes = "MaleStaff"

	Gandledorf
		desc = "Former Administrator."
		robes = "MaleStaff"

	Zane
		desc = "Former Administrator & Charms Professor."
		robes = "MaleStaff"

	Lord_Xioshen
		desc = "Former Administrator & DADA Professor."
		robes = "MaleStaff"

	SnipeDragon
		desc = "Former Administrator."
		robes = "MaleStaff"

	Zero
		desc = "Former DADA Professor."
		robes = "MaleStaff"

	Neo
		desc = "Former Muggle Studies Professor."
		robes = "MaleStaff"

	Grahm
		desc = "Former COMC Professor."
		robes = "MaleStaff"

	BusTaH
		desc = "Former COMC Professor."
		robes = "MaleStaff"

	Charming
		desc = "Former Charms Professor."
		robes = "MaleStaff"

	Katsie
		desc = "Former Transfiguration Professor."
		robes = "FemaleStaff"

	Sampola
		desc = "Former COMC Professor."
		robes = "FemaleStaff"

	Amber
		desc = "Former Transfiguration Professor & Hufflepuff Prefect."
		robes = "FemaleStaff"

	Ezekiel
		desc = "Former Charms Professor."
		robes = "MaleStaff"

	Sponge
		desc = "Former DADA Professor & Slytherin Prefect."
		robes = "MaleStaff"

	Lavender
		desc = "Former Transfiguration Professor."
		robes = "FemaleStaff"

	Odd_Future
		desc = "Former Transfiguration Professor."
		robes = "MaleStaff"

	Skystone
		desc = "Former COMC Professor."
		robes = "MaleStaff"

	Farrah
		desc = "Former Transfiguration Professor."
		robes = "FemaleStaff"

	Lewis
		desc = "Former COMC Professor & Gryffindor Prefect."
		robes = "MaleStaff"

	Seta
		desc = "Professor of Transfiguration and Charms & Slytherin Prefect."
		robes = "FemaleStaff"

	Lion
		desc = "Former DADA Professor & Dueling Instructor."
		robes = "MaleStaff"

	Julz
		desc = "Former Transfiguration Professor."
		robes = "FemaleStaff"

	Rose
		desc = "Former COMC Professor."
		robes = "FemaleStaff"

	Dscudiero
		desc = "Former COMC Professor."
		robes = "MaleStaff"

	El_Diablo
		desc = "Former DADA Professor."
		robes = "MaleStaff"

	Merlin
		desc = "Former Transfiguration Professor & Hufflepuff Prefect."
		robes = "MaleStaff"

	Xzero
		desc = "Former DADA Professor."
		robes = "MaleStaff"

	Roxas
		desc = "Former DADA Professor."
		robes = "MaleStaff"

	Julian_Boi
		desc = "Former DADA Professoro."
		robes = "MaleStaff"

	Max_Quickstaff
		desc = "Former Charms Professor."
		robes = "MaleStaff"

	Neveahlee
		desc = "Former Transfiguration Professor & Slytherin and Gryffindor Prefect."
		robes = "FemaleStaff"

	Severus
		desc = "Former Transfiguration Professor."
		robes = "MaleStaff"

	Sam_Rajax
		desc = "Former DADA Professor."
		robes = "MaleStaff"

	Deathflash
		desc = "Former Duel Instructor."
		robes = "MaleStaff"

	Ice_Dragon
		desc = "Former Duel Instructor."
		robes = "MaleStaff"

	Ben
		name = "Ben (Zachary Lyons/Link)"
		desc = "GCOM Professor. Former Charms, COMC, and Transfiguration Professor. Previous Duel Instructor & Ravenclaw Prefect."
		robes = "MaleStaff"

	Lady_Siren
		desc = "Former Charms Professor & Slytherin Prefect."
		robes = "FemaleStaff"

	Shade
		desc = "Former DADA Professor."
		robes = "MaleStaff"

	Avery
		desc = "Former DADA Professor."
		robes = "FemaleStaff"

	Malokh
		desc = "Former DADA Professor & Ravenclaw Prefect."
		robes = "MaleStaff"

	Mega_Joe
		desc = "Former DADA Professor."
		robes = "MaleStaff"

	Angela
		desc = "Former Charms Professor."
		robes = "FemaleStaff"

	Sirus
		desc = "Former DADA Professor."
		robes = "MaleStaff"

	Monte
		desc = "Former Charms Professor."
		robes = "MaleStaff"

	Zander
		desc = "Former Transfiguration Professor."
		robes = "MaleStaff"

	Andi
		desc = "Former COMC Professor."
		robes = "MaleStaff"

	Theodore_Richards
		desc = "Former DADA Professor."
		robes = "MaleStaff"

	Nick_A_Creed
		desc = "Former COMC Professor,"
		robes = "MaleStaff"

	Severus
		desc = "Former Transfiguration and DADA Professor."
		robes = "MaleStaff"

	Fire
		desc = "Former Duel Instructor."
		robes = "MaleStaff"

	Zach
		name = "Zach (Chaseio Blade)"
		desc = "COMC Professor, Former Off-Peak Professor."
		robes = "MaleStaff"

	Chris_Sparker
		desc = "Former Charms Professor."
		robes = "MaleStaff"