GLOBAL_LIST_EMPTY(alt_title_singletons)


/datum/alt_title
	var/title = ""
	var/title_female
	var/alt_title_flags = NONE
	var/required_award

/datum/alt_title/proc/get_title(female = FALSE)
	if(female && title_female)
		return title_female
	return title

/datum/alt_title/proc/is_unlocked_for(client/C)
	if(required_award)
		if(!length(SSachievements.awards))
			SSachievements.setup()
		var/datum/award/A = SSachievements.awards[required_award]
		if(!A)
			return FALSE
		if(istype(A, /datum/award/achievement/progress))
			var/datum/award/achievement/progress/PA = A
			if(C.player_details.achievements.get_achievement_status(required_award) < PA.required_progress)
				return FALSE
		else if(istype(A, /datum/award/achievement))
			if(C.player_details.achievements.get_achievement_status(required_award) != TRUE)
				return FALSE
		else if(istype(A, /datum/award/score))
			if(C.player_details.achievements.get_achievement_status(required_award) <= 0)
				return FALSE
	if(alt_title_flags & ALT_TITLE_FLAG_PATREON_LOCKED)
		if(!C?.patreon?.is_donator())
			return FALSE
	return TRUE

/// Human-readable reason this entry is locked. Only meaningful to call when is_unlocked_for() is FALSE.
/datum/alt_title/proc/get_lock_reason()
	if(alt_title_flags & ALT_TITLE_FLAG_PATREON_LOCKED)
		return "Requires Patreon donator status"
	if(required_award)
		if(!length(SSachievements.awards))
			SSachievements.setup()
		var/datum/award/A = SSachievements.awards[required_award]
		if(istype(A, /datum/award/achievement/progress))
			var/datum/award/achievement/progress/PA = A
			return "Requires achievement: [PA.name] ([PA.required_progress] progress)"
		if(A)
			return "Requires achievement: [A.name]"
		return "Requires an achievement"
	return "Locked"


/// Cache of path -> singleton instance so we're not `new`-ing these every UI update.
/proc/get_alt_title_instance(path)
	if(!ispath(path, /datum/alt_title))
		return null
	if(!GLOB.alt_title_singletons)
		GLOB.alt_title_singletons = list()
	if(!GLOB.alt_title_singletons[path])
		GLOB.alt_title_singletons[path] = new path()
	return GLOB.alt_title_singletons[path]
