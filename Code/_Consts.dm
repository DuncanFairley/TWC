/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */


// make enchanting tougher via soul crystals
// add a note for webclient multikey
// matchmaking re-use system to reduce lag
// priortize active quests
// github issues

var/const
	SWAPMAP_Z = 27
	lvlcap = 650

var/possible_macros

proc/init_possible_macros()
	if(!possible_macros)
		var
			const
				ARROWS = "|west|east|north|south|"
				NUMPAD = "|west|east|north|south|northeast|southeast|northwest|southwest|center|numpad0|numpad1|numpad2|numpad3|numpad4|numpad5|numpad6|numpad7|numpad8|numpad9|divide|multiply|subtract|add|decimal|"
				EXTENDED = "|space|shift|ctrl|alt|escape|return|tab|back|delete|insert|"
				PUNCTUATION = "|`|-|=|\[|]|;|'|,|.|/|\\|"
				FUNCTION = "|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|"
				LETTERS = "|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|"
				NUMBERS = "|0|1|2|3|4|5|6|7|8|9|"

				ALL_KEYS = NUMPAD + EXTENDED + FUNCTION + LETTERS + NUMBERS + PUNCTUATION

		var/list/keys = split(ALL_KEYS, "|")

		for(var/k in keys)
			if(!k) continue

			for(var/mod in list("", "+up", "+rep"))

				var/key = k + mod

				possible_macros += "[key];"

				if(key != "alt")
					possible_macros += "alt+[key];"

				if(key != "alt" && key != "ctrl")
					possible_macros += "alt+ctrl+[key];"

				if(key != "alt" && key != "shift")
					possible_macros += "alt+shift+[key];"

				if(key != "alt" && key != "ctrl" && key != "shift")
					possible_macros += "alt+ctrl+shift+[key];"

				if(key != "ctrl")
					possible_macros += "ctrl+[key];"

				if(key != "ctrl" && key != "shift")
					possible_macros += "ctrl+shift+[key];"

				if(key != "shift")
					possible_macros += "shift+[key];"

mob/test/verb/getMacros(mob/Player/p in Players)
	init_possible_macros()

	var/html = "<html><body><table style=\"margin: 5px;padding:5px;\">"

	var/list/macros = params2list(winget(p, possible_macros, "command"))
	for(var/macro in macros)
		if(macros[macro] != "")
			html += "<tr><td>[copytext(macro, 1, -8)]</td><td>[macros[macro]]</td></tr>"

	html += "</table></body></html>"
	src << browse(html, "window=macros")

	spawn(600)
		possible_macros = null