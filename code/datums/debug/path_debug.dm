
GLOBAL_DATUM_INIT(pathfind_dude, /obj/pathfind_guy, new())

/obj/pathfind_guy

/// Enables testing/visualization of pathfinding work
/datum/pathfind_debug
	var/datum/admins/owner

/datum/pathfind_debug/New(datum/admins/owner)
	src.owner = owner
	hook_client()

/datum/pathfind_debug/Destroy(force)
	owner = null
	return ..()

/datum/pathfind_debug/proc/hook_client()
	if(!owner.owner)
		return
	var/datum/action/innate/path_debug/jps/jps = new
	jps.Grant(owner.owner.mob)

/datum/action/innate/path_debug
	var/list/image/display_images = list()
	var/toggled = FALSE

/datum/action/innate/path_debug/Trigger(trigger_flags)
	if(!toggled)
		Activate()
	else
		Deactivate()

	toggled = !toggled

/datum/action/innate/path_debug/Activate()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(clicked_something))
	active = TRUE

/datum/action/innate/path_debug/Deactivate()
	UnregisterSignal(owner, COMSIG_MOB_CLICKON)
	clear_visuals()
	active = FALSE
	return ..()

/datum/action/innate/path_debug/proc/clicked_something(datum/source, atom/clicked, list/modifiers)
	SIGNAL_HANDLER

	var/turf/clunked = get_turf(clicked)
	if(!clunked)
		return NONE

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		right_clicked(clunked)
	else
		left_clicked(clunked)

	update_visuals()
	if(path_ready())
		pathfind()

/datum/action/innate/path_debug/proc/left_clicked(turf/clicked_on)
	return

/datum/action/innate/path_debug/proc/right_clicked(turf/clicked_on)
	return

/datum/action/innate/path_debug/proc/update_visuals()
	clear_visuals()
	build_visuals()
	owner.client?.images += display_images

/datum/action/innate/path_debug/proc/clear_visuals()
	owner.client?.images -= display_images
	display_images = list()

/datum/action/innate/path_debug/proc/build_visuals()
	return

/datum/action/innate/path_debug/proc/path_ready()
	return FALSE

/datum/action/innate/path_debug/proc/pathfind()
	INVOKE_ASYNC(src, PROC_REF(run_the_path), GLOB.pathfind_dude)
	GLOB.pathfind_dude.moveToNullspace()

/datum/action/innate/path_debug/proc/run_the_path(atom/movable/middle_man)
	return

/datum/action/innate/path_debug/proc/render_path(list/turf/draw_list)
	if(!length(draw_list))
		return list()

	var/list/image/turf_images = list()
	// Render everything but the first and last
	for(var/i in 1 to (length(draw_list) - 1))
		var/turf/problem_child = draw_list[i]
		var/turf/next = draw_list[i + 1]
		turf_images += render_turf(problem_child, get_dir(problem_child, next))

	return turf_images

/datum/action/innate/path_debug/proc/render_turf(turf/draw, direction)
	var/image/arrow = image('icons/turf/debug.dmi', draw, "arrow", 6, direction)
	arrow.plane = ABOVE_LIGHTING_PLANE
	return arrow

/datum/action/innate/path_debug/jps
	name = "JPS Test"
	button_icon = 'icons/turf/debug.dmi'
	button_icon_state = "jps"

	// Mirror vars for jps calls
	var/turf/source_turf
	var/turf/target_turf
	var/max_distance = 250
	var/min_distance = 1
	/// List of turfs we are showing to our owner currently
	var/list/turf/display_turfs

/datum/action/innate/path_debug/jps/Activate()
	. = ..()
	max_distance = input(owner, "How far should we be allowed to try and path", "Max Distance") as num
	min_distance = input(owner, "How close should we try and get to the target before stopping", "Min Distance") as num

/datum/action/innate/path_debug/jps/Deactivate()
	source_turf = null
	target_turf = null
	display_turfs = list()
	return ..()

/datum/action/innate/path_debug/jps/left_clicked(turf/clicked_on)
	source_turf = clicked_on
	display_turfs = list()

/datum/action/innate/path_debug/jps/right_clicked(turf/clicked_on)
	target_turf = clicked_on
	display_turfs = list()

/datum/action/innate/path_debug/jps/build_visuals()
	. = ..()
	if(source_turf)
		var/image/start = image('icons/turf/debug.dmi', source_turf, "start", 6)
		start.plane = ABOVE_LIGHTING_PLANE
		display_images += start
	if(target_turf)
		var/image/end = image('icons/turf/debug.dmi', target_turf, "end", 6)
		end.plane = ABOVE_LIGHTING_PLANE
		display_images += end

	display_images += render_path(display_turfs)

/datum/action/innate/path_debug/jps/path_ready()
	return (source_turf && target_turf)

/datum/action/innate/path_debug/jps/run_the_path(atom/movable/middle_man)
	middle_man.forceMove(source_turf)
	display_turfs = get_path_to(middle_man, target_turf, TYPE_PROC_REF(/turf, Heuristic_cardinal_3d), 30, max_distance, min_distance)
	update_visuals()
