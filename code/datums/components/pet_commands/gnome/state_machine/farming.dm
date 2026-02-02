
/datum/action_state/farming
	name = "farming"
	description = "Tending to crops"
	var/current_task = "scanning"
	var/current_target = null

/datum/action_state/farming/enter_state(datum/ai_controller/controller)
	current_task = "scanning"
	current_target = null

/datum/action_state/farming/process_state(datum/ai_controller/controller, delta_time)
	if(!controller.blackboard[BB_GNOME_CROP_MODE])
		return ACTION_STATE_COMPLETE

	var/mob/living/pawn = controller.pawn

	switch(current_task)
		if("scanning")
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
						var/obj/item/water_source = find_water_source_nearby(controller)
						if(water_source)
							current_target = water_source
							manager.set_movement_target(controller, water_source)
							current_task = "getting_water"
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
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, soil) > 1)
				return ACTION_STATE_CONTINUE

			soil.user_harvests(pawn)
			pawn.visible_message(span_notice("[pawn] harvests [soil]."))
			playsound(soil, 'sound/items/seed.ogg', 100, FALSE)
			current_task = "scanning"
			return ACTION_STATE_CONTINUE

		if("deweeding")
			var/obj/structure/soil/soil = current_target
			if(!soil || soil.weeds <= 0)
				current_task = "scanning"
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, soil) > 1)
				return ACTION_STATE_CONTINUE

			soil.weeds = max(0, soil.weeds - 25)
			pawn.visible_message(span_notice("[pawn] carefully removes weeds from [soil]."))
			playsound(soil, pick('sound/foley/touch1.ogg','sound/foley/touch2.ogg','sound/foley/touch3.ogg'), 100, TRUE)
			current_task = "scanning"
			return ACTION_STATE_CONTINUE

		if("getting_water")
			var/obj/item/water_source = current_target
			if(!water_source)
				current_task = "scanning"
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, water_source) > 1)
				return ACTION_STATE_CONTINUE

			if(water_source.forceMove(pawn))
				controller.set_blackboard_key(BB_SIMPLE_CARRY_ITEM, water_source)
				pawn.visible_message(span_notice("[pawn] picks up [water_source] for watering."))

			current_task = "scanning"
			return ACTION_STATE_CONTINUE

		if("watering")
			var/obj/structure/soil/soil = current_target
			var/obj/item/carried = controller.blackboard[BB_SIMPLE_CARRY_ITEM]

			if(!soil || !carried || !is_water_container(carried))
				current_task = "scanning"
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, soil) > 1)
				return ACTION_STATE_CONTINUE

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
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, seed_source) > 1)
				return ACTION_STATE_CONTINUE

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
				return ACTION_STATE_CONTINUE

			if(get_dist(pawn, soil) > 1)
				return ACTION_STATE_CONTINUE

			var/obj/item/neuFarm/seed/farm_seed = seed
			farm_seed.try_plant_seed(pawn, soil)
			controller.clear_blackboard_key(BB_SIMPLE_CARRY_ITEM)
			pawn.visible_message(span_notice("[pawn] plants [seed] in [soil]."))
			playsound(soil, pick('sound/foley/touch1.ogg','sound/foley/touch2.ogg','sound/foley/touch3.ogg'), 170, TRUE)

			current_task = "scanning"
			return ACTION_STATE_CONTINUE

	return ACTION_STATE_CONTINUE

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

/datum/action_state/farming/proc/find_seed_source_nearby(datum/ai_controller/controller)
	var/mob/living/pawn = controller.pawn
	for(var/obj/structure/closet/container in oview(7, pawn))
		for(var/obj/item/neuFarm/seed/seed in container.contents)
			return container
	return null
