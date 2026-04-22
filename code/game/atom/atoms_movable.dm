/atom/movable
	layer = OBJ_LAYER
	var/last_move = null
	var/last_move_time = 0
	/// A list containing arguments for Moved().
	VAR_PRIVATE/tmp/list/active_movement
	var/anchored = FALSE
	var/move_resist = MOVE_RESIST_DEFAULT
	var/move_force = MOVE_FORCE_DEFAULT
	var/pull_force = PULL_FORCE_DEFAULT
	var/datum/thrownthing/throwing = null
	var/throw_speed = 1 //How many tiles to move per ds when being thrown. Float values are fully supported
	var/throw_range = 7
	var/mob/living/pulledby = null
	var/initial_language_holder = /datum/language_holder
	var/datum/language_holder/language_holder
	var/verb_say = "says"
	var/verb_ask = "asks"
	var/verb_sing = "sings"
	var/verb_exclaim = "exclaims"
	var/verb_yell = "yells"
	var/speech_span
	var/inertia_dir = 0
	var/atom/inertia_last_loc
	var/inertia_moving = 0
	var/inertia_next_move = 0
	var/inertia_move_delay = 5
	/// Things we can pass through while moving. If any of this matches the thing we're trying to pass's [pass_flags_self], then we can pass through.
	var/pass_flags = NONE
	/// If false makes CanPass call CanPassThrough on this type instead of using default behaviour
	var/generic_canpass = TRUE
	var/moving_diagonally = 0 //0: not doing a diagonal move. 1 and 2: doing the first/second step of the diagonal move
	/// attempt to resume grab after moving instead of before.
	var/atom/movable/moving_from_pull
	var/lastcardinal = 0
	var/lastcardpress = 0
	var/list/acted_explosions	//for explosion dodging
	glide_size = 6
	appearance_flags = TILE_BOUND|PIXEL_SCALE
	var/datum/forced_movement/force_moving = null	//handled soley by forced_movement.dm
	///Holds information about any movement loops currently running/waiting to run on the movable. Lazy, will be null if nothing's going on
	var/datum/movement_packet/move_packet
	/**
	  * In case you have multiple types, you automatically use the most useful one.
	  * IE: Skating on ice, flippers on water, flying over chasm/space, etc.
	  * I reccomend you use the movetype_handler system and not modify this directly, especially for living mobs.
	  */
	var/movement_type = GROUND
	var/atom/movable/pulling
	var/atom_flags = NONE
	var/grab_state = 0
	var/throwforce = 0
	var/datum/component/orbiter/orbiting

	///is the mob currently ascending or descending through z levels?
	var/currently_z_moving

	/// Either [EMISSIVE_BLOCK_NONE], [EMISSIVE_BLOCK_GENERIC], or [EMISSIVE_BLOCK_UNIQUE]
	var/blocks_emissive = EMISSIVE_BLOCK_NONE
	///Internal holder for emissive blocker object, do not use directly use blocks_emissive
	var/atom/movable/emissive_blocker/em_block
	/**
	 * an associative lazylist of relevant nested contents by "channel", the list is of the form: list(channel = list(important nested contents of that type))
	 * each channel has a specific purpose and is meant to replace potentially expensive nested contents iteration
	 * do NOT add channels to this for little reason as it can add considerable memory usage.
	 */
	var/list/important_recursive_contents
	///contains every client mob corresponding to every client eye in this container. lazily updated by SSparallax and is sparse:
	///only the last container of a client eye has this list assuming no movement since SSparallax's last fire
	var/list/client_mobs_in_contents
	var/spatial_grid_key

	/// Whether a user will face atoms on entering them with a mouse. Despite being a mob variable, it is here for performance reasons
	var/face_mouse = FALSE

/mutable_appearance/emissive_blocker

/mutable_appearance/emissive_blocker/New()
	. = ..()
	// Need to do this here because it's overridden by the parent call
	// This is a microop which is the sole reason why this child exists, because its static this is a really cheap way to set color without setting or checking it every time we create an atom
	color = EM_BLOCK_COLOR

/atom/movable/Initialize(mapload)
	. = ..()

#if EMISSIVE_BLOCK_GENERIC != 0
	#error EMISSIVE_BLOCK_GENERIC is expected to be 0 to facilitate a weird optimization hack where we rely on it being the most common.
	#error Read the comment in code/game/atoms_movable.dm for details.
#endif

	if(blocks_emissive)
		if(blocks_emissive == EMISSIVE_BLOCK_UNIQUE)
			render_target = ref(src)
			em_block = new(null, src)
			overlays += em_block
			if(managed_overlays)
				if(islist(managed_overlays))
					managed_overlays += em_block
				else
					managed_overlays = list(managed_overlays, em_block)
			else
				managed_overlays = em_block
	else
		var/static/mutable_appearance/emissive_blocker/blocker = new()
		blocker.icon = icon
		blocker.icon_state = icon_state
		blocker.dir = dir
		blocker.appearance_flags = appearance_flags | EMISSIVE_APPEARANCE_FLAGS
		blocker.plane = EMISSIVE_PLANE
		// Ok so this is really cursed, but I want to set with this blocker cheaply while
		// Still allowing it to be removed from the overlays list later
		// So I'm gonna flatten it, then insert the flattened overlay into overlays AND the managed overlays list, directly
		// I'm sorry
		var/mutable_appearance/flat = blocker.appearance
		overlays += flat
		if(managed_overlays)
			if(islist(managed_overlays))
				managed_overlays += flat
			else
				managed_overlays = list(managed_overlays, flat)
		else
			managed_overlays = flat

	if(opacity)
		AddElement(/datum/element/light_blocking)

/atom/movable/Destroy(force)
	QDEL_NULL(language_holder)
	QDEL_NULL(em_block)

	if(mana_pool)
		QDEL_NULL(mana_pool)

	unbuckle_all_mobs(force = TRUE)

	if(loc)
		//Restore air flow if we were blocking it (movables with ATMOS_PASS_PROC will need to do this manually if necessary)
		if(((CanAtmosPass == ATMOS_PASS_DENSITY && density) || CanAtmosPass == ATMOS_PASS_NO) && isturf(loc))
			CanAtmosPass = ATMOS_PASS_YES
			air_update_turf(TRUE)

	invisibility = INVISIBILITY_ABSTRACT

	if(loc)
		loc.handle_atom_del(src)

	if(opacity)
		RemoveElement(/datum/element/light_blocking)

	if(pulledby)
		pulledby.stop_pulling()

	if(pulling)
		stop_pulling()

	if(orbiting)
		orbiting.end_orbit(src)
		orbiting = null

	if(move_packet)
		if(!QDELETED(move_packet))
			qdel(move_packet)
		move_packet = null

	if(spatial_grid_key)
		SSspatial_grid.force_remove_from_grid(src)

	LAZYNULL(client_mobs_in_contents)

	. = ..()

	for(var/movable_content in contents)
		qdel(movable_content)

	moveToNullspace()

	//This absolutely must be after moveToNullspace()
	//We rely on Entered and Exited to manage this list, and the copy of this list that is on any /atom/movable "Containers"
	//If we clear this before the nullspace move, a ref to this object will be hung in any of its movable containers
	LAZYNULL(important_recursive_contents)

	vis_locs = null

	if(length(vis_contents))
		vis_contents.Cut()

/atom/movable/Exited(atom/movable/gone, direction)
	. = ..()

	if(!LAZYLEN(gone.important_recursive_contents))
		return
	var/list/nested_locs = get_nested_locs(src) + src
	for(var/channel in gone.important_recursive_contents)
		for(var/atom/movable/location as anything in nested_locs)
			LAZYINITLIST(location.important_recursive_contents)
			var/list/recursive_contents = location.important_recursive_contents // blue hedgehog velocity
			LAZYINITLIST(recursive_contents[channel])
			recursive_contents[channel] -= gone.important_recursive_contents[channel]
			switch(channel)
				if(RECURSIVE_CONTENTS_CLIENT_MOBS, RECURSIVE_CONTENTS_HEARING_SENSITIVE)
					if(!length(recursive_contents[channel]))
						// This relies on a nice property of the linked recursive and gridmap types
						// They're defined in relation to each other, so they have the same value
						SSspatial_grid.remove_grid_awareness(location, channel)
			ASSOC_UNSETEMPTY(recursive_contents, channel)
			UNSETEMPTY(location.important_recursive_contents)

/atom/movable/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()

	if(!LAZYLEN(arrived.important_recursive_contents))
		return
	var/list/nested_locs = get_nested_locs(src) + src
	for(var/channel in arrived.important_recursive_contents)
		for(var/atom/movable/location as anything in nested_locs)
			LAZYINITLIST(location.important_recursive_contents)
			var/list/recursive_contents = location.important_recursive_contents // blue hedgehog velocity
			LAZYINITLIST(recursive_contents[channel])
			switch(channel)
				if(RECURSIVE_CONTENTS_CLIENT_MOBS, RECURSIVE_CONTENTS_HEARING_SENSITIVE)
					if(!length(recursive_contents[channel]))
						SSspatial_grid.add_grid_awareness(location, channel)
			recursive_contents[channel] |= arrived.important_recursive_contents[channel]

///allows this movable to hear and adds itself to the important_recursive_contents list of itself and every movable loc its in
/atom/movable/proc/become_hearing_sensitive(trait_source = TRAIT_GENERIC)
	var/already_hearing_sensitive = HAS_TRAIT(src, TRAIT_HEARING_SENSITIVE)
	ADD_TRAIT(src, TRAIT_HEARING_SENSITIVE, trait_source)
	if(already_hearing_sensitive || !HAS_TRAIT(src, TRAIT_HEARING_SENSITIVE))
		return

	for(var/atom/movable/location as anything in get_nested_locs(src) + src)
		LAZYINITLIST(location.important_recursive_contents)
		var/list/recursive_contents = location.important_recursive_contents // blue hedgehog velocity
		if(!length(recursive_contents[RECURSIVE_CONTENTS_HEARING_SENSITIVE]))
			SSspatial_grid.add_grid_awareness(location, SPATIAL_GRID_CONTENTS_TYPE_HEARING)
		recursive_contents[RECURSIVE_CONTENTS_HEARING_SENSITIVE] += list(src)

	var/turf/our_turf = get_turf(src)
	SSspatial_grid.add_grid_membership(src, our_turf, SPATIAL_GRID_CONTENTS_TYPE_HEARING)

/**
 * removes the hearing sensitivity channel from the important_recursive_contents list of this and all nested locs containing us if there are no more sources of the trait left
 * since RECURSIVE_CONTENTS_HEARING_SENSITIVE is also a spatial grid content type, removes us from the spatial grid if the trait is removed
 *
 * * trait_source - trait source define or ALL, if ALL, force removes hearing sensitivity. if a trait source define, removes hearing sensitivity only if the trait is removed
 */
/atom/movable/proc/lose_hearing_sensitivity(trait_source = TRAIT_GENERIC)
	if(!HAS_TRAIT(src, TRAIT_HEARING_SENSITIVE))
		return
	REMOVE_TRAIT(src, TRAIT_HEARING_SENSITIVE, trait_source)
	if(HAS_TRAIT(src, TRAIT_HEARING_SENSITIVE))
		return

	var/turf/our_turf = get_turf(src)
	SSspatial_grid.remove_grid_membership(src, our_turf, SPATIAL_GRID_CONTENTS_TYPE_HEARING)

	for(var/atom/movable/location as anything in get_nested_locs(src) + src)
		var/list/recursive_contents = location.important_recursive_contents // blue hedgehog velocity
		recursive_contents[RECURSIVE_CONTENTS_HEARING_SENSITIVE] -= src
		if(!length(recursive_contents[RECURSIVE_CONTENTS_HEARING_SENSITIVE]))
			SSspatial_grid.remove_grid_awareness(location, SPATIAL_GRID_CONTENTS_TYPE_HEARING)
		ASSOC_UNSETEMPTY(recursive_contents, RECURSIVE_CONTENTS_HEARING_SENSITIVE)
		UNSETEMPTY(location.important_recursive_contents)

/atom/movable/proc/on_hearing_sensitive_trait_loss()
	SIGNAL_HANDLER
	UnregisterSignal(src, COMSIG_REMOVE_TRAIT)
	for(var/atom/movable/location as anything in get_nested_locs(src) + src)
		LAZYREMOVE(location.important_recursive_contents[RECURSIVE_CONTENTS_HEARING_SENSITIVE], src)

///propogates ourselves through our nested contents, similar to other important_recursive_contents procs
///main difference is that client contents need to possibly duplicate recursive contents for the clients mob AND its eye
/mob/proc/enable_client_mobs_in_contents()
	for(var/atom/movable/movable_loc as anything in get_nested_locs(src) + src)
		LAZYINITLIST(movable_loc.important_recursive_contents)
		var/list/recursive_contents = movable_loc.important_recursive_contents // blue hedgehog velocity
		if(!length(recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS]))
			SSspatial_grid.add_grid_awareness(movable_loc, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)
		LAZYINITLIST(recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS])
		recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS] |= src

	var/turf/our_turf = get_turf(src)
	/// We got our awareness updated by the important recursive contents stuff, now we add our membership
	SSspatial_grid.add_grid_membership(src, our_turf, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)

///Clears the clients channel of this mob
/mob/proc/clear_important_client_contents()
	var/turf/our_turf = get_turf(src)
	SSspatial_grid.remove_grid_membership(src, our_turf, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)

	for(var/atom/movable/movable_loc as anything in get_nested_locs(src) + src)
		LAZYINITLIST(movable_loc.important_recursive_contents)
		var/list/recursive_contents = movable_loc.important_recursive_contents // blue hedgehog velocity
		LAZYINITLIST(recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS])
		recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS] -= src
		if(!length(recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS]))
			SSspatial_grid.remove_grid_awareness(movable_loc, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)
		ASSOC_UNSETEMPTY(recursive_contents, RECURSIVE_CONTENTS_CLIENT_MOBS)
		UNSETEMPTY(movable_loc.important_recursive_contents)

/atom/movable/proc/update_emissive_block()
	// This one is incredible.
	// `if (x) else { /* code */ }` is surprisingly fast, and it's faster than a switch, which is seemingly not a jump table.
	// From what I can tell, a switch case checks every single branch individually, although sane, is slow in a hot proc like this.
	// So, we make the most common `blocks_emissive` value, EMISSIVE_BLOCK_GENERIC, 0, getting to the fast else branch quickly.
	// If it fails, then we can check over every value it can be (here, EMISSIVE_BLOCK_UNIQUE is the only one that matters).
	// This saves several hundred milliseconds of init time.
	if(blocks_emissive)
		if(blocks_emissive == EMISSIVE_BLOCK_UNIQUE)
			if(!em_block && !QDELETED(src))
				render_target = ref(src)
				em_block = new(null, src)
			return em_block
		// Implied else if (blocks_emissive == EMISSIVE_BLOCK_NONE) -> return
	// EMISSIVE_BLOCK_GENERIC == 0
	else
		return fast_emissive_blocker(src)

/atom/movable/update_overlays()
	var/list/overlays = ..()
	var/emissive_block = update_emissive_block()
	if(emissive_block)
		// Emissive block should always go at the beginning of the list
		overlays.Insert(1, emissive_block)
	return overlays

/**
 * When the falling atom stops moving and impacts the turf.
 * To reach here from /turf/proc/zImpact, intercept_zImpact() flags must not have included FALL_INTERCEPTED.
*/
/atom/movable/proc/onZImpact(turf/impacted_turf, levels, impact_flags = NONE)
	SHOULD_CALL_PARENT(TRUE)
	if(!(impact_flags & ZIMPACT_NO_MESSAGE))
		visible_message(
			span_danger("[src] crashes into [impacted_turf]!"),
			span_userdanger("You crash into [impacted_turf]!"),
		)
	if(!(impact_flags & ZIMPACT_NO_SPIN))
		INVOKE_ASYNC(src, PROC_REF(do_spin_animation), 0.2 SECONDS, 1)

	SEND_SIGNAL(src, COMSIG_ATOM_ON_Z_IMPACT, impacted_turf, levels)
	return TRUE

/*
 * Attempts to move using zMove if direction is UP or DOWN, step if not
 *
 * Args:
 * direction: The direction to go
 * z_move_flags: bitflags used for checks in zMove and can_z_move
*/
/atom/movable/proc/try_step_multiz(direction, z_move_flags = ZMOVE_FLIGHT_FLAGS)
	if(direction == UP || direction == DOWN)
		return zMove(direction, null, z_move_flags)
	return step(src, direction)

/*
 * The core multi-z movement proc. Used to move a movable through z levels.
 * If target is null, it'll be determined by the can_z_move proc, which can potentially return null if
 * conditions aren't met (see z_move_flags defines in __DEFINES/movement.dm for info) or if dir isn't set.
 * Bear in mind you don't need to set both target and dir when calling this proc, but at least one or two.
 * This will set the currently_z_moving to CURRENTLY_Z_MOVING_GENERIC if unset, and then clear it after
 * Forcemove().
 *
 *
 * Args:
 * * dir: the direction to go, UP or DOWN, only relevant if target is null.
 * * target: The target turf to move the src to. Set by can_z_move() if null.
 * * z_move_flags: bitflags used for various checks in both this proc and can_z_move(). See __DEFINES/movement.dm.
 */
/atom/movable/proc/zMove(dir, turf/target, z_move_flags = ZMOVE_FLIGHT_FLAGS)
	if(!target)
		target = can_z_move(dir, get_turf(src), null, z_move_flags)
		if(!target)
			set_currently_z_moving(FALSE, TRUE)
			return FALSE

	var/list/moving_movs = get_z_move_affected(z_move_flags)

	for(var/atom/movable/movable as anything in moving_movs)
		movable.currently_z_moving = currently_z_moving || CURRENTLY_Z_MOVING_GENERIC
		movable.forceMove(target)
		movable.set_currently_z_moving(FALSE, TRUE)
	// This is run after ALL movables have been moved, so pulls don't get broken unless they are actually out of range.
	if(z_move_flags & ZMOVE_CHECK_PULLS)
		for(var/atom/movable/moved_mov as anything in moving_movs)
			if(z_move_flags & ZMOVE_CHECK_PULLEDBY && moved_mov.pulledby && (moved_mov.z != moved_mov.pulledby.z || get_dist(moved_mov, moved_mov.pulledby) > 1))
				moved_mov.pulledby.stop_pulling()
			if(z_move_flags & ZMOVE_CHECK_PULLING)
				moved_mov.check_pulling(TRUE)
	return TRUE

/// Returns a list of movables that should also be affected when src moves through zlevels, and src.
/atom/movable/proc/get_z_move_affected(z_move_flags)
	. = list(src)
	if(buckled_mobs)
		. |= buckled_mobs
	if(!(z_move_flags & ZMOVE_INCLUDE_PULLED))
		return
	for(var/mob/living/buckled as anything in buckled_mobs)
		if(buckled.pulling)
			. |= buckled.pulling
	if(pulling)
		. |= pulling
		if (pulling.buckled_mobs)
			. |= pulling.buckled_mobs

		//makes conga lines work with ladders and flying up and down; checks if the guy you are pulling is pulling someone,
		//then uses recursion to run the same function again
		if (pulling.pulling)
			. |= pulling.pulling.get_z_move_affected(z_move_flags)

/**
 * Checks if the destination turf is elegible for z movement from the start turf to a given direction and returns it if so.
 * Args:
 * * direction: the direction to go, UP or DOWN, only relevant if target is null.
 * * start: Each destination has a starting point on the other end. This is it. Most of the times the location of the source.
 * * z_move_flags: bitflags used for various checks. See __DEFINES/movement.dm.
 * * rider: A living mob in control of the movable. Only non-null when a mob is riding a vehicle through z-levels.
 */
/atom/movable/proc/can_z_move(direction, turf/start, turf/destination, z_move_flags = ZMOVE_FLIGHT_FLAGS, mob/living/rider)
	if(!start)
		start = get_turf(src)
		if(!start)
			return FALSE
	if(!direction)
		if(!destination)
			return FALSE
		direction = get_dir_multiz(start, destination)
	if(direction != UP && direction != DOWN)
		return FALSE
	if(!destination)
		destination = get_step_multiz(start, direction)
		if(!destination)
			if(z_move_flags & ZMOVE_FEEDBACK)
				to_chat(rider || src, span_warning("There's nowhere to go in that direction!"))
			return FALSE
	if(SEND_SIGNAL(src, COMSIG_CAN_Z_MOVE, start, destination) & COMPONENT_CANT_Z_MOVE)
		return FALSE
	if(z_move_flags & ZMOVE_FALL_CHECKS && (throwing || (movement_type & MOVETYPES_NOT_TOUCHING_GROUND)))
		return FALSE
	if(z_move_flags & ZMOVE_WATER_CHECKS && !iswaterturf(destination))
		return FALSE
	// if(z_move_flags & ZMOVE_CAN_FLY_CHECKS && !(movement_type & (FLYING|FLOATING)))
	if(z_move_flags & ZMOVE_CAN_FLY_CHECKS && !(movement_type & FLYING)) // EXPERIMENTAL: Floating doesn't let you fly up and down
		if(z_move_flags & ZMOVE_FEEDBACK)
			if(rider)
				to_chat(rider, span_warning("[src] [p_are()] incapable of flight."))
			else
				to_chat(src, span_warning("I'm incapable of flight."))
		return FALSE
	if((!(z_move_flags & ZMOVE_IGNORE_OBSTACLES) && !(start.zPassOut(direction) && destination.zPassIn(direction))) || (!(z_move_flags & ZMOVE_ALLOW_ANCHORED) && anchored))
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider || src, span_warning("I can't move there!"))
		return FALSE
	return destination //used by some child types checks and zMove()

/atom/movable/vv_edit_var(var_name, var_value)
	var/static/list/banned_edits = list("step_x" = TRUE, "step_y" = TRUE, "step_size" = TRUE, "bounds" = TRUE)
	var/static/list/careful_edits = list("bound_x" = TRUE, "bound_y" = TRUE, "bound_width" = TRUE, "bound_height" = TRUE)
	if(banned_edits[var_name])
		return FALSE	//PLEASE no.
	if((careful_edits[var_name]) && (var_value % world.icon_size) != 0)
		return FALSE
	switch(var_name)
		if(NAMEOF(src, x))
			var/turf/turf = locate(var_value, y, z)
			if(turf)
				forceMove(turf)
				return TRUE
			return FALSE
		if(NAMEOF(src, y))
			var/turf/turf = locate(x, var_value, z)
			if(turf)
				forceMove(turf)
				return TRUE
			return FALSE
		if(NAMEOF(src, z))
			var/turf/turf = locate(x, y, var_value)
			if(turf)
				admin_teleport(turf)
				return TRUE
			return FALSE
		if(NAMEOF(src, loc))
			if(isatom(var_value) || isnull(var_value))
				admin_teleport(var_value)
				return TRUE
			return FALSE
		if(NAMEOF(src, anchored))
			set_anchored(var_value)
			. = TRUE
		if(NAMEOF(src, pulledby))
			set_pulledby(var_value)
			. = TRUE
		if(NAMEOF(src, glide_size))
			set_glide_size(var_value)
			. = TRUE
	return ..()

/atom/movable/proc/start_pulling(atom/movable/AM, state, force = move_force, suppress_message = FALSE, obj/item/item_override)
	if(QDELETED(AM))
		return FALSE
	if(!(AM.can_be_pulled(src, state, force)))
		return FALSE

	// If we're pulling something then drop what we're currently pulling and pull this instead.
	if(pulling)
		if(state == 0)
			stop_pulling()
			return FALSE
		// Are we trying to pull something we are already pulling? Then enter grab cycle and end.
//		if(AM == pulling)
//			setGrabState(state)
//			if(istype(AM,/mob/living))
//				var/mob/living/AMob = AM
//				AMob.grabbedby(src)
//			return TRUE
//		stop_pulling()
	if(AM.pulledby)
		log_combat(AM, AM.pulledby, "pulled from", src)
		AM.pulledby.stop_pulling() //an object can't be pulled by two mobs at once.
	if(AM != src)
		pulling = AM
		AM.set_pulledby(src)
	setGrabState(state)
	if(ismob(AM))
		var/mob/M = AM
		log_combat(src, M, "grabbed", addition="passive grab")
		M.stop_all_doing()
		if(!suppress_message)
			M.visible_message("<span class='warning'>[src] grabs [M].</span>", \
				"<span class='danger'>[src] grabs you.</span>")
	return TRUE

///Reports the event of the change in value of the pulledby variable.
/atom/movable/proc/set_pulledby(new_pulledby)
	if(new_pulledby == pulledby)
		return FALSE //null signals there was a change, be sure to return FALSE if none happened here.
	. = pulledby
	pulledby = new_pulledby

/atom/movable/proc/stop_pulling(pulling_broke_free = FALSE)
	setGrabState(GRAB_PASSIVE)
	if(!pulling)
		return
	pulling.set_pulledby(null)
	var/atom/movable/old_pulling = pulling
	pulling = null
	SEND_SIGNAL(old_pulling, COMSIG_ATOM_NO_LONGER_PULLED, src)
	SEND_SIGNAL(src, COMSIG_ATOM_NO_LONGER_PULLING, old_pulling)

/atom/movable/proc/Move_Pulled(atom/movable/atom_location)
	if(!pulling)
		return FALSE
	if(pulling.anchored || pulling.move_resist > move_force || !pulling.Adjacent(src))
		stop_pulling()
		return FALSE
	if(isliving(pulling))
		var/mob/living/L = pulling
		if(L.buckled && L.buckled.buckle_prevents_pull) //if they're buckled to something that disallows pulling, prevent it
			stop_pulling()
			return FALSE
	if(atom_location == loc && pulling.density)
		return FALSE
	if(isgroundlessturf(atom_location)) // so you can't move someone into an openspace
		return FALSE
	var/move_dir = get_dir(pulling.loc, atom_location)
	var/turf/pre_turf = get_turf(pulling)
	pulling.Move(get_step(pulling.loc, move_dir), move_dir, glide_size)
	var/turf/post_turf = get_turf(pulling)
	if(pre_turf.snow && !post_turf.snow)
		SEND_SIGNAL(pre_turf.snow, COMSIG_MOB_OVERLAY_FORCE_REMOVE, pulling)
	return TRUE

/atom/movable/proc/after_being_moved_by_pull(atom/movable/puller)
	return

/mob/living/Move_Pulled(atom/movable/atom_location)
	. = ..()
	if(!. || !isliving(pulling))
		return
	set_pull_offsets(pulling, grab_state)

/**
 * Checks if the pulling and pulledby should be stopped because they're out of reach.
 * If z_allowed is TRUE, the z level of the pulling will be ignored.This is to allow things to be dragged up and down stairs.
 */
/atom/movable/proc/check_pulling(only_pulling = FALSE, z_allowed = FALSE)
	if(pulling)
		if(get_dist(src, pulling) > 1 || (z != pulling.z && !z_allowed))
			stop_pulling()
		else if(!isturf(loc))
			stop_pulling()
		else if(pulling && !isturf(pulling.loc) && pulling.loc != loc) //to be removed once all code that changes an object's loc uses forceMove().
			log_game("DEBUG:[src]'s pull on [pulling] wasn't broken despite [pulling] being in [pulling.loc]. Pull stopped manually.")
			stop_pulling()
		else if(pulling.anchored || pulling.move_resist > move_force)
			stop_pulling()
	if(!only_pulling && pulledby && moving_diagonally != FIRST_DIAG_STEP && (get_dist(src, pulledby) > 1 || (z != pulledby.z && !z_allowed))) //separated from our puller and not in the middle of a diagonal move.
		pulledby.stop_pulling()

/atom/movable/proc/set_glide_size(target = 0)
	SEND_SIGNAL(src, COMSIG_MOVABLE_UPDATE_GLIDE_SIZE, target)
	glide_size = target
	for(var/atom/movable/AM in buckled_mobs)
		AM.set_glide_size(target)

////////////////////////////////////////
// Here's where we rewrite how byond handles movement except slightly different
// To be removed on step_ conversion
// All this work to prevent a second bump
/atom/movable/Move(atom/newloc, direction, glide_size_override = 0, update_dir = TRUE)
	. = FALSE

	if(!newloc || newloc == loc)
		return

	// A mid-movement... movement... occured, resolve that first.
	RESOLVE_ACTIVE_MOVEMENT

	if(!direction)
		direction = get_dir(src, newloc)

	if(!face_mouse && !throwing && dir != direction && update_dir)
		setDir(direction)

	var/is_multi_tile_object = is_multi_tile_object(src)

	var/list/old_locs
	if(is_multi_tile_object && isturf(loc))
		old_locs = locs // locs is a special list, this is effectively the same as .Copy() but with less steps
		for(var/atom/exiting_loc as anything in old_locs)
			if(!exiting_loc.Exit(src, direction))
				return
	else if(!loc.Exit(src, direction))
		return

	var/list/new_locs
	if(is_multi_tile_object && isturf(newloc))
		var/dx = newloc.x
		var/dy = newloc.y
		var/dz = newloc.z
		new_locs = block(
			dx, dy, dz,
			dx + ceil(bound_width / 32), dy + ceil(bound_height / 32), dz
		) // If this is a multi-tile object then we need to predict the new locs and check if they allow our entrance.
		for(var/atom/entering_loc as anything in new_locs)
			if(!entering_loc.Enter(src))
				return
			if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, entering_loc) & COMPONENT_MOVABLE_BLOCK_PRE_MOVE)
				return
	else // Else just try to enter the single destination.
		if(!newloc.Enter(src))
			return
		if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, newloc) & COMPONENT_MOVABLE_BLOCK_PRE_MOVE)
			return

	// Past this is the point of no return
	var/atom/oldloc = loc
	var/area/oldarea = get_area(oldloc)
	var/area/newarea = get_area(newloc)

	SET_ACTIVE_MOVEMENT(oldloc, direction, FALSE, old_locs)
	loc = newloc

	. = TRUE

	if(old_locs) // This condition will only be true if it is a multi-tile object.
		for(var/atom/exited_loc as anything in (old_locs - new_locs))
			exited_loc.Exited(src, direction)
	else // Else there's just one loc to be exited.
		oldloc.Exited(src, direction)
	if(oldarea != newarea)
		oldarea.Exited(src, direction)

	for(var/atom/movable/thing as anything in oldloc)
		if(thing == src)
			continue
		thing.Uncrossed(src)

	if(new_locs) // Same here, only if multi-tile.
		for(var/atom/entered_loc as anything in (new_locs - old_locs))
			entered_loc.Entered(src, oldloc, old_locs)
	else
		newloc.Entered(src, oldloc, old_locs)
	if(oldarea != newarea)
		newarea.Entered(src, oldarea)

	for(var/atom/movable/thing as anything in newloc)
		if(thing == src)
			continue
		thing.Crossed(src)

	RESOLVE_ACTIVE_MOVEMENT

////////////////////////////////////////

/atom/movable/Move(atom/newloc, direction, glide_size_override = 0, update_dir = TRUE)
	var/atom/movable/pullee = pulling
	var/turf/current_turf = loc

	if(!moving_from_pull)
		check_pulling(z_allowed = TRUE)

	if(!loc || !newloc)
		return FALSE

	//Early override for some cases like diagonal movement
	if(glide_size_override && glide_size != glide_size_override)
		set_glide_size(glide_size_override)

	var/atom/oldloc = loc
	var/direction_to_move = direction

	if(loc != newloc)
		if (!(direction & (direction - 1))) //Cardinal move
			lastcardinal = direction
			. = ..()
		else //Diagonal move, split it into cardinal moves
			if(HAS_TRAIT(src, TRAIT_BLOCKED_DIAGONAL))
				if (direction & NORTH)
					if (direction & EAST)
						if(lastcardinal == NORTH)
							direction_to_move = EAST
							if(!step(src, EAST))
								direction_to_move = NORTH
								. = step(src, NORTH)
						else if(lastcardinal == EAST)
							direction_to_move = NORTH
							if(!step(src, NORTH))
								direction_to_move = EAST
								. = step(src, EAST)
						else
							direction_to_move = pick(NORTH, EAST)
							. = step(src, direction_to_move)
					else if (direction & WEST)
						if(lastcardinal == NORTH)
							direction_to_move = WEST
							if(!step(src, WEST))
								direction_to_move = NORTH
								. = step(src, NORTH)
						else if(lastcardinal == WEST)
							direction_to_move = NORTH
							if(!step(src, NORTH))
								direction_to_move = WEST
								. = step(src, WEST)
						else
							direction_to_move = pick(NORTH, WEST)
							. = step(src, direction_to_move)
				else if (direction & SOUTH)
					if (direction & EAST)
						if(lastcardinal == SOUTH)
							direction_to_move = EAST
							if(!step(src, EAST))
								direction_to_move = SOUTH
								. = step(src, SOUTH)
						else if(lastcardinal == EAST)
							direction_to_move = SOUTH
							if(!step(src, SOUTH))
								direction_to_move = EAST
								. = step(src, EAST)
						else
							direction_to_move = pick(SOUTH, EAST)
							. = step(src, direction_to_move)
					else if (direction & WEST)
						if(lastcardinal == SOUTH)
							direction_to_move = WEST
							if(!step(src, WEST))
								direction_to_move = SOUTH
								. = step(src, SOUTH)
						else if(lastcardinal == WEST)
							direction_to_move = SOUTH
							if(!step(src, SOUTH))
								direction_to_move = WEST
								. = step(src, WEST)
						else
							direction_to_move = pick(SOUTH, WEST)
							. = step(src, direction_to_move)
			else
				moving_diagonally = FIRST_DIAG_STEP
				var/first_step_dir
				// The `&& moving_diagonally` checks are so that a forceMove taking
				// place due to a Crossed, Bumped, etc. call will interrupt
				// the second half of the diagonal movement, or the second attempt
				// at a first half if step() fails because we hit something.
				if (direction & NORTH)
					if (direction & EAST)
						if (step(src, NORTH) && moving_diagonally)
							first_step_dir = NORTH
							moving_diagonally = SECOND_DIAG_STEP
							. = step(src, EAST)
						else if (moving_diagonally && step(src, EAST))
							first_step_dir = EAST
							moving_diagonally = SECOND_DIAG_STEP
							. = step(src, NORTH)
					else if (direction & WEST)
						if (step(src, NORTH) && moving_diagonally)
							first_step_dir = NORTH
							moving_diagonally = SECOND_DIAG_STEP
							. = step(src, WEST)
						else if (moving_diagonally && step(src, WEST))
							first_step_dir = WEST
							moving_diagonally = SECOND_DIAG_STEP
							. = step(src, NORTH)
				else if (direction & SOUTH)
					if (direction & EAST)
						if (step(src, SOUTH) && moving_diagonally)
							first_step_dir = SOUTH
							moving_diagonally = SECOND_DIAG_STEP
							. = step(src, EAST)
						else if (moving_diagonally && step(src, EAST))
							first_step_dir = EAST
							moving_diagonally = SECOND_DIAG_STEP
							. = step(src, SOUTH)
					else if (direction & WEST)
						if (step(src, SOUTH) && moving_diagonally)
							first_step_dir = SOUTH
							moving_diagonally = SECOND_DIAG_STEP
							. = step(src, WEST)
						else if (moving_diagonally && step(src, WEST))
							first_step_dir = WEST
							moving_diagonally = SECOND_DIAG_STEP
							. = step(src, SOUTH)
				if(moving_diagonally == SECOND_DIAG_STEP)
					if(!. && update_dir)
						setDir(first_step_dir)
				moving_diagonally = 0
				return

	if(!loc || (loc == oldloc && oldloc != newloc))
		last_move = 0
		set_currently_z_moving(FALSE, TRUE)
		return

	if(. && pulling && pulling == pullee && pulling != moving_from_pull) //we were pulling a thing and didn't lose it during our move.
		if(pulling.anchored)
			stop_pulling()
		else
			//puller and pullee more than one tile away or in diagonal position and whatever the pullee is pulling isn't already moving from a pull as it'll most likely result in an infinite loop a la ouroborus.
			if(!pulling.pulling?.moving_from_pull)
				var/pull_dir = get_dir(pulling, src)
				var/target_turf = current_turf

				// Pulling things down/up stairs. zMove() has flags for check_pulling and stop_pulling calls.
				// You may wonder why we're not just forcemoving the pulling movable and regrabbing it.
				// The answer is simple. forcemoving and regrabbing is ugly and breaks conga lines.
				if(pulling.z != z)
					target_turf = get_step(pulling, get_dir(pulling, current_turf))

				if(target_turf != current_turf || (moving_diagonally != SECOND_DIAG_STEP && ISDIAGONALDIR(pull_dir)) || get_dist(src, pulling) > 1)
					pulling.move_from_pull(src, target_turf, glide_size)
			if (pulledby)
				if (pulledby.currently_z_moving)
					check_pulling(z_allowed = TRUE)
				//don't call check_pulling() here at all if there is a pulledby that is not currently z moving
				//because it breaks stair conga lines, for some fucking reason.
				//it's fine because the pull will be checked when this whole proc is called by the mob doing the pulling anyways
			else
				check_pulling()

	//glide_size strangely enough can change mid movement animation and update correctly while the animation is playing
	//This means that if you don't override it late like this, it will just be set back by the movement update that's called when you move turfs.
	if(glide_size_override)
		set_glide_size(glide_size_override)

	last_move = direction_to_move

	if(!face_mouse && !throwing && dir != direction_to_move && update_dir)
		setDir(direction_to_move)
	if(. && has_buckled_mobs() && !handle_buckled_mob_movement(loc, direction_to_move, glide_size_override)) //movement failed due to buckled mob(s)
		. = FALSE

	if(. && pulledby && moving_diagonally != FIRST_DIAG_STEP) // EXPERIMENTAL: Fix grabs not breaking when pulling is moved by something else
		pulledby.check_pulling(only_pulling = TRUE, z_allowed = TRUE)

	if(currently_z_moving)
		if(. && loc == newloc)
			var/turf/pitfall = get_turf(src)
			pitfall.zFall(src, falling_from_move = TRUE)
		else
			set_currently_z_moving(FALSE, TRUE)

/// Called when src is being moved to a target turf because another movable (puller) is moving around.
/atom/movable/proc/move_from_pull(atom/movable/puller, turf/target_turf, glide_size_override)
	moving_from_pull = puller
	Move(target_turf, get_dir(src, target_turf), glide_size_override)
	moving_from_pull = null

/**
 * Called after a successful Move(). By this point, we've already moved.
 * Arguments:
 * * old_loc is the location prior to the move. Can be null to indicate nullspace.
 * * movement_dir is the direction the movement took place. Can be NONE if it was some sort of teleport.
 * * The forced flag indicates whether this was a forced move, which skips many checks of regular movement.
 * * The old_locs is an optional argument, in case the moved movable was present in multiple locations before the movement.
 **/
/atom/movable/proc/Moved(atom/old_loc, movement_dir, forced = FALSE, list/old_locs)
	SHOULD_CALL_PARENT(TRUE)

	var/turf/old_turf = get_turf(old_loc)
	var/turf/new_turf = get_turf(src)

	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, movement_dir, forced, old_locs)

	if(old_loc)
		SEND_SIGNAL(old_loc, COMSIG_ATOM_ABSTRACT_EXITED, src, movement_dir)
	if(loc)
		SEND_SIGNAL(loc, COMSIG_ATOM_ABSTRACT_ENTERED, src, old_loc, old_locs)

	if(HAS_SPATIAL_GRID_CONTENTS(src))
		if(old_turf && new_turf && (old_turf.z != new_turf.z \
			|| GET_SPATIAL_INDEX(old_turf.x) != GET_SPATIAL_INDEX(new_turf.x) \
			|| GET_SPATIAL_INDEX(old_turf.y) != GET_SPATIAL_INDEX(new_turf.y)))

			SSspatial_grid.exit_cell(src, old_turf)
			SSspatial_grid.enter_cell(src, new_turf)

		else if(old_turf && !new_turf)
			SSspatial_grid.exit_cell(src, old_turf)

		else if(new_turf && !old_turf)
			SSspatial_grid.enter_cell(src, new_turf)

	for(var/datum/light_source/L in light_sources) // Cycle through the light sources on this atom and tell them to update.
		L.source_atom?.update_light()

	return TRUE

// Make sure you know what you're doing if you call this, this is intended to only be called by byond directly.
// You probably want CanPass()
/atom/movable/Cross(atom/movable/AM)
	. = TRUE
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSS, AM)
	return CanPass(AM, AM.loc, TRUE)

//oldloc = old location on atom, inserted when forceMove is called and ONLY when forceMove is called!
/atom/movable/Crossed(atom/movable/AM, oldloc)
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSSED, AM)

/**
 * `Uncross()` is a default BYOND proc that is called when something is *going*
 * to exit this atom's turf. It is preferred over `Uncrossed` when you want to
 * deny that movement, such as in the case of border objects, objects that allow
 * you to walk through them in any direction except the one they block
 * (think side windows).
 *
 * While being seemingly harmless, almost everything doesn't actually want to
 * use this, meaning that we are wasting proc calls for every single atom
 * on a turf, every single time something exits it, when basically nothing
 * cares.
 *
 * This overhead caused real problems on Sybil round #159709, where lag
 * attributed to Uncross was so bad that the entire master controller
 * collapsed and people made Among Us lobbies in OOC.
 *
 * If you want to replicate the old `Uncross()` behavior, the most apt
 * replacement is [`/datum/element/connect_loc`] while hooking onto
 * [`COMSIG_ATOM_EXIT`].
 */
/atom/movable/Uncross()
	SHOULD_NOT_OVERRIDE(TRUE)
	CRASH("Uncross() should not be being called, please read the doc-comment for it for why.")

/atom/movable/Uncrossed(atom/movable/AM)
	SEND_SIGNAL(src, COMSIG_MOVABLE_UNCROSSED, AM)

/atom/movable/Bump(atom/A)
	if(!A)
		CRASH("Bump was called with no argument.")
	SEND_SIGNAL(src, COMSIG_MOVABLE_BUMP, A)
	. = ..()
	if(!QDELETED(throwing))
		throwing.finalize(hit = TRUE, target = A)
		. = TRUE
		if(QDELETED(A))
			return
	A.Bumped(src)

///Sets the anchored var and returns if it was successfully changed or not.
/atom/movable/proc/set_anchored(anchorvalue)
	SHOULD_CALL_PARENT(TRUE)
	if(anchored == anchorvalue)
		return
	. = anchored
	anchored = anchorvalue
	if(anchored && pulledby)
		pulledby.stop_pulling()
	SEND_SIGNAL(src, COMSIG_MOVABLE_SET_ANCHORED, anchorvalue)

/// Sets the currently_z_moving variable to a new value. Used to allow some zMovement sources to have precedence over others.
/atom/movable/proc/set_currently_z_moving(new_z_moving_value, forced = FALSE)
	if(forced)
		currently_z_moving = new_z_moving_value
		return TRUE
	var/old_z_moving_value = currently_z_moving
	currently_z_moving = max(currently_z_moving, new_z_moving_value)
	return currently_z_moving > old_z_moving_value

/atom/movable/proc/forceMove(atom/destination)
	. = FALSE
	if(QDELING(src))
		CRASH("Illegal forceMove() on qdeling [type]")
	if(destination)
		. = doMove(destination)
	else
		CRASH("[src] No valid destination passed into forceMove")

/atom/movable/proc/moveToNullspace()
	return doMove(null)

/atom/movable/proc/doMove(atom/destination)
	. = FALSE
	RESOLVE_ACTIVE_MOVEMENT

	var/atom/oldloc = loc

	SET_ACTIVE_MOVEMENT(oldloc, NONE, TRUE, null)

	if(destination)
		///zMove already handles whether a pull from another movable should be broken.
		if(pulledby && !currently_z_moving)
			pulledby.stop_pulling()

		var/same_loc = oldloc == destination
		var/area/old_area = get_area(oldloc)
		var/area/destarea = get_area(destination)

		loc = destination
		moving_diagonally = 0

		if(!same_loc)
			if(loc == oldloc)
				// when attempting to move an atom A into an atom B which already contains A, BYOND seems
				// to silently refuse to move A to the new loc. This can really break stuff (see #77067)
				stack_trace("Attempt to move [src] to [destination] was rejected by BYOND, possibly due to cyclic contents")
				return FALSE
			if(oldloc)
				oldloc.Exited(src, destination)
				if(old_area && old_area != destarea)
					old_area.Exited(src, destination)
			for(var/atom/movable/AM in oldloc)
				AM.Uncrossed(src)
			var/turf/oldturf = get_turf(oldloc)
			var/turf/destturf = get_turf(destination)
			var/old_z = (oldturf ? oldturf.z : null)
			var/dest_z = (destturf ? destturf.z : null)
			if (old_z != dest_z)
				onTransitZ(old_z, dest_z)
			destination.Entered(src, oldloc)
			if(destarea && old_area != destarea)
				destarea.Entered(src, oldloc)

			for(var/atom/movable/AM in destination)
				if(AM == src)
					continue
				AM.Crossed(src, oldloc)

		. = TRUE

	//If no destination, move the atom into nullspace (don't do this unless you know what you're doing)
	else
		. = TRUE
		loc = null
		if(oldloc)
			var/area/old_area = get_area(oldloc)
			oldloc.Exited(src, null)
			if(old_area)
				old_area.Exited(src, null)

	RESOLVE_ACTIVE_MOVEMENT

/atom/movable/proc/onTransitZ(old_z,new_z)
	SEND_SIGNAL(src, COMSIG_MOVABLE_Z_CHANGED, old_z, new_z)
	for (var/item in src) // Notify contents of Z-transition. This can be overridden IF we know the items contents do not care.
		var/atom/movable/AM = item
		AM.onTransitZ(old_z,new_z)

/atom/movable/proc/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	set waitfor = 0
	SEND_SIGNAL(src, COMSIG_MOVABLE_IMPACT, hit_atom, throwingdatum)
	return hit_atom.hitby(src, throwingdatum=throwingdatum)

/atom/movable/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked, datum/thrownthing/throwingdatum, damage_type = "blunt")
	if(!anchored && hitpush && (!throwingdatum || (throwingdatum.force >= (move_resist * MOVE_FORCE_PUSH_RATIO))))
		step(src, AM.dir)
	..()

/atom/movable/proc/safe_throw_at(atom/target, range, speed, mob/thrower, spin = FALSE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE)
	if((force < (move_resist * MOVE_FORCE_THROW_RATIO)) || (move_resist == INFINITY))
		return
	return throw_at(target, range, speed, thrower, spin, diagonals_first, callback, force, gentle = gentle)

/atom/movable/proc/throw_at(atom/target, range, speed, mob/thrower, spin = FALSE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE) //If this returns FALSE then callback will not be called.
	. = FALSE

	if(QDELETED(src))
		CRASH("Qdeleted thing being thrown around.")

	if (!target || speed <= 0)
		return

	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_THROW, args) & COMPONENT_CANCEL_THROW)
		return

	if (pulledby)
		pulledby.stop_pulling()

	//They are moving! Wouldn't it be cool if we calculated their momentum and added it to the throw?
	if (thrower && thrower.last_move && thrower.client && thrower.client.move_delay >= world.time + world.tick_lag*2)
		var/user_momentum = thrower.cached_multiplicative_slowdown
		if (!user_momentum) //no movement_delay, this means they move once per byond tick, lets calculate from that instead.
			user_momentum = world.tick_lag

		user_momentum = 1 / user_momentum // convert from ds to the tiles per ds that throw_at uses.

		if (get_dir(thrower, target) & last_move)
			user_momentum = user_momentum //basically a noop, but needed
		else if (get_dir(target, thrower) & last_move)
			user_momentum = -user_momentum //we are moving away from the target, lets slowdown the throw accordingly
		else
			user_momentum = 0


		if (user_momentum)
			//first lets add that momentum to range.
			range *= (user_momentum / speed) + 1
			//then lets add it to speed
			speed += user_momentum
			if (speed <= 0)
				return//no throw speed, the user was moving too fast.

	. = TRUE // No failure conditions past this point.

	var/target_zone
	if(QDELETED(thrower))
		thrower = null //Let's not pass a qdeleting reference if any.
	else
		target_zone = thrower.zone_selected

	var/datum/thrownthing/TT = new(src, target, get_dir(src, target), range, speed, thrower, diagonals_first, force, gentle, callback, target_zone)

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)
	var/dx = (target.x > src.x) ? EAST : WEST
	var/dy = (target.y > src.y) ? NORTH : SOUTH

	if (dist_x == dist_y)
		TT.pure_diagonal = 1

	else if(dist_x <= dist_y)
		var/olddist_x = dist_x
		var/olddx = dx
		dist_x = dist_y
		dist_y = olddist_x
		dx = dy
		dy = olddx
	TT.dist_x = dist_x
	TT.dist_y = dist_y
	TT.dx = dx
	TT.dy = dy
	TT.diagonal_error = dist_x/2 - dist_y
	TT.start_time = world.time

	if(pulledby)
		pulledby.stop_pulling()

	throwing = TT
	var/turf/curloc = get_turf(src)
	if(TT.target_turf && curloc)
		if(TT.target_turf.z > curloc.z)
			var/turf/above = GET_TURF_ABOVE(curloc)
			if(istype(above, /turf/open/openspace))
				forceMove(above)
	if(spin)
		do_spin_animation(5, 1)

	SEND_SIGNAL(src, COMSIG_MOVABLE_POST_THROW, TT, spin)
	SSthrowing.processing[src] = TT
	if (SSthrowing.state == SS_PAUSED && length(SSthrowing.currentrun))
		SSthrowing.currentrun[src] = TT
	TT.tick()

/atom/movable/proc/handle_buckled_mob_movement(newloc, direction, glide_size_override)
	for(var/mob/living/buckled_mob as anything in buckled_mobs)
		if(!buckled_mob.Move(newloc, direction, glide_size_override)) //If a mob buckled to us can't make the same move as us
			Move(buckled_mob.loc, direction) //Move back to its location
			last_move = buckled_mob.last_move
			inertia_dir = last_move
			buckled_mob.inertia_dir = last_move
			return FALSE
	return TRUE

/atom/movable/proc/force_pushed(atom/movable/pusher, force = MOVE_FORCE_DEFAULT, direction)
	return FALSE

/atom/movable/proc/force_push(atom/movable/AM, force = move_force, direction, silent = FALSE)
	. = AM.force_pushed(src, force, direction)
	if(!silent && .)
		visible_message("<span class='warning'>[src] forcefully pushes against [AM]!</span>", "<span class='warning'>I forcefully push against [AM]!</span>")

/atom/movable/proc/move_crush(atom/movable/AM, force = move_force, direction, silent = FALSE)
	. = AM.move_crushed(src, force, direction)
	if(!silent && .)
		visible_message("<span class='danger'>[src] crushes past [AM]!</span>", "<span class='danger'>I crush [AM]!</span>")

/atom/movable/proc/move_crushed(atom/movable/pusher, force = MOVE_FORCE_DEFAULT, direction)
	return FALSE

/atom/movable/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(mover in buckled_mobs)
		return TRUE

/// Returns true or false to allow src to move through the blocker, mover has final say
/atom/movable/proc/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	SHOULD_CALL_PARENT(TRUE)
	return blocker_opinion

// called when this atom is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/atom/movable/proc/on_exit_storage(datum/component/storage/concrete/S)
	return

// called when this atom is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/atom/movable/proc/on_enter_storage(datum/component/storage/concrete/S)
	return

//called when a mob resists while inside a container that is itself inside something.
/atom/movable/proc/relay_container_resist(mob/living/user, obj/O)
	return

/atom
	var/no_bump_effect = TRUE

/mob
	no_bump_effect = FALSE

#define ATTACK_ANIMATION_PIXEL_DIFF 12
#define ATTACK_ANIMATION_TIME 1

/**
 * Does an attack animation on the target that either uses the used_item icon or an effect from 'icons/effects/effects.dmi'
 *
 * @param {atom} attacked_atom - The thing getting attacked
 * @param visual_effect_icon - The effect drawn on top of attacked_atom
 * @param used_item - The item used to draw the swing animation
 * @param {bool} no_effect - if TRUE, prevents any attack animation on the target
 * @param item_animation_override - String to determine animation_type of swing animation. Overrides used_intent
 * @param {datum} used_intent - Intent used to determine animation_type of swing animation
 * @param {bool} atom_bounce - Whether the src bounces when doing an attack animation
 */
/atom/movable/proc/do_attack_animation(atom/attacked_atom, visual_effect_icon, obj/item/used_item, no_effect, item_animation_override = null, datum/intent/used_intent, atom_bounce, fov_effect = TRUE)
	if(!no_effect && (visual_effect_icon || used_item))
		var/animation_type = item_animation_override || used_intent?.get_attack_animation_type()
		do_item_attack_animation(attacked_atom, visual_effect_icon, used_item, animation_type = animation_type)

	if(!atom_bounce || attacked_atom == src)
		return //don't do an animation if attacking self

	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/turn_dir = 1

	var/direction = get_dir(src, attacked_atom)
	if(direction & NORTH)
		pixel_y_diff = ATTACK_ANIMATION_PIXEL_DIFF
		turn_dir = prob(50) ? -1 : 1
	else if(direction & SOUTH)
		pixel_y_diff = -ATTACK_ANIMATION_PIXEL_DIFF
		turn_dir = prob(50) ? -1 : 1

	if(direction & EAST)
		pixel_x_diff = 12
	else if(direction & WEST)
		pixel_x_diff = -ATTACK_ANIMATION_PIXEL_DIFF
		turn_dir = -1

	if(fov_effect)
		play_fov_effect(attacked_atom, 5, "attack")

	var/matrix/initial_transform = matrix(transform)
	var/matrix/rotated_transform = transform.Turn(15 * turn_dir)
	animate(
		src,
		pixel_x = pixel_x + pixel_x_diff,
		pixel_y = pixel_y + pixel_y_diff,
		transform = rotated_transform,
		time = ATTACK_ANIMATION_TIME,
		easing = LINEAR_EASING,
		flags = ANIMATION_PARALLEL
		)
	animate(
		pixel_x = pixel_x - pixel_x_diff,
		pixel_y = pixel_y - pixel_y_diff,
		transform = initial_transform,
		time = ATTACK_ANIMATION_TIME  * 2,
		easing = SINE_EASING,
		flags = ANIMATION_PARALLEL
		)


/atom/movable/proc/do_item_attack_animation(atom/attacked_atom, visual_effect_icon, obj/item/used_item, animation_type = ATTACK_ANIMATION_SWIPE)
	if (visual_effect_icon)
		var/mutable_appearance/attack_appearance = mutable_appearance('icons/effects/effects.dmi', visual_effect_icon)
		attack_appearance.plane = GAME_PLANE
		// Scale the icon.
		attack_appearance.transform *= 0.4
		// The icon should not rotate.
		attack_appearance.appearance_flags = APPEARANCE_UI
		var/atom/movable/flick_visual/attack = attacked_atom.flick_overlay_view(attack_appearance, 1 SECONDS)
		var/matrix/copy_transform = new(initial(transform))
		attack.dir = get_dir(src, attacked_atom)
		animate(
			attack,
			alpha = 175,
			transform = copy_transform.Scale(0.75),
			time = 0.3 SECONDS
		)
		animate(
			time = 0.1 SECONDS
			)
		animate(
			alpha = 0,
			time = 0.3 SECONDS,
			easing = BACK_EASING|EASE_OUT
			)

	if (!used_item)
		return

	var/mutable_appearance/attack_appearance = mutable_appearance(used_item.icon, used_item.icon_state)
	attack_appearance.plane = GAME_PLANE
	attack_appearance.pixel_w = used_item.pixel_x + used_item.pixel_w
	attack_appearance.pixel_z = used_item.pixel_y + used_item.pixel_z
	// Scale the icon.
	attack_appearance.transform *= 0.5
	// The icon should not rotate.
	attack_appearance.appearance_flags = APPEARANCE_UI

	var/atom/movable/flick_visual/attack = attacked_atom.flick_overlay_view(attack_appearance, 1 SECONDS)
	var/matrix/copy_transform = new(transform)
	var/x_sign = 0
	var/y_sign = 0
	var/direction = get_dir(src, attacked_atom)
	if (direction & NORTH)
		y_sign = -1
	else if (direction & SOUTH)
		y_sign = 1

	if (direction & EAST)
		x_sign = -1
	else if (direction & WEST)
		x_sign = 1

	// Attacking self, or something on the same turf as us
	if (!direction)
		y_sign = 1
		// Not a fan of this, but its the "cleanest" way to animate this
		x_sign = 0.25 * (prob(50) ? 1 : -1)
		// For piercing attacks
		direction = SOUTH

	// And animate the attack!
	switch (animation_type)
		if (ATTACK_ANIMATION_BONK)
			attack.pixel_x = attack.base_pixel_x + 14 * x_sign
			attack.pixel_y = attack.base_pixel_y + 12 * y_sign
			animate(
				attack,
				alpha = 175,
				transform = copy_transform.Scale(0.75),
				pixel_x = 4 * x_sign,
				pixel_y = 3 * y_sign,
				time = 0.2 SECONDS
				)
			animate(
				time = 0.1 SECONDS
				)
			animate(
				alpha = 0,
				time = 0.1 SECONDS,
				easing = BACK_EASING|EASE_OUT
				)

		if (ATTACK_ANIMATION_THRUST)
			var/attack_angle = dir2angle(direction) + rand(-7, 7)
			// Deducting 90 because we're assuming that icon_angle of 0 means an east-facing sprite
			var/anim_angle = attack_angle - 90 + used_item.icon_angle
			var/angle_mult = 1
			if (x_sign && y_sign)
				angle_mult = 1.4
			attack.pixel_x = attack.base_pixel_x + 22 * x_sign * angle_mult
			attack.pixel_y = attack.base_pixel_y + 18 * y_sign * angle_mult
			attack.transform = attack.transform.Turn(anim_angle)
			copy_transform = copy_transform.Turn(anim_angle)
			animate(
				attack,
				pixel_x = (22 * x_sign - 12 * sin(attack_angle)) * angle_mult,
				pixel_y = (18 * y_sign - 8 * cos(attack_angle)) * angle_mult,
				time = 0.1 SECONDS,
				easing = BACK_EASING|EASE_OUT,
			)
			animate(
				attack,
				alpha = 175,
				transform = copy_transform.Scale(0.75),
				pixel_x = (22 * x_sign + 26 * sin(attack_angle)) * angle_mult,
				pixel_y = (18 * y_sign + 22 * cos(attack_angle)) * angle_mult,
				time = 0.3 SECONDS,
				easing = BACK_EASING|EASE_OUT,
			)
			animate(
				alpha = 0,
				pixel_x = -3 * -(x_sign + sin(attack_angle)),
				pixel_y = -2 * -(y_sign + cos(attack_angle)),
				time = 0.1 SECONDS,
				easing = BACK_EASING|EASE_OUT
			)

		if (ATTACK_ANIMATION_SWIPE)
			attack.pixel_x = attack.base_pixel_x + 18 * x_sign
			attack.pixel_y = attack.base_pixel_y + 14 * y_sign
			var/x_rot_sign = 0
			var/y_rot_sign = 0
			var/attack_dir = (prob(50) ? 1 : -1)
			var/anim_angle = dir2angle(direction) - 90 + used_item.icon_angle

			if (x_sign)
				y_rot_sign = attack_dir
			if (y_sign)
				x_rot_sign = attack_dir

			// Animations are flipped, so flip us too!
			if (x_sign > 0 || y_sign < 0)
				attack_dir *= -1

			// We're swinging diagonally, use separate logic
			var/anim_dir = attack_dir
			if (x_sign && y_sign)
				if (attack_dir < 0)
					x_rot_sign = -x_sign * 1.4
					y_rot_sign = 0
				else
					x_rot_sign = 0
					y_rot_sign = -y_sign * 1.4

				// Flip us if we've been flipped *unless* we're flipped due to both axis
				if ((x_sign < 0 && y_sign > 0) || (x_sign > 0 && y_sign < 0))
					anim_dir *= -1

			attack.pixel_x += 10 * x_rot_sign
			attack.pixel_y += 8 * y_rot_sign
			attack.transform = attack.transform.Turn(anim_angle - 45 * anim_dir)
			copy_transform = copy_transform.Scale(0.75)
			animate(attack, alpha = 175, time = 0.3 SECONDS, flags = ANIMATION_PARALLEL)
			animate(time = 0.1 SECONDS)
			animate(alpha = 0, time = 0.1 SECONDS, easing = BACK_EASING|EASE_OUT)

			animate(attack, transform = copy_transform.Turn(anim_angle + 45 * anim_dir), time = 0.3 SECONDS, flags = ANIMATION_PARALLEL)

			var/x_return = 10 * -x_rot_sign
			var/y_return = 8 * -y_rot_sign

			if (!x_rot_sign)
				x_return = 18 * x_sign
			if (!y_rot_sign)
				y_return = 14 * y_sign

			var/angle_mult = 1
			if (x_sign && y_sign)
				angle_mult = 1.4
				if (attack_dir > 0)
					x_return = 8 * x_sign
					y_return = 14 * y_sign
				else
					x_return = 18 * x_sign
					y_return = 6 * y_sign

			animate(attack, pixel_x = 4 * x_sign * angle_mult, time = 0.2 SECONDS, easing = CIRCULAR_EASING | EASE_IN, flags = ANIMATION_PARALLEL)
			animate(pixel_x = x_return, time = 0.2 SECONDS, easing = CIRCULAR_EASING | EASE_OUT)

			animate(attack, pixel_y = 3 * y_sign * angle_mult, time = 0.2 SECONDS, easing = CIRCULAR_EASING | EASE_IN, flags = ANIMATION_PARALLEL)
			animate(pixel_y = y_return, time = 0.2 SECONDS, easing = CIRCULAR_EASING | EASE_OUT)

/obj/effect/temp_visual/dir_setting/attack_effect
	icon = 'icons/effects/effects.dmi'
	duration = 3
	alpha = 200

/obj/effect/temp_visual/dir_setting/block //color is white by default, set to whatever is needed
	icon = 'icons/effects/effects.dmi'
	duration = 3.5
	alpha = 100
	plane = ABOVE_LIGHTING_PLANE

/obj/effect/temp_visual/dir_setting/block/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	. = ..()
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 9)

/atom/movable/proc/do_warning()
	var/image/I
	I = image('icons/effects/effects.dmi', src, "mobwarning", src.layer + 0.1)
	I.pixel_y = 16
	flick_overlay(I, GLOB.clients, 5)

/atom/movable/vv_get_dropdown()
	. = ..()
	. += "<option value='?_src_=holder;[HrefToken()];adminplayerobservefollow=[REF(src)]'>Follow</option>"
	. += "<option value='?_src_=holder;[HrefToken()];admingetmovable=[REF(src)]'>Get</option>"

/atom/movable/proc/ex_check(ex_id)
	if(!ex_id)
		return TRUE
	LAZYINITLIST(acted_explosions)
	if(ex_id in acted_explosions)
		return FALSE
	acted_explosions += ex_id
	return TRUE

/* Language procs */
/atom/movable/proc/get_language_holder(shadow=TRUE)
	RETURN_TYPE(/datum/language_holder)
	if(QDELING(src))
		CRASH("get_language_holder() called on a QDELing atom, \
			this will try to re-instantiate the language holder that's about to be deleted, which is bad.")

	if(!language_holder)
		language_holder = new initial_language_holder(src)
	return language_holder

/atom/movable/proc/grant_language(datum/language/dt, body = FALSE)
	var/datum/language_holder/H = get_language_holder(!body)
	H.grant_language(dt, body)

/atom/movable/proc/grant_all_languages(omnitongue=FALSE)
	var/datum/language_holder/H = get_language_holder()
	H.grant_all_languages(omnitongue)

/atom/movable/proc/get_random_understood_language()
	var/datum/language_holder/H = get_language_holder()
	. = H.get_random_understood_language()

/// Gets a list of all mutually understood languages.
/atom/movable/proc/get_partially_understood_languages()
	return get_language_holder().get_partially_understood_languages()

/// Grants partial understanding of a language.
/atom/movable/proc/grant_partial_language(language, amount = 50)
	return get_language_holder().grant_partial_language(language, amount)

/atom/movable/proc/remove_language(datum/language/dt, body = FALSE)
	var/datum/language_holder/H = get_language_holder(!body)
	H.remove_language(dt, body)

/atom/movable/proc/remove_all_languages()
	var/datum/language_holder/H = get_language_holder()
	H.remove_all_languages()

/// Removes partial understanding of a language.
/atom/movable/proc/remove_partial_language(language)
	return get_language_holder().remove_partial_language(language)

/// Removes all partial languages.
/atom/movable/proc/remove_all_partial_languages()
	return get_language_holder().remove_all_partial_languages()

/atom/movable/proc/has_language(datum/language/dt)
	var/datum/language_holder/H = get_language_holder()
	. = H.has_language(dt)

/atom/movable/proc/copy_known_languages_from(thing, replace=FALSE)
	var/datum/language_holder/H = get_language_holder()
	. = H.copy_known_languages_from(thing, replace)

// Whether an AM can speak in a language or not, independent of whether
// it KNOWS the language
/atom/movable/proc/could_speak_in_language(datum/language/dt)
	. = TRUE

/atom/movable/proc/can_speak_in_language(datum/language/dt)
	var/datum/language_holder/H = get_language_holder()
	if(!H.has_language(dt) || HAS_TRAIT(src, TRAIT_LANGUAGE_BARRIER))
		return FALSE
	else if(H.omnitongue)
		return TRUE
	else if(could_speak_in_language(dt) && (!H.only_speaks_language || H.only_speaks_language == dt))
		return TRUE
	return FALSE

/atom/movable/proc/get_default_language()
	// if no language is specified, and we want to say() something, which
	// language do we use?
	var/datum/language_holder/H = get_language_holder()

	if(H.selected_default_language)
		if(can_speak_in_language(H.selected_default_language))
			return H.selected_default_language
		else
			H.selected_default_language = null


	var/datum/language/chosen_langtype
	var/highest_priority

	for(var/datum/language/langtype as anything in H.languages)
		if(!ispath(langtype))
			langtype = text2path(langtype)

		if(!can_speak_in_language(langtype))
			continue

		var/pri = initial(langtype.default_priority)
		if(!highest_priority || (pri > highest_priority))
			chosen_langtype = langtype
			highest_priority = pri

	H.selected_default_language = .
	. = chosen_langtype

//Returns an atom's power cell, if it has one. Overload for individual items.
/atom/movable/proc/get_cell()
	return

/atom/movable/proc/can_be_pulled(user, grab_state, force)
	if(SEND_SIGNAL(src, COMSIG_ATOM_CAN_BE_PULLED, user) & COMSIG_ATOM_CANT_PULL)
		return FALSE
	if(throwing)
		return FALSE
	if(force < (move_resist * MOVE_FORCE_PULL_RATIO))
		return FALSE
	return TRUE

/// Updates the grab state of the movable
/// This exists to act as a hook for behaviour
/atom/movable/proc/setGrabState(newstate)
	if(newstate == grab_state)
		return
	SEND_SIGNAL(src, COMSIG_MOVABLE_SET_GRAB_STATE, newstate)
	. = grab_state
	grab_state = newstate
	switch(.) //Previous state.
		if(GRAB_PASSIVE, GRAB_AGGRESSIVE)
			if(grab_state >= GRAB_NECK)
				ADD_TRAIT(pulling, TRAIT_IMMOBILIZED, CHOKEHOLD_TRAIT)
				ADD_TRAIT(pulling, TRAIT_FLOORED, CHOKEHOLD_TRAIT)
	switch(grab_state) //Current state.
		if(GRAB_PASSIVE, GRAB_AGGRESSIVE)
			if(. >= GRAB_NECK)
				REMOVE_TRAIT(pulling, TRAIT_IMMOBILIZED, CHOKEHOLD_TRAIT)
				REMOVE_TRAIT(pulling, TRAIT_FLOORED, CHOKEHOLD_TRAIT)

/**
 * meant for movement with zero side effects. only use for objects that are supposed to move "invisibly" (like eye mobs or ghosts)
 * if you want something to move onto a tile with a beartrap or recycler or tripmine or mouse without that object knowing about it at all, use this
 * most of the time you want forceMove()
 */
/atom/movable/proc/abstract_move(atom/new_loc)
	RESOLVE_ACTIVE_MOVEMENT // This should NEVER happen, but, just in case...
	var/atom/old_loc = loc
	var/direction = get_dir(old_loc, new_loc)
	loc = new_loc
	Moved(old_loc, direction, TRUE)

/atom/movable/proc/pushed(new_loc, dir_pusher_to_pushed, glize_size, pusher_dir)
	if(!Move(new_loc, dir_pusher_to_pushed, glize_size))
		return FALSE

	after_pushed(arglist(args))

	return TRUE

/// called after this atom has been successfully pushed
/atom/movable/proc/after_pushed(new_loc, dir_pusher_to_pushed, glize_size, pusher_dir)
	if(pusher_dir)
		setDir(dir_pusher_to_pushed)

#undef ATTACK_ANIMATION_PIXEL_DIFF
#undef ATTACK_ANIMATION_TIME
