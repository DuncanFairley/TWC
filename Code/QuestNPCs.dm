mob/TalkNPC/quest
	Sassy_Pixie
		icon = 'Mobs.dmi'
		icon_state="pixie"
		questPointers = "Pixie Wisdom \[Weekly]"
		Talk()
			set src in oview(3)
			Quest(usr)

		questStart(mob/Player/i_Player, questName)
			i_Player << npcsay("[name]: Get away from me, you creep.")
			i_Player << "<i>You blink.</i>"
			i_Player << npcsay("[name]: What? Are you bored? Okay, well I've got a task for you then, you pathetic imbecile. I'm in need of a few... ingredients, let's say. Not for anything sinister, like taking over your idiotic wizard school or anything. They're for a... birthday party... yeah, that's it! A birthday party.")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			if(.)
				i_Player << npcsay("[name]: Finally, what took you so long? Jeeze. Now I can finally take over that miserable place you call a school and--")
				i_Player << "<i>You blink.</i>"
				i_Player << npcsay("[name]: I mean... Plan the best party ever for, uhm... Ben! Yes, Ben...")
				i_Player << "<i>Sassy Pixie laughs evilly.</i>"
				i_Player << npcsay("[name]: Thanks, mortal!")
			else
				i_Player << npcsay("[name]: Well? What are you still standing there for? Get me what I need!")

		questCompleted(mob/Player/i_Player, questName)
			i_Player << npcsay("[name]: Get away from me, you creep.")


	Vengeful_Wisp
		icon = 'Mobs.dmi'
		icon_state="wisp"
		questPointers = "Will of the Wisp \[Daily]"
		New()
			..()
			alpha = rand(190,255)

			var/color1 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
			var/color2 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
			var/color3 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))

			animate(src, color = color1, time = 10, loop = -1)
			animate(color = color2, time = 10)
			animate(color = color3, time = 10)

		Talk()
			set src in oview(3)
			Quest(usr)

		questStart(mob/Player/i_Player, questName)
			i_Player << npcsay("Vengeful Wisp: You, human! I want you to help me express my rage, kill every wisp you face, vengeance shall be mine! Mawhahahaha!!!")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			if(.)
				i_Player << npcsay("Vengeful Wisp: I love the irony in sending you to kill dead creatures. May they rest in pea-- I will send you to kill them again tomorrow.")
			else
				i_Player << npcsay("Vengeful Wisp: Don't waste time talking to me, actions speak louder than words!")

		questCompleted(mob/Player/i_Player, questName)
			i_Player << npcsay("Vengeful Wisp: Pity the living!")

	Mysterious_Wizard
		icon_state="wizard"
		questPointers = "The Eyes in the Sand \[Daily]"
		Talk()
			set src in oview(3)
			Quest(usr)

		questStart(mob/Player/i_Player, questName)
			i_Player << npcsay("Mysterious Wizard: Beyond this door lies the desert, oh so mysterious... There are strange creatures there called floating eyes, check if they bleed for me!")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			if(.)
				i_Player << npcsay("Mysterious Wizard: Floating eyes, the gods of the desert can bleed after all, how amusing!")
			else
				i_Player << npcsay("Mysterious Wizard: Not enough, go back there and check if they all bleed!")

		questCompleted(mob/Player/i_Player, questName)
			i_Player << npcsay("Mysterious Wizard: So even the gods of the desert can bleed... Interesting!")

	Saratri
		icon_state="lord"
		questPointers = "To kill a Boss \[Daily]"
		Talk()
			set src in oview(3)
			Quest(usr)


		questStart(mob/Player/i_Player, questName)
			i_Player << npcsay("Saratri: Hey there... Did you know there's a terrible monster here called the Basilisk? I'll reward you if you kill it...")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			if(.)
				i_Player << npcsay("Saratri: Good job! I can't believe you pulled it off!")
			else
				i_Player << npcsay("Saratri: Go kill the Basilisk!")

		questCompleted(mob/Player/i_Player, questName)
			i_Player << npcsay("Saratri: Wow! I can't believe you killed the Basilisk!")

	Malcolm
		icon_state="goblin1"
		questPointers = "Draw Me a Stick \[Daily]"
		Talk()
			set src in oview(3)
			Quest(usr)


		questStart(mob/Player/i_Player, questName)
			i_Player << npcsay("Malcolm: Welcome to floor 2! Did you know Basilisk is not the strongest monster here?! There's a magical stickman in this floor, if you manage to defeat it I will reward you.")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			if(.)
				i_Player << npcsay("Malcolm: Good job! I can't believe you pulled it off!")
			else
				i_Player << npcsay("Malcolm: Go kill the Stickman!")

		questCompleted(mob/Player/i_Player, questName)
			i_Player << npcsay("Malcolm: Wow! I can't believe you killed the Stickman!")

	Hunter
		icon_state="lord"
		questPointers = list("Pest Extermination: Rat", "Pest Extermination: Demon Rat", "Pest Extermination: Pixie", "Pest Extermination: Dog", "Pest Extermination: Snake", "Pest Extermination: Wolf", "Pest Extermination: Troll", "Pest Extermination: Fire Bat", "Pest Extermination: Fire Golem", "Pest Extermination: Archangel", "Pest Extermination: Water Elemental", "Pest Extermination: Fire Elemental", "Pest Extermination: Wyvern", "Pest Extermination \[Daily]")


		Talk()
			set src in oview(3)
			Quest(usr)

		questStart(mob/Player/i_Player, questName)
			i_Player << npcsay("Hunter: Hey there, maybe you can help me, I want to exterminate a few pests from our lives.")
			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)
			i_Player << npcsay("Hunter: Did you kill the monsters I requested yet?")
			if(.)
				i_Player << npcsay("Hunter: Good job!")
			else
				i_Player << npcsay("Hunter: Go back out there and exterminate some pests!")

		questCompleted(mob/Player/i_Player, questName)
			i_Player << npcsay("Hunter: You've done a really good job exterminating all those monsters.")



	Zerf
		icon_state = "stat"
		questPointers = list("PvP Introduction", "Culling the Herd", "Strength of Dragons")
		Talk()
			set src in oview(3)
			Quest(usr)

		questStart(mob/Player/i_Player, questName)
			switch(questName)
				if("PvP Introduction")
					i_Player << npcsay("Zerf: Your skin looks so young and fresh, you haven't done much fighting eh? Why don't you try to fight a bunch of players?")
				if("Culling the Herd")
					i_Player << npcsay("Zerf: Let's kill some people... A lot of people!")
				if("Strength of Dragons")
					i_Player << npcsay("Zerf: Show me what you're made of, if you're strong enough I will give you a wand so powerful it contains the strength of dragons!")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			switch(questName)
				if("PvP Introduction")
					if(.)
						i_Player << npcsay("Zerf: Good job but we're just getting started!")
					else
						i_Player << npcsay("Zerf: You aren't going to get any better by not fighting!")
				if("Culling the Herd")
					if(.)
						i_Player << npcsay("Zerf: Mawhahahaha! THEY'RE ALL DEAD!")
					else
						i_Player << npcsay("Zerf: Kill or be killed, my friend.")
				if("Strength of Dragons")
					i_Player << npcsay("Zerf: Hmm... I don't know, are you really ready?")


		questCompleted(mob/Player/i_Player, questName)
			if(i_Player.level == lvlcap)
				i_Player << npcsay("Zerf: Why not try some matchmaking in the ranked arena?")
			else
				i_Player << npcsay("Zerf: When you reach level cap, why not try some matchmaking in the ranked arena?")


	Cassandra
		icon_state="alyssa"
		questPointers = list("Make a Fortune", "Make a Spell", "Make a Wig")
		Talk()
			set src in oview(3)
			Quest(usr)


		questStart(mob/Player/i_Player, questName)

			var/questPointer/pointer = i_Player.questPointers["Make a Potion"]
			if(!pointer || pointer.stage)
				i_Player << npcsay("Cassandra: You should try helping my twin sister Alyssa, she's sitting at Three Broom Sticks, I hear she seeks an immortality potion.")
				return

			if(i_Player.level < lvlcap)
				i_Player << npcsay("Cassandra: Look at you, such a weakling can not possibly help me.")
				return

			switch(questName)
				if("Make a Fortune")
					i_Player << npcsay("Cassandra: Hey there, do you wish to make a fortune?! Well, you've come to the right place, I have a task for you, go out there to the world and collect a peice of the rarest monsters to be found, their fine essence will be sold for millions!")
				if("Make a Spell")
					i_Player << npcsay("Cassandra: You who helped me once before, how about you help me again, thanks to you I'm rich but sadly gold can not buy me true love, however, I did manage to find a way to fulfil my desires.")
					i_Player << npcsay("Cassandra: There is a spell capable of changing the laws of magic, this will help me find what I seek. You'll have to do what you did last time only this time I need you to collect more powerful elements.")
				if("Make a Wig")
					i_Player << npcsay("Cassandra: Hey... Am I pretty? This boy rejected me... I'm rich and powerful but it's not enough, I want to be the most beautiful girl in the world-- nay, the universe! You my dear slave will help me accomplish that goal!")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			if(.)
				switch(questName)
					if("Make a Fortune")
						i_Player << npcsay("Cassandra: Hmmph! I could've done it myself but I'm a lady, here you can have this scarf, I don't need it anymore...")
						i_Player << errormsg("Cassandra takes the monster essences you've collected, she's going to make a fortune while you can warm yourself up with her old scarf.")
					if("Make a Spell")
						i_Player << npcsay("Cassandra: Hmmph! I could've done it myself but I'm a lady, here you can have this wand, I don't need it anymore...")
						i_Player << errormsg("Cassandra takes the monster essences you've collected. She's going to be extremely powerful and get all her heart's desires while you are stuck with an old stick.")
					if("Make a Wig")
						i_Player << npcsay("Cassandra: GIVE ME, GIVE ME, I will be the fairest of them all!")
						i_Player << errormsg("You decide Cassandra is a bitch and you're done running errands for her, you create and keep the wig for yourself, this girl is nothing but trouble.")

						for(var/obj/items/Alyssa/i in i_Player)
							i.Dispose()
			else
				i_Player << npcsay("Cassandra: Maybe I was wrong about you, maybe you aren't capable of defeating such rare monsters.")

		questCompleted(mob/Player/i_Player, questName)
			i_Player << npcsay("Cassandra: I hate you...")

obj/items/Alyssa
	icon='ingred.dmi'
	dropable = 0

	Onion_Root
		icon_state="Onion Root"
		desc = "I found an onion root!"
	Salamander_Drop
		icon_state="Salamander Drop"
		desc = "What the heck is a Salamander Drop?!"
	Indigo_Seeds
		icon_state="Indigo Seeds"
		desc = "I found some Indigo Seeds!"
	Silver_Spider_Legs
		icon_state="Silver Spider Legs"
		desc = "I found some Silver Spider Legs!"



obj/AlyssaChest
	name="Chest"
	icon='turf.dmi'
	icon_state="chest"
	density=1
	mouse_over_pointer = MOUSE_HAND_POINTER

	var/r

	proc/open(mob/Player/p)
		alert(p, "You open the chest")
		if(usr.ror == r)
			return 1
		else
			alert("You find nothing.")

	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			open(usr)

	Click()
		..()
		if(src in oview(1))
			open(usr)
		else
			usr << errormsg("You need to be closer.")

	Onion_Root
		Ror1
			r = 1
		Ror2
			r = 2
		Ror3
			r = 3
		open(mob/Player/p)
			.=..()
			if(. && p.checkQuestProgress("Onion Root"))
				alert("You find an Onion Root!")
				new/obj/items/Alyssa/Onion_Root(usr)
				p.Resort_Stacking_Inv()

	Indigo_Seeds
		Ror1
			r = 1
		Ror2
			r = 2
		Ror3
			r = 3
		open(mob/Player/p)
			.=..()
			if(. && p.checkQuestProgress("Indigo Seeds"))
				alert("You find some Indigo Seeds!")
				new/obj/items/Alyssa/Indigo_Seeds(usr)
				p.Resort_Stacking_Inv()

	Silver_Spider
		Ror1
			r = 1
		Ror2
			r = 2
		Ror3
			r = 3
		open(mob/Player/p)
			.=..()
			if(. && p.checkQuestProgress("Silver Spider Legs"))
				alert("You find some Silver Spider Legs!")
				new/obj/items/Alyssa/Silver_Spider_Legs(usr)
				p.Resort_Stacking_Inv()

mob/TalkNPC/quest
	Alyssa
		icon_state="alyssa"
		Gm=1
		Immortal=1
		questPointers = "Make a Potion"
		Talk()
			set src in oview(3)
			..()
			var/mob/Player/p = usr
			if("Make a Potion" in p.questPointers)
				var/questPointer/pointer = p.questPointers["Make a Potion"]
				if(pointer.stage)
					usr << "<b><font color=blue>Alyssa: </font>Find my ingredients yet?!"
					switch(input("What is your response?","Make a selection")in list("Yes","No"))
						if("Yes")
							usr << "<b><font color=blue>Alyssa: </font>Well let's see them."
							if(pointer.stage == 2)
								usr << "<b><font color=blue>Alyssa: </font>You have it all! How wonderful!"
								sleep(25)
								usr << "<b><font color=blue>Alyssa: </font>Now we'll use these to brew the potion."
								sleep(20)
								usr << "<b><font color=blue>Alyssa: </font>Hopefully I've mixed it right! I'm ready to be immortal."
								sleep(25)
								usr << "<i>Alyssa drinks the potion</i>"
								sleep(20)
								flick("transfigure",src)
								src.icon='Frog.dmi'
								sleep(40)
								flick("transfigure",src)
								icon='NPCs.dmi'
								icon_state="alyssa"
								sleep(20)
								usr << "<b><font color=blue>Alyssa: </font>I guess it was too good to be true."
								sleep(20)
								usr << "<b><font color=blue>Alyssa: </font>Thanks for helping me anyways, you can have these as a token of my gratitude."

								for(var/obj/items/Alyssa/X in usr)
									X.loc = null
								var/obj/items/AlyssaScroll/scroll = locate() in usr
								if(scroll)
									scroll.loc = null
								p.checkQuestProgress("Alyssa")
							else
								usr << "<b><font color=blue>Alyssa: </font>You don't have all of the ingredients! Go back and look for them!"
						if("No")
							usr << "<b><font color=blue>Alyssa: </font>Better keep on looking!"
				else
					usr << "<b><font color=blue>Alyssa: </font>Thanks again for helping me."
			else
				usr << "<b><font color=blue>Alyssa: </font>Hey there! You look like someone with too much time on their hands."
				sleep(15)
				usr << "<b><font color=blue>Alyssa: </font>How would you like to help me out?"
				switch(input("What do you say?","Make a selection")in list("What do you need help with?","No thanks"))
					if("What do you need help with?")
						usr << "<b><font color=blue>Alyssa: </font>Well I've been reading this book I found! There's a recipe here for a potion that makes anyone immortal!"
						sleep(15)
						usr << "<b><font color=blue>Alyssa: </font>I just don't have all the ingredients I need, can you help me find some?!"
						switch(input("Will you help Alysaa find the potion ingredients?","Make a selection")in list("Certainly!","I've got better things to do"))
							if("Certainly!")
								usr << "<b><font color=blue>Alyssa: </font>Oh wonderful! I know people around here make potions. Maybe they have some ingredients stashed away in there houses."
								sleep(15)
								usr << "<b><font color=blue>Alyssa: </font>I'm not saying to steal them....Just borrow them. Indefinitely."
								sleep(15)
								usr << "<b><font color=blue>Alyssa: </font>There's probably some growing around too. Here's my list!"
								new/obj/items/AlyssaScroll(usr)
								alert("Alyssa hands you her list of potion ingredients")
								usr << "<b><font color=blue>Alyssa: </font>Thanks!"
								p.Resort_Stacking_Inv()
								p.startQuest("Make a Potion")
							if("I've got better things to do")
								return
					if("No thanks")
						return

obj/items
	AlyssaScroll
		name="Potion Ingredients"
		icon = 'scrolls.dmi'
		icon_state = "wrote"
		dropable = 0

		var
			content="<body bgcolor=black><u><font color=blue><b><font size=3>Scroll</u><p><font color=red><font size=1>by Alyssa <p><p><font size=2><font color=white><br>Onion Root<br>Indigo Seeds<br>Drop of Salamander<br>Silver Spider Legs <p>"
		verb
			Crumple()
				var/dels = alert("Do you wish to get rid of the scroll?",,"Yes","No")
				if(dels == "Yes")
					if(src in usr)
						src << "You crumple the scroll."
						loc = null
						usr:Resort_Stacking_Inv()
			read()
				set name = "Read"
				usr << browse(content)

		Click()
			if(src in usr)
				read()
			else
				..()
