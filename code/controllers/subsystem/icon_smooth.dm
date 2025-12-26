SUBSYSTEM_DEF(icon_smooth)
	name = "Icon Smoothing"
	init_order = INIT_ORDER_ICON_SMOOTHING
	wait = 1
	priority = FIRE_PRIORITY_SMOOTHING
	flags = SS_TICKER

	var/list/smooth_queue = list()
	var/list/deferred = list()

/datum/controller/subsystem/icon_smooth/fire()
	var/list/cached = smooth_queue // local vars are quicker to access than datum vars, even on src
	//We do this rather then for(var/atom/smoothing_atom in cached) because that sort of for loop copies the whole list.
	//Normally this isn't expensive, but like SSgarbage the smooth queue can get pretty big.
	var/static/last_index = 0 // track last index processed
	// runtimed, we need to cut the remainder
	if(last_index)
		var/old_index = last_index
		last_index = 0 // reset it so if Cut() runtimes we don't try again
		cached.Cut(1, old_index+1)
	// We don't cut during the loop so it's faster
	for(last_index in 1 to length(cached))
		var/atom/smoothing_atom = cached[last_index]
		if(QDELETED(smoothing_atom) || !(smoothing_atom.smoothing_flags & SMOOTH_QUEUED))
			continue
		if(smoothing_atom.flags_1 & INITIALIZED_1)
			smoothing_atom.smooth_icon()
		else
			deferred += smoothing_atom
		if (MC_TICK_CHECK)
			break
	if(last_index) // don't try cutting from the list if we did no work this run
		cached.Cut(1, last_index+1)
		last_index = 0

	if(!length(cached))
		if(length(deferred))
			smooth_queue = deferred
			deferred = cached
		else
			can_fire = FALSE

/datum/controller/subsystem/icon_smooth/Initialize()
	var/list/queue = smooth_queue
	smooth_queue = list()

	// we explicitly do not support new stuff being added to the list while we iterate over it
	for(var/atom/smoothing_atom as anything in queue)
		if(QDELETED(smoothing_atom) || !(smoothing_atom.smoothing_flags & SMOOTH_QUEUED) || !smoothing_atom.z)
			continue
		smoothing_atom.smooth_icon()
		CHECK_TICK
	queue.Cut()
	return ..()

/datum/controller/subsystem/icon_smooth/proc/add_to_queue(atom/thing)
	if(thing.smoothing_flags & SMOOTH_QUEUED)
		return
	thing.smoothing_flags |= SMOOTH_QUEUED
	smooth_queue += thing
	if(!can_fire)
		can_fire = TRUE

// Try to avoid using this where possible; prefer unsetting smoothing_flags instead. List removals are expensive yo.
/datum/controller/subsystem/icon_smooth/proc/remove_from_queues(atom/thing)
	thing.smoothing_flags &= ~SMOOTH_QUEUED
	smooth_queue -= thing
	deferred -= thing
