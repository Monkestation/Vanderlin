/datum/move_loop/minecart
	var/direction
	var/aerial_distance
	var/aerial_velocity

/datum/move_loop/minecart/setup(delay, timeout, dir)
	. = ..()
	if(!.)
		return
	direction = dir

/datum/move_loop/minecart/Destroy()
	if(!QDELETED(moving) && istype(moving, /obj/structure/closet/crate/miningcar))
		var/turf/moving_turf = get_turf(moving)
		if(istype(moving_turf, /turf/open/openspace))
			var/obj/structure/closet/crate/miningcar/minecart = moving
			minecart.handle_aerial_fall(freefall = TRUE)
	. = ..()

/datum/move_loop/minecart/process()
	. = ..()
	if(QDELETED(src) || QDELETED(moving))
		return
	var/turf/moving_turf = get_turf(moving)
	if(istype(moving_turf, /turf/open/openspace))
		aerial_velocity += (delay / 10) * 9.8
		aerial_distance += aerial_velocity * (delay / 10)
		if(aerial_distance >= 1)
			aerial_distance -= 1
			if(istype(moving, /obj/structure/closet/crate/miningcar))
				var/obj/structure/closet/crate/miningcar/minecart = moving
				minecart.handle_aerial_fall()
	else
		aerial_distance = 0
		aerial_velocity = 0

/datum/move_loop/minecart/move()
	var/atom/old_loc = moving.loc
	var/turf/new_loc = get_step(moving, direction)
	if(locate(/obj/structure/minecart_rail) in old_loc)
		if(istype(new_loc, /turf/open/openspace))
			var/turf/below_turf = GET_TURF_BELOW(new_loc)
			if(locate(/obj/structure/minecart_rail) in below_turf)
				new_loc = below_turf
		else if(!(locate(/obj/structure/minecart_rail) in new_loc))
			var/turf/above_turf = GET_TURF_ABOVE(new_loc)
			if(locate(/obj/structure/minecart_rail) in above_turf)
				new_loc = above_turf

	moving.Move(new_loc, direction)
	// We cannot rely on the return value of Move(), we care about teleports and it doesn't
	return old_loc != moving.loc

