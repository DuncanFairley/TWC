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
			spellpointlog << "[time2text(world.realtime,"MMM DD - hh:mm")]: [src] earnt a spell point."
		return 0
	else
		verbs += path
		return 1

mob/GM
	verb
		Teach_Furnunculus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Furnunculus))
				//if(M.learnspell(/mob/Mage/verb/Furnunculus
					M<<"<b><font color=green><font size=1>You learned Furnunculus!"
			src<<"You've taught your class the Furnunculus spell."

mob/GM
	verb
		Teach_Langlock()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Langlock))
					M<<"<b><font color=green><font size=1>You learned Langlock!"
			src<<"You've taught your class the Langlock spell."

mob/GM
	verb
		Teach_Muffliato()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Muffliato))
					M<<"<b><font color=aqua><font size=1>You learned Muffliato!"
			src<<"You've taught your class the Muffliato charm."

mob/GM
	verb
		Teach_Flagrate()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Flagrate))
					M<<"<b><font color=green><font size=1>You learned Flagrate!"
			src<<"You've taught your class the Flagrate spell."


mob/GM
	verb
		Teach_Incindia()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Incindia))
					M<<"<b><font color=green><font size=1>You learned Incindia!"
			src<<"You've taught your class the Incindia spell."
mob/GM
	verb
		Teach_Replacio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Replacio))
					M<<"<b><font color=green><font size=1>You learned Replacio!"
			src<<"You've taught your class the Replacio spell."


mob/GM
	verb
		Teach_Levicorpus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Levicorpus))
					M<<"<b><font color=green><font size=1>You learned Levicorpus!"
			src<<"You've taught your class the Levicorpus spell."

mob/GM
	verb
		Teach_Obliviate()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Obliviate))
					M<<"<b><font color=green><font size=1>You learned Obliviate!"
			src<<"You've taught your class the Obliviate spell."

		Teach_Occlumency()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Occlumency))
					M<<"<b><font color=green><font size=1>You learned Occlumency!"
			src<<"You've taught your class the Occlumency spell."

		Teach_Antifigura()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Antifigura))
					M<<"<b><font color=green><font size=1>You learned Antifigura!"
			src<<"You've taught your class the Antifigura spell."

mob/var/learnedslug

mob/GM
	verb
		Teach_Deletrius()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Deletrius))
					M<<"<b><font color=green><font size=1>You learned Deletrius!"
			src<<"You've taught your class the Deletrius spell."


mob/GM
	verb
		Teach_Eat_Slugs()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Eat_Slugs))
					M<<"<b><font color=green><font size=3>You learned the Slug Vomitting Curse!"
			usr<<"You've taught your class the Eat Slugs."

mob/GM
	verb
		Teach_Immobulus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Immobulus))
					M<<"<b><font color=green><font size=1>You learned Immobulus!"
			src<<"You've taught your class the Immobulus spell."

mob/GM
	verb
		Teach_Impedimenta()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Impedimenta))
					M<<"<b><font color=green><font size=1>You learned Impedimenta!"
			src<<"You've taught your class the Impedimenta spell."
mob/GM
	verb
		Teach_Tarantallegra()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Tarantallegra))
					M<<"<b><font color=green><font size=1>You learned Tarantallegra."
			src<<"You've taught your class the Tarantallegra spell."


mob/GM
	verb
		Teach_Flippendo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Flippendo))
					M<<"<b><font color=green><font size=3>You learned Flippendo!"
			src<<"You've taught your class the Flippendo spell."

mob/GM
	verb
		Teach_Reducto()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Reducto))
					M<<"<b><font color=green><font size=3>You learned Reducto!"
			src<<"You've taught your class the Reducto spell."

mob/GM
	verb
		Teach_Anapneo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Anapneo))
					M<<"<b><font color=blue><font size=3>You learned Anapneo!"
			src<<"You've taught your class the Anapneo Charm."
mob/GM
	verb
		Teach_Arcesso()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Arcesso))
					M<<"<b><font color=blue><font size=3>You learned Arcesso!"
			src<<"You've taught your class the Arcesso Summoning Charm."
mob/GM
	verb
		Teach_Crucio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Crucio))
					M<<"<b><font color=green><font size=3>You learned Crucio!"
			src<<"You've taught your class the Crucio spell."

mob/GM
	verb
		Take_Crucio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				M.verbs -= /mob/Spells/verb/Crucio
			src<<"You've taken your class the Crucio spell."
mob/GM
	verb
		Teach_Arania_Eximae()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Arania Exumai"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Arania_Eximae))
					M<<"<b><font color=green><font size=3>You learned Arania Exumai."
			src<<"You've taught your class the Arania Exumai spell."
mob/GM
	verb
		Teach_Glacius()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Glacius))
					M<<"<b><font color=blue><font size=3>You learned Glacius."
			src<<"You've taught your class the Glacius spell."
		/*Teach_Cugeo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Cugeo))
					M<<"<b><font color=red><font size=3>You learned Cugeo."
			src<<"You've taught your class the cugeo spell."*/
		Teach_Reddikulus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Reddikulus))
					M<<"<b><font color=red><font size=3>You learned Reddikulus."
			src<<"You've taught your class the Reddikulus spell."

		Teach_Rictusempra()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Rictusempra))
					M<<"<b><font color=yellow><font size=3>You learned Rictusempra."
			src<<"You've taught your class the Rictusempra spell."
		Teach_Sense()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Sense))
					M<<"<b><font color=aqua><font size=3>You learned the skill Sense."
			src<<"You've taught your class the Sense skill."

		Take_Sense()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				M.verbs -= /mob/Spells/verb/Sense
			src<<"You've taken from your class the Sense skill."

		Teach_Scan()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Scan))
					M<<"<b><font color=aqua><font size=3>You learned the skill Scan."
			src<<"You've taught your class the Scan skill."

		Take_Scan()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				M.verbs -= /mob/Spells/verb/Scan
			src<<"You've taken from your class the Scan skill."

mob/GM
	verb
		Teach_Expelliarmus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Expelliarmus))
					M<<"<b><font color=green><font size=3>You learned Expelliarmus."
			src<<"You've taught your class the Expelliarmus spell."

mob/GM
	verb
		Teach_Melofors()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Melofors))
					M<<"<b><font color=red><font size=3>You learned Melofors."
			src<<"You've taught your class the Melofors charm."

mob/GM
	verb
		Teach_Reparo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Reparo))
					M<<"<b><font color=white><font size=3>You learned Reparo."
			src<<"You've taught your class the Reparo charm."
mob/GM
	verb
		Teach_Wingardium()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Wingardium_Leviosa))
					M<<"<b><font color=white><font size=3>You learned Wingardium Leviosa."
			src<<"You've taught your class Wingardium Leviosa."
mob/GM
	verb
		Teach_Confundus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Confundus))
					M<<"<b><font color=white><font size=3>You learned Confundus."
			src<<"You've taught your class the Confundus charm."

mob/GM
	verb
		Teach_Bombarda()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Bombarda))
					M<<"<b><font color=red><font size=3>You learned Bombarda."
			src<<"You've taught your class the Bombarda spell."
mob/GM
	verb
		Teach_Chaotica()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Chaotica))
					M<<"<b><font color=green><font size=3>You learned Chaotica."
			src<<"You've taught your class the Chaotica spell."


mob/GM
	verb
		Teach_Episky()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Episky))
					M<<"<b><font color=green><font size=3>You learned Episkey."
			src<<"You've taught your class the Episkey spell."

mob/GM
	verb
		Teach_Protego()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Protego))
					M<<"<b><font color=green><font size=3>You learned Protego!"
			src<<"You've taught your class the Protego charm."

		Teach_Incendio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Incendio))
					M<<"<b><font color=green><font size=3>You learned Incendio!"
			src<<"You've taught your class incendio."

mob/GM
	verb
		Teach_Inflamari()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Inflamari))
					M<<"<b><font color=green><font size=3>You learned Inflamari!!"
			src<<"You've taught your class the Inflamari spell."
mob/GM
	verb
		Teach_Serpensortia()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Serpensortia))
					M<<"<b><font color=green><font size=3>You learned Serpensortia!"
			src<<"You've taught your class the Serpensortia spell."

mob/GM
	verb
		Take_Serpensortia()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				M.verbs -= /mob/Spells/verb/Serpensortia
			src<<"You've taken your class the Serpensortia spell."
mob/GM
	verb
		Teach_Repellium()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Repellium))
					M<<"<b><font color=green><font size=3>You learned Repellium!"
			src<<"You've taught your class the Repellium Charm."
mob/GM
	verb
		Teach_Tremorio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Tremorio))
					M<<"<b><font color=green><font size=3>You learned Tremorio!"
			src<<"You've taught your class the Tremorio spell."
mob/GM
	verb
		Teach_Aqua_Eructo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Aqua_Eructo))
					M<<"<b><font color=green><font size=3>You learned Aqua Eructo."
			src<<"You've taught your class the Aqua Eructo spell."
mob/GM
	verb
		Teach_Imitatus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Imitatus))
					M<<"<b><font color=green><font size=3>You learned Imitatus!"
			src<<"You've taught your class the Imitatus charm."
mob/GM
	verb
		Teach_Depulso()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Depulso))
					M<<"<b><font color=green><font size=3>You learned Depulso!"
			src<<"You've taught your class the Depulso charm."

mob/GM
	verb
		Teach_Eparo_Evanesca()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Eparo_Evanesca))
					M<<"<b><font color=green><font size=3>You learned Eparo Evanesca!"
			src<<"You've taught your class the Eparo Evanesca Charm."

mob/GM
	verb
		Teach_Evanesco()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Evanesco))
					M<<"<b><font color=green><font size=3>You learned Evanesco!"
			src<<"You've taught your class the Evanesco Charm."
mob/GM
	verb
		Teach_Transfigure_Turkey()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Delicio"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Delicio))
					M<<"<b><font color=green><font size=3>You learned Transfigure Turkey! (Delicio)"
			src<<"You've taught your class the Transfigure Turkey."

		Teach_Transfigure_Crow()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Avifors"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Avifors))
					M<<"<b><font color=green><font size=3>You learned Transfigure Crow! (Avifors)"
			src<<"You've taught your class the Transfigure Crow."
mob/GM
	verb
		Teach_Transfigure_Mushroom()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Self to Mushroom"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Mushroom))
					M<<"<b><font color=green><font size=3>You learned to Transfigure yourself to a Mushroom!"
			src<<"You've taught your class the Transfigure Mushroom."
mob/GM
	verb
		Teach_Transfigure_Frog()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Ribbitous"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Ribbitous))
					M<<"<b><font color=green><font size=3>You learned Transfigure Frog! (Ribbitous)"
			src<<"You've taught your class the Transfigure Frog Charm."

mob/GM
	verb
		Teach_Transfigure_Rabbit()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Carrotosi"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Carrotosi))
					M<<"<b><font color=red><font size=3>You learned Transfigure Rabbit! (Carrotosi)"
			src<<"You've taught your class the Transfigure Rabbit Charm."
mob/GM
	verb
		Teach_Transfigure_Skeleton()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Self to Skeleton"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Skeleton))
					M<<"<b><font color=green><font size=3>You learned how to Transfigure yourself into a Skeletal Warrior!"
			src<<"You've taught your class Self to Skeleton."
mob/GM
	verb
		Teach_Transfigure_Dragon()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Self to Dragon"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Dragon))
					M<<"<b><font color=green><font size=3>You learned how to Transfigure yourself into a fearsome Dragon!"
			src<<"You've taught your class Self to Dragon."
mob/GM
	verb
		Teach_Transfigure_Human()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Other to Human"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Other_To_Human))
					M<<"<b><font color=green><font size=3>You learned Transfigure Human!"
			src<<"You've taught your class the Transfigure Human."
mob/GM
	verb
		Teach_Transfigure_Onion()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Harvesto"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Harvesto))
					M<<"<b><font color=green><font size=3>You learned Transfigure Onion! (Onion)"
			src<<"You've taught your class the Transfigure Onion."

mob/GM
	verb
		Teach_Transfigure_Cat()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Felinious"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Felinious))
					M<<"<b><font color=green><font size=3>You learned Transfigure Cat! (Felinious)"
			src<<"You've taught your class the Transfigure Cat."
mob/GM
	verb
		Teach_Transfigure_Mouse()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Scurries"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Scurries))
					M<<"<b><font color=green><font size=3>You learned Transfigure Mouse! (Scurries)"
			src<<"You've taught your class the Transfigure Mouse."
mob/GM
	verb
		Teach_Transfigure_Chair()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Seatio"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Seatio))
					M<<"<b><font color=green><font size=3>You learned Transfigure Chair! (Seatio)"
			src<<"You've taught your class the Transfigure Chair"
mob/GM
	verb
		Teach_Transfigure_Bat()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Nightus"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Nightus))
					M<<"<b><font color=green><font size=3>You learned Transfigure Bat! (Nightus)"
			src<<"You've taught your class the Transfigure Bat."
mob/GM
	verb
		Teach_Transfigure_Pixie()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Peskipixie Pesternomae"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Peskipixie_Pesternomae))
					M<<"<b><font color=green><font size=3>You learned Transfigure Pixie! (Peskipixie_Pesternomae)"
			src<<"You've taught your class the Transfigure Pixie."
mob/GM
	verb
		Teach_Petreficus_Totalus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Petreficus_Totalus))
					M<<"<b><font color=green><font size=3>You learned Petrificus Totalus!"
			src<<"You've taught your class the Petrificus Totalus curse.."
mob/GM
	verb
		Teach_Telendevour()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Telendevour))
					M<<"<b><font color=green><font size=3>You learned the Telendevour Charm!"
			src<<"You've taught your class the Telendevour Charm.."
mob/GM
	verb
		Teach_Accio()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Accio))
					M<<"<b><font color=green><font size=3>You learned how to summon items with Accio!"
			src<<"You've taught your class the Accio Charm."

mob/GM
	verb
		Teach_Densuago()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Densuago))
					M<<"<b><font color=white><b>You learned how to make someones teeth grow for 5 minutes!"
			src<<"You taught your class the Densaugeo jinx."

mob/GM
	verb
		Teach_Ferula()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Ferula))
					M<<"<b><font color=white><b>You learned how to summon the nurse to heal others"
			src<<"You taught your class the Ferula Charm."


mob/GM
	verb
		Teach_Expecto_Patronum()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Expecto_Patronum))
					M<<"<b><font color=white><b>You learned how to repel Dementors!"
			src<<"You taught your class Expecto Patronum."

mob/GM
	verb
		Teach_Dementia()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Dementia))
					M<<"<b><font color=white><b>You learned how to summon Dementors!"
			src<<"You taught your class the Dementia Curse."

		Teach_Avis()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Avis))
					M<<"<b><font color=white><b>You learned the spell, Avis!"
			src<<"You taught your class the Avis Charm."

mob/GM
	verb
		Take_Dementia()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				M.verbs -= /mob/Spells/verb/Dementia
			src<<"You took the Dementia Curse from everyone in the area.."
mob/GM
	verb
		Teach_Portus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Portus))
					M<<"<b><font color=white><b>You learned Portus!"
			src<<"You taught your class the Portus Charm!"
		Teach_Valorus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Valorus))
					M<<"<b><font color=white><b>You learned Valorus!"
			src<<"You taught your class Valorus."
		Teach_Permoveo()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Permoveo))
					M<<"<b><font color=white><b>You learned Permoveo!"
			src<<"You taught your class Permoveo!"
mob/GM
	verb
		Teach_Conjunctivis()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Conjunctivis))
					M<<"<b><font color=white><b>You learned Conjunctivis!"
			src<<"You taught your class the Conjunctivis Hex!"

mob/GM
	verb
		Teach_Waddiwasi()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Waddiwasi))
					M<<"<b><font color=white><b>You learned Waddiwasi!"
			src<<"You taught your class the Waddiwasi spell!"


mob/GM
	verb
		Teach_Transfigure_Self_Human()
			set category = "Teach"
			set hidden = 1
			set name = "Teach Self to Human"
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Self_To_Human))
					M<<"<b><font color=white><b>You learned how to transform yourself back into a Human!"
			src<<"You taught your class how to transform back into a Human."



mob/GM
	verb
		Teach_Incarcerous()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Incarcerous))
					M<<"<b><font size=3><font color=aqua>You learned the Incarcerous Charm."
			src << "You've taught your class the Incarcerous spell"

mob/GM
	verb
		Teach_Aero()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				M.Aero=1
				M<<"<b><p align=center>.: You learned Aero :."
			src<<"You've taught your class the Aero spell."

mob/GM
	verb
		Teach_Disperse()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Disperse))
					M<<"<b><p align=center>.: You learned Disperse :."
			src<<"You've taught your class the Disperse spell."

mob/GM
	verb
		Teach_Herbificus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Herbificus))
					M<<"<b><p align=center>.: You learned Herbificus :."
			src<<"You've taught your class the Herbificus spell."

mob/GM
	verb
		Teach_Solidus()
			set category = "Teach"
			set hidden = 1
			for(var/mob/M in oview(client.view))
				if(M.learnspell(/mob/Spells/verb/Solidus))
					M<<"<b><p align=center>.: You learned Solidus :."
			src<<"You've taught your class the Solidus spell."