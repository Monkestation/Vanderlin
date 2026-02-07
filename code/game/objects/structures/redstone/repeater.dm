/obj/structure/redstone/repeater
	name = "redstone repeater"
	desc = "Amplifies and delays redstone signals. Can be locked by a powered repeater from the side."
	icon_state = "repeater"
	redstone_role = REDSTONE_ROLE_PROCESSOR
	true_pattern = "repeater"
	should_block = FALSE

	var/facing_dir = NORTH
	var/delay_ticks = 2
	var/output_active = FALSE

	// Logic State Tracking
	var/scheduled_state = -1      // 1 = Turning ON, 0 = Turning OFF, -1 = Idle
	var/pending_turn_off = FALSE  // If TRUE, we must turn off immediately after turning on
	var/last_input_state = FALSE
	var/locked = FALSE

	can_connect_wires = TRUE
	send_wall_power = TRUE

/obj/structure/redstone/repeater/Initialize()
	. = ..()
	facing_dir = dir

/obj/structure/redstone/repeater/get_source_power()
	return output_active ? 15 : 0

/obj/structure/redstone/repeater/get_effective_power()
	return output_active ? 15 : 0

/obj/structure/redstone/repeater/get_output_directions()
	return list(facing_dir)

/obj/structure/redstone/repeater/get_input_directions()
	return list(REVERSE_DIR(facing_dir))

/obj/structure/redstone/repeater/get_connection_directions()
	return list(facing_dir, REVERSE_DIR(facing_dir))

/obj/structure/redstone/repeater/can_connect_to(obj/structure/redstone/other, direction)
	return (direction == facing_dir || direction == REVERSE_DIR(facing_dir))

/obj/structure/redstone/repeater/can_receive_from(obj/structure/redstone/source, direction)
	return (direction == REVERSE_DIR(facing_dir))

/obj/structure/redstone/repeater/get_network_neighbors()
	var/list/neighbors = list()
	var/input_dir = REVERSE_DIR(facing_dir)

	// Input side
	var/turf/input_turf = get_step(src, input_dir)
	for(var/obj/structure/redstone/R in input_turf)
		if(can_connect_to(R, input_dir) && R.can_connect_to(src, facing_dir))
			neighbors += R
	if(isclosedturf(input_turf))
		neighbors |= get_wall_power_sources(input_dir, input_turf)

	// Output side
	var/turf/output_turf = get_step(src, facing_dir)
	for(var/obj/structure/redstone/R in output_turf)
		if(can_connect_to(R, facing_dir) && R.can_connect_to(src, input_dir))
			neighbors += R
	if(send_wall_power && isclosedturf(output_turf))
		neighbors |= get_wall_power_neighbors(facing_dir, output_turf)

	return neighbors

/obj/structure/redstone/repeater/proc/update_lock_status()
	var/should_be_locked = FALSE
	var/list/side_dirs = list(turn(facing_dir, 90), turn(facing_dir, -90))

	for(var/check_dir in side_dirs)
		var/turf/T = get_step(src, check_dir)
		if(!T) continue
		for(var/obj/structure/redstone/repeater/R in T)
			if(R.facing_dir == REVERSE_DIR(check_dir) && R.output_active)
				should_be_locked = TRUE
				break
		if(should_be_locked) break

	if(locked != should_be_locked)
		locked = should_be_locked
		update_appearance(UPDATE_OVERLAYS)
		return TRUE
	return FALSE

/obj/structure/redstone/repeater/proc/trigger_lock_updates()
	var/turf/front_turf = get_step(src, facing_dir)
	if(front_turf)
		for(var/obj/structure/redstone/repeater/victim in front_turf)
			if(victim.facing_dir == turn(facing_dir, 90) || victim.facing_dir == turn(facing_dir, -90))
				victim.schedule_network_update()

/obj/structure/redstone/repeater/proc/get_wall_power_sources(direction, turf/wall_turf)
	var/list/sources = list()
	for(var/check_dir in GLOB.cardinals)
		if(check_dir == REVERSE_DIR(direction)) continue
		var/turf/beyond_wall = get_step(wall_turf, check_dir)
		for(var/obj/structure/redstone/R in beyond_wall)
			if(!R.send_wall_power) continue
			var/dir_to_wall = REVERSE_DIR(check_dir)
			if(dir_to_wall in R.get_output_directions())
				sources += R
	return sources

/obj/structure/redstone/repeater/on_power_changed()
	// 1. Lock Check
	var/lock_changed = update_lock_status()
	if(locked) return

	// 2. Calculate Input
	var/input_dir = REVERSE_DIR(facing_dir)
	var/turf/input_turf = get_step(src, input_dir)
	var/input_power = 0

	// Direct input
	for(var/obj/structure/redstone/R in input_turf)
		if(R.can_connect_to(src, facing_dir))
			input_power = max(input_power, R.get_effective_power())

	// Wall input
	if(isclosedturf(input_turf))
		for(var/check_dir in GLOB.cardinals)
			if(check_dir == REVERSE_DIR(input_dir)) continue
			var/turf/beyond_wall = get_step(input_turf, check_dir)
			for(var/obj/structure/redstone/R in beyond_wall)
				if(!R.send_wall_power) continue
				if(!(REVERSE_DIR(check_dir) in R.get_output_directions())) continue
				input_power = max(input_power, R.get_effective_power())

	var/input_on = (input_power > 0)

	if(input_on == last_input_state && !lock_changed)
		return

	last_input_state = input_on

	// 3. Scheduling Logic with Pulse Sustaining
	if(input_on)
		// Input turned ON
		if(!output_active && scheduled_state != 1)
			// We were OFF, start the timer to turn ON
			scheduled_state = 1
			pending_turn_off = FALSE // Reset any pending cutoff
			spawn(delay_ticks)
				apply_scheduled_state()

		else if(scheduled_state == 1)
			// We were ALREADY waiting to turn ON, but maybe we had a pending_turn_off queued?
			// Since input is back, we cancel the pending cutoff.
			pending_turn_off = FALSE

		else if(scheduled_state == 0)
			// We were scheduled to turn OFF, but input came back. Cancel the turn-off.
			scheduled_state = -1
			pending_turn_off = FALSE

	else
		// Input turned OFF
		if(output_active && scheduled_state != 0)
			// We are currently ON, schedule turn OFF
			scheduled_state = 0
			spawn(delay_ticks)
				apply_scheduled_state()

		else if(scheduled_state == 1)
			pending_turn_off = TRUE

/obj/structure/redstone/repeater/proc/apply_scheduled_state()
	update_lock_status()

	// If locked, we abandon the schedule change.
	// In MC, if you lock a repeater mid-pulse, it usually freezes the OUTPUT.
	// So if we were about to change output, locking prevents it.
	if(locked)
		scheduled_state = -1
		pending_turn_off = FALSE
		return

	// Safety check: if scheduled_state was cancelled (set to -1) elsewhere
	if(scheduled_state == -1)
		return

	var/state_changed = FALSE
	var/current_state = scheduled_state // Cache current intent

	// Reset schedule variable now, so we can schedule new things inside this block
	scheduled_state = -1

	if(current_state == 1 && !output_active)
		// Turning ON
		output_active = TRUE
		power_level = 15
		state_changed = TRUE

		// Handling the "Short Pulse" logic
		if(pending_turn_off)
			pending_turn_off = FALSE
			// We finished turning ON, but the input is already gone.
			// Schedule the turn OFF immediately.
			scheduled_state = 0
			spawn(delay_ticks)
				apply_scheduled_state()

	else if(current_state == 0 && output_active)
		// Turning OFF
		output_active = FALSE
		power_level = 0
		state_changed = TRUE

	if(state_changed)
		schedule_network_update()
		trigger_lock_updates()
		update_appearance(UPDATE_OVERLAYS)

/obj/structure/redstone/repeater/update_icon_state()
	. = ..()
	icon_state = "repeater"
	dir = facing_dir

/obj/structure/redstone/repeater/update_overlays()
	. = ..()
	var/mutable_appearance/delay_overlay = mutable_appearance(icon, "delay_[delay_ticks]")
	delay_overlay.color = output_active ? "#FF0000" : "#8B4513"
	. += delay_overlay

	if(output_active)
		var/mutable_appearance/em = emissive_appearance(icon, "delay_[delay_ticks]")
		. += em

	if(locked)
		var/mutable_appearance/lock_overlay = mutable_appearance(icon, "repeater_lock")
		lock_overlay.layer = layer + 0.02
		. += lock_overlay

/obj/structure/redstone/repeater/attack_hand(mob/user)
	if(locked)
		to_chat(user, "<span class='warning'>The repeater is locked!</span>")
		return
	delay_ticks = (delay_ticks % 4) + 1
	to_chat(user, "<span class='notice'>Delay set to [delay_ticks] tick\s.</span>")
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/redstone/repeater/AltClick(mob/user, list/modifiers)
	if(!Adjacent(user)) return
	facing_dir = turn(facing_dir, 90)
	dir = facing_dir
	to_chat(user, "<span class='notice'>You rotate the [name].</span>")
	schedule_network_update()

/obj/structure/redstone/repeater/proc/dir2text_readable(direction)
	switch(direction)
		if(NORTH) return "north"
		if(SOUTH) return "south"
		if(EAST) return "east"
		if(WEST) return "west"
	return "unknown"

/obj/structure/redstone/repeater/examine(mob/user)
	. = ..()
	. += "Facing [dir2text_readable(facing_dir)], delay: [delay_ticks] tick\s."
