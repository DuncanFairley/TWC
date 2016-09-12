/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/var/spellpoints = 0 //Earn 5, and you get to choose a spell
var/spellpointlog = file("Logs/spellpointlog.txt")
mob/Player/proc/learnspell(path)
	if(path in verbs)
		var/StatusEffect/S = findStatusEffect(/StatusEffect/GotSpellpoint)
		if(!S)
			new/StatusEffect/GotSpellpoint(src,60) //A silent marker to prevent people from gaining multiple spell points accidently.
			spellpoints++
			screenAlert("You earnt a spell point!")
			src << "<b>When you've gained at least 5, you can learn a spell with the Use Spellpoints button in Commands.</b>"
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
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Lumos))
					M.screenAlert("You learned a new spell: Lumos!")
			src << infomsg("You've taught your class the Lumos spell.")

		Teach_Langlock()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Langlock))
					M.screenAlert("You learned a new spell: Langlock!")
			src << infomsg("You've taught your class the Langlock spell.")

		Teach_Muffliato()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Muffliato))
					M.screenAlert("You learned a new spell: Muffliato!")
			src << infomsg("You've taught your class the Muffliato spell.")

		Teach_Flagrate()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Flagrate))
					M.screenAlert("You learned a new spell: Flagrate!")
			src << infomsg("You've taught your class the Flagrate spell.")

		Teach_Incindia()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Incindia))
					M.screenAlert("You learned a new spell: Incindia!")
			src << infomsg("You've taught your class the Incindia spell.")

		Teach_Replacio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Replacio))
					M.screenAlert("You learned a new spell: Replacio!")
			src << infomsg("You've taught your class the Replacio spell.")

		Teach_Obliviate()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Obliviate))
					M.screenAlert("You learned a new spell: Obliviate!")
			src << infomsg("You've taught your class the Obliviate spell.")

		Teach_Occlumency()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Occlumency))
					M.screenAlert("You learned a new spell: Occlumency!")
			src << infomsg("You've taught your class the Occlumency spell.")

		Teach_Antifigura()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Antifigura))
					M.screenAlert("You learned a new spell: Antifigura!")
			src << infomsg("You've taught your class the Antifigura spell.")

		Teach_Deletrius()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Deletrius))
					M.screenAlert("You learned a new spell: Deletrius!")
			src << infomsg("You've taught your class the Deletrius spell.")

		Teach_Eat_Slugs()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Eat_Slugs))
					M.screenAlert("You learned a new spell: Eat Slugs!")
			src << infomsg("You've taught your class the Eat Slugs spell.")

		Teach_Impedimenta()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Impedimenta))
					M.screenAlert("You learned a new spell: Impedimenta!")
			src << infomsg("You've taught your class the Impedimenta spell.")

		Teach_Tarantallegra()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Tarantallegra))
					M.screenAlert("You learned a new spell: Tarantallegra!")
			src << infomsg("You've taught your class the Tarantallegra spell.")

		Teach_Flippendo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Flippendo))
					M.screenAlert("You learned a new spell: Flippendo!")
			src << infomsg("You've taught your class the Flippendo spell.")

		Teach_Reducto()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Reducto))
					M.screenAlert("You learned a new spell: Reducto!")
			src << infomsg("You've taught your class the Reducto spell.")

		Teach_Anapneo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Anapneo))
					M.screenAlert("You learned a new spell: Anapneo!")
			src << infomsg("You've taught your class the Anapneo spell.")

		Teach_Arcesso()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Arcesso))
					M.screenAlert("You learned a new spell: Arcesso!")
			src << infomsg("You've taught your class the Arcesso spell.")

		Teach_Glacius()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Glacius))
					M.screenAlert("You learned a new spell: Glacius!")
			src << infomsg("You've taught your class the Glacius spell.")

		Teach_Reddikulus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Reddikulus))
					M.screenAlert("You learned a new spell: Riddikulus!")
			src << infomsg("You've taught your class the Riddikulus spell.")

		Teach_Sense()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Sense))
					M.screenAlert("You learned a new spell: Sense!")
			src << infomsg("You've taught your class the Sense spell.")

		Teach_Scan()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Scan))
					M.screenAlert("You learned a new spell: Scan!")
			src << infomsg("You've taught your class the Scan spell.")

		Teach_Expelliarmus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Expelliarmus))
					M.screenAlert("You learned a new spell: Expelliarmus!")
			src << infomsg("You've taught your class the Expelliarmus spell.")

		Teach_Reparo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Reparo))
					M.screenAlert("You learned a new spell: Reparo!")
			src << infomsg("You've taught your class the Reparo spell.")

		Teach_Wingardium()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Wingardium_Leviosa))
					M.screenAlert("You learned a new spell: Wingardium Leviosa!")
			src << infomsg("You've taught your class the Wingardium Leviosa spell.")

		Teach_Confundus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Confundus))
					M.screenAlert("You learned a new spell: Confundus!")
			src << infomsg("You've taught your class the Confundus spell.")

		Teach_Bombarda()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Bombarda))
					M.screenAlert("You learned a new spell: Bombarda!")
			src << infomsg("You've taught your class the Bombarda spell.")

		Teach_Chaotica()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Chaotica))
					M.screenAlert("You learned a new spell: Chaotica!")
			src << infomsg("You've taught your class the Chaotica spell.")

		Teach_Episky()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Episky))
					M.screenAlert("You learned a new spell: Episkey!")
			src << infomsg("You've taught your class the Episkey spell.")

		Teach_Protego()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Protego))
					M.screenAlert("You learned a new spell: Protego!")
			src << infomsg("You've taught your class the Protego spell.")

		Teach_Incendio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Incendio))
					M.screenAlert("You learned a new spell: Incendio!")
			src << infomsg("You've taught your class the Incendio spell.")

		Teach_Inflamari()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Inflamari))
					M.screenAlert("You learned a new spell: Inflamari!")
			src << infomsg("You've taught your class the Inflamari spell.")

		Teach_Serpensortia()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Serpensortia))
					M.screenAlert("You learned a new spell: Serpensortia!")
			src << infomsg("You've taught your class the Serpensortia spell.")

		Teach_Repellium()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Repellium))
					M.screenAlert("You learned a new spell: Repellium!")
			src << infomsg("You've taught your class the Repellium spell.")

		Teach_Tremorio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Tremorio))
					M.screenAlert("You learned a new spell: Tremorio!")
			src << infomsg("You've taught your class the Tremorio spell.")

		Teach_Aqua_Eructo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Aqua_Eructo))
					M.screenAlert("You learned a new spell: Aqua Eructo!")
			src << infomsg("You've taught your class the Aqua Eructo spell.")

		Teach_Imitatus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Imitatus))
					M.screenAlert("You learned a new spell: Imitatus!")
			src << infomsg("You've taught your class the Imitatus spell.")

		Teach_Depulso()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Depulso))
					M.screenAlert("You learned a new spell: Depulso!")
			src << infomsg("You've taught your class the Depulso spell.")

		Teach_Transfigure_Turkey()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Delicio"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Delicio))
					M.screenAlert("You learned a new spell: Delicio!")
			src << infomsg("You've taught your class the Delicio spell.")

		Teach_Transfigure_Crow()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Avifors"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Avifors))
					M.screenAlert("You learned a new spell: Avifors!")
			src << infomsg("You've taught your class the Avifors spell.")

		Teach_Transfigure_Mushroom()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Personio Mushashi"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Mushroom))
					M.screenAlert("You learned a new spell: Personio Mushashi!")
			src << infomsg("You've taught your class the Personio Mushashi spell.")

		Teach_Transfigure_Frog()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Ribbitous"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Ribbitous))
					M.screenAlert("You learned a new spell: Ribbitous!")
			src << infomsg("You've taught your class the Ribbitous spell.")

		Teach_Transfigure_Rabbit()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Carrotosi"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Carrotosi))
					M.screenAlert("You learned a new spell: Carrotosi!")
			src << infomsg("You've taught your class the Carrotosi spell.")

		Teach_Transfigure_Skeleton()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Personio Sceletus"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Skeleton))
					M.screenAlert("You learned a new spell: Personio Sceletus!")
			src << infomsg("You've taught your class the Personio Sceletus spell.")

		Teach_Transfigure_Dragon()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Personio Draconum"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Dragon))
					M.screenAlert("You learned a new spell: Personio Draconum!")
			src << infomsg("You've taught your class the Personio Draconum spell.")

		Teach_Transfigure_Human()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Transfiguro Revertio"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Other_To_Human))
					M.screenAlert("You learned a new spell: Transfiguro Revertio!")
			src << infomsg("You've taught your class the Transfiguro Revertio spell.")

		Teach_Transfigure_Onion()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Harvesto"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Harvesto))
					M.screenAlert("You learned a new spell: Harvesto!")
			src << infomsg("You've taught your class the Harvesto spell.")

		Teach_Transfigure_Cat()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Felinious"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Felinious))
					M.screenAlert("You learned a new spell: Felinious!")
			src << infomsg("You've taught your class the Felinious spell.")

		Teach_Transfigure_Mouse()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Scurries"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Scurries))
					M.screenAlert("You learned a new spell: Scurries!")
			src << infomsg("You've taught your class the Scurries spell.")

		Teach_Transfigure_Chair()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Seatio"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Seatio))
					M.screenAlert("You learned a new spell: Seatio!")
			src << infomsg("You've taught your class the Seatio spell.")

		Teach_Transfigure_Bat()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Nightus"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Nightus))
					M.screenAlert("You learned a new spell: Nightus!")
			src << infomsg("You've taught your class the Nightus spell.")

		Teach_Transfigure_Pixie()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Peskipixie Pestermi"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Peskipixie_Pesternomae))
					M.screenAlert("You learned a new spell: Peskipixie Pestermi!")
			src << infomsg("You've taught your class the Peskipixie Pestermi spell.")

		Teach_Petreficus_Totalus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Petreficus_Totalus))
					M.screenAlert("You learned a new spell: Petrificus Totalus!")
			src << infomsg("You've taught your class the Petrificus Totalus spell.")

		Teach_Telendevour()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Telendevour))
					M.screenAlert("You learned a new spell: Telendevour!")
			src << infomsg("You've taught your class the Telendevour spell.")

		Teach_Accio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Accio))
					M.screenAlert("You learned a new spell: Accio!")
			src << infomsg("You've taught your class the Accio spell.")

		Teach_Ferula()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Ferula))
					M.screenAlert("You learned a new spell: Ferula!")
			src << infomsg("You've taught your class the Ferula spell.")

		Teach_Avis()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Avis))
					M.screenAlert("You learned a new spell: Avis!")
			src << infomsg("You've taught your class the Avis spell.")

		Teach_Portus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Portus))
					M.screenAlert("You learned a new spell: Portus!")
			src << infomsg("You've taught your class the Portus spell.")

		Teach_Valorus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Valorus))
					M.screenAlert("You learned a new spell: Valorus!")
			src << infomsg("You've taught your class the Valorus spell.")

		Teach_Permoveo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Permoveo))
					M.screenAlert("You learned a new spell: Permoveo!")
			src << infomsg("You've taught your class the Permoveo spell.")

		Teach_Waddiwasi()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Waddiwasi))
					M.screenAlert("You learned a new spell: Waddiwasi!")
			src << infomsg("You've taught your class the Waddiwasi spell.")

		Teach_Transfigure_Self_Human()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Self to Human"
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Human))
					M.screenAlert("You learned a new spell: Personio Humaium!")
			src << infomsg("You've taught your class the Personio Humaium spell.")

		Teach_Incarcerous()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Incarcerous))
					M.screenAlert("You learned a new spell: Incarcerous!")
			src << infomsg("You've taught your class the Incarcerous spell.")

		Teach_Disperse()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Disperse))
					M.screenAlert("You learned a new spell: Disperse!")
			src << infomsg("You've taught your class the Disperse spell.")

		Teach_Herbificus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/Player/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Herbificus))
					M.screenAlert("You learned a new spell: Herbificus!")
			src << infomsg("You've taught your class the Herbificus spell.")