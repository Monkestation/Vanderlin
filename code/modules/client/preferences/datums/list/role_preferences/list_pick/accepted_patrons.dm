/datum/preference/list_type/role_setting/picker/accepted_patrons
	savefile_key = "accepted_patrons"
	savefile_identifier = PREF_CHARACTER
	category = "relations"
	can_randomize = FALSE
	setting_kind = ROLE_SETTING_LIST_PICK
	setting_display_name = "Accepted Patron Faiths"
	max_lines = 10
	is_role = FALSE
	should_apply = TRUE

/datum/preference/list_type/role_setting/picker/accepted_patrons/build_lists()
	if(!length(picker_options))
		for(var/faith_type in GLOB.faith_list)
			picker_options |= faith_type

/datum/preference/list_type/role_setting/picker/accepted_patrons/create_default_value()
	return list() // empty = no restriction

/datum/preference/list_type/role_setting/picker/accepted_patrons/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.accepted_patron_faiths = value

/datum/preference/list_type/role_setting/picker/accepted_patrons/handle_link(datum/preferences/prefs, mob/user)
	var/list/faith_options = list()
	for(var/faith_type in GLOB.faith_list)
		var/datum/faith/F = GLOB.faith_list[faith_type]
		faith_options[F.name] = "[faith_type]"

	var/list/current = prefs.read_preference(/datum/preference/list_type/role_setting/picker/accepted_patrons)
	var/result = browser_input_list(user, "TOGGLE ACCEPTED FAITHS", "FAMILY BONDS OF FAITH", faith_options, null)
	if(!result)
		return

	var/chosen = faith_options[result]
	if(chosen in current)
		current -= chosen
		to_chat(user, span_notice("Removed [result] from accepted faiths."))
	else
		current += chosen
		to_chat(user, span_notice("Added [result] to accepted faiths."))

	prefs.write_preference(/datum/preference/list_type/role_setting/picker/accepted_patrons, current)
