/*
 * Copyright � 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
var/lvlcap = 600
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
	map.Save()*/

obj/drop_on_death
	var/announceToWorld = 1
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			if(announceToWorld)
				hearers()<<"<b>[usr] drops \the [src].</b>"
			else
				hearers()<<"[usr] drops \the [src]."
	proc
		take(mob/M)
			if(announceToWorld)
				world << "<b>[M] takes \the [src].</b>"
			else
				hearers()<<"[M] takes \the [src]."
			Move(M)
			M:Resort_Stacking_Inv()
mob/test/verb
	enter_vault(ckey as text)
		set category = "Vault Debug"
		var/swapmap/map = SwapMaps_Find("[ckey]")
		if(!map)
			map = SwapMaps_Load("[ckey]")
		if(!map)
			usr << "<i>Couldn't find map.</i>"
		else
			var/width = (map.x2+1) - map.x1
			usr.loc = locate(map.x1 + round((width)/2), map.y1+1, map.z1 )
	load_undroppables_into_mob(mob/M as mob in Players)
		set category = "Vault Debug"
		var/swapmap/map = SwapMaps_Find("[M.ckey]")
		if(!map)
			map = SwapMaps_Load("[M.ckey]")
		if(!map)
			usr << "<i>Couldn't find map.</i>"
		else
			for(var/turf/T in map.AllTurfs())
				for(var/obj/O in T)
					if(!(text2path("[O.type]/verb/Drop") in O.verbs) && !istype(O,/obj/Food) && !istype(O,/obj/teleport/leavevault) )
						O.loc = M
			M:Resort_Stacking_Inv()

obj/teleport
	var/dest = ""
	invisibility = 2
	portkey
		icon='blue2.dmi'
		icon_state="portkey"
		name = "Port key"
		invisibility = 0
	proc/Teleport(mob/M)
		if(dest)
			if(M.key)
				var/atom/A = locate(dest) //can be some turf, or some obj
				if(isobj(A))
					M.loc = A.loc
				else if(isturf(A))
					M.loc = A
				M.client.images = list()
				M.loc.loc.Enter(M)
				if(M.classpathfinding)
					M.Class_Path_to()
				return 1
	entervault
		Teleport(mob/M)
			if(M.key)
				var/list/accessible_vaults = M.get_accessible_vaults()
				var/hasownvault = 	fexists("[swapmaps_directory]/map_[usr.ckey].sav")
				if(hasownvault || accessible_vaults.len)
					var/list/result = list()
					for(var/ckey in accessible_vaults)
						result[sql_get_name_from(ckey)] = ckey
					var/chosenvault
					var/response
					if(result.len && hasownvault)
						response = input("Which vault do you wish to enter?") as null|anything in result + "My own"
						if(response == "My own")
							chosenvault = usr.ckey
					else if(result.len)
						response = input("Which vault do you wish to enter?") as null|anything in result
					else if(hasownvault)
						chosenvault = usr.ckey
					if(usr.loc != src.loc) return
					if(chosenvault == usr.ckey)
						usr << npcsay("Vault Master: Welcome back to your vault, [usr].[pick(" Remember good security! If you let someone inside and they steal something, there's not much you can do about it!!"," Only let people into your vault if you completely trust them!","")]")
					else
						if(!response) return
						usr << npcsay("Vault Master: Welcome to [response]'s vault, [usr].")
						chosenvault = result[response]
					var/swapmap/map = SwapMaps_Find("[chosenvault]")
					if(!map)
						map = SwapMaps_Load("[chosenvault]")
					var/width = (map.x2+1) - map.x1
					usr.loc = locate(map.x1 + round((width)/2), map.y1+1, map.z1 )
				else
					M << npcsay("Vault Master: You don't have a vault here, [usr]. Come speak to me and let's see if we can change that.")
	leavevault
		icon = 'turf.dmi'
		icon_state = "exit"
		dest="leavevault"
		invisibility = 0
		Teleport(mob/M)
			if(..())
				unload_vault()

	desert_exit
		icon = 'misc.dmi'
		icon_state = "sandstorm_exit"
		dest = "@Hogwarts"
		invisibility = 0
		Teleport(mob/M)
			if(prob(60))
				..()
				M << infomsg("You magically found yourself at Hogwarts!")
			else
				M.density = 0
				M.Move(locate(rand(4,97),rand(4,97),4))
				M.density = 1
		New()
			..()
			walk_rand(src,8)

var/tmp/vault_last_exit
proc/unload_vault()
	if(vault_last_exit)
		vault_last_exit = world.time
		return

	var/const/VAULT_TIMEOUT = 50
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
	src << infomsg("Map has been unloaded.")
mob/GM/verb/DeleteMap()
	set category = "Custom Maps"
	if(!length(customMaps))
		src << errormsg("No maps currently exist.")
		return
	var/customMap/map = input("Delete which map?") as null|anything in customMaps
	if(!map) return
	if(map.swapmap && map.swapmap.InUse())
		alert("That map currently has a player on it.")
		return
	fdel("[swapmaps_directory]/map_custom_[ckey(map.name)].sav")
	global.loadedMaps.Remove(map)
	global.customMaps.Remove(map)
	Save_World()
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
	var/customMap/copymap = input("Which map do you want to make a copy of?") as null|anything in customMaps
	if(!copymap) return
	var/result = fcopy("[swapmaps_directory]/map_custom_[ckey(copymap.name)].sav","[swapmaps_directory]/map_custom_[ckey(newname)].sav")
	if(result)
		src << infomsg("A copy of [copymap.name] has been created and named [newname]. It has not been loaded.")
		global.customMaps.Add(newmap)
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
	global.loadedMaps.Add(newmap)
	global.customMaps.Add(newmap)
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
	var/Region/r = new(usr.loc, /proc/AccessibleTurfs)
	for(var/T in r.contents)
		new path (T)
mob/GM/verb/LoadMap()
	set category = "Custom Maps"
	if(!length(customMaps))
		src << errormsg("No maps currently exist.")
		return
	var/customMap/map = input("Load which map?") as null|anything in customMaps
	if(!map) return
	if(map.swapmap)
		src << infomsg("\"[map.name]\" is already loaded. Teleporting there now.")
	else
		map.swapmap = SwapMaps_Load("custom_[ckey(map.name)]")
		src << infomsg("Loading \"[map.name]\". Teleporting there now.")
	src.loc = locate(map.swapmap.x1, map.swapmap.y1, map.swapmap.z1)
	global.loadedMaps.Remove(map)
	global.loadedMaps.Add(map)
var/list/customMap/customMaps = list()
var/tmp/list/customMap/loadedMaps = list()
customMap
	var/name = ""
	var/tmp/swapmap/swapmap = null
vault
	var/list/allowedpeople = list()	//ckeys of people with permission to enter
	proc/can_ckey_enter(ckey)
		return (ckey in allowedpeople)
	proc/add_ckey_allowedpeople(ckey)
		allowedpeople += ckey
	proc/remove_ckey_allowedpeople(ckey)
		allowedpeople -= ckey
	proc/name_ckey_assoc()
		//Returns an associated list in list[ckey] = name format
		var/list/result = list()
		for(var/V in src.allowedpeople)
			result[sql_get_name_from(V)] = V
		return result
var/list/vault/globalvaults = list()//Associated with ckey of owner

mob/proc/get_accessible_vaults()
	var/list/accessible_vaults = list()
	for(var/ckey in globalvaults)
		var/vault/V = globalvaults[ckey]
		if(V.can_ckey_enter(src.ckey))
			accessible_vaults += ckey
	return accessible_vaults



mob/VaultGoblin
	icon = 'misc.dmi'
	icon_state = "goblinvault"
	name = "Vault Master"
	verb
		Talk()
			set src in oview(2)
			if(global.globalvaults[usr.ckey])
				var/vault/V = global.globalvaults[usr.ckey]
				switch(input("What would you like to change about your vault?")as null|anything in list("Change who can enter my vault", "Transfer items from old vault to new vault"))
					if("Transfer items from old vault to new vault")
						if(alert("This will move all items from your old-style vault into your current vault. Are you sure you wish to do this?",,"Yes","No")=="Yes")
							var/swapmap/map = SwapMaps_Find("[usr.ckey]")
							if(!map)
								map = SwapMaps_Load("[usr.ckey]")
							var/foundundroppable = 0 // Set if you have an object with no drop verb
							if(usr.bank)for(var/atom/movable/A in usr.bank.items)
								if((text2path("[A.type]/verb/Drop") in A.verbs) && (!istype(A,/obj/Food)))
									A.loc = get_step(map.LoCorner(),NORTHEAST)
								else
									A.loc = usr
									foundundroppable = 1
								usr.bank.items -= A
							if(foundundroppable)
								usr << "Undroppable items have been moved to your personal inventory, instead of your vault."
							usr << npcsay("Vault Master: Your items have been transferred successfully.")
							usr:Resort_Stacking_Inv()

					if("Change who can enter my vault")
						if(V.allowedpeople && V.allowedpeople.len)
							switch(alert("Would you like to allow someone to enter your vault, or remove someone's permission from entering?",,"Allow someone","Deny someone","Cancel"))
								if("Allow someone")
									var/list/peoplecount = Players + fakeDEs - usr
									for(var/mob/N in peoplecount)
										if(N.name == "Deatheater" ||(istype(N,/mob/fakeDE) && N:ownerkey == usr.key))
											peoplecount -= N
									if(!peoplecount.len)
										//Not any people to do anything with
										alert("There's nobody left you can add.")
										return
									var/mob/M = input("Who would you like to allow to enter your vault at any time?") as null|anything in peoplecount
									if(M)
										if(istype(M,/mob/fakeDE))
											V.add_ckey_allowedpeople(ckey(M:ownerkey))
										else
											V.add_ckey_allowedpeople(M.ckey)
										usr << npcsay("Vault Master: [M.name] can now enter your vault at any time. See me again if you wish to change this.")
								if("Deny someone")
									var/list/name_ckey_assoc = V.name_ckey_assoc()
									var/M = input("Who would you like to deny entrance to vault?") as null|anything in name_ckey_assoc
									if(M)
										V.remove_ckey_allowedpeople(name_ckey_assoc[M])
										usr << npcsay("Vault Master: [M] can no longer enter your vault.")
						else
							var/list/peoplecount = Players + fakeDEs - usr
							for(var/mob/N in peoplecount)
								if(N.name == "Deatheater" ||(istype(N,/mob/fakeDE) && N:ownerkey == usr.key))
									peoplecount -= N
							if(!peoplecount.len)
								//Not any people to do anything with
								alert("There's nobody left you can add.")
								return
							var/mob/M = input("Who would you like to allow to enter your vault at any time?") as null|anything in peoplecount
							if(M)
								if(istype(M,/mob/fakeDE))
									V.add_ckey_allowedpeople(ckey(M:ownerkey))
								else
									V.add_ckey_allowedpeople(M.ckey)
								usr << npcsay("Vault Master: [M.name] can now enter your vault at any time. See me again if you wish to change this.")
					else
						usr << npcsay("Vault Master: See me again if you need to change anything with your vault.")

			else if(fexists("[swapmaps_directory]/map_[usr.ckey].sav"))
				usr << npcsay("Vault Master: Hi there.")
				global.globalvaults[usr.ckey] = new /vault()
				//Attempted fix for #373
			else
				if(alert("Do you want a free vault where you can store your belongings?","Vault","Yes","No") == "Yes")
					if(!fexists("[swapmaps_directory]/map_[usr.ckey].sav"))
						usr << npcsay("Vault Master: Okay, I've allocated you some space down in Vault [rand(10,99)][pick("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")]")
						usr << npcsay("Vault Master: Anything you drop in there will be safely kept and available to you at any time. ((If you create a new character, your vault will retain its contents, so it's a good way to transfer your stuff if you want to remake.))")
						if(!islist(global.globalvaults))
							global.globalvaults = list()
						global.globalvaults[usr.ckey] = new /vault()
						var/swapmap/map = SwapMaps_CreateFromTemplate("vault1")
						map.SetID("[usr.ckey]")
						map.Save()
				else
					usr << npcsay("Vault Master: Maybe next time.")

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
						M<<"<font size=2><font color=red><b> <font color=red>[usr.name]</font> </b>:<font color=white> [T]"
					else
						if(rand(1,3)==1) M<<"<i>You hear an odd ringing sound.</i>"
			else
				world << "<b><font face='Comic Sans MS'><font color=green><font size=1>OOC></b><font face='Comic San MS'><font size=2><b><font color=blue>[mob.name]  :</font></b> <font color=white><font size=2> [T]"
	else
		usr << "You can sign in by typing the password followed by your name. (Seperated by a space)"
		failedtries++
		if(failedtries>4)del(src)*/
mob/see_in_dark = 1
client/view = "17x17"
client/New()
	..()
	screen_x_tiles = 17
	screen_y_tiles = 17
client/var/screen_x_tiles = 0
client/var/screen_y_tiles = 0
mob/proc/setsplitter()
	if(!betamapmode)
		//mainvsplit
		var/wholewidth = winget(src,"mainvsplit","size")
		var/xpos = findtext(wholewidth,"x")
		wholewidth = text2num(copytext(wholewidth,1,xpos))
		var/mapwidth = winget(src,"mapwindow","size")
		xpos = findtext(mapwidth,"x")
		mapwidth = text2num(copytext(mapwidth,1,xpos))
		mapwidth = 32*17
		var/percentage = (mapwidth / wholewidth) * 100
		winset(src,"mainvsplit","splitter=[percentage]")

client/verb/resizeMap()
	set name=".resizeMap"
	if(!istype(mob,/mob/Player))return
	var/obj/screenobj/conjunct/C = locate() in screen
	if(mob&&mob.betamapmode)
		var/size = winget(src,"mapwindow","size")
		var/xpos = findtext(size,"x")
		screen_x_tiles = round( text2num(copytext(size,1,xpos)) / 32) + 1
		screen_y_tiles = round( text2num(copytext(size,xpos+1)) / 32)
		view = "[screen_x_tiles]x[screen_y_tiles]"
		if(C) C.screen_loc = view2screenloc(view)
	else
		//NEED TO RESET TO OLD VERSIO HERRREEE
		view="17x17"
		if(C) C.screen_loc = view2screenloc(view)
		screen_x_tiles = 17
		screen_y_tiles = 17
mob/var/betamapmode = 1
mob/verb/ToggleBetaMapMode()
	set name = ".ToggleBetaMapMode"
	if(winget(src,"menu.betamapmode","is-checked") == "true")
		betamapmode = 1
	else
		betamapmode = 0
		setsplitter()
	client.resizeMap()
mob/verb/EnableBetaMapMode()
	set name = ".EnableBetaMapMode"
	betamapmode = 1
	client.resizeMap()
mob/verb/DisableBetaMapMode()
	set name = ".DisableBetaMapMode"
	betamapmode = 0
	setsplitter()
	client.resizeMap()

/mob/proc/GenerateNameOverlay(r,g,b,de=0)
	var/outline = "#000"
	//if(30*r+59*g+11*b > 7650) outline = "#000"
	if(src.pname&&src.key)
		if(de)
			namefont.QuickName(src, "Deatheater", rgb(r,g,b), outline, top=1)
		else
			namefont.QuickName(src, src.pname, rgb(r,g,b), outline, top=1)
	else
		if(de)
			namefont.QuickName(src, "Deatheater", rgb(r,g,b), outline, top=1)
		else
			namefont.QuickName(src, src.name, rgb(r,g,b), outline, top=1)

mob/test/verb/Tick_Lag(newnum as num)
	world.tick_lag = newnum
var/list/housepointsGSRH = new/list(6)

mob/test/verb/Modify_Housepoints()

	housepointsGSRH[1] = input("Select Gryffindor's housepoints:","Housepoints",housepointsGSRH[1]) as num
	housepointsGSRH[2] = input("Select Slytherin's housepoints:","Housepoints",housepointsGSRH[2]) as num
	housepointsGSRH[3] = input("Select Ravenclaw's housepoints:","Housepoints",housepointsGSRH[3]) as num
	housepointsGSRH[4] = input("Select Hufflepuff's housepoints:","Housepoints",housepointsGSRH[4]) as num
	housepointsGSRH[5] = input("Select Auror's housepoints:","Housepoints",housepointsGSRH[5]) as num
	housepointsGSRH[6] = input("Select Deatheater's housepoints:","Housepoints",housepointsGSRH[6]) as num
	Save_World()
mob/var/tmp/Rictusempra
var/radioOnline = 0

proc/check(msg as text)
    var/search = list("\n")//this is a list of stuff you want to make sure is not in the msg
    for(var/c in search)//search through all the things in the list
        var/pos = findtext(msg,c)//tells the position of the unwanted text
        while(pos)//loops through the whole message to make sure there is no more unwanted text
            msg = "[copytext(msg,1,pos)][copytext(msg,pos+1)]"//It makes the unwanted text(in this case "\n") display in the chat rather than it maknig a new line.
            pos = findtext(msg,c,pos)//looks for anymore unwanted text after the first one is found
    return html_encode(msg)
var/list/illegalnames = list(
	"harry",
	"potter",
	"weasley",
	"hermoine",
	"granger",
	"albus",
	"dumbledore",
	"malfoy",
	"lestrange",
	"sirius",
	"voldemort",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"0")
client
	script = "<STYLE>BODY {background: black; color: white; font-family: Arial,sans-serif}a:link {color: #3636F5}</STYLE>"
//	macros return "Attack"

var/DevMode
turf
	leavereception
		icon = 'blue2.dmi'
		name = "Portal"
		Entered(atom/movable/A)
			if(ismob(A) && A:key)
				A.density = 0
				A.Move(locate(50,22,15))
				A.density = 1

turf
	leaveauror
		icon = 'blue2.dmi'
		name = "Portal"
		Entered(atom/movable/A)
			A.loc = locate(87,70,22)

turf
	leavediagon
		icon = 'blue2.dmi'
		name = "Portal"
		Entered(mob/M)
			if(ismob(M))
				M.loc = locate(99,22,15)
				M << "You leave Diagon Alley."

turf
	leavecellar
		icon = 'blue2.dmi'
		name = "Portal"
		Entered(mob/M)
			if(ismob(M))
				M.loc = locate(31,53,26)
				M << "You leave the Cellar."
turf
	floo_aurorhosp
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(mob/M)
			if(ismob(M))
				if(M.Auror)
					flick('mist.dmi',usr)
					var/obj/O = locate("hogshospital")
					M.loc = O.loc
					flick('mist.dmi',usr)
	floo_dehosp
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(mob/M)
			if(ismob(M))
				if(M.DeathEater)
					flick('mist.dmi',usr)
					var/obj/O = locate("DEspawn[rand(1,3)]")
					M.loc = O.loc
					flick('mist.dmi',usr)
	floo_dada
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			if(usr.key != "Murrawhip")
				usr << "You burn your feet in the fireplace. Ouch!"
				return
			flick('mist.dmi',usr)
			usr.loc = locate(29,58,21)
			flick('mist.dmi',usr)
			usr << "You step into the fireplace, and are wooshed away."
	floo_shirou
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			if(A:key != "Murrawhip")
				usr << "You burn your feet in the fireplace. Ouch!"
				return
			usr.loc = locate(80,26,1)
			flick('mist.dmi',usr)
			usr << "You step into the fireplace, and are wooshed away."



turf
	floo_slythern_class
		icon = 'misc.dmi'
		icon_state="blue fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			if(!A:key) return
			switch(input("Which class would you like to go to?","Select a classroom")in list("Defense Against the Dark Arts","Charms","Care of Magical Creatures","Transfiguration","General Course of Magic","Cancel"))
				if("Defense Against the Dark Arts")
					usr.loc = locate(24,54,21)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("Charms")
					usr.loc = locate(70,11,21)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("Care of Magical Creatures")
					usr.loc = locate(52,48,21)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("Transfiguration")
					usr.loc = locate(12,83,22)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("General Course of Magic")
					usr.loc = locate(41,73,22)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)

turf
	floo_triwizard
		icon = 'misc.dmi'
		icon_state="blue fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			switch(input("Which class would you like to go to?","Select a classroom")in list("Defense Against the Dark Arts","Charms","Care of Magical Creatures","Transfiguration","General Course of Magic","Cancel"))
				if("Underwater")
					usr.loc = locate(8,8,9)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)
				if("Sky")
					usr.loc = locate(47,7,24)
					usr << "You step into the fireplace, and are wooshed away."
					flick("m-blue", usr)


turf
	floo_charms
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			flick('mist.dmi',usr)
			usr.loc = locate(70,10,21)
			flick('mist.dmi',usr)
			usr << "You step into the fireplace, and are wooshed away in a blaze of green fire."

turf
	floo_housewars
		icon = 'misc.dmi'
		icon_state="fireplace"
		name = "Fireplace"
		Entered(atom/movable/A)
			if(!ismob(A)) return
			flick('mist.dmi',usr)
			usr.loc = locate(23,28,20)
			flick('mist.dmi',usr)
			usr << "You step into the fireplace, and are wooshed away in a blaze of green fire."

mob/GM/verb/Prize_Draw()
	var/txt = input("Enter the names going into the draw, seperating them so that there's one name on each line.") as null|message
	if(!txt)return
	txt = dd_text2list(txt,"\n")
	alert("The magical box of Murra-Awesome draws the name: [pick(txt)]")
world
	hub = "TheWizardsChronicles.TWC"
	name = "Harry Potter: The Wizards' Chronicles"
	turf=/turf/blankturf
	view="17x17"
var/world/VERSION = "16.01"

world/proc/playtimelogger()
	return
	var/today_d = time2text(world.realtime,"DD")
	var/today_m = time2text(world.realtime,"MM")
	var/today_y = time2text(world.realtime,"YY")
	var/today_h = time2text(world.timeofday,"hh")
	for(var/client/C)
		var/sql = "SELECT ckey FROM tblPlayinglogs WHERE ckey=[mysql_quote(C.ckey)] AND day='[today_d]' AND month='[today_m]' AND year='[today_y]'"
		var/DBQuery/qry = my_connection.NewQuery(sql)
		qry.Execute()
		if(qry.RowCount() > 0)
			//Already has a listing for today - update it
			sql = "UPDATE tblPlayinglogs SET `[today_h]`='1' WHERE ckey=[mysql_quote(C.ckey)] AND day='[today_d]' AND month='[today_m]' AND year='[today_y]'"
			qry = my_connection.NewQuery(sql)
			qry.Execute()
			if(qry.RowsAffected() < 1 && qry.ErrorMsg())
				world.log << "0 rows were affected - (([sql])) - Errormsg: [qry.ErrorMsg()]"
		else
			//Create a listing for today and populate it
			sql = "INSERT INTO tblPlayinglogs(ckey,day,month,year,`[today_h]`) VALUES('[C.ckey]','[today_d]','[today_m]','[today_y]','1')"
			qry = my_connection.NewQuery(sql)
			qry.Execute()
			if(qry.RowsAffected() < 1 && qry.ErrorMsg())
				world.log << "0 rows were affected - (([sql])) - Errormsg: [qry.ErrorMsg()]"
		sleep(2)
world/proc/worldlooper()
	sleep(9000)
	spawn()
		world.playtimelogger()
	if(radioEnabled)
		var/rndnum = rand(1,2)
		for(var/client/C)
			sleep(2)
			if(world.timeofday < 9000)
				C.mob.usedpermoveo = 0
			if(winget(C,"radio_enabled","is-checked") == "false")
				switch(rndnum)
					if(1)
						C.mob << "<font color = white><b><h3>TWC Radio is broadcasting. Click <a href='?src=\ref[C.mob];action=listen_radio'>HERE</a> to listen.</h3></b></font><br>"
					if(2)
						C.mob << "<font color = white><b><h3>You should probably listen to TWC Radio. Click <a href='?src=\ref[C.mob];action=listen_radio'>HERE</a>!</h3></b></font><br>"
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
				"harry",
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
				"marvello",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"0")
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
		proc/filtername(var/charname)
			if(charname=="" || charname == " ")
				return 1
			for(var/W in illegalnames)
				if(findtext(charname,W))
					return 1
			return 0
		Login()
			if(DevMode==1)
				if(!src.Gm)
					src<<"<font color=red><p align=center> || <b>Access Denied</b>|| <p align=center> The server is currently in Maintinence Mode. Access is restricted to Game Masters only.</p>"

					sleep(1)
					del src
				else
					src<<"<b><p align=center> || <b>Access Granted</b> || <p align=center>You have been recognized as a Game Master. The server is currently in maintience mode. Access is permitted to staff only. Welcome.</p>"


			var/mob/Player/character=new()
			//character.savefileversion = currentsavefilversion
			var/desiredname = input("What would you like to name your Harry Potter: The Wizard's Chronicles character? Keep in mind that you cannot use a popular name from the Harry Potter franchise, nor numbers or special characters.")
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
				//	character<<"<font size=3><font color=red>You are now a Hufflepuff. Common Room password is <font size=3><font color=red>Maroon</font><p><b>Dont Tell Anyone Outside of Your House or you will be expelled."

			character.Rank="Player"
			character.baseicon = character.icon
			character.Year="1st Year"
			if(character.Gender=="Female")
				character.gender = FEMALE
			else if(character.Gender=="Male")
				character.gender = MALE
			//character.StatPoints+=10
			//character.verbs += /mob/Player/verb/Use_Statpoints
			src<<"<b><font size=2><font color=#3636F5>Welcome to Harry Potter: The Wizards Chronicles</font> <u><a href='http://wizardschronicles.com/?ver=[VERSION]'>Version [VERSION]</a></u></b> <br>Visit the forums <a href=\"http://forum.wizardschronicles.com\">here.</a>"
			//src<<"<b><font size=2><font color=blue>Welcome to Harry Potter: The Wizards Chronicles</font> <u><a href='?src=\ref[src];action=view_changelog'>Version [VERSION]</a></u></b> <br>Visit the forums <a href=\"http://www.wizardschronicles.com\">here.</a>"
			src<<"<b>You are in the entrance to Diagon Alley."
			src<<"<b><u>Ollivander has a wand for you. Go up, and the first door on your right is the entrance to Ollivander's wand store.</u></b>"
			src<<"<h3>For a full player guide, visit http://guide.wizardschronicles.com.</h3>"
			var/obj/hud/PMHome/H = new()
			usr.client.screen += H
			var/oldmob = src
			src.client.mob = character
			character.gold = 100
			character.client.eye = character
			character.client.perspective = MOB_PERSPECTIVE
			character.loc=locate(45,60,26)
			character.notmonster=1
			character.verbs += /mob/Spells/verb/Inflamari
			for(var/client/C)
				if(C.mob)
					if(C.mob.Gm) C.mob << "<font size=2 color=#C0C0C0><B><I>[character][character.refererckey==C.ckey ? "(referral)" : ""] ([character.client.address]) logged in.</I></B></font>"
					else C.mob << "<font size=2 color=#C0C0C0><B><I>[character][character.refererckey==C.ckey ? "(referral)" : ""] logged in.</I></B></font>"
			character.Teleblock=0
			src = null
			spawn()
				sql_check_for_referral(character)
			del(oldmob)
mob/var
	extraMHP = 0
	extraMMP = 0
	extraDmg = 0
	extraDef = 0
mob/Player
	player=1
	NPC=0
	verb
		Use_Statpoints()
			set category = "Commands"
			if(usr.StatPoints>0)
				switch(input("Which stat would you like to improve?","You have [usr.StatPoints] stat points.")as null|anything in list ("Mana Points","Damage","Defense"))
					if("Health")
						if(src.StatPoints>0)
							var/SP = round(input("How many stat points do you want to put into Health? You have [usr.StatPoints]",,usr.StatPoints) as num|null)
							if(!SP || SP < 0)return
							if(SP <= usr.StatPoints)
								var/addstat = 10*SP
								usr.extraMHP+=addstat
								usr<<infomsg("You gained [addstat] HP!")
								usr.StatPoints -= SP
							else
								usr <<errormsg("You cannot put [SP] stat points into Health as you only have [usr.StatPoints]")
					if("Mana Points")
						if(src.StatPoints>0)
							var/SP = round(input("How many stat points do you want to put into Mana Points? You have [usr.StatPoints]",,usr.StatPoints) as num|null)
							if(!SP || SP < 0)return
							if(SP <= usr.StatPoints)
								var/addstat = 10*SP
								usr.extraMMP+=addstat
								usr<<infomsg("You gained [addstat] MP!")
								usr.StatPoints -= SP
							else
								usr <<errormsg("You cannot put [SP] stat points into Mana Points as you only have [usr.StatPoints]")
					if("Damage")
						if(src.StatPoints>0)
							var/SP = round(input("How many stat points do you want to put into Damage? You have [usr.StatPoints]",,usr.StatPoints) as num|null)
							if(!SP || SP < 0)return
							if(SP <= usr.StatPoints)
								var/addstat = 1*SP
								usr.extraDmg+=addstat
								usr<<infomsg("You gained [addstat] damage!")
								usr.StatPoints -= SP
							else
								usr <<errormsg("You cannot put [SP] stat points into Damage as you only have [usr.StatPoints]")
					if("Defense")
						if(src.StatPoints>0)
							var/SP = round(input("How many stat points do you want to put into Defense? You have [usr.StatPoints]",,usr.StatPoints) as num|null)
							if(!SP || SP < 0)return
							if(SP <= usr.StatPoints)
								var/addstat = 3*SP
								usr.extraDef+=addstat
								usr<<infomsg("You gained [addstat] defense!")
								usr.StatPoints -= SP
							else
								usr <<errormsg("You cannot put [SP] stat points into Defense as you only have [usr.StatPoints]")
				usr.resetMaxHP()
				usr.updateHPMP()
				if(usr.StatPoints == 0)
					usr.verbs.Remove(/mob/Player/verb/Use_Statpoints)
			else
				usr.verbs.Remove(/mob/Player/verb/Use_Statpoints)

	proc
		Saveme()
			if(derobe)
				derobe = 0
				name = prevname

	Login()
		//..()
		dance = 0
		if(Gender=="Female")
			gender = FEMALE
		else if(Gender=="Male")
			gender = MALE
		Resort_Stacking_Inv()
		shielded = 0
		resetSettings()
		if(usr.StatPoints<1)usr.verbs.Remove(/mob/Player/verb/Use_Statpoints)
		shieldamount = 0
		mouse_drag_pointer = MOUSE_DRAG_POINTER
		spawn()
			for(var/client/C)
				if(C.computer_id == src.client.computer_id)
					if(C.mob != src)
						for(var/client/A)
							if(A.mob.Gm)
								A << "<h2>Multikeyers: [C.mob](key: [C.key]) & just logged in: [src] (key: [src.key])</h2>"
		listenooc = 1
		listenhousechat = 1
		invisibility = 0
		switch(key)
			if("Murrawhip")
				src.verbs+=typesof(/mob/GM/verb/)
				src.verbs+=typesof(/mob/Spells/verb/)
				src.verbs+=typesof(/mob/test/verb/)
				src.verbs+=typesof(/mob/Quidditch/verb)
				src.Gm=1
				src.shortapparate=1
				src.draganddrop=1
				src.admin=1
				//src.icon = 'Murrawhip.dmi'
				//src.icon_state = ""
		//spawn()world.Export("http://www.wizardschronicles.com/player_stats_process.php?playername=[name]&level=[level]&house=[House]&rank=[Rank]&login=1&ckey=[ckey]&ip_address=[client.address]")
		timelog = world.realtime
		overlays = list()
		underlays = list()
		if(timerMute > 0)
			src << "<u>You're muted for [timerMute] minute[timerMute==1 ? "" : "s"].</u>"
			spawn() mute_countdown()
		if(timerDet > 0)
			src << "<u>You're in detention for [timerDet] minute[timerDet==1 ? "" : "s"].</u>"
			spawn() detention_countdown()
		switch(src.House)
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
		Players.Add(src)
		bubblesort_atom_name(Players)
		if(housecupwinner)
			src << "<b><font color=#CF21C0>[housecupwinner] is the House Cup winner for this month. They receive +25% gold/XP gained from monster kills.</font></b>"
		if(classdest)
			src << announcemsg("[curClass] class is starting. Click <a href=\"?src=\ref[usr];action=class_path;latejoiner=true\">here</a> for directions.")
		updateHPMP()
		spawn()
			//CheckSavefileVersion()
			if(istype(src.loc.loc,/area/arenas))
				src.loc = locate(50,22,15)
			src.ApplyOverlays()
			unreadmessagelooper()
			sql_update_ckey_in_table(src)
			sql_update_multikey(src)
			src.client.update_individual()
			if(global.clanwars && (src.Auror || src.DeathEater))
				src.ClanwarsInfo()
			winset(src,null,"barHP.is-visible=true;barMP.is-visible=true")

	proc/ApplyOverlays()
		src.overlays = list()
		if(Lwearing)
			var/mob/Player/var/list/tmpwearing = Lwearing
			Lwearing = list()
			for(var/obj/items/wearable/W in tmpwearing)
				spawn()W.Equip(src,1)
		spawn()if(src.away)src.ApplyAFKOverlay()

	verb
		Say(t as text)
			if(!usr.mute)
				if(usr.silence)
					src << "Your tongue is stuck to the roof of your mouth. You can't speak."
					return
				if(usr.Rictusempra==1)
					if(usr.Rictalk==1)
						return
					else
						hearers(client.view) << "[usr.name] tries to speak but only laughs uncontrollably."
						usr.Rictalk=1
						return
				else
					if(usr.spam<=5)
						if(t)
							t=check(t)//run the text through the cleaner
							t = copytext(t,1,500)
							if(copytext(t,1,5)=="\[me]")
								hearers(client.view)<<"[usr][copytext(t,5)]"
							else if(copytext(t,1,4)=="\[w]")
								if(name == "Deatheater")
									range(1)<<"<font size=2><font color=red><b><font color=red>[usr]</font> whispers: <i>[copytext(t,4)]</i>"
								else
									range(1)<<"<font size=2><font color=red><b>[Tag] <font color=red>[usr]</font> whispers: <i>[copytext(t,4)]</i>"

							else
								if(!(cmptext(t,"eat slugs") && (/mob/Spells/verb/Eat_Slugs in verbs)))
									for(var/mob/M in hearers(client.view))
										if(!M.muff)
											if(derobe)
												M<<"<font size=2><font color=red><b><font color=red> [usr]</font></b> :<font color=white> [t]"
											else
												M<<"<font size=2><font color=red><b>[Tag] <font color=red>[usr]</font> [GMTag]</b>:<font color=white> [t]"
										else
											if(rand(1,3)==1) M<<"<i>You hear an odd ringing sound.</i>"
							chatlog << "<font size=2 color=red><b>[usr]</b></font><font color=white> says '[t]'</font>"+"<br>"//This is what it adds to the log!
							if(t == ministrypw)
								if(istype(usr.loc,/turf/gotoministry))
									if(usr.name in ministrybanlist)
										view(src) << "<b>Toilet</b>: <i>The Ministry of Magic is not currently open to you. Sorry!</i>"
									else
										oviewers() << "[usr] disappears."
										if(usr.flying)
											usr.flying = 0
											usr.density = 1
											usr << "You've been knocked off your broom."
										var/obj/dest = locate("ministryentrance")
										for(var/client/C)
											if(C.eye)
												if(C.eye == usr && C.mob != usr)
													C << "<b><font color = white>Your Telendevour wears off.</font></b>"
													C.eye=C.mob
										usr.loc = dest
							if(usr.House == "Ministry")
								switch(lowertext(t))
									if("code black")
										var/area/ministry_of_magic/A = locate(/area/ministry_of_magic)
										if(A.code_black)
											A.code_black = 0
											for(var/mob/M in Players)
												if(M.Auror)
													M << "<b><font color=red>Ministry of Magic - Code Black cancelled</font></b>"
											if(!usr.Auror)
												usr << "<b><font color=red>Ministry of Magic - Code Black cancelled</font></b>"
										else
											for(var/mob/M in Players)
												if(M.Auror)
													M << "<b><font color=red>Ministry of Magic is under attack. Code Black initiated</font></b>"
											if(!usr.Auror)
												usr << "<b><font color=red>Ministry of Magic is under attack. Code Black initiated</font></b>"
											A.code_black = 1
											var/list/turf/seeds = list()
											for(var/turf/T in A)
												if(rand(1,13)==1)
													seeds += T
											var/obj/items/Smoke_Pellet/Pellet
											while(A.code_black)
												for(var/turf/T in seeds)
													Pellet = new(T)
													spawn(rand(1,30))Pellet.Explode()
												sleep(150)

									if("change ministry password")
										if(key=="Murrawhip")
											var/input = input("New password?", "Ministry Password", ministrypw) as null|text
											if(!input) return
											else
												ministrypw = input
											hearers() << "<b><font color=red>Password Changed</font></b>"
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

								if("eat slugs")
									if(/mob/Spells/verb/Eat_Slugs in verbs)
										usr:Eat_Slugs()
										return
								if("close hogwarts")
									if(src.admin)

										for(var/turf/Hogwarts_Exit/T in world)
											T.icon = 'Wall1.dmi'
											T.density = 1
										world<<"[usr] has closed Hogwarts"
										for(var/turf/Hogwarts/T in world)
											T.icon = 'Turf.dmi'
											T.icon_state = "grille"
											T.density = 1
								if("open event")
									if(src.admin)
										hearers()<<"Done."
										for(var/turf/Arena/T in world)
											T.icon = null
											T.density = 0
								if("close event")
									if(src.admin)
										hearers()<<"Done."
										for(var/turf/Arena/T in world)
											T.icon = 'Turf.dmi'
											T.icon_state = "grille"
											T.density = 1
								if("colloportus gate")
									if(src.Gm)
										sleep(20)
										hearers()<<"<font size=1>[usr] has locked the door</font>"
										for(var/turf/Gate/T in oview(5))
											T.door=0
											T.bumpable=0
								if("colloportus")
									if(src.Gm)
										sleep(20)
										hearers()<<"<font size=1>[usr] has locked the door</font>"
										if(classdest)
											usr << errormsg("Friendly reminder: Class guidance is still on.")
										for(var/obj/Hogwarts_Door/T in oview(client.view))
											T.door=0
											T.bumpable=0
								if("alohomora")
									if(src.Gm)
										sleep(20)
										view(client.view)<<"<font size=1>[usr] has unlocked the Door</font>"
										for(var/obj/Hogwarts_Door/T in oview(client.view))
											flick('Alohomora.dmi',T)
											T.door=1
											T.bumpable=1
								if("alohomora gate")
									if(src.Gm)
										sleep(20)
										hearers()<<"<font size=1>[usr] has unlocked the Door</font>"
										for(var/turf/Gate/T in oview())
											flick('Alohomora.dmi',T)
											T.door=1
											T.bumpable=1
											T.door=1
											T.bumpable=1
								if("quillis")
									if(src.Gm)
										for(var/obj/Desk/T in view(client.view))
											var/scroll = /obj/items/scroll
											flick('mist.dmi',T)
											new scroll(T.loc)
										hearers()<<"[usr] flicks \his wand, causing scrolls to appear on the desks."
								if("quillis deletio")
									if(src.Gm)
										for(var/obj/items/scroll/T in oview(client.view))
											flick('mist.dmi',T)
											del T
										hearers()<<"[usr] flicks \his wand, causing scrolls to vanish"

								if("disperse")
									if(src.Gm)
										for(var/turf/T in view(client.view))
											if(length(T.overlays))
												T.overlays += image('mist.dmi',layer=10)
												spawn(9)
													T.overlays = null
													T.density=initial(T.density)
									if(/mob/Spells/verb/Disperse in verbs)
										usr:Disperse()

								if("save me")
									src.Save()
									hearers()<<"[src] has been saved."
								if("save world")
									if(usr.admin)
										for(var/client/C)
											if(C.mob)C.mob.Save()
											//C<<"You've been automatically saved."
											sleep(1)
										Save_World()
										src<<infomsg("The world has been saved.")
								if("clear admin log")
									if(src.admin)
										src<<infomsg("The Logs have been deleted.")
										fdel("Logs/Adminlog.html")
								if("clear gold log")
									if(src.admin)
										src<<infomsg("The Logs have been deleted.")
										fdel("Logs/Goldlog.html")
								if("clear kill log")
									if(src.admin)
										src<<infomsg("The Logs have been deleted.")
										fdel("Logs/kill_log.html")
								if("clear event log")
									if(src.admin)
										src<<infomsg("The Logs have been deleted.")
										fdel("Logs/event_log.html")
								if("clear class log")
									if(src.admin)
										src<<infomsg("The class logs have been deleted.")
										fdel("Logs/classlog.html")
								if("clear radio log")
									if(src.admin)
										src<<infomsg("The radio logs have been deleted.")
										fdel("Logs/DJlog.html")
								if("clear log")
									if(src.admin)
										src<<infomsg("The Logs have been deleted.")
										fdel("Logs/chatlog.html")
								if("afk check")
									if(Gm)
										if(alert("AFK Check was last used about [round((world.realtime - lastusedAFKCheck) / 10 / 60)] minutes ago. Do you want to use it now?",,"Yes","No") == "Yes")
											src<<infomsg("Checking for AFK trainers, and disconnecting once found.")
											for(var/mob/A in world)
												if(A.key&&A.Gm)
													A << infomsg("[src] uses AFK Check")
											AFK_Train_Scan()
											src << infomsg("AFK Check Complete")
								if("disable ooc")
									if(src.Gm)
										OOCMute=1
										src<<infomsg("OOC has been disabled.")
								if("enable ooc")
									if(src.Gm)
										src<<infomsg("OOC Enabled.")
										OOCMute = 0
								if("access admin log files")
									if(src.admin==1)
										usr <<browse(file("Logs/Adminlog.html"))
										src<<infomsg("Access Granted.")
								if("access gold log files")
									if(src.admin==1)
										usr <<browse(goldlog)
										src<<infomsg("Access Granted.")
								if("access log files")
									if(src.admin==1)
										usr <<browse("<body bgcolor=\"black\"> [file2text(chatlog)]</body>","window=1")
										src<<infomsg("Access Granted.")
								if("restricto")
									if(src.Gm)
										hearers()<<"[usr] encases \himself within a magical barrier."
										for(var/turf/T in view(1))
											var/inflamari = /obj/Force_Field
											flick('mist.dmi',T)
											T.overlays += inflamari
											T.density=1
											T.invisibility=0
								if("restricto hellfire")
									if(src.admin)
										hearers()<<"[usr] encases \himself in magical flames."
										for(var/turf/T in view(1))
											var/inflamari = /obj/Inflamari
											T.overlays += inflamari
											T.density=1
											T.invisibility=0
								if("open up")
									if(src.Gm)
										sleep(10)
										hearers()<<"Access Granted. Welcome, [usr]."
										for(var/turf/Holoroom_Door/T in oview())
											T.door=1
											T.bumpable=1

											T.icon = 'ADoor.dmi'
											T.density = 1
											T.icon_state="closed"
											T.bumpable=1
											T.door=1
											T.opacity=0
								if("reservio")
									if(src.Gm)
										sleep(10)
										hearers()<<"Holoroom has been locked and secured."
										for(var/turf/Holoroom_Door/T in oview(5))
											T.door=1
											T.bumpable=1
											T.door=0
											T.bumpable=0
											T.density=1
											T.opacity=0
								if("open hogwarts")
									if(src.admin)
										for(var/turf/Hogwarts_Exit/T in world)
											T.icon = null
											T.density = 0
										for(var/turf/Hogwarts/T in world)
											T.icon = null
											T.density = 0
								if("clanevent1")
									if(src.admin)
										if(!clanevent1)
											clanevent1 = 1
											clanevent1_respawntime = input("Seconds before respawn of destroyed pillar?",,600)
											clanevent1_pointsgivenforpillarkill = input ("Number of points given for destroyed pillar?",,25)
											clanevent1_pointsgivenforkill = input ("Number of points given for player kill?",,1)
											var/MHP = input("Hits required to destroy pillar?",,100)
											for(var/obj/clanpillar/C in world)
												C.enable(MHP)
										else
											clanevent1 = 0
											for(var/obj/clanpillar/C in world)
												C.disable()
							if(cmptext(copytext(t, 1, 18),"restricto maxima "))
								if(src.Gm)
									hearers()<<"[usr] encases the area within a magical barrier."
									var/value = copytext(t, 18, 19)
									if(value == "") value = 5
									else if(text2num(value) < 1) value = 5
									else value = text2num(value)
									for(var/turf/T in (oview(value) - oview(value-1)))
										var/inflamari = /obj/Force_Field
										flick('mist.dmi',T)
										T.overlays += inflamari
										T.density=1
										T.invisibility=0
							usr.spam++
							spawn(30)
								usr.spam--
			else
				usr<<"You cannot send messages while you're muted!"
		OOC(T as text)
			set desc = "Speak on OOC"
			if(!usr.listenooc)
				usr << "Your OOC is turned off."
				return
			if(usr.mute)
				usr<<"You are muted."
				return
			if(OOCMute)

				usr<<"Access to the Communication System has been Restricted. A Game Master has disabled OOC. <p>You can check the status of OOC by saying 'Is OOC off?' out loud."
			else
				if(usr.spam<=5)
					if(!usr.MuteOOC)
						if(T)
							T = copytext(T,1,300)
							T = check(T)
							for(var/client/C)

								if(C.mob)if(C.mob.type == /mob/Player)if(C.mob.listenooc)
									if(usr.name=="Deatheater")
										C << "<b><font face='Comic Sans MS' color=green size=1>OOC></font></b><b><font size=2 color=#3636F5>[usr.prevname] [usr.GMTag]:</font></b> <font color=white size=2> [T]</font>"
									else
										C << "<b><font face='Comic Sans MS' color=green size=1>OOC></font></b><b><font size=2 color=#3636F5>[usr] [usr.GMTag]:</font></b> <font color=white size=2> [T]</font>"


							if(usr.name=="Deatheater")
								chatlog << "<font color=blue><b>[usr.prevname] (ROBED)</b></font><font color=green> OOC's '[T]'</font>"+"<br>"//This is what it adds to the log!
							else
								chatlog << "<font color=blue><b>[usr]</b></font><font color=green> OOC's '[T]'</font>"+"<br>"//This is what it adds to the log!
							usr.spam++
							spawn(30)
								usr.spam--
						else
							usr<<"Please enter something."
					else
						usr << errormsg("OOC is muted.")
				else
//					usr.Auto_Ban()
				//	else
				//		usr.Auto_Mute()




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
			for(var/mob/M in Players)
				online+=1
				if(!M.derobe)
					if(M.House)
						usr << "\icon[wholist[M.House]] <B><font color=blue><font size=1>Name:</font> </b><font color=white>[M.name]<font color=white></b>[M.status]  <b><font color=red>Key: </b>[M.key] <b><font size=1><font color=purple> Level: </b>[M.level]  <b><font color=green>Rank: </b>[M.Rank]</font> </SPAN></B>"
					else
						usr << "\icon[wholist["Empty"]] <B><font color=blue><font size=1>Name:</font> </b><font color=white>[M.name]<font color=white></b>[M.status]  <b><font color=red>Key: </b>[M.key] <b><font size=1><font color=purple> Level: </b>[M.level]  <b><font color=green>Rank: </b>[M.Rank]</font> </SPAN></B>"
				else
					if(M.House)
						usr << "\icon[wholist[M.House]] <B><font color=blue><font size=1>Name:</font> </b><font color=white>[M.prevname]<font color=white></b>[M.status]  <b><font color=red>Key: </b>[M.key] <b><font size=1><font color=purple> Level: </b>[M.level]  <b><font color=green>Rank: </b>[M.Rank]</font> </SPAN></B>"
					else
						usr << "\icon[wholist["Empty"]] <B><font color=blue><font size=1>Name:</font> </b><font color=white>[M.prevname]<font color=white></b>[M.status]  <b><font color=red>Key: </b>[M.key] <b><font size=1><font color=purple> Level: </b>[M.level]  <b><font color=green>Rank: </b>[M.Rank]</font> </SPAN></B>"
			usr << "[online] players online."
			var/logginginmobs = ""
			for(var/client/C)
				if(C.mob && !(Players.Find(C.mob)))
					if(logginginmobs == "")
						logginginmobs += "[C.key]"
					else
						logginginmobs += ", [C.key]"
			if(logginginmobs != "")
				usr << "Logging in: [logginginmobs]."


			/*for(M in world)
				if(M.key)
					if(!M.derobe)
						if(M.House)
							usr << "\icon[text2path("/obj/wholist/[M.House]")] <B><font color=blue><font size=1>Name:</font> </b><font color=white>[M.name]<font color=white></b>[M.status] <b><font color=red>Key: </b>[M.key] <b><font size=1><font color=purple> Level: </b>[M.level]  <b><font color=green>Rank: </b>[M.Rank]</font> </SPAN></B>"
						else
							usr << "\icon[text2path("/obj/wholist/Empty")] <B><font color=blue><font size=1>Name:</font> </b><font color=white>[M.name]<font color=white></b>[M.status] <b><font color=red>Key: </b>[M.key] <b><font size=1><font color=purple> Level: </b>[M.level]  <b><font color=green>Rank: </b>[M.Rank]</font> </SPAN></B>"

					else
						if(M.House)
							usr << "\icon[text2path("/obj/wholist/[M.House]")] <B><font color=blue><font size=1>Name:</font> </b><font color=white>[M.prevname]<font color=white></b>[M.status] <b><font color=red>Key: </b>[M.key] <b><font size=1><font color=purple> Level: </b>[M.level]  <b><font color=green>Rank: </b>[M.Rank]</font> </SPAN></B>"
						else
							usr << "\icon[text2path("/obj/wholist/Empty")] <B><font color=blue><font size=1>Name:</font> </b><font color=white>[M.prevname]<font color=white></b>[M.status] <b><font color=red>Key: </b>[M.key] <b><font size=1><font color=purple> Level: </b>[M.level]  <b><font color=green>Rank: </b>[M.Rank]</font> </SPAN></B>"


*/


		AFK()
			if(!usr.away)
				usr.away = 1
				usr.here=usr.status
				usr.status=" (AFK)"
				world<<"~ <font color=red>[usr]</font> is <u>AFK</u> ~"
				ApplyAFKOverlay()
			else
				usr.away = 0
				usr.status=usr.here
				usr.overlays-=image('AFK.dmi',icon_state="GM")
				usr.overlays-=image('AFK.dmi',icon_state="AFK2")
				usr.overlays-='AFK.dmi'
				world<<"<font color=red>[usr]</font> is no longer AFK."
mob
	proc/ApplyAFKOverlay()
		src.overlays-=image('AFK.dmi',icon_state="GM")
		src.overlays-=image('AFK.dmi',icon_state="AFK2")
		src.overlays-=image('AFK.dmi')
		var/mob/Player/user = usr
		if(src.Gm)
			src.overlays+=image('AFK.dmi',icon_state="GM")
		else if(locate(/obj/items/wearable/pimp_ring) in user.Lwearing)
			src.overlays+=image('AFK.dmi',icon_state="AFK2")
		else
			src.overlays+='AFK.dmi'
mob/Player
	Stat()
		if(statpanel("Stats"))
			stat("Name:",src.name)
			stat("Year:",src.Year)
			stat("Gold:",src.gold)
			stat("Level:",src.level)
			stat("HP:","[src.HP]/[src.MHP+src.extraMHP]")
			stat("MP:","[src.MP]/[src.MMP+src.extraMMP]")
			stat("House:",src.House)
			stat("EXP:","[src.Exp]/[src.Mexp]")
			stat("Stat points:",src.StatPoints)
			stat("Spell points:",src.spellpoints)
			if(admin)
				stat("CPU:",world.cpu)
			stat("---House points---")
			stat("Gryffindor",housepointsGSRH[1])
			stat("Slytherin",housepointsGSRH[2])
			stat("Ravenclaw",housepointsGSRH[3])
			stat("Hufflepuff",housepointsGSRH[4])
			if(src.Auror)
				stat("---Clan points---")
				stat("-Aurors-",housepointsGSRH[5])
			if(src.DeathEater)
				stat("---Clan points---")
				stat("-Deatheaters-",housepointsGSRH[6])
			stat("","")
			if(currentArena)
				if(currentArena.roundtype == HOUSE_WARS)
					stat("Arena:")
					stat("Gryffindor",currentArena.teampoints["Gryffindor"])
					stat("Slytherin",currentArena.teampoints["Slytherin"])
					stat("Hufflepuff",currentArena.teampoints["Hufflepuff"])
					stat("Ravenclaw",currentArena.teampoints["Ravenclaw"])
				else if(currentArena.roundtype == CLAN_WARS)
					stat("Arena:")
					stat("Aurors",currentArena.teampoints["Aurors"])
					stat("Deatheaters",currentArena.teampoints["Deatheaters"])
				else if(currentArena.roundtype == FFA_WARS)
					stat("Arena: (Players Alive)")
					for(var/mob/M in currentArena.players)
						stat("-",M.name)
		if(statpanel("Items"))
			for(var/obj/stackobj/S in contents)
				stat("Click to expand stacked items.")
				break
			for(var/obj/O in src.contents)
				if(istype(O,/obj/stackobj))
					stat("+",O)
					if(O:isopen)
						for(var/obj/B in O:contains)
							stat("-",B)
					//	stat(O:contains)//Display all the objects inside the stack obj
				else
					if(istype(src,/mob/Player))
						if(!src:stackobjects || !(src:stackobjects.Find(O.type))) //If there's NOT a stack object for this obj type, print it
							stat(O)
obj
	stackobj
		var/isopen=0
		var/containstype
		var/list/obj/contains = list()
		Click()
			if(src in usr)
				isopen = !isopen
		verb
			Drop_All()
				//var/tmpname = ""
				//var/isscroll=0
				for(var/obj/items/O in contains)
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
					O.Drop()
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

mob/proc/Resort_Stacking_Inv()
	if(!istype(src,/mob/Player))
		world.log << "[src] is of the wrong type ([src.type]) in /mob/proc/Resort_Stacking_Inv()"
		return
	var/list/counts = list()

	for(var/obj/O in contents)
		//if(istype(O,/Spell)) continue
		if(istype(O,/obj/stackobj))
			O.loc = null
		else
			counts[O.type]++
	if(length(counts))
		var/list/obj/stackobj/tmpstackobjects = list()
		for(var/V in counts)
			if(counts[V] > 1)
				var/obj/stackobj/stack = new()
				var/obj/tmpV = new V()
				stack.containstype = V
				if(src:stackobjects)
					if(src:stackobjects[V])
						var/obj/stackobj/tmpstack = src:stackobjects[V]
						stack.isopen = tmpstack.isopen
				stack.icon = tmpV.icon
				stack.icon_state = tmpV.icon_state
				stack.name = tmpV.name
				stack.suffix = "<font color=red>(x[counts[V]])</font>"
				contents += stack
				for(var/obj/O in contents)
					if(istype(O,stack.containstype))
						stack.contains += O
				tmpstackobjects[V] = stack
		src:stackobjects = tmpstackobjects
	else
		src:stackobjects = null
mob/proc/Check_Death_Drop()
	for(var/obj/drop_on_death/O in src)
		O.Drop()

mob/proc/Death_Check(mob/killer = src)
	killer.updateHPMP()
	src.updateHPMP()
	if(src.HP<1)
		if(src.player)
			Check_Death_Drop()
			for(var/turf/duelsystemcenter/T in duelsystems)
				if(T.D)
					if(T.D.player1 == src)
						range(8,T) << "<i>[T.D.player1] has lost the duel. [T.D.player2] is the winner!</i>"
						del T.D
					else if(T.D.player2 == src)
						range(8,T) << "<i>[T.D.player2] has lost the duel. [T.D.player1] is the winner!</i>"
						del T.D
			for(var/obj/portduelsystem/T in duelsystems)
				if(T.D)
					if(T.D.player1 == src)
						range(8,T) << "<i>[T.D.player1] has lost the duel. [T.D.player2] is the winner!</i>"
						del T.D
					else if(T.D.player2 == src)
						range(8,T) << "<i>[T.D.player2] has lost the duel. [T.D.player1] is the winner!</i>"
						del T.D
			if(src.arcessoing == 1)
				hearers() << "[src] stops waiting for a partner."
				src.arcessoing = 0
			else if(ismob(arcessoing))
				hearers() << "[src] pulls out of the spell."
				stop_arcesso()
			if(src.Detention)
				sleep(1)
				flick('teleboom.dmi',src)
				return
				//src<<"<b><font color=red>Advice:</b></font> You can't kill yourself to get out of detention. Attempt to do it again and all of your spells will be erased from your memory."
			if(src.Immortal==1)
				src<<"[killer] tried to knock you out, but you are immortal."
				killer<<"<font color=blue><b>[src] is immortal and cannot die.</b></font>"
				return
			if(src.monster==1)
				del src
				return
			if(istype(src.loc.loc,/area/hogwarts/Duel_Arenas))
				//src.edeaths+=1 BUG0000122
				src.followplayer=0
				src.HP=src.MHP+src.extraMHP
				src.MP=src.MMP+src.extraMMP
				src.updateHPMP()
				flick('mist.dmi',src)
				switch(src.loc.loc.type)
					if(/area/hogwarts/Duel_Arenas/Main_Arena_Bottom)
						src.loc=locate(29,13,22)
					if(/area/hogwarts/Duel_Arenas/Main_Arena_Top)
						src.loc=locate(29,13,22)
					if(/area/hogwarts/Duel_Arenas/Slytherin)
						src.loc=locate(20,89,21)
					if(/area/hogwarts/Duel_Arenas/Gryffindor)
						src.loc=locate(86,45,21)
					if(/area/hogwarts/Duel_Arenas/Ravenclaw)
						src.loc=locate(89,21,22)
					if(/area/hogwarts/Duel_Arenas/Hufflepuff)
						src.loc=locate(58,89,21)
					if(/area/hogwarts/Duel_Arenas/Duel_Class)
						src.loc=locate(45,82,23)
					if(/area/hogwarts/Duel_Arenas/Main_Arena_Lobby)
						var/obj/Bed/B = pick(Beds)
						src.loc = B.loc
						src.dir = SOUTH
				flick('dlo.dmi',src)
				src<<"<i>You were knocked out by <b>[killer]</b>!</i>"
				if(src.removeoMob) spawn()src:Permoveo()
				src.sight &= ~BLIND
				return
			if(src.loc.loc.type == /area/hogwarts/Hospital_Wing)
				src.HP=src.MHP+src.extraMHP
				src.updateHPMP()
				return
			if(src.loc.loc.type == /area/Underwater)
				src.edeaths+=1
				src.followplayer=0
				src.HP=src.MHP+src.extraMHP
				src.MP=src.MMP+src.extraMMP
				src.updateHPMP()
				flick('mist.dmi',src)
				src.loc=locate(8,8,9)
				flick('dlo.dmi',src)
				src<<"<i>You were knocked out by <b>[killer]</b>!</i>"
				if(src.removeoMob) spawn()src:Permoveo()
				src.sight &= ~BLIND
				return
			if(src.DuelRespawn==2)
				src.edeaths+=1
				src.followplayer=0
				src.HP=src.MHP+src.extraMHP
				src.MP=src.MMP+src.extraMMP
				src.updateHPMP()
				flick('mist.dmi',src)
				src.loc=locate(29,13,22)
				flick('dlo.dmi',src)
				src<<"<i>You were knocked out by <b>[killer]</b>!</i>"
				src.sight &= ~BLIND
				if(src.removeoMob) spawn()src:Permoveo()
				return


			if(src.DuelRespawn==3) //GRYFFINDOR
				src.edeaths+=1
				src.followplayer=0
				src.HP=src.MHP+extraMHP
				src.MP=src.MMP+extraMMP
				src.updateHPMP()
				flick('mist.dmi',src)
				src.loc=locate(87,39,21)
				flick('dlo.dmi',src)
				src<<"<i>You were knocked out by <b>[killer]</b>!</i>"
				src.sight &= ~BLIND
				if(src.removeoMob) spawn()src:Permoveo()
				return
			if(src.DuelRespawn==4) //RAVENCLAW
				src.edeaths+=1
				src.followplayer=0
				src.HP=src.MHP+extraMHP
				src.MP=src.MMP+extraMMP
				src.updateHPMP()
				flick('mist.dmi',src)
				src.loc=locate(56,25,21)
				flick('dlo.dmi',src)
				src<<"<i>You were knocked out by <b>[killer]</b>!</i>"
				src.sight &= ~BLIND
				if(src.removeoMob) spawn()src:Permoveo()
				return
			if(src.DuelRespawn==5) //SLYTHERIN
				src.edeaths+=1
				src.followplayer=0
				src.HP=src.MHP+extraMHP
				src.MP=src.MMP+extraMMP
				src.updateHPMP()
				flick('mist.dmi',src)
				src.loc=locate(15,92,21)
				flick('dlo.dmi',src)
				src<<"<i>You were knocked out by <b>[killer]</b>!</i>"
				src.sight &= ~BLIND
				if(src.removeoMob) spawn()src:Permoveo()
				return
			if(src.DuelRespawn==6) //HUFFLEPUFF
				src.edeaths+=1
				src.followplayer=0
				src.HP=src.MHP+extraMHP
				src.MP=src.MMP+extraMMP
				src.updateHPMP()
				flick('mist.dmi',src)
				src.loc=locate(60,95,21)
				flick('dlo.dmi',src)
				src<<"<i>You were knocked out by <b>[killer]</b>!</i>"
				src.sight &= ~BLIND
				if(src.removeoMob) spawn()src:Permoveo()
				return


			if(src.loc.loc.type in typesof(/area/arenas/MapThree/WaitingArea))
				killer << "Do not attack in the waiting area.."
				src.HP = src.MHP+extraMHP
				return
			if(src.loc.loc.type in typesof(/area/arenas/MapThree/PlayArea))
				if(currentArena)
					if(killer != src)
						range(5,currentArena.speaker) << "<b>Arena</b>: [killer] killed [src]."
						currentArena.players << "<b>Arena</b>: [killer] killed [src]."
					else
						range(5,currentArena.speaker) << "<b>Arena</b>: [killer] killed themself."
						currentArena.players << "<b>Arena</b>: [killer] killed themself."
					currentArena.players.Remove(src)
					src.HP=src.MHP+extraMHP
					src.MP=src.MMP+extraMMP
					src.updateHPMP()
					if(currentArena.players.len == 1)
						var/mob/winner
						for(var/mob/M in currentArena.players)
							winner = M
						view(8,currentArena.speaker) << "<b>Arena</b>: [winner] wins the round!"
						currentArena.players << "<b>Arena</b>: [winner] wins the round!"
						var/turf/T = pick(MapThreeWaitingAreaTurfs)
						winner.loc = T
						winner.density = 1
						for(var/mob/Z in view(8,currentArena.speaker))
							Z << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[Z];action=arena_leave\">clicking here.</a></b>"
						del(currentArena)
					else if(currentArena.players.len == 0)
						var/mob/winner
						winner = src
						view(8,currentArena.speaker) << "<b>Arena</b>: [winner] wins the round!"
						currentArena.players << "<b>Arena</b>: [winner] wins the round!"
						var/turf/T = pick(MapThreeWaitingAreaTurfs)
						winner.loc = T
						winner.density = 1
						for(var/mob/Z in view(8,currentArena.speaker))
							Z << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[Z];action=arena_leave\">clicking here.</a></b>"
						del(currentArena)
					var/turf/T = pick(MapThreeWaitingAreaTurfs)
					src.loc = T
					density = 1
					return
				else
					killer << "Do not attack before a round has started."
					src.HP = src.MHP+extraMHP
					return
			if(clanwars)
			//world clanwars
				if(killer.aurorrobe && src.DeathEater)
					src << "You were killed by [killer] of the Aurors."
					housepointsGSRH[5] += 1
				else if(killer.derobe && src.Auror)
					src << "You were killed by a [killer]."
					housepointsGSRH[6] += 1
			if(src.loc.loc.type in typesof(/area/arenas/MapTwo))
			/////CLAN WARS//////
				if(!(src.derobe && killer.derobe)&&!(src.aurorrobe && killer.aurorrobe))
					if(currentArena)
						if (currentArena.roundtype == CLAN_WARS)
							if(killer.aurorrobe)
								currentArena.Add_Point("Aurors",1)
								src << "You were killed by [killer] of the Aurors"
								killer << "You killed [src]"
							else if(killer.derobe)
								currentArena.Add_Point("Deatheaters",1)
								src << "You were killed by [killer]."
								killer << "You killed [src] of the Aurors"
				else if(src == killer)
					src << "You killed yourself!"
				else
					src << "You were killed by [killer], from your own team!"
					killer << "You killed [src] of your own team!"
				if(currentArena)
					if(currentArena.plyrSpawnTime > 0)
						src << "<i>You must wait [currentArena.plyrSpawnTime] seconds until you respawn.</i>"
				var/obj/Bed/B
				if(derobe)
					B = pick(Map2DEbeds)
				else if(aurorrobe)
					B = pick(Map2Aurorbeds)
				src.loc = B.loc
				src.dir = SOUTH
				if(currentArena)
					src.GMFrozen = 1
					spawn()currentArena.handleSpawnDelay(src)
				src.HP=src.MHP+extraMHP
				src.MP=src.MMP+extraMMP
				src.updateHPMP()
				return
			/////HOUSE WARS/////
			if(src.loc.loc.type in typesof(/area/arenas/MapOne))
				if(src.House != killer.House)
					if(currentArena)
						if(currentArena.roundtype == HOUSE_WARS && currentArena.started)
							currentArena.Add_Point(killer.House,1)
							src << "You were killed by [killer] of [killer.House]"
							killer << "You killed [src] of [src.House]"
				else if(src == killer)
					src << "You killed yourself!"
				else
					src << "You were killed by [killer], from your own team!"
					killer << "You killed [src] of your own team!"
				if(currentArena)
					if(currentArena.plyrSpawnTime > 0)
						src << "<i>You must wait [currentArena.plyrSpawnTime] seconds until you respawn.</i>"
				var/obj/Bed/B
				switch(House)
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
				if(currentArena)
					src.GMFrozen = 1
					spawn()currentArena.handleSpawnDelay(src)
				src.HP=src.MHP+extraMHP
				src.MP=src.MMP+extraMMP
				src.updateHPMP()
				return
			if(src.derobe)
				if(clanwars)
					if(src != killer)
						if(killer.aurorrobe&&src.DE)
							housepointsGSRH[5]+= clanevent1_pointsgivenforkill
				src.edeaths+=1
				src.gold = round(src.gold / 2)
				if(src.level < lvlcap)
					src.Exp = round(src.Exp / 2)
				src.followplayer=0
				src.status=""
				src.HP=src.MHP+extraMHP
				src.MP=src.MMP+extraMMP
				src.updateHPMP()
				flick('mist.dmi',src)
				var/obj/Bed/B = pick(DEBeds)
				src.loc = B.loc
				src.dir = SOUTH
				flick('dlo.dmi',src)
				if(src != killer)
					src<<"<I>You were knocked out by <b>[killer]</b>!"
					killer.pkills+=1
					if(killer.level < lvlcap)
						var/rndexp = src.level + rand(-200,200)
						if(rndexp < 0) rndexp = 27
						killer.Exp+=rndexp
						killer<<infomsg("You knocked [src] out and gained [rndexp] exp.")
						killer.LvlCheck()
					else
						killer<<infomsg("You knocked [src] out.")
				else
					src<<"<I>You knocked yourself out.</I>"
				src.sight &= ~BLIND
				return
			if(src.aurorrobe)
				if(clanwars)
					if(src != killer)
						if(killer.derobe&&src.Auror)
							housepointsGSRH[6]+= clanevent1_pointsgivenforkill
				src.edeaths+=1
				src.gold = round(src.gold / 2)
				if(src.level < lvlcap)
					src.Exp = round(src.Exp / 2)
				src.followplayer=0
				src.status=""
				src.HP=src.MHP+extraMHP
				src.MP=src.MMP+extraMMP
				src.updateHPMP()
				flick('mist.dmi',src)
				var/obj/Bed/B = pick(AurorBeds)
				src.loc = B.loc
				src.dir = SOUTH
				flick('dlo.dmi',src)
				if(src != killer)
					src<<"<I>You were knocked out by <b>[killer]</b>!"
					killer.pkills+=1
					if(killer.level < lvlcap)
						var/rndexp = src.level + rand(-200,200)
						if(rndexp < 0) rndexp = 27
						killer.Exp+=rndexp
						killer<<infomsg("You knocked [src] out and gained [rndexp] exp.")
						killer.LvlCheck()
					else
						killer<<infomsg("You knocked [src] out.")
				else
					src<<"<I>You knocked yourself out.</I>"
				src.sight &= ~BLIND
				return
			if(!src.Detention)
				Zitt = 0
				src.edeaths+=1
				src.followplayer=0
				src.gold = round(src.gold / 2)
				if(src.level < lvlcap)
					src.Exp = round(src.Exp / 2)
				src.HP=src.MHP+extraMHP
				src.MP=src.MMP+extraMMP
				src.updateHPMP()
				flick('mist.dmi',src)
				if(killer != src)
					if(killer.client && src.client && killer.loc.loc.name != "outside")
						if(killer.name == "Deatheater")
							if(src.name == "Deatheater")
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD - hh:mm:ss")]: [killer.prevname](DE robed) killed [src.prevname](DE robed): [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
							else
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD - hh:mm:ss")]: [killer.prevname](DE robed) killed [src]: [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
						else
							if(src.name == "Deatheater")
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD - hh:mm:ss")]: [killer] killed [src.prevname](DE robed): [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
							else
								file("Logs/kill_log.html") << "[time2text(world.realtime,"MMM DD - hh:mm:ss")]: [killer] killed [src]: [src.loc.loc](<a href='?action=teleport;x=[src.x];y=[src.y];z=[src.z]'>Teleport</a>)<br>"
					src<<"<i>You were knocked out by <b>[killer]</b> and sent to the Hospital Wing!</i>"
				src.loc=locate(20,15,21)
				var/obj/Bed/B = pick(Beds)
				src.loc = B.loc
				src.dir = SOUTH
				flick('dlo.dmi',src)

				src.sight &= ~BLIND
				if(src.flying)
					var/mob/Player/caster = src
					for(var/obj/items/wearable/brooms/Broom in caster.Lwearing)
						Broom.Equip(caster,1)
				if(src.removeoMob) spawn()src:Permoveo()
			if(killer.player)
				if(killer != src)
					killer.pkills+=1
					if(killer.level < lvlcap)
						var/rndexp = src.level + rand(-200,200)
						if(rndexp < 0) rndexp = 27
						killer.Exp+=rndexp
						killer<<infomsg("You knocked [src] out and gained [rndexp] exp.")
						killer.LvlCheck()
					else
						killer<<infomsg("You knocked [src] out!")
				else
					src<<"You knocked yourself out!"

		else
			if(killer.client)
				killer.AddKill(src.name)
				if(killer.MonsterMessages)killer<<"<i><small>You knocked [src] out!</small></i>"

				killer.ekills+=1
				killer.ratpoints+=src.ratpoints
				var/gold2give = round((rand(7,14)/10)*gold)
				var/exp2give = round((rand(9,14)/10)*Expg)

				if(killer.House == housecupwinner)
					gold2give *= 1.25
					exp2give *= 1.25
				gold2give = round(gold2give)
				exp2give = round(exp2give)
				killer.gold+=gold2give
				if(killer.level < lvlcap)
					killer.Exp+=exp2give
					killer.addReferralXP(Exp)
				killer.gold = round(killer.gold)
				if(killer.level < lvlcap)
					killer.Exp = round(killer.Exp)
				killer.Texp+=src.Expg
				if(killer.MonsterMessages)
					if(killer.level < lvlcap)
						killer<<"<i><small>You gained [exp2give] exp and [gold2give] gold.</small></i>"
					else
						killer<<"<i><small>You gained [gold2give] gold.</small></i>"
				if(killer.level < lvlcap)
					killer.LvlCheck()
			if(src.type == /mob/Dementor_||src.type == /mob/Snake_ ||src.type == /mob/Bird_||src.type == /mob/Slug)
				del src
				return ..()
			//else Statpoints for monster killz.
			//	if(rand(1,80)==1 && killer.client)
			//		killer.verbs.Add(/mob/Player/verb/Use_Statpoints)
			//		killer.StatPoints++
			src.loc=locate(0,0,0)
			Respawn(src)
/*		Auto_Mute()
			src.mute=1//adds them to the muted list
			world << "<b><Font face='Comic Sans MS'>HGM Security: <Font color=green><Font face='Comic Sans MS'>[src] has been auto-muted for 5 minutes for spamming.</b>"
			spawn(300) if(src.mute){src.mute=0;world << "<b>HGM Security: <font color=green>[src] has been auto-unmuted.</font></b>"}

		Auto_Ban()
			world<<"<B><Font face='Comic Sans MS'>HGM Security: <Font color=green><Font face='Comic Sans MS'>[src] has been automatically banned for Spamming on the main chat channel."
			usr.client.FullBan(usr.key,usr.client.address)
*/

	//	damageblock()
	//		src.HP-=(src.HP/8)


mob/proc/resetStatPoints()
	src.StatPoints = src.level - 1
	src.extraMHP = 0
	src.extraMMP = 0
	src.extraDmg = 0
	src.extraDef = 0
	src.Dmg = (src.level - 1) + 5
	src.Def = (src.level - 1) + 5
	src.MHP = 4 * (src.level - 1) + 200 + 2 * (src.Def + src.extraDef)
	src.verbs.Add(/mob/Player/verb/Use_Statpoints)
mob/proc/resetMaxHP()
	src.MHP = 4 * (src.level - 1) + 200 + 2 * (src.Def + src.extraDef)
mob
	proc
		LvlCheck(var/fakelevels=0)
			if(src.Exp>=src.Mexp)
				src.level++
				var/MPplus=rand(2,10)
			//	src.MHP+=HPplus
				src.HP=src.MHP+extraMHP
				src.MMP+=MPplus
				src.MP=src.MMP+extraMMP
				src.updateHPMP()
				src.Dmg+=1
				src.Def+=1
				src.resetMaxHP()
				//src.Expg=src.Texp
				src.Exp=0
				src.verbs.Remove(/mob/Player/verb/Use_Statpoints)
				src.verbs.Add(/mob/Player/verb/Use_Statpoints)
				src.StatPoints++
				if(src.Mexp<2000)
					src.Mexp*=1.5
				else if(src.Mexp>2000)
					src.Mexp+=500
				Mexp = round(Mexp)
				if(!fakelevels)
					src<<"<b><font color=blue>You are now level [src.level]!</font></b>"
				//	src<<"HP increased by [HPplus]."
				//	src<<"MP increased by [MPplus]."
				//	src<<"Damage increased by [Dmgplus]."
				//	src<<"Defense increased by [Defplus]."
					src<<"You have gained a statpoint."
				var/theiryear = (src.Year == "Hogwarts Graduate" ? 8 : text2num(copytext(src.Year, 1, 2)))
				if(src.level>1 && src.level < 16)
					src.Year="1st Year"
				if(src.level>15 && theiryear < 2)
					src.Year="2nd Year"
					src<<"<b>Congratulations, you are now on your Second Year at Hogwarts.</b>"
					src<<infomsg("You learned how to cancel transfigurations!")
					src.verbs += /mob/Spells/verb/Self_To_Human
				if(src.level>15 && !(/mob/Spells/verb/Self_To_Human in verbs))
					src<<infomsg("You learned how to cancel transfigurations!")
					src.verbs += /mob/Spells/verb/Self_To_Human
				if(src.level>50 && theiryear < 3)
					src.Year="3rd Year"
					src<<"<b>Congratulations on attaining your 3rd Year rank promotion!</b>"
					src.verbs += /mob/Spells/verb/Episky
					src<<"<b><font color=green><font size=3>You learned Episkey."
				if(src.level>100 && theiryear < 4)
					src.Year="4th Year"
					src<<"<b>Congratulations to [src]. You are now a 4th Year."
					src.verbs += /mob/Spells/verb/Self_To_Dragon
					src<<"<b><font color=green><font size=3>You learned how to Transfigure yourself into a fearsome Dragon!"
				if(src.level>200 && theiryear < 5)
					src.Year="5th Year"
					src<<"<b>Congratulations to [src]. You are now a 5th Year."
				if(src.level>300 && theiryear < 6)
					src.Year="6th Year"
					src<<"<b>Congratulations to [src]. You are now a 6th Year."
				if(src.level>400 && theiryear < 7)
					src.Year="7th Year"
					src<<"<b>Congratulations to [src]. You are now a 7th Year."
				if(src.level>500 && theiryear < 8)
					src.Year="Hogwarts Graduate"
					src<<"<b><font color=red>Notice:</font> Congratulations, [src]! You have graduated from Hogwarts and attained the rank of Hogwarts Graduate."
mob/Mailman
	icon='Misc Mobs.dmi'
	icon_state="Mailman"
	density=1
	NPC=1
	player=1
	Gm=1
	verb
		Examine()
			set src in oview(3)
			usr << "Your friendly neighborhood Mail man!!"
mob/Banker
	icon_state="goblin1"
	icon = 'misc.dmi'
	NPC = 1
	Gm = 1
	player=1
	Immortal=1
	density=1
	New()
		..()
		icon_state = "goblin[rand(1,3)]"
	verb
		Examine()
			set src in oview(3)
			usr << "He looks like a trustworthy person to hold my money."
		Talk()
			set src in oview(3)
			if( (locate(/obj/items/freds_key) in usr) && usr.talkedtofred!=2)
				switch(input("How may I help you?","Banker")in list("Deposit","Withdraw","Balance","I'd like to withdraw something from Fred's vault"))
					if("I'd like to withdraw something from Fred's vault")
						alert("You hand the banker the key")
						switch(input("And what would you like to withdraw?","Banker")in list("Wand of Interuption","Cancel"))
							if("Wand of Interuption")
								alert("The banker takes the key and unlocks a small compartment under his desk.")
								alert("He pulls out a box, and removes the wand from it")
								alert("The banker hands you the wand")
								if(usr.talkedtofred!=2)
									new/obj/items/wearable/wands/interruption_wand(usr)
									usr.Resort_Stacking_Inv()
								usr.talkedtofred=2

							if("Cancel")
								return
					if("Deposit")
						set src in oview(2)
						var/heh = input("You have [usr.gold] gold. How much do you wish to deposit?","Deposit",usr.gold) as null|num
						if(heh==null)return
						if (heh < 0)
							alert("Don't try cheating me!","Bank Keeper")
							return()
						if (heh > usr.gold)
							alert("You don't have that much!", "Deposit")
							return()
						if(get_dist(usr,src)>4)return
						usr << "You deposit [heh] gold."
						usr.gold -= heh
						usr.goldinbank += heh
						usr << "You now have [usr.goldinbank] gold in the bank."
						return()

					if("Withdraw")
						set src in oview(2)
						var/heh = input("You have [usr.goldinbank] gold in the bank. How much do you wish to withdraw?","Withdraw",usr.goldinbank) as null|num
						if(heh==null)return
						if (heh < 0)
							alert("Don't try cheating me!","Bank Keeper")
							return()
						if (heh > usr.goldinbank)
							alert("You don't have that much in your bank account!", "Bank Keeper")
							return()
						if(get_dist(usr,src)>4)return
						usr << "You withdraw [heh] gold."
						usr.gold += heh
						usr.goldinbank -= heh
						usr << "You now have [usr.goldinbank] gold in the bank."
						return()

					if("Balance")
						set src in oview(2)
						usr << "You have [usr.goldinbank] gold in the bank."

			else
				switch(input("How may I help you?","Banker")in list("Deposit","Withdraw","Balance"))
					if("Deposit")
						set src in oview(2)
						var/heh = input("You have [usr.gold] gold. How much do you wish to deposit?","Deposit",usr.gold) as null|num
						if(heh==null)return
						if (heh < 0)
							alert("Don't try cheating me!","Bank Keeper")
							return()
						if (heh > usr.gold)
							alert("You don't have that much!", "Deposit")
							return()
						if(get_dist(usr,src)>4)return
						usr << "You deposit [heh] gold."
						usr.gold -= heh
						usr.goldinbank += heh
						usr << "You now have [usr.goldinbank] gold in the bank."
						return()

					if("Withdraw")
						set src in oview(2)
						var/heh = input("You have [usr.goldinbank] gold in the bank. How much do you wish to withdraw?","Withdraw",usr.goldinbank) as null|num
						if(heh==null)return
						if (heh < 0)
							alert("Don't try cheating me!","Bank Keeper")
							return()
						if (heh > usr.goldinbank)
							alert("You don't have that much in your bank account!", "Bank Keeper")
							return()
						if(get_dist(usr,src)>4)return
						usr << "You withdraw [heh] gold."
						usr.gold += heh
						usr.goldinbank -= heh
						usr << "You now have [usr.goldinbank] gold in the bank."
						return()

					if("Balance")
						set src in oview(2)
						usr << "You have [usr.goldinbank] gold in the bank."


obj
	Bank
		Vault
			icon = 'vault.dmi'
			density=1
			accioable=0
			dontsave = 1
			verb
				Examine()
					set src in oview(3)
					usr << "I wonder how everything I have fits into this vault..."
				Bank()
					set src in oview(3)

					if(!usr.bank)
						usr.bank = new/BankClass
					switch(alert("Would you like to deposit or withdraw an item?","Banking", "Deposit", "Withdraw"))

						if("Deposit")
							var/list/obj/inventory = list()
							for(var/obj/O in usr.contents)
								if(!istype(O,/obj/stackobj))
									inventory += O
							var/obj/O = input("Which item would you like to deposit?") as null|obj in inventory
							if(O)
								if(get_dist(usr,src)>4)return
								if(!(O in usr))return
								usr.bank.DepositItem(O)
								usr << "You have deposited [O.name]!"
								usr:Resort_Stacking_Inv()
						else if("Withdraw")
							var/obj/O = input("Which item would you like to withdraw?") as null|obj in usr.bank.GetItems()
							if(O)
								if(get_dist(usr,src)>4)return
								usr.bank.WithdrawItem(O)
								usr << "You have withdrawn [O.name]!"
								usr:Resort_Stacking_Inv()

BankClass
	var
		balance = 0
		list/items = list()
	proc
		GetBalance()
			return src.balance

		DepositMoney(var/num)
			src.balance += num
			return num

		WithdrawMoney(var/num)
			balance -= num
			return num

		DepositItem(var/obj/O)
			src.items.Add(O)
			usr.contents.Remove(O)

		WithdrawItem(var/obj/O)
			src.items.Remove(O)
			usr.contents.Add(O)

		GetItems()
			return src.items


mob
	var
		BankClass/bank = null

obj/Bed
	icon='turf.dmi'
	icon_state="Bed"
	density=0
	dontsave=1
	verb
		Sleep()
			set src in oview(1)
			switch(input("Recover?","Bed")in list("Yes","No"))
				if("Yes")
					if(get_dist(src,usr)>1)return
					usr<<"You go to sleep."
					usr.sight = 1
					usr.HP=usr.MHP+usr.extraMHP
					usr.MP=usr.MMP+usr.extraMMP
					usr.updateHPMP()
					sleep(100)
					if(usr)
						usr.sight = 0
						usr<<"You feel much better."




//VARS
//appearance
mob/var/Detention=0
mob/var/Rank=""
mob/var/Immortal=0
mob/var/Disperse
mob/var/Aero
obj/var/accioable=0
obj/var/clothes
mob/var/DeathEater=0

mob/var/MuteOOC=0

mob/var/Year=""
mob/var/Teleblock=0
mob/var/House
mob/var/Auror=0
mob/var/DE=0
mob/var/Tag=null
mob/var/GMTag=null
mob/var/HA
mob/var/HDE=0

obj/var/dontsave=0
//others
mob/var/base_num_characters_allowed=0
mob/var/level=1
mob/var/Dmg=5
mob/var/Def=5
mob/var/HP=200
mob/var/MHP=200
mob/var/MP=10
mob/var/MMP=10

mob/var/Mexp=5
mob/var/Exp=0
mob/var/Expg=1
mob/var/draganddrop=0
mob/var/picon=null
mob/var/Texp=0
mob/var/NPC=1
mob/var/mute=0
mob/var/listenooc=1
mob/var/listenhousechat=1
mob/var/player=1
mob/var/gold=0
mob/var/goldg=1
mob/var/goldinbank=100

mob/var/monster=0
mob/var/follow=0
mob/var/attack=0
mob/var/wander=0
mob/var/tmp/away=0
mob/var/followplayer=0
mob/var/rank=0
mob/var/description="No extra information provided."
//mob/var/summonable=0
mob/var/skills=0
mob/var/item=0
mob/var/location
mob/var/turf
mob/var/tmp/status=""
mob/var/here=""
mob/var/potion=0
mob/var/ether=0
mob/var/notmonster=1
mob/var/edeaths=0
mob/var/ekills=0
mob/var/pdeaths=0
mob/var/pkills=0
mob/var/carry=0
mob/var/Gm=0

mob/var/StatPoints=0



var/mob/HA=0
obj/var/picon=null
obj/var/value=0
obj/var/lastx
obj/var/lasty
obj/var/lastz

obj/var/damage=0
obj/var/tmp/mob/owner

var/autoheal=0
//playerhouses

var
	Flash = 0
	System = 0

mob/var/tmp
	spam=0
//layers
var/const
	clothes=MOB_LAYER+1
	Mail=MOB_LAYER+2
	head=MOB_LAYER+3
	ears=MOB_LAYER+4
	cape=MOB_LAYER+5
	weapon=MOB_LAYER+6




area/blockeast
	icon='turf.dmi'
	icon_state="block"
	density=0
	Entered()
		if(usr.monster==1)
			usr.density=0
			step(usr,EAST)
			step(usr,EAST)
			usr.density=1
			return
		else
			return
area/blockup
	icon='turf.dmi'
	icon_state="block"
	density=0
	Entered()
		if(usr.monster==1)
			usr.density=0
			step(usr,NORTH)
			step(usr,NORTH)
			usr.density=1
			return
		else
			return
area/blockwest
	icon='turf.dmi'
	icon_state="block"
	density=0
	Entered()
		if(usr.monster==1)
			usr.density=0
			step(usr,WEST)
			step(usr,WEST)
			usr.density=1
			return
		else
			return
area/blocksouth
	icon='turf.dmi'
	icon_state="block"
	density=0
	Entered()
		if(usr.monster==1)
			usr.density=0
			step(usr,SOUTH)
			step(usr,SOUTH)
			usr.density=1
			return
		else
			return

//mob/Madam_Pomfrey
//	icon = 'Pomfrey.dmi'
//	NPC = 1
//	player=0
//	verb
//		Heal()
//			set src in oview(1)
//
//			switch(input("Would you like me to heal you?","Madam Pomfrey the Nurse")in list("Yes, Please.","No Thanks."))
///				if("Yes, Please.")
	//				usr<<"<b><font color=green>Madam Pomfrey:</font><font color=aqua> Episky!"
	//				usr.overlays+=image('attacks.dmi',icon_state="heal")
	//				usr.HP=usr.MHP
	//				usr.status=""
	//				sleep(10)
	//				usr.overlays-=image('attacks.dmi',icon_state="heal")
	//			if("No Thanks.")
	//				usr<<"Madam Pomfrey:  Very well then. Off you go."

obj/Table
	icon = 'desk.dmi'
	icon_state="S1"
	density=1
	dontsave=1
	verb
		Examine()
			set src in oview(1)
			switch(input("What would you like to do?","Table")in list("Examine","Search"))
				if("Examine")
					usr<<"Just an old table."
				if("Search")
					usr<<"You dont find anything useful."




obj
	chairleft
		icon='turf.dmi'
		icon_state="cleft"
		density=0

	chairright
		icon='turf.dmi'
		icon_state="cright"
		density=0

	chairback
		icon='turf.dmi'
		icon_state="cback"
		density=0
		layer = MOB_LAYER +3
	chairfront
		icon='turf.dmi'
		icon_state="cfront"
		density=0

obj/Gate
	icon = 'turf.dmi'
	icon_state="gate"
	density=1




obj/BFrontChair
	icon='Chairs.dmi'
	icon_state="front"
proc
	textcheck(t as text)
	// Returns the text string with all potential html tags (anything \
		between < and >) removed.
		t="[html_encode(t)]"
		var/open = findtext(t,"\<")
		while(open)
			var/close = findtext(t,"&gt;",open)
			if(close)
				if(close < lentext(t))
					t = copytext(t,1,open)+copytext(t,close+4)//+copytext(t,close+1)
				else
					t = copytext(t,1,open)
				open = findtext(t,"\<")
			else
				open = 0
		return t
	Respawn(mob/NPC/E)
		if(!E)return
		if(E.removeoMob)
			var/tmpmob = E.removeoMob
			E.removeoMob = null
			spawn()tmpmob:Permoveo()
		if(!istype(E,/mob/NPC/Enemies))
			E.loc = null
		else
			E.activated = 0
			spawn(1200)////1200
				if(E)
					E.loc = E.origloc
					E.HP = E.MHP
					for(var/mob/A in E.loc.loc)
						if(A.key)
							E.Wander()
							return
					walk(E,0)
					walk_rand(E,11)
					/*if(E)
						E.loc = initial(E.loc)
						if(istype(E,/mob/NPC/Enemies))
							E.activated = 0
							for(var/mob/M in E.loc.loc)
								if(M.key)
									E.Wander()
									return*/



turf
	walltorch_housewars
		name = "walltorch"
		icon='turf.dmi'
		icon_state="w2"
		density=1
		verb
			Pull()
				set src in oview(1)
				switch(input("Pull the Torch?","Pull the Torch?")in list("Yes","No"))
					if("Yes")
						alert("You pull the torch and a secret door opens")
						for(var/turf/secretdoor/T in world)
							flick("opening",T)
							T.icon_state = "open"
							density = 0
							T.bumpable = 1
							opacity = 0
							sleep(70)
							flick("closing",T)
							T.icon_state = "closed"
							density = 1
							opacity = 1
							T.bumpable=0
					if("No")
						return

turf
	statdoor
		name = "Hogwarts Stone Wall"
		icon='door1.dmi'
		density=1
		icon_state="closed"
		verb
			Unlock()
				set src in oview(1)
				if(locate(/obj/items/freds_key) in usr)
					alert("You pull out Fred's Key and use it to unlock the door.")
					for(var/turf/statdoor/T in world)
						flick("opening",T)
						T.icon_state = "open"
						density = 0
						T.bumpable = 1
						opacity = 0
						sleep(70)
						flick("closing",T)
						T.icon_state = "closed"
						density = 1
						opacity = 1
						T.bumpable=0
				else
					usr << errormsg("There is a keyhole, however you do not have the required key...the shape does look like a familiar key though.")
obj
	gargoyle
		icon='turf.dmi'
		icon_state="bg"
		density=1
	gargoyle2
		icon='turf.dmi'
		icon_state="tg"
		density=0
		layer = MOB_LAYER + 1
	gargoylerighttop
		icon='turf.dmi'
		icon_state="tright"
		density=0
		layer = MOB_LAYER + 1
	gargoylerightbottom
		icon='COMC Icons.dmi'
		icon_state="statue 2"
		density=1
	gargoyleleftbottom
		icon = 'COMC Icons.dmi'
		icon_state = "statue 1"
		density = 1
//TURFS
turf
	layer=TURF_LAYER
	icon='turf.dmi'
	grass
		icon_state="grass1"
		name = "snow"

		//icon_state="snow"
		density=0
	curtain1
		icon_state="c1"
		density=0
	curtain2
		icon_state="c2"
		density=0
	curtain3
		icon_state="c3"
		density=0
	curtain4
		icon_state="c4"
		density=0
	woodenfloorblack
		icon_state = "wood - halloween"
		density = 0
		New()
			..()
			var/randnum = rand(1,8)
			spawn(1)
				if(randnum==2)
					src.icon_state="wood2 - halloween"
				else if(randnum==3)
					src.icon_state="wood3 - halloween"
				else if(randnum==4)
					src.icon_state="wood4 - halloween"
				else if(randnum==5)
					src.icon_state="wood5 - halloween"
				else if(randnum==6)
					src.icon_state="wood6 - halloween"
				else if(randnum==7)
					src.icon_state="wood7 - halloween"
				else if(randnum==8)
					src.icon_state="wood8 - halloween"
	woodenfloor
		//icon_state="wood"
		icon_state = "wood"
		density=0
		New()
			..()
			var/randnum = rand(1,8)
			spawn(1)
				if(randnum==2)
					src.icon_state="wood2"
				else if(randnum==3)
					src.icon_state="wood3"
				else if(randnum==4)
					src.icon_state="wood4"
				else if(randnum==5)
					src.icon_state="wood5"
				else if(randnum==6)
					src.icon_state="wood6"
				else if(randnum==7)
					src.icon_state="wood7"
				else if(randnum==8)
					src.icon_state="wood8"


	longtable1
		icon='longtables.dmi'
		icon_state="x"
		density=1
	longtable2
		icon='longtables.dmi'
		icon_state="y"
		density=1
	longtable3
		icon='longtables.dmi'
		icon_state="z"
		density=1
	bluealert
		icon='bluealert.dmi'
		density=0
	//plate
	//	icon='turf.dmi'
	//	icon_state="plate"
	//	density=1
	candle
		icon_state="wood"
		density=0
	wfloor
		icon_state="wfloor"
		density=0
	painting1
		icon_state="p1"
		density=0
		opacity=0
	Art
		icon='Decoration.dmi'
		icon_state="royal top1"
		density=1
		opacity=0
	Art1
		icon='Decoration.dmi'
		icon_state="royal1"
		density=1
		opacity=0
	Art_Man
		icon='Decoration.dmi'
		icon_state="royal top"
		density=1
		opacity=0
	Art_Man2
		icon='Decoration.dmi'
		icon_state="royal"
		density=1
		opacity=0
	Art_Tree
		icon='Decoration.dmi'
		icon_state="tree top"
		density=1
		opacity=0
	Art_Tree2
		icon='Decoration.dmi'
		icon_state="tree"
		density=1
		opacity=0
	painting2
		icon_state="p2"
		density=0
		opacity=0
	painting3
		icon_state="p3"
		density=0
	painting4
		icon_state="p4"
		density=0
	wwall
		icon='wall1.dmi'
		icon_state="wwall"
		density=1
		opacity=0
	holoalertfloor
		icon_state="wood"
		density=0
	clights
		icon_state="lights"
		density = 1
	cane
		//icon_state="cane"
		density=0
	roof
		icon_state="roof"
		density=1
	roofpass
		icon_state="roof"
		density=0
		layer=MOB_LAYER+7
	water
		icon='turf.dmi'
		icon_state="waterreal"
		name = "Ice"
		density=0
		Enter(atom/movable/O, atom/oldloc)
			if(ismob(O) && O.density) return 1 // CHANGE TO return 0 FOR NON-WINTER
			else
				return ..()

	floor
		icon_state="brick"
		density=0
	roofb
		icon_state="broof"
		density=1
		opacity=1
		flyblock=1
	diamondt
		icon_state="tf2"
		density=0
	brick
		icon='hogwartsbrick.dmi'
		icon_state="brick2"
		density=1
	floor1
		icon_state="floor1"
		density=0
	floor2
		icon_state="floor2"
		density=0
	boat
		icon_state="boat"
		density=1
	door
		icon_state="door"
		density=1
	fence
		icon_state="hpfence"
		density=1
	woodenwall
		icon_state="wooden"
		density=1
	dirtwall
		icon_state="dirtwall"
		density=1
	dirtroof
		icon_state="dirtroof"
		density=1
	dirtroofpass
		icon_state="dirtwall"
		density=0
		layer=MOB_LAYER+7
	woodenspike
		icon_state="woodenspike"
		density=0
		layer=MOB_LAYER+7
	road
		icon_state="road"
		density=0
	niblets
		icon_state="nibletsign"
		density=1
	stone
		icon_state="stone"
		density=1
	downfence
		icon_state="post"
		density=1
	waterfall
		icon_state="waterfall"
		density=0
	gmdoor
		icon_state="gmdoor"
		density=1
	turnup
		icon_state="turnup"
		density=1
	turnupfence
		icon_state="turnupleft"
		density=1
	turndown
		icon_state="turndown"
		density=1
	turndownfence
		icon_state="turndownright"
		density=1
	shopsign
		icon_state="shop"
		density=1
	rock
		icon_state="rock"
		density=1
	toprock
		icon_state="toprock"
		density=0
	toprockright
		icon_state="toprockright"
		density=1
	toprockleft
		icon_state="toprockleft"
		density=1
	snowtop
		icon_state="topsnow"
		density=0
	snowtopup
		icon_state="topsnowup"
		density=0
	snowtopleft
		icon_state="topsnowleft"
		density=0
	snowtopright
		icon_state="topsnowright"
		density=0
	black
		icon_state="black"
		density=0
	blankturf
		icon_state="black"
		density=0
	boat1
		icon_state="1"
		density=1
	boat2
		icon_state="2"
		density=1
	boat3
		icon_state="3"
		density=1
	boat4
		icon_state="4"
		density=1
	boat5
		icon_state="5"
		density=1
	boat6
		icon_state="6"
		density=1
	boat7
		icon_state="7"
		density=1
	boat8
		icon_state="8"
		density=1
	blackfloor
		icon_state="blackfloor"
		density=0
	boat9
		icon_state="9"
		density=1
	boat10
		icon_state="10"
		density=1
	boat11
		icon_state="11"
		density=1
	boat12
		icon_state="12"
		density=1
	boat13
		icon_state="13"
		density=1
	boat14
		icon_state="14"
		density=1
	counter
		icon_state="counter"
		density=1
	counterlef
		icon_state="counterleft"
		density=1
	counterright
		icon_state="counterright"
		density=1
	greathalltable
		icon_state="ghtable"
		density=1
	signitem
		icon_state="itemsign"
		density=1
	signweapon
		icon_state="weaponsign"
		density=1
	signbead
		icon_state="bedsign"
		density=1
	signboat
		icon_state="boatsign"
		density=1
	signblacksmith
		icon_state="bssign"
		density=1
	signplayer
		icon_state="plsign"
		density=1
	beacheast
		icon_state="beacheast"
		density=0
	beachwest
		icon_state="beachwest"
		density=0
	beachnorth
		icon_state="beachnorth"
		density=0
	beachsouth
		icon_state="beachsouth"
		density=0
	beachsidesoutheast
		icon_state="beachsoutheast"
		density=0
	beachsidesouthwest
		icon_state="beachsouthwest"
		density=0
	beachsidenortheast
		icon_state="beachnortheast"
		density=0
	beachsidenorthwest
		icon_state="beachnorthwest"
		density=0
	bcornernw
		icon_state="bnw"
		density=0
	bcornerne
		icon_state="bne"
		density=0
	bcornerse
		icon_state="bse"
		density=0
	bcornersw
		icon_state="bsw"
		density=0
	cactus
		icon_state="cactus"
		density=1
	gryffindorfloor
		icon_state="gred"
		density=0

	redroses
		icon_state="redplant"
		density=1
	tree
		icon='Trees.dmi'
		icon_state="tree1"
		density=1
		opacity=0
//	tree
//		density=1
//		opacity=0
	bush
		icon_state="bush"
		density=0
		layer=MOB_LAYER+1
	flower
		icon_state="flower"
		density=1
		layer=MOB_LAYER+1
	stump
		icon_state="stump"
		density=1
	bench
		icon_state="bench"
		density=0
	benche
		icon_state="benche"
		density=0
	sign
		icon='statues.dmi'
		icon_state="sign"
		density=1
	ice
		icon_state="ice"
		density=0
	snow
		icon='turf.dmi' //**ORIGINAL GRASS state=grass1
		icon_state="grass1 - normal"
		density=0
	dirt
		icon_state="dirt"
		density=0
	sand
		icon_state="sand"
		density=0
	tree
		icon='ragtree.dmi'
		density=1
		opacity=0
	walltorch
		icon_state="w2"
		density=1
		flyblock=1
		luminosity = 6
	bigchair
		icon_state="bc"
		density=1
	greenchair
		icon_state="gc"


	statuebody
		icon_state="stat"
		density=1
	statuehead
		icon_state="sh"
		density=1

	redchair
		icon_state="rc"
		density=1
	northpole
		icon_state="pole"
		density=1
	lava
		icon_state="hplava"

	upstairs
		icon_state="stairs"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(2,24,2)
	tostaffoffices
		icon_state="gmstair"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(70,77,21)
	tosilversecond
		icon_state="stairs2"
	tomainhall
		icon_state="gmstair"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(13,57,21)
	toaurorhq
		icon_state="gmstair"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(88,65,22)
	tofloor2
		icon_state="gmstair"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(96,24,21)
	level2
		icon_state="gmstair"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(90,6,21)
	stairsnormal
		icon_state="gmstair"
	downstairs
		icon_state="stairs1"
		Entered(mob/Player/M)
			sleep(8)
			if(M.monster==1)
				return
			else
				M.loc=locate(41,8,5)
mob/Player/Del()
	Players.Remove(src)
	..()
mob/Player/Logout()
	world<<"<B><font size=2 color=red><I>[usr] <b>logged out.</b></I></font></B>"
	usr.followplayer=0
	usr.readbooks = 0
	usr.movable=0
	..()
	del(usr)

turf
	officedoor4
		name = "Tobias's Office"
		icon = 'door1.dmi'
		icon_state = "closed"
		density = 1
		var
			recept = 0
		verb/Signal()
			set category = "Door"
			set src in oview(1)
			if(src.recept == 0)
				usr << "Your request to enter has been sent, if there is no reply, Deputy Headmaster Tobias may be AFK/offline."
				for(var/mob/M in world)
					if(M.key == "")
						switch(input(M,"[usr] wishes to enter your office.","Doorbell") in list ("Allow","Deny"))
							if("Allow")
								M << "You allow [usr] to enter."
								usr << "<b><font size=2>You may enter."
								for(var/turf/officedoor4/T in world)
									flick("opening",T)
									T.icon_state = "open"
									density = 0
									opacity = 0
									sleep(70)
									flick("closing",T)
									T.icon_state = "closed"
									density = 1
									opacity = 1
							if("Deny")
								M << "You don't allow [usr] to enter."
								usr << "<b><font size=2><font color=red>You may not enter."
			else
				usr << "Talk to the receptionist"

turf
	officedoor5
		name = "Sylar's Office"
		icon = 'door1.dmi'
		icon_state = "closed"
		density = 1
		var
			recept = 0
		verb/Signal()
			set category = "Door"
			set src in oview(1)
			if(src.recept == 0)
				usr << "Your request to enter has been sent, if there is no reply, Deputy Headmaster Sylar may be AFK/offline."
				for(var/mob/M in world)
					if(M.key == "")
						switch(input(M,"[usr] wishes to enter your office.","Doorbell") in list ("Allow","Deny"))
							if("Allow")
								M << "You allow [usr] to enter."
								usr << "<b><font size=2>You may enter."
								for(var/turf/officedoor5/T in world)
									flick("opening",T)
									T.icon_state = "open"
									density = 0
									opacity = 0
									sleep(70)
									flick("closing",T)
									T.icon_state = "closed"
									density = 1
									opacity = 1
							if("Deny")
								M << "You don't allow [usr] to enter."
								usr << "<b><font size=2><font color=red>You may not enter."
			else
				usr << "Talk to the receptionist"


	officedoor2
		name = "Ander's Office"
		icon = 'door1.dmi'
		icon_state = "closed"
		density = 1
		var
			recept = 0
		verb/Signal()
			set category = "Door"
			set src in oview(1)
			if(src.recept == 0)
				usr << "Your request to enter has been sent, if there is no reply, Headmaster Ander may be AFK/offline."
				for(var/mob/M in world)
					if(M.key == "")
						switch(input(M,"[usr] wishes to enter your office.","Doorbell") in list ("Allow","Deny","Shortly","Stop","Denied"))
							if("Allow")
								M << "You allow [usr] to enter."
								usr << "You may enter"
								for(var/turf/officedoor2/T in world)
									flick("opening",T)
									T.icon_state = "open"
									density = 0
									opacity = 0
									sleep(70)
									flick("closing",T)
									T.icon_state = "closed"
									density = 1
									opacity = 1
							if("Deny")
								M << "You don't allow [usr] to enter."
								usr << "You may not enter"
							if("Shortly")
								M << "You ask [usr] to wait shortly."
								usr << "Headmaster Ander is currently seeing someone, but will be done shortly. If you have a seat, he will be with you shortly."
								switch(input("Would you like to go to Ander's Waiting room?","Orb to waiting room?")in list("Yes","No"))
									if("Yes")
										flick('magic.dmi',usr)
										usr.loc = locate(54,78,1)
										flick('magic.dmi',usr)
										usr << "\n<b>Ander</b> : Feel free to have a seat, I will be with you shortly."
									if("No")
										usr << "\nAlright."
							if("Stop")
								M << "You tell [usr] to stop."
								usr << "Please only use the signal verb once! If you do not stop you will be punished."
							if("Denied")
								M << "You denied [usr]."
								usr << "<center><h2><font color=red>Denied!</h2></center></font>"
								return
			else
				usr << "Talk to the receptionist."












/////////////////////////





proc/ServerAD()
	world<<"<b><Font color=silver>Server:</b> <font size=1><font color=silver>Thanks for playing The Wizard's Chronicles. Forums: http://www.wizardschronicles.com"
	sleep(3000)
	ServerAD()

proc/SugAD()
	world<<"<b><Font color=silver>Server:</b> <font size=1><font color=green>TWC is currently looking for loads more content to add! Got a suggestion? Post it on the suggestions board at http://www.wizardschronicles.com <br>The only bad suggestion is the one not shared!"
	sleep(9000)
	SugAD()


proc/ServerRW()
	world<<"<b><Font color=silver>Server:</b> <font size=1><font color=red> The server is currently in Developer Mode. This means that the game is currently being coded and updated - Reboots may be frequent."
	sleep(3000)
	ServerRW()
turf
	wall
		icon='wall1.dmi'
		density=1

turf
	dirtOpaque
		name="dirt"
		icon='turf.dmi'
		icon_state="dirt"
		opacity=1

obj
	tabletop
		icon='turf.dmi'
		icon_state="t1"
		density=1
		layer=2
	tableleft
		icon='turf.dmi'
		icon_state="t2"
		density=1
		layer=2
	tablemiddle2
		icon='turf.dmi'
		icon_state="mid2"
		density=1
		layer=2
	tablemiddle
		icon='turf.dmi'
		icon_state="t1"
		density=1
		layer=2
	tablecornerL
		icon='turf.dmi'
		icon_state="t2"
		density=1
		layer=2
	tablecornerR
		icon='turf.dmi'
		icon_state="t3"
		density=1
		layer=2
	tableright
		icon='turf.dmi'
		icon_state="bottomright"
		density=1
		layer=2
	tableleft
		icon='turf.dmi'
		icon_state="bottom1"
		density=1
		layer=2
	tablebottom
		icon='turf.dmi'
		icon_state="bottommid"
		density=1
		layer=2
	tablebottom2
		icon='turf.dmi'
		icon_state="bottommid"
		density=1
		layer=2
	tablemid3
		icon='turf.dmi'
		icon_state="mid3"
		density=1
		layer=2