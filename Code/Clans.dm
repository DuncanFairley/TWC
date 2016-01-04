#define WORN 1
#define REMOVED 2


var/const/REP_FACTOR = 100

var/list/reputations

reputation
	var/rating = 0
	var/name
	var/time

PlayerData
	var
		fame

		name
		time



	proc
		tierToFame(t)
			return 100 * t * (t + 1)

		fametoTier()
			var/r = max(abs(fame) - 1, 0)

			if(r >= 7200) return 8

			var/tier = (sqrt((REP_FACTOR*REP_FACTOR) + (4*REP_FACTOR*r))-REP_FACTOR)/(REP_FACTOR*2)

			return round(tier)

		getRep()
			var/r = abs(fame)

			if(r <= 200) return r

			return r - tierToFame(fametoTier())

proc/initRep(var/ckey)

	if(!worldData.playersData) worldData.playersData = list()

	var/PlayerData/p = worldData.playersData[ckey]
	if(!p)
		p = new
		worldData.playersData[ckey] = p
	return p

mob/Player/proc

	getRep(trim = 0)
		var/PlayerData/r = initRep(ckey)

		return trim ? r.getRep() : r.fame

	addRep(var/p = 0, silent = 0, max = 1)
		var/PlayerData/r = initRep(ckey)

		if(max)

			var/tier

			if(p < 0 && r.fame > 0)      tier = 1
			else if(p > 0 && r.fame < 0) tier = 1
			else                         tier = r.fametoTier() + 1

			var/max_rep = r.tierToFame(tier) * (p > 0 ? 1 : -1)

			if((p > 0 && r.fame + p >= max_rep) || (p < 0 && r.fame + p <= max_rep))
				p = max_rep - r.fame
		else
			r.time = world.realtime

		if(p != 0)
			r.fame += p

			if(pname)
				r.name = pname
			else if(prevname)
				r.name = prevname
			else
				r.name = name

			if(!silent)
				src << infomsg("You gained [abs(p)] [p > 0 ? "peace" : "chaos"] reputation.")

		return r.fame

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

	if(rating > 7200) return "<font color=#9f0419>Legend</font>"
	if(rating > 5600) return "<font color=#aa2fbd>Grand Master</font>"
	if(rating > 4200) return "<font color=#01e4ac>Lord</font>"
	if(rating > 3000) return "<font color=#ff0000>Master</font>"
	if(rating > 2000) return "<font color=#E5E4E2>Respected Warrior</font>"
	if(rating > 1200) return "<font color=#FFD700>Warrior</font>"
	if(rating > 600)  return "<font color=#C0C0C0>Disciple</font>"
	if(rating > 200)  return "<font color=#CD7F32>Initiate</font>"
	return "Neutral"

obj/rep_scoreboard
	icon = 'Rock.dmi'
	mouse_over_pointer = MOUSE_HAND_POINTER
	var/peace = 1
	Click()
		..()
		if(worldData.playersData)

			var/list/people = list()

			for(var/k in worldData.playersData)
				var/PlayerData/p = worldData.playersData[k]

				if(world.realtime - p.time > 12096000) continue

				if((peace && p.fame > 100) || (!peace && p.fame < -100))
					people[p.name] = p


			bubblesort_by_value(people, "fame", TRUE)
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
			for(var/i = (peace ? people.len : 1) to (peace ? 1 : people.len) step (peace ? -1 : 1))

				var/PlayerData/p = people[people[i]]

				html += "<tr class=[isWhite ? "white" : "black"]><td>[rankNum]</td><td>[p.name]</td><td>[getRepRank(p.fame)] ([p.getRep()])</td></tr>"
				isWhite = !isWhite
				rankNum++
			html += "</table>"

			usr << browse(SCOREBOARD_HEADER + html + "</center></html>","window=scoreboard")
