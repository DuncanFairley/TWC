var/list/djlist = list()

mob/GM/verb/Hire_DJ()
	set category = "DJ"
	var/mob/M = input("Who would you like to add as a DJ?") as null|mob in Players
	if(!M)return
	usr << infomsg("You have added [M] as a TWC Radio DJ.")
	M << infomsg("You have been chosen as a DJ for TWC Radio.")
	djlist.Add(M.name)
	M.verbs += /mob/GM/verb/Toggle_TWC_Radio
	M.verbs += /mob/GM/verb/Prize_Draw
	M.verbs += /mob/GM/verb/DJ_Announce
	M.verbs += /mob/GM/verb/DJ_chat
	M.DJ = 1

mob/GM/verb/Fire_DJ()
	set category = "DJ"
	var/mob/M = input("Who would you like to remove as a DJ?") as null|anything in djlist
	if(!M)return
	djlist.Remove(M)
	usr << infomsg("[M] has been removed as a DJ.")
	M.verbs -= /mob/GM/verb/Toggle_TWC_Radio
	M.verbs -= /mob/GM/verb/Prize_Draw
	M.verbs -= /mob/GM/verb/DJ_Announce
	M.verbs -= /mob/GM/verb/Hire_DJ
	M.verbs -= /mob/GM/verb/Fire_DJ
	M.verbs -= /mob/GM/verb/DJ_chat
	M.DJ = 0

mob/GM/verb/DJ_Announce(message as message)
	set category = "DJ"
	set name = "DJ Announce"
	for(var/client/C)
		C.mob << "<center><font color=silver><b>[message]</font></center>"

mob/GM/verb/DJ_chat(var/messsage as text)
	set category="DJ"
	set name="DJ Chat"
	if(usr.mute==1||usr.Detention){usr<<"You can't speak while silenced.";return}
	if(messsage)
		messsage = copytext(check(messsage),1,350)
		if(messsage == null || messsage == "") return
		for(var/client/C)
			if(C.mob)if(C.mob.DJ==1)
				if(usr.name == "Deatheater")
					C<<"<b><font color=red><font size=2>DJ Channel> <font size=2><font color=silver>[usr.prevname]:</b> <font color=white>[messsage]"
				else
					C<<"<b><font color=red><font size=2>DJ Channel> <font size=2><font color=silver>[usr]:</b> <font color=white>[messsage]"