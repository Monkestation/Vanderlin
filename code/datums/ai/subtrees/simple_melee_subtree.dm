/datum/ai_planning_subtree/basic_melee_attack_subtree
	var/datum/ai_behavior/basic_melee_attack/melee_attack_behavior = /datum/ai_behavior/basic_melee_attack
	/// Is this the last thing we do? (if we set a movement target, this will usually be yes)
	var/end_planning = TRUE

/datum/ai_planning_subtree/basic_melee_attack_subtree/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target))
		return
	controller.queue_behavior(melee_attack_behavior, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	if (end_planning)
		return SUBTREE_RETURN_FINISH_PLANNING //we are going into battle...no distractions.

//If you give this to something without the element you are a dumbass.
/datum/ai_planning_subtree/basic_ranged_attack_subtree
	var/min_dist = 3
	var/datum/ai_behavior/basic_ranged_attack/ranged_attack_behavior = /datum/ai_behavior/basic_ranged_attack

/datum/ai_planning_subtree/basic_ranged_attack_subtree/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target))
		return
	if(get_dist(target, controller.pawn) < min_dist)
		return

	controller.queue_behavior(ranged_attack_behavior, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	return SUBTREE_RETURN_FINISH_PLANNING //we are going into battle...no distractions.


/datum/ai_planning_subtree/basic_melee_attack_subtree/bog_troll
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack

/datum/ai_planning_subtree/basic_melee_attack_subtree/mimic
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack/mimic

/datum/ai_planning_subtree/basic_melee_attack_subtree/gator_attack
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack/gator_attack

/datum/ai_planning_subtree/basic_melee_attack_subtree/meatvine
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack/meatvine

/datum/ai_behavior/basic_melee_attack/gator_attack
	action_cooldown = 0.5 SECONDS
	var/death_roll_chance = 15 // Chance to perform a death roll on attack
	var/death_roll_damage = 15 // Extra damage from death roll
	var/death_roll_cooldown = 45 SECONDS // Time between death rolls

/datum/ai_behavior/basic_melee_attack/gator_attack/perform(delta_time, datum/ai_controller/controller, target_key, targetting_datum_key, hiding_location_key)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/gator/gator_pawn = controller.pawn
	var/atom/target = controller.blackboard[target_key]

	if(!istype(gator_pawn) || QDELETED(target) || !isliving(target))
		return

	var/death_roll_cooldown_time = controller.blackboard[BB_GATOR_DEATH_ROLL_COOLDOWN]

	// Check if we can perform a death roll
	if(prob(death_roll_chance) && death_roll_cooldown_time <= world.time && isliving(target))
		var/mob/living/L = target
		if(L.stat != DEAD)
			perform_death_roll(controller, gator_pawn, L)

// Death roll implementation
/datum/ai_behavior/basic_melee_attack/gator_attack/proc/perform_death_roll(datum/ai_controller/controller, mob/living/simple_animal/hostile/retaliate/gator/gator_pawn, mob/living/target)
	gator_pawn.visible_message("<span class='danger'>[gator_pawn] grabs [target] and performs a vicious death roll!</span>")

	target.apply_damage(death_roll_damage, BRUTE, BODY_ZONE_CHEST, damage_type = BCLASS_BITE)
	target.Paralyze(3 SECONDS)
	var/matrix/M = matrix()
	for(var/i in 1 to 3)
		animate(gator_pawn, transform = turn(M, 90 * i), time = 1)
		sleep(1)
	animate(gator_pawn, transform = M, time = 1)

	playsound(gator_pawn, 'sound/vo/mobs/gator/gatordeath.ogg', 70, TRUE)

	// Set cooldown
	controller.set_blackboard_key(BB_GATOR_DEATH_ROLL_COOLDOWN, world.time + death_roll_cooldown)


/datum/ai_planning_subtree/basic_melee_attack_subtree/saiga
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack/saiga
	var/datum/ai_behavior/basic_melee_attack/opportunistic/alternative = /datum/ai_behavior/basic_melee_attack/opportunistic

/datum/ai_planning_subtree/basic_melee_attack_subtree/saiga/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target))
		return
	if(controller.blackboard[BB_BASIC_MOB_FLEEING] && istype(target, /mob))
		controller.queue_behavior(alternative, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
		end_planning = FALSE
	else
		controller.queue_behavior(melee_attack_behavior, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	if (end_planning)
		return SUBTREE_RETURN_FINISH_PLANNING //we are going into battle...no distractions.

/datum/ai_planning_subtree/basic_melee_attack_subtree/no_flee/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(controller.blackboard[BB_BASIC_MOB_FLEEING])
		return
	if(QDELETED(target))
		return
	controller.queue_behavior(melee_attack_behavior, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	if (end_planning)
		return SUBTREE_RETURN_FINISH_PLANNING //we are going into battle...no distractions.

/datum/ai_planning_subtree/basic_melee_attack_subtree/hellhound
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack/hellhound


/datum/ai_planning_subtree/basic_melee_attack_subtree/warden
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack/warden

/datum/ai_planning_subtree/basic_melee_attack_subtree/species_hostile
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack/species_hostile

/// Attack something which is already adjacent to us, without ending planning
/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic
	melee_attack_behavior = /datum/ai_behavior/basic_melee_attack/opportunistic
	end_planning = FALSE
	var/travelling

///If on this, clears the walk travel target upon first contact with enemy
/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic/event_loc
	travelling = BB_TRAVEL_DESTINATION

/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target) || !controller.pawn.Adjacent(target))
		return
	if (isliving(controller.pawn))
		var/mob/living/pawn = controller.pawn
		if (LAZYLEN(pawn.do_afters))
			return

	if(travelling && controller.blackboard[travelling])
		controller.clear_blackboard_key(travelling)
	controller.queue_behavior(melee_attack_behavior, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)

/// Attack something which is already adjacent to us without moving
/datum/ai_behavior/basic_melee_attack/opportunistic
	action_cooldown = 0.2 SECONDS // We gotta check unfortunately often because we're in a race condition with nextmove
	behavior_flags = AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/basic_melee_attack/opportunistic/setup(datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	if (!controller.blackboard_key_exists(targeting_strategy_key))
		CRASH("No target datum was supplied in the blackboard for [controller.pawn]")
	return controller.blackboard_key_exists(target_key)

/datum/ai_behavior/basic_melee_attack/opportunistic/perform(seconds_per_tick, datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	var/atom/movable/atom_pawn = controller.pawn
	if(!atom_pawn.CanReach(controller.blackboard[target_key]))
		finish_action(controller, TRUE, target_key) // Don't clear target
		return FALSE
	. = ..()
	finish_action(controller, TRUE, target_key) // Try doing something else

/datum/ai_planning_subtree/basic_ranged_attack_subtree/opportunistic
	ranged_attack_behavior = /datum/ai_behavior/opportunistic_ranged_attack

/datum/ai_planning_subtree/basic_ranged_attack_subtree/opportunistic/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/mob/living/simple_animal/hostile/pawn = controller.pawn
	if(!istype(pawn) || !pawn.ranged || pawn.ranged_cooldown > world.time)
		return
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(QDELETED(target) || pawn.Adjacent(target))
		return
	controller.queue_behavior(ranged_attack_behavior, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
