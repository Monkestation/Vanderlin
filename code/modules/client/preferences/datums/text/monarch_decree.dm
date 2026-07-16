/datum/preference/text/monarch_decree
	savefile_key = "monarch_decree"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	can_randomize = FALSE
	maximum_value_length = 2048

/datum/preference/text/monarch_decree/handle_link(datum/preferences/prefs, mob/user)
	var/prompt_msg = "Set value for Monarch Decree.\n(You can enter multiple lines. Clearing it will remove the setting.)\n\nExample:\nTaxes are hereby abolished.\nAll peasants must wear purple."
	var/new_val = input(user, prompt_msg, "Monarch Decree", prefs.read_preference(type)) as message|null
	if(isnull(new_val))
		return
	if(new_val == "")
		prefs.write_preference(type, null)
		return
	prefs.write_preference(type, new_val)
