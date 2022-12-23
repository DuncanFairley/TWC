mob/TalkNPC

	quest
		Training_Dummy
			icon = 'Mobs.dmi'
			icon_state="dummy"

			Mk1
				name = "Dummy Mk-I"
				questPointers = "Battle Training I"
				melee = 1
				level = 1100
			Mk2
				name = "Dummy Mk-II"
				questPointers = "Battle Training II"
				holdAttackChance = 30
				level = 1200
			Mk3
				name = "Dummy Mk-III"
				questPointers = "Battle Training III"
				level = 1300
			Mk4
				name = "Dummy Mk-IV"
				questPointers = "Battle Training IV"
				dropAttack = 1
				level = 1400
			Mk5
				name = "Dummy Mk-V"
				questPointers = list("Battle Training V", "Battle Training \[Daily]")
				dropAttack     = 1
				incindiaChance = 10
				bombChance     = 35
				level = 1500

			questStart(mob/Player/i_Player, questName)
				var/ScreenText/s = new(i_Player, src)
				s.AddText("[src] is itching for a fight.")

				..(i_Player, questName)

			questOngoing(mob/Player/i_Player, questName)
				.=..(i_Player, questName)
				var/ScreenText/s = new(i_Player, src)
				s.AddText("[src] is itching for a fight.")

			questCompleted(mob/Player/i_Player, questName)
				var/ScreenText/s = new(i_Player, src)
				s.AddText("[src] is itching for a fight.")

	Chase
		icon_state="tim"

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr

			var/ScreenText/s = new(p, src)

			var/turf/t = locate(x, y-1, z)
			var/amount = 0
			for(var/obj/items/wearable/title/Slayer/title in t)
				if(title.owner == p.ckey)
					amount += title.stack
					title.Dispose()

			if(amount > 0)
				s.AddText("Make good use of my teachings.")

				p.Slayer.add(amount * 10000, p, 1)
			else
				s.AddText("I heard you've slain a lot of monsters, place slayer titles in the blood plate as proof and I will teach you how to make gods bleed.")

	Todd
		icon_state="fred"
		name = "Todd The Elite"

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr

			var/ScreenText/s = new(p, src)

			var/amount = 0
			for(var/obj/items/elite/e in p)
				amount += e.stack * (e.level) ** 3 * 40
				e.Dispose()

			if(amount > 0)
				s.AddText("Let me show you the difference between us and the wild monsters.")

				p.Slayer.add(amount, p, 1)
			else
				s.AddText("Bring me proof you've slain elites or we have nothing to discuess.")


mob/TalkNPC/quest

	Todd
		icon_state="lord"
		name = "Todd One Eye"
		questPointers = "The Elite \[Repeatable]"

		questStart(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			s.AddText("Hello there young slayer, I see you've wandered into our humble guild, we are experts in slaying.")
			s.AddText("Some people like reading books but not me, I like to feel the heat of blood spilling from the corpses of my enemies. It's got nothing to do with the fact I have one eye... I can still read...")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			if(.)
				s.AddText("You smell of blood.")
			else
				s.AddText("Yes, I am Todd and Todd is my brother. We are Todd.")

		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)
			s.AddText("Yes, I am Todd and Todd is my brother. We are Todd.")

	Girl
		icon_state = "girl"
		questPointers = "Stolen by the Lord"

		questStart(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			s.AddText("Help help!")
			s.AddText("My mom left to go to the store and told me to watch my little brother.")
			s.AddText("I needed to get something from my room and when I came back, my little brother was gone, help me find my little brother!")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			s.AddText("Did you find him yet?!?")

			if(.)
				s.AddText("THANK YOU THANK YOU THANK YOU!")
				s.AddText("Here, this is my allowance that I saved up, you can have it.")
			else
				s.AddText("No?! What is taking you so long, my poor little brother is in danger!")

		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)
			s.AddText("Thanks again!")


	Tammie
		icon_state = "tammie"
		questPointers = "Demonic Ritual"

		questStart(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			s.AddText("Did you know there's a ritual that makes you stronger, apparently it involves gathering demonic essences, I wonder how you do that, maybe you have to kill a demonic creature.")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			if(.)
				s.AddText("Wow, I can't believe you went and killed all those little innocent cute rats.")
			else
				s.AddText("It will be a little cruel to collect demonic essences...")

		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)
			s.AddText("You're evil.")

	Blotts
		icon_state = "blotts"
		questPointers = list("Blue Books: Vol I", "Blue Books: Vol II","Blue Books: Vol III", "Blue Books: Vol IV", "Blue Books: Vol V")

		questStart(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("Blue Books: Vol I")
					s.AddText("Hey there, you look quite strong, the other day I found this blueprint you can use to build wood structures.")
					s.AddText("You can probably use student housing area west of the castle to build.")
					s.AddText("Why don't you gather some wood and come back to me.")
				if("Blue Books: Vol II")
					s.AddText("Hello, I can get Hogwarts to give you a special blueprint if you help them get rid of some threats.")
					s.AddText("Slay some monsters and chop some wood, return to me when you are done.")
				if("Blue Books: Vol III")
					s.AddText("Hey, if you want, maybe you should place some books in your house, some reading can't hurt.")
					s.AddText("I tell you what, my friend Tom has a serious rat problem, help him out and I'll give you a new blueprint.")
				if("Blue Books: Vol IV")
					s.AddText("Hey, I found another blueprint involving stone, why don't you go smash some rocks and come back to me.")
				if("Blue Books: Vol V")
					s.AddText("You should go talk to the green men, they told me they have a blueprint you could use.")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("Blue Books: Vol I")
					if(.)
						s.AddText("Nice, you're quite the woodcutter. Here you can have this blueprint.")
						s.AddText("Equip it in student housing area, I'm sure you'll build great things.")
					else
						s.AddText("You can find quality trees in student housing, try using some spells on those.")
				if("Blue Books: Vol II")
					if(.)
						s.AddText("Nice, I hope you build great things with this.")
					else
						s.AddText("I'll be waiting for you here.")
				if("Blue Books: Vol III")
					if(.)
						s.AddText("You should probably read actual books while you are reading in this game.")
					else
						s.AddText("I wonder who is the evil rat breeder who keeps releasing rats in his bar's basement.")
				if("Blue Books: Vol IV")
					if(.)
						s.AddText("Nice, quite the miner, here you can have the blueprint.")
					else
						s.AddText("Stones are harder to get compared to wood.")
				if("Blue Books: Vol V")
					if(.)
						s.AddText("Oh? You can't read the papers they gave you? Here let me translate it for you.")
					else
						s.AddText("I hear they run a lovely shop...")
		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)
			s.AddText("Those bookshelves might contain more blueprints, who knows.")

	Divo
		icon_state = "divo"
		questPointers = list("Cloak of Invisibility", "Cloak of Visibility")

		questStart(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			if(questName == "Cloak of Invisibility")
				s.AddText("You there! You see this shop? It used to be mine, I sold the best invisibility cloak knock offs.")
				s.AddText("Tell you what, if you bring me a certain combination of furr and skins I'll make you a nice invisibility cloak.")
			else
				s.AddText("So, your invisibility cloak is losing it's effect? Don't worry, all we need to do is apply some demonic essences.")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			if(.)
				s.AddText("This cloak is not as good as my previous knock offs, that damned minister of magic prohibted hunting the creatures whose skins I used.")
				s.AddText("Don't worry, when the cloak loses it's magic come back to me and I'll help you.")
			else
				s.AddText("Those demonic essences are very annoying to get.")

		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)
			s.AddText("Come back later when the cloak becomes less... invisible, I'll help you renew it's charm.")

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
					s.AddText("My brother was badly injured by some thugs wearing masks. I need you to brew a potion of any sort.")
					i_Player << "<i>You notice paleness in the brother's face as well as the red gashes all over his legs. He certainly won't be conscious for very long if he doesn't get treatment.</i>"
					s.AddText("You can create a potion in the <b>Potions Classroom</b> near the Slytherin Common room in Hogwarts.")

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
		icon = 'MaleVampire.dmi'
		questPointers = list("Pumpkin Harvest", "Breath of Life", "Breath of Death \[Daily]")

		questStart(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("Pumpkin Harvest")
					s.AddText("You there! Fresh meat! Why don't you clean up my crypt, it's full of disgusting pumpkins. You fresh meats love pumpkins, now go harvest!")
				if("Breath of Life")
					s.AddText("I desire to become more human-like. Why don't you put your fleshy fingers to good use and help me gather a few ingredients, I'll make it worth your while!")
				if("Breath of Death \[Daily]")
					s.AddText("You must be wondering how I came to be - I wasn't always this sexy. I used to be a lifeless corpse, just one of many.")
					s.AddText("One day, this mysterious masked wizard hid inside my crpyt. Once he'd left, he accidently dropped this dark greenish stone fragment right ontop of my grave.")
					s.AddText("It was on this day that I was reborn! Alive but not, I will roam this earth forever!")
					s.AddText("The stone is of no use to me now and I worry that the wizard might come back for it. Tell you what, if you can complete one last task for me, I will give you the stone fragment.")
					s.AddText("I may have resurrected a few more corpses with this fragment, go kill them! I wish to be the only undead around here. Oh, and while you're at it, kill some more pumpkins for me - I hate pumpkins.")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)
			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("Pumpkin Harvest")
					if(.)
						s.AddText("You better not have broken anything, if I find one urn out of place, I'LL EAT YOUR FLESH! Ahem, sorry, thank you for your hard work. Finally my grave is clean and free of those nasty pumpkins!")
					else
						s.AddText("Yuck, pumpkins!")
				if("Breath of Life")
					if(.)
						s.AddText("Finally I can disguise myself as one of you and walk amongst the living! I'll be the prettiest human in town!")
					else
						s.AddText("I actually used to be a professor at Hogwarts, many years ago...")
				if("Breath of Death \[Daily]")
					if(.)
						s.AddText("As agreed, here is the stone fragment I spoke of.")
					else
						s.AddText("Remember to slay all the pumpkins, I REALLY hate pumpkins!")

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
		                     "Extreme Pest Extermination",
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
				s.AddText("Good job!")
			else
				s.AddText("Go back out there and exterminate some pests!")

		questCompleted(mob/Player/i_Player, questName)
			var/ScreenText/s = new(i_Player, src)
			s.AddText("You've done a really good job exterminating all those monsters.")

	Zerf
		icon_state = "stat"
		questPointers = list("PvP Introduction", "Culling the Herd", "Strength of Dragons")

		questStart(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("PvP Introduction")
					s.AddText("Your skin looks so young and fresh, you haven't done much fighting eh? Why don't you try to fight a bunch of players?")
				if("Culling the Herd")
					s.AddText("Let's kill some people... A lot of people!")
				if("Strength of Dragons")
					s.AddText("Show me what you're made of, if you're strong enough I will give you a wand so powerful it contains the strength of dragons!")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			switch(questName)
				if("PvP Introduction")
					if(.)
						s.AddText("Good job but we're just getting started!")
					else
						s.AddText("You aren't going to get any better by not fighting!")
				if("Culling the Herd")
					if(.)
						s.AddText("Mawhahahaha! THEY'RE ALL DEAD!")
					else
						s.AddText("Kill or be killed, my friend.")
				if("Strength of Dragons")
					s.AddText("Hmm... I don't know, are you really ready?")


		questCompleted(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			if(i_Player.level == lvlcap)
				s.AddText("Why not try some matchmaking in the ranked arena?")
			else
				s.AddText("When you reach level cap, why not try some matchmaking in the ranked arena?")


	Cassandra
		icon_state="alyssa"
		questPointers = list("Make a Fortune", "Make a Spell", "Make a Wig")

		questStart(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			var/questPointer/pointer = i_Player.questPointers["Make a Potion"]
			if(!pointer || pointer.stage)
				s.AddText("You should try helping my twin sister Alyssa, she's sitting at Three Broom Sticks, I hear she seeks an immortality potion.")
				return

			if(i_Player.level < lvlcap)
				s.AddText("Look at you, such a weakling can not possibly help me.")
				return

			switch(questName)
				if("Make a Fortune")
					s.AddText("Hey there, do you wish to make a fortune?! Well, you've come to the right place, I have a task for you, go out there to the world and collect a peice of the rarest monsters to be found, their fine essence will be sold for millions!")
				if("Make a Spell")
					s.AddText("You who helped me once before, how about you help me again, thanks to you I'm rich but sadly gold can not buy me true love, however, I did manage to find a way to fulfil my desires.")
					s.AddText("There is a spell capable of changing the laws of magic, this will help me find what I seek. You'll have to do what you did last time only this time I need you to collect more powerful elements.")
				if("Make a Wig")
					s.AddText("Hey... Am I pretty? This boy rejected me... I'm rich and powerful but it's not enough, I want to be the most beautiful girl in the world-- nay, the universe! You my dear slave will help me accomplish that goal!")

			..(i_Player, questName)

		questOngoing(mob/Player/i_Player, questName)
			.=..(i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			if(.)
				switch(questName)
					if("Make a Fortune")
						s.AddText("Hmmph! I could've done it myself but I'm a lady, here you can have this scarf, I don't need it anymore...")
						i_Player << errormsg("Cassandra takes the monster essences you've collected, she's going to make a fortune while you can warm yourself up with her old scarf.")
					if("Make a Spell")
						s.AddText("Hmmph! I could've done it myself but I'm a lady, here you can have this wand, I don't need it anymore...")
						i_Player << errormsg("Cassandra takes the monster essences you've collected. She's going to be extremely powerful and get all her heart's desires while you are stuck with an old stick.")
					if("Make a Wig")
						s.AddText("GIVE ME, GIVE ME, I will be the fairest of them all!")
						i_Player << errormsg("You decide Cassandra is a bitch and you're done running errands for her, you create and keep the wig for yourself, this girl is nothing but trouble.")

						for(var/obj/items/Alyssa/i in i_Player)
							i.Dispose()
			else
				s.AddText("Maybe I was wrong about you, maybe you aren't capable of defeating such rare monsters.")

		questCompleted(mob/Player/i_Player, questName)

			var/ScreenText/s = new(i_Player, src)

			s.AddText("I hate you...")


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
			usr.dir = get_dir(usr, src)
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
				p << infomsg("You find an Onion Root!")
				new/obj/items/Alyssa/Onion_Root(usr)

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
				p << infomsg("You find some Indigo Seeds!")
				new/obj/items/Alyssa/Indigo_Seeds(usr)

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
				p << infomsg("You find some Silver Spider Legs!")
				new/obj/items/Alyssa/Silver_Spider_Legs(usr)

	Salamander_Drop
		Ror1
			r = 1
		Ror2
			r = 2
		Ror3
			r = 3
		open(mob/Player/p)
			.=..()
			if(. && p.checkQuestProgress("Salamander Drop"))
				p << infomsg("You find some Salamander Drop!")
				new/obj/items/Alyssa/Salamander_Drop(usr)

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
						Dispose()
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

