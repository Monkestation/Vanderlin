//======== Regular

GLOBAL_LIST_INIT(ambience_town_day, list('sound/ambience/townday.ogg'))
GLOBAL_LIST_INIT(ambience_town_night, list(
	'sound/ambience/townnight (1).ogg',
	'sound/ambience/townnight (2).ogg',
	'sound/ambience/townnight (3).ogg',
))

GLOBAL_LIST_INIT(ambience_forest_day, list('sound/ambience/forestday.ogg'))
GLOBAL_LIST_INIT(ambience_forest_night, list('sound/ambience/forestnight.ogg'))

GLOBAL_LIST_INIT(ambience_bog_day, list(
	'sound/ambience/bogday (1).ogg',
	'sound/ambience/bogday (2).ogg',
	'sound/ambience/bogday (3).ogg',
))
GLOBAL_LIST_INIT(ambience_bog_night, list('sound/ambience/bognight.ogg'))

GLOBAL_LIST_INIT(ambience_jungle_day, list('sound/ambience/jungleday.ogg'))
GLOBAL_LIST_INIT(ambience_jungle_night, list('sound/ambience/junglenight.ogg'))

GLOBAL_LIST_INIT(ambience_river_day, list(
	'sound/ambience/riverday (1).ogg',
	'sound/ambience/riverday (2).ogg',
	'sound/ambience/riverday (3).ogg',
))
GLOBAL_LIST_INIT(ambience_river_night, list(
	'sound/ambience/rivernight (1).ogg',
	'sound/ambience/rivernight (2).ogg',
	'sound/ambience/rivernight (3).ogg',
))

GLOBAL_LIST_INIT(ambience_indoors, list('sound/ambience/indoorgen.ogg'))
GLOBAL_LIST_INIT(ambience_basement, list('sound/ambience/basement.ogg'))

GLOBAL_LIST_INIT(ambience_mountain, list(
	'sound/ambience/MOUNTAIN (1).ogg',
	'sound/ambience/MOUNTAIN (2).ogg',
))

GLOBAL_LIST_INIT(ambience_lake, list(
	'sound/ambience/lake (1).ogg',
	'sound/ambience/lake (2).ogg',
	'sound/ambience/lake (3).ogg',
))

GLOBAL_LIST_INIT(ambience_boat, list(
	'sound/ambience/boat (1).ogg',
	'sound/ambience/boat (2).ogg',
))

GLOBAL_LIST_INIT(ambience_rain_indoors, list('sound/ambience/rainin.ogg'))
GLOBAL_LIST_INIT(ambience_rain_outdoors, list('sound/ambience/rainout.ogg'))
GLOBAL_LIST_INIT(ambience_rain_sewer, list('sound/ambience/rainsewer.ogg'))

//======== Cave

GLOBAL_LIST_INIT(ambience_cave_generic, list('sound/ambience/cave.ogg'))
GLOBAL_LIST_INIT(ambience_cave_wet, list(
	'sound/ambience/cavewater (1).ogg',
	'sound/ambience/cavewater (2).ogg',
	'sound/ambience/cavewater (3).ogg'))
GLOBAL_LIST_INIT(ambience_cave_lava, list(
	'sound/ambience/cavelava (1).ogg',
	'sound/ambience/cavelava (2).ogg',
	'sound/ambience/cavelava (3).ogg',
))

//======== Spooky

GLOBAL_LIST_INIT(ambience_spooky_generic, list(
	'sound/ambience/noises/genspooky (1).ogg',
	'sound/ambience/noises/genspooky (2).ogg',
	'sound/ambience/noises/genspooky (3).ogg',
	'sound/ambience/noises/genspooky (4).ogg',
	'sound/ambience/noises/genspooky (5).ogg',
))

// Places

GLOBAL_LIST_INIT(ambience_spooky_cave, list(
	'sound/ambience/noises/cave (1).ogg',
	'sound/ambience/noises/cave (2).ogg',
	'sound/ambience/noises/cave (3).ogg',
))

GLOBAL_LIST_INIT(ambience_spooky_forest, list(
	'sound/ambience/noises/owl.ogg',
	'sound/ambience/noises/wolf (1).ogg',
	'sound/ambience/noises/wolf (2).ogg',
	'sound/ambience/noises/wolf (3).ogg',
))

GLOBAL_LIST_INIT(ambience_spooky_dungeon, list(
	'sound/ambience/noises/dungeon (1).ogg',
	'sound/ambience/noises/dungeon (2).ogg',
	'sound/ambience/noises/dungeon (3).ogg',
	'sound/ambience/noises/dungeon (4).ogg',
	'sound/ambience/noises/dungeon (5).ogg',
))

// Desert

GLOBAL_LIST_INIT(ambience_desert_day, list('sound/ambience/desertday.ogg'))
GLOBAL_LIST_INIT(ambience_desert_night, list('sound/ambience/desertnight.ogg'))

// Animals

GLOBAL_LIST_INIT(ambience_spooky_rat, list(
	'sound/ambience/noises/RAT1.ogg',
	'sound/ambience/noises/RAT2.ogg',
))

GLOBAL_LIST_INIT(ambience_spooky_frog, list(
	'sound/ambience/noises/frog (1).ogg',
	'sound/ambience/noises/frog (2).ogg',
))

GLOBAL_LIST_INIT(ambience_spooky_birds, list(
	'sound/ambience/noises/birds (1).ogg',
	'sound/ambience/noises/birds (1).ogg',
	'sound/ambience/noises/birds (3).ogg',
	'sound/ambience/noises/birds (4).ogg',
	'sound/ambience/noises/birds (5).ogg',
	'sound/ambience/noises/birds (6).ogg',
	'sound/ambience/noises/birds (7).ogg',
))

// Misc

GLOBAL_LIST_INIT(ambience_spooky_mystical, list(
	'sound/ambience/noises/mystical (1).ogg',
	'sound/ambience/noises/mystical (1).ogg',
	'sound/ambience/noises/mystical (3).ogg',
	'sound/ambience/noises/mystical (4).ogg',
	'sound/ambience/noises/mystical (5).ogg',
	'sound/ambience/noises/mystical (6).ogg',
))

/// Sound effects
GLOBAL_LIST_INIT(ambience_assoc_sounds, list(
	AMBIENCE_GENERIC = GLOB.ambience_spooky_generic,
	AMBIENCE_CAVE = GLOB.ambience_spooky_cave,
	AMBIENCE_FOREST = GLOB.ambience_spooky_forest,
	AMBIENCE_DUNGEON = GLOB.ambience_spooky_dungeon,
	AMBIENCE_RAT = GLOB.ambience_spooky_rat,
	AMBIENCE_FROG = GLOB.ambience_spooky_frog,
	AMBIENCE_BIRDS = GLOB.ambience_spooky_birds,
	AMBIENCE_MYSTICAL = GLOB.ambience_spooky_mystical,
))

/// Droning ambience
GLOBAL_LIST_INIT(ambience_assoc_droning, list(
	DRONING_TOWN_DAY = GLOB.ambience_town_day,
	DRONING_TOWN_NIGHT = GLOB.ambience_town_night,
	DRONING_FOREST_DAY = GLOB.ambience_forest_day,
	DRONING_FOREST_NIGHT = GLOB.ambience_forest_night,
	DRONING_BOG_DAY = GLOB.ambience_bog_day,
	DRONING_BOG_NIGHT = GLOB.ambience_bog_night,
	DRONING_JUNGLE_DAY = GLOB.ambience_jungle_day,
	DRONING_JUNGLE_NIGHT = GLOB.ambience_jungle_night,
	DRONING_RIVER_DAY = GLOB.ambience_river_day,
	DRONING_RIVER_NIGHT = GLOB.ambience_river_night,
	DRONING_INDOORS = GLOB.ambience_indoors,
	DRONING_BASEMENT = GLOB.ambience_basement,
	DRONING_MOUNTAIN = GLOB.ambience_mountain,
	DRONING_LAKE = GLOB.ambience_lake,
	DRONING_BOAT = GLOB.ambience_boat,
	DRONING_CAVE_GENERIC = GLOB.ambience_cave_generic,
	DRONING_CAVE_WET = GLOB.ambience_cave_wet,
	DRONING_CAVE_LAVA = GLOB.ambience_cave_lava,
	DRONING_RAIN_IN = GLOB.ambience_rain_indoors,
	DRONING_RAIN_OUT = GLOB.ambience_rain_outdoors,
	DRONING_RAIN_SEWER = GLOB.ambience_rain_sewer,
	DRONING_DESERT_DAY = GLOB.ambience_desert_day,
	DRONING_DESERT_NIGHT = GLOB.ambience_desert_night,
))
