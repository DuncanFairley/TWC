/*mob/verb/NewVault1()

	//THIS IS THE FUNCTION FOR CREATING ADDITIONAL VAULT TEMPLATES

	var/height = 10
	var/width = 9 //Width must be odd.
	var/midx = (width+1)/2
	var/swapmap/map = new /swapmap("vault1",width,height,1)
	map.BuildRectangle(map.LoCorner(),map.HiCorner(),/turf/roofb)
	map.BuildFilledRectangle(get_step(map.LoCorner(),NORTHEAST),get_step(map.HiCorner(),SOUTHWEST),/turf/floor)
	map.BuildFilledRectangle(locate(map.x1+1,map.y1+height-2,map.z1),locate(map.x1+width-2,map.y1+height-2,map.z1),/turf/Hogwarts_Stone_Wall)
	map.BuildFilledRectangle(locate(map.x1+midx-1,map.y1+1,map.z1),locate(map.x1+midx-1,map.y1+1,map.z1),/obj/teleport/leavevault)
	map.Save()


mob/verb/NewVaultCustom(var/height as num, var/width as num)

	if(width % 2 == 0) width--

	var/midx = (width+1)/2
	var/swapmap/map = new /swapmap("vault_wizard",width,height,1)
	map.BuildRectangle(map.LoCorner(),map.HiCorner(),/turf/roofb)
	map.BuildFilledRectangle(get_step(map.LoCorner(),NORTHEAST),get_step(map.HiCorner(),SOUTHWEST),/turf/floor)
	map.BuildFilledRectangle(locate(map.x1+1,map.y1+height-2,map.z1),locate(map.x1+width-2,map.y1+height-2,map.z1),/turf/Hogwarts_Stone_Wall)


	map.BuildFilledRectangle(locate(map.x1+midx-1,map.y1+1,map.z1),locate(map.x1+midx-1,map.y1+1,map.z1),/obj/teleport/leavevault)
	map.Save()

mob/verb/LoadMapCUSTOM()
	var/swapmap/map = SwapMaps_Load("vault_wizard")

	var/width = (map.x2+1) - map.x1
	usr.loc = locate(map.x1 + round((width)/2), map.y1+1, map.z1 )

mob/verb/SaveMapCUSTOM()
	var/swapmap/map = SwapMaps_Find("vault_wizard")
	map.Save()
*/
mob/test/verb
	enter_vault(ckey as text)
		set category = "Debug"
		var/swapmap/map = SwapMaps_Find("[ckey]")
		if(!map)
			map = SwapMaps_Load("[ckey]")
		if(!map)
			usr << "<i>Couldn't find map.</i>"
		else
			var/width = (map.x2+1) - map.x1
			usr.loc = locate(map.x1 + round((width)/2), map.y1+1, map.z1 )
	Change_Vault(var/vault as text, var/mob/Player/p in Players)
		set category = "Debug"
		if(fexists("[swapmaps_directory]/tmpl_vault[vault].sav"))
			p.change_vault(vault)
			usr << infomsg("Vault changed")
		else
			usr << errormsg("Vault don't exist.")

mob/Player/proc/change_vault(var/vault)
	var/swapmap/map = SwapMaps_Find("[ckey]")
	if(!map)
		map = SwapMaps_Load("[ckey]")

	var/list/items = list()
	if(map)
		if(!map.InUse())
			for(var/turf/t in map.AllTurfs())
				for(var/obj/items/i in t)
					items += i
					i.loc = null
			map.Unload()
		else
			src << errormsg("Please evacuate everyone from your vault first.")
			return

	sleep(1)

	if(!islist(worldData.globalvaults))
		worldData.globalvaults = list()
	var/vault/v = new
	v.tmpl = vault
	v.version = VAULT_VERSION
	sleep(1)
	worldData.globalvaults[src.ckey] = v
	map = SwapMaps_CreateFromTemplate("vault[vault]")
	if(!map)
		world.log << "ERROR: proc: change_vault() Could not create \"[vault]\" swap map template (vault[vault])"
		return 0

	var/doors = 0
	if(vault == "_hq")
		doors = 5

	else if(vault == "_wizard")
		doors = 7

		var/obj/color_lamp/c = locate("vaultColorLamp")
		c.vaultOwner = ckey

	for(var/i = 1 to doors)
		var/obj/Hogwarts_Door/d = locate("vaultDoor[i]")
		d.tag = null
		d.vaultOwner = ckey

	var/width = (map.x2+1) - map.x1
	var/turf/newEntrance = locate(map.x1 + round((width)/2), map.y1+1, map.z1 )
	for(var/obj/items/i in items)
		i.loc = newEntrance

	map.SetID("[src.ckey]")
	map.Save()
	return 1

obj/teleport
	var/dest = ""
	var/pass
	invisibility = 2
	portkey
		icon='portal.dmi'
		icon_state="portkey"
		name = "Port key"
		invisibility = 0

	Crossed(mob/Player/p)
		if(isplayer(p))
			Teleport(p)

	proc/Teleport(mob/Player/M)
		if(dest)
			if(pass && pass != "")
				var/pw = input(M, "You feel this spot was enchanted with a password protected teleporting spell","Teleport","") as null|text
				if(!pw || M.loc != src.loc) return
				if(pw == pass)
					M << infomsg("Authorization Confirmed.")
				else
					M << errormsg("Authorization Denied.")
					return

			var/atom/A = locate(dest) //can be some turf, or some obj
			if(A)
				if(isobj(A))
					A = A.loc
				M:Transfer(A)
				M.lastproj = world.time + 10
				M.removePath()
				if(M.classpathfinding)
					M.Class_Path_to()
				else if(M.pathdest)
					M.pathTo(M.pathdest)
				return 1
	house
		var/house
		Teleport(mob/Player/M)
			if(!isplayer(M)) return
			if(house == M.House)
				..()
				M << infomsg("<b>Welcome to your common room.</b>")
			else
				M.followplayer = 0
				var/dense = M.density
				M.density = 0
				step(M, turn(M.dir, 180))
				M.density = dense
				M << errormsg("<b>This isn't your common room.</b>")

	entervault
		var/onlySelf = 1
		Teleport(mob/Player/M)
			var/list/accessible_vaults = M.get_accessible_vaults()
			var/hasownvault = 	fexists("[swapmaps_directory]/map_[M.ckey].sav")
			if(hasownvault || (!onlySelf && accessible_vaults.len))
				var/list/result = list()
				if(!onlySelf)
					for(var/ckey in accessible_vaults)
						var/n = sql_get_name_from(ckey)
						if(n in M.blockedpeeps) continue
						result[n] = ckey
				var/chosenvault
				var/response
				if(result.len && hasownvault)
					response = input("Which vault do you wish to enter?") as null|anything in result + "My own"
					if(response == "My own")
						chosenvault = M.ckey
				else if(result.len)
					response = input("Which vault do you wish to enter?") as null|anything in result
				else if(hasownvault)
					chosenvault = M.ckey
				if(M.loc != src.loc) return
				if(chosenvault == M.ckey)
					M << npcsay("Vault Master: Welcome back to your vault, [M].[pick(" Remember good security! If you let someone inside and they steal something, there's not much you can do about it!!"," Only let people into your vault if you completely trust them!","")]")
				else
					if(!response) return
					M << npcsay("Vault Master: Welcome to [response]'s vault, [M].")
					chosenvault = result[response]
				var/swapmap/map = SwapMaps_Find("[chosenvault]")
				if(!map)
					map = SwapMaps_Load("[chosenvault]")
				var/width = (map.x2+1) - map.x1

				var/vault/v = worldData.globalvaults[chosenvault]
				if(v && v.version < VAULT_VERSION && map)
					updateVault(map, chosenvault, v.version)
					v.version = VAULT_VERSION

				M.loc = locate(map.x1 + round((width)/2), map.y1+1, map.z1 )

				if(chosenvault == M.ckey && M.addToVault)
					var/turf/t = locate(M.x, M.y + 2, M.z)
					for(var/obj/o in M.addToVault)
						o.Move(t)
					M.addToVault = null

			else
				M << npcsay("Vault Master: You don't have a vault here, [M]. Come speak to me and let's see if we can change that.")
	leavevault
		icon = 'turf.dmi'
		icon_state = "exit"
		dest="leavevault"
		invisibility = 0
		Teleport(mob/M)
			if(..())
				unload_vault()

var/tmp/vault_last_exit
proc/unload_vault(updateTime = TRUE)
	if(vault_last_exit && updateTime)
		vault_last_exit = world.time
		return

	var/const/VAULT_TIMEOUT = 600
	vault_last_exit = world.time

	spawn(VAULT_TIMEOUT)
		while(vault_last_exit)
			if(world.time - vault_last_exit >= VAULT_TIMEOUT)
				var/list/custom_loaded = list()
				for(var/customMap/c in loadedMaps)
					custom_loaded += c.swapmap

				for(var/swapmap/map in (swapmaps_loaded ^ custom_loaded))
					if(!map.InUse())
						for(var/turf/T in map.AllTurfs())
							for(var/mob/A in T)
								if(!A.key)del(A)
						map.Unload()
				vault_last_exit = null
			sleep(VAULT_TIMEOUT)

proc/updateVault(swapmap/map, owner, version)

	if(version < 2)
		for(var/turf/t in map.AllTurfs())
			for(var/obj/items/i in t)
				if(istype(i, /obj/items/ingredients/daisy) || istype(i, /obj/items/ingredients/aconite) || istype(i, /obj/items/food))
					i.Dispose()

	if(version < 3)
		for(var/turf/t in map.AllTurfs())
			for(var/obj/items/wearable/w in t)
				if(w.quality == 0) continue

				if(istype(w, /obj/items/wearable/wands))
					w.quality = min(round(w.quality * 10, 1), MAX_WAND_LEVEL)

				else if(istype(w, /obj/items/wearable/pets))
					w.quality = min(round(w.quality * 10, 1), MAX_PET_LEVEL)

	if(version < 4)
		var/turf/lastLoc
		var/amount = 0
		for(var/turf/t in map.AllTurfs())
			for(var/obj/items/artifact/a in t)
				amount += a.stack
				a.loc = null
				lastLoc = t
			for(var/obj/items/wearable/invisibility_cloak/c in t)
				c.loc = null

		if(amount)
			var/obj/items/artifact/a = new (lastLoc)
			a.stack = amount
			a.UpdateDisplay()

	if(version < 5)
		for(var/turf/t in map.AllTurfs())

			for(var/obj/items/reputation/r in t)
				r.loc = null

			for(var/obj/items/wearable/w in t)
				if(istype(w, /obj/items/wearable/orb) || istype(w, /obj/items/wearable/title) || istype(w, /obj/items/wearable/magic_eye))
					w.loc = null
				else
					if(w.quality > 0)
						w.quality = 0
						w.bonus &= ~3

						var/list/split = splittext(w.name, " +")

						w.name = split[1]

					if(istype(w, /obj/items/wearable/wands))
						w:exp = 0
						w:projColor = null
					if(istype(w, /obj/items/wearable/pets))
						w:exp = 0
	if(version < 6)
		for(var/turf/t in map.AllTurfs())
			var/fly = t.flyblock
			var/turf/newTurf
			if(istype(t, /turf/floor))
				newTurf = new /turf/buildable/vault (t)
				if(fly) newTurf.flyblock = fly
	if(version < 7)
		for(var/turf/t in map.AllTurfs())

			for(var/obj/items/reputation/r in t)
				r.loc = null

			for(var/obj/items/wearable/w in t)
				if(istype(w, /obj/items/wearable/orb) || istype(w, /obj/items/wearable/title) || istype(w, /obj/items/wearable/magic_eye) || istype(w, /obj/items/wearable/sword) || istype(w, /obj/items/wearable/shield) || istype(w, /obj/items/wearable/ring))
					w.loc = null
				else
					if(w.quality > 0)
						w.quality = 0
						w.bonus &= ~3

						var/list/split = splittext(w.name, " +")

						w.name = split[1]

					if(istype(w, /obj/items/wearable/wands))
						w:exp = 0
						w:projColor = null
					if(istype(w, /obj/items/wearable/pets))
						w:exp = 0

	if(version < 8)
		for(var/turf/t in map.AllTurfs())
			for(var/obj/items/wearable/w in t)
				if(w.quality > 0 && w.bonus == (-1|3))
					w.quality = 0
					w.bonus &= ~3

					var/list/split = splittext(w.name, " +")
					w.name = split[1]

mob/GM/verb/UnloadMap()
	set category = "Custom Maps"
	if(!length(loadedMaps))
		src << errormsg("No maps are loaded.")
		return
	var/customMap/map = input("Unload which map?") as null|anything in loadedMaps
	if(!map) return
	if(map.swapmap.InUse())
		alert("That map currently has a player on it.")
		return
	map.swapmap.UnloadNoSave()
	global.loadedMaps.Remove(map)
	src << infomsg("Map name \"[map.name]\" has been unloaded.")
mob/GM/verb/DeleteMap()
	set category = "Custom Maps"
	if(!length(worldData.customMaps))
		src << errormsg("No maps currently exist.")
		return
	var/customMap/map = input("Delete which map?") as null|anything in worldData.customMaps
	if(!map) return
	if(map.swapmap && map.swapmap.InUse())
		alert("That map currently has a player on it.")
		return
	fdel("[swapmaps_directory]/map_custom_[ckey(map.name)].sav")
	loadedMaps -= map
	worldData.customMaps -= map
	Save_World()
	src << infomsg("Map name \"[map.name]\" has been deleted.")
mob/GM/verb/CopyMap()
	set category = "Custom Maps"
	var/customMap/newmap = new()
	var/newname = input("What do you name the new map? (Won't be shown to players)") as text|null
	if(!newname) return
	if(length(newname) > 19)
		alert("Keep it less than 20 characters.")
		return
	if(fexists("[swapmaps_directory]/map_custom_[ckey(newname)].sav"))
		alert("Map name already exists.")
		return
	newmap.name = newname
	var/customMap/copymap = input("Which map do you want to make a copy of?") as null|anything in worldData.customMaps
	if(!copymap) return
	var/result = fcopy("[swapmaps_directory]/map_custom_[ckey(copymap.name)].sav","[swapmaps_directory]/map_custom_[ckey(newname)].sav")
	if(result)
		src << infomsg("A copy of [copymap.name] has been created and named [newname]. It has not been loaded.")
		worldData.customMaps.Add(newmap)
		Save_World()
	else
		src << errormsg("Report error ID 3feOP to Murrawhip.")
mob/GM/verb/NewMap()
	set category = "Custom Maps"
	var/customMap/newmap = new()
	var/newname = input("What do you name the new map? (Won't be shown to players)") as text|null
	if(!newname) return
	if(length(newname) > 19)
		alert("Keep it less than 20 characters.")
		return
	if(fexists("[swapmaps_directory]/map_custom_[ckey(newname)].sav"))
		alert("Map name already exists.")
		return
	newmap.name = newname
	var/swapmap/swapmap = new("custom_[ckey(newname)]")
	swapmap.Save()
	newmap.swapmap = swapmap
	src.loc = locate(swapmap.x1, swapmap.y1, swapmap.z1)
	loadedMaps += newmap
	worldData.customMaps += newmap
	Save_World()
	src << infomsg("Your new map has been created. <b>Note that your map will never be saved automatically. You must use SaveMap.</b>")
proc/WhichcustomMap(mob/M)
	for(var/customMap/map in global.loadedMaps)
		if(M.z == map.swapmap.z1 &&\
			M.x >= map.swapmap.x1 &&\
			M.x <= map.swapmap.x2 &&\
			M.y >= map.swapmap.y1 &&\
			M.y <= map.swapmap.y2)
			return map
mob/GM/verb/SaveMap()
	set category = "Custom Maps"
	if(!length(loadedMaps))
		src << errormsg("No maps are currently loaded.")
		return
	var/customMap/map = input("Save which map?") as null|anything in loadedMaps
	if(!map) return
	if(map.swapmap.InUse())
		alert("That map currently has a player on it.")
		return

	if(!admin)
		for(var/turf/T in map.swapmap.AllTurfs())
			for(var/atom/movable/a in T)

				if(istype(a, /obj/items))
					a.Dispose()

				else if(istype(a, /mob/TalkNPC/EventMob))
					a.Dispose()

	map.swapmap.Save()
	src << infomsg("Map name \"[map.name]\" has been saved.")
proc
	AccessibleTurfs(turf/t)
		var/ret[] = block(locate(max(t.x-1,1),max(t.y-1,1),t.z),locate(min(t.x+1,world.maxx),min(t.y+1,world.maxy),t.z)) - t
		for(var/turf/i in ret)
			if(t.type != i.type)
				ret -= i
		return ret
mob/GM/verb/FloodFill(path as null|anything in typesof(/turf)|typesof(/area))
	set category = "Custom Maps"
	usr << errormsg("Note that the flood ignores objects including doors. It fills via the type of turf that you are standing on, and replaces it with the type you select.")
	if(!path)return
	if(!admin&&z < SWAPMAP_Z)
		src << errormsg("You can only use it inside swap maps.")
		return
	var/Region/r = new(usr.loc, /proc/AccessibleTurfs)

	var/mob/Player/p = usr
	for(var/T in r.contents)
		var/atom/a = new path (T)

		if(p.CreateVars)
			for(var/line in p.CreateVars)

				var/list/split = splittext(line, "=")

				if(split.len != 2 || !(split[1] in a.vars))
					p.CreateVars -= line
					continue

				if(findtext(split[2], "@"))
					var/ref = locate(copytext(split[2], 2))
					if(!ref)
						p.CreateVars -= line
						continue
					a.vars[split[1]] = ref
				else if(split[2] == "null")
					a.vars[split[1]] = null
				else
					var/n = text2num(split[2])
					if(isnum(n))
						a.vars[split[1]] = n
					else
						a.vars[split[1]] = split[2]

mob/GM/verb/LoadMap()
	set category = "Custom Maps"
	if(!length(worldData.customMaps))
		src << errormsg("No maps currently exist.")
		return
	var/customMap/map = input("Load which map?") as null|anything in worldData.customMaps
	if(!map) return
	if(map.swapmap)
		src << infomsg("\"[map.name]\" is already loaded. Teleporting there now.")
	else
		map.swapmap = SwapMaps_Load("custom_[ckey(map.name)]")
		src << infomsg("Loading \"[map.name]\". Teleporting there now.")
	src.loc = locate(map.swapmap.x1, map.swapmap.y1, map.swapmap.z1)
	global.loadedMaps.Remove(map)
	global.loadedMaps.Add(map)
var/tmp/list/customMap/loadedMaps = list()
customMap
	var/name = ""
	var/tmp/swapmap/swapmap = null
vault
	var/list/allowedpeople	//ckeys of people with permission to enter
	var/tmpl = "1"// used template, 1 by default
	var/version = 1
	proc/add_ckey_allowedpeople(ckey)
		if(!allowedpeople) allowedpeople = list()
		allowedpeople += ckey
	proc/remove_ckey_allowedpeople(ckey)
		allowedpeople -= ckey
		if(!allowedpeople.len) allowedpeople = null
	proc/name_ckey_assoc()
		//Returns an associated list in list[ckey] = name format
		var/list/result = list()
		for(var/V in allowedpeople)
			result[sql_get_name_from(V)] = V
		return result

mob/Player/proc/get_accessible_vaults()
	var/list/accessible_vaults = list()
	for(var/ckey in worldData.globalvaults)
		var/vault/V = worldData.globalvaults[ckey]
		if(src.ckey in V.allowedpeople)
			accessible_vaults += ckey
	return accessible_vaults

/*client/var/verifiedtelnet = 0
client/var/telnetchatmode = "say"
client/var/failedtries = 0
var/telnetdisabled = 0
client/Command(T)
	if(telnetdisabled) del(src)
	if(copytext(T,1,7) == "apples")
		mob.icon = 'telnet.dmi'
		verifiedtelnet = 1
		mob.name = copytext(T,8)
		usr << "Welcome, [mob.name]. Type help for a list of commands."
	else if(verifiedtelnet)
		if(copytext(T,1,5) == "help")
			usr << "ooc						Change to OOC mode"
			usr << "say						Change to Say mode"
			usr << "\[password\] \[name\]	Change to specified name"
			usr << "who						View who list"
		else if(copytext(T,1,4) == "ooc")
			telnetchatmode = "ooc"
		else if(copytext(T,1,4) == "say")
			telnetchatmode = "say"
		else if (copytext(T,1,4) == "who")
			for(var/client/C)
				usr << "[C.mob.name] ([C.key])"
		else
			if(telnetchatmode == "say")
				for(var/mob/M in hearers())
					if(!M.muff)
						M<<"<span style=\"font-size:2;\"><font color=red><b> <font color=red>[usr.name]</span> </b>:<font color=white> [T]"
					else
						if(rand(1,3)==1) M<<"<i>You hear an odd ringing sound.</i>"
			else
				world << "<b><span style=\"face:'Comic;\"><font color=green><font size=1>OOC></b><font face='Comic San MS'><font size=2><b><font color=blue>[mob.name]  :</span></b> <font color=white><font size=2> [T]"
	else
		usr << "You can sign in by typing the password followed by your name. (Seperated by a space)"
		failedtries++
		if(failedtries>4)del(src)*/


/mob/proc/GenerateNameOverlay(r,g,b,de=0)
	var/outline = "#000"
	//if(30*r+59*g+11*b > 7650) outline = "#000"
	var/n
	if(pname && !de)
		n = pname
	else if(istext(de))
		n = de
	else
		n = name

	namefont.QuickName(src, n, rgb(r,g,b), outline, top=1)

mob/test/verb/Tick_Lag(newnum as num)
	set category = "Server"
	world.tick_lag = newnum
mob/test/verb/Modify_Housepoints()
	set category = "Server"

	worldData.housepointsGSRH[1] = input("Select Gryffindor's housepoints:","Housepoints",worldData.housepointsGSRH[1]) as num
	worldData.housepointsGSRH[2] = input("Select Slytherin's housepoints:","Housepoints",worldData.housepointsGSRH[2]) as num
	worldData.housepointsGSRH[3] = input("Select Ravenclaw's housepoints:","Housepoints",worldData.housepointsGSRH[3]) as num
	worldData.housepointsGSRH[4] = input("Select Hufflepuff's housepoints:","Housepoints",worldData.housepointsGSRH[4]) as num
	Save_World()

proc/check(msg as text)
    msg = replacetext(msg, "\n", "")
    return html_encode(msg)

world
	hub = "TheWizardsChronicles.TWC"
	name = "The Wizards' Chronicles"
	turf=/turf/blankturf
	view="17x17"

world/proc/worldlooper()
	sleep(9000)
	if(radioEnabled)
		var/rndnum = rand(1,2)
		for(var/client/C)
			sleep(2)
			if(!C) continue
			if(winget(C,"radio_enabled","is-checked") == "false")
				switch(rndnum)
					if(1)
						C.mob << "<span style=\";\"><b><h3>TWC Radio is broadcasting. Click <a href='http://listen.hotdogradio.com/?ID=TWC'>here</a> to listen.</h3></b></span><br>"
					if(2)
						C.mob << "<span style=\";\"><b><h3>You should probably listen to TWC Radio! Click <a href='http://listen.hotdogradio.com/?ID=TWC'>here</a> to listen!</h3></b></span><br>"
	spawn()worldlooper()
mob
	create_character
		proc/name_filter(name)
			//Returns reason that name is not allowed, or null if it is accepted
			//Format of returned message is "Name is invalid as it [error]"
			//Also removes any non-allowed character
			var/list/allowed_characters = list(
				"a",
				"b",
				"c",
				"d",
				"e",
				"f",
				"g",
				"h",
				"i",
				"j",
				"k",
				"l",
				"m",
				"n",
				"o",
				"p",
				"q",
				"r",
				"s",
				"t",
				"u",
				"v",
				"w",
				"x",
				"y",
				"z",
				" ")
			var/list/unallowed_names = list(
				"robed figure",
				"masked figure",
				"deatheater",
				"auror",
				"harry",
				"potter",
				"albus",
				"malfoy",
				"snape",
				"hermoine",
				"voldemort",
				"dumbledore",
				"riddle",
				"potter",
				"granger",
				"malfoy",
				"weasley",
				"lestrange",
				"sirius",
				"riddle",
				"lestrange",
				"black",
				"marvello")
			var/list/foundinvalids = ""
			alert(length(name))
			for(var/i=1;i<length(name)+1;i++)
				//Checks each character to see if it's a valid character - informs the user to remove it
				if(! (lowertext(copytext(name,i,i+1)) in allowed_characters))
					//Invalid character
					if(length(foundinvalids))
						foundinvalids += ", [copytext(name,i,i+1)]"
					else
						foundinvalids += "[copytext(name,i,i+1)]"
			if(foundinvalids)
				return "contains the following invalid characters, [foundinvalids]"
			if(length(name) < 3)
				return "is less than 3 characters long"
			else if(length(name) > 16)
				return "is more than 16 characters long"
			for(var/unallowed_name in unallowed_names)
				if(findtext(name, unallowed_name))
					return "contains \"[unallowed_name]\""
		Login()
			var/mob/Player/character=new()
			//character.savefileversion = currentsavefilversion
			character.save_loaded = 1
			var/desiredname = input("What would you like to name your Harry Potter: The Wizards' Chronicles character? Keep in mind that you cannot use a popular name from the Harry Potter franchise, nor numbers or special characters.")
			var/passfilter = name_filter(desiredname)
			while(passfilter)
				alert("Your desired name is not allowed as it [passfilter].")
				desiredname = input("Please select a name that does not use a popular name from the Harry Potter franchise, nor numbers or special characters.")
				passfilter = name_filter(desiredname)
			var/charname = desiredname
			charname=copytext(charname,1,24/*the 20 is max name length*/)
			charname = addtext(uppertext(copytext(charname,1,2)),copytext(charname,2,length(charname)+1))
			character.name="[html_encode(charname)]"
			switch(input(src,"You are allowed to choose a House.","House Selection") in list ("Male Gryffindor","Female Gryffindor","Male Slytherin","Female Slytherin","Male Ravenclaw","Female Ravenclaw","Male Hufflepuff","Female Hufflepuff"))
				if("Male Gryffindor")
					character.verbs += /mob/GM/verb/Gryffindor_Chat
					character.House="Gryffindor"
					character.Gender="Male"
					character.icon='MaleGryffindor.dmi'
				//	character<<"<font color=red><font size=3>You are a Gryffindor. Do NOT tell anyone in another house your Common Room Password! The password to the Gryffindor Common Room is, <font color=blue>Fortuna"
				if("Female Gryffindor")
					character.House="Gryffindor"
					character.Gender="Female"
					character.verbs += /mob/GM/verb/Gryffindor_Chat
					character.icon='FemaleGryffindor.dmi'
				//	character<<"<font color=red><font size=3>You are a Gryffindor. Do NOT tell anyone in another house your Common Room Password! The password to the Gryffindor Common Room is, <font color=blue>Fortuna"
				if("Male Slytherin")
					character.House="Slytherin"
					character.Gender="Male"
					character.verbs += /mob/GM/verb/Slytherin_Chat
					character.icon='MaleSlytherin.dmi'
				//	character<<"<font size=3><font color=red>You are a Slytherin. Do NOT tell anyone in another house your Common Room Password! The password to the Slytherin Common Room is, <font color=blue>Kedavra"
				if("Female Slytherin")
					character.House="Slytherin"
					character.Gender="Female"
					character.verbs += /mob/GM/verb/Slytherin_Chat
					character.icon='FemaleSlytherin.dmi'
				if("Male Ravenclaw")
					character.House="Ravenclaw"
					character.Gender="Male"
					character.verbs += /mob/GM/verb/Ravenclaw_Chat
					character.icon='MaleRavenclaw.dmi'
				if("Female Ravenclaw")
					character.House="Ravenclaw"
					character.Gender="Female"
					character.verbs += /mob/GM/verb/Ravenclaw_Chat
					character.icon='FemaleRavenclaw.dmi'
				if("Male Hufflepuff")
					character.House="Hufflepuff"
					character.Gender="Male"
					character.verbs += /mob/GM/verb/Hufflepuff_Chat
					character.icon='MaleHufflepuff.dmi'
				if("Female Hufflepuff")
					character.House="Hufflepuff"
					character.Gender="Female"
					character.verbs += /mob/GM/verb/Hufflepuff_Chat
					character.icon='FemaleHufflepuff.dmi'
				//	character<<"<span style=\"font-size:3;\"><font color=red>You are now a Hufflepuff. Common Room password is <font size=3><font color=red>Maroon</span><p><b>Dont Tell Anyone Outside of Your House or you will be expelled."

			character.Rank="Player"
			character.baseicon = character.icon
			character.Year="1st Year"
			if(character.Gender=="Female")
				character.gender = FEMALE
			else if(character.Gender=="Male")
				character.gender = MALE

			src<<"<b><span style=\"font-size:2;color:#3636F5;\">Welcome to Harry Potter: The Wizards Chronicles</span> <u><a href='https://github.com/DuncanFairley/TWC/commits/master'>Version [VERSION].[SUB_VERSION]</a></u></b> <br>Join Discord <a href=\"https://discord.gg/8wTeMWdCVF\">here.</a>"
			src<<"<b>You are in the entrance to Diagon Alley.</b>"
			src<<"<b><u>Ollivander has a wand for you. Go up, and the first door on your right is the entrance to Ollivander's wand store.</u></b>"
		//	src<<"<h3>For a full player guide, visit http://guide.wizardschronicles.com.</h3>"

			if(!worldData.loggedIn)
				worldData.loggedIn = list()

			if(client.connection == "web")
				worldData.loggedIn[client.address] = client.ckey
			else
				worldData.loggedIn[client.computer_id] = client.ckey

			worldData.loggedIn[client.ckey] = 1

			var/oldmob = src
			src.client.mob = character
			var/obj/items/money/gold/g = new (character)
			g.UpdateDisplay()

			var/obj/o = locate("@DiagonAlley")
			character.loc = o.loc
			character.verbs += /mob/Spells/verb/Inflamari
			character.Fire  = new("Fire")
			character.Earth = new("Earth")
			character.Water = new("Water")
			character.Ghost = new("Ghost")
			character.Gathering = new("Gathering")
			character.Taming = new("Taming")
			character.Alchemy = new("Alchemy")
			character.Slayer = new("Slayer")
			character.Summoning = new("Summoning")
			character.Spellcrafting = new("Spellcrafting")
			character.TreasureHunting = new("Treasure Hunting")
			character.hpBar = new(character)
			character.InitMouseHelper()

			for(var/mob/Player/p in Players)
				if(p.Gm)
					p << "<span style=\"font-size:2; color:#C0C0C0;\"><b><i>[character][character.refererckey==p.client.ckey ? "(referral)" : ""] ([character.client.address])([character.ckey])([character.client.connection == "web" ? "webclient" : "dreamseeker"]) logged in.</i></b></span>"
				else
					p << "<span style=\"font-size:2; color:#C0C0C0;\"><b><i>[character][character.refererckey==p.client.ckey ? "(referral)" : ""] logged in.</i></b></span>"

			character.SendDiscord("logged in (new)")

			if(character.client.tmpInterface)
				character.Interface = character.client.tmpInterface
				character.Interface.Init(character)
			character.startQuest("Tutorial: The Wand Maker")
			character.buildBackpack()
			src = null
			sql_check_for_referral(character)
			del(oldmob)
mob/var/tmp
	clothDmg = 0
	clothDef = 0
	loginProtection = 0
mob/Player

	proc
		addNameTag()
			underlays = list()
			switch(House)
				if("Hufflepuff")
					GenerateNameOverlay(242,228,22)
				if("Slytherin")
					GenerateNameOverlay(41,232,23)
				if("Gryffindor")
					GenerateNameOverlay(240,81,81)
				if("Ravenclaw")
					GenerateNameOverlay(13,116,219)
				if("Ministry")
					GenerateNameOverlay(255,255,255)

	Login()
		loginProtection = 1

		if(client.byond_version <= 512)
			src << errormsg("BYOND version 513 is out, please always update to the latest stable version.")
		if(client.byond_version < world.byond_version)
			src << errormsg("Your installed BYOND version is older than the one the game is using, please update to BYOND version [world.byond_version] or higher. You can continue to play but unpredicted errors may occur.")

		spawn(10)
			if(!save_loaded)
				src << errormsg("Your save didn't load properly, please talk to a GM as fast as possible. You also can't save right now so your save will remain intact without losing anything.")
				for(var/mob/Player/p in Players)
					if(p.Gm)
						p << errormsg("[src.ckey] - [src.name] encountered a save problem, please check it out.")

			sleep(20)
			loginProtection = 0

		if(Gender=="Female")
			gender = FEMALE
		else if(Gender=="Male")
			gender = MALE
	//	Resort_Stacking_Inv()
		buildBackpack()
		mouse_drag_pointer = MOUSE_DRAG_POINTER
		if(client.connection == "web")
			winset(src, "mapwindow.map", "icon-size=32")

		for(var/hudobj/login/l in client.screen)
			client.screen -= l

		if(client.browser_loaded)
			src << output(House, "browser1:Login")

		client.eye = src
		client.perspective = MOB_PERSPECTIVE

		invisibility = 0
		alpha = 255
		sight &= ~(SEE_SELF|BLIND)

		if(key == "Murrawhip" || key == "Rotem12" || key == "Juxnist" || key == world.host)
			verbs+=typesof(/mob/GM/verb/)
			verbs+=typesof(/mob/Spells/verb/)
			verbs+=typesof(/mob/test/verb/)
			verbs+=typesof(/mob/Quidditch/verb)
			Gm=1
			draganddrop=1
			shortapparate=1
			admin=1
		else if(Gm && !(ckey in worldData.Gms))
			spawn()
				removeStaff()

		//spawn()world.Export("http://www.wizardschronicles.com/player_stats_process.php?playername=[name]&level=[level]&house=[House]&rank=[Rank]&login=1&ckey=[ckey]&ip_address=[client.address]")
		timelog = world.realtime
		if(timerMute > 0)
			src << "<u>You're muted for [timerMute] minute[timerMute==1 ? "" : "s"].</u>"
			mute_countdown()
		if(timerDet > 0)
			src << "<u>You're in detention for [timerDet] minute[timerDet==1 ? "" : "s"].</u>"
			detention_countdown()
		addNameTag()
		Players.Add(src)
		bubblesort_atom_name(Players)

		if(worldData.housecupwinner)
			src << "<b><span style=\"color:#CF21C0;\">[worldData.housecupwinner] is the House Cup winner for this month. They receive +50% drop rate/gold/XP from monster kills.</span></b>"
		if(classdest)
			src << announcemsg("[curClass] class is starting. Click <a href=\"?src=\ref[src];action=class_path;latejoiner=true\">here</a> for directions.")

		if(worldData.expModifier > 1 || worldData.DropRateModifier > 1 || worldData.expBookModifier > 1)

			src << infomsg("The world is enjoying the following bonuses:")
			if(worldData.expBookModifier > 1)
				var/drop = (worldData.expBookModifier - 1) * 100
				src << infomsg("[drop]% experience from books.")
			if(worldData.expModifier > 1)
				var/exp  = (worldData.expModifier - 1)      * 100
				src << infomsg("[exp]% experience bonus from monsters.")
			if(worldData.DropRateModifier > 1)
				var/drop = (worldData.DropRateModifier - 1) * 100
				src << infomsg("[drop]% drop rate bonus.")

		if(client.tmpInterface)
			Interface = client.tmpInterface
			Interface.Init(src)
		isDJ(src)
		checkMail()

		spawn()
			var/mob/multikey
			for(var/mob/Player/p in Players)
				if(client == p.client) continue
				if(client.connection == "web")
					if(p.client.address == client.address || p.client.computer_id == client.computer_id)
						multikey = p
						break
				else
					if(p.client.computer_id == client.computer_id)
						multikey = p
						break

			if(multikey)
				for(var/mob/Player/p in Players)
					if(p.Gm)
						p << "<h2>Multikeyers: [multikey](key: [multikey.key] | ip: [multikey.client.address]) & just logged in: [src] (key: [key] | ip: [client.address]) ([client.connection == "web" ? "webclient" : "dreamseeker"])</h2>"

			buildActionBar()
			if(istype(src.loc.loc,/area/arenas) && !rankedArena)
				src.loc = locate(50,22,15)
			unreadmessagelooper()
			sql_update_ckey_in_table(src)
			sql_update_multikey(src)
			src.client.update_individual()
			if(global.clanwars)
				src.ClanwarsInfo()

			if(!worldData.playersData) worldData.playersData = list()
			var/PlayerData/data = worldData.playersData[ckey]
			if(data && data.guild)
				var/guild/g = worldData.guilds[data.guild]

				if(!g || !(ckey in g.members))
					data.guild = null
					verbs -= /mob/GM/verb/Guild_Chat
				else
					verbs += /mob/GM/verb/Guild_Chat
					guild = data.guild

					src << infomsg(g.motd)

			var/obj/items/wearable/masks/robe/deatheater_robes/de = locate() in src
			var/obj/items/wearable/masks/robe/auror_robes/auror = locate() in src
			if(guild == worldData.majorPeace && worldData.majorPeace)

				if(!auror)
					auror = new(src)
					src << infomsg("You were given auror robes.")
				if(de) de.Dispose()

			else if(guild == worldData.majorChaos && worldData.majorChaos)

				if(!de)
					de = new(src)
					src << infomsg("You were given deatheater robes.")

				if(auror) auror.Dispose()
			else
				if(auror) auror.Dispose()
				if(de) de.Dispose()

			BaseIcon()

			LoginReward()
			secretSanta()
			if(worldData.eventPrize) EventReward()
			BYONDMemberReward()

			DisplayPets()
			InitMouseHelper()

			if(worldData.passives)
				if(!passives) passives = list()

				for(var/e in worldData.passives)
					src << infomsg("You have the power of [e].")
					passives[e] += 1


			hpBar = new(src)
			src.ApplyOverlays(0)
			loc.loc.Enter(src, src.loc)
			loc.loc.Entered(src, src.loc)
			if(MP < MMP)
				MPRegen()


	proc/ApplyOverlays(ignoreBonus = 1)
		src.overlays = list()

		if(Lwearing && !trnsed && !noOverlays)

			if(ignoreBonus)
				if(!trnsed && !noOverlays)
					for(var/obj/items/wearable/W in Lwearing)
						if(W.showoverlay)
							var/image/o = new
							o.icon = W.icon
							o.color = W.color
							o.layer = W.wear_layer

							overlays += o
			else
				var/mob/Player/var/list/tmpwearing = Lwearing
				Lwearing = list()

				for(var/obj/items/wearable/W in tmpwearing)
					var/b = W.bonus
					var/obj/items/crystal/s = W.socket
					W.bonus = -1
					W.socket = null
					W.Equip(src,1)
					W.socket = s
					W.bonus = b

					W.calcBonus(src, 0)
					if(s)
						clothDmg   += s.Dmg
						clothDef   += s.Def
						dropRate   += s.luck
						monsterDmg += s.monsterDmg
						monsterDef += s.monsterDef

				resetMaxHP()

		if(src.away)
			src.ApplyAFKOverlay()

	verb
		Say(t as text)

			if(!mute)
				if(silence)
					src << "Your tongue is stuck to the roof of your mouth. You can't speak."
				else
					if(spam<=5 || Gm)
						if(t)
							t=check(t)//run the text through the cleaner
							t = copytext(t,1,500)
							if(copytext(t,1,5)=="\[me]")
								hearers(client.view)<<"<i>[usr] [copytext(t,5)]</i>"
							else if(copytext(t,1,4)=="\[w]")
								if(prevname)
									range(1)<<"<span style=\"font-size:2; color:red;\"><b>[usr] whispers: <i>[copytext(t,4)]</i></b></span>"
								else
									range(1)<<"<span style=\"font-size:2; color:red;\"><b>[Tag][usr] whispers: <i>[copytext(t,4)]</i></b></span>"

							else
								var/silent = FALSE
								if(cmptext(copytext(t, 1, 18),"restricto maxima "))
									if(src.Gm)
										hearers()<<"[usr] encases the area within a magical barrier."
										var/value = copytext(t, 18, 19)
										if(value == "") value = 5
										else if(text2num(value) < 1) value = 5
										else value = text2num(value)
										for(var/turf/T in (oview(value) - oview(value-1)))
											if(T.specialtype & SHIELD) continue
											var/shield = /obj/Force_Field
											T.FlickState("m-black",8,'Effects.dmi')
											T.overlays += shield
											T.density=1
											T.invisibility=0
											T.specialtype |= SHIELD
								else if(cmptext(copytext(t, 1, 10),"eat slugs"))
									if(/mob/Spells/verb/Eat_Slugs in verbs)
										silent = usr:Eat_Slugs(copytext(t, 11))

								if(!silent)
									for(var/mob/Player/M in hearers(client.view))
										if(!M.muff)
											if(prevname)
												M<<"<span style=\"font-size:2; color:red;\"><b>[usr]</b></span> : <span style=\"color:white\">[t]</span>"
											else
												M<<"<span style=\"font-size:2; color:red;\"><b>[Tag][usr][GMTag]</b></span> : <span style=\"color:white\">[t]</span>"
										else
											if(rand(1,3)==1) M<<"<i>You hear an odd ringing sound.</i>"


							if(prevname)
								chatlog << "<span style=\"color:red;\"><b>[prevname] (ROBED)</b></span><span style=\"color:white;\"> says '[t]'</span><br>"
							else
								chatlog << "<span style=\"color:red;\"><b>[src]</b></span><span style=\"color:white;\"> says '[t]'</span><br>"

							if(t == worldData.ministrypw)
								if(istype(usr.loc,/turf/gotoministry))
									if(worldData.ministrybanlist && (usr.name in worldData.ministrybanlist))
										view(src) << "<b>Toilet</b>: <i>The Ministry of Magic is not currently open to you. Sorry!</i>"
									else
										oviewers() << "[usr] disappears."
										if(usr.flying)
											usr.flying = 0
											usr.density = 1
											usr << "You've been knocked off your broom."
										var/atom/a = locate("ministryentrance")
										var/turf/dest = isturf(a) ? a : a.loc
										for(var/mob/Player/p in Players)
											if(p.client.eye == usr && p != usr && p.Interface.SetDarknessColor(TELENDEVOUR_COLOR))
												p << errormsg("Your Telendevour wears off.")
												p.client.eye = p
										usr.loc = dest
							if(House == "Ministry")
								switch(lowertext(t))
									if("change ministry password")
										if(key=="Murrawhip")
											var/input = input("New password?", "Ministry Password", worldData.ministrypw) as null|text
											if(!input) return
											else
												worldData.ministrypw = input
											hearers() << "<b><span style=\"color:red;\">Password Changed</span></b>"
									if("unlock office")
										var/obj/brick2door/door = locate("ministryoffice")
										if(!door)return
										door.door = 1
										view(door) << "<i>You hear the door unlock.</i>"
									if("lock office")
										var/obj/brick2door/door = locate("ministryoffice")
										if(!door)return
										door.door = 0
										view(door) << "<i>You hear the door lock.</i>"
							switch(lowertext(t))
								if("reception")
									if(z == 21)
										var/dest = locate("@Reception")

										FlickState("Orb",12,'Effects.dmi')
										Transfer(dest)

								if("colloportus")
									if(src.Gm)
										sleep(20)
										hearers()<<"<span style=\"font-size:1;\">[usr] has locked the door.</span>"
										if(classdest)
											usr << errormsg("Friendly reminder: Class guidance is still on.")
										for(var/obj/Hogwarts_Door/T in oview(client.view))
											if(!admin && T.vaultOwner) continue
											T.door=0
								if("alohomora")
									if(src.Gm)
										sleep(20)
										view(client.view)<<"<span style=\"font-size:1;\">[usr] has unlocked the door.</span>"
										for(var/obj/Hogwarts_Door/T in oview(client.view))
											if(!admin && T.vaultOwner) continue
											T.FlickState("alohomora",20,'Effects.dmi')
											T.door=1
								if("quillis")
									if(src.Gm)
										for(var/obj/Desk/T in view(client.view))
											var/scroll = /obj/items/scroll
											T.FlickState("m-black",8,'Effects.dmi')
											new scroll(T.loc)
										hearers()<<"[usr] flicks \his wand, causing scrolls to appear on the desks."
								if("quillis deletio")
									if(src.Gm)
										for(var/obj/items/scroll/T in oview(client.view))
											T.FlickState("m-black",8,'Effects.dmi')
											del T
										hearers()<<"[usr] flicks \his wand, causing scrolls to vanish"

								if("disperse")
									if(src.Gm)
										for(var/turf/T in view(client.view))
											if(T.specialtype & SHIELD)
												T.specialtype -= SHIELD
												T.FlickState("m-black",8,'Effects.dmi')
												spawn(9)
													var/shield = /obj/Force_Field
													T.overlays -= shield
													T.density=initial(T.density)
									if(/mob/Spells/verb/Disperse in verbs)
										usr:Disperse()

								if("save me")
									src.Save()
									hearers()<<"[src] has been saved."
								if("save world")
									if(usr.admin)
										for(var/client/C)
											if(isplayer(C.mob)) C.mob.Save()
											//C<<"You've been automatically saved."
											sleep(1)
										Save_World()
										src<<infomsg("The world has been saved.")
								if("clear admin log")
									if(src.admin)
										src<<infomsg("The Admin logs have been deleted.")
										fdel("Logs/Adminlog.html")
								if("clear gold log")
									if(src.admin)
										src<<infomsg("The Gold logs have been deleted.")
										fdel("Logs/Goldlog.html")
								if("clear kill log")
									if(src.admin)
										src<<infomsg("The Kill logs have been deleted.")
										fdel("Logs/kill_log.html")
								if("clear event log")
									if(src.admin)
										src<<infomsg("The Event logs have been deleted.")
										fdel("Logs/event_log.html")
								if("clear class log")
									if(src.admin)
										src<<infomsg("The Class logs have been deleted.")
										fdel("Logs/classlog.html")
								if("clear radio log")
									if(src.admin)
										src<<infomsg("The Radio logs have been deleted.")
										fdel("Logs/DJlog.html")
								if("clear log")
									if(src.admin)
										src<<infomsg("The Chat logs have been deleted.")
										fdel("Logs/chatlog.html")
								if("afk check")
									if(Gm)
										if(alert("AFK Check was last used about [round((world.realtime - worldData.lastusedAFKCheck) / 10 / 60)] minutes ago. Do you want to use it now?",,"Yes","No") == "Yes")
											src<<infomsg("Checking for AFK trainers...")
											for(var/mob/A in world)
												if(A.key&&A.Gm)
													A << infomsg("[src] uses AFK Check")
											AFK_Train_Scan()
											src << infomsg("AFK Check Complete.")
								if("disable ooc")
									if(src.Gm)
										OOCMute=1
										src << infomsg("OOC has been disabled.")
								if("enable ooc")
									if(src.Gm)
										src << infomsg("OOC has been enabled.")
										OOCMute = 0
								if("access admin log files")
									if(src.admin==1)
										src <<browse(file("Logs/Adminlog.html"))
										src<<infomsg("Access Granted.")
								if("restricto")
									if(Gm)
										hearers()<<"[usr] encases \himself within a magical barrier."
										for(var/turf/T in view(1))
											if(T.specialtype & SHIELD) continue
											var/shield = /obj/Force_Field
											T.FlickState("m-black",8,'Effects.dmi')
											T.overlays += shield
											T.density=1
											T.invisibility=0
											T.specialtype -= SHIELD
							if(!Gm)
								spam++
								spawn(30)
									spam--
			else
				usr << errormsg("You can't send messages while you are muted.")
		OOC(T as text)
			set desc = "Speak on OOC"
			if(!listenooc)
				src << "Your OOC is turned off."
				return
			if(mute)
				src << errormsg("You can't send messages while you are muted.")
				return
			if(OOCMute)
				usr<<"Access to the OOC Chat System has been restricted by a Staff Member."
			else
				if(spam<=5)
					if(!MuteOOC)
						if(T)
							T = copytext(T,1,300)
							T = check(T)
							for(var/mob/Player/p in Players)
								if(p.listenooc)
									if(prevname)
										p << "<b><a style=\"font-size:1;font-family:'Comic Sans MS';text-decoration:none;color:green;\" href=\"?src=\ref[p];action=pm_reply;replynametext=[formatName(src)]\">OOC></a></b><b><span style=\"font-size:2; color:#3636F5;\">[prevname][GMTag]:</span></b> <span style=\"color:white; font-size:2;\"> [T]</span>"
									else
										p << "<b><a style=\"font-size:1;font-family:'Comic Sans MS';text-decoration:none;color:green;\" href=\"?src=\ref[p];action=pm_reply;replynametext=[formatName(src)]\">OOC></a></b><b><span style=\"font-size:2; color:#3636F5;\">[src][GMTag]:</span></b> <span style=\"color:white; font-size:2;\"> [T]</span>"

							usr:SendDiscord(T)

							if(prevname)
								chatlog << "<span style=\"color:blue;\"><b>[prevname] (ROBED)</b></span><span style=\"color:green;\"> OOC's '[T]'</span>"+"<br>"//This is what it adds to the log!
							else
								chatlog << "<span style=\"color:blue;\"><b>[src]</b></span><span style=\"color:green;\"> OOC's '[T]'</span>"+"<br>"//This is what it adds to the log!
							spam++
							spawn(30)
								spam--
							if(findtext(T, "://"))
								spam++
								spawn(40)
									spam--
						else
							src<<"Please enter something."
					else
						src << errormsg("OOC is muted.")
				else
					spam+=0.1
					spawn(300)
						spam-=0.1
					if(spam > 7)
						Auto_Mute(15, "spammed OOC")

		Listen_OOC()
			set name = ""
			listenooc = !listenooc
			src << "You are now [listenooc ? "listening" : "<b>not</b> listening"] to the OOC channel."
		Listen_Housechat()
			set name = ""
			listenhousechat = !listenhousechat
			src << "You are now [listenhousechat ? "listening" : "<b>not</b> listening"] to your house channel."

		Who()
			var/online=0
			for(var/mob/Player/M in Players)
				online++
				src << "\icon[wholist[M.House ? M.House : "Empty"]] \
						<b><span style=\"color:blue;\">Name:</span></b> [M.prevname ? M.prevname : M.name][M.status] \
						<b><span style=\"color:red;\">Key:</span></b> [M.key] \
						<b><span style=\"color:purple;\">Level:</span></b> [M.level >= lvlcap ? "[getSkillGroup(M.ckey)] \icon[M.getRankIcon()]" : M.level] \
						<b><span style=\"color:green;\">Rank:</span></b> [M.Rank == "Player" ? M.Year : M.Rank]"

			usr << "[online] players online."
			var/logginginmobs = ""
			for(var/client/C)
				if(C.mob && !(C.mob in Players))
					if(logginginmobs == "")
						logginginmobs += "[C.key]"
					else
						logginginmobs += ", [C.key]"
			if(logginginmobs != "")
				usr << "Logging in: [logginginmobs]."


		AFK()
			if(!usr.away)
				usr.away = 1
				usr.here=usr.status
				usr.status=" (AFK)"
	//			Players<<"~ <span style=\"color:red;\">[usr]</span> is <u>AFK</u> ~"
				ApplyAFKOverlay()
			else
				usr.away = 0
				usr.status=usr.here
	//			Players<<"<span style=\"color:red;\">[usr]</span> is no longer AFK."
				RemoveAFKOverlay()

mob/Player
	proc/ApplyAFKOverlay()
		RemoveAFKOverlay()

		if(!away) return

		if(locate(/obj/items/wearable/afk/pimp_ring) in Lwearing)
			if(House=="Slytherin")
				overlays += image('AFK.dmi', icon_state = "S")
			else if(House=="Gryffindor")
				overlays += image('AFK.dmi', icon_state = "G")
			else if(src.House=="Hufflepuff")
				overlays += image('AFK.dmi', icon_state = "H")
			else
				overlays += image('AFK.dmi', icon_state = "R")
		else if(locate(/obj/items/wearable/afk/hot_chocolate) in Lwearing)
			overlays+=image('AFK.dmi',icon_state="AFK2")
		else if(locate(/obj/items/wearable/afk/heart_ring) in Lwearing)
			overlays+=image('AFK.dmi',icon_state="AFK3")
		else
			overlays+=image('AFK.dmi',icon_state="AFK1")

mob
	proc/RemoveAFKOverlay()
		overlays-=image('AFK.dmi',icon_state="AFK1")
		overlays-=image('AFK.dmi',icon_state="AFK2")
		overlays-=image('AFK.dmi',icon_state="AFK3")
		overlays-=image('AFK.dmi',icon_state="S")
		overlays-=image('AFK.dmi',icon_state="G")
		overlays-=image('AFK.dmi',icon_state="H")
		overlays-=image('AFK.dmi',icon_state="R")


mob/Player
	var/tmp
		obj/favorites/objFavorites = new
		list/mousehelper = list()
		showItems = 0

		backpackOpen = 0

	proc/InitMouseHelper()

		mousehelper["Fire"]            = new /obj/mousehover/Fire
		mousehelper["Water"]           = new /obj/mousehover/Water
		mousehelper["Earth"]           = new /obj/mousehover/Earth
		mousehelper["Ghost"]           = new /obj/mousehover/Ghost
		mousehelper["Taming"]          = new /obj/mousehover/Taming
		mousehelper["Gathering"]       = new /obj/mousehover/Gathering
		mousehelper["Animagus"]        = new /obj/mousehover/Animagus
		mousehelper["Alchemy"]         = new /obj/mousehover/Alchemy
		mousehelper["Summoning"]       = new /obj/mousehover/Summoning
		mousehelper["Spellcrafting"]   = new /obj/mousehover/Spellcrafting
		mousehelper["TreasureHunting"] = new /obj/mousehover/Treasure_Hunting
		mousehelper["Slayer"]          = new /obj/mousehover/Slayer


	Stat()
		if(statpanel("Character"))
			stat("Name:",src.name)
			stat("Year:",src.Year)
			stat("House:",src.House)
			stat("Level:",src.level)
			stat("HP:","[src.HP]/[src.MHP]")
			if(Shield > 0)
				stat("Shield:","[Shield]")
			stat("MP:","[src.MP]/[src.MMP]")
			stat("Damage:","[Dmg] ([Dmg - (level + 4)])")
			stat("Defense:","[Def] ([(Def - (level + 4))/3])")
			stat("Cooldown Reduction:","[round(1000 - (cooldownModifier+extraCDR)*1000, 1)/10]%")
			stat("MP Regeneration:", "[50 + round(level/10)*2 + MPRegen]")
			if(level >= lvlcap && rankLevel)
				var/percent = round((rankLevel.exp / rankLevel.maxExp) * 100)
				stat("Experience Rank: ", "[rankLevel.level]   Exp: [comma(rankLevel.exp)]/[comma(rankLevel.maxExp)] ([percent]%)")
				stat("\icon[getRankIcon()]")
			else
				var/percent = round((Exp / Mexp) * 100)
				stat("EXP:", "[comma(src.Exp)]/[comma(src.Mexp)] ([percent]%)")
			if(wand && (wand.exp + wand.quality > 0))
				var/maxExp = MAX_WAND_EXP(wand)
				var/percent = round((wand.exp / maxExp) * 100)
				stat("Wand:", "Level: [wand.quality]   Exp: [comma(wand.exp)]/[comma(maxExp)] ([percent]%)")
			if(pet)
				if(pet.item.exp + pet.item.quality > 0)
					var/maxExp = MAX_PET_EXP(pet.item)
					var/percent = round((pet.item.exp / maxExp) * 100)
					stat("[pet.name]:", "Level: [pet.item.quality]   Exp: [comma(pet.item.exp)]/[comma(maxExp)] ([percent]%)")

					percent = min(round(pet.stepCount / 10, 1), 100)
					stat("",            "Happiness: [percent]%")
				else
					var/percent = min(round(pet.stepCount / 10, 1), 100)
					stat("[pet.name]:", "Happiness: [percent]%")
			stat("Stat points:", StatPoints)
			stat("Spell points:", spellpoints)
			stat("Threads:", threads)
			if(learning)
				stat("Learning:", learning.name)
				stat("Uses required:", learning.uses)

		if(statpanel("Skills"))
			if(Fire)
				var/percent = round((Fire.exp / Fire.maxExp) * 100)
				var/obj/o = mousehelper["Fire"]
				o.name = "Level: [Fire.level]   Exp: [comma(Fire.exp)]/[comma(Fire.maxExp)] ([percent]%)"
			if(Earth)
				var/percent = round((Earth.exp / Earth.maxExp) * 100)
				var/obj/o = mousehelper["Earth"]
				o.name = "Level: [Earth.level]   Exp: [comma(Earth.exp)]/[comma(Earth.maxExp)] ([percent]%)"
			if(Water)
				var/percent = round((Water.exp / Water.maxExp) * 100)
				var/obj/o = mousehelper["Water"]
				o.name = "Level: [Water.level]   Exp: [comma(Water.exp)]/[comma(Water.maxExp)] ([percent]%)"
			if(Ghost)
				var/percent = round((Ghost.exp / Ghost.maxExp) * 100)
				var/obj/o = mousehelper["Ghost"]
				o.name = "Level: [Ghost.level]   Exp: [comma(Ghost.exp)]/[comma(Ghost.maxExp)] ([percent]%)"
			if(animagusState && Animagus)
				var/percent = round((Animagus.exp / Animagus.maxExp) * 100)
				var/obj/o = mousehelper["Animagus"]
				o.name = "Level: [Animagus.level]   Exp: [comma(Animagus.exp)]/[comma(Animagus.maxExp)] ([percent]%)"
			if(Gathering)
				var/percent = round((Gathering.exp / Gathering.maxExp) * 100)
				var/obj/o = mousehelper["Gathering"]
				o.name = "Level: [Gathering.level]   Exp: [comma(Gathering.exp)]/[comma(Gathering.maxExp)] ([percent]%)"
			if(Taming)
				var/percent = round((Taming.exp / Taming.maxExp) * 100)
				var/obj/o = mousehelper["Taming"]
				o.name = "Level: [Taming.level]   Exp: [comma(Taming.exp)]/[comma(Taming.maxExp)] ([percent]%)"
			if(Alchemy)
				var/percent = round((Alchemy.exp / Alchemy.maxExp) * 100)
				var/obj/o = mousehelper["Alchemy"]
				o.name = "Level: [Alchemy.level]   Exp: [comma(Alchemy.exp)]/[comma(Alchemy.maxExp)] ([percent]%)"
			if(Slayer)
				var/percent = round((Slayer.exp / Slayer.maxExp) * 100)
				var/obj/o = mousehelper["Slayer"]
				o.name = "Level: [Slayer.level]   Exp: [comma(Slayer.exp)]/[comma(Slayer.maxExp)] ([percent]%)"
			if(Summoning)
				var/percent = round((Summoning.exp / Summoning.maxExp) * 100)
				var/obj/o = mousehelper["Summoning"]
				o.name = "Level: [Summoning.level]   Exp: [comma(Summoning.exp)]/[comma(Summoning.maxExp)] ([percent]%)"
			if(Spellcrafting)
				var/percent = round((Spellcrafting.exp / Spellcrafting.maxExp) * 100)
				var/obj/o = mousehelper["Spellcrafting"]
				o.name = "Level: [Spellcrafting.level]   Exp: [comma(Spellcrafting.exp)]/[comma(Spellcrafting.maxExp)] ([percent]%)"
			if(TreasureHunting)
				var/percent = round((TreasureHunting.exp / TreasureHunting.maxExp) * 100)
				var/obj/o = mousehelper["TreasureHunting"]
				o.name = "Level: [TreasureHunting.level]   Exp: [comma(TreasureHunting.exp)]/[comma(TreasureHunting.maxExp)] ([percent]%)"

			stat(mousehelper)

		if(statpanel("Mastery"))
			for(var/spellName in SpellUses)
				var/uses = SpellUses[spellName]
				stat("[spellName]:", "[getMasteryRank(uses)] ([num2text(uses, 8)])")

		if(statpanel("Info"))
			if(admin)
				stat("CPU:", world.cpu)
				stat("Date:", time2text(world.realtime, "DDD MMM DD hh:mm:ss YYYY"))
			stat("---House points---")
			stat("Gryffindor",worldData.housepointsGSRH[1])
			stat("Slytherin",worldData.housepointsGSRH[2])
			stat("Ravenclaw",worldData.housepointsGSRH[3])
			stat("Hufflepuff",worldData.housepointsGSRH[4])
			stat("","")

			if(worldData.passives)
				stat("Global Passives:","")
				stat(worldData.passives)

			if(worldData.currentEvents)
				stat("Current Events:","")
				for(var/RandomEvent/e in worldData.currentEvents)
					if(e.desc)
						stat("", "[e.name] - [e.desc]")
					else if(e.endTime)
						stat("", "[e.name] - [ticks2time(e.endTime - world.time)]")
					else
						stat("", e.name)
			if(worldData.currentArena)
				if(worldData.currentArena.roundtype == HOUSE_WARS)
					stat("Arena:")
					stat("Gryffindor",worldData.currentArena.teampoints["Gryffindor"])
					stat("Slytherin",worldData.currentArena.teampoints["Slytherin"])
					stat("Hufflepuff",worldData.currentArena.teampoints["Hufflepuff"])
					stat("Ravenclaw",worldData.currentArena.teampoints["Ravenclaw"])
				else if(worldData.currentArena.roundtype == FFA_WARS)
					stat("Arena: (Players Alive)")
					for(var/mob/M in worldData.currentArena.players)
						stat("-",M.name)
			if(worldData.currentMatches.arenas)
				stat("Matchmaking:", "(Click to spectate. Click again to stop.)")
				for(var/arena/a in worldData.currentMatches.arenas)
					stat(a.spectateObj)

		if(statpanel("Backpack"))
			if(!backpackOpen)
				backpackOpen = 1
				winset(src, "backpack", "is-visible=true")
		else
			if(backpackOpen)
				backpackOpen = 0
				winset(src, "backpack", "is-visible=false")

		if(showItems || contents.len > BACKPACK_ROWS * BACKPACK_COLS)
			if(statpanel("Items"))

				var/list/money = list()
		//		var/list/stacked
				var/list/other = list()

				for(var/obj/O in src.contents)
					if(istype(O, /obj/items/money))
						money += O
			//		else if(istype(O,/obj/stackobj))

			//			if(!stacked) stacked = list()
			//			stacked += O

					else
						if(Lfavorites && (O in Lfavorites)) continue

						other += O

			//			var/t
			//			if(O.useTypeStack == 0)
			//				t = O.type
			//			else if(O.useTypeStack == 1)
			//				t = O.parent_type
			//			else
			//				t = O.useTypeStack
			//			if(!src:stackobjects || !(src:stackobjects.Find(t))) //If there's NOT a stack object for this obj type, print it
			//				if(!other) other = list()
			//				other += O


				if(money)
					stat("Money:")
					stat(money)

				stat(objFavorites.isopen ? "-" : "+", objFavorites)
				if(objFavorites.isopen && Lfavorites)
					stat(Lfavorites)

				stat("Items:")
				if(other)
					stat(other)

	/*		if(stacked)
				stat("Click to expand stacked items.")
				for(var/obj/stackobj/s in stacked)
					stat("+", s)
					if(s.isopen)
						for(var/obj/B in s.contains)
							if(Lfavorites && (B in Lfavorites)) continue
							stat("-", B)*/
//		if(statpanel("Info"))
/*			stat("Name:",src.name)
			stat("Year:",src.Year)
			stat("House:",src.House)
			stat("Level:",src.level)
			stat("HP:","[src.HP]/[src.MHP]")
			stat("MP:","[src.MP]/[src.MMP]")
			stat("Damage:","[Dmg] ([Dmg - (level + 4)])")
			stat("Defense:","[Def] ([(Def - (level + 4))/3])")
			stat("Cooldown Reduction:","[round(1000 - cooldownModifier*1000, 1)/10]%")
			stat("MP Regeneration:", "[50 + round(level/10)*2 + MPRegen]")
			stat("","")

			if(Fire)
				var/percent = round((Fire.exp / Fire.maxExp) * 100)
				var/obj/o = mousehelper["Fire"]
				o.name = "Level: [Fire.level]   Exp: [comma(Fire.exp)]/[comma(Fire.maxExp)] ([percent]%)"
			if(Earth)
				var/percent = round((Earth.exp / Earth.maxExp) * 100)
				var/obj/o = mousehelper["Earth"]
				o.name = "Level: [Earth.level]   Exp: [comma(Earth.exp)]/[comma(Earth.maxExp)] ([percent]%)"
			if(Water)
				var/percent = round((Water.exp / Water.maxExp) * 100)
				var/obj/o = mousehelper["Water"]
				o.name = "Level: [Water.level]   Exp: [comma(Water.exp)]/[comma(Water.maxExp)] ([percent]%)"
			if(Ghost)
				var/percent = round((Ghost.exp / Ghost.maxExp) * 100)
				var/obj/o = mousehelper["Ghost"]
				o.name = "Level: [Ghost.level]   Exp: [comma(Ghost.exp)]/[comma(Ghost.maxExp)] ([percent]%)"
			if(animagusState && Animagus)
				var/percent = round((Animagus.exp / Animagus.maxExp) * 100)
				var/obj/o = mousehelper["Animagus"]
				o.name = "Level: [Animagus.level]   Exp: [comma(Animagus.exp)]/[comma(Animagus.maxExp)] ([percent]%)"
			if(Gathering)
				var/percent = round((Gathering.exp / Gathering.maxExp) * 100)
				var/obj/o = mousehelper["Gathering"]
				o.name = "Level: [Gathering.level]   Exp: [comma(Gathering.exp)]/[comma(Gathering.maxExp)] ([percent]%)"
			if(Taming)
				var/percent = round((Taming.exp / Taming.maxExp) * 100)
				var/obj/o = mousehelper["Taming"]
				o.name = "Level: [Taming.level]   Exp: [comma(Taming.exp)]/[comma(Taming.maxExp)] ([percent]%)"
			if(Alchemy)
				var/percent = round((Alchemy.exp / Alchemy.maxExp) * 100)
				var/obj/o = mousehelper["Alchemy"]
				o.name = "Level: [Alchemy.level]   Exp: [comma(Alchemy.exp)]/[comma(Alchemy.maxExp)] ([percent]%)"
			if(Slayer)
				var/percent = round((Slayer.exp / Slayer.maxExp) * 100)
				var/obj/o = mousehelper["Slayer"]
				o.name = "Level: [Slayer.level]   Exp: [comma(Slayer.exp)]/[comma(Slayer.maxExp)] ([percent]%)"
			if(Summoning)
				var/percent = round((Summoning.exp / Summoning.maxExp) * 100)
				var/obj/o = mousehelper["Summoning"]
				o.name = "Level: [Summoning.level]   Exp: [comma(Summoning.exp)]/[comma(Summoning.maxExp)] ([percent]%)"
			if(Spellcrafting)
				var/percent = round((Spellcrafting.exp / Spellcrafting.maxExp) * 100)
				var/obj/o = mousehelper["Spellcrafting"]
				o.name = "Level: [Spellcrafting.level]   Exp: [comma(Spellcrafting.exp)]/[comma(Spellcrafting.maxExp)] ([percent]%)"
			if(TreasureHunting)
				var/percent = round((TreasureHunting.exp / TreasureHunting.maxExp) * 100)
				var/obj/o = mousehelper["TreasureHunting"]
				o.name = "Level: [TreasureHunting.level]   Exp: [comma(TreasureHunting.exp)]/[comma(TreasureHunting.maxExp)] ([percent]%)"

			stat("---Skills---")
			stat(mousehelper)
			stat("","")

			if(level >= lvlcap && rankLevel)
				var/percent = round((rankLevel.exp / rankLevel.maxExp) * 100)
				stat("Experience Rank: ", "[rankLevel.level]   Exp: [comma(rankLevel.exp)]/[comma(rankLevel.maxExp)] ([percent]%)")
				stat("\icon[getRankIcon()]")
			else
				var/percent = round((Exp / Mexp) * 100)
				stat("EXP:", "[comma(src.Exp)]/[comma(src.Mexp)] ([percent]%)")
			if(wand && (wand.exp + wand.quality > 0))
				var/maxExp = MAX_WAND_EXP(wand)
				var/percent = round((wand.exp / maxExp) * 100)
				stat("Wand:", "Level: [wand.quality]   Exp: [comma(wand.exp)]/[comma(maxExp)] ([percent]%)")
			if(pet)
				if(pet.item.exp + pet.item.quality > 0)
					var/maxExp = MAX_PET_EXP(pet.item)
					var/percent = round((pet.item.exp / maxExp) * 100)
					stat("[pet.name]:", "Level: [pet.item.quality]   Exp: [comma(pet.item.exp)]/[comma(maxExp)] ([percent]%)")

					percent = min(round(pet.stepCount / 10, 1), 100)
					stat("",            "Happiness: [percent]%")
				else
					var/percent = min(round(pet.stepCount / 10, 1), 100)
					stat("[pet.name]:", "Happiness: [percent]%")
			stat("Stat points:", StatPoints)
			stat("Spell points:", spellpoints)
			stat("Threads:", threads)
			if(learning)
				stat("Learning:", learning.name)
				stat("Uses required:", learning.uses)
			if(admin)
				stat("CPU:", world.cpu)
				stat("Date:", time2text(world.realtime, "DDD MMM DD hh:mm:ss YYYY"))
			stat("---House points---")
			stat("Gryffindor",worldData.housepointsGSRH[1])
			stat("Slytherin",worldData.housepointsGSRH[2])
			stat("Ravenclaw",worldData.housepointsGSRH[3])
			stat("Hufflepuff",worldData.housepointsGSRH[4])
			stat("","")
			if(worldData.currentEvents)
				stat("Current Events:","")
				for(var/RandomEvent/e in worldData.currentEvents)
					if(e.desc)
						stat("", "[e.name] - [e.desc]")
					else if(e.endTime)
						stat("", "[e.name] - [ticks2time(e.endTime - world.time)]")
					else
						stat("", e.name)
			if(worldData.currentArena)
				if(worldData.currentArena.roundtype == HOUSE_WARS)
					stat("Arena:")
					stat("Gryffindor",worldData.currentArena.teampoints["Gryffindor"])
					stat("Slytherin",worldData.currentArena.teampoints["Slytherin"])
					stat("Hufflepuff",worldData.currentArena.teampoints["Hufflepuff"])
					stat("Ravenclaw",worldData.currentArena.teampoints["Ravenclaw"])
				else if(worldData.currentArena.roundtype == FFA_WARS)
					stat("Arena: (Players Alive)")
					for(var/mob/M in worldData.currentArena.players)
						stat("-",M.name)
			if(worldData.currentMatches.arenas)
				stat("Matchmaking:", "(Click to spectate. Click again to stop.)")
				for(var/arena/a in worldData.currentMatches.arenas)
					stat(a.spectateObj)*/

proc/getMasteryRank(var/uses)

	var/i = round(log(10, uses))

	if(i >= 5) return "<span style=\"color:#aa2fbd;\">Master</span>"
	if(i >= 4) return "<span style=\"color:#bdb82f;\">Professional</span>"
	if(i >= 3) return "<span style=\"color:#2f55bd;\">Skilled</span>"
	if(i >= 2) return "<span style=\"color:#47bd2f;\">Apprentice</span>"
	if(i >= 1) return "Beginner"
	return "Clueless"

obj
	favorites
		name = "Favorites:"
		canSave = FALSE
		var/isopen=1

		Click()
			isopen = !isopen

	mousehover
		icon = 'HUD.dmi'
		icon_state = "Animagus"

		Fire
			icon_state = "Fire"
			desc = "Increases damage done with and reduces damage taken from Fire element."
		Water
			icon_state = "Water"
			desc = "Increases damage done with and reduces damage taken from Water element."
		Earth
			icon_state = "Earth"
			desc = "Increases damage done with and reduces damage taken from Earth element."
		Ghost
			icon_state = "Ghost"
			desc = "Increases damage done with and reduces damage taken from Ghost element."
		Gathering
			icon_state = "Gathering"
			desc = "More yield from herbs, trees and stones."
		Taming
			icon_state = "Taming"
			desc = "Helps taming pets."
		Alchemy
			icon_state = "Alchemy"
			desc = "Increases your knowledge of potion brewing, allowing you the chance to concoct expert level potions with greater effects and longitivtiy. Click this to toggle use/throw mode."

			mouse_over_pointer = MOUSE_HAND_POINTER

			Click()
				var/mob/Player/p = usr

				if(p.potionsMode == THROW)
					p.potionsMode = DRINK
					p << infomsg("You will now drink potions.")
				else
					p.potionsMode = THROW
					p << infomsg("You will now throw potions.")

		Animagus
			icon_state = "Animagus"
			desc = "Each level increases charge capacity by 1, reduces damage taken and increases auto health regeneration while in animagus form."
		Summoning
			icon_state = "Summoning"
			desc = "Each level increases summon level by 1, every 10 levels your summon limit increases. Click to toggle summon mode."

			mouse_over_pointer = MOUSE_HAND_POINTER

			Click()
				var/mob/Player/p = usr

				if(p.summonsMode == 1)
					p.summonsMode = 2
					p << infomsg("You will now summon stronger monsters. (2 slots)")
				else
					p.summonsMode = 1
					p << infomsg("You will now summon normal monsters.")

		Spellcrafting
			icon_state = "Spellcrafting"
			desc = "You should probably click those blue chests you find around."
		Slayer
			icon_state = "Slayer"
			desc = "Each level reduces damage taken and increases damage dealt by 1. Click this to toggle Hardmode (Requires level 10)"

			mouse_over_pointer = MOUSE_HAND_POINTER

			Click()
				var/mob/Player/p = usr

				if(p.Slayer.level < 10)
					p << errormsg("You need Slayer level 10 to use this option.")
					return

				if(p.hardmode == 0)
					p.hardmode = 1
					p << infomsg("Monsters will now be stronger but have 50% more drop rate.")
				else if(p.hardmode == 1)
					p.hardmode = 2
					p << infomsg("Monsters will now be even stronger but have 100% more drop rate.")
				else if(p.hardmode == 2)
					p.hardmode = 3
					p << infomsg("Monsters will now be dangerously lethal but have 150% more drop rate.")
				else if(p.hardmode == 3)
					p.hardmode = 4
					p << infomsg("Monsters will now be maybe possibly kill you but have 200% more drop rate.")
				else if(p.hardmode == 4)
					p.hardmode = 5
					p << infomsg("Monsters will now butcher you but have 250% more drop rate.")
				else
					p.hardmode = 0
					p << infomsg("You are fighting normal monsters now.")

		Treasure_Hunting
			icon_state = "Treasure Hunting"
			desc = "You should probably click those chests and barrels you find around."

		MouseEntered(location,control,params)
			if(desc && usr:infoBubble)
				winset(usr, null, "infobubble.labelTitle.text=\"[icon_state]\";infobubble.labelInfo.text=\"[name]\n[desc]\"")
				winshowRight(usr, "infobubble")


		MouseExited(location,control,params)
			winshow(usr, "infobubble", 0)


	stackobj
		var/isopen=0
		var/containstype
		var/list/contains = list()
		var/count = 0
		mouse_over_pointer = MOUSE_HAND_POINTER
		canSave = FALSE

		Click()
			isopen = !isopen

		verb
			Drop_All()
				set category = null
			//	var/tmpname = ""
				//var/isscroll=0
				for(var/obj/items/O in contains)
					if(O.loc != usr)
						contains -= O
						continue
					var/founddrop = 0
					for(var/V in O.verbs)
						if(V:name == "Drop")
							founddrop =1
							break
					if(!founddrop)
						usr << errormsg("This type of item can't be dropped.")
						return
					//tmpname = O.name
					//if(istype(O,/obj/items/scroll))
				//		isscroll = 1
					//O.Move(usr.loc)
					O.drop(usr, O.stack)
				hearers(owner) << infomsg("[usr] drops all of \his [name] items.")
				/*if(isscroll)
					hearers(usr) << "[usr] drops all of \his scrolls."
				else
					switch(copytext(tmpname,length(tmpname)))//Check last letter for pluralizness
						if("f")
							hearers(usr) << "[usr] drops all of \his [copytext(tmpname,1,length(tmpname))]ves."
						if("s")
							hearers(usr) << "[usr] drops all of \his [tmpname]."
						else
							hearers(usr) << "[usr] drops all of \his [tmpname]s."
				*/
				del(src)


mob/Player/var/tmp/list/obj/stackobj/stackobjects

obj/var/useTypeStack = 0
obj/var/stackName

mob/Player/proc/Resort_Stacking_Inv()

	if(Lfavorites)
		for(var/obj/o in src:Lfavorites)
			if(o.loc != src)
				Lfavorites -= o

		if(Lfavorites.len == 0) Lfavorites = null

	var/list/counts = list()

	for(var/obj/O in contents)
		if(istype(O,/obj/stackobj))
			O.loc = null
		else
			var/T
			if(O.useTypeStack == 0)
				T = O.type
			else if(O.useTypeStack == 1)
				T = O.parent_type
			else
				T = O.useTypeStack

			if(!(T in counts)) counts[T] = list()
			counts[T] += O

	if(length(counts))
		var/list/obj/stackobj/tmpstackobjects = list()
		for(var/V in counts)
			var/list/l = counts[V]
			if(l.len > 1)
				var/obj/stackobj/stack = new
				var/obj/tmpV = new V
				stack.containstype = V
				if(src:stackobjects)
					if(src:stackobjects[V])
						var/obj/stackobj/tmpstack = src:stackobjects[V]
						stack.isopen = tmpstack.isopen
				stack.icon = tmpV.icon
				stack.icon_state = tmpV.icon_state
				stack.name = tmpV.stackName ? tmpV.stackName : tmpV.name
				contents += stack

				stack.contains = l
				var/c = 0
				for(var/obj/items/i in stack.contains)
					c += i.stack
				stack.suffix = "<span style=\"color:red;\">(x[c])</span>"
				stack.count = c
				tmpstackobjects[V] = stack
		src:stackobjects = tmpstackobjects
	else
		src:stackobjects = null
mob/proc/Check_Death_Drop()
	usr=src
	for(var/obj/drop_on_death/O in src)
		O.Drop()

area
	var/respawnPoint

mob/proc/Death_Check(mob/killer = src)

	if(src.HP<1)
		if(isplayer(src))
			var/mob/Player/p = src
			Check_Death_Drop()
			for(var/turf/duelsystemcenter/T in duelsystems)
				if(T.D)
					if(T.D.player1 == src)
						range(8,T) << "<i>[T.D.player1] has lost the duel. [T.D.player2] is the winner!</i>"
						del T.D
					else if(T.D.player2 == src)
						range(8,T) << "<i>[T.D.player2] has lost the duel. [T.D.player1] is the winner!</i>"
						del T.D
			for(var/obj/items/portduelsystem/T in duelsystems)
				if(T.D)
					if(T.D.player1 == src)
						range(8,T) << "<i>[T.D.player1] has lost the duel. [T.D.player2] is the winner!</i>"
						del T.D
					else if(T.D.player2 == src)
						range(8,T) << "<i>[T.D.player2] has lost the duel. [T.D.player1] is the winner!</i>"
						del T.D
			if(src.arcessoing == 1)
				hearers() << "[src] stops waiting for a partner."
				p.arcessoing = 0
			else if(ismob(arcessoing))
				hearers() << "[src] pulls out of the spell."
				stop_arcesso()
			if(p.Detention)
				return
			if(p.Immortal==1 && (p.admin || !istype(killer, /mob/Enemies)))
				p<<"[killer] tried to knock you out, but you are immortal."
				killer<<"<span style=\"color:blue;\"><b>[src] is immortal and cannot die.</b></span>"
				return
			var/area/a = loc.loc
			if(istype(a,/area/hogwarts/Duel_Arenas) || a.respawnPoint)
				p.followplayer=0
				p.HP=p.MHP
				p.MP=p.MMP
				p.updateHPMP()
				p.FlickState("m-black",8,'Effects.dmi')

				if(a.respawnPoint)
					p.Transfer(locate(a.respawnPoint))
				else
					switch(src.loc.loc.type)
						if(/area/hogwarts/Duel_Arenas/Main_Arena_Bottom)
							p.Transfer(locate("DuelArena_Death"))
						if(/area/hogwarts/Duel_Arenas/Matchmaking/Main_Arena_Top)
							var/obj/o = pick(worldData.duel_chairs)
							p.Transfer(o.loc)
						if(/area/hogwarts/Duel_Arenas/Slytherin)
							p.Transfer(locate("Slyth_Death"))
						if(/area/hogwarts/Duel_Arenas/Gryffindor)
							p.Transfer(locate("Gryffin_Death"))
						if(/area/hogwarts/Duel_Arenas/Ravenclaw)
							p.Transfer(locate("Raven_Death"))
						if(/area/hogwarts/Duel_Arenas/Hufflepuff)
							p.Transfer(locate("Huffle_Death"))
						if(/area/hogwarts/Duel_Arenas/Matchmaking/Duel_Class)
							p.Transfer(locate("DuelClass_Death"))
						if(/area/hogwarts/Duel_Arenas/Defence_Against_the_Dark_Arts)
							p.Transfer(locate("DADA_Death"))
						if(/area/hogwarts/Duel_Arenas/Main_Arena_Lobby)
							var/obj/Bed/B = pick(Beds)
							p.Transfer(B.loc)
							src.dir = SOUTH
				src<<"<i>You were knocked out by <b>[killer]</b>!</i>"
				if(src.removeoMob) spawn()src:Permoveo()
				src.sight &= ~BLIND
				return
			if(src.loc.loc.type == /area/hogwarts/Hospital_Wing)
				p.HP=p.MHP
				p.updateHP()
				return
			if(src.loc.loc.type in typesof(/area/arenas/MapThree/WaitingArea))
				killer << "Do not attack in the waiting area.."
				p.HP = p.MHP
				return
			if(src.loc.loc.type in typesof(/area/arenas/MapThree/PlayArea))
				if(worldData.currentArena)
					var/list/players = range(8,worldData.currentArena.speaker)|worldData.currentArena.players
					if(killer != src)
						players << "<b>Arena</b>: [killer] killed [src]."
					else
						players << "<b>Arena</b>: [killer] killed themself."
					worldData.currentArena.players.Remove(src)
					p.HP=p.MHP
					p.MP=p.MMP
					p.updateHPMP()
					if(worldData.currentArena.players.len < 2)
						var/mob/winner
						if(worldData.currentArena.players.len != 0)
							winner = worldData.currentArena.players[1]
							var/turf/T = pick(MapThreeWaitingAreaTurfs)
							winner.loc = T
							winner.density = 1
						else
							winner = src
						players << "<b>Arena</b>: [winner] wins the round!"
						for(var/mob/Z in view(8,worldData.currentArena.speaker))
							Z << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[Z];action=arena_leave\">clicking here.</a></b>"

						var/RandomEvent/FFA/e = locate() in worldData.events
						if(e)
							e.winner = winner

						del(worldData.currentArena)
					else
						new /obj/corpse (loc, src, 0)
					var/turf/T = pick(MapThreeWaitingAreaTurfs)
					src.loc = T
					density = 1
					return
				else
					killer << "Do not attack before a round has started."
					src.HP = src.MHP
					return
			/////HOUSE WARS/////
			if((src.loc.loc.type in typesof(/area/arenas/MapOne)) && isplayer(killer))
				if(p.House != killer:House)
					if(worldData.currentArena)
						if(worldData.currentArena.roundtype == HOUSE_WARS && worldData.currentArena.started)
							worldData.currentArena.Add_Point(killer:House,1)
							src << "You were killed by [killer] of [killer:House]"
							killer << "You killed [src] of [p.House]"
				else if(src == killer)
					src << "You killed yourself!"
				else
					src << "You were killed by [killer], from your own team!"
					killer << "You killed [src] of your own team!"
				if(worldData.currentArena)
					if(worldData.currentArena.plyrSpawnTime > 0)
						src << "<i>You must wait [worldData.currentArena.plyrSpawnTime] seconds until you respawn.</i>"
				var/obj/Bed/B
				switch(p.House)
					if("Gryffindor")
						B = pick(Map1Gbeds)
					if("Hufflepuff")
						B = pick(Map1Hbeds)
					if("Slytherin")
						B = pick(Map1Sbeds)
					if("Ravenclaw")
						B = pick(Map1Rbeds)
				src.loc = B.loc
				src.dir = SOUTH
				if(worldData.currentArena)
					worldData.currentArena.handleSpawnDelay(src)

				var/StatusEffect/Lava/s = locate() in p.LStatusEffects
				if(s) s.Deactivate()
				p.filters = null

				p.HP=p.MHP
				p.MP=p.MMP
				p.updateHPMP()
				return
			var/obj/Bed/B
			if(p.prevname)
				if(p.guild == worldData.majorChaos)
					B = pick(DEBeds)
				else if(p.guild == worldData.majorPeace)
					B = pick(AurorBeds)
				else
					B = pick(Beds)
			else
				B = pick(Beds)
			if(!p.Detention)
				if(killer != p && !p.rankedArena)
					if(killer.client && client && killer.loc.loc.name != "outside")
						if(killer:prevname)
							if(p.prevname)
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [killer:prevname](DE robed) killed [p.prevname](DE robed): [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
							else
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [killer:prevname](DE robed) killed [src]: [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
						else
							if(p.prevname)
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [killer] killed [p.prevname](DE robed): [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
							else
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [killer] killed [src]: [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
					if(killer.client && get_dist(src, killer) == 1 && get_dir(src, killer) == turn(src.dir,180))
						src << "<i>You were knocked out by <b>someone from behind</b> and sent to the Hospital Wing!</i>"
					else
						src << "<i>You were knocked out by <b>[killer]</b> and sent to the Hospital Wing!</i>"

				src:nofly()
				if(src.removeoMob) spawn()src:Permoveo()

				src.followplayer=0
				p.HP=p.MHP
				p.MP=p.MMP
				p.updateHPMP()

				if(!src:rankedArena)
					var/obj/items/wearable/resurrection_stone/resurrect = locate() in p.Lwearing
					if(resurrect)
						if(prob(resurrect.chance))
							p << errormsg("Upon being resurrected you lost your resurrection stone.")
							if(resurrect.Consume())
								resurrect.Equip(p, 1)
						new /obj/corpse (loc, src, -1)
					else
						if(src.level < lvlcap)
							src.Exp = round(src.Exp * 0.8)

						var/goldLoss
						if(SHIELD_GOLD in p.passives)
							goldLoss = 0
						else
							var/gold/g = new(src)
							goldLoss = g.toNumber() * 0.2
							g.change(src, bronze=-goldLoss)
						new /obj/corpse (loc, src, goldLoss)

					p.onDeath(loc, resurrect)

					src.sight &= ~BLIND
					src:Transfer(B.loc)
					src.dir = SOUTH
					src.FlickState("Orb",12,'Effects.dmi')
					p.lastHostile = 0
			if(isplayer(killer))
				p.pdeaths+=1
				if(p.rankedArena)
					p.rankedArena.death(src)
				if(killer != src)
					if(clanwars)
						if(p.getRep() < -100)
							clanwars_event.add_auror(1)

						else if(p.getRep() > 100)
							clanwars_event.add_de(1)

					killer:pkills+=1
					displayKills(killer, 1, 1)

					var/spamKilled      = killer.findStatusEffect(/StatusEffect/KilledPlayer)
					var/spamKilledQuest = killer.findStatusEffect(/StatusEffect/KilledPlayerQuest)

					var/rndexp = round(src.level * 1.5) + rand(-200,200)
					if(rndexp < 0) rndexp = rand(20,30)

					if(killer:House == worldData.housecupwinner)
						rndexp *= 1.5

					if(spamKilled)
						rndexp = rndexp * 0.1
					else if(killer.level >= lvlcap)
						new /StatusEffect/KilledPlayer (killer, 40)
						rndexp *= 6

					rndexp = round(rndexp, 1)

					if(!spamKilledQuest)
						new /StatusEffect/KilledPlayerQuest (killer, 20)
						killer:checkQuestProgress("Kill Player")

					killer:addExp(rndexp)
					if(killer:wand)
						var/obj/items/wearable/wands/w = killer:wand
						w.addExp(killer, round(rndexp / 30))

					if(killer:pet)
						var/obj/items/wearable/pets/pet = killer:pet.item
						pet.addExp(killer, round(rndexp / 30))

					if(killer.level < lvlcap)
						killer << infomsg("You knocked [src] out and gained [rndexp] exp.")
					else
						var/gold/g = new(bronze=rndexp)
						g.give(killer)
						killer<<infomsg("You knocked [src] out and gained [g.toString()].")
				else
					src<<"You knocked yourself out!"
			else
				p.edeaths+=1


		else
			if(isplayer(killer) && !killer:Immortal)
				if(istype(src, /mob/Enemies))
					if(!istype(src, /mob/Enemies/Summoned))
						killer.AddKill(src.name)
					killer:checkQuestProgress("Kill [src.name]")
					if(src:isElite)
						killer:checkQuestProgress("Kill Elites")
				if(killer.MonsterMessages)killer<<"<i><small>You knocked [src] out!</small></i>"

				killer:ekills+=1
				displayKills(killer, 1, 2)
				var/gold2give = (rand(6,14)/10)*gold
				var/exp2give  = (rand(6,14)/10)*Expg

				if((SWORD_ANIMAGUS in killer:passives) && killer:Animagus && killer:animagusPower < 100 + killer:Animagus.level && prob(39 + killer:passives[SWORD_ANIMAGUS]))
					killer:animagusPower++

				if(killer.level > src.level && !killer:hardmode)
					gold2give -= gold2give * ((killer.level-src.level)/150)
					exp2give  -= exp2give  * ((killer.level-src.level)/150)

				if(killer:House == worldData.housecupwinner)
					gold2give *= 1.5
					exp2give  *= 1.5

				exp2give *= worldData.expModifier

				var/StatusEffect/Lamps/Gold/gold_rate = killer.findStatusEffect(/StatusEffect/Lamps/Gold)
				var/StatusEffect/Lamps/Exp/exp_rate   = killer.findStatusEffect(/StatusEffect/Lamps/Exp)

				if(gold_rate) gold2give *= gold_rate.rate
				if(exp_rate)  exp2give  *= exp_rate.rate

				if(killer:guild) exp2give *= 1 + killer:getGuildAreas() * 0.1

				gold2give = round(gold2give)
				var/gold/g = new(bronze=gold2give)

				if(killer.MonsterMessages)

					if(exp2give > 0 && killer.level < lvlcap)
						killer<<"<i><small>You gained [comma(exp2give)] exp[gold2give > 0 ? " and [g.toString()]" : ""].</small></i>"
					else if(gold2give > 0)
						killer<<"<i><small>You gained [g.toString()].</small></i>"

				if(gold2give > 0)
					g.give(killer)
				if(exp2give > 0)
					if(killer:party)
						killer:party.addExp(exp2give, killer, exp_rate ? exp_rate.rate : 1)
					else
						killer:addExp(exp2give, !killer.MonsterMessages)

					if(killer:wand)
						var/obj/items/wearable/wands/w = killer:wand
						w.addExp(killer, round(exp2give / 50))

					if(killer:pet)
						var/obj/items/wearable/pets/pet = killer:pet.item
						pet.addExp(killer, round(exp2give / 50))

			if(istype(src, /mob/Enemies))
				src:Death(killer)
			src.loc=null
			Respawn(src, killer)

mob/Player/proc/Auto_Mute(timer=15, reason="spammed")
	if(mute==0)
		mute=1
		Players << "\red <b>[src] has been silenced.</b>"

		if(reason)
			src << "<b>You've been muted because you [reason].</b>"

		if(timer==0)
			Log_admin("[src] has been muted automatically")
		else
			Log_admin("[src] has been muted automatically for [timer] minutes")
			timerMute = timer
			if(timer != 0)
				src << "<u>You've been muted for [timer] minute[timer==1 ? "" : "s"].</u>"
			mute_countdown()

		spawn()sql_add_plyr_log(ckey,"si",reason,timer)


mob/Player/proc/resetStatPoints()
	StatPoints = level - 1
	Dmg = level + 4
	Def = level + 4
	cooldownModifier = 1
	MPRegen = 0
	resetMaxHP()
	if(level > 1 && !(locate(/hudobj/UseStatpoints) in client.screen))
		new /hudobj/UseStatpoints(null, client, null, show=1)

	if(level == lvlcap && rankLevel)
		StatPoints += rankLevel.level


mob/Player/proc/resetMaxHP()
	MHP = 4 * (level - 1) + 200 + 2 * (Def + clothDef)
	if(HP > MHP)
		HP = MHP
	if(hpBar)
		updateHP()

mob/Player
	proc
		LvlCheck(var/nomsg=0)
			if(level >= lvlcap)
				Exp = 0
				return
			if(src.Exp>=src.Mexp)
				level++
				Dmg+=1
				Def+=1
				resetMaxHP()
				MMP = 6 * level + 194
				HP=MHP
				MP=MMP
				updateHPMP()
				Exp=0

				StatPoints++

				lvlGlow()


				if(!(locate(/hudobj/UseStatpoints) in client.screen))
					new /hudobj/UseStatpoints(null, client, null, show=1)

				if(!nomsg)
					screenAlert("You are now level [level]!")
					src<<"You have gained a statpoint, click + next to your health bar."

				var/currentyear = (Year == "Hogwarts Graduate" ? 8 : text2num(copytext(Year, 1, 2)))
				var/theiryear = level2year(level)

				if(theiryear > currentyear)

					for(var/i=currentyear+1 to theiryear)
						if(i == 2)
							src.Year="2nd Year"
							src<<"<b>Congratulations, [src]! You are now a 2nd Year!</b>"
							verbs += /mob/Spells/verb/Episky
							src<<infomsg("You learned Episkey.")
						else if(i == 3)
							Year="3rd Year"
							src<<"<b>Congratulations, [src]! You are now a 3rd Year!</b>"
							src<<infomsg("You learned how to cancel transfigurations!")
							verbs += /mob/Spells/verb/Episky
							verbs += /mob/Spells/verb/Self_To_Human
						else if(i == 4)
							Year="4th Year"
							src<<"<b>Congratulations, [src]! You are now a 4th Year!</b>"
							verbs += /mob/Spells/verb/Self_To_Dragon
							src<<infomsg("You learned how to Transfigure yourself into a fearsome Dragon!")
						else if(i == 5)
							src.Year="5th Year"
							src<<"<b>Congratulations, [src]! You are now a 5th Year!</b>"
						else if(i == 6)
							src.Year="6th Year"
							src<<"<b>Congratulations, [src]! You are now a 6th Year!</b>"
						else if(i == 7)
							src.Year="7th Year"
							src<<"<b>Congratulations, [src]! You are now a 7th Year!</b>"
						else if(i == 8)
							Year="Hogwarts Graduate"
							src<<"<b>Congratulations, [src]! You have graduated from Hogwarts and attained the rank of Hogwarts Graduate.</b>"
							src<<infomsg("You can now view your damage & defense stats in the stats tab.")

							startQuest("Amato Animo Animato Animagus")


				var/obj/items/wearable/seal_bracelet/seal = locate() in Lwearing
				if(seal)
					if(seal.level > level) seal.exp += Mexp

					if(level == lvlcap) seal.Equip(src)

				if(level <= 600)
					Mexp += 50 * theiryear + 60 * (theiryear - 1)
				else
					var/tier = round(level / 50)
					Mexp += 100 * tier

				if(level == lvlcap && rankLevel)
					StatPoints += rankLevel.level

					if(seal)
						rankLevel.add(round(seal.exp / 10, 1), src)

proc/level2year(level)
	if(level < 16) return 1
	if(level < 51) return 2
	if(level < 101) return 3
	if(level < 201) return 4
	if(level < 301) return 5
	if(level < 401) return 6
	if(level < 501) return 7
	return 8

obj/Banker
	icon = 'NPCs.dmi'
	density=1
	mouse_over_pointer = MOUSE_HAND_POINTER

	var/gold/goldinbank

	New()
		..()
		spawn(1) icon_state = "goblin[rand(1,3)]"
		namefont.QuickName(src, src.name, rgb(255,255,255), "#000", top=1)

	Click()
		..()
		if(src in oview(3))
			Talk()
		else
			usr << errormsg("You need to be closer.")

	verb
		Examine()
			set src in oview(3)
			usr << "He looks like a trustworthy person to hold my money."
		Talk()
			set src in oview(3)

			var/mob/Player/p = usr

			if("On House Arrest" in p.questPointers)
				var/questPointer/pointer = p.questPointers["On House Arrest"]
				if(pointer.stage == 1)
					alert("The banker takes the key and unlocks a small compartment under his desk.")
					alert("He pulls out a box, and removes the wand from it")
					alert("The banker hands you the wand")

					new/obj/items/wearable/wands/interruption_wand(usr)
					var/obj/items/freds_key/k = locate() in usr
					if(k)
						k.Dispose()

					p.checkQuestProgress("Fred's Wand")
					return

			if(goldinbank)
				goldinbank.give(usr)
				usr << infomsg("You withdraw [goldinbank.toString()]")
				goldinbank = null
				return

			var/gold/g = new(usr)
			if(g.sorted)
				g.give(usr, 1)
				usr << infomsg("You exchanged coins with the banker.")
			else
				usr << infomsg("You have no coins to exchange.")


//VARS

obj/var/accioable=0

mob/Player/var
	Detention=0
	Rank
	Immortal=0

	MuteOOC=0
	Year

	House
	Tag
	GMTag
	edeaths=0
	ekills=0
	pdeaths=0
	pkills=0

	draganddrop=0
	StatPoints=0
	mute=0

	tmp
		spam=0

mob/var
	level=1
	Dmg=5
	Def=5
	HP=200
	MHP=200
	MP=200
	MMP=200

mob/Player/var/tmp/Shield = 0

mob/var/Mexp=50
mob/var/Exp=0
mob/var/Expg=1
mob/var/tmp/listenooc=1
mob/var/tmp/listenhousechat=1
mob/var/gold/gold
mob/var/goldg=1
mob/var/gold/goldinbank

mob/var/tmp/follow=0
mob/var/tmp/away=0
mob/var/tmp/followplayer=0
mob/var/tmp/status=""
mob/var/tmp/here=""
mob/var/Gm=0

obj/var/picon=null
obj/var/tmp/mob/owner

proc
	textcheck(t as text)
	// Returns the text string with all potential html tags (anything \
		between < and >) removed.
		t="[html_encode(t)]"
		var/open = findtext(t,"\<")
		while(open)
			var/close = findtext(t,"&gt;",open)
			if(close)
				if(close < length(t))
					t = copytext(t,1,open)+copytext(t,close+4)//+copytext(t,close+1)
				else
					t = copytext(t,1,open)
				open = findtext(t,"\<")
			else
				open = 0
		return t
	Respawn(mob/Enemies/E, mob/killer)
		set waitfor = 0
		if(!E)return
		if(E.removeoMob)
			var/tmpmob = E.removeoMob
			E.removeoMob = null
			spawn()tmpmob:Permoveo()
		if(!istype(E,/mob/Enemies))
			E.loc = null
		else
			E.ChangeState(E.INACTIVE)
			if(E.origloc)
				if(E.hpbar)
					E.hpbar.loc = null
				var/time = E.respawnTime
				if(E.isElite)
					time *= 2
					time += rand(0, 100)

					if(E.hardmode)
						time -= (time * E.hardmode)/10 + E.hardmode*30

						time = max(round(time), 300) + rand(-30, 30)

				else
					if(killer && E.level + 1 < killer.level)
						time = time * (1 - (killer.level - (1 + E.level))/800)

					if(E.hardmode)
						time -= (time * E.hardmode)/10 + E.hardmode*30

					time = max(round(time), 100) + rand(-30, 30)

				sleep(time)
				if(E)
					E.loc = E.origloc
					E.HP = E.MHP
					E.dead = 0
					if(E.hpbar)
						E.hpbar.Set(1, E)
					var/active = E.ShouldIBeActive()

					if(!active && istype(E.origloc.loc, /area/newareas))
						var/area/newareas/a = E.origloc.loc

						active = a.region && a.region.active

					if(active)
						E.alpha = 0
						animate(E, alpha = 255, time = 15)

						if(E.color && (E.color in SHINY_LIST))
							emit(loc    = E.loc,
								 ptype  = /obj/particle/star,
								 amount = 5,
								 angle  = new /Random(0, 360),
								 speed  = 5,
								 life   = new /Random(5,10))

			else
				E.loc = null
				if(E.hpbar)
					E.hpbar.loc = null
					E.hpbar = null

mob/Player/proc/onDeath(turf/oldLoc, killerName)
	set waitfor = 0

	filters = null

	var/obj/o        = new
	o.screen_loc     = "CENTER,CENTER+3"

	var/randomMessage = pick("Say \"hi\" to Satan for me!",
	                         "Did you trip and fall over like those chicks from horror flicks?",
	                         "YOU ARE DEAD. Sorry, that was a little dramatic. Seriously though, you've died.",
	                         "Well, look at the bright side, now you won't have to do your homework.",
	                         "Theme music from Titanic plays as your screen fades to black...",
	                         "You died! What's that all about?",
	                         "Dang, you were doing so well! Such a shame.",
	                         "I saw that coming...",
	                         Gender == "Female" ? "RIP guuurl, RIP" : "RIP bro, RIP")

	o.maptext        = "<center><span style=\"color:#e50000;font-size:32pt;font-family:'Comic Sans MS';\">You died!</span><br>" +\
	                   "<span style=\"color:#e50000;\">[randomMessage]</span></center>"
	o.maptext_height = 128
	o.alpha          = 0
	o.plane          = 2

	var/pixelsize = length(randomMessage) * 14

	o.maptext_width = pixelsize
	o.maptext_x     = -ceil(pixelsize/2)

	client.screen += o

	var/obj/bed = locate("respawn_" + ckey)
	var/hudobj/respawn/r
	if(bed)
		r = new (null, client, list("maptext_width" = o.maptext_width, "maptext_x" = o.maptext_x ), 1)
		animate(r, alpha = 255, time = 5)

	animate(o, alpha = 255, time = 5)

	nomove = 2
	client.eye = oldLoc
	client.perspective = EYE_PERSPECTIVE

	sleep(20)
	Interface.SetDarknessColor("#000000", 10, 30)

	var/time = 50
	var/spawnLoc = loc
	while(spawnLoc == loc && time-- > 0)
		sleep(1)

	animate(o, alpha = 0, time = 5)
	client.eye = src
	client.perspective = MOB_PERSPECTIVE
	Interface.SetDarknessColor("#000000")
	nomove = 0
	if(r) r.hide()
	sleep(6)
	client.screen -= o

turf/proc/autojoin(var_name, var_value = 1)
	var/n = 0
	var/turf/t
	t = locate(x, y + 1, z)
	if(t && t.vars[var_name] == var_value) n |= 1
	t = locate(x, y - 1, z)
	if(t && t.vars[var_name] == var_value) n |= 2
	t = locate(x + 1, y, z)
	if(t && t.vars[var_name] == var_value) n |= 4
	t = locate(x - 1, y, z)
	if(t && t.vars[var_name] == var_value) n |= 8

	return n

turf/proc/autojoin1(var_name, var_value = 1)
	var/n = 0
	var/turf/t
	t = locate(x, y + 1, z)
	if(t && t.vars[var_name] == var_value) n |= 1
	t = locate(x + 1, y, z)
	if(t && t.vars[var_name] == var_value) n |= 2
	t = locate(x, y - 1, z)
	if(t && t.vars[var_name] == var_value) n |= 4
	t = locate(x - 1, y, z)
	if(t && t.vars[var_name] == var_value) n |= 8

	return n


WorldData
	var
		list/loggedIn
		list/eventTaken
		eventPrize

mob/Player
	var
		loginRewardDays = 1
		memberReward = 0

	proc/LoginReward()
		set waitfor = 0

		if(worldData.loggedIn)
			if((client.computer_id in worldData.loggedIn) || (client.address in worldData.loggedIn) || (client.ckey in worldData.loggedIn)) return

		sleep(50)

		while(locate(/hudobj/login_reward) in client.screen)
			sleep(10)

		new /hudobj/login_reward(null, client, null, show=1, Player=src)

	proc/BYONDMemberReward()
		set waitfor = 0
		if((client.IsByondMember() != 0 && memberReward < 1))

			sleep(50)

			var/obj/items/wearable/pets/bird/b = locate() in src
			if(!b)

				while(locate(/hudobj/login_reward) in client.screen)
					sleep(10)

				new /hudobj/login_reward(null, client, null, show=1, Player=src, Prize=/obj/items/wearable/pets/bird, Msg="Thank you for supporting BYOND by being a member.")

	proc/EventReward()
		set waitfor = 0

		if(worldData.eventTaken)
			if((client.computer_id in worldData.eventTaken) || (client.address in worldData.eventTaken) || (client.ckey in worldData.eventTaken)) return

		sleep(50)

		while(locate(/hudobj/login_reward) in client.screen)
			sleep(10)

		new /hudobj/login_reward(null, client, null, show=1, Player=src, Prize=worldData.eventPrize)

hudobj/login_reward

	anchor_x   = "CENTER"
	anchor_y   = "CENTER"

	mouse_over_pointer = MOUSE_HAND_POINTER

	icon = 'Chest.dmi'
	icon_state = "golden"

	var/tmp
		canClick = FALSE
		mob/Player/player
		prize
		BYOND = 0

	MouseEntered()
		if(alpha == 255) transform = matrix()*9
	MouseExited()
		if(alpha == 255) transform = matrix()*8

	New(loc=null,client/Client,list/Params,show=1,Player=null,Prize=null,Msg="Thank you for playing.")
		..(loc,Client,Params,show)
		player = Player

		var/obj/o = new /obj/custom { appearance_flags = RESET_TRANSFORM; maptext_y = -120; maptext_x = -112; maptext_width = 256; maptext_height = 48; plane = 2 }

		if(findtext(Msg, "BYOND"))
			BYOND = 1

		if(Prize)
			o.maptext = "<b style=\"text-align:center;color:[player.mapTextColor];\">[Msg]</b>"
			prize = Prize
		else
			var/daysRemaining = 50 - ((player.loginRewardDays + 1) % 50)
			o.maptext = "<b style=\"text-align:center;color:[player.mapTextColor];\">Days played: [player.loginRewardDays+1]<br>Click the chest to get your reward!<br>Special reward in [daysRemaining] day[daysRemaining > 1 ? "s" : ""].</b>"

		overlays += o


	show()
		set waitfor = 0
		updatePos()
		client.screen += src

		alpha = 0
		animate(src, alpha = 32, transform = turn(matrix()*2, 90), time = 2)
		animate(alpha = 64,  transform = turn(matrix()*2.5, 180), time = 2)
		animate(alpha = 96,  transform = turn(matrix()*3, 270), time = 2)
		animate(alpha = 128, transform = matrix()*4, time = 2)
		animate(alpha = 160, transform = turn(matrix()*5, 90), time = 2)
		animate(alpha = 192, transform = turn(matrix()*6, 180), time = 2)
		animate(alpha = 224, transform = turn(matrix()*7, 270), time = 2)
		animate(alpha = 255, transform = matrix()*8, time = 2)

		sleep(8)
		canClick = TRUE

	Click()
		if(canClick && alpha == 255)
			canClick = FALSE
			hide()

			sleep(2)

			emit(loc    = client,
				 ptype  = /obj/particle/magic,
				 amount = 80,
				 angle  = new /Random(1, 359),
				 speed  = 1,
				 life   = new /Random(40,80))

			if(prize)
				if(BYOND)
					player.memberReward++
				else
					if(!worldData.eventTaken)
						worldData.eventTaken = list()

					if(client.connection == "web")
						worldData.eventTaken[client.address] = client.ckey
					else
						worldData.eventTaken[client.computer_id] = client.ckey

					worldData.eventTaken[client.ckey] = 1

				if(islist(prize))
					for(var/p in prize)
						rewardItem(p)
				else
					rewardItem(prize)

			else
				player.loginRewardDays++

				if(!worldData.loggedIn)
					worldData.loggedIn = list()

				if(client.connection == "web")
					worldData.loggedIn[client.address] = client.ckey
				else
					worldData.loggedIn[client.computer_id] = client.ckey

				worldData.loggedIn[client.ckey] = 1

				if(player.loginRewardDays % 50 == 0)
					var/gold/g = new (bronze=rand(5000, 100000))
					player << infomsg("[g.toString()] magically appeared in your pocket.")
					g.give(player)

					rewardItem(/obj/items/lamps/penta_drop_rate_lamp)
					rewardItem(/obj/items/lamps/penta_gold_lamp)
					rewardItem(/obj/items/lamps/penta_exp_lamp)
					rewardItem(/obj/items/chest/legendary_golden_chest)
				else
					if(prob(15))
						var/gold/g = new (bronze=rand(50, 50000))
						player << infomsg("[g.toString()] magically appeared in your pocket.")
						g.give(player)
					else
						var/prize = pickweight(list(/obj/items/key/basic_key                 = 10,
						                            /obj/items/key/wizard_key                = 10,
						                            /obj/items/key/winter_key                = 10,
						                            /obj/items/key/pentakill_key             = 10,
						                            /obj/items/key/sunset_key                = 9,
						                            /obj/items/key/community_key             = 9,
						                            /obj/items/chest/basic_chest             = 10,
						                            /obj/items/chest/wizard_chest            = 10,
						                            /obj/items/chest/winter_chest            = 10,
						                            /obj/items/chest/pentakill_chest         = 10,
						                            /obj/items/chest/sunset_chest            = 9,
						                            /obj/items/chest/community1_chest        = 9,
						                            /obj/items/artifact                      = 8,
						                            /obj/items/crystal/soul                  = 8,
						                            /obj/items/wearable/orb/peace            = 8,
						                            /obj/items/wearable/orb/chaos            = 8,
						                            /obj/items/lamps/double_drop_rate_lamp   = 10,
						                            /obj/items/lamps/double_gold_lamp        = 10,
						                            /obj/items/lamps/double_exp_lamp         = 10,
						                            /obj/items/lamps/triple_drop_rate_lamp   = 8,
						                            /obj/items/lamps/triple_gold_lamp        = 8,
						                            /obj/items/lamps/triple_exp_lamp         = 8,
						                            /obj/items/lamps/quadaple_drop_rate_lamp = 6,
						                            /obj/items/lamps/quadaple_gold_lamp      = 6,
						                            /obj/items/lamps/quadaple_exp_lamp       = 6))

						rewardItem(prize)

	proc/rewardItem(item)
		set waitfor = 0

		var/obj/items/i = new item (player)

		player << infomsg("[i.name] magically appeared in your pocket.")

		var/obj/o = new
		o.appearance = i.appearance
		o.appearance_flags |= PIXEL_SCALE
		o.plane = 2
		o.mouse_over_pointer = MOUSE_INACTIVE_POINTER
		o.screen_loc = "CENTER,CENTER"

		client.screen += o

		o.alpha = 0
		var/ox = rand(-128,128)
		var/oy = rand(-128,128)

		var/matrix/m1 = matrix()*6
		var/matrix/m2 = matrix()*8

		m1.Translate(ox, oy)
		m2.Translate(ox * 1.25, oy * 1.25)

		animate(o, transform = m1, alpha = 255, time = 12)
		animate(transform = m2, alpha = 0, time = 4)

		sleep(17)
		if(client)
			client.screen -= o
