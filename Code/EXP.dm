/*
 * Copyright � 2014 Duncan Fairley
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
	mouse_over_pointer = MOUSE_HAND_POINTER
	Click()
		usr << link("http://radio.wizardschronicles.com")
obj/hud/class
	icon = 'classhud.dmi'
	icon_state = "0"
	screen_loc = "14,1"
	mouse_over_pointer = MOUSE_HAND_POINTER
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

mob/Player/var/tmp
	Checking
	answered

proc
	AFK_Train_Scan()
		lastusedAFKCheck = world.realtime
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
				var/question/q = pick(questions)

				for(var/client/C)
					if(C.mob && C.mob.readbooks)
						winset(C,"mainwindow","flash=2")
				M << "<u>50 seconds left to reply.</u>"
				spawn(200)
					if(!M)return
					if(!M.answered) M << "<u>30 seconds left to reply.</u>"
					sleep(200)
					if(!M)return
					if(!M.answered) M << "<u><b>10 seconds left to reply.</b></u>"
					sleep(100)
					if(M && IsInputOpen(M, "AFK"))
						del M._input["AFK"]
				var
					Input/popup = new (M, "AFK")
					list/answers = Shuffle(q.wrong + q.correct)
					alrt
				if(answers.len > 3)
					alrt = popup.InputList(M, q.question, "Presence Check", answers[1], answers)
				else
					alrt = popup.Alert(M, q.question, "Presence Check", answers[1], answers[2], answers.len == 3 ? answers[3] : null)

				M.answered=1
				M.Checking = 0
				if(alrt != q.correct)M.Checking=1
		sleep(500)
		for(var/mob/Player/M in readers)
			if(M && !M.Checking)
				M.presence = 1
				M << infomsg("You read faster.")
			else
				M.presence = null
				M << infomsg("You feel sleepy and start reading slower.")

mob/Player/var/tmp/presence

obj
	books
		icon = 'Books.dmi'
		density = 1
		mouse_over_pointer = MOUSE_HAND_POINTER
		Click()
			..()
			if(src in view(1))
				Read_book()

		verb/Read_book()
			set src in oview(1)

			if(usr.readbooks == 1)
				usr.readbooks = 2
				usr.movable = 0
				usr:presence = null
				usr << infomsg("You stop reading.")
			else if(!usr.readbooks)
				var/obj/hud/reading/R = new()
				usr.client.screen += R
				usr.readbooks = 1
				usr.movable = 0
				usr << infomsg("You begin reading.")
				spawn(15)
					while(src && usr && usr.readbooks == 1 && (usr in ohearers(src, 1)))
						if(usr.level < lvlcap)
							var/exp = get_exp(usr.level) / (usr:presence ? 1 : 3)
							exp = round(rand(exp - exp / 10, exp + exp / 10))
							usr.Exp += exp
							usr.addReferralXP(exp)
							usr.LvlCheck()
						if(usr.level > 500) usr.gold += round(rand(3,6) / (usr:presence ? 1 : 3))
						sleep(15)
					if(usr)
						usr.client.screen -= R
						usr.readbooks = 0


		EXP_BOOK_lvl0
			icon_state="peace"
			name = "Book of Peace"

		EXP_BOOK_lvl1
			name = "Book of Chaos"
			icon_state="chaos"

		EXP_BOOK_lvl2
			name = "Gringott's Guide to Banking"
			icon_state="bank"

		EXP_BOOK_lvl3
			name = "Guide to Magic"
			icon_state="rmagic"

		EXP_BOOK_lvl4
			name = "Hogwarts: A History"
			icon_state="Hogwarts"

		EXP_BOOK_lvl5
			name = "Gawshawks Guide to Herbology"
			icon_state="herb"

		EXP_BOOK_lvl6
			name = "How to Brew Potions"
			icon_state="potion"

		EXP_BOOK_lvl7
			name = "The Key to Success"
			icon_state="key"

		EXP_BOOK_lvl8
			name = "Fencing for Dummies"
			icon_state="sword"

		EXP_BOOK_lvlde
			name = "Death Eaters Guide"
			icon_state="de"

		EXP_BOOK_lvlauror
			name = "Aurors Guide"
			icon_state="auror"

		EXP_BOOK_lvlslytherin
			name = "Slytherin's Strategies of Battle"
			icon_state="slyth"

		EXP_BOOK_lvlslytherinupgraded
			name = "Salazar's Journal"
			icon_state="slythup"

		EXP_BOOK_lvlhufflepuff
			name = "Hufflepuff's Fable Encyclopedia"
			icon_state="huffle"

		EXP_BOOK_lvlhufflepuffupgraded
			name = "Helga's Journal"
			icon_state="huffleup"

		EXP_BOOK_lvlravenclaw
			name = "Ravenclaw's Vast Dictionary"
			icon_state="raven"

		EXP_BOOK_lvlravenclawupgraded
			name = "Rowena's Journal"
			icon_state="ravenup"

		EXP_BOOK_lvlgryffindor
			name = "Gryffindor's Guide to Valor"
			icon_state="gryff"

		EXP_BOOK_lvlgryffindorupgraded
			name = "Godric's Journal"
			icon_state="gryffup"

		EXP_BOOK_lvlnone
			name = "Book of All Knowledge"
			icon_state="smart"


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




var/list/questions = list()

question
	var
		question
		correct
		list/wrong

	default
		question = "Are you here?"
		correct  = "Yes"
		wrong    = list("No")

	question0
		question = "What color are Dementors?"
		correct  = "Black"
		wrong    = list("White", "Blue")

	question1
		question = "Who is the half blood prince?"
		correct  = "Severus Snape"
		wrong    = list("Harry Potter", "Albus Dumbledore", "Ron Weasley")

	question2
		question = "Who is Tom Riddle?"
		correct  = "Voldemort"
		wrong    = list("Harry Potter", "Albus Dumbledore", "Ron Weasley",  "Lucius Malfoy ")

	question3
		question = "How many unforgivable curses are there?"
		correct  = "Three"
		wrong    = list("One", "Seven")

	question4
		question = "What is Harry Potter's position in Quidditch?"
		correct  = "Seeker"
		wrong    = list("Chaser", "Keeper", "Beater", "He didn't play Quidditch")

	question5
		question = "What is the government of the magical community in Britain called?"
		correct  = "Ministry of Magic"
		wrong    = list("Shadow Clan", "Aurors", "Death Eaters")

	question6
		question = "Who killed Albus Dumbledore?"
		correct  = "Severus Snape"
		wrong    = list("Draco Malfoy", "Voldemort", "Harry Potter")

	question7
		question = "Complete the following: _____ Pit is full of pesky pixies."
		correct  = "Pixie"
		wrong    = list("Snake", "Spider")

	question8
		question = "What is Harry's last name?"
		correct  = "Potter"
		wrong    = list("Snotter", "Hotter")

	question9
		question = "What is Ron's last name?"
		correct  = "Weasley"
		wrong    = list("Beasley", "Potter")

	question10
		question = "What is Snape's first name?"
		correct  = "Severus"
		wrong    = list("Sevvy", "Snakes", "Bob")

	question11
		question = "What color is house Slytherin?"
		correct  = "Green"
		wrong    = list("Red", "Blue", "Yellow")

	question12
		question = "What color is house Hufflepuff?"
		correct  = "Yellow"
		wrong    = list("Red", "Blue", "Green")

	question13
		question = "What color is house Gryffindor?"
		correct  = "Red"
		wrong    = list("Green", "Blue", "Yellow")

	question14
		question = "What color is house Ravenclaw?"
		correct  = "Blue"
		wrong    = list("Red", "Green", "Yellow")

	question15
		question = "What is Dumbledore's first name?"
		correct  = "Albus"
		wrong    = list("Harry", "Severus")

	question16
		question = "1+1=?"
		correct  = "2"
		wrong    = list("3", "11")

	question17
		question = "How many words are in this sentence?"
		correct  = "Seven!"
		wrong    = list("Eight!", "Potato!")

	question18
		question = "Where do new players start?"
		correct  = "Diagon Alley"
		wrong    = list("The Room of Requirement", "The Owlery")

	question19
		question = "Is this a Harry Potter themed game?"
		correct  = "Yes"
		wrong    = list("No","I'm sorry, I am too afk to answer right now.")

	question20
		question = "Who is the ghost of Ravenclaw House?"
		correct  = "The Grey Lady"
		wrong    = list("Bloody Baron", "Fat Friar", "Sir Nicholas de Mimsy-Porpington")

	question21
		question = "Who is the ghost of Gryffindor House?"
		correct  = "Sir Nicholas de Mimsy-Porpington"
		wrong    = list("Bloody Baron", "Fat Friar", "The Grey Lady")

	question22
		question = "Who is the ghost of Slytherin House?"
		correct  = "Bloody Baron"
		wrong    = list("The Grey Lady", "Fat Friar", "Sir Nicholas de Mimsy-Porpington")

	question23
		question = "Who is the ghost of Hufflepuff House?"
		correct  = "Fat Friar"
		wrong    = list("Bloody Baron", "The Grey Lady", "Sir Nicholas de Mimsy-Porpington")

	question24
		question = "When was TWC founded?"
		correct  = "2005"
		wrong    = list("1989", "2031")

	question25
		question = "What is the symbol of Gryffindor house?"
		correct  = "Lion"
		wrong    = list("Eagle", "Badger", "Snake")

	question26
		question = "What is the symbol of Ravenclaw house?"
		correct  = "Eagle"
		wrong    = list("Lion", "Badger", "Snake")

	question27
		question = "What is the symbol of Hufflepuff house?"
		correct  = "Badger"
		wrong    = list("Eagle", "Lion", "Snake")

	question28
		question = "What is the symbol of Slytherin house?"
		correct  = "Snake"
		wrong    = list("Eagle", "Badger", "Lion")

proc/init_books()
	for(var/t in typesof(/question/) - /question)
		questions += new t
	scheduler.schedule(new/Event/AFKCheck,world.tick_lag * 600)

proc
	Shuffle(list/L)
		if(!L)
			CRASH("Shuffle failed because input list is null")

		var/list/l = list()
		while (L.len)
			var/i = pick(L)
			L -= i
			l += i
		return l

	isplayer(atom/A)
		return istype(A, /mob/Player)

	Players(list/Remove=null)
		var/list/L = list()
		for(var/mob/Player/p in Players)
			if(Remove != null && (p in Remove)) continue
			if(p.derobe)
				L.Add(p.prevname)
			else
				L.Add(p)
		return L

	split(txt, d)
		#ifdef DEBUG
		ASSERT(istext(txt))
		ASSERT(istext(d))
		ASSERT(d)
		#endif

		var/pos = findtext(txt, d)
		var/start = 1
		var/dlen = length(d)

		. = list()

		while(pos > 0)
			. += copytext(txt, start, pos)
			start = pos + dlen
			pos = findtext(txt, d, start)

		. += copytext(txt, start)

mob/Player
	proc
		nofly()
			if(flying)
				var/obj/items/wearable/brooms/Broom = locate() in Lwearing
				if(Broom) Broom.Equip(src,1)
atom/movable
	proc
		inOldArena()
			return oldduelmode || (loc && loc.loc:oldsystem)

area
	var/oldsystem = FALSE

	hogwarts/Duel_Arenas/Main_Arena_Bottom
		oldsystem = TRUE
