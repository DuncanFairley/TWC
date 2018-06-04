var/list/environments = list(
	"generic" = 0,
	"padded cell" = 1,
	"room" = 2,
	"bathroom" = 3,
	"livingroom" = 4,
	"stoneroom" = 5,
	"auditorium" = 6,
	"concert hall" = 7,
	"cave" = 8,
	"arena" = 9,
	"hangar" = 10,
	"carpetted hallway" = 11,
	"hallway" = 12,
	"stone corridor" = 13,
	"alley" = 14,
	"forest" = 15,
	"city" = 16,
	"mountains" = 17,
	"quarry" = 18,
	"plain" = 19,
	"parking lot" = 20,
	"sewer pipe" = 21,
	"underwater" = 22,
	"drugged" = 23,
	"dizzy" = 24,
	"psychotic" = 25,
		)

/*
var/sound_environment = 0
mob/verb/SetEnvironment(new_env as anything in environments)
	set hidden = 1
	if(!new_env)
		return
	sound_environment = environments[new_env]

mob/verb/SetSoundVolume(new_volume as num)
	set hidden = 1
	if(!new_volume)
		return
	src.client.sound_system.SetSoundVolume(min(max(new_volume, 0), 100))
	src << "Sound Volume: [src.client.sound_system.sound_volume]"
*/