/turf/open/openspace
	name = "open space"
	desc = "My eyes can see far down below."
	icon_state = MAP_SWITCH("openspace", "openspacemap")
	baseturfs = /turf/open/openspace
	intact = FALSE
	CanAtmosPassVertical = ATMOS_PASS_YES
	var/can_cover_up = TRUE
	var/can_build_on = TRUE
	dynamic_lighting = 1
	path_weight = 500
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_FLOOR_OPEN_SPACE
	smoothing_list = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_CLOSED_WALL
	neighborlay_self = "staticedge"

/turf/open/openspace/Initialize() // handle plane and layer here so that they don't cover other obs/turfs in Dream Maker
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON, PROC_REF(on_atom_created))
	return INITIALIZE_HINT_LATELOAD

/turf/open/openspace/LateInitialize()
	. = ..()
	ADD_TURF_TRANSPARENCY(src, INNATE_TRAIT)

/turf/open/openspace/ChangeTurf(path, list/new_baseturfs, flags)
	UnregisterSignal(src, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON)
	return ..()

/**
 * Prepares a moving movable to be precipitated if Move() is successful.
 * This is done in Enter() and not Entered() because there's no easy way to tell
 * if the latter was called by Move() or forceMove() while the former is only called by Move().
 */
/turf/open/openspace/Enter(atom/movable/movable, atom/oldloc)
	. = ..()
	if(.)
		//higher priority than CURRENTLY_Z_FALLING so the movable doesn't fall on Entered()
		movable.set_currently_z_moving(CURRENTLY_Z_FALLING_FROM_MOVE)

///Makes movables fall when forceMove()'d to this turf.
/turf/open/openspace/Entered(atom/movable/movable)
	. = ..()
	if(movable.set_currently_z_moving(CURRENTLY_Z_FALLING))
		zFall(movable, falling_from_move = TRUE)
/**
 * Drops movables spawned on this turf after they are successfully initialized.
 * so that spawned movables that should fall to gravity, will fall.
 */
/turf/open/openspace/proc/on_atom_created(datum/source, atom/created_atom)
	SIGNAL_HANDLER
	if(ismovable(created_atom))
		zfall_if_on_turf(created_atom)

/turf/open/openspace/proc/zfall_if_on_turf(atom/movable/movable)
	if(QDELETED(movable) || movable.loc != src)
		return
	zFall(movable)

/turf/open/openspace/can_cross_safely(atom/movable/crossing)
	return HAS_TRAIT(crossing, TRAIT_MOVE_FLYING) || !crossing.can_z_move(DOWN, src, z_move_flags = ZMOVE_FALL_FLAGS)

/turf/open/openspace/add_neighborlay(dir, edgeicon, offset = FALSE)
	var/add
	var/y = 0
	var/x = 0
	switch(dir)
		if(NORTH)
			add = "[edgeicon]-n"
			y = -32
		if(SOUTH)
			add = "[edgeicon]-s"
			y = 32
		if(EAST)
			add = "[edgeicon]-e"
			x = -32
		if(WEST)
			add = "[edgeicon]-w"
			x = 32

	if(!add)
		return

	var/image/overlay = image(icon, src, add, pixel_x = offset ? x : 0, pixel_y = offset ? y : 0 )

	LAZYADDASSOC(neighborlay_list, "[dir]", overlay)
	add_overlay(overlay)

/turf/open/openspace/zAirIn()
	return TRUE

/turf/open/openspace/zAirOut()
	return TRUE

/turf/open/openspace/zPassIn(direction)
	if(direction == DOWN)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_IN_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_IN_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/openspace/zPassOut(direction)
	if(direction == DOWN)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_OUT_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/contained_object in contents)
			if(contained_object.obj_flags & BLOCK_Z_OUT_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/openspace/proc/CanCoverUp()
	return can_cover_up

/turf/open/openspace/proc/CanBuildHere()
	return can_build_on

/turf/open/openspace/attack_paw(mob/user)
	return attack_hand(user)

/turf/open/openspace/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(isliving(user))
		. = TRUE
		var/new_flags = Z_MOVE_CLIMBING_FLAGS & ~ZMOVE_LYING_CHECKS
		if(!user.can_z_move(DOWN, src, GET_TURF_BELOW(src), z_move_flags = new_flags|ZMOVE_FEEDBACK))
			return
		INVOKE_ASYNC(src, PROC_REF(start_traveling), user, DOWN)

/turf/open/openspace/proc/start_traveling(mob/living/user, direction)
	var/turf/target = get_step_multiz(src, direction)
	user.visible_message(span_warning("[user] starts to climb down."), span_warning("I start to climb down."))
	if(user.m_intent != MOVE_INTENT_SNEAK)
		playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
	if(do_after(user, 3 SECONDS, src))
		user.zMove(target = target, z_move_flags = Z_MOVE_CLIMBING_FLAGS)
		if(user.m_intent != MOVE_INTENT_SNEAK)
			playsound(user, 'sound/foley/climb.ogg', 100, TRUE)

/turf/open/openspace/attack_ghost(mob/dead/observer/user)
	var/turf/target = GET_TURF_BELOW(src)
	if(!user.Adjacent(src))
		return
	if(!target)
		to_chat(user, "<span class='warning'>I can't go there.</span>")
		return
	user.forceMove(target)
	to_chat(user, "<span class='warning'>I glide down.</span>")
	. = ..()
