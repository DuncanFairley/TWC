/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
obj/snowman
	icon='snowman.dmi'
	name="Snow Man"
	verb
		Examine()
			set src in oview(3)
			usr << "So creative!"
mob
	snowman
		icon='snowman.dmi'
		name="Snow Man"
		verb
			Examine()
				set src in oview(3)
				usr << "So creative!"

mob
	PyramidMan
		name="Mysterious Old Man"
		icon='Tammie.dmi'
		icon_state="back"
		density=1
		Immortal=1
		verb
			Examine()
				set src in oview(3)
				usr << "I wonder how he got past the floating eyes..."
			Talk()
				set src in oview(3)
				alert("Go back the way you came...the pyramid is not ready to reveal itself yet...")
				alert("*The old man laughs very oddly*")

mob/var/StatMan
mob
	TalkNPC
		mouse_over_pointer = MOUSE_HAND_POINTER

		density = 1
		Immortal = 1
		NPC = 1
		Gm=1

		verb
			Talk()

		Click()
			if(src in oview(3))
				Talk()
			else
				usr << errormsg("You need to be closer.")

		StatChangeMan
			name = "Demetrius"
			icon = 'misc.dmi'
			icon_state = "goblin1"

			Talk()
				set src in oview(3)
				if(usr.level < lvlcap)
					hearers(usr) << npcsay("Demetrius: Well hello there, [usr.gender == MALE ? "sonny" : "young lady"]. Unfortunately I cannot help you until you are of a higher level!")
				else
					if(usr.gold < 50000)
						hearers(usr) << npcsay("Demetrius: Well hello there, [usr.gender == MALE ? "sonny" : "young lady"]. Unfortunately you need 50,000 gold before I am able to help you.")
					else
						switch(alert("Would you like to reset your stat points? It will cost 50,000 gold.",,"Yes","No"))
							if("Yes")
								if(usr.gold >= 50000)
									hearers(usr) << npcsay("Demetrius: There you go, [usr.gender == MALE ? "sonny" : "young lady"] - your stats are reset!")
									usr.gold -= 50000
									usr.resetStatPoints()
									usr.HP = usr.MHP + usr.extraMHP
									usr.MP = usr.MMP + usr.extraMMP
									usr.updateHPMP()
							if("No")
								hearers(usr) << npcsay("Demetrius: Maybe next time then. Have a nice day!")

		StatMan
			name="Mysterious Caped Fellow"
			icon='Misc Mobs.dmi'
			icon_state="atomic"

			verb
				Examine()
					set src in oview(3)
					usr << "I like his cape."
			Talk()
				set src in oview(3)
				switch(alert("Hello there... My name is not important, however I have a few special services I can offer you for a price...","Mysterious Caped Fellow", "Rename - 25 Spell Points", "Reset Kills/Deaths - 60 Spell Points", "No Thanks"))
					if("Reset Kills/Deaths - 60 Spell Points")
						if(usr:spellpoints >= 60)
							usr:spellpoints -= 60
							usr.pdeaths = 0
							usr.pkills = 0
							usr << infomsg("Your player kills and deaths have been reset.")
						else
							usr << errormsg("You don't have enough spell points. You need [60 - usr:spellpoints] more spell points.")
					if("Rename - 25 Spell Points")
						if(usr.derobe||usr.aurorrobe)
							usr << errormsg("You can not do this while wearing clan robes.")
							return
						if(usr:spellpoints >= 25)
							var/mob/create_character/c = new
							var/desiredname = input("What name would you like? (Keep in mind that you cannot use a popular name from the Harry Potter franchise, nor numbers or special characters)") as text|null
							if(!desiredname)
								del c
								return
							var/passfilter = c.name_filter(desiredname)
							while(passfilter)
								alert("Your desired name is not allowed as it [passfilter].")
								desiredname = input("Please select a name that does not use a popular name from the Harry Potter franchise, nor numbers or special characters.") as text|null
								if(!desiredname)
									del c
									return
								passfilter = c.name_filter(desiredname)
							del c
							if(name == desiredname) return
							Log_admin("[usr] has changed their name to [desiredname].")
							usr.name = desiredname
							usr.underlays = list()
							switch(usr.House)
								if("Hufflepuff")
									usr.GenerateNameOverlay(242,228,22)
								if("Slytherin")
									usr.GenerateNameOverlay(41,232,23)
								if("Gryffindor")
									usr.GenerateNameOverlay(240,81,81)
								if("Ravenclaw")
									usr.GenerateNameOverlay(13,116,219)
								if("Ministry")
									usr.GenerateNameOverlay(255,255,255)
							usr:spellpoints -= 25
						else
							usr << errormsg("You don't have enough spell points. You need [25 - usr:spellpoints] more spell points.")

obj
	Guard
		icon='monster.dmi'
		icon_state="guard"
		density=1
		Click()


obj
	guard_statue
		icon='monster.dmi'
		icon_state="guard"
		New()
			..()
			var/turf/T = src.loc
			if(T)T.flyblock=1

mob
	Santa
		icon='Christmas Stuff.dmi'
		icon_state="Santa"
		density=1
		Gm=1
		Immortal=1
		verb
			Examine()
				set src in oview(3)
				usr << "He looks so jolly!!"
			Talk()
				set src in oview(3)
				if(usr.talkedtosanta==1)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Santa</font> [GMTag]</b>:<font color=white> Have you talked to Tim yet?"
					sleep(10)
					alert("You shake your head no.")
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Santa</font> [GMTag]</b>:<font color=white> Remember. He's in the Leaky Cauldron."
					return
				if(usr.talkedtosanta==2)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Santa</font> [GMTag]</b>:<font color=white> Have you talked to Tim yet?"
					alert("You tell Santa what Tim said about the receptionist")
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Santa</font> [GMTag]</b>:<font color=white> Alrighty, make sure you check that out."
					return
				if(usr.talkedtosanta==3)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Santa</font> [GMTag]</b>:<font color=white> Sooooo, what's the good word??"
					sleep(20)
					alert("You fill Santa in on your encounter with Shana")
					sleep(10)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Santa</font> [GMTag]</b>:<font color=white> So you did it?!? THANK YOU!"
					sleep(15)
					alert("Santa leaps into your arms, still screaming 'Thank yous' and 'Great Heavens'")
					sleep(15)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Santa</font> [GMTag]</b>:<font color=white> Here, take this! My gift to you, as my way of saying Thank you!"
					alert("Santa gives you a Christmas Wig")
					usr.talkedtosanta=4
					switch(input("Do you want a Girl's Wig, or a Boy's Wig?","Santa")in list("Boy's","Girl's"))
						if("Boy's")
							new/obj/items/wearable/wigs/male_christmas_wig(usr)
							alert("Santa: Enjoy!")
							return
						if("Girl's")
							new/obj/items/wearable/wigs/female_christmas_wig(usr)
							alert("Santa: Enjoy!")
							return
				if(usr.talkedtosanta==4)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Santa</font> [GMTag]</b>:<font color=white> Thanks again!"
					return

				else
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Santa</font> [GMTag]</b>:<font color=white> Ho ho ho, hello there young one. What can I do for you?"
					switch(input("Response to Santa","Response")in list("Can I have a present?","I'm just looking around","Nothing"))
						if("Can I have a present?")
							usr << "\n<font size=2><ont color=red><b>[Tag] <font color=red>Santa</font> [GMTag]</b>:<font color=white> Oh, I wish I could give you one. It seems that I am in a bit of a dilema. A few of my best Elves have gone missing. With them gone, the other elves have no one to look up to, and toy production itself has stopped."
							alert("Santa frowns")
							switch(input("Response to Santa","Santa")in list("Maybe I can help find them for you?","Sorry to hear that"))
								if("Maybe I can help find them for you?")
									usr << "\n<font size=2><ont color=red><b>[Tag] <font color=red>Santa</font> [GMTag]</b>:<font color=white> Oh really?!? That would be just great! Word has it that the Easter Bunny's assistant, Tim, knows something, maybe you could ask him? He usually hangs out in the Leaky Cauldron."
									usr.talkedtosanta=1
								if("Sorry to hear that")
									alert("Santa nods solemnly")
									return
						if("I'm just looking around")
							usr << "\n<font size=2><ont color=red><b>[Tag] <font color=red>Santa</font> [GMTag]</b>:<font color=white> Okie Dokie."
							return
						if("Nothing")
							alert("Santa goes back to what he was doing.")
							return

mob/var/talkedtosanta
mob
	elf1
		icon='Christmas Stuff.dmi'
		icon_state="elf 1"
		density=1
		Immortal=1
		name="Elf"
		verb
			Examine()
				set src in oview(3)
				usr << "They must get tired from making so many toys..."

mob
	elf2
		icon='Christmas Stuff.dmi'
		icon_state="elf 2"
		density=1
		name="Elf"
		Immortal=1
		verb
			Examine()
				set src in oview(3)
				usr << "They must get tired from making so many toys..."

	elf3
		icon='Christmas Stuff.dmi'
		icon_state="elf 3"
		density=1
		name="Elf"
		Immortal=1
		verb
			Examine()
				set src in oview(3)
				usr << "They must get tired from making so many toys..."


mob
	Tim2
		name="Tim "
		icon='Misc Mobs.dmi'
		icon_state="Tim2"
		density=1
		Immortal=1
		verb
			Examine()
				set src in oview(5)
				usr << "One of the Easter Bunnies helpers."
			Talk()
				set src in oview(2)
				if(usr.talkedtosanta==1)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Tim</font> [GMTag]</b>:<font color=white> What do you want..."
					sleep(15)
					alert("You tell Tim about your quest to help Santa")
					sleep(10)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Tim</font> [GMTag]</b>:<font color=white> So you're helping jolly old saint nick."
					switch(input("Response to Tim","Response")in list("Yes, do you know anything?","Not anymore, this is a waste of my time..."))
						if("Yes, do you know anything?")
							usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Tim</font> [GMTag]</b>:<font color=white> Eh, All I know is that I saw that receptionist girl talking to someone about how much easier her life is with Elves to do her work."
							sleep(20)
							usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Tim</font> [GMTag]</b>:<font color=white> I don't know <u>what</u> elves she's talking about, maybe they're the same ones."
							sleep(15)
							usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Tim</font> [GMTag]</b>:<font color=white> But that's all I know, so leave me be."
							sleep(10)
							alert("Tim goes back to his drink")
							usr.talkedtosanta=2
						if("Not anymore, this is a waste of my time...")
							alert("Tim ignores you")
							return
				else
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Tim</font> [GMTag]</b>:<font color=white> Can't you see I'm busy..."
					alert("Tim goes back to his Drink")
					return


mob/Shana_the_Receptionist
	icon='Misc.dmi'
	icon_state="sorceress"
	Gm=1
	Immortal=1
	verb
		Talk()
			set src in oview(3)
			if(usr.talkedtosanta==2)
				usr << "<b><font color=red>[usr]</b></font>: Shana, I know you have the elves"
				sleep(15)
				usr << "<b><font color=blue>Shana:</font> I have no idea what you're talking about..."
				sleep(10)
				alert("Shana looks around nervously")
				switch(input("Response to Shana","Response")in list("What did you do with Santa's Elves!","Forget it"))
					if("What did you do with Santa's Elves!")
						usr << "<b><font color=blue>Shana:</font> I don't know what you're talking about!!!"
						sleep(10)
						usr.loc = locate(73,85,1)
						alert("Shana attempts to apparate away but you leep onto her and apparate along")
					if("Forget it")
						alert("Shana looks relieved")
						return
			else
				switch(input("Hello, [usr]. How can I help you?","Shana") in list ("Call GM","Orb out.","Nevermind"))
					if("Call GM")
						hearers()<<"<b><font color=blue>Shana:</font> Okay, I'll need you to fill out this form."
						usr<<"Shana hands you a form, you look at it."
						sleep(20)
						switch(input("Please specify which GM you'd like to meet with.","GM Form") in list ("Deputy Headmaster Sylar"))

							if("Deputy Headmaster Sylar")
								hearers()<<"<b><font color=red>[usr]</b></font>: I need to speak with Headmaster Ander, please."
								sleep(30)
								hearers()<<"<b><font color=blue>Shana:</font> Alright one second, dear. Paging, Deputy Headmaster Sylar. If he is AFK he could take a while to respond. Have a seat in the Waiting Area if you like."
								for(var/mob/M in world)
									if(M.key=="")
										switch(input(M,"A voice echoes through your mind.  Hello, [M]. [usr] would like to meet with you at the Reception Area. Do you accept?","Shana via Telepathy") in list ("Yes","No","Report to Office"))
											if("Yes")
												flick('dlo.dmi',M)
												sleep(10)
												M.loc = locate(47,50,1)
												flick('dlo.dmi',M)
												hearers() << "<b><font color=blue>Shana:</font> Ah, here he is now. Thank you, [usr]. Come again!"
												sleep(35)
												for(var/mob/Z in world)
													if(Z.name=="Shana the Receptionist")
														flick('dlo.dmi',Z)

														sleep(10)
														Z.invisibility=1

											if("No")
												usr << "<b><font color=blue>Shana:</font> I'm sorry. Sylar is too busy at the moment. Come back later."
												return
												for(var/mob/Z in world)
													if(Z.name=="Shana the Receptionist")
														flick('dlo.dmi',Z)

														sleep(10)
														Z.invisibility=1
											if("Report to Office")
												usr<<"<b><font color=blue>Shana:</font> Sylar would like you to go see him in his office."
												sleep(30)
												for(var/mob/Z in world)
													if(Z.name=="Shana the Receptionist")
														flick('dlo.dmi',Z)

														sleep(10)
														Z.invisibility=1

								for(var/mob/M in world)
									if(M.key=="R")
										switch(input(M,"A voice echoes through your mind.  Hello, [M]. [usr] would like to meet with you at the Reception Area. Do you accept?","Shana via Telepathy") in list ("Yes","No","Report to Office"))
											if("Yes")
												flick('dlo.dmi',M)
												sleep(10)
												M.loc = locate(47,50,1)
												flick('dlo.dmi',M)
												hearers() << "<b><font color=blue>Shana:</font> Ah, here he is now. Thank you, [usr]. Come again!"
												sleep(35)
												for(var/mob/Z in world)
													if(Z.name=="Shana the Receptionist")
														flick('dlo.dmi',Z)

														sleep(10)
														Z.invisibility=1

											if("No")
												usr << "<b><font color=blue>Shana:</font> I'm sorry. Shirou is too busy at the moment. Come back later."
												return
												for(var/mob/Z in world)
													if(Z.name=="Shana the Receptionist")
														flick('dlo.dmi',Z)

														sleep(10)
														Z.invisibility=1
											if("Report to Office")
												usr<<"<b><font color=blue>Shana:</font> Shirou would like you to go see him in his office."
												sleep(30)
												for(var/mob/Z in world)
													if(Z.name=="Shana the Receptionist")
														flick('dlo.dmi',Z)

														sleep(10)
														Z.invisibility=1
					if("Orb out.")
						hearers()<<"<b><font color=red>[usr]</b></font>: Hi Shana. I'd like to leave reception now please."
						sleep(30)
						usr<<"Shana looks up at you and picks up her wand."
						sleep(12)
						hearers()<<"<b><font color=blue>Shana:</font> Alright. ^_^  <font color=aqua>Sanctuario, [usr]!</font>"
						sleep(20)
						flick('dlo.dmi',usr)

						sleep(10)
						usr.loc=locate(51,59,17)
						flick('dlo.dmi',usr)

						sleep(20)
						for(var/mob/Z in world)
							if(Z.name=="Shana the Receptionist")
								flick('dlo.dmi',Z)

								sleep(10)
								Z.invisibility=1
					if("Nevermind")
						hearers()<<"<b><font color=red>[usr]</b></font>: Nevermind."
						sleep(10)
						hearers() << "<b><font color=blue>Shana:</font> Hehe, okay. Bye."
						sleep(35)
						for(var/mob/Z in world)
							if(Z.name=="Shana the Receptionist")
								flick('dlo.dmi',Z)

								sleep(10)
								Z.invisibility=1
