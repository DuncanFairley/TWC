#define WORN 1
#define REMOVED 2


var/reputations

reputation
	var/rating = 0
	var/name
	var/time

proc/initRep(var/ckey)
	var/reputation/r = reputations[ckey]
	if(!r)
		r = new
		reputations[ckey] = r
	return r

mob/Player/proc


	getRep()
		var/reputation/r = initRep(ckey)
		return r.rating

	addRep(var/p = 0)
		var/reputation/r = initRep(ckey)
		r.rating += p
		return r.rating

clan
	var/points = 0

	Light
	Dark


obj/items/wearable/clan_robes

	var/hiddenID = FALSE

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
		else if(on && p.name != "Robed Figure")
			p.prevname = p.name
			p.name     = "Robed Figure"

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
		p.underlays = list()
		switch(p.House)
			if("Hufflepuff")
				p.GenerateNameOverlay(242,228,22)
			if("Slytherin")
				p.GenerateNameOverlay(41,232,23)
			if("Gryffindor")
				p.GenerateNameOverlay(240,81,81)
			if("Ravenclaw")
				p.GenerateNameOverlay(13,116,219)
			if("Ministry")
				p.GenerateNameOverlay(255,255,255)
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


/*

- test hidden ID bugs: PM, Telendevour etc

- add clan quests
- remove/add robes function
- robe icon + color line code

- fix old clan wars?
- fix new clan wars?


*/