/datum/achievement_data
	///Ckey of this achievement data's owner
	var/owner_ckey
	///Current values for each achievement typepath (TRUE/FALSE for achievements, numeric for scores/progress)
	var/list/data = list()
	///Snapshot of values at load time, used to detect dirty state (kept for compatibility, less critical now)
	var/list/original_cached_data = list()
	///Have we done our set-up yet?
	var/initialized = FALSE
	///Save file name used in the save manager
	var/save_file_name = "achievements"

/datum/achievement_data/New(ckey)
	owner_ckey = ckey
	if(SSachievements.initialized && !initialized)
		InitializeData()

/datum/achievement_data/proc/InitializeData()
	initialized = TRUE
	load_all_achievements()

/// Saves all dirty achievement data via the save manager.
/datum/achievement_data/proc/save_achievements()
	var/datum/save_manager/SM = get_save_manager(owner_ckey)
	if(!SM)
		return FALSE

	// Serialize the data list: keys are typepaths (stringified), values are the achievement state.
	// We store the entire achievement data blob as a single key for simplicity.
	var/list/serialized = list()
	for(var/T in data)
		serialized["[T]"] = data[T]

	return SM.set_data(save_file_name, "achievement_data", serialized)

/// Loads all achievements from the save manager, falling back to defaults.
/datum/achievement_data/proc/load_all_achievements()
	var/datum/save_manager/SM = get_save_manager(owner_ckey)
	var/list/saved = list()

	if(SM)
		saved = SM.get_data(save_file_name, "achievement_data", list())
		if(!islist(saved))
			saved = list()

	for(var/T in subtypesof(/datum/award))
		var/datum/award/A = SSachievements.awards[T]
		if(!A || !A.name) // Skip abstract types
			continue

		var/text_key ="[T]"
		if(text_key in saved)
			data[T] = A.parse_value(saved[text_key])
		else
			data[T] = A.default_value

		original_cached_data[T] = data[T]

/// Ensures a specific achievement's data is loaded (lazy load fallback, now just checks local cache).
/datum/achievement_data/proc/get_data(achievement_type)
	var/datum/award/A = SSachievements.awards[achievement_type]
	if(!A || !A.name)
		return FALSE
	// If somehow not in cache, populate with default
	if(isnull(data[achievement_type]))
		data[achievement_type] = A.default_value
		original_cached_data[achievement_type] = A.default_value

/**
 * Unlocks or increments an achievement.
 *
 * - For /datum/award/achievement: one-shot unlock (idempotent).
 * - For /datum/award/achievement/progress: increments progress by `value`; unlocks when progress >= required_progress.
 * - For /datum/award/score: increments the score by `value`.
 *
 * @param achievement_type  Typepath of the /datum/award subtype.
 * @param user              Mob receiving the award (for notifications).
 * @param value             Amount to increment (ignored for plain achievements).
 */
/datum/achievement_data/proc/unlock(achievement_type, mob/user, value = 1)
	set waitfor = FALSE
	if(!SSachievements.achievements_enabled)
		return
	var/datum/award/A = SSachievements.awards[achievement_type]
	if(!A)
		return
	get_data(achievement_type)

	if(istype(A, /datum/award/achievement/progress))
		var/datum/award/achievement/progress/PA = A
		if(data[achievement_type] >= PA.required_progress) // Already completed
			return
		data[achievement_type] = min(data[achievement_type] + value, PA.required_progress)
		if(user && PA.show_progress_messages)
			to_chat(user, span_notice("[PA.name]: [data[achievement_type]]/[PA.required_progress]"))
		if(data[achievement_type] >= PA.required_progress)
			A.inform_user(user)
			A.on_unlock(user)
		save_achievements()

	else if(istype(A, /datum/award/achievement))
		if(data[achievement_type]) // Already unlocked
			return
		data[achievement_type] = TRUE
		A.inform_user(user)
		A.on_unlock(user)
		save_achievements()

	else if(istype(A, /datum/award/score))
		data[achievement_type] += value
		A.inform_user(user)
		save_achievements()

/// Returns the current status/score/progress of an achievement.
/datum/achievement_data/proc/get_achievement_status(achievement_type)
	return data[achievement_type]

/// Returns progress info for a progress achievement as a text string, e.g. "5/10".
/datum/achievement_data/proc/get_progress_string(achievement_type)
	var/datum/award/A = SSachievements.awards[achievement_type]
	if(!istype(A, /datum/award/achievement/progress))
		return null
	var/datum/award/achievement/progress/PA = A
	return "[data[achievement_type]]/[PA.required_progress]"

/// Resets an achievement to its default value and saves.
/datum/achievement_data/proc/reset(achievement_type)
	if(!SSachievements.achievements_enabled)
		return
	var/datum/award/A = SSachievements.awards[achievement_type]
	get_data(achievement_type)
	if(istype(A, /datum/award/achievement)) // covers progress too since it's a subtype
		data[achievement_type] = FALSE
		if(istype(A, /datum/award/achievement/progress))
			data[achievement_type] = 0
	else if(istype(A, /datum/award/score))
		data[achievement_type] = 0
	save_achievements()
