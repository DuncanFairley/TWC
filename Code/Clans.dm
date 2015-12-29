#define WORN 1
#define REMOVED 2


var/list/reputations

reputation
	var/rating = 0
	var/name
	var/time

proc/initRep(var/ckey)

	if(!reputations) reputations = list()

	var/reputation/r = reputations[ckey]
	if(!r)
		r = new
		reputations[ckey] = r
	return r

mob/Player/proc


	getRep()
		var/reputation/r = initRep(ckey)
		return r.rating

	addRep(var/p = 0, silent = 0)
		var/reputation/r = initRep(ckey)
		r.rating += p
		r.time = world.realtime

		if(pname)
			r.name = pname
		else if(prevname)
			r.name = prevname
		else
			r.name = name

		if(!silent)
			src << infomsg("You gained [abs(p)] [p > 0 ? "peace" : "chaos"] reputation.")
		return r.rating

clan
	var/points = 0

	Light
	Dark


obj/items/wearable/clan_robes

	var/hiddenID = FALSE
	canAuction = FALSE
	dropable = 1
	takeable = 1

	Equip(var/mob/Player/owner,var/overridetext=0)
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] wears \his [name].")
			for(var/obj/items/wearable/clan_robes/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,1)
			wear(owner)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] removes \his [name].")

			remove(owner)

	proc/toggle_hood(mob/Player/p, on)
		if(!on && p.prevname)
			p.name     = p.prevname
			p.prevname = null

			if(p.Gender == "Male")
				p.gender = MALE
			else if(p.Gender == "Female")
				p.gender = FEMALE
			else
				p.gender = MALE

		else if(on && p.name != "Robed Figure")
			p.prevname = p.name
			p.name     = "Robed Figure"
			p.gender   = NEUTER

	verb/wear_hood()
		set src in usr
		if(src in usr:Lwearing)
			hiddenID = !hiddenID
			toggle_hood(usr, hiddenID)

			usr.underlays = list()
			wear(usr, FALSE)

	proc/getIcon(var/mob/Player/p)
		if(p.trnsed) return
		if(p.Gender == "Male")
			p.icon = 'MaleAuror.dmi'
		else
			p.icon = 'FemaleAuror.dmi'

	proc/remove(var/mob/Player/p)
		toggle_hood(p, 0)
		p.addNameTag()
		if(locate(/mob/GM/verb/GM_chat) in p.verbs) p.Gm = 1
		p.trnsed = 0
		p.BaseIcon()
		p.ApplyOverlays()


	proc/wear(var/mob/Player/p)
		for(var/mob/Player/watcher in Players)
			var/client/C = watcher.client
			if(C.eye)
				if(C.eye == p && watcher != p)
					C << "<b><font color = white>Your Telendevour wears off."
					C.eye = watcher
		p.density=1
		p.underlays = list()
		p.Immortal = 0
		p.Gm = 0

		if(!p.trnsed)
			getIcon(p)

		toggle_hood(p, hiddenID)

	light_robes

		wear(var/mob/Player/p, base = TRUE)
			if(base) ..(p)
			p.GenerateNameOverlay(196,237,255, hiddenID)

	dark_robes

		wear(var/mob/Player/p, base = TRUE)
			if(base) ..(p)
			p.GenerateNameOverlay(77,77,77, hiddenID)


proc/getRepRank(var/rating)

	rating = abs(rating)

	if(rating > 4000) return "<font color=#9f0419>Legend</font>"
	if(rating > 3200) return "<font color=#aa2fbd>Grand Master</font>"
	if(rating > 2500) return "<font color=#01e4ac>Lord</font>"
	if(rating > 1900) return "<font color=#ff0000>Master</font>"
	if(rating > 1400) return "<font color=#E5E4E2>Respected Warrior</font>"
	if(rating > 900)  return "<font color=#FFD700>Warrior</font>"
	if(rating > 500)  return "<font color=#C0C0C0>Disciple</font>"
	if(rating > 200)  return "<font color=#CD7F32>Initiate</font>"
	return "Neutral"

obj/rep_scoreboard
	icon = 'Rock.dmi'
	mouse_over_pointer = MOUSE_HAND_POINTER
	var/peace = 1
	Click()
		..()
		if(expScoreboard)
			bubblesort_by_value(reputations, "rating", TRUE)
			var/const/SCOREBOARD_HEADER = {"<html><head><title>Reputation Leaderboard</title><style>body
{
	background-color:#FAFAFA;
	font-size:large;
	margin: 0px;
	padding:0px;
	color:#404040;
}
table.colored
{
	background-color:#FAFAFA;
	border-collapse: collapse;
	text-align: left;
	width:100%;
	font: normal 13px/100% Verdana, Tahoma, sans-serif;
	border: solid 1px #E5E5E5;
	padding:3px;
	margin: 4px;
}
tr.white
{
	background-color:#FAFAFA;
	border: solid 1px #E5E5E5;
}
tr.black
{
	background-color:#DFDFDF;
	border: solid 1px #E5E5E5;
}
tr.grey
{
	background-color:#EFEFEF;
	border: solid 1px #EEEEEE;
}
}</style></head>"}

			var/html = {"<body><center><table align="center" class="colored"><tr><td colspan="3"><center>[peace ? "Peace" : "Chaos"] Reputation Leaderboard</center></td></tr><tr><td>#</td><td>Name</td><td>Rank</td></tr>"}
			var/rankNum = 1
			var/isWhite = TRUE
			for(var/i = (peace ? reputations.len : 1) to (peace ? 1 : reputations.len) step (peace ? -1 : 1))

				var/reputation/r = reputations[reputations[i]]
				if(abs(r.rating) < 100) break
				if(world.realtime - r.time > 12096000) continue

				html += "<tr class=[isWhite ? "white" : "black"]><td>[rankNum]</td><td>[r.name]</td><td>[getRepRank(r.rating)] ([abs(r.rating)])</td></tr>"
				isWhite = !isWhite
				rankNum++
			html += "</table>"

			usr << browse(SCOREBOARD_HEADER + html + "</center></html>","window=scoreboard")

/*

- remove/add robes function/quest
- robe icon + color line code

- fix old clan wars?
- fix new clan wars??? already fixed?


*/
