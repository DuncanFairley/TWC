mob/Player/var/ror=0

var/list/mob/Player/Players = list()
turf/var/tmp/flyblock=0

turf
	Enter(atom/movable/O)
		if(ismob(O))
			if(flyblock==2)
				for(var/atom/A in src)
					if(A.density) return 0
				return ..()
			if(!density) return ..()
			if(O:Gm && !O:flying) return ..()
			if(!O:key) return ..()
			else if(density&&flyblock)
				return 0
		return ..()
proc/str_count(haystack, needle)
	. = 0
	var/i = 1
	for(i; i <= length(haystack); i++)
		if(copytext(haystack, i, i + length(needle)) == needle)	.++

client
	mouse_pointer_icon='pointer.dmi'
#define BASE_MENU_CREATE_CHARACTER	"Create New Character"
#define BASE_MENU_DELETE_CHARACTER	"Delete Character"
#define BASE_MENU_CANCEL			"Cancel"
#define BASE_MENU_QUIT				"Quit"
world/cache_lifespan = 0

mob/Player/var/lastreadDP

var/WorldData/worldData

WorldData
	var
		list
			playersData
			expScoreboard
			competitiveBans
			prizeItems
			DP
			housepointsGSRH
			DJs
			dp_editors
			stories
			ministrybanlist
			mailTracker
			auctionItems
			spellsHistory

			vault/globalvaults
			customMap/customMaps
			Gms

		elderWand
		allowGifts   = 1
		dplastupdate
		housecupwinner
		weekcupwinner

		ministrypw    = "ketchup"
		ministrybank  = 0
		taxrate       = 15
		GMSchedule

		tmp
			lastusedAFKCheck
			ministryopen

WorldData/var/Version

proc
	Load_World()
		var/savefile/X = new ("players/World.sav")
		var/version
		X["VERSION"] >> version
		if(!version) version = 0

		X["worldData"] >> worldData
		if(!worldData) worldData = new

		if(!worldData.spellsHistory)
			worldData.spellsHistory = list()

		if(!worldData.ministrybanlist)
			worldData.ministrybanlist = new/list()
		//X["promicons"] >> promicons
		if(!promicons) promicons = list()
		if(!worldData.customMaps) worldData.customMaps = list()
		if(!worldData.globalvaults) worldData.globalvaults = list()
		if(!worldData.DP)
			worldData.DP = new/list()
		if(!worldData.housepointsGSRH)
			worldData.housepointsGSRH = new/list(4)
			worldData.housepointsGSRH[1] = 0
			worldData.housepointsGSRH[2] = 0
			worldData.housepointsGSRH[3] = 0
			worldData.housepointsGSRH[4] = 0

		var/list/cw
		X["ClanWars"] >> cw
		if(cw && cw.len)
			spawn()
				for(var/c in cw)
					if(!(c in clanwars_schedule))
						add_clan_wars(c)

		var/list/classes
		X["AutoClasses"] >> classes
		if(classes && classes.len)
			spawn()
				for(var/class in classes)
					if(!(class in autoclass_schedule))
						add_autoclass(class)

	Save_World()
		fdel("players/World.sav")
		var/savefile/X = new("players/World.sav")
		//var/list/objs=list()

		var/list/cw = list()
		for(var/e in clanwars_schedule)
			cw += e

		var/list/classes = list()
		for(var/e in autoclass_schedule)
			classes += e

		X["VERSION"] << WORLD_VERSION
		X["worldData"] << worldData
		X["ClanWars"] << cw
		X["AutoClasses"] << classes

world/Del()
	Save_World()
	SwapMaps_Save_All()

client/var/tmp
	base_num_characters_allowed = 1
	base_autoload_character = 0
	base_autosave_character = 1
	base_autodelete_mob = 1

obj/stackobj/Write(savefile/F)
	return

mob/Player/base_save_allowed = 1
mob
	var/tmp
		base_save_allowed = 0
		base_save_location = 1

		save_loaded = FALSE

	var/list/base_saved_verbs

	Write(savefile/F)

		..()
		if(src.type != /mob/Player)
			return
//		F["overlays"] << null
		F["icon"] << null
//		F["underlays"] << null
		F["savefileversion"] << SAVEFILE_VERSION
		if (base_save_location && world.maxx)
			F["last_x"] << x
			F["last_y"] << y
			F["last_z"] << z

		var/list/spells = src:saveSpells()
		if(spells && spells.len)
			F["UsedKeys"] << src:saveSpells()

	Read(savefile/F)
		var/testtype
		F["type"] >> testtype
		if(testtype == /mob/create_character)
			F["type"] << /mob/Player
			return
		//F["key"] << null
		saveError = 0
		..()

		if(testtype != /mob/Player)
			return
		if (base_save_location && world.maxx)
			var/mob/Player/p = src
			var/last_x
			var/last_y
			var/last_z
			F["last_x"] >> last_x
			F["last_y"] >> last_y
			F["last_z"] >> last_z

			var/list/usedKeys
			F["UsedKeys"] >> usedKeys

			if(usedKeys && usedKeys.len)
				src:UsedKeys = usedKeys

			if(saveError == 0)
				save_loaded = TRUE
			var/savefile_version
			F["savefileversion"] >> savefile_version
			if(!savefile_version) savefile_version = 16

			if(savefile_version < 17)
				var/gold/g = new
				if(isnum(gold))
					g.change(bronze=gold)
				if(isnum(goldinbank))
					g.change(bronze=goldinbank)
				g.give(src)
				gold       = null
				goldinbank = null

			if(savefile_version < 29)
				var/obj/items/wearable/invisibility_cloak/cloak = locate() in p.Lwearing
				if(cloak)
					cloak.Equip(p, 1, 1)
					cloak.loc = null

			if(savefile_version < 32)
				p.Rank = "Player"

			if(savefile_version < 38)
				p.see_invisible = 0


			if(savefile_version < 46)
				p.Spellcrafting = new("Spellcrafting")
				p.TreasureHunting = new("Treasure Hunting")
				p.Summoning = new("Summoning")
				p.Slayer = new("Slayer")
				p.Alchemy = new("Alchemy")
				p.Gathering = new("Gathering")
				p.Taming = new("Taming")
				p.Animagus = new("Animagus")


				p.MMP = 200
				p.MP = 200
				p.level = 1
				p.Mexp = 50
				p.Exp = 0
				p.resetStatPoints()
				p.Year = "1st Year"

				spawn()
					if(p.client.tmpInterface)
						p.Interface = p.client.tmpInterface
						p.Interface.Init(p)

					for(var/s in p.questPointers)
						if(s == "Brother Trouble") continue
						if(s == "Brewing Practice") continue
						if(s == "Sweet Easter") continue
						if(s == "PvP Introduction") continue
						if(s == "Culling the Herd") continue
						if(s == "Strength of Dragons") continue
						if(s == "Make a Potion") continue
						if(s == "Make a Fortune") continue
						if(s == "Make a Spell") continue
						if(s == "Make a Wig") continue
						if(s == "On House Arrest") continue

						p.questPointers -= s

					p.startQuest("Tutorial: The Wand Maker")

					for(var/obj/items/reputation/r in p)
						r.loc = null

					for(var/obj/items/wearable/w in p)
						if(istype(w, /obj/items/wearable/orb) || istype(w, /obj/items/wearable/title) || istype(w, /obj/items/wearable/magic_eye) || istype(w, /obj/items/wearable/halloween_bucket)|| istype(w, /obj/items/wearable/sword) || istype(w, /obj/items/wearable/shield) || istype(w, /obj/items/wearable/ring))
							if(w in p.Lwearing) w.Equip(p, 1, 1)
							w.loc = null
						else
							if(w.quality > 0)
								w.quality = 0
								w.bonus &= ~3

								var/list/split = splittext(w.name, " +")

								w.name = split[1]

							if(istype(w, /obj/items/wearable/wands))
								w:exp = 0
								w:projColor = null
							if(istype(w, /obj/items/wearable/pets))
								w:exp = 0


					p.verbs -= typesof(/mob/Spells/verb/)
					p.verbs += new/mob/Spells/verb/Inflamari
					p.spellpoints = 0

					p.Fire  = new("Fire")
					p.Earth = new("Earth")
					p.Water = new("Water")
					p.Ghost = new("Ghost")
					p.shortapparate = 0

					p << infomsg("The majority of your quests, your spells, level and any stat bonuses from items had were wiped, the rest of your wealth is untouched.")
			if(savefile_version < 47)

				if(p.Summoning)
					p.Summoning.adjustExp()
				if(p.Spellcrafting)
					p.Spellcrafting.adjustExp()
				if(p.TreasureHunting)
					p.TreasureHunting.adjustExp()
				if(p.Slayer)
					p.Slayer.adjustExp()
				if(p.Alchemy)
					p.Alchemy.adjustExp()
				if(p.Gathering)
					p.Gathering.adjustExp()
				if(p.Taming)
					p.Taming.adjustExp()
				if(p.Animagus)
					p.Animagus.adjustExp()
				if(p.Fire)
					p.Fire.adjustExp()
				if(p.Earth)
					p.Earth.adjustExp()
				if(p.Water)
					p.Water.adjustExp()
				if(p.Ghost)
					p.Ghost.adjustExp()

				p << infomsg("Your skill levels were adjusted to the new exp formula.")

			if(savefile_version < 48)
				for(var/obj/items/wearable/w in p)
					if(w.quality > 0 && w.bonus == (-1|3))
						w.quality = 0
						w.bonus &= ~3

						var/list/split = splittext(w.name, " +")
						w.name = split[1]

			if(savefile_version < 49)
				var/list/l = list("Tamed Dog", "Basilisk", "Cloud", "Wyvern", "Fire Elemental", "Water Elemental", "Archangel", "Projectile", "Fire Golem", "Fire Bat", "Bird ", "Troll", "Floating Eye", "Eye of The Fallen", "Wisp", "Vampire", "Acromantula", "Demon Snake", "Akalla", "Snowman", "The Good Snowman", "Pumpkin", "Cow", "Wolf", "Snake", "Dog", "Pixie", "Training Dummy", "Demon Rat", "Rat", "Stickman", "Summoned", "Zombie", "Boss", "Stickman", "Snowman", "Golem", "Sword", "Wisp", "VampireLord", "Scared Ghost", "Ghost", "Zombie", "Acromantula", "Basilisk", "Snake", "Acromantula", "Sword", "Slug")
				for(var/i in p.monsterkills)
					if(!(i in l))
						p.monsterkills -= i



			if(last_z >= SWAPMAP_Z && !worldData.currentMatches.isReconnect(src) && (!worldData.sandboxZ || !(last_z in worldData.sandboxZ))) //If player is on a swap map, move them to gringotts
				loc = locate("leavevault")
			else
				var/turf/t = locate(last_x, last_y, last_z)
				if(!t || t.name == "blankturf")
					loc = locate("@Hogwarts")
				else
					if(!worldData.playersData) worldData.playersData = list()

					var/guild/g
					var/PlayerData/data = worldData.playersData[ckey]
					if(data)
						g = data.guild
					if(!g) g = "-"

					var/area/a = t.loc

					if((istype(a, /area/DEHQ) || istype(a, /area/safezone/DEHQ)) && worldData.majorChaos != g)
						loc = locate("@Hogwarts")
					else if((istype(a, /area/AurorHQ) || istype(a, /area/safezone/AurorHQ)) && worldData.majorPeace != g)
						loc = locate("@Hogwarts")
					else if(a.timedArea)
						loc = locate("@Hogwarts")
					else
						loc = t

			spawn()
				if(p.loc && p.loc.loc)
					p.loc.loc.Enter(usr)
			if(p.ror==0)
				var/rorrand=rand(1,3)
				p.ror=rorrand
			p.icon_state = ""
			if(p.Gm)
				if(p.Gender == "Female")
					p.icon = 'FemaleStaff.dmi'
				else
					p.icon = 'MaleStaff.dmi'
			else
				if(p.Gender == "Male")
					switch(p.House)
						if("Gryffindor")
							p.icon = 'MaleGryffindor.dmi'
							p.verbs += /mob/GM/verb/Gryffindor_Chat
						if("Ravenclaw")
							p.icon = 'MaleRavenclaw.dmi'
							p.verbs += /mob/GM/verb/Ravenclaw_Chat
						if("Slytherin")
							p.icon = 'MaleSlytherin.dmi'
							p.verbs += /mob/GM/verb/Slytherin_Chat
						if("Hufflepuff")
							p.icon = 'MaleHufflepuff.dmi'
							p.verbs += /mob/GM/verb/Hufflepuff_Chat
						if("Ministry")
							p.icon = 'suit.dmi'
				else if(p.Gender == "Female")
					switch(p.House)
						if("Gryffindor")
							p.icon = 'FemaleGryffindor.dmi'
							p.verbs += /mob/GM/verb/Gryffindor_Chat
						if("Ravenclaw")
							p.icon = 'FemaleRavenclaw.dmi'
							p.verbs += /mob/GM/verb/Ravenclaw_Chat
						if("Slytherin")
							p.icon = 'FemaleSlytherin.dmi'
							p.verbs += /mob/GM/verb/Slytherin_Chat
						if("Hufflepuff")
							p.icon = 'FemaleHufflepuff.dmi'
							p.verbs += /mob/GM/verb/Hufflepuff_Chat
						if("Ministry")
							p.icon = 'suit.dmi'
			p.baseicon = p.icon
			p.color = null
			if(client)
				for(var/mob/Player/c in Players)
					if(c.Gm)
						c <<"<b><i>[src][refererckey == c.client.ckey ? "(referral)" : ""] ([client.address])([ckey])([client.connection == "web" ? "webclient" : "dreamseeker"]) logged in.</i></b>"
					else
						c <<"<b><i>[src][refererckey == c.client.ckey ? "(referral)" : ""] logged in.</i></b>"

				p.SendDiscord("logged in")

				src<<"<b><span style=\"font-size:2; color:#3636F5;\">Welcome to Harry Potter: The Wizards Chronicles</span> <u><a href='https://github.com/DuncanFairley/TWC/commits/master'>Version [VERSION].[SUB_VERSION]</a></u></b> <br>Come join Discord <a href=\"https://discord.gg/3HbY5PjmjE\">here.</a>"

				if(src:lastreadDP < worldData.dplastupdate)
					p << "<span style=\"color:red;\">The Daily Prophet has an issue that you haven't yet read. <a href='?src=\ref[src];action=daily_prophet'>Click here</a> to view.</span>"
				if(p.lastversion != "[VERSION].[SUB_VERSION]")
					p.lastversion = "[VERSION].[SUB_VERSION]"
					src<<"<b><span style=\"font-size:2;\">TWC had an update since you last logged in! A list of changes can be found <a href='https://github.com/DuncanFairley/TWC/commits/master'>here.</a></span></b>"


mob/Player/var/lastversion
var/rules = file("rules.html")

mob/BaseCamp
	base_save_allowed = 0
//	Login()
//		RemoveVerbs()
//		return

	Stat()
		return

mob/BaseCamp/FirstTimePlayer
	proc/FirstTimePlayer()
		return 1

world
	mob = /mob/BaseCamp/ChoosingCharacter
/*var/HTML/HTML
var/HTMLres = list('logo_banner.png', 'logo.png', 'mainstyle.css')
mob/BaseCamp/ChoosingCharacter/Topic(href,href_list[])
	switch(href_list["action"])
		if("loginLoad")
			if(istype(src,/mob/BaseCamp/ChoosingCharacter))
				Choose_Character()
		if("loginNew")
			if(istype(src,/mob/BaseCamp/ChoosingCharacter))
				New_Character()

client/Topic(href,href_list[],hsrc)
	..()
	switch(href_list["action"])
		if("login")
			if(href_list["btnregister"])
				usr << output(HTMLOutput(usr,"register",href_list),"broLogin")
		if("register")
			if(href_list["btncancel"])
				usr << output(HTMLOutput(usr,"login",href_list),"broLogin")
				return
			if(length(href_list["emailaddress"]) < 6\
			|| length(href_list["emailaddress"]) > 60\
			|| !findtext(href_list["emailaddress"],"@"))
				href_list["error"] = "Invalid email address entered."
			else if(!cmptext(href_list["emailaddress"],href_list["emailaddressconfirm"]))
				href_list["error"] = "Email addresses don't match."

			else if(length(href_list["password"]) < 5\
			|| length(href_list["password"]) > 60)
				href_list["error"] = "Password must be between 5 and 60 characters in length."
			else if(!cmptext(href_list["password"],href_list["passwordconfirm"]))
				href_list["error"] = "Passwords don't match."
			if(href_list["error"])
				usr << output(HTMLOutput(usr,"register",href_list),"broLogin")
proc/HTMLOutput(mob/M,page,list/href_list)
	//for(var/res in HTMLres)
	//	M << browse_rsc(res)
	switch(page)
		if("login")
			return {"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="mainstyle.css" />
</head>
<body>
	<div id="centerwrapper">
		<div style="margin-left:auto;margin-right:auto;width: 700px;height: 300px">
			<div style="float: left;width:263px;">
				<img src="silver_logo.jpg" />
			</div>
			<div style="text-align:right;padding-top:40px;">
			<form action="byond://" method="get">
				<label for="emailaddress">Email Address:</label><input id="emailaddress" name="emailaddress" /><br />
				<label for="password">Password:</label><input id="password" name="password" type="password" /><br />
				<input id="remember" type="checkbox" /><label for="remember">Remember login email</label>
				<br />
				<input type="button" name="btnregister" value="Register" style="width:100px;margin-right:3px;" onclick="window.location='?action=login;btnregister=1'" /><input type="submit" value="Login" style="width:100px;" />
				<input type="hidden" name="action" value="login" />
				<br />
				[href_list ? "<span class=\"error\">[href_list["error"]]</span>":]
			</form>
			</div><div style="clear: both"></div>
		</div>
	</div>
</body>
</html>"}
		if("register")
			return {"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="mainstyle.css" />
</head>
<body>
	<div id="centerwrapper">
		<div style="margin-left:auto;margin-right:auto;width: 700px;height: 300px">
			<div style="float: left;width:263px;">
				<img src="silver_logo.jpg" />
			</div>
			<div style="text-align:right;padding-top:30px;">
			<form action="byond://" method="get">
				<label for="emailaddress">Email Address:</label><input id="emailaddress" name="emailaddress" /><br />
				<label for="emailaddressconfirm">Confirm Email Address:</label><input id="emailaddressconfirm" name="emailaddressconfirm" /><br />
				<br />
				<label for="password">Password:</label><input id="password" name="password" type="password" /><br />
				<label for="passwordconfirm">Confirm Password:</label><input id="passwordconfirm" name="passwordconfirm" type="password" /><br />
				<br />
				<input type="button" name="btncancel" value="Cancel" style="width:100px;margin-right:3px;" onclick="window.location='?action=register;btncancel=1'" /><input type="submit" value="Register" style="width:100px;" />
				<input type="hidden" name="action" value="register" />
				<br />
				[href_list ? "<span class=\"error\">[href_list["error"]]</span>":]
			</form>
			</div><div style="clear: both"></div>
		</div>
	</div>
</body>
</html>"}
	return {"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="http://wizardschronicles.com/login/mainstyle.css" />
</head>
<body onresize="hideDiv()">
		<div id="banner">
			<img src="http://wizardschronicles.com/login/logo_banner.png" />
		</div>
		<div id="logo">
			<img src="http://wizardschronicles.com/login/logo.png" />
		</div>
		<div id="main">
				<ul class="centered-ul">
					<li class="horizontal-li"><a href="?src=\ref[M];action=loginNew">New</a></li>
					<li class="horizontal-li"> - </li>
					<li class="horizontal-li"><a href="?src=\ref[M];action=loginLoad">Load</li>
				</ul>
		</div>

	<script language=javascript type='text/javascript'>
		var swap = false;
		hideDiv();
		function hideDiv()
		{
			if(document.documentElement.offsetHeight < 480 && !swap)
			{
				swapNodes(document.getElementById('logo'), document.getElementById('main'));
				swap = true;
			}
			else if(document.documentElement.offsetHeight >= 480 && swap)
			{
 				swapNodes(document.getElementById('logo'), document.getElementById('main'));
				swap = false;
			}
		}

		function swapNodes(node1, node2)
		{
    		node2_copy = node2.cloneNode(true);
    		node1.parentNode.insertBefore(node2_copy, node1);
    		node2.parentNode.insertBefore(node1, node2);
    		node2.parentNode.replaceChild(node2, node2_copy);
		}
	</script>
</body>
</html>"}
*/
client/var/tmp/interface/tmpInterface

hudobj
	login
		anchor_x = "CENTER"
		anchor_y = "CENTER"

		mouse_opacity = 2

		icon = 'Login Stone.dmi'
		icon_state = "moss"

		MouseEntered()
			transform *= 1.25
		MouseExited()
			transform = null


		Load
			maptext = "<b><span style=\"font-size:14px;color:#34d\">Load</span></b>"
			maptext_width = 64
			maptext_x = 9
			maptext_y = 4

			screen_x = 64

			Click()
				if(istype(usr,/mob/BaseCamp/ChoosingCharacter))
					usr.client.glide_size = GLIDE_SIZE
					usr:Choose_Character()

		New
			maptext = "<b><span style=\"font-size:14px;color:#34d\">New</span></b>"
			maptext_width = 64
			maptext_x = 10
			maptext_y = 4

			screen_x = -94

			Click()
				if(istype(usr,/mob/BaseCamp/ChoosingCharacter))
					usr.client.glide_size = GLIDE_SIZE
					usr:New_Character()

obj/loginCamera
	mouse_opacity = 0
	invisibility = 10
	glide_size = 8

	New()
		..()
		tag = "loginCamera"
		wander()

	proc/wander()
		set waitfor = 0
		var/turf/target
		while(src)
			if(!target || loc == target)
				target = locate(rand(50,70), rand(25,75), z)

			var/turf/t = get_step_towards(loc, target)
			if(t)
				loc = t
			else
				target = null
			sleep(4)

PlayerData/var/autoLoad = 0

mob/BaseCamp/ChoosingCharacter
	sight = SEE_THRU
	Login()

		var/PlayerData/p = worldData.playersData[ckey]
		if(p && p.autoLoad)

			var/list/available_char_names=client.base_CharacterNames()

			if(available_char_names.len >= 1)
				client.tmpInterface = new (client)
				client.glide_size = GLIDE_SIZE
				client.base_LoadMob(available_char_names[1])
				del(src)
				return

		reportDiscordWho = 1
		new /hudobj/login/New(null, client, null, 1)
		new /hudobj/login/Load(null, client, null, 1)

		client.tmpInterface = new (client)
		client.onResize(60, 31, 0, 0, 1)

		var/obj/o = locate("loginCamera")
		client.eye = o
		client.perspective = EYE_PERSPECTIVE
		client.glide_size = 8

	//	usr << output(HTMLOutput(src),"broLogin")
		/*var/first_initial = copytext(ckey, 1, 2)
		if(fexists("players/[first_initial]/[ckey].sav"))
			var/mob/tmpmob/A
			var/mob/tmpmob/M = new()
			var/savefile/S = new("players/[first_initial]/[ckey].sav")
			S.cd = "/players/[ckey]/mobs/"
			var/firstentry
			for (var/entry in S)
				S["[entry]/mob"] >> M
				//M = S["[entry]/mob"]The nurse orbs out
				break
			//alert("An old savefile is detected and needs to be converted into a new email-based savefile. The detected character is named \"[M.name]\" and is level [M.level].")
			usr << output(HTMLOutput(src,"login"),"broLogin")*/
	//	winset(src,null,"guild.is-visible=false;splitStack.is-visible=false;SpellBook.is-visible=false;Quests.is-visible=false;Auction.is-visible=false;winSettings.is-visible=false;broLogin.is-visible=true;radio_enabled.is-checked=false;barHP.is-visible=false;barMP.is-visible=false;[radioEnabled ? "mnu_radio.is-disabled=false;" : ""]")



	proc/Choose_Character()
		var/list/available_char_names=client.base_CharacterNames()
		if(length(available_char_names) < 1)
			src<<errormsg("You don't have a character to load, forwarding to creation process.")
			client.base_NewMob()
			del(src)
			return
		else
			client.base_LoadMob(available_char_names[1])
			del(src)
			return
	proc/New_Character()
		var/list/names=client.base_CharacterNames()
		if(length(names) < client.base_num_characters_allowed)
			client.base_NewMob()
			del(src)
			return
		else
			switch(input(src,"You have the maximum amount of allowed characters. Delete one?") in list ("Yes","No"))
				if("Yes")
					DeleteCharacter()
					return
				if("No")
					return
	proc/ChooseCharacter()
		var/list/available_char_names = client.base_CharacterNames()
		var/list/menu = new()
		menu += available_char_names

		if (length(available_char_names) < client.base_num_characters_allowed)
			if (client.base_num_characters_allowed == 1)
				client.base_NewMob()
				del(src)
				return
			else
				menu += BASE_MENU_CREATE_CHARACTER

		if (length(available_char_names))
			menu += BASE_MENU_DELETE_CHARACTER

		menu += BASE_MENU_QUIT

		var/default = null
		var/result = input(src, "Who do you want to be today?", "Welcome to [world.name]!", default) in menu
		switch(result)
			if (0, BASE_MENU_QUIT)
				del(src)
				return

			if (BASE_MENU_CREATE_CHARACTER)
				client.base_NewMob()
				del(src)
				return

			if (BASE_MENU_DELETE_CHARACTER)
				DeleteCharacter()
				ChooseCharacter()
				return

		var/mob/Mob = client.base_LoadMob(result)
		if (Mob)
			del(src)
		else
			ChooseCharacter()

	proc/DeleteCharacter()
		var/list/available_char_names = client.base_CharacterNames()
		var/list/menu = new()
		menu += available_char_names

		menu += BASE_MENU_CANCEL
		menu += BASE_MENU_QUIT

		var/default = null
		var/result = input(src, "Which character do you want to delete?", "Deleting Character", default) in menu

		switch(result)
			if (0, BASE_MENU_QUIT)
				del(src)
				return

			if (BASE_MENU_CANCEL)
				return

		client.base_DeleteMob(result)
		return

mob/Player/var/base_save_verbs = 1

client
	var/tmp/savefile/_base_player_savefile

//	New()
//		..()
//		if (base_autoload_character)
//			base_ChooseCharacter()
//			base_Initialize()


	Del()
		reportDiscordWho = 1
		if(mob && isplayer(mob))
			mob:playedtime += world.realtime  - mob:timelog
			if(mob:isTrading())
				mob:trade.Clean()
			if(mob:party)
				mob:party.remove(mob)
			if(mob:buildItemDisplay)
				mob:buildItemDisplay.loc = null
			mob:auctionClosed()
			var/StatusEffect/S = mob.findStatusEffect(/StatusEffect/Lamps)
			if(S) S.Deactivate()
			if(mob:prevname)
				mob.name = mob:prevname
			if(mob.xp4referer)
				sql_upload_refererxp(mob.ckey,mob.refererckey,mob.xp4referer)
				mob.xp4referer = 0
			if(!mob.Gm)
				mob.Check_Death_Drop()
			if(mob:followers)
				mob.pixel_y = 0
				for(var/obj/o in mob:followers)
					o.Dispose()
				mob:followers = null
			if(mob:pet)
				mob:pet.Dispose()
				mob:pet = null
			var/obj/buildable/hammer_totem/o = locate("pet_[ckey]")
			if(o)
				o.cleanPets()
			if(mob:readbooks > 0)
				var/amount = mob:readbooks - 1
				if(amount)
					var/gold/g = new (bronze=amount)
					g.give(mob)
		if (base_autosave_character)
			base_SaveMob()
		if (base_autodelete_mob && mob)
			del(mob)
		..()


	proc/base_PlayerSavefile()
		if (!_base_player_savefile)
			var/first_initial = copytext(ckey, 1, 2)
			var/filename = "players/[first_initial]/[ckey].sav"
			_base_player_savefile = new(filename)
		return _base_player_savefile


	proc/base_FirstTimePlayer()
		var/mob/BaseCamp/FirstTimePlayer/first_mob = new()
		first_mob.name = key
		first_mob.gender = gender
		mob = first_mob
		return first_mob.FirstTimePlayer()


	proc/base_ChooseCharacter()

		var/mob/BaseCamp/ChoosingCharacter/chooser

		var/list/names = base_CharacterNames()
		if (!length(names))
			var/result = base_FirstTimePlayer()
			if (!result)
				del(src)
				return

			chooser = new()
			mob = chooser

			return

		if (base_num_characters_allowed == 1)
			base_LoadMob(names[1])
			return

		chooser = new()
		mob = chooser
		return


	proc/base_CharacterNames()
		var/list/names = new()
		var/savefile/F = base_PlayerSavefile()

		F.cd = "/players/[ckey]/mobs/"
		var/list/characters = F.dir
		var/char_name
		for (var/entry in characters)
			F["[entry]/name"] >> char_name
			names += char_name
		return names


	proc/base_NewMob()
		base_SaveMob()
		var/mob/new_mob
		new_mob = new /mob/create_character
		new_mob.name = key
		new_mob.gender = gender
		mob = new_mob
		_base_player_savefile = null
		return new_mob


	proc/base_SaveMob()
		if (!mob || !mob.base_save_allowed || !mob.save_loaded)
			return

		if (mob:base_save_verbs)
			mob:base_saved_verbs = mob.verbs - (typesof(/mob/Player/verb)) - (typesof(/mob/verb))

		var/first_initial = copytext(ckey, 1, 2)
		fdel("players/[first_initial]/[ckey].sav")
		var/savefile/F = base_PlayerSavefile()
		var/wasDE = 0
		var/maskedName
		if(mob:prevname)
			maskedName = mob.name
			wasDE = 1
			mob.name = mob:prevname
		var/mob_ckey = ckey(mob.name)

		var/directory = "/players/[ckey]/mobs/[mob_ckey]"
		F.cd = directory


		F["name"] << mob.name
		F["mob"] << mob

		mob.base_saved_verbs = null
		if(wasDE)
			mob.name = maskedName
		_base_player_savefile = null


	proc/base_LoadMob(char_name)
		var/mob/new_mob
		var/char_ckey = ckey(char_name)
		var/savefile/F = base_PlayerSavefile()
		_base_player_savefile = null

		F.cd = "/players/[ckey]/mobs/"
		var/list/characters = F.dir
		var/error = FALSE
		if (!characters.Find(char_ckey))
			world.log << "<b>[key]'s client.LoadCharacter() could not locate character [char_name].</b>"
			error = TRUE
		if(!char_ckey)
			F["mob"] >> new_mob
		else
			F["[char_ckey]/mob"] >> new_mob
		if (new_mob)
			if(istype(new_mob, /mob/create_character))
				usr << "\red <b>Your character has been absolved of the new player bug. Please reconnect and load again.</b>"
				base_DeleteMob(char_name)
				del new_mob
				return
			else if(error && !new_mob.name)
				new_mob.name = "RenameMe"

			if (new_mob:base_save_verbs && new_mob.base_saved_verbs)
				if(!new_mob.base_saved_verbs.len) return null
				new_mob.verbs += new_mob.base_saved_verbs
				new_mob.base_saved_verbs = null

			mob = new_mob

			return new_mob
		return null


	proc/base_DeleteMob(char_name)
		var/char_ckey = ckey(char_name)
		var/savefile/F = base_PlayerSavefile()

		F.cd = "/players/[ckey]/mobs/"
		F.dir.Remove(char_ckey)
