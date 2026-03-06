/datum/award/achievement/progress
	desc = "Keep at it!"
	/// How much progress is needed to unlock this achievement.
	var/required_progress = 10
	/// Whether to send incremental progress messages to the player.
	var/show_progress_messages = FALSE
	default_value = 0  // Progress starts at 0, not FALSE

/datum/award/achievement/progress/get_metadata_row()
	. = ..()
	.["achievement_type"] = "progress"
	.["required_progress"] = required_progress

/// For a progress achievement, the "value" stored is a number 0..required_progress.
/// It counts as unlocked when value >= required_progress.
/datum/award/achievement/progress/parse_value(raw_value)
	return isnum(raw_value) ? clamp(raw_value, 0, required_progress) : 0

/datum/award/achievement/progress/rat_genocide
	name = "Rous Genocide"
	desc = "What the fuck man."
	icon = "rat_killer"
	category = "Combat"
	database_id = "rat_killer_progress"
	required_progress = 3000
	award_flags = AWARD_FLAG_REWARD

/datum/award/achievement/progress/rat_genocide/return_reward_string()
	var/reward_string = ..()
	reward_string += "Pocket Rous"
	return reward_string
