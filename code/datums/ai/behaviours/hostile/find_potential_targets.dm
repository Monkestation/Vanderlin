/// Static typecache list of things we are interested in
/// Consider this a union of the for loop and the hearers call from below
/// Must be kept up to date with the contents of hostile_machines
GLOBAL_LIST_INIT(target_interested_atoms, typecacheof(list(/mob)))

/datum/ai_behavior/find_potential_targets
	action_cooldown = 2 SECONDS
	/// How far can we see stuff?
	var/vision_range = 9

/datum/ai_behavior/find_potential_targets/get_cooldown(datum/ai_controller/cooldown_for)
	if(cooldown_for.blackboard[BB_FIND_TARGETS_FIELD(type)])
		return 60 SECONDS
	return ..()

/datum/ai_behavior/find_potential_targets/perform(seconds_per_tick, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/mob/living/living_mob = controller.pawn
	if(living_mob.pet_passive)
		finish_action(controller, succeeded = FALSE)
		return
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum)
		CRASH("No target datum was supplied in the blackboard for [controller.pawn]")

	var/atom/current_target = controller.blackboard[target_key]
	if (targetting_datum.can_attack(living_mob, current_target))
		finish_action(controller, succeeded = FALSE)
		return

	controller.clear_blackboard_key(target_key)
	// If we're using a field rn, just don't do anything yeah?
	if(controller.blackboard[BB_FIND_TARGETS_FIELD(type)])
		return

	var/list/potential_targets = hearers(vision_range, controller.pawn) - living_mob //Remove self, so we don't suicide

	if(!potential_targets.len)
		failed_to_find_anyone(controller, target_key, targetting_datum_key, hiding_location_key)
		finish_action(controller, succeeded = FALSE)
		return

	var/list/filtered_targets = list()

	for(var/atom/pot_target in potential_targets)
		if(targetting_datum.can_attack(living_mob, pot_target))//Can we attack it?
			filtered_targets += pot_target
			continue

	for(var/mob/living/living_target in filtered_targets)
		if(living_target.stat == DEAD)
			filtered_targets -= living_target
			continue
		if(!living_target.rogue_sneaking)
			continue
		var/extra_chance = (living_mob.health <= living_mob.maxHealth * 50) ? 30 : 0 // if we're below half health, we're way more alert
		if (!living_mob.npc_detect_sneak(living_target, extra_chance))
			filtered_targets -= living_target

	if(!filtered_targets.len)
		failed_to_find_anyone(controller, target_key, targetting_datum_key, hiding_location_key)
		finish_action(controller, succeeded = FALSE)
		return

	var/atom/target = pick_final_target(controller, filtered_targets)
	controller.set_blackboard_key(target_key, target)

	var/atom/potential_hiding_location = targetting_datum.find_hidden_mobs(living_mob, target)

	if(potential_hiding_location) //If they're hiding inside of something, we need to know so we can go for that instead initially.
		controller.set_blackboard_key(hiding_location_key, potential_hiding_location)

	finish_action(controller, succeeded = TRUE)

/datum/ai_behavior/find_potential_targets/proc/failed_to_find_anyone(datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	var/aggro_range = vision_range
	// takes the larger between our range() input and our implicit hearers() input (world.view)
	aggro_range = max(aggro_range, ROUND_UP(max(getviewsize(world.view)) / 2))
	// Alright, here's the interesting bit
	// We're gonna use this max range to hook into a proximity field so we can just await someone interesting to come along
	// Rather then trying to check every few seconds
	var/datum/proximity_monitor/advanced/ai_target_tracking/detection_field = new(
		controller.pawn,
		aggro_range,
		TRUE,
		src,
		controller,
		target_key,
		targeting_strategy_key,
		hiding_location_key,
	)
	// We're gonna store this field in our blackboard, so we can clear it away if we end up finishing successsfully
	controller.set_blackboard_key(BB_FIND_TARGETS_FIELD(type), detection_field)

/datum/ai_behavior/find_potential_targets/proc/new_turf_found(turf/found, datum/ai_controller/controller, datum/targetting_datum/strategy)
	var/valid_found = FALSE
	var/mob/pawn = controller.pawn
	for(var/maybe_target as anything in found)
		if(maybe_target == pawn)
			continue
		if(!is_type_in_typecache(maybe_target, GLOB.target_interested_atoms))
			continue
		if(!strategy.can_attack(pawn, maybe_target))
			continue
		valid_found = TRUE
		break
	if(!valid_found)
		return
	// If we found any one thing we "could" attack, then run the full search again so we can select from the best possible canidate
	var/datum/proximity_monitor/field = controller.blackboard[BB_FIND_TARGETS_FIELD(type)]
	qdel(field) // autoclears so it's fine
	// Fire instantly, you should find something I hope
	controller.modify_cooldown(src, world.time)

/datum/ai_behavior/find_potential_targets/proc/atom_allowed(atom/movable/checking, datum/targetting_datum/strategy, mob/pawn)
	if(checking == pawn)
		return FALSE
	if(!ismob(checking) && !is_type_in_typecache(checking, GLOB.target_interested_atoms))
		return FALSE
	if(!strategy.can_attack(pawn, checking))
		return FALSE
	return TRUE

/datum/ai_behavior/find_potential_targets/proc/new_atoms_found(list/atom/movable/found, datum/ai_controller/controller, target_key, datum/targetting_datum/strategy, hiding_location_key)
	var/mob/pawn = controller.pawn
	var/list/accepted_targets = list()
	for(var/maybe_target as anything in found)
		if(maybe_target == pawn)
			continue
		// Need to better handle viewers here
		if(!ismob(maybe_target) && !is_type_in_typecache(maybe_target, GLOB.target_interested_atoms))
			continue
		if(!strategy.can_attack(pawn, maybe_target))
			continue
		accepted_targets += maybe_target

	// Alright, we found something acceptable, let's use it yeah?
	var/atom/target = pick_final_target(controller, accepted_targets)
	controller.set_blackboard_key(target_key, target)

	var/atom/potential_hiding_location = strategy.find_hidden_mobs(pawn, target)

	if(potential_hiding_location) //If they're hiding inside of something, we need to know so we can go for that instead initially.
		controller.set_blackboard_key(hiding_location_key, potential_hiding_location)

	finish_action(controller, succeeded = TRUE)

/datum/ai_behavior/find_potential_targets/finish_action(datum/ai_controller/controller, succeeded, target_key, targeting_strategy_key, hiding_location_key)
	. = ..()
	if (succeeded)
		var/datum/proximity_monitor/field = controller.blackboard[BB_FIND_TARGETS_FIELD(type)]
		qdel(field) // autoclears so it's fine
		controller.CancelActions() // On retarget cancel any further queued actions so that they will setup again with new target
		controller.modify_cooldown(controller, world.time + get_cooldown(controller))

/// Returns the desired final target from the filtered list of targets
/datum/ai_behavior/find_potential_targets/proc/pick_final_target(datum/ai_controller/controller, list/filtered_targets)
	return pick(filtered_targets)

/datum/ai_behavior/find_potential_targets/human
	vision_range = 7

/datum/ai_behavior/find_potential_targets/rat
	vision_range = 2

/datum/ai_behavior/find_potential_targets/spider
	vision_range = 5

/datum/ai_behavior/find_potential_targets/mimic
	vision_range = 1

/datum/ai_behavior/find_potential_targets/mimic/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if (succeeded)
		controller.CancelActions()
		controller.pawn.icon_state = "mimicopen"


/datum/ai_behavior/find_potential_targets/mole
	vision_range = 9

/datum/ai_behavior/find_potential_targets/troll
	vision_range = 7

/datum/ai_behavior/find_potential_targets/bog_troll
	vision_range = 3

/datum/ai_behavior/find_potential_targets/bog_troll/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	if(succeeded)
		if(istype(controller.pawn, /mob/living/simple_animal/hostile/retaliate/troll))
			var/mob/living/simple_animal/hostile/retaliate/troll/mob = controller.pawn
			mob.ambush()
