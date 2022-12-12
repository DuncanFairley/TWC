obj/museum

	density = 1
	var/robes

	icon = 'statues.dmi'

	mouse_over_pointer = MOUSE_HAND_POINTER

	New()
		..

		if(robes == "MaleStaff")
			icon = 'MaleStaff.dmi'
		if(robes == "FemaleStaff")
			icon = 'FemaleStaff.dmi'
		else
			icon_state = robes

		if(!pname) pname = name

		namefont.QuickName(src, pname, rgb(255,255,255), "#000", top=1)

	Click()
		..()

		var/ScreenText/s = new(usr, src)

		s.AddText("This is [name]: \n[desc]")

		var/n = usr.pname ? usr.pname : usr.name

		if(name == n || pname == n)

			s.SetButtons("OK", "#2299d0", "Clothing", "#00ff00", null)

			if(!s.Wait()) return

			if(s.Result == "Clothing")

				var/d = desc
				appearance = usr.appearance

				underlays = list()
				namefont.QuickName(src, name, rgb(255,255,255), "#000", top=1)

				desc = d
				mouse_over_pointer = MOUSE_HAND_POINTER


	Murrawhip
		desc  = "<b>Owner of TWC & Minister of Magic.<b><br>Murrawhip's contributions to TWC excel any other, he will go down forever in history as 'THAT ONE GUY WHO SHUT DOWN TWC BUT THEN CHANGED HIS MIND' and for that reason - we thank him!"
		robes = "MaleStaff"

	Ander
		desc  = "<b>Former Headmaster of TWC.</b><br>The one that got away... and then came back only to leave again. Ander has been Headmaster more times than you've probably sneezed."
		robes = "green"

	Ragnarok
		desc = "<b>Original owner of TWC.</b><br>Some people liked him and most people didn't."
		robes = "blue2"

	Lucifer
		desc = "<b>Creator of TWC radio. Former Transfiguration Professor.</b><br>A wonderful asset to TWC and a true friend in times of need."
		robes = "MaleStaff"

	Linshon
		desc = "<b>Former Headmaster of TWC.</b><br>Banana man! Linshon was the creator and first person to successfully host TWC's now annual 'Summer Bash'."
		robes = "yellow"

	Shirou
		desc = "Former Headmaster of TWC & DADA Professor."
		robes = "blue"

	Kozu
		desc = "<b>Former Headmaster of TWC.</b><br>Part cute and cuddly, part fierce and fabulous."
		robes = "MaleStaff"

	Ash
		desc = "<b>Former Headmaster of TWC, better known for being an Administrator, former Charms, and Transfiguration Professor.</b><br>TWC's first British Headmaster, some say he was actually Dumbledore and McGonagall's love child but I don't believe it."
		robes = "MaleStaff"

	Rotem
		desc = "<b>Not A Player. Former Headmistress, Deputy Headmistress, Administrator, DADA, COMC, Transfiguration and GCOM Professor.</b><br>We're not sure where she came from but we praise the high heavens that she did! TWC owes alot to Rotem and we hope she never ever leaves. EVER."
		robes = "FemaleStaff"

	Tobias
		desc = "<b>Former Headmaster of TWC.</b><br>The kindest most sweetest soul ever to grace TWC with their presence."
		robes = "teal"

	Justin
		pname = "Justin (Demonic)"
		desc = "<b>Former Headmaster, Deputy Headmaster, Professor of every class at different points. Former Slytherin Prefect and Host.</b><br>He's just always there... It's kind of weird and some what creepy but he's always here when TWC needs him!"
		robes = "white"

	Sylar
		desc = "<b>Former Headmaster, Deputy Headmaster, Administrator, Chat Moderator. Previous GCOM, DADA, and Charms Professor.</b><br>"
		robes = "MaleStaff"

	Owen
		desc = "Former Headmaster, Deputy Headmaster, Administrator, and Professor."
		robes = "pink"

	Firefly
		desc = "Former Deputy Headmaster of TWC."
		robes = "darkgreen"

	Uchiha
		desc = "Former Deputy Headmaster of TWC."
		robes = "lightblue"

	Atomic
		desc = "Former Deputy Headmaster of TWC."
		robes = "white"

	Jared
		desc = "Former Deputy Headmaster of TWC."
		robes = "MaleStaff"

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
		robes = "FemaleStaff"

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

	Severus
		desc = "Former Transfiguration Professor."
		robes = "MaleStaff"

	Sam_Rajax
		desc = "Former DADA Professor."
		robes = "MaleStaff"

	Ben
		pname = "Ben (Link)"
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
		robes = "MaleStaff"

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

	Andi
		desc = "Former COMC Professor."
		robes = "FemaleStaff"

	Theodore_Richards
		desc = "Former DADA Professor."
		robes = "MaleStaff"

	Nick_A_Creed
		desc = "Former COMC Professor,"
		robes = "MaleStaff"

	Severus
		desc = "Former Transfiguration and DADA Professor."
		robes = "MaleStaff"

	Zach
		pname = "Chaseio Blade"
		desc = "GCOM Professor, Former COMC Professor, Former Off-Peak Professor."
		robes = "MaleStaff"

	Chris_Sparker
		desc = "Former Charms Professor."
		robes = "MaleStaff"

	Kole
		desc = "Former Charms Professor."
		robes = "MaleStaff"

	Tim_Cloud
		desc = "Forever remembered for being better than Zander."
		robes = "MaleStaff"

	Vanchi
		desc = "Former Professor, known for teaching and promoting honourable dueling."
		robes = "MaleStaff"

	Blaze
		desc = "A silent mountain forever in the background."
		robes = "MaleStaff"

	Numble
		desc = "Former Professor."
		robes = "MaleStaff"

	Kyo
		desc = "Former Professor."
		robes = "MaleStaff"

	Sara_Quilor
		desc = "Too young to be here."
		robes = "FemaleStaff"

	Katze
		pname = "Katze (Pie)"
		desc = "One of the most active and beloved professors to grace TWC with their presence."
		robes = "MaleStaff"
