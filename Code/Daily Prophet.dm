/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

var/DailyProphet=""
var/dpheader = {"
<head>
	<title>Daily Prophet</title>
	<style>
		body
		{
			background-image: url('http://www.wizardschronicles.com/dpbg.jpg');
		}
		div.title
		{
			font-size: 38pt;
			text-align: center;
			font-weight: bold;
			font-family: Sans-serif;
		}
		div.subtitle
		{
			font-size: 22pt;
			margin-left: 20px;
			text-decoration: underline;
			font-family: Sans-serif;
		}
		div.byline
		{
			font-size: 8pt;
			text-align: right;
		}
		div
		{
			font-size: 11pt;
			margin-left: 5px;
			color:black;
		}
	</style>
</head>
<body>
	<div class = "title">
		Daily Prophet
	</div>
	"}



//mob/GM/verb
//	New_Story(message as message)
	//	set category = "DP"
	//	var/Headline = input(src,"Input your Headline","Headline",src.key)
	//	file("DP.html") << "<HR><p align=center><font color = #F9DB13><font size=4>- ~T~H~E ~ D~A~I~L~Y ~ P~R~O~P~H~E~T~ -<b><u><font color=red><body bgcolor=black><p align=center>[Headline]</u> <font size=1><font color=aqua>by <font size=2>[usr]</b><p align=center><font color=silver><font size=3>[message] <p align=justfy><b><font color = #F9DB13>- <font size=2>[usr]<p>[usr.Rank]<hr>"
	//	world<<"<b><font color=red>EXTRA EXTRA! The Daily Prophet has been updated!"
mob/GM/verb/Clear_Stories()
		set category = "DP"
		DP = list()
		usr<<"<b>All stories and headlines have been cleared."


var/list
	DP = new

mob
	verb
		Refer_a_friend()
			usr << "<br><br><b>If you refer a new player to this game, 10% of any XP they earn will be awarded to you whenever you log in. In order to refer someone, have them visit<br>http://wizardschronicles.com/?ref=[ckey]<b><br>Then have them download and join the game. Once they gain XP, then Save (either manually or by logging out), a percentage of that XP will become available to you automatically when <b>you</b> log in.<br>"
		Daily_Prophet()
			set category = "Commands"
			var/dphtml = dpheader
			//for(var/i=DP.len, i>0, i--)
			src:lastreadDP = world.realtime
			for(var/i in DP)
				dphtml += DP[i]
				dphtml += "<br /><hr />"
			usr << browse(dphtml,"window=1;size=700x550")


mob/GM/verb
	Edit_DP()
		set category = "DP"
		var/editstory = input("Which story do you wish to edit?") as null|anything in DP
		if(!editstory)return
		var/changes = input("Make your changes below","Changes",DP[editstory]) as message|null
		if(!changes)return
		DP[editstory] = changes
	Draft()
		set category = "DP"
		var/Headline = input(src,"Input your 1st headline (Additional headlines can be made by surrounding the text in <div class=\"subtitle\"> and </div>","Headline") as text|null
		if(!Headline)return
		var/message = input("Input the body of the message. (Additional headlines can be made by surrounding the text in <div class=\"subtitle\"> and </div>","Content") as message|null
		if(!message)return
		usr << browse({"[dpheader]
	<div class="subtitle">
		[Headline]
	</div>
	<div class="byline">
		[time2text(world.realtime,"DD Month")], by [usr]
	</div>
	<div>
		[message]
	</div>"},"window=1;size=700x550")
	New_Story()
		set category = "DP"
		var/Headline = input(src,"Input your 1st headline (Additional headlines can be made by surrounding the text in <div class=\"subtitle\"> and </div>","Headline") as text|null
		if(!Headline)return
		var/message = input("Input the body of the message. (Additional headlines can be made by surrounding the text in <div class=\"subtitle\"> and </div>","Content") as message|null
		if(!message)return
		DP[Headline] = {"
	<div class="subtitle">
		[Headline]
	</div>
	<div class="byline">
		[time2text(world.realtime,"DD Month")], by [usr]
	</div>
	<div>
		[message]
	</div>"}

		dplastupdate = world.realtime
		if(alert("Post extra extra message?",,"Yes","No")=="Yes")
			world<<"<b><font color=red>EXTRA EXTRA! The Daily Prophet has been updated! Click <a href='?src=\ref[src];action=daily_prophet'>here</a> to view."