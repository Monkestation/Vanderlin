/datum/coven
	///Name of this Coven.
	var/name = "Coven name"
	///Text description of this Coven.
	var/desc = "Coven description"
	///Icon for this Coven as in Covens.dmi
	var/icon_state
	///If this Coven is unique to a certain Clan.
	var/clan_restricted = FALSE
	///The root type of the powers this Coven uses.
	var/power_type = /datum/coven_power

	/* LEVELING SYSTEM */
	///What rank, or how many dots the caster has in this Coven.
	var/level = 1
	///Maximum level this coven can reach
	var/max_level = 5
	///Current experience points in this coven
	var/experience = 0
	///Experience needed to reach next level
	var/experience_needed = 100
	///Experience multiplier for each level (gets harder to level)
	var/experience_multiplier = 1.25

	/* BACKEND */
	///What rank of this Coven is currently being casted.
	var/level_casting = 1
	///The power that is currently in use.
	var/datum/coven_power/current_power
	///All Coven powers under this Coven that the owner knows. LIST OF INSTANCES, NOT TYPES.
	var/list/datum/coven_power/known_powers = list()
	///The typepaths of possible powers for every rank in this Coven.
	var/all_powers = list()
	///The mob that owns and is using this Coven.
	var/mob/living/carbon/human/owner
	///If this Coven has been assigned before and post_gain effects have already been applied.
	var/post_gain_applied

	///our coven action
	var/datum/action/coven/coven_action

	///Associated research interface for this coven's power tree
	var/datum/coven_research_interface/research_interface
	///List of research nodes unlocked for this coven
	var/list/unlocked_research = list()
	///Current research points available to spend
	var/research_points = 10

	///Base XP gain for successful power use
	var/base_power_xp = 5
	///XP multiplier for higher level powers
	var/power_level_multiplier = 1.5
	///XP gain for discovering new things or unique actions
	var/discovery_xp = 25
	///XP gain for teaching others or mentoring
	var/teaching_xp = 15
	///XP gain for critical successes
	var/critical_success_xp = 10

/datum/coven/New(level)
	all_powers = subtypesof(power_type)

	if (!level)
		return

	// Initialize powers for the starting level
	initialize_powers_for_level(level)

/**
 * Helper proc to initialize powers for a given level
 * This ensures we don't duplicate code between New() and set_level()
 */
/datum/coven/proc/initialize_powers_for_level(target_level)
	// Clear existing powers
	if(length(known_powers))
		QDEL_LIST(known_powers)
		known_powers = list()

	// Add powers for each level up to target_level
	for(var/i in 1 to target_level)
		if(i <= length(all_powers))
			var/type_to_create = all_powers[i]
			var/datum/coven_power/new_power = new type_to_create(src)
			known_powers += new_power

	// Set the current power to the first one if we have any
	if(length(known_powers))
		current_power = known_powers[1]

	src.level = target_level

/**
 * Modifies a Coven's level, updating its available powers
 * to conform to the new level. This proc will be removed when
 * power loadouts are implemented, but for now it's useful for dynamically
 * adding and removing powers.
 *
 * Arguments:
 * * level - the level to set the Coven as, powers included
 */
/datum/coven/proc/set_level(level)
	if (level == src.level)
		return

	initialize_powers_for_level(level)

/**
 * Assigns the Coven to a mob, setting its owner and applying
 * post_gain effects.
 *
 * Arguments:
 * * new_owner - the mob to assign the Coven to
 */
/datum/coven/proc/assign(mob/new_owner)
	if(new_owner == owner)
		return
	if(owner)
		UnregisterSignal(owner, COMSIG_QDELETING)
	RegisterSignal(new_owner, COMSIG_QDELETING, PROC_REF(on_owner_qdel))
	owner = new_owner

	// Set owner for all known powers
	for (var/datum/coven_power/power in known_powers)
		power.set_owner(owner)

	if (!post_gain_applied)
		post_gain()
	post_gain_applied = TRUE

/**
 * Proc to handle potential hard dels.
 * Cleans up any remaining references to avoid circular reference memory leaks.
 * The GC will handle the rest.
 */
/datum/coven/proc/on_owner_qdel()
	SIGNAL_HANDLER
	owner = null
	current_power = null
	QDEL_LIST(known_powers)
	known_powers = null

/**
 * Returns a known Coven power in this Coven
 * searching by type.
 *
 * Arguments:
 * * power_type - the power type to search for
 */
/datum/coven/proc/get_power(power_type)
	if (!ispath(power_type))
		return null

	for (var/datum/coven_power/power in known_powers)
		if (power.type == power_type)
			return power

	return null

/**
 * Check if we already have a power of this type
 */
/datum/coven/proc/has_power(power_type)
	return get_power(power_type) != null

/**
 * Applies effects specific to the Coven to
 * its owner. Also triggers post_gain effects of all
 * known (possessed) powers. Meant to be overridden
 * for modular code.
 */
/datum/coven/proc/post_gain()
	SHOULD_CALL_PARENT(TRUE)

	for (var/datum/coven_power/power in known_powers)
		power.post_gain()

/datum/coven/proc/initialize_research_tree()
	research_interface = new /datum/coven_research_interface(src)
	research_interface.initialize_coven_tree()

	for(var/research_type in research_interface.research_nodes)
		var/datum/coven_research_node/node = research_interface.get_research_node(research_type)
		if(node.required_level <= level)
			unlock_power_from_tree(research_type)

/datum/coven/proc/gain_experience(amount)
	experience += amount
	check_level_up()

/datum/coven/proc/check_level_up()
	while(experience >= experience_needed && level < max_level)
		level_up()

/datum/coven/proc/level_up()
	experience -= experience_needed
	level++
	experience_needed = round(experience_needed * experience_multiplier)

	// Gain bonus research points on level up
	research_points += level * 5

	if(owner)
		to_chat(owner, "<span class='boldannounce'>Your [name] has reached level [level]!</span>")
		to_chat(owner, "<span class='notice'>You gain [level * 5] bonus research points!</span>")

	// Auto-unlock any powers that become available at this level
	if(level <= length(all_powers))
		var/new_power_type = all_powers[level]
		if(!has_power(new_power_type))
			grant_power(new_power_type, "level_unlock")

	// Auto-unlock research nodes that become available
	if(research_interface)
		var/list/newly_available = research_interface.get_available_research()
		var/list/unlocked_this_level = list()

		for(var/research_type in newly_available)
			if(unlock_power_from_tree(research_type))
				var/datum/coven_research_node/node = research_interface.get_research_node(research_type)
				unlocked_this_level += node.name

		if(length(unlocked_this_level) && owner)
			to_chat(owner, "<span class='boldnotice'>New powers unlocked: [jointext(unlocked_this_level, ", ")]</span>")

/datum/coven/proc/unlock_power_from_tree(research_type)
	if(research_type in unlocked_research)
		return FALSE

	if(!research_interface)
		return FALSE

	var/datum/coven_research_node/node = research_interface.get_research_node(research_type)
	if(!node)
		return FALSE

	// Check level requirement
	if(level < node.required_level)
		return FALSE

	// Check prerequisites
	for(var/prereq in node.prerequisites)
		if(!(prereq in unlocked_research))
			return FALSE

	// Unlock the power
	unlocked_research += research_type

	// Grant the power
	if(node.unlocks_power)
		grant_power(node.unlocks_power, "level_unlock")

	// Apply special effects
	if(node.special_effect)
		apply_research_effect(node.special_effect)

	return TRUE

/**
 * Unified power granting system with different sources
 * FIXED: Now properly checks for existing powers and manages instances correctly
 *
 * Arguments:
 * * power_type - The type of power to grant
 * * source - How the power was obtained ("level_unlock", "research", "discovery", "teaching", "special")
 * * silent - Whether to suppress messages
 */
/datum/coven/proc/grant_power(power_type, source = "unknown", silent = FALSE)
	// Check if we already have this power
	if(has_power(power_type))
		return FALSE

	// Validate power type is in our available powers
	if(!(power_type in all_powers))
		return FALSE

	// Create and initialize the power INSTANCE
	var/datum/coven_power/new_power = new power_type(src)
	new_power.owner = owner
	new_power.discipline = src

	// Add the INSTANCE to known_powers (not the type!)
	known_powers += new_power

	// Apply source-specific effects
	switch(source)
		if("research")
			// Powers learned through research might have reduced costs
			new_power.vitae_cost = max(1, round(new_power.vitae_cost * 0.9))
			if(!silent && owner)
				to_chat(owner, "<span class='boldnotice'>Through careful study, you have mastered [new_power.name]!</span>")

		if("discovery")
			// Powers discovered through experimentation might have unique properties
			new_power.range += 1
			if(!silent && owner)
				to_chat(owner, "<span class='boldannounce'>Your experimentation has revealed the secrets of [new_power.name]!</span>")

		if("teaching")
			// Powers learned from others might have social bonuses
			new_power.cooldown_length = max(0, round(new_power.cooldown_length * 0.8))
			if(!silent && owner)
				to_chat(owner, "<span class='boldnotice'>Through the guidance of another, you have learned [new_power.name]!</span>")

		if("special")
			// Special powers might have enhanced effects
			if(!silent && owner)
				to_chat(owner, "<span class='boldannounce'>You have unlocked the forbidden knowledge of [new_power.name]!</span>")

		else // level_unlock or unknown
			if(!silent && owner)
				to_chat(owner, "<span class='boldnotice'>You have learned [new_power.name]!</span>")

	// Apply post-gain effects
	new_power.post_gain()

	// Update current power if this is the first one
	if(!current_power)
		current_power = new_power

	return TRUE

/**
 * DEPRECATED: Use grant_power instead
 * Keeping for backwards compatibility but it now just calls grant_power
 */
/datum/coven/proc/learn_power(power_type)
	return grant_power(power_type, "unknown", FALSE)

/datum/coven/proc/can_research(research_type)
	if(!research_interface)
		return FALSE

	var/datum/coven_research_node/node = research_interface.get_research_node(research_type)
	if(!node)
		return FALSE

	// Check if already researched
	if(research_type in unlocked_research)
		return FALSE

	// Check if prerequisites are met
	for(var/prereq in node.prerequisites)
		if(!(prereq in unlocked_research))
			return FALSE

	// Check if we have enough research points
	if(research_points < node.research_cost)
		return FALSE

	return TRUE

/datum/coven/proc/apply_research_effect(effect_type)
	switch(effect_type)
		if("reduce_vitae_cost")
			// Reduce vitae costs of all powers by 10%
			for(var/datum/coven_power/power in known_powers)
				power.vitae_cost = max(1, round(power.vitae_cost * 0.9))
		if("increase_range")
			// Increase range of all powers by 1
			for(var/datum/coven_power/power in known_powers)
				power.range += 1
		if("reduce_cooldown")
			// Reduce cooldowns by 20%
			for(var/datum/coven_power/power in known_powers)
				power.cooldown_length = max(0, round(power.cooldown_length * 0.8))

/**
 * Main XP gain function with multiple sources
 *
 * Arguments:
 * * amount - Base XP amount
 * * source - What caused the XP gain
 * * power_used - If from power use, which power
 * * multiplier - Additional multiplier
 */
/datum/coven/proc/gain_experience_from_source(amount, source, datum/coven_power/power_used = null, multiplier = 1)
	var/final_amount = amount * multiplier

	// Apply source-specific bonuses
	switch(source)
		if("power_use")
			if(power_used)
				// Higher level powers give more XP
				final_amount = base_power_xp * (power_used.level * power_level_multiplier)

				// Bonus for successful difficult actions
				if(power_used.last_use_was_critical)
					final_amount += critical_success_xp
					power_used.last_use_was_critical = FALSE

		if("discovery")
			final_amount = discovery_xp

		if("teaching")
			final_amount = teaching_xp

		if("meditation")
			// Slower but steady XP gain
			final_amount = amount * 0.5

		if("combat")
			// Combat use of powers gives bonus XP
			final_amount = amount * 1.2

		if("roleplay")
			// Encourage roleplay with XP
			final_amount = amount * 0.8

	// Apply level-based diminishing returns for power use
	if(source == "power_use" && power_used)
		var/level_difference = level - power_used.level
		if(level_difference > 2)
			final_amount *= 0.5 // Reduced XP for using powers way below your level

	gain_experience(round(final_amount))

	// Log XP gain for debugging/admin purposes
	if(owner)
		log_game("[owner] gained [final_amount] XP in [name] from [source]")

/**
 * XP gain triggers for various game events
 */

// Called when a power is successfully used
/datum/coven/proc/on_power_use_success(datum/coven_power/power, is_critical = FALSE, exp_multiplier = 1, vitae_spent = 0)
	var/base_xp = 0

	if(vitae_spent > 0)
		base_xp = round(sqrt(vitae_spent) * 2) // sqrt(50) * 2 = ~14 XP
	else if(power.vitae_cost > 0)
		base_xp = round(sqrt(power.vitae_cost) * 2)
	else
		base_xp = 2

	base_xp += power.level

	if(is_critical)
		base_xp = round(base_xp * 1.5)

	var/final_xp = round(base_xp * exp_multiplier)
	gain_experience(final_xp)

// Called when player discovers something new about their coven
/datum/coven/proc/on_discovery_event(discovery_type)
	gain_experience_from_source(discovery_xp, "discovery")

	if(owner)
		to_chat(owner, "<span class='boldnotice'>Your understanding of [name] deepens through discovery!</span>")

// Called when player teaches someone else
/datum/coven/proc/on_teaching_event(mob/student, datum/coven_power/power_taught)
	gain_experience_from_source(teaching_xp, "teaching")

	if(owner)
		to_chat(owner, "<span class='notice'>Sharing your knowledge of [power_taught.name] has deepened your own understanding.</span>")

// Called during meditation or study actions
/datum/coven/proc/on_meditation_complete(duration_minutes)
	var/xp_gain = duration_minutes * 2 // 2 XP per minute of meditation
	gain_experience_from_source(xp_gain, "meditation")

// Called when powers are used in combat
/datum/coven/proc/on_combat_power_use(datum/coven_power/power, target)
	gain_experience_from_source(base_power_xp, "combat", power)

// Called for good roleplay moments
/datum/coven/proc/on_roleplay_moment(intensity = 1)
	var/xp_gain = 10 * intensity
	gain_experience_from_source(xp_gain, "roleplay")

/datum/coven/proc/research_power(research_type)
	if(!can_research(research_type))
		return FALSE

	var/datum/coven_research_node/node = research_interface.get_research_node(research_type)
	research_points -= node.research_cost
	unlocked_research += research_type

	// Grant the power through research pathway
	if(node.unlocks_power)
		grant_power(node.unlocks_power, "research")

	// Apply special effects
	if(node.special_effect)
		apply_research_effect(node.special_effect)

	// Gain XP for successful research
	gain_experience_from_source(node.research_cost, "discovery")

	if(owner)
		to_chat(owner, "<span class='boldnotice'>You have researched [node.name]!</span>")

	return TRUE

/**
 * Power discovery system - allows finding powers through experimentation
 */
/datum/coven/proc/attempt_power_discovery(experimentation_type)
	if(!owner)
		return FALSE

	// Check if player has the minimum level for discovery
	if(level < 2)
		return FALSE

	var/list/discoverable_powers = list()

	// Find powers that could be discovered
	for(var/power_type in all_powers)
		if(has_power(power_type))
			continue

		var/datum/coven_power/temp_power = new power_type

		// Can discover powers up to current level + 1
		if(temp_power.level <= level + 1 && temp_power.level <= max_level)
			discoverable_powers += power_type

		qdel(temp_power)

	if(!length(discoverable_powers))
		return FALSE

	// Discovery chance based on experimentation type and level
	var/discovery_chance = 0
	switch(experimentation_type)
		if("careful_study")
			discovery_chance = 15 + (level * 5)
		if("bold_experimentation")
			discovery_chance = 25 + (level * 3)
		if("guided_meditation")
			discovery_chance = 10 + (level * 7)
		if("combat_stress")
			discovery_chance = 20 + (level * 2)

	if(prob(discovery_chance))
		var/discovered_power = pick(discoverable_powers)
		grant_power(discovered_power, "discovery")
		on_discovery_event("power_discovery")
		return TRUE

	return FALSE
