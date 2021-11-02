proc/GenerateIcon(atom/movable/a, px = 0, py = 0, wig = 1, shoes = 1, scarf = 1)

	if(scarf)
		var/image/i = image(pick(typesof(/obj/items/wearable/scarves/) - /obj/items/wearable/scarves/), "")
		i.layer   = FLOAT_LAYER - 5
		i.pixel_x = px
		i.pixel_y = py

		a.overlays += i

	if(shoes)
		var/image/i = image(pick(typesof(/obj/items/wearable/shoes/)   - /obj/items/wearable/shoes/),   "")

		i.layer   = FLOAT_LAYER - 5
		i.pixel_x = px
		i.pixel_y = py

		a.overlays += i

	if(wig)
		var/list/colors = list("black", "blue", "green", "grey", "pink", "purple", "silver", "cyan", "teal", "red", "orange")
		var/image/i = image(text2path("/obj/items/wearable/wigs/[a.gender == MALE ? "male" : "female"]_[pick(colors)]_wig"), "")

		i.layer   = FLOAT_LAYER - 4
		i.pixel_x = px
		i.pixel_y = py

		a.overlays += i

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
			name   = pick("Palmer", "Bob", "Jorge", "Davis", "Shayne", "Clayton", "Olin", "Ty", "Jayson", "Owen", "Ned", "Benito", "Prince", "Cyrus", "Art", "Ben", "Derek", "Kendrick", "Frances", "Garry", "Man", "Federico", "Clifford")
			icon   = 'MaleStaff.dmi'
			gender = MALE

		GenerateIcon(src)

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

		tmp
			members
			lastTaught

	proc/say(var/msg, mob/Player/p)
		if(!p)
			hearers(12, professor) << "<span style=\"color:#2bcfce;\">\[[subject] Professor] <b>[professor.name]</b> : </span>[msg]"
		else
			p << "<span style=\"color:#2bcfce;\">\[[subject] Professor] <b>[professor.name]</b> : </span>[msg]"

	proc/start(mob/Player/p)
		if(!professor.canTeach)
			spawn(300)
				professor.canTeach = TRUE
		lastTaught = world.time
		say("Welcome students to [subject] class. Today you will be learning about the spell [name].", p)
		sleep(30)
		say("When I'm done explaining the spell, please come to me and take a practice wand, use that wand to practice the spell until you've learned it. Of course if you already have a practice wand of another spell, you will not be able to get another.", p)
		sleep(60)
		say("This spell [mp ? "uses [mp] of your" : "does not use"] MP for each use. It [wand ? "requires" : "doesn't require"] a wand.", p)
		sleep(30)
		if(cd)
			say("[name] applies a [cd] second cooldown after using it.", p)
			sleep(30)



	projectile
		subject = "DADA"
		uses    = 10000
		wand    = TRUE

		start(mob/Player/p)
			..()
			say("[name] is a projectile-based spell. When casted a projectile will shoot out towards the direction you are facing.", p)
			sleep(30)
			say("If you want to learn [name] faster, use it to knock out monsters or players!", p)
			sleep(30)

		Waddiwasi
			mp = 20
			start(mob/Player/p)
				..()
				say("The [name] projectile looks like pink gum.", p)
		Glacius
			mp = 20
			start(mob/Player/p)
				..()
				say("The [name] projectile looks like ice and can also be used to freeze water.", p)
		Tremorio
			mp = 10
			start(mob/Player/p)
				..()
				say("The [name] projectile looks like muddy dirt and rocks.", p)
		Chaotica
			mp = 30
			start(mob/Player/p)
				..()
				say("The [name] projectile looks like a ball of darkness.", p)
		Aqua_Eructo
			start(mob/Player/p)
				..()
				say("The [name] projectile looks like a wave of water. If you recall, I said this projectile doesn't use MP, it's because it costs health instead, 30 per use.", p)

	verbal
		start(mob/Player/p)
			..()
			say("[name] is a verbal-based spell. This spell is casted by typing [name] into the Say chat.", p)
			sleep(30)

		Eat_Slugs
			subject = "COMC"
			mp      = 100
			cd      = 15
			wand    = TRUE
			start(mob/Player/p)
				..()
				say("[name] will make the target vomit slugs. The slugs are created using not only your MP, but your target's as well. The slugs will slowly eat their MP away until it reaches zero. Once your target runs out of MP, they will stop vomiting up slugs.", p)
		Disperse
			cd      = 10
			start(mob/Player/p)
				..()
				say("It gets rid of any smoke or swamp that may happen around you. There's even a rumor that if used enough times, it'll even disperse dark mark created by dark wizards!", p)

	transfiguration
		subject = "Transfiguration"
		wand    = TRUE
		cd      = 15
		uses    = 200
		start(mob/Player/p)
			..()
			say("[name] is a transfiguration-based spell. When casted the form of the target will change. When you practice this spell, you will get 10 uses when used on players.", p)
			sleep(30)

		Scurries
			start(mob/Player/p)
				..()
				say("This spell transforms others into a mouse.", p)
		Carrotosi
			start(mob/Player/p)
				..()
				say("This is one of the cutest spells. It turns others into a small little white bunny.", p)
		Delicio
			start(mob/Player/p)
				..()
				say("This is wonderful especially to those who are hungry. This turns others into a turkey served with some veggies.", p)
		Seatio
			start(mob/Player/p)
				..()
				say("This will turn people you don't like into a chair!", p)
		Ribbitous
			start(mob/Player/p)
				..()
				say("This will turn others into a frog. Don't think that you'll turn into a prince/princess after you get kissed. It doesn't work like that!", p)
		Personio_Sceletus
			uses = 20
			start(mob/Player/p)
				..()
				say("This spell is one of my favorites and perfect for halloween! You will be able to transform yourself into a skeleton. Careful not to scare too many people like this though.", p)
		Personio_Musashi
			uses = 20
			start(mob/Player/p)
				..()
				say("This spell is great for hiding. It turns you into a little small mushroom.", p)
		Transfiguro_Revertio
			uses = 15
			start(mob/Player/p)
				..()
				say("Let's say you turned transfigured someone by accident. This handy spell turns them back to normal.", p)
		Felinious
			start(mob/Player/p)
				..()
				say("After using this spell on someone, they will be turned into a small black cat. Beware of them crossing you! You don't want any bad luck.", p)
		Avifors
			start(mob/Player/p)
				..()
				say("This turns others into a small black bird. Similar to a black crow. Claw! Claw!", p)
		Nightus
			start(mob/Player/p)
				..()
				say("After using this spell, you will be turned into a little bat. Batman may not like you much in this state.", p)
		Harvesto
			start(mob/Player/p)
				..()
				say("It turns you into a nice onion. Be careful not get eaten though.", p)
		Peskipiksi_Pestermi
			start(mob/Player/p)
				..()
				say("Once you flick your wand and point it at the student, they will be turned into a pixie.", p)
	Antifigura
		subject = "Transfiguration"
		mp      = 50
		cd      = 15
		wand    = TRUE
		start(mob/Player/p)
			..()
			say("If you don't like being transfigured, then this is the spell for you. This will prevent any student from using transfiguration spells on you. This lasts for a certain time though so use it wisely.", p)

	dada
		Petrificus_Totalus
			mp = 50
			cd = 15
			uses = 200
			start(mob/Player/p)
				..()
				say("This is the Full Body-Bind Curse! It stiffens a person's limbs so they cannot move.", p)
		Reducto
			wand = TRUE
			mp = 400
			cd = 15
			start(mob/Player/p)
				..()
				say("If binded, this spell is perfect for you. It frees you from any binds or frozen spells.", p)
		Incindia
			mp   = 450
			cd   = 15
			wand = TRUE
			start(mob/Player/p)
				..()
				say("Careful when you use this. It fires projectiles in all 8 directions! It's quite a useful spell in my opinion.", p)
		Protego
			cd = 40
			mp = 100
			wand = TRUE
			start(mob/Player/p)
				..()
				say("Protego is a shield charm, for 5 seconds any spell you are hit with will effect the caster and not to you, as if you are a mirror.", p)
		Impedimenta
			mp = 750
			cd = 20
			wand = TRUE
			start(mob/Player/p)
				..()
				say("This spell creates an AoE (area of effect) effect inside a 15x15 square for 10 seconds.", p)
		Depulso
			wand = TRUE
			start(mob/Player/p)
				..()
				say("Known as the knockback charm. This pushes someone out of the way. It is great for dueling", p)
				sleep(30)
				say("Using [name] to knock someone off of a broom will prevent them from flying for 15 seconds.", p)
		Occlumency
			wand = TRUE
			start(mob/Player/p)
				..()
				say("This handy spell prevents people from accessing your mind thus they won't be able to see where you are located. It uses your MP in seconds as the MP usage.", p)
		Incarcerous
			cd = 15
			wand = TRUE
			uses = 200
			mp = 50
			start(mob/Player/p)
				..()
				say("This ties someone or something up with ropes.", p)
		Expelliarmus
			cd = 30
			mp = 300
			wand = TRUE
			start(mob/Player/p)
				..()
				say("Known as the disarming charm. You lose your wand and have to re-draw it.", p)
	Flippendo
		subject = "DADA"
		mp      = 10
		wand    = TRUE
		start(mob/Player/p)
			..()
			say("Once this projectile hits the person, it moves them one space.", p)
	gcom
		Sense
			start(mob/Player/p)
				..()
				say("It allows you to sense how many times the student has died and killed others.", p)
		Scan
			start(mob/Player/p)
				..()
				say("This allows you to see how much health and mana the student has. It is nice for checking out your competition.", p)
		Obliviate
			mp = 700
			cd = 30
			wand = TRUE
			start(mob/Player/p)
				..()
				say("You'll forget whatever the caster wants you to. You also will have some of your chat logs erased too.", p)
		Crucio
			mp = 400
			cd = 15
			wand = TRUE
			start(mob/Player/p)
				..()
				say("Inflicts intense pain on the recipient of the curse. One of the three unforgivable curses.", p)
		Solidus
			wand = TRUE
			start(mob/Player/p)
				..()
				say("This creates a huge stone in front of you. Perfect for blocking but only lasts for a set time.", p)
		Densaugeo
			wand = TRUE
			start(mob/Player/p)
				..()
				say("This hex causes the victim's teeth to grow rapidly, but can also be used to restore lost teeth.", p)
		Flagrate
			mp = 300
			cd = 10
			wand = TRUE
			start(mob/Player/p)
				..()
				say("This displays a large announcement to those who are near you.", p)
		Valorus
			wand = TRUE
			start(mob/Player/p)
				..()
				say("This handy spell can make someone stop following you and have someone fall off a broom too.", p)
		Arcesso
			wand = TRUE
			mp = 800
			cd = 15
			start(mob/Player/p)
				..()
				say("You can summon a student with this spell. It requires two students to work though and they both must have this spell.", p)
				sleep(30)
				say("The second person who joins the summoning needs at least 400 MP.", p)
		Riddikulus
			cd = 30
			wand = TRUE
			start(mob/Player/p)
				..()
				say("HAHA! This spell turns you into the opposite sex for a few minutes.", p)
		Telendevour
			wand = TRUE
			start(mob/Player/p)
				..()
				say("This allows you to look into the caster's eyes showing where they are located.", p)

	comc
		subject = "COMC"
		wand    = TRUE
		Serpensortia
			cd = 15
			mp = 100
			start(mob/Player/p)
				..()
				say("Summons a small snake that can be rebellious if not treated right.", p)
		Repellium
			mp = 100
			cd = 90
			start(mob/Player/p)
				..()
				say("Creates an Area of Effect that pushes back all monsters outside the circumference. Beware: this doesn't work on all of them. ;)", p)
				sleep(30)
				say("[name] will also disable projectile usage for 30 seconds.", p)
		Avis
			cd = 15
			mp = 100
			start(mob/Player/p)
				..()
				say("Summons a bird that can come to your aid and heal you plus others if needed.", p)
		Permoveo
			mp = 300
			start(mob/Player/p)
				..()
				say("This unique spell lets you control monsters like trolls or even the bassy if you are lucky.", p)
				sleep(30)
				say("It applies a cooldown after you use it, the cooldown is dependent on your level, it starts at 400 seconds and reduces by 1 per every 2 levels you have until it reaches a minimum of 30 seconds.", p)
		Arania_Exumai
			start(mob/Player/p)
				..()
				say("This spell is used to blast away Acromantulas and, presumably, all other arachnids.", p)
		Dementia
			cd = 15
			start(mob/Player/p)
				..()
				say("This will summon a dementor however it will not be under your control. It could turn on you and eat your soul!", p)
		Expecto_Patronum
			start(mob/Player/p)
				..()
				say("I'd say this would be perfect for fighting dementors. It sends dementors and other dark creatures away.", p)
	charms
		subject = "Charms"
		wand    = TRUE

		Lumos
			cd = 60
			mp = 100

			start(mob/Player/p)
				..()
				say("It lights the area around you.", p)

		Conjunctivis
			cd = 15
			start(mob/Player/p)
				..()
				say("This curse is presumed to cause great pain in the victim's eyes causing the victim to be blind for a certain amount of time.", p)
		Portus
			mp = 25
			cd = 30
			start(mob/Player/p)
				..()
				say("It turns an object into a port-key. That means you can make a scroll into a portal. How exciting!", p)
		Rictusempra
			mp = 500
			start(mob/Player/p)
				..()
				say("This will cause you to laugh without stopping. You won't be able to speak during this time.", p)
		Deletrius
			start(mob/Player/p)
				..()
				say("It deletes things like roses and scrolls.", p)
		Evanesco
			cd = 15
			start(mob/Player/p)
				..()
				say("Vanishes the target; the best description of what happens to it is that it goes \"into non-being, which is to say, everything", p)
		Accio
			start(mob/Player/p)
				..()
				say("Known as the summoning charm. It summons an object to the caster.", p)
		Accio_Maxima
			start(mob/Player/p)
				..()
				say("Known as the summoning charm. It summons every item you own to the caster, like monster drops or scrolls.", p)
		Reparo
			start(mob/Player/p)
				..()
				say("It's used to repair objects. Quite handy if something is broken.", p)
		Herbificus
			start(mob/Player/p)
				..()
				say("This summons roses. It is perfect for Valentine's Day!", p)
		Herbivicus
			start(mob/Player/p)
				..()
				say("This spell helps growing herbs, you still have to plant the seed in a bucket though.", p)
		Bombarda
			mp = 100
			start(mob/Player/p)
				..()
				say("This spell destroys objects and turns it into rubble.", p)
		Eparo_Evanesca
			cd = 10
			start(mob/Player/p)
				..()
				say("It makes the invisible turn visible.", p)
				sleep(30)
				say("[name] prevents who it reveals from recloaking themselves for 15 seconds.", p)
		Langlock
			mp = 600
			start(mob/Player/p)
				..()
				say("This spell glues the subject's tongue to the roof of their mouth, making it hard to speak.", p)
		Muffliato
			start(mob/Player/p)
				..()
				say("This spell fills peoples' ears with an unidentifiable buzzing to keep them from hearing nearby conversations.", p)
		Confundus
			mp = 400
			cd = 40
			start(mob/Player/p)
				..()
				say("It causes the victim to become confused and befuddled.", p)
		Anapneo
			start(mob/Player/p)
				..()
				say("This opens the airpipes of a student.", p)
		Melofors
			cd = 15
			start(mob/Player/p)
				..()
				say("This drops a pumpkin on your targets head temporarily blinding them until it falls off.", p)
		Levicorpus
			mp = 800
			cd = 60
			start(mob/Player/p)
				..()
				say("This flips you upside down so any secret notes or pens will be on the floor for people to collect. Watch out!", p)
		Incendio
			wand = TRUE
			mp = 20
			start(mob/Player/p)
				..()
				say("This spell is helpful with burning roses.", p)
		Imitatus
			start(mob/Player/p)
				..()
				say("This allows you to imitate any student in your view.", p)
		Replacio
			mp = 500
			start(mob/Player/p)
				..()
				say("Using this spell, you get to switch places with yourself and the target you have chosen.", p)
		Ferula
			cd = 60
			start(mob/Player/p)
				..()
				say("This summons our wonderful nurse and she will be there to help heal any minor wounds that you may have.", p)
				sleep(30)
				say("[name]'s heal has a 10 second cooldown.", p)
		Tarantallegra
			mp = 200
			cd = 30
			start(mob/Player/p)
				..()
				say("This spell causes people to dance uncontrollably.", p)
		Furnunculus
			start(mob/Player/p)
				..()
				say("This jinx covers the target in painful boils which causes you to lose health in the process.", p)
		Wingardium_Leviosa
			start(mob/Player/p)
				..()
				say("Levitates and moves the target; the wand motion is described as \"swish and flick.", p)

proc
	ends_with(var/string, var/end, var/ignoreCase = FALSE)
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

area/hogwarts/class
	safezoneoverride = 0

	Defence_Against_the_Dark_Arts
	Charms
	Care_of_Magical_Creatures
	Transfiguration
	Headmasters_Class_West
	Headmasters_Class_East

	var/tmp/class/class
	Entered(atom/movable/Obj, atom/OldLoc)
		..()

		if(class && isplayer(Obj))
			var/mob/Player/p = Obj

			if(!class.members)
				class.members = list()

			if(!(p.ckey in class.members))
				class.members += p.ckey

				if(class.professor.canTeach)
					class.start(p)
				else
					p << infomsg("Take a seat and wait for the teacher to give their lecture.")


WorldData/var/classReqPlayers = 4
WorldData/var/classCooldown = 72000 // 2 hours
WorldData/var/lastClass = 0

obj/startClass
	mouse_opacity = 2
	maptext_width = 96
	layer = 5
	maptext_y = 8
	mouse_over_pointer = MOUSE_HAND_POINTER

	maptext = "<b style=\"text-align:center;\">C L A S S</b>"

	icon = 'bb.dmi'

	var/subject

	Click()
		if(worldData.currentEvents)
			usr << errormsg("You can't use this while an event is running.")
			return

		var/ticks = worldData.classCooldown - (world.realtime - worldData.lastClass)
		if(ticks > 0)
			usr << errormsg("Try again in about [round(ticks / 600, 1)] minutes.")
			return

		var/area/a = loc.loc
		var/count = 0
		for(var/mob/Player/p in a)
			count++

		if(count < worldData.classReqPlayers)
			usr << errormsg("Not enough players to start a class, try inviting your friends over to the classroom.")
			return

		worldData.lastClass = world.realtime

		var/RandomEvent/Class/c = locate() in worldData.events
		c.start(subject=src.subject)








