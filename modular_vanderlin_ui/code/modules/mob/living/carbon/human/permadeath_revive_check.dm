/mob/living/carbon/human/can_be_revived()
	. = ..()
	if(!.)
		return
	if(permadeath_enabled)
		return FALSE
	return TRUE