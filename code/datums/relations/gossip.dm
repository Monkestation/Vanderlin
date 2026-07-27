/datum/history/gossip
	var/is_noble = FALSE
	/// The gossip text as the listener hears it, e.g. "stole from the treasury"
	var/heard_text = ""

/datum/history/gossip/rumor
	label = "Rumor"
	is_noble = FALSE

/datum/history/gossip/noble
	label = "Noble Gossip"
	is_noble = TRUE
