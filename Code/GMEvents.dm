/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

mob
	EventMob
		icon = 'NPCs.dmi'
		icon_state = "palmer"
		name = "Event Mob"
		Immortal = 1
		Gm = 1

		var
			list
				AlreadyGiven = list()
				id = list()
			Message = "Hello."

		/*
		This mob gives an item once to everyone who talks to it.
		*/
		Item
			var/EventItem

			Talk()
				if(!EventItem)
					usr << " <font size=2 color=red><b>[src]</b> : </font>I have nothing to give you."
					return
				if(..())
					var/obj/O = new EventItem(usr)
					usr:Resort_Stacking_Inv()
					usr << " <font size=2 color=red>[src] hands you their [O.name]."

		/* This mob changes a var to everyone who talks to it.
		   It can add/remove/double for number values. (Adding also works for lists I guess)
		   For example, it can give everyone who talks to it 100 Gold once. */
		Variable
			var
				EventVar
				VarTo
				Function = "+"

			Talk()
				if(!EventVar)
					usr << " <font size=2 color=red><b>[src]</b> : </font>I have nothing to give you."
					return
				if(..())
					if(Function == "=")
						usr.vars[EventVar] = VarTo
					else if(Function == "+")
						usr.vars[EventVar] += VarTo
					else if(Function == "*")
						usr.vars[EventVar] *= VarTo

		verb
			Talk()
				set src in view(1)
				if(AlreadyGiven == "reset")
					AlreadyGiven = list()
					id = list()
				if((usr.ckey in AlreadyGiven) || (usr.client.computer_id in id))
					usr << " <font size=2 color=red><b>[src]</b> : </font>Hello! I've seen you before!"
					return 0
				else
					usr << " <font size=2 color=red><b>[src]</b> : </font>[Message]"
					AlreadyGiven.Add(usr.ckey)
					id.Add(usr.client.computer_id)
					return 1

mob
	var/tmp
		EditVar
		EditVal
		ClickEdit = 0
		ClickCreate = 0
		CreatePath
mob/GM
	verb
		Toggle_Click_Create()
			set category = "Events"
			if(clanrobed())return
			if(ClickCreate)
				ClickCreate = 0
				CreatePath = null
				src << "Click Creating mode toggled off."
			else
				if(ClickEdit)Toggle_Click_Editing()
				ClickCreate = 1
				src << "Click Creating mode toggled on."
		Toggle_Click_Editing()
			set category = "Events"
			if(clanrobed())return
			if(ClickEdit)
				ClickEdit = 0
				EditVar = null
				EditVal = null
				src << "Click Editing mode toggled off."
			else
				if(ClickCreate)Toggle_Click_Create()
				ClickEdit = 1
				src << "Click Editing mode toggled on."
		CreatePath(Path as null|anything in typesof(/area,/turf,/obj,/mob) + list("Delete"))
			set category = "Events"
			if(clanrobed())return
			CreatePath = Path
		MassEdit(Var as text)
			set category = "Events"
			if(clanrobed())return
			var/Type = input("What type?","Var Type") as null|anything in list("text","num","reference","null")
			if(Type)
				EditVar = Var
				switch(Type)
					if("text")
						EditVal = input("Value:","Text") as text
					if("num")
						EditVal = input("Value:","Number") as num
					if("reference")
						EditVal = input("Value:","Reference") as area|turf|obj|mob in world
					if("null")
						EditVal = null
		FFA_Mode(var/dmg as num, var/os as anything in list("On", "Off"))
			set category = "Events"
			var/area/a = locate(/area/arenas/MapThree/PlayArea)
			a.dmg = dmg
			a.oldsystem = os == "On"
			src << infomsg("Set dmg modifier to [dmg], old system is [os].")



atom/Click(location)
	..()
	if(usr.ClickEdit)
		if(!usr.EditVar)
			usr << "Pick a var to edit using MassEdit verb."
		else if(usr.EditVar in vars)
			vars[usr.EditVar] = usr.EditVal
	else if(usr.ClickCreate)
		if(!usr.CreatePath)
			usr << "Pick a path to create using CreatePath verb."
		else

			if(!usr.admin && (usr.z <= SWAPMAP_Z || src.z <= SWAPMAP_Z || ispath(usr.CreatePath, /obj/items) || ispath(usr.CreatePath, /mob)))
				usr << errormsg("Can't use outside swap maps or create items/mobs.")
				return

			if(usr.CreatePath == "Delete" && !isplayer(src))
				del src
			else if(isturf(location))
				new usr.CreatePath (location)
			//  Owner var
			//var/item = new usr.CreatePath(location)
			//item:owner = usr.key