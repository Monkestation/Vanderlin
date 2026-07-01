/datum/relation/acquaintance
	name = "Acquaintance"
	desc = "Someone you have crossed paths with."
	upgrades = list(/datum/relation/had_crossed, /datum/relation/was_crossed)

/datum/relation/acquaintance/get_desc_string()
	return "[holder?.name] and [other?.name] have met before."
