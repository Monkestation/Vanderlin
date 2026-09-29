SUBSYSTEM_DEF(redstone)
	name = "Redstone"
	wait = 0.2 SECONDS
	priority = FIRE_PRIORITY_DEFAULT
	flags = SS_NO_INIT

	///list of all our dirty nodes
	var/list/obj/structure/redstone/dirty_nodes = list()

	///turf -> list of redstone objects that care about that turf's
	///power even though they aren't physically standing on it (torches)
	var/list/turf/watchers_by_turf = list()

/datum/controller/subsystem/redstone/fire(resumed = FALSE)
	var/iterations = 0
	var/list/turf/affected_turfs = list()

	while(length(dirty_nodes) && iterations < 100)
		iterations++
		var/list/queue = dirty_nodes.Copy()
		dirty_nodes.Cut()

		for(var/obj/structure/redstone/R as anything in queue)
			if(QDELETED(R))
				continue
			var/turf/T = get_turf(R)
			if(T)
				affected_turfs |= T
				for(var/direction in GLOB.cardinals)
					var/turf/NT = get_step(T, direction)
					if(NT)
						affected_turfs |= NT
			R.recompute_power()

	for(var/turf/T as anything in affected_turfs)
		check_turf_structure_triggers(T)

/datum/controller/subsystem/redstone/proc/check_turf_structure_triggers(turf/T)
	if(!T)
		return
	var/current_power = T.get_turf_power()
	for(var/obj/structure/S in T)
		if(!S.redstone_structure)
			continue
		// Ignore redstone wire objects (dust, torch, repeater component)
		if(ispath(S.type, /obj/structure/redstone) && !istype(S, /obj/structure/lever) && !istype(S, /obj/structure/pressure_plate))
			continue

		//edge checking, we only care if the last power is 0 otherwise pulse networks work weirdly.
		if(current_power > 0 && S.last_redstone_power == 0)
			INVOKE_ASYNC(S, TYPE_PROC_REF(/obj/structure, redstone_triggered), null)

		S.last_redstone_power = current_power

/datum/controller/subsystem/redstone/proc/mark_dirty(obj/structure/redstone/R)
	if(!R || (R in dirty_nodes))
		return
	dirty_nodes += R

/datum/controller/subsystem/redstone/proc/mark_area_dirty(turf/T)
	if(!T)
		return
	for(var/obj/structure/redstone/R in T)
		mark_dirty(R)
	if(watchers_by_turf[T])
		for(var/obj/structure/redstone/R as anything in watchers_by_turf[T])
			mark_dirty(R)

/datum/controller/subsystem/redstone/proc/register_turf_watcher(turf/T, obj/structure/redstone/R)
	if(!T || !R)
		return
	if(!watchers_by_turf[T])
		watchers_by_turf[T] = list()
	watchers_by_turf[T] += R

/datum/controller/subsystem/redstone/proc/unregister_turf_watcher(turf/T, obj/structure/redstone/R)
	if(!T || !watchers_by_turf[T])
		return
	watchers_by_turf[T] -= R
	if(!length(watchers_by_turf[T]))
		watchers_by_turf -= T
