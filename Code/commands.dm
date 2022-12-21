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

	Player
		var
			tmp/openedSettings = 0
			BeepType = 1

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
			winset += "map.focus=true;"

			winset += "winSettings.buttonTextColor.background-color=\"[p.mapTextColor]\";"

			winset += "winSettings.butHideHud.is-checked=false;"

			winset += "winSettings.butHideHud.is-checked=false;"

			var/PlayerData/pd = worldData.playersData[ckey]
			if(pd && pd.autoLoad)
				winset += "winSettings.butAutoLoad.is-checked=true;"
			else
				winset += "winSettings.butAutoLoad.is-checked=false;"

			switch(p.BeepType)
				if(1)
					winset += "winSettings.buttonBeep.is-checked=true;"
				if(2)
					winset += "winSettings.buttonGuitar.is-checked=true;"
				if(3)
					winset += "winSettings.buttonGlass.is-checked=true;"


			winset(src,null,winset)

		ShowSettings()
			set name = ".ShowSettings"
			var/mob/Player/p = src
			if(!p.openedSettings)
				p.openedSettings = 1
				resetSettings()
			winshowCenter(src, "winSettings")
		Soundtoggle(var/n as num)
			set name = ".Soundtoggle"
			src:playSounds = n

		ChangeBeep(var/n as num)
			set name = ".ChangeBeep"
			usr:BeepType = n

			var/sound/S
			switch(usr:BeepType)
				if(1)
					S = sound('Alert.ogg')
				if(2)
					S = sound('Alert.mp3')
				if(3)
					S = sound('TWC_Alert_2.ogg')
			src << S

		MonsterMessagestoggle(var/n as num)
			set name = ".MonsterMessagestoggle"
			MonsterMessages = n

		QuestTrackertoggle(var/n as num)
			set name = ".QuestTrackertoggle"
			var/mob/Player/p = src
			p.HideQuestTracker = n
			p.Interface.Update()

		ClassNotificationstoggle(var/n as num)
			set name = ".ClassNotificationstoggle"
			ClassNotifications = n

		EventNotificationstoggle(var/n as num)
			set name = ".EventNotificationstoggle"
			EventNotifications = n

		Housechattoggle(var/n as num)
			set name = ".Housechattoggle"
			listenhousechat = n

		OOCtoggle(var/n as num)
			set name = ".OOCtoggle"
			listenooc = n

		PMtoggle(var/n as num)
			set name = ".PMtoggle"
			src.PMBlock=n

		Tradetoggle(var/n as num)
			set name = ".Tradetoggle"
			src:TradeBlock=n

		AFKtoggle(var/n as num)
			set name = ".AFKtoggle"
			src:autoAFK=n


mob/Player/var/HideQuestTracker = FALSE
mob/var/pname

mob/var/PMBlock=0
mob/test/verb/Transfer_Savefile()
	set category="Debug"
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

			if(fexists("[swapmaps_directory]/map_[ckey(oldkey)].sav"))

				SwapMaps_Unload(ckey(oldkey))

				if(fexists("[swapmaps_directory]/map_[ckey(newkey)].sav"))
					fdel("[swapmaps_directory]/map_[ckey(newkey)].sav")

				fcopy("[swapmaps_directory]/map_[ckey(oldkey)].sav", "[swapmaps_directory]/map_[ckey(newkey)].sav")

				fdel("[swapmaps_directory]/map_[ckey(oldkey)].sav")

				var/savefile/newV = new("[swapmaps_directory]/map_[ckey(newkey)].sav")
				newV.cd = "//.0"
				newV["id"] << ckey(newkey)

		else
			alert("Couldn't find name/mob")
mob/GM/verb/HGM_Message(msg as message)
			set category="Staff"
			set hidden = 1
			if(!usr.Gm) return
			Players<<"[msg]"