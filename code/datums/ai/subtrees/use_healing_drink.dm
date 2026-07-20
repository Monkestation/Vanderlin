/datum/ai_planning_subtree/use_healing_drink/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(!inv)
		return

	// Find a drink that actually has reagents, purge empties along the way
	var/obj/item/reagent_containers/drink = null
	for(var/obj/item/reagent_containers/candidate as anything in inv.inventory_map[AI_ITEM_HEALING_DRINK])
		if(!candidate.reagents?.total_volume)
			inv.drop_empty_container(candidate)
			continue
		drink = candidate
		break

	if(!drink)
		return

	var/mob/living/carbon/human/H = controller.pawn
	if(H.getBruteLoss() < 20 && H.getFireLoss() < 20)
		return

	controller.queue_behavior(/datum/ai_behavior/consume_healing_drink, BB_HELD_CONSUMABLE, drink)

/datum/ai_behavior/consume_healing_drink
	action_cooldown = 70 SECONDS
	behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION | AI_BEHAVIOR_EXECUTE_ALONGSIDE

/datum/ai_behavior/consume_healing_drink/perform(delta_time, datum/ai_controller/controller, consumable_key, obj/item/reagent_containers/glass/bottle/drink)
	controller.set_blackboard_key(BB_HELD_CONSUMABLE, drink)
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	var/mob/living/carbon/human/H = controller.pawn

	// may have been used since queued
	if(!drink || !drink.reagents?.total_volume)
		if(drink)
			inv?.drop_empty_container(drink)
		finish_action(controller, FALSE, consumable_key)
		return

	if(!inv?.draw_item(drink, AI_ITEM_HEALING_DRINK))
		finish_action(controller, FALSE, consumable_key)
		return

	if(!drink.canconsume(H, H))
		finish_action(controller, FALSE, consumable_key)
		return

	if(drink.closed)
		drink.toggle_cork(H, FALSE)

	drink.attack(H, H, list())
	finish_action(controller, TRUE, consumable_key)

/datum/ai_behavior/consume_healing_drink/finish_action(datum/ai_controller/controller, succeeded, consumable_key)
	. = ..()
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	var/mob/living/carbon/human/H = controller.pawn

	// Check if what's now in hand is the drink we used and it's empty
	var/obj/item/reagent_containers/held = H.get_active_held_item()
	if(istype(held, /obj/item/reagent_containers))
		if(!held.reagents?.total_volume)
			inv?.drop_empty_container(held)
		else
			if(!inv?.stow_item(held))
				H.dropItemToGround(held)
	inv?.restore_hands()
	controller.clear_blackboard_key(consumable_key)
