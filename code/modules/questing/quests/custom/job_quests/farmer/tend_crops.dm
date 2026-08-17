/datum/quest/custom/job_quest/farmer/tend_crops
	required_job = /datum/job/farmer
	issue_label = "Tend Crops"
	quest_difficulty = QUEST_DIFFICULTY_EASY
	var/tend_target = 10

/datum/quest/custom/job_quest/farmer/tend_crops/get_title()
	return title ? title : "Tend the Fields"

/datum/quest/custom/job_quest/farmer/tend_crops/get_objective_text()
	return "Tend crops [progress_current]/[progress_required] times (weeding, hoeing, or otherwise caring for planted soil)."

/datum/quest/custom/job_quest/farmer/tend_crops/get_location_text()
	return "Speak with [quest_giver_name ? quest_giver_name : "the farmer"] for instructions."

/datum/quest/custom/job_quest/farmer/tend_crops/build_from_user(mob/user)
	var/chosen_title = tgui_input_text(user, "Give this quest a title.", "Quest Title", "Tend the Fields", max_length = 64)
	if(!chosen_title)
		return FALSE
	title = chosen_title

	var/count = tgui_input_number(user, "How many tending actions should be required?", "Tend Target", 10, 50, 1)
	if(!count || count < 1)
		return FALSE
	tend_target = count
	progress_required = tend_target
	return ..()

/datum/quest/custom/job_quest/farmer/tend_crops/build_pledge(obj/item/paper/scroll/quest/pledge/PL)
	..()
	PL.pledge_generic_count = tend_target

/datum/quest/custom/job_quest/farmer/tend_crops/build_from_pledge(obj/item/paper/scroll/quest/pledge/PL, mob/steward)
	if(!..())
		return FALSE
	tend_target = PL.pledge_generic_count
	progress_required = tend_target
	return TRUE

/datum/quest/custom/job_quest/farmer/tend_crops/register_progress_signals(mob/acceptor)
	RegisterSignal(acceptor, COMSIG_PLANT_TENDED, PROC_REF(on_crop_tended))

/datum/quest/custom/job_quest/farmer/tend_crops/unregister_progress_signals(mob/acceptor)
	UnregisterSignal(acceptor, COMSIG_PLANT_TENDED)

/datum/quest/custom/job_quest/farmer/tend_crops/proc/on_crop_tended(mob/source, obj/structure/soil/plot)
	SIGNAL_HANDLER
	advance_progress(source)
