/datum/quest/objective/thatchwood
	quest_type = QUEST_OBJECTIVE
	quest_difficulty = QUEST_DIFFICULTY_MEDIUM
	minimum_payout = QUEST_REWARD_MEDIUM_LOW
	maximum_payout = QUEST_REWARD_MEDIUM_HIGH

/datum/quest/objective/thatchwood/on_complete()
	. = ..()
	var/datum/objective_quest_driver/town_objective/driver = SSobjectivequests.get_driver(/datum/objective_quest_driver/town_objective/area/thatchwood)
	driver.check_stage_completion()

/datum/quest/objective/thatchwood/proc/on_world_progress_update()
	return
