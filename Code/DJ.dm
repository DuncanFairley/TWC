var/list/djlist = list()

mob/GM/verb/Hire_Head_DJ()
	set category = "DJ"
	var/mob/M = input("Who would you like to add as Head DJ?") as null|mob in Players
	if(!M)return
	usr << infomsg("You have added [M] as the TWC Radio Head DJ.")
	M << infomsg("You have been chosen as Head DJ for TWC Radio.")
	djlist.Add(M.name)
	src.verbs += /mob/GM/verb/Toggle_TWC_Radio
	src.verbs += /mob/GM/verb/Prize_Draw
	src.verbs += /mob/GM/verb/DJ_Announce
	src.verbs += /mob/GM/verb/Hire_DJ
	src.verbs += /mob/GM/verb/Fire_DJ

mob/GM/verb/Hire_DJ()
	set category = "DJ"
	var/mob/M = input("Who would you like to add as a DJ?") as null|mob in Players
	if(!M)return
	usr << infomsg("You have added [M] as a TWC Radio DJ.")
	M << infomsg("You have been chosen as a DJ for TWC Radio.")
	djlist.Add(M.name)
	src.verbs += /mob/GM/verb/Toggle_TWC_Radio
	src.verbs += /mob/GM/verb/Prize_Draw
	src.verbs += /mob/GM/verb/DJ_Announce

mob/GM/verb/Fire_DJ()
	set category = "DJ"
	var/mob/M = input("Who would you like to remove as a DJ?") as null|anything in djlist
	if(!M)return
	djlist.Remove(M)
	usr << infomsg("[M] has been removed as a DJ.")
	src.verbs -= /mob/GM/verb/Toggle_TWC_Radio
	src.verbs -= /mob/GM/verb/Prize_Draw
	src.verbs -= /mob/GM/verb/DJ_Announce
	src.verbs -= /mob/GM/verb/Hire_DJ
	src.verbs -= /mob/GM/verb/Fire_DJ

mob/GM/verb/DJ_Announce(message as message)
	set category = "DJ"
	set name = "DJ Announce"
	for(var/client/C)
		C.mob << "<center><font color=silver><b>[message]</font></center>"