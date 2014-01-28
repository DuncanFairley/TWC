/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
mob/You/Player
	verb
		Spellbook()
			//set name = ".Spellbook"
			//src.client.screen.Remove(src.Spells)
			//src.client.screen.Add(src.Spells)
			if(winget(src,"winSpellbook","is-visible") == "true")
				CloseSpellbook()
			else
				OpenSpellbook()

		CloseSpellbook()
			set name = ".closeSpellbook"
			winshow(src,"winSpellbook",0)
			lockHUD()
		OpenSpellbook()
			set name= ".openSpellbook"
			updateSpellbook()
			winshow(src,"winSpellbook",1)
			unlockHUD()
	proc
		updateSpellbook()
			var/i=0
			for(var/Spell/S in src.Spells)
				winset(src,"gridSpellbook_All","current-cell=1,[++i]")
				src << output(S,"gridSpellbook_All")

				winset(src,"gridSpellbook_[S.category]","current-cell=1,[i]")
				src << output(S,"gridSpellbook_[S.category]")