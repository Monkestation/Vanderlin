/datum/action_state/farming
	name = "farming"
	description = "Tending to crops"
	var/current_task = "scanning"
	var/current_target = null
	var/stuck_ticks = 0
	var/max_stuck_ticks = 10
	priority_eval_interval = 3 SECONDS

/datum/action_state/farming/evaluate_priority(datum/ai_controller/controller)
	if(!controller.blackboard[BB_GNOME_CROP_MODE])
		return GNOME_PRIORITY_NONE

	if(controller.blackboard[BB_FARMING_TARGET_WELL])
		return GNOME_PRIORITY_HIGH

	var/mob/living/pawn = controller.pawn
	var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
	var/found_actionable = FALSE

	for(var/obj/structure/soil/soil in oview(7, pawn))
		// Harvest ready, always HIGH
		if(soil.produce_ready)
			return GNOME_PRIORITY_HIGH

		// Weeds to pull, always actionable, no item needed
		if(soil.plant && soil.weeds > 25)
			found_actionable = TRUE
			continue

		// Thirsty plant, actionable if we have water, a pre-filled source, or a well + empty container
		if(soil.plant && !soil.plant_dead && soil.water < 150 * 0.3)
			if(carried && is_water_container(carried))
				found_actionable = TRUE
			else if(find_water_source_nearby(controller))
				found_actionable = TRUE
			else if(find_well_nearby(controller) && find_empty_container_nearby(controller))
				found_actionable = TRUE
			continue

		// Empty soil, only actionable if we have seeds OR can find some nearby
		if(!soil.plant)
			if(carried && istype(carried, /obj/item/neuFarm/seed))
				found_actionable = TRUE
			else if(find_seed_source_nearby(controller))
				found_actionable = TRUE
			continue

	return found_actionable ? GNOME_PRIORITY_NORMAL : GNOME_PRIORITY_NONE

/datum/action_state/farming/enter_state(datum/ai_controller/controller)
	current_task = "scanning"
	current_target = null
	stuck_ticks = 0

/datum/action_state/farming/process_state(datum/ai_controller/controller, delta_time)
	if(!controller.blackboard[BB_GNOME_CROP_MODE])
		return ACTION_STATE_COMPLETE

	var/mob/living/pawn = controller.pawn

	switch(current_task)
		if("scanning")
			stuck_ticks = 0

			// Priority 1: Harvest ready crops
			if(!istype(pawn, /mob/living/simple_animal/hostile/retaliate/fae/agriopylon))
				for(var/obj/structure/soil/soil in oview(7, pawn))
					if(soil.produce_ready)
						current_target = soil
						manager.set_movement_target(controller, soil)
						current_task = "harvesting"
						return ACTION_STATE_CONTINUE

			// Priority 2: Remove weeds
			for(var/obj/structure/soil/soil in oview(7, pawn))
				if(soil.plant && soil.weeds > 25)
					current_target = soil
					manager.set_movement_target(controller, soil)
					current_task = "deweeding"
					return ACTION_STATE_CONTINUE

			// Priority 3: Water thirsty plants
			var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
			if(carried && is_water_container(carried))
				for(var/obj/structure/soil/soil in oview(7, pawn))
					if(soil.plant && !soil.plant_dead && soil.water < 150 * 0.3)
						current_target = soil
						manager.set_movement_target(controller, soil)
						current_task = "watering"
						return ACTION_STATE_CONTINUE
			else
				for(var/obj/structure/soil/soil in oview(7, pawn))
					if(soil.plant && !soil.plant_dead && soil.water < 150 * 0.3)
						// Try a pre-filled source first
						var/obj/item/water_source = find_water_source_nearby(controller)
						if(water_source)
							current_target = water_source
							manager.set_movement_target(controller, water_source)
							current_task = "getting_water"
							return ACTION_STATE_CONTINUE
						// Fall back to fetching an empty container and filling at a well
						var/obj/structure/well/well = find_well_nearby(controller)
						var/obj/item/empty = find_empty_container_nearby(controller)
						if(well && empty)
							controller.set_blackboard_key(BB_FARMING_TARGET_WELL, well)
							current_target = empty
							manager.set_movement_target(controller, empty)
							current_task = "getting_empty_container"
							return ACTION_STATE_CONTINUE

			// Priority 4: Plant seeds in empty soil
			if(carried && istype(carried, /obj/item/neuFarm/seed))
				for(var/obj/structure/soil/soil in oview(7, pawn))
					if(!soil.plant)
						current_target = soil
						manager.set_movement_target(controller, soil)
						current_task = "planting"
						return ACTION_STATE_CONTINUE
			else
				for(var/obj/structure/soil/soil in oview(7, pawn))
					if(!soil.plant)
						var/obj/structure/closet/seed_source = find_seed_source_nearby(controller)
						if(seed_source)
							current_target = seed_source
							manager.set_movement_target(controller, seed_source)
							current_task = "getting_seeds"
							return ACTION_STATE_CONTINUE

			return ACTION_STATE_CONTINUE

		if("harvesting")
			var/obj/structure/soil/soil = current_target
			if(!soil || !soil.produce_ready)
				current_task = "scanning"
				stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, soil) > 1)
				stuck_ticks++
				if(stuck_ticks >= max_stuck_ticks)
					current_task = "scanning"
					stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			stuck_ticks = 0
			soil.user_harvests(pawn)
			pawn.visible_message(span_notice("[pawn] harvests [soil]."))
			playsound(soil, 'sound/items/seed.ogg', 100, FALSE)
			current_target = null
			manager.clear_movement_target(controller)
			current_task = "scanning"
			return ACTION_STATE_CONTINUE

		if("deweeding")
			var/obj/structure/soil/soil = current_target
			if(!soil || soil.weeds <= 0)
				current_task = "scanning"
				stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, soil) > 1)
				stuck_ticks++
				if(stuck_ticks >= max_stuck_ticks)
					current_task = "scanning"
					stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			stuck_ticks = 0
			soil.weeds = max(0, soil.weeds - 25)
			pawn.visible_message(span_notice("[pawn] carefully removes weeds from [soil]."))
			playsound(soil, pick('sound/foley/touch1.ogg','sound/foley/touch2.ogg','sound/foley/touch3.ogg'), 100, TRUE)
			current_task = "scanning"
			return ACTION_STATE_CONTINUE

		if("getting_water")
			var/obj/item/water_source = current_target
			if(!water_source)
				current_task = "scanning"
				stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, water_source) > 1)
				stuck_ticks++
				if(stuck_ticks >= max_stuck_ticks)
					current_task = "scanning"
					stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			stuck_ticks = 0
			if(water_source.forceMove(pawn))
				controller.set_blackboard_key(BB_SIMPLE_CARRY_ITEM, water_source)
				pawn.visible_message(span_notice("[pawn] picks up [water_source] for watering."))

			current_task = "scanning"
			return ACTION_STATE_CONTINUE

		if("getting_empty_container")
			var/obj/item/container = current_target
			if(!container)
				current_task = "scanning"
				stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, container) > 1)
				stuck_ticks++
				if(stuck_ticks >= max_stuck_ticks)
					current_task = "scanning"
					stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			stuck_ticks = 0
			if(container.forceMove(pawn))
				controller.set_blackboard_key(BB_SIMPLE_CARRY_ITEM, container)
				pawn.visible_message(span_notice("[pawn] picks up [container] to fetch water."))
				var/obj/structure/well/well = controller.blackboard[BB_FARMING_TARGET_WELL]
				current_target = well
				manager.set_movement_target(controller, well)
				current_task = "filling_at_well"
			else
				current_task = "scanning"
			return ACTION_STATE_CONTINUE

		if("filling_at_well")
			var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
			var/obj/structure/well/well = controller.blackboard[BB_FARMING_TARGET_WELL]

			if(!carried || !well)
				current_task = "scanning"
				stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, well) > 1)
				stuck_ticks++
				if(stuck_ticks >= max_stuck_ticks)
					current_task = "scanning"
					stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			stuck_ticks = 0
			carried.reagents?.add_reagent(/datum/reagent/water, 150)
			pawn.visible_message(span_notice("[pawn] fills [carried] with water from [well]."))
			controller.clear_blackboard_key(BB_FARMING_TARGET_WELL)
			// Return to scanning, it will immediately find the carried water and water a plant
			current_task = "scanning"
			return ACTION_STATE_CONTINUE

		if("watering")
			var/obj/structure/soil/soil = current_target
			var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]

			if(!soil || !carried || !is_water_container(carried))
				current_task = "scanning"
				stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, soil) > 1)
				stuck_ticks++
				if(stuck_ticks >= max_stuck_ticks)
					current_task = "scanning"
					stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			stuck_ticks = 0
			if(carried.reagents && carried.reagents.has_reagent(/datum/reagent/water, 15))
				soil.adjust_water(150)
				pawn.visible_message(span_notice("[pawn] waters [soil]."))
				var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
				playsound(pawn, pick(wash), 100, FALSE)
				pawn.dropItemToGround(carried)
				controller.clear_blackboard_key(BB_SIMPLE_CARRY_ITEM)

			current_task = "scanning"
			return ACTION_STATE_CONTINUE

		if("getting_seeds")
			var/obj/structure/closet/seed_source = current_target
			if(!seed_source)
				current_task = "scanning"
				stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, seed_source) > 1)
				stuck_ticks++
				if(stuck_ticks >= max_stuck_ticks)
					current_task = "scanning"
					stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			stuck_ticks = 0
			var/obj/item/neuFarm/seed/found_seed = null
			for(var/obj/item/neuFarm/seed/seed in seed_source.contents)
				found_seed = seed
				break

			if(found_seed)
				SEND_SIGNAL(seed_source, COMSIG_TRY_STORAGE_TAKE, found_seed, get_turf(pawn), TRUE)
				if(found_seed.forceMove(pawn))
					controller.set_blackboard_key(BB_SIMPLE_CARRY_ITEM, found_seed)
					pawn.visible_message(span_notice("[pawn] takes [found_seed] for planting."))

			current_task = "scanning"
			return ACTION_STATE_CONTINUE

		if("planting")
			var/obj/structure/soil/soil = current_target
			var/obj/item/seed = controller.blackboard[BB_SIMPLE_CARRY_ITEM]

			if(!soil || soil.plant || !seed || !istype(seed, /obj/item/neuFarm/seed))
				current_task = "scanning"
				stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, soil) > 1)
				stuck_ticks++
				if(stuck_ticks >= max_stuck_ticks)
					current_task = "scanning"
					stuck_ticks = 0
				return ACTION_STATE_CONTINUE

			stuck_ticks = 0
			var/obj/item/neuFarm/seed/farm_seed = seed
			farm_seed.try_plant_seed(pawn, soil)
			controller.clear_blackboard_key(BB_SIMPLE_CARRY_ITEM)
			pawn.visible_message(span_notice("[pawn] plants [seed] in [soil]."))
			playsound(soil, pick('sound/foley/touch1.ogg','sound/foley/touch2.ogg','sound/foley/touch3.ogg'), 170, TRUE)

			current_task = "scanning"
			return ACTION_STATE_CONTINUE

	return ACTION_STATE_CONTINUE

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/datum/action_state/farming/proc/is_water_container(obj/item/item)
	if(!istype(item, /obj/item/reagent_containers))
		return FALSE
	var/obj/item/reagent_containers/container = item
	return container.reagents?.has_reagent(/datum/reagent/water, 15)

/datum/action_state/farming/proc/find_water_source_nearby(datum/ai_controller/controller)
	var/mob/living/pawn = controller.pawn
	for(var/obj/item/reagent_containers/container in oview(7, pawn))
		if(container.anchored)
			if(container.reagents?.has_reagent(/datum/reagent/water, 15))
				return container
		else if(istype(container, /obj/item/reagent_containers/glass))
			if(container.reagents?.has_reagent(/datum/reagent/water, 15))
				return container
	return null

/datum/action_state/farming/proc/find_well_nearby(datum/ai_controller/controller)
	var/mob/living/pawn = controller.pawn
	for(var/obj/structure/well/well in oview(15, pawn))
		return well
	return null

/datum/action_state/farming/proc/find_empty_container_nearby(datum/ai_controller/controller)
	var/mob/living/pawn = controller.pawn
	for(var/obj/item/reagent_containers/container in oview(7, pawn))
		if(container.reagents && container.reagents.total_volume == 0)
			return container
	return null

/datum/action_state/farming/proc/find_seed_source_nearby(datum/ai_controller/controller)
	var/mob/living/pawn = controller.pawn
	for(var/obj/structure/closet/container in oview(7, pawn))
		for(var/obj/item/neuFarm/seed in container.contents)
			return container
	return null
