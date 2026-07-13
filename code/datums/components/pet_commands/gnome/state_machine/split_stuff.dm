
#define GNOME_SPLITTER_NEED_THRESHOLD 100

/datum/action_state/splitter
	name = "splitter"
	description = "Processing items in splitter"
	var/current_task = "finding_item"
	priority_eval_interval = 2 SECONDS

/datum/action_state/splitter/evaluate_priority(datum/ai_controller/controller)
	if(controller.blackboard[BB_GNOME_EXTRACTOR_MODE])
		var/obj/machinery/essence/extractor/target_extractor = controller.blackboard[BB_GNOME_TARGET_EXTRACTOR]
		if(!target_extractor || QDELETED(target_extractor))
			return GNOME_PRIORITY_NONE
		if(target_extractor.processing || target_extractor.current_item)
			return GNOME_PRIORITY_NONE
		for(var/obj/item/candidate in find_all_splitter_items(controller))
			if(get_precursor_data(candidate))
				return GNOME_PRIORITY_NORMAL
		return GNOME_PRIORITY_NONE

	if(!controller.blackboard[BB_GNOME_SPLITTER_MODE])
		return GNOME_PRIORITY_NONE

	var/obj/machinery/essence/splitter/target_splitter = controller.blackboard[BB_GNOME_TARGET_SPLITTER]
	if(!target_splitter || QDELETED(target_splitter))
		return GNOME_PRIORITY_NONE

	// Splitter is full  nothing to do right now.
	if(target_splitter.current_items.len >= target_splitter.max_items)
		return GNOME_PRIORITY_NONE

	// Build the set of essence types the network currently needs.
	var/list/needed_types = get_network_needed_types(target_splitter)
	var/network_starved = is_network_starved(target_splitter, needed_types)

	// Scan for candidate items.
	var/found_priority = GNOME_PRIORITY_NONE
	for(var/obj/item/candidate in find_all_splitter_items(controller))
		var/datum/natural_precursor/precursor = get_precursor_data(candidate)
		if(!precursor)
			continue

		// Check if any of this precursor's output types are needed.
		var/network_match = FALSE
		for(var/etype in precursor.essence_yields)
			if(etype in needed_types)
				network_match = TRUE
				break

		if(network_match && network_starved)
			return GNOME_PRIORITY_CRITICAL  // Urgent: network is empty for a needed type
		else if(network_match)
			found_priority = GNOME_PRIORITY_HIGH
		else if(found_priority == GNOME_PRIORITY_NONE)
			found_priority = GNOME_PRIORITY_NORMAL

	return found_priority

/**
 * Returns a list of essence types that at least one machine in the network
 * currently accepts and is below GNOME_SPLITTER_NEED_THRESHOLD.
 * Returns an empty list if the splitter has no network.
 */
/datum/action_state/splitter/proc/get_network_needed_types(obj/machinery/essence/splitter/splitter)
	var/datum/essence_network/net = splitter.network
	if(!net)
		return list()

	var/list/needed = list()
	for(var/obj/machinery/essence/machine in net.machines)
		if(machine == splitter || !machine.accepts_input)
			continue
		var/list/allowed = net.get_allowed_types(machine)
		for(var/etype in allowed)
			var/have = machine.storage ? machine.storage.get(etype) : 0
			if(have < GNOME_SPLITTER_NEED_THRESHOLD)
				needed[etype] = TRUE
	return needed

/**
 * Returns TRUE if any consumer in the network is completely out of an
 * essence type it accepts  i.e. the network is truly starved, not just low.
 */
/datum/action_state/splitter/proc/is_network_starved(obj/machinery/essence/splitter/splitter, list/needed_types)
	var/datum/essence_network/net = splitter.network
	if(!net || !needed_types.len)
		return FALSE

	for(var/obj/machinery/essence/machine in net.machines)
		if(machine == splitter || !machine.accepts_input)
			continue
		var/list/allowed = net.get_allowed_types(machine)
		for(var/etype in allowed)
			if(!(etype in needed_types))
				continue
			var/have = machine.storage ? machine.storage.get(etype) : 0
			if(have <= 0)
				return TRUE
	return FALSE

/datum/action_state/splitter/enter_state(datum/ai_controller/controller)
	current_task = "finding_item"

/datum/action_state/splitter/process_state(datum/ai_controller/controller, delta_time)
	var/extractor_mode = controller.blackboard[BB_GNOME_EXTRACTOR_MODE]
	var/splitter_mode = controller.blackboard[BB_GNOME_SPLITTER_MODE]

	if(!extractor_mode && !splitter_mode)
		return ACTION_STATE_COMPLETE

	var/mob/living/pawn = controller.pawn

	// Extractor path
	if(extractor_mode)
		var/obj/machinery/essence/extractor/target_extractor = controller.blackboard[BB_GNOME_TARGET_EXTRACTOR]
		if(!target_extractor || QDELETED(target_extractor))
			return ACTION_STATE_FAILED

		// Wait while it's busy
		if(target_extractor.processing || target_extractor.current_item)
			return ACTION_STATE_CONTINUE

		switch(current_task)
			if("finding_item")
				var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
				if(carried)
					current_task = "delivering"
					manager.set_movement_target(controller, target_extractor)
					return ACTION_STATE_CONTINUE

				var/obj/item/found_item = find_best_splitter_item(controller, target_extractor)
				if(!found_item)
					return ACTION_STATE_COMPLETE

				controller.set_blackboard_key(BB_GNOME_FOUND_ITEM, found_item)
				manager.set_movement_target(controller, found_item)
				current_task = "picking_up"
				return ACTION_STATE_CONTINUE

			if("picking_up")
				var/obj/item/found_item = controller.blackboard[BB_GNOME_FOUND_ITEM]
				if(!found_item)
					current_task = "finding_item"
					return ACTION_STATE_CONTINUE

				if(get_dist(pawn, found_item) > 1)
					manager.set_movement_target(controller, found_item)
					return ACTION_STATE_CONTINUE

				if(found_item.forceMove(pawn))
					controller.set_blackboard_key(BB_SIMPLE_CARRY_ITEM, found_item)
					controller.clear_blackboard_key(BB_GNOME_FOUND_ITEM)
					pawn.visible_message(span_notice("[pawn] picks up [found_item]."))
					current_task = "delivering"
				else
					current_task = "finding_item"
				return ACTION_STATE_CONTINUE

			if("delivering")
				var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
				if(!carried)
					current_task = "finding_item"
					return ACTION_STATE_CONTINUE

				if(get_dist(pawn, target_extractor) > 1)
					manager.set_movement_target(controller, target_extractor)
					return ACTION_STATE_CONTINUE

				var/datum/natural_precursor/precursor = get_precursor_data(carried)
				if(!precursor)
					pawn.dropItemToGround(carried)
					controller.clear_blackboard_key(BB_SIMPLE_CARRY_ITEM)
					current_task = "finding_item"
					return ACTION_STATE_CONTINUE

				if(carried.forceMove(target_extractor))
					target_extractor.current_item = carried
					controller.clear_blackboard_key(BB_SIMPLE_CARRY_ITEM)
					pawn.visible_message(span_notice("[pawn] carefully loads [carried] into the extractor."))
					target_extractor.begin_extraction(pawn)

				current_task = "finding_item"
				return ACTION_STATE_CONTINUE

		return ACTION_STATE_CONTINUE

	var/obj/machinery/essence/splitter/target_splitter = controller.blackboard[BB_GNOME_TARGET_SPLITTER]
	if(!target_splitter || QDELETED(target_splitter))
		return ACTION_STATE_FAILED

	switch(current_task)
		if("finding_item")
			var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
			if(carried)
				current_task = "delivering"
				manager.set_movement_target(controller, target_splitter)
				return ACTION_STATE_CONTINUE

			var/obj/item/found_item = find_best_splitter_item(controller, target_splitter)
			if(!found_item)
				return ACTION_STATE_COMPLETE  // Nothing to feed right now.

			controller.set_blackboard_key(BB_GNOME_FOUND_ITEM, found_item)
			manager.set_movement_target(controller, found_item)
			current_task = "picking_up"
			return ACTION_STATE_CONTINUE

		if("picking_up")
			var/obj/item/found_item = controller.blackboard[BB_GNOME_FOUND_ITEM]
			if(!found_item)
				current_task = "finding_item"
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, found_item) > 1)
				manager.set_movement_target(controller, found_item)
				return ACTION_STATE_CONTINUE

			if(found_item.forceMove(pawn))
				controller.set_blackboard_key(BB_SIMPLE_CARRY_ITEM, found_item)
				controller.clear_blackboard_key(BB_GNOME_FOUND_ITEM)
				pawn.visible_message(span_notice("[pawn] picks up [found_item]."))
				current_task = "delivering"
			else
				current_task = "finding_item"
			return ACTION_STATE_CONTINUE

		if("delivering")
			var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
			if(!carried)
				current_task = "finding_item"
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, target_splitter) > 1)
				manager.set_movement_target(controller, target_splitter)
				return ACTION_STATE_CONTINUE

			if(target_splitter.processing)
				return ACTION_STATE_CONTINUE

			if(target_splitter.current_items.len >= target_splitter.max_items)
				return ACTION_STATE_CONTINUE

			var/datum/natural_precursor/precursor = get_precursor_data(carried)
			if(!precursor)
				pawn.dropItemToGround(carried)
				controller.clear_blackboard_key(BB_SIMPLE_CARRY_ITEM)
				current_task = "finding_item"
				return ACTION_STATE_CONTINUE

			if(carried.forceMove(target_splitter))
				target_splitter.current_items += carried
				controller.clear_blackboard_key(BB_SIMPLE_CARRY_ITEM)
				pawn.visible_message(span_notice("[pawn] carefully places [carried] into the splitter."))
				if(target_splitter.current_items.len >= target_splitter.max_items)
					target_splitter.begin_bulk_splitting(pawn)
			current_task = "finding_item"
			return ACTION_STATE_CONTINUE

	return ACTION_STATE_CONTINUE

/**
 * Returns all valid candidate items near the source waypoint, regardless of
 * network fitness.  Used by evaluate_priority() and find_best_splitter_item().
 */
/datum/action_state/splitter/proc/find_all_splitter_items(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/gnome_homunculus/gnome = controller.pawn
	var/turf/start = controller.blackboard[BB_GNOME_SPLITTER_SOURCE]
	var/range = controller.blackboard[BB_GNOME_SEARCH_RANGE] || 1
	var/list/results = list()

	if(!start)
		return results

	for(var/turf/open/source in view(range, start))
		for(var/obj/item/I in source.contents)
			if(I.anchored)
				continue
			if(I.w_class > gnome.max_carry_size)
				continue
			if(!gnome.item_matches_filter(I))
				continue
			if(!get_precursor_data(I))
				continue
			results += I
	return results

/**
 * Among all valid candidates, return the one that best serves the network:
 *   1. Items whose output types are network-needed and network is starved.
 *   2. Items whose output types are network-needed (low but not empty).
 *   3. Any item that can be split (no network preference).
 * Within each tier, the first match is returned (closest by iteration order).
 */
/datum/action_state/splitter/proc/find_best_splitter_item(datum/ai_controller/controller, obj/machinery/essence/splitter/splitter)
	var/list/candidates = find_all_splitter_items(controller)
	if(!candidates.len)
		return null

	var/list/needed_types = get_network_needed_types(splitter)
	var/network_starved = is_network_starved(splitter, needed_types)

	// Tier 1  network-critical match
	if(network_starved && needed_types.len)
		for(var/obj/item/I in candidates)
			var/datum/natural_precursor/precursor = get_precursor_data(I)
			for(var/etype in precursor.essence_yields)
				if(etype in needed_types)
					return I

	// Tier 2  network-preferred match
	if(needed_types.len)
		for(var/obj/item/I in candidates)
			var/datum/natural_precursor/precursor = get_precursor_data(I)
			for(var/etype in precursor.essence_yields)
				if(etype in needed_types)
					return I

	// Tier 3  anything splittable
	return candidates.len ? candidates[1] : null

#undef GNOME_SPLITTER_NEED_THRESHOLD
