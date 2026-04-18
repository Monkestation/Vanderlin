/datum/component/riding/gote/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 6, OBJ_LAYER),
		TEXT_SOUTH = list(0, 6, OBJ_LAYER),
		TEXT_EAST = list(-2, 6, OBJ_LAYER),
		TEXT_WEST = list(2, 6, OBJ_LAYER)
	)
