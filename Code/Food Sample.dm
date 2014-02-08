/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
obj/PromPlate
	icon = 'PromFood.dmi'
	icon_state = "Plate"
	New()
		..()
		Refresh()
	proc/Refresh()
		spawn()while(src)
			var/foundfood = 0
			for(var/obj/O in src.loc)
				if(istype(O,/obj/FoodProm))
					foundfood = 1
			if(!foundfood)
				var/foodtypes = typesof(/obj/FoodProm) - /obj/FoodProm
				var/newfood = pick(foodtypes)
				new newfood(src.loc)
			sleep(200)
obj/Trophy
	name = "Trophy"
	icon = 'trophies.dmi'
	Gold
		icon_state = "Gold"
	Yellow
		icon_state = "Yellow"
	Silver
		icon_state = "Silver"
	Bronze
		icon_state = "Bronze"
mob/Cow
	icon = 'Cow.dmi'
	Immortal = 1
	New()
		..()
		walk_rand(src,8)
		Moo()
	proc/Moo()
		spawn()while(src)
			hearers(src) << "Cow: [pick("MooooooOOOoOo!","Moo!","MOOOOOOOOOOOOOOOOOOOOOOOOO","Moooooo!","Moo moo moo!")]"
			sleep(400)
obj
	Food
		icon='turf.dmi'
		dontsave=1
		value=10
		verb
			Eat()
				set src in view(1)
				usr.HP+=25
				if(usr.HP > (usr.MHP+usr.extraMHP)) usr.HP = usr.MHP+usr.extraMHP
				usr<<"You eat \the [src]."
				del src
			Take()
				set src in oview(1)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
			Drop()
				set src in usr
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
	FoodProm
		icon = 'PromFood.dmi'
		Blue_Popsicle
			icon_state = "BluePopsicle"
		Red_Popsicle
			icon_state = "RedPopsicle"
		Yellow_Popsicle
			icon_state = "YellowPopsicle"
		Green_Popsicle
			icon_state = "GreenPopsicle"
		Blue_Snowcone
			icon_state = "BlueSnowcone"
		Green_Snowcone
			icon_state = "GreenSnowcone"
		Yellow_Snowcone
			icon_state = "YellowSnowcone"
		Red_Snowcone
			icon_state = "RedSnowcone"
		Bubble_Gum
			icon_state = "Bubble Gum"
		Blood_Pop
			icon_state = "Blood Pop"
		Skittles
			icon_state = "Skittles"
		Burger
			icon_state = "Burger"
		Fire_Whiskey
			icon_state = "Firewhiskey"
		Cookie
			icon_state = "Cookie"
		Chocolate_Frog
			icon_state = "Chocolate Frog"
		Pudding
			icon_state = "Pudding"
		Slice_of_cake
			icon_state = "Cake Slice"
		Strawberry_Cake
			icon_state = "Strawberry Cake"
		Pumpkin_Juice
			icon_state = "Pumpkinjuice"
		Butterbeer
			icon_state = "Butterbeer"
		New()
			..()
			if(!src.loc)
				del(src)
		verb
			Eat()
				set src in view(1)
				usr.HP+=25
				if(usr.HP > (usr.MHP+usr.extraMHP)) usr.HP = usr.MHP+usr.extraMHP
				usr<<"You eat \the [src]."
				del src
			Take()
				set src in oview(1)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				Pickedup()
				usr:Resort_Stacking_Inv()
			Drop()
				set src in usr
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
		proc/Pickedup()
			spawn()
				sleep(600)
				del(src)

obj/Food/Candy_Cane
			icon_state="cane"
obj/Food/Steak
			icon_state="food16"
obj/Food/Turkey
			icon_state="food13"
obj/Food/Sundae
			icon='Food.dmi'
			icon_state="Sundae"
obj/Food/fruitbucket
			name = "fruit bucket"
			icon_state="food14"
obj/Food/Pizza
			icon='Food.dmi'
			icon_state="Pizza"


mob/GM/verb/Grant_All_Spells(mob/M in Players)
			set category="Staff"
			set popup_menu = 0
			M.verbs += typesof(/mob/Spells/verb)
			M.Disperse = 1
			M.learnedslug = 1
			M<<"[usr] has given you <u>All</u> spells."

mob/GM/verb/Give_All_Quidditch(mob/M in Players)
			set category="Staff"
			set popup_menu = 0
			M.verbs += /mob/Quidditch/verb/Announce_To_Spectators
			M.verbs += /mob/Quidditch/verb/Add_Spectator
			M.verbs += /mob/Quidditch/verb/Remove_Spectator
			M.verbs += /mob/Quidditch/verb/Setup_Match
			M.verbs += /mob/Quidditch/verb/Start_Match
			M.verbs += /mob/Quidditch/verb/End_Match
			M.verbs += /mob/Quidditch/verb/Clear_Match
			M.verbs += /mob/Quidditch/verb/Readd_Member
			M<<"[usr] has given you <u>All</u> Quidditch Moderation verbs."