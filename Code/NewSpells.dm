/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
#define ERROR_MSG 1
#define CAST_MSG 2
proc/TextMsg(type,msg)
	var/starttags = ""
	var/endtags = ""
	switch(type)
		if(ERROR_MSG)
			starttags = "<font color=#840E99><b>"
			endtags = "</b></font>"
		if(CAST_MSG)
			starttags = "<font color=#A3CC49><b>"
			endtags = "</b></font>"
	return "[starttags][msg][endtags]"

var/currentsavefilversion = 1	//New characters are set to this

mob/You/proc/CheckSavefileVersion()
	if(savefileversion < 1)
		var/list/newformatspells = list(/mob/GM/verb/Carrotosi = /Spell/Trans/Other/Rabbit,
			/mob/GM/verb/Avifors = /Spell/Trans/Other/Crow,
			/mob/GM/verb/Delicio = /Spell/Trans/Other/Turkey,
			/mob/GM/verb/Felinious = /Spell/Trans/Other/BlackCat,
			/mob/GM/verb/Harvesto = /Spell/Trans/Other/Onion,
			/mob/GM/verb/Nightus = /Spell/Trans/Other/Bat,
			/mob/GM/verb/Other_To_Human = /Spell/Trans/Other/Human,
			/mob/GM/verb/Peskipixie_Pesternomae = /Spell/Trans/Other/Pixie,
			/mob/GM/verb/Ribbitous = /Spell/Trans/Other/Frog,
			/mob/GM/verb/Scurries = /Spell/Trans/Other/Mouse,
			/mob/GM/verb/Seatio = /Spell/Trans/Other/Chair,
			/mob/GM/verb/Self_To_Dragon = /Spell/Trans/Self/Dragon,
			/mob/GM/verb/Self_To_Human = /Spell/Trans/Self/Human,
			/mob/GM/verb/Self_To_Mushroom = /Spell/Trans/Self/Mushroom,
			/mob/GM/verb/Self_To_Skeleton = /Spell/Trans/Self/Skeleton)
		for(var/V in src.verbs)
			if(V in newformatspells)
				var/newspell = newformatspells[V]
				src.Spells.Add(new newspell())
				src.verbs -= V
		savefileversion = 1


mob/You/var/savefileversion = 0

mob/var/list/Spell/Spells = list()

SpellProj
	parent_type = /obj
	density = 1
	var
		Spell/fromspell
		pSpeed = 0
		pRange = 0
		mob/caster = null
	Bump(atom/obstacle)
		fromspell.Hits(obstacle,src.caster,src)
	proc
		Shoot()
			src.loc = src.caster.loc
			walk(src,src.caster.dir,src.pSpeed)
			sleep(src.pSpeed*src.pRange)//Max life of the projectile
			del(src)
	New(ploc)
		..()
		src.loc = ploc
Spell
	parent_type = /obj
	layer = 11	//HUD + 1
	icon = 'SpellbookIcons.dmi'	//The icon that shows up in the spellbook/actionbar
	var
		MPReq = 0
		pIcon = 'Projectiles.dmi'	//The icon that shows up when you fire the spell
		pIconState = ""
		pSpeed = 2
		pRange = 10
		Incantation = ""
		category = ""	//The category tab in the Spellbook eg. Transfiguration
	Click()
		Cast(usr)
	MouseDrop(HUDelement/actionbarbox/over_object)
		var/mob/You/Player/M = usr
		if(M.HUDLocked) return
		if(istype(over_object,/HUDelement/actionbarbox))
			world << "Set [over_object]'s overlays to list([src])"
			over_object.overlays = list(src)
			over_object.action = src
	proc
		Hits(atom/obstacle,mob/caster,SpellProj/Proj)
			if(obstacle == caster)
				world << "U hit urself"
				del(Proj)
			else if(istype(obstacle,/SpellProj))
				if(obstacle:caster == Proj.caster)
					world << "Hit ur own spell"
					del(Proj)
				else
					world << "display kewl effect as u hit someone else'z spell."
					del(obstacle)
					del(Proj)
			else
				world << "[obstacle] is hit by [caster]."
				del(Proj)
				return 1	//Continues the spell's Hits proc
		Cast(mob/caster)
			if(caster.MP < MPReq)
				usr << TextMsg(ERROR_MSG,"You require [src.MPReq] to cast [src.name].")
				return
			if(Incantation)
				hearers(8,usr) << TextMsg(CAST_MSG,"[caster]: <i>[Incantation].</i>")
		FireProjectile(mob/caster)
			var/SpellProj/Proj = new()
			Proj.fromspell = src
			Proj.icon = src.pIcon
			Proj.icon_state = src.pIconState
			Proj.pSpeed = src.pSpeed
			Proj.pRange = src.pRange
			Proj.caster = caster
			Proj.Shoot()
	Trans
		var
			tIcon
			tIconState
			isRevert = 0// If set, won't use ApplyTransfiguration()
		pIconState = "Transfiguration"
		category = "Trans"
		Self
			tIcon = 'Transfiguration.dmi'
			Dragon
				name = "Self to Dragon"
				icon_state = "Dragon"
				tIconState = "Dragon"
				Incantation = "Personio Draconum"
			Skeleton
				name = "Self to Skeleton"
				icon_state = "Skeleton"
				tIconState = "Skeleton"
				Incantation = "Personio Mortis"
			Mushroom
				name = "Self to Mushroom"
				icon_state = "Mushroom"
				Incantation = "Personio Musashi"
				New(mob/M)
					..()
					if(M)
						src.tIconState = "Mushroom-[M.House]"

			Human
				name = "Self to Human"
				icon_state = "Human"
				isRevert = 1
				Incantation = "Personio Regressus"
				Cast(mob/caster)
					..()
					caster.RevertTrans()


			Cast(mob/caster)
				..()
				//FireProjectile(caster)
				if(!isRevert)//If it's not a self to human, continue
					ApplyTransfiguration(caster,src.tIcon,tIconState)

		Other
			tIcon = 'Transfiguration.dmi'
			Pixie
				name = "Other to Pixie"
				icon_state = "Pixie"
				tIconState = "Pixie"
				Incantation = "Peskipixie Pesternomae"
			Rabbit
				name = "Other to Rabbit"
				icon_state = "Rabbit"
				tIconState = "Rabbit"
				Incantation = "Carrotosi"
			Frog
				name = "Other to Frog"
				icon_state = "Frog"
				tIconState = "Frog"
				Incantation = "Ribbitious"
			Turkey
				name = "Other to Turkey"
				icon_state = "Turkey"
				tIconState = "Turkey"
				Incantation = "Delicio"
			BlackCat
				name = "Other to Black Cat"
				icon_state = "BlackCat"
				tIconState = "BlackCat"
				Incantation = "Felinious"
			Mouse
				name = "Other to Mouse"
				icon_state = "Mouse"
				tIconState = "Mouse"
				Incantation = "Scurries"
			Chair
				name = "Other to Chair"
				icon_state = "Chair"
				tIconState = "Chair"
				Incantation = "Seatio"
			Onion
				name = "Other to Onion"
				icon_state = "Onion"
				tIconState = "Onion"
				Incantation = "Harvesto"
			Crow
				name = "Other to Crow"
				icon_state = "Crow"
				tIconState = "Crow"
				Incantation = "Avifors"
			Bat
				name = "Other to Bat"
				icon_state = "Bat"
				tIconState = "Bat"
				Incantation = "Nightus"
			Human
				name = "Other to Human"
				icon_state = "Human"
				Incantation = "Personio Regressus"

			Hits(atom/obstacle,mob/caster,SpellProj/Proj)
				if(..())	//If /Spell/proc/Hits was successful
					if(!isRevert)
						ApplyTransfiguration(obstacle,src.tIcon,tIconState)
					else
						//Other to Human
						if(ismob(obstacle))
							if(!obstacle:client)
								obstacle:RevertTrans()


			Cast(mob/caster)
				..()
				FireProjectile(caster)
				//ApplyTransfiguration(caster,src.tIcon,tIconState)

		proc
			ApplyTransfiguration(mob/target,pIcon,pIconState,t=0)
				//Applies a transfiguration to an atom with supplied icon/iconstate - t is time in seconds for the effect to last.
				if(!ismob(target))return
				if(!target.client)return
				target.RevertTrans()
				var/StatusEffect/Transfiguration/S = new(target,t)
				S.icon = pIcon
				S.icon_state = pIconState
				S.Activate()