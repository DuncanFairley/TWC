/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/TalkNPC/greenman
	name="Green Man"
	icon='statues.dmi'
	icon_state = "green"
	Gm=1

	Talk()
		set src in oview(3)

		var/goldInHand = usr.gold.get()
		switch(input("Green Man: Hello, we are the Green Man Group. We are merchants who travel around selling things from far away places.","You have [goldInHand] gold")in list("Buy","Cancel"))
			if("Buy")
				switch(input("Green Man: Have a look at our merchandise","You have [goldInHand] gold")as null|anything in list("U-No-Poo 10,000g","Bag-o-Snow 10,000g","Bag of Goodies 100,000g","Whoopie Cushion 4,000g","Tube of fun 3,000g","Smoke Pellet 3,000g","Swamp in ya pocket 5,000g","Peruvian Instant Darkness Powder 7,000g"))
					if("U-No-Poo 10,000g")
						if(goldInHand>=10000)
							new/obj/items/U_No_Poo(usr)
							usr << "Green Man says: Thanks for buying."
							usr.gold.add(-10000)
							worldData.ministrybank += worldData.taxrate*10000/100
							return
					if("Bag-o-Snow 10,000g")
						if(goldInHand>=10000)
							new/obj/items/bagofsnow(usr)
							usr << "Green Man says: Thanks for buying."
							usr.gold.add(-10000)
							worldData.ministrybank += worldData.taxrate*10000/100
							return
					if("Bag of Goodies 100,000g")
						if(goldInHand>=100000)
							new/obj/items/bagofgoodies(usr)
							usr << "Green Man says: Thanks for buying."
							usr.gold.add(-100000)
							worldData.ministrybank += worldData.taxrate*100000/100
							return
					if("Whoopie Cushion 4,000g")
						if(goldInHand>=4000)
							new/obj/items/Whoopie_Cushion(usr)
							usr << "Green Man says: Thanks for buying."
							usr.gold.add(-4000)
							worldData.ministrybank += worldData.taxrate*4000/100
							return
					if("Smoke Pellet 3,000g")
						if(goldInHand>=3000)
							new/obj/items/Smoke_Pellet(usr)
							usr << "Green Man says: Thanks for buying."
							usr.gold.add(-3000)
							worldData.ministrybank += worldData.taxrate*3000/100
							return
					if("Peruvian Instant Darkness Powder 7,000g")
						if(goldInHand>=7000)
							new/obj/items/DarknessPowder(usr)
							usr << "Green Man says: Thanks for buying."
							usr.gold.add(-7000)
							worldData.ministrybank += worldData.taxrate*7000/100
							return
					if("Swamp in ya pocket 5,000g")
						if(goldInHand>=5000)
							new/obj/items/Swamp(usr)
							usr << "Green Man says: Thanks for buying."
							usr.gold.add(-5000)
							worldData.ministrybank += worldData.taxrate*5000/100
							return
					if("Tube of fun 3,000g")
						if(goldInHand>=3000)
							new/obj/items/Tube_of_fun(usr)
							usr << "Green Man says: Thanks for buying."
							usr.gold.add(-3000)
							worldData.ministrybank += worldData.taxrate*3000/100
							return
