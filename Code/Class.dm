/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
obj/teacher
	var
		class/classInfo
		tmp/canTeach = FALSE

	icon = 'NPCs.dmi'
	density = 1
	mouse_over_pointer = MOUSE_HAND_POINTER

	New()
		..()

		if(prob(51))
			name   = pick("Shana", "Shakira", "Valeri", "Elodia", "Marilu", "Shenna", "Coreen", "Debera", "Marlo", "Aracely", "Romana", "Dona", "Tobi", "Kathern", "Majorie", "Dierdre", "Angla", "Judith", "Johnetta", "Lennie", "Kelli")
			icon   = 'FemaleStaff.dmi'
			gender = FEMALE
		else
			name   = pick("Palmer", "Bob", "Jorge", "Davis", "Shayne", "Clayton", "Olin", "Ty", "Jayson", "Owen", "Ned", "Benito", "Prince", "Cyrus", "Art", "Derek", "Kendrick", "Frances", "Garry", "Man", "Federico", "Clifford")
			icon   = 'MaleStaff.dmi'
			gender = MALE

		overlays += image(pick(typesof(/obj/items/wearable/scarves/) - /obj/items/wearable/scarves/), "")
		overlays += image(pick(typesof(/obj/items/wearable/shoes/)   - /obj/items/wearable/shoes/),   "")

		var/list/colors = list("black", "blue", "green", "grey", "pink", "purple", "silver", "cyan", "teal", "red", "orange")
		overlays += image(text2path("/obj/items/wearable/wigs/[gender == MALE ? "male" : "female"]_[pick(colors)]_wig"), "")

		namefont.QuickName(src, src.name, rgb(255,255,255), "#000", top=1)

	proc/talk(mob/Player/p)
		if(p in ohearers(3, src))

			if(!canTeach)
				p << errormsg("You decide not to disturb [src], \he hasn't explained everything about the spell yet.")
				return

			if(classInfo.spelltype in p.verbs)
				p << errormsg("You already know [classInfo.name].")
				return

			if(locate(/obj/items/wearable/wands/practice_wand) in p)
				p << errormsg("You already have a practice wand, you decide not to burden yourself with another.")
				return

			p << infomsg("You received a new practice wand, keep using the spell until you learn it!")
			var/obj/items/wearable/wands/practice_wand/wand = new(p)
			var/learnSpell/l = new

			l.path = classInfo.spelltype
			l.name = classInfo.name
			l.uses = classInfo.uses
			wand.spell = l
			p:Resort_Stacking_Inv()

		else
			p << errormsg("You aren't close enough.")

	verb/Talk()
		set src in oview(2)
		set category = null
		talk(usr)

	Click()
		..()
		talk(usr)

class
	var
		name
		subject = "GCOM"
		mp      = 0
		cd      = 0
		wand    = FALSE
		obj/teacher/professor
		spelltype
		uses = 10

	proc/say(var/msg)
		hearers(12, professor) << "<font color=#2bcfce>\[[subject] Professor] <b>[professor.name]</b> : </font>[msg]"

	proc/start()
		spawn(300)	professor.canTeach = TRUE
		say("Welcome students to [subject] class. Today you will be learning about the spell [name].")
		sleep(30)
		say("When I'm done explaining the spell, please come to me and take a practice wand, use that wand to practice the spell until you've learned it. Of course if you already have a practice wand of another spell, you will not be able to get another.")
		sleep(60)
		say("This spell [mp ? "uses [mp] of your" : "does not use"] MP for each use. It [wand ? "requires" : "doesn't require"] a wand.")
		sleep(30)
		if(cd)
			say("[name] applies a [cd] second cooldown after using it.")
			sleep(30)



	projectile
		subject = "DADA"
		uses    = 1000
		wand    = TRUE

		start()
			..()
			say("[name] is a projectile-based spell. When casted a projectile will shoot out towards the direction you are facing.")
			sleep(30)
			say("If you want to learn [name] faster, use it to knock out monsters or players!")
			sleep(30)

		Waddiwasi
			mp = 10
			start()
				..()
				say("The [name] projectile looks like pink gum.")
		Glacius
			mp = 10
			start()
				..()
				say("The [name] projectile looks like ice and can also be used to freeze water.")
		Tremorio
			mp = 5
			start()
				..()
				say("The [name] projectile looks like muddy dirt and rocks.")
		Chaotica
			mp = 30
			start()
				..()
				say("The [name] projectile looks like a ball of darkness.")
		Aqua_Eructo
			start()
				..()
				say("The [name] projectile looks like a wave of water. If you recall, I said this projectile doesn't use MP, it's because it costs health instead, 30 per use.")

	verbal
		start()
			..()
			say("[name] is a verbal-based spell. This spell is casted by typing [name] into the Say chat.")
			sleep(30)

		Eat_Slugs
			subject = "COMC"
			mp      = 100
			cd      = 15
			wand    = TRUE
			start()
				..()
				say("[name] will make the target vomit slugs. The slugs are created using not only your MP, but your target's as well. The slugs will slowly eat their MP away until it reaches zero. Once your target runs out of MP, they will stop vomiting up slugs.")
		Disperse
			cd      = 10
			start()
				..()
				say("It gets rid of any smoke or swamp that may happen around you. There's even a rumor that if used enough times, it'll even disperse dark mark created by dark wizards!")

	transfiguration
		subject = "Transfiguration"
		wand    = TRUE
		cd      = 15
		start()
			..()
			say("[name] is a transfiguration-based spell. When casted the form of the target will change.")
			sleep(30)

		Scurries
			start()
				..()
				say("This spell transforms others into a mouse.")
		Carrotosi
			start()
				..()
				say("This is one of the cutest spells. It turns others into a small little white bunny.")
		Delicio
			start()
				..()
				say("This is wonderful especially to those who are hungry. This turns others into a turkey served with some veggies.")
		Seatio
			start()
				..()
				say("This will turn people you don't like into a chair!")
		Ribbitous
			start()
				..()
				say("This will turn others into a frog. Don't think that you'll turn into a prince/princess after you get kissed. It doesn't work like that!")
		Personio_Sceletus
			start()
				..()
				say("This spell is one of my favorites and perfect for halloween! You will be able to transform yourself into a skeleton. Careful not to scare too many people like this though.")
		Personio_Musashi
			start()
				..()
				say("This spell is great for hiding. It turns you into a little small mushroom.")
		Transfiguro_Revertio
			start()
				..()
				say("Let's say you turned transfigured someone bu accident. This handy spell turns them back to normal.")
		Felinious
			start()
				..()
				say("After using this spell on someone, they will be turned into a small black cat. Beware of them crossing you! You don't want any bad luck.")
		Avifors
			start()
				..()
				say("This turns others into a small black bird. Similar to a black crow. Claw! Claw!")
		Nightus
			start()
				..()
				say("After using this spell, you will be turned into a little bat. Batman may not like you much in this state.")
		Harvesto
			start()
				..()
				say("It turns you into a nice onion. Be careful not get eaten though.")
		Peskipiksi_Pestermi
			start()
				..()
				say("Once you flick your wand and point it at the student, they will be turned into a pixie.")
	Antifigura
		subject = "Transfiguration"
		mp      = 50
		cd      = 15
		wand    = TRUE
		start()
			..()
			say("If you don't like being transfigured, then this is the spell for you. This will prevent any student from using transfiguration spells on you. This lasts for a certain time though so use it wisely.")

	dada
		Petrificus_Totalus
			mp = 10
			cd = 15
			start()
				..()
				say("This is the Full Body-Bind Curse! It stiffens a person's limbs so they cannot move.")
		Reducto
			wand = TRUE
			start()
				..()
				say("If binded, this spell is perfect for you. It frees you from any binds or frozen spells.")
		Incindia
			mp   = 450
			cd   = 15
			wand = TRUE
			start()
				..()
				say("Careful when you use this. It fires projectiles in all 8 directions! It's quite a useful spell in my opinion.")
		Protego
			cd = 10
			wand = TRUE
			start()
				..()
				say("The Shield Charm causes minor to moderate jinxes, curses, and hexes to rebound upon the attacker.")
		Impedimenta
			mp = 750
			cd = 20
			wand = TRUE
			start()
				..()
				say("This spell freezes everyone in your view for about 10 seconds.")
		Immobulus
			mp = 600
			cd = 15
			wand = TRUE
			start()
				..()
				say("This spell doesnt allow anyone to move in your view for 15 seconds.")
		Depulso
			wand = TRUE
			start()
				..()
				say("Known as the knockback charm. This pushes someone out of the way. It is great for dueling")
				sleep(30)
				say("Using [name] to knock someone off of a broom will prevent them from flying for 15 seconds.")
		Occlumency
			wand = TRUE
			start()
				..()
				say("This handy spell prevents people from accessing your mind thus they won't be able to see where you are located. It uses your MP in seconds as the MP usage.")
		Incarcerous
			cd = 15
			wand = TRUE
			start()
				..()
				say("This ties someone or something up with ropes.")
		Expelliarmus
			cd = 15
			wand = TRUE
			start()
				..()
				say("Known as the disarming charm. You lose your wand and have to re-draw it.")
	Flippendo
		subject = "DADA"
		mp      = 10
		wand    = TRUE
		start()
			..()
			say("Once this projectile hits the person, it moves them one space.")
	gcom
		Sense
			start()
				..()
				say("It allows you to sense how many times the student has died and killed others.")
		Scan
			start()
				..()
				say("This allows you to see how much health and mana the student has. It is nice for checking out your competition.")
		Obliviate
			mp = 700
			cd = 30
			wand = TRUE
			start()
				..()
				say("You'll forget whatever the caster wants you to. You also will have some of your chat logs erased too.")
		Crucio
			mp = 400
			cd = 15
			wand = TRUE
			start()
				..()
				say("Inflicts intense pain on the recipient of the curse. One of the three unforgivable curses.")
		Solidus
			wand = TRUE
			start()
				..()
				say("This creates a huge stone in front of you. Perfect for blocking but only lasts for a set time.")
		Densaugeo
			wand = TRUE
			start()
				..()
				say("This hex causes the victim's teeth to grow rapidly, but can also be used to restore lost teeth.")
		Flagrate
			mp = 300
			cd = 10
			wand = TRUE
			start()
				..()
				say("This displays a large announcement to those who are near you.")
		Valorus
			wand = TRUE
			start()
				..()
				say("This handy spell can make someone stop following you and have someone fall off a broom too.")
		Arcesso
			wand = TRUE
			mp = 800
			cd = 15
			start()
				..()
				say("You can summon a student with this spell. It requires two students to work though and they both must have this spell.")
				sleep(30)
				say("The second person who joins the summoning needs at least 400 MP.")
		Riddikulus
			cd = 30
			wand = TRUE
			start()
				..()
				say("HAHA! This spell turns you into the opposite sex for a few minutes.")
		Telendevour
			wand = TRUE
			start()
				..()
				say("This allows you to look into the caster's eyes showing where they are located.")

	comc
		subject = "COMC"
		wand    = TRUE
		Serpensortia
			cd = 15
			start()
				..()
				say("Summons a small snake that can be rebellious if not treated right.")
		Repellium
			mp = 100
			cd = 90
			start()
				..()
				say("Creates an Area of Effect that pushes back all monsters outside the circumference. Beware: this doesn't work on all of them. ;)")
				sleep(30)
				say("[name] will also disable projectile usage for 30 seconds.")
		Avis
			cd = 15
			start()
				..()
				say("Summons a bird that can come to your aid and heal you plus others if needed.")
		Permoveo
			mp = 300
			start()
				..()
				say("This unique spell lets you control monsters like trolls or even the bassy if you are lucky.")
				sleep(30)
				say("It applies a cooldown after you use it, the cooldown is dependent on your level, it starts at 400 seconds and reduces by 1 per every 2 levels you have until it reaches a minimum of 30 seconds.")
		Arania_Exumai
			start()
				..()
				say("This spell is used to blast away Acromantulas and, presumably, all other arachnids.")
		Dementia
			cd = 15
			start()
				..()
				say("This will summon a dementor however it will not be under your control. It could turn on you and eat your soul!")
		Expecto_Patronum
			start()
				..()
				say("I'd say this would be perfect for fighting dementors. It sends dementors and other dark creatures away.")
	charms
		subject = "Charms"
		wand    = TRUE
		Conjunctivis
			cd = 15
			start()
				..()
				say("This curse is presumed to cause great pain in the victim's eyes causing the victim to be blind for a certain amount of time.")
		Portus
			mp = 25
			cd = 30
			start()
				..()
				say("It turns an object into a port-key. That means you can make a scroll into a portal. How exciting!")
		Rictusempra
			mp = 50
			start()
				..()
				say("This will cause you to laugh without stopping. You won't be able to speak during this time.")
		Deletrius
			start()
				..()
				say("It deletes things like roses and scrolls.")
		Evanesco
			cd = 15
			start()
				..()
				say("Vanishes the target; the best description of what happens to it is that it goes \"into non-being, which is to say, everything")
		Accio
			start()
				..()
				say("Known as the summoning charm. It summons an object to the caster.")
		Reparo
			start()
				..()
				say("It's used to repair objects. Quite handy if something is broken.")
		Herbificus
			start()
				..()
				say("This summons roses. It is perfect for Valentine's Day!")
		Bombarda
			start()
				..()
				say("This spell destroys objects and turns it into rubble.")
		Eparo_Evanesca
			cd = 10
			start()
				..()
				say("It makes the invisible turn visible.")
				sleep(30)
				say("[name] prevents who it reveals from recloaking themselves for 15 seconds.")
		Langlock
			mp = 600
			start()
				..()
				say("This spell glues the subject's tongue to the roof of their mouth, making it hard to speak.")
		Muffliato
			start()
				..()
				say("This spell fills peoples' ears with an unidentifiable buzzing to keep them from hearing nearby conversations.")
		Confundus
			mp = 30
			start()
				..()
				say("It causes the victim to become confused and befuddled.")
		Anapneo
			start()
				..()
				say("This opens the airpipes of a student.")
		Melofors
			cd = 15
			start()
				..()
				say("This drops a pumpkin on your targets head temporarily blinding them until it falls off.")
		Levicorpus
			mp = 800
			cd = 60
			start()
				..()
				say("This flips you upside down so any secret notes or pens will be on the floor for people to collect. Watch out!")
		Incendio
			wand = TRUE
			mp = 10
			start()
				..()
				say("This spell is helpful with burning roses.")
		Imitatus
			start()
				..()
				say("This allows you to imitate any student in your view.")
		Replacio
			mp = 500
			start()
				..()
				say("Using this spell, you get to switch places with yourself and the target you have chosen.")
		Ferula
			cd = 30
			start()
				..()
				say("This summons our wonderful nurse and she will be there to help heal any minor wounds that you may have.")
				sleep(30)
				say("[name]'s heal has a 5 second cooldown.")
		Tarantallegra
			mp = 100
			cd = 15
			start()
				..()
				say("This spell causes people to dance uncontrollably.")
		Furnunculus
			start()
				..()
				say("This jinx covers the target in painful boils which causes you to lose health in the process.")
		Wingardium_Leviosa
			start()
				..()
				say("Levitates and moves the target; the wand motion is described as \"swish and flick.")

proc
	ends_with(var/string, var/end, var/ignoreCase = FALSE)
		var/end_len = length(end)
		var/cut = copytext(string, -end_len)

		if(ignoreCase)
			cut = lowertext(cut)
			end = lowertext(end)

		return cut == end

	replace(string, needle, new_string, start=1, end=0)
		while(findtext(string,needle,start,end))
			var/pos = findtext(string,needle,start,end)
			string = copytext(string,1,pos) + new_string + copytext(string,pos+length(needle))
		return string

mob/Player
	var/tmp/learnSpell/learning

	proc/learnSpell(name, use = 1)
		if(learning && learning.name == name)
			learning.uses -= use
			if(learning.uses <= 0)
				src << infomsg("You learned [learning.name]!")

				var/spellpath = learning.path

				spawn()
					var/obj/items/wearable/wands/practice_wand/wand = locate() in Lwearing
					if(wand)
						wand.Equip(src)
						wand.loc = null
						Resort_Stacking_Inv()
						verbs += spellpath


learnSpell
	var/path
	var/name
	var/uses