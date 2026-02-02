/datum/work_order/store_materials
	name = "Hauling from "
	var/list/materials_to_get = list()

	var/obj/effect/building_node/stockpile/stockpile_node
	var/obj/effect/building_node/taking_node
	var/going_to_stockpile = FALSE

/datum/work_order/store_materials/New(mob/living/new_worker, datum/work_order/type, obj/effect/building_node/resource_collector, mob/camera/strategy_controller/master)
	. = ..()
	if(!length(resource_collector.materials_to_store))
		stop_work("no store requests")
		return
	for(var/obj/effect/building_node/stockpile/pile in master.constructed_building_nodes)
		var/list/path = get_path_to(new_worker, get_turf(pile), TYPE_PROC_REF(/turf, Heuristic_cardinal_3d), 32 + 1, 250,1)
		if(length(path))
			stockpile_node = pile
			break
	if(!stockpile_node)
		stop_work("no stockpile")
		return
	name += resource_collector.name
	grab_materials_from_node(resource_collector)
	set_movement_target(resource_collector)

/datum/work_order/store_materials/proc/grab_materials_from_node(obj/effect/building_node/resource_collector)
	taking_node = resource_collector

	var/max_grab = 5

	for(var/item in resource_collector.materials_to_store)
		var/material_count = resource_collector.materials_to_store[item]
		var/grab_amount = min(max_grab, material_count)
		max_grab -= grab_amount

		materials_to_get |= item
		materials_to_get[item] = grab_amount

		if(resource_collector.materials_to_store[item] == grab_amount)
			resource_collector.materials_to_store -= item
		else
			resource_collector.materials_to_store[item] -= grab_amount

/datum/work_order/store_materials/proc/return_materials()
	for(var/item in materials_to_get)
		taking_node.materials_to_store |= item
		taking_node.materials_to_store[item] += materials_to_get[item]
	materials_to_get = list()

/datum/work_order/store_materials/stop_work(reason = "unknown")
	. = ..()
	if(length(materials_to_get))
		return_materials()

/datum/work_order/store_materials/start_working(mob/living/worker_mob)
	worker.controller_mind.paused = TRUE
	worker.controller_mind.update_stat_panel()
	var/world_start_time = world.time
	if(visible_message)
		worker.visible_message("[worker] [visible_message]")

	if(!going_to_stockpile)
		if(!do_after(worker, work_time_left, target = work_target))
			worker.controller_mind.paused = FALSE
			if(!can_continue)
				stop_work("interrupted")
				return FALSE
			work_time_left = world.time - world_start_time
			return FALSE
		set_movement_target(stockpile_node)
		going_to_stockpile = TRUE
		worker.controller_mind.paused = FALSE
		return

	if(going_to_stockpile)
		if(!do_after(worker, work_time_left, target = work_target))
			worker.controller_mind.paused = FALSE
			if(!can_continue)
				stop_work("interrupted")
				return FALSE
			work_time_left = world.time - world_start_time
			return FALSE
		finish_work()

/datum/work_order/store_materials/proc/add_materials_to_stockpile()
	for(var/item in materials_to_get)
		stockpile_node.stockpile.stored_materials |= item
		stockpile_node.stockpile.stored_materials[item] += materials_to_get[item]
	materials_to_get = list()

/datum/work_order/store_materials/finish_work()
	. = ..()
	add_materials_to_stockpile()
