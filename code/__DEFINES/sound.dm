//max channel is 1024. Only go lower from here, because byond tends to pick the first availiable channel to play sounds on
#define CHANNEL_LOBBYMUSIC 1024
#define CHANNEL_ADMIN 1023 //USED FOR MUSIC
#define CHANNEL_VOX 1022
#define CHANNEL_JUKEBOX 1021
#define CHANNEL_JUSTICAR_ARK 1020
#define CHANNEL_HEARTBEAT 1019 //sound channel for heartbeats
/// Ambient sounds
#define CHANNEL_AMBIENCE 1018
/// Ambient background music or droning
#define CHANNEL_BUZZ 1017
#define CHANNEL_CHARGED_SPELL 1016
#define CHANNEL_RAIN 1015
#define CHANNEL_MUSIC 1014
#define CHANNEL_CMUSIC 1013
#define CHANNEL_WEATHER 1012
#define CHANNEL_IMSICK 1011

//THIS SHOULD ALWAYS BE THE LOWEST ONE!
//KEEP IT UPDATED

#define CHANNEL_HIGHEST_AVAILABLE 1011

/// This is the lowest volume that can be used by playsound otherwise it gets ignored
/// Most sounds around 10 volume can barely be heard. Almost all sounds at 5 volume or below are inaudible
/// This is to prevent sound being spammed at really low volumes due to distance calculations
/// Recommend setting this to anywhere from 10-3 (or 0 to disable any sound minimum volume restrictions)
/// Ex. For a 70 volume sound, 17 tile range, 3 exponent, 2 falloff_distance:
/// Setting SOUND_AUDIBLE_VOLUME_MIN to 0 for the above will result in 17x17 radius (289 turfs)
/// Setting SOUND_AUDIBLE_VOLUME_MIN to 5 for the above will result in 14x14 radius (196 turfs)
/// Setting SOUND_AUDIBLE_VOLUME_MIN to 10 for the above will result in 11x11 radius (121 turfs)
#define SOUND_AUDIBLE_VOLUME_MIN 3

/* Calculates the max distance of a sound based on audible volume
 *
 * Note - you should NEVER pass in a volume that is lower than SOUND_AUDIBLE_VOLUME_MIN otherwise distance will be insanely large (like +250,000)
 *
 * Arguments:
 * * volume: The initial volume of the sound being played
 * * max_distance: The range of the sound in tiles (technically not real max distance since the furthest areas gets pruned due to SOUND_AUDIBLE_VOLUME_MIN)
 * * falloff_distance: Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 * * falloff_exponent: Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * Returns: The max distance of a sound based on audible volume range
 */
#define CALCULATE_MAX_SOUND_AUDIBLE_DISTANCE(volume, max_distance, falloff_distance, falloff_exponent)\
	floor(((((-(max(max_distance - falloff_distance, 0) ** (1 / falloff_exponent)) / volume) * (SOUND_AUDIBLE_VOLUME_MIN - volume)) ** falloff_exponent) + falloff_distance))

/* Calculates the volume of a sound based on distance
 *
 * https://www.desmos.com/calculator/sqdfl8ipgf
 *
 * Arguments:
 * * volume: The initial volume of the sound being played
 * * distance: How far away the sound is in tiles from the source
 * * falloff_distance: Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 * * falloff_exponent: Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * Returns: The max distance of a sound based on audible volume range
 */
#define CALCULATE_SOUND_VOLUME(volume, distance, max_distance, falloff_distance, falloff_exponent)\
	((max(distance - falloff_distance, 0) ** (1 / falloff_exponent)) / ((max(max_distance, distance) - falloff_distance) ** (1 / falloff_exponent)) * volume)

///Default range of a sound.
#define SOUND_RANGE 17
#define MEDIUM_RANGE_SOUND_EXTRARANGE -5
///default extra range for sounds considered to be quieter
#define SHORT_RANGE_SOUND_EXTRARANGE -9
///The range deducted from sound range for things that are considered silent / sneaky
#define SILENCED_SOUND_EXTRARANGE -11
///Percentage of sound's range where no falloff is applied
#define SOUND_DEFAULT_FALLOFF_DISTANCE 1 //For a normal sound this would be 1 tile of no falloff
///The default exponent of sound falloff
#define SOUND_FALLOFF_EXPONENT 6

#define SOUND_MINIMUM_PRESSURE 10

#define SFX_SPARKS "sparks"
#define SFX_CHAIN_STEP	"chain_step"
#define SFX_PLATE_STEP	"plate_step"
#define SFX_PLATE_COAT_STEP	"plate_coat_step"
#define SFX_JINGLE_BELLS	"jingle_bells"
#define SFX_INQUIS_BOOT_STEP	"inquis_boot_step"
#define SFX_POWER_ARMOR_STEP	"power_armor_step"
#define SFX_WATCH_BOOT_STEP	"watch_boot_step"
#define SFX_CAT_MEOW "cat_meow"
#define SFX_CAT_PURR "cat_purr"
#define SFX_EGG_HATCHING "egg_hatching"
#define SFX_DEFAULT_FISH_SLAP "default_fish_slap"
#define SFX_ALT_FISH_SLAP "alt_fish_slap"
#define SFX_REEL "reel"

#define INTERACTION_SOUND_RANGE_MODIFIER 0
#define EQUIP_SOUND_VOLUME 100
#define PICKUP_SOUND_VOLUME 100
#define DROP_SOUND_VOLUME 100
#define YEET_SOUND_VOLUME 100

// Droning ambient loops

#define DRONING_TOWN_DAY "town_day"
#define DRONING_TOWN_NIGHT "town_night"
#define DRONING_FOREST_DAY "forest_day"
#define DRONING_FOREST_NIGHT "forest_night"
#define DRONING_MOUNT_DAY "mountain_day"
#define DRONING_MOUNT_NIGHT "mount_night"
#define DRONING_BOG_DAY "bog_day"
#define DRONING_BOG_NIGHT "bog_night"
#define DRONING_JUNGLE_DAY "jungle_day"
#define DRONING_JUNGLE_NIGHT "jungle_night"
#define DRONING_RIVER_DAY "river_day"
#define DRONING_RIVER_NIGHT "river_night"

#define DRONING_INDOORS "indoors"
#define DRONING_BASEMENT "basement"
#define DRONING_MOUNTAIN "mountain"
#define DRONING_LAKE "lake"
#define DRONING_BOAT "boat"

#define DRONING_RAIN_IN "rain_in"
#define DRONING_RAIN_OUT "rain_out"
#define DRONING_RAIN_SEWER "rain_sewer"

#define DRONING_CAVE_GENERIC "cave_generic"
#define DRONING_CAVE_WET "cave_wet"
#define DRONING_CAVE_LAVA "cave_lava"

// Ambient sounds handled by SSambience

#define AMBIENCE_GENERIC "spooky_generic"
#define AMBIENCE_CAVE "spooky_cave"
#define AMBIENCE_FOREST "spooky_forest"
#define AMBIENCE_DUNGEON "spooky_dungeon"
#define AMBIENCE_RAT "spooky_ray"
#define AMBIENCE_FROG "spooky_frog"
#define AMBIENCE_BIRDS "spooky_birds"
#define AMBIENCE_MYSTICAL "spooky_mystic"
