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
			Players << copytext(T,5)
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
			Players << "<br><hr><b>Rebooting the world now!</b><hr><br>"
			world.Reboot(2)

var/const
	DE_INVITE = 0
	AUROR_INVITE = 1
client/proc
	update_individual()
		set background=1
		if(!mysql_enabled) return
		var/DBQuery/qry
		var/tmpmsg
	/*	qry = my_connection.NewQuery("SELECT isAuror,isDE,Cstore,Cspecverb FROM tblPlayers WHERE ckey=[mysql_quote(src.ckey)];")
		tmpmsg = qry.ErrorMsg()
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
			if(locate(/mob/GM/verb/GM_chat) in mob.verbs) mob.Gm = 1
			mob << "You slip off your Death Eater robes."
			mob.name = mob.prevname
			if(mob.Gender == "Male")
				mob.gender = MALE
			else if(mob.Gender == "Female")
				mob.gender = FEMALE
			else
				mob.gender = MALE
			mob:addNameTag()
		if(mob.aurorrobe && !(/mob/GM/verb/Auror_Robes in mob.verbs))
			//You're no longer a DE but are in robes
			mob.aurorrobe=0
			mob.icon = mob.baseicon
			mob:ApplyOverlays()
			mob:addNameTag()
			if(locate(/mob/GM/verb/GM_chat) in mob.verbs) mob.Gm = 1
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
					update_individual()*/
		qry = my_connection.NewQuery("SELECT ID,Amount,EarnerCkey FROM tblReferralAmounts WHERE RefererCkey=[my_connection.Quote(src.ckey)];")
		qry.Execute()
		tmpmsg = qry.ErrorMsg()
		if(tmpmsg) world.log << "Mysql error update_individual for tblReferralAmounts: [tmpmsg] - SQL: SELECT ID,Amount,EarnerCkey FROM tblReferralAmounts WHERE RefererCkey=[my_connection.Quote(src.ckey)];"
		if(qry.RowCount() > 0)
			var/list/row_data
			var/list/rows2delete = list() //fill with IDs
			while(qry.NextRow())
				row_data = qry.GetRowData()
				var/mob/Player/p = mob
				if(p.level < lvlcap)
					p << "<span style=\"color:yellow;\"><b>You gained [row_data["Amount"]] XP from your referral [sql_get_name_from(row_data["EarnerCkey"])]([row_data["EarnerCkey"]]).</b></span>"
					var/xp2give = text2num(row_data["Amount"])
					//mob.Exp += xp2give
					while( (p.Exp + xp2give) > p.Mexp && p.level <= lvlcap)
						xp2give -= (p.Mexp - p.Exp)
						p.Exp = p.Mexp
						p.LvlCheck()
					p.Exp += xp2give
					p.LvlCheck()
				else
					var/gold2give = text2num(row_data["Amount"])
					gold2give = max(round(gold2give / 10, 1), 1)
					p << "<span style=\"color:yellow;\"><b>You gained [gold2give] gold from your referral [sql_get_name_from(row_data["EarnerCkey"])]([row_data["EarnerCkey"]]).</b></span>"
					var/gold/g = new (bronze=gold2give)
					g.give(p)
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

/*proc
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
							C.mob.verbs.Add(/mob/GM/verb/Auror_Robes)*/