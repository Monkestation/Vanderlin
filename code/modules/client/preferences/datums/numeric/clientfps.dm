/datum/preference/numeric/clientfps
	savefile_key = "clientfps"
	savefile_identifier = PREF_PLAYER
	category = "performance"
	can_randomize = FALSE
	should_update_preview = FALSE
	minimum = -1
	maximum = 1000
	step = 1

/datum/preference/numeric/clientfps/create_default_value(datum/preferences/prefs)
	return 100

/datum/preference/numeric/clientfps/apply_to_client(client/client, value)
	client.fps = (value < 0) ? 100 : value

/datum/preference/numeric/clientfps/handle_link(datum/preferences/prefs, mob/user)
	var/desiredfps = input(user, "Choose your desired fps. (0 = synced with server tick rate (currently:[world.fps]))", "Character Preference", prefs.read_preference(/datum/preference/numeric/clientfps))  as null|num
	if (!isnull(desiredfps))
		prefs.write_preference(/datum/preference/numeric/clientfps, desiredfps)
		prefs.parent.fps = desiredfps
