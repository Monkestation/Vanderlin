/datum/objective_quest_driver
	/// Quest type this driver spawns
	var/quest_type_path = null
	/// Difficulty of quests spawned
	var/quest_difficulty = QUEST_DIFFICULTY_EASY
	/// How long between trigger attempts
	var/cooldown_time = 10 MINUTES
	/// How many quests to spawn per trigger
	var/spawn_amount = 1

	/// Tracked real-world value that drives quest spawning.
	/// e.g. number of messes, number of broken windows, etc.
	var/current_value = 0
	var/value_min = 0
	var/value_max = 20
	/// How much current_value needs to be to consider spawning at all
	var/value_threshold = 1

	COOLDOWN_DECLARE(trigger_cooldown)

/// Override to add custom eligibility logic
/datum/objective_quest_driver/proc/is_eligible()
	SHOULD_CALL_PARENT(FALSE)
	return current_value >= value_threshold

/// Override to change spawn amount dynamically instead of using the fixed amount
/datum/objective_quest_driver/proc/get_spawn_amount()
	SHOULD_CALL_PARENT(FALSE)
	return spawn_amount

/datum/objective_quest_driver/proc/generate_quest()
	if(!quest_type_path)
		return null

	var/datum/quest/Q = new quest_type_path()

	var/landmark = SSquestboard.find_landmark_for(
		quest_difficulty,
		quest_type_path,
		Q.allowed_threat_regions,
		Q.denied_threat_regions,
	)
	// Landmark is optional for objective quests, pass null if none found (but most maps should have one center of the town)
	if(!Q.generate(landmark))
		qdel(Q)
		return null

	Q.reward_amount = Q.calculate_reward(landmark ? get_turf(landmark) : null)
	switch(quest_difficulty)
		if(QUEST_DIFFICULTY_EASY)
			Q.expiry_time = world.time + rand(20 MINUTES, 40 MINUTES)
		if(QUEST_DIFFICULTY_MEDIUM)
			Q.expiry_time = world.time + rand(35 MINUTES, 55 MINUTES)
		if(QUEST_DIFFICULTY_HARD)
			Q.expiry_time = world.time + rand(50 MINUTES, 80 MINUTES)
	return Q
