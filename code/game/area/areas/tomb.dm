// Areas for the tomb
// Copied from other areas but they all have the "Tomb of Matthios" name
// The only real difference is audio

/area/rogue/under/tomb
	name = "Tomb of Matthios"
	icon_state = "basement"
	first_time_text = "THE TOMB OF MATTHIOS"
	soundenv = 5
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/under/tomb/indoors
	icon_state = "indoors"

// Some nice sounds for rest areas
/area/rogue/under/tomb/indoors/rest
	icon_state = "shelter"
	ambientsounds = AMB_TOWNDAY
	ambientnight = AMB_TOWNNIGHT
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'

/area/rogue/under/tomb/indoors/magic
	icon_state = "magician"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/magiciantower og mix.ogg'

/area/rogue/under/tomb/indoors/royal
	icon_state = "manor"
	droning_sound = 'sound/music/area/manor2.ogg'

/area/rogue/under/tomb/indoors/church
	icon_state = "church"
	droning_sound = 'sound/music/area/churchnight.ogg'

/area/rogue/under/tomb/wilds
	icon_state = "woods"
	soundenv = 15
	ambientsounds = AMB_FORESTDAY
	ambientnight = AMB_FORESTNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_FOREST
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/forestnight.ogg'

/area/rogue/under/tomb/wilds/ambush

/area/rogue/under/tomb/wilds/bog
	icon_state = "bog"
	ambientsounds = AMB_BOGDAY
	ambientnight = AMB_BOGNIGHT
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/under/tomb/sewer
	icon_state = "sewer"
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_RATS
	spookynight = SPOOKY_RATS
	droning_sound = 'sound/music/area/sewers.ogg'

/area/rogue/under/tomb/lake
	icon_state = "lake"
	ambientsounds = AMB_BEACH
	ambientnight = AMB_BEACH
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_GEN

/area/rogue/under/tomb/cave
	icon_state = "cave"
	soundenv = 8
	ambientsounds = AMB_GENCAVE
	ambientnight = AMB_GENCAVE
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/caves.ogg'

/area/rogue/under/tomb/cave/lava
	icon_state = "cavelava"
	ambientsounds = AMB_CAVELAVA
	ambientnight = AMB_CAVELAVA
	droning_sound = 'sound/music/area/decap.ogg'

/area/rogue/under/tomb/cave/wet
	icon_state = "cavewet"
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER

/area/rogue/under/tomb/cave/spider
	icon_state = "spider"
	droning_sound = 'sound/music/area/spidercave.ogg'
