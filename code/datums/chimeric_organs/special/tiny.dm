/datum/chimeric_node/special/tiny
	name = "tiny"
	desc = "Lets you be picked up like those little freaks Kobolds."
	weight = 0

	needs_attachment = FALSE
	attachement_type = null

/datum/chimeric_node/special/tiny/final_setup()
	ADD_TRAIT(hosted_carbon, TRAIT_TINY, "[REF(src)]")

/datum/chimeric_node/special/tiny/removal_setup()
	REMOVE_TRAIT(hosted_carbon, TRAIT_TINY, "[REF(src)]")
