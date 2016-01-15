/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
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

mob
	GM
		verb/Warn(mob/M in Players)
			set category="Staff"
			for(var/mob/A in Players)
				if(A.key&&A.Gm) A << "<b><u><span style=\"color:#FF14E0;\">[src] is warning [M]</span></u></b>"
			var/Reason = input(src,"Why are you warning [M]?","Specify Why","Harming others within safe zones is not allowed. (Hogwarts and Diagon Alley)") as null|text
			if(!Reason)return
			if(!M)
				src << errormsg("The person you tried to warn logged out, apply the warning when they log back in.")
				return
			Log_admin("[src] has warned [M] for \"[Reason]\"")
			spawn()sql_add_plyr_log(M.ckey,"wa",Reason)
			M<<"<p><span style=\"color:red;\">You have been issued a warning by [usr]. <p><b><font color=white>Reason: [Reason].</b></span> <p></font><span style=\"color:red;\">If you proceed in these actions, you could be Expelled/Booted/Muted or sent to Detention.</span></p>"
			M<< browse(rules,"window=1")
mob/var/tmp
	mprevicon

mob/var/tmp/Rictalk

obj/var/followplayer
obj/var/loco

mob
	proc
		clanrobed()
			if((locate(/mob/GM/verb/GM_chat) in usr.verbs) && (prevname))
				src << errormsg("You cannot use any GM verbs while wearing clan clothing.")
				return 1

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
				hearers()<<"<span style=\"color:red;\">[usr] meditates.</span>"
				sleep(50)
				usr.overlays-=/image/meditate

				var/maxMP = usr.MMP + usr.extraMMP
				usr.MP = min(maxMP, MP + maxMP*0.5)

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
				hearers()<<"<span style=\"color:red;\">[usr] raises \his hand.</span>"
				usr << "<b>Raise Hand is used during class to tell your teacher that you have a question. Use it again to lower your hand.</b>"
				usr.questionius=1
			else if(usr.questionius==1)
				usr.overlays-=icon('hand.dmi')
				usr << "You put your hand down."
				usr.questionius=0
			else
				usr.overlays+=icon('hand.dmi')
				hearers(usr.client.view,usr)<<"<span style=\"color:red;\">[usr] raises \his hand.</span>"
				usr.questionius=1
mob/verb/Emote(t as text)
	if(usr.Rictusempra==10) return
	if(usr.mute==1)
		usr << errormsg("You can't emote while you are muted.")
		return
	t=check(t)//run the text through the cleaner
	t = copytext(t,1,350)
	hearers()<<"<i>[usr] [t]</i>"
