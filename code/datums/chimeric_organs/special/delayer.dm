/datum/chimeric_node/special/delayer
	name = "delayer"
	desc = "Will delay the triggering of organs by a flat 2 seconds this doesn't stack, this can allow you to stack activations before a cooldown"

	needs_attachment = FALSE
	attachement_type = null

/datum/chimeric_node/special/delayer/final_setup()
	ADD_TRAIT(attached_organ, "delayed", "[REF(src)]")

/datum/chimeric_node/special/delayer/removal_setup()
	REMOVE_TRAIT(attached_organ, "delayed", "[REF(src)]")
