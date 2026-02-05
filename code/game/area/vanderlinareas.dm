// Malum's Anvil Areas

/area/under/mountains/anvil
	name = "malum's anvil generic under (don't use)"
	icon_state = "rogue"
	droning_index = DRONING_MOUNTAIN
	ambient_index = AMBIENCE_GENERIC
	background_track = 'sound/music/area/townstreets.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/outdoors/mountains/anvil/snowy
	soundenv = 8
	plane = INDOOR_PLANE

/area/under/mountains/anvil/lower
	name = "malum's anvil under lower caves"
	icon_state = "lowercavemalum"
	first_time_text = "MALUM'S ANVIL"
	ambush_types = list(
				/turf/open/floor/dirt,
				/turf/open/floor/cobblerock)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/mole = 40,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 30,
				/mob/living/carbon/human/species/rousman/ambush = 30,
				/mob/living/carbon/human/species/orc/ambush = 20,
				/mob/living/simple_animal/hostile/retaliate/troll/cave = 10)

/area/under/mountains/anvil/upper
	name = "malum's anvil under upper caves"
	icon_state = "uppercavemalum"
	ambush_types = list(
				/turf/open/floor/naturalstone)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/mole = 60,
				/mob/living/carbon/human/species/rousman/ambush = 20,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 30,
				/mob/living/simple_animal/hostile/retaliate/troll/cave = 5)

/area/under/mountains/anvil/lower/building
	name = "malum's anvil cave building"
	icon_state = "cavebuildingmalum"
	first_time_text = null
	ambush_types = null
	ambush_mobs = null

/area/under/mountains/anvil/dungeon
	name = "malum's anvil upper dungeon"
	icon_state = "dungeonupper"

/area/under/mountains/anvil/dungeon/can_craft_here()
	return FALSE

/area/under/mountains/anvil/dungeon/lower
	name = "malum's anvil lower dungeon"
	icon_state = "dungeonlower"

/area/under/mountains/anvil/dungeon/lower/can_craft_here()
	return FALSE

/area/outdoors/mountains/anvil
	name = "malum's anvil generic outdoors (don't use)"
	icon_state = "rogue"
	outdoors = TRUE
	droning_index = DRONING_TOWN_DAY
	droning_index_night = DRONING_TOWN_NIGHT
	ambient_index = AMBIENCE_BIRDS
	ambient_index_night = AMBIENCE_GENERIC
	background_track = 'sound/music/area/townstreets.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/indoors/shelter

/area/outdoors/mountains/anvil/peak
	name = "malum's anvil peak"
	icon_state = "anvilpeakmalum"
	background_track = 'sound/music/area/decap.ogg'
	background_track_dusk = null
	background_track_night = null
	first_time_text = "THE PEAK OF MALUM'S ANVIL"

/area/outdoors/mountains/anvil/snowy
	name = "malum's anvil snow"
	icon_state = "snowypeakmalum"
	background_track = 'sound/music/area/decap.ogg'
	background_track_dusk = null
	background_track_night = null

/area/outdoors/mountains/anvil/snowyforest
	name = "malum's anvil forest"
	icon_state = "snowyforestmalum"
	background_track = 'sound/music/area/decap.ogg'
	background_track_dusk = null
	background_track_night = null
	ambush_types = list(
				/turf/open/floor/grass/cold,
				/turf/open/floor/snow/patchy)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/wolf = 40,
				/mob/living/carbon/human/species/goblin/npc/ambush = 30,
				/mob/living/carbon/human/species/rousman/ambush = 20,
				/mob/living/carbon/human/species/orc/ambush = 20)

/area/outdoors/mountains/anvil/castle
	name = "malum's anvil castle"
	icon_state = "castlemalum"
	background_track = 'sound/music/area/decap.ogg'
	background_track_dusk = null
	background_track_night = null
	ambush_types = list(
				/turf/open/floor/cobblerock)
	ambush_mobs = list(
				/mob/living/carbon/human/species/goblin/npc/ambush = 30,
				/mob/living/carbon/human/species/rousman/ambush = 20,
				/mob/living/carbon/human/species/orc/ambush = 20)

/area/outdoors/mountains/anvil/grove
	name = "malum's anvil hidden grove"
	icon_state = "grovemalum"
	ambush_types = list(
				/turf/open/floor/dirt,
				/turf/open/floor/grass)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/wolf = 10)

/area/outdoors/mountains/anvil/lavaexposed
	name = "malum's anvil exposed lava" // Mostly exists so lava exposed to the sky will act like it is
	icon_state = "exposedlavamalum"

/area/indoors/mountains/anvil
	name = "malum's anvil generic indoors (don't use)"
	icon_state = "indoors"
	droning_index = DRONING_INDOORS
	ambient_index = AMBIENCE_GENERIC
	background_track = 'sound/music/area/indoor.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'
	plane = INDOOR_PLANE
	converted_type = /area/outdoors/mountains/anvil/snowy

/area/indoors/mountains/anvil/surface
	name = null
	icon_state = null

/area/indoors/mountains/anvil/surface/building
	name = "malum's anvil surface building"
	icon_state = "surfacebuildingmalum"
