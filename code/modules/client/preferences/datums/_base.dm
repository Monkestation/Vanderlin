/datum/preference
	/// Set to the type itself on abstract datums to prevent instantiation.
	abstract_type = /datum/preference

	///if we are dynamic basically do we need to read a species pref or something aswell?
	var/dynamic = FALSE

	/// Key used in the savefile and sent to the UI. Never change after first use.
	var/savefile_key

	/// UI category grouping key (interpreted by the frontend).
	var/category = "misc"

	/// PREF_CHARACTER or PREF_PLAYER.
	var/savefile_identifier

	/// Determines application order. Use PREF_PRIORITY_* defines.
	var/priority = PREF_PRIORITY_DEFAULT

	/// Whether this preference can be randomised (character prefs only).
	var/can_randomize = TRUE

	/// Whether randomisation is on by default when "random body" is enabled.
	var/randomize_by_default = TRUE

	/// If non-null, only show when the species has this in mutant_bodyparts.
	var/relevant_mutant_bodypart = null

	/// If non-null, only show when the species has this in inherent_traits.
	var/relevant_inherent_trait = null

	/// If non-null, only show when the species has this in organs.
	var/relevant_organ = null

	/// If non-null, only show when the species has this head_flag.
	var/relevant_head_flag = null

	/// Whether null is an acceptable value.
	var/allows_nulls = FALSE

	/// Whether null is the default value.
	var/default_null = FALSE

	/// Whether changing this preference should trigger a character preview refresh.
	var/should_update_preview = TRUE

	///if this is a preference we don't natively apply
	var/should_apply = TRUE

/// Deserialise a raw savefile/UI value into the typed preference value.
/// Must be overridden. May return null if the value is unusable.
/datum/preference/proc/deserialize(input, datum/preferences/prefs)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`deserialize()` not implemented on [type]!")

/// Serialise a typed value back into the savefile representation.
/datum/preference/proc/serialize(input)
	SHOULD_NOT_SLEEP(TRUE)
	return input

/// Produce a default (possibly random) value when nothing is in the savefile.
/datum/preference/proc/create_default_value(datum/preferences/prefs)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`create_default_value(prefs)` not implemented on [type]!")

/// Like create_default_value(prefs) but receives the preferences datum for context.
/datum/preference/proc/create_informed_default_value(datum/preferences/prefs)
	return create_default_value(prefs)

/// Produce a random value for character randomisation.
/datum/preference/proc/create_random_value(datum/preferences/prefs)
	return create_informed_default_value(prefs)

/// Returns TRUE if this preference can be randomised.
/datum/preference/proc/is_randomizable()
	SHOULD_NOT_OVERRIDE(TRUE)
	return savefile_identifier == PREF_CHARACTER && can_randomize

/// Read from a save_data assoc list, returning null if absent.
/datum/preference/proc/read(list/save_data, datum/preferences/prefs)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (isnull(save_data))
		return null
	var/value = save_data[savefile_key]
	if (isnull(value))
		return null
	return deserialize(value, prefs)

/// Validate a value. Must be overridden.
/datum/preference/proc/is_valid(value, datum/preferences/prefs)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`is_valid()` not implemented on [type]!")

/// Apply to a client (PREF_PLAYER prefs).
/datum/preference/proc/apply_to_client(client/C, value)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	return

/// Called when a player preference is updated live.
/datum/preference/proc/apply_to_client_updated(client/C, value)
	SHOULD_NOT_SLEEP(TRUE)
	apply_to_client(C, value)

/// Apply to a human mob (PREF_CHARACTER prefs).
/datum/preference/proc/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`apply_to_human()` not implemented on [type]!")

/// Returns UI data for this preference's current value.
/datum/preference/proc/compile_ui_data(mob/user, value)
	SHOULD_NOT_SLEEP(TRUE)
	return serialize(value)

/// Returns static data baked into the preferences JSON asset.
/datum/preference/proc/compile_constant_data()
	SHOULD_NOT_SLEEP(TRUE)
	return null

/// Returns TRUE if this preference should be shown and editable.
/datum/preference/proc/is_accessible(datum/preferences/prefs)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return TRUE

/datum/preferences/proc/read_preference(preference_type)
	var/datum/preference/entry = GLOB.preference_entries[preference_type]
	if (isnull(entry))
		CRASH("preference type `[preference_type]` is not registered!")

	if (preference_type in preference_cache)
		return preference_cache[preference_type]

	// Cache miss after load, generate and cache a default.
	// This should only happen for preferences added after the player last logged in.
	var/value = entry.create_informed_default_value(src)
	preference_cache[preference_type] = value
	return value

/datum/preferences/proc/read_assoc_preference(preference_type, key)
	var/datum/preference/entry = GLOB.preference_entries[preference_type]
	var/list/value = list()
	if (isnull(entry))
		CRASH("preference type `[preference_type]` is not registered!")

	if (preference_type in preference_cache)
		value = preference_cache[preference_type]
	if(!islist(value))
		CRASH("preference type `[preference_type]` is not a list type preference!")

	if(value)
		return value[key]
	preference_cache[preference_type] = value
	return value[key]

/// Return the default value of a given preference, useful for resetting some
/datum/preferences/proc/read_default_preference(preference_type)
	var/datum/preference/entry = GLOB.preference_entries[preference_type]
	if (isnull(entry))
		CRASH("preference type `[preference_type]` is not registered!")
	return entry.create_informed_default_value(src)

/// Deserialise and cache a new value for a preference.
/// Does NOT write to the savefile, should be used when save_preferences() is called at the end of the block
/// Returns TRUE on success, FALSE if validation fails.
/datum/preferences/proc/write_preference(datum/preference/pref, value)
	if(!istype(pref))
		pref = GLOB.preference_entries[pref]
	var/typed = pref.deserialize(value, src)
	if (!pref.is_valid(typed, src))
		return FALSE
	preference_cache[pref.type] = typed
	return TRUE

/// Deserialise and cache the toggled state for a preference.
/// Does NOT write to the savefile, should be used when save_preferences() is called at the end of the block
/// Returns TRUE on success, FALSE if validation fails.
/datum/preferences/proc/toggle_preference(datum/preference/pref)
	if(!istype(pref))
		pref = GLOB.preference_entries[pref]
	if(!istype(pref, /datum/preference/toggle))
		CRASH(" toggle_preference() called with a non toggle preference [pref.type].")
	var/old_value = read_preference(pref)
	var/typed = pref.deserialize(!old_value, src)
	if (!pref.is_valid(typed, src))
		return FALSE
	preference_cache[pref.type] = typed
	return TRUE

/// Update a preference in-memory and immediately apply it to the live
/// client or character preview. Does NOT write to the savefile.
/// Returns TRUE on success.
/datum/preferences/proc/update_preference(datum/preference/pref, value)
	if(!istype(pref))
		pref = GLOB.preference_entries[pref]
	var/typed = pref.deserialize(value, src)
	if (!pref.is_valid(typed, src))
		return FALSE

	preference_cache[pref.type] = typed

	if (pref.savefile_identifier == PREF_PLAYER)
		pref.apply_to_client_updated(parent, typed)
	else if (pref.should_update_preview)
		update_preview_icon()

	return TRUE

/// This basically exists to move process_Link logic into its own datum,
/// this means adding new thnigs to the menu should use the savefile key
/// Returns TRUE on success
/datum/preference/proc/handle_link(datum/preferences/prefs, mob/user)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("`handle_link()` not implemented on [type]!")
