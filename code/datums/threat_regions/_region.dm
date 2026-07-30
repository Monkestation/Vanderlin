/datum/threat_region
	abstract_type = /datum/threat_region
	var/region_name = "Generic Region Scream At Coder"
	var/latent_ambush = DANGER_SAFE_FLOOR
	var/min_ambush = DANGER_SAFE_FLOOR
	var/max_ambush = DANGER_DIRE_LIMIT
	var/fixed_ambush = FALSE // Some region like Underdark cannot be reduced in danger
	var/lowpop_tick = 1 // How much ambush to tick up every iteration <= 30 pop
	var/highpop_tick = 2 // How much ambush to tick up every iteration > 30 pop
	COOLDOWN_DECLARE(natural_ambush)
	COOLDOWN_DECLARE(induced_ambush)
	var/last_induced_ambush_time = 0 // Time between now and the previous ambush triggered by horn
	COOLDOWN_DECLARE(invasion_cooldown)

/// Fired by trigger_invasion() when latent_ambush >= max_ambush.
/// Override in concrete subtypes to start your dormant invasion events, left as an overridable thing incase we want special things.
/datum/threat_region/proc/on_invasion_threshold()
	//try_spawn_harlequinn()
	return

/datum/threat_region/proc/reduce_latent_ambush(amount)
	if(fixed_ambush)
		return
	if(latent_ambush - amount < min_ambush)
		latent_ambush = min_ambush
	else
		latent_ambush -= amount

/datum/threat_region/proc/increase_latent_ambush(amount)
	if(fixed_ambush)
		return
	if(latent_ambush + amount > max_ambush)
		latent_ambush = max_ambush
	else
		latent_ambush += amount

// Special proc because danger level is dependent on the number of latent ambush
/datum/threat_region/proc/get_danger_level()
	if(latent_ambush <= DANGER_SAFE_LIMIT)
		return DANGER_LEVEL_SAFE
	else if(latent_ambush <= DANGER_LOW_LIMIT)
		return DANGER_LEVEL_LOW
	else if(latent_ambush <= DANGER_MODERATE_LIMIT)
		return DANGER_LEVEL_MODERATE
	else if(latent_ambush <= DANGER_DANGEROUS_LIMIT)
		return DANGER_LEVEL_DANGEROUS
	else if(latent_ambush <= DANGER_DIRE_LIMIT)
		return DANGER_LEVEL_BLEAK
	else
		return DANGER_LEVEL_SAFE

/datum/threat_region/proc/get_danger_color(level)
	switch(get_danger_level())
		if(DANGER_LEVEL_SAFE)
			return "#00FF00"
		if(DANGER_LEVEL_LOW)
			return "#FFFF00"
		if(DANGER_LEVEL_MODERATE)
			return "#FFA500"
		if(DANGER_LEVEL_DANGEROUS)
			return "#FF0000"
		if(DANGER_LEVEL_BLEAK)
			return "#800080"
		else
			return "#FFFFFF"


/datum/threat_region/proc/try_spawn_harlequinn()
	if(!COOLDOWN_FINISHED(SSregionthreat, harlequinn_spawn_cooldown))
		return FALSE

	// Don't stack hunts
	var/datum/weakref/hunt_ref = GLOB.harlequinn_hunt_quest
	var/datum/quest/custom/harlequinn_hunt/existing = hunt_ref?.resolve()
	if(!QDELETED(existing))
		return FALSE

	// Reuse the existing landmark pool — any hard quest landmark in this region
	var/list/candidates = list()
	for(var/obj/effect/landmark/quest_spawner/L in GLOB.quest_landmarks_list)
		if(L.quest_difficulty != QUEST_DIFFICULTY_HARD)
			continue
		var/datum/threat_region/TR = SSregionthreat.get_region_for_turf(get_turf(L))
		if(!TR || TR != src)
			continue
		candidates += L

	if(!length(candidates))
		log_game("HARLEQUINN: No hard landmarks found in [region_name], skipping spawn.")
		return FALSE

	COOLDOWN_START(SSregionthreat, harlequinn_spawn_cooldown, HARLEQUINN_HUNT_COOLDOWN)

	var/obj/effect/landmark/quest_spawner/spawn_point = pick(candidates)
	var/mob/living/carbon/human/harlequinn_vessel/V = new(get_turf(spawn_point), src)

	log_game("HARLEQUINN: Vessel spawned at [COORD(V)] in [region_name].")
	message_admins("HARLEQUINN: Ghost vessel opened in [region_name] at [COORD(V)]. Polling candidates.")
	return TRUE
