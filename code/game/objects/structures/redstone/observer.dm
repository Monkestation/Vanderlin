/obj/structure/redstone/observer
	name = "redstone observer"
	desc = "Watches the tile in front of it. Pulses when a matching item enters, or when a container on that tile gains or loses one."
	icon_state = "observer"
	is_source = TRUE
	/// Types this observer reacts to. Empty = react to anything.
	var/list/filter_types = list()
	var/turf/watched_turf
	var/pulse_time = 3

/obj/structure/redstone/observer/Initialize(mapload)
	. = ..()
	watch_turf(get_step(src, dir))

/obj/structure/redstone/observer/Destroy()
	unwatch_turf()
	return ..()

//we use overlays
/obj/structure/redstone/observer/update_power_color()
	return

/obj/structure/redstone/observer/update_overlays()
	. = ..()
	. += powered_overlay("eyes_front")

/obj/structure/redstone/observer/get_output_toward(atom/asker)
	if(!power)
		return 0
	var/dir_to_asker = get_dir(src, asker)
	if(dir_to_asker != REVERSE_DIR(dir))
		return 0
	return power

/obj/structure/redstone/observer/setDir(newdir)
	var/old_dir = dir
	. = ..()
	if(old_dir == dir)
		return
	watch_turf(get_step(src, dir))

/obj/structure/redstone/observer/proc/watch_turf(turf/new_turf)
	unwatch_turf()
	watched_turf = new_turf
	if(!watched_turf)
		return
	RegisterSignals(watched_turf, list(
		COMSIG_ATOM_ENTERED,
		COMSIG_STORAGE_TURF_INSERTED,
		COMSIG_STORAGE_TURF_REMOVED,
	), PROC_REF(on_watched_change))

/obj/structure/redstone/observer/proc/unwatch_turf()
	if(!watched_turf)
		return
	UnregisterSignal(watched_turf, list(
		COMSIG_ATOM_ENTERED,
		COMSIG_STORAGE_TURF_INSERTED,
		COMSIG_STORAGE_TURF_REMOVED,
	))
	watched_turf = null

/obj/structure/redstone/observer/proc/on_watched_change(datum/source, atom/movable/thing)
	SIGNAL_HANDLER
	check_match(thing)

/obj/structure/redstone/observer/proc/check_match(atom/movable/thing)
	if(QDELETED(thing))
		return
	if(length(filter_types))
		var/matched = FALSE
		for(var/filter_type in filter_types)
			if(istype(thing, filter_type))
				matched = TRUE
				break
		if(!matched)
			return
	pulse()

/obj/structure/redstone/observer/proc/pulse()
	set_power(max_power)
	addtimer(CALLBACK(src, PROC_REF(set_power), 0), pulse_time)
