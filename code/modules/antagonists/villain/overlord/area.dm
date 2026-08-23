/area/overlord_lair
	name = "Phylactery Lair"

/area/overlord_lair/Exit(atom/movable/leaving, direction)
	. = ..()
	if(istype(leaving, /mob/camera/strategy_controller))
		leaving.forceMove(get_turf(GLOB.lair_portal))

/area/overlord_lair/Exited(atom/movable/gone, direction)
	. = ..()
	if(istype(gone, /mob/camera/strategy_controller))
		gone.forceMove(get_turf(GLOB.lair_portal))
