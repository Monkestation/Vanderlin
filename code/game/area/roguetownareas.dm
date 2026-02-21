/area
	name = "roguetown"
	icon_state = "rogue"

/area/indoors
	name = "indoors rt"
	icon_state = "indoors"
	droning_index = DRONING_INDOORS
	ambient_index = AMBIENCE_GENERIC
	background_track = 'sound/music/area/indoor.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'
	plane = INDOOR_PLANE
	converted_type = /area/outdoors

/area/indoors/cave
	name = "latejoin cave"
	icon_state = "cave"
	droning_index = DRONING_CAVE_GENERIC
	soundenv = 8

/area/indoors/cave/late/can_craft_here()
	return FALSE

///// OUTDOORS AREAS //////

/area/outdoors
	name = "outdoors roguetown"
	icon_state = "outdoors"
	outdoors = TRUE
	droning_index = DRONING_TOWN_DAY
	droning_index_night = DRONING_TOWN_NIGHT
	ambient_index = AMBIENCE_BIRDS
	ambient_index_night = AMBIENCE_GENERIC
	background_track = 'sound/music/area/townstreets.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/indoors/shelter

/area/indoors/shelter
	icon_state = "shelter"
	background_track = 'sound/music/area/townstreets.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'

/area/outdoors/mountains
	name = "mountains"
	icon_state = "mountains"
	droning_index = DRONING_MOUNTAIN
	ambient_index = AMBIENCE_GENERIC
	background_track = 'sound/music/area/townstreets.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'
	soundenv = 17
	converted_type = /area/indoors/shelter/mountains

/area/indoors/shelter/mountains
	icon_state = "mountains"
	background_track = 'sound/music/area/townstreets.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'

/area/outdoors/mountains/deception
	name = "deception"
	icon_state = "deception"
	first_time_text = "THE CANYON OF DECEPTION"
	ambush_types = list(
				/turf/open/floor/dirt)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/troll = 30,
				/mob/living/carbon/human/species/skeleton/npc/ambush = 30,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 60)

/area/outdoors/mountains/decap
	name = "mt decapitation"
	icon_state = "decap"
	ambush_types = list(
				/turf/open/floor/dirt)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/troll = 30,
				/mob/living/carbon/human/species/skeleton/npc/ambush = 90,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 20)
	background_track = 'sound/music/area/decap.ogg'
	background_track_dusk = null
	background_track_night = null
	first_time_text = "MALUMS ANVIL"
	custom_area_sound = 'sound/misc/stings/MalumSting.ogg'
	ambush_times = list("night","dawn","dusk","day")

	converted_type = /area/indoors/shelter/mountains/decap
/area/indoors/shelter/mountains/decap
	icon_state = "decap"
	background_track = 'sound/music/area/decap.ogg'
	background_track_dusk = null
	background_track_night = null

/area/outdoors/basin
	name = "town basin"
	icon_state = "basin"
	soundenv = 19
	ambush_times = list("night","dawn","dusk","day")
	ambush_types = list(
				/turf/open/floor/grass)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/wolf = 60,
				/mob/living/carbon/human/species/goblin/npc/ambush/hell = 50,
				/mob/living/carbon/human/species/goblin/npc/ambush/sea = 50,
				/mob/living/carbon/human/species/goblin/npc/ambush = 50)
	background_track = 'sound/music/area/field.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/indoors/shelter/basin

/area/outdoors/basin/Initialize()
	. = ..()
	first_time_text = "[uppertext(SSmapping.config.map_name)] BASIN"

/area/outdoors/basin/safe
	icon_state = "basin_safe"
	ambush_mobs = null

/area/indoors/shelter/basin
	icon_state = "basin"
	background_track = 'sound/music/area/field.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'

/area/indoors/shelter/woods
	icon_state = "woods"
	background_track = 'sound/music/area/forest.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/forestnight.ogg'

/area/outdoors/woods_safe
	name = "woods"
	icon_state = "woods"
	droning_index = DRONING_FOREST_DAY
	droning_index_night = DRONING_FOREST_NIGHT
	ambient_index = AMBIENCE_BIRDS
	ambient_index_night = AMBIENCE_FOREST
	background_track = 'sound/music/area/forest.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/forestnight.ogg'
	soundenv = 15
	converted_type = /area/indoors/shelter/woods

/area/outdoors/river
	name = "river"
	icon_state = "river"
	droning_index = DRONING_RIVER_DAY
	droning_index_night = DRONING_RIVER_NIGHT
	ambient_index = AMBIENCE_FROG
	ambient_index_night = AMBIENCE_FOREST
	background_track = 'sound/music/area/forest.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/forestnight.ogg'
	converted_type = /area/indoors/shelter/woods

/area/outdoors/bog
	name = "the bog"
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
				/mob/living/simple_animal/hostile/retaliate/troll/bog = 35)

	first_time_text = "THE TERRORBOG"
	custom_area_sound = 'sound/misc/stings/BogSting.ogg'
	converted_type = /area/indoors/shelter/bog

/area/indoors/shelter/bog
	icon_state = "bog"
	background_track = 'sound/music/area/bog.ogg'
	background_track_dusk = null
	background_track_night = null

/area/outdoors/beach
	name = "sophia's cry"
	icon_state = "beach"
	droning_index = DRONING_LAKE
	background_track = 'sound/music/area/townstreets.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'

/area/outdoors/eora
	name = "eoran grove"
	icon_state = "eora"
	droning_index = DRONING_FOREST_DAY
	background_track = 'sound/music/area/eora.ogg'
	background_track_dusk =  'sound/music/area/eora.ogg'
	background_track_night = 'sound/music/area/eora.ogg'

//// UNDER AREAS (no indoor rain sound usually)

// these don't get a rain sound because they're underground
/area/under
	name = "basement"
	icon_state = "under"
	background_track = 'sound/music/area/towngen.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'
	soundenv = 8
	plane = INDOOR_PLANE
	converted_type = /area/outdoors/exposed

/area/outdoors/exposed
	icon_state = "exposed"
	background_track = 'sound/music/area/towngen.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'

/area/under/cave
	name = "cave"
	icon_state = "cave"
	droning_index = DRONING_CAVE_GENERIC
	ambient_index = AMBIENCE_CAVE
	background_track = 'sound/music/area/caves.ogg'
	background_track_dusk = null
	background_track_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_types = list(
				/turf/open/floor/dirt)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/bigrat = 30,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 20,
				/mob/living/carbon/human/species/skeleton/npc/ambush = 10)
	converted_type = /area/outdoors/caves

/area/outdoors/caves
	icon_state = "caves"
	background_track = 'sound/music/area/caves.ogg'
	background_track_dusk = null
	background_track_night = null

/area/under/cavewet
	name = "cavewet"
	icon_state = "cavewet"
	droning_index = DRONING_CAVE_WET
	ambient_index = AMBIENCE_CAVE
	background_track = 'sound/music/area/caves.ogg'
	background_track_dusk = null
	background_track_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_types = list(
				/turf/open/floor/dirt)
	ambush_mobs = list(
				/mob/living/carbon/human/species/skeleton/npc/ambush = 10,
				/mob/living/simple_animal/hostile/retaliate/bigrat = 30,
				/mob/living/carbon/human/species/goblin/npc/sea = 20)
	converted_type = /area/outdoors/caves

/area/under/cave/spider
	icon_state = "spider"
	first_time_text = "ARAIGNÉE"
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/spider = 100)
	background_track = 'sound/music/area/spidercave.ogg'
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/spidercave

/area/outdoors/spidercave
	icon_state = "spidercave"
	background_track = 'sound/music/area/spidercave.ogg'
	background_track_dusk = null
	background_track_night = null

/area/under/spiderbase
	name = "spiderbase"
	droning_index = DRONING_BASEMENT
	droning_index_night = DRONING_BASEMENT
	icon_state = "spiderbase"
	background_track = 'sound/music/area/spidercave.ogg'
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/spidercave

/area/outdoors/spidercave
	icon_state = "spidercave"
	background_track = 'sound/music/area/spidercave.ogg'
	background_track_dusk = null
	background_track_night = null

/area/under/cavelava
	name = "cavelava"
	icon_state = "cavelava"
	first_time_text = "MALUM'S ARTERY"
	droning_index = DRONING_CAVE_LAVA
	ambient_index = AMBIENCE_CAVE
	ambush_times = list("night","dawn","dusk","day")
	ambush_types = list(
				/turf/open/floor/dirt)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/bigrat = 30,
				/mob/living/carbon/human/species/skeleton/npc/ambush = 10,
				/mob/living/carbon/human/species/goblin/npc/hell = 20)
	background_track = 'sound/music/area/decap.ogg'
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/decap

/area/under/cavelava/acid
	name = "cavelava"
	icon_state = "cavelava"
	first_time_text = null
	ambush_types = null
	converted_type = null

/area/outdoors/exposed/decap
	icon_state = "decap"
	background_track = 'sound/music/area/decap.ogg'
	background_track_dusk = null
	background_track_night = null

/area/under/lake
	name = "underground lake"
	icon_state = "lake"
	droning_index = DRONING_LAKE
	ambient_index = AMBIENCE_CAVE
	ambient_index_night = AMBIENCE_GENERIC

/area/indoors/ship
	name = "the ship"
	droning_index = DRONING_LAKE
	droning_index_night = DRONING_LAKE
	background_track = 'sound/music/area/townstreets.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/night.ogg'

/area/outdoors/coast
	name = "the coast"
	droning_index = DRONING_LAKE
	droning_index_night = DRONING_LAKE
	background_track = 'sound/music/area/sargoth.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'


///// UNDERWORLD AREAS //////

/area/underworld
	name = "underworld"
	icon_state = "underworld"
	background_track = 'sound/music/area/underworlddrone.ogg'
	background_track_dusk = null
	background_track_night = null
	first_time_text = "The Forest of Repentence"

/area/underworld/Entered(atom/movable/movable, oldloc)
	. = ..()
	if(!iscarbon(movable))
		return
	RegisterSignal(movable, COMSIG_CARBON_PRAY, PROC_REF(on_underworld_prayer))

/area/underworld/Exited(atom/movable/movable)
	. = ..()
	if(!iscarbon(movable))
		return
	UnregisterSignal(movable, COMSIG_CARBON_PRAY)

/area/underworld/proc/on_underworld_prayer(mob/living/carbon/damned, message)
	// Who do the underworld spirits pray to? Good question
	. |= CARBON_PRAY_CANCEL

	if(!damned || !message)
		return

	var/static/list/profane_words = list("zizo","cock","dick","fuck","shit","pussy","cuck","cunt","asshole")
	var/prayer = SANITIZE_HEAR_MESSAGE(message)

	for(var/profanity in profane_words)
		if(findtext(prayer, profanity))
			//put this idiot SOMEWHERE
			var/static/list/unsafe_turfs = list(
				/turf/open/floor/underworld/space,
				/turf/open/openspace,
			)

			var/static/list/turfs = list()
			if(!length(turfs)) //there are a lot of turfs, let's only do this once
				for(var/turf/turf in src)
					if(turf.density)
						continue
					if(is_type_in_list(turf, unsafe_turfs))
						continue
					turfs.Add(turf)

			var/turf/safe_turf = safepick(turfs)
			if(!safe_turf) //fuck
				return

			damned.forceMove(safe_turf)
			to_chat(damned, "<font color='yellow'>INSOLENT WRETCH, YOUR STRUGGLE CONTINUES</font>")
			return

	if(length(prayer) <= 15)
		to_chat(damned, span_danger("My prayer was kinda short..."))
		return

	if(findtext(prayer, damned.patron.name))
		damned.playsound_local(damned, 'sound/misc/notice (2).ogg', 100, FALSE)
		to_chat(damned, "<font color='yellow'>I, [damned.patron], have heard your prayer and yet cannot aid you.</font>")

///// DAKKATOWN AREAS //////

// Players should be fined for any damage they do to the Guild's property
/area/outdoors/beach/boat
	name = "sophia's cry"
	droning_index = DRONING_LAKE
	droning_index_night = DRONING_LAKE
	background_track = 'sound/music/area/townstreets.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'


///// ANTAGONIST AREAS //////  - used on centcom so you can teleport there easily. Each antag area just gets one unique type, if its outdoor use generic indoors, vice versa, to avoid clutter in area list

/area/indoors/bandit_lair
	name = "lair (Bandits)"

/area/indoors/vampire_manor
	name = "lair (Vampire Lord)"

/area/outdoors/bog/inhumen_camp
	name = "lair (Inhumen)"
	background_track = 'sound/music/area/decap.ogg'
	first_time_text = "THE DEEP BOG"

/area/indoors/lich
	name = "lair (Lich)"
	background_track = 'sound/music/area/churchnight.ogg'

/area/delver
	delver_restrictions = TRUE
	converted_type = /area/delver

/area/ship/topdeck
	name = "upperdeck"
	icon_state = "roofs"
	droning_index = DRONING_BOAT
	background_track = 'sound/music/area/topdeckdrone.ogg'
	background_track_dusk = null
	background_track_night = null
	first_time_text = "The Voyager"
	outdoors = TRUE

/area/ship/middeck
	name = "middeck"
	icon_state = "indoors"
	droning_index = DRONING_BOAT
	background_track = 'sound/music/area/topdeckdrone.ogg'
	background_track_dusk = null
	background_track_night = null
	first_time_text = "Waist Deck"

/area/ship/nobledeck
	name = "nobledeck"
	icon_state = "manor"
	droning_index = DRONING_BOAT
	background_track = 'sound/music/area/nobledeckdrone.ogg'
	background_track_dusk = null
	background_track_night = null

/area/ship/shipbrig
	name = "shipbrig"
	icon_state = "cell"
	droning_index = DRONING_BOAT
	background_track = 'sound/music/area/shipbrig.ogg'
	background_track_dusk = null
	background_track_night = null
	first_time_text = "The Brig"
