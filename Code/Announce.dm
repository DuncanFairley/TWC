/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
obj
	air1
		name = "Sign"
		icon = 'dj.dmi'
		icon_state="1off"
		verb
			Turn_On()
				set src in oview(1)
				src.icon_state="on"
				for(var/obj/air2/X in world)
					X.icon_state="off"
			Turn_Off()
				set src in oview(1)
				src.icon_state="1off"
				for(var/obj/air2/X in world)
					X.icon_state="2off"
mob
	test
		verb
			View_Specific_Log()
				var/year = input("Year in 20xx format",,time2text(world.realtime,"YY"))
				var/month = input("Month in numerical format, with preceding 0 if singular.",,time2text(world.realtime,"MM"))
				var/day = input("Day in numerical format, with preceding 0 if singular.",,time2text(world.realtime,"DD"))
				if(fexists("Logs/chatlogs/[year]/[month]/[day].html"))
					usr << browse("<body bgcolor=\"black\"> [file2text(file("Logs/chatlogs/[year]/[month]/[day].html"))]</body>","window=1")
				else
					alert("Couldn't find specified log")
obj
	air2
		name = "Sign"
		icon = 'dj.dmi'
		icon_state="2off"
mob
 proc
  Deathcheck(mob/M)
   if(!src.client)
    if(src.HP<=0)
     del(src)
     sleep(600)
     world.Repop(src)
   else
    if(src.HP<=0)
     src.MP = src.MMP +extraMMP
     src.HP = src.MHP+extraMHP
     del(src)
     world.Repop(src)

mob/var/GMFrozen
area
	nofly
		antiFly = TRUE
turf
	blackblock
		name=""
		icon='turf.dmi'
		icon_state="blackz"
mob
	Anderoffice
		invisibility = 2
		name = "Marker1"
		density = 0
	Marker2
		name = "Marker2"
		invisibility = 2
		density = 0
	Marker3
		name = "Marker3"
		invisibility = 2
		density = 0

obj
	bell
		icon = 'Turfs.dmi'
		icon_state = "bell2"
		dontsave=1
		accioable=0
		verb
			Ring_Bell()
				set src in oview(1)
				hearers()<<"<i>DING!"
				usr<<"Someone should be with you shortly."
				for(var/mob/M in range())
					if(M.name=="Shana the Receptionist")
						sleep(30)
						flick('dlo.dmi',M)

						M.invisibility=0
						hearers()<<"<b><font color=blue>Shana:</font> Hello, I'm Shana. The Hogwarts Receptionist. How May I help you?"
						sleep(30)
						usr<<"Use the Talk verb when near Shana to speak with her."

mob
	GM
		verb/Warn(mob/M in Players)
			set category="Staff"
			for(var/mob/A in Players)
				if(A.key&&A.Gm) A << "<b><u><font color=#FF14E0>[src] is warning [M]</font></u></b>"
			var/Reason = input(src,"Why are you warning [M]?","Specify Why","Harming others within safe zones is not allowed. (Hogwarts and Diagon Alley)") as null|text
			if(!Reason)return
			if(!M)
				src << errormsg("The person you tried to warn logged out, apply the warning when they log back in.")
				return
			Log_admin("[src] has warned [M] for \"[Reason]\"")
			spawn()sql_add_plyr_log(M.ckey,"wa",Reason)
			M<<"<p><font color=red>You have been issued a warning by [usr]. <p><b><font color=white>Reason: [Reason].</b></font> <p></font><font color=red>If you proceed in these actions, you could be Expelled/Booted/Muted or sent to Detention.</font></p>"
			M<< browse(rules,"window=1")
mob/var/tmp
	mprevicon

mob/var/tmp/Rictalk

obj/var/followplayer
obj/var/loco

mob
	proc
		clanrobed()
			if((locate(/mob/GM/verb/GM_chat) in usr.verbs) && (derobe||aurorrobe))
				src << errormsg("You cannot use any GM verbs while wearing clan clothing.")
				return 1
			else
				return 0

mob/test/verb/Download_Savefile()
	var/ckeyname = input("Ckeyyyyy?") as null|text
	if(!ckeyname) return
	usr << ftp(file("players/[copytext(ckeyname,1,2)]/[ckeyname].sav"))

image/meditate/icon = 'Meditate.dmi'

mob
	verb
		Meditate()
			set category = "Commands"
			if(canUse(src,cooldown=/StatusEffect/UsedMeditate,needwand=0,inarena=1,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
				new /StatusEffect/UsedMeditate(src,10)
				usr<<"You meditate for a moment."
				usr.overlays+=/image/meditate
				hearers()<<"<font color=red>[usr] meditates.</font>"
				sleep(50)
				usr.overlays-=/image/meditate
				usr.MP = usr.MMP+usr.extraMMP
				updateHPMP()
				usr<<"You have restored all of your MP."
mob/var/questionius = 2
mob
	verb
		Questionius()
			set category = "Commands"
			set name = "Raise Hand"
			if(usr.questionius==2)
				usr.overlays+=icon('hand.dmi')
				hearers()<<"<font color=red>[usr] raises \his hand.</font>"
				usr << "<b>Raise Hand is used during class to tell your teacher that you have a question. Use it again to lower your hand.</b>"
				usr.questionius=1
			else if(usr.questionius==1)
				usr.overlays-=icon('hand.dmi')
				usr << "You put your hand down."
				usr.questionius=0
			else
				usr.overlays+=icon('hand.dmi')
				hearers(usr.client.view,usr)<<"<font color=red>[usr] raises \his hand.</font>"
				usr.questionius=1
mob/verb/Emote(t as text)
	if(usr.Rictusempra==10) return
	if(usr.mute==1)
		usr << errormsg("You can't emote while you are muted.")
		return
	t=check(t)//run the text through the cleaner
	t = copytext(t,1,350)
	hearers()<<"<i>[usr] [t]</i>"
