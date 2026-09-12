SUBSYSTEM_DEF(mob_stock)
	name = "Mob Stock"
	flags = SS_BACKGROUND
	priority = FIRE_PRIORITY_AMBIENCE
	wait = 5 SECONDS
	runlevels = RUNLEVEL_GAME

	/// The config datum that matched the loaded map. used for basically everything here
	var/datum/map_mob_stock/stock

	/// assoc list: mob typepath -> list of /datum/weakref so waves can pull the chuds into it
	var/list/tracked_mobs = list()
	///next wave cooldown
	COOLDOWN_DECLARE(next_wave_time)

/datum/controller/subsystem/mob_stock/Initialize()
	stock = get_map_mob_stock(SSmapping.config.map_name)
	if(!stock)
		flags |= SS_NO_FIRE
		return ..()

	for(var/path in stock.stock)
		tracked_mobs[path] = list()

	if(stock.wave_defense_enabled)
		schedule_next_wave()

	return ..()

/datum/controller/subsystem/mob_stock/fire(resumed)
	maintain_population()

	if(stock.wave_defense_enabled && COOLDOWN_FINISHED(src, next_wave_time))
		try_launch_wave()

/datum/controller/subsystem/mob_stock/proc/maintain_population()
	#ifdef UNIT_TESTS // why? because this is prone to cause flaky test results since this tries to enforce growth
	return FALSE
	#endif
	if(!length(GLOB.mob_stock_points))
		return

	for(var/path in stock.stock)
		var/desired = stock.stock[path]
		var/list/refs = tracked_mobs[path]
		prune_dead_refs(refs)

		var/missing = desired - length(refs)
		for(var/i in 1 to missing)
			spawn_stock_mob(path)
			if(MC_TICK_CHECK)
				break

/// Belt-and-braces cleanup in case a mob slipped past the signal (shouldn't
/// happen, but a resolve()-null weakref costing us population forever is
/// worse than an extra pass here). I HATE BYOND I HATE BYOND I HATE BYOND
/datum/controller/subsystem/mob_stock/proc/prune_dead_refs(list/refs)
	for(var/datum/weakref/wr as anything in refs)
		if(!wr.resolve())
			refs -= wr

///this just shuffle pick_n_takes from the viable spots to find one thats not occupied
/datum/controller/subsystem/mob_stock/proc/find_valid_starter()
	var/list/points = GLOB.mob_stock_points.Copy()
	var/atom/point
	var/not_found = TRUE
	while(not_found)
		point = pick_n_take(points)
		var/bad = FALSE
		for(var/mob/living/mob in range(7, get_turf(point)))
			if(mob.client)
				bad = TRUE
				break
		if(bad)
			continue
		not_found = FALSE

	return get_turf(point)

/datum/controller/subsystem/mob_stock/proc/spawn_stock_mob(path)
	var/turf/start = find_valid_starter()
	if(!start)
		return
	var/list/viable_turfs = list()
	for(var/turf/open/turf in range(4, start))
		if(isopenspace(turf) || iswaterturf(turf) || islava(turf))
			continue
		var/dense = FALSE
		for(var/atom/atom in turf)
			if(atom.density)
				dense = TRUE
				break
		if(dense)
			continue
		viable_turfs += turf

	var/turf/target = pick(viable_turfs)
	if(!target)
		target = start

	var/mob/living/new_mob = new path(target)
	RegisterSignal(new_mob, COMSIG_LIVING_DEATH, PROC_REF(on_tracked_mob_removed))
	RegisterSignal(new_mob, COMSIG_QDELETING, PROC_REF(on_tracked_mob_removed))
	tracked_mobs[path] += WEAKREF(new_mob)

/datum/controller/subsystem/mob_stock/proc/on_tracked_mob_removed(mob/living/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING))

	var/path = source.type
	var/list/refs = tracked_mobs[path]
	if(!refs)
		return
	for(var/i in length(refs) to 1 step -1)
		var/datum/weakref/wr = refs[i]
		if(!wr || wr.resolve() == source)
			refs.Cut(i, i + 1)

/datum/controller/subsystem/mob_stock/proc/schedule_next_wave()
	COOLDOWN_START(src, next_wave_time, rand(stock.wave_time_min, stock.wave_time_max))

/datum/controller/subsystem/mob_stock/proc/try_launch_wave()
	var/pop_scalar = get_wave_pop_scalar()
	if(pop_scalar <= 0)
		schedule_next_wave()
		return

	var/chosen_set_id = pick_viable_set_id()
	if(!chosen_set_id)
		message_admins("SSmob_stock: tried to launch a wave but none of [stock.wave_defense_set_ids.Join(", ")] have landmarks placed.")
		schedule_next_wave()
		return

	var/list/points = get_wave_defense_points(chosen_set_id)
	var/atom/point_one = points[1]
	var/list/mob/living/wave_mobs = list()
	for(var/path in stock.pick_wave_mobs(pop_scalar))
		var/mob/living/pulled = pull_stock_mob(path, point_one)
		if(pulled)
			wave_mobs += pulled

	if(!length(wave_mobs))
		schedule_next_wave()
		return

	new /datum/wave_defense_coordinator(
		chosen_set_id,
		wave_mobs,
		on_complete = CALLBACK(src, PROC_REF(on_wave_complete)),
		on_failed = CALLBACK(src, PROC_REF(on_wave_failed)),
	)

	schedule_next_wave()
	message_admins("SSmob_stock launched an automatic wave ([chosen_set_id]) with [length(wave_mobs)] mob(s) at [round(pop_scalar * 100)]% pop scaling.")

/// Returns 0..1. 0 means waves are outright disabled (pop below half of lowpop).
/// 1 means full-size waves (pop at or above highpop). Linear ramp in between,
/// anchored at half-lowpop (0) and highpop (1).
/datum/controller/subsystem/mob_stock/proc/get_wave_pop_scalar()
	var/player_count = length(GLOB.player_list)
	var/disable_floor = 0.5 * LOWPOP_THRESHOLD

	if(player_count < disable_floor)
		return 0
	if(player_count >= HIGHPOP_THRESHOLD)
		return 1

	return (player_count - disable_floor) / (HIGHPOP_THRESHOLD - disable_floor)

/// Pulls a live mob of the given path out of tracked_mobs for use in a wave.
/datum/controller/subsystem/mob_stock/proc/pull_stock_mob(path, atom/point)
	var/list/refs = tracked_mobs[path]
	if(!refs)
		return null

	prune_dead_refs(refs)
	for(var/i = 1 to length(refs))
		var/datum/weakref/wr = pick(refs)
		var/mob/living/candidate = wr.resolve()
		if(!candidate)
			continue
		if(get_dist(candidate, point) > 40)
			continue
		return candidate

	return null

/// Picks a random set_id from the map's configured list, restricted to ones
/// that currently have at least one landmark placed. Returns null if none do.
/datum/controller/subsystem/mob_stock/proc/pick_viable_set_id()
	var/list/viable = list()
	for(var/set_id in stock.wave_defense_set_ids)
		if(length(get_wave_defense_points(set_id)))
			viable += set_id
	if(!length(viable))
		return null
	return pick(viable)

/datum/controller/subsystem/mob_stock/proc/on_wave_complete(datum/wave_defense_coordinator/c)
	schedule_next_wave()

/datum/controller/subsystem/mob_stock/proc/on_wave_failed(datum/wave_defense_coordinator/c)
	schedule_next_wave()
