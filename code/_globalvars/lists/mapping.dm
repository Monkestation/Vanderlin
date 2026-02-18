GLOBAL_LIST_INIT(cardinals, list(NORTH, SOUTH, EAST, WEST))
GLOBAL_LIST_INIT(cardinals_multiz, list(NORTH, SOUTH, EAST, WEST, UP, DOWN))
GLOBAL_LIST_INIT(diagonals, list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
GLOBAL_LIST_INIT(corners_multiz, list(UP|NORTHEAST, UP|NORTHWEST, UP|SOUTHEAST, UP|SOUTHWEST, DOWN|NORTHEAST, DOWN|NORTHWEST, DOWN|SOUTHEAST, DOWN|SOUTHWEST))
GLOBAL_LIST_INIT(diagonals_multiz, list(
	NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST,
	UP|NORTH, UP|SOUTH, UP|EAST, UP|WEST, UP|NORTHEAST, UP|NORTHWEST, UP|SOUTHEAST, UP|SOUTHWEST,
	DOWN|NORTH, DOWN|SOUTH, DOWN|EAST, DOWN|WEST, DOWN|NORTHEAST, DOWN|NORTHWEST, DOWN|SOUTHEAST, DOWN|SOUTHWEST))
GLOBAL_LIST_INIT(alldirs_multiz, list(
	NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST,
	UP, UP|NORTH, UP|SOUTH, UP|EAST, UP|WEST, UP|NORTHEAST, UP|NORTHWEST, UP|SOUTHEAST, UP|SOUTHWEST,
	DOWN, DOWN|NORTH, DOWN|SOUTH, DOWN|EAST, DOWN|WEST, DOWN|NORTHEAST, DOWN|NORTHWEST, DOWN|SOUTHEAST, DOWN|SOUTHWEST))
GLOBAL_LIST_INIT(alldirs, list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))

GLOBAL_LIST_EMPTY(landmarks_list)				//list of all landmarks created
GLOBAL_LIST_EMPTY(start_landmarks_list)			//list of all spawn points created
GLOBAL_LIST_EMPTY(department_security_spawns)	//list of all department security spawns
GLOBAL_LIST_EMPTY(generic_event_spawns)			//handles clockwork portal+eminence teleport destinations
GLOBAL_LIST_EMPTY(jobspawn_overrides)			//These will take precedence over normal spawnpoints if created.

GLOBAL_LIST_EMPTY(lich_starts)
GLOBAL_LIST_EMPTY(bandit_starts)
GLOBAL_LIST_EMPTY(admin_warp)
GLOBAL_LIST_EMPTY(vlord_starts)
GLOBAL_LIST_EMPTY(vspawn_starts)
GLOBAL_LIST_EMPTY(dknight_starts)
GLOBAL_LIST_EMPTY(delf_starts)
GLOBAL_LIST_EMPTY(jarosite_starts) // ewww
GLOBAL_LIST_EMPTY(newplayer_start)
GLOBAL_LIST_EMPTY(prisonwarp)	//admin prisoners go to these
GLOBAL_LIST_EMPTY(prisonwarped)	//list of players already warped
GLOBAL_LIST_EMPTY(underworldspawn)
GLOBAL_LIST_EMPTY(underworldspiritspawns) //Where spirits can spawn
GLOBAL_LIST_EMPTY(underworld_coinpull_locs) //When picking up coin maze, warp here
GLOBAL_LIST_EMPTY(hauntstart)
GLOBAL_LIST_EMPTY(testportals)
GLOBAL_LIST_EMPTY(traveltiles)
GLOBAL_LIST_EMPTY(traveltile_spawners)
GLOBAL_LIST_EMPTY(emergencyresponseteamspawn)
GLOBAL_LIST_EMPTY(ruin_landmarks)

/// List of all the maps that have been cached for /proc/load_map
GLOBAL_LIST_EMPTY(cached_maps)

/// Just a list of all the area objects in the game
/// Note, areas can have duplicate types
GLOBAL_LIST_EMPTY(areas)
/// Used by jump-to-area etc. Updated by area/updateName()
/// If this is null, it needs to be recalculated. Use get_sorted_areas() as a getter please
GLOBAL_LIST_EMPTY(sortedAreas)
/// An association from typepath to area instance. Only includes areas with `unique` set.
GLOBAL_LIST_EMPTY_TYPED(areas_by_type, /area)

GLOBAL_LIST_EMPTY(all_abstract_markers)

GLOBAL_LIST_EMPTY(fires_list)

GLOBAL_LIST_EMPTY(streetlamp_list)
