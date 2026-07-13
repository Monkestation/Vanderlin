///how many tiles out from a client we still bother processing dungeon mobs
#define MATTHIOS_PROCESSING_TILE_RANGE 15

SUBSYSTEM_DEF(matthios_mobs)
	name = "Matthios Mobs"
	priority = FIRE_PRIORITY_MOBS - 2
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 2 SECONDS
	var/list/currentrun = list()
	var/list/matthios_mobs = list()
	var/list/dungeon_z = list()
	var/looked = FALSE
	var/list/active_mobs = list()

/datum/controller/subsystem/matthios_mobs/stat_entry()
	..("MM:[matthios_mobs.len]")

/datum/controller/subsystem/matthios_mobs/fire(resumed = 0)
	var/seconds = wait * 0.1
	if(!length(dungeon_z) && !looked)
		dungeon_z = SSmapping.levels_by_trait(ZTRAIT_MATTHIOS_DUNGEON)
		looked = TRUE
	if(!length(dungeon_z))
		return

	if(!resumed)
		active_mobs = build_active_mobs()
		src.currentrun = matthios_mobs.Copy()

	if(!length(active_mobs))
		return

	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	while(currentrun.len)
		var/mob/living/L = currentrun[currentrun.len]
		currentrun.len--
		if(!L || QDELETED(L))
			matthios_mobs -= L
			GLOB.mob_living_list -= L
			continue

		if(!active_mobs[L])
			continue

		if(L.stat == DEAD)
			L.DeadLife(seconds, times_fired)
		else
			L.Life(seconds, times_fired)
		if(MC_TICK_CHECK)
			return

///builds an associative list of every hearing-sensitive atom within MATTHIOS_PROCESSING_TILE_RANGE tiles of a client on a dungeon z-level
/datum/controller/subsystem/matthios_mobs/proc/build_active_mobs()
	. = list()
	var/list/seen_cells = list()
	for(var/level in dungeon_z)
		var/list/clients_here = SSmobs.clients_by_zlevel[level]
		if(!length(clients_here))
			continue
		for(var/mob/living/client_mob as anything in clients_here)
			var/turf/turf = get_turf(client_mob)
			if(!turf)
				continue
			for(var/datum/spatial_grid_cell/cell as anything in SSspatial_grid.get_cells_in_range(turf, MATTHIOS_PROCESSING_TILE_RANGE))
				if(seen_cells[cell])
					continue
				seen_cells[cell] = TRUE
				for(var/atom/hearable as anything in cell.hearing_contents)
					if(hearable in clients_here)
						continue
					.[hearable] = TRUE

/datum/controller/subsystem/matthios_mobs/proc/register_mob(mob/living/L)
	if(!L)
		return FALSE
	matthios_mobs |= L
	return TRUE

/datum/controller/subsystem/matthios_mobs/proc/unregister_mob(mob/living/L)
	if(!L)
		return
	matthios_mobs -= L

#undef MATTHIOS_PROCESSING_TILE_RANGE
