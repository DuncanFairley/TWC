/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

mob/Player
	var/tmp/questBookOpen = FALSE
	verb/questBookClosed()
		set name = ".questBookClosed"
		questBookOpen = FALSE

mob
	var
		palmer
		quests
		talktotom
		ratquest

mob/TalkNPC/quest
	var/questPointers

	New()
		..()
		tag = name
		if(questPointers)
			var/area/a = loc.loc
			if(a.questMobs)
				a.questMobs += src
			else
				a.questMobs = list(src)
	proc

		Quest(mob/Player/i_Player)
			if(i_Player.screen_text) return

			if(i_Player.questPointers)
				for(var/i in i_Player.questPointers)
					var/questPointer/pointer = i_Player.questPointers[i]
					if(!pointer || !pointer.stage)  continue
					if(!(name in pointer.reqs))     continue
					if(questPointers)
						if(islist(questPointers))
							if(i in questPointers)  continue
						else if(questPointers == i) continue

					i_Player.questProgress(i, name)
					i_Player.Interface.Update()
					break

			if(questPointers)
				var/questName
				if(islist(questPointers))
					for(var/i in questPointers)
						var/questPointer/pointer = i_Player.questPointers[i]
						if(!pointer || pointer.stage)
							questName = i
							break
					if(!questName)
						questName = questPointers[length(questPointers)]
				else
					questName = questPointers

				var/questPointer/pointer = i_Player.questPointers[questName]

				if(!pointer)
					questStart(i_Player, questName)
				else if(pointer.stage)
					questOngoing(i_Player, questName)
				else
					var/quest/q = quest_list[questName]
					if(q.repeat && world.realtime - pointer.time >= q.repeat)
						i_Player.questPointers -= questName
						questStart(i_Player, questName)
					else
						questCompleted(i_Player, questName)

		questStart(mob/Player/i_Player, questName)
			if(!i_Player) return

			if(i_Player.screen_text)
				var/ScreenText/s = i_Player.screen_text
				if(!s.WaitEnd()) return

			i_Player.startQuest(questName)

		questOngoing(mob/Player/i_Player, questName)
			if(!i_Player) return

			. = i_Player.checkQuestProgress(name)

		questCompleted(mob/Player/i_Player, questName)
			if(!i_Player) return


	professor_palmer
		icon_state="palmer"
		name="Professor Palmer"
		Immortal=1
		Gm=1
		questPointers = list("Tutorial: Quests", "Master of Keys", "Strength of Graduate \[Weekly]")
		Talk()
			set src in oview(1)
			Quest(usr)

		questStart(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("Tutorial: Quests")

					s.AddText("Hey there, you're new aren't you. I was asked by the Headmaster to teach you about quests.")
					s.AddText("You can click the quest book found in your \"Items\" tab to view quests you have or quests you completed.")
					s.AddText("How would you like to put something in that book? I have a few friends who can help you out with that, why don't you go and meet them?")


				if("Master of Keys")

					if(i_Player.level < lvlcap || !i_Player.rankLevel || i_Player.rankLevel.level > i_Player.rankLevel.TIER)

						s.AddText("You're too young for this, talk to me again when you've gained some more experience.")
						return

					s.AddText("Hey there, I see you got yourself a legendary golden chest, how about I help you open it?")

				if("Strength of Graduate \[Weekly]")

					s.AddText("I see you've grown quite a bit since you first came to this school, how about a challenge to see how strong you've become?")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)
			if(!.)

				switch(questName)
					if("Tutorial: Quests")
						s.AddText("They're friendly people, they'll help you.")
					if("Master of Keys")
						s.AddText("Keep up the good work, it'll be worth it... Maybe.")
					if("Strength of Graduate \[Weekly]")
						s.AddText("Are you up for the challenge?")
			else

				s.AddText("Good work!")

		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)
			s.AddText("Have a good day.")

mob/var/talkedtogirl
mob/var/babyquest
mob/var/babyfound
mob/var/foundlord
mob/var/talkedtofred

mob/TalkNPC/quest
	Fred
		icon_state="fred"
		density=1
		Immortal=1
		questPointers = "On House Arrest"
		Talk()
			set src in oview(3)
			..()
			var/mob/Player/p = usr
			if("On House Arrest" in p.questPointers)
				var/questPointer/pointer = p.questPointers["On House Arrest"]

				if(pointer.stage == 1)
					usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> Quickly now, go get my wand from the deposit box in Gringott's bank."
					sleep(30)
					switch(input("Fred: Quickly now","Fred")in list("Where is Gringott's again?","I'm on my way"))
						if("Where is Gringott's again?")
							usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> Gringott's Bank is found in Diagon Alley. You can find Diagon Alley near Azkaban Prison."
				else if(pointer.stage == 2)
					alert("You show Fred the wand")
					usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> YES! You got it!"
					sleep(30)
					usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> Quickly! Use the wand to get me out of here!"
					sleep(20)
					alert("You point the wand at the barriers")
					usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>[usr]</span> </b>:<font color=white> <b>Finte Incantum!</b>"
					usr.loc=locate(89,33,8)
					usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> Finally! I'm free!!!"
					alert("Fred jumps up and down")
					usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> Thank you so much. You can keep that wand if you'd like."
					p.checkQuestProgress("Fred")
				else
					usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> Thanks again!"
			else
				alert("Fred waves his hands in the air")
				usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> Help help!"
				switch(input("Fred: HELP HELP!","Fred")in list("What happened?","Shh keep it down","*Ignore Fred*"))
					if("What happened?")
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> Some strange man did this to me!"
						sleep(30)
						switch(input("Your response","Fred")in list("Why?","What did he look like?","Which way did he go","Let's get you out of there"))
							if("Why?")
								usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> Well he was walking past my house carrying this large sack."
								sleep(20)
								usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> It looked like there was a person inside. So I confronted him and asked him what was inside."
								sleep(30)
								usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> His only response was casting a spell and locking me in here."
								alert("Fred frowns")
								return
							if("What did he look like?")
								usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> I couldn't tell exactly."
								sleep(20)
								usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> He was wearing a pretty dark cloak."
							if("Which way did he go")
								usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> I'm not sure, he knocked me out and when I woke up, I was in here."
							if("Let's get you out of there")
								usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> Oh thank you!"
								sleep(30)
								usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>[usr]</span> </b>:<font color=white> Now how will we get you out..."
								sleep(30)
								usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> There is a wand of mine. It is in my deposit box at Gringotts. Here"
								alert("Fred tosses the key to you")
								new/obj/items/freds_key(usr)
								usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Fred</span> </b>:<font color=white> Go get it from Gringotts, it can get me out of here."
								alert("You nod")

								p.startQuest("On House Arrest")
								p.Resort_Stacking_Inv()

mob/TalkNPC/quest
	Girl
		icon_state="girl"
		density=1
		Immortal=1
		questPointers = "Stolen by the Lord"
		verb
			Examine()
				set src in oview(3)
				usr << "A local townsgirl."

		Talk()
			set src in oview(3)
			..()
			var/mob/Player/p = usr
			if("Stolen by the Lord" in p.questPointers)
				var/questPointer/pointer = p.questPointers["Stolen by the Lord"]
				if(pointer.stage)
					usr << "The girl looks up at you quickly"
					usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Girl</span> </b>:<font color=white> Did you find him yet?!?"

					if(pointer.stage == 2)
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>[usr]</span> </b>:<font color=white> Yep, I found him. Here you are."
						usr << "You hand the little baby boy to the girl"
						usr << "The girl throws her arms around you"
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Girl</span> </b>:<font color=white> THANK YOU THANK YOU THANK YOU!"
						usr << "You find yourself smiling slightly"
						usr << "\n<span style=\"font-size:2;\"><ont color=red><b> <font color=red>Girl</span> </b>:<font color=white> Here, this is my allowance that I saved up, you can have it."
						usr << "The girl hands you a hand full of gold."
						p.checkQuestProgress("Girl")
					else
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>[usr]</span> </b>:<font color=white> Not yet, sorry."
						usr << "The girl frowns."
				else
					usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Girl</span> </b>:<font color=white> Thanks again!!!"
					sleep(10)
					usr << "The girl smiles bigger than any you've ever seen."

			else
				usr << "\n\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Girl</span> </b>:<font color=white> Help help!"
				alert("The girl waves her arms in distress")
				sleep(30)
				switch(input("Girl: Are you here to help me?","Help?")in list("Yes","No"))
					if("Yes")
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Girl</span> </b>:<font color=white> Oh THANK YOU!"
						sleep(20)
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Girl</span> </b>:<font color=white> My mom left to go to the store, and told me to watch my little brother."
						sleep(30)
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Girl</span> </b>:<font color=white> I needed to get something from my room and when I came back, my little brother was gone."
						alert("The girl bursts into tears")
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>[usr]</span> </b>:<font color=white> Well where did you see him last?"
						alert("The girl scratches her head")
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Girl</span> </b>:<font color=white> Uhm, I'm not sure, I just came back and he was gone."
						sleep(30)
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>[usr]</span> </b>:<font color=white> Maybe I will ask some of the towns people around here."
						alert("The girl nods somberly")
						p.startQuest("Stolen by the Lord")
					if("No")
						alert("The girl frowns")





mob
	Baby
		icon = 'NPCs.dmi'
		icon_state="baby"
		density=1
		Immortal=1
		verb
			Examine()
				set src in oview(5)
				usr << "A widdle baby."

mob/TalkNPC
	Lord
		icon_state="lord"
		density=1
		Immortal=1

		verb
			Examine()
				set src in oview(3)
				usr << "He looks like a mix between Count Choculah and an elf."

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			if("Stolen by the Lord" in p.questPointers)
				var/questPointer/pointer = p.questPointers["Stolen by the Lord"]
				if(pointer.stage == 1)
					switch(input("Lord: How did you get here!","Lord")in list("Your maze was pretty lame","Give back the girls baby"))
						if("Your maze was pretty lame")
							switch(input("Lord: WHAT! NEVER!!! I will demolish you!","Lord")in list("Bring it on!","No! I'm sorry."))
								if("Bring it on!")
									usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Lord</span> </b>:<font color=white> You want to...fight me? Uh, no bodys ever taken the challenge before...HERE! You win."
									p.checkQuestProgress("Lord")
								if("No! I'm sorry.")
									alert("The Lord squints his eyes at you and turns his back")
						if("Give back the girls baby")
							switch(input("Lord: Never! You'll have to take it!","Lord")in list("So it shall be."))
								if("So it shall be.")
									usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=red>Lord</span> </b>:<font color=white> You want to...fight me? Uh, no bodys ever taken the challenge before...HERE! You win."
									p.checkQuestProgress("Lord")
					return
				else if(pointer.stage == 2)
					usr << "You won, go back to the girl."
					return

			usr << "He looks like a mix between Count Choculah and an elf. You decide not to bother him."

turf
	lever
		icon='lever.dmi'
		density=1
		verb
			Examine()
				set src in oview(3)
				alert("You see that the lever is connected to a small trapdoor in the wall")
			Pull_Lever()
				set src in oview(1)
				switch(input("Pull the lever?","Pull the lever?")in list("Yes","No"))
					if("Yes")
						alert("You pull the lever")
						alert("The trapdoor in the wall slowly creeks shut")
						var/mob/Player/p = usr
						p.checkQuestProgress("Lever")
						for(var/turf/lever/L in oview())
							flick("pull",L)
					if("No")
						return

mob/var/talkedtobunny

mob/TalkNPC/quest
	easterbunny
		icon_state = "easter"
		name= "Easter Bunny"
		density=1
		Immortal=1
		questPointers = "Sweet Easter"
		verb
			Examine()
				set src in oview(3)
				usr << "The friendly Easter Bunny!!"

		Talk()
			set src in oview(3)
			..()
			var/mob/Player/p = usr
			var/questPointer/pointer = p.questPointers["Sweet Easter"]
			if(pointer)
				if(pointer.stage)
					if(p.checkQuestProgress("Easter Bunny"))
						alert("You throw the bag of chocolates to the Easter Bunny.")
						sleep(20)
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=#FF3399>Easter Bunny</span> </b>:<font color=white> OH THANK YOU THANK YOU THANK YOU!!!"
						sleep(30)
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=#FF3399>Easter Bunny</span> </b>:<font color=white> Oh! Now Easter can continue! THANK YOU!!!"
						sleep(30)
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=#FF3399>Easter Bunny</span> </b>:<font color=white> I don't have much to give you. Although I can give you this!"
						alert("The Easter Bunny hands you an Easter Wand")
						sleep(20)
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=#FF3399>Easter Bunny</span> </b>:<font color=white> ENJOY!"
					else
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=#FF3399>Easter Bunny</span> </b>:<font color=white> Did you find the chocolate yet!!?!"
						sleep(30)
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=Red>[usr]</span> </b>:<font color=white> No, not yet. Sorry."
						sleep(20)
						alert("The Easter Bunny frowns")
						sleep(20)
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=#FF3399>Easter Bunny</span> </b>:<font color=white> Oh...okay."
					return

			if(!pointer)
				alert("The Easter Bunny frowns")
				switch(input("Your response","Respond")in list("What's wrong","*Walk away slowly*"))
					if("What's wrong")
						usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=#FF3399>Easter Bunny</span> </b>:<font color=white> It's just that, I made these brand new chocolates, that are a MILLION! times better than ordinary chocolate. And they seem to have went missing."
						alert("The Easter Bunny frowns")
						switch(input("Your Response","Respond")in list("Do you have any idea who did this?","Well quit talking to me and get to finding them!"))
							if("Do you have any idea who did this?")
								usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=#FF3399>Easter Bunny</span> </b>:<font color=white> No...I have no idea at all. I mean, who would want to hurt Easter!"
								sleep(30)
								switch(input("Easter Bunny: It's sad","Easter Bunny")in list("Don't worry, i'll find them for you","Oh well, good luck!"))
									if("Don't worry, i'll find them for you")
										usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=#FF3399>Easter Bunny</span> </b>:<font color=white> Oh, Thank you so much! I will be here waiting. Oh please hurry!"
										p.startQuest("Sweet Easter")
									if("Oh well, good luck!")
										return

							if("Well quit talking to me and get to finding them!")
								alert("The Easter Bunny looks away")
								return

					if("*Walk away slowly*")
						alert("You back away slowly")
						step_away(usr, src)
			else
				usr << "\n<span style=\"font-size:2;\"><font color=red><b> <font color=#FF3399>Easter Bunny</span> </b>:<font color=white> THANKS AGAIN!"

mob/var/talkedzombie=0

obj
	chocolatebar
		name="Chocolate Bar"
		icon='chocolate_bar.dmi'
		icon_state="1"
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

	tootsieroll
		name="Tootsie Roll"
		icon='tootsie_roll.dmi'
		icon_state="2"
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

	candycorn
		name="Candy Corn"
		icon='candy_corn.dmi'
		icon_state="3"
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

	caramelapple
		name="Caramel Apple"
		icon='caramel_apple.dmi'
		icon_state="4"
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

obj
	Halloween_Bucket
		icon='halloween_bucket.dmi'
		icon_state="bag1"
		verb
			Take_Out_Candy()
				hearers() << "<span style=\"color:#FFA600;\"><b>[usr] pulls some candy out of \his halloween bucket!</b></span>"
				var/rnd=rand(1,4)
				if(rnd==1)
					var/obj/chocolatebar/p = new
					p:loc = locate(src.x,src.y-1,src.z)
					p:owner = "[usr.key]"
				if(rnd==2)
					var/obj/tootsieroll/p = new
					p:loc = locate(src.x,src.y-1,src.z)
					p:owner = "[usr.key]"
				if(rnd==3)
					var/obj/candycorn/p = new
					p:loc = locate(src.x,src.y-1,src.z)
					p:owner = "[usr.key]"
				if(rnd==4)
					var/obj/caramelapple/p = new
					p:loc = locate(src.x,src.y-1,src.z)
					p:owner = "[usr.key]"


		verb
			Use()
				hearers() << "<span style=\"color:#FFA600;\"><b>[usr] pulls out \his halloween bucket.</b></span>"
				usr.overlays+=image('halloween-bag.dmi')

		verb
			Take_Off()
				hearers() << "<span style=\"color:#FFA600;\"><b>[usr] puts away \his halloween bucket.</b></span>"
				usr.overlays-=image('halloween-bag.dmi')
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Destroy()
				switch(input("Are you sure you want to destroy this?","Destroy?")in list("Yes","No"))
					if("Yes")
						del src
						usr.overlays-=image('halloween-bag.dmi')
					if("No")
						return

			Examine()
				set src in view(3)
				usr << "<span style=\"color:#FFA600;\">It's a Halloween Bucket from 2011!</span>"



obj
	ground_silver_knife
		name="Silver Knife"
		icon='halloween.dmi'
		icon_state="silver knife"
		verb
			Take()
				set src in oview(2)
				if(locate(/obj/Stupid/silver_knife) in usr.contents)
					usr << "<b>You already have a Silver Knife!</b>"
				else if(locate(/obj/items/wearable/halloween_bucket) in usr.contents)
					usr << errormsg("You've already completed this quest!")
				else
					hearers() << "<b>[usr] picks up the Silver Knife.</b>"
					new/obj/Stupid/silver_knife(usr)
					usr:Resort_Stacking_Inv()

obj
	ground_blessed_torch
		name="Blessed Torch"
		icon='halloween.dmi'
		icon_state="torch"
		verb
			Take()
				set src in oview(2)
				if(locate(/obj/Stupid/Blessed_Torch) in usr.contents)
					usr << "<b>You already have a Blessed Torch!</b>"
				else if(locate(/obj/items/wearable/halloween_bucket) in usr.contents)
					usr << errormsg("You've already completed this quest!")
				else
					hearers() << "<b>[usr] picks up the Blessed Torch.</b>"
					new/obj/Stupid/Blessed_Torch(usr)
					usr:Resort_Stacking_Inv()

obj
	ground_holy_grenade
		name="Holy Grenade"
		icon='halloween.dmi'
		icon_state="bomb"
		verb
			Take()
				set src in oview(2)
				if(locate(/obj/Stupid/Holy_Grenade) in usr.contents)
					usr << "<b>You already have a Holy Grenade!</b>"
				else if(locate(/obj/items/wearable/halloween_bucket) in usr.contents)
					usr << errormsg("You've already completed this quest!")
				else
					hearers() << "<b>[usr] picks up the Holy Grenade.</b>"
					new/obj/Stupid/Holy_Grenade(usr)
					usr:Resort_Stacking_Inv()

obj
	Stupid/silver_knife
		name="Silver Knife"
		icon='halloween.dmi'
		icon_state="silver knife"

obj
	Stupid/Blessed_Torch
		icon='halloween.dmi'
		icon_state="torch"

obj
	Stupid/Holy_Grenade
		icon='halloween.dmi'
		icon_state="bomb"


mob/TalkNPC
	Zombie
		NPC=1
		bumpable=0
		Immortal=1
		icon='MaleZombie.dmi'
		icon_state=""
		Gm=1

		Talk()
			set src in oview(3)
			if(usr.talkedzombie==2)
				usr << npcsay("Thanks for helping! Those innocent people will be slain soon!")
			else
				if(usr.talkedzombie==1)
					usr << npcsay("Did you find everything!?")
					if(locate(/obj/Stupid/silver_knife) in usr.contents)
						if(locate(/obj/Stupid/Blessed_Torch) in usr.contents)
							if(locate(/obj/Stupid/Holy_Grenade) in usr.contents)
								for(var/obj/O in usr.contents)
									if(istype(O,/obj/Stupid))
										del(O)
								usr << npcsay("You got everything! You've done enough, leave the rest to me. Thanks!")
								usr << npcsay("Here is your reward.")
								new/obj/items/wearable/halloween_bucket(usr)
								usr:Resort_Stacking_Inv()
								usr.talkedzombie=2
							else
								usr << npcsay("You don't have the Holy Grenade!")
						else
							usr << npcsay("You don't have the Blessed Torch!")
					else
						usr << npcsay("You don't have the Silver Knife!")
				else
					usr << npcsay("Hello. In a fit of rage I believe I have gone and infected 7 people last night with this curse I currently have bestowed upon me. If something is not done about this, you will be looking at a rather large problem.")
					switch(input("Your response?","Make a selection")in list("Why do you want to kill other zombies?","What can I do to help?"))
						if("Why do you want to kill other zombies?")
							usr << npcsay("Simple! I don't like competition, I'm a lazy zombie.")
							switch(input("Your response?","Make a selection")in list("What can I do to help?"))
								if("What can I do to help?")
									usr << npcsay("There are other Zombie killers in the area, you'll need their tools. One in Diagon Alley, one in Hogwarts, and one in Hogsmeade. You will be looking for a silver knife, blessed torch, and a holy grenade. Hurry and return when you've found what we need!")
									usr.talkedzombie=1
						if("What can I do to help?")
							usr << npcsay("There are other Zombie killers in the area, you'll need their tools. One in Diagon Alley, one in Hogwarts, and one in Hogsmeade. You will be looking for a silver knife, blessed torch, and a holy grenade. Hurry and return when you've found what we need!")
							usr.talkedzombie=1
		New()
			..()
			wander()
		proc/wander()

			while(src)
				walk_rand(src,rand(5,30))
				sleep(5)


image/questMarker
	icon    = 'QuestMarker.dmi'
	pixel_y = 32

area
	var/tmp/list/questMobs

	Entered(atom/movable/Obj, atom/OldLoc)
		if(isplayer(Obj))
			var/mob/Player/p = Obj
			p.updateQuestMarkers()
		.=..()

mob/Player
	var/tmp/list/images


	proc
		addImage(i_Name, image/i_Image)
			client.images += i_Image

			if(!images)	images = list()
			images[i_Name]     = i_Image

		removeImage(i_Name)
			if(!(i_Name in images)) return
			client.images -= images[i_Name]
			images        -= i_Name

			if(!images.len) images = null

		removeAllImages()
			if(images)
				for(var/i in images)
					removeImage(i)

		questMarker(mob/TalkNPC/quest/i_Mob)
			if(!i_Mob.questPointers) return

			removeImage(i_Mob.name)

			var/state
			if(islist(i_Mob.questPointers))
				for(var/p in i_Mob.questPointers)
					var/questPointer/pointer = questPointers[p]
					if(!pointer)
						state = "nonactive"
					else if(pointer.stage)
						var/quest/q = quest_list[p]
						if(pointer.stage == q.stages.len)
							state = "completed"
						else
							state = "active"
					else
						var/quest/q = quest_list[p]
						if(q.repeat)
							state = "daily"

					if(state) break
			else
				var/questPointer/pointer = questPointers[i_Mob.questPointers]
				if(!pointer)
					state = "nonactive"
				else if(pointer.stage)

					var/quest/q = quest_list[i_Mob.questPointers]
					if(pointer.stage == q.stages.len)
						state = "completed"
					else state = "active"
				else
					var/quest/q = quest_list[i_Mob.questPointers]
					if(q.repeat)
						state = "daily"

			if(state)
				var/image/i = image('QuestMarker.dmi', i_Mob, state)
				i.pixel_y = 36
				addImage(i_Mob.name, i)

		updateQuestMarkers()
			if(!loc) return
			var/area/a = loc.loc

			removeAllImages()
			if(a.questMobs)
				for(var/mob/TalkNPC/quest/m in a.questMobs)
					questMarker(m)

obj/items/demonic_essence
	icon       = 'jokeitems.dmi'
	icon_state = "DarknessPowder"
	max_stack  = 1

	Take()
		set src in oview(1)
		var/mob/Player/p = usr
		if(p.checkQuestProgress("Demonic Essence"))
			p << infomsg("You touch the demonic essence and it fades, you feel as if you carry it inside your soul.")
			loc = null
		else
			p << errormsg("You don't need this.")

	New()
		..()

		emit(loc    = src, ptype  = /obj/particle/magic,
						   amount = 5,
						   angle  = new /Random(1, 359),
						   speed  = 2,
						   life   = new /Random(20,25))

		animate(src, color = rgb(255, 0, 0), time = 10, loop = -1)
		animate(color = rgb(255, 0, 255), time = 10)

		spawn(300)
			loc = null

obj/items/blood_sack
	icon       = 'jokeitems.dmi'
	icon_state = "Blood Sack"
	max_stack  = 1

	Take()
		set src in oview(1)
		var/mob/Player/p = usr
		if(p.checkQuestProgress("Blood Sack"))
			p << infomsg("You take the acromantula's blood sack.")
			loc = null
		else
			p << errormsg("You don't need this.")

	New()
		..()

		emit(loc    = src, ptype  = /obj/particle/magic,
						   amount = 5,
						   angle  = new /Random(1, 359),
						   speed  = 2,
						   life   = new /Random(20,25))

		spawn(300)
			loc = null


var/list/quest_list
var/list/questRewards

proc
	init_quests()
		quest_list   = list()
		questRewards = list()
		for(var/t in typesof(/quest/) - /quest)
			if(findtext("[t]", "stage")) continue
			var/quest/q = new t(1)
			quest_list[q.name] = q


quest
	var/name
	var/list/stages
	var/desc
	var/list/reqs
	var/questReward/reward
	var/repeat

	New(var/isQuest = 0)
		..(isQuest)

		if(isQuest)
			stages = list()
			for(var/t in typesof(type) - type)
				stages += new t

			if(reward)
				if(!("[reward]" in questRewards))
					questRewards["[reward]"] = new reward

				reward = questRewards["[reward]"]

questReward
	var/gold
	var/exp
	var/items

	clanReward
		var/points
		var/max    = 1

		get(mob/Player/p)
			..(p)

			if(points)
				p.addRep(points, !max, max)

	proc/get(mob/Player/p)
		if(gold)
			p.gold.add(gold)
			p << infomsg("You receive [comma(gold)] gold.")
		if(exp)
			if(p.level < lvlcap)
				p << infomsg("You receive [comma(exp)] experience.")
			p.addExp(exp)
		if(items)
			if(islist(items))
				for(var/t in items)
					var/obj/o = new t (p)
					p << infomsg("You receive [o.name].")
			else
				var/obj/o = new items (p)
				p << infomsg("You receive [o.name].")
			p.Resort_Stacking_Inv()

questPointer
	var/stage
	var/list/reqs
	var/time
	var/track = TRUE

	proc/setReqs(var/list/L)
		reqs = L.Copy()


mob/Player
	var/list/questPointers = list()
	var/tmp/showQuestType = 0 // 0 - active, 1 - complete, 2 - all

	verb
		showQuestType()
			set hidden = 1
			set name = ".showQuestType"

			switch(++showQuestType)
				if(1)
					winset(src, "Quests.buttonQuestDisplay", "text=\"Completed Quests\"")
				if(2)
					winset(src, "Quests.buttonQuestDisplay", "text=\"All Quests\"")
				if(3)
					showQuestType = 0
					winset(src, "Quests.buttonQuestDisplay", "text=\"Active Quests\"")
			buildQuestBook()

	proc
		buildQuestBook()
			src << output(null, "Quests.outputQuests")
			var/i = 0
			var/completed = 0
			for(var/questName in questPointers)
				var/questPointer/pointer = questPointers[questName]

				if((showQuestType == 0 && pointer.stage) || (showQuestType == 1 && !pointer.stage) || showQuestType == 2)
					i++
					src << output("<a href=\"?src=\ref[src];action=selectQuest;questName=[questName]\">[questName]</a>", "Quests.gridQuests:1,[i]")
					if(pointer.stage) src << output("<a href=\"?src=\ref[src];action=trackQuest;questName=[questName]\">Toggle</a>", "Quests.gridQuests:2,[i]")
					else src << output(null, "Quests.gridQuests:2,[i]")
					if(i == 1)
						displayQuest(questName)

				var/quest/q = quest_list[questName]
				if(pointer && (!pointer.stage || q.repeat)) completed++

			var/percent = round((completed /  quest_list.len) * 100, 1)
			var/header  = "You completed [percent]% of the available quests.\nAdventure Time: [getPlayTime()]."
			winset(src, null, "Quests.gridQuests.cells=2x[i];Quests.labelText.text=\"[header]\"")

			winshow(src, "Quests", 1)

		displayQuest(var/questName)

			src << output(null, "Quests.outputQuests")

			var/questPointer/pointer = questPointers[questName]
			var/quest/q              = quest_list[questName]

			src << output("<b><u>[q.name]</u></b><br>", "Quests.outputQuests")
			src << output("[q.desc]<br>", "Quests.outputQuests")

			for(var/i = 1 to q.stages.len)
				if(pointer.stage && pointer.stage < i) break
				var/quest/stage = q.stages[i]
				src << output("[stage.desc]<br>", "Quests.outputQuests")

			if(pointer.time)
				src << output("Completed on: <b>[time2text(pointer.time, "DD Month")]</b><br>", "Quests.outputQuests")


		startQuest(questName)
			if(questName in quest_list)
				var/quest/q = quest_list[questName]
				var/quest/stage = q.stages[1]

				var/questPointer/pointer = new
				pointer.setReqs(stage.reqs)
				pointer.stage = 1

				questPointers[questName] = pointer

				Interface.Update()
				src << infomsg(q.desc)
				src << infomsg(stage.desc)

				updateQuestMarkers()

		trackQuest(var/questName)
			var/questPointer/pointer = questPointers[questName]

			if(pointer.track)
				src << infomsg("[questName] will no longer be tracked on screen.")
				pointer.track = FALSE
			else
				src << infomsg("[questName] will be tracked on screen.")
				pointer.track = TRUE

			Interface.Update()


		questProgress(questName, args, trackedOnly=TRUE)
			var/questPointer/pointer = questPointers[questName]
			if(!pointer.stage)                return
			if(!pointer.track && trackedOnly) return 2

			var/quest/q = quest_list[questName]

			if((args in pointer.reqs) && pointer.reqs[args] > 0)
				pointer.reqs[args]--
				. = 1

				if(pointer.reqs[args] <= 0)
					pointer.reqs -= args

			if(!pointer.reqs.len)
				pointer.stage++
				if(pointer.stage <= q.stages.len)
					var/quest/stage = q.stages[pointer.stage]
					src << infomsg(stage.desc)
					pointer.setReqs(stage.reqs)
				else // quest completed
					if(q.reward) q.reward.get(src)
					pointer.reqs  = null
					pointer.stage = null
					pointer.time = world.realtime
				updateQuestMarkers()


		checkQuestProgress(args)
			var/found = FALSE

			var/list/untracked = list()
			for(var/questName in questPointers)
				if(!(questName in quest_list)) continue

				found = questProgress(questName, args)
				if(found == 2)
					found = 0
					untracked += questName
				else if(found == 1) break

			if(!found && untracked.len)
				for(var/questName in untracked)
					found = questProgress(questName, args, FALSE)
					if(found) break
				untracked = null
			if(found) Interface.Update()

			return found



mob/Player/Topic(href, href_list[])
	if(href_list["action"] == "selectQuest")
		var/questName = href_list["questName"]
		displayQuest(questName)
	else if(href_list["action"] == "trackQuest")
		var/questName = href_list["questName"]
		trackQuest(questName)
	.=..()

mob/Player
	var/tmp/interface/Interface

client/New()
	..()

interface
	var/obj/hud/screentext/quest/quest
	var/mob/Player/parent

	New(mob/Player/p)
		parent = p

		new /hudobj/PMHome(null, parent.client, null, show=1)
		new /hudobj/spellbook(null, parent.client, null, show=1)
		new /hudobj/questbook(null, parent.client, null, show=1)

		Update()

		..()

	proc/Update()
		if(parent.HideQuestTracker && quest)
			parent.client.screen -= quest
			quest = null
		else if(!parent.HideQuestTracker && !quest)
			quest = new
			parent.client.screen += quest

		if(quest)
			quest.update(parent)

	proc/Resize(width, height)

obj/hud/screentext

	questPath
		mouse_over_pointer = MOUSE_HAND_POINTER
		mouse_opacity = 2
		maptext = "<b>\[Path]<b>"
		maptext_width  = 44
		maptext_height = 32

		Click()
			..()
			var/mob/Player/p = usr
			if(p.pathdest && p.pathdest:tag == name)
				p.pathdest = null
				p.removePath()
			else
				p.classpathfinding = 0

				p.pathdest = locate(name)
				if(!p.pathTo(p.pathdest))
					p.pathdest = null
					p << errormsg("You don't know where you are, pathfinding magic is impossible here.")

	quest
		screen_loc = "WEST+1,SOUTH+1"
		maptext_width  = 320
		maptext_height = 320

		proc/update(mob/Player/p)
			maptext = null
			var/count        = 4
			var/offset       = 0
			var/pixel_offset = 29

			for(var/obj/hud/screentext/questPath/path in p.client.screen)
				p.client.screen -= path
			var/removePath = p.pathdest ? TRUE : FALSE

			for(var/questName in p.questPointers)
				var/questPointer/pointer = p.questPointers[questName]
				if(!pointer.stage) continue
				if(!pointer.track) continue

				count--
				if(count < 0) break

				pixel_offset += (pointer.reqs.len) * 14 + 18
				if(pixel_offset >= 32)
					pixel_offset -= 32
					offset++

				if(pointer.reqs.len == 1)
					var/area/a = getArea(locate(pointer.reqs[1]))
					if(a && a.region)
						var/obj/hud/screentext/questPath/path = new
						path.name = pointer.reqs[1]
						path.screen_loc = "WEST+7,SOUTH+[offset]:[pixel_offset]"
						path.maptext = "<span style=\"color:[p.mapTextColor];\">[path.maptext]</span>"
						p.client.screen += path

						if(removePath && path.name == p.pathdest:tag)
							removePath = FALSE

				var/reqsText = ""
				for(var/i in pointer.reqs)
					reqsText += "  - [i]: [pointer.reqs[i]]<br>"

				maptext = "<b>[questName]</b><br>[reqsText][maptext]"

			if(maptext)
				maptext = "<span style=\"color:[p.mapTextColor];\">[maptext] </span>"

			if(removePath)
				p.pathdest = null
				p.removePath()

proc/getArea(atom/a)
	if(a)
		if(istype(a, /atom/movable) && a.loc) return a.loc.loc
		if(isturf(a))                         return a.loc

mob/Player
	var/mapTextColor = "#ffffff"
	verb
		setInterfaceColor(c as color)
			set hidden=1
			set name = ".setInterfaceColor"
			if(!c) return

			mapTextColor = "[c]"
			Interface.Update()

mob/Player
	var
		tmp
			logintime = 0
		playedtime = 0
	proc
		getPlayTime()
			var
				playtime = (world.realtime - logintime) + playedtime
				sec      = round(playtime / 10)
				min      = round(sec      / 60)
				hour     = round(min      / 60)
				day      = round(hour     / 24)
			sec  -= min  * 60
			min  -= hour * 60
			hour -= day  * 24
			var/msg = ""
			if(day)
				msg += "[day] [day > 1 ? "days" : "day"]"
			if(hour)
				if(msg)msg += ", "
				msg += "[hour] [hour > 1 ? "hours" : "hour"]"
			if(min)
				if(msg)msg += ", "
				msg += "[min] [min > 1 ? "minutes" : "minute"]"
			if(sec)
				if(msg)msg += " and "
				msg += "[sec] [sec > 1 ? "seconds" : "second"]"
			return msg