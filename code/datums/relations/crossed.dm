/datum/relation/had_crossed
	name = "Crossed"
	desc = "You have slighted them in the past and they likely hold a grudge."
	symmetric = FALSE

/datum/relation/had_crossed/get_desc_string()
	return "Something happened between [holder?.name] and [other?.name], and [other?.name] is upset about it."

/datum/relation/was_crossed
	name = "Was Crossed"
	desc = "You were slighted by them in the past and you remember it."
	symmetric = FALSE

/datum/relation/was_crossed/get_desc_string()
	return "Something happened between [holder?.name] and [other?.name], and [holder?.name] is upset about it."
