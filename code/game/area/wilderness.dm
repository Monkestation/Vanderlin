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
				/mob/living/simple_animal/hostile/retaliate/wolf = 60,
				/mob/living/simple_animal/hostile/retaliate/troll/axe = 10,
				/mob/living/carbon/human/species/goblin/npc/ambush = 45,
				/mob/living/simple_animal/hostile/retaliate/mole = 25)
	first_time_text = "THE MURDERWOOD"
	custom_area_sound = 'sound/misc/stings/ForestSting.ogg'
	converted_type = /area/indoors/shelter/woods

/area/outdoors/wilderness/outpost
	name = "abandoned outpost"
	first_time_text = "ABANDONED OUTPOST"
	icon_state = "outpost"

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
