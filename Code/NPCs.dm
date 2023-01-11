mob
	TalkNPC
		icon = 'NPCs.dmi'
		mouse_over_pointer = MOUSE_HAND_POINTER

		density = 1

		verb
			Talk()

		Click()
			if(src in oview(3))
				usr.dir = get_dir(usr, src)
				Talk()
			else
				usr << errormsg("You need to be closer.")

		StatChangeMan
			name = "Demetrius"
			icon_state = "goblin1"

			Talk()
				set src in oview(3)
				var/mob/Player/p = usr

				var/ScreenText/s = new(p, src)

				var/gold/g = new (p)
				if(!g.have(250000))
					s.AddText("Well hello there, [usr.gender == MALE ? "sonny" : "young lady"]. Unfortunately you need 25 gold coins before I am able to help you.")
				else
					s.AddText("Would you like to reset your stat points? It will cost 5 gold coins.")
					s.SetButtons("Yes", "#00ff00", "No", "#ff0000", null)

					if(!s.Wait()) return

					if(s.Result == "Yes")
						g = new (p)
						if(g.have(250000))
							hearers(p) << npcsay("Demetrius: There you go, [p.gender == MALE ? "sonny" : "young lady"] - your stats are reset!")
							g.change(gold=-25)
							g.give(p, 1)
							p.resetStatPoints()
							p.HP = usr.MHP
							p.MP = usr.MMP
							p.updateHPMP()


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
							usr:pdeaths = 0
							usr:pkills = 0
							usr << infomsg("Your player kills and deaths have been reset.")
						else
							usr << errormsg("You don't have enough spell points. You need [60 - usr:spellpoints] more spell points.")
					if("Rename - 25 Spell Points")
						if(usr:prevname)
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
							Log_admin("[usr] has changed their name to [desiredname]")

							desiredname = uppertext(copytext(desiredname, 1, 2)) + copytext(desiredname, 2)

							usr.name = desiredname
							usr:addNameTag()
							usr:spellpoints -= 25
						else
							usr << errormsg("You don't have enough spell points. You need [25 - usr:spellpoints] more spell points.")
		VaultGoblin
			name="Vault Master"
			icon_state="goblinvault"

			Talk()
				set src in oview(2)
				if(worldData.globalvaults[usr.ckey])
					var/vault/V = worldData.globalvaults[usr.ckey]
					switch(input("What would you like to change about your vault?")as null|anything in list("Change who can enter my vault", "Transfer items from old vault to new vault"))
						if("Change who can enter my vault")
							if(V.allowedpeople && V.allowedpeople.len)
								switch(alert("Would you like to allow someone to enter your vault, or remove someone's permission from entering?",,"Allow someone","Deny someone","Cancel"))
									if("Allow someone")
										var/mob/Player/M = input("Who would you like to allow to enter your vault at any time?") as null|anything in Players(list(usr))
										if(M)
											if(istext(M))
												M = text2mob(M)
											V.add_ckey_allowedpeople(M.ckey)
											usr << npcsay("Vault Master: [M.prevname ? M.prevname : M.name] can now enter your vault at any time. See me again if you wish to change this.")
									if("Deny someone")
										var/list/name_ckey_assoc = V.name_ckey_assoc()
										var/M = input("Who would you like to deny entrance to vault?") as null|anything in name_ckey_assoc
										if(M)
											V.remove_ckey_allowedpeople(name_ckey_assoc[M])
											usr << npcsay("Vault Master: [M] can no longer enter your vault.")
							else
								if(Players.len == 1)
									//Not any people to do anything with
									alert("There's nobody left you can add.")
									return
								var/mob/Player/M = input("Who would you like to allow to enter your vault at any time?") as null|anything in Players(list(usr))
								if(M)
									if(istext(M))
										M = text2mob(M)
									V.add_ckey_allowedpeople(M.ckey)
									usr << npcsay("Vault Master: [M.prevname ? M.prevname : M.name] can now enter your vault at any time. See me again if you wish to change this.")
						else
							usr << npcsay("Vault Master: See me again if you need to change anything with your vault.")

				else if(fexists("[swapmaps_directory]/map_[usr.ckey].sav"))
					usr << npcsay("Vault Master: Hi there.")
					worldData.globalvaults[usr.ckey] = new /vault()
					//Attempted fix for #373
				else
					if(alert("Do you want a free vault where you can store your belongings?","Vault","Yes","No") == "Yes")
						if(!fexists("[swapmaps_directory]/map_[usr.ckey].sav"))
							usr << npcsay("Vault Master: Okay, I've allocated you some space down in Vault [rand(10,99)][pick("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")]")
							usr << npcsay("Vault Master: Anything you drop in there will be safely kept and available to you at any time. ((If you create a new character, your vault will retain its contents, so it's a good way to transfer your stuff if you want to remake.))")
							if(!islist(worldData.globalvaults))
								worldData.globalvaults = list()
							var/vault/v = new
							v.version = VAULT_VERSION
							worldData.globalvaults[usr.ckey] = v
							var/swapmap/map = SwapMaps_CreateFromTemplate("vault1")
							map.SetID("[usr.ckey]")
							map.Save()
					else
						usr << npcsay("Vault Master: Maybe next time.")
obj
	Ghost
		name = "Hogwarts Ghost"
		icon = 'NPCs.dmi'
		alpha = 100
		density = 0
		layer = 10
		mouse_over_pointer = MOUSE_HAND_POINTER
		appearance_flags = LONG_GLIDE
		glide_size = 4

		New()
			..()

			if(prob(51))
				icon   = 'FemaleStaff.dmi'
				gender = FEMALE
			else
				icon   = 'MaleStaff.dmi'
				gender = MALE

			GenerateIcon(src)

			namefont.QuickName(src, src.name, top=1)

			animate(src, pixel_y = pixel_y +1, time = 7, loop = -1)
			animate(pixel_y = pixel_y -1, time = 7)

			walk_rand(src, 8)


mob/TalkNPC
	Respec
		name = "Vampire Historian"
		icon = 'FemaleVampire.dmi'
		Talk()
			set src in oview(3)

			var/mob/Player/p = usr
			if(p.screen_text) return
			var/rating = p.getRep()

			var/ScreenText/s = new(usr, src)

			if(p.getRep(1) >= 800)

				s.AddText("Hey, I can help you wipe your past sins (player kills/deaths) but be warned, you will be less famous if you do so (800 reputation).")
				s.AddButtons(0, 0, "No", "#ff0000", "Yes", "#00ff00")
				if(s.Wait())
					s.AddButtons("OK", null, 0,0,0,0)
					if(s.Result == "Yes")
						p.pdeaths = 0
						p.pkills  = 0

						if(rating > 0)
							p.addRep(-800)
						else
							p.addRep(800)

						s.AddText("It is done, noone will know your kill/death history.")
					else
						s.AddText("Our past actions determine who we are.")
			else
				s.AddText("You're a nobody, walk away.")


		New()
			..()
			GenerateIcon(src, wig = 0, shoes = 1, scarf = 1)

obj/items/riddle_scroll
	icon_state = "wrote"
	icon = 'Scroll.dmi'

	Click()
		if(src in usr)
			var/obj/magic_force/m = locate() in range(3)
			if(!m)
				usr << errormsg("This riddle is unreadable.")
				return

			usr << infomsg("Hey look, a new riddle, can you solve that one?")
			m.pickRiddle()
			Consume()
		else
			..()

obj/magic_force

	icon               = 'misc.dmi'
	icon_state         = "black"

	mouse_over_pointer = MOUSE_HAND_POINTER
	mouse_opacity      = 2
	layer              = 4

	var
		riddle
		item

		tmp
			count = 8

	Click()

		if(src in oview(3))
			var/mob/Player/p = usr
			p.dir = get_dir(p, src)

			if(count <= 0)

				if(worldData.currentEvents && worldData.currentEvents.len > 5)
					p << errormsg("You can't use this while an event is running.")
					return

				count = 8

				for(var/obj/fadeIn/flame/f in orange(5, src))
					f.Dispose()

				var/list/events = list(/RandomEvent/Sword    = 40,
									   /RandomEvent/Ghosts   = 30,
									   /RandomEvent/Invasion = 20)
				if(!worldData.elderWand)
					events[/RandomEvent/Golem] = 25

				var/event = pickweight(events)
				var/RandomEvent/e = locate(event) in worldData.events
				e.start()
			else
				var/ScreenText/s = new(p, src)

				var/obj/o = locate(item) in loc
				if(o)
					count--
					o.Dispose()

					for(var/obj/Columb/c in orange(5, src))
						if(!(locate(/obj/fadeIn/flame) in c.loc))
							new /obj/fadeIn/flame (c.loc)
							break
					pickRiddle()
					s.AddText("You solved the riddle.")
				else
					s.AddText("A voice whispers in your ear...<br>[riddle]")

	New()
		..()

		pickRiddle()

	proc/pickRiddle()
		var/list/riddles = list(
		"Rare... magical... desired by goblins."                                    = /obj/items/artifact,
		"Let's make a deal... with the devil..."                                    = /obj/items/crystal/soul,
		"I used to be a tree like you then I took an arrow in the knee."            = /obj/items/wood_log,
		"Do you wanna build a stoneman"                                             = /obj/items/stones,
		"Are you lucky?"                                                            = /obj/items/crystal/luck,
		"I like both the sword and the shield."                                     = /obj/items/crystal/magic,
		"The sword is my favorite tool."                                            = /obj/items/crystal/damage,
		"The shield is my favorite tool."                                           = /obj/items/crystal/defense,
		"Before you say goodbye, I am the ones you have to tie!"                    = /obj/items/wearable/shoes,
		"It's cold..."                                                              = /obj/items/wearable/scarves,
		"I name thee..."                                                            = /obj/items/wearable/title,
		"I wear thee..."                                                            = /obj/items/wearable,
		"Color me blind but your wand could use a little shine!"                    = /obj/items/colors,
		"Come to the Dark side."                                                    = /obj/items/DarknessPowder,
		"This item prevents a liquid's spill, and for its use to the brim we fill." = /obj/items/bucket,
		"Unlock me!"                                                                = /obj/items/key)

		var/i = rand(1, riddles.len)

		if(riddle == riddles[i])
			for(var/j = 1 to riddles.len)
				if(riddles[j] != riddle)
					i = j
					break

		riddle = riddles[i]
		item   = riddles[riddle]

		animate(loc, color = rgb(rand(60, 220), rand(60, 220), rand(60, 220)), time = 15)
