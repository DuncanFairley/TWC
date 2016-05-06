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
					if(usr.gold.get() < 50000)
						hearers(usr) << npcsay("Demetrius: Well hello there, [usr.gender == MALE ? "sonny" : "young lady"]. Unfortunately you need 50,000 gold before I am able to help you.")
					else
						switch(alert("Would you like to reset your stat points? It will cost 50,000 gold.",,"Yes","No"))
							if("Yes")
								if(usr.gold.get() >= 50000)
									hearers(usr) << npcsay("Demetrius: There you go, [usr.gender == MALE ? "sonny" : "young lady"] - your stats are reset!")
									usr.gold.add(-50000)
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
							Log_admin("[usr] has changed their name to [desiredname].")

							desiredname = uppertext(copytext(desiredname, 1, 2)) + copytext(desiredname, 2)

							usr.name = desiredname
							usr:addNameTag()
							usr:spellpoints -= 25
						else
							usr << errormsg("You don't have enough spell points. You need [25 - usr:spellpoints] more spell points.")
		PyramidMan
			name="Mysterious Old Man"
			icon_state="pyramid"
			density=1

			verb
				Examine()
					set src in oview(3)
					usr << "I wonder how he got past the floating eyes..."

			Talk()
				set src in oview(3)
				alert("Go back the way you came...the pyramid is not ready to reveal itself yet...")
				alert("*The old man laughs very oddly*")
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
							worldData.globalvaults[usr.ckey] = new /vault()
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

	Shop
		var/shop


		vampire
			icon = 'FemaleVampire.dmi'
			Chaos
				name  = "Chaos Shopkeeper"
				shop = "chaos"
			Peace
				name  = "Peace Shopkeeper"
				shop = "peace"

			New()
				..()
				GenerateIcon(src, wig = 0, shoes = 1, scarf = 1)

			Talk()
				set src in oview(3)
				var/mob/Player/p = usr
				if(p.screen_text) return

				var/ScreenText/s = new(p, src)
				s.AddText("Hey there, I offer special items for those who helped our cause. (Warrior and above)")

				Shop(p, s)

			Buy(mob/Player/p, obj/items/i, price)
				p.addRep(-i.price)

				var/obj/items/newItem = new i.type
				newItem.Move(p)

			canAfford(mob/Player/p)
				var/rating = p.getRep()

				if(abs(rating) <= 1200) return 0

				return p.getRep(1) * (rating > 0 ? 1 : -1)


		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			if(p.screen_text) return

			Shop(usr)

		proc
			Shop(mob/Player/p, ScreenText/s)

				if(!s) s = new(p, src)

				else
					if(!s.Wait(0)) return

				var/i = 0
				var/list/shopRef = shops[shop]
				var/obj/items/o

				s.Result = "Next"
				while(p && s.Result == "Next" && !s.isDisposed)
					i++
					if(i > shopRef.len) i = 1
					o = shopRef[i]

					s.SetText("Would you like [o.name] for [abs(o.price)] reputation?")
					s.SetImage(o)

					var/nextItem = shopRef.len == 1 ? 0 : "Next"
					if((canAfford(usr) >= o.price && o.price > 0) || (canAfford(usr) <= o.price && o.price < 0))
						s.SetButtons("Buy", "#00ff00", "Cancel", "#ff0000", nextItem, "#2299d0")
					else
						s.SetButtons(0, 0, "Cancel", "#ff0000", nextItem, "#2299d0")

					if(!s.Wait(0)) break

				if(!p)
					s.Dispose()
					return

				s.SetButtons("OK")
				s.SetImage(src)
				if(s.Result == "Buy")
					Buy(usr, o)
					s.SetText("Enjoy your new item.")
				else
					s.SetText("Hopefully I'll have something you want next time.")

			Buy(mob/Player/p, obj/items/i, price)
				p.gold.subtract(i.price)

				var/obj/items/newItem = new i.type
				newItem.Move(p)


			canAfford(mob/Player/p)
				return p.gold.get()



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