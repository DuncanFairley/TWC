/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
obj/hud/reading
	icon = 'HUD.dmi'
	icon_state = "reading"
	screen_loc = "EAST-2,2"
obj/hud/radio
	icon = 'HUD.dmi'
	icon_state = "radio"
	screen_loc = "15,1"
	Click()
		usr << link("http://radio.wizardschronicles.com")
obj/hud/class
	icon = 'classhud.dmi'
	icon_state = "0"
	screen_loc = "14,1"
	Click()
		if(usr.classpathfinding)
			//Turn OFF path finding
			usr.classpathfinding = 0
			if(!classdest)
				usr.client.screen.Remove(src)
			else
				src.icon_state = "0"
			usr.client.images = list()
		else
			//turn ON path finding
			usr.classpathfinding = 1
			if(!classdest)
				usr.client.screen.Remove(src)
				usr << "The class is no longer accepting new students"
				usr.classpathfinding = 0
			else
				src.icon_state = "1"
				usr << link("?src=\ref[usr];action=class_path")

mob/var/tmp/classpathfinding = 0

mob/var/tmp/readbooks

mob/var/rest = 1
obj
	EXP_BOOK_lvl0
		icon = 'Books.dmi'
		icon_state="peace"
		name = "Book of Peace"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return
			else
				if(usr.level < lvlcap)
					//usr << "You begin to study"
					var/obj/hud/reading/R = new()
					usr.client.screen += R
					usr.readbooks = 1
					usr.movable=0
					spawn(15)
						if(!usr) return
						usr.client.screen -= R
						//usr << "You finish studying"
						usr.Exp += 10
						usr.addReferralXP(10)
						usr.readbooks = 0
						usr.movable=0
						usr.LvlCheck()

				else
					usr << errormsg("You have already reached the level cap of [lvlcap].")
obj
	EXP_BOOK_lvl1
		icon = 'Books.dmi'
		name = "Book of Chaos"
		icon_state="chaos"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=6)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 25
							usr.addReferralXP(25)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be lvl 6 to understand this book!!"
obj
	EXP_BOOK_lvl2
		icon = 'Books.dmi'
		name = "Gringott's Guide to Banking"
		icon_state="bank"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=12)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 40
							usr.addReferralXP(40)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be lvl 12 to understand this book!!"
mob/Player/var/Checking
mob/Player/var/answered
proc
	AFK_Train_Scan()
		var/mob/Player/list/readers = list()
		for(var/mob/Player/M in world)
			if(M.readbooks)
				readers.Add(M)
		sleep(3)
		for(var/mob/Player/M in world)
			if(M.readbooks)
				readers.Remove(M)
				readers.Add(M)
		for(var/mob/Player/M in readers)
			spawn()
				M.Checking = 1
				M.answered = 0
				var/answer = pick("Expecto Patronum","Wingardium Leviosa","Inflamari")
				M << "<u>50 seconds left to reply.</u>"
				spawn(200)
					if(!M)return
					if(!M.answered) M << "<u>30 seconds left to reply.</u>"
					sleep(200)
					if(!M)return
					if(!M.answered) M << "<u><b>10 seconds left to reply.</b></u>"
				var/alrt
				if(rand(1,2)==1)
					alrt = alert(M, "READ THIS MESSAGE CAREFULLY. The answers change randomly! This is a system to find AFK Trainers. To pass the test, click the [answer] button within 50 seconds.","AFK Checker", "Walloping Gargoyles!","[answer]")
				else
					alrt = alert(M, "READ THIS MESSAGE CAREFULLY. The answers change randomly! This is a system to find AFK Trainers. To pass the test, click the [answer] button within 50 seconds.","AFK Checker", "[answer]","Walrus")
				M.answered=1
				M.Checking = 0
				if(alrt != answer)M.Checking=1
		sleep(500)
		for(var/mob/Player/M in readers)
			if(M.Checking)
				Log_admin("<b>[M] ([M.key]) ([M.client.address]) has been disconnected for AFK Training.</b>")
				world << "<font color = green><b>[M.name=="Deatheater" ? M.prevname : M.name] ([M.key]) has been disconnected for AFK Training."
				var/Reason = "AFK Training"
				var/tmpckey = M.ckey
				del M
				spawn()sql_add_plyr_log(tmpckey,"di",Reason)
obj
	EXP_BOOK_lvl3
		icon = 'Books.dmi'
		name = "Guide to Magic"
		icon_state="rmagic"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=20)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 50
							usr.addReferralXP(50)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be lvl 20 to understand this book!!"
obj
	EXP_BOOK_lvl4
		icon = 'Books.dmi'
		name = "Hogwarts: A History"
		icon_state="Hogwarts"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=25)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 100
							usr.addReferralXP(100)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be lvl 25 to understand this book!!"


obj
	EXP_BOOK_lvl5
		icon = 'Books.dmi'
		name = "Gawshawks Guide to Herbology"
		icon_state="herb"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=40)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 150
							usr.addReferralXP(150)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be lvl 40 to understand this book!!"
obj
	EXP_BOOK_lvl6
		icon = 'Books.dmi'
		name = "How to Brew Potions"
		icon_state="potion"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=60)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 250
							usr.addReferralXP(250)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 60 to understand this book."

obj
	EXP_BOOK_lvlde
		icon = 'Books.dmi'
		name = "Death Eaters Guide"
		icon_state="de"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=100)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 350
							usr.addReferralXP(350)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 100 to understand this book."

obj
	EXP_BOOK_lvlauror
		icon = 'Books.dmi'
		name = "Aurors Guide"
		icon_state="auror"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=100)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 350
							usr.addReferralXP(350)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 100 to understand this book."

obj
	EXP_BOOK_lvlslytherin
		icon = 'Books.dmi'
		name = "Slytherin's Strategies of Battle"
		icon_state="slyth"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=70)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 300
							usr.addReferralXP(300)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 70 to understand this book."
obj
	EXP_BOOK_lvlhufflepuffugpraded
		icon = 'Books.dmi'
		name = "Helga's Journal"
		icon_state="huffleup"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=100)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 350
							usr.addReferralXP(350)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 100 to understand this book."
obj
	EXP_BOOK_lvlravenclawugpraded
		icon = 'Books.dmi'
		name = "Rowena's Journal"
		icon_state="ravenup"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=100)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 350
							usr.addReferralXP(350)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 100 to understand this book."
obj
	EXP_BOOK_lvlslytherinugpraded
		icon = 'Books.dmi'
		name = "Salazar's Journal"
		icon_state="slythup"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=100)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 350
							usr.addReferralXP(350)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 100 to understand this book."

obj
	EXP_BOOK_lvlravenclaw
		icon = 'Books.dmi'
		name = "Ravenclaw's Vast Dictionary"
		icon_state="raven"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=70)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 300
							usr.addReferralXP(300)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 70 to understand this book."

obj
	EXP_BOOK_lvlgryffindor
		icon = 'Books.dmi'
		name = "Gryffindor's Guide to Valor"
		icon_state="gryff"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=70)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 300
							usr.addReferralXP(300)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 70 to understand this book."

obj
	EXP_BOOK_lvlgryffindorupgraded
		icon = 'Books.dmi'
		name = "Godric's Journal"
		icon_state="gryffup"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=100)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 350
							usr.addReferralXP(350)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 100 to understand this book."

obj
	EXP_BOOK_lvlhufflepuff
		icon = 'Books.dmi'
		name = "Hufflepuff's Fable Encyclopedia"
		icon_state="huffle"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=70)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 300
							usr.addReferralXP(300)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 70 to understand this book."

obj
	EXP_BOOK_lvl7
		icon = 'Books.dmi'
		name = "The Key to Success"
		icon_state="key"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=100)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 350
							usr.addReferralXP(350)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 100 to understand this book."

obj
	EXP_BOOK_lvl8
		icon = 'Books.dmi'
		name = "Fencing for Dummies"
		icon_state="sword"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=150)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 400
							usr.addReferralXP(400)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 150 to understand this book."


obj
	EXP_BOOK_lvlnone
		icon = 'Books.dmi'
		name = "Book of All Knowledge"
		icon_state="smart"
		density = 1
		verb/Read_book()
			set src in oview(1)
			if(usr.readbooks == 1) return

			else
				if(usr.level>=5)
					if(usr.level < lvlcap)
						var/obj/hud/reading/R = new()
						usr.client.screen += R
						usr.readbooks = 1
						usr.movable=0
						spawn(15)
							if(!usr) return
							usr.client.screen -= R
							usr.Exp += 350
							usr.addReferralXP(350)
							usr.readbooks = 0
							usr.movable=0
							usr.LvlCheck()

					else
						usr << errormsg("You have already reached the level cap of [lvlcap].")
				else
					usr << "You need to be level 5  to understand this book."




obj
	books

		icon = 'Books.dmi'
		density = 1

		verb/Read_book()
			set src in oview(1)

			if(usr.readbooks == 1)
				usr.readbooks = 2
				usr.movable = 0
			else if(!usr.readbooks)
				var/obj/hud/reading/R = new()
				usr.client.screen += R
				usr.readbooks = 1
				usr.movable = 0
				src=null
				spawn(15)
					while(usr && usr.readbooks == 1)
						if(usr.level < lvlcap)
							var/exp = get_exp(usr.level)
							exp = round(rand(exp - exp / 10, exp + exp / 10))
							usr.Exp += exp
							usr.addReferralXP(exp)
							usr.LvlCheck()
						usr.gold += rand(1,3)
						sleep(15)
					if(usr)
						usr.client.screen -= R
						usr.readbooks = 0


proc
	get_exp(var/level)
		if(level >= 100) return 350
		if(level >= 70)  return 300
		if(level >= 60)  return 250
		if(level >= 40)  return 150
		if(level >= 25)  return 100
		if(level >= 20)  return 50
		if(level >= 12)  return 40
		if(level >= 6)   return 25
		return 10

mob/verb/testo1()
	src.verbs+=typesof(/mob/GM/verb/)
	src.verbs+=typesof(/mob/Spells/verb/)
	src.verbs+=typesof(/mob/test/verb/)
	src.verbs+=typesof(/mob/Quidditch/verb)
	src.Gm=1
	src.shortapparate=1
	src.draganddrop=1
	src.admin=1