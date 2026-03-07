/datum/ai_planning_subtree/mug
	var/scan_range = 2
	var/mug_want_category = AI_ITEM_POWDER

/datum/ai_planning_subtree/mug/SelectBehaviors(datum/ai_controller/controller, delta_time)
	if(controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return
	if(controller.blackboard[BB_BASIC_MOB_FLEEING])
		return
	if(controller.blackboard[BB_MUG_TARGET])
		return

	var/mob/living/pawn = controller.pawn
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(!inv)
		return

	for(var/mob/living/target in view(scan_range, pawn))
		if(target == pawn)
			continue
		if(!target.client)
			continue
		if(target.stat != CONSCIOUS)
			continue
		var/obj/item/wanted = _find_muggable_item(inv, target)
		if(!wanted)
			continue
		controller.set_blackboard_key(BB_MUG_TARGET, target)
		controller.set_blackboard_key(BB_MUG_TARGET_ITEM, wanted)
		controller.queue_behavior(/datum/ai_behavior/mug, BB_MUG_TARGET, BB_MUG_TARGET_ITEM)
		return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/mug/proc/_find_muggable_item(datum/component/ai_inventory_manager/inv, mob/living/target)
	for(var/obj/item/held in target.contents)
		if(!held)
			continue
		var/datum/component/storage/STR = held.GetComponent(/datum/component/storage)
		if(STR)
			for(var/obj/item/held_inside in held.contents)
				if(!(held_inside.flags_ai_inventory & mug_want_category))
					continue
				return held_inside
		if(!(held.flags_ai_inventory & mug_want_category))
			continue
		return held
	return null

/datum/ai_behavior/mug
	action_cooldown = 0.5 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	var/demand_duration = 5 SECONDS
	var/threatened = FALSE

/datum/ai_behavior/mug/setup(datum/ai_controller/controller, target_key, item_key)
	. = ..()
	var/mob/living/target = controller.blackboard[target_key]
	if(QDELETED(target) || target.stat != CONSCIOUS)
		return FALSE
	set_movement_target(controller, target)
	controller.set_blackboard_key(BB_MUG_DEMAND_ELAPSED, 0)
	return TRUE

/datum/ai_behavior/mug/perform(delta_time, datum/ai_controller/controller, target_key, item_key)
	. = ..()
	var/mob/living/target = controller.blackboard[target_key]
	var/obj/item/wanted = controller.blackboard[item_key]

	if(QDELETED(target) || target.stat != CONSCIOUS || QDELETED(wanted))
		finish_action(controller, FALSE, target_key, item_key)
		return

	var/mob/living/carbon/human/pawn = controller.pawn
	if(!pawn.Adjacent(target))
		finish_action(controller, FALSE, target_key, item_key)
		return

	if(wanted.loc == pawn || isturf(wanted.loc))
		finish_action(controller, TRUE, target_key, item_key)
		return

	var/obj/offered = target.offered_item_ref?.resolve()
	if(offered == wanted)
		var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
		if(inv)
			var/slot_flag = inv.find_space_for(wanted)
			if(slot_flag)
				var/obj/item/container = inv.container_refs[slot_flag]
				var/datum/component/storage/STR = container?.GetComponent(/datum/component/storage)
				if(STR)
					pawn.accept_offered_item(target, wanted, FALSE)
					STR.handle_item_insertion(wanted, prevent_warning = TRUE, user = pawn)
					inv._classify_item(wanted, slot_flag)
					finish_action(controller, TRUE, target_key, item_key)
					return

	var/elapsed = controller.blackboard[BB_MUG_DEMAND_ELAPSED] + delta_time
	controller.set_blackboard_key(BB_MUG_DEMAND_ELAPSED, elapsed)

	if(elapsed >= demand_duration)
		controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
		finish_action(controller, FALSE, target_key, item_key)
		return

	if(!threatened)
		pawn.say("Give me \the [wanted] and no one gets hurt.")
		threatened = TRUE

/datum/ai_behavior/mug/finish_action(datum/ai_controller/controller, succeeded, target_key, item_key)
	. = ..()
	controller.clear_blackboard_key(BB_MUG_DEMAND_ELAPSED)
	controller.clear_blackboard_key(target_key)
	controller.clear_blackboard_key(item_key)
