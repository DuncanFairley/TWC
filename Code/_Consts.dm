#define TICK_LAG 1
#define floor(x) round(x)
#define ceil(x) (-round(-(x)))
#define isplayer(x) istype(x, /mob/Player)
#define ismonster(x) istype(x, /mob/Enemies)
#define ismovable(x) istype(x, /atom/movable)
#define SetSize(s) transform = matrix() * ((s) / iconSize)
#define winshowCenter(player, window) player << output(window,"browser1:ShowCenterWindow")
#define winshowRight(player, window) player << output(window,"browser1:ShowRightWindow")

#define VERSION "16.76"
#define SUB_VERSION "2"
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

#define SWORD_EXPLODE 512
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
#define COW 32

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


