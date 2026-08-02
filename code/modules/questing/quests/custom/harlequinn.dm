
/datum/quest/custom/harlequinn_hunt
	issue_label = "Hunt"
	custom_quest_flags = NONE // Never appears in the manual issue picker
	var/datum/weakref/target_harlequinn
	var/harlequinn_region = "the realm"

/datum/quest/custom/harlequinn_hunt/get_title()
	return "Hunt the Harlequinn"

/datum/quest/custom/harlequinn_hunt/get_objective_text()
	return "A Harlequinn has been spotted near [harlequinn_region]. Hunt them down and report to a guild steward."

/datum/quest/custom/harlequinn_hunt/get_location_text()
	return "Last sighted near [harlequinn_region]."

/datum/quest/custom/harlequinn_hunt/generate(obj/effect/landmark/quest_spawner/landmark)
	add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_QUEST_CREATED, 1)
	title = get_title()
	quest_difficulty = QUEST_DIFFICULTY_HARD
	reward_amount = HARLEQUINN_HUNT_REWARD
	progress_required = 1
	return TRUE

/datum/quest/custom/harlequinn_hunt/proc/mark_harlequinn_dead()
	progress_current = 1

/datum/quest/custom/harlequinn_hunt/check_completion()
	return progress_current >= progress_required

/datum/quest/custom/harlequinn_hunt/validate(mob/steward, turf/input_point)
	var/mob/living/carbon/human/H = target_harlequinn?.resolve()
	if(QDELETED(H) || H.stat == DEAD)
		return steward_validate(steward)
	return FALSE

/datum/quest/custom/harlequinn_hunt/on_validate_fail(mob/steward, turf/input_point, atom/movable/talker)
	talker.say("The Harlequinn still breathes. Finish the job first.")

/datum/quest/custom/harlequinn_hunt/Destroy()
	var/datum/weakref/hunt_ref = GLOB.harlequinn_hunt_quest
	var/datum/quest/custom/harlequinn_hunt/existing = hunt_ref?.resolve()
	if(existing == src)
		GLOB.harlequinn_hunt_quest = null
	return ..()
