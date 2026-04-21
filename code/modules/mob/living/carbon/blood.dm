
// bleedout checks
/mob/living/carbon/proc/in_bleedout()
	return (CHECK_BITFIELD(status_flags, BLEEDOUT))

/// Blood volume, affected by the heart
/mob/living/carbon/proc/get_blood_circulation()
	if(HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
		return BLOOD_VOLUME_NORMAL
	if(!needs_heart())
		return blood_volume

	var/heart_efficiency = getorganslotefficiency(ORGAN_SLOT_HEART)
	var/apparent_blood_volume = blood_volume

	var/pulse_mod = 1
	if(HAS_TRAIT(src, TRAIT_FAKEDEATH))
		pulse_mod = 1
	else
		switch(pulse)
			if(-INFINITY to PULSE_NONE)
				//Did someone at least perform CPR?
				if(recent_heart_pump && (world.time <= text2num(recent_heart_pump[1]) + heart_pump_duration))
					pulse_mod *= recent_heart_pump[recent_heart_pump[1]]
				else
					if(stat < DEAD)
						//Fuck - But we're still alive so there is *some* blood flow.
						pulse_mod *= 0.1
					else
						//Dead people don't pump blood, at all
						pulse_mod *= 0
			if(PULSE_SLOW)
				pulse_mod *= 0.9
			if(PULSE_FAST)
				pulse_mod *= 1.1
			if(PULSE_FASTER, PULSE_THREADY)
				pulse_mod *= 1.25

	var/min_efficiency = recent_heart_pump ? 0.5 : 0.25
	apparent_blood_volume *= clamp(1 - (100 - heart_efficiency)/100, min_efficiency, 5)
	apparent_blood_volume *= pulse_mod

	var/blockage = get_chem_effect(src, CE_BLOCKAGE)
	if(blockage)
		var/list/hearts = getorganslotlist(ORGAN_SLOT_HEART)
		var/bypassed_heart = FALSE
		for(var/thing in hearts)
			var/obj/item/organ/heart/heart = thing
			if(heart.open)
				bypassed_heart = TRUE
		if(!bypassed_heart)
			apparent_blood_volume *= max(0, 1 - (blockage/100))

	return apparent_blood_volume

/// Blood volume, affected by the condition of circulation organs, affected by the oxygen loss - What ultimately matters for brain.
/mob/living/carbon/proc/get_blood_oxygenation()
	if(HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
		return BLOOD_VOLUME_NORMAL

	var/apparent_blood_volume = get_blood_circulation()
	if(blood_carries_oxygen())
		if(!needs_lungs())
			return apparent_blood_volume
	else
		apparent_blood_volume = BLOOD_VOLUME_NORMAL

	var/apparent_blood_volume_mod = max(0, 1 - (getOxyLoss() * 0.1) /max(maxHealth, 1))
	var/oxygenated = get_chem_effect(CE_OXYGENATED)
	if(oxygenated == 1) // Tirimol
		apparent_blood_volume_mod += 0.5
	else if(oxygenated >= 2) // Dexalin plus
		apparent_blood_volume_mod += 0.8
	apparent_blood_volume = apparent_blood_volume * apparent_blood_volume_mod
	return apparent_blood_volume

/// Do we need blood to sustain the brain?
/mob/living/carbon/proc/blood_carries_oxygen()
	return TRUE

/mob/living/carbon/proc/needs_lungs()
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return FALSE
	return TRUE
