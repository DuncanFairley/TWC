/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
#define CREATE_PATH list(/obj,/mob,/turf,/area)			//	change the path to what you want to create, if you wish
#define _CSS "<style type='text/css'></style>"	//	Enter the CSS style for the browser, if you wish to make it ore fancy.
mob/var/list/monsterkills = list()
mob
	proc
		Award(medalname)
			Players << "<h3>[src] has gained the [medalname] achievement!</h3>"
			world.SetMedal(medalname,src)
		AddKill(var/monster)
			monsterkills["[monster]"]++
			switch(monster)
				if("Basilisk")
					if(monsterkills["[monster]"] == 1)
						spawn()Award("Bassy Attacks!")
				if("Dementor")
					if(monsterkills["[monster]"] == 100)
						spawn()Award("Where's the chocolate!?")
				if("Rat","Demon Rat")
					if((monsterkills["Rat"] + monsterkills["Demon Rat"]) == 500)
						spawn()Award("Need a cat?")
mob/Player/var
	timerDet = 0
	timerMute = 0

proc/reset_winAT(var/mob/Player/M)
	if(winexists(M,"winAT"))
		winset(M,"winAT","parent=none")
	winclone(M, "window", "winAT")
	var/list/winAT = list()
	winAT["size"] = "740x500"
	winAT["statusbar"] = "false"
	winAT["title"] = "Administration Tools"
	winset(M,"winAT",list2params(winAT))

	winclone(M,"pane","panATMain")
	var/list/panATMain = list()
	panATMain["anchor1"] = "0,0"
	panATMain["anchor2"] = "100,100"
	panATMain["title"] = "Main"
	winset(M,"panATMain",list2params(panATMain))

	var/list/tabAT = list()
	tabAT["parent"] = "winAT"
	tabAT["type"] = "tab"
	tabAT["size"] = "740x500"
	tabAT["anchor1"] = "0,0"
	tabAT["anchor2"] = "100,100"
	//tabAT["background-color"] = "#FF0000"
	tabAT["on-tab"] = ".tabATChange"
	tabAT["tabs"] = "panATMain"
	winset(M,"tabAT",list2params(tabAT))

mob/GM/verb/EditVerbs(var/Zref as text, var/Verb as text, var/btnid as text)
	set name = ".EditVerbs"
	var/mob/Player/M = locate(Zref)
	if(!Gm)return
	var/V = text2path(Verb)
	var/ischecked = winget(src,"[btnid]","is-checked")
	if(!(V in usr.verbs))
		winset(src,"[btnid]","is-checked=[ischecked=="true" ? "false" : "true"]")
		alert("You can only add/remove verbs that you already have yourself.")
	else if(ischecked == "true")
		M.verbs += V
		M << infomsg("[usr] has given you [V]")
		usr << infomsg("You have given [M] [V]")
	else if(ischecked == "false")
		M.verbs -= V
		M << infomsg("[usr] has removed [V] from you.")
		usr << infomsg("You have removed [V] from [M].")
	else
		world.log << "Error code 3ghLMV"

var/allverbs = typesof(/mob/verb) | typesof(/mob/Spells/verb) | typesof(/mob/GM/verb) | typesof(/mob/test/verb) | typesof(/mob/Quidditch/verb)
client/verb/tabATChange()
	set name = ".tabATChange"
	if(!mob.admin)return
	switch(winget(src,"tabAT","current-tab"))
		if("panATLogs")
			if(/mob/GM/verb/ChatLogs in mob.verbs)
				src << browse("<body bgcolor=\"black\"> [file2text(chatlog)]</body>","window=broATLogsChat")
			if(/mob/GM/verb/AdminLogs in mob.verbs)
				src << browse("[file2text(adminlog)]","window=broATLogsAdmin")
			if(/mob/GM/verb/EventLogs in mob.verbs)
				src << browse("<table>[file2text(eventlog)]</table>","window=broATLogsEvents")
			if(/mob/GM/verb/ClassLogs in mob.verbs)
				src << browse("[file2text(classlog)]","window=broATLogsClass")
			if(/mob/GM/verb/GoldLogs in mob.verbs)
				src << browse("[file2text(goldlog)]","window=broATLogsGold")
			if(/mob/GM/verb/KillLogs in mob.verbs)
				src << browse("[file2text(killlog)]","window=broATLogsKill")
		if("panATVerbs")
			var/mob/Player/M = input("Pick player to view the verbs of") as null|anything in Players
			if(!M)return
			reset_panATVerbs(src)
			var/i = 0
			var/lasty = 5
			var/alternate = 0 //Alternate between 0 and 1
			winset(src, "panATVerbs","size=710x[25*(length(allverbs)/2) + 15]")
			for(var/verb/V in allverbs)
				var/list/btnparams = list()
				btnparams["parent"] = "panATVerbs"
				btnparams["type"] = "button"
				btnparams["button-type"] = "checkbox"
				if(V in M.verbs)
					btnparams["is-checked"] = "true"
				else
					btnparams["is-checked"] = "false"
				btnparams["command"] = ".EditVerbs \"\ref[M]\" \"[V]\" \"btn_[++i]\""
				btnparams["text"] = "[V]"
				btnparams["size"] = "350x20"
				btnparams["pos"] = "[alternate ? "360" : "5"],[lasty]"
				winset(usr, "btn_[i]",list2params(btnparams))
//winset(usr, "btn_[++i]","parent=panATVerbs;type=button;button-type=checkbox;is-checked=false;command=.EditVerbs+[M]+\"[V]\"+\"btn_[i]\";text=[V];size=350x20;pos=[alternate ? "360" : "5"],[lasty]")//;pos=20,20")

				if(alternate)
					lasty += 25
				alternate = !alternate
			winset(src,"tabAT","tabs=%2BpanATVerbs")
			winset(src,"tabAT","current-tab=panATVerbs")

proc/reset_panATLogs(var/mob/Player/M)
	if(winexists(M,"panATLogs"))
		winset(M,"panATLogs","parent=none")
	winclone(M,"pane","panATLogs")
	var/list/panATLogs = list()
	panATLogs["anchor1"] = "0,0"
	panATLogs["anchor2"] = "100,100"
	panATLogs["title"] = "Logs"
	winset(M,"panATLogs",list2params(panATLogs))

	var/list/tabATLogs = list()
	tabATLogs["parent"] = "panATLogs"
	tabATLogs["type"] = "tab"
	tabATLogs["size"] = "740x500"
	tabATLogs["anchor1"] = "0,0"
	tabATLogs["anchor2"] = "100,100"
	//tabAT["background-color"] = "#FF0000"
	//tabATLogs["on-tab"] = ".tabATChange"
	//tabATLogs["tabs"] = "panATMain"
	winset(M,"tabATLogs",list2params(tabATLogs))

proc/reset_panATLogsChat(var/mob/Player/M)
	if(winexists(M,"panATLogsChat"))
		winset(M,"panATLogsChat","parent=none")
	winclone(M,"pane","panATLogsChat")
	var/list/panATLogsChat = list()
	panATLogsChat["anchor1"] = "0,0"
	panATLogsChat["anchor2"] = "100,100"
	panATLogsChat["size"] = "740x500"
	panATLogsChat["title"] = "Chat"
	winset(M,"panATLogsChat",list2params(panATLogsChat))

	var/list/broATLogsChat = list()
	broATLogsChat["type"] = "browser"
	broATLogsChat["parent"] = "panATLogsChat"
	broATLogsChat["size"] = "640x480"
	broATLogsChat["anchor1"] = "0,0"
	broATLogsChat["anchor2"] = "100,100"
	winset(M,"broATLogsChat",list2params(broATLogsChat))

proc/reset_panATLogsAdmin(var/mob/Player/M)
	if(winexists(M,"panATLogsAdmin"))
		winset(M,"panATLogsAdmin","parent=none")
	winclone(M,"pane","panATLogsAdmin")
	var/list/panATLogsAdmin = list()
	panATLogsAdmin["anchor1"] = "0,0"
	panATLogsAdmin["anchor2"] = "100,100"
	panATLogsAdmin["size"] = "740x500"
	panATLogsAdmin["title"] = "Admin"
	winset(M,"panATLogsAdmin",list2params(panATLogsAdmin))

	var/list/broATLogsAdmin = list()
	broATLogsAdmin["type"] = "browser"
	broATLogsAdmin["parent"] = "panATLogsAdmin"
	broATLogsAdmin["size"] = "640x480"
	broATLogsAdmin["anchor1"] = "0,0"
	broATLogsAdmin["anchor2"] = "100,100"
	winset(M,"broATLogsAdmin",list2params(broATLogsAdmin))

proc/reset_panATLogsEvents(var/mob/Player/M)
	if(winexists(M,"panATLogsEvents"))
		winset(M,"panATLogsEvents","parent=none")
	winclone(M,"pane","panATLogsEvents")
	var/list/panATLogsEvents = list()
	panATLogsEvents["anchor1"] = "0,0"
	panATLogsEvents["anchor2"] = "100,100"
	panATLogsEvents["size"] = "740x500"
	panATLogsEvents["title"] = "Events"
	winset(M,"panATLogsEvents",list2params(panATLogsEvents))

	var/list/broATLogsEvents = list()
	broATLogsEvents["type"] = "browser"
	broATLogsEvents["parent"] = "panATLogsEvents"
	broATLogsEvents["size"] = "640x480"
	broATLogsEvents["anchor1"] = "0,0"
	broATLogsEvents["anchor2"] = "100,100"
	winset(M,"broATLogsEvents",list2params(broATLogsEvents))

proc/reset_panATLogsClass(var/mob/Player/M)
	if(winexists(M,"panATLogsClass"))
		winset(M,"panATLogsClass","parent=none")
	winclone(M,"pane","panATLogsClass")
	var/list/panATLogsClass = list()
	panATLogsClass["anchor1"] = "0,0"
	panATLogsClass["anchor2"] = "100,100"
	panATLogsClass["size"] = "740x500"
	panATLogsClass["title"] = "Classes"
	winset(M,"panATLogsClass",list2params(panATLogsClass))

	var/list/broATLogsClass = list()
	broATLogsClass["type"] = "browser"
	broATLogsClass["parent"] = "panATLogsClass"
	broATLogsClass["size"] = "640x480"
	broATLogsClass["anchor1"] = "0,0"
	broATLogsClass["anchor2"] = "100,100"
	winset(M,"broATLogsClass",list2params(broATLogsClass))

proc/reset_panATLogsGold(var/mob/Player/M)
	if(winexists(M,"panATLogsGold"))
		winset(M,"panATLogsGold","parent=none")
	winclone(M,"pane","panATLogsGold")
	var/list/panATLogsGold = list()
	panATLogsGold["anchor1"] = "0,0"
	panATLogsGold["anchor2"] = "100,100"
	panATLogsGold["size"] = "740x500"
	panATLogsGold["title"] = "Gold"
	winset(M,"panATLogsGold",list2params(panATLogsGold))

	var/list/broATLogsGold = list()
	broATLogsGold["type"] = "browser"
	broATLogsGold["parent"] = "panATLogsGold"
	broATLogsGold["size"] = "640x480"
	broATLogsGold["anchor1"] = "0,0"
	broATLogsGold["anchor2"] = "100,100"
	winset(M,"broATLogsGold",list2params(broATLogsGold))

proc/reset_panATLogsKill(var/mob/Player/M)
	if(winexists(M,"panATLogsKill"))
		winset(M,"panATLogsKill","parent=none")
	winclone(M,"pane","panATLogsKill")
	var/list/panATLogsKill = list()
	panATLogsKill["anchor1"] = "0,0"
	panATLogsKill["anchor2"] = "100,100"
	panATLogsKill["size"] = "740x500"
	panATLogsKill["title"] = "Kill"
	winset(M,"panATLogsKill",list2params(panATLogsKill))

	var/list/broATLogsKill = list()
	broATLogsKill["type"] = "browser"
	broATLogsKill["parent"] = "panATLogsKill"
	broATLogsKill["size"] = "640x480"
	broATLogsKill["anchor1"] = "0,0"
	broATLogsKill["anchor2"] = "100,100"
	winset(M,"broATLogsKill",list2params(broATLogsKill))

proc/reset_panATVerbs(var/mob/Player/M)
	if(winexists(M,"panATVerbs"))
		winset(M,"panATVerbs","parent=none")
	winclone(M,"pane","panATVerbs")
	var/list/panATVerbs = list()
	panATVerbs["anchor1"] = "0,0"
	panATVerbs["anchor2"] = "100,100"
	panATVerbs["title"] = "Player Verb Editor"
	panATVerbs["can-scroll"] = "true"
	winset(M,"panATVerbs",list2params(panATVerbs))
mob/GM/verb/ChatLogs()
	set hidden = 1
mob/GM/verb/AdminLogs()
	set hidden = 1
mob/GM/verb/EventLogs()
	set hidden = 1
mob/GM/verb/ClassLogs()
	set hidden = 1
mob/GM/verb/GoldLogs()
	set hidden = 1
mob/GM/verb/KillLogs()
	set hidden = 1
mob/GM/verb/Administration_Tools()
	reset_winAT(usr)
	if(/mob/GM/verb/EditVerbs in verbs)
		reset_panATVerbs(usr)
		winset(src,"tabAT","tabs=%2BpanATVerbs")
	if((/mob/GM/verb/ChatLogs in verbs) || (/mob/GM/verb/EventLogs in verbs) || (/mob/GM/verb/ClassLogs in verbs))
		reset_panATLogs(usr)
		winset(src,"tabAT","tabs=%2BpanATLogs")
	if(/mob/GM/verb/ChatLogs in verbs)
		reset_panATLogsChat(usr)
		winset(src,"tabATLogs","tabs=%2BpanATLogsChat")
	if(/mob/GM/verb/AdminLogs in verbs)
		reset_panATLogsAdmin(usr)
		winset(src,"tabATLogs","tabs=%2BpanATLogsAdmin")
	if(/mob/GM/verb/EventLogs in verbs)
		reset_panATLogsEvents(usr)
		winset(src,"tabATLogs","tabs=%2BpanATLogsEvents")
	if(/mob/GM/verb/ClassLogs in verbs)
		reset_panATLogsClass(usr)
		winset(src,"tabATLogs","tabs=%2BpanATLogsClass")
	if(/mob/GM/verb/GoldLogs in verbs)
		reset_panATLogsGold(usr)
		winset(src,"tabATLogs","tabs=%2BpanATLogsGold")
	if(/mob/GM/verb/KillLogs in verbs)
		reset_panATLogsKill(usr)
		winset(src,"tabATLogs","tabs=%2BpanATLogsKill")
	winshow(src,"winAT",1)
mob/Player
	proc
		mute_countdown()
			sleep(600)
			timerMute--
			if(timerMute < 1)
				if(!src.mute)return
				mute = 0
				Players << "<b><span style=\"color:red;\">[src] has been unsilenced.</span></b>"
			else
				mute_countdown()
		detention_countdown()
			sleep(600)//Minutes babbby.
			timerDet--
			if(timerDet < 1)
				if(!Detention)return
				flick('dlo.dmi',src)
				src:Transfer(locate("@Hogwarts"))

				src.Detention=0
				src.MuteOOC=0
				Players<<"[src] has been released from Detention."
				src.client.update_individual()
			else
				detention_countdown()

mob/test/verb/Remove_Junk()
	var/input = input("Which junk are we talkin'?","Junk Removal") as null|anything in list("PM Inbox","PM Outbox","Inventory","Bank Deposit Items")
	if(!input) return
	if(input == "PM Inbox")
		var/alrt = alert("View amount of messages in world, or delete individual's messages.",,"View","Delete")
		if(alrt == "View")
			for(var/mob/Player/M in world)
				src << "[M] has [M.pmsRec.len] PMs in INBOX "
		if(alrt == "Delete")
			var/mob/Player/person = input("Which person would you like to delete INBOX messages from?") as null|mob in world
			if(!person)return
			var/alrt2 = alert("[person] has [person.pmsRec.len] messages. Would you like to delete them?",,"Yes","No")
			if(alrt2 == "Yes") person.pmsRec = list()
	else if(input == "PM Outbox")
		var/alrt = alert("View amount of messages in world, or delete individual's messages.",,"View","Delete")
		if(alrt == "View")
			for(var/mob/Player/M in world)
				src << "[M] has [M.pmsSen.len] PMs in OUTBOX "
		if(alrt == "Delete")
			var/mob/Player/person = input("Which person would you like to delete OUTBOX messages from?") as null|mob in world
			if(!person)return
			var/alrt2 = alert("[person] has [person.pmsSen.len] messages. Would you like to delete them?",,"Yes","No")
			if(alrt2 == "Yes") person.pmsSen = list()
	else if(input == "Inventory")
		var/alrt = alert("View amount of items in world, or delete individual's items.",,"View","Delete")
		if(alrt == "View")
			for(var/mob/Player/M in world)
				src << "[M] has [M.contents.len] items "
		if(alrt == "Delete")
			var/mob/Player/person = input("Which person would you like to delete their items?") as null|mob in world
			if(!person)return
			var/alrt2 = alert("[person] has [person.contents.len] items. Would you like to delete them?",,"Yes","No")
			if(alrt2 == "Yes") person.contents = list()
proc/Log_admin(adminaction)
	file("Logs/Adminlog.html")<<"[time2text(world.realtime,"MMM DD YYYY - hh:mm")]: [adminaction]<br />"
proc/Log_gold(gold,var/mob/Player/from,var/mob/Player/too)
	if(from.client.address == too.client.address)
		goldlog<<"<b>[time2text(world.realtime,"MMM DD YYYY - hh:mm")]: [from]([from.key])([from.client.address]) gave [comma(gold)] gold to [too]([too.key])([too.client.address])</b><br />"
	else if(gold>1000)goldlog<<"[time2text(world.realtime,"MMM DD YYYY - hh:mm")]: [from]([from.key])([from.client.address]) gave [gold] gold to [too]([too.key])([too.client.address])<br />"
mob/GM/verb
	Check_EXP(mob/Player/p in Players)
		set category = "Staff"

		if(p.level >= lvlcap && p.rankLevel)
			src << "[p]'s EXP: [comma(p.rankLevel.exp)]"
			sleep(30)
			src << "[p]'s EXP: [comma(p.rankLevel.exp)]"
		else
			src << "[p]'s EXP: [p.Exp]"
			sleep(30)
			src << "[p]'s EXP: [p.Exp]"

mob
	var
		admin
var
	classlog = file("Logs/classlog.html")
	chatlog = file("Logs/chatlog.html")
	eventlog = file("Logs/event_log.html")
	DJlog = file("Logs/DJlog.html")
	killlog = file("Logs/kill_log.html")
	goldlog = file("Logs/goldlog.html")
	adminlog = file("Logs/Adminlog.html")
mob/GM
	verb
		GM_chat(var/message as text)
			set category="Staff"
			set name="GM Chat"
			if(!message || message == "") return
			var/mob/Player/m = src
			for(var/mob/Player/p in Players)
				if(p.Gm)
					p << "<b><span style=\"color:silver; font-size:2;\">GM> [m.prevname ? m.prevname : name]:</span></b> <span style=\"color:white;\">[message]</span>"
			chatlog << "<b><span style=\"color:silver;\">GM> [m.prevname ? m.prevname : name]:</span></b> <span style=\"color:white;\">[message]</span><br>"


		Gryffindor_Chat(var/message as text)
			if(!listenhousechat)
				usr << "You are not listening to Gryffindor chat."
				return
			var/mob/Player/m = src
			if(m.mute==1||m.Detention){m<<errormsg("You can't speak while silenced.");return}
			if(!message || message == "") return
			message = copytext(check(message),1,350)

			for(var/mob/Player/p in Players)
				if((p.House == "Gryffindor" || p.admin) && p.listenhousechat)
					p << "<b><span style=\"font-size:2; color:red\">Gryffindor Channel> </span><span style=\"font-size:2; color:silver\">[m.prevname ? m.prevname : name]:</span></b> <span style=\"color:white;\">[message]</span>"

			chatlog << "<b><span style=\"color:red;\">Gryffindor> [m.prevname ? m.prevname : name]:</span></b> <span style=\"color:white;\">[message]</span><br>"


		Ravenclaw_Chat(var/message as text)
			if(!listenhousechat)
				usr << "You are not listening to Ravenclaw chat."
				return
			var/mob/Player/m = src
			if(m.mute==1||m.Detention){m<<errormsg("You can't speak while silenced.");return}
			if(!message || message == "") return
			message = copytext(check(message),1,350)

			for(var/mob/Player/p in Players)
				if((p.House == "Ravenclaw" || p.admin) && p.listenhousechat)
					p << "<b><span style=\"font-size:2; color:blue\">Ravenclaw Channel> </span><span style=\"font-size:2; color:silver\">[m.prevname ? m.prevname : name]:</span></b> <span style=\"color:white;\">[message]</span>"

			chatlog << "<b><span style=\"color:blue;\">Ravenclaw> [m.prevname ? m.prevname : name]:</span></b> <span style=\"color:white;\">[message]</span><br>"



		Slytherin_Chat(var/message as text)
			if(!listenhousechat)
				usr << "You are not listening to Slytherin chat."
				return
			var/mob/Player/m = src
			if(m.mute==1||m.Detention){m<<errormsg("You can't speak while silenced.");return}
			if(!message || message == "") return
			message = copytext(check(message),1,350)

			for(var/mob/Player/p in Players)
				if((p.House == "Slytherin" || p.admin) && p.listenhousechat)
					p << "<b><span style=\"font-size:2; color:green\">Slytherin Channel> </span><span style=\"font-size:2; color:silver\">[m.prevname ? m.prevname : name]:</span></b> <span style=\"color:white;\">[message]</span>"

			chatlog << "<b><span style=\"color:green;\">Slytherin> [m.prevname ? m.prevname : name]:</span></b> <span style=\"color:white;\">[message]</span><br>"



		Hufflepuff_Chat(var/message as text)
			if(!listenhousechat)
				usr << "You are not listening to Hufflepuff chat."
				return
			var/mob/Player/m = src
			if(m.mute==1||m.Detention){m<<errormsg("You can't speak while silenced.");return}
			if(!message || message == "") return

			for(var/mob/Player/p in Players)
				if((p.House == "Hufflepuff" || p.admin) && p.listenhousechat)
					p << "<b><span style=\"font-size:2; color:yellow\">Hufflepuff Channel> </span><span style=\"font-size:2; color:silver\">[m.prevname ? m.prevname : name]:</span></b> <span style=\"color:white;\">[message]</span>"

			chatlog << "<b><span style=\"color:yellow;\">Hufflepuff> [m.prevname ? m.prevname : name]:</span></b> <span style=\"color:white;\">[message]</span><br>"


		Sanctuario(mob/Player/p in view()&Players)
			set category="Staff"

			var/obj/Sanctuario/s = new (loc)
			walk_towards(s, p, 2)
			sleep(20)
			s.loc = null
			flick('apparate.dmi', p)
			sleep(5)
			p.Transfer(locate("@Hogwarts"))
			flick('apparate.dmi', p)
			sleep(20)
			p << "<b><span style=\"color:green;\">[usr]'s Sanctuario charm teleported you to Hogwarts.</span></b>"



mob
	test/verb
		Levelup(mob/Player/M in Players)
			set category = "Staff"
			var/lvls = input("Select number of levels to gain.") as null|num
			if(!lvls) return
			Log_admin("[src] has made [M] gain [lvls] levels")
			while(lvls>0)
				M.Exp = M.Mexp
				M.LvlCheck(1)
				lvls--
			src << "[M] is now level [M.level]."
mob
	GM/verb
		DJ_Log()
			set category = "DJ"
			usr<<browse(DJlog)
		View_Player_Log()
			if(!mysql_enabled) {alert("MySQL isn't enabled on this server."); return}
			var/input = input("This utility views the warnings, detentions, bans, etc. of a specified player. Do you wish to enter a ckey, or select a player?") as null|anything in list("Enter a ckey","Select a player")
			if(!input)return
			if(input == "Enter a ckey")
				var/inckey = input("Ckey/key of player?") as null|text
				if(!inckey) return
				usr << browse(sql_retrieve_plyr_log(ckey(inckey),usr),"window=1;size=600x450")

			else if(input == "Select a player")
				var/list/plyrs = list()
				for(var/client/C)
					plyrs.Add(C.mob)
				var/mob/sel = input("Which player would you like to view the log of?") as null|anything in plyrs
				if(!sel) return
				usr << browse(sql_retrieve_plyr_log(sel.ckey,usr),"window=1;size=600x450")
mob/proc/manual_view_player_log(ckey)
	src << browse(sql_retrieve_plyr_log(ckey,src),"window=1;size=600x450")

//GM STANDARD GOTO COMMAND//
mob/GM/verb
	Goto(mob/M in world)
		set category = "Staff"
		var/dense = density
		src.density=0
		src.Move(locate(M.x,M.y+1,M.z))
		src.density=dense
		M << "<b><span style=\"color:blue;\">[src]</span> has teleported to you.</b>"
		src << "With a flick of your wand, you find yourself next to <b>[M]</b>."



mob/GM/verb/Orb_Surroundings(var/mob/M in world)
	set category = "Staff"
	set popup_menu = 0
	for(var/mob/K in oview(1))

		flick('Dissapear.dmi',K)
		spawn(8)
			var/rnd = rand(-1,1)
			var/rnd2 = rand(-1,1)
			if(isplayer(K))
				K:Transfer(locate(M.x+rnd,M.y+rnd2,M.z))
			else
				K.loc = locate(M.x+rnd,M.y+rnd2,M.z)
			flick('Appear.dmi',K)
	sleep(8)
	flick('Dissapear.dmi',usr)
	usr.x = M.x
	usr.y = M.y+1
	usr.z = M.z
	flick('Appear.dmi',usr)
mob/GM/verb/Bring(mob/M in world)
	set category = "Staff"
	view(M)<<"[M] disappears (GM Summon)."
	M.flying = 0
	M.density = 1
	flick('Dissapear.dmi',M)
	sleep(20)
	if(isplayer(M))
		M:Transfer(locate(x,y,z))
	else
		M.loc = locate(x,y,z)
	flick('Appear.dmi',M)
	M << "You have been summoned."
	src << "You have summoned <b><span style=\"color:red;\">[M].</span></b>"

mob
	GM/verb
		Check_IP(mob/M in Players)
			set category = "Staff"
			set popup_menu = 0
			if(!M.client) return
			usr << "[M]'s IP: [M.client.address]"
			usr << "connection type: [M.client.connection]"


		Grant_Name_Change(mob/select in Players)
			set category="Staff"
			var/name2be
			:start
			name2be = input(select,"You have been instructed to change your name. Please select a new one.","Change your name",name2be) as text
			var/ans = alert(src,"[select] selected \"[name2be]\". Is this acceptable?","Name Change","Yes","No")
			if(ans == "Yes")
				select.name = name2be
				select:addNameTag()
				select << "Your selected name is accepted."
			else
				var/reason = input("The name was unacceptable due to it: (Finish the sentence)","Name Change") as text
				alert(select,"Your selected name was not acceptable due to it [reason]")
				goto start



		Detention(mob/Player/M in Players)
			set category = "Staff"
			for(var/mob/Player/A in Players)
				if(A.Gm) A << "<b><u><span style=\"color:#FF14E0;\">[src] has opened the Detention window on [M].</span></u></b>"
			var/timer = input("Set timer for detention in /minutes/ (Leave as 0 for detention to stick until you remove it)","Detention timer",0) as num|null
			if(timer == null) return
			var/Reason = input(src,"You are being Detentioned because you: <finish sentence>","Specify Why","harmed somebody within a safe zone (Hogwarts or Diagon Alley).") as null|text
			if(Reason == null) return
			if(M.key)
				if(M && M.removeoMob)
					spawn()
						var/mob/m = M
						m:Permoveo()
				M.density = 1
				flick('dlo.dmi',M)
				M.Detention=1
				sleep(10)
				M:Transfer(locate("Detention"))
				flick('dlo.dmi',M)
				M.MuteOOC=1
				hearers()<<"[name]: <b><span style=\"font-size:2;color:aqua;\">Incarcifors, [M].</span></b>"
				Players<<"[M] has been sent to Detention."
				M << "<b>Welcome to Detention.</b>"
				if(Reason)
					M << "You have been sent here because you [Reason]"
				else
					M << "Review the rules."
				spawn(55)M << browse(rules,"window=1")
			if(timer)
				Log_admin("[src] has detentioned [M]([M.ckey]) for [timer] minutes for [Reason]")
				M.timerDet = timer
				if(timer != 0)
					M << "<u>You're in detention for [timer] minute[timer==1 ? "" : "s"].</u>"
				spawn()M.detention_countdown()
			else
				Log_admin("[src] has detentioned [M]([M.ckey]) indefinitely for [Reason]")
			spawn()sql_add_plyr_log(M.ckey,"de",Reason,timer)

///////////// Floor Guidance \\\\\\\\\\\\

		Host_HM_Class()
			set category = "Teach"
			set name = "Host GCOM Class"
			classdest = input("Select a mob where your class will be held. (Usually just the invisible mob named HM Class. Note: The mob you select MUST be on the same floor as the default, or it won't work.)",,"HM_Class") as null|mob in world
			if(!classdest) return
			var/notes = input("Notes regarding class? (You're subbing for someone, etc.)") as text
			if(notes)
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a HM class - Notes: [notes]<br />"
			else
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a HM class<br />"
			curClass = "GCOM"
			for(var/mob/Player/p in Players)
				p.beep(2)
			for(var/mob/Player/p in Players)
				p << announcemsg("General Course of Magic class is starting. Click <a href=\"?src=\ref[p];action=class_path\">here</a> for directions.")
		Host_COMC_Class()
			set category = "Teach"
			classdest = input("Select a mob where your class will be held. (Usually just the invisible mob named COMC Class. Note: The mob you select MUST be on the same floor as the default, or it won't work.)",,"COMC-Class") as null|mob in world
			if(!classdest) return
			var/notes = input("Notes regarding class? (You're subbing for someone, etc.)") as text
			if(notes)
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a COMC class - Notes: [notes]<br />"
			else
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a COMC class<br />"
			for(var/mob/Player/p in Players)
				p << announcemsg("Care of Magical Creatures class is starting. Click <a href=\"?src=\ref[p];action=class_path\">here</a> for directions.")
			curClass = "COMC"
			for(var/mob/Player/p in Players)
				p.beep(2)
		Host_Trans_Class()
			set category = "Teach"
			classdest = input("Select a mob where your class will be held. (Usually just the invisible mob named Transfiguration Class. Note: The mob you select MUST be on the same floor as the default, or it won't work.)",,"Transfiguration-Class") as null|mob in world
			if(!classdest) return
			var/notes = input("Notes regarding class? (You're subbing for someone, etc.)") as text
			if(notes)
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a Transfiguration class - Notes: [notes]<br />"
			else
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a Transfiguration class<br />"
			curClass = "Transfiguration"
			for(var/mob/Player/p in Players)
				p.beep(2)
			for(var/mob/Player/p in Players)
				p << announcemsg("Transfiguration class is starting. Click <a href=\"?src=\ref[p];action=class_path\">here</a> for directions.")
		Host_Duel_Class()
			set category = "Teach"
			classdest = input("Select a mob where your class will be held. (Usually just the invisible mob named Charms. Note: The mob you select MUST be on the same floor as the default, or it won't work.)",,"Charms-Class") as null|mob in world
			if(!classdest) return
			var/notes = input("Notes regarding class? (You're subbing for someone, etc.)") as text
			if(notes)
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a Duel class - Notes: [notes]<br />"
			else
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a Duel class<br />"
			curClass = "Duel"
			for(var/mob/Player/p in Players)
				p.beep(2)
			for(var/mob/Player/p in Players)
				p << announcemsg("Duel class is starting. Click <a href=\"?src=\ref[p];action=class_path\">here</a> for directions.")
		Host_DADA_Class()
			set category = "Teach"
			classdest = input("Select a mob where your class will be held. (Usually just the invisible mob named DADA Class. Note: The mob you select MUST be on the same floor as the default, or it won't work.)",,"DADA-Class") as null|mob in world
			if(!classdest) return
			var/notes = input("Notes regarding class? (You're subbing for someone, etc.)") as text
			if(notes)
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a DADA class - Notes: [notes]<br />"
			else
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a DADA class<br />"
			curClass = "DADA"
			for(var/mob/Player/p in Players)
				p.beep(2)
			for(var/mob/Player/p in Players)
				p << announcemsg("Defence Against the Dark Arts class is starting. Click <a href=\"?src=\ref[p];action=class_path\">here</a> for directions.")
		Host_Headmaster_Class()
			set category = "Teach"
			classdest = input("Select a mob where your class will be held. (Usually just the invisible mob named Headmaster Class. Note: The mob you select MUST be on the same floor as the default, or it won't work.)",,"Headmaster-Class") as null|mob in world
			if(!classdest) return
			var/notes = input("Notes regarding class? (You're subbing for someone, etc.)") as text
			if(notes)
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a Headmaster class - Notes: [notes]<br />"
			else
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a Headmaster class<br />"
			curClass = "Headmasters"
			for(var/mob/Player/p in Players)
				p.beep(2)
			for(var/mob/Player/p in Players)
				p << announcemsg("Headmaster's General Magic class is starting. Click <a href=\"?src=\ref[p];action=class_path\">here</a> for directions.")
		Host_Charms_Class()
			set category = "Teach"
			classdest = input("Select a mob where your class will be held. (Usually just the invisible mob named Charms Class. Note: The mob you select MUST be on the same floor as the default, or it won't work.)",,"Charms-Class") as null|mob in world
			if(!classdest) return
			var/notes = input("Notes regarding class? (You're subbing for someone, etc.)") as text
			if(notes)
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a Charms class - Notes: [notes]<br />"
			else
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a Charms class<br />"
			curClass = "Charms"
			for(var/mob/Player/p in Players)
				p.beep(2)
			for(var/mob/Player/p in Players)
				p << announcemsg("Charms class is starting. Click <a href=\"?src=\ref[p];action=class_path\">here</a> for directions.")

		Host_Muggle_Studies_Class()
			set category = "Teach"
			classdest = input("Select a mob where your class will be held. (Usually just the invisible mob named Muggle Studies. Note: The mob you select MUST be on the same floor as the default, or it won't work.)") as null|mob in world
			if(!classdest) return
			var/notes = input("Notes regarding class? (You're subbing for someone, etc.)") as text
			if(notes)
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a Muggle Studies class - Notes: [notes]<br />"
			else
				classlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]: [usr] started a Muggle Studies class<br />"
			curClass = "Muggle Studies"
			for(var/mob/Player/p in Players)
				p.beep(2)
			for(var/mob/Player/p in Players)
				p << announcemsg("Muggle Studies class is starting. Click <a href=\"?src=\ref[p];action=class_path\">here</a> for directions.")

		End_Floor_Guidence()
			set category = "Teach"
			set name = "End Floor Guidance"
			var/stillpathing = ""
			for(var/mob/Player/M in Players)
				if(M.classpathfinding)
					stillpathing += "\n  [M.name]"
					for(var/image/C in M.client.images)
						if(C.icon == 'arrows.dmi')
							M.client.images.Remove(C)
					M.classpathfinding = 0
			if(stillpathing != "")
				for(var/mob/Player/M in Players)
					if(M.Gm)
						M << infomsg("The following players were currently using floor guidance. Maybe they want to come?:[stillpathing]")
			usr<<infomsg("Floor Guidance offline.")
			classdest = null

		Toggle_Safemode()
			set category = "Staff"
			if(safemode)
				src << "<b>Players can now use offensive spells in <u>all</u> safezones.</b>"
				safemode = 0
			else
				src << "<b>Players can no longer use offensive spells in <u>all</u> safezones.</b>"
				safemode = 1
		Toggle_Area_Safemode()
			set category = "Staff"
			var/area/A = loc.loc
			if(!A.safezoneoverride)
				src << "<b>Players can now use offensive spells in [loc.loc].</b>"
				A.safezoneoverride = 1
			else
				src << "<b>Players can no longer use offensive spells in [loc.loc].</b>"
				A.safezoneoverride = 0

		Release_From_Detention(mob/Player/M in Players)
			set category = "Staff"
			set popup_menu = 0
			if(M && M.removeoMob)
				spawn()
					var/mob/m = M
					m:Permoveo()
			flick('dlo.dmi',M)
			M.Transfer(locate("@Hogwarts"))
			M.Detention=0
			M.MuteOOC=0
			Players<<"[M] has been released from Detention."
			spawn()M.client.update_individual()
		Stealth_Orb(mob/M in world)
			set category = "Staff"
			set popup_menu = 0
			src.x = M.x
			src.y = M.y+1
			src.z = M.z
			usr<<"You orb silently behind [M]."

		Immortal()
			set category="Staff"
			var/mob/Player/p = src
			if(p.Immortal==0)
				flick('mist.dmi',p)
				p<<"You are now Immortal."
				p.Immortal=1
			else if(p.Immortal==1)
				flick('mist.dmi',p)
				p<<"You are now a Mortal."
				p.Immortal=0
		Give_Immortality(mob/Player/M in world)
			set category="Staff"
			set popup_menu = 0
			if(M.Immortal==0)
				flick('mist.dmi',M)
				M<<"<b><span style=\"color:aqua;\">[src] has made you an Immortal. You can no longer die.</span>"
				M.Immortal=1
			else if(M.Immortal==1)
				flick('mist.dmi',M)
				M<<"<b><span style=\"color:blue;\">[src] has made you a Mortal. You are now vulnerable to Death.</span>"
				M.Immortal=0
		Mute(mob/Player/M in Players)
			set category = "Staff"
			if(M.mute==0)
				M.mute=1
				Players << "\red <b>[M] has been silenced by [src].</b>"
				var/timer = input("Set timer for mute in /minutes/ (Leave as 0 for mute to stick until you remove it)","Mute timer",0) as num|null
				if(timer==null)return
				var/Reason = input(src,"You are being muted because you: <finish sentence>","Specify Why","spammed OOC.") as null|text
				if(Reason)
					M << "<b>You've been muted because you [Reason]</b>"
				if(timer==0)
					Log_admin("[src] has muted [M]([M.ckey]) indefinitely for [Reason]")
				else
					Log_admin("[src] has muted [M]([M.ckey]) for [timer] minutes for [Reason]")
					M.timerMute = timer
					if(timer != 0)
						M << "<u>You've been muted for [timer] minute[timer==1 ? "" : "s"].</u>"
					spawn()M.mute_countdown()

				spawn()sql_add_plyr_log(M.ckey,"si",Reason,timer)

			else
				M.timerMute = 0
				M.mute=0
				Players<<"<b><span stlye=\"color:red;\">[M] has been unsilenced.</span></b>"
				Log_admin("[src] has unmuted [M]")

		Event_Announce(message as message)
			set category = "Staff"
			set desc = "(message) Announce something to all players logged in"
			if(!message)return
			eventlog << "<tr><td><b>[src.name]</b></td><td>[time2text(world.realtime,"MMM DD YYYY - hh:mm:ss")]</td><td>[message]</td></tr>"
			for(var/mob/Player/p in Players)
				p.beep(1)
				p <<  "<hr><center><span style=\"color:blue;\"><b>Announcement From [src]:</b></span><br><span style=\"color:red;\"><b>[message]</span><hr></center>"
			if(!mysql_enabled) return
			var/sql = "INSERT INTO tblEventLogs(name,timestamp,message) VALUES([mysql_quote("[name] ([key])")],UNIX_TIMESTAMP(),[mysql_quote(message)])"
			var/DBQuery/qry = my_connection.NewQuery(sql)
			qry.Execute()
		Announce(message as message)
			set category = "Staff"
			set name = "Announce"
			set desc = "(message) Announce something to all players logged in"
			if(!message)return
			for(var/client/C)
				C.mob << "<hr><center><span style=\"color:blue;\"><b>Announcement From [src]:</b></span><br><span style=\"color:red;\"><b>[message]</span><hr></center>"
		Reboot()
			set category = "Staff"
			switch(input("Are you sure you'd like to reboot?","?") in list("Yes", "Yes & Save", "No"))
				if("Yes")
					world.Reboot()
				if("Yes & Save")
					for(var/mob/Player/p in Players)
						if(z >= SWAPMAP_Z)
							loc = locate("leavevault")
						p.Save()
					Save_World()
					sleep(1)
					world.Reboot()
		Shutdown()
			set category = "Staff"
			switch(input("Are you sure you'd like to shut down?","?")in list("Yes","No"))
				if("Yes")
					Players << "<B><p align=center><span style=\"color:red;\"><u>ATTENTION</u></span><p align=center><b>The Server is being shutdown temporarily.<p align=center><b><span style=\"color:blue;\">See you again soon!</span></b>"
					sleep(50)
					del world
				if("No")
					return
		Create(O as null|anything in typesof(/obj,/mob,/turf,/area))
			set category = "Staff"
			set name = "Create"
			set desc="(object) Create a new mob, or obj"

			if(!O)
				return

			if(!admin)
				if(z < SWAPMAP_Z)
					src << errormsg("You can only use it inside swap maps.")
					return
				if(ispath(O, /obj/items) || ispath(O, /mob))
					src << errormsg("Only admins can create this.")
					return

			var/item = new O(usr.loc)
			if(isobj(item))item:owner = usr.key
			if(isobj(item)||ismob(item))hearers() << "With a flick of [usr]'s wand, a [item:name] appears."
			if(ispath(O, /obj/items)) Log_admin("<b>[src.name] ([src.ckey]) has created [item:name]</b>")
		Search_Create()
			set category="Staff"
			usr.client<<link("?command=create;")
		/*Edit(A in world)
			set category="Staff"
			usr.client<<link("?command=edit;target=\ref[A];type=view;")*/
		Edit(obj/O as obj|mob|turf|area in world)
			set category = "Staff"
			set name = "Edit"
			set desc="(target) Edit a target item's variables"

			if(O==null)return

			if(!admin && (istype(O, /obj/items) || istype(O, /obj/pet) || isarea(O) || O.z < SWAPMAP_Z || z < SWAPMAP_Z || ismob(O)))
				return

			var/list/builtin[0]
			var/list/temp[0]
			var/list/custom[0]
			var/list/temp_custom[0]
			var/found = FALSE

			var/search_for
			if(isturf(O))
				search_for = "loc"
			else if(isobj(O))
				search_for = "animate_movement"
			else
				search_for = "type"

			for(var/s in O.vars)
				if(s == search_for)
					found = TRUE
				else if((s == "pmsRec" || s == "pmsSen")&&ckey!="murrawhip") continue
				else if(s == "step_x" || s == "step_y" || s == "step_size" || s == "bounds") continue
				if(!issaved(O.vars[s]))
					if(found)
						temp.Add(s)
					else
						temp_custom.Add(s)
				else if(found)
					builtin.Add(s)
				else
					custom.Add(s)

			var/list/options = list()
			if(builtin.len)     options += "Built in"
			if(temp.len)        options += "Temp"
			if(custom.len)      options += "Custom"
			if(temp_custom.len) options += "Temp Custom"

			var/variable
			switch(input("Which var type?","Var") as null|anything in options)
				if("Built in")
					variable = input("Which var?","Var") as null|anything in builtin
				if("Temp")
					variable = input("Which var?","Var") as null|anything in temp
				if("Custom")
					variable = input("Which var?","Var") as null|anything in custom
				if("Temp Custom")
					variable = input("Which var?","Var") as null|anything in temp_custom

			if(!variable) return

			var/default
			var/typeof = O.vars[variable]
			var/dir

			if(isnull(typeof))
				usr << "Unable to determine variable type."
			else if(isnum(typeof))
				usr << "Variable appears to be <b>NUM</b>."
				default = "num"
				dir = 1

			else if(istext(typeof))
				usr << "Variable appears to be <b>TEXT</b>."
				default = "text"

			else if(isloc(typeof))
				usr << "Variable appears to be <b>REFERENCE</b>."
				default = "reference"

			else if(isicon(typeof))
				usr << "Variable appears to be <b>ICON</b>."
				typeof = "\icon[typeof]"
				default = "icon"

			else if(istype(typeof,/atom) || istype(typeof,/datum))
				usr << "Variable appears to be <b>TYPE</b>."
				default = "type"

			else if(istype(typeof,/list))
				usr << "Variable appears to be <b>LIST</b>."
				default = "list"

			else if(istype(typeof,/client))
				usr << "Variable appears to be <b>CLIENT</b>."
				usr << "*** Warning!  Clients are uneditable ***"
				default = "cancel"

			else
				usr << "Variable appears to be <b>FILE</b>."
				default = "file"

			usr << "Variable contains: [typeof]"
			if(dir)
				switch(typeof)
					if(1)
						dir = "NORTH"
					if(2)
						dir = "SOUTH"
					if(4)
						dir = "EAST"
					if(8)
						dir = "WEST"
					if(5)
						dir = "NORTHEAST"
					if(6)
						dir = "SOUTHEAST"
					if(9)
						dir = "NORTHWEST"
					if(10)
						dir = "SOUTHWEST"
					else
						dir = null
				if(dir)
					usr << "If a direction, direction is: [dir]"

			var/class

			options = list("text","num","type","reference","icon","file","restore to default")

			if(default=="list")
				options += "list"

			if(istype(O.vars[variable], /datum))
				options += "Edit reference"

			class = input("What kind of variable?","Variable Type",default) as null|anything in options

			switch(class)
				if("Edit reference")
					spawn() Edit(O.vars[variable])
				if("restore to default")
					O.vars[variable] = initial(O.vars[variable])

				if("text")
					O.vars[variable] = input("Enter new text:","Text",\
						O.vars[variable]) as text

				if("num")
					O.vars[variable] = input("Enter new number:","Num",\
						O.vars[variable]) as num

				if("type")
					O.vars[variable] = input("Enter type:","Type",O.vars[variable]) \
						in typesof(/obj,/mob,/area,/turf)

				if("reference")
					O.vars[variable] = input("Select reference:","Reference",\
						O.vars[variable]) as mob|obj|turf|area in world

				if("file")
					O.vars[variable] = input("Pick file:","File",O.vars[variable]) \
						as file

				if("list")
					var/list/l = O.vars[variable]
					var/v = input("Which?","Count: [l.len]") as null|anything in l
					if(!v) return
					if(istype(v,/datum))
						spawn() Edit(v)
					else if(istext(v))
						if(l[v])
							if(istype(l[v],/datum))
								spawn() Edit(l[v])
							else if(isnum(l[v]))
								l[v] = input("Enter new number:","Num",\
									l[v]) as num
							else if(istext(l[v]))
								l[v] = input("Enter new text:","Text",\
									l[v]) as text
					else if(isnum(v))
						v = input("Enter new number:","Num", v) as num

					else
						usr << "Can't edit"


				if("icon")
					O.vars[variable] = input("Pick icon:","Icon",O.vars[variable]) \
						as icon
		Disconnect(mob/M in world)
			set category="Staff"
			switch(alert("Disconnect: [M]","Disconnect Player","Yes","No"))
				if("Yes")
					Players<<"<b><span style=\"color:red;\">[M] has been disconnected from the server.</b></span>"
					if(!M.key)
						del(M)
						return
					M.Save()
					var/tmpckey = M.ckey
					var/tmpname = M.name
					del(M)
					var/Reason = input("Why was [tmpname] disconnected?")
					spawn()sql_add_plyr_log(tmpckey,"di",Reason)
					Log_admin("[src] has disconnected [tmpname]")
		Phase()
			set category = "Staff"
			if(usr.density == 1)
				usr << "You phase out, allowing you to walk on water and through walls."//sends the msg to the user
				usr.density = 0
			else if(usr.density == 0)
				usr << "You are solid again."
				usr.density = 1
		Cloak()
			set category = "Staff"
			var/mob/Player/p = src
			if(p.cloaked==0)
				hearers() << "<b>[usr] has vanished."
				flick('GMOrb.dmi',usr)
				sleep(9)
				p.icon = null
				p.cloaked=1
				p.density=0
				p.underlays = list()
				p.overlays = list()
			else
				hearers() << "<b>[usr] has appeared."
				//usr.icon = usr.mprevicon
				flick('GMOrb.dmi',usr)
				sleep(11)
				p.icon = usr.baseicon
				p.ApplyOverlays()
				p.invisibility=0
				p.cloaked=0
				p.density=1
				p.addNameTag()
		Freeze(var/mob/Player/M in Players)
			set popup_menu = 0
			set category="Staff"
			if(!M.GMFrozen)
				M.GMFrozen=1
				M.overlays+='freeze.dmi'
				M<<"You have been frozen."
			else
				M.GMFrozen=0
				M.overlays-='freeze.dmi'
				M<<"You have been unfrozen."
		Teleport_Someone(mob/teleportee as mob in world, mob/destination as mob in world)
			set category="Staff"
			set desc="Teleport Self or Other to Target"
			var/originalden = teleportee.density
			teleportee.density = 0
			teleportee.loc = destination.loc
			teleportee.density = originalden
			hearers(teleportee) << "[teleportee] appears in a flash of light."
mob/GM/verb
	Ban(mob/M in Players)
		set category = "Staff"
		if(M.key=="MaxIsJoe")
			Players<<"<b>[src] tried to ban [M] but it bounced off and [usr] banned themself!"
			Log_admin("[src] tried to ban [M] but banned themself by default")
			crban_fullban(usr)
		else
			M.Save()
			Players<<infomsg("[M] has been suspended from The Wizards' Chronicles.")
			var/tmpckey = M.ckey
			var/tmpname = M.name
			crban_fullban(M)
			var/Reason = input("Why was [tmpname] banned?")
			var/timer = input("Set timer for ban in /days/ (Leave as 0 for ban to stick indefinitely)","Ban timer",0) as num
			if(!timer)
				Log_admin("[src] has fullbanned [tmpname]([tmpckey]) indefinitely")
			else
				Log_admin("[src] has fullbanned [tmpname]([tmpckey]) for [timer] days")
			sql_add_plyr_log(tmpckey,"ba",Reason,timer)

	Unban(key as text)
		set category = "Staff"
		//var/A = input("Select the key of the person you wish to unban:","Unban") as null|anything in crban_keylist
		//if(!key)return
		if(key)Log_admin("[src] has unbanned [key]")
		crban_unban(key)
	Unban_list()
		set category = "Staff"
		var/bban = ""
		for(var/A in crban_keylist)
			bban += "<br>[A]"
		src << browse("The following keys are banned: [bban]","window=1")

var/OOCMute=0
mob/Player/var
	shortapparate  = 0
	tmp
		superspeed = 0
		cloaked    = 0

turf
	DblClick()
		..()

		var/mob/Player/p = usr
		if(p.shortapparate && !(p.prevname))
			if(!density)// && get_dist(usr,src) <25)
				flick('apparate.dmi',p)
				if(p.density)
					p.density = 0
					p.Move(src)
					p.density = 1
				else
					p.Move(src)
				flick('apparate.dmi',p)
		else
			if(p.superspeed && p.nomove == 0)

				var/turf/t
				if(!p.admin)
					if(density) return

					var/obj/o = new (p.loc)
					o.density = 1

					var/steps = 10
					while(o.loc != src && steps > 0)
						steps--
						var/check = get_step_to(o, src)
						if(!check) break

						o.loc = check
						t     = check

					o.loc = null
				else
					t = src

				if(t)
					p.jumpTo(t)


mob/Player/proc/jumpTo(turf/t)
	set waitfor = 0
	nomove = 2
	var
		px = (x * 32) - (t.x * 32)
		py = (y * 32) - (t.y * 32)

	dir = get_dir(src, t)

	var/time = round(((abs(px) + abs(py)) / 32) * 0.5)

	var/list/ghosts = list()
	for(var/i = 1 to 4)
		var/image/o = new
		o.appearance = appearance
		o.alpha = 255 - i * 50

		o.pixel_x = px * 0.1 * i
		o.pixel_y = py * 0.1 * i

		ghosts += o

	var/underlaysTmp = underlays.Copy()
	underlays += ghosts

	animate(src, pixel_x = -px,
	             pixel_y = -py, time = time)


	animate(client, pixel_x = -px,
	                pixel_y = -py, time = time)

	sleep(time + 1)
	pixel_x = 0
	pixel_y = 0

	var/dense = density
	density = 0
	Move(t)
	if(!density)
		density = dense

	client.pixel_x = 0
	client.pixel_y = 0

	underlays = underlaysTmp
	nomove = 0



mob/GM
	verb
		Edit_Rules()
			set category = "Staff"
			var/input = input("Rules - Back up the contents prior to editing. Thanks.","TWC Rules",file2text(rules)) as null|message
			if(!input) return
			fdel("rules.html")
			file("rules.html") << "[input]"
			src << "Rules posted. Thanks."

mob/GM
	verb
		Reset_Matchmaking()
			if(alert(src, "Are you sure you want to reset matchmaking?", "Reset Matchmaking Scoreboard", "Yes", "No") == "Yes")

				for(var/k in worldData.playersData)
					var/PlayerData/p = worldData.playersData[k]

					if(abs(p.fame) < 10)
						worldData.playersData -= k
					else
						p.mmWins   = initial(p.mmWins)
						p.mmRating = initial(p.mmRating)
						p.mmTime   = initial(p.mmTime)

				src << infomsg("Competitive Matchmaking scoreboard deleted.")
		Check_Inactivity(mob/M in Players)
			set category = "Staff"
			var/time = "Inactive for "
			var/ticks = M.client.inactivity
			var/seconds = round(ticks/10)
			var/minutes = round(seconds/60)
			seconds -= minutes * 60
			var/hours = round(minutes/60)
			minutes -= hours * 60
			if(hours) time += "[hours] [hours > 1 ? "hours" : "hour"]"
			if(minutes)
				if(hours) time += ", "
				time += "[minutes] [minutes > 1 ? "minutes" : "minute"]"
			if(seconds)
				if(minutes) time += ", and "
				time += "[seconds] [seconds > 1 ? "seconds" : "second"]."
			else
				if(minutes) time += ", and "
				time += "0 seconds."
			usr << infomsg("[time]")


////////// GM Freezing \\\\\\\\\\\\\\\\

mob/GM
	verb
		Freeze_Area()
			set category="Staff"
			usr<<"With a flick of your wand, you Freeze your view!"
			for(var/mob/Player/M in ohearers(client.view, src))
				if(M != src && !M.GMFrozen)
					M.GMFrozen=1
					M.overlays+='freeze.dmi'

		Unfreeze_Area()
			set category="Staff"
			usr<<"With a flick of your wand, you UnFreeze your view!"
			for(var/mob/Player/M in ohearers(client.view, src))
				if(M != src && M.GMFrozen)
					M.GMFrozen=0
					M.overlays-='freeze.dmi'

		AddItem(var/s in shops, var/path in (typesof(/obj/items)-/obj/items))
			set category="Staff"
			set name = "Add item to shop"

			var/new_price = input("Price", "[path]") as null|num
			if(new_price)
				var/obj/items/i = new path()
				i.price = new_price
				shops[s] += i

				var/new_limit = input("Limit (0 for infinite)", "[path]", 0) as null|num
				i.limit = new_limit	? new_limit : 0

		Add_Prize(var/path in (typesof(/obj/items)-/obj/items))
			set category="Staff"
			if(!worldData.prizeItems) worldData.prizeItems = list()

			worldData.prizeItems += path
			src << infomsg("[path] added to prize list.")

		Remove_Prize(var/path in worldData.prizeItems)
			set category="Staff"
			worldData.prizeItems -= path

			if(!worldData.prizeItems.len) worldData.prizeItems = null

			src << infomsg("[path] removed from prize list.")

		Give_Prize(var/mob/Player/p in Players())
			set category="Events"
			var/note = input("Special notes, you would usually write name of the event and the round this reward was given, for example: \"Free For All - Round 2\"", "Notes") as null|text
			if(note && note != "")

				switch(alert("Which prize?", "Give Prize", "Gold", "Common Item", "Rare Item"))
					if("Gold")
						var/gold_prize = input("How much gold?", "Gold Prize") as null|num
						if(gold_prize)
							var/gold/g = new(bronze=gold_prize)
							g.give(p)
							hearers() << infomsg("<i>[name] gives [p] [g.toString()].</i>")
							goldlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm")]: [name]([key])([client.address]) gave [comma(gold_prize)] <b>prize</b> gold to [p.name]([p.key])([p.client.address]) Notes: [note]<br />"
					if("Common Item")
						var/i = pickweight(list(/obj/items/key/basic_key = 25,
										   /obj/items/artifact           = 20,
		                        		   /obj/items/key/wizard_key     = 20,
		                        		   /obj/items/key/pentakill_key  = 20,
								   		   /obj/items/key/sunset_key     = 10,
										   /obj/items/key/winter_key     = 10))


						var/obj/items/item_prize = new i (p)
						hearers() << infomsg("<i>[name] gives [p] [item_prize.name].</i>")
						goldlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm")]: [name]([key])([client.address]) gave [item_prize.name] <b>prize</b> common item to [p.name]([p.key])([p.client.address]) Notes: [note]<br />"


					if("Rare Item")
						if(!worldData.prizeItems)
							src << errormsg("No rare items to give.")
							return

						var/i = pick(worldData.prizeItems)
						worldData.prizeItems -= i
						if(!worldData.prizeItems.len) worldData.prizeItems = null

						var/obj/items/item_prize = new i (p)
						p.Resort_Stacking_Inv()
						hearers() << infomsg("<i>[name] gives [p] [item_prize.name].</i>")
						goldlog << "[time2text(world.realtime,"MMM DD YYYY - hh:mm")]: [name]([key])([client.address]) gave [item_prize.name] <b>prize</b> rare item to [p.name]([p.key])([p.client.address]) Notes: [note]<br />"

		RemoveItem(var/s in shops)
			set category="Staff"
			set name = "Remove item from shop"

			var/obj/items/i = input("Select item", "[s]") as null|obj in shops[s]
			if(i)
				shops[s] -= i
				del i

		EditItem(var/s in shops)
			set category = "Staff"
			set name = "Edit item price/limit"

			var/obj/items/i = input("Select item", "[s]") as null|obj in shops[s]
			if(i)
				EDITITEM
				switch(alert(src, "Price or limit", "Edit Item", "Price", "Limit", "Cancel"))
					if("Price")
						var/new_price = input("New price", i.name, i.price) as null|num
						if(new_price)
							i.price = new_price
						goto EDITITEM
					if("Limit")
						var/new_limit = input("New limit (0 for infinite)", i.name, i.limit) as null|num
						if(new_limit)
							i.limit = new_limit
						goto EDITITEM


		Competitive_Ban(var/k as text)
			set category = "Staff"
			k = ckey(k)
			if(!k || k == "") return
			if(!worldData.competitiveBans) worldData.competitiveBans = list()

			if(!(k in worldData.competitiveBans)) worldData.competitiveBans += k
			src << infomsg("[k] is now banned from competitive matchmaking.")

			for(var/mob/Player/p in Players)
				if(p.ckey == k)
					var/hudobj/Find_Duel/o = locate(/hudobj/Find_Duel) in p.client.screen
					if(o)
						o.hide()
						if(p in worldData.currentMatches.queue)
							worldData.currentMatches.removeQueue(p)

					p.matchmaking_ready = 0
					for(var/obj/hud/duel/d in p.client.screen)
						p.client.screen -= d
					break

		Competitive_Unban(var/k in worldData.competitiveBans)
			set category = "Staff"

			worldData.competitiveBans -= k
			if(!worldData.competitiveBans.len) worldData.competitiveBans = null

			src << infomsg("[k] is now unbanned from competitive matchmaking.")


var
	crban_bannedmsg="<span style=\"color:red;\"><big><tt>You're banned.</tt></big></span>"
	crban_preventbannedclients = 0 // See above comments
	crban_keylist[0]  // Banned keys and their associated IP addresses
	crban_iplist[0]   // Banned IP addresses
	crban_ipranges[0] // Banned IP ranges
	crban_unbanned[0] // So we can remove bans (list of ckeys)
mob/test/verb/Reload_Bans()
	world.Load_Bans()
proc/crban_fullban(mob/M)
	// Ban the mob using as many methods as possible, and then boot them for good measure
	if (!M || !M.key || !M.client) return
	crban_unbanned.Remove(M.ckey)
	crban_key(M.ckey)
	crban_IP(M.client.address)
	//crban_client(M.client)
	crban_ie(M)
	del M
	world.Save_Bans()

proc/crban_fullbanclient(client/C)
	// Equivalent to above, but is passed a client
	if (!C) return
	crban_key(C.ckey)
	crban_IP(C.address)
	//crban_client(C)
	crban_ie(C)
	del C

proc/crban_isbanned(X)
	// When given a mob, client, key, or IP address:
	// Returns 1 if that person is banned.
	// Returns 0 if they are not banned.
	// Only considers basic key and IP bans; but that is sufficient for most purposes.
	if (istype(X,/mob)) X=X:ckey
	if (istype(X,/client)) X=X:ckey
	if (ckey(X) in crban_unbanned) return 0
	if ((X in crban_iplist) || (ckey(X) in crban_keylist)) return 1
	else return 0

proc/crban_getworldid()
	var/worldid=world.address
	while (findtext(worldid,"."))
		worldid=copytext(worldid,1,findtext(worldid,"."))+"_"+copytext(worldid,findtext(worldid,".")+1)
	return worldid

proc/crban_ie(mob/M)
	var/html="<html><body onLoad=\"document.cookie='cr[crban_getworldid()]=k; \
expires=Fri, 31 Dec 2060 23:59:59 UTC'\"; document.write(document.cookie)></body></html>"
	M << browse(html,"window=crban;titlebar=0;size=1x1;border=0;clear=1;can_resize=0")
	sleep(3)
	M << browse(null,"window=crban")

proc/crban_IP(address)
	if (!crban_iplist.Find(address) && address && address!="localhost" && address!="127.0.0.1")
		crban_iplist.Add(address)

proc/crban_iprange(partialaddress as text, appendperiod=1)
	//// Bans a range of IP addresses, given by "partialaddress". See the comments at the top of this file.
	//// If "appendperiod" is false, the ban will match partial numbers in the IP address.
	//// Again, see the comments at the top of this file.
	//// Returns the range of IP addresses banned, or null upon failure (e.g. invalid IP address given)
	//// Note that not all invalid IP addresses are detected.

	// Parse for valid IP address
	partialaddress=crban_parseiprange(partialaddress, appendperiod)

	// We don't want to end up banning everyone
	if (!partialaddress) return null

	// Add IP range
	if (partialaddress in crban_ipranges)
		usr << "The IP range '[partialaddress]' is already banned."
	else
		crban_ipranges += partialaddress

	// Ban affected clients
	for (var/client/C)
		if (!C.mob) continue // Sanity check
		if (copytext(C.address,1,length(partialaddress)+1)==partialaddress)
			usr << "Key '[C.key]' [C.mob.name!=C.key ? "([C.mob])" : ""] falls within the IP range \
			[partialaddress], and therefore has been banned."
			crban_fullban(C.mob)

	// Return what we banned
	return partialaddress

proc/crban_parseiprange(partialaddress, appendperiod=1)
	// Remove invalid characters (everything except digits and periods)
	var/charnum=1
	while (charnum<=length(partialaddress))
		var/char=copytext(partialaddress,charnum,charnum+1)
		if (char==",")
			// Replace commas with periods (common typo)
			partialaddress=copytext(partialaddress,1,charnum)+"."+copytext(partialaddress,charnum+1)
		else if (!(char in list("0","1","2","3","4","5","6","7","8","9",".")))
			// Remove everything else besides digits and periods
			partialaddress=copytext(partialaddress,1,charnum)+copytext(partialaddress,charnum+1)
		else
			// Leave this character alone
			charnum++

	// If all of the characters were invalid, quit while we're a head
	if (!partialaddress) return null

	// Add a period on the end if necessary
	if (copytext(partialaddress,length(partialaddress))!=".")
		// Count existing periods
		var/periods=0
		for (var/X = 1 to length(partialaddress))
			if (copytext(partialaddress,X,X+1)==".") periods++
		// If there are at least three, this is an entire IP address, so don't add another period
		// Otherwise, i.e. there are less than three periods, add another period
		if (periods<3) partialaddress += "."

	return partialaddress

proc/crban_key(key as text,address as text)
	var/ckey=ckey(key)
	crban_unbanned.Remove(ckey)
	if (!crban_keylist.Find(ckey))
		crban_keylist.Add(ckey)
		crban_keylist[ckey]=address

proc/crban_unban(key as text)
	//Unban a key and associated IP address
	key=ckey(key)
	if (key && crban_keylist.Find(key))
		usr << "Key '[key]' unbanned."
		crban_iplist.Remove(crban_keylist[key])
		crban_keylist.Remove(key)
		crban_unbanned.Add(key)
	world.Save_Bans()

proc/crban_client(client/C)
	return
	var/F=C.Import()
	var/savefile/S = F ? new(F) : new()
	S["[ckey(world.url)]"]<<1
	C.Export(S)

world/IsBanned(key, ip)
	.=..()
	if (!. && crban_preventbannedclients)
		//// Key check
		if (crban_keylist.Find(ckey(key)))
			if (key!="Guest")
				crban_IP(ip)
			// Disallow login
			for(var/mob/Player/P in Players)
				if(P.admin) P << "[src] ([key]) tried to log in. ([ip])"
			src << crban_bannedmsg
			return 1
		//// IP check
		if (crban_iplist.Find(address))
			if (crban_unbanned.Find(ckey(key)))
				//We've been unbanned
				crban_iplist.Remove(address)
			else
				//We're still banned
				src << crban_bannedmsg
				for(var/mob/Player/P in Players)
					if(P.admin) P << "[src] ([key]) tried to log in. ([ip])"
				return 1
		//// IP range check
		for (var/X in crban_ipranges)
			if (findtext(address,X)==1)
				src << crban_bannedmsg
				return 1
client/New()
	for (var/X in crban_ipranges)
		if (findtext(address,X)==1)
			crban_fullbanclient(src)
			src << crban_bannedmsg
			for(var/mob/Player/P in Players)
				if(P.admin) P << "[src] ([key]) tried to log in. ([address])"
			del src

	if (crban_keylist.Find(ckey))
		src << crban_bannedmsg
		for(var/mob/Player/P in Players)
			if(P.admin) P << "[src] ([key]) tried to log in.(Result of keyban. 1st tier.) ([address])"
		if (key!="Guest")
			crban_fullbanclient(src)
		del src

	if (crban_iplist.Find(address))
		if (crban_unbanned.Find(ckey))
			//We've been unbanned
			crban_iplist.Remove(address)
		else
			//We're still banned
			for(var/mob/Player/P in Players)
				if(P.admin) P << "[src] ([key]) tried to log in.(Result of IP ban. 2nd tier.) ([address])"
			src << crban_bannedmsg
			del src

	/*var/savefile/S=Import()
	if (ckey(world.url) in S)
		if (crban_unbanned.Find(ckey))
			//We've been unbanned
			S[world.url] << 0
			Export(S)
		else
			//We're still banned
			for(var/client/C)
				if(C.key == "Murrawhip") C << "[src] ([key]) tried to log in. (Result of Savefile ban. 3rd tier.)  ([address])"
			src << crban_bannedmsg
			crban_fullbanclient(src)
			del src*/

	if (address && address!="127.0.0.1" && address!="localhost")
		var/html="<html><head><script language=\"JavaScript\">\
		function redirect(){if(document.cookie){window.location='byond://?cr=ban;'+document.cookie}\
		else{window.location='byond://?cr=ban'}}</script></head>\
		<body onLoad=\"redirect()\">Please wait...</body></html>"
		src << browse(html,"window=crban;titlebar=0;size=1x1;border=0;clear=1;can_resize=0")
		spawn(20) src << browse(null,"window=crban")

	.=..()

client/Topic(href, href_list[])
	if (href_list["action"]=="teleport")
		if(usr.Gm)
			var/nx = text2num(href_list["x"])
			var/ny = text2num(href_list["y"])
			var/nz = text2num(href_list["z"])
			usr.loc = locate(nx,ny,nz)
			hearers() << "POOF!"
			hearers() << "<i>[usr] appears at the scene of the crime...</i>"
		else
			usr << "<b>Lol fuck off.</b>"
			Players << "[usr]([usr.client.address]) tried to hack the teleport function."
	if (href_list["cr"]=="ban")
		src << browse(null,"window=crban")
		if (href_list["cr"+crban_getworldid()]=="k")
			if (crban_unbanned.Find(ckey))
				// Unban
				var/html="<html><body onLoad=\"document.cookie='cr[crban_getworldid()]=n; \
				expires=Fri, 31 Dec 2060 23:59:59 UTC'\"></body></html>"
				mob << browse(html,"window=crunban;titlebar=0;size=1x1;border=0;clear=1;can_resize=0")
				spawn(10) mob << browse(null,"window=crunban")
			else
				src << crban_bannedmsg
				for(var/mob/Player/P in Players)
					if(P.admin) P << "[src] ([key]) tried to log in. (Result of Cookie ban. 4th tier.)  ([address])"
				crban_fullban(mob)
				del src
	.=..()
var/list/obj/Bed/Beds = list()
var/list/obj/Bed/AurorBeds = list()
var/list/obj/Bed/DEBeds = list()
var/list/obj/Bed/Map1Gbeds = list()
var/list/obj/Bed/Map1Sbeds = list()
var/list/obj/Bed/Map1Rbeds = list()
var/list/obj/Bed/Map1Hbeds = list()
var/list/obj/Bed/Map2DEbeds = list()
var/list/obj/Bed/Map2Aurorbeds = list()
var/list/turf/MapThreeWaitingAreaTurfs = list()
var
	mysql_enabled = 0
	mysql_host = "127.0.0.1"
	mysql_port = 3306
	mysql_database = "TWC"
	mysql_username = "root"
	mysql_password = "password"
	DBConnection/my_connection = new()
	DBI = ""
	connected = null

	clanadmin_hash = ""
world/New()
	world.log = file("Logs/[VERSION]-log.txt")
	world.log << "---WORLD STARTED- [time2text(world.realtime)] - WORLD STARTED---"
	var/INI/ini = new("config.ini")
	if(!fexists("config.ini"))
		world.log << "config.ini NOT FOUND."
	else
		var/Configuration/cfg_mysql = ini.GetSection("mysql")
		if(cfg_mysql.Value("mysql_enabled") == "true")
			mysql_enabled = 1
			mysql_host = cfg_mysql.Value("mysql_host")
			mysql_port = cfg_mysql.Value("mysql_port")
			mysql_database = cfg_mysql.Value("mysql_database")
			mysql_username = cfg_mysql.Value("mysql_username")
			mysql_password = cfg_mysql.Value("mysql_password")
			DBI = "dbi:mysql:[mysql_database]:[mysql_host]:[mysql_port]"
			connected = my_connection.Connect(DBI,mysql_username,mysql_password)
			if(!connected)
				world.log << my_connection.ErrorMsg()
				mysql_enabled = 0
		var/Configuration/cfg_clans = ini.GetSection("clans")
		clanadmin_hash = cfg_clans.Value("clanadmin_hash")
	Load_World()
	init_events()
	swapmaps_directory = "vaults"

	Load_Bans()
	for(var/turf/duelsystemcenter/T in world)duelsystems.Add(T)
	var/mob/Madame_Pomfrey/hosp = locate("hospital")
	var/mob/Madame_Pomfrey/DEhosp = locate("DEhospital")
	var/mob/Madame_Pomfrey/Aurorhosp = locate("Aurorhospital")
	for(var/obj/Bed/B in range(8,hosp))
		if(B.icon_state == "Top") Beds.Add(B)
	for(var/obj/Bed/B in range(8,DEhosp))
		if(B.icon_state == "Top") DEBeds.Add(B)
	for(var/obj/Bed/B in range(8,Aurorhosp))
		if(B.icon_state == "Top") AurorBeds.Add(B)
	for(var/obj/Bed/B in locate(/area/arenas/MapOne/Gryff))
		if(B.icon_state == "Top") Map1Gbeds.Add(B)
	for(var/obj/Bed/B in locate(/area/arenas/MapOne/Slyth))
		if(B.icon_state == "Top") Map1Sbeds.Add(B)
	for(var/obj/Bed/B in locate(/area/arenas/MapOne/Raven))
		if(B.icon_state == "Top") Map1Rbeds.Add(B)
	for(var/obj/Bed/B in locate(/area/arenas/MapOne/Huffle))
		if(B.icon_state == "Top") Map1Hbeds.Add(B)
	for(var/obj/Bed/B in locate(/area/arenas/MapTwo/DE))
		if(B.icon_state == "Top") Map2DEbeds.Add(B)
	for(var/obj/Bed/B in locate(/area/arenas/MapTwo/Auror))
		if(B.icon_state == "Top") Map2Aurorbeds.Add(B)
	for(var/turf/T in locate(/area/arenas/MapThree/WaitingArea))
		MapThreeWaitingAreaTurfs.Add(T)
	world.status = "<b><span style=\"font-family:'Comic Sans MS'; color:black;\">Server: <span style=\"color:blue;\">Community Server</span> || Version: <span style=\"color:red;\">[VERSION]</span></span></b>"
	for(var/mob/TalkNPC/M in world)
		M.GenerateNameOverlay(255,255,255)

	rankIcons = list()
	for(var/state in icon_states('Ranks.dmi'))
		rankIcons[state] = icon('Ranks.dmi', state)

	MapInitialized()

//	worldlooper()
world/proc/Load_Bans()
	var/savefile/S=new("players/cr_full.ban")
	S["key"] >> crban_keylist
	S["IP"] >> crban_iplist
	S["unban"] >> crban_unbanned
	if (!length(crban_keylist)) crban_keylist=list()
	if (!length(crban_iplist)) crban_iplist=list()
	if (!length(crban_unbanned)) crban_unbanned=list()
world/proc/Save_Bans()
	var/savefile/S=new("players/cr_full.ban")
	S["key"] << crban_keylist
	S["IP"] << crban_iplist
	S["unban"] << crban_unbanned

var/list/rankIcons


var
	list/__post_init = list()
	map_initialized = 0

proc
	MapInitialized()
		set waitfor = 0
		if(!map_initialized)
			map_initialized = 1
			for(var/atom/o in __post_init)
				o.MapInit()
			__post_init = null

atom
	var/post_init = 0

	New()
		if(map_initialized)
			post_init && MapInit()
		else if(post_init)
			__post_init[src] = 1

	proc/MapInit()

image
	roofedge
		icon = 'StoneRoof.dmi'
		appearance_flags = TILE_BOUND|RESET_COLOR|RESET_ALPHA
		layer = 10

		east
			icon_state = "edge-4"
			pixel_x = -32
		west
			icon_state = "edge-8"
			pixel_x = 32
		north
			icon_state = "edge-1"
			pixel_y = -32
		south
			icon_state = "edge-2"
			pixel_y = 32
	grassedge
		appearance_flags = RESET_COLOR
		icon = 'GrassEdge.dmi'

		north
			icon_state = "north"
		west
			icon_state = "west"
		east
			icon_state = "east"
		south
			icon_state = "south"

mob/test/verb/hireStaff((mob/Player/p in Players), color as text)

	if(!worldData.Gms) worldData.Gms = list()

	if(!(p.ckey in worldData.Gms))
		worldData.Gms += p.ckey

	if(!p.Gm)
		if(!p.pname)
			p.pname = p.name
		p.name = "<[p.pname]><span style='color:[color];'><b>[p.pname]</b></span>"
		p.Tag = "</b><span style='color:[color];'>\[Professor] <b>"
		p.GMTag = "<span style='color:[color];'>"
		p.Gm = 1
		p.shortapparate = 1
		p.see_invisible = 2

		var/list/verbsList = list(/mob/GM/verb/Remote_View,
		                          /mob/GM/verb/Return_View,
		                          /mob/GM/verb/Give_Prize,
		                          /mob/test/verb/Teach_Spells,
		                          /mob/GM/verb/House_Points,
		                          /mob/GM/verb/Create,
		                          /mob/GM/verb/Edit,
		                          /mob/GM/verb/Delete,
		                          /mob/GM/verb/LoadMap,
		                          /mob/GM/verb/UnloadMap,
		                          /mob/GM/verb/FloodFill,
		                          /mob/GM/verb/Arena,
		                          /mob/GM/verb/Arena_Summon,
		                          /mob/GM/verb/FFA_Mode,
		                          /mob/GM/verb/Toggle_Click_Create,
		                          /mob/GM/verb/CreatePath,
		                          /mob/GM/verb/Freeze_Area,
		                          /mob/GM/verb/Unfreeze_Area,
		                          /mob/GM/verb/Freeze,
		                          /mob/GM/verb/Cloak,
		                          /mob/GM/verb/Phase,
		                          /mob/GM/verb/Disconnect,
		                          /mob/GM/verb/Mute,
		                          /mob/GM/verb/Check_EXP,
		                          /mob/GM/verb/Check_Inactivity,
		                          /mob/GM/verb/Event_Announce,
		                          /mob/GM/verb/Announce,
		                          /mob/GM/verb/Immortal,
		                          /mob/GM/verb/Detention,
		                          /mob/GM/verb/Release_From_Detention,
		                          /mob/GM/verb/Toggle_Area_Safemode,
		                          /mob/GM/verb/Toggle_Safemode,
		                          /mob/GM/verb/End_Floor_Guidence,
		                          /mob/GM/verb/Teach_Herbificus,
								  /mob/GM/verb/Teach_Incarcerous,
								  /mob/GM/verb/Teach_Waddiwasi,
								  /mob/GM/verb/Teach_Valorus,
						  		  /mob/GM/verb/Teach_Avis,
								  /mob/GM/verb/Teach_Accio,
								  /mob/GM/verb/Teach_Petreficus_Totalus,
								  /mob/GM/verb/Teach_Transfigure_Bat,
								  /mob/GM/verb/Teach_Transfigure_Mouse,
								  /mob/GM/verb/Teach_Transfigure_Onion,
								  /mob/GM/verb/Teach_Transfigure_Dragon,
								  /mob/GM/verb/Teach_Transfigure_Rabbit,
								  /mob/GM/verb/Teach_Transfigure_Skeleton,
								  /mob/GM/verb/Teach_Transfigure_Human,
								  /mob/GM/verb/Teach_Transfigure_Cat,
								  /mob/GM/verb/Teach_Transfigure_Chair,
								  /mob/GM/verb/Teach_Transfigure_Pixie,
								  /mob/GM/verb/Teach_Telendevour,
								  /mob/GM/verb/Teach_Ferula,
								  /mob/GM/verb/Teach_Portus,
								  /mob/GM/verb/Teach_Permoveo,
								  /mob/GM/verb/Teach_Transfigure_Self_Human,
								  /mob/GM/verb/Teach_Disperse,
								  /mob/GM/verb/Teach_Transfigure_Turkey,
								  /mob/GM/verb/Teach_Eparo_Evanesca,
								  /mob/GM/verb/Teach_Imitatus,
								  /mob/GM/verb/Teach_Tremorio,
								  /mob/GM/verb/Teach_Serpensortia,
								  /mob/GM/verb/Teach_Incendio,
								  /mob/GM/verb/Teach_Episky,
								  /mob/GM/verb/Teach_Bombarda,
								  /mob/GM/verb/Teach_Wingardium,
								  /mob/GM/verb/Teach_Expelliarmus,
								  /mob/GM/verb/Teach_Reparo,
								  /mob/GM/verb/Teach_Confundus,
								  /mob/GM/verb/Teach_Chaotica,
								  /mob/GM/verb/Teach_Protego,
								  /mob/GM/verb/Teach_Inflamari,
								  /mob/GM/verb/Teach_Repellium,
								  /mob/GM/verb/Teach_Aqua_Eructo,
								  /mob/GM/verb/Teach_Depulso,
								  /mob/GM/verb/Teach_Evanesco,
								  /mob/GM/verb/Teach_Transfigure_Crow,
								  /mob/GM/verb/Teach_Transfigure_Frog,
								  /mob/GM/verb/Teach_Transfigure_Mushroom,
								  /mob/GM/verb/Teach_Sense,
								  /mob/GM/verb/Teach_Glacius,
								  /mob/GM/verb/Teach_Anapneo,
								  /mob/GM/verb/Teach_Flippendo,
								  /mob/GM/verb/Teach_Impedimenta,
								  /mob/GM/verb/Teach_Deletrius,
								  /mob/GM/verb/Teach_Occlumency,
								  /mob/GM/verb/Teach_Replacio,
								  /mob/GM/verb/Teach_Flagrate,
								  /mob/GM/verb/Teach_Langlock,
								  /mob/GM/verb/Teach_Scan,
								  /mob/GM/verb/Teach_Reddikulus,
								  /mob/GM/verb/Teach_Arcesso,
								  /mob/GM/verb/Teach_Reducto,
								  /mob/GM/verb/Teach_Tarantallegra,
								  /mob/GM/verb/Teach_Eat_Slugs,
								  /mob/GM/verb/Teach_Antifigura,
								  /mob/GM/verb/Teach_Obliviate,
								  /mob/GM/verb/Teach_Incindia,
								  /mob/GM/verb/Teach_Muffliato,
								  /mob/GM/verb/Teach_Lumos,
								  /mob/GM/verb/Host_Muggle_Studies_Class,
								  /mob/GM/verb/Host_Headmaster_Class,
								  /mob/GM/verb/Host_Duel_Class,
								  /mob/GM/verb/Host_COMC_Class,
								  /mob/GM/verb/Host_HM_Class,
								  /mob/GM/verb/Host_Trans_Class,
								  /mob/GM/verb/Host_DADA_Class,
								  /mob/GM/verb/Host_Charms_Class,
								  /mob/GM/verb/Bring,
								  /mob/GM/verb/Goto,
								  /mob/GM/verb/Warn,
								  /mob/GM/verb/HGM_Message,
								  /mob/GM/verb/Prize_Draw,
								  /mob/GM/verb/GM_Herbificus,
								  /mob/GM/verb/Orb_Surroundings,
								  /mob/GM/verb/View_Player_Log,
								  /mob/GM/verb/Sanctuario,
								  /mob/GM/verb/GM_chat)

		p.verbs += verbsList


mob/test/verb/fireStaff(var/Ckey in worldData.Gms)

	worldData.Gms -= Ckey
	if(!worldData.Gms.len) worldData.Gms = null

	var/mob/Player/p
	for(var/mob/Player/player in Players)
		if(player.ckey == Ckey)
			p = player
			break

	if(p)
		p.removeStaff()

mob/Player/proc/removeStaff()
	if(pname)
		name = pname
	Tag = null
	GMTag = null
	Gm = 0
	shortapparate = 0
	see_invisible = 0
	draganddrop = 0
	Immortal = 0
	if(!flying)
		density = 1
	pname = null

	verbs -= typesof(/mob/GM/verb/)
	verbs -= /mob/test/verb/Teach_Spells
	verbs -= /mob/Spells/verb/Avada_Kedavra
	verbs -= /mob/Spells/verb/Imperio
	verbs -= /mob/Spells/verb/Ecliptica
	verbs -= /mob/Spells/verb/Basilio
	verbs -= /mob/Spells/verb/Gravitate