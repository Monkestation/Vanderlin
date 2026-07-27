/area/indoors/town/church/dreamcave
	name = "The Dream Cave"
	icon = 'icons/turf/areas/manor.dmi'
	icon_state = "magician"
	ambient_index = AMBIENCE_MYSTICAL
	first_time_text = "The Dream Cave"
	background_track = 'sound/music/area/magiciantower.ogg'
	outdoors = FALSE
	alpha = 0

/area/indoors/town/church/dreamcave/starchamber
	name = "The Star Chamber"
	first_time_text = "The Star Chamber"
	area_flags = VALID_TERRITORY | UNIQUE_AREA | NO_TELEPORT

/area/indoors/town/church/dreamcave/starchamber/can_craft_here()
	return FALSE
