
/datum/ai_planning_subtree/loot
	var/scan_range = 7

/datum/ai_planning_subtree/loot/SelectBehaviors(datum/ai_controller/controller, delta_time)
	if(controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return
	if(controller.blackboard[BB_BASIC_MOB_FLEEING])
		return

	var/mob/living/pawn = controller.pawn
	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(!inv)
		return

	var/list/blacklist = controller.blackboard[BB_LOOT_BLACKLIST]

	for(var/obj/item/candidate in view(scan_range, pawn))
		if(!isturf(candidate.loc))
			continue
		if(_is_blacklisted(blacklist, candidate))
			continue
		if(!_item_is_wanted(inv, pawn, candidate))
			continue
		controller.set_blackboard_key(BB_LOOT_TARGET, candidate)
		controller.queue_behavior(/datum/ai_behavior/loot_pick_up, BB_LOOT_TARGET)
		return SUBTREE_RETURN_FINISH_PLANNING

	for(var/mob/living/corpse in orange(scan_range, pawn))
		if(corpse == pawn)
			continue
		if(corpse.stat != DEAD && corpse.body_position != LYING_DOWN)
			continue
		var/obj/item/strip_target = _find_lootable_item_on_body(inv, pawn, corpse, blacklist)
		if(!strip_target)
			continue
		controller.set_blackboard_key(BB_LOOT_TARGET, corpse)
		controller.set_blackboard_key(BB_LOOT_TARGET_ITEM, strip_target)
		controller.queue_behavior(/datum/ai_behavior/loot_strip_body, BB_LOOT_TARGET, BB_LOOT_TARGET_ITEM)
		return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/loot/proc/_is_blacklisted(list/blacklist, obj/item/candidate)
	if(!blacklist)
		return FALSE
	if(candidate in blacklist)
		return TRUE
	return FALSE

/datum/ai_planning_subtree/loot/proc/_item_is_wanted(datum/component/ai_inventory_manager/inv, mob/living/pawn, obj/item/candidate)
	if(!candidate.flags_ai_inventory)
		return FALSE
	if(istype(candidate, /obj/item/gun))
		return FALSE
	if(istype(candidate, /obj/item/weapon))
		return FALSE
	if(candidate.anchored)
		return FALSE
	if(HAS_TRAIT(candidate, TRAIT_NODROP))
		return FALSE
	return TRUE

/datum/ai_planning_subtree/loot/proc/_find_lootable_item_on_body(datum/component/ai_inventory_manager/inv, mob/living/pawn, mob/living/corpse, list/blacklist)
	for(var/obj/item/held in corpse.contents)
		if(!held)
			continue
		var/datum/component/storage/STR = held.GetComponent(/datum/component/storage)
		if(STR)
			for(var/obj/item/held_inside in held.contents)
				if(_is_blacklisted(blacklist, held_inside))
					continue
				if(!_item_is_wanted(inv, pawn, held_inside))
					continue
				if(!held_inside.canStrip(corpse))
					continue
				return held_inside
			continue
		if(_is_blacklisted(blacklist, held))
			continue
		if(!_item_is_wanted(inv, pawn, held))
			continue
		if(!held.canStrip(corpse))
			continue
		return held
	return null


/datum/ai_behavior/loot_pick_up
	action_cooldown = 0.5 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	var/loot_delay = 2 SECONDS

/datum/ai_behavior/loot_pick_up/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/obj/item/target = controller.blackboard[target_key]
	if(QDELETED(target) || !isturf(target.loc))
		return FALSE
	set_movement_target(controller, target)
	return TRUE

/datum/ai_behavior/loot_pick_up/perform(delta_time, datum/ai_controller/controller, target_key)
	var/obj/item/target = controller.blackboard[target_key]
	if(QDELETED(target) || !isturf(target.loc))
		finish_action(controller, FALSE, target_key)
		return

	var/mob/living/carbon/human/pawn = controller.pawn
	if(!pawn.Adjacent(target))
		finish_action(controller, FALSE, target_key)
		return

	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(!inv)
		finish_action(controller, FALSE, target_key)
		return

	if(QDELETED(target) || !isturf(target.loc))
		finish_action(controller, FALSE, target_key)
		return

	var/slot_flag = inv.find_space_for(target)
	if(!slot_flag)
		pawn.visible_message(span_notice("[pawn] looks at [target] but has no room for it."))
		controller.add_blackboard_key_lazylist(BB_LOOT_BLACKLIST, target)
		// Prune it after 5 minutes so the list doesn't grow forever
		addtimer(CALLBACK(controller, TYPE_PROC_REF(/datum/ai_controller, remove_thing_from_blackboard_key), BB_LOOT_BLACKLIST, target), 5 MINUTES)
		finish_action(controller, FALSE, target_key)
		return

	var/obj/item/container = inv.container_refs[slot_flag]
	var/datum/component/storage/STR = container?.GetComponent(/datum/component/storage)
	if(!STR)
		finish_action(controller, FALSE, target_key)
		return

	STR.handle_item_insertion(target, prevent_warning = TRUE, user = pawn)
	finish_action(controller, TRUE, target_key)

/datum/ai_behavior/loot_pick_up/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	controller.clear_blackboard_key(target_key)


/datum/ai_behavior/loot_strip_body
	action_cooldown = 0.5 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	var/strip_delay = 3 SECONDS

/datum/ai_behavior/loot_strip_body/setup(datum/ai_controller/controller, body_key, item_key)
	. = ..()
	var/mob/living/body = controller.blackboard[body_key]
	if(QDELETED(body))
		return FALSE
	set_movement_target(controller, body)
	return TRUE

/datum/ai_behavior/loot_strip_body/perform(delta_time, datum/ai_controller/controller, body_key, item_key)
	var/mob/living/body = controller.blackboard[body_key]
	var/obj/item/target_item = controller.blackboard[item_key]

	if(QDELETED(body) || QDELETED(target_item))
		finish_action(controller, FALSE, body_key, item_key)
		return

	if(body.stat != DEAD && body.body_position != LYING_DOWN)
		finish_action(controller, FALSE, body_key, item_key)
		return

	var/mob/living/carbon/human/pawn = controller.pawn
	if(!pawn.Adjacent(body))
		finish_action(controller, FALSE, body_key, item_key)
		return

	if(!target_item.canStrip(body))
		finish_action(controller, FALSE, body_key, item_key)
		return

	pawn.visible_message(span_notice("[pawn] searches [body]'s body."))

	if(!do_after(pawn, strip_delay, body))
		finish_action(controller, FALSE, body_key, item_key)
		return

	if(QDELETED(body) || QDELETED(target_item))
		finish_action(controller, FALSE, body_key, item_key)
		return
	if(body.stat != DEAD && body.body_position != LYING_DOWN)
		finish_action(controller, FALSE, body_key, item_key)
		return

	var/datum/component/ai_inventory_manager/inv = controller.get_inventory()
	if(!inv)
		finish_action(controller, FALSE, body_key, item_key)
		return

	var/slot_flag = inv.find_space_for(target_item)
	if(!slot_flag)
		controller.add_blackboard_key_lazylist(BB_LOOT_BLACKLIST, target_item)
		// Prune it after 5 minutes so the list doesn't grow forever
		addtimer(CALLBACK(controller, TYPE_PROC_REF(/datum/ai_controller, remove_thing_from_blackboard_key), BB_LOOT_BLACKLIST, target_item), 5 MINUTES)
		finish_action(controller, FALSE, body_key, item_key)
		return

	var/obj/item/container = inv.container_refs[slot_flag]
	var/datum/component/storage/STR = container?.GetComponent(/datum/component/storage)
	if(!STR)
		finish_action(controller, FALSE, body_key, item_key)
		return

	if(target_item.doStrip(pawn, body))
		STR.handle_item_insertion(target_item, prevent_warning = TRUE, user = pawn)
		finish_action(controller, TRUE, body_key, item_key)
	else
		controller.add_blackboard_key_lazylist(BB_LOOT_BLACKLIST, target_item)
		// Prune it after 5 minutes so the list doesn't grow forever
		addtimer(CALLBACK(controller, TYPE_PROC_REF(/datum/ai_controller, remove_thing_from_blackboard_key), BB_LOOT_BLACKLIST, target_item), 5 MINUTES)
		finish_action(controller, FALSE, body_key, item_key)

/datum/ai_behavior/loot_strip_body/finish_action(datum/ai_controller/controller, succeeded, body_key, item_key)
	. = ..()
	controller.clear_blackboard_key(body_key)
	controller.clear_blackboard_key(item_key)
