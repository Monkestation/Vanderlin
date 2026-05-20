// Easy kill quests
/datum/quest/kill/easy
	quest_type = QUEST_KILL_EASY
	mob_types_to_spawn = QUEST_KILL_MOBS_LIST
	count_min = 1
	count_max = 3

/datum/quest/kill/easy/get_title()
	if(title)
		return title
	return "Slay [pick("a dangerous", "a fearsome", "a troublesome", "an elusive")] [pick("beast", "monster", "brigand", "creature")]"

/datum/quest/kill/easy/get_objective_text()
	return "Slay [progress_required] [initial(target_mob_type.name)]."

/datum/quest/kill/easy/generate(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	spawn_kill_mobs(landmark)

	return TRUE
