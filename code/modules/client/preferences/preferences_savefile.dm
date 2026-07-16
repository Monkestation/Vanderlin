//This is the lowest supported version, anything below this is completely obsolete and the entire savefile will be wiped.
#define SAVEFILE_VERSION_MIN 18

//This is the current version, anything below this will attempt to update (if it's not obsolete)
//	You do not need to raise this if you are adding new values that have sane defaults.
//	Only raise this value when changing the meaning/format/name/layout of an existing value
//	where you would want the updater procs below to run
#define SAVEFILE_VERSION_MAX 35

/*
SAVEFILE UPDATING/VERSIONING - 'Simplified', or rather, more coder-friendly ~Carn
	This proc checks if the current directory of the savefile S needs updating
	It is to be used by the load_character and load_preferences procs.
	(S.cd=="/" is preferences, S.cd=="/character[integer]" is a character slot, etc)

	if the current directory's version is below SAVEFILE_VERSION_MIN it will simply wipe everything in that directory
	(if we're at root "/" then it'll just wipe the entire savefile, for instance.)

	if its version is below SAVEFILE_VERSION_MAX but above the minimum, it will load data but later call the
	respective update_preferences() or update_character() proc.
	Those procs allow coders to specify format changes so users do not lose their setups and have to redo them again.

	Failing all that, the standard sanity checks are performed. They simply check the data is suitable, reverting to
	initial() values if necessary.
*/
/datum/preferences/proc/savefile_needs_update(savefile/S)
	var/savefile_version
	S["version"] >> savefile_version

	if(savefile_version < SAVEFILE_VERSION_MIN)
		S.dir.Cut()
		return -2

	if(savefile_version < SAVEFILE_VERSION_MAX)
		return savefile_version

	return -1

//should these procs get fairly long
//just increase SAVEFILE_VERSION_MIN so it's not as far behind
//SAVEFILE_VERSION_MAX and then delete any obsolete if clauses
//from these procs.
//This only really meant to avoid annoying frequent players
//if your savefile is 3 months out of date, then 'tough shit'.

/datum/preferences/proc/update_preferences(current_version, savefile/S)
	if(current_version < 29)
		key_bindings = (read_preference(/datum/preference/toggle/hotkeys)) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)
		parent.update_movement_keys()
		to_chat(parent, "<span class='danger'>Empty keybindings, setting default to [read_preference(/datum/preference/toggle/hotkeys) ? "Hotkey" : "Classic"] mode</span>")

/datum/preferences/proc/update_character(current_version, savefile/S)
	if(current_version < 22)
		job_preferences = list()
		for(var/datum/job/J as anything in subtypesof(/datum/job))
			var/new_value
			if(new_value)
				job_preferences[initial(J.title)] = new_value

	if(current_version < 24)
		if(!(read_preference(/datum/preference/choiced/underwear) in GLOB.underwear_list))
			write_preference(GLOB.preference_entries[/datum/preference/choiced/underwear], "Nude")

	if(current_version < 25)
		randomise = list(RANDOM_UNDERWEAR = TRUE, RANDOM_UNDERWEAR_COLOR = TRUE, RANDOM_UNDERSHIRT = TRUE, RANDOM_SKIN_TONE = TRUE, RANDOM_EYE_COLOR = TRUE)
		if(S["name_is_always_random"] == 1)
			randomise[RANDOM_NAME] = TRUE
		if(S["body_is_always_random"] == 1)
			randomise[RANDOM_BODY] = TRUE
		if(S["species_is_always_random"] == 1)
			randomise[RANDOM_SPECIES] = TRUE

	if(current_version < 30)
		var/raw_voice_color
		S["voice_color"] >> raw_voice_color
		write_preference(GLOB.preference_entries[/datum/preference/color/voice_color], raw_voice_color)

	if(current_version < 31)
		write_preference(GLOB.preference_entries[/datum/preference/choiced/culture], /datum/culture/universal/ambiguous)
		var/list/assoc_skins = pref_species.get_skin_list()
		var/list/skins = list()
		for(var/skin in assoc_skins)
			skins += assoc_skins[skin]
		if(!(read_preference(/datum/preference/choiced/skin_tone) in skins))
			write_preference(GLOB.preference_entries[/datum/preference/choiced/skin_tone], pick_assoc(assoc_skins))

	if(current_version < 32)
		var/species_name = S["species"]
		for(var/species_id in GLOB.species_list)
			var/datum/species/species_type = GLOB.species_list[species_id]
			if(species_type::name == species_name)
				write_preference(GLOB.preference_entries[/datum/preference/choiced/species], species_type)
				break

	if(current_version < 33)
		var/vtype = read_preference(/datum/preference/choiced/voice_type)
		switch(vtype)
			if("Masculine")
				write_preference(GLOB.preference_entries[/datum/preference/choiced/voice_type], VOICE_TYPE_MASC)
			if("Feminine")
				write_preference(GLOB.preference_entries[/datum/preference/choiced/voice_type], VOICE_TYPE_FEM)

	if(current_version < 34)
		var/list/flat = list()
		for(var/key in list(
			"real_name","gender","pronouns","voice_type","age",
			"origin","domhand","alignment","phobia","selected_accent",
			"family","setspouse","gender_choice",
			"species","selected_patron","culture",
			"skin_tone","eye_color","voice_color","detail_color","underwear_color",
			"underwear","undershirt","accessory","detail","socks",
			"flavortext","flavortext_display",
			"ooc_notes","ooc_notes_display",
			"ooc_extra","ooc_extra_link","headshot_link",
			"joblessrole"
		))
			S[key] >> flat[key]
		migrate_character_flat_to_preference(flat)

/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)
		return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"

/datum/preferences/proc/load_preferences()
	if(!path)
		return FALSE
	if(!fexists(path))
		return FALSE

	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"
	var/needs_update = savefile_needs_update(S)
	if(needs_update == -2)
		return FALSE

	// Non-preference fields
	S["admin_ghost_icon"]	>> admin_ghost_icon
	S["lastchangelog"]		>> lastchangelog
	S["be_special"] 		>> be_special
	S["triumphs"]			>> triumphs
	S["lastclass"]			>> lastclass
	S["default_slot"]		>> default_slot
	S["ignoring"]			>> ignoring
	S["menuoptions"]		>> menuoptions
	S["owned_loadout_items"] >> owned_loadout_items
	S["next_special_trait"]	>> next_special_trait
	S["multi_ready_slots"]	>> multi_ready_slots
	if(!islist(multi_ready_slots))
		multi_ready_slots = list()
	S["key_bindings"]		>> key_bindings
	if(!islist(owned_loadout_items))
		owned_loadout_items = list()

	// preference player fields
	preference_load_from_savefile(S, PREF_PLAYER)

	if(needs_update >= 0)
		update_preferences(needs_update, S)

	// Sanitize non-preference fields
	lastchangelog = sanitize_text(lastchangelog, initial(lastchangelog))
	default_slot = sanitize_integer(default_slot, 1, max_save_slots, initial(default_slot))
	menuoptions = SANITIZE_LIST(menuoptions)
	be_special = SANITIZE_LIST(be_special)
	key_bindings = sanitize_islist(key_bindings, list())

	check_new_keybindings()

	load_tickets(S)


	return TRUE

/datum/preferences/proc/save_preferences()
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"

	WRITE_FILE(S["version"], SAVEFILE_VERSION_MAX)

	// Non-preference fields
	WRITE_FILE(S["triumphs"], triumphs)
	WRITE_FILE(S["admin_ghost_icon"], admin_ghost_icon)
	WRITE_FILE(S["lastclass"], lastclass)
	WRITE_FILE(S["lastchangelog"], lastchangelog)
	WRITE_FILE(S["be_special"], be_special)
	WRITE_FILE(S["default_slot"], default_slot)
	WRITE_FILE(S["ignoring"], ignoring)
	WRITE_FILE(S["menuoptions"], menuoptions)
	WRITE_FILE(S["key_bindings"], key_bindings)
	WRITE_FILE(S["multi_ready_slots"], multi_ready_slots)
	WRITE_FILE(S["owned_loadout_items"], owned_loadout_items)
	WRITE_FILE(S["next_special_trait"], next_special_trait)

	// preference player fields
	preference_save_to_savefile(S, PREF_PLAYER)

	save_tickets(S)
	return TRUE


/datum/preferences/proc/_load_species(S)
	var/species_type = GLOB.species_list[S["species"]]
	if(!species_type)
		species_type = /datum/species/human/northern
	pref_species = new species_type()


/datum/preferences/proc/_load_appearence(S)
	S["randomise"] >> randomise

	// Override randomise flags to prevent tainted saves.
	randomise[RANDOM_BODY] = FALSE
	randomise[RANDOM_BODY_ANTAG] = FALSE
	randomise[RANDOM_UNDERWEAR] = FALSE
	randomise[RANDOM_SKIN_TONE] = FALSE
	randomise[RANDOM_EYE_COLOR] = FALSE


/datum/preferences/proc/load_character(slot)
	if(!path)
		return FALSE
	if(!fexists(path))
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"
	if(!slot)
		slot = default_slot
	slot = sanitize_integer(slot, 1, max_save_slots, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		WRITE_FILE(S["default_slot"], slot)

	S.cd = "/character[slot]"
	var/needs_update = savefile_needs_update(S)
	if(needs_update == -2)
		return FALSE

	// Systems with their own load logic
	_load_species(S)
	load_triumph_shop_character_data(S)
	load_quirks(S)

	// preference character fields
	preference_load_from_savefile(S, PREF_CHARACTER)

	// Non-preference character fields
	_load_appearence(S)

	if(!read_preference(/datum/preference/choiced/culture))
		write_preference(GLOB.preference_entries[/datum/preference/choiced/culture], /datum/culture/universal/ambiguous)

	// Custom names
	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/savefile_slot_name = custom_name_id + "_name"
		S[savefile_slot_name] >> custom_names[custom_name_id]

	// Non-preference jobs/loadout
	S["job_preferences"] >> job_preferences

	// Non-preference complex fields
	S["body_markings"] >> body_markings
	body_markings = SANITIZE_LIST(body_markings)
	validate_body_markings()

	S["descriptor_entries"] >> descriptor_entries
	descriptor_entries = SANITIZE_LIST(descriptor_entries)
	S["custom_descriptors"] >> custom_descriptors
	custom_descriptors = SANITIZE_LIST(custom_descriptors)
	validate_descriptors()

	if(needs_update >= 0)
		update_character(needs_update, S)

	// Sanitize non-preference fields
	var/gender = read_preference(/datum/preference/choiced/gender)
	var/cached_name = read_preference(/datum/preference/text/real_name)
	cached_name = reject_bad_name(cached_name)
	if(!cached_name)
		cached_name = random_unique_name(gender)
		write_preference(GLOB.preference_entries[/datum/preference/text/real_name], cached_name)

	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/namedata = GLOB.preferences_custom_names[custom_name_id]
		custom_names[custom_name_id] = reject_bad_name(custom_names[custom_name_id], namedata["allow_numbers"])
		if(!custom_names[custom_name_id])
			custom_names[custom_name_id] = get_default_name(custom_name_id)

	randomise = SANITIZE_LIST(randomise)

	if(!job_preferences)
		job_preferences = list()
	else
		for(var/j in job_preferences)
			if(job_preferences[j] != JP_LOW && job_preferences[j] != JP_MEDIUM && job_preferences[j] != JP_HIGH)
				job_preferences -= j

	S["customizer_entries"] >> customizer_entries
	validate_customizer_entries()

	return TRUE

/datum/preferences/proc/save_character()
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/character[default_slot]"

	WRITE_FILE(S["version"], SAVEFILE_VERSION_MAX)

	// preference character fields
	preference_save_to_savefile(S, PREF_CHARACTER)


	// Non-preference fields
	WRITE_FILE(S["randomise"], randomise)
	WRITE_FILE(S["job_preferences"], job_preferences)
	WRITE_FILE(S["equipped_loadout"], equipped_loadout)
	WRITE_FILE(S["equipped_loadout_colors"], equipped_loadout_colors)
	WRITE_FILE(S["single_round_loadout_colors"], single_round_loadout_colors)
	WRITE_FILE(S["single_round_loadout"], single_round_loadout)

	// Custom names
	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/savefile_slot_name = custom_name_id + "_name"
		WRITE_FILE(S[savefile_slot_name], custom_names[custom_name_id])

	// Systems with their own save logic
	WRITE_FILE(S["customizer_entries"], customizer_entries)
	WRITE_FILE(S["body_markings"], body_markings)
	WRITE_FILE(S["descriptor_entries"], descriptor_entries)
	WRITE_FILE(S["custom_descriptors"], custom_descriptors)
	save_quirks(S)

	return TRUE

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN

#ifdef TESTING
//DEBUG
//Some crude tools for testing savefiles
//path is the savefile path
/client/verb/savefile_export(path as text)
	set hidden = TRUE
	var/savefile/S = new /savefile(path)
	S.ExportText("/",file("[path].txt"))

//path is the savefile path
/client/verb/savefile_import(path as text)
	set hidden = TRUE
	var/savefile/S = new /savefile(path)
	S.ImportText("/",file("[path].txt"))

#endif

/datum/preferences/proc/check_new_keybindings()
	var/list/keybind_names = list()
	var/list/used_keys = list()
	for(var/key in key_bindings)
		keybind_names |= key_bindings[key]
		used_keys |= key

	if(!length(GLOB.hotkey_keybinding_list_by_key))
		init_keybindings()
	for(var/key in GLOB.hotkey_keybinding_list_by_key)
		var/list/key_name = GLOB.hotkey_keybinding_list_by_key[key]
		if(!length(key_name))
			continue
		if(!(key_name[1] in keybind_names))
			if(key in used_keys)
				preference_message_list |= span_bold("[key_name[1]] is unbound and the default key is in use, please set the keybind yourself!")
				continue
			key_bindings |= key
			key_bindings[key] = GLOB.hotkey_keybinding_list_by_key[key]

/datum/preferences/proc/preference_load_from_savefile(savefile/S, identifier)
	for (var/datum/preference/entry as anything in GLOB.preferences_in_priority_order)
		if (entry.savefile_identifier != identifier)
			continue
		var/raw
		S[entry.savefile_key] >> raw
		var/value
		if (!isnull(raw))
			value = entry.deserialize(raw, src)
		if (isnull(value))
			value = entry.create_informed_default_value(src)
			// Write the default back so stale/absent keys are healed immediately.
			WRITE_FILE(S[entry.savefile_key], entry.serialize(value))
		preference_cache[entry.type] = value

/datum/preferences/proc/preference_save_to_savefile(savefile/S, identifier)
	for (var/T in GLOB.preference_entries)
		var/datum/preference/entry = GLOB.preference_entries[T]
		if (entry.savefile_identifier != identifier)
			continue
		if (!(T in preference_cache))
			continue
		WRITE_FILE(S[entry.savefile_key], entry.serialize(preference_cache[T]))
