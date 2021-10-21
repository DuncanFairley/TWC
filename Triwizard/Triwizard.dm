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

turf
	Sea_Floor
		icon = 'Underwater.dmi'
		icon_state = "Sand Floor"
