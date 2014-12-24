/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

mob/var/StatMan
mob
	TalkNPC
		icon = 'NPCs.dmi'
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
			icon_state="stat"

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
		Jim
			icon_state="jim"
			density=1
			Immortal=1

			verb
				Examine()
					set src in oview(5)
					usr << "One of the Easter Bunnies helpers."

			Talk()
				set src in oview(2)
				if(usr.talkedtosanta==1)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Jim</font> [GMTag]</b>:<font color=white> What do you want..."
					sleep(15)
					alert("You tell Jim about your quest to help Santa")
					sleep(10)
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Jim</font> [GMTag]</b>:<font color=white> So you're helping jolly old saint nick."
					switch(input("Response to Jim","Response")in list("Yes, do you know anything?","Not anymore, this is a waste of my time..."))
						if("Yes, do you know anything?")
							usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Jim</font> [GMTag]</b>:<font color=white> Eh, All I know is that I saw that receptionist girl talking to someone about how much easier her life is with Elves to do her work."
							sleep(20)
							usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Jim</font> [GMTag]</b>:<font color=white> I don't know <u>what</u> elves she's talking about, maybe they're the same ones."
							sleep(15)
							usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Jim</font> [GMTag]</b>:<font color=white> But that's all I know, so leave me be."
							sleep(10)
							alert("Jim goes back to his drink")
							usr.talkedtosanta=2
						if("Not anymore, this is a waste of my time...")
							alert("Jim ignores you")
							return
				else
					usr << "\n<font size=2><font color=red><b>[Tag] <font color=red>Jim</font> [GMTag]</b>:<font color=white> Can't you see I'm busy..."
					alert("Jim goes back to his Drink")
					return


		PyramidMan
			name="Mysterious Old Man"
			icon_state="pyramid"
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