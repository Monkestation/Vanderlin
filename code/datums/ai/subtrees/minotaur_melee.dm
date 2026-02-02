/datum/ai_planning_subtree/minotaur_melee_attack
/datum/ai_planning_subtree/minotaur_melee_attack/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target))
		return

	controller.queue_behavior(/datum/ai_behavior/minotaur_melee_attack, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/minotaur_melee_attack
	action_cooldown = 0.2 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/minotaur_melee_attack/setup(datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]
	if(isnull(targetting_datum))
		CRASH("No target datum was supplied in the blackboard for [controller.pawn]")

	// Hiding location is priority
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

	set_movement_target(controller, target)
	SEND_SIGNAL(controller.pawn, COMSIG_COMBAT_TARGET_SET, TRUE)

/datum/ai_behavior/minotaur_melee_attack/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/minotaur/boss = controller.pawn
	if(!boss || boss.stat != CONSCIOUS)
		return
	if(!istype(boss))
		finish_action(controller, FALSE)
		return
	var/atom/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]
	if(!targetting_datum.can_attack(boss, target))
		finish_action(controller, FALSE, target_key)
		return

	if(ismob(target))
		if(target:stat == DEAD)
			finish_action(controller, FALSE, target_key)
			return

	var/hiding_target = targetting_datum.find_hidden_mobs(boss, target)
	controller.set_blackboard_key(hiding_location_key, hiding_target)

	boss.face_atom(target)

	var/list/possible_intents = list()
	for(var/datum/intent/intent as anything in boss.possible_a_intents)
		if(istype(intent, /datum/intent/unarmed/help) || istype(intent, /datum/intent/unarmed/shove) || istype(intent, /datum/intent/unarmed/grab))
			continue
		possible_intents |= intent

	if(length(possible_intents))
		boss.a_intent = pick(possible_intents)
		boss.used_intent = boss.a_intent

	if(!boss.CanReach(target))
		finish_action(controller, FALSE, target_key)
		return

	var/current_phase = controller.blackboard[BB_MINOTAUR_PHASE]

	if(hiding_target)
		controller.ai_interact(hiding_target, TRUE, TRUE)
	else
		controller.ai_interact(target, TRUE, TRUE)

	// Extra effects based on phase
	if(current_phase >= 2 && prob(30))
		// Phase 2+ chance for a knockback effect
		if(ismob(target) && isturf(target.loc))
			var/mob/living/L = target
			var/throw_dir = get_dir(boss, L)
			L.throw_at(get_edge_target_turf(L, throw_dir), 1, 1)
			L.Knockdown(0.5 SECONDS)

	if(current_phase >= 3 && prob(20))
		// Phase 3 chance for a cleave attack hitting adjacent targets
		for(var/mob/living/L in range(1, boss))
			if(L != boss && L != target && !L.faction_check_mob(boss))
				L.adjustBruteLoss(boss.melee_damage_lower / 2)
				to_chat(L, "<span class='danger'>[boss] cleaves you with its attack!</span>")
				new /obj/effect/temp_visual/minotaur_impact(get_turf(L))

	if(boss.next_click < world.time && istype(boss))
		boss.next_click = world.time + boss.melee_attack_cooldown
		SEND_SIGNAL(boss, COMSIG_MOB_BREAK_SNEAK)

	// Chance to sidestep after attack, increasing with phase
	if(prob(15 * current_phase) && isturf(boss.loc) && isturf(target.loc) && boss.stat != DEAD)
		var/target_dir = get_dir(boss, target)
		var/static/list/cardinal_sidestep_directions = list(-90, -45, 0, 45, 90)
		var/static/list/diagonal_sidestep_directions = list(-45, 0, 45)
		var/chosen_dir = 0

		if(target_dir & (target_dir - 1))
			chosen_dir = pick(diagonal_sidestep_directions)
		else
			chosen_dir = pick(cardinal_sidestep_directions)

		if(chosen_dir)
			chosen_dir = turn(target_dir, chosen_dir)
			boss.Move(get_step(boss, chosen_dir))
			boss.face_atom(target)

/datum/ai_behavior/minotaur_melee_attack/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)

	var/mob/living/simple_animal/basic_mob = controller.pawn
	basic_mob.cmode = FALSE
	SEND_SIGNAL(controller.pawn, COMSIG_COMBAT_TARGET_SET, FALSE)
