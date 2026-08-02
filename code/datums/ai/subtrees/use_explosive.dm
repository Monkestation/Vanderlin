/datum/ai_planning_subtree/throw_grenade/SelectBehaviors(datum/ai_controller/controller, delta_time)
	// Only throw grenades if we have a target to throw at
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		return
	// Don't interrupt if already doing something
	if(controller.blackboard[BB_HELD_CONSUMABLE])
		return
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(!inv)
		return
	var/obj/item/explosive/grenade = inv.get_item(AI_ITEM_GRENADE)
	if(!grenade)
		return
	controller.set_blackboard_key(BB_HELD_CONSUMABLE, grenade)
	controller.queue_behavior(/datum/ai_behavior/throw_grenade, BB_HELD_CONSUMABLE, BB_BASIC_MOB_CURRENT_TARGET, grenade)

/datum/ai_behavior/throw_grenade
	action_cooldown = 2 MINUTES // Long cooldown - grenades are precious and dangerous also cause fuck having smoke bomb spamming horcs
	behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION | AI_BEHAVIOR_EXECUTE_ALONGSIDE

/datum/ai_behavior/throw_grenade/perform(delta_time, datum/ai_controller/controller, consumable_key, target_key, obj/item/explosive/grenade)
	controller.set_blackboard_key(BB_HELD_CONSUMABLE, grenade)
	if(!grenade)
		finish_action(controller, FALSE, consumable_key, target_key)
		return
	var/mob/living/target = controller.blackboard[target_key]
	if(!target || QDELETED(target))
		finish_action(controller, FALSE, consumable_key, target_key)
		return
	var/mob/living/carbon/human/H = controller.pawn
	// Check we're in throwable range
	if(get_dist(H, target) > grenade.throw_range)
		finish_action(controller, FALSE, consumable_key, target_key)
		return
	// no throwing through walls hopefully
	if(!can_see(H, target, grenade.throw_range))
		finish_action(controller, FALSE, consumable_key, target_key)
		return
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(H.get_active_held_item() != grenade)
		var/obj/item/usable = inv?.draw_usable_item(grenade, AI_ITEM_GRENADE)
		if(!usable)
			finish_action(controller, FALSE, consumable_key, target_key)
			return
		controller.set_blackboard_key(BB_HELD_CONSUMABLE, usable)
		grenade = usable
	grenade.arm_grenade(H)
	H.throw_item(get_turf(target))
	finish_action(controller, TRUE, consumable_key, target_key)

/datum/ai_behavior/throw_grenade/finish_action(datum/ai_controller/controller, succeeded, consumable_key, target_key)
	. = ..()
	controller.clear_blackboard_key(consumable_key)
	controller.clear_blackboard_key(target_key)
	// If somehow we still have it (arm failed, throw failed), drop it and die I guess
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	var/mob/living/carbon/human/H = controller.pawn
	var/obj/item/held = H.get_active_held_item()
	if(held && (held.flags_ai_inventory & AI_ITEM_GRENADE))
		if(!inv?.stow_item(held))
			H.dropItemToGround(held)
	inv?.restore_hands()
