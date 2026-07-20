
/datum/action_state/transport
	name = "transport"
	description = "Moving items between waypoints"
	var/current_task = "finding_item"
	var/moving_to_target = FALSE
	priority_eval_interval = 2 SECONDS

/datum/action_state/transport/evaluate_priority(datum/ai_controller/controller)
	var/turf/source = controller.blackboard[BB_GNOME_TRANSPORT_SOURCE]
	var/turf/dest   = controller.blackboard[BB_GNOME_TRANSPORT_DEST]

	if(!source || !dest)
		return GNOME_PRIORITY_NONE

	// Already carrying something, finish the delivery.
	if(controller.blackboard[BB_SIMPLE_CARRY_ITEM])
		return GNOME_PRIORITY_HIGH

	// Check if anything is actually waiting at the source.
	if(find_transport_item(controller))
		return GNOME_PRIORITY_NORMAL

	return GNOME_PRIORITY_NONE

/datum/action_state/transport/enter_state(datum/ai_controller/controller)
	current_task = "finding_item"
	moving_to_target = FALSE

/datum/action_state/transport/exit_state(datum/ai_controller/controller)
	moving_to_target = FALSE

/datum/action_state/transport/process_state(datum/ai_controller/controller, delta_time)
	var/mob/living/pawn = controller.pawn

	switch(current_task)
		if("finding_item")
			var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
			if(carried)
				current_task = "delivering"
				var/turf/dest = controller.blackboard[BB_GNOME_TRANSPORT_DEST]
				if(dest)
					manager.set_movement_target(controller, dest)
				return ACTION_STATE_CONTINUE

			var/obj/item/found_item = find_transport_item(controller)
			if(!found_item)
				// Nothing left to move, we're done.
				return ACTION_STATE_COMPLETE

			controller.set_blackboard_key(BB_GNOME_FOUND_ITEM, found_item)
			manager.set_movement_target(controller, found_item)
			current_task = "picking_up"
			return ACTION_STATE_CONTINUE

		if("picking_up")
			var/obj/item/found_item = controller.blackboard[BB_GNOME_FOUND_ITEM]
			if(!found_item)
				current_task = "finding_item"
				moving_to_target = FALSE
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, found_item) > 1)
				if(!moving_to_target)
					manager.set_movement_target(controller, found_item)
					moving_to_target = TRUE
				return ACTION_STATE_CONTINUE

			if(found_item.forceMove(pawn))
				controller.set_blackboard_key(BB_SIMPLE_CARRY_ITEM, found_item)
				controller.clear_blackboard_key(BB_GNOME_FOUND_ITEM)
				pawn.visible_message(span_notice("[pawn] picks up [found_item]."))
				current_task = "delivering"
				moving_to_target = FALSE
				var/turf/dest = controller.blackboard[BB_GNOME_TRANSPORT_DEST]
				if(dest)
					manager.set_movement_target(controller, dest)
			else
				current_task = "finding_item"
				moving_to_target = FALSE
			return ACTION_STATE_CONTINUE

		if("delivering")
			var/turf/dest = controller.blackboard[BB_GNOME_TRANSPORT_DEST]
			if(!dest)
				return ACTION_STATE_FAILED

			if(get_dist(pawn, dest) > 1)
				if(!moving_to_target)
					manager.set_movement_target(controller, dest)
					moving_to_target = TRUE
				return ACTION_STATE_CONTINUE

			current_task = "dropping"
			moving_to_target = FALSE
			return ACTION_STATE_CONTINUE

		if("dropping")
			var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
			var/turf/dest = controller.blackboard[BB_GNOME_TRANSPORT_DEST]
			if(!carried)
				current_task = "finding_item"
				return ACTION_STATE_CONTINUE

			pawn.dropItemToGround(carried)
			carried.forceMove(dest)
			controller.clear_blackboard_key(BB_SIMPLE_CARRY_ITEM)
			pawn.visible_message(span_notice("[pawn] carefully sets down [carried]."))
			current_task = "finding_item"
			moving_to_target = FALSE
			return ACTION_STATE_CONTINUE

	return ACTION_STATE_CONTINUE

/datum/action_state/transport/proc/find_transport_item(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/gnome_homunculus/gnome = controller.pawn
	var/turf/source = controller.blackboard[BB_GNOME_TRANSPORT_SOURCE]
	var/range = controller.blackboard[BB_GNOME_SEARCH_RANGE] || 1

	if(!source)
		return null

	for(var/turf/check_turf in view(range, source))
		for(var/obj/item/I in check_turf.contents)
			if(I.anchored)
				continue
			if(I.w_class > gnome.max_carry_size)
				continue
			if(!gnome.item_matches_filter(I))
				continue
			return I
	return null
