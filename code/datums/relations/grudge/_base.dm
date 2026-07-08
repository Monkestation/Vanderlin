/datum/history
	var/label = "Incident"
	var/aggressor_text = ""
	var/victim_text = ""
	var/created_at = 0
	var/datum/mind/aggressor
	var/datum/mind/victim

/datum/history/New(label, aggressor_text, victim_text, datum/mind/aggressor, datum/mind/victim)
	src.label = label
	src.aggressor_text = aggressor_text
	src.victim_text = victim_text
	src.aggressor = aggressor
	src.victim = victim
	src.created_at = world.time

/datum/history/proc/attach_to(datum/relation/R)
	LAZYADD(R.relation_history, src)
	return src
