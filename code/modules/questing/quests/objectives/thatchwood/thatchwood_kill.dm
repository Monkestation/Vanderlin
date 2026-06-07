/datum/quest/objective/thatchwood/kill
	title = "Drive Out the Hostiles"

/datum/quest/objective/thatchwood/kill/generate(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(!.)
		return FALSE
	var/datum/objective_quest_driver/town_objective/area/thatchwood/driver = SSobjectivequests.get_driver(/datum/objective_quest_driver/town_objective/area/thatchwood)
	if(!driver)
		return FALSE
	progress_required = driver.mob_count
	return TRUE

/datum/quest/objective/thatchwood/kill/get_objective_text()
	return "Drive out the hostile creatures lurking in Thatchwood. ([progress_current]/[progress_required] slain)"

/datum/quest/objective/thatchwood/kill/get_location_text()
	return "Hostiles have been spotted throughout Thatchwood."

/datum/quest/objective/thatchwood/kill/on_world_progress_update()
	var/datum/objective_quest_driver/town_objective/area/thatchwood/driver = SSobjectivequests.get_driver(/datum/objective_quest_driver/town_objective/area/thatchwood)
	if(!driver)
		return
	progress_current = driver.initial_mob_count - driver.mob_count
	on_progress_update()

/datum/quest/objective/thatchwood/kill/get_target_location()
	var/datum/objective_quest_driver/town_objective/area/thatchwood/driver = SSobjectivequests.get_driver(/datum/objective_quest_driver/town_objective/area/thatchwood)
	if(!driver || !length(driver.mobs))
		return null
	return get_turf(pick(driver.mobs))
