/datum/organ_process/spleen
	slot = ORGAN_SLOT_SPLEEN
	mob_types = list(/mob/living/carbon/human)

/datum/organ_process/spleen/needs_process(mob/living/carbon/owner)
	return (..() && !HAS_TRAIT(owner, TRAIT_NOHUNGER) && CAN_HAVE_BLOOD(owner))

/datum/organ_process/spleen/handle_process(mob/living/carbon/owner, delta_time, times_fired)
	if(owner.get_blood_volume() >= BLOOD_VOLUME_NORMAL)
		return

	var/nutrition_ratio = clamp(round(owner.nutrition / NUTRITION_LEVEL_WELL_FED, 0.2), 0.4, 1)

	if(owner.satiety > 80)
		nutrition_ratio *= 1.25

	var/blood_regen = 0
	var/combined_nutrition_requirement = 0
	var/list/spleens = owner.getorganslotlist(ORGAN_SLOT_SPLEEN)
	for(var/thing in spleens)
		var/obj/item/organ/spleen/spleen = thing
		blood_regen += (spleen.get_slot_efficiency(ORGAN_SLOT_SPLEEN) * spleen.blood_regen_factor)
		combined_nutrition_requirement += spleen.nutriment_req / 100
	var/blood_restore_multiplier = 1 + owner.get_chem_effect(CE_BLOODRESTORE)
	blood_regen *= blood_restore_multiplier
	combined_nutrition_requirement *= blood_restore_multiplier
	if(!blood_regen)
		return
	owner.adjust_nutrition(-combined_nutrition_requirement * nutrition_ratio * delta_time)
	owner.adjust_blood_volume(CEILING(blood_regen * nutrition_ratio * delta_time, 0.1))
	return TRUE
