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
		desc  = "Past Headmaster of TWC,"
		robes = "green"

	Ragnarok
		desc = "Original owner of TWC."
		robes = "blue"

	Lucifer
		desc = "Creator of TWC radio. Past Co-Owner & Transfiguration Professor."
		robes = "MaleStaff"

	Linshon
		desc = "Past Headmaster of TWC."
		robes = "yellow"

	Shirou
		desc = "Past Headmaster of TWC & DADA Professor."
		robes = "lightblue"

	Kozu
		desc = "Past Headmaster of TWC."
		robes = "MaleStaff"

	Ash
		desc = "Past Headmaster of TWC,"
		robes = "MaleStaff"

	Rotem
		desc = "Event Coordinator. Past Headmistress, Deputy Headmistress, Administrator, DADA, COMC, Transfiguration and GCOM Professor"
		robes = "FemaleStaff"

	Tobias
		desc = "Past Headmaster of TWC."
		robes = "teal"

	Justin_aka_Demonic
		desc = "Past Headmaster, Deputy Headmaster, Professor of every class at different points. Past Slytherin Prefect and Host."
		robes = "white"

	Sylar
		desc = "Headmaster of TWC. Past Deputy Headmaster, Administrator, Chat Moderator. Previous GCOM, DADA, and Charms Professor."
		robes = "orange"

	Chrissy
		desc = "Past Headmistress, Deputy Headmistress, Administrator, and Professor."
		robes = "pink"

	Firefly
		desc = "Past Deputy Headmaster of TWC."
		robes = "darkgreen"

	Uchiha
		desc = "Past Deputy Headmaster of TWC."
		robes = "cyan"

	Atomic
		desc = "Past Deputy Headmaster of TWC."
		robes = "white"

	Jared
		desc = "Past Deputy Headmaster of TWC."
		robes = "cyan"

	Spitfire
		desc = "Administrator & DADA Professor"
		robes = "MaleStaff"

	Nornamort
		desc = "Past Administrator."
		robes = "MaleStaff"

	Dark
		desc = "Past Administrator & DADA Professor."
		robes = "MaleStaff"

	Gandledorf
		desc = "Past Administrator."
		robes = "MaleStaff"

	Zane
		desc = "Past Administrator & Charms Professor."
		robes = "MaleStaff"

	Lord_Xioshen
		desc = "Past Administrator & DADA Professor."
		robes = "MaleStaff"

	SnipeDragon
		desc = "Past Administrator."
		robes = "MaleStaff"

	Zero
		desc = "Past DADA Professor."
		robes = "MaleStaff"

	Neo
		desc = "Past Muggle Studies Professor."
		robes = "MaleStaff"

	Grahm
		desc = "Past COMC Professor."
		robes = "MaleStaff"

	BusTaH
		desc = "Past COMC Professor."
		robes = "MaleStaff"

	Charming
		desc = "Past Charms Professor."
		robes = "MaleStaff"

	Katsie
		desc = "Past Transfiguration Professor."
		robes = "FemaleStaff"

	Sampola
		desc = "Past COMC Professor."
		robes = "FemaleStaff"

	Amber
		desc = "Past Transfiguration Professor & Hufflepuff Prefect."
		robes = "FemaleStaff"

	Ezekiel
		desc = "Past Charms Professor."
		robes = "MaleStaff"

	Sponge
		desc = "Past DADA Professor & Slytherin Prefect."
		robes = "MaleStaff"

	Lavender
		desc = "Past Transfiguration Professor."
		robes = "FemaleStaff"

	Odd_Future
		desc = "Past Transfiguration Professor."
		robes = "MaleStaff"

	Skystone
		desc = "Past COMC Professor."
		robes = "MaleStaff"

	Farrah
		desc = "Past Transfiguration Professor."
		robes = "FemaleStaff"

	Lewis
		desc = "Past COMC Professor & Gryffindor Prefect."
		robes = "MaleStaff"

	Seta
		desc = "Professor of Transfiguration and Charms & Slytherin Prefect."
		robes = "FemaleStaff"

	Lion
		desc = "Past DADA Professor & Dueling Instructor."
		robes = "MaleStaff"

	Julz
		desc = "Past Transfiguration Professor."
		robes = "FemaleStaff"

	Rose
		desc = "Past COMC Professor."
		robes = "FemaleStaff"

	Dscudiero
		desc = "Past COMC Professor."
		robes = "MaleStaff"

	El_Diablo
		desc = "Past DADA Professor."
		robes = "MaleStaff"

	Merlin
		desc = "Past Transfiguration Professor & Hufflepuff Prefect."
		robes = "MaleStaff"

	Xzero
		desc = "Past DADA Professor."
		robes = "MaleStaff"

	Roxas
		desc = "Past DADA Professor."
		robes = "MaleStaff"

	Julian_Boi
		desc = "Past DADA Professoro."
		robes = "MaleStaff"

	Max_Quickstaff
		desc = "Past Charms Professor."
		robes = "MaleStaff"

	Neveahlee
		desc = "Past Transfiguration Professor & Slytherin and Gryffindor Prefect."
		robes = "FemaleStaff"

	Severus
		desc = "Past Transfiguration Professor."
		robes = "MaleStaff"

	Sam_Rajax
		desc = "Past DADA Professor."
		robes = "MaleStaff"

	Deathflash
		desc = "Past Duel Instructor."
		robes = "MaleStaff"

	Ice_Dragon
		desc = "Past Duel Instructor."
		robes = "MaleStaff"

	Zachary_Lyons_AKA_Link
		desc = "GCOM Professor. Past Charms, COMC, and Transfiguration Professor. Previous Duel Instructor & Ravenclaw Prefect."
		robes = "MaleStaff"

	Lady_Siren
		desc = "Past Charms Professor & Slytherin Prefect."
		robes = "FemaleStaff"

	Shade
		desc = "Past DADA Professor."
		robes = "MaleStaff"

	Avery
		desc = "Past DADA Professor."
		robes = "FemaleStaff"

	Malokh
		desc = "Past DADA Professor & Ravenclaw Prefect."
		robes = "MaleStaff"

	Mega_Joe
		desc = "Past DADA Professor."
		robes = "MaleStaff"

	Angela
		desc = "Past Charms Professor."
		robes = "FemaleStaff"

	Sirus
		desc = "Past DADA Professor."
		robes = "MaleStaff"

	Monte
		desc = "Past Charms Professor."
		robes = "MaleStaff"

	Zander
		desc = "Past Transfiguration Professor."
		robes = "MaleStaff"

	Andi
		desc = "Past COMC Professor."
		robes = "MaleStaff"

	Theodore_Richards
		desc = "Past DADA Professor."
		robes = "MaleStaff"

	Nick_A_Creed
		desc = "Past COMC Professor,"
		robes = "MaleStaff"

	Severus
		desc = "Past Transfiguration and DADA Professor."
		robes = "MaleStaff"

	Fire
		desc = "Past Duel Instructor."
		robes = "MaleStaff"

	Chaseio_Blade
		desc = "Temporary COMC Professor, Past Off-Peak Professor."
		robes = "MaleStaff"

	Chris_Sparker
		desc = "Charms Professor."
		robes = "MaleStaff"