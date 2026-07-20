#define HARASS_HEALTH_THRESHOLD   0.65  // below 65% max health = consider harassing
#define HARASS_STAMINA_THRESHOLD  55    // above this stamina damage = consider harassing
#define HARASS_RETREAT_DIST       4     // tiles to back off after an attack
#define HARASS_BASE_COOLDOWN      (4 SECONDS)  // base pause between dart-ins
#define HARASS_STAMINA_COOLDOWN_SCALE 0.05 // extra seconds per point of stamina over threshold

/datum/ai_planning_subtree/wounded_harass

/datum/ai_planning_subtree/wounded_harass/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target || QDELETED(target))
		controller.set_blackboard_key(BB_HUMAN_NPC_HARASS_MODE, FALSE)
		controller.set_blackboard_key(BB_HUMAN_NPC_HARASS_RETREATING, FALSE)
		return

	var/health_frac = pawn.health / pawn.maxHealth //idk if this does anything for humans
	// Stamina threshold scales down as health drops - the more hurt we are the easier tiredness triggers harass
	var/effective_stamina_thresh = HARASS_STAMINA_THRESHOLD * health_frac
	var/should_harass = (health_frac < HARASS_HEALTH_THRESHOLD) || (pawn.stamina > effective_stamina_thresh)

	var/currently_harassing = controller.blackboard[BB_HUMAN_NPC_HARASS_MODE]

	if(!should_harass && !currently_harassing)
		return // Healthy and not tired, normal combat

	if(!should_harass && currently_harassing)
		// ewxit harass mode once we finish a retreat
		if(!controller.blackboard[BB_HUMAN_NPC_HARASS_RETREATING])
			controller.set_blackboard_key(BB_HUMAN_NPC_HARASS_MODE, FALSE)
			return
		// Still retreating from last dart, finish it out
		controller.queue_behavior(/datum/ai_behavior/human_npc_harass_retreat, BB_BASIC_MOB_CURRENT_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

	controller.set_blackboard_key(BB_HUMAN_NPC_HARASS_MODE, TRUE)

	if(controller.blackboard[BB_HUMAN_NPC_HARASS_RETREATING])
		if(world.time < controller.blackboard[BB_HUMAN_NPC_HARASS_COOLDOWN])
			//back off and wait
			controller.queue_behavior(/datum/ai_behavior/human_npc_harass_retreat, BB_BASIC_MOB_CURRENT_TARGET)
			return SUBTREE_RETURN_FINISH_PLANNING
		controller.set_blackboard_key(BB_HUMAN_NPC_HARASS_RETREATING, FALSE)
		return SUBTREE_RETURN_FINISH_PLANNING // re-plan next tick into DART IN

	// If we're adjacent, fire the attack then immediately start retreating
	if(pawn.Adjacent(target))
		controller.queue_behavior(/datum/ai_behavior/human_npc_harass_strike, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM)
		return SUBTREE_RETURN_FINISH_PLANNING

	// Not adjacent - move in
	controller.queue_behavior(/datum/ai_behavior/human_npc_harass_dart_in, BB_BASIC_MOB_CURRENT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/human_npc_harass_dart_in
	action_cooldown = 0.2 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/human_npc_harass_dart_in/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(!target || QDELETED(target))
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/human_npc_harass_dart_in/perform(delta_time, datum/ai_controller/controller, target_key)
	var/mob/living/carbon/human/pawn = controller.pawn
	var/mob/living/target = controller.blackboard[target_key]
	if(!target || QDELETED(target))
		finish_action(controller, FALSE)
		return
	pawn.face_atom(target)
	if(pawn.Adjacent(target))
		finish_action(controller, TRUE) // adjacent, subtree will now queue the strike
		return


/datum/ai_behavior/human_npc_harass_dart_in/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()

/datum/ai_behavior/human_npc_harass_strike
	action_cooldown = 0.2 SECONDS
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/human_npc_harass_strike/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key)
	var/mob/living/carbon/human/pawn = controller.pawn
	var/mob/living/target = controller.blackboard[target_key]
	var/datum/targetting_datum/td = controller.blackboard[targetting_datum_key]

	if(!target || QDELETED(target) || !td.can_attack(pawn, target))
		finish_action(controller, FALSE)
		return

	if(pawn.next_move > world.time) // not ready to swing yet
		finish_action(controller, FALSE)
		return

	pawn.face_atom(target)

	// Pick an intent - same logic as smart melee
	var/list/possible_intents = list()
	for(var/datum/intent/intent as anything in pawn.possible_a_intents)
		if(istype(intent, /datum/intent/unarmed/help) || istype(intent, /datum/intent/unarmed/shove) || istype(intent, /datum/intent/unarmed/grab))
			continue
		possible_intents |= intent
	if(length(possible_intents))
		pawn.a_intent = pick(possible_intents)
		pawn.used_intent = pawn.a_intent

	if(!pawn.CanReach(target))
		finish_action(controller, FALSE)
		return

	controller.ai_interact(target, TRUE, TRUE)
	if(pawn.next_click < world.time)
		pawn.next_click = world.time + (pawn.used_intent?.clickcd * ( 1 + rand(0.2, 0.4)))
		SEND_SIGNAL(pawn, COMSIG_MOB_BREAK_SNEAK)

	// Cooldown scales up with stamina damage and scales down with health - the more gassed/hurt, the longer we hide
	var/health_frac = pawn.health / pawn.maxHealth
	var/stamina_over = max(0, pawn.stamina - HARASS_STAMINA_THRESHOLD)
	var/cooldown = HARASS_BASE_COOLDOWN
	cooldown += stamina_over * HARASS_STAMINA_COOLDOWN_SCALE SECONDS
	cooldown *= lerp(1.5, 1.0, health_frac) // up to 50% longer cooldown at 0 health
	controller.set_blackboard_key(BB_HUMAN_NPC_HARASS_RETREATING, TRUE)
	controller.set_blackboard_key(BB_HUMAN_NPC_HARASS_COOLDOWN, world.time + cooldown)
	finish_action(controller, TRUE)

/datum/ai_behavior/human_npc_harass_retreat
	action_cooldown = 0.2 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/human_npc_harass_retreat/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/carbon/human/pawn = controller.pawn
	var/mob/living/target = controller.blackboard[target_key]
	if(!target || QDELETED(target))
		return FALSE
	var/turf/retreat_turf = get_turf(pawn)
	var/retreat_dir = REVERSE_DIR(get_dir(pawn, target))
	for(var/i in 1 to HARASS_RETREAT_DIST)
		var/turf/next = get_step(retreat_turf, retreat_dir)
		if(!next || !next.can_cross_safely(pawn) || next.density)
			break
		retreat_turf = next
	set_movement_target(controller, retreat_turf)

/datum/ai_behavior/human_npc_harass_retreat/perform(delta_time, datum/ai_controller/controller, target_key)
	var/mob/living/carbon/human/pawn = controller.pawn
	var/mob/living/target = controller.blackboard[target_key]
	// Keep facing target while backing off so we don't turn our back
	if(target && !QDELETED(target))
		pawn.face_atom(target)
	var/turf/move_target = controller.current_movement_target
	if(!move_target || get_dist(pawn, move_target) <= 1)
		finish_action(controller, TRUE)
		return.

#undef HARASS_HEALTH_THRESHOLD
#undef HARASS_STAMINA_THRESHOLD
#undef HARASS_RETREAT_DIST
#undef HARASS_BASE_COOLDOWN
#undef HARASS_STAMINA_COOLDOWN_SCALE
