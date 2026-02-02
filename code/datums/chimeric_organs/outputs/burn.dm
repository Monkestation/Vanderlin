/datum/chimeric_node/output/burn
	name = "ignition"
	desc = "When activated ignites you."

/datum/chimeric_node/output/burn/trigger_effect(multiplier)
	. = ..()
	hosted_carbon.fire_act(1, 1 - (node_purity * 0.1))
