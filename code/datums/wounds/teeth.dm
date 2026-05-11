/datum/wound/teeth
	name = "Dental Avulsion"
	desc = "Patient's teeth have been violently ripped off due to blunt trauma."
	severity = WOUND_SEVERITY_LIGHT
	associated_bclasses = FRACTURE_BCLASSES
	viable_zones = list(BODY_ZONE_PRECISE_MOUTH)

/datum/wound/teeth/can_apply_to_bodypart(obj/item/bodypart/mouth/affected)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(affected))
		return FALSE

	if(!affected.get_teeth_amount())
		return FALSE
	return TRUE

/datum/wound/teeth/apply_to_bodypart(obj/item/bodypart/mouth/affected, silent = FALSE, crit_message = FALSE)
	. = ..()
	if(!.)
		return
	if(!istype(affected))
		return FALSE
	if(!affected.max_teeth)
		qdel(src)
		return
	if(!silent && sound_effect)
		playsound(affected.owner, pick(sound_effect), 90, TRUE)
	affected.knock_out_teeth(rand(1, 4))
	qdel(src)
