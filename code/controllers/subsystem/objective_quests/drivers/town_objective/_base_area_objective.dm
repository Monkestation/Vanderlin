/datum/objective_quest_driver/town_objective/area
	abstract_type = /datum/objective_quest_driver/town_objective/area
	/// The area type this driver manages
	var/list/area_types = list()
	/// real list of our area types
	var/list/real_areas = list()

/datum/objective_quest_driver/town_objective/area/New()
	. = ..()
	if(!length(area_types))
		return
	for(var/area/A as anything in GLOB.areas)
		if(is_type_in_list(A, area_types))
			real_areas |= A
	setup_stages()

/datum/objective_quest_driver/town_objective/area/proc/setup_stages()
	return

/datum/objective_quest_driver/town_objective/proc/notify_active_quest(quest_type)
	if(current_stage > length(stages))
		return
	var/list/stage = stages[current_stage]
	if(!(quest_type in stage["quest_types"]))
		return
	for(var/obj/item/paper/scroll/quest/quest_scroll in GLOB.quest_scrolls)
		if(!istype(quest_scroll.assigned_quest, quest_type))
			continue
		var/datum/quest/objective/thatchwood/quest = quest_scroll.assigned_quest
		quest.on_world_progress_update()
