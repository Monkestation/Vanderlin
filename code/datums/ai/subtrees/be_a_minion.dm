/// Obey your summoner (or equivalent)
/datum/ai_planning_subtree/being_a_minion
	/// Blackboard key where we travel a place
	var/location_key = BB_TRAVEL_DESTINATION
	/// Who we're following
	var/follow_target = BB_FOLLOW_TARGET
	/// What do we do in order to travel
	var/travel_behavior = /datum/ai_behavior/travel_towards/stop_on_arrival


/datum/ai_planning_subtree/being_a_minion/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/mob/living/pawn = controller.pawn

	if(isliving(pawn) && SHOULD_RESIST(pawn))
		return

	// Commands take priority over travel/follow, but don't fight combat
	var/commanded_key = controller.blackboard[BB_COMMANDED_ACTION]
	if(commanded_key)
		controller.queue_behavior(/datum/ai_behavior/obey_command, BB_COMMANDED_ACTION, BB_COMMANDED_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

	var/turf/travel = controller.blackboard[location_key]
	var/mob/following = controller.blackboard[follow_target]

	var/mob/living/threat = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!isliving(threat) || QDELETED(threat) || threat.stat == DEAD)
		threat = controller.blackboard[BB_HIGHEST_THREAT_MOB]
	if(isliving(threat) && !QDELETED(threat) && threat.stat != DEAD)
		return

	if(travel)
		controller.queue_behavior(travel_behavior, location_key)
		return SUBTREE_RETURN_FINISH_PLANNING
	else if(following)
		if(get_dist(pawn, following) > 12)
			controller.clear_blackboard_key(BB_FOLLOW_TARGET)
		else
			controller.queue_behavior(/datum/ai_behavior/follow_friend, follow_target)
		return SUBTREE_RETURN_FINISH_PLANNING
	return

/// Follow the target
/datum/ai_behavior/follow_friend
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
/datum/ai_behavior/follow_friend/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]

	if (QDELETED(target))
		return FALSE
	set_movement_target(controller, target)
/datum/ai_behavior/follow_friend/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	var/mob/target = controller.blackboard[target_key]

	if (QDELETED(target))
		return

	return

/datum/ai_behavior/obey_command
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	/// Was pet_passive on before we hijacked it, so we know whether to restore it
	var/was_passive = FALSE
/datum/ai_behavior/obey_command/setup(datum/ai_controller/controller, action_key, target_key)
	. = ..()
	var/mob/living/pawn = controller.pawn
	if(QDELETED(pawn))
		return FALSE

	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

	switch(controller.blackboard[action_key])
		if("kick", "feint")
			required_distance = 1
		else
			required_distance = 10

	set_movement_target(controller, target)

	if(isanimal(pawn))
		var/mob/living/simple_animal/SA = pawn
		was_passive = SA.pet_passive
		SA.pet_passive = FALSE

	return TRUE

/datum/ai_behavior/obey_command/perform(seconds_per_tick, datum/ai_controller/controller, action_key, target_key)
	. = ..()
	var/mob/living/pawn = controller.pawn
	var/atom/target = controller.blackboard[target_key]
	var/key = controller.blackboard[action_key]

	if(QDELETED(pawn) || QDELETED(target))
		return finish_action(controller)

	if(required_distance && get_dist(pawn, target) > required_distance)
		return

	pawn.face_atom(target)

	switch(key)
		if("feint")
			if(!isliving(target))
				return finish_action(controller)
			if(isanimal(pawn))
				var/mob/living/simple_animal/SA = pawn
				SA.pet_passive = FALSE
			pawn.ai_controller?.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
			var/datum/rmb_intent/feint/F = new()
			F.special_attack(pawn, target)

		if("kick")
			if(!isliving(target))
				return finish_action(controller)
			if(!pawn.Adjacent(target)) //required_range=1 should have gotten us here, but re-check in case target moved this tick
				return
			pawn.ai_controller?.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
			if(istype(pawn, /mob/living/simple_animal/hostile/retaliate/primordial))
				var/mob/living/simple_animal/hostile/retaliate/primordial/P = pawn
				primordial_shove_effect(P, target)
			else
				var/old_mmb = pawn.mmb_intent
				pawn.mmb_intent = new INTENT_KICK(pawn)
				target.onkick(pawn)
				QDEL_NULL(pawn.mmb_intent)
				pawn.mmb_intent = old_mmb

		if("special")
			if(istype(pawn, /mob/living/simple_animal/hostile/retaliate/primordial))
				var/mob/living/simple_animal/hostile/retaliate/primordial/P = pawn
				if(!COOLDOWN_FINISHED(P, next_ability_use))
					return finish_action(controller)
				P.ability(get_turf(target), P)
				COOLDOWN_START(P, next_ability_use, P.ability_cooldown)
			else
				if(pawn.has_status_effect(/datum/status_effect/debuff/specialcd))
					return finish_action(controller)
				var/obj/item/weapon/W = pawn.get_active_held_item()
				if(!istype(W) || !W.weapon_special)
					return finish_action(controller)
				if(!W.weapon_special.apply_cost(pawn))
					return finish_action(controller)
				W.weapon_special.deploy(pawn, W, target)

	return finish_action(controller)

/datum/ai_behavior/obey_command/finish_action(datum/ai_controller/controller)
	. = ..()
	var/mob/living/pawn = controller.pawn
	if(!QDELETED(pawn) && isanimal(pawn) && was_passive)
		var/mob/living/simple_animal/SA = pawn
		SA.pet_passive = TRUE
	controller.clear_blackboard_key(BB_COMMANDED_ACTION)

/datum/ai_behavior/obey_command/proc/primordial_shove_effect(mob/living/simple_animal/hostile/retaliate/primordial/P, mob/living/target)
	var/shove_dir = get_dir(P, target)
	var/turf/dest = get_ranged_target_turf(target, shove_dir, 2)
	if(dest)
		target.throw_at(dest, 2, 1, P)
