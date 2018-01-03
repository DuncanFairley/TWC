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

		if(src:hpBar)
			var/newWidth = hppercent/100
			var/newX     = (newWidth - 1) * 14

			var/matrix/m = matrix(newWidth, 0, newX, 0, 1, 0)

			if(src:hpBar.alpha == 0 && newWidth != 1)
				animate(src:hpBar, alpha = 255, time = 5)
				sleep(5)

			animate(src:hpBar, transform = m, time = 10)

			if(newWidth == 1)
				sleep(15)
				if(HP == MHP+extraMHP)
					animate(src:hpBar, alpha = 0, time = 5)

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
	icon = 'healthbar.dmi'

	New(mob/Player/p)
		pixel_x = 2
		pixel_y = -6
		color   = "#0d0"

		p.addFollower(src)
		overlays += /obj/healthbar/frame

		if(p.HP == p.MHP + p.extraMHP)
			alpha = 0

		loc = p.loc

	frame
		icon_state = "frame"
		appearance_flags = RESET_TRANSFORM|RESET_COLOR


mob/Player/var/tmp/obj/healthbar/hpBar