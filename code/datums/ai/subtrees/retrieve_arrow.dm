/datum/ai_planning_subtree/retrieve_arrows
	parent_type = /datum/ai_planning_subtree/archer_base

/datum/ai_planning_subtree/retrieve_arrows/SelectBehaviors(datum/ai_controller/controller, delta_time)
	if(!validate_archer_equipment(controller))
		return
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/bow = controller.blackboard[BB_ARCHER_NPC_BOW]
	var/obj/item/ammo_holder/quiver/Q = controller.blackboard[BB_ARCHER_NPC_QUIVER]

	if(bow.chambered)
		return
	if(Q.ammo_list.len >= Q.max_storage)
		return
	if(!controller.blackboard[BB_ARCHER_NPC_TARGET_ARROW])
		var/obj/item/arrow = _find_nearby_arrow(get_turf(controller.pawn), Q)
		if(!arrow)
			return
		controller.set_blackboard_key(BB_ARCHER_NPC_TARGET_ARROW, arrow)

	controller.queue_behavior(/datum/ai_behavior/retrieve_arrow, BB_ARCHER_NPC_TARGET_ARROW)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_planning_subtree/retrieve_arrows/proc/_find_nearby_arrow(mob/living/carbon/human/pawn, obj/item/ammo_holder/quiver/Q)
	var/turf/pawn_turf = get_turf(pawn)
	for(var/obj/item/ammo_casing/arrow in range(ARCHER_NPC_ARROW_SEARCH_RANGE, pawn_turf))
		for(var/accepted in Q.ammo_type)
			if(istype(arrow, accepted))
				return arrow
	return null


/datum/ai_behavior/retrieve_arrow
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	action_cooldown = 0.5 SECONDS

/datum/ai_behavior/retrieve_arrow/setup(datum/ai_controller/controller, arrow_key)
	. = ..()
	if(!.)
		return FALSE
	var/obj/item/arrow = controller.blackboard[arrow_key]
	if(!arrow || QDELETED(arrow))
		controller.clear_blackboard_key(arrow_key)
		return FALSE
	controller.current_movement_target = arrow
	return TRUE

/datum/ai_behavior/retrieve_arrow/perform(delta_time, datum/ai_controller/controller, arrow_key)
	var/mob/living/carbon/human/pawn = controller.pawn
	var/obj/item/ammo_casing/arrow = controller.blackboard[arrow_key]

	if(!arrow || QDELETED(arrow))
		finish_action(controller, FALSE, arrow_key)
		return

	if(!pawn.CanReach(arrow))
		finish_action(controller, FALSE, arrow_key)
		return

	// Find the quiver again at perform time in case equipment changed
	var/obj/item/ammo_holder/quiver/Q = null
	for(var/obj/item/ammo_holder/quiver/worn in pawn.get_equipped_items())
		for(var/accepted in worn.ammo_type)
			if(istype(arrow, accepted))
				Q = worn
				break
		if(Q)
			break

	if(!Q || Q.ammo_list.len >= Q.max_storage)
		finish_action(controller, FALSE, arrow_key)
		return

	// Pick up the arrow and store directly into quiver
	// Mirrors ammo_holder/attackby logic but without needing a mob intermediary since we want this to just work
	arrow.forceMove(Q)
	Q.ammo_list += arrow
	Q.update_appearance(UPDATE_ICON_STATE)

	finish_action(controller, TRUE, arrow_key)

/datum/ai_behavior/retrieve_arrow/finish_action(datum/ai_controller/controller, succeeded, arrow_key)
	. = ..()
	controller.clear_blackboard_key(arrow_key)
