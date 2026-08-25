/datum/ai_planning_subtree/basic_melee_attack_subtree/no_flee/dragger
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack/dragger
	end_planning = TRUE

/datum/ai_behavior/basic_melee_attack/dragger
	action_cooldown = 0.2 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	sidesteps_after = TRUE

/datum/ai_behavior/basic_melee_attack/dragger/perform(seconds_per_tick, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()

	var/mob/living/simple_animal/hostile/dragger/dragger_pawn = controller.pawn
	if(!dragger_pawn || dragger_pawn.stat != CONSCIOUS)
		return

	var/atom/target = controller.blackboard[target_key]
	if(!iscarbon(target) || QDELETED(target))
		return

	var/mob/living/carbon/victim = target
	if(victim.stat == DEAD)
		return

	// Check if we can start dragging the victim
	var/drag_cooldown = controller.blackboard[BB_DRAGGER_DRAG_COOLDOWN]
	if(drag_cooldown <= world.time && prob(15))
		controller.blackboard[BB_DRAGGER_VICTIM] = victim
		controller.queue_behavior(/datum/ai_behavior/drag_victim)
		controller.blackboard[BB_DRAGGER_DRAG_COOLDOWN] = world.time + 15 SECONDS
