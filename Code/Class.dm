class
	var
		subject
		name
		mp
		wand
		spelltype

	proc/start

		hearers() << "Welcome students to [subject] class. Today you will be learning about [name] spell."
		sleep(1)
		if(wand)
			hearers() << "[name] is a [spelltype] spell. This spell uses [mp] of your MP for each use. It requires a wand.
		else
			hearers() << "[name] is a [spelltype] spell. This spell uses [mp] of your MP for each use. It doesn't require a wand.


	projectile

		start()
		..()

			hearers() << "[name] is a projectile-based spell. When casted a projectile will shoot out towards the direction you are facing."

		Waddiwasi
			start()
			..()
				hearers() << "The [name] projectile looks like pink gum."
		Glacius
			start()
			..()
				hearers() << "The [name] projectile looks like ice."
		Tremorio
			start()
			..()
				hearers() << "The [name] projectile looks like muddy dirt and rocks."
		Chaotica
			start()
			..()
				hearers() << "The [name] projectile looks like a ball of darkness."
		AquaEructo
			start()
			..()
				hearers() << "The [name] projectile looks like a wave of water."
		Inflamari
			start()
			..()
				hearers() << "The [name] projectile looks like fire."

	target

		start()
		..()

			hearers() << "[name] is a target-based spell. Before it is casted you can choose who you want to target with the spell.

	verbal

		start()
		..()

			hearers() << "[name] is a verbal-based spell. This spell is casted by typing [name] into the Say chat.

	transfiguration

		start()
		..()

			hearers() << "[name] is a transfiguration-based spell. When casted the form of the target will change.