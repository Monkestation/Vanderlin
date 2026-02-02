/datum/ai_planning_subtree/detect_humans

/datum/ai_planning_subtree/detect_humans/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	// Don't scan for humans if we're already engaged in combat
	if(controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return

	// Queue the behavior to find nearby humans
	controller.queue_behavior(/datum/ai_behavior/find_and_set/humans, BB_BASIC_MOB_FLEE_TARGET, /mob/living/carbon/human, 9)

/// Behavior that finds the nearest human we should flee from
/datum/ai_behavior/find_and_set/humans
	vision_range = 6

/datum/ai_behavior/find_and_set/humans/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(!ishuman(checking))
		return FALSE
	var/mob/living/carbon/human/H = checking
	if(H.stat == DEAD)
		return FALSE

	// Check if we can attack them (respects factions/friends)
	var/mob/living/living_pawn = pawn
	var/datum/ai_controller/controller = living_pawn.ai_controller
	var/datum/targetting_datum/targetting_datum = controller.blackboard[BB_TARGETTING_DATUM]
	if(!targetting_datum.can_attack(living_pawn, H))
		return FALSE

	return TRUE

/datum/ai_behavior/find_and_set/humans/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/mob/living/living_pawn = controller.pawn
	if(!living_pawn)
		return null

	var/list/potential_threats = list()
	for(var/mob/living/carbon/human/H in oview(search_range, living_pawn))
		if(H.stat == DEAD)
			continue
		// Check if we can attack them (respects factions/friends)
		var/datum/targetting_datum/targetting_datum = controller.blackboard[BB_TARGETTING_DATUM]
		if(!targetting_datum.can_attack(living_pawn, H))
			continue
		potential_threats += H

	if(!length(potential_threats))
		controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, FALSE)
		return null

	// Set fleeing state and return closest threat
	controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, TRUE)
	return pick_final_item(controller, potential_threats)

/datum/ai_behavior/find_and_set/humans/pick_final_item(datum/ai_controller/controller, list/potential_threats)
	var/turf/our_position = get_turf(controller.pawn)
	return get_closest_atom(/mob/living/carbon/human, potential_threats, our_position)

/datum/ai_behavior/find_and_set/humans/failed_to_find_anything(datum/ai_controller/controller, set_key, locate_path, search_range)
	controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, FALSE)
	return ..()
