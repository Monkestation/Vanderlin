/datum/preference/numeric/pixel_size
	savefile_key = "pixel_size"
	savefile_identifier = PREF_PLAYER
	category = "ui"
	can_randomize = FALSE
	should_update_preview = FALSE
	minimum = 0
	maximum = 3
	step = 1

/datum/preference/numeric/pixel_size/create_default_value(datum/preferences/prefs)
	return 0

/datum/preference/numeric/pixel_size/handle_link(datum/preferences/prefs, mob/user)
	switch(prefs.read_preference(/datum/preference/numeric/pixel_size))
		if(PIXEL_SCALING_AUTO)
			prefs.write_preference(/datum/preference/numeric/pixel_size, PIXEL_SCALING_1X)
		if(PIXEL_SCALING_1X)
			prefs.write_preference(/datum/preference/numeric/pixel_size, PIXEL_SCALING_1_2X)
		if(PIXEL_SCALING_1_2X)
			prefs.write_preference(/datum/preference/numeric/pixel_size, PIXEL_SCALING_2X)
		if(PIXEL_SCALING_2X)
			prefs.write_preference(/datum/preference/numeric/pixel_size, PIXEL_SCALING_3X)
		if(PIXEL_SCALING_3X)
			prefs.write_preference(/datum/preference/numeric/pixel_size, PIXEL_SCALING_AUTO)
	user.client.view_size.apply() //Let's winset() it so it actually works
