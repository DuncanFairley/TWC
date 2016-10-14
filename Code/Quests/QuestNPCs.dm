/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

mob/TalkNPC/quest

	vampires
		icon = 'FemaleVampire.dmi'

		New()
			..()
			GenerateIcon(src, wig = 0, shoes = 1, scarf = 1)


		Peace_Vampire
			icon = 'MaleVampire.dmi'
			questPointers = "Preserve Peace \[Daily]"

			Peace_Vampire_Lord
				questPointers = "Preserve Peace \[Rank Up]"

				questStart(mob/Player/i_Player, questName)

					var/PlayerData/r = worldData.playersData[i_Player.ckey]

					if(r)

						var/max_rep = r.tierToFame(r.fametoTier() + 1)

						if(r.fame >= max_rep)
							..(i_Player, questName)

							return

					var/ScreenText/s = new(i_Player, src)
					s.AddText("Who the hell are you, why do you dare show your face before me.")

				questOngoing(mob/Player/i_Player, questName)
					.=..(i_Player, questName)

					if(.)
						var/obj/items/wearable/masks/peace_mask/peace = locate() in i_Player
						var/obj/items/wearable/masks/chaos_mask/chaos = locate() in i_Player

						if(chaos)
							chaos.Dispose()
							i_Player << errormsg("Your chaos mask was taken from you.")

						if(!peace)
							peace = new(i_Player)
							i_Player << infomsg("You were given a peace mask.")

			questStart(mob/Player/i_Player, questName)

				var/ScreenText/s = new(i_Player, src)
				s.AddText("Help me preserve the peace, go slaughter those who spread chaos.")

				..(i_Player, questName)

			questOngoing(mob/Player/i_Player, questName)
				.=..(i_Player, questName)

				var/ScreenText/s = new(i_Player, src)

				if(.)
					s.AddText("Thank you for supporting the peace.")
				else
					s.AddText("We must stop the chaos from spreading.")

			questCompleted(mob/Player/i_Player, questName)

				var/ScreenText/s = new(i_Player, src)
				s.AddText("I might have more tasks for you in the future.")


		Chaos_Vampire
			icon = 'MaleVampire.dmi'
			questPointers = "Spread Chaos \[Daily]"

			Chaos_Vampire_Lord
				questPointers = "Spread Chaos \[Rank Up]"

				questStart(mob/Player/i_Player, questName)

					var/PlayerData/r = worldData.playersData[i_Player.ckey]
					if(r)
						var/max_rep = r.tierToFame(r.fametoTier() + 1)

						if(r.fame <= -max_rep)

							..(i_Player, questName)
							return

					var/ScreenText/s = new(i_Player, src)
					s.AddText("Who the hell are you, why do you dare show your face before me.")

				questOngoing(mob/Player/i_Player, questName)
					.=..(i_Player, questName)

					if(.)
						var/obj/items/wearable/masks/peace_mask/peace = locate() in i_Player
						var/obj/items/wearable/masks/chaos_mask/chaos = locate() in i_Player

						if(peace)
							peace.Dispose()
							i_Player << errormsg("Your peace mask was taken from you.")
						if(!chaos)
							chaos = new(i_Player)
							i_Player << infomsg("You were given a chaos mask.")


			questStart(mob/Player/i_Player, questName)

				var/ScreenText/s = new(i_Player, src)
				s.AddText("Help me spread chaos, go slaughter those who preach about peace.")

				..(i_Player, questName)

			questOngoing(mob/Player/i_Player, questName)
				.=..(i_Player, questName)

				var/ScreenText/s = new(i_Player, src)

				if(.)
					s.AddText("Thank you for spreading more chaos.")
				else
					s.AddText("Kill the bloody peace snobs.")


			questCompleted(mob/Player/i_Player, questName)
				var/ScreenText/s = new(i_Player, src)
				s.AddText("I might have more tasks for you in the future.")

		Austra
			questPointers = "Royal Blood \[Weekly]"


			questStart(mob/Player/i_Player, questName)

				var/ScreenText/s = new(i_Player, src)

				s.AddText("Hi... Who are you? Hmm...")
				s.AddText("You humans always go about unnoticed, it might just work... How do you feel about helping me take on a very powerful ancient being? You'll help me fer sure!")
				s.AddText("Good! I can't give you much details right now but there in the night lurk creatures older than any human alive, they know far superior art or \"magic\" as you humans call it, I need you to help me kill a high ranking member of--")
				s.AddText("We'll need a bait, go gather 50 blood sacks.")

				..(i_Player, questName)

			questOngoing(mob/Player/i_Player, questName)
				.=..(i_Player, questName)

				var/ScreenText/s = new(i_Player, src)

				if(.)
					s.AddText("Great! You got it!")
					s.AddText("Give me the blood sacks, I'll create a blood coin for you.")
				else
					s.AddText("You should probably get a few more blood sacks, this won't be enough...")

			questCompleted(mob/Player/i_Player, questName)
				var/ScreenText/s = new(i_Player, src)
				s.AddText("Not bad for a human. Come back next week, I'll help you make another bait.")

	Simon
		icon = 'Simon.dmi'
		questPointers = list("Brother Trouble",
		                     "Brewing Practice")

		questStart(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("Brother Trouble")
					s.AddText("Hello there! Can you help me?")
					i_Player << "<i>You check if the scene is clear.</i>"
					s.AddText("My brother was badly injured by some thugs wearing masks. I need you to brew a health potion of any sort.")
					i_Player << "<i>You notice paleness in the brother's face as well as the red gashes all over his legs. He certainly won't be conscious for very long if he doesn't get treatment.</i>"
					s.AddText("You can create a potion in the <b>Potions Classroom</b> near the Slytherin Common room in Hogwarts.")
					s.AddText("Before you go, take these ingredients. You'll need them to create a potion.")
					for(var/i = 1 to 5)
						new /obj/items/ingredients/aconite (i_Player)
						new /obj/items/ingredients/daisy (i_Player)
						new /obj/items/ingredients/rat_tail (i_Player)

				if("Brewing Practice")
					s.AddText("Hey, you might have a talent for potion brewing, why don't you go brew some more?")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("Brother Trouble")
					if(.)
						s.AddText("Did you get it?")
						i_Player << "<i>You nod.</i>"
						s.AddText("Thank goodness!")
						s.AddText("Here, drink some of this Todd.")

						var/obj/questDecor/Todd/t = locate("SimonTodd")
						if(t)
							t.Animation()

						i_Player << "<i>[name] quickly shoves the health potion into Todd's mouth.</i>"
						i_Player << "<i>Todd regains color to his face and the gashes on his leg quickly sow themselves together.</i>"
						i_Player << "<i>[name] turns towards you.</i>"
						s.AddText("Thank you so much! If you hadn't shown up, my brother may not have lived!")
					else
						s.AddText("Please, hurry! He may not have much time.")
				if("Brewing Practice")
					if(.)
						s.AddText("I hope you had fun brewing those, I tell you what, take this book and record the potion recipes you find, I'm sure it'll be fun!")
					else
						s.AddText("Thanks again for the save! Are you having fun brewing potions?")

		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)

			s.AddText("Thanks again for the save! My brother says he wants to be a young wizard just like you!")



	Sassy_Pixie
		icon = 'Mobs.dmi'
		icon_state="pixie"
		questPointers = list("Pixie Love", "Pixie Wisdom \[Weekly]")

		questStart(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("Pixie Love")
					s.AddText("Look at my lovely pixie family, I love them all, each and every one of them. Now kill them all for me.")
				if("Pixie Wisdom \[Weekly]")
					s.AddText("Get away from me, you creep.")
					i_Player << "<i>You blink.</i>"
					s.AddText("What? Are you bored? Okay, well I've got a task for you then, you pathetic imbecile. I'm in need of a few... ingredients, let's say. Not for anything sinister, like taking over your idiotic wizard school or anything. They're for a... birthday party... yeah, that's it! A birthday party.")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)
			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("Pixie Love")
					if(.)
						s.AddText("Finally, what took you so long? Jeeze. Now I can finally take over.")
					else
						s.AddText("Well? What are you still standing there for? Murder my family!")
				if("Pixie Wisdom \[Weekly]")
					if(.)
						s.AddText("Finally, what took you so long? Jeeze. Now I can finally take over that miserable place you call a school and--")
						i_Player << "<i>You blink.</i>"
						s.AddText("I mean... Plan the best party ever for, uhm... Ben! Yes, Ben...")
						i_Player << "<i>Sassy Pixie laughs evilly.</i>"
						s.AddText("Thanks, mortal!")
					else
						s.AddText("Well? What are you still standing there for? Get me what I need!")

		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)
			s.AddText("Get away from me, you creep.")

	Zombie
		name = "Bob the Zombie"
		icon = 'MaleZombie.dmi'
		questPointers = list("Pumpkin Harvest", "Breath of Life", "Breath of Death")

		questStart(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("Pumpkin Harvest")
					s.AddText("You there! Fresh meat! Why don't you clean up my crypt, it's full of disgusting pumpkins. You fresh meat love pumpkins, go harvest!")
				if("Breath of Life")
					s.AddText("I desire to become more human-like, why don't you help me gather a few ingredients, I'll make it worth your while!")
				if("Breath of Death")
					s.AddText("You must be wondering how I came to be, I wasn't always this sexy, I used to be a lifeless corpse, just one of many.")
					s.AddText("One day, this mysterious masked wizard hid inside my crpyt, when he left he accidently dropped this dark greenish stone fragment right ontop of my grave.")
					s.AddText("That day I was reborn, alive but not, I will stay here forever!")
					s.AddText("The stone is of no use to me again and the wizard might come back for it, tell you what. If you do one more task for me, I will give you the stone fragment.")
					s.AddText("I may have resurrected a few more corpses with this fragment, go kill them, I want to be the only one. While you're at it, also kill some more pumpkins for me, I hate pumpkins.")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)
			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("Pumpkin Harvest")
					if(.)
						s.AddText("I hope you didn't break anything, you cleaning people are always so clumsy but oh well I suppose a ghost will haunt you if you did, at least my grave is finally clean.")
					else
						s.AddText("Yuck, pumpkins!")
				if("Breath of Life")
					if(.)
						s.AddText("Now I can disguise myself and walk amongst the living!")
					else
						s.AddText("I actually used to be a professor at Hogwarts years ago.")
				if("Breath of Death")
					if(.)
						s.AddText("As agreed, you can have the stone fragment now.")
					else
						s.AddText("Remember to slay all the pumpkins, I really hate pumpkins.")

		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)

			s.AddText("I wonder what happens if you merge it with more fragments...")

	Vengeful_Wisp
		icon = 'Mobs.dmi'
		icon_state="wisp"
		questPointers = list("Secret of the Crypt",
		                     "Will of the Wisp \[Daily]")
		New()
			..()
			alpha = rand(190,255)

			var/color1 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
			var/color2 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
			var/color3 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))

			animate(src, color = color1, time = 10, loop = -1)
			animate(color = color2, time = 10)
			animate(color = color3, time = 10)

		questStart(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)
			switch(questName)
				if("Secret of the Crypt")
					s.AddText("Hello there Human! Why do you disturb us? Do you wish to learn the ways of enchantment?")
					s.AddText("Oh, you don't know what enchanting is?")
					s.AddText("The enchanter merges two identical elements to create a greater element.")
					s.AddText("It also requires the power of two artifacts.")
					s.AddText("There might be hints on how to enchant hidden in the bookshelves.")
					s.AddText("Before you go, have some of these. They're called <b>Luck Crystals</b>.")
					s.AddText("They will improve the chance that your enchantment succeeds. Because humans sure can fail, mawhahaha...")

					for(var/i = 1 to 3)
						new /obj/items/crystal/luck (i_Player)

				if("Will of the Wisp \[Daily]")
					s.AddText("You, human! I want you to help me express my rage, kill every wisp you face, vengeance shall be mine! Mawhahahaha!!!")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("Secret of the Crypt")
					if(.)
						s.AddText("Good job. I honestly didn't believe a human like yourself would figure it out.")
						s.AddText("Then again, I did give a good amount of clues...")
					else
						s.AddText("Don't worry, I have an eternity.")
				if("Will of the Wisp \[Daily]")
					if(.)
						s.AddText("I love the irony in sending you to kill dead creatures. May they rest in pea-- I will send you to kill them again tomorrow.")
					else
						s.AddText("Don't waste time talking to me, actions speak louder than words!")

		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)

			s.AddText("Pity the living!")


	Mysterious_Wizard
		icon_state="wizard"
		questPointers = "The Eyes in the Sand \[Daily]"

		questStart(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)
			s.AddText("Beyond this door lies the desert, oh so mysterious... There are strange creatures there called floating eyes, check if they bleed for me!")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			if(.)
				s.AddText("Floating eyes, the gods of the desert can bleed after all, how amusing!")
			else
				s.AddText("Not enough, go back there and check if they all bleed!")

		questCompleted(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)
			s.AddText("So even the gods of the desert can bleed... Interesting!")

	Saratri
		icon_state="lord"
		questPointers = "To kill a Boss \[Daily]"

		questStart(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)
			s.AddText("Hey there... Did you know there's a terrible monster here called the Basilisk? I'll reward you if you kill it...")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)
			if(.)
				s.AddText("Good job! I can't believe you pulled it off!")
			else
				s.AddText("Go kill the Basilisk!")

		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)
			s.AddText("Wow! I can't believe you killed the Basilisk!")

	Malcolm
		icon_state="goblin1"
		questPointers = "Draw Me a Stick \[Daily]"

		questStart(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)
			s.AddText("Welcome to floor 2! Did you know Basilisk is not the strongest monster here?! There's a magical stickman in this floor, if you manage to defeat it I will reward you.")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)
			if(.)
				s.AddText("Good job! I can't believe you pulled it off!")
			else
				s.AddText("Go kill the Stickman!")

		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)
			s.AddText("Wow! I can't believe you killed the Stickman!")

	Hunter
		icon_state="lord"
		questPointers = list("Pest Extermination: Rat",
		                     "Pest Extermination: Common Pests",
		                     "Pest Extermination: Pixie",
		                     "Pest Extermination: Dog",
		                     "Pest Extermination: Snake",
		                     "Pest Extermination: Wolf",
		                     "Pest Extermination: Uncommon Pests",
		                     "Pest Extermination: Fire Bat",
		                     "Pest Extermination: Fire Golem",
		                     "Pest Extermination: Archangel",
		                     "Pest Extermination: Water Elemental",
		                     "Pest Extermination: Fire Elemental",
		                     "Pest Extermination: Wyvern",
		                     "Pest Extermination: Demon Rat",
		                     "Pest Extermination: Troll",
		                     "Pest Extermination: Acromantula",
		                     "Pest Extermination \[Daily]")


		questStart(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			s.AddText("Hey there, maybe you can help me, I want to exterminate a few pests from our lives.")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			s.AddText("Did you kill the monsters I requested yet?")
			if(.)
				s.AddText("Hunter: Good job!")
			else
				s.AddText("Hunter: Go back out there and exterminate some pests!")

		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)
			s.AddText("Hunter: You've done a really good job exterminating all those monsters.")

	Zerf
		icon_state = "stat"
		questPointers = list("PvP Introduction", "Culling the Herd", "Strength of Dragons")

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
		if(p.ror == r)
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
		questPointers = "Make a Potion"
		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			if("Make a Potion" in p.questPointers)
				var/questPointer/pointer = p.questPointers["Make a Potion"]
				if(pointer.stage)
					usr << "<b><span style=\"color:blue;\">Alyssa: </span>Find my ingredients yet?!"
					switch(input("What is your response?","Make a selection")in list("Yes","No"))
						if("Yes")
							usr << "<b><span style=\"color:blue;\">Alyssa: </span>Well let's see them."
							if(pointer.stage == 2)
								usr << "<b><span style=\"color:blue;\">Alyssa: </span>You have it all! How wonderful!"
								sleep(25)
								usr << "<b><span style=\"color:blue;\">Alyssa: </span>Now we'll use these to brew the potion."
								sleep(20)
								usr << "<b><span style=\"color:blue;\">Alyssa: </span>Hopefully I've mixed it right! I'm ready to be immortal."
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
								usr << "<b><span style=\"color:blue;\">Alyssa: </span>I guess it was too good to be true."
								sleep(20)
								usr << "<b><span style=\"color:blue;\">Alyssa: </span>Thanks for helping me anyways, you can have these as a token of my gratitude."

								for(var/obj/items/Alyssa/X in usr)
									X.loc = null
								var/obj/items/AlyssaScroll/scroll = locate() in usr
								if(scroll)
									scroll.loc = null
								p.checkQuestProgress("Alyssa")
							else
								usr << "<b><span style=\"color:blue;\">Alyssa: </span>You don't have all of the ingredients! Go back and look for them!"
						if("No")
							usr << "<b><span style=\"color:blue;\">Alyssa: </span>Better keep on looking!"
				else
					usr << "<b><span style=\"color:blue;\">Alyssa: </span>Thanks again for helping me."
			else
				usr << "<b><span style=\"color:blue;\">Alyssa: </span>Hey there! You look like someone with too much time on their hands."
				sleep(15)
				usr << "<b><span style=\"color:blue;\">Alyssa: </span>How would you like to help me out?"
				switch(input("What do you say?","Make a selection")in list("What do you need help with?","No thanks"))
					if("What do you need help with?")
						usr << "<b><span style=\"color:blue;\">Alyssa: </span>Well I've been reading this book I found! There's a recipe here for a potion that makes anyone immortal!"
						sleep(15)
						usr << "<b><span style=\"color:blue;\">Alyssa: </span>I just don't have all the ingredients I need, can you help me find some?!"
						switch(input("Will you help Alysaa find the potion ingredients?","Make a selection")in list("Certainly!","I've got better things to do"))
							if("Certainly!")
								usr << "<b><span style=\"color:blue;\">Alyssa: </span>Oh wonderful! I know people around here make potions. Maybe they have some ingredients stashed away in there houses."
								sleep(15)
								usr << "<b><span style=\"color:blue;\">Alyssa: </span>I'm not saying to steal them....Just borrow them. Indefinitely."
								sleep(15)
								usr << "<b><span style=\"color:blue;\">Alyssa: </span>There's probably some growing around too. Here's my list!"
								new/obj/items/AlyssaScroll(usr)
								alert("Alyssa hands you her list of potion ingredients")
								usr << "<b><span style=\"color:blue;\">Alyssa: </span>Thanks!"
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

obj/questDecor/Todd
	icon = 'Todd.dmi'
	icon_state = "Lacerated Todd"

	proc
		Animation()
			set waitfor = 0

			if(icon_state == "Healthy Todd") return

			icon_state = "Healthy Todd"
			sleep(1)
			animate(src, transform = turn(matrix(), 90), time = 10)
			sleep(200)
			animate(src, transform = null, time = 10)
			sleep(11)
			icon_state = "Lacerated Todd"
