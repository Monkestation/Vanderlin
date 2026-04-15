/datum/organ_process/spleen
	slot = ORGAN_SLOT_SPLEEN
	mob_types = list(/mob/living/carbon/human)

/datum/organ_process/spleen/needs_process(mob/living/carbon/owner)
	return (..() && !HAS_TRAIT(owner, TRAIT_NOHUNGER))

/datum/organ_process/spleen/handle_process(mob/living/carbon/owner, delta_time, times_fired)
	if(owner.blood_volume >= BLOOD_VOLUME_NORMAL)
		return
	var/nutrition_ratio = 0
	switch(owner.nutrition)
		if(0 to NUTRITION_LEVEL_STARVING)
			nutrition_ratio = 0.2
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
			nutrition_ratio = 0.4
		if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
			nutrition_ratio = 0.6
		if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
			nutrition_ratio = 0.8
		else
			nutrition_ratio = 1
	if(owner.satiety > 80)
		nutrition_ratio *= 1.25

	var/blood_regen = 0
	var/combined_nutrition_requirement = 0
	var/list/spleens = owner.getorganslotlist(ORGAN_SLOT_SPLEEN)
	for(var/thing in spleens)
		var/obj/item/organ/spleen/spleen = thing
		blood_regen += (spleen.get_slot_efficiency(ORGAN_SLOT_SPLEEN) * spleen.blood_regen_factor)
		combined_nutrition_requirement += (spleen.nutriment_req/20)
	blood_regen *= (1 + owner.get_chem_effect(CE_BLOODRESTORE))
	combined_nutrition_requirement *= (1 + (owner.get_chem_effect(CE_BLOODRESTORE) * 0.5))
	if(!blood_regen)
		return
	owner.adjust_nutrition(-combined_nutrition_requirement * nutrition_ratio * 0.5 * delta_time)
	owner.adjust_bloodvolume(CEILING(blood_regen * nutrition_ratio * 0.5 * delta_time, 0.1))
	return TRUE

/// Blood volume adjust proc
/mob/living/proc/adjust_bloodvolume(amount, cap)
	if(cap && (blood_volume >= cap))
		return TRUE
	blood_volume = max(blood_volume + amount, 0)
	return TRUE
