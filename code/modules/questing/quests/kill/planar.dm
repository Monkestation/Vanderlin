/datum/quest/kill/planar
	quest_difficulty = QUEST_DIFFICULTY_EASY
	quest_type = QUEST_PLANAR
	count_min = 2
	count_max = 4

	/// Stores which faction list was chosen at generate() time so title/objective can reference it.
	var/list/chosen_faction_pool

	var/list/infernal_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/infernal/imp,
		/mob/living/simple_animal/hostile/retaliate/infernal/hellhound,
	)
	var/list/fae_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/fae/sprite,
		/mob/living/simple_animal/hostile/retaliate/fae/glimmerwing,
	)
	var/list/elemental_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/elemental/crawler,
		/mob/living/simple_animal/hostile/retaliate/elemental/warden,
	)

/datum/quest/kill/planar/generate(obj/effect/landmark/quest_spawner/landmark)
	chosen_faction_pool = pick(infernal_mobs, fae_mobs, elemental_mobs)
	mob_types_to_spawn = chosen_faction_pool
	. = ..()
	if(.)
		spawn_kill_mobs(landmark)

/datum/quest/kill/planar/proc/get_faction_name()
	if(chosen_faction_pool == infernal_mobs)
		return "infernal"
	if(chosen_faction_pool == fae_mobs)
		return "fae"
	if(chosen_faction_pool == elemental_mobs)
		return "elemental"
	return "unknown"

/datum/quest/kill/planar/get_title()
	if(title)
		return title
	return "[pick("Drive back", "Repel", "Slay", "Eliminate")] the [get_faction_name()] incursion"

/datum/quest/kill/planar/get_objective_text()
	if(!target_mob_type)
		return "Slay the enemies."
	return "Slay [progress_current]/[progress_required] [initial(target_mob_type.name)]s."

/datum/quest/kill/planar/medium
	quest_difficulty = QUEST_DIFFICULTY_MEDIUM
	minimum_payout = QUEST_REWARD_MEDIUM_LOW
	maximum_payout = QUEST_REWARD_MEDIUM_HIGH
	count_min = 2
	count_max = 3

	infernal_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/infernal/hellhound,
		/mob/living/simple_animal/hostile/retaliate/infernal/watcher,
	)
	fae_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/fae/glimmerwing,
		/mob/living/simple_animal/hostile/retaliate/fae/dryad,
	)
	elemental_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/elemental/warden,
		/mob/living/simple_animal/hostile/retaliate/elemental/behemoth,
	)

/datum/quest/kill/planar/hard
	quest_difficulty = QUEST_DIFFICULTY_HARD
	minimum_payout = QUEST_REWARD_HARD_LOW
	maximum_payout = QUEST_REWARD_HARD_HIGH
	count_min = 1
	count_max = 2

	infernal_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/infernal/watcher,
		/mob/living/simple_animal/hostile/retaliate/infernal/fiend,
	)
	fae_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/fae/dryad,
		/mob/living/simple_animal/hostile/retaliate/fae/sylph,
	)
	elemental_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/elemental/behemoth,
		/mob/living/simple_animal/hostile/retaliate/elemental/collossus,
	)
