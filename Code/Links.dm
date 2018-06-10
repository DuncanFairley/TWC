client/verb/forums_link()
	set name = "Forums"
	set hidden = 1
	usr << link("http://forum.wizardschronicles.com/")

client/verb/discord_link()
	set name = "Discord"
	set hidden = 1
	usr << link("https://discord.gg/CgMW8Z9")

/*
client/verb/donate()
	set name = "Donate"
	set hidden = 1
	switch(alert(src, "Please before you continue, read this, Internet and time are not free, by donating to MaxIsJoe you are allowing him to improve the server and keep it alive for a while, this is an option, he will continue hosting the server as much as he can and work on content for this server as much as he can with or without donations, only donate if you really want to help this server staying alive.", "Read Me", "I Understand","I changed my mind"))
		if("I Understand")
			usr << link("https://www.paypal.me/MaxIsJoey")
		if("I changed my mind")
			return
*/