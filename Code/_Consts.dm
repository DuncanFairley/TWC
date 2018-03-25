/*
 * Copyright © 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */

#define DEBUG 1
#define TICK_LAG 1
#define islist(x) istype(x,/list)
#define floor(x) round(x)
#define ceil(x) (-round(-(x)))
#define isplayer(x) istype(x, /mob/Player)
#define ismonster(x) istype(x, /mob/Enemies)
#define SetSize(s) transform = matrix() * ((s) / iconSize)
#define clamp(n, low, high) min(max((n), low), high)
#define winshowCenter(player, window) player << output(window,"browser1:ShowCenterWindow")

#define VERSION "16.69"
#define SAVEFILE_VERSION 30
#define VAULT_VERSION 5
#define lvlcap 800
#define SWAPMAP_Z 25 // world map z + 1 (the +1 is for buildable area, don't add if not using sandbox)
#define WINTER 0
#define AUTUMN 1
#define HALLOWEEN 0
#define NIGHTCOLOR "#6464d0"
#define TELENDEVOUR_COLOR "#64d0d0"
#define MAGICEYE_COLOR "#9df"

#define PET_LIGHT 1
#define PET_FOLLOW_FAR 2
#define PET_FOLLOW_RIGHT 4
#define PET_FOLLOW_LEFT 8
#define PET_SHINY 128
#define PET_FLY 256
#define SHINY_LIST list("#dd1111", "#11dd11", "#1111dd", "#dd11dd", "#11dddd", "#dddd11")
#define MAX_PET_LEVEL 30
#define MAX_PET_EXP(pet) ((pet.quality + 1) * 20000)

#define MAX_WAND_LEVEL 30
#define MAX_WAND_EXP(wand) ((wand.quality + 1) * 20000)

#define POTIONS_AMOUNT 37


#define EARTH 1
#define FIRE  2
#define WATER 4
#define GHOST 8

#define SWAMP  1
#define SHIELD 2

#define DIRS_LIST list(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)

#define WORN 1
#define REMOVED 2


#if HALLOWEEN
WorldData/var/tmp/list/waterColors = list()
#endif

obj/custom // used for defining custom objects with { } constructor

client
	fps = 30
	glide_size = 32

mob/Player
	glide_size = 32


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
	var/post_init = 0

	New()
		if(map_initialized)
			post_init && MapInit()
		else if(post_init)
			__post_init[src] = 1
		..()

	proc/MapInit()