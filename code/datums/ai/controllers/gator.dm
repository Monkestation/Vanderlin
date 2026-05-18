/datum/ai_controller/gator
	movement_delay = 0.8 SECONDS // Gators are slower than rats on land
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
		BB_GATOR_IN_WATER = FALSE,
		BB_GATOR_AMBUSH_COOLDOWN = 0,
		BB_GATOR_DEATH_ROLL_COOLDOWN = 0,
		BB_GATOR_PREFERRED_TERRITORY = null
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/simple_find_target/gator,
		/datum/ai_planning_subtree/find_food/gator,
		/datum/ai_planning_subtree/gator_behavior,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/gator_attack,
		/datum/ai_planning_subtree/find_dead_bodies,
		/datum/ai_planning_subtree/eat_dead_body,
		/datum/ai_planning_subtree/find_water,
	)
	idle_behavior = /datum/idle_behavior/gator_idle


/datum/idle_behavior/gator_idle
	var/ambush_pose_chance = 15 // Chance to enter an ambush pose while idle
	var/ambush_pose_time = 10 SECONDS // How long to stay in ambush pose

/datum/idle_behavior/gator_idle/perform_idle_behavior(delta_time, datum/ai_controller/controller)
	if(controller.blackboard[BB_BASIC_MOB_FOOD_TARGET]) // this means we are likely eating a corpse
		return
	if(controller.blackboard[BB_RESISTING]) //we are trying to resist
		return

	var/mob/living/simple_animal/hostile/retaliate/gator/gator_pawn = controller.pawn
	if(!istype(gator_pawn))
		return

	var/in_water = controller.blackboard[BB_GATOR_IN_WATER]

	// If in water, move less and occasionally enter ambush pose
	if(in_water)
		if(prob(ambush_pose_chance) && !gator_pawn.cmode)
			gator_pawn.visible_message("<span class='notice'>[gator_pawn] goes still, with only its eyes above the water.</span>")
			gator_pawn.cmode = TRUE
			addtimer(CALLBACK(src, PROC_REF(end_ambush_pose), gator_pawn), ambush_pose_time)
			return

		// Move less in water
		if(prob(15))
			step_rand(gator_pawn)
	else
		// Normal movement on land
		if(prob(50))
			step_rand(gator_pawn)

/datum/idle_behavior/gator_idle/proc/end_ambush_pose(mob/living/simple_animal/hostile/retaliate/gator/gator_pawn)
	if(istype(gator_pawn))
		gator_pawn.cmode = FALSE

/datum/ai_planning_subtree/find_water
	var/search_range = 10

/datum/ai_planning_subtree/find_water/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/gator/gator_pawn = controller.pawn
	if(!istype(gator_pawn))
		return

	// Only look for water if we don't have a preferred territory or target
	if(controller.blackboard[BB_GATOR_PREFERRED_TERRITORY] || controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return

	controller.queue_behavior(/datum/ai_behavior/find_water_source, search_range)

/datum/ai_planning_subtree/gator_behavior
	var/return_to_water_chance = 60 // Percent chance to return to water when not in combat
	var/ambush_cooldown = 30 SECONDS // Time between ambush attempts

/datum/ai_planning_subtree/gator_behavior/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/gator/gator_pawn = controller.pawn
	if(!istype(gator_pawn))
		return

	var/in_water = controller.blackboard[BB_GATOR_IN_WATER]
	var/has_target = !isnull(controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
	var/ambush_cooldown_time = controller.blackboard[BB_GATOR_AMBUSH_COOLDOWN]

	// Check if we're in water
	if(isturf(gator_pawn.loc))
		var/turf/T = gator_pawn.loc
		in_water = (istype(T, /turf/open/water) && !istype(T, /turf/open/water/river))

		for(var/turf/around in range(1, src))
			if(in_water)
				break
			in_water = (istype(around, /turf/open/water) && !istype(around, /turf/open/water/river))

		controller.set_blackboard_key(BB_GATOR_IN_WATER, in_water)

	if(has_target && in_water && ambush_cooldown_time <= world.time)
		controller.queue_behavior(/datum/ai_behavior/gator_ambush, BB_BASIC_MOB_CURRENT_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

	if(!has_target && !in_water && prob(return_to_water_chance))
		var/atom/water_target = controller.blackboard[BB_GATOR_PREFERRED_TERRITORY]
		if(QDELETED(water_target))
			return
		if(water_target.z != gator_pawn.z)
			controller.set_blackboard_key(BB_GATOR_PREFERRED_TERRITORY, null)
			water_target = null
		if(water_target)
			controller.queue_behavior(/datum/ai_behavior/return_to_water, BB_GATOR_PREFERRED_TERRITORY)
			return SUBTREE_RETURN_FINISH_PLANNING
