GLOBAL_DATUM_INIT(openspace_backdrop_one_for_all, /atom/movable/openspace_backdrop, new)

/atom/movable/openspace_backdrop
	name = "openspace_backdrop"
	icon = 'icons/turf/floors.dmi'
	icon_state = "grey"
	anchored = TRUE
	plane = OPENSPACE_BACKDROP_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_ID

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
	vis_contents += GLOB.openspace_backdrop_one_for_all //Special grey square for projecting backdrop darkness filter on it.
	return INITIALIZE_HINT_LATELOAD

/turf/open/openspace/LateInitialize()
	. = ..()
	AddElement(/datum/element/turf_z_transparency, is_openspace = TRUE)

/turf/open/openspace/can_traverse_safely(atom/movable/traveler)
	var/turf/destination = GET_TURF_BELOW(src)
	if(!destination)
		return TRUE // this shouldn't happen
	for(var/obj/structure/O in contents)
		if(O.obj_flags & BLOCK_Z_OUT_DOWN)
			return TRUE
	if(!traveler.can_zTravel(destination, DOWN, src)) // something is blocking their fall!
		return TRUE
	if(!traveler.can_zFall(src, DOWN, destination)) // they can't fall!
		return TRUE
	return FALSE

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

/turf/open/openspace/zPassIn(atom/movable/A, direction, turf/source)
	if(direction == DOWN)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_IN_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_IN_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/openspace/zPassOut(atom/movable/A, direction, turf/destination)
	if(A.anchored && !isprojectile(A))
		return FALSE
	if(HAS_TRAIT(A, TRAIT_I_AM_INVISIBLE_ON_A_BOAT))
		return FALSE
	if(HAS_TRAIT(A, "hooked"))
		return FALSE
	if(direction == DOWN)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_OUT_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_OUT_UP)
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
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		var/turf/target = GET_TURF_BELOW(src)
		if(!target)
			to_chat(user, "<span class='warning'>I can't climb there.</span>")
			return
		if(!user.can_zTravel(target, DOWN, src))
			to_chat(user, "<span class='warning'>I can't climb here.</span>")
			return
		if(user.m_intent != MOVE_INTENT_SNEAK)
			playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
		user.visible_message("<span class='warning'>[user] starts to climb down.</span>", "<span class='warning'>I start to climb down.</span>")
		if(do_after(L, 3 SECONDS, src))
			if(user.m_intent != MOVE_INTENT_SNEAK)
				playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
			var/pulling = user.pulling
			if(ismob(pulling))
				user.pulling.forceMove(target)
			user.forceMove(target)
			user.start_pulling(pulling,suppress_message = TRUE)

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
