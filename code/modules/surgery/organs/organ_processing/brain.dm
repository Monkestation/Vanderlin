/datum/organ_process/brain
	slot = ORGAN_SLOT_BRAIN

/datum/organ_process/brain/handle_process(mob/living/carbon/owner, delta_time, times_fired)
	var/obj/item/organ/brain/brain = owner.getorganslot(ORGAN_SLOT_BRAIN)
	if(!brain)
		return

	var/effective_blood_oxygenation = GET_EFFECTIVE_BLOOD_VOL(owner.get_blood_oxygenation(), owner.total_blood_req)
	var/is_stable = owner.get_chem_effect(CE_STABLE)
	var/damprob = 0

	switch(effective_blood_oxygenation)
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			if(DT_PROB(2.5, delta_time))
				to_chat(owner, span_warning("<i>I feel [pick("dizzy","woozy","faint")].</i>"))
			owner.adjustOxyLoss(round(0.005 * (BLOOD_VOLUME_NORMAL - effective_blood_oxygenation) * delta_time * 0.3, 1))
			damprob = is_stable ? 10 : 30
			if((brain.current_blood <= 0) && !brain.past_damage_threshold(2) && DT_PROB(damprob, delta_time))
				brain.applyOrganDamage(BRAIN_DAMAGE_LOW_OXYGENATION)
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			owner.adjust_eye_blur_up_to(4, 4)
			if(DT_PROB(5, delta_time))
				to_chat(owner, span_userdanger("<i>I feel very [pick("dizzy","woozy","faint")]...</i>"))
			owner.adjustOxyLoss(FLOOR(0.01 * (BLOOD_VOLUME_NORMAL - effective_blood_oxygenation) * delta_time * 0.3, 1))
			damprob = is_stable ? 15 : 50
			if((brain.current_blood <= 0) && !brain.past_damage_threshold(4) && DT_PROB(damprob, delta_time))
				brain.applyOrganDamage(BRAIN_DAMAGE_LOW_OXYGENATION)
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			owner.adjust_eye_blur_up_to(6, 6)
			if(DT_PROB(5, delta_time))
				to_chat(owner, span_userdanger("<i>I feel extremely [pick("dizzy","woozy","faint")]...</i>"))
			owner.adjustOxyLoss(2.5 * delta_time)
			damprob = is_stable ? 40 : 75
			if((brain.current_blood <= 0) && !brain.past_damage_threshold(6) && DT_PROB(damprob, delta_time))
				brain.applyOrganDamage(BRAIN_DAMAGE_LOWER_OXYGENATION)

		if(-INFINITY to BLOOD_VOLUME_SURVIVE)
			owner.adjust_eye_blur_up_to(6, 6)
			if((brain.current_blood <= 0) && DT_PROB(7.5, delta_time))
				to_chat(owner, span_userdanger("<i>I feel [pick("heavy", "dehydrated", "empty")] and [pick("faint", "weak", "lightheaded", "dizzy")]!</i>"))
			owner.adjustOxyLoss(5 * delta_time)
			owner.Unconscious(rand(6,12) SECONDS)
			damprob = is_stable ? 65 : 100
			if((brain.current_blood <= 0) && DT_PROB(damprob, delta_time))
				brain.applyOrganDamage(BRAIN_DAMAGE_LOWEST_OXYGENATION)

	owner.handle_brain_damage()
	return TRUE
