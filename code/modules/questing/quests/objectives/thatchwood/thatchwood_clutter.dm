/datum/quest/objective/thatchwood/clear_clutter
	title = "Clean Up the Clutter"

/datum/quest/objective/thatchwood/clear_clutter/generate(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(!.)
		return FALSE
	var/datum/objective_quest_driver/town_objective/area/thatchwood/driver = SSobjectivequests.get_driver(/datum/objective_quest_driver/town_objective/area/thatchwood)
	if(!driver)
		return FALSE
	progress_required = driver.clutter_count
	return TRUE

/datum/quest/objective/thatchwood/clear_clutter/get_objective_text()
	return "Clear the junk and clutter littering Thatchwood. ([progress_current]/[progress_required] removed)"

/datum/quest/objective/thatchwood/clear_clutter/get_location_text()
	return "Clutter has been reported throughout Thatchwood."

/datum/quest/objective/thatchwood/clear_clutter/on_world_progress_update()
	var/datum/objective_quest_driver/town_objective/area/thatchwood/driver = SSobjectivequests.get_driver(/datum/objective_quest_driver/town_objective/area/thatchwood)
	if(!driver)
		return
	progress_current = driver.initial_clutter_count - driver.clutter_count
	on_progress_update()
