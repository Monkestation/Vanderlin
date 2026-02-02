/datum/work_order/craft_gear
	name = "Crafting Gear"
	work_time_left = 45 SECONDS
	stamina_cost = 12
	var/gear_type_path
	var/item_path
	var/obj/effect/building_node/crafting_node
	var/list/material_cost = list()
	var/obj/effect/workspot/workspot

/datum/work_order/craft_gear/New(mob/living/new_worker, datum/work_order/type, obj/effect/workspot/work_spot, obj/effect/building_node/node, item_type, list/materials, gear_type)
	. = ..()
	crafting_node = node
	item_path = item_type
	material_cost = materials
	workspot = work_spot
	gear_type_path = gear_type
	set_movement_target(work_spot)

/datum/work_order/craft_gear/start_working(mob/living/worker_mob)
	if(!crafting_node.use_work_materials(material_cost))
		worker.controller_mind.pause_task_for(30 SECONDS, workspot)
		crafting_node.add_material_request(src, material_cost, 3)
		return
	. = ..()

/datum/work_order/craft_gear/finish_work()
	// Spawn the item
	var/obj/item/gear_item = new item_path(get_turf(crafting_node))

	// Create and attach the worker_gear datum
	var/datum/worker_gear/gear_datum = new gear_type_path(gear_item, null, null)

	// Store it in the building node
	var/gear_key = "[gear_type_path]_[crafting_node.get_stored_count(gear_type_path) + 1]"
	crafting_node.store_gear(gear_item, gear_datum, gear_key)

	worker.visible_message("<span class='notice'>[worker] finishes crafting [gear_item]!</span>")
	. = ..()
