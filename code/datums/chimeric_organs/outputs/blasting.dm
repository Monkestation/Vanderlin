
/datum/chimeric_node/output/blasting
	name = "blasting"
	desc = "When activated you explode"

/datum/chimeric_node/output/blasting/trigger_effect(multiplier)
	. = ..()
	cell_explosion(get_turf(hosted_carbon), multiplier * (20 + (node_purity * 0.1)), 0.01)
