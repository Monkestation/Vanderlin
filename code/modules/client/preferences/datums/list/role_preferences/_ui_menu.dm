/// Filtered list of only role_setting preference entries, built once at init
GLOBAL_LIST_INIT(role_setting_preference_entries, init_role_setting_preference_entries())
/// Assoc list: savefile_key -> /datum/preference/list_type/role_setting, built once at init
GLOBAL_LIST_INIT(role_setting_entries_by_key, init_role_setting_entries_by_key())
/// Flat list of unique UI categories across all role settings, built once at init
GLOBAL_LIST_INIT(role_setting_categories, init_role_setting_categories())

/proc/init_role_setting_preference_entries()
	var/list/output = list()
	for(var/pref_type in GLOB.preference_entries)
		var/datum/preference/list_type/role_setting/entry = GLOB.preference_entries[pref_type]
		if(istype(entry, /datum/preference/list_type/role_setting))
			output[pref_type] = entry
	return output

/proc/init_role_setting_entries_by_key()
	var/list/output = list()
	for(var/pref_type in GLOB.role_setting_preference_entries)
		var/datum/preference/list_type/role_setting/entry = GLOB.role_setting_preference_entries[pref_type]
		output[entry.savefile_key] = entry
	return output

/proc/init_role_setting_categories()
	var/list/output = list()
	for(var/pref_type in GLOB.role_setting_preference_entries)
		var/datum/preference/list_type/role_setting/entry = GLOB.role_setting_preference_entries[pref_type]
		if(!(entry.ui_category in output))
			output += entry.ui_category
	return output

/datum/role_settings_menu
	var/datum/preferences/preferences

/datum/role_settings_menu/New(datum/preferences/prefs)
	preferences = prefs

/datum/role_settings_menu/ui_host(mob/user)
	return user

/datum/role_settings_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/role_settings_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "RoleSettings", "Role Settings")
		ui.open()

/datum/role_settings_menu/ui_data(mob/user)
	var/list/settings = list()
	for(var/pref_type in GLOB.role_setting_preference_entries)
		var/datum/preference/list_type/role_setting/entry = GLOB.role_setting_preference_entries[pref_type]
		var/list/current = preferences.read_preference(pref_type)
		var/list/setting_data = list(
			"savefile_key" = entry.savefile_key,
			"display_name" = entry.setting_display_name,
			"category" = entry.ui_category,
			"kind" = entry.setting_kind,
			"lines" = current?.len ? current.Copy() : list(),
			"max_lines" = entry.max_lines,
		)
		if(!entry.is_role)
			continue
		if(istype(entry, /datum/preference/list_type/role_setting/picker))
			var/datum/preference/list_type/role_setting/picker/picker_entry = entry
			setting_data["options"] = picker_entry.get_option_data()
		else
			setting_data["example_text"] = entry.example_text
		settings += list(setting_data)
	return list("settings" = settings, "categories" = GLOB.role_setting_categories.Copy())

/datum/role_settings_menu/proc/locate_role_setting(savefile_key)
	return GLOB.role_setting_entries_by_key[savefile_key]

/datum/role_settings_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("add_line")
			var/datum/preference/list_type/role_setting/pref = locate_role_setting(params["savefile_key"])
			if(!pref)
				return FALSE
			var/list/current = preferences.read_preference(pref.type)
			if(current.len >= pref.max_lines)
				return FALSE
			var/new_line = sanitize_text(params["value"])
			if(!new_line)
				return FALSE
			current += new_line
			preferences.write_preference(pref, current)
			preferences.save_preferences()
			return TRUE

		if("edit_line")
			var/datum/preference/list_type/role_setting/pref = locate_role_setting(params["savefile_key"])
			if(!pref)
				return FALSE
			var/list/current = preferences.read_preference(pref.type)
			var/index = params["index"] + 1
			if(index < 1 || index > current.len)
				return FALSE
			var/edited = sanitize_text(params["value"])
			if(!edited)
				return FALSE
			current[index] = edited
			preferences.write_preference(pref, current)
			preferences.save_preferences()
			return TRUE

		if("remove_line")
			var/datum/preference/list_type/role_setting/pref = locate_role_setting(params["savefile_key"])
			if(!pref)
				return FALSE
			var/list/current = preferences.read_preference(pref.type)
			var/index = params["index"] + 1
			if(index < 1 || index > current.len)
				return FALSE
			current.Cut(index, index + 1)
			preferences.write_preference(pref, current)
			preferences.save_preferences()
			return TRUE
