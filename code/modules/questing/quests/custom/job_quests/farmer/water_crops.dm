/datum/quest/custom/job_quest/farmer/water_crops
	required_job = /datum/job/farmer
	issue_label = "Water Crops"
	quest_difficulty = QUEST_DIFFICULTY_EASY
	var/water_target = 8

/datum/quest/custom/job_quest/farmer/water_crops/get_title()
	return title ? title : "Water the Fields"

/datum/quest/custom/job_quest/farmer/water_crops/get_objective_text()
	return "Water soil plots [progress_current]/[progress_required]."

/datum/quest/custom/job_quest/farmer/water_crops/get_location_text()
	return "Speak with [quest_giver_name ? quest_giver_name : "the farmer"] for instructions."

/datum/quest/custom/job_quest/farmer/water_crops/build_from_user(mob/user)
	var/chosen_title = tgui_input_text(user, "Give this quest a title.", "Quest Title", "Water the Fields", max_length = 64)
	if(!chosen_title)
		return FALSE
	title = chosen_title

	var/count = tgui_input_number(user, "How many plots need to be watered?", "Water Target", 8, 40, 1)
	if(!count || count < 1)
		return FALSE
	water_target = count
	progress_required = water_target
	return ..()

/datum/quest/custom/job_quest/farmer/water_crops/build_pledge(obj/item/paper/scroll/quest/pledge/PL)
	..()
	PL.pledge_generic_count = water_target

/datum/quest/custom/job_quest/farmer/water_crops/build_from_pledge(obj/item/paper/scroll/quest/pledge/PL, mob/steward)
	if(!..())
		return FALSE
	water_target = PL.pledge_generic_count
	progress_required = water_target
	return TRUE

/datum/quest/custom/job_quest/farmer/water_crops/register_progress_signals(mob/acceptor)
	RegisterSignal(acceptor, COMSIG_PLANT_WATERED, PROC_REF(on_crop_watered))

/datum/quest/custom/job_quest/farmer/water_crops/unregister_progress_signals(mob/acceptor)
	UnregisterSignal(acceptor, COMSIG_PLANT_WATERED)

/datum/quest/custom/job_quest/farmer/water_crops/proc/on_crop_watered(mob/source, obj/structure/soil/plot)
	SIGNAL_HANDLER
	advance_progress(source)
