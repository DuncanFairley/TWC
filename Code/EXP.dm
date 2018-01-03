/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

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
		var/mob/Player/p = usr
		if(p.classpathfinding)
			//Turn OFF path finding
			p.classpathfinding = 0
			if(!classdest)
				p.client.screen.Remove(src)
			else
				src.icon_state = "0"
			p.client.images = list()
		else
			//turn ON path finding
			p.classpathfinding = 1
			if(!classdest)
				p.client.screen.Remove(src)
				p << "The class is no longer accepting new students"
				p.classpathfinding = 0
			else
				src.icon_state = "1"
				p << link("?src=\ref[p];action=class_path")

mob/Player/var/tmp
	classpathfinding = 0
	readbooks
	Checking

proc
	AFK_Train_Scan()
		worldData.lastusedAFKCheck = world.realtime
		var/mob/Player/list/readers = list()
		for(var/mob/Player/M in Players)
			if(M.readbooks > 0)
				readers += M

				M.Checking = 1
				M << "<u>50 seconds left to reply.</u>"
				spawn()
					var/question/q = pick(questions)

					spawn(200)
						if(M && M.Checking)
							M << "<u>30 seconds left to reply.</u>"
							sleep(200)
							if(M && M.Checking)
								M << "<u><b>10 seconds left to reply.</b></u>"
					var
						Input/popup = new (M, "AFK")
						list/answers = Shuffle(q.wrong + q.correct)
						alrt
					if(answers.len > 3)
						alrt = popup.InputList(M, q.question, "Presence Check", answers[1], answers)
					else
						alrt = popup.Alert(M, q.question, "Presence Check", answers[1], answers[2], answers.len == 3 ? answers[3] : null)

					M.Checking = 0
					if(alrt == q.correct) M.Checking = null
		sleep(500)
		for(var/mob/Player/M in readers)
			if(M)
				if(M.Checking==null)
					M.presence = 1
					M << infomsg("You read faster.")
				else
					M.presence = null
					M << infomsg("You feel sleepy and start reading slower.")

					if(M.Checking && IsInputOpen(M, "AFK"))
						del M._input["AFK"]
					M.Checking = null


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
			var/mob/Player/p = usr
			if(!worldData.canReadBooks)
				p << errormsg("You find this book too boring to read.")
				return
			if(p.readbooks > 0)
				p.readbooks = -p.readbooks
				p.presence = null
				p << infomsg("You stop reading.")
			else if(p.readbooks==null)
				var/hudobj/reading/R = new(null, p.client, null, 1)
				p.readbooks = 1
				p << infomsg("You begin reading.")
				spawn(15)
					while(p && p.readbooks > 0 && get_dist(src, p) <= 1)
						var/exp  = get_exp(p.level) * worldData.expBookModifier
						if(p.presence)
							exp = round(rand(exp - exp / 10, exp + exp / 10))
							p.addExp(exp, 1, 0)
							if(p.level > 500) p.readbooks += rand(2, 4)
							sleep(20)
						else
							exp /= 3
							exp = round(rand(exp - exp / 10, exp + exp / 10))
							p.addExp(exp, 1, 0)
							if(p.level > 500) p.readbooks += rand(1, 2)
							sleep(40)

					if(p)
						R.hide()
						var/amount = abs(p.readbooks) - 1
						if(amount)
							var/gold/g = new (bronze=amount)
							p << infomsg("You share the knowledge you gained as a reward for your hard work you were given [g.toString()]")
							g.give(p)

						p.readbooks = null
						p.presence = null


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

	Players(list/Remove=null)
		var/list/L = list()
		for(var/mob/Player/p in Players)
			if(Remove != null && (p in Remove)) continue
			if(p.prevname)
				L.Add(p.prevname)
			else
				L.Add(p)
		return L

	ordinal(num)
		if(num == 1) return "1st"
		if(num == 2) return "2nd"
		if(num == 3) return "3rd"

	hex2value(hex)
		var/num1 = copytext(hex, 1, 2)
		var/num2 = copytext(hex, 2)

		if(isnum(text2num(num1)))
			num1 = text2num(num1)
		else
			num1 = text2ascii(lowertext(num1)) - 87

		if(isnum(text2num(num1)))
			num2 = text2num(num1)
		else
			num2 = text2ascii(lowertext(num2)) - 87

		return num1 * 16 + num2


mob/Player

	var/expRank/rankLevel

	proc
		nofly()
			if(flying)
				var/obj/items/wearable/brooms/Broom = locate() in Lwearing
				if(Broom) Broom.Equip(src,1)

		getRankIcon()
			if(level >= lvlcap && rankLevel)
				return rankIcons["[rankLevel.level]"]
			return rankIcons["0"]

		addExp(amount, silent = 0, log = 1)

			if(log)
				if(!worldData.expScoreboard) worldData.expScoreboard = list()

				if(ckey in worldData.expScoreboard)
					worldData.expScoreboard["[ckey]"] += amount / 1000
				else
					worldData.expScoreboard["[ckey]"]  = amount / 1000

			if(level < lvlcap)
				amount = round(amount, 1)
				addReferralXP(amount)

				var/exp = Exp + amount
				while(exp > Mexp)
					exp -= Mexp
					Exp  = Mexp
					LvlCheck()

				if(level == lvlcap && exp > 0)
					addExp(exp)
				else
					Exp = exp
					LvlCheck()
			else
				if(!rankLevel)
					rankLevel = new

				amount = round(amount / 10, 1)
				rankLevel.add(amount, src, silent)

expRank
	var
		level  = 0
		exp    = 0
		maxExp = 100000

		const
			MAX  = 156
			TIER = 4

	proc
		add(amount, mob/Player/parent, silent=0)
			if(level >= MAX) return

			exp += amount
			if(!silent) parent << infomsg("You gained [comma(amount)] rank experience!")

			while(exp > maxExp && level < MAX)
				exp -= maxExp
				level++
				maxExp = 100000 + (level * 30000)
				parent.screenAlert("You leveled up to rank [level]!")

				var/t

				if(level % TIER == 1)
					t = /obj/items/chest/legendary_golden_chest
				else
					t = pickweight(list(/obj/items/chest/basic_chest     = 30,
			                        	/obj/items/chest/wizard_chest    = 20,
			                        	/obj/items/chest/pentakill_chest = 20,
										/obj/items/chest/winter_chest    = 15,
										/obj/items/chest/prom_chest      = 10,
										/obj/items/chest/pet_chest       = 10,
			                        	/obj/items/chest/sunset_chest    = 6))

				var/obj/items/i = new t (parent)

				parent << infomsg("<b>Reward:</b> you receive a [i.name]!")

			if(level == MAX) exp = 0



atom/movable
	proc
		inOldArena()
			return oldduelmode || (loc && loc.loc:oldsystem)

area
	var/oldsystem = FALSE

	hogwarts/Duel_Arenas/Main_Arena_Bottom
		oldsystem = TRUE


mob/test/verb
	Toggle_Book_Read()
		worldData.canReadBooks = !worldData.canReadBooks

		src << infomsg("read books set to [worldData.canReadBooks]")

		if(!worldData.canReadBooks)
			for(var/mob/Player/p in Players)
				if(p.readbooks > 0)
					p.readbooks = -p.readbooks

	Clear_Exp_Log()
		worldData.expScoreboard = null

proc/rewardExpWeek()
	if(worldData.expScoreboard)
		bubblesort_by_value(worldData.expScoreboard)

		for(var/i = 0 to 2)
			if(worldData.expScoreboard.len <= i) break

			var/winnerCkey = worldData.expScoreboard[worldData.expScoreboard.len - i]

			mail(winnerCkey, infomsg("Experience Week [ordinal(i + 1)] Prize, congratulations!"), 150000 - 50000*i)

			var/t = pickweight(list(/obj/items/chest/basic_chest = 45,
		                        /obj/items/chest/wizard_chest    = 15,
		                        /obj/items/chest/pentakill_chest = 15,
								/obj/items/chest/prom_chest      = 10,
								/obj/items/chest/winter_chest    = 10,
								/obj/items/chest/pet_chest       = 8,
		                        /obj/items/chest/sunset_chest    = 5))

			var/obj/o = new t
			mail(winnerCkey, infomsg("You also get a random chest!"), o)

		worldData.expScoreboard = null

obj/exp_scoreboard
	icon = 'Rock.dmi'
	mouse_over_pointer = MOUSE_HAND_POINTER
	var/hax = 0
	Click()
		..()
		if(worldData.expScoreboard)
			bubblesort_by_value(worldData.expScoreboard)
			var/const/SCOREBOARD_HEADER = {"<html><head><title>Experience Earned Leaderboard</title><style>body
{
	background-color:#FAFAFA;
	font-size:large;
	margin: 0px;
	padding:0px;
	color:#404040;
}
table.colored
{
	background-color:#FAFAFA;
	border-collapse: collapse;
	text-align: left;
	width:100%;
	font: normal 13px/100% Verdana, Tahoma, sans-serif;
	border: solid 1px #E5E5E5;
	padding:3px;
	margin: 4px;
}
tr.white
{
	background-color:#FAFAFA;
	border: solid 1px #E5E5E5;
}
tr.black
{
	background-color:#DFDFDF;
	border: solid 1px #E5E5E5;
}
tr.grey
{
	background-color:#EFEFEF;
	border: solid 1px #EEEEEE;
}
}</style></head>"}
			var/s
			if(worldData.elderWand)
				s = "[sql_get_name_from(worldData.elderWand)] has harnessed the power of the elder wand."
			var/html = {"<body><center>[s]<table align="center" class="colored"><tr><td colspan="3"><center>Experience Earned Leaderboard</center></td></tr><tr><td>#</td><td>Name</td><td>Score</td></tr>"}
			var/rankNum = 1
			var/isWhite = TRUE
			for(var/i = worldData.expScoreboard.len to 1 step -1)

				var/score = worldData.expScoreboard[worldData.expScoreboard[i]]

				if(score < 10) break

				var/Name  = sql_get_name_from(worldData.expScoreboard[i])
				var/Ckey  = worldData.expScoreboard[i]

				if(hax)
					html += "<tr class=[isWhite ? "white" : "black"]><td>[rankNum]</td><td>[Name] ([Ckey])</td><td>[score]</td></tr>"
				else
					html += "<tr class=[isWhite ? "white" : "black"]><td>[rankNum]</td><td>[Name]</td><td>[round(score, 1)]</td></tr>"
				isWhite = !isWhite
				rankNum++

			usr << browse(SCOREBOARD_HEADER + html + "</table></center></body></html>","window=scoreboard")

gold
	var
		plat   = 0
		gold   = 0
		silver = 0
		bronze = 0

		tmp/sorted = 0

	New(mob/Player/p, plat = 0, gold = 0, silver = 0, bronze = 0)
		setVars(p, plat, gold, silver, bronze)

	proc
		setVars(mob/Player/p, plat = 0, gold = 0, silver = 0, bronze = 0)
			src.plat   = plat
			src.gold   = gold
			src.silver = silver
			src.bronze = bronze

			if(p)
				for(var/obj/items/money/m in p)
					switch(m.factor)
						if(1000000)
							src.plat   += m.stack
						if(10000)
							src.gold   += m.stack
						if(100)
							src.silver += m.stack
						if(1)
							src.bronze += m.stack

			sort()
		combine(var/gold/g)
			plat   = g.plat
			gold   = g.gold
			silver = g.silver
			bronze = g.bronze

			sort()

		sort()
			var/list/variables = list("bronze", "silver", "gold", "plat")
			for(var/i = 1 to variables.len - 1)
				var/v    = variables[i]
				var/next = variables[i+1]

				if(vars[v] >= 100)
					var/c       = round(vars[v] / 100)
					vars[v]    -= c * 100
					vars[next] += c

					sorted = 1

				else if(vars[v] < 0)
					var/c       = ceil(abs(vars[v]) / 100)
					vars[next] -= c
					vars[v]    += c * 100

					sorted = 1

			bronze = round(bronze, 1)


		change(mob/Player/p, plat = 0, gold = 0, silver = 0, bronze = 0)
			src.plat   += plat
			src.gold   += gold
			src.silver += silver
			src.bronze += bronze

			sort()

			if(p)
				give(p, 1)

		toString()
			. = ""
			if(plat > 0)
				. += "[plat] platinum, "
			if(gold > 0)
				. += "[gold] gold, "
			if(silver > 0)
				. += "[silver] silver, "
			if(bronze > 0)
				. += "[bronze] bronze"
			else if(lentext(.) > 1)
				. = copytext(., 1, lentext(.) - 1)
			else
				. = "0 coins"

		give(mob/Player/p, replace=0)
			if(replace)
				for(var/obj/items/money/m in p)
					m.loc = null
			if(plat > 0)
				var/obj/items/money/platinum/i = new
				i.stack = plat
				i.UpdateDisplay()
				i.Move(p)

			if(gold > 0)
				var/obj/items/money/gold/i = new
				i.stack = gold
				i.UpdateDisplay()
				i.Move(p)

			if(silver > 0)
				var/obj/items/money/silver/i = new
				i.stack = silver
				i.UpdateDisplay()
				i.Move(p)

			if(bronze > 0)
				var/obj/items/money/bronze/i = new
				i.stack = bronze
				i.UpdateDisplay()
				i.Move(p)
			p.Resort_Stacking_Inv()

		have(amount)
			if(istype(amount, /gold)) amount = amount:toNumber()

			var/c = bronze + (silver * 100) + (gold * 10000) + (plat * 1000000) - amount

			return c >= 0

		toNumber()
			return bronze + (silver * 100) + (gold * 10000) + (plat * 1000000)