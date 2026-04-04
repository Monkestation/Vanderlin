// Base for kill quests
/datum/quest/kill
	var/list/mob_types_to_spawn = list()
	var/count_min = 1
	var/count_max = 3

/datum/quest/kill/proc/spawn_kill_mobs(obj/effect/landmark/quest_spawner/landmark)
	target_mob_type = pick(mob_types_to_spawn)
	progress_required = rand(count_min, count_max)
	target_spawn_area = get_area_name(get_turf(landmark))

	// Spawn mobs
	for(var/i in 1 to progress_required)
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue

		var/obj/effect/quest_spawn/spawn_effect = new /obj/effect/quest_spawn(spawn_turf)
		var/mob/living/new_mob = new target_mob_type(spawn_effect)
		new_mob.faction |= "quest"
		new_mob.AddComponent(/datum/component/quest_object/kill, src)
		ADD_TRAIT(new_mob, TRAIT_FRESHSPAWN, "[type]")
		addtimer(TRAIT_CALLBACK_REMOVE(new_mob, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
		addtimer(CALLBACK(new_mob, TYPE_PROC_REF(/mob/living, setup_equip_block)), 3 SECONDS)
		spawn_effect.contained_atom = new_mob
		spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
		add_tracked_atom(new_mob)
		landmark.add_quest_faction_to_nearby_mobs(spawn_turf)
		sleep(1)

/datum/quest/kill/get_additional_reward()
	..()
	// Additional reward based on mob difficulty and number required
	var/mob_type_difficulty = QUEST_KILL_MOBS_LIST[target_mob_type]
	return progress_required * mob_type_difficulty
