/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

obj
	var
		rubbleable
		rubble
		pname
		piconstate

mob
	var
		ClassNotifications = 1 // If set to 1, your window will flash when a class is announced
		EventNotifications = 1
		MonsterMessages = 1
mob
	verb
		resetSettings()
			set name = ".resetSettings"
			var/winset = "butHousechattoggle.is-checked=false;butOOCtoggle.is-checked=false;"
			var/mob/Player/p = src
			if(PMBlock)
				winset += "butPMtoggle.is-checked=true;"
			else
				winset += "butPMtoggle.is-checked=false;"
			if(p.TradeBlock)
				winset += "butTradetoggle.is-checked=true;"
			else
				winset += "butTradetoggle.is-checked=false;"

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
			if(p.playSounds)
				winset += "butSoundtoggle.is-checked=false;"
			else
				winset += "butSoundtoggle.is-checked=true;"

			if(autoAFK)
				winset += "butAFKtoggle.is-checked=false;"
			else
				winset += "butAFKtoggle.is-checked=true;"

			if(p.HideQuestTracker)
				winset += "butQuestTrackertoggle.is-checked=true;"
			else
				winset += "butQuestTrackertoggle.is-checked=false;"
			winset += "mnu_Settings.command=.ShowSettings;"
			winset += "mnu_Settings.is-disabled=false;"
			winset += "broLogin.is-visible=false;"
			winset += "map.focus=true;"

			if(p.loopedMove)
				winset += "buttonControlSet.is-checked=true;"
			else
				winset += "buttonControlSet.is-checked=false;"

			winset(src,null,winset)
		ShowSettings()
			set name = ".ShowSettings"
			var/mob/Player/p = src
			winset(src, null, "winSettings.is-visible=true;winSettings.button5.background-color=\"[p.mapTextColor]\"")
		Soundtoggle()
			set name = ".Soundtoggle"
			if(winget(src,"butSoundtoggle","is-checked") == "true")
				src:playSounds = 0
			else
				src:playSounds = 1
		MonsterMessagestoggle()
			set name = ".MonsterMessagestoggle"
			if(winget(src,"butMonsterMessagestoggle","is-checked") == "true")
				MonsterMessages = 0
			else
				MonsterMessages = 1
		QuestTrackertoggle()
			set name = ".QuestTrackertoggle"
			var/mob/Player/p = src
			if(winget(src,"butQuestTrackertoggle","is-checked") == "true")
				p.HideQuestTracker = TRUE
			else
				p.HideQuestTracker = FALSE
			p.Interface.Update()
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
		Tradetoggle()
			set name = ".Tradetoggle"
			if(winget(src,"butTradetoggle","is-checked") == "true")
				src:TradeBlock=1
			else
				src:TradeBlock=0

		AFKtoggle()
			set name = ".AFKtoggle"
			if(winget(src,"butAFKtoggle","is-checked") == "true")
				src:autoAFK=0
			else
				src:autoAFK=1

mob/Player/var/HideQuestTracker = FALSE
mob/var/pname

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
			Players<<"[msg]"