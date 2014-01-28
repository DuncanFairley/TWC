/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
/*
Those two mobs pretty much exist already only they were bugged.
You can remove the old mobs from the source but that's up to you.

Old mobs names:
EventMob_Item
EventMob_Variable

I changed them to work properly and have more options.
Those mobs can help admins+ add quests.


There's only one thing I couldn't do.
I couldn't call stacking update proc for EventMobItem since I don't know it's name.

Changes/Fixes:

 - You can now change what the mobs say.
 - Event Mob Variable can now do more than just 'set' values, it can add/remove/double number values for example.
 - AlreadyGiven list was changed to work with ckeys instead of names (People could use Deatheater robes to get two prizes)
 - Event Mob Item now actually gives items.
 - AlreadyGiven now have a reset option.
 - Changed the paths of both mobs by removing the _ to avoid compile errors (Because those paths are already used).
*/


mob


	/*
	This mob gives an item once to everyone who talks to it.

	You need to add the stacking code for this mob.
	*/
	EventMobItem
		icon = 'misc.dmi'
		icon_state = "palmer"
		name = "Event Mob"
		Immortal = 1
		Gm = 1
		var
			list/AlreadyGiven = list()
			EventItem
			Message = "Hello."
		verb
			Talk()
				set src in view(1)
				if(AlreadyGiven == "reset")AlreadyGiven = list()
				if(!EventItem)
					usr << " <font size=2 color=red><b>[src]</b> : </font>I have nothing to give you."
					return
				if(usr.ckey in AlreadyGiven)
					usr << " <font size=2 color=red><b>[src]</b> : </font>Hello! I've already given you the item. Sorry."
					return
				else
					AlreadyGiven.Add(usr.ckey)
					var/obj/O = new EventItem(usr)
					usr:Resort_Stacking_Inv()
			//		Stacking code here.
					usr << " <font size=2 color=red><b>[src]</b> : </font>[Message]"
					usr << " <font size=2 color=red>[src] hands you their [O.name]."



	/* This mob changes a var to everyone who talks to it.
	   It can add/remove/double for number values. (Adding also works for lists I guess)
	   For example, it can give everyone who talks to it 100 Gold once. */
	EventMobVariable
		icon = 'misc.dmi'
		icon_state = "palmer"
		name = "Event Mob"
		Immortal = 1
		Gm = 1
		var
			list/AlreadyGiven = list()
			EventVar
			VarTo
			Message = "Hello."
			Function = "="
		verb
			Talk()
				set src in view(1)
				if(AlreadyGiven == "reset")AlreadyGiven = list()
				if(usr.ckey in AlreadyGiven)
					usr << " <font size=2 color=red><b>[src]</b> : </font>Hello! I've seen you before."
					return
				else
					AlreadyGiven.Add(usr.ckey)
					usr << " <font size=2 color=red><b>[src]</b> : </font>[Message]"
					if(Function == "=")
						usr.vars[EventVar] = VarTo
					else if(Function == "+")
						usr.vars[EventVar] += VarTo
					else if(Function == "*")
						usr.vars[EventVar] *= VarTo

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
			CreatePath = Path
		MassEdit(Var as text)
			set category = "Events"
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
		else if(usr.CreatePath == "Delete")
			del src
		else
			new usr.CreatePath(location)
			//  Owner var
			//var/item = new usr.CreatePath(location)
			//item:owner = usr.key