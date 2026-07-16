/datum/preference/choiced/scaling_method
	savefile_key = "scaling_method"
	savefile_identifier = PREF_PLAYER
	category = "ui"
	can_randomize = FALSE
	should_update_preview = FALSE

/datum/preference/choiced/scaling_method/init_possible_values(datum/preferences/prefs)
	return list("normal", "pixel_perfect", "distorted")

/datum/preference/choiced/scaling_method/create_default_value(datum/preferences/prefs)
	return "normal"

/datum/preference/choiced/scaling_method/handle_link(datum/preferences/prefs, mob/user)
	switch(prefs.read_preference(/datum/preference/choiced/scaling_method))
		if(SCALING_METHOD_NORMAL)
			prefs.write_preference(/datum/preference/choiced/scaling_method, SCALING_METHOD_DISTORT)
		if(SCALING_METHOD_DISTORT)
			prefs.write_preference(/datum/preference/choiced/scaling_method, SCALING_METHOD_BLUR)
		if(SCALING_METHOD_BLUR)
			prefs.write_preference(/datum/preference/choiced/scaling_method, SCALING_METHOD_NORMAL)
	user.client.view_size.setZoomMode()
