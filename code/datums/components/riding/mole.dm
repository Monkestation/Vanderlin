/datum/component/riding/mole/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return  list(
		TEXT_NORTH = list(6, 25, OBJ_LAYER),
		TEXT_SOUTH = list(12, 25, ABOVE_MOB_LAYER),
		TEXT_EAST = list(15, 25, OBJ_LAYER),
		TEXT_WEST = list(30, 25, OBJ_LAYER)
	)
