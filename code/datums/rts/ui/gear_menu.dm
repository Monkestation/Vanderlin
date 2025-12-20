/atom/movable/screen/gear_menu_backdrop
	icon = 'icons/hud/rts_ability_hud.dmi'
	icon_state = "inventory_ui"
	screen_loc = "EAST:-16,SOUTH:96"
	var/list/gear_slots = list()
	var/atom/movable/screen/close_gear_menu/close
	var/obj/effect/building_node/linked_node
	var/max_x = 3
	var/max_y = 6
	var/current_x = 0
	var/current_y = 0

/atom/movable/screen/gear_menu_backdrop/New(loc, ...)
	. = ..()
	close = new

/atom/movable/screen/gear_menu_backdrop/proc/open_ui(mob/camera/strategy_controller/opener, obj/effect/building_node/node)
	close_uis(opener)
	linked_node = node

	var/list/available_gear = get_node_gear_list(node)

	for(var/gear_display_name in available_gear)
		var/atom/movable/screen/gear_slot/new_slot = new
		new_slot.gear_type = gear_display_name
		new_slot.linked_node = node
		new_slot.parent_menu = src

		var/datum/worker_gear/stored_gear = available_gear[gear_display_name]
		new_slot.set_gear_item(stored_gear)

		new_slot.screen_loc = "EAST:[-(16 + (current_x*32))],SOUTH:[96 + (current_y*32)]"
		new_slot.name = gear_display_name

		current_x++
		if(current_x >= max_x)
			current_x = 0
			current_y++

		opener.client.screen += new_slot
		gear_slots += new_slot

	opener.client.screen += src
	opener.client.screen += close

/atom/movable/screen/gear_menu_backdrop/proc/close_uis(mob/camera/strategy_controller/closer)
	for(var/atom/movable/screen/gear_slot/slot as anything in gear_slots)
		gear_slots -= slot
		closer.client.screen -= slot
		qdel(slot)
	closer.client.screen -= src
	closer.client.screen -= close
	current_x = 0
	current_y = 0
	linked_node = null

/atom/movable/screen/gear_menu_backdrop/proc/get_node_gear_list(obj/effect/building_node/node)
	var/list/gear_list = list()

	if(!node.stored_gear || !length(node.stored_gear))
		var/list/slot_types = list(
			WORKER_SLOT_HEAD,
			WORKER_SLOT_SHIRT,
			WORKER_SLOT_PANTS,
			WORKER_SLOT_SHOES,
			WORKER_SLOT_HANDS
		)

		for(var/slot_type in slot_types)
			var/slot_name = get_slot_display_name_static(slot_type)
			gear_list["[slot_name] (Empty)"] = null

		return gear_list

	var/list/slot_groups = list()

	slot_groups[WORKER_SLOT_HEAD] = list()
	slot_groups[WORKER_SLOT_SHIRT] = list()
	slot_groups[WORKER_SLOT_PANTS] = list()
	slot_groups[WORKER_SLOT_SHOES] = list()
	slot_groups[WORKER_SLOT_HANDS] = list()

	for(var/datum/worker_gear/gear in node.stored_gear)
		if(gear.slot in slot_groups)
			slot_groups[gear.slot] += gear

	for(var/slot_type in slot_groups)
		var/list/gear_in_slot = slot_groups[slot_type]
		var/slot_name = get_slot_display_name_static(slot_type)

		if(length(gear_in_slot))
			for(var/i = 1 to length(gear_in_slot))
				var/datum/worker_gear/gear = gear_in_slot[i]
				var/display_name = "[slot_name]: [gear.item.name]"
				if(length(gear_in_slot) > 1)
					display_name = "[slot_name] #[i]: [gear.item.name]"
				gear_list[display_name] = gear
		else
			gear_list["[slot_name] (Empty)"] = null

	return gear_list

/atom/movable/screen/gear_menu_backdrop/proc/get_slot_display_name_static(slot_type)
	switch(slot_type)
		if(WORKER_SLOT_HEAD)
			return "Head Gear"
		if(WORKER_SLOT_SHIRT)
			return "Shirts"
		if(WORKER_SLOT_PANTS)
			return "Pants"
		if(WORKER_SLOT_SHOES)
			return "Footwear"
		if(WORKER_SLOT_HANDS)
			return "Tools"
		else
			return "Unknown"

/atom/movable/screen/close_gear_menu
	icon = 'icons/hud/rts_ability_hud.dmi'
	icon_state = "inventory_close"
	screen_loc = "EAST:-16,SOUTH:96"

/atom/movable/screen/close_gear_menu/Click(location, control, params)
	. = ..()
	var/mob/camera/strategy_controller/clicker = usr
	if(!istype(clicker))
		return
	clicker.close_gear_ui()

/atom/movable/screen/gear_slot
	icon = 'icons/hud/storage.dmi'
	icon_state = "background"
	screen_loc = "EAST:-16,SOUTH:96"
	var/gear_type
	var/obj/item/stored_item
	var/obj/effect/building_node/linked_node
	var/atom/movable/screen/gear_menu_backdrop/parent_menu

/atom/movable/screen/gear_slot/proc/set_gear_item(obj/item/item)
	if(stored_item)
		cut_overlays()

	stored_item = item

	if(item)
		var/mutable_appearance/MA = mutable_appearance(item.icon, item.icon_state, layer + 0.1, plane)
		add_overlay(MA)
		name = "[gear_type]: [item.name]"
	else
		name = "[gear_type]: Empty"

/atom/movable/screen/gear_slot/Click(location, control, params)
	. = ..()
	var/mob/camera/strategy_controller/clicker = usr
	if(!istype(clicker))
		return

	var/list/modifiers = params2list(params)
	if(modifiers["left"])
		handle_left_click(clicker)
	else if(modifiers["right"])
		handle_right_click(clicker)

/atom/movable/screen/gear_slot/proc/handle_left_click(mob/camera/strategy_controller/user)
	if(!stored_item)
		to_chat(user, "No item stored in [gear_type] slot.")
		return

	var/datum/worker_mind/selected_worker = user.displayed_mob_ui?.worker_mind
	if(!selected_worker)
		to_chat(user, "No worker selected. Select a worker first.")
		return

	create_retrieve_gear_task(user, selected_worker)

/atom/movable/screen/gear_slot/proc/handle_right_click(mob/camera/strategy_controller/user)
	if(!stored_item)
		to_chat(user, "No item stored in [gear_type] slot.")
		return

	display_stored_item_stats(user)

/atom/movable/screen/gear_slot/proc/create_retrieve_gear_task(mob/camera/strategy_controller/user, datum/worker_mind/worker_mind)
	if(!worker_mind || !stored_item || !linked_node)
		return

	worker_mind.set_current_task(/datum/work_order/retrieve_gear, linked_node, stored_item, gear_type)

	to_chat(user, "[worker_mind.worker_name] assigned to retrieve [stored_item.name] from [linked_node.name].")

/atom/movable/screen/gear_slot/proc/display_stored_item_stats(mob/camera/strategy_controller/user)
	var/stats_text = "<b>[stored_item.name] (Stored)</b><br>"
	stats_text += "<b>Location:</b> [linked_node.name]<br>"
	stats_text += "<b>Storage Type:</b> [gear_type]<br><br>"

	if(stored_item.desc)
		stats_text += "<b>Description:</b><br>"
		stats_text += "[stored_item.desc]<br><br>"

	stats_text += "<i>Left-click to assign retrieval task<br>"
	stats_text += "Right-click to view details</i>"

	var/datum/browser/popup = new(user, "stored_gear_stats", "[stored_item.name] Info", 350, 250)
	popup.set_content(stats_text)
	popup.open()
