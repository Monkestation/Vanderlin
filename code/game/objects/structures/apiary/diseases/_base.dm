
/datum/bee_disease
	var/name = "Unknown Disease"
	var/description = "A mysterious affliction"
	var/progression_rate = 1.0
	var/severity_threshold = DISEASE_CRITICAL_SEVERITY
	var/infection_chance_base = DISEASE_BASE_INFECTION
	var/infection_chance_nearby = DISEASE_NEARBY_INFECTION

/datum/bee_disease/proc/apply_effects(obj/structure/apiary/hive)
	return

/datum/bee_disease/proc/get_inspection_message()
	return "The bees appear diseased."

/datum/bee_disease/proc/get_severity_description(severity)
	if(severity < 30)
		return span_notice("The infection appears to be mild.")
	else if(severity < 70)
		return span_warning("The infection is moderately severe.")
	else
		return span_danger("The infection is very severe! The colony may collapse soon!")
