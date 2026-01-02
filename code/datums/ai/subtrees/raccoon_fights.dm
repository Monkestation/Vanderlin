/datum/ai_planning_subtree/territorial_struggle/raccoon
	hostility_chance = 15 // Slightly less aggressive than male cats

/datum/ai_planning_subtree/territorial_struggle/raccoon/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	if(!SPT_PROB(hostility_chance, seconds_per_tick))
		return
	if(controller.blackboard_key_exists(BB_TRESSPASSER_TARGET))
		controller.queue_behavior(/datum/ai_behavior/territorial_struggle/raccoon, BB_TRESSPASSER_TARGET, BB_HOSTILE_MEOWS)
		return SUBTREE_RETURN_FINISH_PLANNING

	controller.queue_behavior(/datum/ai_behavior/find_and_set/raccoon_tresspasser, BB_TRESSPASSER_TARGET, /mob/living/simple_animal/hostile/retaliate/raccoon)

/datum/ai_behavior/find_and_set/raccoon_tresspasser
	action_cooldown = 5 SECONDS

/datum/ai_behavior/find_and_set/raccoon_tresspasser/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	for(var/mob/living/simple_animal/hostile/retaliate/raccoon/potential_enemy in oview(search_range, controller.pawn))
		if(potential_enemy == controller.pawn)
			continue
		var/datum/ai_controller/basic_controller/enemy_controller = potential_enemy.ai_controller
		if(isnull(enemy_controller))
			continue
		// They're already in a fight, leave them alone
		if(enemy_controller.blackboard_key_exists(BB_TRESSPASSER_TARGET))
			continue
		// Mutual targeting
		enemy_controller.set_blackboard_key(BB_TRESSPASSER_TARGET, controller.pawn)
		return potential_enemy
	return null

/datum/ai_behavior/find_and_set/raccoon_tresspasser/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(!istype(checking, /mob/living/simple_animal/hostile/retaliate/raccoon))
		return FALSE
	var/mob/living/simple_animal/hostile/retaliate/raccoon/potential_enemy = checking
	var/datum/ai_controller/basic_controller/enemy_controller = potential_enemy.ai_controller
	if(isnull(enemy_controller))
		return FALSE
	// They're already fighting someone
	if(enemy_controller.blackboard_key_exists(BB_TRESSPASSER_TARGET))
		return FALSE
	return TRUE

// Raccoon territorial struggle behavior
/datum/ai_behavior/territorial_struggle/raccoon
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION | AI_BEHAVIOR_REQUIRE_REACH
	action_cooldown = 0.25 SECONDS
	end_battle_chance = 20 // Raccoons end fights slightly more often than cats

/datum/ai_behavior/territorial_struggle/raccoon/perform(seconds_per_tick, datum/ai_controller/controller, target_key, cries_key)
	. = ..()
	var/mob/living/target = controller.blackboard[target_key]

	if(QDELETED(target))
		finish_action(controller, TRUE, target_key)
		return

	var/mob/living/living_pawn = controller.pawn
	var/list/threaten_list = controller.blackboard[cries_key]

	// Raccoon sounds and combat animations
	if(length(threaten_list))
		if(prob(50))
			if(prob(50))
				living_pawn.say(pick(threaten_list), forced = "ai_controller")
			else
				playsound(living_pawn, 'sound/vo/mobs/cat/cathiss.ogg', 80, TRUE, -1) // Can be replaced with raccoon-specific sounds

		else
			if(prob(50))
				target.say(pick(threaten_list), forced = "ai_controller")
			else
				playsound(target, 'sound/vo/mobs/cat/cathiss.ogg', 80, TRUE, -1)

	if(prob(35))
		if(prob(50))
			playsound(target, "smallslash", 100, TRUE, -1)
			target.do_attack_animation(living_pawn, "claw")
		else
			playsound(living_pawn, "smallslash", 100, TRUE, -1)
			living_pawn.do_attack_animation(target, "claw")

	if(!prob(end_battle_chance))
		return

	// 50/50 chance to determine loser
	var/datum/ai_controller/loser_controller = prob(50) ? controller : target.ai_controller

	loser_controller.set_blackboard_key(BB_BASIC_MOB_FLEE_TARGET, target)
	loser_controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, TRUE)
	addtimer(CALLBACK(loser_controller, TYPE_PROC_REF(/datum/ai_controller, set_blackboard_key), BB_BASIC_MOB_FLEEING, FALSE), 10 SECONDS)
	target.ai_controller.clear_blackboard_key(BB_TRESSPASSER_TARGET)
	finish_action(controller, TRUE, target_key)

/datum/ai_behavior/territorial_struggle/raccoon/finish_action(datum/ai_controller/controller, success, target_key)
	. = ..()
	controller.clear_blackboard_key(target_key)
