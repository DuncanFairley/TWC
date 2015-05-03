/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
/obj/destination
	invisibility=2
mob
	ministryfinancer
		icon_state="divo"
		icon = 'NPCs.dmi'
		NPC = 1
		Gm = 1
		player=1
		Immortal=1
		density=1
		name = "Head of Finance"
		verb
			Talk()
				set src in oview(3)
				if(usr.Rank == "Minister of Magic")
					hearers() << npcsay("Head of Finance: Hello, Minister. We currently have [ministrybank] gold.")
					var/choice = input("What would you like to do?") as null|anything in list("Deposit gold","Withdraw gold","Change tax rate")
					switch(choice)
						if("Deposit gold")
							var/amount = input("How much would you like to deposit?",,usr.gold) as null|num
							if(!amount)return
							if(usr.gold >= amount && amount > 0)
								hearers() << npcsay("Head of Finance: I've placed the [amount] gold into the account.")
								ministrybank += amount
								usr.gold -= amount
							else
								hearers() << npcsay("Head of Finance: You don't have that much gold.")
						if("Withdraw gold")
							var/amount = input("How much would you like to withdraw?",,ministrybank) as null|num
							if(!amount)return
							if(amount <= ministrybank && amount > 0)
								hearers() << npcsay("Head of Finance: Here is the [amount] gold.")
								ministrybank -= amount
								usr.gold += amount
							else
								hearers() << npcsay("Head of Finance: There isn't that much gold in the ministry account.")

						if("Change tax rate")
							var/newtaxrate = input("What will the new taxrate be? (%)","New Tax Rate",taxrate) as null|num
							if(!newtaxrate)return
							taxrate = newtaxrate
							hearers() << npcsay("Head of Finance: The tax rate is now [taxrate]%.")
				else
					hearers() << npcsay("Head of Finance: Unfortunately, I can only discuss the finances of the Ministry with the Minister.")
/obj/ministrybox
	name = "Ministry Mail Box"
	icon = 'desk.dmi'
	icon_state = "ministrybox"
	mouse_over_pointer = MOUSE_HAND_POINTER
	New()
		..()
		ministrybox = src
	Click()
		if(!(src in oview(1)))return
		if(usr.House=="Ministry")
			var/reply = alert("Do you wish to retrieve the mail, or add something?",,"Retrieve","Add","Cancel")
			if(reply=="Cancel")return
			else if(reply == "Retrieve")
				var/i = 0
				for(var/obj/O in src.contents)
					O.Move(usr)
					i++
				usr:Resort_Stacking_Inv()
				usr << "<b>Ministry Box:</b> <i> [i] item[i==1 ? "" : "s"] of mail [i==1 ? "has" : "have"] been added to your inventory.</i>"
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

var/list/bugfixes = list()
var/list/unvoteablebugfixes = list()
var/list/changes = list()

mob/test
	verb
		ChangelogAdmin()
			set name = "Changelog Admin"
			switch(alert("Edit or delete changelog?","Changelog Admin","Edit","Delete"))
				if("Edit")
					var/input = input("Changelog contents:","Changelog admin",file2text(file("changelog.html"))) as null|message
					if(!input) return
					fdel("changelog.html")
					file("changelog.html") << "[input]"
					src << "Changelog updated. Thank you Murra, you ROCK.;)"
				if("Delete")
					fdel("changelog.html")

	//src << browse(file("changelog.html"),"window=1;size=500x500")
	/*var/input = input("What would you like to do?") as null|anything in list("Add change","Remove change","View votes")
	switch(input)
		if("Add change")
			input = input("What type of change?") as  null|anything in list("Bugfix","Unvoteable Bugfix","Addition/change")
			switch(input)
				if("Bugfix")
					input = input("What's the bugfix?") as null|text
					if(input)
						bugfixes["[input]"] = 0
				if("Unvoteable Bugfix")
					input = input("What's the bugfix?") as null|text
					if(input)
						unvoteablebugfixes["[input]"] = 0
				if("Addition/change")
					input = input("What's the Addition/change?") as null|text
					if(input)
						changes["[input]"] = 0
		if("Remove change")
			input = alert("Would you like to remove all, or remove a specific change?",,"Remove all","Remove one","Cancel")
			switch(input)
				if("Remove all")
					bugfixes = list()
				if("Remove one")
					input = alert("Type?",,"Bugfix","Unvoteable Bugfix","Change")
					switch(input)
						if("Bugfix")
							input = input("Which one?") as null|anything in bugfixes
							if(!input)return
							bugfixes.Remove(input)
						if("Unvoteable Bugfix")
							input = input("Which one?") as null|anything in unvoteablebugfixes
							if(!input)return
							unvoteablebugfixes.Remove(input)
						if("Change")
							input = input("Which one?") as null|anything in changes
							if(!input)return
							changes.Remove(input)
		if("View votes")
			var/middle = "</table>Bugfixes:<table border=1>"
			for(var/A in bugfixes)
				middle += "<tr><td>[A]</td><td>[bugfixes[A]]</td></tr>"
			var/html = {"
<html>
<head>
<title>Change log display</title>
</head>
<body>
	[middle]
</body>
</html>"}
			usr << browse(html,"window=1;size=500x500")
mob/You/var/list/mybugs = list()

mob/You/verb/Changelog()
	var/middle = "<b>Version [VERSION]</b><br />"
	if(changes.len)
		middle += {"<u>Additions/Changes</u>:<br />
<table>
	"}
		for(var/A in changes)
			middle += "<tr><td>-[A]</td></tr>"
		middle += "</table>"
	if(bugfixes.len)
		middle += {"<u>Bugfixes</u>:<br />
<table>
	"}
		for(var/A in bugfixes)
			if(mybugs["[copytext(A,1,15)]"])
				if(mybugs["[copytext(A,1,15)]"] == "1")
					middle += "<tr><td>-[A]</td><td>(Fixed/<a href='?src=\ref[src];action=changelog_vote;index=[copytext(A,1,15)];vote=-1'>Unfixed</a>)</td></tr>"
				else
					middle += "<tr><td>-[A]</td><td>(<a href='?src=\ref[src];action=changelog_vote;index=[copytext(A,1,15)];vote=1'>Fixed</a>/Unfixed</a>)</td></tr>"
			else
				middle += "<tr><td>-[A]</td><td>(<a href='?src=\ref[src];action=changelog_vote;index=[copytext(A,1,15)];vote=1'>Fixed</a>/<a href='?src=\ref[src];action=changelog_vote;index=[copytext(A,1,15)];vote=-1'>Unfixed</a>)</td></tr>"
		middle += "</table>"
		for(var/A in unvoteablebugfixes)
			middle += "<tr><td>-[A]</td></tr>"
		middle += "</table>"
	var/html = {"
<html>
<head>
<title>Changelog</title>
</head>
<body>
	[middle]
</body>
</html>"}
	usr << browse(html,"window=1;size=500x500")*/