// stairs require /turf/open/openspace as the tile above them to work
// multiple stair objects can be chained together; the Z level transition will happen on the final stair object in the chain

/obj/structure/stairs
	name = "stairs"
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs"
	anchored = TRUE
	layer = 2
	obj_flags = CAN_BE_HIT | IGNORE_SINK | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	no_over_text = TRUE
	var/should_sink = FALSE

/obj/structure/stairs/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

	if(should_sink)
		obj_flags &= ~IGNORE_SINK

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
	dir = dirin
	var/turf/partner = get_step_multiz(src, turn(dir, 180)|DOWN)
	if(isopenturf(partner))
		var/obj/structure/stairs/stairs = locate() in partner
		if(!stairs)
			stairs = new /obj/structure/stairs(partner)
		stairs.dir = dir
	SEND_SIGNAL(user, COMSIG_ITEM_CRAFTED, user, type)
	record_featured_stat(FEATURED_STATS_CRAFTERS, user)
	record_featured_object_stat(FEATURED_STATS_CRAFTED_ITEMS, name)
	add_abstract_elastic_data(ELASCAT_CRAFTING, "[name]", 1)
	return

/obj/structure/stairs/stone/d/OnCrafted(dirin, mob/user)
	SHOULD_CALL_PARENT(FALSE)
	dir = dirin
	var/turf/partner = get_step_multiz(src, turn(dir, 180)|DOWN)
	if(isopenturf(partner))
		var/obj/structure/stairs/stairs = locate() in partner
		if(!stairs)
			stairs = new /obj/structure/stairs/stone(partner)
		stairs.dir = dir
	SEND_SIGNAL(user, COMSIG_ITEM_CRAFTED, user, type)
	record_featured_stat(FEATURED_STATS_CRAFTERS, user)
	record_featured_object_stat(FEATURED_STATS_CRAFTED_ITEMS, name)
	add_abstract_elastic_data(ELASCAT_CRAFTING, "[name]", 1)
	return

/obj/structure/stairs/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER

	if(isobserver(leaving))
		return

	if(user_walk_into_target_loc(leaving, get_dir(src, new_location)))
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

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

/obj/structure/stairs/proc/user_walk_into_target_loc(atom/movable/AM, dirmove)
	var/turf/newtarg = get_target_loc(dirmove)
	if(newtarg)
		INVOKE_ASYNC(src, GLOBAL_PROC_REF(movable_travel_z_level), AM, newtarg)
		return TRUE
	return FALSE

/// A helper proc to handle chained atoms moving across Z-levels. Currently only handles mobs pulling movables.
/proc/movable_travel_z_level(atom/movable/AM, turf/newtarg)
	if(!isliving(AM))
		AM.forceMove(newtarg)
		return
	var/mob/living/L = AM
	var/atom/movable/pulling = L.pulling
	var/was_pulled_buckled = FALSE
	if(pulling)
		if(pulling in L.buckled_mobs)
			was_pulled_buckled = TRUE
	L.forceMove(newtarg)
	if(pulling)
		L.stop_pulling()
		pulling.forceMove(newtarg)
		L.start_pulling(pulling, suppress_message = TRUE)
		if(was_pulled_buckled)
			var/mob/living/M = pulling
			if(M.body_position != LYING_DOWN)	// piggyback carry
				L.buckle_mob(pulling, TRUE, TRUE, FALSE, 0, 0)
			else				// fireman carry
				L.buckle_mob(pulling, TRUE, TRUE, 90, 0, 0)
