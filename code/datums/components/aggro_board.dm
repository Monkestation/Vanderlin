/datum/component/ai_aggro_system
	/// Default threat threshold before a mob is considered hostile
	var/default_threat_threshold = 10
	/// Default range at which mobs detect and add threats
	var/default_aggro_range = 9
	/// Default range at which mobs maintain aggro before dropping target
	var/default_maintain_range = 12
	/// Default decay rate per second
	var/default_decay_rate = 2

/datum/component/ai_aggro_system/Initialize(threat_threshold, aggro_range, maintain_range, decay_rate)
	. = ..()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/living_mob = parent
	living_mob.AddElement(/datum/element/relay_attackers)
	if(!living_mob.ai_controller)
		return COMPONENT_INCOMPATIBLE

	// Initialize the aggro table
	living_mob.ai_controller.blackboard[BB_MOB_AGGRO_TABLE] = list()

	// Set configurable parameters
	living_mob.ai_controller.set_blackboard_key(BB_THREAT_THRESHOLD, threat_threshold || default_threat_threshold)
	living_mob.ai_controller.set_blackboard_key(BB_AGGRO_RANGE, aggro_range || default_aggro_range)
	living_mob.ai_controller.set_blackboard_key(BB_AGGRO_MAINTAIN_RANGE, maintain_range || default_maintain_range)

	START_PROCESSING(SSaggro, src)
	// Register signals
	RegisterSignal(parent, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(on_attacked))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/ai_aggro_system/Destroy(force)
	STOP_PROCESSING(SSaggro, src)

	// Unregister signals
	UnregisterSignal(parent, list(
		COMSIG_ATOM_WAS_ATTACKED,
		COMSIG_LIVING_DEATH
	))

	return ..()

/// Public method to add threat to specific mob
/datum/component/ai_aggro_system/proc/add_threat_to_mob(mob/target, amount)
	if(!target || !parent)
		return

	var/mob/living/living_mob = parent
	add_threat(living_mob, target, amount)

/// Public method to add threat to specific mob
/datum/component/ai_aggro_system/proc/add_threat_to_mob_capped(mob/target, amount, cap)
	if(!target || !parent)
		return
	var/mob/living/living_mob = parent
	var/list/aggro_table = living_mob.ai_controller.blackboard[BB_MOB_AGGRO_TABLE]
	if(!length(aggro_table))
		add_threat(living_mob, target, amount)
	var/aggro = aggro_table[target]
	if(aggro >= cap)
		return
	amount -= aggro
	add_threat(living_mob, target, amount)

/// Adds threat to an attacker based on damage dealt
/datum/component/ai_aggro_system/proc/on_attacked(mob/victim, atom/attacker, damage)
	SIGNAL_HANDLER

	if(!victim.ai_controller)
		return

	if(!ismob(attacker))
		return

	// Base threat from being attacked
	var/threat_to_add = 5

	// Add additional threat based on damage if provided
	if(damage)
		threat_to_add += damage * 0.5

	add_threat(victim, attacker, threat_to_add)

/// Clears the aggro table when the mob dies
/datum/component/ai_aggro_system/proc/on_death(mob/living/source)
	SIGNAL_HANDLER

	if(!source.ai_controller)
		return

	// Clear aggro table on death
	source.ai_controller.blackboard[BB_MOB_AGGRO_TABLE] = list()
	source.ai_controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)

/// Adds or modifies threat level for a specific mob
/datum/component/ai_aggro_system/proc/add_threat(mob/victim, mob/attacker, amount)
	if(!victim?.ai_controller || !attacker)
		return

	var/list/aggro_table = victim.ai_controller.blackboard[BB_MOB_AGGRO_TABLE]
	if(!aggro_table)
		aggro_table = list()

	// Add or update threat level
	if(aggro_table[attacker])
		aggro_table[attacker] += amount
	else
		aggro_table[attacker] = amount

	// Ensure threat level isn't negative
	if(aggro_table[attacker] < 0)
		aggro_table[attacker] = 0

	// Update the aggro table
	victim.ai_controller.blackboard[BB_MOB_AGGRO_TABLE] = aggro_table

	if(!victim.ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		victim.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, attacker)

	// Update highest threat mob
	update_highest_threat(victim)

/// Periodically decays threat levels
/datum/component/ai_aggro_system/process()
	var/decay_amount = default_decay_rate
	var/mob/living/living_mob = parent
	if(!living_mob?.ai_controller)
		return

	var/list/aggro_table = living_mob.ai_controller.blackboard[BB_MOB_AGGRO_TABLE]
	if(!aggro_table || !length(aggro_table))
		return

	var/list/to_remove = list()

	// Decay all threat values
	for(var/mob/threat_mob as anything in aggro_table)
		aggro_table[threat_mob] -= decay_amount

		// If threat drops below 0, mark for removal
		if(aggro_table[threat_mob] <= 0)
			to_remove += threat_mob

	// Remove any mobs with 0 or negative threat
	for(var/mob/threat_mob as anything in to_remove)
		aggro_table -= threat_mob

	// Update the aggro table
	living_mob.ai_controller.blackboard[BB_MOB_AGGRO_TABLE] = aggro_table

	// Update highest threat mob
	update_highest_threat(living_mob)

/// Updates who the highest threat mob is
/datum/component/ai_aggro_system/proc/update_highest_threat(mob/living/source)
	if(!source?.ai_controller)
		return

	var/list/aggro_table = source.ai_controller.blackboard[BB_MOB_AGGRO_TABLE]
	if(!aggro_table || !length(aggro_table))
		source.ai_controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
		return

	var/highest_threat = 0
	var/mob/highest_threat_mob = null

	// Find the mob with the highest threat
	for(var/mob/threat_mob as anything in aggro_table)
		if(aggro_table[threat_mob] > highest_threat)
			highest_threat = aggro_table[threat_mob]
			highest_threat_mob = threat_mob

	// Update highest threat mob if it meets threshold
	var/threat_threshold = source.ai_controller.blackboard[BB_THREAT_THRESHOLD] || default_threat_threshold
	if(highest_threat >= threat_threshold)
		source.ai_controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, highest_threat_mob)
		SEND_SIGNAL(source, COMSIG_AI_GENERAL_CHANGE, "Threat Changed: [highest_threat_mob]")
	else
		source.ai_controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
