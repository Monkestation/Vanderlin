/area/overlord_lair
	name = "Phylactery Lair"

/area/overlord_lair/Exit(atom/movable/AM, atom/newLoc)
	. = ..()
	if(istype(AM, /mob/camera/strategy_controller))
		AM.forceMove(get_turf(GLOB.lair_portal))

/area/overlord_lair/Exited(atom/movable/M)
	. = ..()
	if(istype(M, /mob/camera/strategy_controller))
		M.forceMove(get_turf(GLOB.lair_portal))
