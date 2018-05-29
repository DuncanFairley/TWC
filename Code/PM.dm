/*
 * Copyright � 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/Player/var/list/atom/movable/PM/pmsRec = list()
mob/Player/var/list/atom/movable/PM/pmsSen = list()
mob/Player/var/tmp/atom/movable/PM/curPM

atom/movable/PM
	var
		body
		from
		pmTo
		read = 0
	New(var/Pname,var/Pbody,var/mob/Pfrom,var/mob/Pto)
		name = Pname
		body = Pbody
		from = Pfrom
		pmTo = Pto
		..()
proc/text2mob(var/txtMob)
	for(var/mob/Player/M in Players)
		if(M.name == txtMob || M.pname == txtMob || M.prevname == txtMob)
			return M
proc/formatName(mob/Player/M,force=1)
	if(M.prevname) return force ? (M.pname ? M.pname : M.prevname) : "[M]"
	if(M.pname)  return M.pname
	return "[M]"

var/PMheader = {"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>The Wizards' Chronicles</title>
</head>
<style>
	body
	{
		margin:5px;
		padding:0px;
		font:11px verdana;
		color:white;
		background-color:black;
	}
	div.header
	{
		padding:10px;
		text-align:center;
		font: 14px verdana;
		font-weight: bold;
	}
	div.subheader
	{
		padding:5px;
		font-weight: bold;
	}
</style>
				"}

proc/ckey2auth(ckey)
	return md5("[clanadmin_hash][ckey]")
mob/Player/proc/PMHome()
	var/unreadmsgs = 0
/*	var/clanadministration = "<div class = \"header\">Clan Administration</div>"

	if(DeathEater)
		clanadministration += {"
							<br />
							<a href='http://wizardschronicles.com/clanadmin.php?action=view_home&myckey=[ckey]&auth=[ckey2auth(ckey)]'>Deatheater HQ</a>"}
	if(Auror)
		clanadministration += {"
							<br />
							<a href='http://wizardschronicles.com/clanadmin.php?action=view_home&myckey=[ckey]&auth=[ckey2auth(ckey)]'>Auror HQ</a>"}


	if(clanadministration == "<div class = \"header\">Clan Administration</div>")
		clanadministration = {"
							...
							<br />"}
	else
		clanadministration += {"
							<br />
							...
							<br />
							<br />"}*/
	for(var/atom/movable/PM/A in src.pmsRec)
		if(!A.read) unreadmsgs++
	src << browse({"[PMheader]
	<div class = "header">Private Messaging</div>
	<br />
	<a href='?src=\ref[src];action=pm_Create'>Create Message</a>
	<br />
	<a href='?src=\ref[src];action=pm_inbox'>Inbox ([unreadmsgs] new messages)</a>
	<br />
	<a href='?src=\ref[src];action=pm_outbox'>Sent Messages</a>
	<br />
	<a href='?src=\ref[src];action=pm_blockedplyrs'>Block/Unblock Players</a>
	<br />
	<a href='?src=\ref[src];action=pm_MainMenu'>Refresh</a>
			"})
mob/Player/var/list/blockedpeeps = list()
mob/var/tmp/timelog = 0
var/list/emotes = list("farts","burps","coughs","yawns","sneezes","picks their nose","breathes heavily","scratches their arm","fidgets","plays with their fingers","plays with their hair")
mob/var/autoAFK = TRUE
mob/Player/proc/unreadmessagelooper()
	set background = 1
	var/unreadmsgs = 0
	spawn()
		while(src)
			sleep(2650)
			sql_update_ckey_in_table(src)
			unreadmsgs = 0
			for(var/atom/movable/PM/A in src.pmsRec)
				if(!A.read)
					unreadmsgs++
			var/rndnum = rand(1,200)
			switch(rndnum)
				if(1)
					Emote("[pick(emotes)].")

			if(!away && autoAFK && client.inactivity > 9000)
				//Been inactive for over 600 seconds/5 minutes
				away = 1
				here=status
				status=" (AFK)"
				ApplyAFKOverlay()

			if(unreadmsgs)
				src << "<b><a href='?src=\ref[src];action=pm_inbox'>You have [unreadmsgs] unread message[unreadmsgs > 1 ? "s":] in your inbox.</a></b>"

WorldData/var/tmp
	list
		tournamentLobby
		tournamentPlayers
	tournamentSummon = 0

mob/Player/Topic(href,href_list[])
	..()
	if(usr)
		src = usr
	else if(src)
		usr = src
	switch(href_list["action"])
		//<a href='?src=\ref[src];action=teleport;x=[killer.x];y=[killer.y];z=[killer.z]'>Teleport</a>
		if("view_changelog")
			src << link("http://wizardschronicles.com/?ver=[VERSION]")
		if("daily_prophet")
			src:Daily_Prophet()
		if("tournament")
			if(worldData.tournamentSummon > 0)
				if(ckey in worldData.tournamentLobby)
					worldData.tournamentLobby -= ckey
					src << errormsg("You left the tournament.")
				else
					worldData.tournamentLobby += ckey
					src << errormsg("You joined the tournament.")
		if("arena_leave")
			if(worldData.currentArena)
				if(src in worldData.currentArena.players)
					src << "<b>You cannot leave while you are involved in a round.</b>"
					return

			if(istype(src.loc.loc,/area/arenas))
				var/obj/o = locate("@Courtyard")
				src.loc = o.loc
		if("arena_teleport")
			if(src.rankedArena) return
			if(ckey in worldData.competitiveBans) return
			switch(worldData.arenaSummon)
				if(0) //disabled
					alert("The round is no longer allowing teleportation.")
					return
				if(1) //House Wars
					if(!Detention)
						src.flying=0
						src.density=1
						var/mob/M = locate("MapOne")
						density = 0
						Move(M.loc)
						density = 1
						src << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[src];action=arena_leave\">clicking here.</a></b>"
				if(3) //FFA
					if(!Detention)
						src.flying=0
						var/mob/M = locate("MapThree")
						density = 0
						Move(M.loc)
						density = 1
						src << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[src];action=arena_leave\">clicking here.</a></b>"
			var/mob/Player/user = src
			for(var/obj/items/wearable/brooms/Broom in user.Lwearing)
				Broom.Equip(user,1)
			for(var/obj/items/wearable/invisibility_cloak/Cloak in user.Lwearing)
				Cloak.Equip(user,1)
			if(src:auctionInfo)
				src:auctionClosed()
				winshow(src, "Auction", 0)
		if("pm_blockplyr")
			var/input = input("Who don't you wish to receive messages from anymore?","Block player") as null|anything in Players(list(src))
			if(input)
				if(istext(input))
					input = text2mob(input)
				input = formatName(input)
				blockedpeeps.Remove(input)
				blockedpeeps.Add(input)
				src << link("byond://?src=\ref[src];action=pm_blockedplyrs")
				alert("You will no longer receive messages from [input]. You can unblock them by clicking their name in the block menu.")

		if("pm_remblock")
			blockedpeeps.Remove(href_list["plyr"])
			src << link("byond://?src=\ref[src];action=pm_blockedplyrs")
		if("pm_blockedplyrs")
			var/blockedplyers = ""
			for(var/A in blockedpeeps)
				blockedplyers += "<br><a href='?src=\ref[src];action=pm_remblock;plyr=[A]'>[A]</a>"
			src << browse({"[PMheader]
	<div class = "header">Blocked Players</div>
	<br />
	<a href='?src=\ref[src];action=pm_blockplyr'>Block a player</a>
	<br><br>
	<b>Blocked players:</b><br>
	[blockedplyers]
	<br />
	<br />
	...
	<br />
	<a href='?src=\ref[src];action=pm_MainMenu'>Back to Main Menu</a>
						"})
		if("pm_inbox_frdmsg")
			var/atom/movable/PM/msg = src.pmsRec[text2num(href_list["msgid"])]
			src << browse(null,"window=pm_Read")
			src.curPM = msg
			src.curPM.pmTo = null
			src.curPM.read = 0
			src << browse(createPM(),"window=pm_Create;size=650x400")
		if("pm_outbox_frdmsg")
			var/atom/movable/PM/msg = src.pmsSen[text2num(href_list["msgid"])]
			src << browse(null,"window=pm_Read")
			src.curPM = msg
			src.curPM.pmTo = null
			src.curPM.read = 0
			src << browse(createPM(),"window=pm_Create;size=650x400")
		if("pm_inbox_delall")
			src.pmsRec = list()
			src << browse(null,"window=pm_Read")
			src << link("byond://?src=\ref[src];action=pm_inbox")
		if("pm_outbox_delall")
			src.pmsSen = list()
			src << browse(null,"window=pm_Read")
			src << link("byond://?src=\ref[src];action=pm_outbox")

		if("pm_reply")
			var/mob/online = text2mob(href_list["replynametext"])
			if(online)
			//	world << "Trying to PM [online.name] - [online.pname] - [online.type]"
				src.PM(online)
			else
				alert(src,"[href_list["replynametext"]] is no longer online.")
		if("pm_outbox_delmsg")
			var/atom/movable/PM/msg = src.pmsSen[text2num(href_list["msgid"])]
			src.pmsSen.Remove(msg)
			src << link("byond://?src=\ref[src];action=pm_outbox")
			src << browse(null,"window=pm_Read")
		if("pm_inbox_delmsg")
			var/atom/movable/PM/msg = src.pmsRec[text2num(href_list["msgid"])]
			src.pmsRec.Remove(msg)
			src << link("byond://?src=\ref[src];action=pm_inbox")
			msg.body = replacetext(msg.body,"\n","<br>")
			src << browse(null,"window=pm_Read")
		if("pm_outbox_readmsg")
			var/msgid = text2num(href_list["msgid"])
			if(src.pmsSen.len < msgid) return
			var/atom/movable/PM/msg = src.pmsSen[msgid]
			var/i = msgid
			msg.read=1
			src << link("byond://?src=\ref[src];action=pm_outbox")
			msg.body = replacetext(msg.body,"\n","<br>")
			src << browse({"[PMheader]
	<div class = "header">Sent Messages</div>
	<br />
	<div class = "subheader"><u>[msg.name]</u> to <a href='?src=\ref[src];action=pm_reply;replynametext=[msg.pmTo]'>[msg.pmTo]</a></div>
	<br />
	<a href='?src=\ref[src];action=pm_outbox_delmsg;msgid=[i]'>Delete</a>&nbsp;
	<br />
	<br />
	[msg.body]
						"},"window=pm_Read;size=650x400")
		if("pm_inbox_readmsg")
			var/msgid = text2num(href_list["msgid"])
			if(src.pmsRec.len < msgid) return
			var/atom/movable/PM/msg = src.pmsRec[msgid]
			var/i = msgid
			msg.read=1
			src << link("byond://?src=\ref[src];action=pm_inbox")
			msg.body = replacetext(msg.body,"\n","<br>")
			src << browse({"[PMheader]
	<div class = "header">Inbox</div>
	<br />
	<div class = "subheader"><u>[msg.name]</u> from <a href='?src=\ref[src];action=pm_reply;replynametext=[msg.from]'>[msg.from]</a></div>
	<br />
	<a href='?src=\ref[src];action=pm_inbox_delmsg;msgid=[i]'>Delete</a>&nbsp;
	<br />
	<br />
	[msg.body]
						"},"window=pm_Read;size=650x400")
		if("pm_outbox")
			var/atom/movable/PM/P
			var/links = ""
			if(src.pmsSen.len)
				links += "<br><a href='?src=\ref[src];action=pm_outbox_delall'>Delete all</a><br>"
				for(var/i=1;i<=src.pmsSen.len;i++)
					P = src.pmsSen[i]
					links += "<a href='?src=\ref[src];action=pm_outbox_readmsg;msgid=[i]'>[P]</a> To <a href='?src=\ref[src];action=pm_reply;replynametext=[P.pmTo]'>[P.pmTo]</a><br />"
			else
				links += "<i>There are no sent messages stored.</i>"
			src << browse({"[PMheader]
	<div class = "header">Sent Messages</div>
	<br />
	[links]
	<br />
	<br />
	...
	<br />
	<a href='?src=\ref[src];action=pm_MainMenu'>Back to Main Menu</a>
						"})
		if("pm_inbox")
			var/newlinks = ""
			var/oldlinks = ""
			var/atom/movable/PM/P
			if(src.pmsRec.len)
				oldlinks += "<br><a href='?src=\ref[src];action=pm_inbox_delall'>Delete all</a><br>"
				for(var/i=1;i<=src.pmsRec.len;i++)
					P = src.pmsRec[i]
					if(!P.read)
						newlinks += "<b><a href='?src=\ref[src];action=pm_inbox_readmsg;msgid=[i]'>[P]</a></b> From <a href='?src=\ref[src];action=pm_reply;replynametext=[P.from]'>[P.from]</a><br />"
					else
						oldlinks += "<a href='?src=\ref[src];action=pm_inbox_readmsg;msgid=[i]'>[P]</a> From <a href='?src=\ref[src];action=pm_reply;replynametext=[P.from]'>[P.from]</a><br />"
			else
				oldlinks += "<i>There are no received messages stored.</i>"

			src << browse({"[PMheader]
	<div class = "header">Inbox</div>
	<br />
	[newlinks]
	<br />
	[oldlinks]
	<br />
	<br />
	...
	<br />
	<a href='?src=\ref[src];action=pm_MainMenu'>Back to Main Menu</a>
						"})
		if("pm_changeRecipient")
			var/mob/input = input("Select recipient for the PM","Private Messaging") as null|anything in Players()
			if(input)
				if(istext(input))
					input = text2mob(input)
				src.curPM.pmTo = "[input]"
			src << browse(createPM(),"window=pm_Create;size=650x400")
		if("pm_changeSub")
			src.curPM.name = copytext(input("Select a subject for the PM","Private Messaging",src.curPM.name),1,35)
			src << browse(createPM(),"window=pm_Create;size=650x400")
		if("pm_changeBody")
			src.curPM.body = input("Input the message for the PM","Private Messaging",src.curPM.body) as message
			src << browse(createPM(),"window=pm_Create;size=650x400")
		if("pm_Create")
			var/mob/M = input("Select the recipient of the Private Message:","Private Messaging") as null|anything in Players()
			if(!M)return
			src.PM(M)
		if("pm_MainMenu")
			src.PMHome()
		if("pm_Send")
			src.pm_Send()

mob/Player/verb/PM(var/p in Players())
	if(src.mute)
		alert("You are not allowed to send messages while you are muted.")
		return
	if(src.Detention)
		alert("You are not allowed to send messages while in detention.")
		return
	var/mob/M = p
	if(istext(M))
		M = text2mob(M)
	if(M.key)
		var/mob/Player/Y = src
		var/atom/movable/PM/pm = new /atom/movable/PM("Subject","Body","[formatName(Y)]","[formatName(M)]")
		pm.body = input("Input the main text of the Private Message being sent to [formatName(M)]") as message|null
		if(!pm.body)return
		Y.curPM = pm
		src.pm_Send()

mob/Player/proc/createPM()
	return ({"[PMheader]
	<div class = "header">Private Messaging</div>
	<br />
	<div class = "subheader">Create Message</div>
	<br />
	<a href='?src=\ref[src];action=pm_Send'>Send</a>
	<a href='?src=\ref[src];action=pm_Create'>Reset</a>
	<br /><br />
	<table>
	<tr>
		<td>To:</td>
		<td><a href='?src=\ref[src];action=pm_changeRecipient'>[src.curPM.pmTo ? src.curPM.pmTo : "Select Recipient"]</a></td>
	</tr>
	<tr valign=top>
		<td>Body:</td>
		<td><a href='?src=\ref[src];action=pm_changeBody'>[src.curPM.body]</a></td>
	</tr>
	</table>
	<br />
			"})

mob
	Player
		proc/pm_Send()
			if(src.mute)
				alert("You are not allowed to send messages.")
				return
			if(src.Detention)
				alert("You are not allowed to send messages.")
				return
			if(!src.curPM.pmTo)
				alert("You are required to select a recipient.")
				return
			var/mob/Player/Y = text2mob("[src.curPM.pmTo]")
			if(!Y || Y.PMBlock)
				alert("That person does not wish to receive private messages at the moment.")
				return
			else if(Y.pmsRec.len > 100&&Y.pmsSen.len > 100)
				src.pmsSen.Add(src.curPM)
				spawn()alert("That person cannot receive private messages because their inbox and outbox is full. This message has been added to your outbox.")
				Y << "<b>[formatName(src)] tried to send you a PM, but you couldn't receive it because your inbox AND outbox has over 100 PMs each already. Delete some."
				return
			else if(Y.pmsRec.len > 100)
				src.pmsSen.Add(src.curPM)
				spawn()alert("That person cannot receive private messages because their inbox is full. This message has been added to your outbox.")
				Y << "<b>[formatName(src)] tried to send you a PM, but you couldn't receive it because your inbox has over 100 PMs already. Delete some."
				return
			else if(Y.pmsSen.len > 100)
				src.pmsSen.Add(src.curPM)
				spawn()alert("That person cannot receive private messages because their outbox is full. This message has been added to your outbox.")
				Y << "<b>[formatName(src)] tried to send you a PM, but you couldn't receive it because your outbox has over 100 PMs already. Delete some."
				return
			else if("[formatName(src)]" in Y.blockedpeeps)
				alert("That person does not wish to receive private messages at the moment.")
				return
			else if(!Y)
				alert("[src.curPM.pmTo] is offline.")
				return
			else if(src.curPM.body == "Body"|| !src.curPM.body)
				alert("The PM's body has no content.")
				return
			else if(src.prevname)
				if(alert("PMs sent from robed/masked figures will be sent as though you are unrobed. Do you still wish to send this message?",,"Yes","No") == "No")
					return
			src.curPM.body = "<u>Sent [time2text(world.realtime,"Day - DD/Month/YYYY, hh:mm")]</u><br><br>[src.curPM.body]"
			src.curPM.name = "Private Message"
			src.pmsSen.Add(src.curPM)
			Y.pmsRec.Add(src.curPM)
			var/pmcounter=0
			for(var/aPM in Y.pmsRec)
				pmcounter++
				if(aPM == src.curPM)break
			src << "Private Message Sent to <a href='?src=\ref[src];action=pm_reply;replynametext=[formatName(Y)]'>[formatName(Y)]</a>."
			Y << "You have received a <a href='?src=\ref[Y];action=pm_inbox_readmsg;msgid=[pmcounter]'>new private message</a> from <a href='?src=\ref[Y];action=pm_reply;replynametext=[formatName(src)]'>[formatName(src)]</a>."
			Y.beep()