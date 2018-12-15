/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

mob/GM/verb/Grant_All_Spells(mob/M in Players)
			set category="Staff"
			set popup_menu = 0

			M.verbs += typesof(/mob/Spells/verb)

			M.verbs -= list(/mob/Spells/verb/Conjunctivis,
							/mob/Spells/verb/Expecto_Patronum,
							/mob/Spells/verb/Rictusempra,
							/mob/Spells/verb/Dementia,
							/mob/Spells/verb/Crucio,
							/mob/Spells/verb/Melofors,
							/mob/Spells/verb/Levicorpus,
							/mob/Spells/verb/Densuago,
							/mob/Spells/verb/Solidus,
							/mob/Spells/verb/Arania_Eximae,
							/mob/Spells/verb/Furnunculus,
							/mob/Spells/verb/Evanesco,
							/mob/Spells/verb/Eparo_Evanesca,
							/mob/Spells/verb/Gravitate)

			M<<"[usr] has given you <u>All</u> spells."


atom/proc/FlickState(iconState, time, file)
	set waitfor = 0
	var/oldState = icon_state
	var/oldIcon
	icon_state = iconState

	if(file)
		oldIcon = icon
		icon = file

	sleep(time)
	if(icon_state == iconState)
		icon_state = oldState
	if(oldIcon && icon == file)
		icon = oldIcon