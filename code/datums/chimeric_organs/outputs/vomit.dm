/datum/chimeric_node/output/vomit
	name = "nauseous"
	desc = "When activated causes you to vomit"

/datum/chimeric_node/output/vomit/trigger_effect(multiplier)
	. = ..()
	hosted_carbon.vomit()
