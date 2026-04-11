#define STAIR_TERMINATOR_AUTOMATIC 0
#define STAIR_TERMINATOR_NO 1
#define STAIR_TERMINATOR_YES 2

// dir determines the direction of travel to go upwards
// stairs require /turf/open/openspace as the tile above them to work, unless your stairs have 'force_open_above' set to TRUE
// multiple stair objects can be chained together; the Z level transition will happen on the final stair object in the chain

/obj/structure/stairs
	name = "stairs"
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs"
	base_icon_state = "stairs"
	anchored = TRUE
	move_resist = INFINITY
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

	/// If TRUE replaces the turf above this stair obj with /turf/open/openspace
	var/force_open_above = FALSE
	/// Determines if this stair is the last in a "chain" of stairs, ie next step is upstairs
	VAR_FINAL/terminator_mode = STAIR_TERMINATOR_AUTOMATIC
	/// Upstairs turf. Is observed for changes if force_open_above is TRUE (to re-open if necessary)
	VAR_FINAL/turf/directly_above
	/// If TRUE, we have left/middle/right sprites.
	var/has_merged_sprites = FALSE

/obj/structure/stairs/Initialize(mapload)
	. = ..()

	GLOB.stairs += src
	if(force_open_above)
		force_open_above()
		build_signal_listener()
	update_surrounding()

	var/static/list/exit_connections = list(
		COMSIG_ATOM_EXIT = PROC_REF(on_exit_stairs),
	)

	AddElement(/datum/element/connect_loc, exit_connections)
	AddElement(/datum/element/give_turf_traits, string_list(list(TRAIT_IMMERSE_STOPPED)))

/obj/structure/stairs/Destroy()
	if(directly_above)
		UnregisterSignal(directly_above, COMSIG_TURF_MULTIZ_NEW)
		directly_above = null
	GLOB.stairs -= src
	return ..()

/obj/structure/stairs/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change) //Look this should never happen but...
	. = ..()
	if(force_open_above)
		build_signal_listener()
	update_surrounding()

/// Updates the sprite and the sprites of neighboring stairs to reflect merged sprites
/obj/structure/stairs/proc/update_surrounding()
	if(!has_merged_sprites)
		return

	update_appearance()

	for(var/obj/structure/stairs/stair in get_step(src, turn(dir, 90)))
		stair.update_appearance()

	for(var/obj/structure/stairs/stair in get_step(src, turn(dir, -90)))
		stair.update_appearance()

/obj/structure/stairs/update_icon_state()
	. = ..()
	if(!has_merged_sprites)
		return

	var/has_left_stairs = FALSE
	var/has_right_stairs = FALSE
	for(var/obj/structure/stairs/stair in get_step(src, turn(dir, 90)))
		if(stair.dir == dir)
			has_left_stairs = TRUE
			break

	for(var/obj/structure/stairs/stair in get_step(src, turn(dir, -90)))
		if(stair.dir == dir)
			has_right_stairs = TRUE
			break

	if(has_left_stairs && has_right_stairs)
		icon_state = "[base_icon_state]-m"
	else if(has_left_stairs)
		icon_state = "[base_icon_state]-r"
	else if(has_right_stairs)
		icon_state = "[base_icon_state]-l"
	else
		icon_state = base_icon_state

/obj/structure/stairs/proc/on_exit_stairs(datum/source, atom/movable/leaving, direction)
	SIGNAL_HANDLER

	if(leaving == src)
		return //Let's not block ourselves.

	if(!isobserver(leaving) && isTerminator() && direction == dir && get_target_loc(direction))
		leaving.set_currently_z_moving(CURRENTLY_Z_ASCENDING)
		INVOKE_ASYNC(src, PROC_REF(stair_ascend), leaving)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

// /obj/structure/stairs/Cross(atom/movable/AM)
// 	if(isTerminator() && (get_dir(src, AM) == dir))
// 		return FALSE
// 	return ..()

/obj/structure/stairs/proc/stair_ascend(atom/movable/climber)
	var/turf/checking = get_step_multiz(src, UP)
	if(!istype(checking))
		return
	// I'm only interested in if the pass is unobstructed, not if the mob will actually make it
	if(!climber.can_z_move(UP, get_turf(src), checking, z_move_flags = ZMOVE_ALLOW_BUCKLED))
		return
	var/turf/target = GET_TURF_ABOVE_DIAGONAL(src, dir|UP)
	if(istype(target) && !climber.can_z_move(DOWN, target, z_move_flags = ZMOVE_FALL_FLAGS)) //Don't throw them into a tile that will just dump them back down.
		climber.zMove(target = target, z_move_flags = ZMOVE_STAIRS_FLAGS)
		/// Moves anything that's being dragged by src or anything buckled to it to the stairs turf.
		if(climber.pulling && !(climber.pulling in climber.buckled_mobs)) // EXPERIMENTAL: conflict between pulling move and buckled move
			climber.pulling?.move_from_pull(climber, loc, climber.glide_size)
		for(var/mob/living/buckled as anything in climber.buckled_mobs)
			if(buckled == climber.pulling) // EXPERIMENTAL: conflict between pulling move and buckled move
				continue
			buckled.pulling?.move_from_pull(buckled, loc, buckled.glide_size)

/obj/structure/stairs/vv_edit_var(var_name, var_value)
	. = ..()
	if(!.)
		return
	if(var_name != NAMEOF(src, force_open_above))
		return
	if(!var_value)
		if(directly_above)
			UnregisterSignal(directly_above, COMSIG_TURF_MULTIZ_NEW)
			directly_above = null
	else
		build_signal_listener()
		force_open_above()

/obj/structure/stairs/proc/build_signal_listener()
	if(directly_above)
		UnregisterSignal(directly_above, COMSIG_TURF_MULTIZ_NEW)
	var/turf/open/openspace/T = get_step_multiz(src, UP)
	RegisterSignal(T, COMSIG_TURF_MULTIZ_NEW, PROC_REF(on_multiz_new))
	directly_above = T

/obj/structure/stairs/proc/force_open_above()
	var/turf/open/openspace/T = get_step_multiz(src, UP)
	if(T && !istype(T))
		T.ChangeTurf(/turf/open/openspace, flags = CHANGETURF_INHERIT_AIR)

/obj/structure/stairs/proc/on_multiz_new(turf/source, dir)
	SIGNAL_HANDLER

	if(dir == UP)
		var/turf/open/openspace/T = get_step_multiz(src, UP)
		if(T && !istype(T))
			T.ChangeTurf(/turf/open/openspace, flags = CHANGETURF_INHERIT_AIR)

/obj/structure/stairs/intercept_zImpact(list/falling_movables, levels = 1)
	. = ..()
	// falling from a higher z level onto stairs
	if(levels != 1 || !isTerminator())
		return
	for(var/mob/living/guy in falling_movables)
		if(!can_fall_down_stairs(guy))
			continue
		to_chat(guy, span_warning("You trip down [src]!"))
		on_fall(guy)
	. |= FALL_INTERCEPTED | FALL_NO_MESSAGE | FALL_RETAIN_PULL

/// Will the passed mob tumble down the stairs instead of walking?
/obj/structure/stairs/proc/can_fall_down_stairs(mob/living/falling)
	if(falling.buckled || falling.pulledby)
		return FALSE
	if(falling.stat >= UNCONSCIOUS) // if you shove someone unconscious down the stairs, they'd probably roll
		return TRUE
	if(falling.IsOffBalanced()) // off balance
		return TRUE
	return FALSE

/// What happens when a mob tumbles down the stairs
/obj/structure/stairs/proc/on_fall(mob/living/falling)
	falling.AdjustParalyzed(1 SECONDS)
	falling.OffBalance(1 SECONDS)
	falling.AdjustKnockdown(2.5 SECONDS)
	falling.spin(1 SECONDS, 0.25 SECONDS)
	falling.apply_damage(rand(4, 8), BRUTE, spread_damage = TRUE)
	SSmove_manager.move_towards(falling, get_ranged_target_turf(src, REVERSE_DIR(dir), 2), delay = 0.4 SECONDS, timeout = 1 SECONDS)

/obj/structure/stairs/proc/isTerminator() //If this is the last stair in a chain and should move mobs up
	if(terminator_mode != STAIR_TERMINATOR_AUTOMATIC)
		return (terminator_mode == STAIR_TERMINATOR_YES)
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	var/turf/them = get_step(T, dir)
	if(!them)
		return FALSE
	for(var/obj/structure/stairs/S in them)
		if(S.dir == dir)
			return FALSE
	return TRUE

/obj/structure/stairs/abyss
	name = "abyss stairs"
	icon = 'icons/delver/abyss_objects.dmi'
	icon_state = "abyss_stairs"

/obj/structure/stairs/stone
	name = "stone stairs"
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stonestairs"

// original icon = 'icons/roguetown/topadd/cre/enigma_misc1.dmi'
/obj/structure/stairs/stone/church
	name = "stone stairs"
	icon = 'icons/obj/stairs.dmi'
	icon_state = "churchstairs"

//	climb_offset = 10
	//RTD animate climbing offset so this can be here

/obj/structure/stairs/fancy
	icon_state = "fancy_stairs"

/obj/structure/stairs/fancy/c
	icon_state = "fancy_stairs_c"
	uses_lord_coloring = LORD_PRIMARY

/obj/structure/stairs/fancy/r
	icon_state = "fancy_stairs_r"
	uses_lord_coloring = LORD_PRIMARY

/obj/structure/stairs/fancy/l
	icon_state = "fancy_stairs_l"
	uses_lord_coloring = LORD_PRIMARY

/obj/structure/stairs/OnCrafted(dirin, mob/user)
	dir = dirin
	var/turf/partner = get_step_multiz(src, dirin|UP)
	if(isopenturf(partner))
		var/obj/structure/stairs/stairs = locate() in partner
		if(!stairs)
			stairs = new /obj/structure/stairs(partner)
		stairs.dir = dir
	. = ..()

/obj/structure/stairs/d/OnCrafted(dirin, mob/user)
	SHOULD_CALL_PARENT(FALSE)
	SEND_SIGNAL(user, COMSIG_ITEM_CRAFTED, user, type)
	record_featured_stat(FEATURED_STATS_CRAFTERS, user)
	record_featured_object_stat(FEATURED_STATS_CRAFTED_ITEMS, name)
	add_abstract_elastic_data(ELASCAT_CRAFTING, "[name]", 1)

	dir = dirin
	var/turf/partner = get_step(src, turn(dir, 180))
	if(!isopenturf(partner))
		return
	partner = get_step_multiz(src, turn(dir, 180)|DOWN)
	if(isopenturf(partner))
		var/obj/structure/stairs/stairs = locate() in partner
		if(!stairs)
			stairs = new /obj/structure/stairs(partner)
		stairs.dir = dir
	return

/obj/structure/stairs/stone/d/OnCrafted(dirin, mob/user)
	SHOULD_CALL_PARENT(FALSE)
	SEND_SIGNAL(user, COMSIG_ITEM_CRAFTED, user, type)
	record_featured_stat(FEATURED_STATS_CRAFTERS, user)
	record_featured_object_stat(FEATURED_STATS_CRAFTED_ITEMS, name)
	add_abstract_elastic_data(ELASCAT_CRAFTING, "[name]", 1)

	dir = dirin
	var/turf/partner = get_step(src, turn(dir, 180))
	if(!isopenturf(partner))
		return
	partner = get_step_multiz(src, turn(dir, 180)|DOWN)
	if(isopenturf(partner))
		var/obj/structure/stairs/stairs = locate() in partner
		if(!stairs)
			stairs = new /obj/structure/stairs/stone(partner)
		stairs.dir = dir
	return

/// From a cardinal direction, returns the resulting turf we'll end up at if we're uncrossing the stairs. Used for pathfinding, mostly.
/obj/structure/stairs/proc/get_transit_destination(dirmove)
	return get_target_loc(dirmove) || get_step(src, dirmove) // just normal movement if we failed to find a matching stair

/// Get the turf above/below us corresponding to the direction we're moving on the stairs.
/obj/structure/stairs/proc/get_target_loc(dirmove)
	var/turf/newtarg
	if(dirmove == dir)
		// the optimization macro here is beacuse this can be called in pathfinding
		// and therefore can be quite expensive
		newtarg = GET_TURF_ABOVE_DIAGONAL(get_turf(src), UP|dirmove)
	else if(dirmove == REVERSE_DIR(dir))
		newtarg = GET_TURF_BELOW_DIAGONAL(get_turf(src), DOWN|dirmove)
	if(!newtarg)
		return // nowhere to move to???
	for(var/obj/structure/stairs/partner in newtarg)
		if(partner.dir == dir) // partner matches our dir
			return newtarg

#undef STAIR_TERMINATOR_AUTOMATIC
#undef STAIR_TERMINATOR_NO
#undef STAIR_TERMINATOR_YES
