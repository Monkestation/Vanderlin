/datum/preference/list_type/role_setting/picker
	abstract_type = /datum/preference/list_type/role_setting/picker
	setting_kind = "picker"
	can_randomize = FALSE
	/// List of type paths to pick from
	var/list/picker_options = list()
	///are we string?
	var/string = FALSE

/datum/preference/list_type/role_setting/picker/proc/build_lists()
	SHOULD_CALL_PARENT(FALSE)
	CRASH("picker list has no picker_options and no build_lists() override")

/datum/preference/list_type/role_setting/picker/is_valid(value, datum/preferences/prefs)
	if(!islist(value))
		return FALSE
	for(var/entry in value)
		var/path = ispath(entry) ? entry : text2path(entry)
		if(string)
			path = entry
		if(!path || !(path in picker_options))
			return FALSE
	return TRUE

/datum/preference/list_type/role_setting/picker/deserialize(input, datum/preferences/prefs)
	if(!length(picker_options))
		build_lists()
	if(!islist(input))
		return create_default_value(prefs)
	var/list/cleaned = list()
	for(var/entry in input)
		var/path = ispath(entry) ? entry : text2path(entry)
		if(string)
			path = entry
		if(path && (path in picker_options))
			cleaned += "[path]"
	return cleaned

/datum/preference/list_type/role_setting/picker/proc/get_option_data()
	var/list/result = list()
	for(var/path in picker_options)
		if(ispath(path))
			var/atom/movable/A = path
			if(ispath(A))
				result += list(list(
					"value" = "[path]",
					"name" = initial(A.name),
					"icon" = initial(A.icon),
					"icon_state" = initial(A.icon_state),
					"is_path" = TRUE,
				))
			else
				result += list(list(
					"value" = "[path]",
					"name" = initial(A.name),
				))
		else
			result += list(list(
				"value" = "[path]",
				"name" = "[path]",
				"is_path" = FALSE,
			))
	return result
