/datum/quest/kill/raid
	quest_type = QUEST_RAID
	mob_types_to_spawn = QUEST_RAID_LIST
	count_min = 4
	count_max = 6

/datum/quest/kill/raid/get_title()
	if(title)
		return title
	return "Stop a raid of [pick("slavers", "bandits", "brigands", "raiders")]"

/datum/quest/kill/raid/get_objective_text()
	return "Eliminate [progress_required] [initial(target_mob_type.name)]."

/datum/quest/kill/raid/get_location_text()
	return target_spawn_area ? "Reported raid in [target_spawn_area] region." : "Reported infestations in Azuria region."

/datum/quest/kill/raid/generate(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	spawn_kill_mobs(landmark)

	return TRUE
