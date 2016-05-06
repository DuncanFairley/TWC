/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
obj/destination
	invisibility=2
mob
	ministryfinancer
		icon_state="divo"
		icon = 'NPCs.dmi'
		density=1
		name = "Head of Finance"
		verb
			Talk()
				set src in oview(3)
				var/mob/Player/p = usr
				if(p.Rank == "Minister of Magic")
					hearers() << npcsay("Head of Finance: Hello, Minister. We currently have [worldData.ministrybank] gold.")
					var/choice = input("What would you like to do?") as null|anything in list("Deposit gold","Withdraw gold","Change tax rate")
					switch(choice)
						if("Deposit gold")
							var/amount = input("How much would you like to deposit?",,usr.gold.get()) as null|num
							if(!amount)return
							if(p.gold.get() >= amount && amount > 0)
								hearers() << npcsay("Head of Finance: I've placed the [amount] gold into the account.")
								worldData.ministrybank += amount
								p.gold.add(-amount)
							else
								hearers() << npcsay("Head of Finance: You don't have that much gold.")
						if("Withdraw gold")
							var/amount = input("How much would you like to withdraw?",,worldData.ministrybank) as null|num
							if(!amount)return
							if(amount <= worldData.ministrybank && amount > 0)
								hearers() << npcsay("Head of Finance: Here is the [amount] gold.")
								worldData.ministrybank -= amount
								p.gold.add(amount)
							else
								hearers() << npcsay("Head of Finance: There isn't that much gold in the ministry account.")

						if("Change tax rate")
							var/newtaxrate = input("What will the new taxrate be? (%)","New Tax Rate",worldData.taxrate) as null|num
							if(!newtaxrate)return
							worldData.taxrate = newtaxrate
							hearers() << npcsay("Head of Finance: The tax rate is now [worldData.taxrate]%.")
				else
					hearers() << npcsay("Head of Finance: Unfortunately, I can only discuss the finances of the Ministry with the Minister.")
obj/ministrybox
	name = "Ministry Mail Box"
	icon = 'desk.dmi'
	icon_state = "ministrybox"
	mouse_over_pointer = MOUSE_HAND_POINTER
	New()
		..()
		ministrybox = src
	Click()
		if(!(src in oview(1)))return
		var/mob/Player/p = usr
		if(p.House=="Ministry")
			var/reply = alert("Do you wish to retrieve the mail, or add something?",,"Retrieve","Add","Cancel")
			if(reply=="Cancel")return
			else if(reply == "Retrieve")
				var/i = 0
				for(var/obj/O in src.contents)
					O.Move(usr)
					i++
				p.Resort_Stacking_Inv()
				p << "<b>Ministry Box:</b> <i> [i] item[i==1 ? "" : "s"] of mail [i==1 ? "has" : "have"] been added to your inventory.</i>"
				return

		var/list/obj/items/scroll/scrolls = list()
		for(var/obj/items/scroll/S in usr)
			scrolls += S
		if(scrolls.len<1)
			view(src) << "<b>Ministry Box:</b> <i>You need to be carrying a scroll before you can drop it in the box.</i>"
		else
			var/obj/items/scroll/S = input("Which scroll would you like to give to the ministry? Note that junk mail is not permitted - if you abuse this system you will be banned from the Ministry of Magic premises.") as null|obj in scrolls
			if(!S) return
			if(!S.content)
				view(src) << "<b>Ministry Box:</b> <i>Your scroll doesn't have anything written on it.</i>"
			else
				S.Move(src)
				view(src) << "<b>Ministry Box:</b> <i>Thank you!</i>"

