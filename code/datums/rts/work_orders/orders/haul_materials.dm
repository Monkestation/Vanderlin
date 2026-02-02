/datum/work_order/haul_materials
	name = "Hauling to "
	var/list/materials_to_get = list()

	var/obj/effect/building_node/stockpile/stockpile_node
	var/obj/effect/building_node/taking_node
	var/going_to_stockpile = TRUE

/datum/work_order/haul_materials/New(mob/living/new_worker, datum/work_order/type, obj/effect/building_node/resource_collector, mob/camera/strategy_controller/master)
	. = ..()
	if(!length(resource_collector.material_requests))
		stop_work("no material requests")
		return
	for(var/obj/effect/building_node/stockpile/pile in master.constructed_building_nodes)
		var/list/path = get_path_to(new_worker, get_turf(pile), TYPE_PROC_REF(/turf, Heuristic_cardinal_3d), 32 + 1, 250,1)
		if(length(path))
			stockpile_node = pile
			break
	if(!stockpile_node)
		stop_work("no stockpiles")
		return
	name += resource_collector.name
	taking_node = resource_collector
	set_movement_target(stockpile_node)

/datum/work_order/haul_materials/proc/grab_materials_from_stockpile()
	var/max_grab = 5

	for(var/requestor in taking_node.material_requests)
		for(var/item in taking_node.material_requests[requestor])
			if(max_grab <= 0)
				return
			var/material_count = stockpile_node.stockpile.stored_materials[item]
			var/grab_amount = min(max_grab, material_count)
			max_grab -= grab_amount

			materials_to_get |= item
			materials_to_get[item] = grab_amount

			taking_node.material_requests[requestor][item] -= grab_amount
			if(taking_node.material_requests[requestor][item] <= 0)
				taking_node.material_requests[requestor] -= item
				if(!length(taking_node.material_requests[requestor]))
					taking_node.material_requests -= requestor

			stockpile_node.stockpile.stored_materials[item] -= grab_amount
			stockpile_node.stockpile.stored_materials[item] = max(stockpile_node.stockpile.stored_materials[item], 0)

/datum/work_order/haul_materials/proc/return_materials()
	stockpile_node.stockpile.add_resources(materials_to_get)
	materials_to_get = list()

/datum/work_order/haul_materials/stop_work(reason = "unknown")
	. = ..()
	if(length(materials_to_get))
		return_materials()

/datum/work_order/haul_materials/start_working(mob/living/worker_mob)
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
		finish_work()
		return

	if(going_to_stockpile)
		if(!do_after(worker, work_time_left, target = work_target))
			worker.controller_mind.paused = FALSE
			if(!can_continue)
				stop_work("interrupted")
				return FALSE
			work_time_left = world.time - world_start_time
			return FALSE
		grab_materials_from_stockpile()
		set_movement_target(taking_node)
		going_to_stockpile = FALSE
		worker.controller_mind.paused = FALSE
		return

/datum/work_order/haul_materials/proc/add_materials_to_requestor()
	for(var/item in materials_to_get)
		taking_node.work_materials |= item
		taking_node.work_materials[item] += materials_to_get[item]
	materials_to_get = list()

/datum/work_order/haul_materials/finish_work()
	. = ..()
	add_materials_to_requestor()
