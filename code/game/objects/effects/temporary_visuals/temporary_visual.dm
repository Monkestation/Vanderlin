//temporary visual effects
/obj/effect/temp_visual
	icon_state = "nothing"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	///time, in deciseconds, that this object will exist
	var/duration = 10
	///if true, will pick a random direction when created.
	var/randomdir = TRUE
	/// how long to fade away, if null, will disappear instantly.
	var/fade_time

/obj/effect/temp_visual/Initialize(mapload)
	. = ..()
	if(randomdir)
		setDir(pick(GLOB.cardinals))

	addtimer(CALLBACK(src, PROC_REF(timed_out)), duration)

/obj/effect/temp_visual/proc/timed_out()
	if(fade_time)
		animate(src, time = fade_time, alpha = 0)
		QDEL_IN(src, fade_time)
	else
		qdel(src)

/obj/effect/temp_visual/ex_act()
	return

/obj/effect/temp_visual/dir_setting
	randomdir = FALSE

/obj/effect/temp_visual/dir_setting/Initialize(mapload, set_dir)
	if(set_dir)
		setDir(set_dir)
	. = ..()

/obj/effect/temp_visual/duration_setting/Initialize(mapload, new_duration)
	if(new_duration)
		duration = new_duration
	return ..()
