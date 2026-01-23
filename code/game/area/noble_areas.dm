///// MANOR AREAS //////

/area/indoors/town/keep
	name = "Manor"
	icon = 'icons/turf/areas/manor.dmi'
	icon_state = "manor"
	background_track = 'sound/music/area/manor.ogg'
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/manorgarri

/area/indoors/town/keep/Initialize()
	. = ..()
	first_time_text = "THE KEEP OF [uppertext(SSmapping.config.map_name)]"

/area/outdoors/town/keep
	name = "Keep Grounds"
	icon = 'icons/turf/areas/manor.dmi'
	icon_state = "manor_out"

/area/outdoors/town/keep/Initialize()
	. = ..()
	first_time_text = "[uppertext(SSmapping.config.map_name)] KEEP GROUNDS"


/area/indoors/town/keep/throne
	name = "Throne Room"
	icon_state = "throne"

/area/indoors/town/keep/lord_appt
	name = "Lord's Appartment"
	icon_state = "lord_appt"

/area/indoors/town/keep/captain
	name = "Captain's Room"
	icon_state = "captain"

/area/indoors/town/keep/hand
	name = "Hand's Room"
	icon_state = "hand"

/area/indoors/town/keep/phys
	name = "Court Physician's Office"
	icon_state = "physician"

/area/indoors/town/keep/heir
	name = "Heirs' Room"
	icon_state = "heir"

/area/indoors/town/keep/heir/heir1
	name = "First Heir's Room"
	icon_state = "heir1"

/area/indoors/town/keep/heir/heir2
	name = "Second Heir's Room"
	icon_state = "heir2"

/area/indoors/town/keep/knight
	name = "Knights' Quarters"
	icon_state = "knight"

/area/indoors/town/keep/knight/knight1
	name = "First Knight's Quarters"
	icon_state = "knight1"

/area/indoors/town/keep/knight/knight2
	name = "Second Knight's Quarters"
	icon_state = "knight2"

/area/indoors/town/keep/squire
	name = "Squires' Quarters"
	icon_state = "squire"

/area/indoors/town/keep/squire/squire1
	name = "First Squire's Quarters"
	icon_state = "squire1"

/area/indoors/town/keep/squire/squire2
	name = "Second Squire's Quarters"
	icon_state = "squire2"

/area/indoors/town/keep/kitchen
	name = "Keep Kitchen"
	icon_state = "kitchen"

/area/indoors/town/keep/kitchen/cellar
	name = "Keep Kitchen Cellar"
	icon_state = "kitchen"

/area/indoors/town/keep/servant
	name = "Servants' Quarters"
	icon_state = "servant"

/area/indoors/town/keep/servanthead
	name = "Head Servant's Quarters"
	icon_state = "servant_head"

/area/indoors/town/keep/library
	name = "Keep Libray"
	icon_state = "library"

/area/indoors/town/keep/archivist
	name = "Archivist's Quarters"
	icon_state = "archivists_quarters"

/area/indoors/town/keep/feast
	name = "Keep Feast Hall"
	icon_state = "feast_hall"

/area/indoors/town/keep/dungeoneer
	name = "Court Dungeoneer's Quarters"
	icon_state = "dungeoneer"

/area/indoors/town/keep/jester
	name = "Jester's Quarters"
	icon_state = "jester"

/area/indoors/town/keep/guest
	name = "Keep Guest Room"
	icon_state = "guest"

/area/indoors/town/keep/guest/guest1
	name = "Keep Guest Room 1"
	icon_state = "guest1"

/area/indoors/town/keep/guest/guest2
	name = "Keep Guest Room 2"
	icon_state = "guest2"

/area/indoors/town/keep/guest/meeting
	name = "Keep Meeting Room"
	icon_state = "meeting"

/area/indoors/town/keep/halls
	name = "Keep Halls"
	icon_state = "halls"

/area/indoors/town/keep/halls/n
	name = "Keep Halls (North)"
	icon_state = "halls_n"

/area/indoors/town/keep/halls/e
	name = "Keep Halls (East)"
	icon_state = "halls_e"

/area/indoors/town/keep/halls/s
	name = "Keep Halls (South)"
	icon_state = "halls_s"

/area/indoors/town/keep/halls/w
	name = "Keep Halls (West)"
	icon_state = "halls_w"

/area/indoors/town/keep/garrison
	name = "Keep Garrison"
	icon_state = "manorgarri"

/area/indoors/town/keep/gate
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

/area/indoors/town/keep/magician
	name = "Wizard's Tower"
	icon_state = "magiciantower"
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


// Minor Nobles
/area/indoors/town/noble_manor
	icon = 'icons/turf/areas/manor.dmi'
	icon_state = "noble"
	background_track = 'sound/music/area/manor.ogg'
	background_track_dusk = null
	background_track_night = null
	converted_type = /area/outdoors/exposed/manorgarri

/area/outdoors/town/noble_manor
	icon = 'icons/turf/areas/manor.dmi'
	icon_state = "noble_out"

/area/indoors/town/noble_manor/blue
	name = "Blue Noble Manor"
	icon_state = "noble1"

/area/outdoors/town/noble_manor/blue
	first_time_text = "Blue Noble Manor"
	icon_state = "noble1_out"

/area/indoors/town/noble_manor/yellow
	name = "Yellow Noble Manor"
	icon_state = "noble2"

/area/outdoors/town/noble_manor/yellow
	icon_state = "noble2_out"
	first_time_text = "Green Noble Manor"

/area/indoors/town/noble_manor/red
	name = "Red Noble Manor"
	icon_state = "noble3"

/area/outdoors/town/noble_manor/red
	icon_state = "noble3_out"
	first_time_text = "Red Noble Manor"
