/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
world/Topic(T,Addr,Master,Key)
	switch(copytext(T,1,5))
		if("7ann")
			//Announce to world
			world << copytext(T,5)
		if("7cla")
			//Reload clan permissions for specified ckey
			for(var/client/C)
				if(C.ckey == copytext(T,5))
					C.update_individual()
		if("7sav")
			//Save the world
			for(var/client/C)
				spawn() C.mob.Save()
				sleep(1)
			return "Saved"
		if("7reb")
			//Reboot the game
			world << "<br><hr><b>Rebooting the world now!</b><hr><br>"
			world.Reboot(2)

proc
	Aurors()
		var/list/members = list()
		for(var/mob/M in Players)
			if(M.Auror) members += M
		return members
	Deatheaters()
		var/list/members = list()
		for(var/mob/M in Players)
			if(M.DeathEater) members += M
		return members
mob/proc
	ClanMembers()
		if(Auror)      return Aurors()
		if(DeathEater) return Deatheaters()

mob/GM/verb/Clan_store()
	set category = "Clan"
	set name = "Clan Store"
	var/index = Auror ? 5 : 6
	var/area/_area = Auror ? /area/AurorHQ : /area/DEHQ
	switch(input("This is pretty well a beta test! I expect there will be a better interface if I decide to go with this idea. Select what you want to spend your clan points on. You will have the option to confirm your choice after you click one.") as null|anything in list(\
		"Repair Doors - 5 points", "Reinforce Doors - 10 points", "Break Invisibility - 1 point"))
		if("Repair Doors - 5 points")
			if(alert("This will rebuild all the doors inside your clan HQ for 5 points.",,"Yes","No") == "Yes")
				if(housepointsGSRH[index] >= 5)
					housepointsGSRH[index] -= 5
					ClanMembers() << "<b>[src] used Repair Doors for 5 points.</b>"
					for(var/obj/brick2door/clandoor/D in locate(_area))
						if(D.icon_state == "brokeopen")
							var/obj/brick2door/clandoor/newdoor = new(D.loc)
							var/StatusEffect/S = D.loc.loc.findStatusEffect(/StatusEffect/ClanWars/ReinforcedDoors)
							if(S)newdoor.MHP *= 2
							del(D)
						else
							D.HP = D.MHP
				else
					src << "<b>You don't have the required amount of points.</b>"

		if("Reinforce Doors - 10 points")
			if(alert("This will double the max HP of each door in your HQ for 30 minutes. Note: This will not increase each door's HP to maximum, it only affects the Max HP. You would need to use Repair Doors seperately, or wait for the door to regenerate itself after being destroyed.",,"Yes","No") == "Yes")
				if(housepointsGSRH[index] >= 10)
					var/atom/A = locate(_area)
					var/StatusEffect/S = A.findStatusEffect(/StatusEffect/ClanWars/ReinforcedDoors)
					if(S)
						S.cantUseMsg(src)
					else
						new /StatusEffect/ClanWars/ReinforcedDoors(A,1800)
						housepointsGSRH[index] -= 10
						ClanMembers() << "<b>[src] used Reinforce Doors for 10 points.</b>"
				else
					src << "<b>You don't have the required amount of points.</b>"

		if("Break Invisibility - 1 point")
			if(alert("This will uncloak any invisible people inside your HQ(not a part of your clan) for 1 point.",,"Yes","No") == "Yes")
				if(housepointsGSRH[index] >= 1)
					housepointsGSRH[index] -= 1
					ClanMembers() << "<b>[src] used Break Invisibility for 1 point.</b>"
					for(var/mob/Player/M in locate(_area))
						if(M.key&&(M.invisibility==1))
							flick('teleboom.dmi',M)
							M.invisibility=0
							M.icon_state = ""
							M<<"You have been revealed!"
							new /StatusEffect/Decloaked(M,15)
				else
					src << "<b>You don't have the required amount of points.</b>"

var/const
	DE_INVITE = 0
	AUROR_INVITE = 1
client/proc
	update_individual()
		set background=1
		if(!mysql_enabled) return
		var/DBQuery/qry = my_connection.NewQuery("SELECT isAuror,isDE,Cstore,Cspecverb FROM tblPlayers WHERE ckey=[mysql_quote(src.ckey)];")
		var/tmpmsg = qry.ErrorMsg()
		if(tmpmsg) world.log << "Mysql error update_individual. 1: [tmpmsg]"
		qry.Execute()
		tmpmsg = qry.ErrorMsg()
		if(tmpmsg) world.log << "Mysql error update_individual. 2: [tmpmsg]"
		mob.DeathEater=0
		mob.HA=0
		mob.Auror=0
		if(mob.aurorrobe)
			mob.icon = mob.baseicon
		else if(mob.derobe)
			mob.name = mob.prevname
			mob.icon = mob.baseicon
		mob.verbs.Remove(/mob/GM/verb/Auror_chat)
		mob.verbs.Remove(/mob/GM/verb/Auror_Robes)
		mob.verbs.Remove(/mob/GM/verb/DErobes)
		mob.verbs.Remove(/mob/GM/verb/DE_chat)
		mob.verbs.Remove(/mob/GM/verb/Clan_store)
		mob.verbs.Remove(/mob/Spells/verb/Morsmordre)
		if(mob.derobe && !(/mob/GM/verb/DErobes in mob.verbs))
			//You're no longer a DE but are in robes
			mob.icon = mob.baseicon
			mob.derobe=0
			mob:ApplyOverlays()
			if(locate(/mob/GM/verb/End_Floor_Guidence) in mob.verbs) mob.Gm = 1
			mob << "You slip off your Death Eater robes."
			mob.name = mob.prevname
			mob.underlays = list()
			if(mob.Gender == "Male")
				mob.gender = MALE
			else if(mob.Gender == "Female")
				mob.gender = FEMALE
			else
				mob.gender = MALE
			switch(mob.House)
				if("Hufflepuff")
					mob.GenerateNameOverlay(242,228,22)
				if("Slytherin")
					mob.GenerateNameOverlay(41,232,23)
				if("Gryffindor")
					mob.GenerateNameOverlay(240,81,81)
				if("Ravenclaw")
					mob.GenerateNameOverlay(13,116,219)
				if("Ministry")
					mob.GenerateNameOverlay(255,255,255)
			for(var/mob/fakeDE/d in world)
				if(d.ownerkey == mob.key) del d
		if(mob.aurorrobe && !(/mob/GM/verb/Auror_Robes in mob.verbs))
			//You're no longer a DE but are in robes
			mob.aurorrobe=0
			mob.icon = mob.baseicon
			mob:ApplyOverlays()
			mob.underlays = list()
			switch(mob.House)
				if("Hufflepuff")
					mob.GenerateNameOverlay(242,228,22)
				if("Slytherin")
					mob.GenerateNameOverlay(41,232,23)
				if("Gryffindor")
					mob.GenerateNameOverlay(240,81,81)
				if("Ravenclaw")
					mob.GenerateNameOverlay(13,116,219)
				if("Ministry")
					mob.GenerateNameOverlay(255,255,255)
			if(locate(/mob/GM/verb/End_Floor_Guidence) in mob.verbs) mob.Gm = 1
		if(qry.RowCount() > 0)
			qry.NextRow()
			var/list/row_data = qry.GetRowData()
			if(text2num(row_data["isAuror"]))
				mob:Auror = 1
				mob.verbs.Add(/mob/GM/verb/Auror_chat)
				mob.verbs.Add(/mob/GM/verb/Auror_Robes)
				if(text2num(row_data["Cstore"]))
					mob.verbs.Add(/mob/GM/verb/Clan_store)
			else if(text2num(row_data["isDE"]))
				mob:DeathEater = 1
				mob.verbs.Add(/mob/GM/verb/DErobes)
				mob.verbs.Add(/mob/GM/verb/DE_chat)
				if(text2num(row_data["Cstore"]))
					mob.verbs.Add(/mob/GM/verb/Clan_store)
				if(text2num(row_data["Cspecverb"]))
					mob.verbs.Add(/mob/Spells/verb/Morsmordre)
			else
				qry = my_connection.NewQuery("SELECT type FROM tblAlerts WHERE ckey=[mysql_quote(src.ckey)];")
				tmpmsg = qry.ErrorMsg()
				if(tmpmsg) world.log << "Mysql error update_individual. 3: [tmpmsg]"
				qry.Execute()
				tmpmsg = qry.ErrorMsg()
				if(tmpmsg) world.log << "Mysql error update_individual. 4: [tmpmsg]"
				if(qry.RowCount() > 0)
					qry.NextRow()
					row_data = qry.GetRowData()

					var/type = text2num(row_data["type"])
					qry = my_connection.NewQuery("DELETE FROM tblAlerts WHERE ckey='[src.ckey]';")
					qry.Execute()
					if(type == DE_INVITE)
						var/rply = alert(mob,"You have been invited to join the Deatheater clan. Do you accept?",,"Yes","No")
						if(rply == "Yes")
							//Add them to clan and recall update_individual
							qry = my_connection.NewQuery("UPDATE tblPlayers SET isDE=1,clanRank='Deatheater' WHERE ckey=[mysql_quote(src.ckey)];")
							qry.Execute()
							mob << "You can access Deatheater HQ by clicking the PM button on your HUD."
					if(type == AUROR_INVITE)
						var/rply = alert(mob,"You have been invited to join the Auror clan. Do you accept?",,"Yes","No")
						if(rply == "Yes")
							//Add them to clan and recall update_individual
							qry = my_connection.NewQuery("UPDATE tblPlayers SET isAuror=1,clanRank='Aurors' WHERE ckey=[mysql_quote(src.ckey)];")
							qry.Execute()
							mob << "You can access Auror HQ by clicking the PM button on your HUD."
					update_individual()
		qry = my_connection.NewQuery("SELECT ID,Amount,EarnerCkey FROM tblReferralAmounts WHERE RefererCkey=[my_connection.Quote(src.ckey)];")
		qry.Execute()
		tmpmsg = qry.ErrorMsg()
		if(tmpmsg) world.log << "Mysql error update_individual for tblReferralAmounts: [tmpmsg] - SQL: SELECT ID,Amount,EarnerCkey FROM tblReferralAmounts WHERE RefererCkey=[my_connection.Quote(src.ckey)];"
		if(qry.RowCount() > 0)
			var/list/row_data
			var/list/rows2delete = list() //fill with IDs
			while(qry.NextRow())
				row_data = qry.GetRowData()
				if(mob.level < lvlcap)
					mob << "<font color=yellow><b>You gained [row_data["Amount"]] XP from your referral [sql_get_name_from(row_data["EarnerCkey"])]([row_data["EarnerCkey"]]).</b></font>"
					var/xp2give = text2num(row_data["Amount"])
					//mob.Exp += xp2give
					while( (mob.Exp + xp2give) > mob.Mexp)
						xp2give -= (mob.Mexp - mob.Exp)
						mob.Exp = mob.Mexp
						mob.LvlCheck()
					mob.Exp += xp2give
					mob.LvlCheck()
				else
					var/gold2give = text2num(row_data["Amount"])
					mob << "<font color=yellow><b>You gained [gold2give] gold from your referral [sql_get_name_from(row_data["EarnerCkey"])]([row_data["EarnerCkey"]]).</b></font>"
					mob.gold += max(round(gold2give / 10, 1), 1)
				rows2delete += row_data["ID"]
			var/sql_rows2delete = ""
			for(var/rowID in rows2delete)
				if(rows2delete[1] == rowID)
					//If it's the first result, don't add OR first
					sql_rows2delete += "ID=[rowID]"
				else
					sql_rows2delete += " OR ID=[rowID]"
			qry = my_connection.NewQuery("DELETE FROM tblReferralAmounts WHERE [sql_rows2delete];")
			qry.Execute()
			tmpmsg = qry.ErrorMsg()
			if(tmpmsg) world.log << "Mysql error update_individual for tblReferralAmounts - couldn't delete: [tmpmsg] - SQL: DELETE FROM tblReferralAmounts WHERE [sql_rows2delete];"

proc
	update_all_clans()
		set background=1
		if(!mysql_enabled)return
		var/list/clients = list()
		var/list/dupeclients = list()
		var/list/changes = list()
		for(var/client/C)
			clients.Add(C)
		dupeclients.Add(clients)
		var/tmpsql
		while(clients.len)
			if(!tmpsql)
				tmpsql += "ckey='[clients[clients.len]]'"
			else
				tmpsql += " OR ckey='[clients[clients.len]]'"
			clients.Remove(clients[clients.len])


		var/DBQuery/qry = my_connection.NewQuery("SELECT ckey,isAuror,isDE FROM tblPlayers WHERE [tmpsql];")
		var/tmpmsg = qry.ErrorMsg()
		if(tmpmsg) world.log << "Mysql error update_all_clans. 1: [tmpmsg]"
		qry.Execute()
		tmpmsg = qry.ErrorMsg()
		if(tmpmsg) world.log << "Mysql error update_all_clans. 2: [tmpmsg]"
		if(qry.RowCount() > 0)
			while(qry.NextRow())
				var/list/row_data = qry.GetRowData()
				if(text2num(row_data["isAuror"]))
					changes.Add(list(row_data["ckey"] = 2))		//It's an auror
				else if(text2num(row_data["isDE"]))
					changes.Add(list(row_data["ckey"] = 1))	//It's a deatheater
				else
					changes.Add(list(row_data["ckey"] = 0))	//Ain't in a clan
			for(var/client/C in dupeclients)
				if(C.mob.type == /mob/Player)
					C.mob.DeathEater=0
					C.mob.HA=0
					C.mob.Auror=0
					C.mob.verbs.Remove(/mob/GM/verb/Auror_chat)
					C.mob.verbs.Remove(/mob/GM/verb/Auror_Robes)
					C.mob.verbs.Remove(/mob/GM/verb/DErobes)
					C.mob.verbs.Remove(/mob/GM/verb/DE_chat)


					switch(changes[C.ckey])
						if(1)//DE
							C.mob:DeathEater = 1
							C.mob.verbs.Add(/mob/GM/verb/DErobes)
							C.mob.verbs.Add(/mob/GM/verb/DE_chat)
						if(2)//Auror
							C.mob:Auror = 1
							C.mob.verbs.Add(/mob/GM/verb/Auror_chat)
							C.mob.verbs.Add(/mob/GM/verb/Auror_Robes)