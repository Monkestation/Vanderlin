/datum/ai_planning_subtree/use_throwable
	var/max_throw_dist = 7 // Only throw if within this distance
	var/min_throw_dist = 2 // Don't bother throwing at point blank

/datum/ai_planning_subtree/use_throwable/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		return
	if(controller.blackboard[BB_HELD_CONSUMABLE])
		return

	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(!inv)
		return

	var/obj/item/weapon/knife/throwingknife = inv.get_item(AI_ITEM_THROWING)
	if(!throwingknife)
		return

	var/mob/living/pawn = controller.pawn
	var/dist = get_dist(pawn, target)

	// Only throw within our sweet spot range
	if(dist > max_throw_dist || dist < min_throw_dist)
		return

	// Need line of sight to throw
	if(!can_see(pawn, target, max_throw_dist))
		return

	controller.queue_behavior(/datum/ai_behavior/use_throwable, BB_HELD_CONSUMABLE, BB_BASIC_MOB_CURRENT_TARGET, throwingknife)

/datum/ai_behavior/use_throwable
	action_cooldown = 4 SECONDS
	behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION | AI_BEHAVIOR_EXECUTE_ALONGSIDE

/datum/ai_behavior/use_throwable/perform(delta_time, datum/ai_controller/controller, consumable_key, target_key, obj/item/weapon/knife/throwingknife)
	. = ..()
	controller.set_blackboard_key(BB_HELD_CONSUMABLE, throwingknife)
	if(!throwingknife)
		finish_action(controller, FALSE, consumable_key, target_key)
		return

	var/mob/living/target = controller.blackboard[target_key]
	if(!target || QDELETED(target))
		finish_action(controller, FALSE, consumable_key, target_key)
		return

	var/mob/living/pawn = controller.pawn
	var/dist = get_dist(pawn, target)

	if(dist > throwingknife.throw_range || dist < 2)
		finish_action(controller, FALSE, consumable_key, target_key)
		return

	if(!can_see(pawn, target, throwingknife.throw_range))
		finish_action(controller, FALSE, consumable_key, target_key)
		return

	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(pawn.get_active_held_item() != throwingknife)
		var/obj/item/usable = inv?.draw_usable_item(throwingknife, AI_ITEM_THROWING)
		if(!usable)
			finish_action(controller, FALSE, consumable_key, target_key)
			return
		controller.set_blackboard_key(BB_HELD_CONSUMABLE, usable)
		throwingknife = usable

	pawn.face_atom(target)
	pawn.throw_item(get_turf(target))
	finish_action(controller, TRUE, consumable_key, target_key)

/datum/ai_behavior/use_throwable/finish_action(datum/ai_controller/controller, succeeded, consumable_key, target_key)
	. = ..()
	controller.clear_blackboard_key(consumable_key)
	// Restore hands to whatever they were holding before
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	inv?.restore_hands()
