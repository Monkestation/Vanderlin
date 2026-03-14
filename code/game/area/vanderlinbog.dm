/area/outdoors/bog
	name = "the bog"
	icon = 'icons/turf/areas/bog.dmi'
	icon_state = "bog"
	droning_index = DRONING_BOG_DAY
	droning_index_night = DRONING_BOG_NIGHT
	ambient_index = AMBIENCE_FROG
	ambient_index_night = AMBIENCE_GENERIC
	background_track = 'sound/music/area/bog.ogg'
	background_track_dusk = null
	background_track_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_types = list(
				/turf/open/floor/dirt,
				/turf/open/water)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/bigrat = 20,
				/mob/living/simple_animal/hostile/retaliate/spider = 80,
				/mob/living/carbon/human/species/goblin/npc/ambush/sea = 50,
				/mob/living/simple_animal/hostile/retaliate/troll/bog = 35,
				new /datum/ambush_config/bog_guard_deserters = 50,
				new /datum/ambush_config/bog_guard_deserters/hard = 25,
				new /datum/ambush_config/mirespiders_ambush = 110,
				new /datum/ambush_config/mirespiders_crawlers = 25,
				new /datum/ambush_config/mirespiders_aragn = 10,
				new /datum/ambush_config/mirespiders_unfair = 5)

	first_time_text = "THE TERRORBOG"
	custom_area_sound = 'sound/misc/stings/BogSting.ogg'
	converted_type = /area/indoors/shelter/bog
	threat_region = THREAT_REGION_TERRORBOG

/area/indoors/shelter/bog
	name = "bog dwelling"
	icon = 'icons/turf/areas/bog.dmi'
	icon_state = "bog_indoors"
	background_track = 'sound/music/area/bog.ogg'
	background_track_dusk = null
	background_track_night = null

// ###############
/area/outdoors/bog/e_highroad
	name = "the eastern highroad"
	first_time_text = "THE EASTERN HIGHROAD"
	custom_area_sound = 'sound/misc/stings/RosewoodSting.ogg'

/area/indoors/shelter/bog/e_highroad_camp
	name = "the eastern highroad camp"

// ###############
/area/outdoors/bog/w_highroad
	name = "the western highroad"
	first_time_text = "THE WESTERN HIGHROAD"
	custom_area_sound = 'sound/misc/stings/RosewoodSting.ogg'

// ###############
/area/outdoors/bog/witch
	name = "bog witch's isle"
	icon_state = "bog_witch"
	first_time_text = "Bog Witch's Hut"

/area/indoors/shelter/bog/witch
	name = "bog witch's hut"
	icon_state = "bog_witch_indoors"

// ###############
/area/outdoors/bog/lich
	name = "Dark Tower"
	icon_state = "lichtower"
	first_time_text = "Dark Tower"

/area/indoors/shelter/bog/lich
	name = "Dark Tower"
	icon_state = "lichtower_indoors"

// ###############
/area/outdoors/bog/central
	name = "Central Terrorbog"

/area/outdoors/bog/east
	icon_state = "bog_east"
	name = "Eastern Terrorbog"

/area/outdoors/bog/west
	icon_state = "bog_west"
	name = "Western Terrorbog"

// ###############
/area/outdoors/bog/north
	name = "Northern Terrorbog"

/area/outdoors/bog/north/east
	icon_state = "bog_east"
	name = "North-Eastern Terrorbog"

/area/outdoors/bog/north/west
	icon_state = "bog_west"
	name = "North-Western Terrorbog"

// ###############
/area/outdoors/bog/south
	name = "Southern Terrorbog"

/area/outdoors/bog/south/east
	icon_state = "bog_east"
	name = "South-Eastern Terrorbog"

/area/outdoors/bog/south/west
	icon_state = "bog_west"
	name = "South-Western Terrorbog"

// ###############
/area/outdoors/bog/beach
	name = "Terrorbog Coast"
	icon_state = "bog_beach"
	first_time_text = "THE TERRORBOG COAST"

/area/outdoors/bog/beach/east
	name = "Eastern Terrorbog Coast"

/area/outdoors/bog/beach/west
	name = "Western Terrorbog Coast"
