/datum/ai_planning_subtree/use_powder
	var/combat_locked = TRUE

/datum/ai_planning_subtree/use_powder/bum
	combat_locked = FALSE

/datum/ai_planning_subtree/use_powder/SelectBehaviors(datum/ai_controller/controller, delta_time)
	// ONLY use powder if we're actively fighting someone
	if(!controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET] && combat_locked)
		return
	// Don't interrupt if already holding something to use
	if(controller.blackboard[BB_HELD_CONSUMABLE])
		return
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(!inv)
		return
	var/obj/item/powder = inv.get_item(AI_ITEM_POWDER)
	if(!powder)
		return
	controller.queue_behavior(/datum/ai_behavior/use_powder, BB_HELD_CONSUMABLE, powder)

/datum/ai_behavior/use_powder
	action_cooldown = 3 MINUTES // Very long cooldown, this is a rare treat
	behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION | AI_BEHAVIOR_EXECUTE_ALONGSIDE

/datum/ai_behavior/use_powder/perform(delta_time, datum/ai_controller/controller, consumable_key, obj/item/powder)
	controller.set_blackboard_key(BB_HELD_CONSUMABLE, powder)
	if(!powder)
		finish_action(controller, FALSE, consumable_key)
		return
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	var/mob/living/carbon/human/H = controller.pawn
	if(H.get_active_held_item() != powder)
		var/obj/item/usable = inv?.draw_usable_item(powder, AI_ITEM_POWDER)
		if(!usable)
			finish_action(controller, FALSE, consumable_key)
			return
		controller.set_blackboard_key(BB_HELD_CONSUMABLE, usable)
	// Powder must be snorted
	var/old_zone = H.zone_selected
	H.zone_selected = BODY_ZONE_PRECISE_NOSE
	controller.ai_interact(H, maintain_position = TRUE)
	H.zone_selected = old_zone
	finish_action(controller, TRUE, consumable_key)

/datum/ai_behavior/use_powder/finish_action(datum/ai_controller/controller, succeeded, consumable_key)
	. = ..()
	controller.clear_blackboard_key(consumable_key)
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	var/mob/living/carbon/human/H = controller.pawn
	var/obj/item/held = H.get_active_held_item()
	if(held && (held.flags_ai_inventory & AI_ITEM_POWDER))
		if(!inv?.stow_item(held))
			H.dropItemToGround(held)
	inv?.restore_hands()
