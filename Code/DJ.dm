var/list/DJs = list()

mob/GM/verb/Hire_DJ(var/k as text)
	set category = "DJ"
	if(!k || k == "")return
	if(!DJs)
		DJs = list()
	DJs +=k
	src << infomsg("You hired [k].")

	for(var/mob/Player/p in Players)
		if(p.ckey == k)
			p << infomsg("You have been chosen as a DJ for TWC Radio.")
			isDJ(p)
			break

mob/GM/verb/Fire_DJ(var/k in DJs)
	set category = "DJ"
	if(!k)return
	DJs -= k
	if(!DJs.len) DJs = null
	src << infomsg("You fired [k].")

	for(var/mob/Player/p in Players)
		if(p.ckey == k)
			isDJ(p)
			break

proc/isDJ(mob/Player/p)

	if(DJs && (p.ckey in DJs))
		p.verbs += /mob/GM/verb/Toggle_TWC_Radio
		p.verbs += /mob/GM/verb/Prize_Draw
	else if(!(p.Gm || p.admin))
		p.verbs -= /mob/GM/verb/Toggle_TWC_Radio
		p.verbs -= /mob/GM/verb/Prize_Draw
		p.verbs -= /mob/GM/verb/Hire_DJ
		p.verbs -= /mob/GM/verb/Fire_DJ