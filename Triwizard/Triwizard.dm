/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

area
	Underwater
		icon = 'Water.dmi'
		icon_state = "water"
		layer = 13
		alpha = 150

mob/var/tmp/unslow = 0
mob/proc/unslow()
	set waitfor = 0
	unslow=1
	sleep(1200)
	usr << "<b>The effects wear off.</b>"
	unslow=0

obj/items/Underwater_Bean
	icon = 'Bean.dmi'
	icon_state = "Bean"
	name = "Mysterious Bean"
	desc = "It's a little wet."

	Click()
		if(src in usr)
			if(canUse(usr,cooldown=null,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstflying=0,againstcloaked=0))
				var/mob/Player/p = usr
				if(usr.unslow) return
				p << "<b>You swallow the bean.</b>"
				flick("transfigure",p)
				p.trnsed = 1
				p.overlays = null
				if(p.Gender == "Female")
					p.icon = 'FemaleFish.dmi'
				else
					p.icon = 'MaleFish.dmi'
				p.unslow()
				if(p.away) p.ApplyAFKOverlay()
				Consume()
		else
			..()

obj
	TriwizardCup
		icon = 'Goblet.dmi'
		name = "Triwizard Cup"
		icon_state = "blue-idle"
		//This will have the same icon as the goblet of fire, but will teleport the first person who touches it to
		//the great hall, announce the winner, then delete itself.
		Click()
			if(usr in oview(1))
				usr << "You reach up and touch the Triwizard Cup."
				usr.loc = locate(38,37,21)
				Players << "<h2>Congratulations to <b>[usr]</b> who has reached the Triwizard Cup first! Assemble in the Great Hall for the 2011 Triwizard Tournament Closing Ceremony</h2>"
				del(src)

turf
	Sea_Floor
		icon = 'Underwater.dmi'
		icon_state = "Sand Floor"
		slow = 2
