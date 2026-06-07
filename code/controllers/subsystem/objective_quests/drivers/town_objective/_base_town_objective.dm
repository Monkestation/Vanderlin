/datum/objective_quest_driver/town_objective
	abstract_type = /datum/objective_quest_driver/town_objective
	cooldown_time = 5 MINUTES
	spawn_amount = 4

	/// Current stage index into stage_list
	var/current_stage = 1
	/// List of associative stage definitions, in order.
	/// Each entry: list(quest_types = list(), triumph_reward = 0, triumph_reason = "")
	var/list/stages = list()

/datum/objective_quest_driver/town_objective/is_eligible()
	if(!length(stages))
		return FALSE
	if(current_stage > length(stages))
		return FALSE
	var/list/stage = stages[current_stage]
	var/list/stage_quest_types = stage["quest_types"]
	// Only eligible if none of this stage's quests are already in the pool
	for(var/quest_type in stage_quest_types)
		for(var/datum/quest/Q as anything in SSquestboard.quest_pool[quest_difficulty])
			if(istype(Q, quest_type))
				return FALSE
	return TRUE

/datum/objective_quest_driver/town_objective/generate_quest()
	// Town objective overrides this to spawn all stage quests at once
	// Called once per fire, spawns every quest type in the current stage
	if(current_stage > length(stages))
		return null
	var/list/stage = stages[current_stage]
	for(var/quest_type in stage["quest_types"])
		var/datum/quest/Q = new quest_type()
		if(!Q.generate(null))
			qdel(Q)
			continue
		Q.reward_amount = Q.calculate_reward(null)
		Q.expiry_time = 0 // town objective quests don't expire
		SSquestboard.quest_pool[quest_difficulty] += Q
	return null // we handle insertion ourselves

/datum/objective_quest_driver/town_objective/get_spawn_amount()
	if(current_stage > length(stages))
		return 0
	return length(stages[current_stage]["quest_types"])

/// Called on quest hand-in to check if the current stage is complete
/datum/objective_quest_driver/town_objective/proc/check_stage_completion()
	if(current_stage > length(stages))
		return

	var/list/stage = stages[current_stage]
	var/list/stage_quest_types = stage["quest_types"]

	// Check if any quests from this stage are still unclaimed in the pool
	for(var/datum/quest/Q as anything in SSquestboard.quest_pool[quest_difficulty])
		if(Q.type in stage_quest_types)
			return // Still quests remaining, not done yet

	// Nothing left unclaimed, advance
	award_stage_triumph(stage)
	current_stage++

/datum/objective_quest_driver/town_objective/proc/award_stage_triumph(list/stage)
	var/triumph_amount = stage["triumph_reward"]
	var/triumph_reason = stage["triumph_reason"]
	if(!triumph_amount)
		return
	for(var/client/client as anything in GLOB.clients)
		client.mob.adjust_triumphs(triumph_amount, reason = triumph_reason, override_bonus = TRUE)

/// Override in subtypes to define what quest types belong to the current stage
/datum/objective_quest_driver/town_objective/proc/get_stage_quest_types()
	if(current_stage > length(stages))
		return list()
	return stages[current_stage]["quest_types"]
