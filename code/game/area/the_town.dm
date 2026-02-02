/area/indoors/town
	name = "indoors"
	icon = 'icons/turf/areas/town.dmi'
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
	first_time_text = "The Drunken Saiga"
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
	icon_state = "inquisition"
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


///// OUTDOORS AREAS (again, for some reason)

/area/outdoors/town
	name = "outdoors"
	icon = 'icons/turf/areas/town.dmi'
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


/// Village stuff

// so you can teleport to the farm
/area/indoors/soilsons
	name = "soilsons"

/area/indoors/butchershop
	name = "butcher shop"

/area/indoors/villagegarrison
	name = "village garrison"
	icon_state = "garrison"

/area/outdoors/farm
	name = "soilery"
	icon_state = "farm"
	soundenv = 19
	background_track = 'sound/music/area/field.ogg'
	background_track_dusk = 'sound/music/area/septimus.ogg'
	background_track_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/indoors/shelter/basin
