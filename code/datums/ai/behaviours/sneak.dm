/datum/ai_planning_subtree/sneak/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	if(controller.blackboard[BB_SNEAKING] || (world.time < controller.blackboard[BB_SNEAK_COOLDOWN]))
		return

	var/mob/living/simple_animal/basic_mob = controller.pawn
	var/turf/current_turf = get_turf(basic_mob)
	var/light_amount = current_turf.get_lumcount()
	if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
		controller.queue_behavior(/datum/ai_behavior/basic_sneak)

/datum/ai_behavior/basic_sneak
	action_cooldown = 3 SECONDS  // How often to check for sneak opportunities
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

	/// Threshold of light to determine if it's dark enough to sneak
	var/light_threshold = SHADOW_SPECIES_LIGHT_THRESHOLD
	/// How long the cooldown is before the mob can sneak again after breaking sneaking
	var/sneak_cooldown_time = 30 SECONDS
	/// Key for tracking the sneak cooldown in the blackboard
	var/sneak_cooldown_key = BB_SNEAK_COOLDOWN
	/// Key for tracking sneaking status in the blackboard
	var/sneaking_key = BB_SNEAKING
	/// The alpha value applied when sneaking
	var/sneak_alpha = 100

/datum/ai_behavior/basic_sneak/setup(datum/ai_controller/controller)
	. = ..()
	// Initialize blackboard values if they don't exist
	if(isnull(controller.blackboard[sneak_cooldown_key]))
		controller.set_blackboard_key(sneak_cooldown_key, 0)
	if(isnull(controller.blackboard[sneaking_key]))
		controller.set_blackboard_key(sneaking_key, FALSE)

/datum/ai_behavior/basic_sneak/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/basic_mob = controller.pawn

	if(!isturf(basic_mob.loc))
		// Can't sneak if not on a turf
		finish_action(controller, FALSE)
		return

	var/currently_sneaking = controller.blackboard[sneaking_key]
	var/sneak_cooldown_time_remaining = controller.blackboard[sneak_cooldown_key]

	if(currently_sneaking)
		// Already sneaking, maintain the state
		finish_action(controller, TRUE)
		return

	if(world.time < sneak_cooldown_time_remaining)
		// Still on cooldown
		finish_action(controller, FALSE)
		return

	// Check light levels
	var/turf/current_turf = get_turf(basic_mob)
	var/light_amount = current_turf.get_lumcount()

	if(light_amount < light_threshold)
		// Dark enough to sneak
		start_sneaking(controller)
		finish_action(controller, TRUE)
	else
		finish_action(controller, FALSE)

/**
 * Start sneaking behavior
 * Sets alpha and updates blackboard state
 */
/datum/ai_behavior/basic_sneak/proc/start_sneaking(datum/ai_controller/controller)
	var/mob/living/simple_animal/basic_mob = controller.pawn
	controller.set_blackboard_key(sneaking_key, TRUE)
	basic_mob.alpha = sneak_alpha
	RegisterSignal(basic_mob, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(break_sneak))
	RegisterSignal(basic_mob, COMSIG_MOB_BREAK_SNEAK, PROC_REF(break_sneak))


/datum/ai_behavior/basic_sneak/proc/break_sneak(mob/living/simple_animal/basic_mob)
	var/datum/ai_controller/controller = basic_mob.ai_controller
	UnregisterSignal(basic_mob, list(COMSIG_MOB_BREAK_SNEAK, COMSIG_ATOM_WAS_ATTACKED))
	controller.set_blackboard_key(sneaking_key, FALSE)
	basic_mob.alpha = initial(basic_mob.alpha)
	controller.set_blackboard_key(sneak_cooldown_key, world.time + sneak_cooldown_time)
