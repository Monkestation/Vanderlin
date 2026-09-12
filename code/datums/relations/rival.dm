/datum/relation/rival
	name = "Rival"
	desc = "You are engaged in a constant struggle to prove who is the better."
	upgrades = list(/datum/relation/acquaintance)
	category = "Rival"

/datum/relation/rival/get_desc_string()
	return "[holder?.name] and [other?.name] are fiercely competitive with one another."
