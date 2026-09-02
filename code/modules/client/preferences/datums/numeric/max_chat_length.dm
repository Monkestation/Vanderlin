/datum/preference/numeric/max_chat_length
	savefile_key = "max_chat_length"
	savefile_identifier = PREF_PLAYER
	category = "chat"
	can_randomize = FALSE
	should_update_preview = FALSE
	minimum = 1
	maximum = CHAT_MESSAGE_MAX_LENGTH
	step = 1

/datum/preference/numeric/max_chat_length/create_default_value(datum/preferences/prefs)
	return CHAT_MESSAGE_MAX_LENGTH

/datum/preference/numeric/handle_link(datum/preferences/prefs, mob/user)
	var/desiredlength = input(user, "Choose the max character length of shown Runechat messages. Valid range is 1 to [CHAT_MESSAGE_MAX_LENGTH] (default: [prefs.read_default_preference(/datum/preference/numeric/max_chat_length)]))", "Character Preference", prefs.read_preference(/datum/preference/numeric/max_chat_length))  as null|num
	if (!isnull(desiredlength))
		prefs.write_preference(/datum/preference/numeric/max_chat_length, clamp(desiredlength, 1, CHAT_MESSAGE_MAX_LENGTH))
