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

		var/gold/g = new(usr)
		switch(input("Green Man: Hello, we are the Green Man Group. We are merchants who travel around selling things from far away places.","You have [g.toString()].")in list("Buy","Cancel"))
			if("Buy")
				switch(input("Green Man: Have a look at our merchandise","You have [g.toString()].")as null|anything in list("U-No-Poo 1 gold coin","Bag-o-Snow 1 gold coin","Bag of Goodies 10 gold coins","Whoopie Cushion 40 silver coins","Tube of fun 30 silver coins","Smoke Pellet 30 silver coins","Swamp in ya pocket 50 silver coins","Peruvian Instant Darkness Powder 70 silver coins"))
					if("U-No-Poo 1 gold coin")
						if(g.have(10000))
							new/obj/items/U_No_Poo(usr)
							usr << "Green Man says: Thanks for buying."
							g.change(usr, bronze=-10000)
							worldData.ministrybank += worldData.taxrate*100
					if("Bag-o-Snow 1 gold coin")
						if(g.have(10000))
							new/obj/items/bagofsnow(usr)
							usr << "Green Man says: Thanks for buying."
							g.change(usr, bronze=-10000)
							worldData.ministrybank += worldData.taxrate*100
					if("Bag of Goodies 10 gold coins")
						if(g.have(100000))
							new/obj/items/bagofgoodies(usr)
							usr << "Green Man says: Thanks for buying."
							g.change(usr, bronze=-100000)
							worldData.ministrybank += worldData.taxrate*1000
					if("Whoopie Cushion 40 silver coins")
						if(g.have(4000))
							new/obj/items/Whoopie_Cushion(usr)
							usr << "Green Man says: Thanks for buying."
							g.change(usr, bronze=-4000)
							worldData.ministrybank += worldData.taxrate*40
					if("Smoke Pellet 30 silver coins")
						if(g.have(3000))
							new/obj/items/Smoke_Pellet(usr)
							usr << "Green Man says: Thanks for buying."
							g.change(usr, bronze=-3000)
							worldData.ministrybank += worldData.taxrate*30
					if("Peruvian Instant 70 silver coins")
						if(g.have(7000))
							new/obj/items/DarknessPowder(usr)
							usr << "Green Man says: Thanks for buying."
							g.change(usr, bronze=-7000)
							worldData.ministrybank += worldData.taxrate*70
					if("Swamp in ya pocket 50 silver coins")
						if(g.have(5000))
							new/obj/items/Swamp(usr)
							usr << "Green Man says: Thanks for buying."
							g.change(usr, bronze=-5000)
							worldData.ministrybank += worldData.taxrate*50
					if("Tube of fun 30 silver coins")
						if(g.have(3000))
							new/obj/items/Tube_of_fun(usr)
							usr << "Green Man says: Thanks for buying."
							g.change(usr, bronze=-3000)
							worldData.ministrybank += worldData.taxrate*30
