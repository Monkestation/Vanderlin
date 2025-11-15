/datum/ai_behavior/find_aggro_targets
	action_cooldown = 1 SECONDS

/datum/ai_behavior/find_aggro_targets/get_cooldown(datum/ai_controller/cooldown_for)
	if(cooldown_for.blackboard[BB_FIND_TARGETS_FIELD(type)])
		return 60 SECONDS
	return ..()

/datum/ai_behavior/find_aggro_targets/perform(seconds_per_tick, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()

	var/mob/living/living_mob = controller.pawn
	if(!living_mob || living_mob.pet_passive)
		finish_action(controller, succeeded = FALSE)
		return

	// Check if we already have a threat target
	var/mob/current_target = controller.blackboard[BB_HIGHEST_THREAT_MOB]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum)
		CRASH("No target datum was supplied in the blackboard for [controller.pawn]")

	// If we have a valid target, check if it's still valid
	if(current_target && istype(current_target, /mob/living))
		var/mob/living/living_target = current_target

		// Check if target is dead
		if(living_target.stat == DEAD)
			controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
			current_target = null
		else
			// Check if target is too far away
			var/maintain_range = controller.blackboard[BB_AGGRO_MAINTAIN_RANGE] || 12

			if (!targetting_datum.can_attack(living_mob, current_target))
				controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
				current_target = null

			if(current_target && get_dist(living_mob, living_target) > maintain_range)
				controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
				current_target = null

	// If we have a valid target, set it
	if(current_target)
		if(current_target == controller.blackboard[target_key])
			finish_action(controller, succeeded = FALSE)
			return
		controller.set_blackboard_key(target_key, current_target)

		// Check if target is hiding in something
		var/atom/potential_hiding_location = find_hiding_location(living_mob, current_target)
		if(potential_hiding_location)
			controller.set_blackboard_key(hiding_location_key, potential_hiding_location)
		else
			controller.clear_blackboard_key(hiding_location_key)

		finish_action(controller, succeeded = TRUE)
		return

	// Clear target key since we don't have a valid target
	controller.clear_blackboard_key(target_key)

	// If we're using a field rn, just don't do anything
	if(controller.blackboard[BB_FIND_TARGETS_FIELD(type)])
		return

	// If we don't have a target, check for new targets in range
	scan_for_new_targets(controller, living_mob, target_key, targetting_datum, hiding_location_key, targetting_datum_key)

/// Scans for new potential targets
/datum/ai_behavior/find_aggro_targets/proc/scan_for_new_targets(datum/ai_controller/controller, mob/living/living_mob, target_key, datum/targetting_datum/targetting_datum, hiding_location_key, targetting_datum_key)
	var/aggro_range = controller.blackboard[BB_AGGRO_RANGE] || 9
	var/list/potential_targets = hearers(aggro_range, living_mob) - living_mob

	if(!potential_targets.len)
		failed_to_find_anyone(controller, target_key, targetting_datum_key, hiding_location_key)
		finish_action(controller, succeeded = FALSE)
		return

	var/list/filtered_targets = list()
	for(var/mob/living/pot_target in potential_targets)
		// Skip dead mobs
		if(pot_target.stat == DEAD)
			continue
		if (!targetting_datum.can_attack(living_mob, pot_target))
			continue
		// Skip sneaking mobs with a chance to detect them
		if(pot_target.rogue_sneaking)
			var/extra_chance = (living_mob.health <= living_mob.maxHealth * 0.5) ? 30 : 0
			if(!living_mob.npc_detect_sneak(pot_target, extra_chance))
				continue

		// Add to filtered targets
		filtered_targets += pot_target

	if(!filtered_targets.len)
		failed_to_find_anyone(controller, target_key, targetting_datum_key, hiding_location_key)
		finish_action(controller, succeeded = FALSE)
		return

	// Choose a random mob from filtered targets to add initial threat
	var/mob/living/chosen_target = pick(filtered_targets)

	// Find the aggro component on our mob
	var/datum/component/ai_aggro_system/aggro_comp = living_mob.GetComponent(/datum/component/ai_aggro_system)
	if(aggro_comp)
		// Add initial threat to start aggro mechanic
		aggro_comp.add_threat_to_mob_capped(chosen_target, 15, 15)
		aggro_comp.add_threat_to_mob(chosen_target, 3)

	// Check if this pushed the target over the threshold
	var/mob/highest_threat = controller.blackboard[BB_HIGHEST_THREAT_MOB]
	if(highest_threat)
		controller.set_blackboard_key(target_key, highest_threat)

		// Check if target is hiding in something
		var/atom/potential_hiding_location = find_hiding_location(living_mob, highest_threat)
		if(potential_hiding_location)
			controller.set_blackboard_key(hiding_location_key, potential_hiding_location)

		finish_action(controller, succeeded = TRUE)
	else
		finish_action(controller, succeeded = FALSE)

/datum/ai_behavior/find_aggro_targets/proc/failed_to_find_anyone(datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	var/aggro_range = controller.blackboard[BB_AGGRO_RANGE] || 9
	// takes the larger between our range() input and our implicit hearers() input (world.view)
	aggro_range = max(aggro_range, ROUND_UP(max(getviewsize(world.view)) / 2))
	// Set up proximity field to await someone interesting to come along
	var/datum/proximity_monitor/advanced/ai_aggro_tracking/detection_field = new(
		controller.pawn,
		aggro_range,
		TRUE,
		src,
		controller,
		target_key,
		targeting_strategy_key,
		hiding_location_key,
	)
	// Store this field in our blackboard, so we can clear it away if we end up finishing successfully
	controller.set_blackboard_key(BB_FIND_TARGETS_FIELD(type), detection_field)

/// Helper proc to check if an atom is allowed for aggro targeting
/datum/ai_behavior/find_aggro_targets/proc/atom_allowed(atom/movable/checking, datum/targetting_datum/strategy, mob/pawn)
	if(checking == pawn)
		return FALSE
	if(!ismob(checking) && !is_type_in_typecache(checking, GLOB.target_interested_atoms))
		return FALSE
	if(!strategy.can_attack(pawn, checking))
		return FALSE
	// Additional aggro-specific checks for living mobs
	if(istype(checking, /mob/living))
		var/mob/living/living_target = checking
		if(living_target.stat == DEAD)
			return FALSE
		if(living_target.rogue_sneaking)
			var/mob/living/living_pawn = pawn
			var/extra_chance = (living_pawn.health <= living_pawn.maxHealth * 0.5) ? 30 : 0
			if(!living_pawn.npc_detect_sneak(living_target, extra_chance))
				return FALSE
	return TRUE

/// Called when proximity field detects new turf - quick validity check
/datum/ai_behavior/find_aggro_targets/proc/new_turf_found(turf/found, datum/ai_controller/controller, datum/targetting_datum/strategy)
	var/valid_found = FALSE
	var/mob/pawn = controller.pawn
	for(var/maybe_target as anything in found)
		if(atom_allowed(maybe_target, strategy, pawn))
			valid_found = TRUE
			break
	if(!valid_found)
		return
	// If we found any one thing we "could" attack, then run the full search again so we can select from the best possible candidate
	var/datum/proximity_monitor/field = controller.blackboard[BB_FIND_TARGETS_FIELD(type)]
	qdel(field) // autoclears so it's fine
	// Fire instantly, you should find something I hope
	controller.modify_cooldown(src, world.time)

/// Called when proximity field detects new atoms - processes them for aggro
/datum/ai_behavior/find_aggro_targets/proc/new_atoms_found(list/atom/movable/found, datum/ai_controller/controller, target_key, datum/targetting_datum/strategy, hiding_location_key)
	var/mob/living/pawn = controller.pawn
	var/list/accepted_targets = list()

	for(var/maybe_target as anything in found)
		if(atom_allowed(maybe_target, strategy, pawn))
			accepted_targets += maybe_target

	if(!accepted_targets.len)
		return

	// Add threat to all accepted targets, then see if any become our new highest threat
	var/datum/component/ai_aggro_system/aggro_comp = pawn.GetComponent(/datum/component/ai_aggro_system)
	if(aggro_comp)
		for(var/mob/living/target in accepted_targets)
			aggro_comp.add_threat_to_mob_capped(target, 15, 15)
			aggro_comp.add_threat_to_mob(target, 3)

	// Check if we now have a highest threat target
	var/mob/highest_threat = controller.blackboard[BB_HIGHEST_THREAT_MOB]
	if(highest_threat)
		controller.set_blackboard_key(target_key, highest_threat)

		var/atom/potential_hiding_location = find_hiding_location(pawn, highest_threat)
		if(potential_hiding_location)
			controller.set_blackboard_key(hiding_location_key, potential_hiding_location)

		finish_action(controller, succeeded = TRUE)

/// Helper proc to find if a mob is hiding in something
/datum/ai_behavior/find_aggro_targets/proc/find_hiding_location(mob/living/source, mob/living/target)
	// Check if target is inside something
	if(istype(target.loc, /obj/item) || istype(target.loc, /obj/structure) || istype(target.loc, /obj/machinery))
		return target.loc
	return null

/datum/ai_behavior/find_aggro_targets/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if(succeeded)
		var/datum/proximity_monitor/field = controller.blackboard[BB_FIND_TARGETS_FIELD(type)]
		qdel(field) // autoclears so it's fine
		controller.CancelActions() // Cancel any further queued actions so they setup again with new target
		controller.modify_cooldown(controller, get_cooldown(controller))

/datum/ai_behavior/find_aggro_targets/bum/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if(succeeded)
		var/mob/living/pawn = controller.pawn
		pawn.say(pick(GLOB.bum_aggro))

/datum/ai_behavior/find_aggro_targets/species_hostile/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if(succeeded)
		var/mob/living/pawn = controller.pawn
		pawn.emote("rage")
		pawn.say(pick(GLOB.species_hostile))

/datum/ai_behavior/find_aggro_targets/species_hostile/failed_to_find_anyone(datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	. = ..()
	var/mob/living/pawn = controller.pawn
	if(pawn)
		pawn.cmode = FALSE