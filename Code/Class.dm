obj/teacher
	var
		class/classInfo
		tmp/canTeach = FALSE

	icon = 'NPCs.dmi'

	New()
		..()

		if(prob(50))
			icon_state = "shana"
			name       = pick("Shana")
		else
			icon_state = "palmer"
			name       = pick("Palmer", "Bob")

	Click()
		..()
		if(usr in ohearers(3, src))

			if(!canTeach)
				usr << errormsg("You decide not to disturb the teacher, he didn't explain everything about the spell yet.")
				return

			if(classInfo.spelltype in usr.verbs)
				usr << errormsg("You already know this spell.")
				return

			if(locate(/obj/items/wearable/wands/practice_wand) in usr)
				usr << errormsg("You already have a practice wand, you decide not to burden yourself with another.")
				return

			usr << infomsg("You received a new practice wand, keep using the spell until you learn it!")
			var/obj/items/wearable/wands/practice_wand/wand = new(usr)
			var/learnSpell/l = new

			l.path = classInfo.spelltype
			l.name = classInfo.name
			l.uses = classInfo.uses
			wand.spell = l
			usr:Resort_Stacking_Inv()

		else
			usr << errormsg("You aren't close enough.")

class
	var
		name
		subject = "GCOM"
		mp      = 0
		wand    = FALSE
		obj/teacher/professor
		spelltype
		uses = 10

	proc/say(var/msg)
		hearers(12, professor) << "<font color=#2bcfce>\[[subject] Professor] <b>[professor.name]</b> : </font>[msg]"

	proc/start()
		spawn(150)	professor.canTeach = TRUE
		say("Welcome students to [subject] class. Today you will be learning about [name] spell.")
		sleep(30)
		say("When I'm done explaining the spell, please come to me and take a practice wand, use that wand to practice the spell until you've learned it. Of course if you already have a practice wand of another spell, you will not be able to get another.")
		sleep(60)
		say("This spell [mp ? "uses [mp] of your" : "does not use"] MP for each use. It [wand ? "requires" : "doesn't require"] a wand.")
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

	target
		start()
			..()
			say("[name] is a target-based spell. Before it is casted you can choose who you want to target with the spell.")
			sleep(30)

	verbal

		start()
			..()
			say("[name] is a verbal-based spell. This spell is casted by typing [name] into the Say chat.")
			sleep(30)

		Eat_Slugs
			subject = "COMC"
			mp      = 100
			wand    = TRUE
			start()
				..()
				say("Eat slugs will make the target vommit slugs, the slugs are created using not only your MP your target's as well, it will slowly eat their MP away because of this if they have no MP left, no slugs will come out.")
		Disperse

	transfiguration

		start()
			..()
			say("[name] is a transfiguration-based spell. When casted the form of the target will change.")
			sleep(30)

		Petrificus_Totalus
		Scurries
		Carrotosi
		Delicio
		Seatio
		Ribbitous
		Personio_Sceletus
		Personio_Musashi
		Transfiguro_Revertio
		Felinious
		Avifors
		Antifigura
		Nightus
		Harvesto
		Peskipiksi_Pestermi
	dada
		Incindia
	gcom

	comc
		Serpensortia
		Repellium
		Avis
		Permoveo
		Eat_Slugs
		Arania_Exumai

	charms

	Conjunctivis
	Portus
	Expecto_Patronum
	Rictusempra
	Dementia
	Deletrius
	Evanesco
	Crucio
	Accio
	Reparo
	Herbificus
	Bombarda
	Eparo_Evanesca
	Flippendo
	Langlock
	Arcesso
	Telendevour
	Muffliato
	Protego
	Impedimenta
	Valorus
	Immobulus
	Reducto
	Confundus
	Anapneo
	Melofors
	Levicorpus
	Depulso
	Occlumency
	Flagrate
	Incendio
	Imitatus
	Riddikulus
	Densaugeo
	Replacio
	Incarcerous
	Obliviate
	Ferula
	Tarantallegra
	Solidus
	Sense
	Scan
	Furnunculus
	Expelliarmus
	Disperse
	Wingardium_Leviosa

proc/ends_with(var/string, var/end, var/ignoreCase = FALSE)
	var/end_len = length(end)
	var/cut = copytext(string, -end_len)

	if(ignoreCase)
		cut = lowertext(cut)
		end = lowertext(end)

	return cut == end

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