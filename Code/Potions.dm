/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob
	var/obj/Potion/Tools/Cauldron/brewing=null
	/*Move()
		..()
		if(brewing)
			brewing = null*/

obj/Potion
	var/pickupable=0
	proc
		determPot(var/meth)
			//Returns: Type path of Potion
			var/obj/Potion/Container/Potions/Pot
			switch(meth)
				if("moo")
					Pot = new /obj/Potion/Container/Potions/Health_Potion
			return Pot
	New()
		..()
		if(!src.pickupable) src.verbs -= /obj/Potion/verb/Take
	verb
		Take()
			set src in oview(1)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."
	Container
		var/uses=0
		var/meth=""
		pickupable=1
		icon = 'Potions.dmi'
		Flask
		Potions
			Invisibility_Potion
				icon_state = "yellow"
				pDrink()
					var/aicon = usr.icon
					var/list/aoverlays = usr.overlays
					usr.overlays = null
					usr.icon = null
					hearers() << "<b>[usr] turns invisible."
					sleep(100) //ERRRROORRRR DOESn'T REAPPPAEEARRR
					if(!usr.icon)
						usr.icon = aicon
						usr.overlays = aoverlays
						hearers() << "<b>[usr] appears."
			Health_Potion
				icon_state = "red"
				pDrink()
					if(usr.MHP == usr.HP)
						usr << "<b>The potion has no effect."
						return
					hearers() << "[usr]'s wounds begin to heal."
					var/diff = usr.MHP - usr.HP
					sleep(40)
					usr.HP += diff/3
					sleep(40)
					usr.HP += diff/3
					sleep(40)
					usr.HP = usr.MHP
			Mana_Potion
				icon_state = "blue"
				pDrink()
					if(usr.MMP == usr.MP)
						usr << "<b>The potion has no effect."
						return
					usr << "<b>You start to feel energized."
					var/diff = usr.MMP - usr.MP
					sleep(40)
					usr.MP += diff/3
					sleep(40)
					usr.MP += diff/3
					sleep(40)
					usr.MP = usr.MMP

		Click()
			var/newname = input("What do you wish to label the Flask?","Labelling",name) as null|text
			name = newname
		DblClick()
			return
		proc
			pDrink()
				usr << "The contents cause no effect!"
		verb
			Fill(var/obj/Potion/Tools/Cauldron/C in oview(1))
				if(C.meth=="")
					usr << "There is nothing in that cauldron."
				else
					if(meth!="")
						usr << "You empty the [src] then fill it with the contents of the cauldron."
					else
						usr << "You fill the [src] with the contents of the cauldron."
					var/obj/Potion/Container/Potions/P = determPot(C.meth)
					P.meth = C.meth
					P.Move(usr)
					P.name = src.name
					P.uses = 1
					C.icon_state=""
					C.overlays=null
					C.meth = ""
					del src
			Drink()
				if(uses<1)
					usr << "The [src] is empty!"
					meth=""
				else
					uses --
					hearers() << "[usr] drinks the contents of \the [src]"
					spawn() src.pDrink()
					sleep(3)
					if(uses==0)
						new/obj/Potion/Container/Flask(usr)
						del(src)
	Tools
		pickupable=0
		Silver_knife
			pickupable=1
			icon = 'Tools.dmi'
			icon_state = "Silver_knife"
		Mortar_and_pestle
			icon = 'Tools.dmi'
			icon_state = "Mortar_and_pestle"
			pickupable=1
		Dropper
			pickupable=1
			icon = 'Tools.dmi'
			icon_state = "Dropper"
		Stirring_rod
			pickupable=1
			icon = 'Tools.dmi'
			icon_state = "Stirring_rod"
		Cauldron
			icon='Cauldron.dmi'
			density=1
			var/meth=""
			var/busy=0
			proc
				randcolor()
					var/list/colours = list(
					"blue",
					"black",
					"red",
					"pink",
					"white",
					"green",
					"yellow")
					icon_state = pick(colours)
				pStir(var/spelled=0)
					if(busy)
						usr << "This Cauldron is being used."
						return
					if(meth=="")
						usr << "There is nothing in the cauldron"
						return
					var/selection=alert("Stir clockwise or anticlockwise?","Stir Potion","Clockwise","Anticlockwise","Cancel")
					if(selection=="Cancel") return
					var/times=input("How many times would you like to sir [selection]?") as null|num
					if(!times) return
					if(times > 15 || times <1)
						usr << "You do not need to stir that much."
						return
					if(!spelled)
						usr << "Stirring. (If you move during this process, the potion will be ruined)"
						usr.brewing = src
					else
						usr << "Stirring."
					busy=1
					sleep(times*10)
					busy=0
					randcolor()
					if(!usr.brewing&&!spelled)
						meth=""
						//phailed
						return
					usr << "You stirred the potion [selection] [times] times."
					meth += "stirred [selection] [times] times<br>"
					randcolor()
			verb
				Heat()
					set src in oview(1)
					if(busy)
						usr << "This Cauldron is being used."
						return
					if(meth=="")
						usr << "There is nothing in the cauldron"
						return
					var/selection=alert("How would you like to heat the contents?","Heating","Boil","Simmer","Cancel")
					if(selection=="Cancel") return
					var/times=input("How many seconds would you like to [selection]?") as null|num
					if(!times) return
					if(times <1)
						usr << "You don't have a time turner."
						return
					if(busy)
						usr << "This Cauldron is being used."
						return
					usr << "[selection]ing the Cauldron for [times] seconds."
					busy=1
					overlays+=icon('Cauldron.dmi',"flame")
					sleep(times*10)
					overlays=null
					busy=0
					usr << "Your potion has finished [selection]ing."
					meth += "[selection]ed [times] seconds<br>"
					randcolor()


				Add_to_Cauldron()
					set src in oview(1)
					if(busy)
						usr << "This Cauldron is being used."
						return
					var/list/ingreds = new/list()
					for(var/obj/Potion/Ingredients/I in usr)
						ingreds.Add(I)
					var/selection=input("Select what you would like to add to the cauldron:") as null|obj in ingreds
					if(!selection)return
					meth += "added [selection]<br>"
					del selection
					randcolor()
				Stir()
					set src in oview(1)
					if(!(locate(/obj/Potion/Tools/Stirring_rod) in usr.contents))
						usr << "You need a stirring rod!"
						return
					pStir()

			proc
				Check_potion()

	Ingredients
		var/maxamountreceived=1
		var/grindable=0
		var/liquidable=0
		var/fruitable=0
		var/name2be=""
		icon = 'PotionIngredients.dmi'
		pickupable=1
		Goat_bezoar
			name="Goat_bezoar"
			grindable=1
		Grinded_Goat_bezoar
			name="Grinded_Goat_bezoar"
		Aconite
		Acromantula_corpse
			liquidable=1
		Acromantula_liquid
			name="Acromantula_liquid"
			name2be="Acromantula venom"
		Armadillo_liquid
			name="Armadillo_liquid"
			name2be="Armadillo bile"
		Asphodel
			maxamountreceived=5
			fruitable=1
		Asphodel_Fruit
			name="Asphodel_Fruit"
			grindable=1
		Grinded_Asphodel_Fruit
			name="Grinded_Asphodel_Fruit"
		Belladonna
		Bicorn_horn
			name="Bicorn_horn"
			grindable=1
		Grinded_Bicorn_horn
			name="Grinded_Bicorn_horn"
		Bubotuber
			liquidable=1
		Bubotuber_liquid
			name="Bubotuber_liquid"
			name2be="Bubotuber Pus"

		New()
			..()
			if(!grindable) verbs-=/obj/Potion/Ingredients/verb/Grind
			if(!fruitable) verbs-=/obj/Potion/Ingredients/verb/Pick_Fruit
			if(!liquidable) verbs-=/obj/Potion/Ingredients/verb/Squeeze
		verb
			Squeeze()
				set src in view()
				var/obj/Potion/Tools/Dropper/N
				if(!(locate(/obj/Potion/Tools/Dropper) in usr.contents))
					usr << "You need a Dropper to store the liquid!"
					return
				for(var/obj/Potion/Tools/Dropper/D in usr.contents)
					if(D.name == "Dropper")
						N = D
				if(!N)
					usr << "You need an empty Dropper to store the liquid!"
					return
				var/type = text2path("/obj/Potion/Ingredients/[src]_liquid")
				new type (usr)
				del(src)


			Grind()
				set src in view(1)
				if(!(locate(/obj/Potion/Tools/Mortar_and_pestle) in usr.contents))
					usr << "You need a Mortar and pestle!"
					return
				world << "/obj/Potion/Ingredients/Grinded_[src.name]"
				var/type = text2path("/obj/Potion/Ingredients/Grinded_[src.name]")
				new type (usr)
				del(src)
			Pick_Fruit()
				set src in view(1)
				var/randnum = rand(1,maxamountreceived)
				var/type = text2path("/obj/Potion/Ingredients/[src]_Fruit")
				for(var/i=1; i<=randnum; i++)
					new type (usr)
				usr << "You pick [randnum] fruit from the [src]."
				del(src)

