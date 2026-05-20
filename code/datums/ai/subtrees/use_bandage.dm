/datum/ai_planning_subtree/use_bandage

/datum/ai_planning_subtree/use_bandage/SelectBehaviors(datum/ai_controller/controller, delta_time)
	if(controller.blackboard[BB_HELD_CONSUMABLE] || controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return

	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(!inv)
		return
	var/obj/item/bandage = inv.get_item(AI_ITEM_BANDAGE)
	if(!bandage)
		return
	var/real = FALSE
	var/mob/living/carbon/human/human_pawn = controller.pawn
	for(var/obj/item/bodypart/bodypart as anything in human_pawn.bodyparts)
		if((length(bodypart.wounds) || length(bodypart.embedded_objects)) && !bodypart.bandage)
			real = TRUE
			controller.set_blackboard_key(BB_TARGET_ZONE_OVERRIDE, bodypart.body_zone)
			break

	if(!real)
		return
	controller.queue_behavior(/datum/ai_behavior/apply_bandage, BB_HELD_CONSUMABLE, bandage)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/apply_bandage
	action_cooldown = 30 SECONDS

/datum/ai_behavior/apply_bandage/perform(delta_time, datum/ai_controller/controller, consumable_key, obj/item/bandage)
	controller.set_blackboard_key(BB_HELD_CONSUMABLE, bandage)
	if(!bandage)
		finish_action(controller, FALSE, consumable_key)
		return

	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	var/mob/living/carbon/human/H = controller.pawn

	if(H.get_active_held_item() != bandage)
		var/obj/item/usable = inv?.draw_usable_item(bandage, AI_ITEM_BANDAGE)
		if(!usable)
			finish_action(controller, FALSE, consumable_key)
			return

		// Cache the extracted item so finish_action can clean it up
		controller.set_blackboard_key(BB_HELD_CONSUMABLE, usable)

	var/old_zone = H.zone_selected
	H.zone_selected = controller.blackboard[BB_TARGET_ZONE_OVERRIDE]
	controller.ai_interact(H, maintain_position = TRUE)
	controller.clear_blackboard_key(BB_TARGET_ZONE_OVERRIDE)
	H.zone_selected = old_zone
	finish_action(controller, TRUE, consumable_key)

/datum/ai_behavior/apply_bandage/finish_action(datum/ai_controller/controller, succeeded, consumable_key)
	. = ..()
	controller.clear_blackboard_key(consumable_key)
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()

	var/mob/living/carbon/human/H = controller.pawn
	var/obj/item/held = H.get_active_held_item()
	if(held && (held.flags_ai_inventory & AI_ITEM_BANDAGE))
		if(!inv?.stow_item(held))
			H.dropItemToGround(held)

	inv?.restore_hands()
