/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/var/ror=0

var/list/mob/Player/Players = list()
turf/var/flyblock=0

turf
	Enter(atom/movable/O)
		if(ismob(O))
			if(flyblock==2)
				for(var/atom/A in src)
					if(A.density) return 0
				return ..()
			if(!density) return ..()
			if(O:Gm && !O:flying) return ..()
			if(!O:key) return ..()
			else if(density&&flyblock)
				return 0
		return ..()
proc/str_count(haystack, needle)
	. = 0
	var/i = 1
	for(i; i <= length(haystack); i++)
		if(copytext(haystack, i, i + length(needle)) == needle)	.++

client
	mouse_pointer_icon='pointer.dmi'
#include <deadron/basecamp>
#define DEBUG 1
#define BASE_MENU_CREATE_CHARACTER	"Create New Character"
#define BASE_MENU_DELETE_CHARACTER	"Delete Character"
#define BASE_MENU_CANCEL			"Cancel"
#define BASE_MENU_QUIT				"Quit"
world/cache_lifespan = 0

mob/Player/var/lastreadDP
var/dplastupdate
var/lastusedAFKCheck = 0
proc
	Load_World()
		var/savefile/X = new ("players/World.sav")
		//var/list/objs=list()
		X["DP"] >> DP
		X["allowGifts"] >> allowGifts
		X["housepoints"] >> housepointsGSRH
		X["dplastupdate"] >> dplastupdate
		if(X["DJs"]) X["DJs"] >> DJs
		if(X["DPEditors"]) X["DPEditors"] >> dp_editors
		if(X["Stories"]) X["Stories"] >> stories
		X["ministrybanlist"] >> ministrybanlist
		X["housecupwinner"] >> housecupwinner
		if(!ministrybanlist)
			ministrybanlist = new/list()
		X["ministrybox"] >> ministrybox
		X["ministrypw"] >> ministrypw
		X["ministrybank"] >> ministrybank
		X["taxrate"] >> taxrate
		X["lastusedAFKCheck"] >> lastusedAFKCheck
		X["magicEyesLeft"] >> magicEyesLeft
		//X["promicons"] >> promicons
		if(!promicons) promicons = list()
		X["globalvaults"] >> globalvaults
		X["customMaps"] >> customMaps
		if(!customMaps) customMaps = list()
		if(!globalvaults) globalvaults = list()
		if(magicEyesLeft == null)
			magicEyesLeft = 10
		if(ministrybox)
			ministrybox.loc = locate(ministrybox.lastx,ministrybox.lasty,ministrybox.lastz)
		//X["objs"] >> objs

		/*for(var/obj/O in objs)
			O.loc = locate(O.lastx, O.lasty, O.lastz)
			if(istype(O,/obj/Hogwarts_Door))
				var/obj/Hogwarts_Door/A = O
				for(var/obj/Hogwarts_Door/H in locate(A.lastx, A.lasty, A.lastz))
					H.pass = A.pass
					H.bumpable = A.bumpable
					H.door = A.door
					del A*/
		if(!DP)
			DP = new/list()
		if(!housepointsGSRH)
			housepointsGSRH = new/list(6)
			housepointsGSRH[1] = 0
			housepointsGSRH[2] = 0
			housepointsGSRH[3] = 0
			housepointsGSRH[4] = 0
			housepointsGSRH[5] = 0
			housepointsGSRH[6] = 0

		var/list/cw
		X["ClanWars"] >> cw
		if(cw && cw.len)
			spawn()
				for(var/c in cw)
					if(!(c in clanwars_schedule))
						var/list/l = split(c, " - ")
						add_clan_wars(l[1], l[2])

		var/list/classes
		X["AutoClasses"] >> classes
		if(classes && classes.len)
			spawn()
				for(var/class in classes)
					if(!(class in autoclass_schedule))
						var/list/l = split(class, " - ")
						add_autoclass(l[1], l[2])

		X["skill_rating"] >> skill_rating
		if(!skill_rating) skill_rating = list()

		X["reputations"] >> reputations
		if(!reputations) reputations = list()

		X["competitiveBans"] >> competitiveBans
		X["prizeItems"] >> prizeItems

	Save_World()
		fdel("players/World.sav")
		var/savefile/X = new("players/World.sav")
		//var/list/objs=list()

		var/list/cw = list()
		for(var/e in clanwars_schedule)
			cw += e

		var/list/classes = list()
		for(var/e in autoclass_schedule)
			classes += e
		X["competitiveBans"] << competitiveBans
		X["prizeItems"] << prizeItems
		X["skill_rating"] << skill_rating
		X["reputations"] << reputations
		X["ClanWars"] << cw
		X["AutoClasses"] << classes
		X["DJs"] << DJs
		X["DPEditors"] << dp_editors
		X["Stories"] << stories
		X["DP"] << DP
		X["housepoints"] << housepointsGSRH
		X["dplastupdate"] << dplastupdate
		X["housecupwinner"] << housecupwinner
		X["ministrybanlist"] << ministrybanlist
		X["ministrypw"] << ministrypw
		X["ministrybank"] << ministrybank
		X["magicEyesLeft"] << magicEyesLeft
		X["taxrate"] << taxrate
		X["allowGifts"] << allowGifts
		X["lastusedAFKCheck"] << lastusedAFKCheck
		//X["promicons"] << promicons
		X["globalvaults"] << globalvaults
		X["customMaps"] << customMaps
		if(ministrybox)
			ministrybox.lastx = ministrybox.x
			ministrybox.lasty = ministrybox.y
			ministrybox.lastz = ministrybox.z
			X["ministrybox"] << ministrybox
		/*for(var/obj/O in world)
			if(istype(O,/obj/Hogwarts_Door))
				if(O:pass)
					O.lastx = O.x
					O.lasty = O.y
					O.lastz = O.z
					objs.Add(O)
			else if(O.dontsave)
				continue
			else if(O.z==21 || O.z==19)
				O.lastx = O.x
				O.lasty = O.y
				O.lastz = O.z
				objs.Add(O)
		X["objs"] << objs*/
world/Del()
	Save_World()
	SwapMaps_Save_All()

client/var/tmp
	base_num_characters_allowed = 1
	base_autoload_character = 0
	base_autosave_character = 1
	base_autodelete_mob = 1
	base_save_verbs = 1
obj/stackobj/Write(savefile/F)
	return
mob/proc/detectStoopidBug(sourcefile, line)
	if(!Gender)
		for(var/mob/Player/M in Players)
			if(M.Gm) M << "<h4>[src] has that save bug. Tell Rotem/Murrawhip that it occured on [sourcefile] line [line]</h4>"
#define SAVEFILE_VERSION 10
mob
	var/tmp
		base_save_allowed = 1
		base_save_location = 1

	var/list/base_saved_verbs

	proc/base_InitFromSavefile()
		return


	Write(savefile/F)
		..()
		if(src.type != /mob/Player)
			return
		F["overlays"] << null
		F["icon"] << null
		F["underlays"] << null
		F["savefileversion"] << SAVEFILE_VERSION
		if (base_save_location && world.maxx)
			F["last_x"] << x
			F["last_y"] << y
			F["last_z"] << z
		detectStoopidBug(__FILE__, __LINE__)
		return

	Read(savefile/F)
		var/testtype
		F["type"] >> testtype
		if(testtype == /mob/create_character)
			F["type"] << /mob/Player
			return
		//F["key"] << null
		..()
		if(testtype != /mob/Player)
			return
		detectStoopidBug(__FILE__, __LINE__)
		if (base_save_location && world.maxx)
			var/last_x
			var/last_y
			var/last_z
			F["last_x"] >> last_x
			F["last_y"] >> last_y
			F["last_z"] >> last_z
			var/savefile_version
			F["savefileversion"] >> savefile_version
			if(!savefile_version) savefile_version = 3
			if(savefile_version < 3)
				src.resetStatPoints()
				src << infomsg("Your statpoints have been reset.")
			if(savefile_version < 4)
				if(learnedslug) // replaces var with verb for eat slugs
					learnedslug = null
					verbs += /mob/Spells/verb/Eat_Slugs

				if(Disperse) // replaces var with verb for eat slugs
					Disperse = null
					verbs += /mob/Spells/verb/Disperse

				for(var/obj/Pyramid_Bean/bean in contents)
					bean.loc = null
					new /obj/items/Underwater_Bean (src)

				Resort_Stacking_Inv()

			if(savefile_version < 5)
				pdeaths = edeaths
				edeaths = 0

			if(savefile_version < 7)
				spawn()
					verbs -= /mob/Spells/verb/Avada_Kedavra
					verbs -= /mob/Spells/verb/Ecliptica
					verbs -= /mob/Spells/verb/Crapus_Sticketh
					verbs -= /mob/Spells/verb/Herbificus_Maxima
					verbs -= /mob/Spells/verb/Basilio
					verbs -= /mob/Spells/verb/Shelleh
					verbs -= /mob/Spells/verb/Imperio

			if(savefile_version < 8)
				spawn()
					var/mob/Player/p = src

					p.MMP = p.level * 6

					if(ratquest==1)
						var/questPointer/pointer = new
						pointer.time = world.realtime
						p.questPointers["Rats in the Cellar"] = pointer
					if(babyquest==1)
						var/questPointer/pointer = new
						pointer.time = world.realtime
						p.questPointers["Stolen by the Lord"] = pointer
					if(talkedtoalyssa==2)
						var/questPointer/pointer = new
						pointer.time = world.realtime
						p.questPointers["Make a Potion"] = pointer
					if(talkedtofred==3)
						var/questPointer/pointer = new
						pointer.time = world.realtime
						p.questPointers["On House Arrest"] = pointer

					talkedtogirl = null
					babyquest = null
					babyfound = null
					foundlord = null
					talkedtofred = null
					onionroot = null
					indigoseeds = null
					silverspiderlegs = null
					salamanderdrop = null
					talkedtosanta = null
					palmer = null
					quests = null
					talktotom = null
					ratquest = null

			if(savefile_version < 9)
				spawn()
					if(talkedtobunny == 3)
						var/questPointer/pointer = new
						pointer.time = world.realtime
						var/mob/Player/p = src
						p.questPointers["Sweet Easter"] = pointer

					talkedtobunny = null

			if(savefile_version < 10)
				DeathEater = null
				HA         = null
				Auror      = null
				HDE        = null
				if(aurorrobe)
					icon = baseicon
					aurorrobe = null
				else if(derobe)
					name = prevname
					icon = baseicon
					derobe = null
				verbs.Remove(/mob/GM/verb/Auror_chat)
				verbs.Remove(/mob/GM/verb/Auror_Robes)
				verbs.Remove(/mob/GM/verb/DErobes)
				verbs.Remove(/mob/GM/verb/DE_chat)
				verbs.Remove(/mob/GM/verb/Clan_store)
				verbs.Remove(/mob/Spells/verb/Morsmordre)

				var/turf/t = locate("@Hogwarts")
				last_x = t.x
				last_y = t.y
				last_z = t.z

			var/turf/t = locate(last_x, last_y, last_z)
			if(!t || t.name == "blankturf")
				loc = locate("@Hogwarts")
			else if(last_z >= SWAPMAP_Z && !currentMatches.isReconnect(src)) //If player is on a swap map, move them to gringotts
				loc = locate("leavevault")
			else if(istype(t.loc, /area/DEHQ) && !DeathEater)
				loc = locate("@Hogwarts")
			else if(istype(t.loc, /area/AurorHQ) && !Auror)
				loc = locate("@Hogwarts")
			else
				loc = t

			spawn()
				if(usr.loc)
					if(usr.loc.loc)
						usr.density = 0
						usr.loc.loc.Enter(usr)
						usr.density = 1
			if(usr.ror==0)
				var/rorrand=rand(1,3)
				usr.ror=rorrand
			usr.occlumens = 0
			usr.icon_state = ""
			if(usr.Gm)
				if(usr.Gender == "Female")
					usr.icon = 'FemaleStaff.dmi'
				else
					usr.icon = 'MaleStaff.dmi'
			else
				if(usr.Gender == "Male")
					switch(usr.House)
						if("Gryffindor")
							usr.icon = 'MaleGryffindor.dmi'
							usr.verbs += /mob/GM/verb/Gryffindor_Chat
						if("Ravenclaw")
							usr.icon = 'MaleRavenclaw.dmi'
							usr.verbs += /mob/GM/verb/Ravenclaw_Chat
						if("Slytherin")
							usr.icon = 'MaleSlytherin.dmi'
							usr.verbs += /mob/GM/verb/Slytherin_Chat
						if("Hufflepuff")
							usr.icon = 'MaleHufflepuff.dmi'
							usr.verbs += /mob/GM/verb/Hufflepuff_Chat
						if("Ministry")
							usr.icon = 'suit.dmi'
				else if(usr.Gender == "Female")
					switch(usr.House)
						if("Gryffindor")
							usr.icon = 'FemaleGryffindor.dmi'
							usr.verbs += /mob/GM/verb/Gryffindor_Chat
						if("Ravenclaw")
							usr.icon = 'FemaleRavenclaw.dmi'
							usr.verbs += /mob/GM/verb/Ravenclaw_Chat
						if("Slytherin")
							usr.icon = 'FemaleSlytherin.dmi'
							usr.verbs += /mob/GM/verb/Slytherin_Chat
						if("Hufflepuff")
							usr.icon = 'FemaleHufflepuff.dmi'
							usr.verbs += /mob/GM/verb/Hufflepuff_Chat
						if("Ministry")
							usr.icon = 'suit.dmi'
			usr.baseicon = usr.icon
			if(client)
				for(var/client/C)
					if(C.mob)
						if(C.mob.Gm) C.mob <<"<B><I>[src][refererckey==C.ckey ? "(referral)" : ""] ([client.address])([ckey])([client.connection == "web" ? "webclient" : "dreamseeker"]) logged in.</I></B>"
						else C.mob <<"<B><I>[src][refererckey==C.ckey ? "(referral)" : ""] logged in.</I></B>"
				usr.Teleblock=0
				usr<<browse(rules,"window=1;size=500x400")
				src<<"<b><font size=2><font color=#3636F5>Welcome to Harry Potter: The Wizards Chronicles</font> <u><a href='?src=\ref[src];action=view_changelog'>Version [VERSION]</a></u></b> <br>Visit the forums <a href=\"http://www.wizardschronicles.com\">here.</a>"
				//if(!usr.Gm)usr.see_invisible = 0
				var/obj/hud/PMHome/H = new()
				usr.client.screen += H
				if(radioOnline)
					var/obj/hud/radio/Z = new()
					usr.client.screen += Z
				if(src:lastreadDP < dplastupdate)
					usr << "<font color=red>The Daily Prophet has an issue that you haven't yet read. <a href='?src=\ref[src];action=daily_prophet'>Click here</a> to view.</font>"
				if(VERSION != src:lastversion)
					src:lastversion = VERSION
					src<<"<b><font size=2>TWC had an update since you last logged in! A list of changes can be found <a href='?src=\ref[src];action=view_changelog'>here.</a></font></b>"


mob/Player/var/lastversion
var/rules = file("rules.html")

mob/BaseCamp
	base_save_allowed = 0
	Login()
		RemoveVerbs()
		return

	Stat()
		return

	proc/RemoveVerbs()
		for (var/my_verb in verbs)
			verbs -= my_verb

mob/BaseCamp/FirstTimePlayer
	proc/FirstTimePlayer()
		return 1

world
	mob = /mob/BaseCamp/ChoosingCharacter
var/HTML/HTML
var/HTMLres = list('logo_banner.png', 'logo.png', 'mainstyle.css')
mob/BaseCamp/ChoosingCharacter/Topic(href,href_list[])
	switch(href_list["action"])
		if("loginLoad")
			if(istype(src,/mob/BaseCamp/ChoosingCharacter))
				Choose_Character()
		if("loginNew")
			if(istype(src,/mob/BaseCamp/ChoosingCharacter))
				New_Character()

client/Topic(href,href_list[],hsrc)
	..()
	switch(href_list["action"])
		if("login")
			if(href_list["btnregister"])
				usr << output(HTMLOutput(usr,"register",href_list),"broLogin")
		if("register")
			if(href_list["btncancel"])
				usr << output(HTMLOutput(usr,"login",href_list),"broLogin")
				return
			if(length(href_list["emailaddress"]) < 6\
			|| length(href_list["emailaddress"]) > 60\
			|| !findtext(href_list["emailaddress"],"@"))
				href_list["error"] = "Invalid email address entered."
			else if(!cmptext(href_list["emailaddress"],href_list["emailaddressconfirm"]))
				href_list["error"] = "Email addresses don't match."

			else if(length(href_list["password"]) < 5\
			|| length(href_list["password"]) > 60)
				href_list["error"] = "Password must be between 5 and 60 characters in length."
			else if(!cmptext(href_list["password"],href_list["passwordconfirm"]))
				href_list["error"] = "Passwords don't match."
			if(href_list["error"])
				usr << output(HTMLOutput(usr,"register",href_list),"broLogin")
proc/HTMLOutput(mob/M,page,list/href_list)
	//for(var/res in HTMLres)
	//	M << browse_rsc(res)
	switch(page)
		if("login")
			return {"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="mainstyle.css" />
</head>
<body>
	<div id="centerwrapper">
		<div style="margin-left:auto;margin-right:auto;width: 700px;height: 300px">
			<div style="float: left;width:263px;">
				<img src="silver_logo.jpg" />
			</div>
			<div style="text-align:right;padding-top:40px;">
			<form action="byond://" method="get">
				<label for="emailaddress">Email Address:</label><input id="emailaddress" name="emailaddress" /><br />
				<label for="password">Password:</label><input id="password" name="password" type="password" /><br />
				<input id="remember" type="checkbox" /><label for="remember">Remember login email</label>
				<br />
				<input type="button" name="btnregister" value="Register" style="width:100px;margin-right:3px;" onclick="window.location='?action=login;btnregister=1'" /><input type="submit" value="Login" style="width:100px;" />
				<input type="hidden" name="action" value="login" />
				<br />
				[href_list ? "<span class=\"error\">[href_list["error"]]</span>":]
			</form>
			</div><div style="clear: both"></div>
		</div>
	</div>
</body>
</html>"}
		if("register")
			return {"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="mainstyle.css" />
</head>
<body>
	<div id="centerwrapper">
		<div style="margin-left:auto;margin-right:auto;width: 700px;height: 300px">
			<div style="float: left;width:263px;">
				<img src="silver_logo.jpg" />
			</div>
			<div style="text-align:right;padding-top:30px;">
			<form action="byond://" method="get">
				<label for="emailaddress">Email Address:</label><input id="emailaddress" name="emailaddress" /><br />
				<label for="emailaddressconfirm">Confirm Email Address:</label><input id="emailaddressconfirm" name="emailaddressconfirm" /><br />
				<br />
				<label for="password">Password:</label><input id="password" name="password" type="password" /><br />
				<label for="passwordconfirm">Confirm Password:</label><input id="passwordconfirm" name="passwordconfirm" type="password" /><br />
				<br />
				<input type="button" name="btncancel" value="Cancel" style="width:100px;margin-right:3px;" onclick="window.location='?action=register;btncancel=1'" /><input type="submit" value="Register" style="width:100px;" />
				<input type="hidden" name="action" value="register" />
				<br />
				[href_list ? "<span class=\"error\">[href_list["error"]]</span>":]
			</form>
			</div><div style="clear: both"></div>
		</div>
	</div>
</body>
</html>"}
	return {"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="http://wizardschronicles.com/login/mainstyle.css" />
</head>
<body onresize="hideDiv()">
		<div id="banner">
			<img src="http://wizardschronicles.com/login/logo_banner.png" />
		</div>
		<div id="logo">
			<img src="http://wizardschronicles.com/login/logo.png" />
		</div>
		<div id="main">
				<ul class="centered-ul">
					<li class="horizontal-li"><a href="?src=\ref[M];action=loginNew">New</a></li>
					<li class="horizontal-li"> - </li>
					<li class="horizontal-li"><a href="?src=\ref[M];action=loginLoad">Load</li>
				</ul>
		</div>

	<script language=javascript type='text/javascript'>
		var swap = false;
		hideDiv();
		function hideDiv()
		{
			if(document.documentElement.offsetHeight < 480 && !swap)
			{
				swapNodes(document.getElementById('logo'), document.getElementById('main'));
				swap = true;
			}
			else if(document.documentElement.offsetHeight >= 480 && swap)
			{
 				swapNodes(document.getElementById('logo'), document.getElementById('main'));
				swap = false;
			}
		}

		function swapNodes(node1, node2)
		{
    		node2_copy = node2.cloneNode(true);
    		node1.parentNode.insertBefore(node2_copy, node1);
    		node2.parentNode.insertBefore(node1, node2);
    		node2.parentNode.replaceChild(node2, node2_copy);
		}
	</script>
</body>
</html>"}


mob/tmpmob
mob/BaseCamp/ChoosingCharacter
	movable=1
	Login()

		usr << output(HTMLOutput(src),"broLogin")
		/*var/first_initial = copytext(ckey, 1, 2)
		if(fexists("players/[first_initial]/[ckey].sav"))
			var/mob/tmpmob/A
			var/mob/tmpmob/M = new()
			var/savefile/S = new("players/[first_initial]/[ckey].sav")
			S.cd = "/players/[ckey]/mobs/"
			var/firstentry
			for (var/entry in S)
				S["[entry]/mob"] >> M
				//M = S["[entry]/mob"]The nurse orbs out
				break
			//alert("An old savefile is detected and needs to be converted into a new email-based savefile. The detected character is named \"[M.name]\" and is level [M.level].")
			usr << output(HTMLOutput(src,"login"),"broLogin")*/
		winset(src,null,"mapwindow.on-size=\".resizeMap\";winSettings.is-visible=false;broLogin.is-visible=true;radio_enabled.is-checked=false;barHP.is-visible=false;barMP.is-visible=false;[radioEnabled ? "mnu_radio.is-disabled=false;" : ""]")
		loc=locate(93,85,2)
		..()

	proc/Choose_Character()
		var/list/available_char_names=client.base_CharacterNames()
		if(length(available_char_names) < 1)
			src<<errormsg("You don't have a character to load, forwarding to creation process.")
			src.sight=1
			client.base_NewMob()
			del(src)
			return
		else
			client.base_LoadMob(available_char_names[1])
			del(src)
			return
	proc/New_Character()
		src.sight=1
		var/list/names=client.base_CharacterNames()
		if(length(names) < client.base_num_characters_allowed)
			client.base_NewMob()
			src.sight=0
			del(src)
			return
		else
			switch(input(src,"You have the maximum amount of allowed characters. Delete one?") in list ("Yes","No"))
				if("Yes")
					DeleteCharacter()
					usr.sight=0
					return
				if("No")
					usr.sight=0
					return
	proc/ChooseCharacter()
		var/list/available_char_names = client.base_CharacterNames()
		var/list/menu = new()
		menu += available_char_names

		if (length(available_char_names) < client.base_num_characters_allowed)
			if (client.base_num_characters_allowed == 1)
				client.base_NewMob()
				del(src)
				return
			else
				menu += BASE_MENU_CREATE_CHARACTER

		if (length(available_char_names))
			menu += BASE_MENU_DELETE_CHARACTER

		menu += BASE_MENU_QUIT

		var/default = null
		var/result = input(src, "Who do you want to be today?", "Welcome to [world.name]!", default) in menu
		switch(result)
			if (0, BASE_MENU_QUIT)
				del(src)
				return

			if (BASE_MENU_CREATE_CHARACTER)
				client.base_NewMob()
				del(src)
				return

			if (BASE_MENU_DELETE_CHARACTER)
				DeleteCharacter()
				ChooseCharacter()
				return

		var/mob/Mob = client.base_LoadMob(result)
		if (Mob)
			del(src)
		else
			ChooseCharacter()

	proc/DeleteCharacter()
		var/list/available_char_names = client.base_CharacterNames()
		var/list/menu = new()
		menu += available_char_names

		menu += BASE_MENU_CANCEL
		menu += BASE_MENU_QUIT

		var/default = null
		var/result = input(src, "Which character do you want to delete?", "Deleting Character", default) in menu

		switch(result)
			if (0, BASE_MENU_QUIT)
				del(src)
				return

			if (BASE_MENU_CANCEL)
				return

		client.base_DeleteMob(result)
		sight=0
		return


client
	var/tmp/savefile/_base_player_savefile

	New()
		.=..()
		if (base_autoload_character)
			base_ChooseCharacter()
			base_Initialize()
			return
		return ..()

	Del()
		if(mob && isplayer(mob))
			if(mob:isTrading())
				mob:trade.Clean()
			var/StatusEffect/S = mob.findStatusEffect(/StatusEffect/Lamps)
			if(S) S.Deactivate()
			if(mob.prevname)
				mob.derobe = 0
				mob.name = mob.prevname
			mob.occlumens = 0
			if(mob.xp4referer)
				sql_upload_refererxp(mob.ckey,mob.refererckey,mob.xp4referer)
				mob.xp4referer = 0
			if(!mob.Gm)
				mob.Check_Death_Drop()
		if (base_autosave_character)
			base_SaveMob()
		if (base_autodelete_mob)
			del(mob)
		return ..()


	proc/base_PlayerSavefile()
		if (!_base_player_savefile)
			var/first_initial = copytext(ckey, 1, 2)
			var/filename = "players/[first_initial]/[ckey].sav"
			_base_player_savefile = new(filename)
		return _base_player_savefile


	proc/base_FirstTimePlayer()
		var/mob/BaseCamp/FirstTimePlayer/first_mob = new()
		first_mob.name = key
		first_mob.gender = gender
		mob = first_mob
		return first_mob.FirstTimePlayer()


	proc/base_ChooseCharacter()
		base_SaveMob()

		var/mob/BaseCamp/ChoosingCharacter/chooser

		var/list/names = base_CharacterNames()
		if (!length(names))
			var/result = base_FirstTimePlayer()
			if (!result)
				del(src)
				return

			chooser = new()
			mob = chooser

			return

		if (base_num_characters_allowed == 1)
			base_LoadMob(names[1])
			return

		chooser = new()
		mob = chooser
		return


	proc/base_CharacterNames()
		var/list/names = new()
		var/savefile/F = base_PlayerSavefile()

		F.cd = "/players/[ckey]/mobs/"
		var/list/characters = F.dir
		var/char_name
		for (var/entry in characters)
			F["[entry]/name"] >> char_name
			names += char_name
		return names


	proc/base_NewMob()
		base_SaveMob()
		var/mob/new_mob
		new_mob = new /mob/create_character
		new_mob.name = key
		new_mob.gender = gender
		mob = new_mob
		_base_player_savefile = null
		return new_mob


	proc/base_SaveMob()
		if (!mob || !mob.base_save_allowed)
			return

		if (base_save_verbs)
			mob.base_saved_verbs = mob.verbs
		var/first_initial = copytext(ckey, 1, 2)
		fdel("players/[first_initial]/[ckey].sav")
		var/savefile/F = base_PlayerSavefile()
		var/wasDE = 0
		if(mob.name == "Robed Figure" && mob.prevname)
			wasDE = 1
			mob.name = mob.prevname
		var/mob_ckey = ckey(mob.name)

		var/directory = "/players/[ckey]/mobs/[mob_ckey]"
		F.cd = directory


		F["name"] << mob.name
		F["mob"] << mob
		if(wasDE)
			mob.name = "Robed Figure"
		_base_player_savefile = null


	proc/base_LoadMob(char_name)
		var/mob/new_mob
		var/char_ckey = ckey(char_name)
		var/savefile/F = base_PlayerSavefile()
		_base_player_savefile = null

		F.cd = "/players/[ckey]/mobs/"
		var/list/characters = F.dir
		var/error = FALSE
		if (!characters.Find(char_ckey))
			world.log << "<b>[key]'s client.LoadCharacter() could not locate character [char_name].</b>"
			error = TRUE
		if(!char_ckey)
			F["mob"] >> new_mob
		else
			F["[char_ckey]/mob"] >> new_mob
		if (new_mob)
			if(istype(new_mob, /mob/create_character))
				usr << "\red <b>Your character has been absolved of the new player bug. Please reconnect and load again.</b>"
				base_DeleteMob(char_name)
				del new_mob
				return
			else if(error && !new_mob.name)
				new_mob.name = "RenameMe"

			mob = new_mob

			new_mob.base_InitFromSavefile()
			if (base_save_verbs && new_mob.base_saved_verbs)
				if(!new_mob.base_saved_verbs.len) return null
				for (var/item in new_mob.base_saved_verbs)
					new_mob.verbs += item
			return new_mob
		return null


	proc/base_DeleteMob(char_name)
		var/char_ckey = ckey(char_name)
		var/savefile/F = base_PlayerSavefile()

		F.cd = "/players/[ckey]/mobs/"
		F.dir.Remove(char_ckey)