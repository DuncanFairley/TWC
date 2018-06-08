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
				spawn _SoundEngine('stonedoor_openclose.ogg', O, range = 5, volume=15)
				spawn(rand(1,30))W.rumble()
			sleep(150)
			for(var/obj/movablewall/W in range(20,O))
				spawn _SoundEngine('stonedoor_openclose.ogg', O, range = 5, volume =15)
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

mob/TalkNPC/quest/Tammie
	icon_state = "tammie"
	questPointers = "Demonic Ritual"
	Talk()
		set src in oview(3)
		..()
		var/mob/Player/p = usr
		var/questPointer/pointer = p.questPointers["Demonic Ritual"]
		var/obj/selecteditem
		var/selectedprice
		var/gold/g = new(usr)
		switch(input("Tom: Welcome to the Leaky Cauldron. What do ya wanna do?","Tom")as null|anything in list("Shop","Talk"))
			if("Talk")
				if(pointer)
					if(pointer.stage)
						if(p.checkQuestProgress("Tammie"))
							p << npcsay("Tammie: Wow, I can't believe you went and killed all those little innocent cute rats.")
					else
						p << npcsay("Tammie: Did you know there's a ritual that makes you stronger, apparently it involves gathering demonic essences, I wonder how you do that, maybe you have to kill a demonic creature.")
						p.startQuest("Demonic Ritual")
				else
					p << npcsay("Tammie : You Are Evil..")
			if("Shop")
				switch(input("What do you need?","Tammie")as null|anything in list("Ale","A slice of Pie","Cooked Meat","Cheese","Sundae","Fortune Cookie","Fish","Bread"))
					if("Ale")
						if(p.Year in list("1st Year","2nd Year","3rd Year",""))
							p << npcsay("Tammie: I am sorry.. but your not old enough to drink!")
						else
							selecteditem = /obj/maxfood/Ale
							selectedprice = 30
					if("A slice of Pie")
						selecteditem = /obj/maxfood/Pie
						selectedprice = 65
					if("Cheese")
						selecteditem = /obj/maxfood/Cheese
						selectedprice = 25
					if("Sundae")
						selecteditem = /obj/maxfood/Sundae
						selectedprice = 40
					if("Fortune Cookie")
						selecteditem = /obj/maxfood/fortune_cookie
						selectedprice = 70
					if("Fish")
						selecteditem = /obj/maxfood/Fish
						selectedprice = 100
					if("Bread")
						selecteditem = /obj/maxfood/Bread
						selectedprice = 10
				g = new(usr)
				if(!g.have(selectedprice))
					usr << npcsay("Tammie: I am sorry, that's not enough.. - it's [selectedprice]g.")
				else
					g.change(usr, bronze=-selectedprice)
					worldData.ministrybank += worldData.taxrate*selectedprice/100
					new selecteditem(usr)
					usr << npcsay("Tammie : Enjoy your food!")
					usr:Resort_Stacking_Inv()


mob/Tom_
	icon = 'NPCs.dmi'
	icon_state="tom"
	density=1

mob/TalkNPC/quest/Tom
	icon_state="tom"
	density=1
	questPointers = "Rats in the Cellar"
	Talk()
		set src in oview(2)
		..()
		var/mob/Player/p = usr
		var/questPointer/pointer = p.questPointers["Tutorial: Quests"]
		if(pointer && pointer.stage == 2)
			p.checkQuestProgress("Tom")
		switch(input("Tom: Welcome to the Leaky Cauldron. What do ya wanna do?","Tom")as null|anything in list("Shop","Talk"))
			if("Talk")
				if("Rats in the Cellar" in p.questPointers)
					pointer = p.questPointers["Rats in the Cellar"]
					if(pointer.stage == 1)
						usr << npcsay("Tom: I will take you down to the cellar")
						sleep(10)
						if(get_dist(usr,src)<5)
							var/turf/t = locate("@TomCellar")
							p.Transfer(t)
							var/mob/TheTom = new/mob/Tom_(get_step(t, NORTH))
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
										var/turf/t = locate("@TomCellar")
										p.Transfer(t)
										var/mob/TheTom = new/mob/Tom_(get_step(t, NORTH))
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
				if(p.Year in list("1st Year","2nd Year","3rd Year",""))
					p << npcsay("Tom: Sorry mate. Come back when you're older.")
				else
					p << npcsay("Tom: Sorry mate. Those rats drank all of the beer.")
			if(null)
				p << npcsay("Tom: Seeya later then.")

mob/test/verb/MagicEyes()
	alert("There are currently [worldData.magicEyesLeft] magic eyes left at Divo.")
	worldData.magicEyesLeft = input("How many would you like there to be?",,worldData.magicEyesLeft) as num

mob/TalkNPC/Divo
	icon_state="divo"

	Talk()
		set src in oview(2)
		var/obj/selecteditem
		var/selectedprice
		var/itemlist
		if(worldData.magicEyesLeft)
			itemlist = list("Magical Eye 20 platinum coins","Invisibility Cloak 6 gold coins")
		else
			itemlist = list("Invisibility Cloak 6 gold coins")
		var/gold/g = new (usr)
		switch(input("Divo: Hi there! Welcome to Divo's Magical Wares. [worldData.magicEyesLeft ? "I've got a limited supply of these ultra rare magical eyes. They let you see invisible people. Very powerful stuff. I'm only going to sell a limited amount though, otherwise my cloak business would be pointless wouldn't it? I have [worldData.magicEyesLeft] left." : ""]","You have [g.toString()]")as null|anything in itemlist)
			if("Magical Eye 20 platinum coins")
				selecteditem = /obj/items/wearable/magic_eye
				selectedprice = 20000000
			if("Invisibility Cloak 6 gold coins")
				selectedprice = 60000
				selecteditem = /obj/items/wearable/invisibility_cloak
			if(null)
				usr << npcsay("Divo: Sorry that I don't have anything interesting to ya... ")
				return
		g = new (usr)
		if(!g.have(selectedprice))
			usr<< npcsay("Divo: I'm running a business here - you don't have enough for this.")
		else
			if(selecteditem == /obj/items/wearable/magic_eye)
				worldData.magicEyesLeft--
			g.change(usr, bronze=-selectedprice)
			worldData.ministrybank += worldData.taxrate*selectedprice/100
			new selecteditem(usr)
			usr << npcsay("Divo: Thank you.")
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
		var/gold/g = new(p)
		if(swiftmode)
			switch(alert("Ollivander: Welcome to Ollivander's Wand Shop - may I sell you a wand? They're 100 gold","You have [g.toString()]","Yes","No"))
				if("Yes")
					start
					var/length = rand(8,13)
					var/core = pick("Phoenix Feather", "Dragon Heartstring", "Veela Hair", "Unicorn Hair")
					var/wood = pick("Birch", "Oak", "Ash", "Willow", "Mahogany", "Elder")
					var/wandname = "[length] inch [wood] wand ([core])"
					switch(alert("This [wandname] costs a silver coin. Would you like to purchase it?","You have [g.toString()]","Yes","No"))
						if("Yes")
							g = new (usr)
							if(g.have(100))
								view(7,Olli) << "[nametext] Here's your new [wandname], [usr]!"
								g.change(usr, silver=-1)
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
							switch(alert("Would you like me to find you another wand?","You have [g.toString()]","Yes","No"))
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
					switch(alert("Ollivander: Welcome to Ollivander's Wand Shop - may I sell you a wand? They're a silver coin each","You have [g.toString()]","Yes","No"))
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
							switch(alert("This [wandname] costs a silver coin. Would you like to purchase it?","You have [g.toString()]","Yes","No"))
								if("Yes")
									g = new(usr)
									if(g.have(100))
										view(7,Olli) << "[nametext] Here's your new [wandname], [usr]!"
										g.change(usr, silver=-1)
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
									switch(alert("Would you like me to find you another wand?","You have [g.toString()]","Yes","No"))
										if("Yes")
											rnd = rand(12,15)
											view(7,Olli) << "[nametext] [Olli.phrases[rnd]]"
											goto start
										else
											view(7,Olli) << "[nametext] Have a nice day then!"


					Olli.busy = 0

obj/Madame_Pomfrey
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
				var/mob/Player/p = usr
				p<<"<b><span style=\"color:green;\">Madam Pomfrey:</span><font color=aqua> Episkey [p]!"
				new /StatusEffect/UsedFerulaToHeal(p,10)
				p.overlays+=image('attacks.dmi',icon_state="heal")

				var/maxHP = p.MHP + p.extraMHP
				p.HP = min(maxHP, round(p.HP + maxHP * 0.15 + rand(-15, 15), 1))

				p.updateHPMP()
				src = null
				spawn(10)
					if(p)
						p.overlays-=image('attacks.dmi',icon_state="heal")

	New()
		..()
		view(src)<<"<b>Madame Pomfrey</b>: Hello. Need healing? Click me."
		spawn(500)
			flick('dlo.dmi',src)
			sleep(10)
			view(src)<<"The nurse orbs out."
			Dispose()


mob/Madame_Pomfrey
	icon='NPCs.dmi'
	icon_state="nurse"

	verb
		Heal_Me()
			set src in oview(1)
			var/mob/Player/p = usr
			p<<"<b><span style=\"color:green;\">Madam Pomfrey:</span><font color=aqua> Episkey [p]!"
			p.overlays+=image('attacks.dmi',icon_state="heal")
			p.HP=p.MHP+p.extraMHP
			p.updateHPMP()
			src = null
			spawn(10)
				if(p)
					p.overlays-=image('attacks.dmi',icon_state="heal")

mob/TalkNPC/Broom_Salesman
	icon = 'NPCs.dmi'
	icon_state="wizard"
	name="Chrono"

	Talk()
		set src in oview(2)
		var/obj/selecteditem
		var/selectedprice
		var/gold/g = new(usr)
		switch(input("Chrono: Hi there! Welcome to Chrono's Brooms. We have two models in stock right now - would you like to purchase one?","You have [g.toString()]")as null|anything in list("Cleansweep Seven - 1 gold coin","Nimbus 2000 - 3 gold coins"))
			if("Cleansweep Seven - 1 gold coin")
				selecteditem = /obj/items/wearable/brooms/cleansweep_seven
				selectedprice = 10000
			if("Nimbus 2000 - 3 gold coins")
				selectedprice = 30000
				selecteditem = /obj/items/wearable/brooms/nimbus_2000
			if(null)
				usr << npcsay("Chrono: Come see me any time if you change your mind.")
				return
		g = new(usr)
		if(!g.have(selectedprice))
			usr << npcsay("Chrono: Unfortunately you don't have enough for this broom - it's [selectedprice]g.")
		else
			g.change(usr, bronze=-selectedprice)
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

				var/actualPrice = round(i.price * worldData.shopPriceModifier, 1)
				var/gold/g = new(usr)
				var/gold/price = new (bronze=actualPrice)
				if(!g.have(actualPrice))
					var/gold/diff = new(bronze=actualPrice - g.toNumber())
					usr << infomsg("You don't have enough money for [i.name]. It costs [price.toString()]. You need [diff.toString()].")
					return
				if(alert(usr, "Are you sure you want to buy [i.name] for [price.toString()]","Are you sure?","Yes","No") == "Yes")
					g.setVars(usr)
					if(g.have(actualPrice))
						new i.type (usr)
						usr << infomsg("You bought [i] for [price.toString()].")
						g.change(usr, bronze=-actualPrice)
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
					  	/obj/items/wearable/masks/white_mask,
					  	/obj/items/wearable/masks/pink_mask,
					  	/obj/items/wearable/masks/orange_mask,
					  	/obj/items/spellbook/peace,
					  	/obj/items/spellbook/lumos),

					  "chaos" = newlist(
					  	/obj/items/wearable/masks/black_mask,
					  	/obj/items/wearable/masks/teal_mask,
					  	/obj/items/wearable/masks/purple_mask,
					  	/obj/items/spellbook/blood,
					  	/obj/items/spellbook/aggravate),

					  "random" = list()
					)

obj/items/spellbook/peace/price = 666
obj/items/spellbook/blood/price = -666

obj/items/spellbook/lumos/price = 999
obj/items/spellbook/aggravate/price = -999

obj/items/wearable/masks/black_mask/price  = -444
obj/items/wearable/masks/teal_mask/price   = -444
obj/items/wearable/masks/purple_mask/price = -444

obj/items/wearable/masks/white_mask/price  = 444
obj/items/wearable/masks/pink_mask/price   = 444
obj/items/wearable/masks/orange_mask/price = 444


mob/TalkNPC/Vault_Salesman
	icon_state="goblin1"
	var/itemlist = list()
	New()
		..()
		icon_state = "goblin[rand(1,3)]"

		itemlist["Free Vault - Free!"]                                  = list("1",       0)
		itemlist["Medium Vault - 3 platinum coins and 30 artifacts"]    = list("_med",    30)
		itemlist["Big Vault - 6 platinum coins and 60 artifacts"]       = list("_big",    60)
		itemlist["Huge Vault - 10 platinum coins and 100 artifacts"]    = list("_huge",   100)
		itemlist["2 Rooms Vault - 15 platinum coins and 150 artifacts"] = list("_2rooms", 150)
		itemlist["4 Rooms Vault - 24 platinum coins and 240 artifacts"] = list("_4rooms", 240)
		itemlist["Luxury Vault - 36 platinum coins and 360 artifacts"]  = list("_luxury", 360)
		itemlist["HQ Vault - 40 platinum coins and 400 artifacts"]      = list("_hq",     400)
		itemlist["Wizard Vault - 66 platinum coins, 60 gold coins and 666 artifacts"]  = list("_wizard", 666)

	Talk()
		set src in oview(2)

		if(!(usr.ckey in worldData.globalvaults) || !fexists("[swapmaps_directory]/map_[usr.ckey].sav"))
			usr << npcsay("Vault Salesman: Please go talk to the vault master before coming to me.")
			return
		var/gold/g = new (usr)
		var/index = input("[name]: Hi there! Welcome to Gringotts, perhaps you wish to purchase one of our vaults?", "You have [g.toString()]")as null|anything in itemlist
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
					var/gold/price = new(gold=selectedprice * 10)
					usr << infomsg("Selling your existing vault reduces the price to [selectedprice] artifacts and [price.toString()].")
					break


			var/obj/items/artifact/a = locate() in usr
			g.setVars(usr)
			if(!a || a.stack < selectedprice || !g.have(selectedprice * 100000))
				usr << npcsay("[name]: I'm running a business here - you can't afford this.")
			else
				if(usr:change_vault(selectedvault))
					g.setVars(usr)
					g.change(usr, gold=-selectedprice * 10)
					worldData.ministrybank += worldData.taxrate*selectedprice*1000

					a.stack -= selectedprice
					if(!a.stack)
						a.loc = null
					else
						a.UpdateDisplay()

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
		"Farmer Lamp - 10 gold coins and 1 artifact",
		"Double Exp Lamp - 20 gold coins and 2 artifacts",
		"Double Gold Lamp - 20 gold coins and 2 artifacts",
		"Double Drop Rate Lamp - 30 gold coins and 3 artifacts",
		"Title: Rich - 1 platinum coin and 10 artifacts",
		"Title: Treasure Hunter - 1 platinum coin and 10 artifacts",
		"Title: Genie's Friend - 2 platinum coins and 20 artifacts",
		"Community Key - 90 gold coins and 9 artifacts",
		"Pet Key - 20 gold coins and 2 artifacts")

		var/gold/g = new (usr)
		switch(input("[name]: Hello... I sell lamps and magical rarities! Now now, they're not just lamps, they're magical lamps! My lamps will help you make your wishes come true! For the right price you might also net yourself something rare!", "You have [g.toString()]")as null|anything in itemlist)
			if("Farmer Lamp - 10 gold coins and 1 artifact")
				selecteditem  = /obj/items/lamps/farmer_lamp
				selectedprice = 1
			if("Double Exp Lamp - 20 gold coins and 2 artifacts")
				selecteditem  = /obj/items/lamps/double_exp_lamp
				selectedprice = 2
			if("Double Gold Lamp - 20 gold coins and 2 artifacts")
				selecteditem  = /obj/items/lamps/double_gold_lamp
				selectedprice = 2
			if("Double Drop Rate Lamp - 30 gold coins and 3 artifacts")
				selecteditem  = /obj/items/lamps/double_drop_rate_lamp
				selectedprice = 3
			if("Title: Rich - 1 platinum coin and 10 artifacts")
				selecteditem  = /obj/items/wearable/title/Rich
				selectedprice = 10
			if("Title: Treasure Hunter - 1 platinum coin and 10 artifacts")
				selecteditem  = /obj/items/wearable/title/Treasure_Hunter
				selectedprice = 10
			if("Title: Genie's Friend - 2 platinum coins and 20 artifacts")
				selecteditem  = /obj/items/wearable/title/Genie
				selectedprice = 20
			if("Community Key - 90 gold coins and 9 artifacts")
				selecteditem  = /obj/items/key/community_key
				selectedprice = 9
			if("Pet Key - 20 gold coins and 2 artifacts")
				selecteditem  = /obj/items/key/pet_key
				selectedprice = 2
			if(null)
				usr << npcsay("[name]: I only sell to the rich! Begone!")
				return

		g = new (usr)
		var/obj/items/artifact/a = locate() in usr

		if(!a || a.stack < selectedprice || !g.have(selectedprice * 100000))
			usr << npcsay("[name]: I'm running a business here - you can't afford this.")
		else
			g.change(usr, bronze=-selectedprice * 100000)
			worldData.ministrybank += worldData.taxrate*selectedprice*1000
			new selecteditem (usr)

			a.stack -= selectedprice
			if(!a.stack)
				a.loc = null
			else
				a.UpdateDisplay()

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