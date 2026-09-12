/datum/ai_planning_subtree/flesh_advanced_melee_attack/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()

	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target))
		return
	if(!target)
		return

	if(controller.blackboard[BB_FLESH_FRENZY_ACTIVE])
		controller.queue_behavior(/datum/ai_behavior/flesh_frenzy_attack, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM)
		return SUBTREE_RETURN_FINISH_PLANNING

	// Normal combat with special moves
	controller.queue_behavior(/datum/ai_behavior/flesh_combat, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/flesh_combat
	action_cooldown = 0.2 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/flesh_combat/setup(datum/ai_controller/controller, target_key, targetting_datum_key)
	. = ..()
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]
	if(isnull(targetting_datum))
		return FALSE

	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

	set_movement_target(controller, target)
	return TRUE

/datum/ai_behavior/flesh_combat/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn
	var/mob/living/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum.can_attack(flesh, target))
		finish_action(controller, FALSE, target_key)
		return

	if(ismob(target) && target.stat == DEAD)
		finish_action(controller, FALSE, target_key)
		return

	flesh.face_atom(target)

	// Select attack type based on various factors
	var/attack_type = "normal"

	// Special grab attempt if target is weak
	if(ismob(target))
		var/mob/living/L = target
		if(L.health < L.maxHealth * 0.3 && prob(30))
			attack_type = "grab"

	// Powerful slam if we're well-fed
	if(controller.blackboard[BB_FLESH_HUNGER] < 50 && prob(25))
		attack_type = "slam"

	// Execute the selected attack
	if(!flesh.CanReach(target))
		finish_action(controller, FALSE, target_key)
		return

	if(flesh.next_click > world.time)
		return

	switch(attack_type)
		if("grab")
			flesh.visible_message("<span class='warning'>[flesh] tries to grab [target] with its massive arms!</span>")
			flesh.UnarmedAttack(target)
			if(prob(40) && ismob(target))
				var/mob/living/L = target
				L.OffBalance(8 SECONDS)
				L.visible_message("<span class='danger'>[L] is caught in [flesh]'s grasp!</span>")

		if("slam")
			flesh.visible_message("<span class='danger'>[flesh] slams down on [target] with tremendous force!</span>")
			// Stronger attack with knockdown
			flesh.UnarmedAttack(target)
			if(ismob(target))
				var/mob/living/L = target
				if(L.IsOffBalanced())
					L.CombatKnockdown(3 SECONDS)
				else
					L.OffBalance(3 SECONDS)

			for(var/mob/living/nearby in orange(1, target))
				if(nearby != target && nearby != flesh)
					flesh.UnarmedAttack(nearby)

		else
			flesh.UnarmedAttack(target)

	flesh.next_click = world.time + flesh.melee_attack_cooldown
	finish_action(controller, TRUE)

/datum/ai_behavior/flesh_combat/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)

/datum/ai_behavior/flesh_frenzy_attack
	action_cooldown = 0.1 SECONDS  // Attack faster in frenzy
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/flesh_frenzy_attack/setup(datum/ai_controller/controller, target_key, targetting_datum_key)
	. = ..()
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]
	if(isnull(targetting_datum))
		return FALSE

	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

	set_movement_target(controller, target)
	return TRUE

/datum/ai_behavior/flesh_frenzy_attack/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn
	var/mob/living/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum.can_attack(flesh, target))
		finish_action(controller, FALSE, target_key)
		return

	if(ismob(target) && target.stat == DEAD)
		finish_action(controller, FALSE, target_key)
		return

	if(flesh.next_click > world.time)
		return

	flesh.face_atom(target)

	if(!flesh.CanReach(target))
		finish_action(controller, FALSE, target_key)
		return

	// Frenzied attack - rapid slashing
	flesh.visible_message("<span class='danger'>[flesh] attacks [target] in a wild frenzy!</span>")
	flesh.UnarmedAttack(target)


	if(prob(40))
		flesh.UnarmedAttack(target)

	// Random movement after attack to make it harder to track
	var/list/possible_move_targets = list()
	for(var/turf/T in orange(2, flesh))
		if(flesh.CanReach(T))
			possible_move_targets += T

	if(length(possible_move_targets) && prob(50))
		var/turf/move_target = pick(possible_move_targets)
		flesh.forceMove(move_target)
		flesh.face_atom(target)

	flesh.next_click = world.time + (flesh.melee_attack_cooldown * 0.6) // Faster attacks in frenzy
	finish_action(controller, TRUE)

/datum/ai_behavior/flesh_frenzy_attack/finish_action(datum/ai_controller/controller, succeeded, ...)
	. = ..()
	controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
	SEND_SIGNAL(controller.pawn, COMSIG_COMBAT_TARGET_SET, FALSE)
