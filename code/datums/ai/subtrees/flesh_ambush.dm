/datum/ai_planning_subtree/flesh_ambush_subtree/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	// Don't ambush while regenerating or in frenzy
	if(controller.blackboard[BB_FLESH_IS_REGENERATING] || controller.blackboard[BB_FLESH_FRENZY_ACTIVE])
		return

	var/atom/ambush_target = controller.blackboard[BB_FLESH_AMBUSH_TARGET]
	if(!QDELETED(ambush_target))
		controller.queue_behavior(/datum/ai_behavior/continue_ambush)
		return SUBTREE_RETURN_FINISH_PLANNING

	// Random chance to enter ambush mode
	if(prob(5))
		controller.queue_behavior(/datum/ai_behavior/setup_ambush)

/datum/ai_behavior/setup_ambush
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/setup_ambush/setup(datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn

	// Find a dark spot to hide
	var/list/possible_ambush_spots = list()
	for(var/turf/T in orange(7, flesh))
		if((IS_OPAQUE_TURF(T) || T.get_lumcount() < 0.3))
			if(!flesh.CanReach(T))
				continue
			possible_ambush_spots += T

	if(!length(possible_ambush_spots))
		return FALSE

	var/turf/ambush_spot = pick(possible_ambush_spots)
	set_movement_target(controller, ambush_spot)
	return TRUE

/datum/ai_behavior/setup_ambush/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn
	var/datum/targetting_datum/targetting_datum = controller.blackboard[BB_TARGETTING_DATUM]
	// Look for potential targets
	var/list/potential_targets = list()
	for(var/mob/living/L in view(7, flesh))
		if(L != flesh && L.stat != DEAD && targetting_datum.can_attack(flesh, L))
			potential_targets += L

	if(!length(potential_targets))
		finish_action(controller, FALSE)
		return

	var/mob/living/target = pick(potential_targets)
	controller.blackboard[BB_FLESH_AMBUSH_TARGET] = target
	flesh.visible_message("<span class='warning'>[flesh] goes still, watching [target] intently...</span>", vision_distance = 3)

	// Add slight camouflage effect
	flesh.alpha = 180

	finish_action(controller, TRUE)

/datum/ai_behavior/continue_ambush
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	action_cooldown = 0.5 SECONDS

/datum/ai_behavior/continue_ambush/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn
	var/mob/living/target = controller.blackboard[BB_FLESH_AMBUSH_TARGET]

	// Check if target is still valid
	if(QDELETED(target) || target.stat == DEAD || get_dist(flesh, target) > 10)
		// Reset ambush
		controller.blackboard[BB_FLESH_AMBUSH_TARGET] = null
		flesh.alpha = 255
		finish_action(controller, FALSE)
		return

	// If target gets close enough, pounce!
	if(get_dist(flesh, target) <= 3)
		flesh.visible_message("<span class='danger'>[flesh] lunges at [target] from the shadows!</span>")
		flesh.alpha = 255

		if(isturf(flesh.loc) && isturf(target.loc))
			var/throw_dir = get_dir(flesh, target)
			var/turf/throw_at = get_step(target, throw_dir)
			flesh.forceMove(throw_at)

			flesh.UnarmedAttack(target)
			target.Knockdown(3 SECONDS)

			controller.blackboard[BB_FLESH_AMBUSH_TARGET] = null
			finish_action(controller, TRUE)
			return

	finish_action(controller, FALSE) // Continue ambushing
