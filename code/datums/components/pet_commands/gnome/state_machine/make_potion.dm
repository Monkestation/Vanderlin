#define ALCHEMY_WATER_MIN       50
#define ALCHEMY_BREW_DONE       21
#define ALCHEMY_OVERFLOW_VOL    10

/datum/action_state/alchemy
	name = "alchemy"
	description = "Automated alchemy brewing"
	var/current_phase = "check_cauldron"
	priority_eval_interval = 2 SECONDS

/datum/action_state/alchemy/evaluate_priority(datum/ai_controller/controller)
	if(!controller.blackboard[BB_GNOME_ALCHEMY_MODE])
		return GNOME_PRIORITY_NONE

	var/obj/machinery/light/fueled/cauldron/cauldron = controller.blackboard[BB_GNOME_TARGET_CAULDRON]
	var/obj/structure/well/well = controller.blackboard[BB_GNOME_TARGET_WELL]

	if(!cauldron || !well)
		return GNOME_PRIORITY_NONE

	// Cauldron finished brewing and has a lot of reagents overflowing risk.
	if(cauldron.brewing >= ALCHEMY_BREW_DONE && cauldron.reagents.total_volume > ALCHEMY_OVERFLOW_VOL)
		var/obj/item/bottle = find_suitable_bottle(controller)
		if(!bottle)
			return GNOME_PRIORITY_CRITICAL  // Done brewing but can't bottle urgent.
		return GNOME_PRIORITY_HIGH          // Done brewing, bottle ready.

	// Cauldron needs water to begin.
	if(cauldron.brewing == 0 && cauldron.reagents.get_reagent_amount(/datum/reagent/water) < ALCHEMY_WATER_MIN)
		return GNOME_PRIORITY_HIGH

	// Otherwise just monitor periodically.
	return GNOME_PRIORITY_NORMAL

// ---------------------------------------------------------------------------
// Processing
// ---------------------------------------------------------------------------

/datum/action_state/alchemy/process_state(datum/ai_controller/controller, delta_time)
	if(!controller.blackboard[BB_GNOME_ALCHEMY_MODE])
		return ACTION_STATE_COMPLETE

	var/mob/living/pawn = controller.pawn
	var/obj/machinery/light/fueled/cauldron/cauldron = controller.blackboard[BB_GNOME_TARGET_CAULDRON]
	var/obj/structure/well/well = controller.blackboard[BB_GNOME_TARGET_WELL]

	if(!cauldron || !well)
		return ACTION_STATE_FAILED

	switch(current_phase)
		if("check_cauldron")
			if(cauldron.brewing == 0 && cauldron.reagents.get_reagent_amount(/datum/reagent/water) < ALCHEMY_WATER_MIN)
				current_phase = "need_water"
			else if(cauldron.brewing >= ALCHEMY_BREW_DONE && cauldron.reagents.total_volume > 0)
				current_phase = "need_bottles"
			else
				current_phase = "idle"
			return ACTION_STATE_CONTINUE

		if("need_water")
			var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
			if(!carried || !is_water_container(carried))
				var/obj/item/water_container = find_water_container_nearby(controller)
				if(water_container)
					manager.set_movement_target(controller, water_container)
					current_phase = "getting_water_container"
				else
					current_phase = "check_cauldron"
			else
				manager.set_movement_target(controller, well)
				current_phase = "filling_water"
			return ACTION_STATE_CONTINUE

		if("getting_water_container")
			var/obj/item/water_container = find_water_container_nearby(controller)
			if(!water_container)
				current_phase = "check_cauldron"
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, water_container) > 1)
				return ACTION_STATE_CONTINUE

			if(water_container.forceMove(pawn))
				controller.set_blackboard_key(BB_SIMPLE_CARRY_ITEM, water_container)
				pawn.visible_message(span_notice("[pawn] picks up [water_container]."))
				current_phase = "filling_water"
				manager.set_movement_target(controller, well)

			return ACTION_STATE_CONTINUE

		if("filling_water")
			var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
			if(!carried || !is_water_container(carried))
				current_phase = "need_water"
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, well) > 1)
				return ACTION_STATE_CONTINUE

			carried.reagents?.add_reagent(/datum/reagent/water, ALCHEMY_WATER_MIN)
			pawn.visible_message(span_notice("[pawn] fills [carried] with water."))
			current_phase = "adding_water"
			manager.set_movement_target(controller, cauldron)
			return ACTION_STATE_CONTINUE

		if("adding_water")
			var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
			if(!carried || !is_water_container(carried))
				current_phase = "need_water"
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, cauldron) > 1)
				return ACTION_STATE_CONTINUE

			carried.reagents.trans_to(cauldron, ALCHEMY_WATER_MIN)
			pawn.visible_message(span_notice("[pawn] pours water into [cauldron]."))
			pawn.dropItemToGround(carried)
			controller.clear_blackboard_key(BB_SIMPLE_CARRY_ITEM)
			current_phase = "check_cauldron"
			return ACTION_STATE_CONTINUE

		if("need_bottles")
			var/obj/item/bottle = find_suitable_bottle(controller)
			if(!bottle)
				current_phase = "idle"
				return ACTION_STATE_CONTINUE

			manager.set_movement_target(controller, bottle)
			current_phase = "getting_bottle"
			return ACTION_STATE_CONTINUE

		if("getting_bottle")
			var/obj/item/bottle = find_suitable_bottle(controller)
			if(!bottle)
				current_phase = "need_bottles"
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, bottle) > 1)
				return ACTION_STATE_CONTINUE

			if(bottle.forceMove(pawn))
				controller.set_blackboard_key(BB_SIMPLE_CARRY_ITEM, bottle)
				pawn.visible_message(span_notice("[pawn] picks up [bottle]."))
				current_phase = "bottling"
				manager.set_movement_target(controller, cauldron)

			return ACTION_STATE_CONTINUE

		if("bottling")
			var/obj/item/bottle = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
			if(!bottle || !bottle.reagents)
				current_phase = "need_bottles"
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, cauldron) > 1)
				return ACTION_STATE_CONTINUE

			cauldron.reagents.trans_to(bottle, bottle.reagents.maximum_volume - bottle.reagents.total_volume)
			pawn.visible_message(span_notice("[pawn] fills [bottle] with the finished potion."))

			var/turf/bottle_storage = controller.blackboard[BB_GNOME_BOTTLE_STORAGE]
			if(bottle_storage)
				bottle.forceMove(bottle_storage)
				pawn.visible_message(span_notice("[pawn] stores the finished potion."))
			else
				pawn.dropItemToGround(bottle)

			controller.clear_blackboard_key(BB_SIMPLE_CARRY_ITEM)

			if(cauldron.reagents && cauldron.reagents.total_volume > ALCHEMY_OVERFLOW_VOL)
				current_phase = "need_bottles"
			else
				current_phase = "check_cauldron"

			return ACTION_STATE_CONTINUE

		if("idle")
			if(get_dist(pawn, cauldron) > 2)
				manager.set_movement_target(controller, cauldron)

			// Periodically re-check so we catch brew completions.
			if(prob(20))
				current_phase = "check_cauldron"

			return ACTION_STATE_CONTINUE

	return ACTION_STATE_CONTINUE

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/datum/action_state/alchemy/proc/is_water_container(obj/item/I)
	return (istype(I, /obj/item/reagent_containers) && I.reagents)

/datum/action_state/alchemy/proc/find_water_container_nearby(datum/ai_controller/controller)
	var/mob/living/pawn = controller.pawn
	var/obj/structure/well/well = controller.blackboard[BB_GNOME_TARGET_WELL]

	for(var/obj/item/reagent_containers/I in range(3, well))
		if(I.reagents && I.reagents.total_volume == 0)
			return I

	for(var/obj/item/reagent_containers/I in range(5, pawn))
		if(I.reagents && I.reagents.total_volume == 0)
			return I

	return null

/datum/action_state/alchemy/proc/find_suitable_bottle(datum/ai_controller/controller)
	var/mob/living/pawn = controller.pawn
	var/turf/bottle_storage = controller.blackboard[BB_GNOME_BOTTLE_STORAGE]
	var/obj/machinery/light/fueled/cauldron/cauldron = controller.blackboard[BB_GNOME_TARGET_CAULDRON]

	var/list/search_areas = list()
	if(bottle_storage)
		search_areas += bottle_storage
	if(cauldron)
		search_areas += get_turf(cauldron)

	for(var/turf/area in search_areas)
		for(var/obj/item/reagent_containers/I in range(3, area))
			if(I.reagents && I.reagents.total_volume == 0)
				return I

	// Fallback: look near any essence machinery in range.
	for(var/obj/machinery/essence/machinery in view(15, pawn))
		for(var/obj/item/reagent_containers/I in range(3, machinery))
			if(I.reagents && I.reagents.total_volume == 0)
				return I

	return null

#undef ALCHEMY_WATER_MIN
#undef ALCHEMY_BREW_DONE
#undef ALCHEMY_OVERFLOW_VOL
