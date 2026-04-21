/datum/component/riding/pig/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 4, OBJ_LAYER),
		TEXT_SOUTH = list(0, 4, ABOVE_MOB_LAYER),
		TEXT_EAST = list(-2, 4, OBJ_LAYER),
		TEXT_WEST = list(2, 4, OBJ_LAYER)
	)
