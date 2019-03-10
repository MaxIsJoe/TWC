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

var/list/PageSounds = list('pageturn1.ogg',
	                     	'pageturn2.ogg',
	                     	'pageturn3.ogg')

var/list/FemaleCoughSounds = list('f_cougha.ogg',
	                     	'f_coughb.ogg')

var/list/MaleCoughSounds = list('m_cougha.ogg',
	                     	'm_coughb.ogg',
	                     	'm_coughc.ogg')

var/list/FemaleYawnSounds = list('female_yawn1.ogg',
	                     	'female_yawn2.ogg')

var/list/MaleYawnSounds = list('male_yawn1.ogg',
	                     	'male_yawn2.ogg')

var/list/claps = list('clap1.ogg',
	                  'clap2.ogg',
	                  'clap3.ogg',
	                  'clap4.ogg')

var/list/farts_sounds = list('fart.ogg',
	                  'fartingmountain.ogg',
	                  'fartmassive.ogg')

var/FemaleSneeze = 'f_sneeze.ogg'
var/MaleSneeze = 'm_sneeze.ogg'
var/ThroatclearMale = 'throatclear_male.ogg'
var/ThroatclearFemale = 'throatclear_female.ogg'
var/SighMale = 'sigh_male.ogg'
var/SighFemale = 'sigh_female.ogg'
var/ManLaugh = 'manlaugh.ogg'
var/WomenLaugh = 'womanlaugh.ogg'
var/FartEmote = 'fart.ogg'
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

