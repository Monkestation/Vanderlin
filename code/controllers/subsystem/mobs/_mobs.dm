///how many tiles out from a client we still bother processing mobs that aren't otherwise exempt
#define MOB_PROCESSING_TILE_RANGE 15

SUBSYSTEM_DEF(mobs)
	name = "Mobs"
	priority = FIRE_PRIORITY_MOBS
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	// While this base doesn't process it's subtypes may
	var/list/processing = list()
	var/list/currentrun = list()

	/// Cliented /living mobs by Z level
	var/static/list/clients_by_zlevel[][]
	/// Cliented /dead mobs by Z level
	var/static/list/dead_players_by_zlevel[][] = list(list())
	/// Cliented /camera mob by Z level
	var/static/list/camera_players_by_zlevel[][] = list(list())

	/// Non cliented mobs by Z level
	var/static/list/mobs_by_zlevel[][] = list(list())

	var/datum/mob_affix_system/affix_system

/datum/controller/subsystem/mobs/proc/MaxZChanged()
	if(!islist(clients_by_zlevel))
		clients_by_zlevel = new /list(world.maxz, 0)
		dead_players_by_zlevel = new /list(world.maxz, 0)
		mobs_by_zlevel = new /list(world.maxz, 0)

	while(length(clients_by_zlevel) < world.maxz)
		clients_by_zlevel.len++
		clients_by_zlevel[length(clients_by_zlevel)] = list()

		dead_players_by_zlevel.len++
		dead_players_by_zlevel[length(dead_players_by_zlevel)] = list()

		camera_players_by_zlevel.len++
		camera_players_by_zlevel[length(camera_players_by_zlevel)] = list()

		mobs_by_zlevel.len++
		mobs_by_zlevel[length(dead_players_by_zlevel)] = list()

/datum/controller/subsystem/mobs/fire(resumed = FALSE)
	var/seconds = wait * 0.1

	if(!resumed)
		src.currentrun = build_currentrun()

	var/list/currentrun = src.currentrun
	var/times_fired = src.times_fired
	while(length(currentrun))
		var/mob/living/L = currentrun[length(currentrun)]
		currentrun.len--
		if(!L)
			continue

		if(L.stat == DEAD)
			L.DeadLife(seconds, times_fired)
		else
			L.Life(seconds, times_fired)

		if(MC_TICK_CHECK)
			return

///builds the list of mobs that should process this fire:
///- mobs on town z-levels (always process, regardless of proximity)
///- mobs within MOB_PROCESSING_TILE_RANGE of a client elsewhere
///excludes mobs handled by other subsystems
/datum/controller/subsystem/mobs/proc/build_currentrun()
	var/list/the_run = list()

	var/list/seen_cells = list()
	for(var/z_index in 1 to length(SSmapping.z_list))
		if(z_index in GLOB.tomb_z_levels)
			continue // Own SS
		// These Z levels always process fully
		if(z_index in GLOB.town_z_levels)
			the_run |= mobs_by_zlevel[z_index]
			continue
		if(SSmapping.level_has_any_trait(z_index, list(ZTRAIT_ALWAYS_PROCESS)))
			the_run |= mobs_by_zlevel[z_index]
			continue
		var/list/clients_here = clients_by_zlevel[z_index]
		if(!length(clients_here))
			continue
		for(var/mob/living/client_mob as anything in clients_here)
			var/turf/turf = get_turf(client_mob)
			if(!turf)
				continue
			for(var/datum/spatial_grid_cell/cell as anything in SSspatial_grid.get_cells_in_range(turf, MOB_PROCESSING_TILE_RANGE))
				if(seen_cells[cell])
					continue
				seen_cells[cell] = TRUE
				for(var/mob/living/listener in cell.hearing_contents)
					if(listener.client) // Own SS
						continue
					the_run |= listener

	return the_run

/datum/controller/subsystem/mobs/proc/enhance_mob(mob/living/mob, delve_level = 1)
	if(!affix_system)
		affix_system = new()
	affix_system.enhance_mob(mob, delve_level - 1)

#undef MOB_PROCESSING_TILE_RANGE
