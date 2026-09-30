/datum/preference/text/erp_preferences
	savefile_key = "erp_preferences"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	maximum_value_length = 512

/datum/preference/text/erp_preferences/handle_link(datum/preferences/prefs, mob/user)
	var/new_value = input(user, "Input your ERP preferences:", "ERP Preferences", prefs.read_preference(/datum/preference/text/erp_preferences)) as message|null
	if(new_value == null)
		return
	prefs.write_preference(/datum/preference/text/erp_preferences, new_value)
	to_chat(user, span_notice("Successfully updated ERP preferences."))