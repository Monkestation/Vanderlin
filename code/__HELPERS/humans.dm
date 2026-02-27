/mob/living/carbon/human/proc/is_noble()
	if(job in GLOB.noble_positions)
		return TRUE
	if(HAS_TRAIT(src, TRAIT_NOBLE_BLOOD) || HAS_TRAIT(src, TRAIT_NOBLE_POWER))
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/is_yeoman()
	return FALSE

/mob/living/carbon/human/proc/is_courtier()
	return FALSE
