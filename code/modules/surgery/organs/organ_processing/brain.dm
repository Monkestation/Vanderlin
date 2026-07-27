/datum/organ_process/brain
	slot = ORGAN_SLOT_BRAIN

/datum/organ_process/brain/handle_process(mob/living/carbon/owner, seconds_per_tick)
	var/obj/item/organ/brain/brain = owner.getorganslot(ORGAN_SLOT_BRAIN)
	if(!brain)
		return

	var/effective_blood_oxygenation = GET_EFFECTIVE_BLOOD_VOL(owner.get_blood_oxygenation(), owner.total_blood_req)
	var/is_stable = owner.get_chem_effect(CE_STABLE)

	// Some effects are halved mid-combat.
	var/determined_mod = owner.get_chem_effect(CE_STIMULANT) ? 0.5 : 1

	var/word = pick("dizzy","woozy","faint")
	switch(effective_blood_oxygenation)
		// Low blood but not a big deal in the immediate
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			if(SPT_PROB(2.5, seconds_per_tick))
				owner.set_eye_blur_if_lower(1 SECONDS * determined_mod)
				if(prob(50))
					to_chat(owner, span_danger("I feel [word]. It's getting a bit hard to breathe."))
					owner.losebreath += 0.5 * determined_mod * seconds_per_tick
				else if(owner.get_stamina_loss() < 25 * determined_mod)
					to_chat(owner, span_danger("I feel [word]. It's getting a bit hard to focus."))
					owner.adjust_stamina(5 * determined_mod * seconds_per_tick)
			if(brain.current_blood <= 0 && SPT_PROB(is_stable ? 10 : 30, seconds_per_tick))
				brain.applyOrganDamage(BRAIN_DAMAGE_LOW_OXYGENATION)
		// Pretty low blood, getting dangerous!
		if(BLOOD_VOLUME_RISKY to BLOOD_VOLUME_OKAY)
			if(SPT_PROB(5, seconds_per_tick))
				owner.set_eye_blur_if_lower(2 SECONDS * determined_mod)
				owner.set_dizzy_if_lower(2 SECONDS * determined_mod)
				if(prob(50))
					to_chat(owner, span_bolddanger("I feel very [word]. It's getting hard to breathe!"))
					owner.losebreath += 1 * determined_mod
				else if(owner.get_stamina_loss() < 40 * determined_mod)
					to_chat(owner, span_bolddanger("I feel very [word]. It's getting hard to stay awake!"))
					owner.adjust_stamina(7.5 * determined_mod * seconds_per_tick)
			if(brain.current_blood <= 0 && SPT_PROB(is_stable ? 15 : 45, seconds_per_tick))
				brain.applyOrganDamage(BRAIN_DAMAGE_LOW_OXYGENATION)
		// Very low blood, danger!!
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_RISKY)
			if(SPT_PROB(5, seconds_per_tick))
				owner.set_eye_blur_if_lower(4 SECONDS * determined_mod)
				owner.set_dizzy_if_lower(4 SECONDS * determined_mod)
				if(prob(50))
					to_chat(owner, span_userdanger("I feel extremely [word]! It's getting very hard to breathe!"))
					owner.losebreath += 1.5 * determined_mod
				else if(owner.get_stamina_loss() < 80 * determined_mod)
					to_chat(owner, span_userdanger("I feel extremely [word]! It's getting very hard to stay awake!"))
					owner.adjust_stamina(10 * determined_mod * seconds_per_tick)
			if(brain.current_blood <= 0 && SPT_PROB(is_stable ? 15 : 45, seconds_per_tick))
				brain.applyOrganDamage(BRAIN_DAMAGE_LOWER_OXYGENATION)
		// Critically low blood, death is near! Adrenaline won't help you here.
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			if(SPT_PROB(7.5, seconds_per_tick))
				if(owner.stat < UNCONSCIOUS)
					owner.Unconscious(rand(0.5 SECONDS, 1 SECONDS))
					to_chat(owner, span_userdanger("I black out for a moment!"))
				if(prob(50))
					owner.losebreath += 1.5
				else if(owner.get_stamina_loss() < 80)
					owner.adjust_stamina(10 * seconds_per_tick)
			if(brain.current_blood <= 0 && SPT_PROB(is_stable ? 25 : 75, seconds_per_tick))
				brain.applyOrganDamage(BRAIN_DAMAGE_LOWER_OXYGENATION)
		// Below BLOOD_VOLUME_SURVIVE, your brain starts to die
		if(-INFINITY to BLOOD_VOLUME_SURVIVE)
			owner.Unconscious(rand(6,12) SECONDS)
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(owner, span_userdanger("<i>I feel [pick("heavy", "dehydrated", "empty")] and [word]!</i>"))
			if(brain.current_blood <= 0 && SPT_PROB(is_stable ? 33 : 100, seconds_per_tick))
				brain.applyOrganDamage(BRAIN_DAMAGE_LOWEST_OXYGENATION)

	owner.handle_brain_damage(seconds_per_tick)
	return TRUE
