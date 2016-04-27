/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
obj/movablewall
	name = "Brick Wall"
	icon = 'wall1.dmi'
	density = 1
	var/dir2go = -1
	proc/rumble()
		if(initial(x) == x)
			loc = locate(x+dir2go,y,z)
		else
			loc = locate(initial(x),y,z)
var/functioning = 0
mob/Bump(obj/movablewall/O)
	..()
	src = null
	if(!istype(O,/obj/movablewall)) return

	if(!functioning)
		spawn()
			functioning = 1
			for(var/obj/movablewall/W in range(20,O))
				spawn(rand(1,30))W.rumble()
			sleep(150)
			for(var/obj/movablewall/W in range(20,O))
				spawn(rand(1,30))W.rumble()
			functioning = 0
proc/npcsay(T as text)
	return "<span style=\"color:#1eff00;\">[T]</span>"
proc/errormsg(T as text)
	return "<span style=\"color:#E32020;\"><i>[T]</i></span>"
proc/announcemsg(T as text)
	return "<span style=\"color:#27BBF5; font-size:3;\"><b>[T]</b></span>"
proc/infomsg(T as text)
	return "<span style=\"color:#27BBF5;\">[T]</span>"
mob/TalkNPC/male_wigseller
	name="Wig Salesman"
	icon_state="mwig"
	Immortal=1
	Gm=1

	Talk()
		set src in oview(4)
		usr << npcsay("Wig Seller says: Welcome to our little wig shop, use the mirrors to select a wig of your liking!")

mob/TalkNPC/female_wigseller
	name="Wig Saleswoman"
	icon_state="fwig"
	Immortal=1
	Gm=1

	Talk()
		set src in oview(4)
		usr << npcsay("Wig Seller says: Welcome to our little wig shop, use the mirrors to select a wig of your liking!")

mob/TalkNPC/quest/Tammie
	icon_state = "tammie"
	NPC = 1
	Immortal=1
	questPointers = "Demonic Ritual"
	Talk()
		set src in oview(3)
		..()
		var/mob/Player/p = usr
		var/questPointer/pointer = p.questPointers["Demonic Ritual"]
		if(pointer)
			if(pointer.stage)
				if(p.checkQuestProgress("Tammie"))
					p << npcsay("Tammie: Wow, I can't believe you went and killed all those little innocent cute rats.")
				else
					p << npcsay("Tammie: It will be a little cruel to collect demonic essences...")
				return
			else
				p << npcsay("Tammie: You're evil.")
		else
			p << npcsay("Tammie: Did you know there's a ritual that makes you stronger, apparently it involves gathering demonic essences, I wonder how you do that, maybe you have to kill a demonic creature.")
			p.startQuest("Demonic Ritual")

mob/Tom_
	icon = 'NPCs.dmi'
	icon_state="tom"
	NPC = 1
	Immortal=1
	Gm=1
	density=1

mob/TalkNPC/quest/Tom
	icon_state="tom"
	NPC = 1
	density=1
	Immortal=1
	Gm=1
	questPointers = "Rats in the Cellar"
	Talk()
		set src in oview(2)
		..()
		var/mob/Player/p = usr
		var/questPointer/pointer = p.questPointers["Tutorial: Quests"]
		if(pointer && pointer.stage == 2)
			p.checkQuestProgress("Tom")
		switch(input("Tom: Welcome to the Leaky Cauldron. What do ya wanna do?","You have [comma(usr.gold)] gold")as null|anything in list("Shop","Talk"))
			if("Talk")
				if("Rats in the Cellar" in p.questPointers)
					pointer = p.questPointers["Rats in the Cellar"]
					if(pointer.stage == 1)
						usr << npcsay("Tom: I will take you down to the cellar")
						sleep(10)
						if(get_dist(usr,src)<5)
							p.Transfer(locate(70,55,26))
							var/mob/TheTom = new/mob/Tom_(locate(70,56,26))
							usr << npcsay("Tom: This is as far as I'll go. Thank you again.")
							sleep(50)
							del TheTom
						else
							usr << npcsay("You hear a voice in your head: <i>Hey! You're not even here!</i>")
					else if(pointer.stage == 2)
						usr << npcsay("Tom stares at you in awe.")
						sleep(10)
						usr << npcsay("Tom: You did it!")
						sleep(10)
						usr << npcsay("Tom: Thank you so much! I don't have much to give you, but I can give you this.")
						p.checkQuestProgress("Tom")
					else
						usr << npcsay("Tom: Hey, Thanks again!")

				else
					usr << npcsay("Tom: Hello there, Professor Palmer sent me an owl about you.")
					switch(input("Tom: Did you come to help me?","Help?")in list("Yes","No"))
						if("Yes")
							usr << npcsay("Tom: Excellent!")
							sleep(10)
							usr << npcsay("Tom: I always store my beverages in a cellar below the ground in order to keep them cool, however recently there have been rats somehow getting in.")
							sleep(10)
							usr << npcsay("Tom: If you would be so kind as to get rid of all the rats, and stop them from getting back in. I would be very greatful.")
							switch(input("Tom: What do you say?","Help?")in list("Yes","No"))
								if("Yes")
									usr << npcsay("Tom: Thank you so much.")
									sleep(10)
									usr << npcsay("Tom: I will take you down to the cellar")
									sleep(10)
									if(get_dist(usr,src)<5)
										p.startQuest("Rats in the Cellar")
										usr.loc = locate(70,55,26)
										var/mob/TheTom = new/mob/Tom_(locate(70,56,26))
										usr << npcsay("Tom: This is as far as I'll go. Thank you again.")
										sleep(20)
										del TheTom
									else
										usr << npcsay("You hear a voice in your head: <i>Hey! You're not even here!</i>")
									return
								if("No")
									usr << npcsay("Tom: Alright then.")
									return
						if("No")
							usr << npcsay("Tom: My mistake. Carry on.")
							return
			if("Shop")
				if(usr.Year in list("1st Year","2nd Year","3rd Year",""))
					usr << npcsay("Tom: Sorry mate. Come back when you're older.")
				else
					usr << npcsay("Tom: Sorry mate. Those rats drank all of the beer.")
					/*var/obj/selecteditem
					var/selectedprice
					switch(input("Tom: What can I get for ya?","You have [comma(usr.gold)] gold")as null|anything in list("Draft Beer  50g","Iced Tea  50g"))
						if("Draft Beer  50g")
							selecteditem = /obj/Beer
							selectedprice = 50
						if("Iced Tea  50g")
							selectedprice = 50
							selecteditem = /obj/Tea
						if(null)
							usr << npcsay("Tom: Just gimme a holler if ya want anything.")
							return
					if(usr.gold < selectedprice)
						usr << npcsay("Tom: Ya don't have enough coin for that. I ain't budging on these prices - it's [selectedprice]g or nothing.")
					else
						usr.gold -= selectedprice
						ministrybank += taxrate*selectedprice/100
						new selecteditem(usr)
						usr << npcsay("Tom: There ya go. Enjoy.")
						usr:Resort_Stacking_Inv()*/
			if(null)
				usr << npcsay("Tom: Seeya later then.")

mob/test/verb/MagicEyes()
	alert("There are currently [worldData.magicEyesLeft] magic eyes left at Divo.")
	worldData.magicEyesLeft = input("How many would you like there to be?",,worldData.magicEyesLeft) as num

mob/TalkNPC/Divo
	icon_state="divo"
	NPC = 1
	Immortal=1

	Talk()
		set src in oview(2)
		var/obj/selecteditem
		var/selectedprice
		var/itemlist
		if(worldData.magicEyesLeft)
			itemlist = list("Magical Eye 20,000,000g","Invisibility Cloak 9000g")
		else
			itemlist = list("Invisibility Cloak 9000g")
		switch(input("Divo: Hi there! Welcome to Divo's Magical Wares. [worldData.magicEyesLeft ? "I've got a limited supply of these ultra rare magical eyes. They let you see invisible people. Very powerful stuff. I'm only going to sell a limited amount though, otherwise my cloak business would be pointless wouldn't it? I have [worldData.magicEyesLeft] left." : ""]","You have [comma(usr.gold)] gold")as null|anything in itemlist)
			if("Magical Eye 20,000,000g")
				selecteditem = /obj/items/wearable/magic_eye
				selectedprice = 20000000
			if("Invisibility Cloak 9000g")
				selectedprice = 9000
				selecteditem = /obj/items/wearable/invisibility_cloak
			if(null)
				usr << npcsay("Divo: Sorry that I don't have anything interesting to ya... ")
				return
		if(usr.gold.get() < selectedprice)
			usr<< npcsay("Divo: I'm running a business here - you don't have enough gold for this.")
		else
			if(selecteditem == /obj/items/wearable/magic_eye)
				worldData.magicEyesLeft--
			usr.gold.add(-selectedprice)
			worldData.ministrybank += worldData.taxrate*selectedprice/100
			new selecteditem(usr)
			usr << npcsay("Divo: Thank you.")
			usr:Resort_Stacking_Inv()

mob/TalkNPC/Blotts
	icon_state="blotts"
	NPC = 1
	Immortal=1

	Talk()
		set src in oview(2)
		var/obj/selecteditem
		var/selectedprice
		switch(input("Blotts: Hi there! Welcome to Flourish and Blotts. Do any titles interest you?","You have [comma(usr.gold)] gold")as null|anything in list("Basic COMC 500g","Monster book of Monsters 500g"))
			if("Basic COMC 500g")
				selecteditem = /obj/COMCText
				selectedprice = 500
			if("Monster book of Monsters 500g")
				selectedprice = 500
				selecteditem = /obj/MonBookMon
			if(null)
				usr << npcsay("Blotts: Come see me any time if you change your mind.")
				return
		if(usr.gold.get() < selectedprice)
			usr << npcsay("Blotts: Unfortunately you don't have enough for this book - it's [selectedprice]g.")
		else
			usr.gold.add(-selectedprice)
			worldData.ministrybank += worldData.taxrate*selectedprice/100
			new selecteditem(usr)
			usr << npcsay("Blotts: Thanks very much for your business!")
			usr:Resort_Stacking_Inv()

mob/TalkNPC/Ollivander
	icon_state="ollivander"
	var/swiftmode=0
	var/busy=0
	var/gdir
	var/const/nametext = "<b><span style=\";\">Ollivander</b>:</span><font color = white>"
	var/list/phrases = list("Hmm...","Uhmm...","Let's see here...","Possibly..? No. No that won't do.","Probably not.","I don't think so.", "Too flexible, I would think.","Oh yes; this will do very nicely.","Ahah! One of my finest!", "Oh yes. Nice and springy.","This one should suit perfectly.","Oh. Okay then.","I thought this one would be perfect, but you're the customer!","Pity... You could be great with this wand.","Fair enough.")

	Talk()
		set src in oview(3)
		var/mob/TalkNPC/Ollivander/Olli = src
		var/mob/Player/p = usr
		if(swiftmode)
			switch(alert("Ollivander: Welcome to Ollivander's Wand Shop - may I sell you a wand? They're 100 gold","You have [comma(usr.gold)] gold","Yes","No"))
				if("Yes")
					start
					var/length = rand(8,13)
					var/core = pick("Phoenix Feather", "Dragon Heartstring", "Veela Hair", "Unicorn Hair")
					var/wood = pick("Birch", "Oak", "Ash", "Willow", "Mahogany", "Elder")
					var/wandname = "[length] inch [wood] wand ([core])"
					switch(alert("This [wandname] costs 100 gold. Would you like to purchase it?","You have [comma(usr.gold)]","Yes","No"))
						if("Yes")
							if(usr.gold.get()>=100)
								view(7,Olli) << "[nametext] Here's your new [wandname], [usr]!"
								usr.gold.add(-100)
								worldData.ministrybank += worldData.taxrate*100/100
								var/obj/newwand
								switch(wood)
									if("Birch")
										newwand = new/obj/items/wearable/wands/birch_wand(usr)
									if("Oak")
										newwand = new/obj/items/wearable/wands/oak_wand(usr)
									if("Ash")
										newwand = new/obj/items/wearable/wands/ash_wand(usr)
									if("Willow")
										newwand = new/obj/items/wearable/wands/willow_wand(usr)
									if("Mahogany")
										newwand = new/obj/items/wearable/wands/mahogany_wand(usr)
									if("Elder")
										newwand = new/obj/items/wearable/wands/elder_wand(usr)
								newwand.name = wandname
								p.Resort_Stacking_Inv()
								if(p.checkQuestProgress("Ollivander"))
									p << npcsay("Ollivander: Oh you're just starting out eh? My friend Palmer can help you out, his name is Palmer, he is quite friendly.")
									p.startQuest("Tutorial: Friendly Professor")
							else
								usr << "You do not have enough gold at this time. Maybe you should check your bank account at Gringotts?"
						if("No")
							switch(alert("Would you like me to find you another wand?","You have [comma(usr.gold)]","Yes","No"))
								if("Yes")
									var/rnd = rand(12,15)
									usr << "[nametext] [Olli.phrases[rnd]]"
									goto start
								else
									usr << "[nametext] Have a nice day then!"
		else
			src = null
			spawn()
				if(Olli.busy)
					view(7,Olli) << "[nametext] I'm a little busy at the moment, [usr]. I'll be able to help you in a moment."
					return
				Olli.busy = 1

				if(locate(/obj/items/wearable/wands) in usr.contents)
					Olli.busy = 0
					view(7,Olli) << "[nametext] Ah, I remember you, [usr]. I believe I've already sold you a wand."
					if(p.checkQuestProgress("Ollivander"))
						p << npcsay("Ollivander: Oh you're just starting out eh? My friend Palmer can help you out, his name is Palmer, he is quite friendly.")
						p.startQuest("Tutorial: Friendly Professor")
				else
					var/answered = 0
					spawn(200)
						if(!answered)
							Olli.busy = 0
							return
					switch(alert("Ollivander: Welcome to Ollivander's Wand Shop - may I sell you a wand? They're 100 gold","You have [comma(usr.gold)] gold","Yes","No"))
						if("Yes")
							view(5,Olli) << "[nametext] Let me just take a look for you."
							start
							step(Olli, NORTH)
							sleep(4)
							Olli.gdir = WEST
							if(rand(0,1) == 1) Olli.gdir = EAST
							step(Olli, Olli.gdir)
							sleep(4)
							step(Olli, Olli.gdir)
							sleep(4)
							if(rand(0,1))
								step(Olli, Olli.gdir)
								sleep(4)
							if(rand(0,1))
								step(Olli, Olli.gdir)
								sleep(4)
							Olli.dir = NORTH
							sleep(4)
							var/rnd = rand(1,3)
							view(7,Olli) << "[nametext] [Olli.phrases[rnd]]"
							sleep(40)
							rnd = rand(4,7)
							view(7,Olli) << "[nametext] [Olli.phrases[rnd]]"
							sleep(4)
							step(Olli, Olli.gdir)
							sleep(4)
							if(rand(0,1))
								step(Olli, Olli.gdir)
								sleep(4)
							step(Olli,Olli.gdir)
							sleep(4)
							Olli.dir = NORTH
							sleep(35)
							rnd = rand(8,11)
							view(7,Olli) << "[nametext] [Olli.phrases[rnd]]"
							while(Olli.loc != initial(Olli.loc))
								sleep(3)
								step_to(Olli,initial(Olli.loc))
							Olli.dir = SOUTH
							var/length = rand(8,13)
							var/core = pick("Phoenix Feather", "Dragon Heartstring", "Veela Hair", "Unicorn Hair")
							var/wood = pick("Birch", "Oak", "Ash", "Willow", "Mahogany", "Elder")
							var/wandname = "[length] inch [wood] wand ([core])"
							if(!usr)
								view(7,Olli) << "How rude... I just got this wand ready, and they leave!"
								sleep(2)
								Olli.busy = 0
								return
							switch(alert("This [wandname] costs 100 gold. Would you like to purchase it?","You have [comma(usr.gold)] gold.","Yes","No"))
								if("Yes")
									if(usr.gold.get()>=100)
										view(7,Olli) << "[nametext] Here's your new [wandname], [usr]!"
										usr.gold.add(-100)
										worldData.ministrybank += worldData.taxrate*100/100
										var/obj/newwand
										switch(wood)
											if("Birch")
												newwand = new/obj/items/wearable/wands/birch_wand(usr)
											if("Oak")
												newwand = new/obj/items/wearable/wands/oak_wand(usr)
											if("Ash")
												newwand = new/obj/items/wearable/wands/ash_wand(usr)
											if("Willow")
												newwand = new/obj/items/wearable/wands/willow_wand(usr)
											if("Mahogany")
												newwand = new/obj/items/wearable/wands/mahogany_wand(usr)
											if("Elder")
												newwand = new/obj/items/wearable/wands/elder_wand(usr)
										newwand.name = wandname
										p.Resort_Stacking_Inv()
										if(p.checkQuestProgress("Ollivander"))
											p << npcsay("Ollivander: Oh you're just starting out eh? My friend Palmer can help you out, his name is Palmer, he is quite friendly.")
											p.startQuest("Tutorial: Friendly Professor")
									else
										usr << "You do not have enough gold at this time. Maybe you should check your bank account at Gringotts?"
								if("No")
									switch(alert("Would you like me to find you another wand?","You have [comma(usr.gold)] gold.","Yes","No"))
										if("Yes")
											rnd = rand(12,15)
											view(7,Olli) << "[nametext] [Olli.phrases[rnd]]"
											goto start
										else
											view(7,Olli) << "[nametext] Have a nice day then!"


					Olli.busy = 0

obj/Madame_Pomfrey
	bumpable=0
	density = 1
	icon='NPCs.dmi'
	icon_state="nurse"

	mouse_over_pointer = MOUSE_HAND_POINTER

	Click()
		if(usr in oview(src, 1))
			Heal_Me()
	verb
		Heal_Me()
			if(canUse(usr,cooldown=/StatusEffect/UsedFerulaToHeal))
				set src in oview(1)
				usr<<"<b><span style=\"color:green;\">Madam Pomfrey:</span><font color=aqua> Episkey [usr]!"
				new /StatusEffect/UsedFerulaToHeal(usr,10)
				usr.overlays+=image('attacks.dmi',icon_state="heal")

				var/maxHP = usr.MHP + usr.extraMHP
				usr.HP = min(maxHP, round(usr.HP + maxHP * 0.15 + rand(-15, 15), 1))

				usr.updateHPMP()
				src = null
				spawn(10)
					if(usr)
						usr.overlays-=image('attacks.dmi',icon_state="heal")

	New()
		..()
		view(src)<<"<b>Madame Pomfrey</b>: Hello. Need healing? Click me."
		spawn(500)
			flick('dlo.dmi',src)
			sleep(10)
			view(src)<<"The nurse orbs out."
			Dispose()


mob/Madame_Pomfrey
	NPC=1
	bumpable=0
	Gm=1
	Immortal=1
	icon='NPCs.dmi'
	icon_state="nurse"

	verb
		Heal_Me()
			set src in oview(1)
			usr<<"<b><span style=\"color:green;\">Madam Pomfrey:</span><font color=aqua> Episkey [usr]!"
			usr.overlays+=image('attacks.dmi',icon_state="heal")
			usr.HP=usr.MHP+usr.extraMHP
			usr.updateHPMP()
			src = null
			spawn(10)
				if(usr)
					usr.overlays-=image('attacks.dmi',icon_state="heal")

mob/AndersGoat
	NPC=1
	bumpable=0
	Immortal=1
	icon='Mobs.dmi'
	icon_state="goat"
	Gm=1
	//Names the NPC//Do i really need to say... Sets their ICON STATE
	New()//States that its calling a new something ^_^
		..()
		wander()//Calls the following PROC, which makes the NPC move by itself
	proc/wander()//Self-Explanatory
		//I have no idea what it does, but its required
		while(src)//As long as the src exists...
			walk_rand(src,rand(5,30))//This will happen...
			sleep(5)//And this tells it how long between each step it takes

mob/Turkey
	NPC=1
	bumpable=0
	Immortal=1
	icon='Turkey.dmi'
	Gm=1
	//Names the NPC//Do i really need to say... Sets their ICON STATE
	New()//States that its calling a new something ^_^
		..()
		wander()//Calls the following PROC, which makes the NPC move by itself
	proc/wander()//Self-Explanatory
		//I have no idea what it does, but its required
		while(src)//As long as the src exists...
			walk_rand(src,rand(5,30))//This will happen...
			sleep(5)



mob/TalkNPC/Broom_Salesman
	icon = 'NPCs.dmi'
	icon_state="wizard"
	item="Potion"
	name="Chrono"

	Talk()
		set src in oview(2)
		var/obj/selecteditem
		var/selectedprice
		switch(input("Chrono: Hi there! Welcome to Chrono's Brooms. We have two models in stock right now - would you like to purchase one?","You have [comma(usr.gold)] gold")as null|anything in list("Cleansweep Seven - 5,000g","Nimbus 2000 - 10,000g"))
			if("Cleansweep Seven - 5,000g")
				selecteditem = /obj/items/wearable/brooms/cleansweep_seven
				selectedprice = 5000
			if("Nimbus 2000 - 10,000g")
				selectedprice = 10000
				selecteditem = /obj/items/wearable/brooms/nimbus_2000
			if(null)
				usr << npcsay("Chrono: Come see me any time if you change your mind.")
				return
		if(usr.gold.get() < selectedprice)
			usr << npcsay("Chrono: Unfortunately you don't have enough for this broom - it's [selectedprice]g.")
		else
			usr.gold.add(-selectedprice)
			worldData.ministrybank += worldData.taxrate*selectedprice/100
			new selecteditem(usr)
			usr << npcsay("Chrono: Thanks very much for your business, and be careful on the pitch!")
			usr:Resort_Stacking_Inv()


obj/The_Dark_Mark
	icon = 'Mobs.dmi'
	icon_state="Darkmark"
	luminosity=21

	New()
		..()
		HP = rand(4,6)
		tag = "DarkMark"
		light(src, 10, 600, "green")
		spawn(600)
			if(loc)
				Players<<"The Dark Mark fades back into the clouds."
				Dispose()
	var/tmp
		HP
		list/people = list()
	proc/counter(mob/Player/i_Player)
		HP--
		if(!(i_Player in people))
			people += i_Player
		if(HP <= 0)
			var/txt = ""

			for(var/i = 1; i <= people.len; i++)
				if(!people[i]) continue

				var/mob/Player/p = people[i]

				if(i == 1)
					txt += p.name
				else if(i != people.len)
					txt += "[p.name], "
				else
					txt += " and [p.name]"

				if(p.ckey != owner)
					p.addRep(3)


			Players << "The Dark Mark was dispersed by [txt]."
			Dispose()
	Dispose()
		..()
		people = null

mob/Player/var/tmp/shop_index = 1
obj/shop

	var
		obj/parent

	New(obj/shop/parent, offset_x = 0, offset_y = 0)
		loc = locate(parent.x + offset_x, parent.y + offset_y, parent.z)
		src.parent = parent

	base
		var
			list
				images = list()
				items

		New(obj/shop/parent, offset_x = 0, offset_y = 0)
			..(parent, offset_x, offset_y)

			images += image('storehud.dmi',
							new /obj/shop/buttons/buy (src,0,3),
							"buy")

			images += image('storehud.dmi',
				            new /obj/shop/buttons/previous (src,-1,3),
				            "previous")

			images += image('storehud.dmi',
							new /obj/shop/buttons/next (src,1,3),
							"next")

			spawn(10)
				if(!items && (name in shops))
					items = shops[name]

		proc
			shop(mob/Player/M)
				if(!items)
					if(name in shops)
						items = shops[name]
					else return
				if(!items.len) return

				M.client.images += images
				M.shop_index = rand(1,items.len)
				update(1, M)

			unshop(mob/Player/M)
				if(!items)
					if(name in shops)
						items = shops[name]
					else return
				if(!items.len) return

				M.client.images -= images
				update(0, M)

			update(i, mob/Player/M)
				if(!items)
					if(name in shops)
						items = shops[name]
					else return
				if(!items.len) return

				var/obj/o = items[M.shop_index]
				M.overlays -= o.icon

				if(i != 0)
					if(i == 1)
						M.shop_index++
						if(M.shop_index > items.len)
							M.shop_index = 1

					else
						M.shop_index--
						if(M.shop_index < 1)
							M.shop_index = items.len
					o = items[M.shop_index]
					M.overlays += o.icon

					if(prob(10))
						var/txt = pick("Try a few more, maybe you will find something you like.", "Eww, this looks like you gained a couple pounds.", "Try this for size!", "This does not make you look fat! I promise!", "You look so hot! You can almost forget an ugly person walked into the store.")
						usr << npcsay("Magic Mirror says: [txt]")

		malewigshop

		femalewigshop

		random

	buttons
		mouse_over_pointer = MOUSE_HAND_POINTER

		previous
			Click()
				if(usr.loc != parent.loc) return
				parent:update(-1, usr)


		next
			Click()
				if(usr.loc != parent.loc) return
				parent:update(1, usr)
		buy

			Click()
				if(usr.loc != parent.loc) return
				var/obj/items/i = parent:items[usr:shop_index]

				var/actualPrice = round(i.price * shopPriceModifier, 1)

				if(usr.gold.get() < actualPrice)
					usr << infomsg("You don't have enough money for [i.name]. It costs [comma(actualPrice)]. You need [comma(actualPrice - usr.gold.get())] more gold.")
					return

				if(alert(usr, "Are you sure you want to buy [i.name] for [comma(actualPrice)] gold?","Are you sure?","Yes","No") == "Yes")
					if(usr.gold.get() >= actualPrice)
						new i.type (usr)
						usr << infomsg("You bought [i] for [comma(actualPrice)] gold.")
						usr.gold.add(-actualPrice)
						worldData.ministrybank += worldData.taxrate*actualPrice/100
						usr:Resort_Stacking_Inv()

						for(var/mob/Player/p in usr.loc)
							parent:unshop(p)

						if(i.limit > 0)
							i.limit--
							if(i.limit<=0)
								parent:items -= i
								del i

						for(var/mob/Player/p in usr.loc)
							parent:shop(p)

obj/items/var/tmp/limit = 0
var/shopPriceModifier = 1
var/list/shops = list("malewigshop" = newlist(
						/obj/items/wearable/wigs/male_black_wig,
						/obj/items/wearable/wigs/male_blond_wig,
						/obj/items/wearable/wigs/male_blue_wig,
						/obj/items/wearable/wigs/male_green_wig,
						/obj/items/wearable/wigs/male_grey_wig,
						/obj/items/wearable/wigs/male_pink_wig,
						/obj/items/wearable/wigs/male_purple_wig,
						/obj/items/wearable/wigs/male_silver_wig),

					  "femalewigshop" = newlist(
					  	/obj/items/wearable/wigs/female_black_wig,
						/obj/items/wearable/wigs/female_blonde_wig,
						/obj/items/wearable/wigs/female_blue_wig,
						/obj/items/wearable/wigs/female_green_wig,
						/obj/items/wearable/wigs/female_grey_wig,
						/obj/items/wearable/wigs/female_pink_wig,
						/obj/items/wearable/wigs/female_purple_wig,
						/obj/items/wearable/wigs/female_silver_wig),

					  "peace" = newlist(
					  	/obj/items/spellbook/peace),

					  "chaos" = newlist(
					  	/obj/items/spellbook/blood),

					  "random" = list()
					)

obj/items/spellbook/peace/price = 666
obj/items/spellbook/blood/price = -666

mob/TalkNPC/Vault_Salesman
	icon_state="goblin1"
	var/itemlist = list()
	New()
		..()
		icon_state = "goblin[rand(1,3)]"

		itemlist["Free Vault - Free!"]                                = list("1",       0)
		itemlist["Medium Vault - 3,000,000 gold and 30 artifacts"]    = list("_med",    30)
		itemlist["Big Vault - 6,000,000 gold and 60 artifacts"]       = list("_big",    60)
		itemlist["Huge Vault - 10,000,000 gold and 100 artifacts"]    = list("_huge",   100)
		itemlist["2 Rooms Vault - 15,000,000 gold and 150 artifacts"] = list("_2rooms", 150)
		itemlist["4 Rooms Vault - 24,000,000 gold and 240 artifacts"] = list("_4rooms", 240)
		itemlist["Luxury Vault - 36,000,000 gold and 360 artifacts"]  = list("_luxury", 360)
		itemlist["HQ Vault - 40,000,000 gold and 400 artifacts"]      = list("_hq",     400)
		itemlist["Wizard Vault - 66,600,000 gold and 666 artifacts"]  = list("_wizard", 666)

	Talk()
		set src in oview(2)

		if(!(usr.ckey in worldData.globalvaults) || !fexists("[swapmaps_directory]/map_[usr.ckey].sav"))
			usr << npcsay("Vault Salesman: Please go talk to the vault master before coming to me.")
			return

		var/index = input("[name]: Hi there! Welcome to Gringotts, perhaps you wish to purchase one of our vaults?", "You have [comma(usr.gold)] gold")as null|anything in itemlist
		if(!index)
			usr << npcsay("[name]: I only sell to the rich! Begone!")
			return

		var/selectedvault = itemlist[index][1]
		var/selectedprice = itemlist[index][2]

		var/vault/v = worldData.globalvaults[usr.ckey]
		if(v.tmpl == selectedvault)
			usr << npcsay("[name]: You already have this exact same vault.")
		else
			for(var/i in itemlist)
				if(itemlist[i][1] == v.tmpl)
					selectedprice = max(selectedprice - itemlist[i][2], 0)
					usr << infomsg("Selling your existing vault reduces the price to [selectedprice] artifacts and [selectedprice * 100000] gold.")
					break

			var/list/artifacts = list()
			var/amount = 0
			for(var/obj/items/artifact/a in usr)
				artifacts += a
				amount    += a.stack

			if(usr.gold.get() < selectedprice * 100000 || amount < selectedprice)
				usr << npcsay("[name]: I'm running a business here - you can't afford this.")
			else
				if(usr:change_vault(selectedvault))
					usr.gold.add(-selectedprice * 100000)
					worldData.ministrybank += worldData.taxrate*selectedprice*1000

					for(var/obj/items/o in artifacts)
						selectedprice -= o.stack

						if(selectedprice < 0)
							o.stack = abs(selectedprice)
							o.UpdateDisplay()
						else
							o.loc = null

						if(selectedprice<=0) break
					usr:Resort_Stacking_Inv()
					usr << npcsay("[name]: Thank you.")

mob/TalkNPC/Artifacts_Salesman
	icon_state="goblin1"
	New()
		..()
		icon_state = "goblin[rand(1,3)]"

	Talk()
		set src in oview(2)

		var/selecteditem
		var/selectedprice
		var/itemlist = list(
		"Farmer Lamp - 100,000 gold and 1 artifact",
		"Double Exp Lamp - 200,000 gold and 2 artifacts",
		"Double Gold Lamp - 200,000 gold and 2 artifacts",
		"Double Drop Rate Lamp - 300,000 gold and 3 artifacts",
		"Title: Rich - 1,000,000 gold and 10 artifacts",
		"Title: Treasure Hunter - 1,000,000 gold and 10 artifacts",
		"Title: Genie's Friend - 2,000,000 gold and 20 artifacts",
		"Community Key - 900,000 gold and 9 artifacts")
		switch(input("[name]: Hello... I sell lamps and magical rarities! Now now, they're not just lamps, they're magical lamps! My lamps will help you make your wishes come true! For the right price you might also net yourself something rare!", "You have [comma(usr.gold)] gold")as null|anything in itemlist)
			if("Farmer Lamp - 100,000 gold and 1 artifact")
				selecteditem  = /obj/items/lamps/farmer_lamp
				selectedprice = 1
			if("Double Exp Lamp - 200,000 gold and 2 artifacts")
				selecteditem  = /obj/items/lamps/double_exp_lamp
				selectedprice = 2
			if("Double Gold Lamp - 200,000 gold and 2 artifacts")
				selecteditem  = /obj/items/lamps/double_gold_lamp
				selectedprice = 2
			if("Double Drop Rate Lamp - 300,000 gold and 3 artifacts")
				selecteditem  = /obj/items/lamps/double_drop_rate_lamp
				selectedprice = 3
			if("Title: Rich - 1,000,000 gold and 10 artifacts")
				selecteditem  = /obj/items/wearable/title/Rich
				selectedprice = 10
			if("Title: Treasure Hunter - 1,000,000 gold and 10 artifacts")
				selecteditem  = /obj/items/wearable/title/Treasure_Hunter
				selectedprice = 10
			if("Title: Genie's Friend - 2,000,000 gold and 20 artifacts")
				selecteditem  = /obj/items/wearable/title/Genie
				selectedprice = 20
			if("Community Key - 900,000 gold and 9 artifacts")
				selecteditem  = /obj/items/key/community_key
				selectedprice = 9
			if(null)
				usr << npcsay("[name]: I only sell to the rich! Begone!")
				return

		var/list/artifacts = list()
		var/amount = 0
		for(var/obj/items/artifact/a in usr)
			artifacts += a
			amount += a.stack
		if(usr.gold.get() < selectedprice * 100000 || amount < selectedprice)
			usr << npcsay("[name]: I'm running a business here - you can't afford this.")
		else
			usr.gold.add(-selectedprice * 100000)
			worldData.ministrybank += worldData.taxrate*selectedprice*1000
			new selecteditem (usr)
			for(var/obj/items/o in artifacts)
				selectedprice -= o.stack

				if(selectedprice < 0)
					o.stack = abs(selectedprice)
					o.UpdateDisplay()
				else
					o.loc = null

				if(selectedprice<=0) break

			usr:Resort_Stacking_Inv()
			usr << npcsay("[name]: Thank you.")

proc
	comma(n)
		if(istype(n, /gold))
			n = n:get()
		if(!isint(n))
			.=copytext("[round(n-round(n),0.01)]",2)
			n=round(n)
		n=num2text(n,15)
		while(length(n)>3)
			.=",[copytext(n,length(n)-2)][.]"
			n=copytext(n,1,length(n)-2)
		return n+.

	isint(n)
		return n==round(n)


obj/items/wearable/shoes/green_shoes/price = 2000000
obj/items/wearable/shoes/blue_shoes/price = 2000000
obj/items/wearable/shoes/red_shoes/price = 2000000
obj/items/wearable/shoes/yellow_shoes/price = 2000000
obj/items/wearable/shoes/white_shoes/price = 4000000
obj/items/wearable/shoes/orange_shoes/price = 4000000
obj/items/wearable/shoes/teal_shoes/price = 4000000
obj/items/wearable/shoes/purple_shoes/price = 4000000
obj/items/wearable/shoes/black_shoes/price = 4000000
obj/items/wearable/shoes/pink_shoes/price = 4000000
obj/items/wearable/scarves/yellow_scarf/price = 200000
obj/items/wearable/scarves/black_scarf/price = 1600000
obj/items/wearable/scarves/blue_scarf/price = 200000
obj/items/wearable/scarves/green_scarf/price = 1600000
obj/items/wearable/scarves/orange_scarf/price = 200000
obj/items/wearable/scarves/pink_scarf/price = 1600000
obj/items/wearable/scarves/purple_scarf/price = 2000000
obj/items/wearable/scarves/red_scarf/price = 1600000
obj/items/wearable/scarves/teal_scarf/price = 2200000
obj/items/wearable/scarves/white_scarf/price = 2200000
obj/items/wearable/bling/price = 250000

proc/RandomizeShop()
	while(length(shops["random"]))
		shops["random"] -= shops["random"][1]
	var/list/items = list(/obj/items/wearable/shoes/green_shoes,
						  /obj/items/wearable/shoes/blue_shoes,
						  /obj/items/wearable/shoes/red_shoes,
						  /obj/items/wearable/shoes/yellow_shoes,
						  /obj/items/wearable/shoes/white_shoes,
						  /obj/items/wearable/shoes/orange_shoes,
						  /obj/items/wearable/shoes/teal_shoes,
						  /obj/items/wearable/shoes/purple_shoes,
						  /obj/items/wearable/shoes/black_shoes,
						  /obj/items/wearable/shoes/pink_shoes,
						  /obj/items/wearable/scarves/yellow_scarf,
						  /obj/items/wearable/scarves/black_scarf,
						  /obj/items/wearable/scarves/blue_scarf,
						  /obj/items/wearable/scarves/green_scarf,
						  /obj/items/wearable/scarves/orange_scarf,
						  /obj/items/wearable/scarves/pink_scarf,
						  /obj/items/wearable/scarves/purple_scarf,
						  /obj/items/wearable/scarves/red_scarf,
						  /obj/items/wearable/scarves/teal_scarf,
						  /obj/items/wearable/scarves/white_scarf,
						  /obj/items/wearable/bling)
	for(var/i = 1 to 5)
		var/path = pick(items)
		var/obj/items/item = new path()
		item.price = round(item.price * (rand(90, 110)/100))
		shops["random"] += item

		items -= path