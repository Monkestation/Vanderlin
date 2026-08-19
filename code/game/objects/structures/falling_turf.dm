/obj/structure/falling_turf
	icon = null
	icon_state = null
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	obj_flags = BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	var/set_delay = 0
	var/random_delay_range = 1 SECONDS
	var/turf/replacement_type = /turf/open/openspace
	var/fall_time = 2 SECONDS

/obj/structure/falling_turf/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(start_fall)), set_delay + rand(0, random_delay_range))


/obj/structure/falling_turf/proc/start_fall()
	var/turf/T = get_turf(src)
	if(!istype(T))
		qdel(src)
		return
	// snapshot the turf's look before we destroy it
	appearance = T.appearance
	dir = T.dir
	layer = (T.layer + 0.1)
	plane = T.plane

	// swap the real turf out from under us
	T.ChangeTurf(replacement_type)

	// shrink to nothing, then clean up
	animate(src, transform = matrix().Scale(0.05, 0.05), time = fall_time)
	QDEL_IN(src, fall_time)
