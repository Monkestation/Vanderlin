/area/outdoors/wilderness
	name = "wilderness"
	icon_state = "woods"
	droning_index = DRONING_FOREST_DAY
	droning_index_night = DRONING_FOREST_NIGHT
	ambient_index = AMBIENCE_BIRDS
	ambient_index_night = AMBIENCE_FOREST
	background_track = 'sound/music/area/forest.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/forestnight.ogg'
	soundenv = 15
	ambush_times = list("night","dawn","dusk","day")
	ambush_types = list(
				/turf/open/floor/grass)

	ambush_mobs = list(
		new /datum/ambush_config/wolf_pack = 15,
		new /datum/ambush_config/lone_troll = 10,
		new /datum/ambush_config/troll_and_wolves = 8,
		new /datum/ambush_config/goblin_ambush_party = 15,
		new /datum/ambush_config/goblin_raid_party = 8,
		new /datum/ambush_config/raccoon_swarm = 20,
		new /datum/ambush_config/mole_pack = 15,
		new /datum/ambush_config/deserter_patrol = 12,
		new /datum/ambush_config/highwayman_duo = 10,
		new /datum/ambush_config/highwayman_gang = 6,
		new /datum/ambush_config/mixed_wildlife = 15,
	)
	first_time_text = "THE MURDERWOOD"
	custom_area_sound = 'sound/misc/stings/ForestSting.ogg'
	converted_type = /area/indoors/shelter/woods
	threat_region = THREAT_REGION_OUTER_GROVE

/area/outdoors/wilderness/outpost
	icon_state = "outpost"
	threat_region = THREAT_REGION_NORTHERN_GROVE

/area/outdoors/wilderness/outpost/vanderlin
	name = "abandoned outpost"
	first_time_text = "Thatchwood Outpost"
	threat_region = THREAT_REGION_NORTHERN_GROVE

/area/outdoors/wilderness/outpost/salem
	name = "salem outpost"
	first_time_text = "Salem Outpost"

/area/indoors/wilderness
	name = "indoors - wilderness"
	icon_state = "indoorwild"

/area/indoors/wilderness/tavern
	name = "fermented cackleberry"
	icon_state = "tavern"
	first_time_text = "The Fermented Cackleberry"
	droning_index = DRONING_INDOORS
	droning_index_night = DRONING_INDOORS
	background_track = "sound/blank.ogg"
	background_track_dusk = "sound/blank.ogg"
	background_track_night = "sound/blank.ogg"
	converted_type = /area/outdoors/exposed/tavern

/area/indoors/wilderness/garrison
	name = "garrison"
	icon_state = "garrison"
	background_track = 'sound/music/area/manorgarri.ogg'
	background_track_dusk = null
	background_track_night = null
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/manorgarri

/area/indoors/wilderness/shop
	name = "shop"
	icon_state = "shop"
	background_track = 'sound/music/area/shop.ogg'
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/shop

/area/indoors/wilderness/magic
	name = "Wizard's Tower"
	icon = 'icons/turf/areas/manor.dmi'
	icon_state = "magiciantower"
	ambient_index = AMBIENCE_MYSTICAL
	background_track = 'sound/music/area/magiciantower.ogg'
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/magiciantower
