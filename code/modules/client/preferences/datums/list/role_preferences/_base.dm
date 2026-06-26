/datum/preference/list_type/role_setting
	abstract_type = /datum/preference/list_type/role_setting
	savefile_identifier = PREF_CHARACTER
	can_randomize = FALSE
	should_update_preview = FALSE
	should_apply = FALSE

	/// Tab category shown in the UI
	var/ui_category = "General"
	/// "freetext" or "picker"
	var/setting_kind = ROLE_SETTING_TEXT
	/// Max number of lines allowed
	var/max_lines = 10
	/// Display name shown in the input prompt
	var/setting_display_name = "Setting"
	/// Example text appended to the prompt
	var/example_text = null

/datum/preference/list_type/role_setting/is_valid(value, datum/preferences/prefs)
	if (!islist(value))
		return FALSE
	for (var/line in value)
		if (!istext(line))
			return FALSE
	return TRUE

/datum/preference/list_type/role_setting/create_default_value(datum/preferences/prefs)
	return list()

/datum/preference/list_type/role_setting/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	return
