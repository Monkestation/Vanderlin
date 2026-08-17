/datum/quest/objective/clean_mess
	title = "Clean Up the Mess"
	quest_type = QUEST_OBJECTIVE
	quest_difficulty = QUEST_DIFFICULTY_EASY
	minimum_payout = QUEST_REWARD_EASY_LOW
	maximum_payout = QUEST_REWARD_EASY_HIGH

	/// How many messes the claimant needs to clean
	var/messes_to_clean = 5

/datum/quest/objective/clean_mess/generate(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(!.)
		return FALSE
	// Scale required cleans to how bad the current mess situation is
	var/datum/objective_quest_driver/mess/driver = SSobjectivequests.get_driver(/datum/objective_quest_driver/mess)
	if(driver)
		messes_to_clean = clamp(round(driver.current_value / 2), 3, 15)
	progress_required = messes_to_clean
	title = "Clean Filth"
	return TRUE

/datum/quest/objective/clean_mess/get_objective_text()
	return "Clean up [progress_current]/[progress_required] piles of filth around the town."

/datum/quest/objective/clean_mess/get_location_text()
	return "Piles of filth have been reported throughout the town."

/datum/quest/objective/clean_mess/register_signals(mob/user)
	RegisterSignal(user, COMSIG_MOB_WASHED_MESS, PROC_REF(on_mess_cleaned))

/datum/quest/objective/clean_mess/proc/on_mess_cleaned(mob/source, obj/effect/decal/cleanable/mess)
	if(complete)
		return
	progress_current++
	on_progress_update()

/datum/quest/objective/unregister_signals(mob/user)
	UnregisterSignal(user, COMSIG_MOB_WASHED_MESS)
