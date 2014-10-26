/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
obj
	questbook
		name="Quest Book"
		icon='questbook.dmi'
		verb
			Read_Quest_Book()
				if(usr.quests>=2)
					usr << "\n<b><u>You have completed [usr.quests] Quests</b></u>"
					if(usr.ratquest==1)
						usr << "-You completed Tom the Barman's <b>Rats in the Cellar</b> quest."
					if(usr.babyquest==1)
						usr << "-You completed the little girl's <b>Stolen by the Lord</b> quest."
					if(usr.talkedtoalyssa==2)
						usr << "-You completed Alyssa's <b>Make a Potion</b> quest."
					if(usr.talkedtofred==3)
						usr << "-You completed Fred's <b>On House Arrest</b> quest."
				if(usr.quests==1)
					usr << "\n<b><u>You have completed [usr.quests] Quest</b></u>"
					if(usr.ratquest==1)
						usr << "-You completed Tom the Barman's <b>Rats in the Cellar</b> quest."
					if(usr.babyquest==1)
						usr << "-You completed the little girl's <b>Stolen by the Lord</b> quest."
					if(usr.talkedtoalyssa==2)
						usr << "-You completed Alyssa's <b>Make a Potion</b> quest."
					if(usr.talkedtofred==3)
						usr << "-You completed Fred's <b>On House Arrest</b> quest."
				if(usr.quests==0)
					usr << "\n<b><u>You have completed [usr.quests] Quests</b></u>"
					if(usr.quests==0)
						usr << "-You have completed no quests."
					else
						return

mob
	var
		palmer
		quests
		talktotom
		ratquest

mob/TalkNPC
	professor_palmer
		icon = 'misc.dmi'
		icon_state="palmer"
		name="Professor Palmer"
		Immortal=1
		Gm=1

		Talk()
			set src in oview(1)
			if(usr.palmer==1)
				switch(input("Palmer: Are you here for a new book?","New book?")in list("Yes","No"))
					if("Yes")
						if(locate(/obj/questbook) in usr.contents)
							usr << "\nYou already have a quest book in your inventory!"
							return
						usr << "\nAlright, here you are."
						alert("Professor Palmer hands you a new Quest Book")
						new/obj/questbook(usr)
						usr.Resort_Stacking_Inv()
					if("No")
						usr << "\nAlright, have a good day."
						return
			else
				usr.palmer=1
				usr << "Hello there young student. I am a Former Professor at Hogwarts. My name is Professor Palmer."
				sleep(20)
				usr << "<br>I was asked by the Headmaster to teach you about quests and the quest book. Oh, and to give you this."
				alert("Professor Palmer hands you a small black book")
				new/obj/questbook(usr)
				usr.quests=0
				usr << "<br>This is your quest book, inside you keep track of all your accomplished quests."
				sleep(50)
				usr << "<br>If you lose your quest book, you can come back here and get a new one."
				sleep(30)
				usr << "<br>How would you like to put something in that book?"
				sleep(30)
				usr << "<br>If you're interested, I have a friend who could use your help. Tom the Barman in Diagon Alley could use your help, go check it out."
				usr.talktotom=1

mob/var/talkedtogirl
mob/var/babyquest
mob/var/babyfound
mob/var/foundlord

mob/TalkNPC
	Lisa
		icon='Misc Mobs.dmi'
		icon_state="Lisa"
		density=1
		Immortal=1

		Talk()
			set src in oview(3)
			if(usr.talkedtogirl==1)
				usr << "\nHi there. What can I do for you?"
				sleep(30)
				switch(input("What can I do for you?","Lisa")in list("Anything interesting happening?","Do you live here?","Nevermind"))
					if("Anything interesting happening?")
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Lisa</font> [GMTag]</b>:<font color=white> Nothing really."
						sleep(30)
						usr << "<font size=2><font color=red><b>[Tag] <font color=red>Lisa</font> [GMTag]</b>:<font color=white> Actually, yesterday I saw this guy holding a bag with something moving inside. It looked pretty suspicious. I guess it was nothing though."
						switch(input("Lisa: Don't you think its suspcious?","Lisa")in list("Which way was he going?","Yeah thats pretty suspcious","Its not that suspicious"))
							if("Which way was he going?")
								usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Lisa</font> [GMTag]</b>:<font color=white> I'm pretty sure I saw him going south."
							if("Yeah thats pretty suspcious")
								alert("Lisa nods")
							if("Its not that suspicious")
								usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Lisa</font> [GMTag]</b>:<font color=white> I guess"
					if("Do you live here?")
						alert("Lisa chuckles")
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Lisa</font> [GMTag]</b>:<font color=white> Of course I live here! Why else would I be here."
					if("Nevermind")
						alert("Lisa smiles.")
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Lisa</font> [GMTag]</b>:<font color=white> Alright."
			else
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Lisa</font> [GMTag]</b>:<font color=white> Hi there. What can I do for you?"
				sleep(30)
				switch(input("What can I do for you?","Lisa")in list("Anything interesting happening?","Do you live here?","Nevermind"))
					if("Anything interesting happening?")
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Lisa</font> [GMTag]</b>:<font color=white> Nothing really exciting right now."
					if("Do you live here?")
						alert("Lisa chuckles")
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Lisa</font> [GMTag]</b>:<font color=white> Of course I live here! Why else would I be here."
					if("Nevermind")
						alert("Lisa smiles.")
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Lisa</font> [GMTag]</b>:<font color=white> Alright."

mob/var/talkedtofred

mob/TalkNPC
	Fred
		icon='Misc Mobs.dmi'
		icon_state="Fred"
		density=1
		Immortal=1

		Talk()
			set src in oview(3)
			if(usr.talkedtofred==3)
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> Thanks again!"
			else
				alert("Fred waves his hands in the air")
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> Help help!"
				switch(input("Fred: HELP HELP!","Fred")in list("What happened?","Shh keep it down","*Ignore Fred*"))
					if("What happened?")
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> Some strange man did this to me!"
						sleep(30)
						switch(input("Your response","Fred")in list("Why?","What did he look like?","Which way did he go","Let's get you out of there"))
							if("Why?")
								usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> Well he was walking past my house carrying this large sack."
								sleep(20)
								usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> It looked like there was a person inside. So I confronted him and asked him what was inside."
								sleep(30)
								usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> His only response was casting a spell and locking me in here."
								alert("Fred frowns")
								return
							if("What did he look like?")
								usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> I couldn't tell exactly."
								sleep(20)
								usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> He was wearing a pretty dark cloak."
							if("Which way did he go")
								usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> I'm not sure, he knocked me out and when I woke up, I was in here."
							if("Let's get you out of there")
								if(usr.talkedtofred==1)
									usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> Quickly now, go get my wand from the deposit box in Gringott's bank."
									sleep(30)
									switch(input("Fred: Quickly now","Fred")in list("Where is Gringott's again?","I'm on my way"))
										if("Where is Gringott's again?")
											usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> Gringott's Bank is found in Diagon Alley. You can find Diagon Alley near Azkaban Prison."
										if("I'm on my way")
											return

								if(usr.talkedtofred==2)
									alert("You show Fred the wand")
									usr.talkedtofred=3
									usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> YES! You got it!"
									sleep(30)
									usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> Quickly! Use the wand to get me out of here!"
									sleep(20)
									alert("You point the wand at the barriers")
									usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>[usr]</font> [GMTag]</b>:<font color=white> <b>Finte Incantum!</b>"
									usr.loc=locate(89,33,8)
									usr.delinterwand=1
									usr.quests+=1
									usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> Finally! I'm free!!!"
									alert("Fred jumps up and down")
									usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> Thank you so much. You can keep that wand if you'd like."


								else
									if(locate(/obj/items/freds_key) in usr.contents)
										usr << "\nYou already have Fred's Key in your inventory!"
										return
									else if(usr.bank && locate(/obj/items/freds_key)in usr.bank.items)
										usr << "\nYou already have Fred's Key in your bank vault!"
										return
									else
										usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> Oh thank you!"
										sleep(30)
										usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>[usr]</font> [GMTag]</b>:<font color=white> Now how will we get you out..."
										sleep(30)
										usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> There is a wand of mine. It is in my deposit box at Gringotts. Here"
										alert("Fred tosses the key to you")
										new/obj/items/freds_key(usr)
										usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Fred</font> [GMTag]</b>:<font color=white> Go get it from Gringotts, it can get me out of here."
										alert("You nod")

/**********************************

talkedtofred=1  -  go to gringotts
talkedtofred=2  -  got the wand
talkedtofred=3  -  done

**********************************/


mob/TalkNPC
	Girl
		icon='Misc Mobs.dmi'
		icon_state="girl"
		density=1
		Immortal=1

		verb
			Examine()
				set src in oview(3)
				usr << "A local townsgirl."

		Talk()
			set src in oview(3)
			if(usr.talkedtogirl==2)
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Girl</font> [GMTag]</b>:<font color=white> Thanks again!!!"
				sleep(30)
				alert("The girl smiles bigger than any you've ever seen.")
				return
			if(usr.talkedtogirl==1)
				alert("The girl looks up at you quickly")
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Girl</font> [GMTag]</b>:<font color=white> Did you find him yet?!?"
				if(usr.babyfound==1)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>[usr]</font> [GMTag]</b>:<font color=white> Yep, I found him. Here you are."
					alert("You hand the little baby boy to the girl")
					alert("The girl throws her arms around you")
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Girl</font> [GMTag]</b>:<font color=white> THANK YOU THANK YOU THANK YOU!"
					alert("You find yourself smiling slightly")
					usr << "\n<font size=2><ont color=red><b>[Tag] <font color=red>Girl</font> [GMTag]</b>:<font color=white> Here, this is my allowance that I saved up, you can have it."
					alert("The girl hands you a hand full of gold.")
					alert("You aquired 5,250 gold.")
					if(usr.talkedtogirl==2)return
					usr.quests+=1
					usr.gold+=5250
					usr.babyquest=1
					usr.talkedtogirl=2
					usr.babyfound=2
					return
				else
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>[usr]</font> [GMTag]</b>:<font color=white> Not yet, sorry."
					alert("The girl frowns.")
			else
				usr << "\n\n<font size=2><font color=red><b>[Tag] <font color=red>Girl</font> [GMTag]</b>:<font color=white> Help help!"
				alert("The girl waves her arms in distress")
				sleep(30)
				switch(input("Girl: Are you here to help me?","Help?")in list("Yes","No"))
					if("Yes")
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Girl</font> [GMTag]</b>:<font color=white> Oh THANK YOU!"
						sleep(20)
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Girl</font> [GMTag]</b>:<font color=white> My mom left to go to the store, and told me to watch my little brother."
						sleep(30)
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Girl</font> [GMTag]</b>:<font color=white> I needed to get something from my room and when I came back, my little brother was gone."
						alert("The girl bursts into tears")
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>[usr]</font> [GMTag]</b>:<font color=white> Well where did you see him last?"
						alert("The girl scratches her head")
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Girl</font> [GMTag]</b>:<font color=white> Uhm, I'm not sure, I just came back and he was gone."
						sleep(30)
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>[usr]</font> [GMTag]</b>:<font color=white> Maybe I will ask some of the towns people around here."
						alert("The girl nods somberly")
						usr.talkedtogirl=1
						foundlord = 1
					if("No")
						alert("The girl frowns")

mob
	Baby
		icon='Misc Mobs.dmi'
		icon_state="baby"
		density=1
		Immortal=1
		verb
			Examine()
				set src in oview(5)
				usr << "A widdle baby."

mob/TalkNPC
	Lord
		icon='Misc Mobs.dmi'
		icon_state="Lord"
		density=1
		Immortal=1

		verb
			Examine()
				set src in oview(3)
				usr << "He looks like a mix between Count Choculah and an elf."

		Talk()
			set src in oview(3)
			if(foundlord == 1)
				switch(input("Lord: How did you get here!","Lord")in list("Your maze was pretty lame","Give back the girls baby"))
					if("Your maze was pretty lame")
						switch(input("Lord: WHAT! NEVER!!! I will demolish you!","Lord")in list("Bring it on!","No! I'm sorry."))
							if("Bring it on!")
								usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Lord</font> [GMTag]</b>:<font color=white> You want to...fight me? Uh, no bodys ever taken the challenge before...HERE! You win."
							//	alert("The Lord vanishes in a puff of smoke leaving the baby laying on the floor. You pick up the baby and decide to high tail it out before he returns.")
								usr.babyfound=1
								usr.foundlord=2
							//	usr.loc=locate(74,89,3)
							if("No! I'm sorry.")
								alert("The Lord squints his eyes at you and turns his back")
					if("Give back the girls baby")
						switch(input("Lord: Never! You'll have to take it!","Lord")in list("So it shall be."))
							if("So it shall be.")
								usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Lord</font> [GMTag]</b>:<font color=white> You want to...fight me? Uh, no bodys ever taken the challenge before...HERE! You win."
							//	alert("The Lord vanishes in a puff of smoke leaving the baby laying on the floor. You pick up the baby and decide to high tail it out before he returns.")
								usr.babyfound=1
								usr.foundlord=2
							//	usr.loc=locate(74,89,3)
			else if(foundlord == 2 && talkedtogirl != 2)
				usr << "You won, go back to the girl."
			else
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
				if(usr.ratpoints>=30)
					switch(input("Pull the lever?","Pull the lever?")in list("Yes","No"))
						if("Yes")
							alert("You pull the lever")
							alert("The trapdoor in the wall slowly creeks shut")
							usr.talktotom=2
							for(var/turf/lever/L in oview())
								flick("pull",L)
						if("No")
							return
				else
					usr << "Maybe you should go clear out more rats before you pull the lever."

mob/var/talkedtobunny

mob/TalkNPC
	easterbunny
		icon='Easter Stuff.dmi'
		name= "Easter Bunny"
		density=1
		Immortal=1

		verb
			Examine()
				set src in oview(3)
				usr << "The friendly Easter Bunny!!"

		Talk()
			set src in oview(3)
			if(usr.talkedtobunny==1)
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=#FF3399>Easter Bunny</font> [GMTag]</b>:<font color=white> Did you find the chocolate yet!!?!"
				sleep(30)
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=Red>[usr]</font> [GMTag]</b>:<font color=white> No, not yet. Sorry."
				sleep(20)
				alert("The Easter Bunny frowns")
				sleep(20)
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=#FF3399>Easter Bunny</font> [GMTag]</b>:<font color=white> Oh...okay."

			if(usr.talkedtobunny==2)
				alert("You throw the bag of chocolates to the Easter Bunny.")
				sleep(20)
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=#FF3399>Easter Bunny</font> [GMTag]</b>:<font color=white> OH THANK YOU THANK YOU THANK YOU!!!"
				sleep(30)
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=#FF3399>Easter Bunny</font> [GMTag]</b>:<font color=white> Oh! Now Easter can continue! THANK YOU!!!"
				sleep(30)
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=#FF3399>Easter Bunny</font> [GMTag]</b>:<font color=white> I don't have much to give you. Although I can give you this!"
				alert("The Easter Bunny hands you an Easter Wand")
				new/obj/items/wearable/wands/maple_wand(usr)
				sleep(20)
				usr.talkedtobunny=3
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=#FF3399>Easter Bunny</font> [GMTag]</b>:<font color=white> ENJOY!"
			if(usr.talkedtobunny==3)
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=#FF3399>Easter Bunny</font> [GMTag]</b>:<font color=white> THANKS AGAIN!"

			else
				alert("The Easter Bunny frowns")
				switch(input("Your response","Respond")in list("What's wrong","*Walk away slowly*"))
					if("What's wrong")
						usr << "\n<font size=2><font color=red><b>[Tag] <font color=#FF3399>Easter Bunny</font> [GMTag]</b>:<font color=white> It's just that, I made these brand new chocolates, that are a MILLION! times better than ordinary chocolate. And they seem to have went missing."
						alert("The Easter Bunny frowns")
						switch(input("Your Response","Respond")in list("Do you have any idea who did this?","Well quit talking to me and get to finding them!"))
							if("Do you have any idea who did this?")
								usr << "\n<font size=2><font color=red><b>[Tag] <font color=#FF3399>Easter Bunny</font> [GMTag]</b>:<font color=white> No...I have no idea at all. I mean, who would want to hurt Easter!"
								sleep(30)
								switch(input("Easter Bunny: It's sad","Easter Bunny")in list("Don't worry, i'll find them for you","Oh well, good luck!"))
									if("Don't worry, i'll find them for you")
										usr << "\n<font size=2><font color=red><b>[Tag] <font color=#FF3399>Easter Bunny</font> [GMTag]</b>:<font color=white> Oh, Thank you so much! I will be here waiting. Oh please hurry!"
										usr.talkedtobunny=1
									if("Oh well, good luck!")
										return

							if("Well quit talking to me and get to finding them!")
								alert("The Easter Bunny looks away")
								return

					if("*Walk away slowly*")
						alert("You back away slowly")
						usr.x = usr:x
						usr.y = usr:y-1
						usr.z = usr:z

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
				hearers() << "<font color=#FFA600><b>[usr] pulls some candy out of \his halloween bucket!</b></font>"
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
				hearers() << "<font color=#FFA600><b>[usr] pulls out \his halloween bucket.</b></font>"
				usr.overlays+=image('halloween-bag.dmi')

		verb
			Take_Off()
				hearers() << "<font color=#FFA600><b>[usr] puts away \his halloween bucket.</b></font>"
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
				usr << "<font color=#FFA600>It's a Halloween Bucket from 2011!</font>"



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

mob/TalkNPC
	Tim
		icon='Misc Mobs.dmi'
		icon_state="Tim"
		density=1
		Immortal=1

		verb
			Examine()
				set src in oview(3)
				usr << "One of the Easter Bunnies helpers."

		Talk()
			set src in oview(3)
			if(usr.talkedtobunny==1)
				switch(input("Tim: Isn't it sad what happened the Easter Bunny?","Tim")in list("Very sad.","Any idea who did it?","Not really."))
					if("Very sad.")
						alert("Tim nods somberly")
					if("Any idea who did it?")
						switch(input("Tim: It was probably that thief Zonko.","Tim")in list("Maybe I will go talk to Zonko"))
							if("Maybe I will go talk to Zonko")
								usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Tim</font> [GMTag]</b>:<font color=white> Alright"

			if(usr.talkedtobunny==3)
				usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Tim</font> [GMTag]</b>:<font color=white> Thanks again."


			else
				if(usr.talkedtobunny==1)
					return
				if(usr.talkedtobunny==2)
					return
				if(usr.talkedtobunny==3)
					return
				else
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Tim</font> [GMTag]</b>:<font color=white> The Easter Bunny is in there."


mob/TalkNPC
	Sean
		icon='Misc Mobs.dmi'
		icon_state="Sean"
		density=1
		Immortal=1

		verb
			Examine()
				set src in oview(3)
				usr << "A local townsman."

		Talk()
			set src in oview(3)
			usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Sean</font> [GMTag]</b>:<font color=white> Hiya. What's up?"
			if(foundlord) return
			sleep(20)
			switch(input("Your response","Respond")in list("I'm looking for someone","Nothing really","Mind your own business"))
				if("Mind your own business")
					alert("Sean shrugs")
					sleep(20)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Sean</font> [GMTag]</b>:<font color=white> Whatever."
				if("Nothing really")
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Sean</font> [GMTag]</b>:<font color=white> That's cool."
				if("I'm looking for someone")
					sleep(10)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Sean</font> [GMTag]</b>:<font color=white> Oh?"
					sleep(20)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Sean</font> [GMTag]</b>:<font color=white> And who would that be?"
					switch(input("Your response","Respond")in list("Don't worry about it","It's a little baby, have you seen him?"))
						if("Don't worry about it")
							usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Sean</font> [GMTag]</b>:<font color=white> If you say so..."
						if("It's a little baby, have you seen him?")
							usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Sean</font> [GMTag]</b>:<font color=white> Hm...I saw a man holding a baby the other day."
							sleep(30)
							usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Sean</font> [GMTag]</b>:<font color=white> He was kinda scary looking too."
							switch(input("Your response","Respond")in list("Was he holding a bag??","Ok Thanks"))
								if("Was he holding a bag??")
									usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Sean</font> [GMTag]</b>:<font color=white> I think so..."
									sleep(20)
									switch(input("Your response","Respond")in list("Which way did he go?","Ok Thanks"))
										if("Which way did he go?")
											usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Sean</font> [GMTag]</b>:<font color=white> Well when I saw him he was over there"
											sleep(30)
											alert("Sean points in the direction of Silverblood")
											usr.foundlord=1
											sleep(20)
											switch(input("Your response","Respond")in list("Ok Thanks"))
												if("Ok Thanks")
													usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Sean</font> [GMTag]</b>:<font color=white> No problem."
										if("Ok Thanks")
											usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Sean</font> [GMTag]</b>:<font color=white> No problem."
								if("Ok Thanks")
									usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Sean</font> [GMTag]</b>:<font color=white> No problem."

obj/FredsDresser
	icon='items.dmi'
	icon_state="cabinet"
	name="Fred's Dresser"
	density=1
	value=2500
	dontsave=1
	verb
		Search()
			set src in oview(1)
			if(usr.talkedtofred==3)
				if(locate(/obj/items/freds_key) in usr)
					usr << "You don't find anything of interest."
				else
					usr << "<b>You find a Key!</b>"
					new/obj/items/freds_key(usr)
			else
				usr << "You don't find anything of interest."

mob/var/talkedtoalyssa


mob/TalkNPC
	Alyssa
		icon='Misc Mobs.dmi'
		icon_state="Character 37"
		Gm=1
		Immortal=1

		Talk()
			set src in oview(3)
			if(usr.talkedtoalyssa==2)
				usr << "<b><font color=blue>Alyssa: </font>Thanks again for helping me."
			else
				if(usr.talkedtoalyssa==1)
					usr << "<b><font color=blue>Alyssa: </font>Find my ingredients yet?!"
					switch(input("What is your response?","Make a selection")in list("Yes","No"))
						if("Yes")
							usr << "<b><font color=blue>Alyssa: </font>Well let's see them."
							if(usr.silverspiderlegs==1)
								if(usr.salamanderdrop==1)
									if(usr.indigoseeds==1)
										if(usr.onionroot==1)
											usr << "<b><font color=blue>Alyssa: </font>You have it all! How wonderful!"
											sleep(25)
											usr << "<b><font color=blue>Alyssa: </font>Now we'll use these to brew the potion."
											for(var/obj/Alyssa/X in usr)
												del X
											sleep(20)
											usr << "<b><font color=blue>Alyssa: </font>Hopefully I've mixed it right! I'm ready to be immortal."
											sleep(25)
											usr << "<i>Alyssa drinks the potion</i>"
											sleep(20)
											flick("transfigure",src)
											src.icon='monsters.dmi'
											src.icon_state="frog"
											sleep(40)
											flick("transfigure",src)
											icon='Misc Mobs.dmi'
											icon_state="Character 37"
											sleep(20)
											usr << "<b><font color=blue>Alyssa: </font>I guess it was too good to be true."
											sleep(20)
											usr << "<b><font color=blue>Alyssa: </font>Thanks for helping me anyways, you can have these as a token of my gratitude."
											if(usr.talkedtoalyssa!=2)
												new/obj/items/wearable/shoes/royale_shoes(usr)
												usr.quests+=1
												usr.talkedtoalyssa=2
												alert("Alyssa gives you a pair of Royale Shoes")
										else
											usr << "<b><font color=blue>Alyssa: </font>You don't have the Onion Root! I need that!"
									else
										usr << "<b><font color=blue>Alyssa: </font>You don't have the Indigo Seeds! I need those!"
								else
									usr << "<b><font color=blue>Alyssa: </font>You don't have the Drop of Salamander! I need that!"
							else
								usr << "<b><font color=blue>Alyssa: </font>You don't have the Silver Spider Legs! I need those!"
						if("No")
							usr << "<b><font color=blue>Alyssa: </font>Better keep on looking!"
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
									usr.talkedtoalyssa=1
									usr << "<b><font color=blue>Alyssa: </font>Oh wonderful! I know people around here make potions. Maybe they have some ingredients stashed away in there houses."
									sleep(15)
									usr << "<b><font color=blue>Alyssa: </font>I'm not saying to steal them....Just borrow them. Indefinitely."
									sleep(15)
									usr << "<b><font color=blue>Alyssa: </font>There's probably some growing around too. Here's my list!"
									if(usr.talkedtoalyssa==1)
										new/obj/AlyssaScroll(usr)
										alert("Alyssa hands you her list of potion ingredients")
										usr << "<b><font color=blue>Alyssa: </font>Thanks!"
								if("I've got better things to do")
									return
						if("No thanks")
							return

mob/var/onionroot
mob/var/indigoseeds
mob/var/silverspiderlegs
mob/var/salamanderdrop

obj
	Alyssa/Onion_Root
		icon='ingred.dmi'
		icon_state="Onion Root"
		verb
			Examine()
				usr << "I found an onion root!"

obj
	Alyssa/Salamander_Drop
		icon='ingred.dmi'
		icon_state="Salamander Drop"
		verb
			Examine()
				usr << "What the heck is a Salamander Drop?!"

obj
	Alyssa/Indigo_Seeds
		icon='ingred.dmi'
		icon_state="Indigo Seeds"
		verb
			Examine()
				usr << "I found some Indigo Seeds!"

obj
	Alyssa/Silver_Spider_Legs
		icon='ingred.dmi'
		icon_state="Silver Spider Legs"
		verb
			Examine()
				usr << "I found some Silver Spider Legs!"



obj/AlyssaChest/Onion_Root1
	name="Chest"
	icon='turf.dmi'
	icon_state="chest"
	density=1
	value=0
	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			alert("You open the chest")
			if(usr.ror==1)
				if(usr.onionroot==1)
					alert("You find nothing.")
				else
					alert("You find an Onion Root!")
					usr.onionroot=1
					new/obj/Alyssa/Onion_Root(usr)
			else
				alert("You find nothing.")

obj/AlyssaChest/Onion_Root2
	name="Chest"
	icon='turf.dmi'
	icon_state="chest"
	density=1
	value=0
	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			alert("You open the chest")
			if(usr.ror==2)
				if(usr.onionroot==1)
					alert("You find nothing.")
				else
					alert("You find an Onion Root!")
					usr.onionroot=1
					new/obj/Alyssa/Onion_Root(usr)
			else
				alert("You find nothing.")

obj/AlyssaChest/Onion_Root3
	name="Chest"
	icon='turf.dmi'
	icon_state="chest"
	density=1
	value=0
	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			alert("You open the chest")
			if(usr.ror==3)
				if(usr.onionroot==1)
					alert("You find nothing.")
				else
					alert("You find an Onion Root!")
					usr.onionroot=1
					new/obj/Alyssa/Onion_Root(usr)
			else
				alert("You find nothing.")

obj/AlyssaChest/Indigo_Seeds1
	name="Chest"
	icon='turf.dmi'
	icon_state="chest"
	density=1
	value=0
	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			alert("You open the chest")
			if(usr.ror==1)
				if(usr.indigoseeds==1)
					alert("You find nothing.")
				else
					alert("You find some Indigo Seeds!")
					usr.indigoseeds=1
					new/obj/Alyssa/Indigo_Seeds(usr)
			else
				alert("You find nothing.")

obj/AlyssaChest/Indigo_Seeds2
	name="Chest"
	icon='turf.dmi'
	icon_state="chest"
	density=1
	value=0
	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			alert("You open the chest")
			if(usr.ror==2)
				if(usr.indigoseeds==1)
					alert("You find nothing.")
				else
					alert("You find some Indigo Seeds!")
					usr.indigoseeds=1
					new/obj/Alyssa/Indigo_Seeds(usr)
			else
				alert("You find nothing.")

obj/AlyssaChest/Indigo_Seeds3
	name="Chest"
	icon='turf.dmi'
	icon_state="chest"
	density=1
	value=0
	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			alert("You open the chest")
			if(usr.ror==3)
				if(usr.indigoseeds==1)
					alert("You find nothing.")
				else
					alert("You find some Indigo Seeds!")
					usr.indigoseeds=1
					new/obj/Alyssa/Indigo_Seeds(usr)
			else
				alert("You find nothing.")

obj/AlyssaChest/Silver_Spider1
	name="Chest"
	icon='turf.dmi'
	icon_state="chest"
	density=1
	value=0
	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			alert("You open the chest")
			if(usr.ror==1)
				if(usr.silverspiderlegs==1)
					alert("You find nothing.")
				else
					alert("You find some Silver Spider Legs!")
					usr.silverspiderlegs=1
					new/obj/Alyssa/Silver_Spider_Legs(usr)
			else
				alert("You find nothing.")

obj/AlyssaChest/Silver_Spider2
	name="Chest"
	icon='turf.dmi'
	icon_state="chest"
	density=1
	value=0
	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			alert("You open the chest")
			if(usr.ror==2)
				if(usr.silverspiderlegs==1)
					alert("You find nothing.")
				else
					alert("You find some Silver Spider Legs!")
					usr.silverspiderlegs=1
					new/obj/Alyssa/Silver_Spider_Legs(usr)
			else
				alert("You find nothing.")

obj/AlyssaChest/Silver_Spider3
	name="Chest"
	icon='turf.dmi'
	icon_state="chest"
	density=1
	value=0
	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			alert("You open the chest")
			if(usr.ror==3)
				if(usr.silverspiderlegs==1)
					alert("You find nothing.")
				else
					alert("You find some Silver Spider Legs!")
					usr.silverspiderlegs=1
					new/obj/Alyssa/Silver_Spider_Legs(usr)
			else
				alert("You find nothing.")



mob/Player
	var/tmp/list/quests_progress // keep it tmp for now until it's fully tested

	proc
		clean_quests()
			if(quests_progress)
				for(var/i in quests_progress)
					if(!(i in quests))
						quests_progress -= i

				if(!quests_progress.len)
					quests_progress = null
var
	list/quests


obj/quests

	var
		quest_name
		message

	giver
		var
			init = 0
			reward
		verb
			Talk()
				set src in view(1)
				if(!quests)
					quests = list()
				if(init)
					var/mob/Player/p = usr
					if(!p.quests_progress)
						p.quests_progress = list()

					if(!(quest_name in p.quests_progress) || p.quests_progress[quest_name] == 1)
						p.quests_progress[quest_name] = 1
						usr << npcsay(message)
					else
						var/flags = 1
						for(var/i = 1; i <= quests[quest_name]; i++)
							flags += 2 ** i
						if(flags == p.quests_progress[quest_name])
							p.quests_progress[quest_name] = -1

							if(reward)
								if(isnum(reward))
									p.gold += reward
									p << "<b><i>[src] gives you [comma(reward)] gold.</i></b>"
								else if(istext(reward))
									p << npcsay(reward)
								else
									var/obj/O = new reward(p)
									p.Resort_Stacking_Inv()
									p << " <font size=2 color=red>[src] hands you their [O.name]."

				else
					init()
					usr << infomsg("Quest initilized")
		proc
			init()
				quests[quest_name] = 0
				init = 1
		New()
			..()
			spawn(5)
				if(init)
					init()
	progress

		var
			item
			id

		item
			item = 1
			verb
				Take()
					set src in view(1)
					prog(usr)
		npc
			item = 0
			verb
				Talk()
					set src in view(1)
					prog(usr)
		verb
			Init()
				set src in view(1)
				init()

		proc
			init()
				verbs -= /obj/quests/progress/verb/Init
				quests[quest_name]++
				id = 2 ** quests[quest_name]

			prog(mob/Player/p)
				if((quest_name in p.quests_progress) && p.quests_progress[quest_name] > 0)
					if((p.quests_progress[quest_name] & id) == id)
						p << (item ? errormsg("You already took this item.") : message)
					else
						p << infomsg(message)
						p.quests_progress[quest_name] += id
				else
					p << (item ? errormsg("You don't see any use for this.") : npcsay("[name] says: Hello again!"))

		New()
			..()
			spawn(10)
				if(id)
					init()