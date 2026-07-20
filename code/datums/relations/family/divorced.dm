/datum/relation/divorced
	name = "Divorced"
	desc = "You were once married to this person."
	symmetric = FALSE // each side holds their own copy
	incompatible = list(/datum/relation/family/spouse)
	category = "Family"

/datum/relation/divorced/get_desc_string()
	SHOULD_CALL_PARENT(FALSE)
	var/ex_name = snapshot?["name"] || other?.name || "someone"
	return "[holder?.name] was formerly married to [ex_name]."
