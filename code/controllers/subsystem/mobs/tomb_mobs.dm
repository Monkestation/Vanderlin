///how many tiles out from a client we still bother processing dungeon mobs
#define MATTHIOS_PROCESSING_TILE_RANGE 15

MOBS_SUBSYSTEM_DEF(matthios_mobs)
	name = "Matthios Mobs"
	priority = FIRE_PRIORITY_TOMB_MOBS
	flags = SS_KEEP_TIMING | SS_NO_INIT

/datum/controller/subsystem/mobs/matthios_mobs/build_currentrun()
	var/list/the_run = list()

	var/list/seen_cells = list()
	for(var/z_index in GLOB.tomb_z_levels)
		var/list/clients_here = clients_by_zlevel[z_index]
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
				for(var/mob/living/listener in cell.hearing_contents)
					if(listener.client)
						continue
					the_run |= listener

	return the_run

/datum/controller/subsystem/mobs/matthios_mobs/proc/get_random_mob()
	var/list/mobs = list()
	for(var/z_index in GLOB.tomb_z_levels)
		mobs |= mobs_by_zlevel[z_index]
	return pick(mobs)

#undef MATTHIOS_PROCESSING_TILE_RANGE
