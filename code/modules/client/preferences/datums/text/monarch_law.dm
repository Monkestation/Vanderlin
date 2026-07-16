/datum/preference/text/monarch_law
	savefile_key = "monarch_law"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	can_randomize = FALSE
	maximum_value_length = 2048

/datum/preference/text/monarch_law/handle_link(datum/preferences/prefs, mob/user)
	var/prompt_msg = "Set value for Monarch Law.\n(You can enter multiple lines. Clearing it will remove the setting.)\n\nExample:\nThou shalt not steal.\nThou shalt not kill."
	var/new_val = input(user, prompt_msg, "Monarch Law", prefs.read_preference(type)) as message|null
	if(isnull(new_val))
		return
	if(new_val == "")
		prefs.write_preference(type, null)
		return
	prefs.write_preference(type, new_val)
