//!! IMPORTANT: spawn() is used here for a very specific reason, we want propagation inside networks to essentially always be a tick apart per updating source
/obj/structure/redstone
	name = "redstone component"
	icon = 'icons/obj/redstone.dmi'
	anchored = TRUE
	density = FALSE
	var/powered = FALSE
	var/power_level = 0 // 0-15 for redstone dust
	var/list/connected_components = list()
	var/list/wire_connections = list("2" = 0, "1" = 0, "8" = 0, "4" = 0) // NSEW
	var/can_connect_wires = TRUE
	var/send_wall_power = TRUE // Control whether this component can send power through walls
	var/list/power_sources = list() // Track all power sources and their strengths
	var/list/power_update_queue = list() // Prevent infinite loops during updates
	var/updating_power = FALSE

/obj/structure/redstone/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/redstone/LateInitialize()
	. = ..()
	if(can_connect_wires)
		update_wire_connections()
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/redstone/Destroy()
	. = ..()
	// Clean up connections when destroyed
	for(var/obj/structure/redstone/component in connected_components)
		component.connected_components -= src
		component.clear_power_source(src) // Remove us as a power source
		component.update_wire_connections()
		component.update_appearance(UPDATE_OVERLAYS)

/obj/structure/redstone/proc/update_wire_connections()
	if(!can_connect_wires)
		return

	// Reset connections
	for(var/dir in wire_connections)
		wire_connections[dir] = 0
	connected_components = list()

	// Check all cardinal directions
	for(var/direction in GLOB.cardinals)
		var/turf/target_turf = get_step(src, direction)
		for(var/obj/structure/redstone/component in target_turf)
			if(!component.can_connect_wires)
				continue

			var/connection_dir = get_dir(src, component)
			if(can_connect_to(component, connection_dir))
				wire_connections["[connection_dir]"] = 1
				connected_components += component

				// Update the other component's connection too
				var/reverse_dir = get_dir(component, src)
				if(component.can_connect_to(src, reverse_dir))
					component.wire_connections["[reverse_dir]"] = 1
					component.connected_components |= src
					component.update_appearance(UPDATE_OVERLAYS)

/obj/structure/redstone/proc/can_connect_to(obj/structure/redstone/other, dir)
	return TRUE // Override in subclasses for specific connection rules

/obj/structure/redstone/proc/set_power(new_power_level, mob/user, obj/structure/redstone/source)
	if(updating_power)
		return

	updating_power = TRUE

	if(source)
		if(new_power_level > 0)
			power_sources[ref(source)] = source
		else
			power_sources -= ref(source)
	else
		if(new_power_level > 0)
			power_sources["direct"] = new_power_level
		else
			power_sources -= "direct"

	var/max_power = 0

	// Check direct power
	if("direct" in power_sources)
		max_power = max(max_power, power_sources["direct"])

	for(var/source_key in power_sources)
		if(source_key == "direct")
			continue
		var/obj/structure/redstone/source_obj = power_sources[source_key]
		if(source_obj && !QDELETED(source_obj))
			var/received_power = calculate_received_power(source_obj)
			max_power = max(max_power, received_power)
		else
			power_sources -= source_key

	if(max_power != power_level)
		power_level = max_power
		powered = (power_level > 0)
		update_appearance(UPDATE_OVERLAYS)
		propagate_power(user, source)

	updating_power = FALSE


/obj/structure/redstone/proc/calculate_received_power(obj/structure/redstone/source_obj)
	// Default: receive the source's current power level
	return source_obj.power_level


/obj/structure/redstone/proc/propagate_power(mob/user, obj/structure/redstone/source)
	// Default behavior: send power in all directions
	var/list/power_directions = get_power_directions()
	for(var/direction in power_directions)
		send_power_in_direction(direction, user, source)

/obj/structure/redstone/proc/get_power_directions()
	// Default: send power in all cardinal directions
	return GLOB.cardinals

/obj/structure/redstone/proc/get_input_directions()
	// Default: allows power in from any cardinal direction
	return GLOB.cardinals

/obj/structure/redstone/proc/send_power_in_direction(direction, mob/user, obj/structure/redstone/source)
	var/turf/target_turf = get_step(src, direction)

	// Send power to regular redstone components
	for(var/obj/structure/redstone/component in target_turf)
		if(component == source)
			continue // Don't send power back to the source

		if(!component.can_connect_wires)
			continue

		if(!component.can_connect_to(src, turn(direction, 180)))
			continue

		// Add to update queue to prevent infinite loops
		if(!(component in power_update_queue))
			power_update_queue += component
			spawn(1)
				power_update_queue -= component
				component.receive_power(power_level, src, user)

	// Send power through walls if enabled
	if(send_wall_power && isclosedturf(target_turf))
		send_wall_power_in_direction(direction, target_turf, user, source)

/obj/structure/redstone/proc/send_wall_power_in_direction(direction, turf/wall_turf, mob/user, obj/structure/redstone/source)
	for(var/check_direction in GLOB.cardinals)
		if(check_direction == REVERSE_DIR(direction))
			continue
		var/turf/beyond_wall = get_step(wall_turf, check_direction)

		for(var/obj/structure/redstone/component in beyond_wall)
			if(istype(component, /obj/structure/redstone/torch))
				var/obj/structure/redstone/torch/torch = component
				// Check if this torch is attached to the wall we're powering through
				if(torch.attached_dir == turn(check_direction, 180)) // Torch attached to the wall we're behind
					// Send power to invert the torch
					if(!(torch in power_update_queue))
						power_update_queue += torch
						spawn(1)
							power_update_queue -= torch
							torch.receive_power(power_level, src, user)
			else
				if(direction in component.get_input_directions())
					if(!(component in power_update_queue))
						power_update_queue += component
						spawn(1)
							power_update_queue -= component
							component.receive_power(power_level, src, user)


/obj/structure/redstone/proc/receive_power(incoming_power, obj/structure/redstone/source, mob/user)
	// Default behavior - just pass through the power
	set_power(incoming_power, user, source)

/obj/structure/redstone/proc/clear_power_source(obj/structure/redstone/source)
	// Remove a specific power source
	if(source)
		power_sources -= ref(source)
	else
		power_sources -= "direct"

	var/max_power = 0

	// Check direct power
	if("direct" in power_sources)
		max_power = max(max_power, power_sources["direct"])

	// Check object sources by looking at their CURRENT power level
	for(var/source_key in power_sources)
		if(source_key == "direct")
			continue
		var/obj/structure/redstone/source_obj = power_sources[source_key]
		if(source_obj && !QDELETED(source_obj))
			var/received_power = calculate_received_power(source_obj)
			max_power = max(max_power, received_power)
		else
			power_sources -= source_key

	if(max_power != power_level)
		set_power(max_power, null, null)

/obj/structure/redstone/redstone_triggered(mob/user) //this is essentially legacy code
	set_power(15, user, null) // External trigger acts as temporary power source

	spawn(2)
		clear_power_source(null)

/obj/structure/redstone/update_overlays()
	. = ..()
	if(!can_connect_wires)
		return

	// Create wire overlay pattern
	var/wire_pattern = ""
	for(var/dir in wire_connections)
		if(wire_connections[dir])
			wire_pattern += dir

	if(wire_pattern)
		var/mutable_appearance/wire_overlay = mutable_appearance(icon, "wire_[wire_pattern]")
		wire_overlay.layer = layer - 0.01
		if(powered)
			wire_overlay.color = "#FF0000" // Red when powered
		else
			wire_overlay.color = "#8B4513" // Brown when unpowered
		. += wire_overlay
	else
		var/mutable_appearance/wire_overlay = mutable_appearance(icon, "wire")
		wire_overlay.layer = layer - 0.01
		if(powered)
			wire_overlay.color = "#FF0000" // Red when powered
		else
			wire_overlay.color = "#8B4513" // Brown when unpowered
		. += wire_overlay
