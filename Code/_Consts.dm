#define TICK_LAG 1
#define floor(x) round(x)
#define ceil(x) (-round(-(x)))
#define isplayer(x) istype(x, /mob/Player)
#define ismonster(x) istype(x, /mob/Enemies)
#define ismovable(x) istype(x, /atom/movable)
#define SetSize(s) transform = matrix() * ((s) / iconSize)
#define winshowCenter(player, window) player << output(window,"browser1:ShowCenterWindow")
#define winshowRight(player, window) player << output(window,"browser1:ShowRightWindow")

#define VERSION "16.77"
#define SUB_VERSION "0"
#define SAVEFILE_VERSION 48
#define VAULT_VERSION 8
#define WORLD_VERSION 1
#define lvlcap 800
#define SWAPMAP_Z 22 // world map z + 1 (the +1 is for buildable area, don't add if not using sandbox)
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
#define RING_ALCHEMY 32
#define RING_CLOWN 64
#define RING_FAIRY 128
#define RING_NINJA 256
#define RING_10 512
#define RING_11 1024
#define RING_12 2048
#define RING_13 4096
#define RING_14 8192
#define RING_15 16384
#define RING_DUAL_SHIELD 32768

#define SHIELD_ALCHEMY 1
#define SHIELD_NINJA 2
#define SHIELD_3 4
#define SHIELD_4 8
#define SHIELD_5 16
#define SHIELD_MP 32
#define SHIELD_CLOWN 64
#define SHIELD_MPDAMAGE 128
#define SHIELD_GOLD 256
#define SHIELD_10 512
#define SHIELD_11 1024
#define SHIELD_12 2048
#define SHIELD_13 4096
#define SHIELD_14 8192
#define SHIELD_15 16384
#define SHIELD_16 32768

#define SWORD_MANA 1
#define SWORD_ALCHEMY 2
#define SWORD_NINJA 4
#define SWORD_4 8
#define SWORD_5 16
#define SWORD_6 32
#define SWORD_CLOWN 64
#define SWORD_8 128
#define SWORD_9 256
#define SWORD_EXPLODE 512
#define SWORD_FIRE 1024
#define SWORD_HEALONKILL 2048
#define SWORD_ANIMAGUS 4096
#define SWORD_GHOST 8192
#define SWORD_SNAKE 16384
#define SWORD_16 32768

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



WorldData/var/tmp/baseChance = 0.016




