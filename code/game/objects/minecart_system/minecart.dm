/obj/structure/closet/crate/miningcar
	name = "mine cart"
	desc = "A cart for use on rails. Or off rails, if you're so inclined."
	icon = 'icons/obj/track.dmi'
	icon_state = "minecart"
	base_icon_state = "minecart"
	drag_slowdown = 2
	//open_sound = 'sound/machines/trapdoor/trapdoor_open.ogg'
	//close_sound = 'sound/machines/trapdoor/trapdoor_shut.ogg'
	buckle_lying = FALSE
	horizontal = FALSE

	/// Whether we're on a set of rails or just on the ground
	var/on_rails = FALSE
	/// How many turfs we are travelling, also functions as speed (more momentum = faster)
	var/momentum = 0
	///the id we just travelled to
	var/last_travelled_to = ""
	///do we have a hopper attached?
	var/hopper_mode = FALSE

/obj/structure/closet/crate/miningcar/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noisy_movement, 'sound/tank_treads.ogg', 50)
	return INITIALIZE_HINT_LATELOAD

/obj/structure/closet/crate/miningcar/LateInitialize()
	. = ..()
	if(locate(/obj/structure/minecart_rail) in loc)
		update_rail_state(TRUE)

/obj/structure/closet/crate/miningcar/examine(mob/user)
	. = ..()
	if(on_rails)
		. += span_notice("You can give this a bump to send it on its way, or drag it off the rails to drag it around.")
	else
		. += span_notice("Drag this onto a mine cart rail to set it on the rails.")

/obj/structure/closet/crate/miningcar/Move(atom/newloc, direct, glide_size_override, update_dir)
	if(isnull(newloc))
		return ..()
	if(!on_rails)
		return ..()
	// Allows people to drag minecarts along the rails rather than solely shoving it
	if(can_travel_on_turf(get_turf(newloc), direct))
		return ..()
	momentum = 0
	return FALSE

/obj/structure/closet/crate/miningcar/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(!on_rails || momentum <= 0)
		return

	if(hopper_mode)
		for(var/turf/turf in range(1, src))
			if(locate(/obj/structure/roller) in get_turf(turf))
				continue
			for(var/obj/item/item in turf.contents)
				if(item.anchored)
					continue
				item.forceMove(src)
				visible_message(span_notice("[src] hopper up [item]."))

	// Handling running OVER people
	for(var/mob/living/smacked in loc)
		if(smacked.body_position == LYING_DOWN)
			continue
		if(momentum <= 8)
			momentum = floor(momentum / 2)
			break
		smack(smacked, 12, 1.25)
		if(QDELETED(src))
			break

// Hack: If a mob is buckled onto the cart, bumping the cart will instead bump the mob (because higher layer)
// So if we want to allow people to shove carts people are riding, we gotta check the mob for bumped and redirect it
/obj/structure/closet/crate/miningcar/post_buckle_mob(mob/living/buckled_mob)
	RegisterSignal(buckled_mob, COMSIG_ATOM_BUMPED, PROC_REF(buckled_bumped))
	RegisterSignal(buckled_mob, COMSIG_MOVABLE_BUMP_PUSHED, PROC_REF(block_bump_push))

/obj/structure/closet/crate/miningcar/post_unbuckle_mob(mob/living/unbuckled_mob)
	UnregisterSignal(unbuckled_mob, list(COMSIG_ATOM_BUMPED, COMSIG_MOVABLE_BUMP_PUSHED))

/obj/structure/closet/crate/miningcar/proc/buckled_bumped(datum/source, atom/bumper)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(shove_off), bumper)

/**
 * Called when the minecart smacks into someone.
 *
 * * smacked - The mob that was smacked.
 * * damage_mod - How much to multiply the momentum by to get the damage.
 * * momentum_mod - How much to divide the momentum by after the smack.
 */
/obj/structure/closet/crate/miningcar/proc/smack(mob/living/smacked, damage_mod = 8, momentum_mod = 1.5)
	ASSERT(momentum_mod >= 1)
	if(!smacked.apply_damage(damage_mod * momentum, BRUTE, BODY_ZONE_CHEST))
		return
	if(atom_integrity <= max_integrity * 0.05)
		smacked.visible_message(
			span_danger("[src] smashes into [smacked], breaking into pieces!"),
			span_userdanger("You are smacked by [src] as it breaks into pieces!"),
		)
		//playsound(src, 'sound/effects/break_stone.ogg', 50, vary = TRUE)
		momentum = 0

	else
		smacked.visible_message(
			span_danger("[src] smashes into [smacked]!"),
			span_userdanger("You are smacked by [src]!"),
		)
	//playsound(src, 'sound/effects/bang.ogg', 50, vary = TRUE)
	take_damage(max_integrity * 0.05)
	momentum = floor(momentum / momentum_mod)
	if(smacked.body_position == LYING_DOWN)
		smacked.Paralyze(4 SECONDS)
		return

	smacked.Knockdown(5 SECONDS)
	for(var/side_dir in shuffle(GLOB.alldirs))
		// Don't throw people in front of the cart, and
		// don't throw people in any direction behind us
		if(side_dir == dir || (side_dir & REVERSE_DIR(dir)))
			continue
		var/turf/open/open_turf = get_step(src, side_dir)
		if(!istype(open_turf))
			continue
		smacked.safe_throw_at(open_turf, 1, 3, spin = FALSE)

/**
 * Updates the state of the minecart to be on or off rails.
 */
/obj/structure/closet/crate/miningcar/proc/update_rail_state(new_state)
	if(on_rails == new_state)
		return
	on_rails = new_state
	if(on_rails)
		drag_slowdown = 0.5
		RegisterSignal(src, COMSIG_MOVABLE_BUMP_PUSHED, PROC_REF(block_bump_push))
	else
		drag_slowdown = 2
		UnregisterSignal(src, COMSIG_MOVABLE_BUMP_PUSHED)

// We want a low move resistance so people can drag it along the tracks
// But we also don't want people to nudge it with a push (since it requires a do_after to set off)
/obj/structure/closet/crate/miningcar/proc/block_bump_push(datum/source, mob/living/bumper, force)
	SIGNAL_HANDLER
	if(on_rails)
		return COMPONENT_NO_PUSH
	if(force < MOVE_FORCE_STRONG)
		return COMPONENT_NO_PUSH
	return NONE

/obj/structure/closet/crate/miningcar/forceMove(atom/destination)
	. = ..()
	if(!.)
		return
	if(!(locate(/obj/structure/minecart_rail) in get_turf(destination)))
		update_rail_state(FALSE)

/obj/structure/closet/crate/miningcar/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(!isliving(usr) || !usr.Adjacent(over) || !usr.Adjacent(src) || !Adjacent(over))
		return
	if(on_rails)
		if(isopenturf(over))
			try_take_off_rails(usr, over)
		return

	if(istype(over, /obj/structure/minecart_rail) || (isopenturf(over) && (locate(/obj/structure/minecart_rail) in over)))
		try_put_on_rails(usr, get_turf(over))
		return

/**
 * Attempt to remove the cart from rails
 *
 * * user - The user attempting to remove the cart from the rails.
 * * new_destination - The turf the cart will be moved to.
 */
/obj/structure/closet/crate/miningcar/proc/try_take_off_rails(mob/living/user, turf/open/new_destination)
	if(!do_after(user, 2 SECONDS, src))
		return
	update_rail_state(FALSE)
	Move(new_destination)
	/*
	var/sound/thud_sound = sound('sound/weapons/thudswoosh.ogg')
	thud_sound.pitch = 0.5
	playsound(src, thud_sound, 50, TRUE)
	*/

/**
 * Attempt to put the cart on rails
 *
 * * user - The user attempting to put the cart on the rails.
 * * new_destination - The turf the cart will be moved to.
 */
/obj/structure/closet/crate/miningcar/proc/try_put_on_rails(mob/living/user, turf/open/new_destination)
	if(!do_after(user, 2 SECONDS, src))
		return
	var/obj/structure/minecart_rail/set_rail = locate() in new_destination
	if(isnull(set_rail))
		return
	Move(new_destination)
	setDir(set_rail.dir)
	update_rail_state(TRUE)
	/*
	var/sound/click_sound = sound('sound/machines/click.ogg')
	click_sound.pitch = 0.5
	playsound(src, click_sound, 50, TRUE)
	*/

/obj/structure/closet/crate/miningcar/Bump(atom/bumped_atom)
	. = ..()
	if(.)
		return

	// Handling running INTO people
	if(!isliving(bumped_atom) || momentum <= 0)
		return
	if(bumped_atom in buckled_mobs)
		return

	if(momentum <= 8)
		momentum = floor(momentum / 2)
		return
	smack(bumped_atom)

/obj/structure/closet/crate/miningcar/Bumped(atom/movable/bumped_atom)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(shove_off), bumped_atom)

/obj/structure/closet/crate/miningcar/relaymove(mob/user, direction)
	if(!on_rails || momentum > 0)
		return
	if(user in buckled_mobs)
		return
	user.setDir(direction)

	shove_off(user)

/// Starts the cart moving automatically.
/obj/structure/closet/crate/miningcar/proc/shove_off(atom/movable/bumped_atom)
	if(!on_rails || momentum > 0)
		return

	obj_flags |= BLOCK_Z_OUT_DOWN
	var/movedir = bumped_atom.dir
	var/turf/next_turf = get_step(src, movedir)
	if(!can_travel_on_turf(next_turf, movedir))
		return

	if(isliving(bumped_atom))
		var/obj/structure/minecart_rail/rail = locate() in loc
		var/mob/living/bumper = bumped_atom
		if(bumper.mob_size <= MOB_SIZE_SMALL)
			return
		if(!do_after(bumper, 1.5 SECONDS, src))
			return
		if(QDELETED(rail) || !on_rails || !can_travel_on_turf(next_turf, movedir))
			return
		momentum += 10

	else if(isitem(bumped_atom))
		var/obj/item/bumped_item = bumped_atom
		if(bumped_item.w_class <= WEIGHT_CLASS_SMALL)
			return
		momentum += bumped_item.w_class

	else if(istype(bumped_atom, /obj/structure/closet/crate/miningcar))
		var/obj/structure/closet/crate/miningcar/bumped_car = bumped_atom
		if(bumped_car.momentum <= 0)
			return
		momentum += bumped_car.momentum
		bumped_car.momentum = 0

	if(momentum <= 0)
		return

	setDir(movedir)
	var/datum/move_loop/loop = SSmove_manager.move(src, dir, delay = calculate_delay(), subsystem = SSminecarts, flags = MOVEMENT_LOOP_START_FAST|MOVEMENT_LOOP_IGNORE_PRIORITY, move_loop_type = /datum/move_loop/minecart)
	RegisterSignal(loop, COMSIG_MOVELOOP_PREPROCESS_CHECK, PROC_REF(check_rail))
	RegisterSignal(loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(decay_momentum))

/obj/structure/closet/crate/miningcar/proc/check_rail(datum/move_loop/move/source)
	SIGNAL_HANDLER

	if(momentum <= 0)
		stack_trace("Mine cart moving on 0 momentum!")
		SSmove_manager.stop_looping(src, SSminecarts)
		obj_flags &= ~BLOCK_Z_OUT_DOWN
		momentum = 0
		return MOVELOOP_SKIP_STEP
	// Forced to not move
	if(anchored)
		return MOVELOOP_SKIP_STEP

	// Going through open space
	for(var/obj/structure/fluff/traveltile/travel in get_turf(src))
		if(travel.aportalgoesto == last_travelled_to)
			break
		for(var/turf/open/viable_turfs in travel.return_connected_turfs())
			for(var/obj/structure/minecart_rail/rail in viable_turfs)
				forceMove(viable_turfs)
				for(var/card in GLOB.cardinals)
					var/turf/dir_step = get_step(rail, card)
					var/obj/structure/minecart_rail/located = locate(/obj/structure/minecart_rail) in dir_step
					if(!located)
						continue
					setDir(get_dir(rail, located))
					var/datum/move_loop/minecart/loop = SSmove_manager.processing_on(src, SSminecarts)
					loop.direction = get_dir(rail, located)
				last_travelled_to = travel.aportalid
				return MOVELOOP_SKIP_STEP

	// Going straight
	if(can_travel_on_turf(get_step(src, dir)))
		var/obj/structure/fluff/traveltile/travel = locate(/obj/structure/fluff/traveltile) in get_turf(src)
		if(!travel)
			last_travelled_to = ""
		return NONE

	// Trying to turn
	for(var/next_dir in shuffle(list(turn(dir, 90), turn(dir, -90))))
		if(!can_travel_on_turf(get_step(src, next_dir), next_dir))
			continue
		momentum -= 1 // Extra cost for turning
		if(momentum <= 0)
			break
		source.direction = next_dir
		return NONE

	// Flying over openspace
	if((!on_rails || momentum >= 4) && istype(get_step(src, dir), /turf/open/openspace))
		update_rail_state(FALSE) // Time to fly
		return NONE

	// // Derail if too fast
	if((!on_rails || momentum >= 30) && isopenturf(get_step(src, dir)))
		update_rail_state(FALSE) // Time to fly
		return NONE

	// Can't go straight and cant turn = STOP
	SSmove_manager.stop_looping(src, SSminecarts)
	obj_flags &= ~BLOCK_Z_OUT_DOWN
	if(momentum >= 12)
		visible_message(span_warning("[src] comes to a violent halt!"))
		throw_contents()
	else
		visible_message(span_notice("[src] comes to a slow stop."))
	momentum = 0
	return MOVELOOP_SKIP_STEP

/obj/structure/closet/crate/miningcar/proc/decay_momentum(datum/move_loop/move/source)
	SIGNAL_HANDLER

	if(momentum > 0)
		var/obj/structure/minecart_rail/railbreak/stop_break = locate() in loc
		// There is a break and it is powered, so STOP
		if(stop_break && !stop_break.force_disabled && stop_break.rotations_per_minute)
			if(momentum >= 8)
				visible_message(span_notice("[src] comes to a sudden stop."))
			else
				visible_message(span_notice("[src] comes to a stop."))
			SSmove_manager.stop_looping(src, SSminecarts)
			obj_flags &= ~BLOCK_Z_OUT_DOWN
			momentum = 0
			return
		check_powered()
		momentum -= 0.7

	// No more momentum = STOP
	if(momentum <= 0)
		SSmove_manager.stop_looping(src, SSminecarts)
		obj_flags &= ~BLOCK_Z_OUT_DOWN
		momentum = 0
		visible_message(span_notice("[src] comes to a slow stop."))
		return

	// Handles slowing down the move loop / cart
	var/datum/move_loop/loop = SSmove_manager.processing_on(src, SSminecarts)
	loop?.set_delay(calculate_delay())

/// Calculates how fast the cart is going
/obj/structure/closet/crate/miningcar/proc/calculate_delay()
	return (2 SECONDS) * NUM_E**(-0.05 SECONDS * momentum)

/// Checks if we can travel via rail on the passed turf. dir_to_check is the direction of minecart movement
/obj/structure/closet/crate/miningcar/proc/can_travel_on_turf(turf/next_turf, dir_to_check = dir)

	var/obj/structure/minecart_rail/located_rail = locate(/obj/structure/minecart_rail) in get_turf(src)

	// If our current turf does NOT have a rail, only check the next rail. Otherwise, check our current rail then check the next rail.
	for(var/obj/structure/minecart_rail/rail in next_turf)
		if(!located_rail)
			if(REVERSE_DIR(dir_to_check) & rail.minecart_dirs)
				return TRUE
		else
			if(!(dir_to_check & located_rail.minecart_dirs))
				return FALSE
			if(!(REVERSE_DIR(dir_to_check) & rail.minecart_dirs))
				return FALSE
			return TRUE

	// We don't care about next rail if going through traveltile
	for(var/obj/structure/fluff/traveltile/travel in next_turf)
		for(var/turf/open/viable_turfs in travel.return_connected_turfs())
			for(var/obj/structure/minecart_rail/rail in viable_turfs)
				if(!located_rail)
					return TRUE
				else
					if(!(dir_to_check & located_rail.minecart_dirs))
						return FALSE
					return TRUE

	var/turf/above_next = GET_TURF_ABOVE(next_turf)
	for(var/obj/structure/minecart_rail/rail in above_next)
		if(!located_rail)
			if(REVERSE_DIR(dir_to_check) & rail.minecart_dirs)
				return TRUE
		else
			if(!(dir_to_check & located_rail.minecart_dirs))
				return FALSE
			if(!(REVERSE_DIR(dir_to_check) & rail.minecart_dirs))
				return FALSE
			return TRUE

	var/turf/below_next = GET_TURF_BELOW(next_turf)
	for(var/obj/structure/minecart_rail/rail in below_next)
		if(!located_rail)
			if(REVERSE_DIR(dir_to_check) & rail.minecart_dirs)
				return TRUE
		else
			if(!(dir_to_check & located_rail.minecart_dirs))
				return FALSE
			if(!(REVERSE_DIR(dir_to_check) & rail.minecart_dirs))
				return FALSE
			return TRUE

	return FALSE

/obj/structure/closet/crate/miningcar/proc/check_powered()
	var/obj/structure/minecart_rail/potential_power = locate() in loc
	if(!potential_power)
		return
	update_rail_state(TRUE)
	if(potential_power.rotations_per_minute)
		momentum += round(potential_power.rotations_per_minute / 3)

/// Throws all the contents of the cart out ahead
/obj/structure/closet/crate/miningcar/proc/throw_contents()
	var/was_open = opened
	var/list/to_yeet = contents.Copy()
	var/yeet_rider = has_buckled_mobs()
	if(yeet_rider)
		to_yeet += buckled_mobs
		unbuckle_all_mobs()

	bust_open()
	if(!opened)
		return

	if(!length(to_yeet))
		if(!was_open)
			visible_message(span_warning("[src] breaks open!"))
		return

	var/throw_distance = clamp(ceil(momentum / 3) - 4, 1, 255)
	var/turf/some_distant_turf = get_edge_target_turf(src, dir)
	if(throw_distance)
		for(var/atom/movable/yeeten in to_yeet)
			yeeten.throw_at(some_distant_turf, throw_distance, 3 + FLOOR(momentum * 0.01, 1))

	if(was_open)
		visible_message(span_warning("[src] spills its contents!"))
	else
		// Update this message if someone allows multiple people to ride one minecart
		visible_message(span_warning("[src] breaks open, spilling its contents[yeet_rider ? " and throwing its rider":""]!"))

	for(var/obj/structure/minecart_rail/rail in get_turf(src))
		update_rail_state(TRUE)
		break

/obj/structure/closet/crate/miningcar/proc/handle_aerial_fall(freefall)
	set waitfor = 0

	var/turf/current_turf = get_turf(src)

	if(!freefall)
		movement_type |= FLYING // this along with zFall(force = TRUE) only allows the cart to fall one z level
	current_turf.zFall(src, force = TRUE)
	movement_type &= ~FLYING
