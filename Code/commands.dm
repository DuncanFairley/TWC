/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
turf
	bathroomstall
		icon = 'Stall.dmi'
		name = "Stall"
		density = 1
		opacity = 1
		s1
			icon_state = "1"
		s2
			icon_state = "2"
		s3
			icon_state = "3"
		s4
			icon_state = "4"
		s5
			icon_state = "5"
		toilet
			name = "toilet"
			icon = 'toilet.dmi'
			density = 0
		sink
			icon = 'sink.dmi'
			density = 1
/area/Diagon_Alley
mob
	var
		WNDone
obj
	var
		rubbleable
		rubble

mob
	var
		rubble
		ClassNotifications = 1 // If set to 1, your window will flash when a class is announced
		EventNotifications = 1
		MonsterMessages = 1
mob
	verb
		resetSettings()
			set name = ".resetSettings"
			var/winset = "butHousechattoggle.is-checked=false;butOOCtoggle.is-checked=false;"
			if(PMBlock)
				winset += "butPMtoggle.is-checked=true;"
			else
				winset += "butPMtoggle.is-checked=false;"
			if(betamapmode)
				winset += "butMapmodetoggle.is-checked=true;"
				EnableBetaMapMode()
			else
				winset += "butMapmodetoggle.is-checked=false;"
				DisableBetaMapMode()
			if(MonsterMessages)
				winset += "butMonsterMessagestoggle.is-checked=false;"
			else
				winset += "butMonsterMessagestoggle.is-checked=true;"
			if(ClassNotifications)
				winset += "butClassNotificationstoggle.is-checked=false;"
			else
				winset += "butClassNotificationstoggle.is-checked=true;"
			if(EventNotifications)
				winset += "butEventNotificationstoggle.is-checked=false;"
			else
				winset += "butEventNotificationstoggle.is-checked=true;"

			winset += "mnu_Settings.command=.ShowSettings;"
			winset += "mnu_Settings.is-disabled=false;"
			winset += "broLogin.is-visible=false;"
			winset += "map.focus=true;"
			winset(src,null,winset)
		ShowSettings()
			set name = ".ShowSettings"
			winset(src,"winSettings","is-visible=true")
		MonsterMessagestoggle()
			set name = ".MonsterMessagestoggle"
			if(winget(src,"butMonsterMessagestoggle","is-checked") == "true")
				MonsterMessages = 0
			else
				MonsterMessages = 1
		ClassNotificationstoggle()
			set name = ".ClassNotificationstoggle"
			if(winget(src,"butClassNotificationstoggle","is-checked") == "true")
				ClassNotifications = 0
			else
				ClassNotifications = 1
		EventNotificationstoggle()
			set name = ".EventNotificationstoggle"
			if(winget(src,"butEventNotificationstoggle","is-checked") == "true")
				EventNotifications = 0
			else
				EventNotifications = 1
		Housechattoggle()
			set name = ".Housechattoggle"
			if(winget(src,"butHousechattoggle","is-checked") == "true")
				listenhousechat = 0
			else
				listenhousechat = 1
		OOCtoggle()
			set name = ".OOCtoggle"
			if(winget(src,"butOOCtoggle","is-checked") == "true")
				listenooc = 0
			else
				listenooc = 1
		PMtoggle()
			set name = ".PMtoggle"
			if(winget(src,"butPMtoggle","is-checked") == "true")
				src.PMBlock=1
			else
				src.PMBlock=0
		Mapmodetoggle()
			set name = ".Mapmodetoggle"
			if(winget(src,"butMapmodetoggle","is-checked") == "false")
				DisableBetaMapMode()
			else
				EnableBetaMapMode()

mob/var/pname
obj/var/pname
obj/var/piconstate

mob/var/PMBlock=0
mob/test/verb/Transfer_Savefile()
	if(alert("Note: The new key's savefile will be overwritten. If either the new key or the old key are online, they will be forcibly logged out. The old key's savefile will be stored so that Murrawhip can retrieve it if something goes wrong, but not loaded by the player. Their vault will not be transferred.",,"Yes","Cancel") == "Yes")
		var/oldkey = input("Which key(Important! key! not ckey!) are you transferring the savefile FROM? (Usually a guest key)") as null|text
		if(!oldkey)return
		var/old_first_initial = lowertext(copytext(oldkey, 1, 2))
		if(!fexists("players/[old_first_initial]/[ckey(oldkey)].sav"))
			alert("players/[old_first_initial]/[oldkey].sav doesn't exist.")
			return
		var/newkey = input("Which key(Important! key! not ckey!) are you transferring the savefile TO?") as null|text
		if(!newkey)return
		var/new_first_initial = lowertext(copytext(newkey, 1, 2))
		//if(!fexists("players/[new_first_initial]/[newkey].sav"))
		//	alert("players/[new_first_initial]/[ckey(newkey)].sav doesn't exist.")
		//	return
		for(var/client/C)
			if(C.key == oldkey || C.key == newkey)
				C.mob.Save()
				usr << "<i>Booting [C.mob.name]([C.key]).</i>"
				C << "<b>Log in with key([newkey])</b>"
				del(C)
		var/savefile/oldF = new("players/[old_first_initial]/[ckey(oldkey)].sav")
		oldF.cd = "/players/[ckey(oldkey)]/mobs/"
		var/old_name
		var/mob/old_mob
		for (var/entry in oldF.dir)
			oldF["[entry]/name"] >> old_name
			oldF["[entry]/mob"] >> old_mob
			break
		if(old_name && old_mob)
			usr << "<i>Loaded into memory old character.</i>"
			if(fexists("players/[new_first_initial]/[newkey].sav"))
				fdel("players/[new_first_initial]/[newkey].sav")
			usr << "<i>New key wiped clean.</i>"
			var/savefile/newF = new("players/[new_first_initial]/[ckey(newkey)].sav")
			newF.cd = "/players/[ckey(newkey)]/mobs/[ckey(old_name)]"
			old_mob.key = newkey
			newF["name"] << old_name
			newF["mob"] << old_mob
			usr << "<i>Savefile transferred into new key. If the person has a PDS, you'll need to change its owner var.</i>"
			fcopy("players/[old_first_initial]/[ckey(oldkey)].sav","players/transferbackups/[old_first_initial]/[ckey(oldkey)].sav")
			del old_mob
			fdel("players/[old_first_initial]/[ckey(oldkey)].sav")
		else
			alert("Couldn't find name/mob")
mob/GM/verb/HGM_Message(msg as message)
			set category="Staff"
			set hidden = 1
			if(!usr.Gm) return
			world<<"[msg]"

var/Menu="<body bgcolor=black><p align=center><font size=3><font color=green><><><><><><><><><><><><><><p align=center><font size=2><font color=aqua>Welcome to <p><font size=3><font color=red>~ The Three Broomsticks ~ <p><font size=2><font color=aqua>Tavern and Fine Dining <p align=center><font color=green><font size=3><><><><><><><><><><><><><><p align=center><font color=blue><font size=3>|| <u>MENU</u> ||<p align=center><font size=3><font color=red><u>Beverages</u><font size=2><p align=center><font color=green><b>1. Draft Beer -50g</b> - Satisfy your craving for fun with our fine, freshly brewed beer. Made from natural ingrediants including Hippogryff Feather Extract.<p align=center><font color=green><b>2.Iced Tea - 20g</b> - Enjoy our lucious sweet tea with enachanted ice cubes floating around, that wont dissolve!  Wand-Stirred.<p align=center><font size=3><font color=red><u>Meals</u><font size=2><p align=center><font color=green><b>Turkey 100g</b> - Roasted or Fried, either way it's extremely delicious and sure to satisfy your craving for meat. Fried with our own method, the Inflamari Charm.<p align=center><font color=green>Steak - 125g </b> - Rare, Medium, Well Done, however you like your steak, you haven't lived until you've tried our Pixie Power Steak, or our Basilisk Big Boy Steak. Cooked any way you want.<font size=2><p align=center><font color=green><b>Pepperoni Pizza - 100g </b>Enjoy our finest Pizza, sprinkled with crispy, fresh baked pepperonies. Hand tossed crust with cheese baked into it.<p align=center><font color=red><u>Desserts</u><font size=2><p align=center><font color=green>Blueberry Pie - 80g</b> - Mmmm kick back with our warm, freshly baked Blueberry pie. Packed tight with extra blueberries.  Will burn crust on request!<p align=center><font color=green>CocoNut Cream Pie - 180g (Our finest dessert.)</b> - This pie is our specialty.  Smothered in coconut strips, smeared with cream and baked warm or cooled on your request. Cooled with the Glacius Charm for flash freezing. Perfect for your ice cream!  Heated with the Inflamari Charm to make it literally melt in your mouth to assure perfect sugary satisfaction. <p align=center><font color=green>Apple Pie - 75g</b> - Hot, baked apple pie. Homemade by our own, Tammie.<font size=2><p align=center><font color=green><b>Vanilla Sundae - 120g</b> Our finest dessert. Freshly roasted vanilla bean ice cream, topped with Inflamari melted fudge, and a freshly rinsed Cherry. Enchanted for extra flavour. <p><font size=1><font color=silver>*For additional items not on this menu, please see a staff member. Some items are freshly conjured and invented but haven't made it onto the menu yet. <p><font size=2><font color=white>Thanks for dining at  The Three Broomsticks!</b>"




