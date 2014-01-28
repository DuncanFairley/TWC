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
proc
	GetFiles(dir, extension)
		var/list/L
		var/list/L2
		var/F
		L = flist(dir)
		L2 = new /list()
		for(F in L)
			if(copytext(F,length(F)) == "/")
				L2 += GetFiles(dir + F, extension)
			else if(!extension || copytext(F,length(F) - length(extension)+1) == extension)
				L2.Add(dir + F)
		return L2

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
				view()<<"<b><Font color=red>[usr]:</font> Herbificus."