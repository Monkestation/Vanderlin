/datum/surgery_operation/basic/cure_rot
	name = "Cure Rot"
	desc = "Cleanse a limb of rot, lethal to deadites when performed on the chest."

	implements = list(
		TOOL_CAUTERY = 1,
		/obj/item/clothing/neck/psycross/silver = 1.4,
		/obj/item = 1.55,
	)

	time = 4 SECONDS

	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

	skill_min = SKILL_LEVEL_APPRENTICE

	any_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_VESSELS_CLAMPED

/datum/surgery_operation/basic/cure_rot/get_recommended_tool()
	return TOOL_CAUTERY

/datum/surgery_operation/basic/cure_rot/get_default_radial_image()
	return image(/obj/item/weapon/surgery/cautery)

/datum/surgery_operation/basic/cure_rot/state_check(mob/living/patient)
	if(!iscarbon(patient))
		return FALSE

	if(IS_DEADITE(patient))
		return TRUE

	var/mob/living/carbon/carbon_patient = patient
	for(var/obj/item/bodypart/part as anything in carbon_patient.bodyparts)
		if(HAS_TRAIT(part, TRAIT_ROTTEN))
			return TRUE

	for(var/obj/item/organ/organ as anything in carbon_patient.internal_organs)
		if(organ.germ_level >= INFECTION_LEVEL_ONE * 0.2)
			return TRUE

	return FALSE

/datum/surgery_operation/basic/cure_rot/tool_check(obj/item/tool)
	if(!istype(tool, /obj/item/clothing/neck/psycross) && !tool.get_temperature())
		return FALSE

	return TRUE

/datum/surgery_operation/basic/cure_rot/on_preop(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_notice("I begin to burn the rot within [patient]..."),
		span_notice("[surgeon] begins to burn the rot from [patient]."),
		span_notice("[surgeon] begins to burn the flesh of [patient]."),
	)

/datum/surgery_operation/basic/cure_rot/on_success(mob/living/carbon/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_notice("I burn away the rot from [patient]."),
		span_notice("[surgeon] burns the rot from [patient]."),
		span_notice("[surgeon] burns the flesh of [patient]."),
	)

	// I would rather not have this but afaik this is the only way to reduce this outside of the cure rot miracle
	var/datum/component/rot/rot = patient?.GetComponent(/datum/component/rot)
	if(rot) // ew
		rot.amount = 0

	if(ishuman(patient))
		var/mob/living/carbon/human/H = patient
		H?.funeral = FALSE

	if(IS_DEADITE(patient))
		patient.mind.remove_antag_datum(/datum/antagonist/zombie)
		patient.death()

	var/damage = max(20 - (GET_MOB_SKILL_VALUE(surgeon, skill_used) / 3), 0)
	for(var/obj/item/bodypart/part as anything in patient.bodyparts)
		part.revive_limb()
		part.germ_level = 0
		part.receive_damage(burn = damage)

	for(var/obj/item/organ as anything in patient.internal_organs)
		if(organ.germ_level >= INFECTION_LEVEL_ONE * 0.2)
			organ.set_germ_level(INFECTION_LEVEL_ONE * 0.2)
