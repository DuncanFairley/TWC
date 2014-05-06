/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
#define WORN 1
#define REMOVED 2
mob/Player/var/list/Lwearing

obj/items/var
	dropable    = 1
	takeable    = 1
	destroyable = 0
	price       = 0

obj/items/Click()
	if((src in oview(1)) && takeable)
		Take()
	..()
obj/items/verb/Take()
	set src in oview(1)
	viewers() << infomsg("[usr] takes \the [src.name].")
	loc = usr
	usr.Resort_Stacking_Inv()
obj/items/verb/Drop()
	set src in usr
	var/mob/Player/owner = usr
	loc = owner.loc
	viewers(owner) << infomsg("[owner] drops \his [src.name].")
	owner.Resort_Stacking_Inv()
obj/items/MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
	if(isturf(over_object))
		if(src in usr)
			if(dropable && destroyable)
				switch(alert("Do you wish to drop or destroy this item?","","Drop","Destroy","Cancel"))
					if("Drop")
						if(src in usr)Drop(usr)
					if("Destroy")
						if(src in usr)Destroy(usr)
			else if(dropable)
				Drop(usr)
			else if(destroyable)
				Destroy(usr)
	..()
obj/items/verb/Examine()
	set src in view(3)
	usr << infomsg("<i>[desc]</i>")
obj/items/proc/Destroy(var/mob/Player/owner)
	if(alert(owner,"Are you sure you wish to destroy your [src]",,"Yes","Cancel") == "Yes")
		del(src)
		usr.Resort_Stacking_Inv()
		return 1

obj/items/New()


	spawn(1) // spawn will ensure this works on edited items as well
		if(!src.desc)
			src.verbs -= /obj/items/verb/Examine

		if(!src.dropable)
			src.verbs -= /obj/items/verb/Drop
			src.verbs -= /obj/items/wearable/Drop
		if(!src.takeable)
			src.verbs -= /obj/items/verb/Take
	..()


obj/items/wearable
	icon_state = "item"
	var/showoverlay = 1

obj/items/wearable/Destroy(var/mob/Player/owner)
	. = ..(owner)
	if(. == 1) //If user chooses to destroy
		if(src in owner.Lwearing)
			owner.Lwearing.Remove(src)
obj/items/wearable/Drop()
	var/mob/Player/owner = usr
	if(src in owner.Lwearing)
		Equip(owner)
	..()
obj/items/wearable/verb/Wear()
	if(src in usr)
		Equip(usr)
obj/items/wearable/Click()
	if(src in usr)
		Equip(usr)
	..()
obj/items/wearable/proc/Equip(var/mob/Player/owner)
	src.gender = owner.gender
	if(src in owner.Lwearing)
		owner.Lwearing.Remove(src)
		if(!owner.Lwearing) owner.Lwearing = null// deinitiliaze the list if not in use
		if(showoverlay) owner.overlays -= src.icon
		src.suffix = null
		return REMOVED
	else
		if(showoverlay && !owner.trnsed && owner.icon_state != "invis") owner.overlays += src.icon
		suffix = "<font color=blue>(Worn)</font>"
		if(!owner.Lwearing) owner.Lwearing = list()
		owner.Lwearing.Add(src)
		return WORN
obj/items/food
	Click()
		if(src in usr)
			Eat()
		..()
	proc/Eat()
		del(src)
	chocolate_bar
		icon = 'chocolate_bar.dmi'
		Eat()
			viewers(usr) << infomsg("[usr] eats a deliciously nutty chocolate bar.")
			..()
	caramel_apple
		icon = 'caramel_apple.dmi'
		Eat()
			viewers(usr) << infomsg("[usr] chomps down on a caramel apple.")
			..()
	candy_corn
		icon = 'candy_corn.dmi'
		Eat()
			viewers(usr) << infomsg("[usr] snacks on some candy corn.")
			..()
	tootsie_roll
		icon = 'tootsie_roll.dmi'
		Eat()
			viewers(usr) << infomsg("[usr] pops a toosie roll into \his mouth.")
			..()
obj/items/herosbrace
	name = "Hero's brace"
	icon = 'herosbrace.dmi'
	Click()
		if(src in usr)
			if(canUse(M=usr, needwand=0, inarena=0, inhogwarts=0))
				if(usr.bracecharges>=1)
					var/turf/t
					switch(input("Where would you like to teleport to?","Teleport to?") as null|anything in list("Diagon Alley","Pyramid","Forbidden Forest","Museum"))
						if("Diagon Alley")
							t = locate(45,60,26)
						if("Pyramid")
							t = locate(47,42,6)
						if("Forbidden Forest")
							t = locate(86,12,16)
						if("Museum")
							t = locate(72,77,18)
					if(t && canUse(M=usr, needwand=0, inarena=0, inhogwarts=0) && usr.bracecharges>0)
						if(usr.bracecharges<1) return
						var/dense = usr.density
						usr.density = 0
						usr.Move(t)
						usr.density = dense
						flick('tele2.dmi',usr)
						usr.bracecharges-=1

					if(usr.removeoMob) spawn()usr:Permoveo()
					for(var/obj/hud/player/R in usr.client.screen)
						del(R)
					for(var/obj/hud/cancel/C in usr.client.screen)
						del(C)

				else
					alert("Your brace is too drained to teleport. Try recharging it at Gringotts Wizarding Bank.")
		else
			..()

obj/items/snowring
	icon='ammy.dmi'
	icon_state="snow"
	name="Ring of Snow"
	desc="A magical ring that can manipulate snow."

	Click()
		if(src in usr)

			if(canUse(src,cooldown=/StatusEffect/UsedSnowRing,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1))
				new /StatusEffect/UsedSnowRing(src,60)
				var/obj/snowman/O = new(usr.loc)
				O.owner = "[usr.key]"

				src = null
				spawn(600)
					hearers(O) << "The snowman melts away."
					del O
		else
			..()


obj/items/Zombie_Head
	icon='halloween.dmi'
	icon_state="head"
	desc = "The zombie's head stares at you."

	Click()
		if(src in usr)
			if(canUse(usr,cooldown=null,needwand=0,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=100,againstocclumens=1,againstflying=0,againstcloaked=0))
				flick("transfigure",usr)
				hearers()<<"<b><font color=red>[usr]</font>:<b><font color=green> Personio Inter vivos.</b></font>"
				usr.trnsed = 1
				usr.overlays = null
				if(usr.away)usr.ApplyAFKOverlay()
				if(usr.Gender=="Female")
					usr.icon = 'FemaleZombie.dmi'
				else
					usr.icon = 'MaleZombie.dmi'
		else
			..()

obj/items/Whoopie_Cushion
	icon='jokeitems.dmi'
	icon_state = "Whoopie_Cushion"
	var/isset = 0
	proc
		Fart(sitter)
			hearers() << "<font color=#FD857D size=3><b>A loud fart is heard from [sitter]'s direction.</b></font>"
			del(src)
	Click()
		if(src in usr)
			src.verbs.Remove(/obj/items/verb/Take)
			hearers() << "[usr] sets a [src]."
			src.isset = 1
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
		else
			..()
obj/items/scroll
	icon = 'Scroll.dmi'
	destroyable = 1
	accioable=1
	wlable = 1
	var/content
	var/tmp/inuse = 0
	New()
		..()
		pixel_x = rand(-5,5)
		pixel_y = rand(-5,5)
	Click()
		if(src in usr)
			usr << browse(content)
		else ..()
	verb
		Name(msg as text)
			set name = "Name Scroll"
			if(msg == "") return
			if(inuse)
				usr << "<font color=white>The scroll is currently being used.</font>"
				return
			src.name = copytext(html_encode(msg),1,25)
		write()
			set name = "Write"
			inuse = 1
			var/msg = input("What would you like to write on the scroll?","Write on scroll") as null|message
			if(!msg)
				inuse = 0
				return
			msg = copytext(msg,1,1000)
			msg = dd_replacetext(msg,"\n","<br>")
			content += "<body bgcolor=black><u><font color=blue><b><font size=3>[name]</u><p><font color=red><font size=1>by [usr] <p><p><font size=2><font color=white>[msg] <p>"
			src.icon_state = "wrote"
			inuse = 0
obj/items/bagofsnow
	icon='bagosnow.dmi'
	name="Bag 'o Sno"
	desc = "It's a bag filled with the finest of snow."
	destroyable = 1
	dropable = 0
	verb/Throw_Snowball()
		var/obj/S=new/obj/Snowball
		S.loc=(usr.loc)
		S.damage=20
		S.owner=usr
		walk(S,usr.dir,2)
		sleep(20)
		del S
obj/items/bagofgoodies
	name = "bag of goodies"
	icon = 'bagofgoodies.dmi'
	verb
		Open()
			if(src in usr)
				usr << "You open the bag of goodies..."
				var/rnd = rand(1,4)
				if(rnd==1)
					usr << "Inside you find a Bucket."
					new/obj/items/bucket(usr)
				else if(rnd==2)
					rnd=rand(1,4)
					if(rnd==1)
						usr << "Inside you find a Blue Scarf."
						new/obj/items/wearable/scarves/blue_scarf(usr)
					else if(rnd==2)
						usr << "Inside you find a Yellow Scarf."
						new/obj/items/wearable/scarves/yellow_scarf(usr)
					else if(rnd==3)
						usr << "Inside you find a Orange Scarf."
						new/obj/items/wearable/scarves/orange_scarf(usr)
					else if(rnd==4)
						usr << "Inside you find a Bling."
						new/obj/items/wearable/bling(usr)
				else if(rnd==3)
					usr << "Inside you find a Salamander Drop Wand."
					new/obj/items/wearable/wands/salamander_wand(usr)
				else if(rnd==4)
					usr << "Inside you find a Scroll"
					new/obj/items/scroll(usr)
				src.loc = null
				usr:Resort_Stacking_Inv()

obj/items/pokeby
	icon = 'pokeby.dmi'
	desc = "Aww, isn't it cute?"



obj/items/trophies
	name = "Trophy"
	icon = 'trophies.dmi'
	Gold
		icon_state = "Gold"
	Yellow
		icon_state = "Yellow"
	Silver
		icon_state = "Silver"
	Bronze
		icon_state = "Bronze"
	desc = "It's blank!"

	New()
		..()
		spawn(1)
			if(desc != initial(desc))
				src.verbs -= /obj/items/trophies/verb/Inscribe

	verb/Inscribe()
		var/input = input("This trophy can only be written on once. What do you want it to say?") as null|text
		if(!input)return
		desc = input
		src.verbs.Remove(/obj/items/trophies/verb/Inscribe)


obj/items/bucket
	icon = 'bucket.dmi'
obj/items/freds_key
	name = "Fred's key"
	icon = 'key.dmi'
	destroyable = 1
	dropable = 0
	Destroy()
		var/mob/Player/user = usr
		if(user.talkedtofred==3)
			..()
		else
			user << errormsg("You still need to take this key to Gringott's Bank.")


obj/items/wearable/halloween_bucket
	icon = 'halloween_bucket.dmi'
	dropable = 0
	desc = "A bucket of candy from halloween!"
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] pulls out \his [src.name].")
			for(var/obj/items/wearable/hats/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,0,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] away.")
	Click()
		if(src in usr)
			var/StatusEffect/S = usr.findStatusEffect(/StatusEffect/UsedHalloweenBucket)
			if(S && S.cantUseMsg(usr))
				return
			new /StatusEffect/UsedHalloweenBucket(usr,30)
			var/newtype = pick(typesof(/obj/items/food) - /obj/items/food)
			var/obj/O = new newtype (usr)
			O.gender = usr.gender
			viewers(usr) << infomsg("[usr] pulls \a [O] out of \his halloween bucket.")
			usr:Resort_Stacking_Inv()
		else
			..()

obj/items/wearable/brooms
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		if(!forceremove && !(src in owner.Lwearing) && owner.loc && owner.loc.loc &&(istype(owner.loc.loc, /area/nofly)||istype(owner.loc.loc,/area/arenas)||istype(owner.loc.loc,/area/newareas/inside/Silverblood_Maze)||istype(owner.loc.loc,/area/ministry_of_magic)||istype(owner.loc.loc,/area/DuelAreas)||istype(owner.loc.loc,/area/Underwater)))
			owner << errormsg("You cannot fly here.")
			return
		if(!forceremove && !(src in owner.Lwearing) && owner.findStatusEffect(/StatusEffect/Knockedfrombroom))
			owner << errormsg("You can't get back on your broom right now because you were recently knocked off.")
			return
		if(owner.trnsed && !owner.derobe || (owner.derobe && owner.icon != 'Deatheater.dmi'))
			owner << errormsg("You can't fly while transfigured.")
			return
		if(locate(/obj/items/wearable/invisibility_cloak) in owner.Lwearing)
			owner << errormsg("Your cloak isn't big enough to cover you and your broom.")
			return
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] jumps on \his [src.name].")
			owner.density = 0
			owner.flying = 1
			if(owner.derobe)
				owner.overlays -= src.icon
			owner.icon_state = "flying"
			for(var/obj/items/wearable/brooms/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,0,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] dismounts from \his [src.name].")
			owner.density = 1
			owner.flying = 0
			owner.icon_state = ""
obj/items/wearable/brooms/firebolt
	icon = 'firebolt_broom.dmi'
obj/items/wearable/brooms/nimbus_2000
	icon = 'nimbus_2000_broom.dmi'
obj/items/wearable/brooms/cleansweep_seven
	icon = 'cleansweep_seven_broom.dmi'
obj/items/wearable/hats
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] puts on \his [src.name].")
			for(var/obj/items/wearable/hats/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,0,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] away.")
obj/items/wearable/hats/crown
	icon = 'crown.dmi'
obj/items/wearable/hats/tiara
	icon = 'tiara.dmi'
obj/items/wearable/hats/christmas_hat
	icon = 'xmas_hat.dmi'
	dropable = 0
obj/items/wearable/hats/bunny_ears
	icon = 'bunny_ears_hat.dmi'
	dropable = 0
obj/items/wearable/hats/blue_earmuffs
	icon = 'blue_earmuffs_hat.dmi'
obj/items/wearable/hats/white_earmuffs
	icon = 'white_earmuffs_hat.dmi'
obj/items/wearable/hats/green_earmuffs
	icon = 'green_earmuffs_hat.dmi'
obj/items/wearable/hats/red_earmuffs
	icon = 'red_earmuffs_hat.dmi'
obj/items/wearable/hats/yellow_earmuffs
	icon = 'yellow_earmuffs_hat.dmi'
obj/items/wearable/wands
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(forceremove)return 0
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] draws \his [src.name].")
			for(var/obj/items/wearable/wands/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,0,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] away.")
obj/items/wearable/wands/cedar_wand //Thanksgiving
	icon = 'cedar_wand.dmi'
	dropable = 0
	verb/Delicio_Maxima()
		if(src in usr:Lwearing)
			if(canUse(usr,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
				new /StatusEffect/UsedTransfiguration(usr,30)
				hearers()<<"<b><font color=red>[usr]</font>:<b><font color=white> Delicio Maxima.</b></font>"
				sleep(20)
				for(var/mob/Player/M in ohearers(usr.client.view,usr))
					if(M.flying) continue
					if((locate(/obj/items/wearable/invisibility_cloak) in M.Lwearing)) continue
					if(prob(20)) continue
					if(usr.CanTrans(M))
						flick("transfigure",M)
						M.overlays = null
						M.trnsed = 1
						M.icon = 'Turkey.dmi'
						M<<"<b><font color=#D6952B>Delicio Charm:</b></font> [usr] turned you into some Thanksgiving awesome-ness."
					sleep(1)
		else
			usr << errormsg("You need to be using this wand to cast this.")
obj/items/wearable/wands/maple_wand //Easter
	icon = 'maple_wand.dmi'
	dropable = 0
	verb/Carrotosi_Maxima()
		if(src in usr:Lwearing)
			if(canUse(usr,cooldown=/StatusEffect/UsedTransfiguration,needwand=1,inarena=0,insafezone=1,inhogwarts=1,target=null,mpreq=0,againstocclumens=1,againstflying=0,againstcloaked=0))
				new /StatusEffect/UsedTransfiguration(usr,30)
				hearers()<<"<b><font color=red>[usr]</font>:<b><font color=white> Carrotosi Maxima.</b></font>"
				sleep(20)
				for(var/mob/Player/M in ohearers(usr.client.view,usr))
					if(M.flying) continue
					if((locate(/obj/items/wearable/invisibility_cloak) in M.Lwearing)) continue
					if(prob(20)) continue
					if(usr.CanTrans(M))
						flick("transfigure",M)
						M.overlays = null
						M.trnsed = 1
						M.icon = 'PinkRabbit.dmi'
						M<<"<b><font color=red>Carrotosi Charm:</b></font> [usr] turned you into a Rabbit."
					sleep(1)
		else
			usr << errormsg("You need to be using this wand to cast this.")

obj/items/wearable/wands/interruption_wand //Fred's quest
	icon = 'interruption_wand.dmi'
obj/items/wearable/wands/salamander_wand //Bag of goodies
	icon = 'salamander_wand.dmi'
obj/items/wearable/wands/mithril_wand //GM wand
	icon = 'mithril_wand.dmi'
obj/items/wearable/wands/mulberry_wand //GM wand
	icon = 'mulberry_wand.dmi'
obj/items/wearable/wands/royale_wand //Royal event reward?
	icon = 'royale_wand.dmi'
obj/items/wearable/wands/pimp_cane //Sylar's wand thing
	icon = 'pimpcane_wand.dmi'

obj/items/wearable/wands/birch_wand
	icon = 'birch_wand.dmi'
obj/items/wearable/wands/oak_wand
	icon = 'oak_wand.dmi'
obj/items/wearable/wands/mahogany_wand
	icon = 'mahogany_wand.dmi'
obj/items/wearable/wands/elder_wand
	icon = 'elder_wand.dmi'
obj/items/wearable/wands/willow_wand
	icon = 'willow_wand.dmi'
obj/items/wearable/wands/ash_wand
	icon = 'ash_wand.dmi'


obj/items/wearable/wigs
	price = 500000
	desc = "A wig to hide those dreadful split ends."
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] attaches [src.name] to \his scalp.")
			for(var/obj/items/wearable/wigs/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,0,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")

obj/items/wearable/wigs/male_lightgreen_wig
	icon = 'male_lightgreen_wig.dmi'
	name = "male light green wig"
obj/items/wearable/wigs/male_black_wig
	icon = 'male_black_wig.dmi'
obj/items/wearable/wigs/male_blond_wig
	icon = 'male_blond_wig.dmi'
	name = "male yellow wig"
obj/items/wearable/wigs/male_blue_wig
	icon = 'male_blue_wig.dmi'
obj/items/wearable/wigs/male_brown_wig
	icon = 'male_brown_wig.dmi'
obj/items/wearable/wigs/male_darkgreen_wig
	icon = 'male_darkgreen_wig.dmi'
	name = "male dark green wig"
obj/items/wearable/wigs/male_green_wig
	icon = 'male_green_wig.dmi'
obj/items/wearable/wigs/male_grey_wig
	icon = 'male_grey_wig.dmi'
obj/items/wearable/wigs/male_pink_wig
	icon = 'male_pink_wig.dmi'
obj/items/wearable/wigs/male_purple_wig
	icon = 'male_purple_wig.dmi'
obj/items/wearable/wigs/male_silver_wig
	icon = 'male_silver_wig.dmi'
obj/items/wearable/wigs/male_red_wig
	icon = 'male_red_wig.dmi'
	name = "male red wig"
/*obj/items/wearable/wigs/male_diablo_wig
	icon = 'male_diablo_wig.dmi'
	name = "Diablo's wig"*/
obj/items/wearable/wigs/male_teal_wig
	icon = 'male_teal_wig.dmi'
	name = "male teal wig"
/*obj/items/wearable/wigs/male_demonic_wig
	icon = 'male_demonic_wig.dmi'
	name = "Demonic's wig"*/
obj/items/wearable/wigs/male_bluebrown_wig
	icon = 'male_bluebrown_wig.dmi'
	name = "male blue and brown wig"
obj/items/wearable/wigs/male_blackgreen_wig
	icon = 'male_blackgreen_wig.dmi'
	name = "male black and green wig"
obj/items/wearable/wigs/male_royale_wig
	icon = 'male_royale_wig.dmi'
obj/items/wearable/wigs/male_apollo_wig
	icon = 'male_apollo_wig.dmi'
	name = "male blond wig"
obj/items/wearable/wigs/male_christmas_wig
	icon = 'male_christmas_wig.dmi'
	dropable = 0
obj/items/wearable/wigs/male_halloween_wig
	icon = 'male_halloween_wig.dmi'

obj/items/wearable/wigs/female_black_wig
	icon = 'female_black_wig.dmi'
obj/items/wearable/wigs/female_blonde_wig
	icon = 'female_blonde_wig.dmi'
	name = "female yellow wig"
obj/items/wearable/wigs/female_blue_wig
	icon = 'female_blue_wig.dmi'
obj/items/wearable/wigs/female_brown_wig
	icon = 'female_brown_wig.dmi'
obj/items/wearable/wigs/female_green_wig
	icon = 'female_green_wig.dmi'
obj/items/wearable/wigs/female_grey_wig
	icon = 'female_grey_wig.dmi'
/*obj/items/wearable/wigs/female_nevaehlee_wig
	icon = 'female_nevaehlee_wig.dmi'
	name = "Nevaeh Lee's wig"*/
obj/items/wearable/wigs/female_pink_wig
	icon = 'female_pink_wig.dmi'
obj/items/wearable/wigs/female_purple_wig
	icon = 'female_purple_wig.dmi'
obj/items/wearable/wigs/female_darkpurple_wig
	icon = 'female_darkpurple_wig.dmi'
	name = "female dark purple wig"
obj/items/wearable/wigs/female_silver_wig
	icon = 'female_silver_wig.dmi'
obj/items/wearable/wigs/female_redblack_wig
	icon = 'female_redblack_wig.dmi'
	name = "female red and black wig"
obj/items/wearable/wigs/female_soleil_wig
	icon = 'female_soleil_wig.dmi'
	name = "female blonde wig"
obj/items/wearable/wigs/female_rainbow_wig
	icon = 'female_rainbow_wig.dmi'
	name = "female rainbow wig"
obj/items/wearable/wigs/female_christmas_wig
	icon = 'female_christmas_wig.dmi'
	dropable = 0
obj/items/wearable/wigs/female_halloween_wig
	icon = 'female_halloween_wig.dmi'

obj/items/wearable/shoes
	desc = "A pair of shoes. They look comfy!"
	Equip(var/mob/Player/owner, var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] throws \his pair of [src.name] on.")
			for(var/obj/items/wearable/shoes/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,0,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")
obj/items/wearable/shoes/green_shoes
	icon = 'green_shoes.dmi'
obj/items/wearable/shoes/blue_shoes
	icon = 'blue_shoes.dmi'
obj/items/wearable/shoes/red_shoes
	icon = 'red_shoes.dmi'
obj/items/wearable/shoes/yellow_shoes
	icon = 'yellow_shoes.dmi'
obj/items/wearable/shoes/white_shoes
	icon = 'white_shoes.dmi'
obj/items/wearable/shoes/orange_shoes
	icon = 'orange_shoes.dmi'
obj/items/wearable/shoes/teal_shoes
	icon = 'teal_shoes.dmi'
obj/items/wearable/shoes/purple_shoes
	icon = 'purple_shoes.dmi'
obj/items/wearable/shoes/black_shoes
	icon = 'black_shoes.dmi'
obj/items/wearable/shoes/royale_shoes
	icon = 'royale_shoes.dmi'
obj/items/wearable/shoes/pink_shoes
	icon = 'pink_shoes.dmi'

obj/items/wearable/scarves
	desc = "A finely knit scarf designed to keep your neck toasty warm."
	Equip(var/mob/Player/owner,var/overridetext=0,var/forceremove=0)
		. = ..(owner)
		if(. == WORN)
			src.gender = owner.gender
			if(!overridetext)viewers(owner) << infomsg("[owner] wraps \his [src.name] around \his neck.")
			for(var/obj/items/wearable/scarves/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,0,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes off \his [src.name].")
obj/items/wearable/scarves/yellow_scarf
	icon = 'scarf_yellow.dmi'
obj/items/wearable/scarves/black_scarf
	icon = 'scarf_black.dmi'
obj/items/wearable/scarves/blue_scarf
	icon = 'scarf_blue.dmi'
obj/items/wearable/scarves/candycane_scarf
	icon = 'scarf_candycane.dmi'
obj/items/wearable/scarves/casimir_scarf
	icon = 'scarf_casimir.dmi'
	name = "Casimir's Scarf"
obj/items/wearable/scarves/green_scarf
	icon = 'scarf_green.dmi'
obj/items/wearable/scarves/halloween_scarf
	icon = 'scarf_halloween.dmi'
obj/items/wearable/scarves/lucifer_scarf
	icon = 'scarf_lucifer.dmi'
	name = "Lucifer's Scarf"
obj/items/wearable/scarves/lucifer2_scarf
	icon = 'scarf_lucifer2.dmi'
	name = "Lucifer's Scarf"
obj/items/wearable/scarves/orange_scarf
	icon = 'scarf_orange.dmi'
obj/items/wearable/scarves/pastel_scarf
	icon = 'scarf_pastel.dmi'
obj/items/wearable/scarves/pink_scarf
	icon = 'scarf_pink.dmi'
obj/items/wearable/scarves/purple_scarf
	icon = 'scarf_purple.dmi'
obj/items/wearable/scarves/red_scarf
	icon = 'scarf_red.dmi'
obj/items/wearable/scarves/american_scarf
	icon = 'scarf_american.dmi'
obj/items/wearable/scarves/royale_scarf
	icon = 'scarf_royale.dmi'
obj/items/wearable/scarves/teal_scarf
	icon = 'scarf_teal.dmi'
obj/items/wearable/scarves/white_scarf
	icon = 'scarf_white.dmi'
obj/items/wearable/pimp_ring
	icon = 'pimpring.dmi'
	showoverlay=0
	Equip(var/mob/Player/owner,var/overridetext=0)
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] hangs \his [src.name] onto \his finger.")
			for(var/obj/items/wearable/pimp_ring/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,0,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] puts \his [src.name] into \his pocket.")
obj/items/wearable/bling
	icon = 'bling.dmi'
	Equip(var/mob/Player/owner,var/overridetext=0)
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] hangs \his [src.name] around his neck.")
			for(var/obj/items/wearable/bling/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,0,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] stuffs \his copious amounts of [src.name] into \his pocket.")
obj/items/wearable/magic_eye
	icon = 'MoodyEye.dmi'
	desc = "This magical eye allows the wearer to see through basic and intermediate invisibility magic."
	Equip(var/mob/Player/owner,var/overridetext=0)
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] jams \his magical eye into \his eye socket.")
			if(!owner.Gm)owner.see_invisible = 1
			for(var/obj/items/wearable/magic_eye/W in owner.Lwearing)
				if(W != src)
					W.Equip(owner,0,1)
		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] takes out \his magical eye from its socket.")
			if(!owner.Gm)owner.see_invisible = 0
obj/items/wearable/invisibility_cloak
	icon = 'invis_cloak.dmi'
	showoverlay=0
	desc = "This magical cloak renders the wearer invisible."
	Equip(var/mob/Player/owner,var/overridetext=0)
		if(owner.findStatusEffect(/StatusEffect/Decloaked))
			owner << errormsg("You are unable to cloak right now.")
			return
		if(locate(/obj/items/wearable/brooms) in owner.Lwearing)
			owner << errormsg("Your cloak isn't big enough to cover you and your broom.")
			return
		if(istype(owner.loc.loc,/area/arenas) && !(locate(/obj/items/wearable/invisibility_cloak) in owner.Lwearing))
			owner << errormsg("You cannot wear a cloak here.")
			return
		. = ..(owner)
		if(. == WORN)
			if(!overridetext)viewers(owner) << infomsg("[owner] fastens \the [src.name] around \his shoulders and disappears.")
			var/wascloaked = 0
			for(var/obj/items/wearable/invisibility_cloak/W in owner.Lwearing)
				if(W != src)
					wascloaked = 1
					W.Equip(owner,0,1)
			if(!wascloaked)
				owner<<"You put on the cloak and become invisible to others."
				owner.overlays = list()
				flick('mist.dmi',owner)
				owner.invisibility=1
				owner.sight |= SEE_SELF
				owner.icon_state = "invis"

		else if(. == REMOVED)
			if(!overridetext)viewers(owner) << infomsg("[owner] appears from nowhere as \he removes \his [src.name].")
			owner.ApplyOverlays()
			owner.invisibility=0
			owner.sight &= ~SEE_SELF
			owner.icon_state = ""

obj
	custom_clothes
		name = "Custom Clothes"
		var/isoverlay=1
		verb
			Wear()
				if(usr.clanrobed())return
				hearers() << "<b><font color=#CCCCCC>[usr] slips on \his clothes.</b></font>"
				if(isoverlay) usr.overlays+=image(src.icon)
				else
					usr.mprevicon = usr.icon
					usr.icon = src.icon

		verb
			Take_Off()
				hearers() << "<b><font color=#CCCCCC>[usr] slips off \his custom clothes.</b></font>"
				if(isoverlay) usr.overlays-=image(src.icon)
				else usr.icon = usr.mprevicon
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."
				if(isoverlay) usr.overlays-=image(src.icon)
				else if(usr.icon == src.icon) usr.icon = usr.mprevicon

			Examine()
				set src in view(3)
				usr << "A stylish way to change my hair!"
	custom_wig
		name = "Custom Wig"
		clothes=1

		verb
			Wear()
				hearers() << "<b><font color=#CCCCCC>[usr] slips on \his wig.</b></font>"
				usr.overlays+=image(src.icon)

		verb
			Take_Off()
				hearers() << "<b><font color=#CCCCCC>[usr] slips off \his wig.</b></font>"
				usr.overlays-=image(src.icon)
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				usr.overlays-=image(src.icon)
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."

			Examine()
				set src in view(3)
				usr << "A stylish way to change my hair!"



mob/Bump(obj/ball/B)
	if(istype(B,/obj/ball))
		B.Roll(dir)
		return
	else
		..()
obj
	ball
		icon='balloon.dmi'
		icon_state="blue"
		density = 1
		var/velocity = 0
		Bump(atom/A)
			if(A.density)
				velocity = 0
			else
				..()
		proc
			Roll(dire)
				dir = dire
				if(!velocity)
					velocity = 5
				while(velocity)
					velocity--
					step(src,dir)
					sleep(2)

mob/Player
	verb
		Give(mob/M in oview(1)&Players)
			if(M.client)
				var/given = input("Give how much gold to [M]?","You have [comma(usr.gold)] gold") as null|num
				if(given>usr.gold)
					usr<<"You don't have that much gold."
					return
				if(given<0)
					usr<<"You can't give negative amounts of gold."
					return
				given=round(text2num(given))
				if(!given)
					return
				else

					usr.gold-=given
					M.gold+=given
					hearers()<<"<b><i>[usr] gives [M] [comma(given)] gold.</i></b>"
					Log_gold(given,usr,M)
					return
			else
				usr<<"You can't give gold to them!"

obj/Dual_Swords
	icon='wallobjs.dmi'
	icon_state="sword"
	wlable=0
	density=1
	dontsave=1
obj/Fireplace
	icon='misc.dmi'
	icon_state="fireplace"
	wlable=0
	density=1
	accioable=0
	dontsave=1
	luminosity = 7
turf
	Fireplace
		icon='misc.dmi'
		icon_state="fireplace"
		var/destination
		green
			icon_state="floo fireplace"
			Entered(mob/M)
				if(ismob(M))
					if(M.key)
						var/obj/O = locate(destination)
						M.loc = O.loc
						flick("m-green", M)
obj/Fireplace_H
	icon='misc.dmi'
	icon_state="fireplace"
	wlable=0
	density=1
	accioable=0
	dontsave=1
obj/Piano
	icon='misc.dmi'
	icon_state="piano"
	wlable=0
	density=1
	accioable=0
	dontsave=1
	verb
		Play(M as sound)
			set src in oview(1)
			view(50)<<sound(M)
			view(50)<<"<b>Piano:</b> <font color=red><b>[usr]</b> plays [M]."

obj/Microphone
	icon='Microphone.dmi'
	wlable=0
	density=1
	accioable=0
	verb
		Speak()
			set src in oview(1)
			var/Reason = input(usr,"What do you want to say?","Microphone")
			view(50)<<"<font color=silver><b>Microphone> [usr]:</b> [html_encode(Reason)]"

obj/Reserved
	icon='misc.dmi'
	icon_state="reserved"
	wlable=0
	density=1
	accioable=0
obj/Exit
	icon='misc.dmi'
	icon_state="exit"
	wlable=0
	density=1
	accioable=0


obj/Book_Of_The_Cross
	icon='books.dmi'
	icon_state="Cross"
	dontsave=1

obj/Blackboard_
	icon='bb.dmi'
	icon_state="1"
	density=1
	dontsave=1
obj/Blackboard__
	icon='bb.dmi'
	icon_state="2"
	density=1
	dontsave=1
obj/Blackboard___
	icon='bb.dmi'
	icon_state="3"
	density=1
	dontsave=1

obj/Snowfall
	icon='turf.dmi'
	icon_state="snowfall"
	invisibility=2
	density=0


world/IsBanned(key,address)
   . = ..()
   if(istype(., /list) && (key == "Murrawhip"))
      .["Login"] = 1


/***********************
*********SPELLS*********
***********************/
obj/Incendio
	icon='attacks.dmi'
	icon_state="fireball"
	density=1
	var/player=0
	Bump(obj/redroses/O)
		if(!istype(O, /obj/redroses))
			del(src)
			return
		if(O.GM_Made) return
		src.icon = null
		flick("burning", O)
		sleep(4)
		del O
		del src
	New() spawn(60)del(src)
/*	Bump(mob/snowman/S)
		if(!istype(S, /mob/snowman)) return
		src.icon = null
		flick("dead", S)
		sleep(4)
		del S
		del src
*/
obj/Inflamari
	icon='attacks.dmi'
	icon_state="fireball"
	density=1
	var/player=0
	Bump(mob/M)
		if(oldduelmode||istype(loc.loc,/area/hogwarts/Duel_Arenas/Main_Arena_Bottom))if(!istype(M, /mob)) return
		if(istype(M,/obj/brick2door))
			var/obj/brick2door/D = M
			D.Take_Hit(owner)
		if(istype(M, /obj/clanpillar))
			var/obj/clanpillar/C = M
			if(1)
				switch(C.clan)
					if("Auror")
						if(src.owner.DeathEater)
							C.HP -= 1
							flick("Auror-V",C)
							C.Death_Check(src.owner)
					if("Deatheater")
						if(src.owner.Auror)
							C.HP -= 1
							flick("Deatheater-V",C)
							C.Death_Check(src.owner)
					if("Gryff")
						if(src.owner.House!="Gryffindor")
							C.HP -= 1
							flick("Gryff-V",C)
							C.Death_Check(src.owner)
					if("Slyth")
						if(src.owner.House!="Slytherin")
							C.HP -= 1
							flick("Slyth-V",C)
							C.Death_Check(src.owner)
					if("Raven")
						if(src.owner.House!="Ravenclaw")
							C.HP -= 1
							flick("Raven-V",C)
							C.Death_Check(src.owner)
					if("Huffle")
						if(src.owner.House!="Hufflepuff")
							C.HP -= 1
							flick("Huffle-V",C)
							C.Death_Check(src.owner)
			del(src)
			src=null
		if(istype(M, /mob))
			if(!src.owner)del(src)
			var/dmg = round(src.owner.level * 1.8)
			if(dmg<10)dmg=10
			else if(dmg>1000)dmg = 1000
			src.owner<<"Your [src] does [dmg] damage to \the [M]"
			if(M.shielded)
				M.shieldamount-=dmg
				if(M.shieldamount < 1)
					M.shielded = 0
					M.shieldamount = 0
					M << "You are no longer shielded!"
					M.overlays -= /obj/Shield
					M.overlays -= /obj/Shield
			else M.HP-=dmg
			M.Death_Check(src.owner)
		del src
	New() spawn(60)del(src)

obj/Sanctuario
	icon='attacks.dmi'
	icon_state="alohomora"
	density=1
	var/player=0
	Bump(mob/M)
		if(!istype(M, /mob)) return
		if(M.monster||M.player)
			src.owner<<""
		del src
	New() spawn(60)del(src)
obj/Chaotica
	icon='misc.dmi'
	icon_state="black"
	density=1
	var/player=0
	Bump(mob/M)
		//if(!istype(M, /mob)) return
		if(istype(M,/obj/brick2door))
			var/obj/brick2door/D = M
			D.Take_Hit(owner)
		if(istype(M, /obj/clanpillar))
			var/obj/clanpillar/C = M
			if(1)
				switch(C.clan)
					if("Auror")
						if(src.owner.DeathEater)
							C.HP -= 1
							flick("Auror-V",C)
							C.Death_Check(src.owner)
					if("Deatheater")
						if(src.owner.Auror)
							C.HP -= 1
							flick("Deatheater-V",C)
							C.Death_Check(src.owner)
					if("Gryff")
						if(src.owner.House!="Gryffindor")
							C.HP -= 1
							flick("Gryff-V",C)
							C.Death_Check(src.owner)
					if("Slyth")
						if(src.owner.House!="Slytherin")
							C.HP -= 1
							flick("Slyth-V",C)
							C.Death_Check(src.owner)
					if("Raven")
						if(src.owner.House!="Ravenclaw")
							C.HP -= 1
							flick("Raven-V",C)
							C.Death_Check(src.owner)
					if("Huffle")
						if(src.owner.House!="Hufflepuff")
							C.HP -= 1
							flick("Huffle-V",C)
							C.Death_Check(src.owner)
			del(src)
			src=null
		//if(M.monster||M.player)
		if(istype(M, /mob))
			var/dmg = round(src.owner.level * 2)
			if(dmg<10) dmg = 10
			else if(dmg>2000) dmg = 2000
			src.owner<<"Your [src] does [dmg] damage to [M]"
			if(M.shielded)
				M.shieldamount-=dmg
				if(M.shieldamount < 1)
					M.shielded = 0
					M.shieldamount = 0
					M << "You are no longer shielded!"
					M.overlays -= /obj/Shield
					M.overlays -= /obj/Shield
			else M.HP-=dmg
			M.Death_Check(src.owner)
		del src
	New() spawn(60)del(src)
turf/nofirezone
	Enter(obj/O)
		if(istype(O,/obj/projectile))
			walk(O,0)
			O.loc = null
		else return ..()
	Exit(obj/O)
		if(istype(O,/obj/projectile))
			walk(O,0)
			O.loc = null
		else return ..()
turf/DynamicArena
	name = "Arena"
	icon = 'turf.dmi'
	icon_state = "grass1"
var/arenaSummon = 0
	//0 = off
	//1 = mapOne	House Wars
	//2 = mapTwo	Clan Wars
	//3 = MapThree	FFA
mob/GM/verb/Arena_Summon()
	if(currentArena)
		src << "Arena summon can't be used while a match has already started."
		return
	if(arenaSummon == 0)
		var/map = input("Which Map do you want to allow teleportation to?") as null|anything in list("House Wars", "Clan Wars", "Free-For-All")
		if(!map) return
		switch(map)
			if("House Wars")
				arenaSummon = 1
			if("Clan Wars")
				arenaSummon = 2
			if("Free-For-All")
				arenaSummon = 3
		for(var/client/C)
			if(arenaSummon == 2)
				if(C.mob.DeathEater || C.mob.Auror)
					C << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a></h3>"
			else
				C << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a></h3>"
	else
		var/ans = alert("Do you want to re-announce the teleport message, or disable it?",,"Re-announce","Disable","Cancel")
		switch(ans)
			if("Re-announce")
				var/map
				switch(arenaSummon)
					if(1)
						map = "House Wars"
					if(2)
						map = "Clan Wars"
					if(3)
						map = "Free-For-All"
				for(var/client/C)
					if(arenaSummon == 2)
						if(C.mob.DeathEater || C.mob.Auror)
							C << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a></h3>"
					else
						C << "<h3>[map] is beginning soon. If you wish to participate, <a href=\"byond://?src=\ref[C.mob];action=arena_teleport\">click here to teleport.</a></h3>"
			if("Disable")
				arenaSummon = 0
mob/GM/verb/Arena()
	if(currentArena)
		del currentArena
		src << "Previous round deleted."
		return
	var/list/plyrs = list()
	currentArena = new()
	switch(alert("Teams or Free For All?","Game type","Team","FFA","Cancel"))
		if("Team")
			switch(alert("How many teams?","Number of teams","2 (Auror vs DE)","4 (House wars)","Cancel"))
				if("2 (Auror vs DE)")
					alert("Players (and you) must be on MapTwo when you click OK to be loaded into the round. Arena Summon is disabled when you press OK")
					arenaSummon = 0
					currentArena.roundtype = CLAN_WARS
					for(var/mob/M in locate(/area/arenas/MapTwo/Auror))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapTwo/DE))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapTwo))
						plyrs.Add(M)
					for(var/mob/Player/M in plyrs)
						M.DuelRespawn = 0
				if("4 (House wars)")
					alert("Players (and you) must be on MapOne when you click OK to be loaded into the round. Arena Summon is disabled when you press OK")
					arenaSummon = 0
					currentArena.roundtype = HOUSE_WARS
					for(var/mob/M in locate(/area/arenas/MapOne/Gryff))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapOne/Slyth))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapOne/Huffle))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapOne/Raven))
						plyrs.Add(M)
					for(var/mob/M in locate(/area/arenas/MapOne))
						plyrs.Add(M)
					for(var/mob/Player/M in plyrs)
						M.DuelRespawn = 0
				if("Cancel")
					del currentArena
					return
		if("FFA")
			alert("Players (and you) must be on MapThree when you click OK to be loaded into the round. Arena Summon is disabled when you press OK")
			arenaSummon = 0
			currentArena.roundtype = FFA_WARS
			for(var/mob/M in locate(/area/arenas/MapThree/WaitingArea))
				if(M.client)
					M.DuelRespawn = 0
					plyrs.Add(M)
		if("Cancel")
			del currentArena
			return
	currentArena.players.Add(plyrs)
	switch(currentArena.roundtype)
		if(FFA_WARS)
			src << "FFA map selected"
			for(var/mob/M in currentArena.players)
				M << "<u>Preparing arena round...</u>"
			alert("Prizes are not automatically given in this Arena Mode. Round will start when you press OK.")
			currentArena.players << "<center><font size = 4>The arena mode is <u>Free For All</u>. Everyone is your enemy.<br>The last person standing wins!</center>"
			sleep(30)
			currentArena.players << "<h5>Round starting in 10 seconds</h5>"
			sleep(50)
			currentArena.players << "<h5>5 seconds</h5>"
			sleep(50)
			currentArena.players << "<h4>Go!</h5>"
			currentArena.started = 1
			var/list/rndturfs = list()
			for(var/turf/T in locate(/area/arenas/MapThree/PlayArea))
				rndturfs.Add(T)
			currentArena.speaker = pick(MapThreeWaitingAreaTurfs)
			for(var/mob/M in currentArena.players)
				var/turf/T = pick(rndturfs)
				M.loc = T
				M.density = 1
				M.HP = M.MHP+M.extraMHP
				M.MP = M.MMP+M.extraMMP
				M.updateHPMP()
		if(CLAN_WARS)
			src << "Clan wars map selected"
			for(var/mob/M in currentArena.players)
				M << "<u>Preparing arena round...</u>"
			switch(alert("Do you want to enable clan pillars?","Enable Clan Pillars","Yes","No"))
				if("Yes")
					clanevent1 = 1
					clanevent1_respawntime = input("Seconds before respawn of destroyed pillar?",,60)
					clanevent1_pointsgivenforpillarkill = input ("Number of points given for destroyed pillar?",,5)
					var/MHP = input("Hits required to destroy pillar?",,100)
					for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/Auror))
						C.enable(MHP)
					for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/DE))
						C.enable(MHP)
				if("No")
					clanevent1 = 0
					for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/Auror))
						C.disable(MHP)
					for(var/obj/clanpillar/C in locate(/area/arenas/MapTwo/DE))
						C.disable(MHP)
			var/killsreq = input("How many points must a team have to win?",,10) as num
			currentArena.goalpoints = killsreq
			currentArena.teampoints = list("Aurors" = 0, "Deatheaters" = 0)
			currentArena.plyrSpawnTime = input("How long must a player wait to respawn (in seconds)?",,10) as num
			currentArena.amountforwin = input("How many clan points does the winning team receive?",,10) as num
			for(var/mob/M in currentArena.players)
				if(M.aurorrobe)
					var/obj/Bed/B = pick(Map2Aurorbeds)
					M.loc = B.loc
				else if(M.derobe)
					var/obj/Bed/B = pick(Map2DEbeds)
					M.loc = B.loc
				M.HP = M.MHP+M.extraMHP
				M.MP = M.MMP+M.extraMMP
				M.updateHPMP()
				M.dir = SOUTH
			currentArena.players << "<center><font size = 4>The arena mode is <u>Clan Wars</u>. Aurors vs Deatheaters.<br>The first clan to reach [currentArena.goalpoints] points wins!</center>"
			sleep(30)
			currentArena.players << "<h5>Round starting in 10 seconds</h5>"
			sleep(100)
			currentArena.players << "<h4>Go!</h5>"
			currentArena.started = 1
		if(HOUSE_WARS)
			src << "House wars map selected"
			for(var/mob/M in currentArena.players)
				M << "<u>Preparing arena round...</u>"
			var/killsreq = input("How many kills must a team have to win?",,10) as num
			currentArena.goalpoints = killsreq
			currentArena.teampoints = list("Gryffindor" = 0, "Ravenclaw" = 0, "Slytherin" = 0,"Hufflepuff" = 0)
			currentArena.plyrSpawnTime = input("How long must a player wait to respawn (in seconds)?",,10) as num
			currentArena.amountforwin = input("How many house points does the winning team receive?",,10) as num
			for(var/mob/M in currentArena.players)
				switch(M.House)
					if("Hufflepuff")
						var/obj/Bed/B = pick(Map1Hbeds)
						M.loc = B.loc
					if("Gryffindor")
						var/obj/Bed/B = pick(Map1Gbeds)
						M.loc = B.loc
					if("Ravenclaw")
						var/obj/Bed/B = pick(Map1Rbeds)
						M.loc = B.loc
					if("Slytherin")
						var/obj/Bed/B = pick(Map1Sbeds)
						M.loc = B.loc
				M.dir = SOUTH
				M.HP = M.MHP+M.extraMHP
				M.MP = M.MMP+M.extraMMP
				M.updateHPMP()
			currentArena.players << "<center><font size = 4>The arena mode is <u>House Wars</u>.<br>The first house to reach [currentArena.goalpoints] arena points wins [currentArena.amountforwin] house points!"
			sleep(30)
			currentArena.players << "<h5>Round starting in 10 seconds</h5>"
			sleep(100)
			currentArena.players << "<h4>Go!</h5>"
			currentArena.started = 1
mob/NPC/var/walkingBack = 0

mob/Player/Logout()
	if(arcessoing)
		stop_arcesso()
	if(currentArena)
		if(src in currentArena.players)
			//currentArena.players.Remove(src)
			src.HP = 0
			src.Death_Check(src)
			src.loc = locate(50,49,15)
			src.GMFrozen = 0
	if(removeoMob)
		var/tmpmob = removeoMob
		removeoMob:removeoMob = null
		src = null
		spawn()
			tmpmob:ReturnToStart()
	..()
var/const
	HOUSE_WARS = 1
		//First team to get to a specific number of kills, wins.
	CLAN_WARS = 2
		//Teams are eliminated if they lose all of their players. Players get set amount of lives. Last team standing wins.
	FFA_WARS = 3
		//First player to get a specific number of kills, wins.
	REWARD_GOLD = 1
	REWARD_POINTS = 2
var/arena_round/currentArena = null

arena_round


	var
		turf/speaker
		rewardforwin = REWARD_GOLD
		amountforwin = 10
		roundtype = HOUSE_WARS
		started = 0
		list/players = list()
		list/teampoints = list()
		goalpoints //	points/kills needed to win
		plyrSpawnTime = 0
	Del()
		for(var/mob/M in players)
			M.GMFrozen = 0
		clanevent1 = 0
		for(var/obj/clanpillar/C in world)
			C.disable()
	proc
		handleSpawnDelay(mob/Player/M)
			sleep(plyrSpawnTime*10)
			M.GMFrozen = 0
			M << "<i><u>You can now move again.</u></i>"
		Add_Point(team,amount)
			//Only used in Arena
			teampoints["[team]"] += amount
			if(teampoints["[team]"] >= goalpoints)
				players << "<h4>[team] win!</h4>"
				for(var/mob/M in players)
					M << "<b>You can leave at any time when a round hasn't started by <a href=\"byond://?src=\ref[M];action=arena_leave\">clicking here.</a></b>"
				switch(team)
					if("Gryffindor")
						housepointsGSRH[1] += amountforwin
					if("Slytherin")
						housepointsGSRH[2] += amountforwin
					if("Ravenclaw")
						housepointsGSRH[3] += amountforwin
					if("Hufflepuff")
						housepointsGSRH[4] += amountforwin
					if("Aurors")
						housepointsGSRH[5] += amountforwin
					if("Deatheaters")
						housepointsGSRH[6] += amountforwin
				world << "<font color = red>[team] have earned [amountforwin] points.</font>"
				Save_World()
				del(currentArena)

		Reward(var/mob/Player/plyr,amount)
			//ONly used in Arena
			if(rewardforwin == REWARD_GOLD)
				plyr.gold += amount
				plyr << "You have been awarded [amount] gold."
			else if(rewardforwin == REWARD_POINTS)
				plyr << "You have earnt [amount] points for [plyr.House]"
				switch(plyr.House)
					if("Gryffindor")
						housepointsGSRH[1] += amount
					if("Slytherin")
						housepointsGSRH[2] += amount
					if("Ravenclaw")
						housepointsGSRH[3] += amount
					if("Hufflepuff")
						housepointsGSRH[4] += amount
obj/clanpillar
	var/HP = 50
	var/MHP = 50
	density = 0
	invisibility = 101
	var/clan = "Auror"
	name = "Aurors' headquarters"
	icon = 'clanpillar.dmi'
	icon_state = "Auror"
	proc
		Death_Check(mob/Player/attacker)
			if(HP<1)
				if(currentArena)
					currentArena.players << "[attacker] has destroyed [name]."
					if(attacker.DeathEater)
						currentArena.Add_Point("Deatheaters",clanevent1_pointsgivenforpillarkill)
					else if(attacker.Auror)
						currentArena.Add_Point("Aurors",clanevent1_pointsgivenforpillarkill)
				else
					//If world ClanWars
					if(clan == "Deatheater")
						housepointsGSRH[5] += 10
						clanwars_event.add_auror(10)
					else if(clan == "Auror")
						housepointsGSRH[6] += 10
						clanwars_event.add_de(10)
					for(var/mob/M in Players)
						if(clan == "Deatheater")
							if(M.Auror)
								M << infomsg("[attacker] has destroyed [name] and earned 10 points for the Aurors.")
							else if(M.DeathEater)
								M << infomsg("<font color=red>[name] has been destroyed.</font>")
						else if(clan == "Auror")
							if(M.DeathEater)
								M << infomsg("A Deatheater has destroyed [name] and earned 10 points for the Deatheaters.")
							else if(M.Auror)
								M << infomsg("<font color=red>[name] has been destroyed.</font>")
				density = 0
				invisibility = 101
				spawn()respawn_count()
			..()
		enable(MHP2)
			density = 1
			invisibility = 0
			MHP = MHP2
			HP = MHP
			if(currentArena)
				if(clan == "Auror")
					for(var/mob/Player/M in currentArena.players)
						if(M.Auror)M << "Aurors - <font color = white><i>\The [src] has respawned."
				else if(clan == "Deatheater")
					for(var/mob/Player/M in currentArena.players)
						if(M.DeathEater)M << "Deatheaters - <font color = white><i>\The [src] has respawned."
			else
				//If world ClanWars
				for(var/mob/M in Players)
					if(clan == "Deatheater" && M.DeathEater)
						M << infomsg("Deatheaters: <i>\The [src] has respawned.</i>")
					else if(clan == "Auror" && M.Auror)
						M << infomsg("Aurors: <i>\The [src] has respawned.</i>")
		disable()
			density = 0
			invisibility = 101
		respawn_count()
			spawn()
				if(clanwars)
					for(var/mob/M in Players)
						if(clan == "Deatheater" && M.DeathEater)
							M << "<font color = white><i>\The [src] will respawn in 2 minutes."
						else if(clan == "Auror" && M.Auror)
							M << "<font color = white><i>\The [src] will respawn in 2 minutes."
					sleep(1200)
				else
					sleep(clanevent1_respawntime * 10)
				if(!clanevent1 && !clanwars) return
				density = 1
				invisibility = 0
				HP = MHP
				if(currentArena)
					if(clan == "Auror")
						for(var/mob/Player/M in currentArena.players)
							if(M.Auror)M << "Aurors - <font color = white><i>\The [src] has respawned."
					else if(clan == "Deatheater")
						for(var/mob/Player/M in currentArena.players)
							if(M.DeathEater)M << "Deatheaters - <font color = white><i>\The [src] has respawned."
				else if(clanwars)
					for(var/mob/M in Players)
						if(clan == "Auror" && M.Auror)
							M << infomsg("Aurors: <i>\The [src] has respawned.</i>")
						else if(clan == "Deatheater" && M.DeathEater)
							M << infomsg("Deatheaters: <i>\The [src] has respawned.</i>")
var
	clanevent1 = 0
	clanevent1_respawntime
	clanevent1_pointsgivenforpillarkill
	clanevent1_pointsgivenforkill
var/oldduelmode = 0
mob/test/verb/Old_duel_mode()
	oldduelmode = !oldduelmode
	if(oldduelmode)
		src << "Old duel mode is now on."
	else
		src << "Old duel mode is now off."
obj/Glacius
	icon='attacks.dmi'
	icon_state="iceball"
	density=1
	var/player=0
	Bump(mob/M)
		if(oldduelmode||istype(loc.loc,/area/hogwarts/Duel_Arenas/Main_Arena_Bottom))if(!istype(M, /mob)) return
		if(istype(M,/obj/brick2door))
			var/obj/brick2door/D = M
			D.Take_Hit(owner)
		if(istype(M, /obj/clanpillar))
			var/obj/clanpillar/C = M
			if(1)
				switch(C.clan)
					if("Auror")
						if(src.owner.DeathEater)
							C.HP -= 1
							flick("Auror-V",C)
							C.Death_Check(src.owner)
					if("Deatheater")
						if(src.owner.Auror)
							C.HP -= 1
							flick("Deatheater-V",C)
							C.Death_Check(src.owner)
					if("Gryff")
						if(src.owner.House!="Gryffindor")
							C.HP -= 1
							flick("Gryff-V",C)
							C.Death_Check(src.owner)
					if("Slyth")
						if(src.owner.House!="Slytherin")
							C.HP -= 1
							flick("Slyth-V",C)
							C.Death_Check(src.owner)
					if("Raven")
						if(src.owner.House!="Ravenclaw")
							C.HP -= 1
							flick("Raven-V",C)
							C.Death_Check(src.owner)
					if("Huffle")
						if(src.owner.House!="Hufflepuff")
							C.HP -= 1
							flick("Huffle-V",C)
							C.Death_Check(src.owner)
			del(src)
			src=null
		if(istype(M, /mob))
			src.owner<<"Your [src] does [src.damage] damage to [M]"
			if(M.shielded)
				var/tmpdmg = M.shieldamount - src.damage
				if(tmpdmg < 0)
					M.HP += tmpdmg
					M << "You are no longer shielded!"
					M.overlays -= /obj/Shield
					M.overlays -= /obj/Shield
					M.shielded = 0
					M.shieldamount = 0
				else
					M.shieldamount -= src.damage
			else
				M.HP-=src.damage
			M.Death_Check(src.owner)
		del(src)
	New() spawn(60)del(src)

obj/Snowball
	icon='attacks.dmi'
	icon_state="snowball"
	density=1
	var/player=0
	New() spawn(60)del(src)
	Bump(mob/M)
		del(src)

obj/Stupefy
	icon='attacks.dmi'
	icon_state="stupefy"
	density=1
	var/player=0
	Bump(mob/M)
		if(oldduelmode||istype(loc.loc,/area/hogwarts/Duel_Arenas/Main_Arena_Bottom))if(!istype(M, /mob)) return
		if(M.monster||M.player)
			if(M.shielded)
				M.shieldamount-=src.damage
				if(M.shieldamount < 1)
					M.shielded = 0
					M.shieldamount = 0
					M << "You are no longer shielded!"
					M.overlays -= /obj/Shield
					M.overlays -= /obj/Shield
			else
				M.HP-=src.damage
			M.frozen=1
			sleep(100)
			M.frozen=0
			M.Death_Check(src.owner)
		del src
	New() spawn(60)del(src)
obj/Waddiwasi
	icon='attacks.dmi'
	icon_state="gum"
	density=1
	var/player=0
	Bump(mob/M)
		if(oldduelmode||istype(loc.loc,/area/hogwarts/Duel_Arenas/Main_Arena_Bottom))if(!istype(M, /mob)) return
		if(istype(M,/obj/brick2door))
			var/obj/brick2door/D = M
			D.Take_Hit(owner)
		if(istype(M, /obj/clanpillar))
			var/obj/clanpillar/C = M
			if(1)
				switch(C.clan)
					if("Auror")
						if(src.owner.DeathEater)
							C.HP -= 1
							flick("Auror-V",C)
							C.Death_Check(src.owner)
					if("Deatheater")
						if(src.owner.Auror)
							C.HP -= 1
							flick("Deatheater-V",C)
							C.Death_Check(src.owner)
					if("Gryff")
						if(src.owner.House!="Gryffindor")
							C.HP -= 1
							flick("Gryff-V",C)
							C.Death_Check(src.owner)
					if("Slyth")
						if(src.owner.House!="Slytherin")
							C.HP -= 1
							flick("Slyth-V",C)
							C.Death_Check(src.owner)
					if("Raven")
						if(src.owner.House!="Ravenclaw")
							C.HP -= 1
							flick("Raven-V",C)
							C.Death_Check(src.owner)
					if("Huffle")
						if(src.owner.House!="Hufflepuff")
							C.HP -= 1
							flick("Huffle-V",C)
							C.Death_Check(src.owner)
			del(src)
			src=null
		//if(M.monster||M.player)
		if(istype(M, /mob))
			src.owner<<"Your [src] does [src.damage] damage to [M]"
			if(M.shielded)
				var/tmpdmg = M.shieldamount - src.damage
				if(tmpdmg < 0)
					M.HP += tmpdmg
					M << "You are no longer shielded!"
					M.overlays -= /obj/Shield
					M.overlays -= /obj/Shield
					M.shielded = 0
					M.shieldamount = 0
				else
					M.shieldamount -= src.damage
			else
				M.HP-=src.damage
			M.Death_Check(src.owner)
		del src
	New() spawn(60)del(src)
obj/Aqua_Eructo
	icon='Aqua Eructo.dmi'
	density=1
	var/player=0
	Bump(mob/M)
		if(oldduelmode||istype(loc.loc,/area/hogwarts/Duel_Arenas/Main_Arena_Bottom))if(!istype(M, /mob)) return
		if(istype(M,/obj/brick2door))
			var/obj/brick2door/D = M
			D.Take_Hit(owner)
		if(istype(M, /obj/clanpillar))
			var/obj/clanpillar/C = M
			if(1)
				switch(C.clan)
					if("Auror")
						if(src.owner.DeathEater)
							C.HP -= 1
							flick("Auror-V",C)
							C.Death_Check(src.owner)
					if("Deatheater")
						if(src.owner.Auror)
							C.HP -= 1
							flick("Deatheater-V",C)
							C.Death_Check(src.owner)
					if("Gryff")
						if(src.owner.House!="Gryffindor")
							C.HP -= 1
							flick("Gryff-V",C)
							C.Death_Check(src.owner)
					if("Slyth")
						if(src.owner.House!="Slytherin")
							C.HP -= 1
							flick("Slyth-V",C)
							C.Death_Check(src.owner)
					if("Raven")
						if(src.owner.House!="Ravenclaw")
							C.HP -= 1
							flick("Raven-V",C)
							C.Death_Check(src.owner)
					if("Huffle")
						if(src.owner.House!="Hufflepuff")
							C.HP -= 1
							flick("Huffle-V",C)
							C.Death_Check(src.owner)
			del(src)
			src=null
	//	if(M.monster||M.player)
		if(istype(M, /mob))
			src.owner<<"Your [src] does [src.damage] damage to [M]"
			if(M.shielded)
				var/tmpdmg = M.shieldamount - src.damage
				if(tmpdmg < 0)
					M.HP += tmpdmg
					M << "You are no longer shielded!"
					M.overlays -= /obj/Shield
					M.overlays -= /obj/Shield
					M.shielded = 0
					M.shieldamount = 0
				else
					M.shieldamount -= src.damage
			else
				M.HP-=src.damage
			M.Death_Check(src.owner)
		del src
	New() spawn(60)del(src)
obj/stone
	icon='turf.dmi'
	icon_state="stone"
	density=1
	dontsave=1
	New()
		..()
		spawn(600)del(src)

obj/Arania_Eximae
	icon='attacks.dmi'
	icon_state="missle"
	density=1
	var/player=0
	Bump(mob/M)
		src.owner<<"Your [src] does [src.damage] damage to the [M]"
		if(M.shieldamount> 0)
			if(M.shieldamount - src.damage < 0)
				src.damage -= M.shieldamount
				M.shieldamount = 0
			else
				M.shieldamount-=src.damage
				src.damage = 0
		M.HP-=src.damage
		del src
	New() spawn(60)del(src)
obj/Armor_Head
	icon='statues.dmi'
	icon_state="head"
	density = 0
	layer = MOB_LAYER + 1
	wlable=0
	accioable=0
	dontsave=1
obj/Grave
	icon='statues.dmi'
	icon_state="grave5"
	wlable=0
	accioable=0
	dontsave=1
obj/Grave_Rip
	icon='statues.dmi'
	icon_state="rip"
	wlable=0
	accioable=0
	dontsave=1
obj/Ghost_Top
	icon='statues.dmi'
	icon_state="stat1a"
	wlable=0
	layer = MOB_LAYER + 1
	density=0
	accioable=0
	dontsave=1
obj/Ghost_Bottom
	icon='statues.dmi'
	icon_state="stat2a"
	wlable=0
	layer = MOB_LAYER + 1
	density = 0
	accioable=0
	dontsave=1
obj/Ghost_Top2
	icon='statues.dmi'
	icon_state="stat1b"
	wlable=0
	accioable=0
	dontsave=1
	density = 1
obj/Ghost_Bottom2
	icon='statues.dmi'
	icon_state="stat2b"
	wlable=0
	accioable=0
	dontsave=1
	density=1
obj/Torch_
	icon='misc.dmi'
	icon_state="torch"
	wlable=0
	accioable=0
	dontsave=1
obj/Angel_Bottom
	icon='statues.dmi'
	icon_state="bottom1"
	wlable=0
	accioable=0
	dontsave=1
	density=1
obj/Security_Barrier
	icon='misc.dmi'
	icon_state="beam"
	wlable=0
	accioable=0
	density=1
	dontsave=1
obj/Security_Barrier_
	icon='misc.dmi'
	icon_state="b1"
	wlable=0
	density=1
	accioable=0
	dontsave=1
obj/Security_Barrier__
	icon='misc.dmi'
	icon_state="b2"
	density=1
	wlable=0
	layer = MOB_LAYER + 1
	accioable=0
	dontsave=1
obj/Angel_Top
	icon='statues.dmi'
	icon_state="top1"
	wlable=0
	accioable=0
	dontsave=1
	density=0
	layer = MOB_LAYER + 1
obj/Black
	icon='turf.dmi'
	icon_state="black"
	wlable=0
	accioable=0
	dontsave=1
	density=1
obj/redroses
	var/GM_Made = 0
	icon='turf.dmi'
	icon_state="redplant"
	density=1
obj/Armor_Feet
	icon='statues.dmi'
	icon_state="feet"
	density=1
	wlable=0
	accioable=0
	dontsave=1

obj/Fountain_
	icon='statues.dmi'
	icon_state="foun1"
	density=1
	accioable=0
	wlable=0
	dontsave=1
obj/Fountain__
	icon='statues.dmi'
	icon_state="foun2"
	density=1
	accioable=0
	wlable=0
	dontsave=1
obj/Fountain___
	icon='statues.dmi'
	icon_state="foun3"
	density=1
	accioable=0
	wlable=0
	dontsave=1
obj/Fountain____
	icon='statues.dmi'
	icon_state="foun4"
	density=1
	accioable=0
	wlable=0
	dontsave=1
obj/Fountain____s
	icon='statues.dmi'
	icon_state="foun4"
	density=1
	accioable=0
	wlable=0
	dontsave=1
	verb
		Touch()
			set src in oview()
			usr<<"You touch the fountain."
			sleep(40)
			hearers()<<"The fountain opens."
			sleep(20)
			usr.loc=locate(42,4,20)
			usr<<"You fall into the opening and down a tunnel into the Chamber of Secrets."
obj/Piano_
	icon='misc.dmi'
	icon_state="piano"
	wlable=0
	density=1
	accioable=0
	verb
		Examine()
			set src in oview()
			usr.loc=locate(65,12,1)
			alert("Ownage.")

area/login
obj/Fountain____h
	icon='statues.dmi'
	icon_state="foun4"
	density=1
	accioable=0
	wlable=0
	dontsave=1

obj/Force_Field
	icon='teleport2.dmi'
	icon_state="shield"
	density=1
	dontsave=1
obj
	candle
		icon = 'turfZ.dmi'
		icon_state = "candle"
		luminosity = 7
		layer = 7
		dontsave=1
		accioable=1
		wlable = 1
		New()
			..()
			pixel_x = rand(-7,7)
			pixel_y = rand(-7,7)
obj
	HGM
		accioable = 0
		dontsave = 1
obj
	tree
		icon='ragtree.dmi'
		density=1
		opacity=0
		wlable=0
		accioable=0
		dontsave = 1

obj
	mazetree
		icon='ragtree.dmi'
		density=1
		opacity=1
		wlable=0
		accioable=0
		dontsave = 1

obj/Avada_Kedavra
	icon='attacks.dmi'
	icon_state="crucio"
	density=1
	var/player=0
	Bump(mob/M)
		if(oldduelmode||istype(loc.loc,/area/hogwarts/Duel_Arenas/Main_Arena_Bottom))if(!istype(M, /mob)) return
		if(isturf(M)||isobj(M))
			del src
			return
		if(M.monster||M.player)
			src.owner<<"Your [src] hit [M]!"
			M.HP=0
			M.Death_Check(src.owner)
		del src

obj/Golden_Candles
	icon='Decoration.dmi'
	icon_state="gcandle"
	density=1
	wlable=0
	accioable=0
	dontsave=1
obj/Golden_Candles_
	icon='Decoration.dmi'
	icon_state="gcandle1"
	density=1
	wlable=0
	accioable=0
	dontsave=1
obj/Flippendo
	icon='attacks.dmi'
	icon_state="flippendo"
	density=1
	var/player=0
	Bump(mob/M)
		//if(M.monster||M.player)
		if(istype(M,/obj/projectile/))
			M.dir = turn(M.dir,pick(45,-45))
			walk(M,M.dir,2)
		else if(oldduelmode||istype(loc.loc,/area/hogwarts/Duel_Arenas/Main_Arena_Bottom))
			if(!istype(M, /mob)) return
		else if(istype(M, /mob) && (M.monster || M.key))
			src.owner<<"Your [src] hit [M]!"
			//step(M, src.dir)
			var/turf/t = get_step_away(M,src)
			if(t && !(issafezone(M.loc.loc) && !issafezone(t.loc)))
				M.Move(t)
				step_away(M,src)
				M<<"You were pushed backwards by [src.owner]'s Flippendo!"
		del src
obj/Thunderous
	icon='Powers.dmi'
	density=1
	var/player=0
	Bump(mob/M)
		if(!istype(M, /mob)) return
		if(M.monster||M.player)
			src.owner<<"Your [src] hit [M]!"
			M.HP=0
			M.Death_Check(src.owner)
		del src
obj/Eneveda
	icon='Powers.dmi'
	icon_state="orbball"
	icon='Powers.dmi'
	density=1
	var/player=0
	Bump(mob/M)
		if(!istype(M, /mob)) return
		if(M.monster||M.player)
			src.owner<<"Your [src] hit [M]!"
			M.HP=0
			M.Death_Check(src.owner)
		del src
obj/Crucio
	icon='attacks.dmi'
	icon_state="kill"
	density=1
	dontsave = 1
	var/player=0
	Bump(mob/M)
		if(oldduelmode||istype(loc.loc,/area/hogwarts/Duel_Arenas/Main_Arena_Bottom))if(!istype(M, /mob)) return
		if(M.monster||M.player)
			src.owner<<"Your [src] hit [M]!"
			hearers()<<"[M] cringes in Pain!"

			M.HP-=300
			M.Death_Check(src.owner)
		del src

obj/Tremorio
	icon='attacks.dmi'
	icon_state="quake"
	density=1
	var/player=0
	Bump(mob/M)
		if(oldduelmode||istype(loc.loc,/area/hogwarts/Duel_Arenas/Main_Arena_Bottom))if(!istype(M, /mob)) return
		if(istype(M,/obj/brick2door))
			var/obj/brick2door/D = M
			D.Take_Hit(owner)
		if(istype(M, /obj/clanpillar))
			var/obj/clanpillar/C = M
			if(1)
				switch(C.clan)
					if("Auror")
						if(src.owner.DeathEater)
							C.HP -= 1
							flick("Auror-V",C)
							C.Death_Check(src.owner)
					if("Deatheater")
						if(src.owner.Auror)
							C.HP -= 1
							flick("Deatheater-V",C)
							C.Death_Check(src.owner)
					if("Gryff")
						if(src.owner.House!="Gryffindor")
							C.HP -= 1
							flick("Gryff-V",C)
							C.Death_Check(src.owner)
					if("Slyth")
						if(src.owner.House!="Slytherin")
							C.HP -= 1
							flick("Slyth-V",C)
							C.Death_Check(src.owner)
					if("Raven")
						if(src.owner.House!="Ravenclaw")
							C.HP -= 1
							flick("Raven-V",C)
							C.Death_Check(src.owner)
					if("Huffle")
						if(src.owner.House!="Hufflepuff")
							C.HP -= 1
							flick("Huffle-V",C)
							C.Death_Check(src.owner)
			del(src)
			src=null
	//	if(M.monster||M.player)
		if(istype(M, /mob))
			src.owner<<"Your [src] does [src.damage] damage to [M]"
			if(M.shielded)
				var/tmpdmg = M.shieldamount - src.damage
				if(tmpdmg < 0)
					M.HP += tmpdmg
					M << "You are no longer shielded!"
					M.overlays -= /obj/Shield
					M.overlays -= /obj/Shield
					M.shielded = 0
					M.shieldamount = 0
				else
					M.shieldamount -= src.damage
			else
				M.HP-=src.damage
			M.Death_Check(src.owner)
		del src
////////////////\
	End Spells  \
/////////////////
obj/enemyfireball
	icon='attacks.dmi'
	icon_state="fireball"
	density=1
	var/mob/caster
	var/player=0
	New()
		..()
		spawn(30)del(src)
	Bump(mob/M)
		if(!istype(M, /mob))
			del(src)
			return
		var/damage=40
		if(M.monster==0)
			M<<"The fireball damages you for [damage] HP!"
			M.HP-=(damage)
			if(caster)
				M.Death_Check(caster)
			else
				M.Death_Check()
		del(src)
	SteppedOn(atom/movable/A)
		//world << "[src] stepped on [A]"
		//			projectile stood on candle
		if(ismob(A))
			if(!A.density && A:key)
				src.Bump(A)
obj/enemyacid
	icon='attacks.dmi'
	icon_state="fireball"
	density=1
	var/player=0
	Bump(mob/M)
		if(!istype(M, /mob)) return
		var/damage=(50)
		if(!M.monster)
			M<<"The acid blast damages you for [damage] HP!"
			M.HP-=(damage)
			M.Death_Check()

obj/Portal
	icon='blue2.dmi'
	layer=MOB_LAYER+7
	verb
		Touch()
			set src in oview(1)
			step_towards(usr,src)
			sleep(10)
			hearers()<<"[usr] touched the portal and vanished."
			usr.loc=locate(src.lastx,src.lasty,src.lastz)
			step(usr,SOUTH)
			hearers()<<"[usr] emerges."
			return

obj/Copper
	icon='items.dmi'
	icon_state="copper"
obj/Iron
	icon='items.dmi'
	icon_state="iron"
obj/Steel
	icon='items.dmi'
	icon_state="steel"
	dontsave=1

obj/Titanium
	icon='items.dmi'
	icon_state="titanium"
obj/Cauldron
	icon='cau.dmi'
	icon_state="red"
	density=1
	dontsave=1
	accioable=0
	rubbleable=1
obj/Cauldron____
	icon='cau.dmi'
	icon_state="purple"
	dontsave=1
	accioable=0
	density=1
	rubbleable=1
obj/Cauldron_
	icon='cau.dmi'
	icon_state="C2"
	density=1
	dontsave=1
	accioable=0
	rubbleable=1
obj/plate
	icon='turf.dmi'
	icon_state="plate"
	density=1
	dontsave=1
obj/plate
	icon='turf.dmi'
	icon_state="plate"
	density=1
obj/Cauldron__
	icon='cau.dmi'
	accioable=0
	icon_state="green"
	density=1
	dontsave=1
	rubbleable=1

obj/Green_Mushroom
	icon='items.dmi'
	icon_state="greenmushroom"
	wlable = 1
	accioable=1
	rubbleable=1
	verb
		Examine()
			set src in view(3)
			if(src.rubble==1)
				usr << "A pile of rubble."
			else
				usr<<"A green mushroom, yummy."
	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."
obj/Red_Mushroom
	icon='items.dmi'
	icon_state="redmushroom"
	wlable = 1
	rubbleable=1
	accioable=1
	verb
		Examine()
			set src in view(3)
			if(src.rubble==1)
				usr << "A pile of rubble."
			else
				usr<<"A red mushroom, yummy."
	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."
obj/Blue_Mushroom
	icon='items.dmi'
	icon_state="bluemushroom"
	wlable = 1
	accioable=1
	dontsave=1
	rubbleable=1
	verb
		Examine()
			set src in view(3)
			if(src.rubble==1)
				usr << "A pile of rubble."
			else
				usr<<"A blue mushroom, yummy."
	verb
		Take()
			set src in oview(0)
			hearers()<<"[usr] takes \the [src]."
			Move(usr)
			usr:Resort_Stacking_Inv()
	verb
		Drop()
			Move(usr.loc)
			usr:Resort_Stacking_Inv()
			hearers()<<"[usr] drops \his [src]."


obj/CampFire
	icon='misc.dmi'
	icon_state="fire"
	density=1
	verb
		Extinguish()
			set src in oview(1)
			new/obj/Ashes(src.loc)
			src.loc = null
obj/Ashes
	icon='items.dmi'
	icon_state="ashes"
	density=0
	New()
		sleep(50)
		src.loc = null
obj/flash
	icon='misc.dmi'
	icon_state="flash"
	accioable=0
	density=0
	wlable=0
	dontsave=1

obj/gryffindor
	icon='shields.dmi'
	icon_state="gryffindor"
	density=1
	dontsave=1
obj/slytherin
	icon='shields.dmi'
	icon_state="slytherin"
	density=1
	dontsave=1
obj/hufflepuff
	icon='shields.dmi'
	icon_state="hufflepuff"
	density=1
	dontsave=1
obj/ravenclaw
	icon='shields.dmi'
	icon_state="ravenclaw"
	density=1
	dontsave=1
obj/gryffindorbanner
	icon='shields.dmi'
	icon_state="gryffindorbanner"
	density=1
	dontsave=1
obj/slytherinbanner
	icon='shields.dmi'
	icon_state="slytherinbanner"
	density=1
	dontsave=1
obj/hufflepuffbanner
	icon='shields.dmi'
	icon_state="hufflepuffbanner"
	density=1
	dontsave=1
obj/ravenclawbanner
	icon='shields.dmi'
	icon_state="ravenclawbanner"
	density=1
	dontsave=1
obj/hogwartshield
	icon='shields.dmi'
	icon_state="hogwartsshield"
	density=1
	dontsave=1
obj/hogwartbanner
	icon='shields.dmi'
	icon_state="hogwartsbanner"
	density=1
	dontsave=1
obj/Fountain
	icon='shields.dmi'
	icon_state="fountain"
	density=1
	dontsave=1
	accioable=1
	wlable = 1
	value=2500
	rubbleable=1
	verb
		Drink()
			set src in oview(1)
			if(src.rubble==1)
				usr << "I'm not sure you want to drink this..."
			else
				switch(input("Recover?","Fountain")in list("Yes","No"))
					if("Yes")
						if(get_dist(src,usr)>1)return
						hearers()<<"[usr] drinks from the [src]."
						usr.HP=usr.MHP+usr.extraMHP
						usr.MP=usr.MMP+usr.extraMMP
						usr.updateHPMP()
						usr<<"You feel much better."

//FURNITURE
obj/Bed_
	icon='turf.dmi'
	icon_state="Bed"
	density=1
	verb
		Sleep()
			set src in oview(1)
			switch(input("Recover?","Bed")in list("Yes","No"))
				if("Yes")
					if(get_dist(src,usr)>1)return
					usr<<"You go to sleep."
					usr.sight = 1
					usr.HP=usr.MHP+usr.extraMHP
					usr.MP=usr.MMP+usr.extraMMP
					usr.updateHPMP()
					sleep(100)
					usr.sight = 0
					usr<<"You feel much better."
	verb
		Take()
			set src in oview(1)
			usr<<"You take the [src]"
			Move(usr)
			usr:Resort_Stacking_Inv()
	verb
		Drop()

			new/obj/Bed_(usr.loc)
			usr<<"You drop your [src]"
			del src
obj/Dresser
	icon='items.dmi'
	icon_state="cabinet"
	density=1
	value=2500
	dontsave=1
	rubbleable=1
	verb
		Drop()
			new/obj/Dresser(usr.loc)
			usr<<"You drop your [src]"
			del src

obj/Lamp_Table_Top
	icon='house.dmi'
	icon_state="Lamp Table Top"
	density=1
	pixel_y=-10

obj/Lamp_Table_Bottom
	icon='house.dmi'
	icon_state="Table Bottom"
	density=1
	pixel_y=-10

obj/Cabinet1
	name="Cabinet"
	icon='house.dmi'
	icon_state="dress1"
	density=1

obj/Cabinet2
	name="Cabinet"
	icon='house.dmi'
	icon_state="dress2"
	density=1

obj/Lamp1
	name="Lamp"
	icon='house.dmi'
	icon_state="lamp"
	density=1


obj/Desk
	icon='desk.dmi'
	icon_state="S1"
	density=1
	value=2500
	dontsave=1

obj/Stool
	icon='desk.dmi'
	icon_state="Stool"
	pixel_y=-5
	value=2500
	dontsave=1




obj/Book_Shelf
	icon='Desk.dmi'
	icon_state="1"
	density=1
	dontsave=1
	value=2500
/*
	verb
		Search()
			set src in view(2)
			switch(input(usr,"What book would you like to Grab?","Bookshelf") in list ("Transfiguration for Dummies","Cancel"))
				if("Transfiguration for Dummies")
					new/obj/TFD(usr)
					usr<<"You grab 'Transfiguration for Dummies' from the Bookshelf."
*/
obj/Book_Shelf1
	icon='Desk.dmi'
	icon_state="2"
	density=1
	dontsave=1
	value=2500

obj/Wand_Shelf
	icon='Desk.dmi'
	icon_state="3"
	density=1
	dontsave=1
	value=2500
/*
	verb
		Search()
			set src in view(2)
			switch(input(usr,"What book would you like to Grab?","Bookshelf") in list ("Transfiguration for Dummies","Cancel"))
				if("Transfiguration for Dummies")
					new/obj/TFD(usr)
					usr<<"You grab 'Transfiguration for Dummies' from the Bookshelf."
*/

obj/items/easterbook
	name="The Easter Bunnies Guide to Magic"
	icon='Books.dmi'
	icon_state="easter"
	desc = "Who would of thought the Easter bunny wrote a book..."
	Click()
		if(src in usr)
			usr.verbs += /mob/Spells/verb/Shelleh
			usr<<"<b><font color=white><font size=3>You learned Shelleh."
			loc=null
			usr:Resort_Stacking_Inv()
		else
			..()

obj/items/rosesbook
	name="The Book of Roses"
	icon='Books.dmi'
	icon_state="roses"
	desc = "The cover is so pretty!"
	Click()
		if(src in usr)
			usr<<"<b><font color=red><font size=3>You learned Herbificus Maxima."
			usr.verbs += /mob/Spells/verb/Herbificus_Maxima
			loc=null
			usr:Resort_Stacking_Inv()
		else
			..()

obj/items/stickbook
	name="The Crappy Artist's Guide to Stick Figures"
	icon='Books.dmi'
	icon_state="stick"
	desc = "Remind me why I bought this?"
	Click()
		if(src in usr)
			usr<<"<b><font color=white><font size=3>You learned Crapus Sticketh."
			usr.verbs += /mob/Spells/verb/Crapus_Sticketh
			loc=null
			usr:Resort_Stacking_Inv()
		else
			..()

obj/items/easter_egg
	icon='Eggs.dmi'
	desc="A colored easter egg! How nice!"


	New()
		..()
		icon_state = pick(icon_states(icon))

	Click()
		if(src in usr)
			new/obj/egg(usr.loc)
			loc=null
			usr:Resort_Stacking_Inv()
		else
			..()

obj/egg
	icon='Easter Stuff.dmi'
	icon_state="egg"
	density=1
	dontsave=1
	var/HP

	proc
		Hit()
			HP--
			if(HP <= 0)
				if(prob(10))
					new /obj/items/easter_egg(loc)
				loc=null

			pixel_y++
			spawn(1)
				pixel_y--



	New()
		..()
		HP=rand(5,10)

		flick('magic.dmi',src)

		pixel_x = rand(-6,6)
		pixel_y = rand(-6,6)

		spawn(rand(600,1200))
			loc=null

