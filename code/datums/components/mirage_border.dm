/datum/component/mirage_border
	can_transfer = TRUE
	var/obj/effect/abstract/mirage_holder/holder
	var/turf/target_turf // Store the target turf
	var/mirage_direction // Store the direction
	var/allow_movement = TRUE // Allow crossing the mirage border
	var/list/turf/above_turfs = list() // Store turfs above for signal cleanup

/datum/component/mirage_border/Initialize(turf/target, direction, range=world.view, allow_move = TRUE)
	if(!isturf(parent))
		return COMPONENT_INCOMPATIBLE
	if(!target || !istype(target) || !direction)
		. = COMPONENT_INCOMPATIBLE
		CRASH("[type] improperly instanced with the following args: target=\[[target]\], direction=\[[direction]\], range=\[[range]\]")

	target_turf = target
	mirage_direction = direction
	allow_movement = allow_move
	holder = new(parent)

	var/x = target.x
	var/y = target.y
	var/z = target.z

	var/turf/southwest = locate(CLAMP(x - (direction & WEST ? range : 0), 1, world.maxx), CLAMP(y - (direction & SOUTH ? range : 0), 1, world.maxy), CLAMP(z, 1, world.maxz))
	var/turf/northeast = locate(CLAMP(x + (direction & EAST ? range : 0), 1, world.maxx), CLAMP(y + (direction & NORTH ? range : 0), 1, world.maxy), CLAMP(z, 1, world.maxz))

	for(var/turf/i as anything in block(southwest, northeast))
		holder.vis_contents += i

	if(direction & SOUTH)
		holder.pixel_y -= world.icon_size * range
	if(direction & WEST)
		holder.pixel_x -= world.icon_size * range

	// Register signals for movement
	if(allow_movement)
		RegisterSignal(parent, COMSIG_ATOM_ENTERED, PROC_REF(on_entered))
		RegisterSignal(parent, COMSIG_ATOM_EXITED, PROC_REF(on_exited))

		// Register signals on turfs above
		var/turf/current_turf = parent
		var/turf/check_turf = current_turf
		while(check_turf)
			check_turf = GET_TURF_ABOVE(check_turf)
			if(check_turf)
				above_turfs += check_turf
				RegisterSignal(check_turf, COMSIG_ATOM_ENTERED, PROC_REF(on_entered_from_above))

/datum/component/mirage_border/Destroy()
	target_turf = null
	above_turfs = null
	QDEL_NULL(holder)
	return ..()

/datum/component/mirage_border/PreTransfer()
	holder.moveToNullspace()

/datum/component/mirage_border/PostTransfer()
	if(!isturf(parent))
		return COMPONENT_INCOMPATIBLE
	holder.forceMove(parent)

// When something enters this turf
/datum/component/mirage_border/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc)
	SIGNAL_HANDLER

	if(!ismob(arrived) && !isobj(arrived))
		return

	var/turf/old_turf = get_turf(old_loc)
	var/turf/current_turf = get_turf(arrived)

	if(!old_turf || !current_turf)
		return

	// Check if they're moving in the direction of the mirage
	if(!is_moving_toward_mirage(old_turf, current_turf))
		return

	// Teleport them to the target turf
	attempt_mirage_crossing(arrived, FALSE)

// When something exits this turf
/datum/component/mirage_border/proc/on_exited(datum/source, atom/movable/gone, direction)
	SIGNAL_HANDLER

	if(!ismob(gone) && !isobj(gone))
		return

	// Check if they're moving in the direction of the mirage
	if(direction != mirage_direction)
		return

	// Teleport them to the target turf
	attempt_mirage_crossing(gone, FALSE)

// When something enters from a turf above
/datum/component/mirage_border/proc/on_entered_from_above(datum/source, atom/movable/arrived, atom/old_loc)
	SIGNAL_HANDLER

	if(!ismob(arrived) && !isobj(arrived))
		return

	var/turf/arrival_turf = get_turf(arrived)
	if(!arrival_turf || !(arrival_turf in above_turfs))
		return

	// Check if they're at the same x,y as the parent border turf
	var/turf/border_turf = parent
	if(arrival_turf.x != border_turf.x || arrival_turf.y != border_turf.y)
		return

	// Teleport to target + 1 z-level
	attempt_mirage_crossing(arrived, TRUE)

// Helper to check if movement is toward the mirage
/datum/component/mirage_border/proc/is_moving_toward_mirage(turf/old_turf, turf/new_turf)
	if(!old_turf || !new_turf)
		return FALSE

	// Only check same z-level movement
	if(old_turf.z != new_turf.z)
		return FALSE

	// Calculate direction of movement
	var/dx = new_turf.x - old_turf.x
	var/dy = new_turf.y - old_turf.y

	// Check if movement aligns with mirage direction
	if(mirage_direction & NORTH && dy > 0)
		return TRUE
	if(mirage_direction & SOUTH && dy < 0)
		return TRUE
	if(mirage_direction & EAST && dx > 0)
		return TRUE
	if(mirage_direction & WEST && dx < 0)
		return TRUE

	return FALSE

// Teleport the atom to the target turf
/datum/component/mirage_border/proc/attempt_mirage_crossing(atom/movable/crosser, from_above = FALSE)
	if(!target_turf || !crosser)
		return FALSE

	var/turf/current = get_turf(crosser)
	if(current == target_turf)
		return FALSE

	var/turf/destination
	if(from_above)
		destination = locate(target_turf.x, target_turf.y, CLAMP(target_turf.z + 1, 1, world.maxz))
		if(!destination)
			destination = target_turf
	else
		destination = target_turf

	// Calculate pixel offset based on movement direction
	var/pixel_offset = world.icon_size
	var/initial_pixel_x = 0
	var/initial_pixel_y = 0

	if(mirage_direction & NORTH)
		initial_pixel_y = -pixel_offset
	else if(mirage_direction & SOUTH)
		initial_pixel_y = pixel_offset

	if(mirage_direction & EAST)
		initial_pixel_x = -pixel_offset
	else if(mirage_direction & WEST)
		initial_pixel_x = pixel_offset

	// Determine glide time
	var/glide_time = crosser.glide_size || world.icon_size
	if(ismob(crosser))
		var/mob/M = crosser
		if(M.client?.glide_size)
			glide_time = M.client.glide_size

	// Set pixel offset BEFORE teleporting
	crosser.pixel_x += initial_pixel_x
	crosser.pixel_y += initial_pixel_y

	// Handle client eye animation if it's a mob with a client
	var/client/C
	if(ismob(crosser))
		var/mob/M = crosser
		C = M.client
		if(C)
			// Offset the client's eye position
			C.pixel_x += initial_pixel_x
			C.pixel_y += initial_pixel_y

	// Teleport to destination
	crosser.forceMove(destination)

	if(isliving(crosser))
		var/mob/living/M = crosser
		if(!M.client)
			M.force_island_check()

	// Animate both the mob and client back to normal
	animate(crosser, pixel_x = crosser.pixel_x - initial_pixel_x, pixel_y = crosser.pixel_y - initial_pixel_y, time = glide_time, flags = ANIMATION_PARALLEL)

	if(C)
		animate(C, pixel_x = C.pixel_x - initial_pixel_x, pixel_y = C.pixel_y - initial_pixel_y, time = glide_time, flags = ANIMATION_PARALLEL)
		to_chat(C, span_notice("You cross through the mirage..."))

	return TRUE

/obj/effect/abstract/mirage_holder
	name = "Mirage holder"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_PLANE | VIS_HIDE
