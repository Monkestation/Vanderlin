#define FLANK_RADIUS             3    // tiles away from target to orbit
#define FLANK_MIN_SEPARATION     60   // degrees between us and nearest ally
#define FLANK_ENGAGE_DIST        2    // tiles - "close enough" to our flank spot
#define FLANK_ATTACK_CHANCE      25   // % chance to commit a real attack while flanking
#define FLANK_RECHECK_INTERVAL   (3 SECONDS)

/datum/ai_planning_subtree/squad_flank

/datum/ai_planning_subtree/squad_flank/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target || QDELETED(target))
		controller.clear_blackboard_key(BB_HUMAN_NPC_FLANK_ANGLE)
		controller.clear_blackboard_key(BB_HUMAN_NPC_FLANK_TARGET)
		return

	var/list/ally_angles = list()
	var/turf/target_turf = get_turf(target)
	for(var/mob/living/carbon/human/ally in view(10, pawn))
		if(ally == pawn)
			continue
		if(!faction_check(pawn.faction, ally.faction))
			continue
		var/datum/ai_controller/human_npc/ally_ctrl = ally.ai_controller
		if(!ally_ctrl)
			continue
		var/mob/living/ally_target = ally_ctrl.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
		if(ally_target != target)
			continue
		// What angle is this ally at from the target?
		var/turf/ally_turf = get_turf(ally)
		if(!ally_turf || !target_turf)
			continue
		var/dx = ally_turf.x - target_turf.x
		var/dy = ally_turf.y - target_turf.y
		var/angle = round(arctan(dy, dx) + 360) % 360
		ally_angles += angle

	// If no allies are fighting this target, no need to flank
	if(!length(ally_angles))
		controller.clear_blackboard_key(BB_HUMAN_NPC_FLANK_ANGLE)
		controller.clear_blackboard_key(BB_HUMAN_NPC_FLANK_TARGET)
		return

	// Sort angles and find the largest gap
	ally_angles = sortList(ally_angles)
	var/largest_gap = 0
	var/gap_start_angle = 0
	for(var/i in 1 to length(ally_angles))
		var/next_i = (i % length(ally_angles)) + 1
		var/gap = (ally_angles[next_i] - ally_angles[i] + 360) % 360
		if(gap > largest_gap)
			largest_gap = gap
			gap_start_angle = ally_angles[i]

	// Not enough angular separation to bother flanking
	if(largest_gap < FLANK_MIN_SEPARATION)
		controller.clear_blackboard_key(BB_HUMAN_NPC_FLANK_ANGLE)
		controller.clear_blackboard_key(BB_HUMAN_NPC_FLANK_TARGET)
		return

	// Our ideal angle is the midpoint of the largest gap
	var/my_angle = (gap_start_angle + round(largest_gap / 2)) % 360

	var/cached_angle = controller.blackboard[BB_HUMAN_NPC_FLANK_ANGLE]
	var/turf/flank_turf = controller.blackboard[BB_HUMAN_NPC_FLANK_TARGET]

	// Recalculate if our angle has shifted more than 30 degrees or we have no turf
	if(isnull(cached_angle) || abs(cached_angle - my_angle) > 30 || QDELETED(flank_turf))
		var/fx = round(target_turf.x + FLANK_RADIUS * cos(my_angle))
		var/fy = round(target_turf.y + FLANK_RADIUS * sin(my_angle))
		flank_turf = locate(clamp(fx, 1, world.maxx), clamp(fy, 1, world.maxy), target_turf.z)
		var/search_attempts = 0
		while(flank_turf && (!flank_turf.can_cross_safely(pawn) || flank_turf.density) && search_attempts < FLANK_RADIUS)
			flank_turf = get_step_towards(flank_turf, target_turf)
			search_attempts++
		if(!flank_turf || !flank_turf.can_cross_safely(pawn))
			return
		controller.set_blackboard_key(BB_HUMAN_NPC_FLANK_ANGLE, my_angle)
		controller.set_blackboard_key(BB_HUMAN_NPC_FLANK_TARGET, flank_turf)

	if(get_dist(pawn, flank_turf) <= FLANK_ENGAGE_DIST)
		// We're in position. Occasionally fire an attack, otherwise just hold.
		if(prob(FLANK_ATTACK_CHANCE))
			controller.clear_blackboard_key(BB_HUMAN_NPC_FLANK_TARGET)
			return
		// Hold position, face target, look threatening
		pawn.face_atom(target)
		return SUBTREE_RETURN_FINISH_PLANNING
	controller.queue_behavior(/datum/ai_behavior/human_npc_move_to_flank, BB_HUMAN_NPC_FLANK_TARGET, BB_BASIC_MOB_CURRENT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/human_npc_move_to_flank
	action_cooldown = 0.2 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/human_npc_move_to_flank/setup(datum/ai_controller/controller, flank_turf_key, target_key)
	. = ..()
	var/turf/flank_turf = controller.blackboard[flank_turf_key]
	if(!flank_turf || QDELETED(flank_turf))
		return FALSE
	set_movement_target(controller, flank_turf)

/datum/ai_behavior/human_npc_move_to_flank/perform(delta_time, datum/ai_controller/controller, flank_turf_key, target_key)
	var/mob/living/carbon/human/pawn = controller.pawn
	var/turf/flank_turf = controller.blackboard[flank_turf_key]
	var/mob/living/target = controller.blackboard[target_key]

	if(!flank_turf || QDELETED(flank_turf))
		finish_action(controller, FALSE)
		return

	// If the target moved a lot, the flank turf may no longer make sense - let subtree recalculate
	if(target && get_dist(get_turf(target), flank_turf) > FLANK_RADIUS + 3)
		controller.clear_blackboard_key(BB_HUMAN_NPC_FLANK_ANGLE)
		controller.clear_blackboard_key(flank_turf_key)
		finish_action(controller, FALSE)
		return

	// Face the target while moving so we look alert
	if(target)
		pawn.face_atom(target)

	if(get_dist(pawn, flank_turf) <= FLANK_ENGAGE_DIST)
		finish_action(controller, TRUE)
		return

	finish_action(controller, FALSE)

#undef FLANK_RADIUS
#undef FLANK_MIN_SEPARATION
#undef FLANK_ENGAGE_DIST
#undef FLANK_ATTACK_CHANCE
#undef FLANK_RECHECK_INTERVAL
