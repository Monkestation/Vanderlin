/datum/ai_controller/lycan
	movement_delay = 0.5 SECONDS
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/leyline(),
		BB_LEYLINE_SOURCE = null,
		BB_TELEPORT_COOLDOWN = 0,
		BB_ENERGY_SURGE_COOLDOWN = 0,
		BB_SHOCKWAVE_COOLDOWN = 0,
		BB_LEYLINE_ENERGY = 100,
		BB_MAX_LEYLINE_ENERGY = 100,
		BB_ENERGY_REGEN_RATE = 0.5
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/leyline_special_abilities,
		/datum/ai_planning_subtree/leyline_teleport,
		/datum/ai_planning_subtree/leyline_melee_attack,
		/datum/ai_planning_subtree/defend_leyline,
		/datum/ai_planning_subtree/leyline_energy_management,
	)
	idle_behavior = /datum/idle_behavior/guard_leyline


/datum/idle_behavior/guard_leyline/perform_idle_behavior(delta_time, datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/leylinelycan/lycan = controller.pawn
	var/obj/structure/leyline/source = controller.blackboard[BB_LEYLINE_SOURCE]

	if(prob(15))
		step_rand(lycan)

	if(!source || QDELETED(source))
		return

	// If we moved too far from our leyline, move back towards it
	if(get_dist(lycan, source) > 7)
		controller.set_movement_target(source)
		return

/datum/targetting_datum/basic/leyline

/datum/targetting_datum/basic/leyline/can_attack(mob/living/living_mob, atom/the_target)
	if(isturf(the_target) || !the_target ) // bail out on invalids
		return FALSE
	var/mob/living/simple_animal/attacker = living_mob
	if(istype(attacker))
		if(attacker.binded == TRUE)
			return FALSE

	if(isobj(the_target))
		return TRUE

	if(ismob(the_target)) //Target is in godmode, ignore it.
		if(HAS_TRAIT(the_target, TRAIT_GODMODE))
			return FALSE

	if(living_mob.see_invisible < the_target.invisibility)//Target's invisible to us, forget it
		return FALSE

	if(HAS_TRAIT(the_target, TRAIT_IMPERCEPTIBLE))
		return FALSE

	if(!isturf(the_target.loc))
		return FALSE

	if(isliving(the_target)) //Targetting vs living mobs
		var/mob/living/L = the_target
		if(faction_check(living_mob, L) || L.stat >= DEAD) //basic targetting doesn't target dead people
			return FALSE
		return TRUE

	return FALSE
