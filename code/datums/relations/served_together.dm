
/datum/relation/served_together
	name = "Served Together"
	desc = "You crossed paths during active military service."
	upgrades = list(/datum/relation/acquaintance)

/datum/relation/served_together/get_desc_string()
	return "[holder?.name] and [other?.name] served together at some point."
