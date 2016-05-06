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