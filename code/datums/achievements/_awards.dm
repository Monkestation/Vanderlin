/datum/award
	///Name of the achievement, If null it won't show up in the achievement browser. (Handy for inheritance trees)
	var/name
	var/desc = "You did it."
	///Found in ui_icons/achievements
	var/icon = "default"
	var/category = "Normal"

	///What ID do we use in db, limited to 32 characters
	var/database_id
	//Bump this up if you're changing outdated table identifier and/or achievement type
	var/achievement_version = 2

	//Value returned on db connection failure, in case we want to differ 0 and nonexistent later on
	var/default_value = FALSE
	/// Whether this is a positive or negative achievement (overdosing on crack and dying is a negative, for example)
	var/achievement_quality = ACHIEVEMENT_NEUTRAL
	/// Whether or not we get an unlock message
	var/unlock_message = FALSE
	/// Whether or not we should play the unlocking sound
	var/unlock_sound = FALSE
	 /// If set, this many triumphs are granted when the achievement is first unlocked
	var/triumph_reward = 0
	///these are the flags we have
	var/award_flags = NONE

///This proc loads the achievement data from the hub.
/datum/award/proc/load(key)
	if(!SSdbcore.Connect())
		return default_value
	if(!key || !database_id || !name)
		return default_value
	var/raw_value = get_raw_value(key)
	return parse_value(raw_value)

///This saves the changed data to the hub.
/datum/award/proc/get_changed_rows(key, value)
	if(!database_id || !key || !name)
		return
	return list(
		"ckey" = key,
		"achievement_key" = database_id,
		"value" = value,
	)

/datum/award/proc/get_metadata_row()
	return list(
		"achievement_key" = database_id,
		"achievement_version" = achievement_version,
		"achievement_type" = "award",
		"achievement_name" = name,
		"achievement_description" = desc,
	)

///Get raw numerical achievement value from the database
/datum/award/proc/get_raw_value(key)
	var/datum/DBQuery/Q = SSdbcore.NewQuery(
		"SELECT value FROM [format_table_name("achievements")] WHERE ckey = :ckey AND achievement_key = :achievement_key",
		list("ckey" = key, "achievement_key" = database_id)
	)
	if(!Q.Execute(async = TRUE))
		qdel(Q)
		return 0
	var/result = 0
	if(Q.NextRow())
		result = text2num(Q.item[1])
	qdel(Q)
	return result

//Should return sanitized value for achievement cache
/datum/award/proc/parse_value(raw_value)
	return default_value

///Can be overriden for achievement specific events
/datum/award/proc/on_unlock(mob/user)
	return

/datum/award/proc/return_reward_string()
	SHOULD_CALL_PARENT(TRUE)
	var/reward_str = "Reward: "
	if(triumph_reward)
		reward_str += "[triumph_reward] Triumph\s"
	return reward_str

/datum/award/proc/inform_user(mob/user)
	var/unlock_text = ""
	var/unlock_sound_file = null
	switch(achievement_quality)
		if(ACHIEVEMENT_RARE)
			if(unlock_message)
				unlock_text = span_achievementrare("Achievement unlocked:\n<b>[name]</b>")
			if(unlock_sound)
				unlock_sound_file = 'sound/achievement/achievement_rare.wav'
		if(ACHIEVEMENT_GOOD)
			if(unlock_message)
				unlock_text = span_achievementgood("Achievement unlocked:\n<b>[name]</b>")
			if(unlock_sound)
				unlock_sound_file = 'sound/achievement/achievement_good.wav'
		if(ACHIEVEMENT_NEUTRAL)
			if(unlock_message)
				unlock_text = span_achievementneutral("Achievement unlocked:\n<b>[name]</b>")
			if(unlock_sound)
				unlock_sound_file = 'sound/achievement/achievement_neutral.wav'
		if(ACHIEVEMENT_BAD)
			if(unlock_message)
				unlock_text = span_achievementbad("Achievement unlocked:\n<b>[name]</b>")
			if(unlock_sound)
				unlock_sound_file = 'sound/achievement/achievement_bad.wav'
	if(unlock_text)
		to_chat(user, unlock_text)
	if(unlock_sound_file)
		var/sound/sounding = sound(unlock_sound_file, FALSE, 0, volume = 75)
		SEND_SOUND(user, sounding)
	if(unlock_message) // <-- only show popup if this award type uses messages
		show_achievement_toast(user, src)

///Achievements are one-off awards for usually doing cool things.
/datum/award/achievement
	desc = "Achievement for epic people"
	unlock_message = TRUE
	unlock_sound = TRUE

/datum/award/achievement/on_unlock(mob/user)
	. = ..()
	if(triumph_reward && user)
		user.adjust_triumphs(triumph_reward, counted = TRUE, reason = "Achievement unlocked: [name]", silent = TRUE)

/datum/award/achievement/get_metadata_row()
	. = ..()
	.["achievement_type"] = "achievement"

/datum/award/achievement/parse_value(raw_value)
	return raw_value > 0

///Scores are for leaderboarded things, such as killcount of a specific boss
/datum/award/score
	desc = "you did it sooo many times."
	category = "Scores"
	default_value = 0

	var/track_high_scores = TRUE
	var/list/high_scores = list()

/datum/award/score/New()
	. = ..()
	if(track_high_scores)
		LoadHighScores()

/datum/award/score/get_metadata_row()
	. = ..()
	.["achievement_type"] = "score"

/datum/award/score/proc/LoadHighScores()
	var/datum/DBQuery/Q = SSdbcore.NewQuery(
		"SELECT ckey,value FROM [format_table_name("achievements")] WHERE achievement_key = :achievement_key ORDER BY value DESC LIMIT 50",
		list("achievement_key" = database_id)
	)
	if(!Q.Execute(async = TRUE))
		qdel(Q)
		return
	else
		while(Q.NextRow())
			var/key = Q.item[1]
			var/score = text2num(Q.item[2])
			high_scores[key] = score
		qdel(Q)

/datum/award/score/parse_value(raw_value)
	return isnum(raw_value) ? raw_value : 0
