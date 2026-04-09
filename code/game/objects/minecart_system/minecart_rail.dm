
/obj/structure/minecart_rail
	name = "cart rail"
	desc = "Carries carts along the track."
	icon = 'icons/obj/track.dmi'
	icon_state = "track"
	//layer = TRAM_RAIL_LAYER
	plane = FLOOR_PLANE
	anchored = TRUE
	move_resist = INFINITY

	rotation_structure = TRUE
	redstone_structure = TRUE
	initialize_dirs = CONN_DIR_LEFT | CONN_DIR_RIGHT

	var/secondary_direction

	var/static/list/directions = list(
		"Downwards Left Turn" = SOUTHWEST,
		"Downwards Right Turn" = SOUTHEAST,
		"Upwards Left Turn" = NORTHWEST,
		"Upwards Right Turn" = NORTHEAST,
		"Up and Down" = NORTH,
		"Left and Right" = WEST,
	)
	/// Bitflag of directions that a minecart ON this rail can travel to
	var/minecart_dirs

/obj/structure/minecart_rail/Initialize(mapload)
	. = ..()
	//AddElement(/datum/element/give_turf_traits, string_list(list(TRAIT_TURF_IGNORE_SLOWDOWN)))
	//AddElement(/datum/element/footstep_override, footstep = FOOTSTEP_CATWALK)
	set_minecart_dirs(initial = TRUE)

/obj/structure/minecart_rail/LateInitialize()
	. = ..()
	for(var/obj/structure/closet/crate/miningcar/cart in loc)
		cart.update_rail_state(TRUE)
	set_minecart_dirs()

/obj/structure/minecart_rail/setDir(newdir)
	. = ..()
	set_minecart_dirs()

/obj/structure/minecart_rail/proc/set_minecart_dirs(initial)
	var/turf/our_turf = get_turf(src)
	switch(dir)
		if(NORTH, SOUTH)
			minecart_dirs = NORTH | SOUTH
		if(WEST, EAST)
			minecart_dirs = EAST | WEST
		if(SOUTHWEST)
			minecart_dirs = NORTH | WEST
		if(SOUTHEAST)
			minecart_dirs = NORTH | EAST
		if(NORTHWEST)
			minecart_dirs = SOUTH | WEST
		if(NORTHEAST)
			minecart_dirs = SOUTH | EAST

	if(initial)
		return

	for(var/direction in GLOB.cardinals)
		if(!(direction & minecart_dirs))
			continue
		var/turf/above_turf = GET_TURF_ABOVE(our_turf)
		var/turf/step_up = get_step(above_turf, direction)
		var/turf/step_side = get_step(src, direction)
		var/turf/step_down = GET_TURF_BELOW(step_side)
		var/found = FALSE

		if(step_up && istype(above_turf, /turf/open/openspace))
			for(var/obj/structure/minecart_rail/rail in step_up.contents)
				if(!(REVERSE_DIR(direction) & rail.minecart_dirs))
					continue
				if(dir == WEST || dir == EAST)
					dir = direction
					set_minecart_dirs(initial = TRUE)
					pixel_y = base_pixel_y + 7
				icon_state = "vertical_track"
				found = TRUE
				break

		if(!found && step_down && istype(step_side, /turf/open/openspace))
			for(var/obj/structure/minecart_rail/rail in step_down.contents)
				if(!(REVERSE_DIR(direction) & rail.minecart_dirs))
					continue
				if(dir == WEST || dir == EAST)
					rail.pixel_y = rail.base_pixel_y + 7
				rail.icon_state = "vertical_track"
				break

/obj/structure/minecart_rail/redstone_triggered(mob/user)
	. = ..()
	if(!secondary_direction)
		return
	var/last_direction = secondary_direction
	secondary_direction = dir
	setDir(last_direction)

/obj/structure/minecart_rail/attackby_secondary(obj/item/I, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(I?.tool_behaviour == TOOL_MULTITOOL)
		rotate_direction(user)
		return

	var/choice = browser_input_list(user, "Choose a direction to cycle to when activated by a trigger.", src, list("Downwards Left Turn", "Downwards Right Turn", "Upwards Left Turn", "Upwards Right Turn", "Up and Down", "Left and Right"))
	if(!choice || QDELETED(user) || QDELETED(src))
		return

	secondary_direction = directions[choice]

/obj/structure/minecart_rail/proc/rotate_direction(mob/user)
	var/choice = browser_input_list(user, "Rotate the rail towards a direction.", src, list("Downwards Left Turn", "Downwards Right Turn", "Upwards Left Turn", "Upwards Right Turn", "Up and Down", "Left and Right"))
	if(!choice)
		return

	playsound(src, 'sound/misc/ratchet.ogg', 20, TRUE)
	setDir(directions[choice])

/obj/structure/minecart_rail/update_animation_effect()
	. = ..()
	if(rotations_per_minute)
		icon_state = "track_shaft"
	else
		icon_state = "track"

/obj/structure/minecart_rail/find_rotation_network()
	if(ISDIAGONALDIR(dir))
		return
	for(var/direction in GLOB.cardinals)
		if(!(direction & dpdir))
			continue
		var/turf/step_back = get_step(src, direction)
		for(var/obj/structure/structure in step_back.contents)
			if(!structure.rotation_network)
				continue
			if(istype(structure, /obj/structure/minecart_rail))
				if(!(REVERSE_DIR(direction) & structure.dpdir))
					continue

			if(rotation_network)
				if(!structure.try_network_merge(src))
					rotation_break()
			else
				if(!structure.try_connect(src))
					rotation_break()

	if(!rotation_network)
		rotation_network = new
		rotation_network.add_connection(src)
		last_stress_added = 0
		set_stress_use(stress_use)

/obj/structure/minecart_rail/return_surrounding_rotation(datum/rotation_network/network)
	if(!(dir in GLOB.cardinals))
		return list()
	. = ..()

/obj/structure/minecart_rail/find_and_propagate(list/checked, first = FALSE)
	if(!length(checked))
		checked = list()
	checked |= src
	if(ISDIAGONALDIR(dir))
		return checked
	. = ..()

/obj/structure/minecart_rail/set_rotations_per_minute(speed)
	. = ..()
	if(!.)
		return
	set_stress_use(32 * (speed / 8))

/obj/structure/minecart_rail/examine(mob/user)
	. = ..()
	. += rail_examine()
	if(secondary_direction)
		. += span_smallnotice("When activated, this rail will switch to [dir2text(secondary_direction)].")

/obj/structure/minecart_rail/proc/rail_examine()
	return span_notice("Connect this rail to shafts to give momentum to carts that pass over.")

/obj/structure/minecart_rail/set_connection_dir()
	if(ISDIAGONALDIR(dir))
		dpdir = NONE
		return
	. = ..()

/obj/structure/minecart_rail/railbreak
	name = "cart rail brake"
	desc = "Stops carts in their tracks. On the tracks. Requires rotational power to function."
	icon_state = "track_break"
	can_buckle = TRUE
	buckle_requires_restraints = TRUE
	var/force_disabled = FALSE
	//buckle_lying = NO_BUCKLE_LYING

/obj/structure/minecart_rail/railbreak/rail_examine()
	return span_notice("Connect this rail to shafts to stop carts that pass over it. Currently [force_disabled ? "disabled" : (rotations_per_minute ? "powered" : "unpowered")].")

/obj/structure/minecart_rail/railbreak/redstone_triggered(mob/user)
	force_disabled = !force_disabled

/obj/structure/minecart_rail/railbreak/update_animation_effect()
	. = ..()
	icon_state = initial(icon_state)

/obj/structure/minecart_rail/railbreak/set_minecart_dirs(initial)
	. = ..()
	icon_state = initial(icon_state)
