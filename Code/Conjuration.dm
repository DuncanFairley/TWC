mob/verb/updateHPMP()
	set hidden = 1

	var/hppercent = clamp(HP / MHP, 0, 1)
	var/mppercent = clamp(MP / MMP, 0, 1)

	src:Interface.hpbar.Set(hppercent)
	src:Interface.mpbar.Set(mppercent)

	src:Interface.hpbar.UpdateText(HP, MHP)
	src:Interface.mpbar.UpdateText(MP, MMP)

	if(!(src:tickers & MP_REGEN) && MP < MMP)
		src:MPRegen()

	if(src:hpBar)
		src:hpBar.Set(hppercent, src)

	if(src:party)
		src:party.updateHP(src, hppercent)

	if(!(src:tickers & HP_REGEN) && HP < MHP && src:animagusOn)
		src:HPRegen()

mob/Player
	proc/updateMP()
		var/mppercent = clamp(MP / MMP, 0, 1)

		Interface.mpbar.Set(mppercent)
		Interface.mpbar.UpdateText(MP, MMP)

		if(!(tickers & MP_REGEN) && MP < MMP)
			MPRegen()

	proc/updateHP()
		var/hppercent = clamp(HP / MHP, 0, 1)
		Interface.hpbar.Set(hppercent)
		Interface.hpbar.UpdateText(HP, MHP)

		hpBar.Set(hppercent, src)

		if(party)
			party.updateHP(src, hppercent)

		if(!(tickers & HP_REGEN) && HP < MHP && animagusOn)
			HPRegen()

mob/Player
	var
		MPRegen = 0
		tmp/tickers = 0

	proc/MPRegen()
		set waitfor = 0

		tickers |= MP_REGEN
		sleep(50)

		while(MP < MMP)
			MP = min(MP + 50 + round(level/10)*2 + MPRegen, MMP)
			var/mppercent = clamp(MP / MMP, 0, 1)

			Interface.mpbar.Set(mppercent)
			Interface.mpbar.UpdateText(MP, MMP)
			sleep(50)

		tickers &= ~MP_REGEN

	proc/HPRegen()
		set waitfor = 0

		if(tickers & HP_REGEN) return
		tickers |= HP_REGEN
		sleep(10)

		while(HP < MHP && animagusOn)

			if(world.time - lastCombat > 100) // disables hp regen in pvp

				HP = min(HP + 30 + round(level/10)*3 + Animagus.level*3, MHP)
				var/hppercent = clamp(HP / MHP, 0, 1)

				Interface.hpbar.Set(hppercent)
				Interface.hpbar.UpdateText(HP, MHP)

				hpBar.Set(hppercent, src)
			sleep(10)

		tickers &= ~HP_REGEN

mob/var/Gender
mob/var/tmp/usedpermoveo
mob/var/tmp/removeoMob



mob/GM
	verb
		GM_Herbificus()
			set category = "Spells"
			if(src.key)
				var/obj/redroses/p = new
				p.GM_Made = 1
				p.accioable = 0
				p:loc = locate(src.x,src.y-1,src.z)
				p.FlickState("Orb",12,'Effects.dmi')
				p:owner = "[usr.key]"
				hearers()<<"<b><span style=\"color:red;\">[usr]:</span> Herbificus."


obj/healthbar
	mouse_opacity = 0
	icon = 'healthbar_28.dmi'

	var/barSize = 13.5

	pixel_x = 2
	pixel_y = -6
	color   = "#0d0"
	appearance_flags = LONG_GLIDE|TILE_BOUND|PIXEL_SCALE
	layer = 4
	canSave = 0

	New(mob/Player/p)
		overlays += /obj/hpframe/small

		if(p)
			loc = p.loc

			if(isplayer(p))
				if(p.HP == p.MHP)
					alpha = 0
				else
					Set(clamp(p.HP / p.MHP, 0, 1), src, instant=1)
				p:addFollower(src)

				glide_size = p.glide_size

	big
		barSize = 31.5
		icon = 'healthbar_64.dmi'

		pixel_x = -20
		pixel_y = -24
		layer = 5

		New(mob/p)

			overlays += /obj/hpframe/big

			if(p)
				if(p.HP == p.MHP)
					alpha = 0

				loc = p.loc

				glide_size = p.glide_size

	screen
		icon = 'healthbar_256.dmi'
		icon_state = "pixel"
		plane = 2
		layer = 10
		parent_type = /hudobj

		mouse_opacity = 0

		var
			const/barSize = 127.5
			isMana = 0
			tmp/obj/mtext
			tmp/obj/hpframe/screenBack/back


		New(loc, mob/Player/p, anchorX, screenX, anchorY, screenY, mana=0)
			client = p.client
			isMana     = mana
			overlays  += /obj/hpframe/screen

			back = new

			anchor_x = anchorX
			screen_x = screenX
			anchor_y = anchorY
			screen_y = screenY

			mtext = new
			mtext.maptext_width = 256
			mtext.maptext_height = 16
			mtext.layer = 12
			mtext.plane = 2

			if(isMana)

				Set(clamp(p.MP / p.MMP, 0, 1), instant=1)
				UpdateText(p.MP, p.MMP)
			else
				Set(clamp(p.HP / p.MHP, 0, 1), instant=1)
				UpdateText(p.HP, p.MHP)

			updatePos()

			p.client.screen += mtext
			p.client.screen += src
			p.client.screen += back

		proc
			UpdateText(current, max)
				mtext.maptext = "<b style=\"text-align: center;\">[current]/[max]</b>"

			Set(var/perc, instant=0)
				set waitfor = 0
				var/newX = perc * barSize
				var/matrix/m = matrix(1 - perc, 0, newX, 0, 1, 0)

				var/c
				if(isMana)
					if(perc > 0.6) c = "#39f"
					else if(perc >= 0.3) c = "#66b2ff"
					else c = "#9cf"
				else
					if(perc > 0.6) c = "#0d0"
					else if(perc >= 0.3) c = "#d90"
					else c = "#d00"

				if(instant)
					color = c
					back.transform = m
				else
					animate(back, transform = m, time = 10)
					animate(src, color = c, time = 10)

		updatePos()
			..()
			mtext.screen_loc = screen_loc
			back.screen_loc = screen_loc

	proc
		Set(var/perc, mob/M, instant=0)
			set waitfor = 0
			var/newX     = (perc - 1) * barSize

			var/matrix/m = matrix(perc, 0, newX, 0, 1, 0)

			if(alpha == 0 && perc != 1)
				animate(src, alpha = 255, time = 5)
				sleep(5)

			var/c
			if(perc > 0.6) c = "#0d0"
			else if(perc >= 0.3) c = "#d90"
			else c = "#d00"


			if(instant)
				color = c
				transform = m
			else
				animate(src, color = c, transform = m, time = 10)

			if(perc >= 1 && M)
				sleep(15)
				if(M && M.HP >= M.MHP)
					animate(src, alpha = 0, time = 5)

obj/hpframe
	layer = FLOAT_LAYER
	small
		icon = 'healthbar_28.dmi'
		icon_state = "frame"
	big
		icon = 'healthbar_64.dmi'
		icon_state = "frame"
	screenBack
		icon = 'healthbar_256.dmi'
		icon_state = "frameBack"
		plane = 2
		layer = 11
	screen
		icon = 'healthbar_256.dmi'
		icon_state = "frame"
		layer = 12
		plane = 2

	appearance_flags = RESET_TRANSFORM|RESET_COLOR|PIXEL_SCALE


mob/Player/var/tmp/obj/healthbar/hpBar
