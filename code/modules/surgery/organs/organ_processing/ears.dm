/datum/organ_process/ears
	slot = ORGAN_SLOT_EARS
	mob_types = list(/mob/living/carbon/human)

/datum/organ_process/ears/handle_process(mob/living/carbon/owner, delta_time, times_fired)
	var/ear_efficiency = owner.getorganslotefficiency(ORGAN_SLOT_EARS)
	if((ear_efficiency < bruised_threshold) && (ear_efficiency > failing_threshold) && DT_PROB(((optimal_threshold - ear_efficiency)/optimal_threshold) * 2, delta_time))
		owner.sound_damage(0, 4 SECONDS)
		to_chat(owner, span_warning("The ringing in your ears grows louder, blocking out any external noises for a moment."))
	if(ear_efficiency < failing_threshold)
		ADD_TRAIT(owner, TRAIT_DEAF, NO_EARS)
	else
		REMOVE_TRAIT(owner, TRAIT_DEAF, NO_EARS)
	return TRUE
