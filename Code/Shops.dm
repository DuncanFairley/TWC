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

mob/TalkNPC/Ollivander
	icon_state="ollivander"

	Talk()
		set src in oview(3)

		var/mob/Player/p = usr
		var/gold/g = new(p)

		var/ScreenText/s = new(p, src)

		if(locate(/obj/items/wearable/wands) in p.contents)
			s.AddText("Ah, I remember you, [p.name]. I believe I've already sold you a wand.")
			if(p.checkQuestProgress("Ollivander"))
				s.AddText("Oh you're just starting out eh? My friend Palmer can help you out, his name is Palmer, he is quite friendly.")
				p.startQuest("Tutorial: Friendly Professor")
			return

		s.AddText("Welcome to Ollivander's Wand Shop - may I sell you a wand? A wand costs 1 silver.")

		if(g.have(100))
			s.SetButtons("Yes", "#00ff00", "No", "#ff0000", null)

		if(!s.Wait()) return

		if(s.Result == "Yes")
			var/core = pick("Phoenix Feather", "Dragon Heartstring", "Veela Hair", "Unicorn Hair")
			var/wood = pick("Birch", "Oak", "Ash", "Willow", "Mahogany", "Elder")
			var/wandname = "[rand(8,13)] inch [wood] wand ([core])"

			s.AddText("This [wandname] costs a silver coin. Would you like to purchase it?")

			s.SetButtons("Yes", "#00ff00", "Another", "#2299d0", "No", "#ff0000")

			if(!s.Wait()) return

			while(s.Result == "Another")
				core = pick("Phoenix Feather", "Dragon Heartstring", "Veela Hair", "Unicorn Hair")
				wood = pick("Birch", "Oak", "Ash", "Willow", "Mahogany", "Elder")
				wandname = "[rand(8,13)] inch [wood] wand ([core])"

				s.AddText("This [wandname] costs a silver coin. Would you like to purchase it?")

				if(!s.Wait()) return

			if(s.Result == "Yes")
				s.SetButtons("Ok", "#2299d0", null, "#2299d0", null, "#ff0000")
				s.AddText("Enjoy your new wand, [p.name].")
				g.change(p, silver=-1)

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
					s.AddText("Oh you're just starting out eh? My friend Palmer can help you out, his name is Palmer, he is quite friendly.")
					p.startQuest("Tutorial: Friendly Professor")


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
			if(canUse(usr,needwand=0,cooldown=/StatusEffect/UsedFerulaToHeal))
				set src in oview(1)
				var/mob/Player/p = usr
				p<<"<b><span style=\"color:green;\">Madam Pomfrey:</span><font color=aqua> Episkey [p]!"
				new /StatusEffect/UsedFerulaToHeal(p,10*p.cooldownModifier)
				p.overlays+=image('attacks.dmi',icon_state="heal")

				p.HP = p.MHP

				p.updateHP()
				src = null
				spawn(10)
					if(p)
						p.overlays-=image('attacks.dmi',icon_state="heal")

	New(loc, time=0)
		set waitfor = 0
		..(loc)

		if(time)
			hearers() << "<b>Madame Pomfrey</b>: Hello. Need healing? Click me."
			sleep(time)
			FlickState("Orb",12,'Effects.dmi')
			sleep(12)
			hearers() << "The nurse orbs out."
			Dispose()

mob/TalkNPC/Broom_Salesman
	icon = 'NPCs.dmi'
	icon_state="wizard"
	name="Chrono"

	Talk()
		set src in oview(2)
		usr << npcsay("Chrono: Check the brooms I got on the wall, they're all for sale.")

mob/TalkNPC/greenman
	name="Green Man"
	icon='statues.dmi'
	icon_state = "green"

	Talk()
		set src in oview(3)
		var/mob/Player/p = usr
		if(p.checkQuestProgress("Green Men"))
			p << npcsay("Green Man: I heard you liked building, here you can have those papers... If you can read them hahahaha.")
		else
			p << npcsay("Green Man: Hello, we are the Green Man Group. We are merchants who travel around selling things from far away places.")


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

		Crossed(mob/Player/p)
			if(isplayer(p))
				shop(p)

		Uncrossed(mob/Player/p)
			if(isplayer(p))
				unshop(p)

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
					  "random" = list()
					)

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
		set src in oview(3)

		usr << npcsay("Artifacts Salesman: I have some exquisite rarties for sale, check the items on display.")

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


obj/shopStand

	mouse_opacity      = 2
	mouse_over_pointer = MOUSE_HAND_POINTER

	var
		artifactPrice = 0
		goldPrice = 0
		item
		stock
		reqRep

	Click()
		if(src in oview(3))
			var/mob/Player/p = usr

			if(stock==0)
				p << errormsg("Out of stock.")
				return

			var/ScreenText/s = new(p, src)

			if(reqRep && ((reqRep < 0 && p.getRep() > reqRep) || (reqRep > 0 && p.getRep() < reqRep)))
				s.AddText("You aren't famous enough to buy this.")
				return

			var/gold/gPrice = new(bronze=goldPrice)
			var/gold/g = new(p)
			var/obj/items/artifact/a = locate() in p

			if(goldPrice && artifactPrice)
				s.AddText("Would you like to buy this item for [gPrice.toString()] and [artifactPrice] artifacts?")
			else if(goldPrice)
				s.AddText("Would you like to buy this item for [gPrice.toString()]?")
			else
				s.AddText("Would you like to buy this item for [artifactPrice] artifacts?")

			if((!goldPrice || g.have(goldPrice)) && (!artifactPrice || (a && a.stack >= artifactPrice)))
				s.SetButtons("Buy", "#00ff00", "Cancel", "#ff0000", null)

			if(!s.Wait()) return

			if(s.Result == "Buy")
				var/txt = "You bought [name] for "
				if(goldPrice)
					g.change(p, bronze=-goldPrice)
					txt += gPrice.toString()

				if(artifactPrice)
					if(goldPrice) txt += " and "
					a.Consume(artifactPrice)
					txt += "[artifactPrice] artifacts."
				else
					txt += "."

				new item (p)
				p << infomsg(txt)

				if(stock) stock--

		else
			..()