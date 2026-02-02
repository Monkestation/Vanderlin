
/datum/chimeric_node/special/twinned
	name = "twinned"

	needs_attachment = TRUE
	attachement_type = OUTPUT_NODE

	var/static/list/global_twinned_floaters = list()

	var/datum/chimeric_node/special/twinned/attached_twinned

/datum/chimeric_node/special/twinned/setup()
	if(length(global_twinned_floaters))
		var/datum/chimeric_node/special/twinned/plucked_node = pick(global_twinned_floaters)
		attached_twinned = plucked_node
		global_twinned_floaters -= plucked_node
		return
	global_twinned_floaters += src

/datum/chimeric_node/special/twinned/trigger_special(is_good = TRUE, multiplier, modifier)
	if(!attached_twinned)
		return FALSE
	attached_output.trigger_effect(is_good, multiplier)
	return TRUE
