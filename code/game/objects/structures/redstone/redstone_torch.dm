/obj/structure/redstone/torch
	name = "redstone torch"
	desc = "A torch that provides constant redstone power. Inverts when the attached block is powered."
	icon_state = "torch"
	redstone_role = REDSTONE_ROLE_SOURCE
	var/attached_dir = SOUTH
	var/inverted = FALSE
	var/base_power = 15
	can_connect_wires = TRUE
	send_wall_power = FALSE

/obj/structure/redstone/torch/Initialize()
	. = ..()
	attached_dir = dir
	power_level = base_power

/obj/structure/redstone/torch/LateInitialize()
	. = ..()
	schedule_network_update()

/obj/structure/redstone/torch/get_source_power()
	return inverted ? 0 : base_power

/obj/structure/redstone/torch/get_effective_power()
	return get_source_power()

/obj/structure/redstone/torch/get_output_directions()
	var/list/dirs = GLOB.cardinals.Copy()
	dirs -= attached_dir
	return dirs

/obj/structure/redstone/torch/get_input_directions()
	return list(attached_dir)

/obj/structure/redstone/torch/can_connect_to(obj/structure/redstone/other, direction)
	// Connect to wires on non-attached sides for output
	// Don't visually connect on attached side
	return (direction != attached_dir)

/obj/structure/redstone/torch/can_receive_from(obj/structure/redstone/source, direction)
	// Accept power from attached side for inversion
	return (direction == attached_dir)

/obj/structure/redstone/torch/receive_source_power(incoming_power, obj/structure/redstone/source)
	// This is called during propagation when another source tries to power us
	// For wall power: check if source is powering through our attached wall
	if(!source.send_wall_power)
		return

	var/turf/attached_turf = get_step(src, attached_dir)
	if(!isclosedturf(attached_turf))
		return

	// Source must be adjacent to our attached wall
	var/turf/source_turf = get_turf(source)
	var/source_adjacent_to_wall = FALSE
	for(var/d in GLOB.cardinals)
		if(get_step(attached_turf, d) == source_turf)
			source_adjacent_to_wall = TRUE
			break

	if(!source_adjacent_to_wall)
		return

	if(incoming_power > 0 && !inverted)
		inverted = TRUE
		power_level = 0

/obj/structure/redstone/torch/on_power_changed()
	var/should_be_inverted = check_receiving_power()

	if(should_be_inverted != inverted)
		inverted = should_be_inverted
		power_level = get_source_power()
		// Need to repropagate since our output changed
		spawn(1)
			schedule_network_update()

/obj/structure/redstone/torch/proc/check_receiving_power()
	var/turf/attached_turf = get_step(src, attached_dir)

	// Case 1: Direct connection - check for powered redstone on attached side
	if(!isclosedturf(attached_turf))
		for(var/obj/structure/redstone/R in attached_turf)
			if(R == src)
				continue
			if(!(R.redstone_role & REDSTONE_ROLE_SOURCE) && R.power_level > 0)
				// It's powered dust/repeater/etc
				if(REVERSE_DIR(attached_dir) in R.get_output_directions())
					return TRUE
			else if((R.redstone_role & REDSTONE_ROLE_SOURCE) && R.get_source_power() > 0)
				// It's an active source
				if(REVERSE_DIR(attached_dir) in R.get_output_directions())
					return TRUE
		return FALSE

	// Case 2: Wall - check for wall power sources around the wall
	for(var/check_dir in GLOB.cardinals)
		var/turf/around_wall = get_step(attached_turf, check_dir)
		if(around_wall == loc)
			continue  // Skip our own turf

		for(var/obj/structure/redstone/R in around_wall)
			if(!R.send_wall_power)
				continue
			if(R.power_level > 0 || ((R.redstone_role & REDSTONE_ROLE_SOURCE) && R.get_source_power() > 0))
				return TRUE

	return FALSE

/obj/structure/redstone/torch/update_overlays()
	. = ..()
	var/mutable_appearance/attachment_overlay = mutable_appearance(icon, "torch_attachment")
	attachment_overlay.dir = attached_dir
	. += attachment_overlay

	if(!inverted)
		var/mutable_appearance/power_overlay = mutable_appearance(icon, "torch_on")
		. += power_overlay
	else
		var/mutable_appearance/inverted_overlay = mutable_appearance(icon, "torch_inverted")
		. += inverted_overlay

/obj/structure/redstone/torch/AltClick(mob/user, list/modifiers)
	if(!Adjacent(user))
		return
	attached_dir = turn(attached_dir, 90)
	dir = attached_dir
	to_chat(user, "<span class='notice'>You rotate the [name] to attach to the [dir2text_readable(attached_dir)] side.</span>")
	schedule_network_update()

/obj/structure/redstone/torch/proc/dir2text_readable(direction)
	switch(direction)
		if(NORTH) return "north"
		if(SOUTH) return "south"
		if(EAST) return "east"
		if(WEST) return "west"
	return "unknown"

/obj/structure/redstone/torch/examine(mob/user)
	. = ..()
	. += "It is attached to the [dir2text_readable(attached_dir)] side."
	. += inverted ? "The torch is inverted (off)." : "The torch is providing power."
