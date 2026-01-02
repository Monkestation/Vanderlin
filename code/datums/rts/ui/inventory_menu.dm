
/atom/movable/screen/worker_inventory_backdrop
	icon = 'icons/hud/rts_ability_hud.dmi'
	icon_state = "inventory_ui"
	screen_loc = "WEST,SOUTH:96"
	var/list/inventory_slots = list()
	var/atom/movable/screen/close_inventory/close
	var/datum/worker_mind/linked_worker
	var/max_x = 2
	var/max_y = 3
	var/current_x = 0
	var/current_y = 0

/atom/movable/screen/worker_inventory_backdrop/New(loc, ...)
	. = ..()
	close = new

/atom/movable/screen/worker_inventory_backdrop/Destroy(force)
	QDEL_NULL(close)
	linked_worker = null
	return ..()

/atom/movable/screen/worker_inventory_backdrop/proc/open_ui(mob/camera/strategy_controller/opener, datum/worker_mind/worker)
	close_uis(opener)
	linked_worker = worker

	var/list/slot_types = list(
		WORKER_SLOT_HEAD,
		WORKER_SLOT_SHIRT,
		WORKER_SLOT_PANTS,
		WORKER_SLOT_SHOES,
		WORKER_SLOT_HANDS
	)

	for(var/slot_type in slot_types)
		var/atom/movable/screen/worker_inventory_slot/new_slot = new
		new_slot.slot_type = slot_type
		new_slot.linked_worker = worker
		new_slot.parent_menu = src

		// Get the current gear in this slot
		var/datum/worker_gear/gear = worker.get_gear_in_slot(slot_type)
		if(gear && gear.item)
			new_slot.set_item(gear.item)

		new_slot.screen_loc = "WEST:[(current_x*32)],SOUTH:[96 + (current_y*32)]"
		new_slot.name = get_slot_display_name(slot_type)

		current_x++
		if(current_x >= max_x)
			current_x = 0
			current_y++

		opener.client.screen += new_slot
		inventory_slots += new_slot

	opener.client.screen += src
	opener.client.screen += close

/atom/movable/screen/worker_inventory_backdrop/proc/close_uis(mob/camera/strategy_controller/closer)
	for(var/atom/movable/screen/worker_inventory_slot/slot as anything in inventory_slots)
		inventory_slots -= slot
		closer.client.screen -= slot
		qdel(slot)
	closer.client.screen -= src
	closer.client.screen -= close
	current_x = 0
	current_y = 0
	linked_worker = null

/atom/movable/screen/worker_inventory_backdrop/proc/update_display()
	if(!linked_worker)
		return

	for(var/atom/movable/screen/worker_inventory_slot/slot in inventory_slots)
		var/datum/worker_gear/gear = linked_worker.get_gear_in_slot(slot.slot_type)
		if(gear && gear.item)
			slot.set_item(gear.item)
		else
			slot.set_item(null)

/atom/movable/screen/worker_inventory_backdrop/proc/get_slot_display_name(slot_type)
	switch(slot_type)
		if(WORKER_SLOT_HEAD)
			return "Head"
		if(WORKER_SLOT_SHIRT)
			return "Shirt"
		if(WORKER_SLOT_PANTS)
			return "Pants"
		if(WORKER_SLOT_SHOES)
			return "Shoes"
		if(WORKER_SLOT_HANDS)
			return "Hands"
		else
			return "Unknown"

/atom/movable/screen/close_inventory
	icon = 'icons/hud/rts_ability_hud.dmi'
	icon_state = "inventory_close"
	screen_loc = "WEST,SOUTH:96"

/atom/movable/screen/close_inventory/Click(location, control, params)
	. = ..()
	var/mob/camera/strategy_controller/clicker = usr
	if(!istype(clicker))
		return
	clicker.close_inventory_ui()

/atom/movable/screen/worker_inventory_slot
	icon = 'icons/hud/storage.dmi'
	icon_state = "background"
	screen_loc = "WEST,SOUTH:96"
	var/slot_type
	var/obj/item/equipped_item
	var/datum/worker_mind/linked_worker
	var/atom/movable/screen/worker_inventory_backdrop/parent_menu

/atom/movable/screen/worker_inventory_slot/proc/set_item(obj/item/item)
	if(equipped_item)
		cut_overlays()

	equipped_item = item

	if(item)
		var/mutable_appearance/MA = mutable_appearance(item.icon, item.icon_state, layer + 0.1, plane)
		add_overlay(MA)
		name = "[parent_menu.get_slot_display_name(slot_type)]: [item.name]"
	else
		name = "[parent_menu.get_slot_display_name(slot_type)]: Empty"

/atom/movable/screen/worker_inventory_slot/Click(location, control, params)
	. = ..()
	var/mob/camera/strategy_controller/clicker = usr
	if(!istype(clicker))
		return

	var/list/modifiers = params2list(params)
	if(modifiers["left"])
		handle_left_click(clicker)
	else if(modifiers["right"])
		handle_right_click(clicker)

/atom/movable/screen/worker_inventory_slot/proc/handle_left_click(mob/camera/strategy_controller/user)
	if(!linked_worker || !equipped_item)
		to_chat(user, "No item equipped in [parent_menu.get_slot_display_name(slot_type)] slot.")
		return

	var/datum/worker_gear/gear = linked_worker.get_gear_in_slot(slot_type)
	if(!gear)
		to_chat(user, "No gear data found for [equipped_item.name].")
		return

	display_gear_stats(user, gear)

/atom/movable/screen/worker_inventory_slot/proc/handle_right_click(mob/camera/strategy_controller/user)
	if(!linked_worker || !equipped_item)
		to_chat(user, "No item equipped in [parent_menu.get_slot_display_name(slot_type)] slot.")
		return

	var/list/available_nodes = find_storage_nodes(user)

	if(!length(available_nodes))
		to_chat(user, "No suitable storage buildings found nearby.")
		return

	if(length(available_nodes) == 1)
		var/obj/effect/building_node/target_node = available_nodes[1]
		attempt_gear_storage(user, target_node)
		return

	var/list/node_options = list()
	for(var/obj/effect/building_node/node in available_nodes)
		node_options[node.name] = node

	var/choice = input(user, "Select storage location:", "Store Gear") as null|anything in node_options
	if(!choice)
		return

	var/obj/effect/building_node/selected_node = node_options[choice]
	attempt_gear_storage(user, selected_node)

/atom/movable/screen/worker_inventory_slot/proc/display_gear_stats(mob/camera/strategy_controller/user, datum/worker_gear/gear)
	var/stats_text = "<b>[gear.item.name] Stats:</b><br>"

	stats_text += "<b>Basic Effects:</b><br>"
	if(gear.work_speed_modifier != 1.0)
		var/percent = (gear.work_speed_modifier - 1.0) * 100
		stats_text += "- Work Speed: [percent > 0 ? "+" : ""][percent]%<br>"

	if(gear.walkspeed_modifier != 0)
		stats_text += "- Movement Speed: [gear.walkspeed_modifier > 0 ? "+" : ""][gear.walkspeed_modifier]<br>"

	if(gear.stamina_cost_modifier != 1.0)
		var/percent = (1.0 - gear.stamina_cost_modifier) * 100
		stats_text += "- Stamina Efficiency: [percent > 0 ? "+" : ""][percent]%<br>"

	if(gear.stamina_regen_modifier != 1.0)
		var/percent = (gear.stamina_regen_modifier - 1.0) * 100
		stats_text += "- Stamina Regen: [percent > 0 ? "+" : ""][percent]%<br>"

	if(gear.stamina_modifier != 0)
		stats_text += "- Max Stamina: [gear.stamina_modifier > 0 ? "+" : ""][gear.stamina_modifier]<br>"

	if(length(gear.task_bonuses))
		stats_text += "<br><b>Task Bonuses:</b><br>"
		for(var/task_type in gear.task_bonuses)
			var/list/bonuses = gear.task_bonuses[task_type]
			var/task_name = get_task_display_name(task_type)
			stats_text += "-<b>[task_name]:</b><br>"

			for(var/bonus_key in bonuses)
				var/bonus_value = bonuses[bonus_key]
				var/bonus_description = get_bonus_description(bonus_key, bonus_value)
				stats_text += "  -[bonus_description]<br>"

	if(gear.item.desc)
		stats_text += "<br><b>Description:</b><br>"
		stats_text += "[gear.item.desc]"

	var/datum/browser/popup = new(user, "gear_stats", "[gear.item.name] Stats", 400, 300)
	popup.set_content(stats_text)
	popup.open()

/atom/movable/screen/worker_inventory_slot/proc/get_task_display_name(task_type)
	var/type_name = "[task_type]"
	var/list/path_parts = splittext(type_name, "/")
	var/last_part = path_parts[length(path_parts)]

	last_part = replacetext(last_part, "_", " ")
	return capitalize(last_part)

/atom/movable/screen/worker_inventory_slot/proc/get_bonus_description(bonus_key, bonus_value)
	switch(bonus_key)
		if(TASK_KEY_SPEED)
			var/percent = (bonus_value - 1.0) * 100
			return "Speed: [percent > 0 ? "+" : ""][percent]%"
		if(TASK_KEY_REDUCTION)
			var/percent = (1.0 - bonus_value) * 100
			return "Stamina Cost: [percent > 0 ? "-" : "+"][percent]%"
		if(TASK_KEY_QUANTITY)
			var/percent = (bonus_value - 1.0) * 100
			return "Quantity: [percent > 0 ? "+" : ""][percent]%"
		else
			return "[bonus_key]: [bonus_value]"

/atom/movable/screen/worker_inventory_slot/proc/find_storage_nodes(mob/camera/strategy_controller/user)
	var/list/storage_nodes = list()

	var/search_range = 10
	var/list/nearby_turfs = view(search_range, linked_worker.worker)

	for(var/turf/turf in nearby_turfs)
		for(var/obj/effect/building_node/node in turf.contents)
			if(can_node_store_gear(node, slot_type))
				storage_nodes += node

	return storage_nodes

/atom/movable/screen/worker_inventory_slot/proc/can_node_store_gear(obj/effect/building_node/node, gear_slot)
	// for now, assume all nodes can store gear but you might want to restrict this
	return TRUE

/atom/movable/screen/worker_inventory_slot/proc/attempt_gear_storage(mob/camera/strategy_controller/user, obj/effect/building_node/target_node)
	if(!target_node || !linked_worker || !equipped_item)
		return

	var/datum/worker_gear/gear = linked_worker.get_gear_in_slot(slot_type)
	if(!gear)
		to_chat(user, "Failed to retrieve gear data.")
		return

	linked_worker.remove_gear_from_slot(slot_type)

	var/storage_key = "[slot_type]_[equipped_item.type]_[world.time]"
	target_node.store_gear(equipped_item, storage_key)
	parent_menu.update_display()

	to_chat(user, "Stored [equipped_item.name] in [target_node.name].")

	if(!target_node.Adjacent(linked_worker.worker))
		create_storage_task(user, target_node)

/atom/movable/screen/worker_inventory_slot/proc/create_storage_task(mob/camera/strategy_controller/user, obj/effect/building_node/target_node)
	linked_worker.set_current_task(/datum/work_order/store_gear, target_node, equipped_item)
