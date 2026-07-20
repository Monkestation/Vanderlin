/obj/structure/redstone/comparator
	name = "redstone comparator"
	desc = "Compares redstone signal strengths. Can read containers and signals through walls."
	icon_state = "comparator"
	redstone_role = REDSTONE_ROLE_PROCESSOR

	var/mode = "compare" // "compare" or "subtract"

	// Inputs (Cached)
	var/main_input = 0
	var/side_input_left = 0
	var/side_input_right = 0

	var/output_power = 0
	var/scheduled_target = -1 // For the 1-tick delay handling

	var/last_storage_signal = 0

	can_connect_wires = TRUE
	send_wall_power = TRUE

/obj/structure/redstone/comparator/Initialize()
	. = ..()
	// We process to check containers
	START_PROCESSING(SSobj, src)

/obj/structure/redstone/comparator/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/redstone/comparator/get_source_power()
	return output_power

/obj/structure/redstone/comparator/get_effective_power()
	return output_power

/obj/structure/redstone/comparator/get_output_directions()
	return list(dir)

/obj/structure/redstone/comparator/get_input_directions()
	return list(REVERSE_DIR(dir), turn(dir, 90), turn(dir, -90))

/obj/structure/redstone/comparator/get_connection_directions()
	return list(dir, REVERSE_DIR(dir), turn(dir, 90), turn(dir, -90))

/obj/structure/redstone/comparator/can_connect_to(obj/structure/redstone/other, dir)
	return TRUE // Connects on all sides

/obj/structure/redstone/comparator/can_receive_from(obj/structure/redstone/source, dir)
	return (dir in get_input_directions())

/obj/structure/redstone/comparator/get_network_neighbors()
	var/list/neighbors = list()

	// 1. Standard Redstone Neighbors
	for(var/dir in get_connection_directions())
		var/turf/T = get_step(src, dir)
		for(var/obj/structure/redstone/R in T)
			if(can_connect_to(R, dir) && R.can_connect_to(src, REVERSE_DIR(dir)))
				neighbors += R

	// 2. Wall Power OUTPUT (Front)
	var/turf/front = get_step(src, dir)
	if(isclosedturf(front))
		neighbors |= get_wall_power_neighbors(dir, front)

	// 3. Wall Power INPUT (Rear & Sides)
	for(var/input_dir in get_input_directions())
		var/turf/T = get_step(src, input_dir)
		if(isclosedturf(T))
			neighbors |= get_wall_power_sources(input_dir, T)

	return neighbors

/obj/structure/redstone/comparator/proc/get_wall_power_sources(input_dir, turf/wall_turf)
	var/list/sources = list()
	for(var/check_dir in GLOB.cardinals)
		if(check_dir == REVERSE_DIR(input_dir)) continue
		var/turf/beyond_wall = get_step(wall_turf, check_dir)
		for(var/obj/structure/redstone/R in beyond_wall)
			if(!R.send_wall_power) continue
			var/dir_to_wall = REVERSE_DIR(check_dir)
			if(dir_to_wall in R.get_output_directions())
				sources += R
	return sources

/obj/structure/redstone/comparator/get_wall_power_neighbors(direction, turf/wall_turf)
	var/list/neighbors = list()

	// Horizontal
	for(var/check_dir in GLOB.cardinals)
		if(check_dir == REVERSE_DIR(direction)) continue
		var/turf/beyond_wall = get_step(wall_turf, check_dir)
		for(var/obj/structure/redstone/dust/dust in beyond_wall)
			neighbors += dust
		for(var/obj/structure/redstone/repeater/rep in beyond_wall)
			if(REVERSE_DIR(rep.facing_dir) == REVERSE_DIR(check_dir)) neighbors += rep

	// Vertical (Multi-Z)
	var/turf/above = GET_TURF_ABOVE(wall_turf)
	if(above)
		for(var/obj/structure/redstone/dust/dust in above) neighbors += dust

	var/turf/below = GET_TURF_BELOW(wall_turf)
	if(below)
		for(var/obj/structure/redstone/dust/dust in below) neighbors += dust

	return neighbors

/obj/structure/redstone/comparator/process()
	// 1. Get the current state of the container
	var/current_storage_signal = get_storage_signal()

	// 2. Only recalculate if the STORAGE ITSELF changed.
	// Do not compare against main_input (which might be high due to a wire).
	if(current_storage_signal != last_storage_signal)
		on_power_changed()

/obj/structure/redstone/comparator/on_power_changed()
	// 1. Calculate Side Inputs
	var/left_dir = turn(dir, 90)
	var/right_dir = turn(dir, -90)

	side_input_left = get_power_from_side(left_dir)
	side_input_right = get_power_from_side(right_dir)

	// 2. Calculate Main Input (Rear)
	var/rear_dir = REVERSE_DIR(dir)
	var/redstone_signal = get_power_from_side(rear_dir)

	// Update the separate storage tracker
	last_storage_signal = get_storage_signal()

	// Set the actual main input
	main_input = max(redstone_signal, last_storage_signal)

	// 3. Determine Desired Output
	var/max_side = max(side_input_left, side_input_right)
	var/desired_output = 0

	if(mode == "compare")
		// MAINTAIN STRENGTH: If Main >= Side, output Main. Else 0.
		desired_output = (main_input >= max_side) ? main_input : 0
	else // subtract
		desired_output = max(0, main_input - max_side)

	if(desired_output != output_power)
		// Prevent spamming spawns if we are already scheduled for this target
		if(scheduled_target != desired_output)
			scheduled_target = desired_output
			spawn(1)
				apply_scheduled_output()

/obj/structure/redstone/comparator/proc/apply_scheduled_output()
	// If we changed our mind mid-delay (fast pulse), handle it or cancel
	if(scheduled_target == -1) return

	if(output_power != scheduled_target)
		output_power = scheduled_target
		power_level = output_power

		// Only now do we update the network
		schedule_network_update()
		update_appearance(UPDATE_OVERLAYS)

	scheduled_target = -1

/obj/structure/redstone/comparator/proc/get_power_from_side(side_dir)
	var/turf/T = get_step(src, side_dir)
	var/found_power = 0

	// A. Direct Connection
	for(var/obj/structure/redstone/R in T)
		if(R.can_connect_to(src, REVERSE_DIR(side_dir)))
			found_power = max(found_power, R.get_effective_power())

	// B. Wall Power (Reading through a block)
	if(isclosedturf(T))
		for(var/check_dir in GLOB.cardinals)
			if(check_dir == REVERSE_DIR(side_dir)) continue
			var/turf/source_turf = get_step(T, check_dir)
			for(var/obj/structure/redstone/R in source_turf)
				if(R.send_wall_power)
					if(REVERSE_DIR(check_dir) in R.get_output_directions())
						found_power = max(found_power, R.get_effective_power())

	return found_power

/obj/structure/redstone/comparator/proc/get_storage_signal()
	var/turf/back_turf = get_step(src, REVERSE_DIR(dir))

	for(var/obj/O in back_turf)
		var/datum/component/storage/storage_comp = O.GetComponent(/datum/component/storage)
		if(storage_comp)
			return calculate_storage_fullness(storage_comp, O)
	return 0

/obj/structure/redstone/comparator/proc/calculate_storage_fullness(datum/component/storage/storage_comp, obj/O)
	var/max_capacity = storage_comp.screen_max_rows * storage_comp.screen_max_columns
	if(max_capacity <= 0)
		return 0

	var/total = 0
	for(var/obj/item/item in O.contents)
		total += (item.grid_width / 32) * (item.grid_height / 32)

	return round((total / max_capacity) * 15)

/obj/structure/redstone/comparator/update_icon()
	. = ..()
	icon_state = (mode == "subtract") ? "comparator_subtract" : "comparator"

/obj/structure/redstone/comparator/update_overlays()
	. = ..()
	var/mutable_appearance/rear_torch = mutable_appearance(icon, "torch_rear")
	rear_torch.color = (output_power > 0) ? "#FF0000" : "#8B4513"
	. += rear_torch

	if(output_power > 0)
		var/mutable_appearance/em = emissive_appearance(icon, "torch_rear")
		. += em

	var/mutable_appearance/front_torch = mutable_appearance(icon, "torch_front")
	front_torch.color = (mode == "subtract") ? "#FF0000" : "#8B4513"
	. += front_torch

	if(mode == "subtract")
		var/mutable_appearance/em = emissive_appearance(icon, "torch_front")
		. += em

/obj/structure/redstone/comparator/attack_hand(mob/user)
	mode = (mode == "compare") ? "subtract" : "compare"
	to_chat(user, "<span class='notice'>Mode changed to [mode].</span>")
	on_power_changed() // Recalculate
	update_appearance(UPDATE_ICON | UPDATE_OVERLAYS)

/obj/structure/redstone/comparator/AltClick(mob/user, list/modifiers)
	if(!Adjacent(user))
		return
	dir = turn(dir, 90)
	to_chat(user, "<span class='notice'>You rotate the [name].</span>")
	schedule_network_update()
	on_power_changed()
