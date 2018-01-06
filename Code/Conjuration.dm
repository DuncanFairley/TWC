/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

mob/verb/updateHPMP()
	set name = ".updateHPMP"
	if(!key)return
	spawn()
		var/hppercent = HP / (MHP+extraMHP) * 100
		var/mppercent = MP / (MMP+extraMMP) * 100
		winset(src,null,"barHP.value=[hppercent];barMP.value=[mppercent];")

		if(hppercent > 0 && src:hpBar)
			src:hpBar.Set(hppercent/100, src)

			if(src:party)
				src:party.updateHP(src, hppercent/100)

mob
	var
		Gender

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

	var/barSize = 14

	pixel_x = 2
	pixel_y = -6
	color   = "#0d0"
	appearance_flags = LONG_GLIDE|TILE_BOUND
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
		barSize = 32
		icon = 'healthbar_64.dmi'

		pixel_x = -20
		pixel_y = -24
		layer = 5

		New(mob/p, hud)

			overlays += /obj/hpframe/big

			if(p)
				if(p.HP == p.MHP + p.extraMHP)
					alpha = 0

				loc = p.loc

				glide_size = p.glide_size


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

	appearance_flags = RESET_TRANSFORM|RESET_COLOR


mob/Player/var/tmp/obj/healthbar/hpBar