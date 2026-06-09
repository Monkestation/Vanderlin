/datum/ai_planning_subtree/leyline_melee_attack
	var/melee_attack_behavior = /datum/ai_behavior/leyline_melee_attack

/datum/ai_planning_subtree/leyline_melee_attack/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target))
		return

	controller.queue_behavior(melee_attack_behavior, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/leyline_melee_attack
	action_cooldown = 0.2 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/leyline_melee_attack/setup(datum/ai_controller/controller, target_key, targetting_datum_key)
	. = ..()
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]
	if(isnull(targetting_datum))
		CRASH("No target datum was supplied in the blackboard for [controller.pawn]")

	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

	set_movement_target(controller, target)
	SEND_SIGNAL(controller.pawn, COMSIG_COMBAT_TARGET_SET, TRUE)

/datum/ai_behavior/leyline_melee_attack/perform(seconds_per_tick, datum/ai_controller/controller, target_key, targetting_datum_key)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/leylinelycan/lycan = controller.pawn

	var/atom/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum.can_attack(lycan, target))
		finish_action(controller, FALSE, target_key)
		return

	if(ismob(target) && target:stat == DEAD)
		finish_action(controller, FALSE, target_key)
		return

	lycan.face_atom(target)

	// Select best intent (defaulting to bite)
	var/list/possible_intents = list()
	for(var/datum/intent/intent as anything in lycan.possible_a_intents)
		if(istype(intent, /datum/intent/simple/bite))
			possible_intents |= intent

	if(length(possible_intents))
		lycan.a_intent = pick(possible_intents)
		lycan.used_intent = lycan.a_intent

	if(!lycan.CanReach(target))
		finish_action(controller, FALSE, target_key)
		return

	controller.ai_interact(target, TRUE, TRUE)

	// Handle attack cooldown
	if(lycan.next_click < world.time)
		lycan.next_click = world.time + lycan.melee_attack_cooldown
		SEND_SIGNAL(lycan, COMSIG_MOB_BREAK_SNEAK)

	// Chance to sidestep after attack (35% chance)
	if(prob(35))
		if(!target || !isturf(target.loc) || !isturf(lycan.loc) || lycan.stat == DEAD)
			return

		var/target_dir = get_dir(lycan, target)
		var/chosen_dir = 0

		// Pick a direction to sidestep
		if(target_dir & (target_dir - 1)) // Diagonal
			chosen_dir = pick(-45, 0, 45)
		else // Cardinal
			chosen_dir = pick(-90, -45, 0, 45, 90)

		if(chosen_dir)
			chosen_dir = turn(target_dir, chosen_dir)
			lycan.Move(get_step(lycan, chosen_dir))
			lycan.face_atom(target) // Keep facing the target

/datum/ai_behavior/leyline_melee_attack/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)

	var/mob/living/simple_animal/hostile/retaliate/leylinelycan/lycan = controller.pawn
	lycan.cmode = FALSE
	SEND_SIGNAL(controller.pawn, COMSIG_COMBAT_TARGET_SET, FALSE)
