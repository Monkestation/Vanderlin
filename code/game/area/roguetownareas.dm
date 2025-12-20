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

/area/outdoors/rtfield
	name = "town basin"
	icon_state = "rtfield"
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
	converted_type = /area/indoors/shelter/rtfield

/area/outdoors/rtfield/Initialize()
	. = ..()
	first_time_text = "[uppertext(SSmapping.config.map_name)] BASIN"

/area/outdoors/rtfield/safe
	ambush_mobs = null

/area/indoors/shelter/rtfield
	icon_state = "rtfield"
	background_track = 'sound/music/area/field.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'

/area/outdoors/woods
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

///// TOWN AREAS //////

/area/indoors/town
	name = "indoors"
	icon_state = "indoor_town"
	background_track = 'sound/music/area/indoor.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/deliverer.ogg'
	converted_type = /area/outdoors/exposed/town

/area/outdoors/exposed/town
	icon_state = "town"
	background_track = 'sound/music/area/towngen.ogg'
	background_track_dusk = null
	background_track_night = 'sound/music/area/deliverer.ogg'

///// MANOR AREAS //////

/area/indoors/town/manor
	name = "Manor"
	icon = 'icons/turf/areas_manor.dmi'
	icon_state = "manor"
	background_track = 'sound/music/area/manor.ogg'
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/manorgarri

/area/indoors/town/manor/Initialize()
	. = ..()
	first_time_text = "THE KEEP OF [uppertext(SSmapping.config.map_name)]"

/area/indoors/town/manor/throne
	name = "Throne Room"
	icon_state = "throne"

/area/indoors/town/manor/lord_appt
	name = "Lord's Appartment"
	icon_state = "lord_appt"

/area/indoors/town/manor/captain
	name = "Captain's Room"
	icon_state = "captain"

/area/indoors/town/manor/hand
	name = "Hand's Room"
	icon_state = "hand"

/area/indoors/town/manor/phys
	name = "Court Physician's Office"
	icon_state = "physician"

/area/indoors/town/manor/heir
	name = "Heirs' Room"
	icon_state = "heir"

/area/indoors/town/manor/heir/heir1
	name = "First Heir's Room"
	icon_state = "heir1"

/area/indoors/town/manor/heir/heir2
	name = "Second Heir's Room"
	icon_state = "heir2"

/area/indoors/town/manor/knight
	name = "Knights' Quarters"
	icon_state = "knight"

/area/indoors/town/manor/knight/knight1
	name = "First Knight's Quarters"
	icon_state = "knight1"

/area/indoors/town/manor/knight/knight2
	name = "Second Knight's Quarters"
	icon_state = "knight2"

/area/indoors/town/manor/squire
	name = "Squires' Quarters"
	icon_state = "squire"

/area/indoors/town/manor/squire/squire1
	name = "First Squire's Quarters"
	icon_state = "squire1"

/area/indoors/town/manor/squire/squire2
	name = "Second Squire's Quarters"
	icon_state = "squire2"

/area/indoors/town/manor/kitchen
	name = "Keep Kitchen"
	icon_state = "kitchen"

/area/indoors/town/manor/kitchen/cellar
	name = "Keep Kitchen Cellar"
	icon_state = "kitchen"

/area/indoors/town/manor/servant
	name = "Servants' Quarters"
	icon_state = "servant"

/area/indoors/town/manor/servanthead
	name = "Head Servant's Quarters"
	icon_state = "servant_head"

/area/indoors/town/manor/library
	name = "Keep Libray"
	icon_state = "library"

/area/indoors/town/manor/archivist
	name = "Archivist's Quarters"
	icon_state = "archivists_quarters"

/area/indoors/town/manor/feast
	name = "Keep Feast Hall"
	icon_state = "feast_hall"

/area/indoors/town/manor/dungeoneer
	name = "Court Dungeoneer's Quarters"
	icon_state = "dungeoneer"

/area/indoors/town/manor/jester
	name = "Jester's Quarters"
	icon_state = "jester"

/area/indoors/town/manor/guest
	name = "Keep Guest Room"
	icon_state = "guest"

/area/indoors/town/manor/guest/guest1
	name = "Keep Guest Room 1"
	icon_state = "guest1"

/area/indoors/town/manor/guest/guest2
	name = "Keep Guest Room 2"
	icon_state = "guest2"

/area/indoors/town/manor/guest/meeting
	name = "Keep Meeting Room"
	icon_state = "meeting"

/area/indoors/town/manor/halls
	name = "Keep Halls"
	icon_state = "halls"

/area/indoors/town/manor/halls/n
	name = "Keep Halls (North)"
	icon_state = "halls_n"

/area/indoors/town/manor/halls/e
	name = "Keep Halls (East)"
	icon_state = "halls_e"

/area/indoors/town/manor/halls/s
	name = "Keep Halls (South)"
	icon_state = "halls_s"

/area/indoors/town/manor/halls/w
	name = "Keep Halls (West)"
	icon_state = "halls_w"

/area/indoors/town/manor/garrison
	name = "Keep Garrison"
	icon_state = "manorgarri"

/area/indoors/town/manorgate
	name = "Manor Gate"
	icon_state = "manorgate"
	background_track = 'sound/music/area/manorgarri.ogg'
	background_track_dusk = null
	background_track_night = 'sound/music/area/deliverer.ogg'

/area/outdoors/exposed/manorgarri
	icon_state = "manorgarri"
	background_track = 'sound/music/area/manor.ogg'
	background_track_dusk = null
	background_track_night = null

/area/outdoors/exposed/cell
	icon_state = "cell"
	background_track = 'sound/music/area/manorgarri.ogg'
	background_track_dusk = null
	background_track_night = null

/area/indoors/town/magician
	name = "Wizard's Tower"
	icon_state = "magician"
	ambient_index = AMBIENCE_MYSTICAL
	background_track = 'sound/music/area/magiciantower.ogg'
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/magiciantower

/area/outdoors/exposed/magiciantower
	icon_state = "magiciantower"
	background_track = 'sound/music/area/magiciantower.ogg'
	background_track_dusk = null
	background_track_night = null

/area/indoors/town/shop
	name = "Shop"
	icon_state = "shop"
	background_track = 'sound/music/area/shop.ogg'
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/shop

/area/outdoors/exposed/shop
	icon_state = "shop"
	background_track = 'sound/music/area/shop.ogg'

/area/indoors/town/bath
	name = "Baths"
	icon_state = "bath"
	background_track = 'sound/music/area/bath.ogg'
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/bath

/area/outdoors/exposed/bath
	icon_state = "bath"
	background_track = 'sound/music/area/bath.ogg'

/*	..................   Areas to play with the music a bit   ................... */
/area/indoors/town/bath/redhouse // lets try something different
	background_track = 'sound/music/area/Fulminate.ogg'
	converted_type = /area/outdoors/exposed/bath/redhouse

/area/outdoors/exposed/bath/redhouse
	background_track = 'sound/music/area/Fulminate.ogg'

/area/indoors/town/tavern/saiga
	background_track = 'sound/music/area/Folia1490.ogg'
	background_track_night = 'sound/music/area/LeTourdion.ogg'
	converted_type = /area/outdoors/exposed/tavern/saiga

/area/outdoors/exposed/tavern/saiga
	background_track = 'sound/music/area/Folia1490.ogg'
	background_track_night = 'sound/music/area/LeTourdion.ogg'

/area/indoors/town/garrison
	name = "Garrison"
	icon_state = "garrison"
	background_track = 'sound/music/area/manorgarri.ogg'
	background_track_dusk = null
	background_track_night = null
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/manorgarri

/area/indoors/town/garrison/lieutenant
	name = "Watch Lieutenant"

/area/indoors/town/cell
	name = "dungeon cell"
	icon_state = "cell"
	ambient_index = AMBIENCE_DUNGEON
	ambient_index_night = AMBIENCE_DUNGEON
	background_track = 'sound/music/area/manorgarri.ogg'
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/cell

/area/indoors/town/tavern
	name = "tavern"
	icon_state = "tavern"
	first_time_text = "The Drunken Saiga"
	droning_index = DRONING_INDOORS
	droning_index_night = DRONING_INDOORS
	background_track = "sound/blank.ogg"
	background_track_dusk = "sound/blank.ogg"
	background_track_night = "sound/blank.ogg"
	converted_type = /area/outdoors/exposed/tavern

/area/outdoors/exposed/tavern
	icon_state = "tavern"

/area/indoors/town/church
	name = "church"
	icon_state = "church"
	background_track = 'sound/music/area/church.ogg'
	background_track_dusk = null
	background_track_night = 'sound/music/area/churchnight.ogg'
	converted_type = /area/outdoors/exposed/church

/area/outdoors/exposed/church
	icon_state = "church"
	background_track = 'sound/music/area/church.ogg'
	background_track_dusk = null
	background_track_night = 'sound/music/area/churchnight.ogg'

/area/indoors/town/church/chapel
	icon_state = "chapel"
	first_time_text = "THE HOUSE OF THE TEN"

/area/indoors/town/church/inquisition
	name = "inquisition"
	first_time_text = "INQUISITIONS LAIR"

/area/indoors/town/fire_chamber
	name = "incinerator"
	icon_state = "fire_chamber"

/area/indoors/town/fire_chamber/can_craft_here()
	return FALSE

/area/indoors/town/warehouse
	name = "dock warehouse import"
	icon_state = "warehouse"

/area/indoors/town/warehouse/can_craft_here()
	return FALSE

/area/indoors/town/vault
	name = "vault"
	icon_state = "vault"

/area/indoors/town/vault/can_craft_here()
	return FALSE

/area/indoors/town/entrance
	icon_state = "entrance"

/area/indoors/town/entrance/Initialize()
	. = ..()
	first_time_text = "[uppertext(SSmapping.config.map_name)]"

/area/indoors/town/clocktower
	first_time_text = "Clocktower"
	icon_state = "clocktower"
	background_track = 'sound/music/area/clocktower_ambience.ogg'

/area/indoors/town/orphanage
	first_time_text = "The Orphanage"
	icon_state = "orphanage"

/area/indoors/town/clinic_large
	first_time_text = "The Clinic"
	icon_state = "clinic_large"

/area/indoors/town/clinic_large/apothecary
	name = "Apothecary's Workshop"
	icon_state = "clinic_apoth"

/area/indoors/town/clinic_large/feldsher
	name = "Feldsher's Office"
	icon_state = "clinic_feld"

/area/indoors/town/thieves_guild
	first_time_text = "Thieves' Guild"
	icon_state = "thieves_guild"

/area/indoors/town/merc_guild
	first_time_text = "Mercenary Guild"
	icon_state = "merc_guild"

/area/indoors/town/steward
	first_time_text = "Stewards Office"
	icon_state = "steward"

/area/indoors/town/smithy
	name = "Smithy"
	icon_state = "smithy"
	background_track = 'sound/music/area/dwarf.ogg'
	background_track_dusk = null
	background_track_night = null
	first_time_text = "The Smithy"
	converted_type = /area/outdoors/exposed/dwarf

/area/indoors/town/dwarfin
	name = "makers quarter"
	icon_state = "dwarfin"
	background_track = 'sound/music/area/dwarf.ogg'
	background_track_dusk = null
	background_track_night = null
	first_time_text = "The Makers' Quarter"
	converted_type = /area/outdoors/exposed/dwarf

/area/outdoors/exposed/dwarf
	icon_state = "dwarf"
	background_track = 'sound/music/area/dwarf.ogg'
	background_track_dusk = null
	background_track_night = null

/area/indoors/town/town_elder/place
	icon_state = "tavern"
	first_time_text = "THE?"

// so you can teleport to the farm
/area/indoors/soilsons
	name = "soilsons"

/area/indoors/butchershop
	name = "butcher shop"

/area/indoors/villagegarrison
	name = "village garrison"

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

///// OUTDOORS AREAS (again, for some reason)

/area/outdoors/town
	name = "outdoors"
	icon_state = "town"
	background_track = 'sound/music/area/townstreets.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/deliverer.ogg'
	converted_type = /area/indoors/shelter/town

/area/outdoors/town/Initialize()
	. = ..()
	first_time_text = "[uppertext(SSmapping.config.map_name)]"

/area/indoors/shelter/town
	icon_state = "town"
	background_track = 'sound/music/area/townstreets.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/deliverer.ogg'

/area/outdoors/town/sargoth
	name = "outdoors"
	icon_state = "sargoth"
	background_track = 'sound/music/area/sargoth.ogg'
	background_track_dusk = null
	converted_type = /area/indoors/shelter/town/sargoth

/area/indoors/shelter/town/sargoth
	icon_state = "sargoth"
	background_track = 'sound/music/area/sargoth.ogg'
	background_track_dusk = null
	background_track_night = null

/area/outdoors/town/roofs
	name = "roofs"
	icon_state = "roofs"
	droning_index = DRONING_MOUNTAIN
	ambient_index = AMBIENCE_GENERIC
	background_track = 'sound/music/area/field.ogg'
	converted_type = /area/indoors/shelter/town/roofs

/area/indoors/shelter/town/roofs
	icon_state = "roofs"
	background_track = 'sound/music/area/field.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/deliverer.ogg'

/area/outdoors/town/dwarf
	name = "makers quarter"
	icon_state = "dwarf"
	background_track = 'sound/music/area/dwarf.ogg'
	background_track_dusk = null
	background_track_night = null
	first_time_text = "The Makers' Quarter"
	converted_type = /area/indoors/shelter/town/dwarf

/area/indoors/shelter/town/dwarf
	icon_state = "dwarf"
	background_track = 'sound/music/area/dwarf.ogg'
	background_track_dusk = null
	background_track_night = null

///// UNDERGROUND AREAS //////

/area/under/town
	name = "basement"
	icon_state = "town"
	background_track = 'sound/music/area/catacombs.ogg'
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/under/town

/area/outdoors/exposed/under/town
	icon_state = "town"
	background_track = 'sound/music/area/catacombs.ogg'
	background_track_dusk = null
	background_track_night = null

/area/under/town/sewer
	name = "sewer"
	icon_state = "sewer"
	droning_index = DRONING_CAVE_WET
	ambient_index = AMBIENCE_RAT
	background_track = 'sound/music/area/sewers.ogg'
	background_track_dusk = null
	background_track_night = null
	custom_area_sound = 'sound/misc/stings/SewerSting.ogg'
	converted_type = /area/outdoors/exposed/under/sewer

/area/under/town/sewer/Initialize()
	. = ..()
	first_time_text = "[uppertext(SSmapping.config.map_name)]'S SEWERS"

/area/outdoors/exposed/under/sewer
	icon_state = "sewer"
	background_track = 'sound/music/area/sewers.ogg'
	background_track_dusk = null
	background_track_night = null

/area/under/town/basement
	name = "basement"
	icon_state = "basement"
	droning_index = DRONING_BASEMENT
	ambient_index = AMBIENCE_DUNGEON
	background_track = 'sound/music/area/catacombs.ogg'
	background_track_dusk = null
	background_track_night = null
	soundenv = 5
	converted_type = /area/outdoors/exposed/under/basement

/area/outdoors/exposed/under/basement
	icon_state = "basement"
	background_track = 'sound/music/area/catacombs.ogg'
	background_track_dusk = null
	background_track_night = null


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
				/turf/open/transparent/openspace,
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

// Players are penalized for entering the Guild Gaptain's quarters (FAFO)
/area/outdoors/beach/boat/captain
	name = "guild captain"
	droning_index = DRONING_LAKE
	droning_index_night = DRONING_LAKE
	background_track = 'sound/music/area/townstreets.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'

/area/indoors/town/theatre
	name = "theatre"
	icon_state = "manor"
	background_track = null
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/theatre

/area/outdoors/exposed/theatre
	name = "theatre"
	icon_state = "manor"
	background_track = null
	background_track_dusk = null
	background_track_night = null

/area/indoors/town/apothecary
	name = "apothecary"
	icon_state = "manor"
	background_track = null
	background_track_dusk = null
	background_track_night = null

/area/under/town/ruin
	name = "townruin"
	icon_state = "town"
	background_track = 'sound/music/area/catacombs.ogg'
	background_track_dusk = null
	background_track_night = null


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
