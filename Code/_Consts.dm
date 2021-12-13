#define TICK_LAG 1
#define floor(x) round(x)
#define ceil(x) (-round(-(x)))
#define isplayer(x) istype(x, /mob/Player)
#define ismonster(x) istype(x, /mob/Enemies)
#define ismovable(x) istype(x, /atom/movable)
#define SetSize(s) transform = matrix() * ((s) / iconSize)
#define winshowCenter(player, window) player << output(window,"browser1:ShowCenterWindow")
#define winshowRight(player, window) player << output(window,"browser1:ShowRightWindow")

#define VERSION "16.75"
#define SUB_VERSION "3"
#define SAVEFILE_VERSION 47
#define VAULT_VERSION 7
#define WORLD_VERSION 1
#define lvlcap 800
#define SWAPMAP_Z 21 // world map z + 1 (the +1 is for buildable area, don't add if not using sandbox)
#define WINTER 1
#define AUTUMN 0
#define HALLOWEEN 0
#define NIGHTCOLOR "#6464d0"
#define TELENDEVOUR_COLOR "#64d0d0"
#define MAGICEYE_COLOR "#9df"
#define COMBAT_TIME 150

#define PET_LIGHT 1
#define PET_FOLLOW_FAR 2
#define PET_FOLLOW_RIGHT 4
#define PET_FOLLOW_LEFT 8
#define PET_FETCH 32
#define PET_HIDE 64
#define PET_SHINY 128
#define PET_FLY 256
#define SHINY_LIST list("#dd1111", "#11dd11", "#1111dd", "#dd11dd", "#11dddd", "#dddd11")
#define MAX_PET_LEVEL 100
#define MAX_PET_EXP(pet) ((pet.quality + 1) * 20000)

#define MAX_WAND_LEVEL 100
#define MAX_WAND_EXP(wand) ((wand.quality + 1) * 20000)

#define POTIONS_AMOUNT 70

// passives
#define RING_WATERWALK 1
#define RING_APPARATE 2
#define RING_DISPLACEMENT 4
#define RING_LAVAWALK 8
#define RING_DUAL_SWORD 16
#define RING_DUAL_SHIELD 32768

#define SHIELD_MP 32
#define SHIELD_SELFDAMAGE 64
#define SHIELD_MPDAMAGE 128
#define SHIELD_GOLD 256
#define SHIELD_5 512

#define SWORD_FIRE 1024
#define SWORD_HEALONKILL 2048
#define SWORD_ANIMAGUS 4096
#define SWORD_GHOST 8192
#define SWORD_SNAKE 16384

#define BACKPACK_ROWS  12
#define BACKPACK_COLS  20


#define EARTH 1
#define FIRE  2
#define WATER 4
#define GHOST 8
#define HEAL 16

#define SWAMP  1
#define SHIELD 2

#define DIRS_LIST list(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)

#define WORN 1
#define REMOVED 2

#define GLIDE_SIZE 0

#define MP_REGEN 1
#define HP_REGEN 2
#define ANIMAGUS_TICK 4
#define ANIMAGUS_RECOVER 8

#define DRINK 0
#define THROW 1


#if HALLOWEEN
WorldData/var/tmp/list/waterColors = list()
#endif

obj/custom // used for defining custom objects with { } constructor


/*client
	fps = 50
	glide_size = 32

mob/Player
	glide_size = 32*/

mob/Player/verb/ToggleFPS()
	set category = null
	if(client.fps == 40)
		client.fps = 10
		client.glide_size = 0
		GLIDE = 0
	else
		client.fps = 40
		client.glide_size = 32
		GLIDE = 32
	src << infomsg("FPS set to [client.fps].")


var
	list/__post_init = list()
	map_initialized = 0

proc
	MapInitialized()
		set waitfor = 0
		if(!map_initialized)
			map_initialized = 1
			for(var/atom/o in __post_init)
				o.MapInit()
			__post_init = null

atom
	movable
		appearance_flags = PIXEL_SCALE

	var/post_init = 0

	New()
		if(post_init)
			if(map_initialized)
				MapInit()
			else
				__post_init[src] = 1
		..()

	proc/MapInit()



WorldData/var/tmp/baseChance = 0.015


/*
mob/Player

	var/tmp
		displayStats = 0

	verb/TestMe()
		set hidden = 1
		displayStats = 0
	verb/TestMe2()
		set waitfor = 0
		set hidden = 1
		if(displayStats) return
		displayStats = 1
		while(displayStats)
			sleep(5)

			var/count = 1

			src << output({"Name: [name]
Year: [Year]
House: [House]
Level: [level]
HP: [HP]/[MHP]
MP: [MP]/[MMP]
Damage: [Dmg] ([Dmg - (level + 4)])
Defense: [Def] ([(Def - (level + 4))/3])
Cooldown Reduction: [round(1000 - cooldownModifier*1000, 1)/10]%
MP Regeneration: [50 + round(level/10)*2 + MPRegen]

---Skills---"}, "grid3:1,[count++]")

			if(Fire)
				var/percent = round((Fire.exp / Fire.maxExp) * 100)
				var/obj/o = mousehelper["Fire"]
				o.name = "Fire   Level: [Fire.level]   Exp: [comma(Fire.exp)]/[comma(Fire.maxExp)] ([percent]%)"

				src << output(o, "grid3:1,[count++]")
			if(Earth)
				var/percent = round((Earth.exp / Earth.maxExp) * 100)
				var/obj/o = mousehelper["Earth"]
				o.name = "Earth   Level: [Earth.level]   Exp: [comma(Earth.exp)]/[comma(Earth.maxExp)] ([percent]%)"

				src << output(o, "grid3:1,[count++]")
			if(Water)
				var/percent = round((Water.exp / Water.maxExp) * 100)
				var/obj/o = mousehelper["Water"]
				o.name = "Water   Level: [Water.level]   Exp: [comma(Water.exp)]/[comma(Water.maxExp)] ([percent]%)"

				src << output(o, "grid3:1,[count++]")
			if(Ghost)
				var/percent = round((Ghost.exp / Ghost.maxExp) * 100)
				var/obj/o = mousehelper["Ghost"]
				o.name = "Ghost   Level: [Ghost.level]   Exp: [comma(Ghost.exp)]/[comma(Ghost.maxExp)] ([percent]%)"

				src << output(o, "grid3:1,[count++]")
			if(animagusState && Animagus)
				var/percent = round((Animagus.exp / Animagus.maxExp) * 100)
				var/obj/o = mousehelper["Animagus"]
				o.name = "Animagus   Level: [Animagus.level]   Exp: [comma(Animagus.exp)]/[comma(Animagus.maxExp)] ([percent]%)"

				src << output(o, "grid3:1,[count++]")
			if(Gathering)
				var/percent = round((Gathering.exp / Gathering.maxExp) * 100)
				var/obj/o = mousehelper["Gathering"]
				o.name = "Gathering   Level: [Gathering.level]   Exp: [comma(Gathering.exp)]/[comma(Gathering.maxExp)] ([percent]%)"

				src << output(o, "grid3:1,[count++]")
			if(Taming)
				var/percent = round((Taming.exp / Taming.maxExp) * 100)
				var/obj/o = mousehelper["Taming"]
				o.name = "Taming   Level: [Taming.level]   Exp: [comma(Taming.exp)]/[comma(Taming.maxExp)] ([percent]%)"

				src << output(o, "grid3:1,[count++]")
			if(Alchemy)
				var/percent = round((Alchemy.exp / Alchemy.maxExp) * 100)
				var/obj/o = mousehelper["Alchemy"]
				o.name = "Alchemy   Level: [Alchemy.level]   Exp: [comma(Alchemy.exp)]/[comma(Alchemy.maxExp)] ([percent]%)"

				src << output(o, "grid3:1,[count++]")
			if(Slayer)
				var/percent = round((Slayer.exp / Slayer.maxExp) * 100)
				var/obj/o = mousehelper["Slayer"]
				o.name = "Slayer   Level: [Slayer.level]   Exp: [comma(Slayer.exp)]/[comma(Slayer.maxExp)] ([percent]%)"

				src << output(o, "grid3:1,[count++]")
			if(Summoning)
				var/percent = round((Summoning.exp / Summoning.maxExp) * 100)
				var/obj/o = mousehelper["Summoning"]
				o.name = "Summoning   Level: [Summoning.level]   Exp: [comma(Summoning.exp)]/[comma(Summoning.maxExp)] ([percent]%)"

				src << output(o, "grid3:1,[count++]")
			if(Spellcrafting)
				var/percent = round((Spellcrafting.exp / Spellcrafting.maxExp) * 100)
				var/obj/o = mousehelper["Spellcrafting"]
				o.name = "Spellcrafting   Level: [Spellcrafting.level]   Exp: [comma(Spellcrafting.exp)]/[comma(Spellcrafting.maxExp)] ([percent]%)"

				src << output(o, "grid3:1,[count++]")
			if(TreasureHunting)
				var/percent = round((TreasureHunting.exp / TreasureHunting.maxExp) * 100)
				var/obj/o = mousehelper["TreasureHunting"]
				o.name = "Treasure Hunting   Level: [TreasureHunting.level]   Exp: [comma(TreasureHunting.exp)]/[comma(TreasureHunting.maxExp)] ([percent]%)"

				src << output(o, "grid3:1,[count++]")

		//	src << output("", "grid3:1,[count++]")


			if(level >= lvlcap && rankLevel)
				var/percent = round((rankLevel.exp / rankLevel.maxExp) * 100)
				src << output("Experience Rank:   [rankLevel.level]   Exp: [comma(rankLevel.exp)]/[comma(rankLevel.maxExp)] ([percent]%)", "grid3:1,[count++]")
			else
				var/percent = round((Exp / Mexp) * 100)
				src << output("EXP:   [comma(src.Exp)]/[comma(src.Mexp)] ([percent]%)", "grid3:1,[count++]")
			if(wand && (wand.exp + wand.quality > 0))
				var/maxExp = MAX_WAND_EXP(wand)
				var/percent = round((wand.exp / maxExp) * 100)
				src << output("Wand:   Level: [wand.quality]   Exp: [comma(wand.exp)]/[comma(maxExp)] ([percent]%)", "grid3:1,[count++]")

			if(pet)
				if(pet.item.exp + pet.item.quality > 0)
					var/maxExp = MAX_PET_EXP(pet.item)
					var/percent = round((pet.item.exp / maxExp) * 100)
					var/hap = min(round(pet.stepCount / 10, 1), 100)
					src << output("[pet.name]: Level: [pet.item.quality]   Exp: [comma(pet.item.exp)]/[comma(maxExp)] ([percent]%)\nHappiness: [hap]%", "grid3:1,[count++]")
				else
					var/percent = min(round(pet.stepCount / 10, 1), 100)
					src << output("[pet.name]: Happiness: [percent]%", "grid3:1,[count++]")

			src << output({"Stat points: [StatPoints]
Spell points: [spellpoints]
Threads: [threads]"}, "grid3:1,[count++]")

			if(learning)
				src << output("Learning: [learning.name]\nUses required: [learning.uses]", "grid3:1,[count++]")*/


var/snowCurse = 0

WorldData
	var
		tmp
			elfDelay = 30
			list/secretSanta


#define SANTAPORTAL "@ChristmasWorldOut"

mob/Player

	proc/secretSanta()
		set waitfor = 0

		if(worldData.secretSanta)
			if((client.computer_id in worldData.secretSanta) || (client.address in worldData.secretSanta) || (client.ckey in worldData.secretSanta)) return

		var/minutes = worldData.elfDelay + rand(99)
		sleep(minutes*600)

		while(client.inactivity > 600 || !loc || !loc.loc:region)
			sleep(100)

		while(locate(/hudobj/login_reward) in client.screen)
			sleep(10)

		var/atom/o = locate(SANTAPORTAL)
		if(ismovable(o)) o = o.loc
		new /obj/secret/Elf (o, src)


obj/secret/Elf
	icon = 'NPCs.dmi'
	icon_state = "elf1"
	canSave = FALSE

	New(Loc, mob/Player/p)
		set waitfor = 0

		icon_state = "elf[rand(1,3)]"

		..(Loc)

		while(p && loc && (z != p.z || get_dist(loc, p.loc) > 1))

			var/list/path = getPathTo(loc, p.loc)
			if(!path) break

			for(var/turf/t in path)
				if(!loc) break
				if(t == p.loc) break
				dir = get_dir(loc, t)
				loc = t
				sleep(1)

			if(!loc) break

			var/obj/teleport/o = locate() in orange(1, loc)
			var/near = get_dist(loc, p.loc) <= 1

			if(o && !near)
				var/turf/d = locate(o.dest)
				loc = d
			else if(near) break

		if(!p)
			loc = null
		else
			if(get_dist(loc, p.loc) > 1)
				loc = get_step(p.loc, NORTH)
				dir = SOUTH

			var/list/messages = list("Hello [p.name]! Santa gave me this special present to deliver, enjoy!",
			                         "Hey look, I got pointy ears. I'm the mailelf, a fat bastard sent me on an errand to give you this present.",
			                         "Hohohoho! I'm not fat nor do I have a beard but I've got the next best thing, a present, only for you [p.name]!",
			                         "Me elf me deliver gift.",
			                         "I walked for five days in order to find you and deliver this present from some bearded stranger, [p.name]")
			hearers() << npcsay("Elf: [pick(messages)]")
			sleep(10)

			if(p)
				new /hudobj/secretSanta(null, p.client, null, show=1, Player=p)
			sleep(30)

			var/atom/target = locate(SANTAPORTAL)

			while(target && loc && loc != target.loc)

				var/list/path = getPathTo(loc, target.loc)
				if(!path) break

				for(var/turf/t in path)
					if(!loc) break
					dir = get_dir(loc, t)
					loc = t
					sleep(1)

				if(loc == target.loc || !loc) break

				var/obj/teleport/o = locate() in orange(1, loc)
				if(o)
					var/turf/d = locate(o.dest)
					loc = d
				else break

			loc = null


hudobj/secretSanta

	anchor_x   = "CENTER"
	anchor_y   = "CENTER"

	mouse_over_pointer = MOUSE_HAND_POINTER

	icon = 'present.dmi'
	icon_state = "gift"

//	icon = 'Eggs.dmi'
//	icon_state = "1"

	var/tmp
		canClick = FALSE
		mob/Player/player

	MouseEntered()
		if(alpha == 255) transform = matrix()*9
	MouseExited()
		if(alpha == 255) transform = matrix()*8

	New(loc=null,client/Client,list/Params,show=1,Player=null)
		..(loc,Client,Params,show)
		player = Player

		icon_state = "[rand(1,16)]"

		var/obj/o = new /obj/custom { appearance_flags = RESET_TRANSFORM; maptext_y = -120; maptext_x = -112; maptext_width = 256; maptext_height = 48; plane = 2 }

		o.maptext = "<b style=\"text-align:center;color:[player.mapTextColor];\">What's this? A gift? Open it!</b>"
		overlays += o


	show()
		set waitfor = 0
		updatePos()
		client.screen += src

		alpha = 0
		animate(src, alpha = 32, transform = turn(matrix()*2, 90), time = 2)
		animate(alpha = 64,  transform = turn(matrix()*2.5, 180), time = 2)
		animate(alpha = 96,  transform = turn(matrix()*3, 270), time = 2)
		animate(alpha = 128, transform = matrix()*4, time = 2)
		animate(alpha = 160, transform = turn(matrix()*5, 90), time = 2)
		animate(alpha = 192, transform = turn(matrix()*6, 180), time = 2)
		animate(alpha = 224, transform = turn(matrix()*7, 270), time = 2)
		animate(alpha = 255, transform = matrix()*8, time = 2)

		sleep(8)
		canClick = TRUE

	Click()
		if(canClick && alpha == 255)
			canClick = FALSE
			hide()

			sleep(2)

			emit(loc    = client,
				 ptype  = /obj/particle/magic,
				 amount = 80,
				 angle  = new /Random(1, 359),
				 speed  = 1,
				 life   = new /Random(40,80))

			if(!worldData.secretSanta)
				worldData.secretSanta = list()

			if(client.connection == "web")
				worldData.secretSanta[client.address] = client.ckey
			else
				worldData.secretSanta[client.computer_id] = client.ckey

			worldData.secretSanta[client.ckey] = 1


			var/prize = pickweight(list(/obj/items/key/basic_key                 = 10,
						                /obj/items/key/wizard_key                = 10,
						                /obj/items/key/winter_key                = 10,
						                /obj/items/key/pentakill_key             = 10,
						                /obj/items/key/sunset_key                = 10,
				                        /obj/items/key/community_key             = 10,
				                        /obj/items/chest/basic_chest             = 10,
						                /obj/items/chest/wizard_chest            = 10,
						                /obj/items/chest/winter_chest            = 10,
						                /obj/items/chest/pentakill_chest         = 10,
						                /obj/items/chest/sunset_chest            = 10,
						                /obj/items/chest/community1_chest        = 10,
						                /obj/items/artifact                      = 8,
						                /obj/items/crystal/soul                  = 8,
						                /obj/items/wearable/orb/peace            = 8,
						                /obj/items/wearable/orb/chaos            = 8,
						                /obj/items/lamps/double_drop_rate_lamp   = 9,
						                /obj/items/lamps/double_gold_lamp        = 9,
						                /obj/items/lamps/double_exp_lamp         = 9,
						                /obj/items/lamps/triple_drop_rate_lamp   = 8,
						                /obj/items/lamps/triple_gold_lamp        = 8,
						                /obj/items/lamps/triple_exp_lamp         = 8,
						                /obj/items/lamps/quadaple_drop_rate_lamp = 7,
						                /obj/items/lamps/quadaple_gold_lamp      = 7,
						                /obj/items/lamps/quadaple_exp_lamp       = 7))

			rewardItem(prize)

	proc/rewardItem(item)
		set waitfor = 0

		var/obj/items/i = new item (player)

		player << infomsg("[i.name] magically appeared in your pocket.")

		var/obj/o = new
		o.appearance = i.appearance
		o.appearance_flags |= PIXEL_SCALE
		o.plane = 2
		o.mouse_over_pointer = MOUSE_INACTIVE_POINTER
		o.screen_loc = "CENTER,CENTER"

		client.screen += o

		o.alpha = 0
		var/ox = rand(-128,128)
		var/oy = rand(-128,128)

		var/matrix/m1 = matrix()*6
		var/matrix/m2 = matrix()*8

		m1.Translate(ox, oy)
		m2.Translate(ox * 1.25, oy * 1.25)

		animate(o, transform = m1, alpha = 255, time = 12)
		animate(transform = m2, alpha = 0, time = 4)

		sleep(17)
		if(client)
			client.screen -= o

obj/items/treasure/gift
	icon = 'present.dmi'
	icon_state = "gift"

	event = "Gift"



obj
	clock

		Curse_Clock

			New()
				..()

				setTime(60, 0)

				spawn()
					while(src)
						if(countdown())
							snowCurse = !snowCurse

							for(var/mob/Player/p in Players)
								flick("transfigure",p)
								p.trnsed = 0
								p.BaseIcon()
								p.ApplyOverlays()

							setTime(snowCurse ? 30 : 60, 0)

						sleep(10)

obj
	snow_counter
		var/count     = 2000
		var/marks     = 0
		maptext_width = 64
		pixel_x       = 8

		New()
			..()
			tag = "SnowCounter"
			updateDisplay()

		proc
			add(c = 1)
				count -= snowCurse ? c * 2 : c
				if(count <= 0)
					count = 2000
					marks++
					. = 1
				updateDisplay()

			updateDisplay()
				if(count >= 100)
					pixel_x = -5
				else if(count >= 10)
					pixel_x = -4
				else
					pixel_x = 8

				maptext = "<b><span style=\"font-size:4; color:#FF4500;\">[count]</span></b>"


mob/Enemies/Summoned/Boss/Snowman/Super

	name = "The Super Evil Snowman"
	HPmodifier  = 25
	DMGmodifier = 2
	Range = 21
	level = 3000

	prizePoolSize = 4
	damageReq     = 20

	drops = list(/obj/items/key/master_key,
				 /obj/items/chest/legendary_golden_chest,
				 /obj/items/wearable/orb/peace/greater,
				 /obj/items/wearable/orb/chaos/greater,
				 /obj/items/chest/winter_chest/limited_edition,
				 /obj/items/lamps/sextuple_drop_rate_lamp,
				 /obj/items/lamps/sextuple_gold_lamp,
				 /obj/items/lamps/sextuple_exp_lamp)


	Death(mob/Player/killer)
		Players << infomsg("<b>The Super Evil Snowman was killed by [killer.name]</b>")
		..()

	var/tmp/cow = 0

	Attack()
		..()

		if(target && !cow)
			cow = 1
			spawn(10)
				cow = 0

			var/obj/boss/death/d = new (target.loc, src, pick(5,7,9))
			d.density = 1
			for(var/i = 1 to rand(1,5))
				step_away(d, src)
			d.density = 0

	Attacked(obj/projectile/p)
		if(p.element == FIRE)
			..()
			emit(loc    = src,
				 ptype  = /obj/particle/red,
			     amount = 4,
			     angle  = new /Random(1, 359),
			     speed  = 2,
			     life   = new /Random(15,20))

			if(p.owner)

				if(prob(20))
					animate(p.owner.client, color=rgb(rand(40, 200), rand(20, 220), rand(60, 180)), time=10, loop = 2)

					for(var/c = 1 to 4)
						animate(color=rgb(rand(20, 180), rand(40, 200), rand(60, 220)), time=10)

					animate(color=null, time=10)
				if(prob(30))
					var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
					var/dmg = round(Dmg * 1.5 + rand(-4,8))
					for(var/d in dirs)
						castproj(icon_state = "snowball", damage = dmg, name = "snowball", cd = 0, lag = 1, Dir=d)

		else
			emit(loc    = src,
				 ptype  = /obj/particle/green,
			     amount = 4,
			     angle  = new /Random(1, 359),
			     speed  = 2,
			     life   = new /Random(15,20))

	New()
		..()

		alpha = rand(190,255)

		var/color1 = rgb(rand(40, 255), rand(20, 255), rand(60, 255))
		var/color2 = rgb(rand(40, 255), rand(20, 255), rand(60, 255))
		var/color3 = rgb(rand(40, 255), rand(20, 255), rand(60, 255))
		var/color4 = rgb(rand(40, 255), rand(20, 255), rand(60, 255))

		animate(src, color = color1, time = 10, loop = -1)
		animate(color = color2, time = 10)
		animate(color = color3, time = 10)
		animate(color = color4, time = 10)
