/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

WorldData/var
	list/guilds

	majorPeace
	majorChaos


PlayerData/var/guild

mob/Player
	var/tmp/guild

	Topic(href, href_list[])
		.=..()
		if(href_list["action"]=="guildPromote")
			if(!guild) return

			var/guild/g = worldData.guilds[guild]
			var/who     = href_list["who"]

			if(!(who in g.members)) return

			if(g.members[ckey] > g.members[who] + 1)
				g.members[who]++
				g.Refresh(src)


		else if(href_list["action"]=="guildDemote")
			if(!guild) return

			var/guild/g = worldData.guilds[guild]
			var/who     = href_list["who"]

			if(!(who in g.members)) return

			if(g.members[ckey] > g.members[who] && g.members[who] - 1 >= 1)
				g.members[who]--
				g.Refresh(src)

		else if(href_list["action"]=="guildRemove")

			if(!guild) return

			var/guild/g = worldData.guilds[guild]

			var/who = href_list["who"]

			if(who == ckey)
				if(alert("Are you sure you want to quit?", "Quit", "Yes", "No") == "No") return
				src << errormsg("You left [g.name] guild")
				guild = null
				verbs -= /mob/GM/verb/Guild_Chat
			else

				if(!(who in g.members)) return
				if(g.members[ckey] <= g.members[who]) return
				if(alert("Are you sure you want to remove [who]?", "Remove", "Yes", "No") == "No") return

				for(var/mob/Player/p in Players)
					if(p.ckey == who)
						p << errormsg("You were removed from [g.name] guild")
						p.guild = null
						p.verbs -= /mob/GM/verb/Guild_Chat
						break

			g.Remove(who)
			g.Refresh(src)


mob/GM
	verb
		Guild_Chat(var/message as text)
			set name="Guild Chat"
			if(usr.mute==1||usr.Detention){usr<<errormsg("You can't speak while silenced.");return}

			if(!message || message == "") return
			message = copytext(check(message),1,350)

			var/mob/Player/p = src
			if(!p.guild) return
			var/guild/g = worldData.guilds[p.guild]

			var/f = g.Rep() < 0 ? "green" : "red"

			for(var/mob/Player/m in Players)
				if(m.guild == p.guild)
					if(p.prevname)
						m << "<b><span style=\"color:[f]; font-size:2;\">Guild Channel> <span style=\"color:silver;\">[p.prevname](Masked):</span></b> <span style=\"color:white;\">[message]</span>"
					else
						m << "<b><span style=\"color:[f]; font-size:2;\">Guild Channel> <span style=\"color:silver;\">[p]:</span></b> <span style=\"color:white;\">[message]</span>"

			chatlog << "<b><span style=\"color:silver;\">[g.name]> [prevname ? prevname : name]:</span></b> <span style=\"color:white;\">[message]</span><br>"


guild
	var
		name
		id

		limit = 2

		motd

		list
			members
			ranks

	proc
		Init(mob/Player/owner, name)
			src.name = name

			if(!worldData.guilds) worldData.guilds = list()

			worldData.guilds[owner.ckey] = src
			id = owner.ckey

			members = list()
			members[owner.ckey] = 4

			owner.guild = id
			var/PlayerData/data = initPlayer(id)
			data.guild = id

			ranks = list("Recruit", "Member", "Leader", "Master")

			owner.verbs += /mob/GM/verb/Guild_Chat

		Show(mob/Player/p)

			var/params = list()
			params["guild.is-visible"] = "true"

			var/rank = members[p.ckey]

			params["guild.buttonMotd.is-visible"]   = rank > 1 ? "true" : "false"
			params["guild.buttonInvite.is-visible"] = rank > 2 ? "true" : "false"

			if(rank > 3)
				params["guild.buttonRanks.is-visible"] = "true"

				params["guild.inputRank4.text"] = ranks[4]
				params["guild.inputRank3.text"] = ranks[3]
				params["guild.inputRank2.text"] = ranks[2]
				params["guild.inputRank1.text"] = ranks[1]

			else
				params["guild.buttonRanks.is-visible"] = "false"

			winset(p, null, list2params(params)) // Execute

			p << output(null, "guild.outputMotd")
			p << output(motd, "guild.outputMotd")

			Refresh(p)

		Refresh(mob/Player/p)

			if(!(p.ckey in members))
				winset(p, "guild", "is-visible=false")
				return
			p << output(null, "guild.outputMembers")

			var/rep = Rep()
			var/alignment = rep < 0 ? "Chaos" : "Peace"
			p << output("<b>Guild Reputation:</b>\t[alignment] ([abs(rep)])<br><b>Guild Skill:</b>\t\t[Skill()]<br>", "guild.outputMembers")


			p << output("<b>Name</b>",       "guild.gridMembers:1,1")
			p << output("<b>Rank</b>",       "guild.gridMembers:2,1")
			p << output("<b>Reputation</b>", "guild.gridMembers:3,1")
			winset(p, "guild.gridMembers", "cells=5x1")

			var/playerRank = members[p.ckey]

			var/row = 1
			for(var/m in members)
				row++
				var/PlayerData/data = worldData.playersData[m]

				alignment = data.fame < 0 ? "Chaos" : "Peace"

				p << output(data.name, "guild.gridMembers:1,[row]")
				p << output(ranks[members[m]], "guild.gridMembers:2,[row]")
				p << output("[alignment] ([abs(data.fame)])", "guild.gridMembers:3,[row]")

				if(m == p.ckey)
					p << output("<a href=\"?src=\ref[p];action=guildRemove;who=[m]\">Quit</a>", "guild.gridMembers:5,[row]")
				else
					var/memberRank = members[m]

					if(playerRank > 2 && playerRank > memberRank)
						if(playerRank > memberRank + 1)
							p << output("<a href=\"?src=\ref[p];action=guildPromote;who=[m]\">Promote</a>", "guild.gridMembers:4,[row]")

						if(memberRank > 1)
							p << output("<a href=\"?src=\ref[p];action=guildDemote;who=[m]\">Demote</a>", "guild.gridMembers:5,[row]")
						else
							p << output("<a href=\"?src=\ref[p];action=guildRemove;who=[m]\">Remove</a>", "guild.gridMembers:5,[row]")

			winset(p, "guild.gridMembers", "cells=5x[row]")


		Add(mob/Player/p)
			if(!(p.ckey in members))
				members[p.ckey] = 1

				var/PlayerData/data = initPlayer(p.ckey)

				data.guild = id
				p.guild    = id

				p << infomsg("<b>Welcome to [name].</b>")
				p << infomsg(motd)


		Remove(ckey)
			if(ckey == id)

				for(var/mob/Player/p in Players)
					if(p.guild == id)
						p << errormsg("[name] guild was disbanded.")
						p.guild = null
						p.verbs -= /mob/GM/verb/Guild_Chat

				Dispose()

			else if(members.Remove(ckey))

				var/PlayerData/data = worldData.playersData[ckey]
				data.guild   = null

		Rep()
			var/i = 0
			for(var/ckey in members)
				var/PlayerData/p = worldData.playersData[ckey]
				if(p) i += p.fame

			return i

		Skill(text = 1)
			var/i = 0
			for(var/ckey in members)
				var/PlayerData/p = worldData.playersData[ckey]
				if(p) i += p.mmRating

			i /= members.len

			if(text)
				if(i >= 200)
					return "[getSkillFromNum(i)] [5 - round((i % 200) / 40)]"
				else
					return getSkillFromNum(i)
			return i

		Score()
			return (Rep() / 7200) * Skill(0)


		Dispose()
			worldData.guilds -= id

			for(var/ckey in members)
				var/PlayerData/data = worldData.playersData[ckey]
				data.guild   = null

			members = null
			ranks   = null

			if(worldData.majorPeace == id)      worldData.majorPeace = null
			else if(worldData.majorChaos == id) worldData.majorChaos = null


mob/TalkNPC/Guildmaster
	icon = 'MaleVampire.dmi'
	name = "Guildmaster"

	Talk()
		set src in oview(3)
		var/mob/Player/p = usr
		if(p.screen_text) return

		var/ScreenText/s = new(p, src)

		if(p.guild)
			s.AddText("Hey there, I offer special services to guild masters.")

			if(p.guild == p.ckey)
				var/guild/g = worldData.guilds[p.guild]
				if(g.limit >= 5)
					s.AddText("Your guild is already at max capacity.")
					return

				s.AddText("Would you like to increase your guild's capacity for 5 artifacts and 500,000 gold?")

				var/list/artifacts = getArtifacts(p, 5)
				if(p.gold.get() >= 500000 && artifacts)
					s.AddButtons(0, 0, "No", "#ff0000", "Yes", "#00ff00")
				else
					s.AddButtons(0, 0, "No", "#ff0000", 0, 0)
					return

				if(s.WaitEnd() && s.Result == "Yes")
					if(p.gold.get() < 500000) return

					for(var/obj/i in artifacts)
						if(i.loc != p) return

					p.gold.subtract(500000)
					for(var/obj/o in artifacts)
						o.Dispose()

					p.Resort_Stacking_Inv()
					g.limit++

					p << infomsg("Your guild capacity has increased to [g.limit].")

			else
				s.AddText("Tell your leader to come see me himself if he wishes to buy.")

		else

			s.AddText("Would you like to create your own guild? A guild charter costs 1,500,000 gold and 15 artifacts.")

			var/list/artifacts = getArtifacts(p, 15)
			if(p.gold.get() >= 1500000 && artifacts)
				s.AddButtons(0, 0, "No", "#ff0000", "Yes", "#00ff00")
			else
				s.AddButtons(0, 0, "No", "#ff0000", 0, 0)
				return

			if(s.WaitEnd() && s.Result == "Yes")

				var/mob/create_character/c = new
				var/desiredname = input("What name would you like? (Keep in mind that you cannot use certain names nor numbers or special characters)") as text|null
				if(!desiredname)
					del c
					return
				desiredname = trimAll(desiredname)
				var/passfilter = c.name_filter(desiredname)

				if(!passfilter)

					if(worldData.guilds && worldData.guilds.len)
						for(var/guild/g in worldData.guilds)
							if(g.name == desiredname)
								passfilter = "a guild already exists with that name"
								break
				else
					passfilter = "it [passfilter]"

				while(passfilter)
					alert("Your desired name is not allowed as [passfilter].")
					desiredname = input("Please select a name that does not use numbers or special characters.") as text|null
					if(!desiredname)
						del c
						return
					desiredname = trimAll(desiredname)
					passfilter = c.name_filter(desiredname)

					if(!passfilter)

						if(worldData.guilds && worldData.guilds.len)
							for(var/guild/g in worldData.guilds)
								if(g.name == desiredname)
									passfilter = "a guild already exists with that name"
									break
					else
						passfilter = "it [passfilter]"

				del c

				if(p.gold.get() >= 1500000)
					for(var/obj/o in artifacts)
						if(o.loc != p) return

					p.gold.subtract(1500000)
					for(var/obj/o in artifacts)
						o.Dispose()

					p.Resort_Stacking_Inv()

					var/guild/g = new
					g.Init(p, desiredname)


proc/trimRight(text)
	var/i
	for(i = 1 to length(text))
		if(text2ascii(text, i) == 32)
			continue
		break
	return copytext(text, i)

proc/trimLeft(text)
    var/i
    for(i = length(text) to 1 step -1)
        if(text2ascii(text, i) == 32)
            continue
        break
    return copytext(text, 1, i+1)

proc/trimAll(text)
    return trimRight(trimLeft(text))


// BUG: can take more than required artifacts if using combined old+new stacking
proc/getArtifacts(mob/Player/p, amount)

	var/list/artifacts = list()
	var/i = 0
	for(var/obj/items/artifact/a in p)
		artifacts += a
		i         += a.stack

		if(i >= amount) break

	return i >= amount ? artifacts : null


obj/guild
	icon='statues.dmi'
	icon_state="sign"
	pixel_y = 8
	pixel_x = -1
	layer = 5

	mouse_over_pointer = MOUSE_HAND_POINTER

	Click()
		..()

		if(src in orange(3))

			var/mob/Player/p = usr
			if(!p.guild)
				p << errormsg("You are not in a guild.")
				return

			var/guild/g = worldData.guilds[p.guild]
			g.Show(p)

		else
			usr << errormsg("You need to be closer.")


mob/Player/verb/guild_command(var/action as text)
	set hidden = 1
	set name   = ".guildcommand"
	if(!guild) return

	var/guild/g = worldData.guilds[guild]

	var/rank = g.members[ckey]

	if(action == "motd"   && rank > 1)

		var/text = input("What would you like to set message of the day to? (200 characters limit)", "Guild MOTD", g.motd) as null|message
		if(text)
			g.motd = copytext(text, 1, 200)
			src << output(null,   "guild.outputMotd")
			src << output(g.motd, "guild.outputMotd")

	else if(action == "invite" && rank > 2)

		if(g.members.len >= g.limit)
			src << errormsg("Your guild is at max capacity.")
			return

		var/mob/Player/p = input("Who would you like to invite? (Invite costs 200,000 Gold, even if they decline)", "Guild Invite") as null|anything in Players(list(usr))
		if(p)
			if(istext(p))
				p = text2mob(p)

			if(gold.get() < 200000)
				src << errormsg("You don't have enough gold.")
				return

			if(p.guild)
				src << errormsg("They are already in a guild.")
				return

			gold.subtract(200000)

			src=null
			spawn()
				if(alert(p, "Would you like to join [g.name] guild?", "Guild Invite", "Yes", "No") == "Yes")
					g.Add(p)
					p.verbs += /mob/GM/verb/Guild_Chat




	else if(action == "ranks"  && rank > 3)
		var/list/ranks = params2list(winget(src, "guild.inputRank1;guild.inputRank2;guild.inputRank3;guild.inputRank4", "text"))

		for(var/i = 1 to 4)
			g.ranks[i] = copytext(ranks[ranks[i]], 1, 20)


		g.Refresh(src)
		src << infomsg("Guild ranks changed.")


mob/Player/proc/getGuildAreas()
	if(!guild) return

	. = 0

	for(var/a in worldData.areaData)
		var/AreaData/data = worldData.areaData[a]

		if(data.guild == guild) .++