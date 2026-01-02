/datum/ai_planning_subtree/bring_food_to_babies
	var/kitten_detection_range = 7 // How far the cat can detect kittens

/datum/ai_planning_subtree/bring_food_to_babies/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()

	var/mob/living/simple_animal/pet/cat/cat_pawn = controller.pawn
	if(!istype(cat_pawn) || cat_pawn.stat == DEAD)
		return

	// First check if we already have food in inventory
	var/obj/item/reagent_containers/food/held_food = null
	if(istype(cat_pawn.held_item, /obj/item/reagent_containers/food))
		held_food = cat_pawn.held_item

	// If we don't have food, check if we have a food target
	var/obj/item/reagent_containers/food/food_target = null
	if(!held_food)
		var/atom/potential_food = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
		if(istype(potential_food, /obj/item/reagent_containers/food))
			food_target = potential_food

	// If we have neither food in hand nor a food target, do nothing
	if(!held_food && !food_target)
		return

	// Check if there are any kittens nearby
	var/mob/living/simple_animal/pet/cat/kitten/nearest_kitten = null
	var/nearest_dist = INFINITY

	for(var/mob/living/simple_animal/pet/cat/kitten/K in oview(kitten_detection_range, cat_pawn))
		if(K.stat == DEAD)
			continue
		if(SEND_SIGNAL(K, COMSIG_MOB_RETURN_HUNGER) > 25)
			continue

		var/dist = get_dist(cat_pawn, K)
		if(dist < nearest_dist)
			nearest_dist = dist
			nearest_kitten = K

	if(nearest_kitten)
		// Store kitten as target
		controller.set_blackboard_key(BB_CAT_KITTEN_TARGET, nearest_kitten)

		if(held_food)
			// We already have food, bring it to kitten
			controller.queue_behavior(/datum/ai_behavior/bring_food_to_kitten, BB_CAT_HOLDING_FOOD, BB_CAT_KITTEN_TARGET)
			return SUBTREE_RETURN_FINISH_PLANNING
		else if(food_target)
			// We need to pick up the food first
			controller.queue_behavior(/datum/ai_behavior/fetch_food_for_kitten, BB_BASIC_MOB_CURRENT_TARGET, BB_CAT_KITTEN_TARGET)
			return SUBTREE_RETURN_FINISH_PLANNING

// New behavior to pick up food before bringing to kitten
/datum/ai_behavior/fetch_food_for_kitten
	action_cooldown = 0.5 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	required_distance = 1

/datum/ai_behavior/fetch_food_for_kitten/setup(datum/ai_controller/controller, food_key, kitten_key)
	. = ..()

	var/obj/item/reagent_containers/food/food = controller.blackboard[food_key]
	if(QDELETED(food))
		return FALSE

	set_movement_target(controller, food)
	return TRUE

/datum/ai_behavior/fetch_food_for_kitten/perform(delta_time, datum/ai_controller/controller, food_key, kitten_key)
	. = ..()

	var/mob/living/simple_animal/pet/cat/cat_pawn = controller.pawn
	if(!istype(cat_pawn) || cat_pawn.stat == DEAD)
		finish_action(controller, FALSE)
		return

	var/obj/item/reagent_containers/food/food = controller.blackboard[food_key]
	var/mob/living/simple_animal/pet/cat/kitten/kitten = controller.blackboard[kitten_key]

	if(QDELETED(food) || QDELETED(kitten) || kitten.stat == DEAD)
		finish_action(controller, FALSE)
		return

	if(get_dist(cat_pawn, food) <= required_distance)
		// We're close enough to pick up the food
		cat_pawn.visible_message("<span class='notice'>\The [cat_pawn] picks up [food] in its mouth.</span>")

		// Pick up the food
		if(cat_pawn.held_item)
			// Drop current item if any
			cat_pawn.drop_held_item()

		cat_pawn.held_item = food
		food.forceMove(cat_pawn) // Move food into cat's inventory

		// Store reference to held food
		controller.set_blackboard_key(BB_CAT_HOLDING_FOOD, food)

		// Queue behavior to bring food to kitten
		controller.queue_behavior(/datum/ai_behavior/bring_food_to_kitten, BB_CAT_HOLDING_FOOD, BB_CAT_KITTEN_TARGET)

		finish_action(controller, TRUE)
		return

	// If we can't reach the food for some reason, give up after a timeout
	if(delta_time > 10 SECONDS)
		finish_action(controller, FALSE)
		return

/datum/ai_behavior/fetch_food_for_kitten/finish_action(datum/ai_controller/controller, succeeded, food_key, kitten_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(BB_CAT_KITTEN_TARGET)
		// Clear the food target if we failed to reach it
		controller.clear_blackboard_key(food_key)

/datum/ai_behavior/bring_food_to_kitten
	action_cooldown = 0.5 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	required_distance = 1

/datum/ai_behavior/bring_food_to_kitten/setup(datum/ai_controller/controller, food_key, kitten_key)
	. = ..()

	var/mob/living/simple_animal/pet/cat/kitten/kitten = controller.blackboard[kitten_key]
	if(QDELETED(kitten) || kitten.stat == DEAD)
		return FALSE

	set_movement_target(controller, kitten)
	return TRUE

/datum/ai_behavior/bring_food_to_kitten/perform(delta_time, datum/ai_controller/controller, food_key, kitten_key)
	. = ..()

	var/mob/living/simple_animal/pet/cat/cat_pawn = controller.pawn
	if(!istype(cat_pawn) || cat_pawn.stat == DEAD)
		finish_action(controller, FALSE)
		return

	var/obj/item/reagent_containers/food/food = controller.blackboard[food_key]
	var/mob/living/simple_animal/pet/cat/kitten/kitten = controller.blackboard[kitten_key]

	if(QDELETED(food) || QDELETED(kitten) || kitten.stat == DEAD)
		finish_action(controller, FALSE)
		return

	if(get_dist(cat_pawn, kitten) <= required_distance)
		// We're close enough to the kitten, drop the food
		cat_pawn.visible_message("<span class='notice'>\The [cat_pawn] drops [food] in front of [kitten].</span>")

		// Drop the food
		cat_pawn.held_item = null
		food.forceMove(get_turf(kitten))

		kitten.ai_controller?.ai_interact(food)
		if(!QDELETED(food))
			kitten.next_click = 0
			kitten.ai_controller?.ai_interact(food)

		// Make a meow sound
		//playsound(get_turf(cat_pawn), pick('sound/vo/mobs/cat/meow1.ogg', 'sound/vo/mobs/cat/meow2.ogg'), 50, TRUE, -1)

		// Clear the food reference
		controller.clear_blackboard_key(food_key)

		finish_action(controller, TRUE)
		return

	// If we can't reach the kitten for some reason, give up after a timeout
	if(delta_time > 10 SECONDS)
		finish_action(controller, FALSE)
		return

/datum/ai_behavior/bring_food_to_kitten/finish_action(datum/ai_controller/controller, succeeded, food_key, kitten_key)
	. = ..()
	controller.clear_blackboard_key(BB_CAT_KITTEN_TARGET)
	if(!succeeded && controller.blackboard[food_key])
		// If we fail to deliver, drop the food
		var/mob/living/simple_animal/pet/cat/cat_pawn = controller.pawn
		var/obj/item/reagent_containers/food = controller.blackboard[food_key]

		if(istype(cat_pawn) && cat_pawn.held_item == food)
			cat_pawn.drop_held_item()

		controller.clear_blackboard_key(food_key)
