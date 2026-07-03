/datum/surgery_operation/basic/extract_chimeric_node
	name = "Extract Humors"
	desc = "Extract humors from an animals organs for augmentation."

	category = "Pestran"
	heretical = TRUE

	implements = list(
		TOOL_SCALPEL = 1,
		TOOL_SAW = 1.2,
	)

	time = 5 SECONDS

	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT

	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_BONE_SAWED|SURGERY_VESSELS_CLAMPED

/datum/surgery_operation/basic/extract_chimeric_node/get_default_radial_image()
	return image(/obj/item/chimeric_node)

/datum/surgery_operation/basic/extract_chimeric_node/all_required_strings()
	return list("the patient must be on a meathook") + ..()

/datum/surgery_operation/basic/extract_chimeric_node/state_check(mob/living/patient)
	if(!istype(patient, /mob/living/simple_animal))
		return FALSE

	if(HAS_TRAIT(patient, TRAIT_NODE_EXTRACTED))
		return FALSE

	if(!istype(patient.buckled, /obj/structure/meathook))
		return FALSE

	return TRUE

/datum/surgery_operation/basic/extract_chimeric_node/on_preop(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_notice("I begin to carefully extract chimeric tissue from [patient]'s organs..."),
		span_warning("[surgeon] begins to chimeric tissue from [patient]'s innards."),
		span_warning("[surgeon] begins to extract something from [patient]'s innards."),
	)

/datum/surgery_operation/basic/extract_chimeric_node/on_success(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_notice("You successfully extract chimeric tissue from [patient], forming it into a node."),
		span_warning("[surgeon] extracts chimeric tissue from [patient]'s body."),
		span_warning("[surgeon] extracts something grotesque from [patient]'s body."),
	)

	var/amount = rand(1, 3)
	for(var/i = 1 to amount)
		patient.create_chimeric_node()

	patient.adjustBruteLoss(30)
	patient.adjustOxyLoss(30)
	patient.emote("gasp")

	ADD_TRAIT(patient, TRAIT_NODE_EXTRACTED, "surgery")

	record_featured_stat(FEATURED_STATS_CRIMINALS, surgeon)

/datum/surgery_operation/basic/extract_chimeric_node/on_failure(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_warning("I botch the extraction, causing severe damage!"),
		span_warning("[surgeon] makes a mistake during the extraction!"),
		span_warning("[surgeon] makes a mistake!")
	)

	patient.adjustBruteLoss(50)
	patient.emote("painscream")
