turf
	dirtOpaque
		name="dirt"
		icon='turf.dmi'
		icon_state="dirt"
		opacity=1
turf
	officedoor4
		name = "Tobias's Office"
		icon = 'door1.dmi'
		icon_state = "closed"
		density = 1
		var
			recept = 0
		verb/Signal()
			set category = "Door"
			set src in oview(1)
			if(src.recept == 0)
				usr << "Your request to enter has been sent, if there is no reply, Deputy Headmaster Tobias may be AFK/offline."
				for(var/mob/M in world)
					if(M.key == "")
						switch(input(M,"[usr] wishes to enter your office.","Doorbell") in list ("Allow","Deny"))
							if("Allow")
								M << "You allow [usr] to enter."
								usr << "<b><font size=2>You may enter."
								for(var/turf/officedoor4/T in world)
									flick("opening",T)
									T.icon_state = "open"
									density = 0
									opacity = 0
									sleep(70)
									flick("closing",T)
									T.icon_state = "closed"
									density = 1
									opacity = 1
							if("Deny")
								M << "You don't allow [usr] to enter."
								usr << "<b><font size=2><font color=red>You may not enter."
			else
				usr << "Talk to the receptionist"

turf
	officedoor5
		name = "Sylar's Office"
		icon = 'door1.dmi'
		icon_state = "closed"
		density = 1
		var
			recept = 0
		verb/Signal()
			set category = "Door"
			set src in oview(1)
			if(src.recept == 0)
				usr << "Your request to enter has been sent, if there is no reply, Deputy Headmaster Sylar may be AFK/offline."
				for(var/mob/M in world)
					if(M.key == "")
						switch(input(M,"[usr] wishes to enter your office.","Doorbell") in list ("Allow","Deny"))
							if("Allow")
								M << "You allow [usr] to enter."
								usr << "<b><font size=2>You may enter."
								for(var/turf/officedoor5/T in world)
									flick("opening",T)
									T.icon_state = "open"
									density = 0
									opacity = 0
									sleep(70)
									flick("closing",T)
									T.icon_state = "closed"
									density = 1
									opacity = 1
							if("Deny")
								M << "You don't allow [usr] to enter."
								usr << "<b><font size=2><font color=red>You may not enter."
			else
				usr << "Talk to the receptionist"


	officedoor2
		name = "Ander's Office"
		icon = 'door1.dmi'
		icon_state = "closed"
		density = 1
		var
			recept = 0
		verb/Signal()
			set category = "Door"
			set src in oview(1)
			if(src.recept == 0)
				usr << "Your request to enter has been sent, if there is no reply, Headmaster Ander may be AFK/offline."
				for(var/mob/M in world)
					if(M.key == "")
						switch(input(M,"[usr] wishes to enter your office.","Doorbell") in list ("Allow","Deny","Shortly","Stop","Denied"))
							if("Allow")
								M << "You allow [usr] to enter."
								usr << "You may enter"
								for(var/turf/officedoor2/T in world)
									flick("opening",T)
									T.icon_state = "open"
									density = 0
									opacity = 0
									sleep(70)
									flick("closing",T)
									T.icon_state = "closed"
									density = 1
									opacity = 1
							if("Deny")
								M << "You don't allow [usr] to enter."
								usr << "You may not enter"
							if("Shortly")
								M << "You ask [usr] to wait shortly."
								usr << "Headmaster Ander is currently seeing someone, but will be done shortly. If you have a seat, he will be with you shortly."
								switch(input("Would you like to go to Ander's Waiting room?","Orb to waiting room?")in list("Yes","No"))
									if("Yes")
										flick('magic.dmi',usr)
										usr.loc = locate(54,78,1)
										flick('magic.dmi',usr)
										usr << "\n<b>Ander</b> : Feel free to have a seat, I will be with you shortly."
									if("No")
										usr << "\nAlright."
							if("Stop")
								M << "You tell [usr] to stop."
								usr << "Please only use the signal verb once! If you do not stop you will be punished."
							if("Denied")
								M << "You denied [usr]."
								usr << "<center><h2><font color=red>Denied!</h2></center></font>"
								return
			else
				usr << "Talk to the receptionist."
	bluealert
		icon='bluealert.dmi'
		density=0
	wwall
		icon='wall1.dmi'
		icon_state="wwall"
		density=1
		opacity=0
	holoalertfloor
		icon_state="wood"
		density=0
	clights
		icon_state="lights"
		density = 1
	cane
		//icon_state="cane"
		density=0
	roof
		icon_state="roof"
		density=1
	roofpass
		icon_state="roof"
		density=0
		layer=MOB_LAYER+7
	boat
		icon_state="boat"
		density=1
	door
		icon_state="door"
		density=1
	woodenwall
		icon_state="wooden"
		density=1
	dirtwall
		icon_state="dirtwall"
		density=1
	dirtroof
		icon_state="dirtroof"
		density=1
	dirtroofpass
		icon_state="dirtwall"
		density=0
		layer=MOB_LAYER+7
	woodenspike
		icon_state="woodenspike"
		density=0
		layer=MOB_LAYER+7
	waterfall
		icon_state="waterfall"
		density=0
	gmdoor
		icon_state="gmdoor"
		density=1
	niblets
		icon_state="nibletsign"
		density=1
	boat9
		icon_state="9"
		density=1
	boat10
		icon_state="10"
		density=1
	boat11
		icon_state="11"
		density=1
	boat12
		icon_state="12"
		density=1
	boat13
		icon_state="13"
		density=1
	boat14
		icon_state="14"
		density=1
	boat1
		icon_state="1"
		density=1
	boat2
		icon_state="2"
		density=1
	boat3
		icon_state="3"
		density=1
	boat4
		icon_state="4"
		density=1
	boat5
		icon_state="5"
		density=1
	boat6
		icon_state="6"
		density=1
	boat7
		icon_state="7"
		density=1
	boat8
		icon_state="8"
		density=1
	signitem
		icon_state="itemsign"
		density=1
	signweapon
		icon_state="weaponsign"
		density=1
	signbead
		icon_state="bedsign"
		density=1
	signboat
		icon_state="boatsign"
		density=1
	signblacksmith
		icon_state="bssign"
		density=1
	signplayer
		icon_state="plsign"
		density=1
	beacheast
		icon_state="beacheast"
		density=0
	beachwest
		icon_state="beachwest"
		density=0
	beachnorth
		icon_state="beachnorth"
		density=0
	beachsouth
		icon_state="beachsouth"
		density=0
	beachsidesoutheast
		icon_state="beachsoutheast"
		density=0
	beachsidesouthwest
		icon_state="beachsouthwest"
		density=0
	beachsidenortheast
		icon_state="beachnortheast"
		density=0
	beachsidenorthwest
		icon_state="beachnorthwest"
		density=0
	bcornernw
		icon_state="bnw"
		density=0
	bcornerne
		icon_state="bne"
		density=0
	bcornerse
		icon_state="bse"
		density=0
	bcornersw
		icon_state="bsw"
		density=0
	cactus
		icon_state="cactus"
		density=1
	northpole
		icon_state="pole"
		density=1
	upstairs
		icon_state="stairs"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(2,24,2)
	tostaffoffices
		icon_state="gmstair"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(70,77,21)
	tosilversecond
		icon_state="stairs2"
	tomainhall
		icon_state="gmstair"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(13,57,21)
	toaurorhq
		icon_state="gmstair"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(88,65,22)
	tofloor2
		icon_state="gmstair"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(96,24,21)
	level2
		icon_state="gmstair"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(90,6,21)
	downstairs
		icon_state="stairs1"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(41,8,5)
	bench
		icon_state="bench"
		density=0
	benche
		icon_state="benche"
		density=0
	rock
		icon_state="rock"
		density=1
	toprock
		icon_state="toprock"
		density=0
	toprockright
		icon_state="toprockright"
		density=1
	toprockleft
		icon_state="toprockleft"
		density=1
	turnup
		icon_state="turnup"
		density=1
	turnupfence
		icon_state="turnupleft"
		density=1
	turndown
		icon_state="turndown"
		density=1
	turndownfence
		icon_state="turndownright"
		density=1
	shopsign
		icon_state="shop"
		density=1
	floor1
		icon_state="floor1"
		density=0
	floor2
		icon_state="floor2"
		density=0
	stone
		icon_state="stone"
		density=1
	tree
		icon='Trees.dmi'
		icon_state="tree1"
		density=1
		opacity=0
//	tree
//		density=1
//		opacity=0
	counter
		icon_state="counter"
		density=1
	counterlef
		icon_state="counterleft"
		density=1
	counterright
		icon_state="counterright"
		density=1
	greathalltable
		icon_state="ghtable"
		density=1
	gryffindorfloor
		icon_state="gred"
		density=0
//mob/Madam_Pomfrey
//	icon = 'Pomfrey.dmi'
//	NPC = 1
//	player=0
//	verb
//		Heal()
//			set src in oview(1)
//
//			switch(input("Would you like me to heal you?","Madam Pomfrey the Nurse")in list("Yes, Please.","No Thanks."))
///				if("Yes, Please.")
	//				usr<<"<b><font color=green>Madam Pomfrey:</font><font color=aqua> Episky!"
	//				usr.overlays+=image('attacks.dmi',icon_state="heal")
	//				usr.HP=usr.MHP
	//				usr.status=""
	//				sleep(10)
	//				usr.overlays-=image('attacks.dmi',icon_state="heal")
	//			if("No Thanks.")
	//				usr<<"Madam Pomfrey:  Very well then. Off you go."
turf
	leavediagon
		icon = 'portal.dmi'
		name = "Portal"
		Entered(mob/M)
			if(ismob(M))
				M.loc = locate(99,22,15)
				M << "You leave Diagon Alley."
turf

	basementpole
		icon='COMC Icons.dmi'
		icon_state="pole"
		density=1
	basementrail
		icon='COMC Icons.dmi'
		icon_state="rail"
		density=1
	DarkAngelTop
		icon='Objects.dmi'
		icon_state="top"
		density=1
	DarkAngelBottom
		icon='Objects.dmi'
		icon_state="bottom"
		density=1
	Gate
		bumpable=1
		door=1
		icon='gate.dmi'
		density=1
		icon_state="closed"
		opacity=1
		pass=""
	Rag_Door
		icon='Door.dmi'
		density=1
		icon_state="never"
		flyblock=1
		opacity=0
		verb
			Examine()
				set src in oview(3)
				usr << "\nYou see a large black 'X' painted onto the door, and a small inscription saying 'Never Again'."
	Iandoor
		name = "Lord Xioshen's Door"
		icon = 'Door.dmi'
		flyblock=1
		icon_state = "closed"
		density = 1
		opacity=1
		pass=""
		door=0
		bumpable=0
	Amberdoor
		name = "Door"
		icon = 'Door.dmi'
		flyblock=1
		icon_state = "closed"
		density = 1
		opacity=1
		pass=""
		door=0
		bumpable=0
	Diablodoor
		name = "Door"
		icon = 'Door.dmi'
		flyblock=1
		icon_state = "closed"
		density = 1
		opacity=1
		pass=""
		door=0
		bumpable=0
	AmberDiablodoor
		name = "Door"
		icon = 'Door.dmi'
		flyblock=1
		icon_state = "closed"
		density = 1
		opacity=1
		pass=""
		door=0
		bumpable=0
	Shiroudoor
		name = "Wooden Door"
		icon = 'Door.dmi'
		flyblock=1
		icon_state = "closed"
		density = 1
		opacity=1
		pass=""
		door=0
		bumpable=0
		Enter()
			if(bumpable==0)
				return 0
			else return ..()
	IanOfficeDoor
		name = "Ian's Office Door"
		flyblock=1
		icon = 'Door.dmi'
		icon_state = "closed"
		density = 1
		opacity=1
		pass=""
		door=0
		bumpable=0
	Voyager_Door
		bumpable=1
		flyblock=1
		door=1
		icon='ADoor.dmi'
		density=1
		icon_state="closed"
		opacity=1
		pass=""
	stump
		icon_state="stump"
		density=1
	Holoroom_Door
		bumpable=1
		door=0
		icon='Door.dmi'
		density=1
		icon_state="closed"
		opacity=1
		pass=""
	greenchair
		icon_state="gc"
area
	Cata1_Enter
		Entered(mob/Player/M)
			if(!istype(M, /mob)) return
			if(M.monster==1)
				return
			else
				M.loc=locate(44,62,7)

	Cata1_Return
		Entered(mob/Player/M)
			if(!istype(M, /mob)) return
			if(M.monster==1)
				return
			else
				M.loc=locate(9,71,21)
	Ghoul_Area_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(8,usr.y,23)
	Archangel_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,8,23)
	Battle_Area
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(92,1,16)
	Battle_Area_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(1,21,15)

	mainhall2
		Entered(mob/Player/M)
			if(M.monster==1)
				return
			else
				M.loc=locate(22,62,21)

	Barn2
		Entered(mob/Player/M)
			M.loc=locate(48,2,21)
	Arena_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(50,1,15)
	SilverbloodLevel2
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(19,89,2)
	SilverbloodLevel1
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(32,22,2)
	Scorpion_Cave
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(69,10,19)
	Scorpion_Cave_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(16,70,18)
	SilverbloodExit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(49,34,3)
	SilverbloodGroundExit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(14,97,18)
area
	Ander_To
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(89,36,22)

area
	Ander_To2
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(91,3,23)
area
	IanHouse2
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(86,2,13)
area
	IanHouse1
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(71,38,17)


	Cave_exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(48,32,1)
	cave_exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(51,79,4)
	cave_entrance
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(69,14,3)

	Volcano
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(19,9,8)
	Volcano_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(56,84,9)
	Ice_Cavern
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(50,2,14)
	Ice_Cavern_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(45,20,13)

	Zydoc_End
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(94,usr.y,11)
	Zydoc_Land
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(7,usr.y,6)
	Forest_End
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(7,usr.y,11)
	Forest_Land
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(99,usr.y,12)
	Ice_End
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,7,11)
	Ice_Land
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,99,13)

	Dark_Elf_KD
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,6,17)
	Dark_Elf_KD_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,94,12)
	Mine
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(27,11,16)
	Mine_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(28,88,7)
	Tunder_Path
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,7,15)
	Thunder_Path_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,94,11)
	Tunder_Field
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(usr.x,7,18)
	Azkaban_Enter
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(58,1,25)
	Sylar_Enter
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(75,11,1)
area
	Gryff1
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(9,97,13)

area
	Raven1
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(12,57,13)

area
	Slyth1
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(83,62,13)

area
	Huffle1
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(47,97,13)

area
	Gryff2
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(65,63,14)

area
	Raven2
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(33,45,14)

area
	Slyth2
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(33,63,14)

area
	Huffle2
		Entered(mob/Player/M)
			if(quidditchmatch) if(quidditchmatch.gameon) return
			if(istype(M, /mob/Player))
				M.loc=locate(65,45,14)
area
	Cave_entrance
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(16,23,3)
		Arena_Exit
			Entered(mob/Player/M)
				if(istype(M, /mob/Player))
					M.density = 0
					M.Move(locate(3,21,15))
					M.density = 1
		Arena
			Entered(mob/Player/M)
				if(!M || !istype(M, /mob/Player)) return
				if(M.monster==1)
					return
				else
					M.loc=locate(50,100,17)
		AzkabanGroundEnter
			Entered(mob/Player/M)
				if(!istype(M, /mob/Player))
					return
				else
					usr.density=1
					usr.flying=0
					usr.icon_state=""
					M << "<font color=red>Welcome to Diagon Alley. Ollivander's Wand Shop is the first shop on the right, after you move through the moving wall</font>"
					M.loc=locate(45,5,26)
		Dark_Forest
			Entered(mob/Player/M)
				if(!istype(M,/mob)) return
				if(M.monster==1)
					return
				else
					M.density = 0
					M.Move(locate(92,3,16))
					M.density = 1
		Student_Housing2/Entered(mob/Player/M)
			if(!istype(M,/mob)) return
			if(M.monster==1)
				return
			else
				M.loc=locate(2,25,17)

		Student_Housing3/Entered(mob/Player/M)
			if(!istype(M,/mob)) return
			if(M.monster==1)
				return
			else
				M.loc=locate(48,99,8)

		Student_Housing4/Entered(mob/Player/M)
			if(M.monster==1)
				return
			else
				M.loc=locate(47,2,19)
		Hogsmaede_Exit/Entered(mob/Player/M)
			if(!istype(M, /mob)) return
			if(M.monster==1)
				return
			else
				M.loc=locate(51,1,17)
turf

	pumpkin
		icon = 'pumpkin.dmi'
obj/Signs/Sign_NickSam
	icon='statues.dmi'
	icon_state="sign"
	dontsave=1
	density=1
	wlable=0
	verb
		Read_()
			set src in oview(10)
			usr<<"<font size=3><font color=silver>Here lies <b>Blackwood Manor  - <font color=blue><b>Home of Sampola and Nick</b>"
	Signs/Cost/Cost50k
		name="Sign"
		icon='statues.dmi'
		icon_state="sign"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		verb
			Read_()
				set src in oview(10)
				usr<<"<b>This house costs 50,000 gold."

	Signs/Cost/Cost100k
		name="Sign"
		icon='statues.dmi'
		icon_state="sign"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		verb
			Read_()
				set src in oview(10)
				usr<<"<b>This house costs 100,000 gold."

	Signs/Cost/Cost150k
		name="Sign"
		icon='statues.dmi'
		icon_state="sign"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		verb
			Read_()
				set src in oview(10)
				usr<<"<b>This house costs 150,000 gold."

	Signs/Cost/Cost200k
		name="Sign"
		icon='statues.dmi'
		icon_state="sign"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		verb
			Read_()
				set src in oview(10)
				usr<<"<b>This house costs 200,000 gold."
obj
	Signs/Hogsmeade_Bank
		icon='statues.dmi'
		icon_state="sign"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		verb
			Read_()
				set src in oview(10)
				usr<<"\n<font color=red><b>Gringott's Wizard's Bank.</font><font color=blue><br>Hogsmeade Branch.</b>"
obj
	Signs/Windhowl_Manor
		icon='statues.dmi'
		icon_state="sign"
		dontsave=1
		density=1
		wlable=0
		accioable=0
		verb
			Read_()
				set src in oview(10)
				usr<<"<b>Inside is <u>Animation</u>. Fun, Friends, and Entertainment lay inside these doors."
area
	OldAuror
area
	To_Santa
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(74,3,7)
area
	Back_From_Quid
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(48,35,14)
area
	To_Owlery_Broom
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				if(M.flying==1)
					M.flying=0
					M.density=1
					M.icon_state=""
					M << "You land gently."
				M.loc=locate(42,5,23)
area/Block
area/Block
	density=1
		Student_Housing/Entered(mob/Player/M)
			if(M.monster==1)
				return
			else
				M.loc=locate(100,44,19)
area/blockeast
	icon='turf.dmi'
	icon_state="block"
	density=0
	Entered()
		if(usr.monster==1)
			usr.density=0
			step(usr,EAST)
			step(usr,EAST)
			usr.density=1
			return
		else
			return
area/blockup
	icon='turf.dmi'
	icon_state="block"
	density=0
	Entered()
		if(usr.monster==1)
			usr.density=0
			step(usr,NORTH)
			step(usr,NORTH)
			usr.density=1
			return
		else
			return
area/blockwest
	icon='turf.dmi'
	icon_state="block"
	density=0
	Entered()
		if(usr.monster==1)
			usr.density=0
			step(usr,WEST)
			step(usr,WEST)
			usr.density=1
			return
		else
			return
area/blocksouth
	icon='turf.dmi'
	icon_state="block"
	density=0
	Entered()
		if(usr.monster==1)
			usr.density=0
			step(usr,SOUTH)
			step(usr,SOUTH)
			usr.density=1
			return
		else
			return
turf
	sand2
		icon='Turfs.dmi'
		icon_state="desert"
		name="sand"
obj/Healing_Potion
obj/Initial
	icon='misc.dmi'
	wlable=0
obj/Book_Of_The_Cross
	icon='books.dmi'
	icon_state="Cross"
	dontsave=1
obj/Piano
	icon='misc.dmi'
	icon_state="piano"
	wlable=0
	density=1
	accioable=0
	dontsave=1
	verb
		Play(M as sound)
			set src in oview(1)
			view(50)<<sound(M)
			view(50)<<"<b>Piano:</b> <font color=red><b>[usr]</b> plays [M]."
obj
	mazetree
		icon='ragtree.dmi'
		density=1
		opacity=1
		wlable=0
		accioable=0
		dontsave = 1
obj/plate
	icon='turf.dmi'
	icon_state="plate"
	density=1
	dontsave=1
obj/Stool
	icon='desk.dmi'
	icon_state="Stool"
	pixel_y=-5
	value=2500
	dontsave=1
mob
	Holoalert
		density=0
		bumpable=1
		invisibility=2
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(41,62,21)
			alert(usr,"ACCESS DENIED.  You need a teacher to cast Alohomora upon this door to gain access to the Holoroom.","Holo-Room Computer")
area
	nowalk
		Entered()
			return
			usr<<"You may not pass."
turf
	lordcave
		name="Hole"
		icon='hole.dmi'
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				if(usr.foundlord==1)
					var/mob/Player/user = usr
					var/obj/items/wearable/brooms/B = locate() in user.Lwearing
					if(B)
						B.Equip(user,0)
					M.density = 0
					M.Move(locate(62,72,7))
					M.density = 1
					M.flying = 0
				else
					alert("A charm keeps you from going down the hole")
area
	To_Grin
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(30,60,20)

area
	From_Grin
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(45,82,26)
area
	To_SecondfloorRaven
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(95,20,22)

area
	From_SecondfloorRaven
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(35,19,21)
area
	From_DA
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(99,4,25)
	ShriekingShack_Enter
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(46,1,13)
	ShriekingShack_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(11,89,15)
	SilverbloodEnter
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				if(M.flying==1)
					M.loc=locate(49,30,3)
					M<<"You may not fly inside Silverblood."
				else
					M.loc=locate(24,2,2)
	Desert1
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(2,55,5)
	Desert_back
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(99,50,4)
	Desert2
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(34,2,6)
	Desert2_back
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(41,99,4)
	Holo_Room_Enter
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(74,25,22)
				alert(usr,"Welcome to the Holo-Room. The teacher of this class will be in control of the Holograms. Train carefully!","Holo-Room Computer")
	Holo_Room_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(69,45,21)
	Holoalert
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(41,62,21)
area
	Hogwarts_Enter
		Entered(mob/Player/M)
			if(!istype(M, /mob/Player)) return
			if(M.monster==1)
				return
			else
				M.loc=locate(13,25,21)
obj/Beer2
	icon='misc.dmi'
	icon_state="beer"
	accioable=0
obj/Shadow_Orb
	icon='items.dmi'
	icon_state="shadoworb"
	accioable=1
	value=0
	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."
obj/Fire_Orb
	icon='items.dmi'
	icon_state="fireorb"
	value=0
	verb

	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."

obj/Sold
	icon='items.dmi'
	icon_state="windorb"
	dontsave=0
	value=0
obj
	flag
		icon='flag.dmi'
		icon_state="ground"
		name="American Flag"

		verb
			Use()
				hearers() << "<b><font color=red>[usr] pulls <font color=white>out \his<font color=blue> Flag!</b></font>"
				usr.overlays+=image('flag.dmi',icon_state="flag")

		verb
			Put_Away()
				hearers()<<"<b><font color=red>[usr] puts <font color=white>away \his<font color=blue> Flag.</b></font>"
				usr.overlays-=image('flag.dmi',icon_state="flag")

			Examine()
				set src in view(3)
				usr << "Yay America!"
			Destroy()
				switch(input("Are you sure you want to destroy your Flag?","Destroy?")in list("Yes","No"))
					if("Yes")
						del src
					if("No")
						return
mob
	snowman
		icon='snowman.dmi'
		name="Snow Man"
		verb
			Examine()
				set src in oview(3)
				usr << "So creative!"
obj
	Guard
		icon='Mobs.dmi'
		icon_state="guard"
		density=1
		Click()
mob/Mailman
	icon='Misc Mobs.dmi'
	icon_state="Mailman"
	density=1
	NPC=1
	player=1
	Gm=1
	verb
		Examine()
			set src in oview(3)
			usr << "Your friendly neighborhood Mail man!!"
obj/Cauldron_________
	icon='General.dmi'
	icon_state="tile44"
	accioable=0
	wlable=0
	density=1
	dontsave=1
	rubbleable=1
obj/Cauldron__
	icon='cau.dmi'
	accioable=0
	icon_state="green"
	density=1
	dontsave=1
	rubbleable=1
obj/Cauldron_
	icon='cau.dmi'
	icon_state="C2"
	density=1
	dontsave=1
	accioable=0
	rubbleable=1
obj/Cauldron
	icon='cau.dmi'
	icon_state="red"
	density=1
	dontsave=1
	accioable=0
	rubbleable=1
obj/Cauldron____
	icon='cau.dmi'
	icon_state="purple"
	dontsave=1
	accioable=0
	density=1
	rubbleable=1
turf
	candle
	icon_state="wood"
	density=0
turf
	Hogwarts

		Entered(mob/Player/M)
			if(!istype(M, /mob/Player)) return
			M.loc=locate(13,25,21)
			if(usr.flying == 1)
				usr << "You land gently."
				usr.flying = 0
				usr.density = 1
				usr.icon_state="Blank"
	Hogwarts_Exit

		Entered(mob/Player/M)
			if(!istype(M, /mob)) return
			M.loc=locate(50,49,15)
mob
	Madame_Pomfrey//Names the NPC//Do i really need to say... Sets their ICON STATE

		Click()//This starts- wait... you know what this is... i hope ^^
			switch(input("Would you like me to heal you?","Madam Pomfrey the Nurse")in list("Yes, Please.","Cure my illness.","No Thanks."))
				if("Yes, Please.")
					usr<<"<b><font color=green>Madam Pomfrey:</font><font color=aqua> Episkey!"
					usr.overlays+=image('attacks.dmi',icon_state="heal")
					usr.HP=usr.MHP+usr.extraMHP
					usr.updateHPMP()
					sleep(10)
					usr.overlays-=image('attacks.dmi',icon_state="heal")
				if("Cure my illness.")
					usr<<"<b><font color=green>Madam Pomfrey:</font><font color=aqua> Ah, I shall use an ancient remedy to cure your afflictions."
					sleep(20)
					usr<<"<b><font color=green>Madam Pomfrey:</font><font color=aqua> An Mani Elem, Vas Rel Por!"
					usr<<"The nurse finishes uttering the ancient spell and waves her wand around you. You suddenly feel all warm inside."
					usr.overlays+=image('attacks.dmi',icon_state="heal")
					usr.HP=usr.MHP+usr.extraMHP
					usr.updateHPMP()
					sleep(10)
					usr.overlays-=image('attacks.dmi',icon_state="heal")
					usr.overlays-=image('MaleRavenclaw.dmi',icon_state="pimple")
					usr.Zitt=0
				if("No Thanks.")
					usr<<"Madam Pomfrey:  Very well then. Off you go."
mob/Madam_Pomfrey
	NPC=1
	bumpable=0
	Immortal=1
	icon='NPCs.dmi'
	icon_state="nurse"
	Gm=1
	//Names the NPC//Do i really need to say... Sets their ICON STATE
	New()//States that its calling a new something ^_^
		..()
		wander()//Calls the following PROC, which makes the NPC move by itself
	proc/wander()//Self-Explanatory
		//I have no idea what it does, but its required
		while(src)//As long as the src exists...
			walk_rand(src,rand(5,30))//This will happen...
			sleep(5)//And this tells it how long between each step it takes
	Click()//This starts- wait... you know what this is... i hope ^^
		switch(input("Would you like me to heal you?","Madam Pomfrey the Nurse")in list("Yes, Please.","No Thanks."))
			if("Yes, Please.")
				usr<<"<b><font color=green>Madam Pomfrey:</font><font color=aqua> Episkey!"
				usr.overlays+=image('attacks.dmi',icon_state="heal")
				usr.HP=usr.MHP+usr.extraMHP
				usr.updateHPMP()
				src = null
				spawn(10)
					usr.overlays-=image('attacks.dmi',icon_state="heal")
			if("No Thanks.")
				usr<<"Madam Pomfrey:  Very well then. Off you go."
	verb
		Heal()
			set src in oview(1)

			switch(input("Would you like me to heal you?","Madam Pomfrey the Nurse")in list("Yes, Please.","No Thanks."))
				if("Yes, Please.")
					usr<<"<b><font color=green>Madam Pomfrey:</font><font color=aqua> Episkey!"
					usr.overlays+=image('attacks.dmi',icon_state="heal")
					usr.HP=usr.MHP+usr.extraMHP
					usr.updateHPMP()
					sleep(10)
					usr.overlays-=image('attacks.dmi',icon_state="heal")
				if("No Thanks.")
					usr<<"Madam Pomfrey:  Very well then. Off you go."
mob/Sir_Nicholas
	icon = 'NPCs.dmi'
	icon_state = "normal"
	Immortal=1
	density=0
	NPC = 1
	Gm = 1
	New()//States that its calling a new something ^_^
		wander()//Calls the following PROC, which makes the NPC move by itself
	proc/wander()//Self-Explanatory
		//I have no idea what it does, but its required
		while(src)//As long as the src exists...
			walk_rand(src,rand(5,30))//This will happen...
			sleep(5)//And this tells it how long between each step it takes
	Click()//This starts- wait... you know what this is... i hope ^^
		if(!(src in view(usr.client.view)))return
		hearers()<<"<b>Sir Nicholas:</b> G'day, [usr]. I trust your day is going well, eh mate?"
		sleep(30)
		hearers()<<"Sir Nicholas opens his head and closes it, before flying off."
		icon_state="headless"
		sleep(20)
		icon_state="normal"
mob/Bloody_Baron
	icon = 'NPCs.dmi'
	icon_state = "baron"
	density=0
	Immortal=1
	NPC = 1
	Gm = 1
	New()//States that its calling a new something ^_^
		wander()//Calls the following PROC, which makes the NPC move by itself
	proc/wander()//Self-Explanatory
		//I have no idea what it does, but its required
		while(src)//As long as the src exists...
			walk_rand(src,rand(5,30))//This will happen...
			sleep(5)//And this tells it how long between each step it takes
	Click()//This starts- wait... you know what this is... i hope ^^
		if(!(src in view(usr.client.view)))return
		hearers()<<"<b>The Bloody Baron:</b> *Moan* Ahhhhhhhhhh......ooooooohhh. Leave me alone, [usr]."
mob/Moaning_Myrtle
	icon = 'NPCs.dmi'
	icon_state = "myrtle"
	density=0
	Immortal=1
	NPC = 1
	Gm = 1
	New()//States that its calling a new something ^_^
		wander()//Calls the following PROC, which makes the NPC move by itself
	proc/wander()//Self-Explanatory
		//I have no idea what it does, but its required
		while(src)//As long as the src exists...
			walk_rand(src,rand(5,30))//This will happen...
			sleep(5)//And this tells it how long between each step it takes
	Click()//This starts- wait... you know what this is... i hope ^^
		if(!(src in view(usr.client.view)))return
		hearers()<<"<b>Moaning Myrtle:</b> *Sob* Wahhhhhh! Ohhhh, hello there, [usr]. *Blush* GO AWAY! *sob* ahhh..."
obj/Snowfall
	icon='turf.dmi'
	icon_state="snowfall"
	invisibility=2
	density=0
obj/books
	EXP_BOOK_lvlnone
	name = "Book of All Knowledge"
	icon_state="smart"
obj/Book_Shelf_
	icon='Desk.dmi'
	icon_state="1"
	density=1
	dontsave=1

	New()
		..()
		spawn(1)
			for(var/mob/Player/p in Players)
				if(p.Gm)
					Players << "Special teleport bookshelf found in [x],[y],[z] on [loc]. Please delete it."
turf
	secretdoor
		bumpable=0
		name="Hogwarts Stone Wall"
		flyblock=1
		door=1
		icon='door1.dmi'
		density=1
		icon_state="closed"
		opacity=1
turf
	walltorch_housewars
		name = "walltorch"
		icon='turf.dmi'
		icon_state="w2"
		density=1
		verb
			Pull()
				set src in oview(1)
				switch(input("Pull the Torch?","Pull the Torch?")in list("Yes","No"))
					if("Yes")
						alert("You pull the torch and a secret door opens")
						for(var/turf/secretdoor/T in world)
							flick("opening",T)
							T.icon_state = "open"
							density = 0
							T.bumpable = 1
							opacity = 0
							sleep(70)
							flick("closing",T)
							T.icon_state = "closed"
							density = 1
							opacity = 1
							T.bumpable=0
					if("No")
						return
turf
	Rabbit_Hole
		icon='hole.dmi'
		Entered(mob/Player/M)
			if(M.monster==1)
				return
			else
				M.loc=locate(26,70,7)
obj/Ani/I
	icon='ian.dmi'
	icon_state="i"
	accioable=0

obj/Ani/A
	icon='ian.dmi'
	icon_state="a"
	accioable=0

obj/Ani/N
	icon='ian.dmi'
	icon_state="n"
	accioable=0

obj/Ani/T
	icon='ian.dmi'
	icon_state="t"
	accioable=0

obj/Ani/M
	icon='ian.dmi'
	icon_state="m"
	accioable=0

obj/Ani/O
	icon='ian.dmi'
	icon_state="o"
	accioable=0
obj/arrowup
	icon='items.dmi'
	icon_state="arrowup"
obj/arrowdown
	icon='items.dmi'
	icon_state="arrowdown"
obj/arrowleft
	icon='items.dmi'
	icon_state="arrowleft"
obj/arrowright
	icon='items.dmi'
	icon_state="arrowright"
obj/Copper
	icon='items.dmi'
	icon_state="copper"
obj/Iron
	icon='items.dmi'
	icon_state="iron"
obj/Steel
	icon='items.dmi'
	icon_state="steel"
	dontsave=1
obj/Titanium
	icon='items.dmi'
	icon_state="titanium"
obj/CampFire
	icon='misc.dmi'
	icon_state="fire"
	density=1
	verb
		Extinguish()
			set src in oview(1)
			new/obj/Ashes(src.loc)
			src.loc = null
obj/Ashes
	icon='items.dmi'
	icon_state="ashes"
	density=0
	New()
		sleep(50)
		src.loc = null
obj/items/Blue_Mushroom
	icon = 'items.dmi'
	icon_state = "bluemushroom"
	desc = "A blue mushroom.. yummy!"
	takeable = 0

obj/items/Green_Mushroom
	icon = 'items.dmi'
	icon_state = "greenmushroom"
	desc = "A green mushroom.. yummy!"
	takeable = 0

obj/items/Yellow_Mushroom
	icon = 'items.dmi'
	icon_state = "yellowmushroom"
	desc = "A yellow mushroom.. yummy!"
	takeable = 0

obj/items/Red_Mushroom
	icon = 'items.dmi'
	icon_state = "redmushroom"
	desc = "A red mushroom.. yummy!"
	takeable = 0
obj/Security_Barrier
	icon='misc.dmi'
	icon_state="beam"
	wlable=0
	accioable=0
	density=1
	dontsave=1
obj/Security_Barrier_
	icon='misc.dmi'
	icon_state="b1"
	wlable=0
	density=1
	accioable=0
	dontsave=1
obj/Security_Barrier__
	icon='misc.dmi'
	icon_state="b2"
	density=1
	wlable=0
	layer = MOB_LAYER + 1
	accioable=0
	dontsave=1
obj/flash
	icon='misc.dmi'
	icon_state="flash"
	accioable=0
	density=0
	wlable=0
	dontsave=1
turf

	pyramidmid
		layer = 6
		name = "pyramid"
		icon = 'pyramid.dmi'
		icon_state = "mid"

	pyramidleft
		layer = 6
		name = "pyramid"
		icon = 'pyramid.dmi'
		icon_state = "left"

	pyramidright
		layer = 6
		name = "pyramid"
		icon = 'pyramid.dmi'
		icon_state = "right"

	p_blackline
		layer = 6
		name = "pyramid"
		icon = 'pyramid.dmi'
		icon_state = "line"

	p_blacklinedown
		layer = 6
		name = "pyramid"
		icon = 'pyramid.dmi'
		icon_state = "down"

obj/PromPlate
	icon = 'PromFood.dmi'
	icon_state = "Plate"
	New()
		..()
		Refresh()
	proc/Refresh()
		spawn()while(src)
			var/foundfood = 0
			for(var/obj/O in src.loc)
				if(istype(O,/obj/FoodProm))
					foundfood = 1
			if(!foundfood)
				var/foodtypes = typesof(/obj/FoodProm) - /obj/FoodProm
				var/newfood = pick(foodtypes)
				new newfood(src.loc)
			sleep(200)
obj
	Food
		icon='turf.dmi'
		dontsave=1
		value=10
		verb
			Eat()
				set src in view(1)
				usr.HP+=25
				if(usr.HP > (usr.MHP+usr.extraMHP)) usr.HP = usr.MHP+usr.extraMHP
				usr<<"You eat \the [src]."
				del src
			Take()
				set src in oview(1)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
			Drop()
				set src in usr
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
	FoodProm
		icon = 'PromFood.dmi'
		Blue_Popsicle
			icon_state = "BluePopsicle"
		Red_Popsicle
			icon_state = "RedPopsicle"
		Yellow_Popsicle
			icon_state = "YellowPopsicle"
		Green_Popsicle
			icon_state = "GreenPopsicle"
		Blue_Snowcone
			icon_state = "BlueSnowcone"
		Green_Snowcone
			icon_state = "GreenSnowcone"
		Yellow_Snowcone
			icon_state = "YellowSnowcone"
		Red_Snowcone
			icon_state = "RedSnowcone"
		Bubble_Gum
			icon_state = "Bubble Gum"
		Blood_Pop
			icon_state = "Blood Pop"
		Skittles
			icon_state = "Skittles"
		Burger
			icon_state = "Burger"
		Fire_Whiskey
			icon_state = "Firewhiskey"
		Cookie
			icon_state = "Cookie"
		Chocolate_Frog
			icon_state = "Chocolate Frog"
		Pudding
			icon_state = "Pudding"
		Slice_of_cake
			icon_state = "Cake Slice"
		Strawberry_Cake
			icon_state = "Strawberry Cake"
		Pumpkin_Juice
			icon_state = "Pumpkinjuice"
		Butterbeer
			icon_state = "Butterbeer"
		New()
			..()
			if(!src.loc)
				del(src)
		verb
			Eat()
				set src in view(1)
				usr.HP+=25
				if(usr.HP > (usr.MHP+usr.extraMHP)) usr.HP = usr.MHP+usr.extraMHP
				usr<<"You eat \the [src]."
				del src
			Take()
				set src in oview(1)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				Pickedup()
				usr:Resort_Stacking_Inv()
			Drop()
				set src in usr
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
		proc/Pickedup()
			spawn()
				sleep(600)
				del(src)

obj/Food/Candy_Cane
			icon_state="cane"
obj/Food/Steak
			icon_state="food16"
obj/Food/Turkey
			icon_state="food13"
obj/Food/Sundae
			icon='Food.dmi'
			icon_state="Sundae"
obj/Food/fruitbucket
			name = "fruit bucket"
			icon_state="food14"
obj/Food/Pizza
			icon='Food.dmi'
			icon_state="Pizza"
turf
	flower
		icon_state="flower"
		density=1
		layer=MOB_LAYER+1
obj/Book_Of_The_Cross
	icon='books.dmi'
	icon_state="Cross"
	dontsave=1
turf
	snowtopright
		icon_state="topsnowright"
		density=0
	snowtop
		icon_state="topsnow"
		density=0
	snowtopup
		icon_state="topsnowup"
		density=0
	snowtopleft
		icon_state="topsnowleft"
		density=0
	stairsnormal
		icon_state="gmstair"
	redroses
		icon_state="redplant"
		density=1
	redchair
		icon_state="rc"
		density=1
obj
	bell
		icon = 'Turfs.dmi'
		icon_state = "bell2"
		dontsave=1
		accioable=0
		verb
			Ring_Bell()
				set src in oview(1)
				hearers()<<"<i>DING!"
				usr<<"Someone should be with you shortly."
				for(var/mob/M in range())
					if(M.name=="Shana the Receptionist")
						sleep(30)
						flick('dlo.dmi',M)

						M.invisibility=0
						hearers()<<"<b><font color=blue>Shana:</font> Hello, I'm Shana. The Hogwarts Receptionist. How May I help you?"
						sleep(30)
						usr<<"Use the Talk verb when near Shana to speak with her."
obj/Gate
	icon = 'turf.dmi'
	icon_state="gate"
	density=1

obj/enemyacid
	icon='attacks.dmi'
	icon_state="fireball"
	density=1
	var/player=0
	Bump(mob/M)
		if(!istype(M, /mob)) return
		var/damage=(50)
		if(!M.monster)
			M<<"The acid blast damages you for [damage] HP!"
			M.HP-=(damage)
			M.Death_Check()

obj/enemyfireball
	icon='attacks.dmi'
	icon_state="fireball"
	density=1
	var/mob/caster
	var/player=0
	New()
		..()
		spawn(30)del(src)
	Bump(mob/M)
		if(!istype(M, /mob))
			del(src)
			return
		var/damage=40
		if(M.monster==0)
			M<<"The fireball damages you for [damage] HP!"
			M.HP-=(damage)
			if(caster)
				M.Death_Check(caster)
			else
				M.Death_Check()
		del(src)
	SteppedOn(atom/movable/A)
		//world << "[src] stepped on [A]"
		//			projectile stood on candle
		if(ismob(A))
			if(!A.density && A:key)
				src.Bump(A)

obj/Fountain____s
	icon='statues.dmi'
	icon_state="foun4"
	density=1
	accioable=0
	wlable=0
	dontsave=1
	verb
		Touch()
			set src in oview()
			usr<<"You touch the fountain."
			sleep(40)
			hearers()<<"The fountain opens."
			sleep(20)
			usr.loc=locate(42,4,20)
			usr<<"You fall into the opening and down a tunnel into the Chamber of Secrets."

area/login

obj/Fountain____h
	icon='statues.dmi'
	icon_state="foun4"
	density=1
	accioable=0
	wlable=0
	dontsave=1

obj/Fireplace_H
	icon='misc.dmi'
	icon_state="fireplace"
	wlable=0
	density=1
	accioable=0
	dontsave=1
obj/Vanishing_Cabnet
	icon='portal.dmi'
	icon_state="portkey"
	verb
		Open()
			set src in oview(1)
			step_towards(usr,src)
			sleep(10)
			if(usr.followplayer==1){alert("You cannot use the vanishing cabnet while following a player.");return}
			if(usr.removeoMob) spawn()usr:Permoveo()
			hearers() << "[usr] walks into the cabnet and disappears."
obj/Port_Key
	icon='portal.dmi'
	icon_state="portkey"
	verb
		Touch()
			set src in oview(1)
			step_towards(usr,src)
			sleep(10)
			if(usr.followplayer==1){alert("You cannot use a portkey while following a player.");return}
			if(usr.removeoMob) spawn()usr:Permoveo()
			hearers()<<"[usr] touches the portkey and vanishes."
			for(var/obj/hud/player/R in usr.client.screen)
				del(R)
			for(var/obj/hud/cancel/C in usr.client.screen)
				del(C)
			usr.loc=locate(src.lastx,src.lasty,src.lastz)
			step(usr,SOUTH)
			return
	New()
		..()
		spawn(300)
			del(src)