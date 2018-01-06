
// todo, exp share, perhaps total exp display

mob/Player/var/tmp
	party/party
	list/partyTokens

mob/Party/verb/Party_Chat(var/message as text)
	set name="Party Chat"

	var/mob/Player/p = src
	if(p.mute==1||p.Detention){p<<errormsg("You can't speak while silenced.");return}

	if(!message || message == "") return
	message = copytext(check(message),1,350)

	if(!p.party) return

	var/f
	if(p.House == "Hufflepuff")
		f = "yellow"
	else if(p.House == "Slytherin")
		f = "green"
	else if(p.House == "Ravenclaw")
		f = "blue"
	else
		f = "red"

	for(var/mob/Player/m in p.party.members)
		if(p.prevname)
			m << "<b><span style=\"color:[f]; font-size:2;\">Party Channel> <span style=\"color:silver;\">[p.prevname](Masked):</span></b> <span style=\"color:white;\">[message]</span>"
		else
			m << "<b><span style=\"color:[f]; font-size:2;\">Party Channel> <span style=\"color:silver;\">[p]:</span></b> <span style=\"color:white;\">[message]</span>"

	chatlog << "<b><span style=\"color:silver;\">Party> [p.prevname ? p.prevname : name]:</span></b> <span style=\"color:white;\">[message]</span><br>"


party
	var
		leader
		list/members
		list/healths

	New(mob/Player/p)
		leader = p.ckey

		members = list()
		healths = list()
		new /hudobj/Party_Kick   (null, p.client, null, 1)

		add(p)

	proc
		updateHP(var/mob/Player/p, var/perc)
			var/obj/healthbar/hp = healths[p.ckey]
			hp.Set(perc)

		refreshHealthPos()
			var/mob/Player/m = members[1]
			var/offset = 2
			for(var/obj/healthbar/bar in m.client.screen)
				bar.screen_loc = "NORTH-[offset],WEST+2"
				offset++
				m.client.screen += bar

		add(var/mob/Player/p)
			members += p

			p.party = src

			new /hudobj/Party_Leave  (null, p.client, null, 1)

			if(p.ckey != leader)
				var/hudobj/Party_Invite/o = locate() in p.client.screen
				if(o)
					o.hide()

			p.verbs += new/mob/Party/verb/Party_Chat

			var/obj/healthbar/big/hpbar = new()
			var/obj/hpMaptext = new
			hpMaptext.maptext = p.name
			hpMaptext.maptext_width = 96
			hpMaptext.maptext_y = 6
			hpMaptext.appearance_flags = RESET_TRANSFORM
			hpbar.overlays += hpMaptext
			hpbar.screen_loc = "NORTH-[members.len],WEST+2"

			hpbar.Set(p.HP / (p.MHP + p.extraMHP), instant=1)
			healths[p.ckey] = hpbar

			for(var/c in healths)
				var/obj/h = healths[c]
				p.client.screen += h

			for(var/mob/Player/m in members)
				if(m == p) continue
				m.client.screen += hpbar

			refreshHealthPos()


		remove(var/mob/Player/p)
			for(var/mob/Player/m in members)
				m.client.screen -= healths[p.ckey]
			healths -= p.ckey

			for(var/obj/healthbar/bar in p.client.screen)
				p.client.screen -= bar

			members -= p
			p.party = null
			p.partyTokens = null

			p.verbs -= /mob/Party/verb/Party_Chat

			var/hudobj/Party_Leave/o = locate() in p.client.screen
			if(o)
				o.hide()



			if(leader == p.ckey)
				var/hudobj/Party_Kick/o2 = locate() in p.client.screen
				if(o2)
					o2.hide()

				if(members.len > 1)
					var/mob/Player/m = members[1]
					leader = m.ckey

					m << infomsg("You are now the party leader.")

					new /hudobj/Party_Invite (null, m.client, null, 1)
					new /hudobj/Party_Kick   (null, m.client, null, 1)
				else
					for(var/mob/Player/m in members)
						remove(m)
						m << infomsg("The party has been disbanded.")
					members = null
					healths = null
			else
				new /hudobj/Party_Invite(null, p.client, null, 1)

			if(members && members.len > 1)
				refreshHealthPos()
			else
				for(var/mob/Player/m in members)
					remove(m)
					m << infomsg("The party has been disbanded.")
				members = null
				healths = null

		addExp(var/amount, var/mob/Player/p)
			amount = round(amount / members.len, 1)

			var/area/a = p.loc.loc

			for(var/mob/Player/m in members)
				var/area/checkArea = m.loc.loc
				if(checkArea.region == a.region)
					m.addExp(amount, !m.MonsterMessages)


hudobj
	Party_Invite
		icon_state = "party_add"

		anchor_x    = "EAST"
		screen_x    = -96
		screen_y    = 64
		anchor_y    = "SOUTH"

		Click()
			var/mob/Player/p = usr

			if(IsInputOpen(p, "Party"))
				del p._input["Party"]

			var/list/people = ohearers(p.client.view)&Players
			var/mob/Player/M

			for(var/mob/Player/c in people)
				if(c.party) people-=c

			if(people.len)
				var/Input/popup = new (p, "Party")
				M = popup.InputList(p, "Who to invite?", "Party Invite", people[1], people)
				del popup
			if(!M) return
			if(!(M in ohearers(p.client.view))) return

			if(!p.partyTokens)
				p.partyTokens = list()

			p.partyTokens += M.ckey

			M << infomsg("[p.name] invites you to a party, <a href=\"byond://?src=\ref[M];action=party_join;leader=\ref[p]\">click here</a> to join.")

	Party_Kick
		icon_state = "party_remove"

		anchor_x    = "EAST"
		screen_x    = -64
		screen_y    = 64
		anchor_y    = "SOUTH"

		Click()
			var/mob/Player/p = usr

			if(IsInputOpen(p, "Party"))
				del p._input["Party"]

			var/list/people = p.party.members - p
			var/mob/Player/M

			if(people.len)
				var/Input/popup = new (p, "Party")
				M = popup.InputList(p, "Who to kick?", "Party Kick", people[1], people)
				del popup
			if(!M) return

			p.party.remove(M)

	Party_Leave
		icon_state = "party_leave"

		anchor_x    = "EAST"
		screen_x    = -32
		screen_y    = 64
		anchor_y    = "SOUTH"

		Click()
			var/mob/Player/p = usr
			p.party.remove(p)
			usr << infomsg("You left the party.")
