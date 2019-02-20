/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

#define WORN 1
#define REMOVED 2


var/const/REP_FACTOR = 100

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

proc/initPlayer(var/ckey)

	if(!worldData.playersData) worldData.playersData = list()

	var/PlayerData/p = worldData.playersData[ckey]
	if(!p)
		p = new
		worldData.playersData[ckey] = p
	return p

mob/Player/proc

	getRep(trim = 0)
		if(!worldData.playersData) worldData.playersData = list()

		var/PlayerData/r = worldData.playersData[ckey]
		if(!r) return 0

		return trim ? r.getRep() : r.fame

	addRep(var/p = 0, silent = 0, max = 1)
		var/PlayerData/r = initPlayer(ckey)

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


proc/getRepRank(var/rating)

	rating = abs(rating)

	if(rating > 7200) return "<span style=\"color:#9f0419;\">Legend</span>"
	if(rating > 5600) return "<span style=\"color:#aa2fbd;\">Grand Master</span>"
	if(rating > 4200) return "<span style=\"color:#01e4ac;\">Lord</span>"
	if(rating > 3000) return "<span style=\"color:#ff0000;\">Master</span>"
	if(rating > 2000) return "<span style=\"color:#E5E4E2;\">Respected Warrior</span>"
	if(rating > 1200) return "<span style=\"color:#FFD700;\">Warrior</span>"
	if(rating > 600)  return "<span style=\"color:#C0C0C0;\">Disciple</span>"
	if(rating > 200)  return "<span style=\"color:#CD7F32;\">Initiate</span>"
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

			var/list/guilds

			if(worldData.guilds && worldData.guilds.len)

				guilds = list()

				for(var/k in worldData.guilds)
					var/guild/g = worldData.guilds[k]

					if((peace && g.Rep() > 100) || (!peace && g.Rep() < -100))
						guilds[k] = g.Score()

				if(!guilds.len)
					guilds = null
				else
					bubblesort_by_value(guilds)

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

			if(guilds)
				rankNum = 1
				isWhite = TRUE

				html += {"</table><table align="center" class="colored"><tr><td colspan="4"><center>[peace ? "Peace" : "Chaos"] Guilds Leaderboard</center></td></tr><tr><td>#</td><td>Name</td><td>Reputation</td><td>Skill</td></tr>"}

				for(var/i = (peace ? guilds.len : 1) to (peace ? 1 : guilds.len) step (peace ? -1 : 1))

					var/guild/g = worldData.guilds[guilds[i]]

					html += "<tr class=[isWhite ? "white" : "black"]><td>[rankNum]</td><td>[g.name]</td><td>[abs(g.Rep())]</td><td>[g.Skill()]</td></tr>"
					isWhite = !isWhite
					rankNum++


			usr << browse(SCOREBOARD_HEADER + html + "</table></center></body></html>","window=scoreboard")


obj/items/wearable/masks
	desc = "A mask to hide your identity."
	wear_layer = FLOAT_LAYER - 3

	var
		r
		g
		b
		n = "Masked Figure"

	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		if(!overridetext && !forceremove && !(src in owner.Lwearing) && istype(owner.loc.loc, /area/hogwarts) && issafezone(owner.loc.loc))
			owner << errormsg("You can't wear this here.")
			return

		. = ..(owner)
		if(forceremove) return
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] wears \his [src.name].")
			for(var/obj/items/wearable/masks/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,1,0)

			if(n == "Auror")

				if(owner.Gender == "Female")
					owner.icon = 'FemaleAuror.dmi'
				else
					owner.icon = 'MaleAuror.dmi'

				owner.underlays = list()
				owner.GenerateNameOverlay(r,g,b)
				return

			if(!owner.prevname)
				owner.prevname = owner.name
				owner.gender   = NEUTER

			if(n == "Deatheater" && !owner.trnsed && !owner.noOverlays)
				owner.icon = 'Deatheater.dmi'
				owner.trnsed = 1
				owner.overlays = null
				if(owner.away) owner.ApplyAFKOverlay()

			owner.name = n
			owner.underlays = list()
			if(n == "Masked Figure")
				var/guild/i
				if(worldData.guilds) i = worldData.guilds[owner.guild]
				owner.GenerateNameOverlay(r,g,b, i ? i.ranks[1] : 1)
			else
				owner.GenerateNameOverlay(r,g,b, 1)

		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")

			if(n == "Auror")
				owner.BaseIcon()

				owner.underlays = list()
				owner.addNameTag()
			else if(owner.prevname)
				owner.name     = owner.prevname
				owner.prevname = null

				if(owner.Gender == "Male")
					owner.gender = MALE
				else if(owner.Gender == "Female")
					owner.gender = FEMALE
				else
					owner.gender = MALE

				owner.underlays = list()
				owner.addNameTag()

				if(n == "Deatheater")
					owner.trnsed = 0
					owner.BaseIcon()
					owner.ApplyOverlays()


obj/items/wearable/masks/peace_mask
	icon = 'mask_peace.dmi'
	dropable = 0
	r = 196
	g = 237
	b = 255

obj/items/wearable/masks/chaos_mask
	icon = 'mask_chaos.dmi'
	dropable = 0
	r = 140
	g = 10
	b = 10

obj/items/wearable/masks/black_mask
	icon = 'mask_black.dmi'
	r = 77
	g = 77
	b = 77

obj/items/wearable/masks/white_mask
	icon = 'mask_white.dmi'
	r = 200
	g = 200
	b = 200

obj/items/wearable/masks/purple_mask
	icon = 'mask_purple.dmi'
	r = 128
	g = 0
	b = 128

obj/items/wearable/masks/pink_mask
	icon = 'mask_pink.dmi'
	r = 255
	g = 192
	b = 203

obj/items/wearable/masks/orange_mask
	icon = 'mask_orange.dmi'
	r = 255
	g = 165
	b = 0

obj/items/wearable/masks/teal_mask
	icon = 'mask_teal.dmi'
	r = 0
	g = 128
	b = 128

area
	hogwarts
		Entered(atom/movable/Obj, atom/OldLoc)
			..()

			if(isplayer(Obj) && issafezone(src))
				var/mob/Player/p = Obj

				var/obj/items/wearable/masks/m = locate() in p.Lwearing

				if(m)
					spawn(1) m.Equip(p, 1, 0)


obj/items/wearable/masks/robe
	desc = "A robe to hide your identity."
	dropable = 0
	showoverlay = FALSE

	deatheater_robes
		icon = 'Deatheater.dmi'
		r = 77
		g = 77
		b = 77
		n = "Deatheater"

	auror_robes
		icon = 'MaleAuror.dmi'
		r = 196
		g = 237
		b = 255
		n = "Auror"

