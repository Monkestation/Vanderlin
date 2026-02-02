/datum/chimeric_node/special
	abstract_type = /datum/chimeric_node/special
	name = "Special Node"
	desc = "Generic special node"
	slot = SPECIAL_NODE

	var/needs_attachment = FALSE
	var/attachement_type = INPUT_NODE

	var/datum/chimeric_node/input/attached_input
	var/datum/chimeric_node/output/attached_output

/datum/chimeric_node/special/proc/trigger_special(is_good = TRUE, multiplier, datum/component/chimeric_organ/modifier)
	return
