///associative list of the form: list(lift_id = list(all lift_master datums attached to lifts of that type))
GLOBAL_LIST_EMPTY(active_lifts_by_type)

///coordinate and control movement across linked industrial_lift's. allows moving large single multitile platforms and many 1 tile platforms.
///also is capable of linking platforms across linked z levels
/datum/lift_master
	///the lift platforms we consider as part of this lift. ordered in order of lowest z level to highest z level after init.
	///(the sorting algorithm sucks btw)
	var/list/obj/structure/industrial_lift/lift_platforms

	///whether the lift handled by this lift_master datum is multitile as opposed to nxm platforms per z level
	var/multitile_platform = FALSE

	///taken from our lift platforms. if true we go through each z level of platforms and attempt to make the lowest left corner platform
	///into one giant multitile object the size of all other platforms on that z level.
	var/create_multitile_platform = FALSE

	///lift platforms have already been sorted in order of z level.
	var/z_sorted = FALSE

	///lift_id taken from our base lift platform, used to put us into GLOB.active_lifts_by_type
	var/lift_id = BASIC_LIFT_ID

	///overridable ID string to link control units to this specific lift_master datum. created by placing a lift id landmark object
	///somewhere on the tram, if its anywhere on the tram we'll find it in init and set this to whatever it specifies
	var/specific_lift_id

	///if true, the lift cannot be manually moved.
	var/controls_locked = FALSE
	///this is so cursed
	var/ignore_pathing_obstacles = FALSE
	var/list/objects_pre_alpha = list()
		///this is our held_cargo
	var/list/held_cargo = list()

/datum/lift_master/New(obj/structure/industrial_lift/lift_platform)
	lift_id = lift_platform.lift_id
	create_multitile_platform = lift_platform.create_multitile_platform

	Rebuild_lift_plaform(lift_platform)

	LAZYADDASSOCLIST(GLOB.active_lifts_by_type, lift_id, src)

	for(var/obj/structure/industrial_lift/lift as anything in lift_platforms)
		lift.add_initial_contents()

/datum/lift_master/Destroy()
	for(var/obj/structure/industrial_lift/lift_platform as anything in lift_platforms)
		lift_platform.lift_master_datum = null
	lift_platforms = null

	LAZYREMOVEASSOC(GLOB.active_lifts_by_type, lift_id, src)
	if(isnull(GLOB.active_lifts_by_type))
		GLOB.active_lifts_by_type = list()//im lazy

	return ..()

/datum/lift_master/proc/add_lift_platforms(obj/structure/industrial_lift/new_lift_platform)
	if(new_lift_platform in lift_platforms)
		return
	for(var/obj/structure/industrial_lift/other_platform in new_lift_platform.loc)
		if(other_platform != new_lift_platform)
			stack_trace("there is more than one lift platform on a tile when a lift_master adds it. this causes problems")
			qdel(other_platform)

	new_lift_platform.lift_master_datum = src
	LAZYADD(lift_platforms, new_lift_platform)
	RegisterSignal(new_lift_platform, COMSIG_PARENT_QDELETING, PROC_REF(remove_lift_platforms))

	check_for_landmarks(new_lift_platform)

	if(z_sorted)//make sure we dont lose z ordering if we get additional platforms after init
		order_platforms_by_z_level()

/datum/lift_master/proc/remove_lift_platforms(obj/structure/industrial_lift/old_lift_platform)
	SIGNAL_HANDLER

	if(!(old_lift_platform in lift_platforms))
		return

	old_lift_platform.lift_master_datum = null
	LAZYREMOVE(lift_platforms, old_lift_platform)
	UnregisterSignal(old_lift_platform, COMSIG_PARENT_QDELETING)
	if(!length(lift_platforms))
		qdel(src)

///Collect all bordered platforms via a simple floodfill algorithm. allows multiz trams because its funny
/datum/lift_master/proc/Rebuild_lift_plaform(obj/structure/industrial_lift/base_lift_platform)
	add_lift_platforms(base_lift_platform)
	var/list/possible_expansions = list(base_lift_platform)

	while(possible_expansions.len)
		for(var/obj/structure/industrial_lift/borderline as anything in possible_expansions)
			var/list/result = borderline.lift_platform_expansion(src)
			if(length(result))
				for(var/obj/structure/industrial_lift/lift_platform as anything in result)
					if(lift_platforms.Find(lift_platform))
						continue

					add_lift_platforms(lift_platform)
					possible_expansions |= lift_platform

			possible_expansions -= borderline

///check for any landmarks placed inside the locs of the given lift_platform
/datum/lift_master/proc/check_for_landmarks(obj/structure/industrial_lift/new_lift_platform)
	SHOULD_CALL_PARENT(TRUE)

	for(var/turf/platform_loc as anything in new_lift_platform.locs)
		var/obj/effect/landmark/lift_id/id_giver = locate() in platform_loc

		if(id_giver)
			set_info_from_id_landmark(id_giver)

///set vars and such given an overriding lift_id landmark
/datum/lift_master/proc/set_info_from_id_landmark(obj/effect/landmark/lift_id/landmark)
	SHOULD_CALL_PARENT(TRUE)

	if(!istype(landmark, /obj/effect/landmark/lift_id))//lift_master subtypes can want differnet id's than the base type wants
		return

	if(landmark.specific_lift_id)
		specific_lift_id = landmark.specific_lift_id

	qdel(landmark)

///orders the lift platforms in order of lowest z level to highest z level.
/datum/lift_master/proc/order_platforms_by_z_level()
	//contains nested lists for every z level in the world. why? because its really easy to sort
	var/list/platforms_by_z = list()
	platforms_by_z.len = world.maxz

	for(var/z in 1 to world.maxz)
		platforms_by_z[z] = list()

	for(var/obj/structure/industrial_lift/lift_platform as anything in lift_platforms)
		if(QDELETED(lift_platform) || !lift_platform.z)
			lift_platforms -= lift_platform
			continue

		platforms_by_z[lift_platform.z] += lift_platform

	if(create_multitile_platform)
		for(var/list/z_list as anything in platforms_by_z)
			if(!length(z_list))
				continue

			create_multitile_platform_for_z_level(z_list)//this will subtract all but one platform from the list

	var/list/output = list()

	for(var/list/z_list as anything in platforms_by_z)
		output += z_list

	lift_platforms = output

	z_sorted = TRUE

///goes through all platforms in the given list and finds the one in the lower left corner
/datum/lift_master/proc/create_multitile_platform_for_z_level(list/obj/structure/industrial_lift/platforms_in_z)
	var/min_x = INFINITY
	var/max_x = 0

	var/min_y = INFINITY
	var/max_y = 0

	var/z = 0

	for(var/obj/structure/industrial_lift/lift_to_sort as anything in platforms_in_z)
		if(!z)
			if(!lift_to_sort.z)
				stack_trace("create_multitile_platform_for_z_level() was given a platform in nullspace or not on a turf!")
				platforms_in_z -= lift_to_sort
				continue

			z = lift_to_sort.z

		if(z != lift_to_sort.z)
			stack_trace("create_multitile_platform_for_z_level() was given lifts on different z levels!")
			platforms_in_z -= lift_to_sort
			continue

		min_x = min(min_x, lift_to_sort.x)
		max_x = max(max_x, lift_to_sort.x)

		min_y = min(min_y, lift_to_sort.y)
		max_y = max(max_y, lift_to_sort.y)

	var/turf/lower_left_corner_loc = locate(min_x, min_y, z)
	if(!lower_left_corner_loc)
		CRASH("was unable to find a turf at the lower left corner of this z")

	var/obj/structure/industrial_lift/lower_left_corner_lift = locate() in lower_left_corner_loc

	if(!lower_left_corner_lift)
		CRASH("there was no lift in the lower left corner of the given lifts")

	platforms_in_z.Cut()
	platforms_in_z += lower_left_corner_lift//we want to change the list given to us not create a new one. so we do this

	lower_left_corner_lift.create_multitile_platform(min_x, min_y, max_x, max_y, z)

///returns the closest lift to the specified atom, prioritizing lifts on the same z level. used for comparing distance
/datum/lift_master/proc/return_closest_platform_to(atom/comparison, allow_multiple_answers = FALSE)
	if(!istype(comparison) || !comparison.z)
		return FALSE

	var/list/obj/structure/industrial_lift/candidate_platforms = list()

	for(var/obj/structure/industrial_lift/platform as anything in lift_platforms)
		if(platform.z == comparison.z)
			candidate_platforms += platform

	var/obj/structure/industrial_lift/winner = candidate_platforms[1]
	var/winner_distance = get_dist(comparison, winner)

	var/list/tied_winners = list(winner)

	for(var/obj/structure/industrial_lift/platform_to_sort as anything in candidate_platforms)
		var/platform_distance = get_dist(comparison, platform_to_sort)

		if(platform_distance < winner_distance)
			winner = platform_to_sort
			winner_distance = platform_distance

			if(allow_multiple_answers)
				tied_winners = list(winner)

		else if(platform_distance == winner_distance && allow_multiple_answers)
			tied_winners += platform_to_sort

	if(allow_multiple_answers)
		return tied_winners

	return winner

/// Returns a lift platform on the z-level which is vertically closest to the passed target_z
/datum/lift_master/proc/return_closest_platform_to_z(target_z)
	var/obj/structure/industrial_lift/found_platform
	for(var/obj/structure/industrial_lift/lift as anything in lift_platforms)
		// Already at the same Z-level, we can stop
		if(lift.z == target_z)
			found_platform = lift
			break

		// Set up an initial lift to compare to
		if(!found_platform)
			found_platform = lift
			continue

		// Same level, we can go with the one we currently have
		if(lift.z == found_platform.z)
			continue

		// If the difference between the current found platform and the target
		// if less than the distance between the next lift and the target,
		// our current platform is closer to the target than the next one, so we can skip it
		if(abs(found_platform.z - target_z) < abs(lift.z - target_z))
			continue

		// The difference is smaller for this lift, so it's closer
		found_platform = lift

	return found_platform

/// Returns a list of all the z-levels our lift is currently on.
/datum/lift_master/proc/get_zs_we_are_on()
	var/list/zs_we_are_present_on = list()
	for(var/obj/structure/industrial_lift/lift as anything in lift_platforms)
		zs_we_are_present_on |= lift.z
	return zs_we_are_present_on

///returns all industrial_lifts associated with this tram on the given z level or given atoms z level
/datum/lift_master/proc/get_platforms_on_level(atom/atom_reference_OR_z_level_number)
	var/z = atom_reference_OR_z_level_number
	if(isatom(atom_reference_OR_z_level_number))
		z = atom_reference_OR_z_level_number.z

	if(!isnum(z) || z < 0 || z > world.maxz)
		return null

	var/list/platforms_in_z = list()

	for(var/obj/structure/industrial_lift/lift_to_check as anything in lift_platforms)
		if(lift_to_check.z)
			platforms_in_z += lift_to_check

	return platforms_in_z

/**
 * Moves the lift UP or DOWN, this is what users invoke with their hand.
 * This is a SAFE proc, ensuring every part of the lift moves SANELY.
 *
 * Arguments:
 * going - UP or DOWN directions, where the lift should go. Keep in mind by this point checks of whether it should go up or down have already been done.
 * user - Whomever made the lift movement.
 */
/datum/lift_master/proc/move_lift_vertically(going, mob/user)
	//lift_platforms are sorted in order of lowest z to highest z, so going upwards we need to move them in reverse order to not collide
	if(going == UP)
		var/obj/structure/industrial_lift/platform_to_move
		var/current_index = length(lift_platforms)

		while(current_index > 0)
			platform_to_move = lift_platforms[current_index]
			current_index--

			platform_to_move.travel(going)

	else if(going == DOWN)
		for(var/obj/structure/industrial_lift/lift_platform as anything in lift_platforms)
			lift_platform.travel(going)

/**
 * Moves the lift after a passed delay.
 *
 * This is a more "user friendly" or "realistic" lift move.
 * It includes things like:
 * - Allowing lift "travel time"
 * - Shutting elevator safety doors
 * - Sound effects while moving
 * - Safety warnings for anyone below the lift (while it's moving downwards)
 *
 * Arguments:
 * duration - required, how long do we wait to move the lift?
 * door_duration - optional, how long should we wait to open the doors after arriving? If null, we won't open or close doors
 * direction - which direction are we moving the lift?
 * user - optional, who is moving the lift?
 */
/datum/lift_master/proc/move_after_delay(lift_move_duration, door_duration, direction, mob/user)
	if(!isnum(lift_move_duration))
		CRASH("[type] move_after_delay called with invalid duration ([lift_move_duration]).")
	if(lift_move_duration <= 0 SECONDS)
		move_lift_vertically(direction, user)
		return

	// Move the lift after a timer
	addtimer(CALLBACK(src, PROC_REF(move_lift_vertically), direction, user), lift_move_duration, TIMER_UNIQUE)


	// Here on we only care about lifts going DOWN
	if(direction != DOWN)
		return

	// Okay we're going down, let's try to display some warnings to people below
	var/list/turf/lift_locs = list()
	for(var/obj/structure/industrial_lift/going_to_move as anything in lift_platforms)
		// This lift has no warnings so we don't even need to worry about it
		if(!going_to_move.warns_on_down_movement)
			continue
		// Collect all the turfs our lift is found at
		lift_locs |= going_to_move.locs

/**
 * Simple wrapper for checking if we can move 1 zlevel, and if we can, do said move.
 * Locks controls, closes all doors, then moves the lift and re-opens the doors afterwards.
 *
 * Arguments:
 * direction - which direction are we moving?
 * lift_move_duration - how long does the move take? can be 0 or null for instant move.
 * door_duration - how long does it take for the doors to open after a move?
 * user - optional, who moved it?
 */
/datum/lift_master/proc/simple_move_wrapper(direction, lift_move_duration, mob/user)
	if(!Check_lift_move(direction))
		return FALSE

	// Lock controls, to prevent moving-while-moving memes
	set_controls(LIFT_PLATFORM_LOCKED)
	// Send out a signal that we're going
	SEND_SIGNAL(src, COMSIG_LIFT_SET_DIRECTION, direction)

	if(isnull(lift_move_duration) || lift_move_duration <= 0 SECONDS)
		// Do an instant move
		move_lift_vertically(direction, user)
		// And unlock the controls after
		set_controls(LIFT_PLATFORM_UNLOCKED)
		return TRUE

	// Do a delayed move
	move_after_delay(
		lift_move_duration = lift_move_duration,
		door_duration = lift_move_duration * 1.5,
		direction = direction,
		user = user,
	)

	addtimer(CALLBACK(src, PROC_REF(finish_simple_move_wrapper)), lift_move_duration * 1.5)
	return TRUE

/**
 * Wrap everything up from simple_move_wrapper finishing its movement
 */
/datum/lift_master/proc/finish_simple_move_wrapper()
	SEND_SIGNAL(src, COMSIG_LIFT_SET_DIRECTION, 0)
	set_controls(LIFT_PLATFORM_UNLOCKED)

/**
 * Moves the lift to the passed z-level.
 *
 * Checks for validity of the move: Are we moving to the same z-level, can we actually move to that z-level?
 * Does NOT check if the lift controls are currently locked.
 *
 * Moves to the passed z-level by calling move_after_delay repeatedly until the passed z-level is reached.
 * This proc sleeps as it moves.
 *
 * Arguments:
 * target_z - required, the Z we want to move to
 * loop_callback - optional, an additional callback invoked during the l oop that allows the move to cancel.
 * user - optional, who started the move
 */
/datum/lift_master/proc/move_to_zlevel(target_z, datum/callback/loop_callback, mob/user)
	if(!isnum(target_z) || target_z <= 0)
		CRASH("[type] move_to_zlevel was passed an invalid target_z ([target_z]).")

	var/obj/structure/industrial_lift/prime_lift = return_closest_platform_to_z(target_z)
	var/lift_z = prime_lift.z
	// We're already at the desired z-level!
	if(target_z == lift_z)
		return FALSE

	// The amount of z levels between the our and target_z
	var/z_difference = abs(target_z - lift_z)
	// Direction (up/down) needed to go to reach target_z
	var/direction = lift_z < target_z ? UP : DOWN

	// We can't go that way anymore, or possibly ever
	if(!Check_lift_move(direction))
		return FALSE

	// Okay we're ready to start moving now.
	set_controls(LIFT_PLATFORM_LOCKED)
	// Send out a signal that we're going
	SEND_SIGNAL(src, COMSIG_LIFT_SET_DIRECTION, direction)
	var/travel_speed = prime_lift.elevator_vertical_speed

	// Approach the desired z-level one step at a time
	for(var/i in 1 to z_difference)
		if(!Check_lift_move(direction))
			break
		if(loop_callback && !loop_callback.Invoke())
			break
		// move_after_delay will set up a timer and cause us to move after a time
		move_after_delay(
			lift_move_duration = travel_speed,
			direction = direction,
			user = user,
		)
		// and we don't want to send another request until the timer's done
		stoplag(travel_speed + 0.1 SECONDS)
		if(QDELETED(src) || QDELETED(prime_lift))
			return

	SEND_SIGNAL(src, COMSIG_LIFT_SET_DIRECTION, 0)
	set_controls(LIFT_PLATFORM_UNLOCKED)
	return TRUE

/**
 * Moves the lift, this is what users invoke with their hand.
 * This is a SAFE proc, ensuring every part of the lift moves SANELY.
 * It also locks controls for the (miniscule) duration of the movement, so the elevator cannot be broken by spamming.
 */
/datum/lift_master/proc/move_lift_horizontally(going)
	set_controls(LIFT_PLATFORM_LOCKED)

	if(multitile_platform)
		for(var/obj/structure/industrial_lift/platform_to_move as anything in lift_platforms)
			platform_to_move.travel(going)

		set_controls(LIFT_PLATFORM_UNLOCKED)
		return

	var/max_x = 0
	var/max_y = 0
	var/max_z = 0
	var/min_x = world.maxx
	var/min_y = world.maxy
	var/min_z = world.maxz

	for(var/obj/structure/industrial_lift/lift_platform as anything in lift_platforms)
		max_z = max(max_z, lift_platform.z)
		min_z = min(min_z, lift_platform.z)

		min_x = min(min_x, lift_platform.x)
		max_x = max(max_x, lift_platform.x)
		//this assumes that all z levels have identical horizontal bounding boxes
		//but if youre still using a non multitile tram platform at this point
		//then its your own problem. it wont runtime it will jsut be slower than it needs to be if this assumption isnt
		//the case

		min_y = min(min_y, lift_platform.y)
		max_y = max(max_y, lift_platform.y)

	for(var/z in min_z to max_z)
		//This must be safe way to border tile to tile move of bordered platforms, that excludes platform overlapping.
		if(going & WEST)
			//Go along the X axis from min to max, from left to right
			for(var/x in min_x to max_x)
				if(going & NORTH)
					//Go along the Y axis from max to min, from up to down
					for(var/y in max_y to min_y step -1)
						var/obj/structure/industrial_lift/lift_platform = locate(/obj/structure/industrial_lift, locate(x, y, z))
						lift_platform?.travel(going)

				else if(going & SOUTH)
					//Go along the Y axis from min to max, from down to up
					for(var/y in min_y to max_y)
						var/obj/structure/industrial_lift/lift_platform = locate(/obj/structure/industrial_lift, locate(x, y, z))
						lift_platform?.travel(going)

				else
					for(var/y in min_y to max_y)
						var/obj/structure/industrial_lift/lift_platform = locate(/obj/structure/industrial_lift, locate(x, y, z))
						lift_platform?.travel(going)
		else
			//Go along the X axis from max to min, from right to left
			for(var/x in max_x to min_x step -1)
				if(going & NORTH)
					//Go along the Y axis from max to min, from up to down
					for(var/y in max_y to min_y step -1)
						var/obj/structure/industrial_lift/lift_platform = locate(/obj/structure/industrial_lift, locate(x, y, z))
						lift_platform?.travel(going)

				else if (going & SOUTH)
					for(var/y in min_y to max_y)
						var/obj/structure/industrial_lift/lift_platform = locate(/obj/structure/industrial_lift, locate(x, y, z))
						lift_platform?.travel(going)

				else
					//Go along the Y axis from min to max, from down to up
					for(var/y in min_y to max_y)
						var/obj/structure/industrial_lift/lift_platform = locate(/obj/structure/industrial_lift, locate(x, y, z))
						lift_platform?.travel(going)

	set_controls(LIFT_PLATFORM_UNLOCKED)

///Check destination turfs
/datum/lift_master/proc/Check_lift_move(check_dir)
	for(var/obj/structure/industrial_lift/lift_platform as anything in lift_platforms)
		for(var/turf/bound_turf in lift_platform.locs)
			var/turf/T = get_step_multiz(lift_platform, check_dir)
			if(!T)//the edges of multi-z maps
				return FALSE
			if(check_dir == UP && !istype(T, /turf/open/openspace)) // We don't want to go through the ceiling!
				return FALSE
			if(check_dir == DOWN && !istype(get_turf(lift_platform), /turf/open/openspace)) // No going through the floor!
				return FALSE
	return TRUE

/**
 * Sets all lift parts's controls_locked variable. Used to prevent moving mid movement, or cooldowns.
 */
/datum/lift_master/proc/set_controls(state)
	controls_locked = state

/**
 * resets the contents of all platforms to their original state in case someone put a bunch of shit onto the tram.
 * intended to be called by admins. passes all arguments to reset_contents() for each of our platforms.
 *
 * Arguments:
 * * consider_anything_past - number. if > 0 our platforms will only handle foreign contents that exceed this number in each of their locs
 * * foreign_objects - bool. if true our platforms will consider /atom/movable's that arent mobs as part of foreign contents
 * * foreign_non_player_mobs - bool. if true our platforms consider mobs that dont have a mind to be foreign
 * * consider_player_mobs - bool. if true our platforms consider player mobs to be foreign. only works if foreign_non_player_mobs is true as well
 */
/datum/lift_master/proc/reset_lift_contents(consider_anything_past = 0, foreign_objects = TRUE, foreign_non_player_mobs = TRUE, consider_player_mobs = FALSE)
	for(var/obj/structure/industrial_lift/lift_to_reset in lift_platforms)
		lift_to_reset.reset_contents(consider_anything_past, foreign_objects, foreign_non_player_mobs, consider_player_mobs)

	return TRUE

/datum/lift_master/tram/proc/hide_tram()
	ignore_pathing_obstacles = TRUE
	for(var/obj/structure/industrial_lift/tram/platform in lift_platforms)
		platform.horizontal_speed = 0.1
		base_horizontal_speed = 0.1
		horizontal_speed = 0.1
		if(!platform.fake)
			platform.obj_flags &= ~BLOCK_Z_OUT_DOWN
			platform.alpha = 0
		for(var/atom/movable/movable in platform.lift_load)
			if(ismob(movable))
				platform.RemoveItemFromLift(movable)
				continue
			objects_pre_alpha |= movable
			objects_pre_alpha[movable] = movable.alpha
			ADD_TRAIT(movable, TRAIT_I_AM_INVISIBLE_ON_A_BOAT, REF(src))
			movable.density = FALSE
			movable.alpha = 0

		for(var/obj/structure/industrial_lift/tram/moving_platform in platform.moving_lifts)
			if(moving_platform.fake)
				continue
			moving_platform.horizontal_speed = 0.1
			moving_platform.obj_flags &= ~BLOCK_Z_OUT_DOWN
			moving_platform.alpha = 0

/datum/lift_master/tram/proc/show_tram()
	ignore_pathing_obstacles = FALSE
	for(var/obj/structure/industrial_lift/tram/platform in lift_platforms)
		platform.horizontal_speed = 4
		base_horizontal_speed = 4
		horizontal_speed = 4
		if(!platform.fake)
			platform.obj_flags |= BLOCK_Z_OUT_DOWN
			platform.alpha = 255
		for(var/atom/movable/movable in objects_pre_alpha)
			movable.alpha = objects_pre_alpha[movable]
			REMOVE_TRAIT(movable, TRAIT_I_AM_INVISIBLE_ON_A_BOAT, REF(src))
			objects_pre_alpha -= movable
			movable.density = initial(movable.density)

		for(var/obj/structure/industrial_lift/tram/moving_platform in platform.moving_lifts)
			if(moving_platform.fake)
				continue
			moving_platform.horizontal_speed = 4
			moving_platform.obj_flags |= BLOCK_Z_OUT_DOWN
			moving_platform.alpha = 255

/datum/lift_master/tram/proc/try_process_order(fence = FALSE)
	var/total_coin_value = 0
	var/spent_amount = 0
	var/list/requested_supplies = list()
	var/list/request_fufillment = list()
	var/list/reputation_purchases = list() // Track reputation purchases
	var/total_reputation_cost = 0

	var/datum/world_faction/faction = SSmerchant.active_faction
	if(!faction)
		return

	for(var/obj/structure/industrial_lift/tram/platform in lift_platforms)
		for(var/atom/movable/listed_atom in platform.lift_load)
			if(!fence)
				for(var/datum/trade_request/request in SSmerchant.trade_requests)
					if(listed_atom.type == request.input_atom || (ispath(request.input_atom, /obj/item/reagent_containers/glass/bottle) && istype(listed_atom, /obj/item/reagent_containers/glass/bottle)))
						if(istype(listed_atom, /obj/item/reagent_containers/glass/bottle))
							var/obj/item/reagent_containers/glass/bottle/input_bottle = request.input_atom
							if(initial(input_bottle.list_reagents))
								var/passed = FALSE
								var/list/input_reagents = initial(input_bottle.list_reagents)
								for(var/datum/reagent/reagent as anything in initial(input_bottle.list_reagents))
									var/obj/item/reagent_containers/glass/bottle/bottle = listed_atom
									if(bottle.reagents.has_reagent(reagent, input_reagents[reagent] * 0.5))
										passed = TRUE
								if(!passed)
									continue
						if(!(request in request_fufillment))
							request_fufillment |= request
							request_fufillment[request] = list()
						request_fufillment[request] |= listed_atom
						if(length(request_fufillment[request]) >= request.input_amount)
							for(var/atom/atom in request_fufillment[request])
								request_fufillment[request] -= atom
								qdel(atom)
							for(var/i = 1 to request.output_amount)
								SSmerchant.sending_stuff += request.output_atom
							request.total_trade--
							if(request.total_trade <= 0)
								SSmerchant.trade_requests -= request
								qdel(request)

	for(var/obj/structure/industrial_lift/tram/platform in lift_platforms)
		for(var/atom/movable/listed_atom in platform.lift_load)
			if(istype(listed_atom, /obj/item/paper/scroll/cargo))
				var/obj/item/paper/scroll/cargo/cargo_manifest = listed_atom

				// Add regular orders
				requested_supplies.Add(cargo_manifest.orders.Copy())

				if(cargo_manifest.reputation_orders && length(cargo_manifest.reputation_orders))
					for(var/datum/supply_pack/pack in cargo_manifest.reputation_orders)
						if(cargo_manifest.reputation_orders[pack])
							reputation_purchases[pack] = TRUE
							// Calculate reputation cost
							var/quantity = cargo_manifest.orders[pack] || 0
							var/rep_cost = pack.calculate_reputation_cost()
							total_reputation_cost += rep_cost * quantity

				qdel(listed_atom)

			if(istype(listed_atom, /obj/item/coin))
				total_coin_value += listed_atom.get_real_price()
				qdel(listed_atom)

			for(var/atom/movable/inside in listed_atom.get_all_contents())
				if(inside == listed_atom)
					continue
				if(istype(inside, /obj/item/paper/scroll/cargo))
					var/obj/item/paper/scroll/cargo/cargo_manifest = inside
					requested_supplies.Add(cargo_manifest.orders.Copy())

					if(cargo_manifest.reputation_orders && length(cargo_manifest.reputation_orders))
						for(var/datum/supply_pack/pack in cargo_manifest.reputation_orders)
							if(cargo_manifest.reputation_orders[pack])
								reputation_purchases[pack] = TRUE
								var/quantity = cargo_manifest.orders[pack] || 0
								var/rep_cost = pack.calculate_reputation_cost()
								total_reputation_cost += rep_cost * quantity

					qdel(inside)
				if(istype(inside, /obj/item/coin))
					total_coin_value += inside.get_real_price()
					qdel(inside)

		// Process platform orders
		if(!length(requested_supplies))
			spawn_coins(total_coin_value, platform) // without orders, acts as a coin consolidator
			total_coin_value = 0
			continue

		// Check reputation requirements BEFORE processing any orders
		if(total_reputation_cost > 0 && faction.faction_reputation < total_reputation_cost)
			// Create failure note and return coins
			spawn_coins(total_coin_value, platform, crate_type = /obj/structure/closet/crate/chest/merchant)
			var/obj/item/paper/failure_note = new(get_turf(platform))
			failure_note.name = "delivery failure notice"
			failure_note.info = "Order rejected: Insufficient reputation. Required: [total_reputation_cost], Available: [faction.faction_reputation]. Please improve relations before attempting reputation purchases."
			total_coin_value = 0
			continue

		// Calculate costs and process orders (modified for reputation pricing)
		var/total_required_cost = 0
		for(var/datum/supply_pack/requested as anything in requested_supplies)
			if(!requested_supplies[requested])
				continue

			var/modifier = 1
			if(fence)
				if(!requested.contraband)
					modifier = 1.5

			// Check if this is a reputation purchase (costs 2x mammons)
			var/reputation_multiplier = 1
			if(reputation_purchases[requested])
				reputation_multiplier = 2

			var/quantity = requested_supplies[requested]
			var/cost_per_item = FLOOR(requested.cost * modifier * reputation_multiplier, 1)
			total_required_cost += cost_per_item * quantity

		// Check if we have enough coins
		if(total_coin_value < total_required_cost)
			// Create failure note and return coins
			spawn_coins(total_coin_value, platform, crate_type = /obj/structure/closet/crate/chest/merchant)
			var/obj/item/paper/failure_note = new(get_turf(platform))
			failure_note.name = "delivery failure notice"
			failure_note.info = "Order rejected: Insufficient payment. Required: [total_required_cost] mammons, Provided: [total_coin_value]."
			total_coin_value = 0
			continue

		// Deduct reputation cost first
		if(total_reputation_cost > 0)
			faction.faction_reputation -= total_reputation_cost

		for(var/datum/supply_pack/requested as anything in requested_supplies)
			if(!requested_supplies[requested])
				continue

			var/modifier = 1
			if(fence)
				if(!requested.contraband)
					modifier = 1.5

			// Apply reputation multiplier for reputation purchases
			var/reputation_multiplier = 1
			if(reputation_purchases[requested])
				reputation_multiplier = 2

			for(var/i in 1 to requested_supplies[requested])
				var/cost = FLOOR(requested.cost * modifier * reputation_multiplier, 1)
				if(total_coin_value >= cost)
					total_coin_value -= cost
					spent_amount += cost

					// Check if item is normally available or reputation purchase
					var/datum/world_faction/active_faction = SSmerchant.active_faction
					if(active_faction && active_faction.has_supply_pack(requested.type))
						// Normal purchase - item is in stock
						SSmerchant.requestlist[requested] += 1
					else if(reputation_purchases[requested])
						// Reputation purchase - override stock limitation
						SSmerchant.requestlist[requested] += 1
					// If neither condition is met, the item simply isn't processed (shouldn't happen with proper validation)

		// Return remaining coins
		spawn_coins(total_coin_value, platform, crate_type = /obj/structure/closet/crate/chest/merchant)

		// Create success note if reputation was used
		if(total_reputation_cost > 0)
			var/obj/item/paper/success_note = new(get_turf(platform))
			success_note.name = "reputation purchase confirmation"
			success_note.info = "Reputation purchase successful! [total_reputation_cost] reputation spent. Remaining: [faction.faction_reputation]"

		total_coin_value = 0

	// Track spending (unchanged)
	if(spent_amount)
		record_round_statistic(STATS_TRADE_VALUE_IMPORTED, spent_amount)
		add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_MAMMONS_SPENT, spent_amount, 1)

/datum/lift_master/tram/proc/get_valid_turfs(obj/structure/industrial_lift/tram/platform)
	var/list/valid_turfs = list()
	for(var/obj/structure/industrial_lift/tram/moving_platform in platform.moving_lifts)
		var/is_valid_turf = TRUE
		if(moving_platform.fake)
			is_valid_turf = FALSE
			continue
		var/turf/possible_turf = get_turf(moving_platform)
		for(var/obj/structure/structure in possible_turf)
			if(structure == moving_platform)
				continue
			if(structure.density)
				is_valid_turf = FALSE
				break
		if(is_valid_turf)
			valid_turfs |= possible_turf
	return valid_turfs

/datum/lift_master/tram/proc/spawn_coins(total_coin_value, obj/structure/industrial_lift/tram/platform, obj/structure/closet/crate_type)
	if(total_coin_value <= 0)
		return

	var/list/possible_turfs = get_valid_turfs(platform)
	var/atom/location
	if(length(possible_turfs))
		location = get_turf(pick(possible_turfs))
	else
		var/obj/structure/industrial_lift/tram/picked = pick(platform.moving_lifts)
		location = get_turf(picked)
	if(ispath(crate_type))
		location = new crate_type(location)
		location.name = "currency chest"

	var/gold_coins = floor(total_coin_value/10)
	if(gold_coins >= 1)
		var/stacks = floor(gold_coins/20) // keep this in sync with MAX_COIN_STACK_SIZE in coins.dm
		if(stacks >= 1)
			for(var/i in 1 to stacks)
				new /obj/item/coin/gold(location, 20)
		var/remainder = gold_coins % 20
		if(remainder >= 1)
			new /obj/item/coin/gold(location, remainder)
	total_coin_value -= gold_coins*10
	if(!total_coin_value)
		return location

	var/silver_coins = floor(total_coin_value/5)
	if(silver_coins >= 1)
		var/stacks = floor(silver_coins/20)
		if(stacks >= 1)
			for(var/i in 1 to stacks)
				new /obj/item/coin/silver(location, 20)
		var/remainder = silver_coins % 20
		if(remainder >= 1)
			new /obj/item/coin/silver(location, remainder)
	total_coin_value -= silver_coins*5
	if(!total_coin_value)
		return location

	var/copper = floor(total_coin_value)
	new /obj/item/coin/copper(location, copper)

	return location

/datum/lift_master/tram/proc/check_living()
	for(var/obj/structure/industrial_lift/tram/platform in lift_platforms)
		var/mob/living/mob = locate(/mob/living) in platform
		if(istype(mob, /mob/living/simple_animal/hostile/retaliate/trader))
			continue
		if(istype(mob))
			return FALSE

	return TRUE

/datum/lift_master/tram/proc/try_sell_items(fence = FALSE)
	var/total_coin_value = 0
	var/sell_modifer = 1
	if(fence)
		sell_modifer = 0.75
	for(var/obj/structure/industrial_lift/tram/platform in lift_platforms)
		var/list/atom/movable/original_contents = list()
		for(var/datum/weakref/initial_contents_ref as anything in platform.initial_contents)
			if(!initial_contents_ref)
				continue
			var/atom/movable/resolved_contents = initial_contents_ref.resolve()
			if(!resolved_contents)
				continue
			if(!(resolved_contents in platform.lift_load))
				continue
			original_contents += resolved_contents
		var/list/sold_items = list()
		var/list/sold_count = list()
		SSmerchant.handle_lift_contents(platform, platform.lift_load, destination) //this potentially nukes some items so its done here
		for(var/atom/movable/listed_atom in platform.lift_load)
			if(listed_atom in original_contents)
				continue
			if(istype(listed_atom, /obj/item/paper/scroll))
				continue
			if(istype(listed_atom, /obj/item/coin))
				continue
			if(!listed_atom.sellprice && !SSmerchant.get_item_base_value(listed_atom.type))
				continue

			var/old_price = SSmerchant.active_faction.get_actual_sell_price(listed_atom.type, sell_modifer)
			if(old_price <= 0)
				continue

			total_coin_value += old_price
			sold_count[initial(listed_atom.name)] += 1
			sold_items[initial(listed_atom.name)] += old_price
			SSmerchant.handle_selling(listed_atom.type)

			var/new_price = SSmerchant.active_faction.get_actual_sell_price(listed_atom.type, sell_modifer)
			if(old_price != new_price)
				SSmerchant.changed_sell_prices(listed_atom.type, old_price, new_price)

			for(var/atom/movable/inside in listed_atom.get_all_contents())
				if(inside == listed_atom)
					continue
				if(inside in original_contents)
					continue
				if(istype(inside, /obj/item/paper/scroll))
					continue
				if(istype(inside, /obj/item/coin))
					continue
				if(!inside.sellprice && !SSmerchant.get_item_base_value(inside.type))
					continue

				var/old_inside_price = SSmerchant.active_faction.get_actual_sell_price(inside.type, sell_modifer)
				if(old_inside_price <= 0)
					continue

				total_coin_value += old_inside_price
				sold_count[initial(inside.name)] += 1
				sold_items[initial(inside.name)] += old_inside_price
				SSmerchant.handle_selling(inside.type)

				var/new_inside_price = SSmerchant.active_faction.get_actual_sell_price(inside.type, sell_modifer)
				if(old_inside_price != new_inside_price)
					SSmerchant.changed_sell_prices(inside.type, old_inside_price, new_inside_price)
				qdel(inside)

			if(ismobholder(listed_atom))
				var/obj/item/mob_holder/holder = listed_atom
				for(var/obj/item/item in holder.held_mob.get_equipped_items())
					item.forceMove(get_turf(holder))
				to_chat(holder.held_mob, span_boldwarning("You have been sold."))
				qdel(holder.held_mob) //so long my friend
			qdel(listed_atom)

		var/atom/location = spawn_coins(total_coin_value, platform) // try_process_order will eat these coins, so don't spawn a chest
		record_round_statistic(STATS_TRADE_VALUE_EXPORTED, total_coin_value)
		add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_MAMMONS_GAINED, total_coin_value)
		if(length(sold_items) && !fence)
			var/scrolls_to_spawn = CEILING(length(sold_items) / 6, 1)
			for(var/i = 1 to scrolls_to_spawn)
				if(!length(sold_items) || !length(sold_count))
					continue
				var/list/items = list()
				var/list/count = list()
				for(var/b = 1 to length(sold_items))
					if(b > 6) // manifest can reasonably fit 6 entries
						continue
					var/first_item = sold_items[1]
					items[first_item] = sold_items[first_item]
					sold_items -= first_item
					var/first_count = sold_count[1]
					count[first_count] = sold_count[first_count]
					sold_count -= first_count
				var/obj/item/paper/scroll/sold_manifest/manifest = new /obj/item/paper/scroll/sold_manifest(location)
				manifest.count = count.Copy()
				manifest.items = items.Copy()
				manifest.rebuild_info()
