/obj/structure/redstone
	name = "redstone component"
	desc = "A component of a redstone wire network."
	icon = 'icons/obj/redstone.dmi'
	anchored = TRUE
	density = FALSE

	var/power = 0
	var/max_power = 15

	// true for things that generate power independent of neighbor state
	var/is_source = FALSE

	var/unpowered_color = "#4A3B3B"
	var/powered_color = "#FF2200"

/obj/structure/redstone/Initialize(mapload)
	. = ..()
	update_power_color()
	update_appearance(UPDATE_ICON)
	mark_network_dirty()

/obj/structure/redstone/Destroy()
	// neighbor turfs have to be captured BEFORE calling the parent,
	// since get_step() needs src to still have a valid loc atleast I think? GC is weird
	var/turf/T = get_turf(src)
	var/list/turf/neighbor_turfs = list()
	for(var/direction in GLOB.cardinals)
		var/turf/NT = get_step(src, direction)
		if(NT)
			neighbor_turfs += NT
	. = ..()
	if(T)
		SSredstone.mark_area_dirty(T)
	for(var/turf/NT as anything in neighbor_turfs)
		SSredstone.mark_area_dirty(NT)

/obj/structure/redstone/setDir(newdir)
	var/old_dir = dir
	. = ..()
	if(old_dir == dir)
		return
	var/turf/old_front = get_step(src, old_dir)
	var/turf/old_back = get_step(src, REVERSE_DIR(old_dir))
	SSredstone.mark_area_dirty(old_front)
	SSredstone.mark_area_dirty(old_back)
	update_appearance(UPDATE_ICON)
	mark_network_dirty()

/obj/structure/redstone/proc/get_neighbors()
	var/list/obj/structure/redstone/L = list()
	for(var/direction in GLOB.cardinals)
		var/turf/T = get_step(src, direction)
		if(!T)
			continue
		for(var/obj/structure/redstone/R in T)
			if(R != src)
				L += R
	return L

/obj/structure/redstone/proc/get_local_source_power()
	var/turf/T = get_turf(src)
	if(!T)
		return 0
	var/max_p = 0
	for(var/obj/structure/S in T)
		if(S == src)
			continue
		max_p = max(max_p, S.get_redstone_output())
	return max_p

/// Marks this node's own tile AND every adjacent tile dirty.
/obj/structure/redstone/proc/mark_network_dirty()
	var/turf/T = get_turf(src)
	if(T)
		SSredstone.mark_area_dirty(T)
	for(var/direction in GLOB.cardinals)
		SSredstone.mark_area_dirty(get_step(src, direction))

/// Marks self and every CURRENTLY adjacent redstone node dirty for
/// next tick. Only use for power state changes pretty much.
/obj/structure/redstone/proc/propagate_dirty()
	var/turf/T = get_turf(src)
	if(T)
		SSredstone.mark_area_dirty(T)
	for(var/direction in GLOB.cardinals)
		var/turf/NT = get_step(src, direction)
		if(NT)
			SSredstone.mark_area_dirty(NT)

/// Sets power, updates the sprite, and wakes up neighbors if needed
/obj/structure/redstone/proc/set_power(new_power)
	new_power = clamp(new_power, 0, max_power)
	if(new_power == power)
		return FALSE
	power = new_power
	update_power_color()
	update_appearance(UPDATE_ICON)
	propagate_dirty()
	return TRUE

///this just tints the sprite to a redstone power color
/obj/structure/redstone/proc/update_power_color()
	var/frac = clamp(power / max_power, 0, 1)
	var/r1 = hex2num(copytext(unpowered_color, 2, 4))
	var/g1 = hex2num(copytext(unpowered_color, 4, 6))
	var/b1 = hex2num(copytext(unpowered_color, 6, 8))
	var/r2 = hex2num(copytext(powered_color, 2, 4))
	var/g2 = hex2num(copytext(powered_color, 4, 6))
	var/b2 = hex2num(copytext(powered_color, 6, 8))
	var/r = round(r1 + (r2 - r1) * frac)
	var/g = round(g1 + (g2 - g1) * frac)
	var/b = round(b1 + (b2 - b1) * frac)
	color = rgb(r, g, b)

/// Recalculates power from current inputs. Overridden per subtype.
/obj/structure/redstone/proc/recompute_power()
	return

/// What power this node presents to a neighbor asking for it.
/obj/structure/redstone/proc/get_output_toward(atom/asker)
	return power

/// For components that don't tint their whole sprite
/obj/structure/redstone/proc/powered_overlay(overlay_state)
	var/mutable_appearance/O = mutable_appearance(icon, overlay_state)
	O.color = power > 0 ? powered_color : unpowered_color
	return O
