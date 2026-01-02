SUBSYSTEM_DEF(island_mobs)
	name = "Island Mobs"
	priority = FIRE_PRIORITY_MOBS - 1 // Slightly lower priority than main mobs
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	var/list/currentrun = list()
	var/list/island_mobs = list() // All mobs registered to islands
	var/list/active_islands = list() // Islands with players on them (datum/island_data)
	var/list/mobs_by_island = list() // island_id -> list of mobs

/datum/controller/subsystem/island_mobs/stat_entry()
	..("IM:[island_mobs.len]|AI:[active_islands.len]")

/datum/controller/subsystem/island_mobs/fire(resumed = 0)
	var/seconds = wait * 0.1

	if (!resumed)
		// Update active islands - only process mobs on islands with players
		update_active_islands()

		// Build currentrun from mobs on active islands only
		src.currentrun = list()
		for(var/island_id in active_islands)
			var/list/island_mob_list = mobs_by_island[island_id]
			if(island_mob_list)
				src.currentrun += island_mob_list

	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired

	while(currentrun.len)
		var/mob/living/L = currentrun[currentrun.len]
		currentrun.len--

		if(!L || QDELETED(L))
			remove_mob(L)
			continue

		if(!L.cached_island_id || !(L.cached_island_id in active_islands))
			continue

		if(L.stat == DEAD)
			L.DeadLife()
		else
			L.Life(seconds, times_fired)

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/island_mobs/proc/update_active_islands()
	active_islands.Cut()

	for(var/client/C in GLOB.clients)
		if(!C.mob)
			continue

		var/mob/M = C.mob
		var/turf/T = get_turf(M)
		if(!T)
			continue

		var/datum/island_data/island = SSterrain_generation.get_island_at_location(T)
		if(island && island.island_id)
			active_islands |= island.island_id

/datum/controller/subsystem/island_mobs/proc/register_mob(mob/living/L, island_id)
	if(!L)
		return FALSE

	if(!island_id)
		var/datum/island_data/island = SSterrain_generation.get_island_at_location(get_turf(L))
		island_id = island?.island_id

	if(L.cached_island_id)
		remove_mob(L)

	island_mobs |= L
	L.cached_island_id = island_id

	if(!mobs_by_island[island_id])
		mobs_by_island[island_id] = list()

	mobs_by_island[island_id] |= L

	return TRUE

/datum/controller/subsystem/island_mobs/proc/remove_mob(mob/living/L)
	if(!L)
		return

	island_mobs -= L

	if(L.cached_island_id)
		var/list/island_mob_list = mobs_by_island[L.cached_island_id]
		if(island_mob_list)
			island_mob_list -= L
		L.cached_island_id = null

/datum/controller/subsystem/island_mobs/proc/get_mobs_on_island(island_id)
	var/list/listed_mobs = mobs_by_island[island_id]
	return listed_mobs?.Copy()
