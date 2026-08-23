GLOBAL_LIST_EMPTY(underwear_m)
GLOBAL_LIST_EMPTY(underwear_f)
GLOBAL_LIST_INIT(underwear_list, init_underwear_list())

/proc/init_underwear_list()
	var/list/underwear = init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear)

	GLOB.underwear_m = underwear[MALE_SPRITE_LIST]
	GLOB.underwear_f = underwear[FEMALE_SPRITE_LIST]

	return underwear[DEFAULT_SPRITE_LIST]

GLOBAL_LIST_EMPTY(undershirt_m)
GLOBAL_LIST_EMPTY(undershirt_f)
GLOBAL_LIST_INIT(undershirt_list, init_undershirt_list())

/proc/init_undershirt_list()
	var/list/undershirts = init_sprite_accessory_subtypes(/datum/sprite_accessory/undershirt)

	GLOB.undershirt_m = undershirts[MALE_SPRITE_LIST]
	GLOB.undershirt_f = undershirts[FEMALE_SPRITE_LIST]

	return undershirts[DEFAULT_SPRITE_LIST]
