/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/var/spellpoints = 0 //Earn 5, and you get to choose a spell
var/spellpointlog = file("Logs/spellpointlog.txt")
mob/proc/learnspell(path)
	if(path in verbs)
		var/StatusEffect/S = findStatusEffect(/StatusEffect/GotSpellpoint)
		if(!S)
			new/StatusEffect/GotSpellpoint(src,60) //A silent marker to prevent people from gaining multiple spell points accidently.
			spellpoints++
			src << "<b>You earnt a spell point! When you've gained at least 5, you can learn a spell with the Use Spellpoints button in Commands.</b>"
			//src << "<i>As you've learned this spell previously, you've earnt a spellpoint instead. Each time you earn 5 spellpoints, you can learn a spell of your choice.</i>"
			spellpointlog << "[time2text(world.realtime,"MMM DD YYYY- hh:mm")]: [src] earnt a spell point."
		return 0
	else
		verbs += path
		return 1

mob/GM
	verb
		Teach_Lumos()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Lumos))
					M << infomsg("You learned Lumos!")
			src << infomsg("You've taught your class the Lumos spell.")

		Teach_Langlock()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Langlock))
					M << infomsg("You learned Langlock!")
			src << infomsg("You've taught your class the Langlock spell.")

		Teach_Muffliato()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Muffliato))
					M << infomsg("You learned Muffliato!")
			src << infomsg("You've taught your class the Muffliato spell.")

		Teach_Flagrate()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Flagrate))
					M << infomsg("You learned Flagrate!")
			src << infomsg("You've taught your class the Flagrate spell.")

		Teach_Incindia()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Incindia))
					M << infomsg("You learned Incindia!")
			src << infomsg("You've taught your class the Incindia spell.")

		Teach_Replacio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Replacio))
					M << infomsg("You learned Replacio!")
			src << infomsg("You've taught your class the Replacio spell.")

		Teach_Obliviate()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Obliviate))
					M << infomsg("You learned Obliviate!")
			src << infomsg("You've taught your class the Obliviate spell.")

		Teach_Occlumency()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Occlumency))
					M << infomsg("You learned Occlumency!")
			src << infomsg("You've taught your class the Occlumency spell.")

		Teach_Antifigura()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Antifigura))
					M << infomsg("You learned Antifigura!")
			src << infomsg("You've taught your class the Antifigura spell.")

		Teach_Deletrius()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Deletrius))
					M << infomsg("You learned Deletrius!")
			src << infomsg("You've taught your class the Deletrius spell.")

		Teach_Eat_Slugs()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Eat_Slugs))
					M << infomsg("You learned Eat Slugs!")
			src << infomsg("You've taught your class the Eat Slugs spell.")

		Teach_Impedimenta()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Impedimenta))
					M << infomsg("You learned Impedimenta!")
			src << infomsg("You've taught your class the Impedimenta spell.")

		Teach_Tarantallegra()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Tarantallegra))
					M << infomsg("You learned Tarantallegra!")
			src << infomsg("You've taught your class the Tarantallegra spell.")

		Teach_Flippendo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Flippendo))
					M << infomsg("You learned Flippendo!")
			src << infomsg("You've taught your class the Flippendo spell.")

		Teach_Reducto()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Reducto))
					M << infomsg("You learned Reducto!")
			src << infomsg("You've taught your class the Reducto spell.")

		Teach_Anapneo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Anapneo))
					M << infomsg("You learned Anapneo!")
			src << infomsg("You've taught your class the Anapneo spell.")

		Teach_Arcesso()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Arcesso))
					M << infomsg("You learned Arcesso!")
			src << infomsg("You've taught your class the Arcesso spell.")

		Teach_Glacius()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Glacius))
					M << infomsg("You learned Glacius!")
			src << infomsg("You've taught your class the Glacius spell.")

		/*Teach_Cugeo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Cugeo))
					M << infomsg("You learned Cugeo!")
			src << infomsg("You've taught your class the Cugeo spell.")*/

		Teach_Reddikulus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Reddikulus))
					M << infomsg("You learned Riddikulus!")
			src << infomsg("You've taught your class the Riddikulus spell.")

		Teach_Sense()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Sense))
					M << infomsg("You learned Sense!")
			src << infomsg("You've taught your class the Sense spell.")

		Teach_Scan()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Scan))
					M << infomsg("You learned Scan!")
			src << infomsg("You've taught your class the Scan spell.")

		Teach_Expelliarmus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Expelliarmus))
					M << infomsg("You learned Expelliarmus!")
			src << infomsg("You've taught your class the Expelliarmus spell.")

		Teach_Reparo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Reparo))
					M << infomsg("You learned Reparo!")
			src << infomsg("You've taught your class the Reparo spell.")

		Teach_Wingardium()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Wingardium_Leviosa))
					M << infomsg("You learned Wingardium Leviosa!")
			src << infomsg("You've taught your class the Wingardium Leviosa spell.")

		Teach_Confundus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Confundus))
					M << infomsg("You learned Confundus!")
			src << infomsg("You've taught your class the Confundus spell.")

		Teach_Bombarda()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Bombarda))
					M << infomsg("You learned Bombarda!")
			src << infomsg("You've taught your class the Bombarda spell.")

		Teach_Chaotica()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Chaotica))
					M << infomsg("You learned Chaotica!")
			src << infomsg("You've taught your class the Chaotica spell.")

		Teach_Episky()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Episky))
					M << infomsg("You learned Episkey!")
			src << infomsg("You've taught your class the Episkey spell.")

		Teach_Protego()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Protego))
					M << infomsg("You learned Protego!")
			src << infomsg("You've taught your class the Protego spell.")

		Teach_Incendio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Incendio))
					M << infomsg("You learned Incendio!")
			src << infomsg("You've taught your class the Incendio spell.")

		Teach_Inflamari()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Inflamari))
					M << infomsg("You learned Inflamari!")
			src << infomsg("You've taught your class the Inflamari spell.")

		Teach_Serpensortia()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Serpensortia))
					M << infomsg("You learned Serpensortia!")
			src << infomsg("You've taught your class the Serpensortia spell.")

		Teach_Repellium()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Repellium))
					M << infomsg("You learned Repellium!")
			src << infomsg("You've taught your class the Repellium spell.")

		Teach_Tremorio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Tremorio))
					M << infomsg("You learned Tremorio!")
			src << infomsg("You've taught your class the Tremorio spell.")

		Teach_Aqua_Eructo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Aqua_Eructo))
					M << infomsg("You learned Aqua Eructo!")
			src << infomsg("You've taught your class the Aqua Eructo spell.")

		Teach_Imitatus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Imitatus))
					M << infomsg("You learned Imitatus!")
			src << infomsg("You've taught your class the Imitatus spell.")

		Teach_Depulso()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Depulso))
					M << infomsg("You learned Depulso!")
			src << infomsg("You've taught your class the Depulso spell.")

		Teach_Eparo_Evanesca()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Eparo_Evanesca))
					M << infomsg("You learned Eparo Evanesca!")
			src << infomsg("You've taught your class the Eparo Evanesca spell.")

		Teach_Evanesco()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Evanesco))
					M << infomsg("You learned Evanesco!")
			src << infomsg("You've taught your class the Evanesco spell.")

		Teach_Transfigure_Turkey()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Delicio"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Delicio))
					M << infomsg("You learned Delicio!")
			src << infomsg("You've taught your class the Delicio spell.")

		Teach_Transfigure_Crow()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Avifors"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Avifors))
					M << infomsg("You learned Avifors!")
			src << infomsg("You've taught your class the Avifors spell.")

		Teach_Transfigure_Mushroom()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Personio Mushashi"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Mushroom))
					M << infomsg("You learned Personio Mushashi!")
			src << infomsg("You've taught your class the Personio Mushashi spell.")

		Teach_Transfigure_Frog()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Ribbitous"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Ribbitous))
					M << infomsg("You learned Ribbitous!")
			src << infomsg("You've taught your class the Ribbitous spell.")

		Teach_Transfigure_Rabbit()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Carrotosi"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Carrotosi))
					M << infomsg("You learned Carrotosi!")
			src << infomsg("You've taught your class the Carrotosi spell.")

		Teach_Transfigure_Skeleton()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Personio Sceletus"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Skeleton))
					M << infomsg("You learned Personio Sceletus!")
			src << infomsg("You've taught your class the Personio Sceletus spell.")

		Teach_Transfigure_Dragon()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Personio Draconum"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Dragon))
					M << infomsg("You learned Personio Draconum!")
			src << infomsg("You've taught your class the Personio Draconum spell.")

		Teach_Transfigure_Human()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Transfiguro Revertio"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Other_To_Human))
					M << infomsg("You learned Transfiguro Revertio!")
			src << infomsg("You've taught your class the Transfiguro Revertio spell.")

		Teach_Transfigure_Onion()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Harvesto"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Harvesto))
					M << infomsg("You learned Harvesto!")
			src << infomsg("You've taught your class the Harvesto spell.")

		Teach_Transfigure_Cat()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Felinious"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Felinious))
					M << infomsg("You learned Felinious!")
			src << infomsg("You've taught your class the Felinious spell.")

		Teach_Transfigure_Mouse()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Scurries"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Scurries))
					M << infomsg("You learned Scurries!")
			src << infomsg("You've taught your class the Scurries spell.")

		Teach_Transfigure_Chair()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Seatio"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Seatio))
					M << infomsg("You learned Seatio!")
			src << infomsg("You've taught your class the Seatio spell.")

		Teach_Transfigure_Bat()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Nightus"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Nightus))
					M << infomsg("You learned Nightus!")
			src << infomsg("You've taught your class the Nightus spell.")

		Teach_Transfigure_Pixie()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Peskipixie Pestermi"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Peskipixie_Pesternomae))
					M << infomsg("You learned Peskipixie Pestermi!")
			src << infomsg("You've taught your class the Peskipixie Pestermi spell.")

		Teach_Petreficus_Totalus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Petreficus_Totalus))
					M << infomsg("You learned Petrificus Totalus!")
			src << infomsg("You've taught your class the Petrificus Totalus spell.")

		Teach_Telendevour()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Telendevour))
					M << infomsg("You learned Telendevour!")
			src << infomsg("You've taught your class the Telendevour spell.")

		Teach_Accio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Accio))
					M << infomsg("You learned Accio!")
			src << infomsg("You've taught your class the Accio spell.")

		Teach_Ferula()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Ferula))
					M << infomsg("You learned Ferula!")
			src << infomsg("You've taught your class the Ferula spell.")

		Teach_Avis()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Avis))
					M << infomsg("You learned Avis!")
			src << infomsg("You've taught your class the Avis spell.")

		Teach_Portus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Portus))
					M << infomsg("You learned Portus!")
			src << infomsg("You've taught your class the Portus spell.")

		Teach_Valorus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Valorus))
					M << infomsg("You learned Valorus!")
			src << infomsg("You've taught your class the Valorus spell.")

		Teach_Permoveo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Permoveo))
					M << infomsg("You learned Permoveo!")
			src << infomsg("You've taught your class the Permoveo spell.")

		Teach_Waddiwasi()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Waddiwasi))
					M << infomsg("You learned Waddiwasi!")
			src << infomsg("You've taught your class the Waddiwasi spell.")

		Teach_Transfigure_Self_Human()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Self to Human"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Human))
					M << infomsg("You learned Personio Humaium!")
			src << infomsg("You've taught your class the Personio Humaium spell.")

		Teach_Incarcerous()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Incarcerous))
					M << infomsg("You learned Incarcerous!")
			src << infomsg("You've taught your class the Incarcerous spell.")

		Teach_Disperse()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Disperse))
					M << infomsg("You learned Disperse!")
			src << infomsg("You've taught your class the Disperse spell.")

		Teach_Herbificus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Herbificus))
					M << infomsg("You learned Herbificus!")
			src << infomsg("You've taught your class the Herbificus spell.")