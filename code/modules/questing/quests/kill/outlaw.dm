/datum/quest/kill/outlaw
	quest_type = QUEST_OUTLAW
	mob_types_to_spawn = list(
		/mob/living/carbon/human/species/human/northern/deranged_knight
	)
	count_min = 1
	count_max = 1

/datum/quest/kill/outlaw/get_title()
	if(title)
		return title
	return "Defeat [pick("the terrible", "the dreadful", "the monstrous", "the infamous")] [pick("warlord", "beast", "sorcerer", "abomination")]"

/datum/quest/kill/outlaw/get_objective_text()
	return "Slay [initial(target_mob_type.name)]."

/datum/quest/kill/outlaw/generate(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	spawn_kill_mobs(landmark)
	spawn_goons(landmark)
	return TRUE

/// Spawns proximity-gated goons near the quest landmark to accompany the outlaw target.
/datum/quest/kill/outlaw/proc/spawn_goons(obj/effect/landmark/quest_spawner/landmark)
	for(var/i in 1 to rand(2, 5))
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue
		var/obj/effect/quest_spawn/spawn_effect = new /obj/effect/quest_spawn(spawn_turf)
		var/mob/living/goon = new /mob/living/carbon/human/species/human/northern/highwayman/dk_goon(spawn_effect)
		goon.faction |= "quest"
		spawn_effect.contained_atom = goon
		spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
		ADD_TRAIT(goon, TRAIT_FRESHSPAWN, "[type]")
		addtimer(TRAIT_CALLBACK_REMOVE(goon, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
