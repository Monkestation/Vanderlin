/datum/component/riding/saiga/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 8, OBJ_LAYER),
		TEXT_SOUTH = list(0, 8, ABOVE_MOB_LAYER),
		TEXT_EAST = list(-2, 8, OBJ_LAYER),
		TEXT_WEST = list(2, 8, OBJ_LAYER)
	)
