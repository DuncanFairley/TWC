/*
 * Copyright � 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
client/proc/radio_start()
	if(radioEnabled)
		usr << "<center><b>Loading TWC Radio...</b></center><br>"
		winset(src,"radio_enabled","is-checked=true")
		usr << browse("<embed src=\"http://srv1.hotdogradio.com:8000/TWC.m3u\" autostart=true loop=false volume=100 hidden=true></embed>","window=radiobrowser")
	else
		usr << "<center><b>TWC Radio is not currently on-air.</b></center><br>"
mob/verb/radio_end()
	set hidden = 1
	usr << browse(null,"window=radiobrowser")
	winset(usr,"radio_enabled","is-checked=false")
client/verb/linkenable_radio()
	set hidden = 1
	if(winget(src, "radio_enabled", "is-checked")=="true")
		mob.radio_end()
	else
		radio_start()
client/verb/enable_radio()
	set hidden = 1
	if(winget(src, "radio_enabled", "is-checked")=="false")
		mob.radio_end()
	else
		radio_start()
var/radiosonginfo = {"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>TWC Radio</title>
<meta http-equiv="REFRESH" content="0;url=http://twcradio.wizardschronicles.com"></HEAD>
<BODY>
Redirecting.
</BODY>
</HTML>
"}
client/verb/songinfo()
	set hidden = 1
	usr << browse(radiosonginfo,"window=1")
var/tmp/radioEnabled = 0
mob/GM/verb/Toggle_TWC_Radio()
	if(radioEnabled)
		radioEnabled = 0
		DJlog << "[time2text(world.realtime,"MMM DD - hh:mm:ss")]: [usr] ended TWC Radio<br />"
		world.disable_radio()
	else
		radioEnabled = 1
		DJlog << "[time2text(world.realtime,"MMM DD - hh:mm:ss")]: [usr] started TWC Radio<br />"
		world.enable_radio()
world/proc
	enable_radio()
		for(var/mob/Player/C in world)
			if(C.key)
				C << "<font color = white><b><h3>TWC Radio is broadcasting. Click <a href='?src=\ref[C];action=listen_radio'>HERE</a> to listen.</h3></b></font><br>"
				winset(C,"mnu_radio","is-disabled=false")
	disable_radio()
		for(var/mob/Player/C in world)
			if(C.key)
				winset(C,"mnu_radio","is-disabled=true")
				winset(C,"radio_enabled","is-checked=false")
				spawn()C.radio_end()


var/hHeader = {"
<html>
<head>
<title>Controller</title>
</head>
<style>
	body
	{
		margin:5px;
		padding:0px;
		font:11px verdana;
		color:white;
		background-color:black;
	}
	div.header
	{
		padding:10px;
		text-align:center;
		font: 14px verdana;
		font-weight: bold;
	}
	table
	{
		text-align:center;
		font:11px verdana;

	}
	td.dual
	{
		width:50%;
	}
</style>
"}

mob/test/verb/Teach_Spells()
	set category = "Teach"
	//set hidden = 1
	src << browse({"
[hHeader]
<body>
<div class="header">
	Teach Spells to all in view
</div>
<center>
<table cellpadding = "10">
	<tr>
		<td>[(/mob/GM/verb/Teach_Accio in verbs) ? "<a href='?src=\ref[src];action=teach_accio'>Accio</a>" : "Accio"]</td>
		<td>[(/mob/GM/verb/Teach_Aero in verbs) ? "<a href='?src=\ref[src];action=teach_aero'>Aero</a>" : "Aero"]</td>
		<td>[(/mob/GM/verb/Teach_Anapneo in verbs) ? "<a href='?src=\ref[src];action=teach_anapneo'>Anapneo</a>" : "Anapneo"]</td>
		<td></td>
		<td>[(/mob/GM/verb/Teach_Aqua_Eructo in verbs) ? "<a href='?src=\ref[src];action=teach_aquaeructo'>Aqua Eructo</a>" : "Aqua Eructo"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Arania_Eximae in verbs) ? "<a href='?src=\ref[src];action=teach_araniaexumai'>Arania Exumai</a>" : "Arania Exumai"]</td>
		<td></td>
		<td>[(/mob/GM/verb/Teach_Transfigure_Crow in verbs) ? "<a href='?src=\ref[src];action=teach_avifors'>Avifors</a>" : "Avifors"]</td>
		<td>[(/mob/GM/verb/Teach_Avis in verbs) ? "<a href='?src=\ref[src];action=teach_avis'>Avis</a>" : "Avis"]</td>
		<td>[(/mob/GM/verb/Teach_Bombarda in verbs) ? "<a href='?src=\ref[src];action=teach_bombarda'>Bombarda</a>" : "Bombarda"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Transfigure_Rabbit in verbs) ? "<a href='?src=\ref[src];action=teach_carrotosi'>Carrotosi</a>" : "Carrotosi"]</td>
		<td>[(/mob/GM/verb/Teach_Chaotica in verbs) ? "<a href='?src=\ref[src];action=teach_chaotica'>Chaotica</a>" : "Chaotica"]</td>
		<td>[(/mob/GM/verb/Teach_Confundus in verbs) ? "<a href='?src=\ref[src];action=teach_confundus'>Confundus</a>" : "Confundus"]</td>
		<td>[(/mob/GM/verb/Teach_Conjunctivis in verbs) ? "<a href='?src=\ref[src];action=teach_conjunctivis'>Conjunctivis</a>" : "Conjunctivis"]</td>
		<td>[(/mob/GM/verb/Teach_Crucio in verbs) ? "<a href='?src=\ref[src];action=teach_crucio'>Crucio</a>" : "Crucio"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Deletrius in verbs) ? "<a href='?src=\ref[src];action=teach_deletrius'>Deletrius</a>" : "Deletrius"]</td>
		<td>[(/mob/GM/verb/Teach_Transfigure_Turkey in verbs) ? "<a href='?src=\ref[src];action=teach_delicio'>Delicio</a>" : "Delicio"]</td>
		<td>[(/mob/GM/verb/Teach_Dementia in verbs) ? "<a href='?src=\ref[src];action=teach_dementia'>Dementia</a>" : "Dementia"]</td>
		<td>[(/mob/GM/verb/Teach_Densuago in verbs) ? "<a href='?src=\ref[src];action=teach_densuago'>Densuago</a>" : "Densuago"]</td>
		<td>[(/mob/GM/verb/Teach_Depulso in verbs) ? "<a href='?src=\ref[src];action=teach_depulso'>Depulso</a>" : "Depulso"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Disperse in verbs) ? "<a href='?src=\ref[src];action=teach_disperse'>Disperse</a>" : "Disperse"]</td>
		<td>[(/mob/GM/verb/Teach_Eat_Slugs in verbs) ? "<a href='?src=\ref[src];action=teach_eatslugs'>Eat Slugs</a>" : "Eat Slugs"]</td>
		<td></td>
		<td>[(/mob/GM/verb/Teach_Eparo_Evanesca in verbs) ? "<a href='?src=\ref[src];action=teach_eparoevanesca'>Eparo Evanesca</a>" : "Eparo Evanesca"]</td>
		<td>[(/mob/GM/verb/Teach_Episky in verbs) ? "<a href='?src=\ref[src];action=teach_episky'>Episkey</a>" : "Episkey"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Evanesco in verbs) ? "<a href='?src=\ref[src];action=teach_evanesco'>Evanesco</a>" : "Evanesco"]</td>
		<td>[(/mob/GM/verb/Teach_Expecto_Patronum in verbs) ? "<a href='?src=\ref[src];action=teach_expectpatronum'>Expecto Patronum</a>" : "Expecto Patronum"]</td>
		<td>[(/mob/GM/verb/Teach_Expelliarmus in verbs) ? "<a href='?src=\ref[src];action=teach_expelliarmus'>Expelliarmus</a>" : "Expelliarmus"]</td>
		<td>[(/mob/GM/verb/Teach_Transfigure_Cat in verbs) ? "<a href='?src=\ref[src];action=teach_felinious'>Felinious</a>" : "Felinious"]</td>
		<td>[(/mob/GM/verb/Teach_Ferula in verbs) ? "<a href='?src=\ref[src];action=teach_ferula'>Ferula</a>" : "Ferula"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Flagrate in verbs) ? "<a href='?src=\ref[src];action=teach_flagrate'>Flagrate</a>" : "Flagrate"]</td>
		<td>[(/mob/GM/verb/Teach_Flippendo in verbs) ? "<a href='?src=\ref[src];action=teach_flippendo'>Flippendo</a>" : "Flippendo"]</td>
		<td>[(/mob/GM/verb/Teach_Furnunculus in verbs) ? "<a href='?src=\ref[src];action=teach_furnunculus'>Furnunculus</a>" : "Furnunculus"]</td>
		<td>[(/mob/GM/verb/Teach_Glacius in verbs) ? "<a href='?src=\ref[src];action=teach_glacius'>Glacius</a>" : "Glacius"]</td>
		<td>[(/mob/GM/verb/Teach_Transfigure_Onion in verbs) ? "<a href='?src=\ref[src];action=teach_harvesto'>Harvesto</a>" : "Harvesto"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Herbificus in verbs) ? "<a href='?src=\ref[src];action=teach_herbificus'>Herbificus</a>" : "Herbificus"]</td>
		<td>[(/mob/GM/verb/Teach_Imitatus in verbs) ? "<a href='?src=\ref[src];action=teach_imitatus'>Imitatus</a>" : "Imitatus"]</td>
		<td>[(/mob/GM/verb/Teach_Immobulus in verbs) ? "<a href='?src=\ref[src];action=teach_immobulus'>Immobulus</a>" : "Immobulus"]</td>
		<td>[(/mob/GM/verb/Teach_Impedimenta in verbs) ? "<a href='?src=\ref[src];action=teach_impedimenta'>Impedimenta</a>" : "Impedimenta"]</td>
		<td>[(/mob/GM/verb/Teach_Incarcerous in verbs) ? "<a href='?src=\ref[src];action=teach_incarcerous'>Incarcerous</a>" : "Incarcerous"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Incendio in verbs) ? "<a href='?src=\ref[src];action=teach_incendio'>Incendio</a>" : "Incendio"]</td>
		<td>[(/mob/GM/verb/Teach_Incindia in verbs) ? "<a href='?src=\ref[src];action=teach_incindia'>Incindia</a>" : "Incindia"]</td>
		<td>[(/mob/GM/verb/Teach_Inflamari in verbs) ? "<a href='?src=\ref[src];action=teach_inflamari'>Inflamari</a>" : "Inflamari"]</td>
		<td>[(/mob/GM/verb/Teach_Langlock in verbs) ? "<a href='?src=\ref[src];action=teach_langlock'>Langlock</a>" : "Langlock"]</td>
		<td>[(/mob/GM/verb/Teach_Levicorpus in verbs) ? "<a href='?src=\ref[src];action=teach_levicorpus'>Levicorpus</a>" : "Levicorpus"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Melofors in verbs) ? "<a href='?src=\ref[src];action=teach_melofors'>Melofors</a>" : "Melofors"]</td>
		<td>[(/mob/GM/verb/Teach_Muffliato in verbs) ? "<a href='?src=\ref[src];action=teach_muffliato'>Muffliato</a>" : "Muffliato"]</td>
		<td>[(/mob/GM/verb/Teach_Transfigure_Bat in verbs) ? "<a href='?src=\ref[src];action=teach_nightus'>Nightus</a>" : "Nightus"]</td>
		<td>[(/mob/GM/verb/Teach_Obliviate in verbs) ? "<a href='?src=\ref[src];action=teach_obliviate'>Obliviate</a>" : "Obliviate"]</td>
		<td>[(/mob/GM/verb/Teach_Occlumency in verbs) ? "<a href='?src=\ref[src];action=teach_occlumency'>Occlumency</a>" : "Occlumency"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Transfigure_Human in verbs) ? "<a href='?src=\ref[src];action=teach_othertohuman'>Other to Human</a>" : "Other to Human"]</td>
		<td>[(/mob/GM/verb/Teach_Transfigure_Pixie in verbs) ? "<a href='?src=\ref[src];action=teach_peskipixiepesternomae'>Peskipixie Pesternomae</a>" : "Peskipixie Pesternomae"]</td>
		<td>[(/mob/GM/verb/Teach_Petreficus_Totalus in verbs) ? "<a href='?src=\ref[src];action=teach_petreficustotalus'>Petrificus Totalus</a>" : "Petrificus Totalus"]</td>
		<td>[(/mob/GM/verb/Teach_Portus in verbs) ? "<a href='?src=\ref[src];action=teach_portus'>Portus</a>" : "Portus"]</td>
		<td>[(/mob/GM/verb/Teach_Protego in verbs) ? "<a href='?src=\ref[src];action=teach_protego'>Protego</a>" : "Protego"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Reddikulus in verbs) ? "<a href='?src=\ref[src];action=teach_reddikulus'>Reddikulus</a>" : "Reddikulus"]</td>
		<td>[(/mob/GM/verb/Teach_Reducto in verbs) ? "<a href='?src=\ref[src];action=teach_reducto'>Reducto</a>" : "Reducto"]</td>
		<td>[(/mob/GM/verb/Teach_Reparo in verbs) ? "<a href='?src=\ref[src];action=teach_reparo'>Reparo</a>" : "Reparo"]</td>
		<td>[(/mob/GM/verb/Teach_Repellium in verbs) ? "<a href='?src=\ref[src];action=teach_repellium'>Repellium</a>" : "Repellium"]</td>
		<td>[(/mob/GM/verb/Teach_Replacio in verbs) ? "<a href='?src=\ref[src];action=teach_replacio'>Replacio</a>" : "Replacio"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Transfigure_Frog in verbs) ? "<a href='?src=\ref[src];action=teach_ribbitous'>Ribbitous</a>" : "Ribbitous"]</td>
		<td>[(/mob/GM/verb/Teach_Rictusempra in verbs) ? "<a href='?src=\ref[src];action=teach_rictusempra'>Rictusempra</a>" : "Rictusempra"]</td>
		<td>[(/mob/GM/verb/Teach_Scan in verbs) ? "<a href='?src=\ref[src];action=teach_scan'>Scan</a>" : "Scan"]</td>
		<td>[(/mob/GM/verb/Teach_Transfigure_Mouse in verbs) ? "<a href='?src=\ref[src];action=teach_scurries'>Scurries</a>" : "Scurries"]</td>
		<td>[(/mob/GM/verb/Teach_Transfigure_Chair in verbs) ? "<a href='?src=\ref[src];action=teach_seatio'>Seatio</a>" : "Seatio"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Transfigure_Dragon in verbs) ? "<a href='?src=\ref[src];action=teach_selftodragon'>Self to Dragon</a>" : "Self to Dragon"]</td>
		<td>[(/mob/GM/verb/Teach_Transfigure_Self_Human in verbs) ? "<a href='?src=\ref[src];action=teach_selftohuman'>Self to Human</a>" : "Self to Human"]</td>
		<td>[(/mob/GM/verb/Teach_Transfigure_Mushroom in verbs) ? "<a href='?src=\ref[src];action=teach_selftomushroom'>Self to Mushroom</a>" : "Self to Mushroom"]</td>
		<td>[(/mob/GM/verb/Teach_Transfigure_Skeleton in verbs) ? "<a href='?src=\ref[src];action=teach_selftoskeleton'>Self to Skeleton</a>" : "Self to Skeleton"]</td>
		<td>[(/mob/GM/verb/Teach_Sense in verbs) ? "<a href='?src=\ref[src];action=teach_sense'>Sense</a>" : "Sense"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Serpensortia in verbs) ? "<a href='?src=\ref[src];action=teach_serpensortia'>Serpensortia</a>" : "Serpensortia"]</td>
		<td>[(/mob/GM/verb/Teach_Solidus in verbs) ? "<a href='?src=\ref[src];action=teach_solidus'>Solidus</a>" : "Solidus"]</td>
		<td></td>
		<td>[(/mob/GM/verb/Teach_Tarantallegra in verbs) ? "<a href='?src=\ref[src];action=teach_tarantallegra'>Tarantallegra</a>" : "Tarantallegra"]</td>
		<td>[(/mob/GM/verb/Teach_Telendevour in verbs) ? "<a href='?src=\ref[src];action=teach_telendevour'>Telendevour</a>" : "Telendevour"]</td>
	</tr>
	<tr>
		<td></td>
		<td>[(/mob/GM/verb/Teach_Tremorio in verbs) ? "<a href='?src=\ref[src];action=teach_tremorio'>Tremorio</a>" : "Tremorio"]</td>
		<td>[(/mob/GM/verb/Teach_Waddiwasi in verbs) ? "<a href='?src=\ref[src];action=teach_waddiwasi'>Waddiwasi</a>" : "Waddiwasi"]</td>
		<td>[(/mob/GM/verb/Teach_Arcesso in verbs) ? "<a href='?src=\ref[src];action=teach_arcesso'>Arcesso</a>" : "Arcesso"]</td>
		<td>[(/mob/GM/verb/Teach_Permoveo in verbs) ? "<a href='?src=\ref[src];action=teach_permoveo'>Permoveo</a>" : "Permoveo"]</td>
	</tr>
	<tr>
		<td>[(/mob/GM/verb/Teach_Valorus in verbs) ? "<a href='?src=\ref[src];action=teach_valorus'>Valorus</a>" : "Valorus"]</td>
		<td>[(/mob/GM/verb/Teach_Wingardium in verbs) ? "<a href='?src=\ref[src];action=teach_wingardium'>Wingardium Levisoa</a>" : "Wingardium Leviosa"]</td>
	</tr>

</table>
</center>
</body>
</html>
"},"window=1;size=600x350")



mob/Topic(href,href_list[])
	..()
	switch(href_list["action"])
		if("delete_log_entry")
			if(usr.admin)
				var/confirm = alert("Are you sure you wish to remove the entry from the logfile?",,"Yes","No")
				if(confirm != "Yes")return
				var/sql = "DELETE FROM `tblWarnings` WHERE timestamp=[href_list["id"]]"
				var/DBQuery/qry = my_connection.NewQuery(sql)
				qry.Execute()
				manual_view_player_log(href_list["return2ckey"])
			else
				world.log << "HACKING ATTEMPT - DFgm354 - [usr]"
				for(var/client/C)
					if(C.mob.admin)
						C.mob << "HACKING ATTEMPT - DFgm354 - [usr]"
		if("class_path")
			if(classdest)
				if(href_list["latejoiner"] == "true")
					for(var/mob/Player/M in Players)
						if(M.Gm)
							M << infomsg("GMs, [usr] just logged in and clicked the class guidance system.")
				usr.classpathfinding = 1
				if(usr.loc.loc == classdest.loc.loc)
					usr << "You're already in class."
					client.images = list()
				else
					if(usr.Class_Path_to())
						usr << infomsg("Follow the blue markers to class.")
			else
				usr << "The class is no longer accepting new players."
				usr.classpathfinding = 0
		if("listen_radio")
			usr.client.linkenable_radio()
		if("teach_valorus")
			src:Teach_Valorus()
		if("teach_arcesso")
			src:Teach_Arcesso()
		if("teach_anapneo")
			src:Teach_Anapneo()
		if("teach_accio")
			src:Teach_Accio()
		if("teach_aero")
			src:Teach_Aero()
		if("teach_occlumency")
			src:Teach_Occlumency()
		if("teach_aquaeructo")
			src:Teach_Aqua_Eructo()
		if("teach_araniaexumai")
			src:Teach_Arania_Eximae()

		if("teach_avifors")
			src:Teach_Transfigure_Crow()
		if("teach_avis")
			src:Teach_Avis()
		if("teach_bombarda")
			src:Teach_Bombarda()
		if("teach_carrotosi")
			src:Teach_Transfigure_Rabbit()
		if("teach_chaotica")
			src:Teach_Chaotica()
		if("teach_conjunctivis")
			src:Teach_Conjunctivis()
		if("teach_crucio")
			src:Teach_Crucio()
		if("teach_deletrius")
			src:Teach_Deletrius()
		if("teach_delicio")
			src:Teach_Transfigure_Turkey()
		if("teach_dementia")
			src:Teach_Dementia()
		if("teach_densuago")
			src:Teach_Densuago()
		if("teach_depulso")
			src:Teach_Depulso()
		if("teach_disperse")
			src:Teach_Disperse()
		if("teach_eatslugs")
			src:Teach_Eat_Slugs()
		if("teach_eparoevanesca")
			src:Teach_Eparo_Evanesca()
		if("teach_episky")
			src:Teach_Episky()
		if("teach_evanesco")
			src:Teach_Evanesco()
		if("teach_expectpatronum")
			src:Teach_Expecto_Patronum()
		if("teach_expelliarmus")
			src:Teach_Expelliarmus()
		if("teach_felinious")
			src:Teach_Transfigure_Cat()
		if("teach_ferula")
			src:Teach_Ferula()
		if("teach_flagrate")
			src:Teach_Flagrate()
		if("teach_flippendo")
			src:Teach_Flippendo()
		if("teach_furnunculus")
			src:Teach_Furnunculus()
		if("teach_glacius")
			src:Teach_Glacius()
		if("teach_harvesto")
			src:Teach_Transfigure_Onion()
		if("teach_herbificus")
			src:Teach_Herbificus()
		if("teach_imitatus")
			src:Teach_Imitatus()
		if("teach_immobulus")
			src:Teach_Immobulus()
		if("teach_impedimenta")
			src:Teach_Impedimenta()
		if("teach_incarcerous")
			src:Teach_Incarcerous()
		if("teach_incendio")
			src:Teach_Incendio()
		if("teach_incindia")
			src:Teach_Incindia()
		if("teach_inflamari")
			src:Teach_Inflamari()
		if("teach_langlock")
			src:Teach_Langlock()
		if("teach_levicorpus")
			src:Teach_Levicorpus()
		if("teach_melofors")
			src:Teach_Melofors()
		if("teach_muffliato")
			src:Teach_Muffliato()
		if("teach_nightus")
			src:Teach_Transfigure_Bat()
		if("teach_obliviate")
			src:Teach_Obliviate()
		if("teach_othertohuman")
			src:Teach_Transfigure_Human()
		if("teach_peskipixiepesternomae")
			src:Teach_Transfigure_Pixie()
		if("teach_petreficustotalus")
			src:Teach_Petreficus_Totalus()
		if("teach_portus")
			src:Teach_Portus()
		if("teach_permoveo")
			src:Teach_Permoveo()
		if("teach_protego")
			src:Teach_Protego()
		if("teach_reddikulus")
			src:Teach_Reddikulus()
	//	if("teach_cugeo")
		//	src:Teach_Cugeo()
		if("teach_reducto")
			src:Teach_Reducto()
		if("teach_reparo")
			src:Teach_Reparo()
		if("teach_repellium")
			src:Teach_Repellium()
		if("teach_replacio")
			src:Teach_Replacio()
		if("teach_ribbitous")
			src:Teach_Transfigure_Frog()
		if("teach_rictusempra")
			src:Teach_Rictusempra()
		if("teach_scan")
			src:Teach_Scan()
		if("teach_scurries")
			src:Teach_Transfigure_Mouse()
		if("teach_seatio")
			src:Teach_Transfigure_Chair()
		if("teach_selftodragon")
			src:Teach_Transfigure_Dragon()
		if("teach_selftohuman")
			src:Teach_Transfigure_Self_Human()
		if("teach_selftomushroom")
			src:Teach_Transfigure_Mushroom()
		if("teach_selftoskeleton")
			src:Teach_Transfigure_Skeleton()
		if("teach_sense")
			src:Teach_Sense()
		if("teach_serpensortia")
			src:Teach_Serpensortia()
		if("teach_solidus")
			src:Teach_Solidus()
		if("teach_tarantallegra")
			src:Teach_Tarantallegra()
		if("teach_telendevour")
			src:Teach_Telendevour()
		if("teach_tremorio")
			src:Teach_Tremorio()
		if("teach_waddiwasi")
			src:Teach_Waddiwasi()
		if("teach_confundus")
			src:Teach_Confundus()
		if("teach_wingardium")
			src:Teach_Wingardium()