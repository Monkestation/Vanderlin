
/obj/structure/redstone/dust
	name = "redstone dust"
	desc = "A trail of glowing dust that carries a signal between components."
	icon_state = "wire"

	//this like the other connected lists NEEDS to be in this order or icons break
	var/list/connected = list("2" = FALSE, "1" = FALSE, "8" = FALSE, "4" = FALSE)

/obj/structure/redstone/dust/recompute_power()
	var/turf/my_turf = get_turf(src)
	var/best = my_turf ? my_turf.get_redstone_power_output(src) : 0

	for(var/direction in GLOB.cardinals)
		var/turf/NT = get_step(src, direction)
		if(!NT)
			continue
		for(var/obj/structure/redstone/dust/D in NT)
			best = max(best, D.power - 1)
		for(var/obj/structure/redstone/R in NT)
			if(!istype(R, /obj/structure/redstone/dust))
				best = max(best, R.get_output_toward(src))

	set_power(max(best, 0))
	update_appearance(UPDATE_ICON)

/// Dust visually links to anything redstone,
/// not just other dust. Same logic as water and shit.
/obj/structure/redstone/dust/proc/refresh_connections()
	for(var/direction in list(SOUTH, NORTH, WEST, EAST))
		var/turf/T = get_step(src, direction)
		var/has_link = FALSE
		if(T)
			for(var/obj/structure/redstone/R in T)
				has_link = TRUE
				break
		connected["[direction]"] = has_link

/obj/structure/redstone/dust/update_icon_state()
	. = ..()
	refresh_connections()
	var/state_suffix = ""
	for(var/key in connected)
		if(connected[key])
			state_suffix += key
	icon_state = state_suffix ? "wire_[state_suffix]" : "wire"
