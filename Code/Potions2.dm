/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
proc/sql_is_ckey_in_table(ckey)
//Returns player's name from Database, or 0 if it doesn't exist
	if(!mysql_enabled) return
	var/DBQuery/qry = my_connection.NewQuery("SELECT name FROM tblPlayers WHERE ckey = [mysql_quote(ckey)];")
	qry.Execute()
	if(qry.RowCount() > 0)
		qry.NextRow()
		var/list/row_data = qry.GetRowData()
		for(var/D in row_data)
			return row_data[D]
	else
		return 0
/*mob/verb/Updatedthingy()
	set category = "AWESOME"
	set hidden = 1
	sql_update_ckey_in_table(src)
mob/verb/Viewname()
	set category = "AWESOME"
	set hidden = 1
	var/nm = sql_is_ckey_in_table(ckey)
	if(!nm) world << "You aint in dere!"
	else world << "Ya name is [nm]!"
mob/verb/HI()
	set category = "AWESOME"
	sql_update_multikey(src)
	world << "[ckey] - [client.address] - [client.computer_id]"
mob/verb/TestCKEY(mob/M in world)
	var/result = sql_assoc_ckey(M.ckey)
	if(!result) world << "No ckeys found."
	else world << result

*/
proc/mysql_quote(text)
	return my_connection.Quote(text)
proc/sql_update_multikey(mob/M)
	if(!mysql_enabled) return
	var/DBQuery/qry = my_connection.NewQuery({"INSERT INTO tblMultikey(ckey,IP,ID)
		VALUES ('[M.ckey]',INET_ATON('[M.client.address]'),'[num2text(text2num(M.client.computer_id),12)]');"})
	var/tmpmsg = qry.ErrorMsg()
	if(tmpmsg) world.log << "Mysql error sql_update_multikey. 1: [tmpmsg]"
	qry.Execute()
	//tmpmsg = qry.ErrorMsg()
	//if(tmpmsg) world.log << "Mysql error sql_update_multikey. 2: [tmpmsg]"

proc/sql_upload_refererxp(pckey, prefererckey, pxp4referer)
	if(!mysql_enabled) return
	if(!prefererckey || !pxp4referer) return
	var/DBQuery/qry = my_connection.NewQuery({"SELECT ID,Amount FROM tblReferralAmounts WHERE EarnerCkey=[my_connection.Quote(pckey)] AND RefererCkey=[my_connection.Quote(prefererckey)];"})
	qry.Execute()
	if(qry.RowCount() > 0)
		//Update it
		qry.NextRow()
		var/list/row_data = qry.GetRowData()
		qry = my_connection.NewQuery("UPDATE tblReferralAmounts SET Amount=[text2num(row_data["Amount"]) + pxp4referer] WHERE ID=[row_data["ID"]]")
		qry.Execute()
		if(qry.RowsAffected() != 1)
			world.log << "[qry.RowsAffected()] rows effected for SQL query: UPDATE tblReferralAmounts SET Amount=[row_data["Amount"] + pxp4referer] WHERE ID=[row_data["ID"]]"
	else
		//Make a new row
		qry = my_connection.NewQuery("INSERT INTO tblReferralAmounts(RefererCkey,EarnerCkey,Amount) VALUES([my_connection.Quote(prefererckey)],[my_connection.Quote(pckey)],[pxp4referer])")
		qry.Execute()
		if(qry.RowsAffected() != 1)
			world.log << "[qry.RowsAffected()] rows effected for SQL query: INSERT INTO tblReferralAmounts(RefererCkey,EarnerCkey,Amount) VALUES([my_connection.Quote(prefererckey)],[my_connection.Quote(pckey)],[pxp4referer])"

proc/sql_get_name_from(ckey)
	if(!mysql_enabled) return
	var/DBQuery/qry = my_connection.NewQuery({"SELECT name FROM tblPlayers WHERE ckey=[mysql_quote(ckey)];"})
	qry.Execute()
	if(qry.RowCount() > 0)
		qry.NextRow()
		var/list/row_data = qry.GetRowData()
		return row_data["name"]
	else
		Log_admin("No rows returned for sql_get_name_from([ckey]).")

proc/sql_check_for_referral(mob/Player/M)
	if(!mysql_enabled) return
	var/DBQuery/qry = my_connection.NewQuery({"SELECT ID,RefererCkey FROM tblReferrals WHERE IPAddress=INET_ATON('[M.client.address]');"})
	//var/DBQuery/qry = my_connection.NewQuery({"SELECT ID,RefererCkey FROM tblReferrals WHERE IPAddress=INET_ATON('24.67.89.35');"})
	qry.Execute()
	if(qry.RowCount() > 0)
		qry.NextRow()
		var/list/row_data = qry.GetRowData()
		Log_admin("[M.name] ([M.ckey]) ([M.client.address]) redeemed a referral code belonging to [row_data["RefererCkey"]]")
		for(var/mob/A in Players)
			if(A.ckey == row_data["RefererCkey"])
				A << "<i>[M.name], who just logged in, claimed your referral code. You should help them out so they earn more XP for you!</i>"
		qry = my_connection.NewQuery({"DELETE FROM tblReferrals WHERE ID=[row_data["ID"]];"})
		qry.Execute()
		if(row_data["RefererCkey"] == M.ckey)
			return
		qry = my_connection.NewQuery({"UPDATE tblPlayers SET refererckey=[my_connection.Quote(row_data["RefererCkey"])] WHERE ckey=[my_connection.Quote(M.ckey)];"})
		qry.Execute()
		var/tmpmsg = qry.ErrorMsg()
		if(tmpmsg) world.log << "sql_check_for_referral failed for [row_data["RefererCkey"]] : [tmpmsg]"
		M.refererckey = row_data["RefererCkey"]

mob/var/xp4referer = 0
mob/var/refererckey = ""

mob/proc/addReferralXP(xp)
	if(refererckey)
		xp4referer += (xp * 0.10)


proc/sql_retrieve_plyr_log(ckey,mob/caller)
	var/DBQuery/qry = my_connection.NewQuery("SELECT timestamp,code,length,msg FROM tblWarnings WHERE ckey='[ckey]';")
	var/tmpmsg = qry.ErrorMsg()
	if(tmpmsg) world.log << "Mysql error sql_retrieve_plyr_log. 1: [tmpmsg]"
	qry.Execute()
	tmpmsg = qry.ErrorMsg()
	if(tmpmsg) world.log << "Mysql error sql_retrieve_plyr_log. 2: [tmpmsg]"
	var/log = {"<html>
<head>
	<style type="text/css">
		tr.one
		{
			background-color:#FFFFFF;
		}
		tr.two
		{
			background-color:#E6E6E6;
		}
		tr.expired
		{
			color:#8F8F8F;
		}
	</style>
</head>
<body>
	<b>Player log for ckey([ckey])</b><br />
	<table>
		"}
	if(qry.RowCount() > 0)
		var/time
		var/type
		var/altTR = 0
		while(qry.NextRow())
			var/list/row_data = qry.GetRowData()
			altTR = !altTR
			//25920000 is 10ths in 30 days
			var/trclass
			if(row_data["msg"] == "AFK+Training")
				if( (world.realtime - text2num(row_data["timestamp"])) > 51840000)
					if(altTR)
						trclass="class=\"one expired\""
					else
						trclass="class=\"two expired\""
				else
					if(altTR)
						trclass="class=\"one\""
					else
						trclass="class=\"two\""
			else
				if( (world.realtime - text2num(row_data["timestamp"])) > 25920000)
					if(altTR)
						trclass="class=\"one expired\""
					else
						trclass="class=\"two expired\""
				else
					if(altTR)
						trclass="class=\"one\""
					else
						trclass="class=\"two\""
			time = time2text(text2num(row_data["timestamp"]),"DD-MMM-YY/hh:mm")
			//Warning, Ban, Boot, etc.
			switch(row_data["code"])
				if("wa")
					type = "Warning"
				if("de")
					type = "Detention"
				if("ba")
					type = "Ban"
				if("di")
					type = "Disconnect"
				if("si")
					type = "Silence"
			var/length //(3 days) (1 minute) (indefinitely) etc
			if(type=="Detention" || type=="Ban" || type=="Silence")
				var/tmplength = row_data["length"]
				if(tmplength == "0")
					length = " (indefinitely)"
				else
					if(type=="Ban")
						length = " ([tmplength] days)"
					else
						length = " ([tmplength] minutes)"
			var/msg = url_decode(row_data["msg"])
			if(caller.admin)
				log += "<tr [trclass]><td>[time]:</td><td>[type][length]</td><td>[msg]</td><td><a href='?src=\ref[caller];action=delete_log_entry;id=[row_data["timestamp"]];return2ckey=[ckey]'>X</a></td></font></b></tr>"
			else
				log += "<tr [trclass]><td>[time]:</td><td>[type][length]</td><td>[msg]</td></font></b></tr>"
			//log += "<br>[greyfont][time]: [type][length] - \"[msg]\"</font></b>"
		log += "</table>"
	return log


proc/sql_add_plyr_log(ckey,code,msg,length)
	if(!mysql_enabled) return
	msg = url_encode(msg,0)
	var/DBQuery/qry = my_connection.NewQuery({"INSERT INTO tblWarnings(ckey,code,msg,timestamp,length) VALUES('[ckey]','[code]',[mysql_quote(msg)],
		'[num2text(world.realtime,11)]','[length]');"})
	var/tmpmsg = qry.ErrorMsg()
	if(tmpmsg) world.log << "Mysql error sql_add_plyr_log. 1: [tmpmsg]"
	qry.Execute()
	tmpmsg = qry.ErrorMsg()
	if(tmpmsg) world.log << "Mysql error sql_add_plyr_log. 2: [tmpmsg]"

proc/sql_assoc_ckey(ckey)
	//Queries database for ckeys that have the same ID or IP as the entered ckey
	if(!mysql_enabled) return
	var/DBQuery/qry = my_connection.NewQuery("SELECT IP,ID FROM tblMultikey WHERE ckey = [mysql_quote(ckey)];")
	var/tmpmsg = qry.ErrorMsg()
	if(tmpmsg) world.log << "Mysql error sql_assoc_ckey. 1: [tmpmsg]"
	var/list/IPs = list()
	var/list/IDs = list()
	qry.Execute()
	tmpmsg = qry.ErrorMsg()
	if(tmpmsg) world.log << "Mysql error sql_assoc_ckey. 2: [tmpmsg]"
	var/sqlcondition = ""
	if(qry.RowCount() > 0)
		while(qry.NextRow())
			var/list/row_data = qry.GetRowData()
			IPs.Remove(row_data["IP"])
			IPs.Add(row_data["IP"])
			IDs.Remove(row_data["ID"])
			IDs.Add(row_data["ID"])
	if(!IPs.len)return 0
	for(var/IP in IPs)
		if(IPs[1] == IP)
			sqlcondition += "IP='[IP]'"
		else
			sqlcondition += "OR IP='[IP]'"
	for(var/ID in IDs)
		sqlcondition += "OR ID='[ID]'"
	qry = my_connection.NewQuery("SELECT ckey FROM tblMultikey WHERE [sqlcondition];")
	tmpmsg = qry.ErrorMsg()
	if(tmpmsg) world.log << "Mysql error sql_assoc_ckey. 3: [tmpmsg]"
	qry.Execute()
	tmpmsg = qry.ErrorMsg()
	if(tmpmsg) world.log << "Mysql error sql_assoc_ckey. 4: [tmpmsg]"
	var/result = "The following ckeys are related to the ckey you entered either by IP address or Computer ID:<br>"
	var/list/ckeys = list()

	if(qry.RowCount() > 0)
		while(qry.NextRow())
			var/list/row_data = qry.GetRowData()
			ckeys.Remove(row_data["ckey"])
			ckeys.Add(row_data["ckey"])
		for(var/Z in ckeys)
			var/namae = sql_is_ckey_in_table(Z)
			if(namae)
				result += "<br>[namae] ([Z])"
			else
				result += "<br>Unknown ([Z])"
	else
		return 0
	return result

mob/GM/verb/Associated_Keys()
	set category = "Staff"
	if(!mysql_enabled) {alert("MySQL isn't enabled on this server."); return}
	var/input = input("This utility works by taking your inputted ckey(A key in lowercase with all punctuation removed, EG. Apples200_rulz becomes apples200rulz), and seeing if there's any other ckeys that have the same computer ID or IP address. It then displays these ckeys, if there are any.  -- Do you wish to enter a ckey, or select a player?") as null|anything in list("Enter a ckey","Select a player")
	if(!input)return
	var/result
	if(input == "Enter a ckey")
		var/inckey = input("Ckey of player? (A ckey is a key in lowercase, and with all punctuation and special non-number characters removed)") as null|text
		if(!inckey) return
		result = sql_assoc_ckey(ckey(inckey))

	else if(input == "Select a player")
		var/list/mob/mobs = list()
		for(var/client/C)
			mobs.Add(C.mob)
		var/mob/selmob = input("Which player would you like to check?") as null|anything in mobs
		if(!selmob)return
		result = sql_assoc_ckey(selmob.ckey)
	if(result)
		src << browse(result)
	else
		src << browse("<b>Invalid/non-existent ckey</b>")
proc/sql_update_ckey_in_table(mob/M)
	//Either creates a new player listing, or updates the old
	if(!mysql_enabled) return
	var/DBQuery/qry = my_connection.NewQuery("SELECT timeloggedin FROM tblPlayers WHERE ckey=[mysql_quote(M.ckey)];")
	qry.Execute()
	if(qry.RowCount() > 0)
		//Update old listing
		if(world.realtime - M.timelog < 200 || M.timelog == 0)
			return
		qry.NextRow()
		var/list/row_data = qry.GetRowData()
		var/oldtime
		for(var/D in row_data)
			oldtime = text2num(row_data[D])
			break
		var/time = oldtime + (world.realtime - M.timelog)
		M.timelog = world.realtime
		if(M.name == "Deatheater")
			qry = my_connection.NewQuery({"UPDATE tblPlayers
			SET name=[mysql_quote(M.prevname)],level=[M.level],house=[mysql_quote(M.House)],rank=[mysql_quote(M.Rank)],IP=INET_ATON('[M.client.address]'),timeloggedin='[time]',lastLoggedIn=CURDATE() WHERE ckey=[mysql_quote(M.ckey)];"})
		else
			qry = my_connection.NewQuery({"UPDATE tblPlayers
			SET name=[mysql_quote(M.name)],level=[M.level],house=[mysql_quote(M.House)],rank=[mysql_quote(M.Rank)],IP=INET_ATON('[M.client.address]'),timeloggedin='[time]',lastLoggedIn=CURDATE() WHERE ckey=[mysql_quote(M.ckey)];"})
		qry.Execute()
	else
		//Make new listing
		qry = my_connection.NewQuery({"INSERT INTO tblPlayers(ckey,name,level,house,rank,IP,timeloggedin)
		VALUES ([mysql_quote(M.ckey)],[mysql_quote(M.name)],[M.level],[mysql_quote(M.House)],[mysql_quote(M.Rank)],INET_ATON('[M.client.address]'),0);"})
		qry.Execute()
		var/tmpmsg = qry.ErrorMsg()
		if(tmpmsg) world.log << "Mysql error sql_update_ckey_in_table. 1: [tmpmsg]"

