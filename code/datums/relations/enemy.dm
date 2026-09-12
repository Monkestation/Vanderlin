/datum/relation/enemy
	name = "Enemy"
	desc = "You have known them for a while and really cannot stand each other."
	incompatible = list(/datum/relation/friend)
	upgrades = list(/datum/relation/acquaintance, /datum/relation/rival)

/datum/relation/enemy/get_desc_string()
	return "[holder?.name] and [other?.name] do not get along well."
