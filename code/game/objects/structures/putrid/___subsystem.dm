SUBSYSTEM_DEF(meatvines)
	name = "Meatvines"
	wait = 1 SECONDS
	flags = SS_NO_INIT
	priority = FIRE_PRIORITY_OBJ

	var/list/edge_vines = list() // Only vines that can spread
	var/list/interior_vines = list() // Vines completely surrounded
	var/list/tracked_turfs = list() // Closed turfs we're watching

	var/current_edge_index = 1
	var/current_interior_index = 1
	var/vines_per_tick = 200 // Process this many edge vines per tick
	var/interior_vines_per_tick = 50 // Process fewer interior vines
	var/process_ticks = 0

/datum/controller/subsystem/meatvines/stat_entry(msg)
	msg = "E:[length(edge_vines)]|I:[length(interior_vines)]|T:[length(tracked_turfs)]"
	return ..()

/datum/controller/subsystem/meatvines/fire(resumed)
	process_ticks++

	if(length(edge_vines))
		var/list/current_queue = edge_vines
		var/processed = 0

		while(current_edge_index <= length(current_queue) && processed < vines_per_tick)
			var/obj/structure/meatvine/vine = current_queue[current_edge_index]
			current_edge_index++
			processed++

			if(QDELETED(vine) || !vine.master || vine.master.isdying)
				edge_vines -= vine
				continue

			vine.grow()
			if(!QDELETED(vine))
				vine.spread(vine?.master?.hive_spread_chance)

		if(current_edge_index > length(current_queue))
			current_edge_index = 1

	// Process interior vines less frequently (only growth, every 5 process_ticks)
	if(process_ticks % 5 == 0 && length(interior_vines))
		var/list/interior_queue = interior_vines
		var/processed = 0

		while(current_interior_index <= length(interior_queue) && processed < interior_vines_per_tick)
			var/obj/structure/meatvine/vine = interior_queue[current_interior_index]
			current_interior_index++
			processed++

			if(QDELETED(vine) || !vine.master || vine.master.isdying)
				interior_vines -= vine
				continue

			vine.grow()

		if(current_interior_index > length(interior_queue))
			current_interior_index = 1

/datum/controller/subsystem/meatvines/proc/register_vine(obj/structure/meatvine/vine)
	if(vine.is_edge_vine())
		edge_vines |= vine
	else
		interior_vines |= vine

/datum/controller/subsystem/meatvines/proc/unregister_vine(obj/structure/meatvine/vine)
	edge_vines -= vine
	interior_vines -= vine

/datum/controller/subsystem/meatvines/proc/check_vine_neighbors(obj/structure/meatvine/vine)
	var/was_edge = (vine in edge_vines)
	var/is_edge = vine.is_edge_vine()

	if(was_edge && !is_edge)
		edge_vines -= vine
		interior_vines |= vine
	else if(!was_edge && is_edge)
		interior_vines -= vine
		edge_vines |= vine

/datum/controller/subsystem/meatvines/proc/track_turf(turf/T)
	if(T in tracked_turfs)
		return
	tracked_turfs[T] = TRUE
	RegisterSignal(T, COMSIG_TURF_CHANGE, PROC_REF(on_turf_changed))

/datum/controller/subsystem/meatvines/proc/untrack_turf(turf/T)
	tracked_turfs -= T
	UnregisterSignal(T, COMSIG_TURF_CHANGE)

/datum/controller/subsystem/meatvines/proc/on_turf_changed(turf/source, path, list/new_baseturfs, flags, list/post_change_callbacks)
	SIGNAL_HANDLER

	if(!isopenturf(source))
		return

	untrack_turf(source)

	// Check adjacent vines to see if they can now spread here
	for(var/direction in GLOB.cardinals)
		var/turf/check = get_step(source, direction)
		var/obj/structure/meatvine/vine = locate(/obj/structure/meatvine) in check
		if(vine && vine.master && !vine.master.isdying)
			// Move to edge vines if not already
			if(vine in interior_vines)
				interior_vines -= vine
				edge_vines |= vine
