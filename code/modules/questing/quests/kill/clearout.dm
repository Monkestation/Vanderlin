/datum/quest/kill/clearout
	quest_type = QUEST_CLEAR_OUT
	mob_types_to_spawn = QUEST_KILL_MEDIUM_LIST
	count_min = 3
	count_max = 6

/datum/quest/kill/clearout/get_title()
	if(title)
		return title
	return "Clear out [pick("a nest of", "a den of", "a group of", "a pack of")] [pick("monsters", "bandits", "creatures", "vermin")]"

/datum/quest/kill/clearout/get_objective_text()
	return "Eliminate [progress_required] [initial(target_mob_type.name)]."

/datum/quest/kill/clearout/get_location_text()
	return target_spawn_area ? "Reported infestation in [target_spawn_area] region." : "Reported infestations in Azuria region."

/datum/quest/kill/clearout/generate(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	spawn_kill_mobs(landmark)

	return TRUE
