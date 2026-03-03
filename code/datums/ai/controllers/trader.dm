/datum/ai_controller/basic_controller/trader
	max_target_distance = 300
	movement_delay = 0.4 SECONDS

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic,
	)

	ai_movement = /datum/ai_movement/astar ///datum/ai_movement/hybrid_pathing/gnome
	idle_behavior = /datum/idle_behavior/idle_random_walk/not_while_on_target/trader
	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree/trader,
		/datum/ai_planning_subtree/prepare_travel_to_destination/trader,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
		/datum/ai_planning_subtree/setup_shop,
	)

/datum/ai_controller/basic_controller/trader/jumpscare
	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree/trader,
		/datum/ai_planning_subtree/prepare_travel_to_destination/trader,
		/datum/ai_planning_subtree/travel_to_point/and_clear_target,
		/datum/ai_planning_subtree/setup_shop/jumpscare,
	)

/datum/ai_planning_subtree/basic_ranged_attack_subtree/trader
	ranged_attack_behavior = /datum/ai_behavior/basic_ranged_attack/trader

/datum/ai_behavior/basic_ranged_attack/trader
	action_cooldown = 3 SECONDS

///Subtree to find our very first customer and set up our shop after walking right into their face
/datum/ai_planning_subtree/setup_shop
	///What do we do in order to offer our deals?
	var/datum/ai_behavior/setup_shop/setup_shop_behavior = /datum/ai_behavior/setup_shop

/datum/ai_planning_subtree/setup_shop/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)

	//If we don't have our ability, return
	if(!controller.blackboard_key_exists(BB_SETUP_SHOP))
		return

	//If we already have a shop spot, return
	if(controller.blackboard_key_exists(BB_SHOP_SPOT))
		return

	//If we don't have a target stall, look for an unclaimed one
	if(!controller.blackboard_key_exists(BB_TARGET_STALL))
		controller.queue_behavior(/datum/ai_behavior/find_and_set/unclaimed_stall, BB_TARGET_STALL, /obj/effect/landmark/stall) // or whatever your stall type is
		return

	//We have our target stall, time to set up shop there
	controller.queue_behavior(setup_shop_behavior, BB_TARGET_STALL)
	return SUBTREE_RETURN_FINISH_PLANNING

///The ai will create a shop at an unclaimed stall
/datum/ai_behavior/setup_shop
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH


/datum/ai_behavior/setup_shop/setup(datum/ai_controller/controller, target_key)
	var/obj/target = controller.blackboard[target_key]
	if(!target)
		return FALSE
	set_movement_target(controller, target)
	return !QDELETED(target)

/datum/ai_behavior/setup_shop/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()

	//We lost track of our stall or our ability, abort
	if(!controller.blackboard_key_exists(target_key) || !controller.blackboard_key_exists(BB_SETUP_SHOP))
		finish_action(controller, FALSE, target_key)
		return

	var/datum/action/setup_shop/shop = controller.blackboard[BB_SETUP_SHOP]
	shop.Trigger()

	// Set the stall as our shop spot
	var/obj/effect/landmark/stall/stall = controller.blackboard[target_key]
	stall.claimed_by_trader = TRUE
	controller.set_blackboard_key(BB_SHOP_SPOT, stall)
	controller.clear_blackboard_key(BB_TARGET_STALL)

	finish_action(controller, TRUE, target_key)

/datum/idle_behavior/idle_random_walk/not_while_on_target/trader
	target_key = BB_SHOP_SPOT

///Version of setup show where the trader will run at you to assault you with incredible deals
/datum/ai_planning_subtree/setup_shop/jumpscare
	setup_shop_behavior = /datum/ai_behavior/setup_shop/jumpscare

/datum/ai_behavior/setup_shop/jumpscare
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH

/datum/ai_behavior/setup_shop/jumpscare/setup(datum/ai_controller/controller, target_key)
	. = ..()
	if(.)
		set_movement_target(controller, controller.blackboard[target_key])

/datum/ai_behavior/setup_shop/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	controller.clear_blackboard_key(target_key)



///Subtree that checks if we are on the target atom's tile, and sets it as a travel target if not
///The target is taken from the blackboard. This one always requires a specific implementation.
/datum/ai_planning_subtree/prepare_travel_to_destination
	var/target_key
	var/travel_destination_key = BB_TRAVEL_DESTINATION

/datum/ai_planning_subtree/prepare_travel_to_destination/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/atom/target = controller.blackboard[target_key]

	//Target is deleted, or we are already standing on it
	if(QDELETED(target) || (isturf(target) && controller.pawn.loc == target) || (target.loc == controller.pawn.loc))
		return

	//Already set with this value, return
	if(controller.blackboard[target_key] == controller.blackboard[travel_destination_key])
		return

	controller.queue_behavior(/datum/ai_behavior/set_travel_destination, target_key, travel_destination_key)
	return //continue planning regardless of success

/datum/ai_planning_subtree/prepare_travel_to_destination/trader
	target_key = BB_SHOP_SPOT

/datum/ai_behavior/set_travel_destination

/datum/ai_behavior/set_travel_destination/perform(seconds_per_tick, datum/ai_controller/controller, target_key, location_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]

	if(QDELETED(target))
		finish_action(controller, FALSE, target_key)
		return

	controller.set_blackboard_key(location_key, target)

	finish_action(controller, TRUE, target_key)

/datum/idle_behavior/idle_random_walk/not_while_on_target
	///What is the spot we have to stand on?
	var/target_key

/datum/idle_behavior/idle_random_walk/not_while_on_target/perform_idle_behavior(seconds_per_tick, datum/ai_controller/controller)
	var/atom/target = controller.blackboard[target_key]

	//Don't move, if we are are already standing on it
	if(!QDELETED(target) && ((isturf(target) && controller.pawn.loc == target) || (target.loc == controller.pawn.loc)))
		return

	return ..()
