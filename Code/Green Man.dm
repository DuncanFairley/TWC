/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/greenman
	name="Green Man"
	icon='statues.dmi'
	icon_state = "green"
	Immortal=1
	Gm=1
	verb
		Shop()
			set src in oview(2)
			switch(input("Green Man: Hello, we are the Green Man Group. We are merchants who travel around selling things from far away places.","You have [usr.gold] gold")in list("Buy","Cancel"))
				if("Buy")
					switch(input("Green Man: Have a look at our merchandise","You have [usr.gold] gold")as null|anything in list("U-No-Poo 10,000g","Bag-o-Snow 10,000g","Bag of Goodies 35,000g","Whoopie Cushion 4,000g","Tube of fun 3,000g","Smoke Pellet 3,000g","Swamp in ya pocket 5,000g","Peruvian Instant Darkness Powder 7,000g"))
						if("U-No-Poo 10,000g")
							if(usr.gold>=10000)
								new/obj/items/U_No_Poo(usr)
								usr << "Green Man says: Thanks for buying."
								usr.gold-=10000
								ministrybank += taxrate*10000/100
								usr:Resort_Stacking_Inv()
								return
						if("Bag-o-Snow 10,000g")
							if(usr.gold>=10000)
								new/obj/items/bagofsnow(usr)
								usr << "Green Man says: Thanks for buying."
								usr.gold-=10000
								ministrybank += taxrate*10000/100
								usr:Resort_Stacking_Inv()
								return
						if("Firebolt 8,000,000g")
							if(usr.gold>=8000000)
								new/obj/items/wearable/brooms/firebolt(usr)
								usr << "Green Man says: Thanks for buying."
								usr.gold-=8000000
								ministrybank += taxrate*8000000/100
								usr:Resort_Stacking_Inv()
								return
						if("Bag of Goodies 35,000g")
							if(usr.gold>=35000)
								new/obj/items/bagofgoodies(usr)
								usr << "Green Man says: Thanks for buying."
								usr.gold-=35000
								ministrybank += taxrate*35000/100
								usr:Resort_Stacking_Inv()
								return
						if("Whoopie Cushion 4,000g")
							if(usr.gold>=4000)
								new/obj/items/Whoopie_Cushion(usr)
								usr << "Green Man says: Thanks for buying."
								usr.gold-=4000
								ministrybank += taxrate*4000/100
								usr:Resort_Stacking_Inv()
								return
						if("Smoke Pellet 3,000g")
							if(usr.gold>=3000)
								new/obj/items/Smoke_Pellet(usr)
								usr << "Green Man says: Thanks for buying."
								usr.gold-=3000
								ministrybank += taxrate*3000/100
								usr:Resort_Stacking_Inv()
								return
						if("Peruvian Instant Darkness Powder 7,000g")
							if(usr.gold>=7000)
								new/obj/items/DarknessPowder(usr)
								usr << "Green Man says: Thanks for buying."
								usr.gold-=7000
								ministrybank += taxrate*7000/100
								usr:Resort_Stacking_Inv()
								return
						if("Swamp in ya pocket 5,000g")
							if(usr.gold>=5000)
								new/obj/items/Swamp(usr)
								usr << "Green Man says: Thanks for buying."
								usr.gold-=5000
								ministrybank += taxrate*5000/100
								usr:Resort_Stacking_Inv()
								return
						if("Tube of fun 3,000g")
							if(usr.gold>=3000)
								new/obj/items/Tube_of_fun(usr)
								usr << "Green Man says: Thanks for buying."
								usr.gold-=3000
								ministrybank += taxrate*3000/100
								usr:Resort_Stacking_Inv()
								return

mob/greenmanno
	name="Green Man"
	icon='statues.dmi'
	icon_state = "green"
	Immortal=1
	Gm=1
	verb
		Shop()
			set src in oview(2)
			alert("The Green Man Group is currently working on their new products for this month.")

mob/var/bracecharges

obj
	bracecharger
		name="Re-Charger"
		icon='tele.dmi'
		icon_state="rainbow"
		density=1
		dontsave=1
		verb
			Recharge()
				set src in oview(2)
				usr << "<font color=red>Re-charging..."
				sleep(20)
				usr << "<font color=green>Complete."
				usr.bracecharges=3