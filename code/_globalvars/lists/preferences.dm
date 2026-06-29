/// Assoc list: preference_type -> instantiated /datum/preference
GLOBAL_LIST_INIT(preference_entries, init_preference_entries())

/// Assoc list: savefile_key -> instantiated /datum/preference
GLOBAL_LIST_INIT(preference_entries_by_key, init_preference_entries_by_key())

GLOBAL_LIST_INIT(preferences_in_priority_order, build_preferences_in_priority_order())

/proc/init_preference_entries()
	var/list/output = list()
	for (var/datum/preference/T as anything in subtypesof(/datum/preference))
		if (initial(T.abstract_type) == T)
			continue
		output[T] = new T
	return output

/proc/init_preference_entries_by_key()
	var/list/output = list()
	for (var/datum/preference/T as anything in subtypesof(/datum/preference))
		if (initial(T.abstract_type) == T)
			continue
		output[initial(T.savefile_key)] = GLOB.preference_entries[T]
	return output

/// Returns a flat list of all Vanderlin preferences sorted by priority.
/proc/build_preferences_in_priority_order()
	var/list/by_priority[MAX_PREF_PRIORITY]
	for (var/T in GLOB.preference_entries)
		var/datum/preference/pref = GLOB.preference_entries[T]
		LAZYADD(by_priority[pref.priority], pref)
	var/list/flat = list()
	for (var/i in 1 to MAX_PREF_PRIORITY)
		if (!by_priority[i])
			continue
		flat += by_priority[i]
	return flat
