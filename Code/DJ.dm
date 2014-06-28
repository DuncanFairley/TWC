/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
var/list/DJs

mob/GM/verb/Hire_DJ(var/k as text)
	set category = "DJ"
	if(!k || k == "")return
	k = ckey(k)
	if(!DJs)
		DJs = list()
	DJs += k
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


mob/GM/verb/Prize_Draw()
	set category = "DJ"
	var/txt = input("Enter the names going into the draw, seperating them so that there's one name on each line.") as null|message
	if(!txt)return
	var/txt_list = dd_text2list(txt, "\n")

	switch(alert("Would you like to display the list?", "Prize Draw", "Yes", "No"))
		if("Yes")
			hearers(client.view) << "<font color='#DF0101' size='3' face='Comic Sans MS'>The list contains:\n[txt]</font>"
	DRAW
	var/winner = pick(txt_list)
	switch(alert("The magical box of Murra-Awesome draws the name: [winner]", "Prize Draw", "Redraw", "Announce", "Cancel"))
		if("Redraw")
			goto DRAW
		if("Announce")
			hearers(client.view) << "<font color='#DF0101' size='3' face='Comic Sans MS'>[winner] was picked!</font>"
			goto DRAW