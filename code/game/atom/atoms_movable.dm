/atom/movable
	layer = OBJ_LAYER
	var/last_move = null
	var/last_move_time = 0
	var/anchored = FALSE
	var/move_resist = MOVE_RESIST_DEFAULT
	var/move_force = MOVE_FORCE_DEFAULT
	var/pull_force = PULL_FORCE_DEFAULT
	var/datum/thrownthing/throwing = null
	var/throw_speed = 1 //How many tiles to move per ds when being thrown. Float values are fully supported
	var/throw_range = 7
	var/mob/pulledby = null
	var/initial_language_holder = /datum/language_holder
	var/datum/language_holder/language_holder
	var/verb_say = "says"
	var/verb_ask = "asks"
	var/verb_exclaim = "exclaims"
	var/verb_yell = "yells"
	var/speech_span
	var/inertia_dir = 0
	var/atom/inertia_last_loc
	var/inertia_moving = 0
	var/inertia_next_move = 0
	var/inertia_move_delay = 5
	var/pass_flags = 0
	var/moving_diagonally = 0 //0: not doing a diagonal move. 1 and 2: doing the first/second step of the diagonal move
	var/lastcardinal = 0
	var/lastcardpress = 0
	var/atom/movable/moving_from_pull		//attempt to resume grab after moving instead of before.
	var/list/acted_explosions	//for explosion dodging
	glide_size = 6
	appearance_flags = TILE_BOUND|PIXEL_SCALE
	var/datum/forced_movement/force_moving = null	//handled soley by forced_movement.dm
	///Holds information about any movement loops currently running/waiting to run on the movable. Lazy, will be null if nothing's going on
	var/datum/movement_packet/move_packet
	/// Incase you have multiple types, you automatically use the most useful one. IE: Skating on ice, flippers on water, flying over chasm/space, etc.
	var/movement_type = GROUND
	var/atom/movable/pulling
	var/atom_flags = NONE
	var/grab_state = 0
	var/throwforce = 0
	var/datum/component/orbiter/orbiting
	/// Either FALSE, [EMISSIVE_BLOCK_GENERIC], or [EMISSIVE_BLOCK_UNIQUE]
	var/blocks_emissive = FALSE
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

/atom/movable/Initialize(mapload)
	. = ..()
	switch(blocks_emissive)
		if(EMISSIVE_BLOCK_GENERIC)
			update_emissive_block()
		if(EMISSIVE_BLOCK_UNIQUE)
			render_target = ref(src)
			em_block = new(src, render_target)
			vis_contents += em_block

/atom/movable/Destroy()
	QDEL_NULL(em_block)
	if(spatial_grid_key)
		SSspatial_grid.force_remove_from_grid(src)

	LAZYCLEARLIST(client_mobs_in_contents)

	LAZYCLEARLIST(important_recursive_contents)//has to be before moveToNullspace() so that we can exit our spatial_grid cell if we're in it
	return ..()


/atom/movable/Exited(atom/movable/gone, direction)
	. = ..()

	if(!LAZYLEN(gone.important_recursive_contents))
		return
	var/list/nested_locs = get_nested_locs(src) + src
	for(var/channel in gone.important_recursive_contents)
		for(var/atom/movable/location as anything in nested_locs)
			var/list/recursive_contents = location.important_recursive_contents // blue hedgehog velocity
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
	ADD_TRAIT(src, TRAIT_HEARING_SENSITIVE, trait_source)
	if(!HAS_TRAIT(src, TRAIT_HEARING_SENSITIVE))
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
	UnregisterSignal(src, COMSIG_ATOM_REMOVE_TRAIT)
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
		var/list/recursive_contents = movable_loc.important_recursive_contents // blue hedgehog velocity
		recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS] -= src
		if(!length(recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS]))
			SSspatial_grid.remove_grid_awareness(movable_loc, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)
		ASSOC_UNSETEMPTY(recursive_contents, RECURSIVE_CONTENTS_CLIENT_MOBS)
		UNSETEMPTY(movable_loc.important_recursive_contents)


/atom/movable/proc/update_emissive_block()
	if(blocks_emissive != EMISSIVE_BLOCK_GENERIC)
		return
	if(length(managed_vis_overlays))
		for(var/a in managed_vis_overlays)
			var/obj/effect/overlay/vis/vs
			if(vs.plane == EMISSIVE_BLOCKER_PLANE)
				SSvis_overlays.remove_vis_overlay(src, list(vs))
				break
	SSvis_overlays.add_vis_overlay(src, icon, icon_state, EMISSIVE_BLOCKER_LAYER, EMISSIVE_BLOCKER_PLANE, dir)

/atom/movable/proc/can_safely_descend(turf/target)
	return TRUE

/atom/movable/proc/can_zFall(turf/source, levels = 1, turf/target, direction)
	if(!direction)
		direction = DOWN
	if(!source)
		source = get_turf(src)
		if(!source)
			return FALSE
	if(!target)
		target = get_step_multiz(source, direction)
		if(!target)
			return FALSE

	if((movement_type & FLYING) && HAS_TRAIT(src, TRAIT_HOLLOWBONES))
		var/turf/below = GET_TURF_BELOW(source)
		if(isopenspace(below))
			return TRUE

	return !(movement_type & FLYING) && has_gravity(source) && !throwing

/atom/movable/proc/onZImpact(turf/T, levels)
	var/atom/highest = T
	for(var/i in T.contents)
		var/atom/A = i
		if(!A.density)
			continue
		if(isobj(A) || ismob(A))
			if(A.layer > highest.layer)
				highest = A
//	INVOKE_ASYNC(src, PROC_REF(SpinAnimation), 5, 2)
	throw_impact(highest)
	return TRUE

//For physical constraints to travelling up/down.
/atom/movable/proc/can_zTravel(turf/destination, direction, override_source)
	var/turf/T = get_turf(src)
	if(override_source)
		T = override_source
	if(!T)
		return FALSE
	if(!direction)
		if(!destination)
			return FALSE
		direction = get_dir(T, destination)
	if(direction != UP && direction != DOWN)
		return FALSE
	if(!destination)
		destination = get_step_multiz(T, direction)
		if(!destination)
			return FALSE
	if(T.zPassOut(src, direction, destination) && destination.zPassIn(src, direction, T))
		return TRUE

/atom/movable/vv_edit_var(var_name, var_value)
	var/static/list/banned_edits = list("step_x", "step_y", "step_size", "bounds")
	var/static/list/careful_edits = list("bound_x", "bound_y", "bound_width", "bound_height")
	if(var_name in banned_edits)
		return FALSE	//PLEASE no.
	if((var_name in careful_edits) && (var_value % world.icon_size) != 0)
		return FALSE
	switch(var_name)
		if("x")
			var/turf/T = locate(var_value, y, z)
			if(T)
				forceMove(T)
				return TRUE
			return FALSE
		if("y")
			var/turf/T = locate(x, var_value, z)
			if(T)
				forceMove(T)
				return TRUE
			return FALSE
		if("z")
			var/turf/T = locate(x, y, var_value)
			if(T)
				forceMove(T)
				return TRUE
			return FALSE
		if("loc")
			if(istype(var_value, /atom))
				forceMove(var_value)
				return TRUE
			else if(isnull(var_value))
				moveToNullspace()
				return TRUE
			return FALSE
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

/atom/movable/proc/stop_pulling(forced = TRUE)
	if(pulling)
		if(pulling != src)
			pulling.set_pulledby(null)
			var/mob/living/ex_pulled = pulling
			pulling = null
			SEND_SIGNAL(ex_pulled, COMSIG_ATOM_NO_LONGER_PULLED, src)
	setGrabState(GRAB_PASSIVE)

/atom/movable/proc/Move_Pulled(atom/A)
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
	if(A == loc && pulling.density)
		return FALSE
	var/move_dir = get_dir(pulling.loc, A)
	if(!Process_Spacemove(move_dir))
		return FALSE
	var/turf/pre_turf = get_turf(pulling)
	pulling.Move(get_step(pulling.loc, move_dir), move_dir, glide_size)
	var/turf/post_turf = get_turf(pulling)
	if(pre_turf.snow && !post_turf.snow)
		SEND_SIGNAL(pre_turf.snow, COMSIG_MOB_OVERLAY_FORCE_REMOVE, pulling)
		if(ismob(src))
			var/mob/source = src
			source.update_vision_cone()
	return TRUE

/mob/living/Move_Pulled(atom/A)
	. = ..()
	if(!. || !isliving(A))
		return
	var/mob/living/L = A
	set_pull_offsets(L, grab_state)

/atom/movable/proc/check_pulling()
	if(pulling)
		var/atom/movable/pullee = pulling
		if(pullee && get_dist(src, pullee) > 1)
			stop_pulling()
			return
		if(!isturf(loc))
			stop_pulling()
			return
		if(pullee && !isturf(pullee.loc) && pullee.loc != loc) //to be removed once all code that changes an object's loc uses forceMove().
			log_game("DEBUG:[src]'s pull on [pullee] wasn't broken despite [pullee] being in [pullee.loc]. Pull stopped manually.")
			stop_pulling()
			return
		if(pulling.anchored || pulling.move_resist > move_force)
			stop_pulling()
			return
	if(pulledby && moving_diagonally != FIRST_DIAG_STEP && get_dist(src, pulledby) > 1)		//separated from our puller and not in the middle of a diagonal move.
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
/atom/movable/Move(atom/newloc, direct=0, glide_size_override = 0)
	. = FALSE
	if(!newloc || newloc == loc)
		return

	if(!direct)
		direct = get_dir(src, newloc)
	if(!(atom_flags & NO_DIR_CHANGE) && !throwing)
		setDir(direct)

	if(!loc.Exit(src, newloc))
		return

	if(!newloc.Enter(src, src.loc))
		return

	if (SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, newloc) & COMPONENT_MOVABLE_BLOCK_PRE_MOVE)
		return

	// Past this is the point of no return
	var/atom/oldloc = loc
	var/area/oldarea = get_area(oldloc)
	var/area/newarea = get_area(newloc)
	loc = newloc
	. = TRUE
	if(oldloc)
		oldloc.Exited(src, newloc)
	if(oldarea)
		if(oldarea != newarea)
			oldarea.Exited(src, newloc)

	for(var/i in oldloc)
		if(i == src) // Multi tile objects
			continue
		var/atom/movable/thing = i
		thing.Uncrossed(src)

	newloc.Entered(src, oldloc)
	if(oldarea != newarea)
		newarea.Entered(src, oldloc)

	for(var/i in loc)
		if(i == src) // Multi tile objects
			continue
		var/atom/movable/thing = i
		thing.Crossed(src)

////////////////////////////////////////

/atom/movable/Move(atom/newloc, direct, glide_size_override = 0)
	var/atom/movable/pullee = pulling
	var/turf/T = loc
	if(!moving_from_pull)
		check_pulling()
	if(!loc || !newloc)
		return FALSE
	var/atom/oldloc = loc
	var/direction_to_move = direct

	//Early override for some cases like diagonal movement
	if(glide_size_override)
		set_glide_size(glide_size_override)

	if(loc != newloc)
		if (!(direct & (direct - 1))) //Cardinal move
			lastcardinal = direct
			. = ..()
		else //Diagonal move, split it into cardinal moves
			if (direct & NORTH)
				if (direct & EAST)
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
						direction_to_move = pick(NORTH,EAST)
						. = step(src, direction_to_move)
				else if (direct & WEST)
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
						direction_to_move = pick(NORTH,WEST)
						. = step(src, direction_to_move)
			else if (direct & SOUTH)
				if (direct & EAST)
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
						direction_to_move = pick(SOUTH,EAST)
						. = step(src, direction_to_move)
				else if (direct & WEST)
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
						direction_to_move = pick(SOUTH,WEST)
						. = step(src, direction_to_move)

	if(!loc || (loc == oldloc && oldloc != newloc))
		last_move = 0
		return

	if(.)
		Moved(oldloc, direct)
	if(. && pulling && pulling == pullee && pulling != moving_from_pull) //we were pulling a thing and didn't lose it during our move.
		if(pulling.anchored)
			stop_pulling()
		else
			var/pull_dir = get_dir(src, pulling)
			//puller and pullee more than one tile away or in diagonal position
			if(get_dist(src, pulling) > 1 || (moving_diagonally != SECOND_DIAG_STEP && ((pull_dir - 1) & pull_dir)))
				pulling.moving_from_pull = src
				pulling.Move(T, get_dir(pulling, T), glide_size) //the pullee tries to reach our previous position
				pulling.moving_from_pull = null
			check_pulling()

	//glide_size strangely enough can change mid movement animation and update correctly while the animation is playing
	//This means that if you don't override it late like this, it will just be set back by the movement update that's called when you move turfs.
	if(glide_size_override)
		set_glide_size(glide_size_override)

	last_move = direct
	if(!(atom_flags & NO_DIR_CHANGE) && !throwing)
		setDir(direction_to_move)
	if(. && has_buckled_mobs() && !handle_buckled_mob_movement(loc,direct, glide_size_override)) //movement failed due to buckled mob(s)
		return FALSE
	return TRUE

//Called after a successful Move(). By this point, we've already moved
/atom/movable/proc/Moved(atom/OldLoc, Dir, Forced = FALSE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, OldLoc, Dir, Forced)
	if (!inertia_moving)
		inertia_next_move = world.time + inertia_move_delay
		newtonian_move(Dir)

	var/turf/old_turf = get_turf(OldLoc)
	var/turf/new_turf = get_turf(src)

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

	return TRUE

/atom/movable/Destroy(force)
	QDEL_NULL(proximity_monitor)
	QDEL_NULL(language_holder)

	unbuckle_all_mobs(force=1)

	. = ..()
	if(loc)
		//Restore air flow if we were blocking it (movables with ATMOS_PASS_PROC will need to do this manually if necessary)
		if(((CanAtmosPass == ATMOS_PASS_DENSITY && density) || CanAtmosPass == ATMOS_PASS_NO) && isturf(loc))
			CanAtmosPass = ATMOS_PASS_YES
			air_update_turf(TRUE)
		loc.handle_atom_del(src)
	for(var/atom/movable/AM in contents)
		qdel(AM)
	moveToNullspace()
	invisibility = INVISIBILITY_ABSTRACT
	if(pulledby)
		pulledby.stop_pulling()

	if(move_packet)
		if(!QDELETED(move_packet))
			qdel(move_packet)
		move_packet = null

	if(orbiting)
		orbiting.end_orbit(src)
		orbiting = null

// Make sure you know what you're doing if you call this, this is intended to only be called by byond directly.
// You probably want CanPass()
/atom/movable/Cross(atom/movable/AM)
	. = TRUE
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSS, AM)
	return CanPass(AM, AM.loc, TRUE)

//oldloc = old location on atom, inserted when forceMove is called and ONLY when forceMove is called!
/atom/movable/Crossed(atom/movable/AM, oldloc)
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSSED, AM)

/atom/movable/Uncross(atom/movable/AM, atom/newloc)
	. = ..()
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_UNCROSS, AM,) & COMPONENT_MOVABLE_BLOCK_UNCROSS)
		return FALSE
	if(isturf(newloc) && !CheckExit(AM, newloc))
		return FALSE

/atom/movable/Uncrossed(atom/movable/AM)
	SEND_SIGNAL(src, COMSIG_MOVABLE_UNCROSSED, AM)

/atom/movable/Bump(atom/A)
	if(!A)
		CRASH("Bump was called with no argument.")
	SEND_SIGNAL(src, COMSIG_MOVABLE_BUMP, A)
	. = ..()
	if(!QDELETED(throwing))
		throwing.hit_atom(A)
		. = TRUE
		if(QDELETED(A))
			return
	A.Bumped(src)

/atom/movable/proc/forceMove(atom/destination)
	. = FALSE
	if(destination)
		. = doMove(destination)
	else
		CRASH("[src] No valid destination passed into forceMove")

/atom/movable/proc/moveToNullspace()
	return doMove(null)

/atom/movable/proc/doMove(atom/destination)
	. = FALSE
	if(destination)
		if(pulledby)
			pulledby.stop_pulling()
		var/atom/oldloc = loc
		var/same_loc = oldloc == destination
		var/area/old_area = get_area(oldloc)
		var/area/destarea = get_area(destination)

		loc = destination
		moving_diagonally = 0

		if(!same_loc)
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

		Moved(oldloc, NONE, TRUE)
		. = TRUE

	//If no destination, move the atom into nullspace (don't do this unless you know what you're doing)
	else
		. = TRUE
		if (loc)
			var/atom/oldloc = loc
			var/area/old_area = get_area(oldloc)
			oldloc.Exited(src, null)
			if(old_area)
				old_area.Exited(src, null)
		loc = null

/atom/movable/proc/onTransitZ(old_z,new_z)
	SEND_SIGNAL(src, COMSIG_MOVABLE_Z_CHANGED, old_z, new_z)
	for (var/item in src) // Notify contents of Z-transition. This can be overridden IF we know the items contents do not care.
		var/atom/movable/AM = item
		AM.onTransitZ(old_z,new_z)

///Proc to modify the movement_type and hook behavior associated with it changing.
/atom/movable/proc/setMovetype(newval)
	if(movement_type == newval)
		return
	. = movement_type
	movement_type = newval

//Called whenever an object moves and by mobs when they attempt to move themselves through space
//And when an object or action applies a force on src, see newtonian_move() below
//Return 0 to have src start/keep drifting in a no-grav area and 1 to stop/not start drifting
//Mobs should return 1 if they should be able to move of their own volition, see client/Move() in mob_movement.dm
//movement_dir == 0 when stopping or any dir when trying to move
/atom/movable/proc/Process_Spacemove(movement_dir = 0)
	if(has_gravity(src))
		return 1

	if(pulledby)
		return 1

	if(throwing)
		return 1

	if(!isturf(loc))
		return 1

	return 0


/atom/movable/proc/newtonian_move(direction) //Only moves the object if it's under no gravity
	if(!loc || Process_Spacemove(0))
		inertia_dir = 0
		return 0

	inertia_dir = direction
	if(!direction)
		return 1
	inertia_last_loc = loc
	SSspacedrift.processing[src] = src
	return 1

/atom/movable/proc/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	set waitfor = 0
	SEND_SIGNAL(src, COMSIG_MOVABLE_IMPACT, hit_atom, throwingdatum)
	return hit_atom.hitby(src, throwingdatum=throwingdatum)

/atom/movable/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked, datum/thrownthing/throwingdatum, damage_type = "blunt")
	if(!anchored && hitpush && (!throwingdatum || (throwingdatum.force >= (move_resist * MOVE_FORCE_PUSH_RATIO))))
		step(src, AM.dir)
	..()

/atom/movable/proc/safe_throw_at(atom/target, range, speed, mob/thrower, spin = FALSE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG)
	if((force < (move_resist * MOVE_FORCE_THROW_RATIO)) || (move_resist == INFINITY))
		return
	return throw_at(target, range, speed, thrower, spin, diagonals_first, callback, force)

/atom/movable/proc/throw_at(atom/target, range, speed, mob/thrower, spin = FALSE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, extra = FALSE) //If this returns FALSE then callback will not be called.
	. = FALSE
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

	var/datum/thrownthing/TT = new()
	TT.thrownthing = src
	TT.target = target
	TT.target_turf = get_turf(target)
	TT.init_dir = get_dir(src, target)
	TT.maxrange = range
	TT.speed = speed
	TT.thrower = thrower
	TT.diagonals_first = diagonals_first
	TT.force = force
	TT.callback = callback
	TT.extra = extra
	if(!QDELETED(thrower))
		TT.target_zone = thrower.zone_selected

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
			var/turf/above = get_step_multiz(curloc, UP)
			if(istype(above, /turf/open/transparent/openspace))
				forceMove(above)
	spin = FALSE
	if(spin)
		SpinAnimation(5, 1)

	SEND_SIGNAL(src, COMSIG_MOVABLE_POST_THROW, TT, spin)
	SSthrowing.processing[src] = TT
	if (SSthrowing.state == SS_PAUSED && length(SSthrowing.currentrun))
		SSthrowing.currentrun[src] = TT
	TT.tick()

/atom/movable/proc/handle_buckled_mob_movement(newloc, direct, glide_size_override)
	for(var/m in buckled_mobs)
		var/mob/living/buckled_mob = m
		if(!buckled_mob.Move(newloc, direct, glide_size_override))
			forceMove(buckled_mob.loc)
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

/atom/movable/CanPass(atom/movable/mover, turf/target)
	if(mover in buckled_mobs)
		return 1
	return ..()

// called when this atom is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/atom/movable/proc/on_exit_storage(datum/component/storage/concrete/S)
	return

// called when this atom is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/atom/movable/proc/on_enter_storage(datum/component/storage/concrete/S)
	return

/atom/movable/proc/get_spacemove_backup()
	var/atom/movable/dense_object_backup
	for(var/A in orange(1, get_turf(src)))
		if(isarea(A))
			continue
		else if(isturf(A))
			var/turf/turf = A
			if(!turf.density)
				continue
			return turf
		else
			var/atom/movable/AM = A
			if(!AM.CanPass(src) || AM.density)
				if(AM.anchored)
					return AM
				dense_object_backup = AM
				break
	. = dense_object_backup

//called when a mob resists while inside a container that is itself inside something.
/atom/movable/proc/relay_container_resist(mob/living/user, obj/O)
	return

/atom
	var/no_bump_effect = TRUE

/mob
	no_bump_effect = FALSE

GLOBAL_VAR_INIT(pixel_diff, 12)
GLOBAL_VAR_INIT(pixel_diff_time, 1)

/atom/movable/proc/do_attack_animation(atom/attacked_atom, visual_effect_icon, obj/item/used_item, no_effect, item_animation_override = null, datum/intent/used_intent)
	if(used_item)
		var/animation_type = item_animation_override || used_intent?.get_attack_animation_type()
		do_item_attack_animation(attacked_atom, visual_effect_icon, used_item, animation_type = animation_type)

	if(attacked_atom == src)
		return //don't do an animation if attacking self
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/turn_dir = 1

	var/direction = get_dir(src, attacked_atom)
	if(direction & NORTH)
		pixel_y_diff = GLOB.pixel_diff
		turn_dir = prob(50) ? -1 : 1
	else if(direction & SOUTH)
		pixel_y_diff = -GLOB.pixel_diff
		turn_dir = prob(50) ? -1 : 1

	if(direction & EAST)
		pixel_x_diff = GLOB.pixel_diff
	else if(direction & WEST)
		pixel_x_diff = -GLOB.pixel_diff
		turn_dir = -1

	var/matrix/initial_transform = matrix(transform)
	var/matrix/rotated_transform = transform.Turn(15 * turn_dir)
	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, transform=rotated_transform, time = GLOB.pixel_diff_time, easing=LINEAR_EASING, flags = ANIMATION_PARALLEL)
	animate(pixel_x = pixel_x - pixel_x_diff, pixel_y = pixel_y - pixel_y_diff, transform=initial_transform, time = GLOB.pixel_diff_time * 2, easing=SINE_EASING, flags = ANIMATION_PARALLEL)


/atom/movable/proc/do_item_attack_animation(atom/attacked_atom, visual_effect_icon, obj/item/used_item, animation_type = ATTACK_ANIMATION_SWIPE)
	if (visual_effect_icon)
		var/image/attack_image = image(icon = 'icons/effects/effects.dmi', icon_state = visual_effect_icon)
		attack_image.plane = attacked_atom.plane + 1
		// Scale the icon.
		attack_image.transform *= 0.4
		// The icon should not rotate.
		attack_image.appearance_flags = APPEARANCE_UI
		var/atom/movable/flick_visual/attack = attacked_atom.flick_overlay_view(attack_image, 1 SECONDS)
		var/matrix/copy_transform = new(transform)
		animate(attack, alpha = 175, transform = copy_transform.Scale(0.75), time = 0.3 SECONDS)
		animate(time = 0.1 SECONDS)
		animate(alpha = 0, time = 0.3 SECONDS, easing = BACK_EASING|EASE_OUT)

	if (isnull(used_item))
		return

	var/image/attack_image = image(icon = used_item, icon_state = used_item.icon_state)
	attack_image.plane = attacked_atom.plane + 1
	attack_image.pixel_w = used_item.pixel_x + used_item.pixel_w
	attack_image.pixel_z = used_item.pixel_y + used_item.pixel_z
	// Scale the icon.
	attack_image.transform *= 0.5
	// The icon should not rotate.
	attack_image.appearance_flags = APPEARANCE_UI

	var/atom/movable/flick_visual/attack = attacked_atom.flick_overlay_view(attack_image, 1 SECONDS)
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
			attack.pixel_x = 14 * x_sign
			attack.pixel_y = 12 * y_sign
			animate(attack, alpha = 175, transform = copy_transform.Scale(0.75), pixel_x = 4 * x_sign, pixel_y = 3 * y_sign, time = 0.2 SECONDS)
			animate(time = 0.1 SECONDS)
			animate(alpha = 0, time = 0.1 SECONDS, easing = BACK_EASING|EASE_OUT)

		if (ATTACK_ANIMATION_THRUST)
			var/attack_angle = dir2angle(direction) + rand(-7, 7)
			// Deducting 90 because we're assuming that icon_angle of 0 means an east-facing sprite
			var/anim_angle = attack_angle - 90 + used_item.icon_angle
			var/angle_mult = 1
			if (x_sign && y_sign)
				angle_mult = 1.4
			attack.pixel_x = 22 * x_sign * angle_mult
			attack.pixel_y = 18 * y_sign * angle_mult
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
			attack.pixel_x = 18 * x_sign
			attack.pixel_y = 14 * y_sign
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
	layer = ABOVE_LIGHTING_LAYER
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

//TODO: Better floating
/atom/movable/proc/float(on)
	if(throwing)
		return
	if(on && !(movement_type & FLOATING))
		animate(src, pixel_y = pixel_y + 2, time = 1 SECONDS, loop = -1, flags = ANIMATION_RELATIVE)
		animate(pixel_y = pixel_y - 2, time = 1 SECONDS, loop = -1, flags = ANIMATION_RELATIVE)
		setMovetype(movement_type | FLOATING)
	else if (!on && (movement_type & FLOATING))
		animate(src, pixel_y = initial(pixel_y), time = 1 SECONDS)
		setMovetype(movement_type & ~FLOATING)

/* Language procs */
/atom/movable/proc/get_language_holder(shadow=TRUE)
	RETURN_TYPE(/datum/language_holder)
	if(language_holder)
		return language_holder
	else
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

	for(var/lt in H.languages)
		var/datum/language/langtype = lt
		if(!can_speak_in_language(langtype))
			continue

		var/pri = initial(langtype.default_priority)
		if(!highest_priority || (pri > highest_priority))
			chosen_langtype = langtype
			highest_priority = pri

	H.selected_default_language = .
	. = chosen_langtype

/* End language procs */
/atom/movable/proc/ConveyorMove(movedir)
	set waitfor = FALSE
	if(!anchored && has_gravity())
		step(src, movedir)

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

/obj/item/proc/do_pickup_animation(atom/target)
	set waitfor = FALSE
	if(!istype(loc, /turf))
		return
	var/image/I = image(icon = src, loc = loc, layer = layer + 0.1)
	I.plane = GAME_PLANE
	I.transform *= 0.75
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	var/turf/T = get_turf(src)
	var/direction
	var/to_x = 0
	var/to_y = 0

	if(!QDELETED(T) && !QDELETED(target))
		direction = get_dir(T, target)
	if(direction & NORTH)
		to_y = 32
	else if(direction & SOUTH)
		to_y = -32
	if(direction & EAST)
		to_x = 32
	else if(direction & WEST)
		to_x = -32
	if(!direction)
		to_y = 16
	flick_overlay(I, GLOB.clients, 6)
	var/matrix/M = new
	M.Turn(pick(-30, 30))
	animate(I, alpha = 175, pixel_x = to_x, pixel_y = to_y, time = 3, transform = M, easing = CUBIC_EASING)
	sleep(1)
	animate(I, alpha = 0, transform = matrix(), time = 1)

/**
 * meant for movement with zero side effects. only use for objects that are supposed to move "invisibly" (like eye mobs or ghosts)
 * if you want something to move onto a tile with a beartrap or recycler or tripmine or mouse without that object knowing about it at all, use this
 * most of the time you want forceMove()
 */
/atom/movable/proc/abstract_move(atom/new_loc)
	var/atom/old_loc = loc
	var/direction = get_dir(old_loc, new_loc)
	loc = new_loc
	Moved(old_loc, direction, TRUE)
