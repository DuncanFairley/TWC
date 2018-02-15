/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

mob/verb/updateHPMP()
	set hidden = 1

	var/hppercent = clamp(HP / (MHP+extraMHP), 0, 1)
	var/mppercent = clamp(MP / MMP, 0, 1)

	src:Interface.hpbar.Set(hppercent)
	src:Interface.mpbar.Set(mppercent)

	src:Interface.hpbar.UpdateText(HP, MHP+extraMHP)
	src:Interface.mpbar.UpdateText(MP, MMP)

	src:hpBar.Set(hppercent, src)

	if(src:party)
		src:party.updateHP(src, hppercent)

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
				flick('dlo.dmi',p)
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
				if(p.HP == p.MHP + p.extraMHP)
					alpha = 0
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
				if(p.HP == p.MHP + p.extraMHP)
					alpha = 0

				loc = p.loc

				glide_size = p.glide_size

	screen
		barSize = 127.5
		icon = 'healthbar_256.dmi'
		icon_state = "pixel"
		plane = 2
		layer = 10

		var
			isMana = 0
			tmp/obj/mtext
			tmp/obj/hpframe/screenBack/back


		New(loc, mob/Player/p, sloc, mana=0)
			isMana     = mana
			overlays  += /obj/hpframe/screen

			back = new
			back.screen_loc = sloc
			p.client.screen += back

			screen_loc = sloc
			p.client.screen += src

			mtext = new
			mtext.screen_loc = sloc
			mtext.maptext_width = 256
			mtext.maptext_height = 16
			mtext.layer = 12
			mtext.plane = 2
			p.client.screen += mtext

			if(isMana)

				Set(clamp(p.MP / p.MMP, 0, 1), instant=1)
				UpdateText(p.MP, p.MMP)
			else
				Set(clamp(p.HP / (p.MHP + p.extraMHP), 0, 1), instant=1)
				UpdateText(p.HP, p.MHP + p.extraMHP)

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

			if(perc == 1 && M)
				sleep(15)
				if(M.HP == M.MHP+M.extraMHP)
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
