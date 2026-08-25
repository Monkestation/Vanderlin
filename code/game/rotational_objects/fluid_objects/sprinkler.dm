/obj/structure/sprinkler
	name = "sprinkler"
	desc = "A sprinkler head that distributes water over crops."
	icon = 'icons/roguetown/misc/pipes.dmi'
	icon_state = "sprinkler"
	density = FALSE
	layer = ABOVE_OBJ_LAYER
	plane = GAME_PLANE
	damage_deflection = 3
	blade_dulling = DULLING_BASHCHOP
	attacked_sound = list('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg')
	smeltresult = /obj/item/ingot/bronze
	obj_flags = CAN_BE_HIT
	accepts_water_input = TRUE

	var/obj/structure/water_pipe/connected_pipe
	var/datum/reagent/current_reagent
	var/water_pressure = 0
	var/active = FALSE
	var/spray_range = 2
	var/min_pressure_required = 2
	var/last_spray_time = 0
	var/spray_delay = 10 SECONDS

/obj/structure/sprinkler/Initialize()
	. = ..()
	var/turf/our_turf = get_turf(src)
	for(var/obj/structure/water_pipe/pipe in our_turf)
		connected_pipe = pipe
		break

	if(!connected_pipe)
		for(var/direction in GLOB.cardinals)
			var/turf/adjacent_turf = get_step(src, direction)
			for(var/obj/structure/water_pipe/pipe in adjacent_turf)
				connected_pipe = pipe
				break
			if(connected_pipe)
				break

	if(connected_pipe)
		START_PROCESSING(SSobj, src)
	else
		visible_message(span_warning("[src] needs to be placed on or near a water pipe!"))

/obj/structure/sprinkler/Destroy()
	STOP_PROCESSING(SSobj, src)
	connected_pipe = null
	return ..()

/obj/structure/sprinkler/process(seconds_per_tick)
	if(!connected_pipe || QDELETED(connected_pipe))
		active = FALSE
		current_reagent = null
		water_pressure = 0
		return

	current_reagent = connected_pipe.carrying_reagent
	water_pressure = connected_pipe.water_pressure

	var/should_be_active = (water_pressure >= min_pressure_required && current_reagent)

	if(should_be_active != active)
		active = should_be_active
		update_appearance(UPDATE_OVERLAYS)
		if(active)
			visible_message(span_notice("[src] begins spraying [initial(current_reagent.name)]!"))
		else
			visible_message(span_notice("[src] stops spraying."))

	if(active && world.time > last_spray_time + spray_delay)
		spray_water()
		last_spray_time = world.time

/obj/structure/sprinkler/proc/spray_water(seconds_per_tick)
	if(!active || !current_reagent || !connected_pipe)
		return

	connected_pipe.use_pressure(seconds_per_tick)

	var/turf/center = get_turf(src)
	var/obj/effect/temp_visual/sprinkler/effect = new /obj/effect/temp_visual/sprinkler(center)
	var/datum/reagent/pipe_reagent = connected_pipe.carrying_reagent
	effect.color = initial(pipe_reagent.color)

	var/datum/reagent/faux_reagent = new pipe_reagent
	faux_reagent.on_aeration(water_pressure, get_turf(src))

	// Get all turfs within range
	for(var/turf/T in range(spray_range, center))
		// Skip our own turf
		if(T == center)
			continue

		var/datum/reagents/splash_holder
		if(can_spray_reach(center, T))
			for(var/mob/living/mob in T.contents)
				if(!splash_holder)
					splash_holder = new/datum/reagents(FLOOR(water_pressure * 0.5, 1))
					splash_holder.my_atom = src
					splash_holder.add_reagent(pipe_reagent, FLOOR(water_pressure * 0.5, 1))
				splash_holder.reaction(mob, TOUCH, 1)
			for(var/obj/structure/soil/crop in T)
				crop.adjust_water(water_pressure * 2)

/obj/structure/sprinkler/proc/can_spray_reach(turf/start, turf/target)
	var/list/path_turfs = getline(start, target)
	// Remove the starting turf (sprinkler location)
	path_turfs -= start

	for(var/turf/T in path_turfs)
		if(T.density)
			return FALSE

		for(var/atom/movable/A in T)
			if(ismob(A))
				continue
			if(A.density)
				return FALSE

		if(T == target)
			return TRUE

	return TRUE

/obj/structure/sprinkler/return_rotation_chat()
	var/status = active ? "Active" : "Inactive"
	var/reagent_name = current_reagent ? initial(current_reagent.name) : "None"

	return "Status: [status]\n\
			Pressure: [water_pressure]\n\
			Fluid: [reagent_name]\n\
			Range: [spray_range] tiles"

/obj/structure/sprinkler/examine(mob/user)
	. = ..()
	if(connected_pipe)
		. += span_info("Connected to a water pipe.")
	else
		. += span_warning("Not connected to any water pipe!")

	if(active)
		. += span_notice("The sprinkler is currently active and spraying [initial(current_reagent.name)].")
	else if(water_pressure < min_pressure_required)
		. += span_warning("Insufficient water pressure. Needs at least [min_pressure_required] pressure.")
	else
		. += span_notice("The sprinkler is inactive.")

/obj/effect/temp_visual/sprinkler
	icon = 'icons/effects/96x96.dmi'
	icon_state = "sprinkle"
	duration = 4 SECONDS
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -32
	pixel_y = -32
	alpha = 120
	fade_time = 1 SECONDS

/obj/effect/temp_visual/sprinkler/Initialize()
	. = ..()
	var/matrix/matrix = matrix()
	matrix.Scale(2)
	animate(src, transform = matrix, time = 0.5 SECONDS)
