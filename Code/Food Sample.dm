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
			M<<"[usr] has given you <u>All</u> spells."

