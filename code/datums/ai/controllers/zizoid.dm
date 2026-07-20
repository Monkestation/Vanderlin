/datum/ai_controller/zizoid
	movement_delay = 0.4 SECONDS

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/zizoid(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
		BB_FLESH_HUNGER = 0,
		BB_FLESH_FRENZY_COOLDOWN = 0,
		BB_FLESH_CONSUMED_BODIES = 0,
		BB_FLESH_LAST_HEALTH = 900,
		BB_FLESH_IS_REGENERATING = FALSE,
		BB_FLESH_AMBUSH_TARGET = null,
		BB_FLESH_FRENZY_ACTIVE = FALSE
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/flesh_frenzy_subtree,
		/datum/ai_planning_subtree/flesh_regeneration_subtree,
		/datum/ai_planning_subtree/flesh_hunger_subtree,
		/datum/ai_planning_subtree/flesh_ambush_subtree,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/flesh_advanced_melee_attack,
		/datum/ai_planning_subtree/find_dead_bodies,
		/datum/ai_planning_subtree/eat_dead_body,
	)

	idle_behavior = /datum/idle_behavior/flesh_idle

/datum/idle_behavior/flesh_idle/proc/find_lurk_spot(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn
	var/list/possible_lurk_spots = list()

	for(var/turf/open/T in orange(7, flesh))
		if(IS_OPAQUE_TURF(T) || (T.get_lumcount() < 0.5))
			if(!flesh.CanReach(T))
				continue
			possible_lurk_spots += T

	if(length(possible_lurk_spots))
		return pick(possible_lurk_spots)
	return null

/datum/idle_behavior/flesh_idle/perform_idle_behavior(delta_time, datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/blood/flesh = controller.pawn

	if(prob(15) && !controller.blackboard[BB_FLESH_IS_REGENERATING])
		var/turf/lurk_spot = find_lurk_spot(controller)
		if(lurk_spot)
			controller.set_movement_target(lurk_spot)
			return

	if(prob(5))
		playsound(flesh, pick('sound/effects/wounds/crack2.ogg', 'sound/effects/wounds/pierce1.ogg', 'sound/effects/wounds/splatter.ogg'), 100, TRUE)
		flesh.visible_message("<span class='warning'>[flesh] makes a disturbing wet sound.</span>")

	var/move_prob = 50
	if(controller.blackboard[BB_FLESH_HUNGER] > 75)
		move_prob = 80
	else if(controller.blackboard[BB_FLESH_IS_REGENERATING])
		move_prob = 20

	if(prob(move_prob))
		var/movement_target = locate(flesh.x + rand(-10, 10), flesh.y + rand(-10, 10), flesh.z)
		if(movement_target)
			controller.set_movement_target(movement_target)
