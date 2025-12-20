/datum/ai_planning_subtree/beg_human

/datum/ai_planning_subtree/beg_human/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	if(istype(controller.pawn, /mob/living/simple_animal/hostile/retaliate))
		var/mob/living/simple_animal/hostile/retaliate/mob = controller.pawn
		if(SEND_SIGNAL(mob, COMSIG_MOB_RETURN_HUNGER) >= 25)
			return // not hungry
	if(controller.blackboard_key_exists(BB_HUMAN_BEG_TARGET))
		controller.queue_behavior(/datum/ai_behavior/beacon_for_food, BB_HUMAN_BEG_TARGET, BB_HUNGRY_MEOW, BB_BEGGING_FOOD_ITEM)
		return
	controller.queue_behavior(/datum/ai_behavior/find_and_set/human_beg, BB_HUMAN_BEG_TARGET, /mob/living/carbon/human)

/datum/ai_behavior/find_and_set/human_beg/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/list/locate_items = controller.blackboard[BB_BASIC_FOODS]
	for(var/mob/living/carbon/human/human_target in oview(search_range, controller.pawn))
		if(human_target.stat != CONSCIOUS || isnull(human_target.mind))
			continue
		var/obj/item/found_food = locate_food_in_hands(human_target, locate_items)
		if(!found_food)
			continue
		controller.set_blackboard_key(BB_BEGGING_FOOD_ITEM, found_food)
		return human_target
	return null

/datum/ai_behavior/find_and_set/human_beg/proc/locate_food_in_hands(mob/living/carbon/human/human_target, list/locate_items)
	var/list/filtered = typecache_filter_list(human_target.held_items, locate_items)
	if(length(filtered))
		return filtered[1]
	return null

/datum/ai_behavior/find_and_set/human_beg/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(!ishuman(checking))
		return FALSE
	var/mob/living/carbon/human/human_target = checking
	if(human_target.stat != CONSCIOUS || isnull(human_target.mind))
		return FALSE
	var/mob/living/living_pawn = pawn
	var/datum/ai_controller/controller = living_pawn.ai_controller
	var/list/locate_items = controller.blackboard[BB_BASIC_FOODS]
	var/obj/item/found_food = locate_food_in_hands(human_target, locate_items)
	if(!found_food)
		return FALSE
	controller.set_blackboard_key(BB_BEGGING_FOOD_ITEM, found_food)
	return TRUE

/datum/ai_behavior/beacon_for_food
	action_cooldown = 5 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	required_distance = 2

/datum/ai_behavior/beacon_for_food/setup(datum/ai_controller/controller, target_key, meows_key, food_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, (target))

/datum/ai_behavior/beacon_for_food/perform(seconds_per_tick, datum/ai_controller/controller, target_key, meows_key, food_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		finish_action(controller, FALSE, target_key, food_key)
		return
	if(get_dist(controller.pawn, target) > required_distance)
		return

	var/mob/living/living_pawn = controller.pawn
	var/list/meowing_list = controller.blackboard[meows_key]
	if(length(meowing_list))
		living_pawn.say(pick(meowing_list), forced = "ai_controller")

	var/obj/item/food_item = controller.blackboard[food_key]
	if(food_item && !QDELETED(food_item))
		living_pawn.create_point_bubble(food_item)

	finish_action(controller, TRUE, target_key, food_key)

/datum/ai_behavior/beacon_for_food/finish_action(datum/ai_controller/controller, success, target_key, food_key)
	. = ..()
	controller.clear_blackboard_key(target_key)
	controller.clear_blackboard_key(food_key)
