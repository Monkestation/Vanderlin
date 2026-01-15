
/datum/ai_planning_subtree/papameat_sacrifice

/datum/ai_planning_subtree/papameat_sacrifice/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/obj/structure/meatvine/papameat/papameat = controller.blackboard[BB_PAPAMEAT_TARGET]

	if(!papameat || QDELETED(papameat))
		controller.clear_blackboard_key(BB_PAPAMEAT_TARGET)
		controller.clear_blackboard_key(BB_PAPAMEAT_HEALING)
		return

	// Check if papameat is critical
	var/integrity_percent = papameat.get_integrity_percentage()
	if(integrity_percent >= PAPAMEAT_CRITICAL_HEALTH)
		return // Not critical, don't sacrifice

	// Check if another mob is already healing
	if(controller.blackboard[BB_PAPAMEAT_HEALING])
		return SUBTREE_RETURN_FINISH_PLANNING

	if(get_dist(papameat, controller.pawn) >= 75)
		return

	// Check if another mob is close enough and also healing
	for(var/mob/living/simple_animal/nearby in range(10, papameat))
		if(nearby == controller.pawn)
			continue
		var/datum/ai_controller/nearby_ai = nearby.ai_controller
		if(nearby_ai?.blackboard[BB_PAPAMEAT_HEALING])
			return // Someone else is already sacrificing

	controller.queue_behavior(/datum/ai_behavior/papameat_sacrifice, BB_PAPAMEAT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING



/datum/ai_planning_subtree/papameat_feed_corpse

/datum/ai_planning_subtree/papameat_feed_corpse/SelectBehaviors(datum/ai_controller/controller, delta_time)
	// Don't try to feed if we're in combat or healing
	if(controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return
	if(controller.blackboard[BB_PAPAMEAT_HEALING])
		return

	// Already feeding something
	if(controller.blackboard[BB_FEEDING_CORPSE])
		controller.queue_behavior(/datum/ai_behavior/papameat_feed_corpse, BB_CORPSE_TO_FEED)
		return SUBTREE_RETURN_FINISH_PLANNING

	// Look for nearby corpses
	var/mob/living/simple_animal/hostile/retaliate/meatvine/our_mob = controller.pawn
	var/obj/structure/meatvine/papameat/nearest_papameat = null
	var/min_dist = INFINITY

	// Find nearest papameat

	for(var/obj/structure/meatvine/papameat/PM in our_mob.master.papameats)
		var/dist = get_dist(our_mob, PM)
		if(dist > 30)
			continue
		if(dist < min_dist)
			min_dist = dist
			nearest_papameat = PM

	if(!nearest_papameat)
		return

	// Find corpses
	for(var/mob/living/corpse in view(10, our_mob))
		if(corpse == our_mob)
			continue
		if(corpse.stat != DEAD)
			continue
		if(corpse.buckled)
			continue // Already being dragged

		controller.set_blackboard_key(BB_CORPSE_TO_FEED, corpse)
		controller.set_blackboard_key(BB_PAPAMEAT_TARGET, nearest_papameat)
		controller.queue_behavior(/datum/ai_behavior/papameat_feed_corpse, BB_CORPSE_TO_FEED)
		return SUBTREE_RETURN_FINISH_PLANNING


/datum/ai_planning_subtree/papameat_defend

/datum/ai_planning_subtree/papameat_defend/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/obj/structure/meatvine/papameat/papameat = controller.blackboard[BB_PAPAMEAT_TARGET]

	if(!papameat || QDELETED(papameat))
		return

	// Don't defend if we're sacrificing or feeding
	if(controller.blackboard[BB_PAPAMEAT_HEALING])
		return
	if(controller.blackboard[BB_FEEDING_CORPSE])
		return

	controller.queue_behavior(/datum/ai_behavior/papameat_defend, BB_PAPAMEAT_TARGET)


/datum/ai_planning_subtree/meatvine_bridge

/datum/ai_planning_subtree/meatvine_bridge/SelectBehaviors(datum/ai_controller/controller, delta_time)
	// Don't bridge if we're doing critical tasks
	if(controller.blackboard[BB_PAPAMEAT_HEALING])
		return
	if(controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return

	// Check if we have an obstacle target
	var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = controller.pawn
	if(!length(mob?.master?.blocked_spread_locations))
		return
	var/datum/bridge_request/request = pick(mob.master.blocked_spread_locations)
	controller.set_blackboard_key(BB_BRIDGE_TARGET, request)

	if(!request || !request.target_location)
		controller.clear_blackboard_key(BB_BRIDGE_TARGET)
		controller.clear_blackboard_key(BB_BRIDGING)
		return

	// Check if request is too old (>60 seconds)
	if(world.time - request.timestamp > 600)
		controller.clear_blackboard_key(BB_BRIDGE_TARGET)
		controller.clear_blackboard_key(BB_BRIDGING)
		return

	// Already bridging
	if(controller.blackboard[BB_BRIDGING])
		controller.queue_behavior(/datum/ai_behavior/meatvine_bridge, BB_BRIDGE_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

	// Start bridging
	controller.queue_behavior(/datum/ai_behavior/meatvine_bridge, BB_BRIDGE_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/meatvine_destroy_obstacle

/datum/ai_planning_subtree/meatvine_destroy_obstacle/SelectBehaviors(datum/ai_controller/controller, delta_time)
	// Don't attack obstacles if we're healing papameat
	if(controller.blackboard[BB_PAPAMEAT_HEALING])
		return

	// Check if we have an obstacle target
	var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = controller.pawn
	if(!length(mob?.master?.obstacle_targets))
		return
	var/atom/obstacle = pick(mob.master.obstacle_targets)
	var/list/obstacles = mob.master.obstacle_targets.Copy()
	while(get_dist(obstacle, mob) > 30 && length(obstacles))
		var/atom/old_obstacle = obstacle
		obstacle = pick_n_take(obstacles)
		if(!locate(/obj/structure/meatvine/floor) in range(mob.tether_distance, obstacle))
			mob.master.cooldown_obstacle(obstacle)
			obstacle = old_obstacle

	controller.set_blackboard_key(BB_OBSTACLE_TARGET, obstacle)
	if(!obstacle || QDELETED(obstacle))
		controller.clear_blackboard_key(BB_OBSTACLE_TARGET)
		controller.clear_blackboard_key(BB_ATTACKING_OBSTACLE)
		return

	// Already attacking
	if(controller.blackboard[BB_ATTACKING_OBSTACLE])
		controller.queue_behavior(/datum/ai_behavior/meatvine_destroy_obstacle, BB_OBSTACLE_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

	// Start attacking
	controller.queue_behavior(/datum/ai_behavior/meatvine_destroy_obstacle, BB_OBSTACLE_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING


/datum/ai_planning_subtree/meatvine_evolve

/datum/ai_planning_subtree/meatvine_evolve/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = controller.pawn

	if(!istype(mob))
		return

	if(!length(mob.possible_evolutions))
		return

	// Don't evolve if we're doing critical tasks
	if(controller.blackboard[BB_PAPAMEAT_HEALING])
		return
	if(controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return
	if(controller.blackboard[BB_FEEDING_CORPSE])
		return

	// Check if ready to evolve
	if(mob.evolution_progress < mob.evolution_max)
		return

	// Find nearest papameat
	if(!mob.master?.papameats || !length(mob.master.papameats))
		return

	var/obj/structure/meatvine/papameat/nearest_papa = null
	var/min_dist = INFINITY

	for(var/obj/structure/meatvine/papameat/PM in mob.master.papameats)
		if(QDELETED(PM))
			continue
		var/dist = get_dist(mob, PM)
		if(dist < min_dist)
			min_dist = dist
			nearest_papa = PM

	if(!nearest_papa)
		return

	controller.set_blackboard_key(BB_EVOLUTION_TARGET, nearest_papa)
	controller.queue_behavior(/datum/ai_behavior/meatvine_evolve, BB_EVOLUTION_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING


/datum/ai_planning_subtree/use_personal_abilities

/datum/ai_planning_subtree/use_personal_abilities/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/mob = controller.pawn

	if(!istype(mob))
		return

	// Don't use abilities if we're doing critical tasks
	if(controller.blackboard[BB_PAPAMEAT_HEALING])
		return
	if(controller.blackboard[BB_FEEDING_CORPSE])
		return
	if(controller.blackboard[BB_BRIDGING])
		return

	// Evaluate all available abilities
	var/datum/action/cooldown/meatvine/personal/best_ability = null
	var/best_score = 0

	for(var/datum/action/cooldown/meatvine/personal/ability in mob.actions)
		if(!istype(ability))
			continue

		if(!ability.IsAvailable())
			continue

		var/score = ability.evaluate_ai_score(controller)
		if(score > best_score)
			best_score = score
			best_ability = ability

	if(!best_ability || best_score <= 0)
		return

	controller.set_blackboard_key(BB_ABILITY_TO_USE, best_ability)
	controller.queue_behavior(/datum/ai_behavior/use_personal_ability, BB_ABILITY_TO_USE)
	return SUBTREE_RETURN_FINISH_PLANNING
