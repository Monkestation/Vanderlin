/datum/quest/objective/thatchwood/clear_trees
	title = "Clear the Overgrowth"

/datum/quest/objective/thatchwood/clear_trees/generate(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(!.)
		return FALSE
	var/datum/objective_quest_driver/town_objective/area/thatchwood/driver = SSobjectivequests.get_driver(/datum/objective_quest_driver/town_objective/area/thatchwood)
	if(!driver)
		return FALSE
	progress_required = CEILING(driver.tree_count * 0.8, 1)
	return TRUE

/datum/quest/objective/thatchwood/clear_trees/get_objective_text()
	return "Clear the overgrown trees blocking Thatchwood's expansion. ([progress_current]/[progress_required] cleared)"

/datum/quest/objective/thatchwood/clear_trees/get_location_text()
	return "Dense overgrowth has been reported throughout Thatchwood."

/datum/quest/objective/thatchwood/clear_trees/on_world_progress_update()
	var/datum/objective_quest_driver/town_objective/area/thatchwood/driver = SSobjectivequests.get_driver(/datum/objective_quest_driver/town_objective/area/thatchwood)
	if(!driver)
		return
	progress_current = driver.initial_tree_count - driver.tree_count
	on_progress_update()
