/datum/quest/custom/job_quest/farmer/harvest_crops
	required_job = /datum/job/farmer
	issue_label = "Harvest Crops"
	quest_difficulty = QUEST_DIFFICULTY_MEDIUM
	var/harvest_target = 5

/datum/quest/custom/job_quest/farmer/harvest_crops/get_title()
	return title ? title : "Bring in the Harvest"

/datum/quest/custom/job_quest/farmer/harvest_crops/get_objective_text()
	return "Harvest ready crops [progress_current]/[progress_required]."

/datum/quest/custom/job_quest/farmer/harvest_crops/get_location_text()
	return "Speak with [quest_giver_name ? quest_giver_name : "the farmer"] for instructions."

/datum/quest/custom/job_quest/farmer/harvest_crops/build_from_user(mob/user)
	var/chosen_title = tgui_input_text(user, "Give this quest a title.", "Quest Title", "Bring in the Harvest", max_length = 64)
	if(!chosen_title)
		return FALSE
	title = chosen_title

	var/count = tgui_input_number(user, "How many crops need to be harvested?", "Harvest Target", 5, 30, 1)
	if(!count || count < 1)
		return FALSE
	harvest_target = count
	progress_required = harvest_target
	return ..()

/datum/quest/custom/job_quest/farmer/harvest_crops/build_pledge(obj/item/paper/scroll/quest/pledge/PL)
	..()
	PL.pledge_generic_count = harvest_target

/datum/quest/custom/job_quest/farmer/harvest_crops/build_from_pledge(obj/item/paper/scroll/quest/pledge/PL, mob/steward)
	if(!..())
		return FALSE
	harvest_target = PL.pledge_generic_count
	progress_required = harvest_target
	return TRUE

/datum/quest/custom/job_quest/farmer/harvest_crops/register_progress_signals(mob/acceptor)
	RegisterSignal(acceptor, COMSIG_PLANT_HARVESTED, PROC_REF(on_crop_harvested))

/datum/quest/custom/job_quest/farmer/harvest_crops/unregister_progress_signals(mob/acceptor)
	UnregisterSignal(acceptor, COMSIG_PLANT_HARVESTED)

/datum/quest/custom/job_quest/farmer/harvest_crops/proc/on_crop_harvested(mob/source, obj/structure/soil/plot)
	SIGNAL_HANDLER
	advance_progress(source)
