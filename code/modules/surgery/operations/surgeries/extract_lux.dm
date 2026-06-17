/datum/surgery_operation/basic/extract_lux
	name = "Lux Extraction"
	desc = "Sever ones divine link by extracting the lux from their heart."

	category = "Pestran"

	implements = list(
		TOOL_SCALPEL = 1,
		TOOL_SAW = 1.6,
		IMPLEMENT_HAND = 2.5,
	)

	time = 8 SECONDS

	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT

	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_BONE_SAWED|SURGERY_VESSELS_CLAMPED

/datum/surgery_operation/basic/extract_lux/get_default_radial_image()
	return image(/obj/item/reagent_containers/lux)

/datum/surgery_operation/basic/extract_lux/state_check(mob/living/patient)
	if(patient.stat == DEAD)
		return FALSE

	if(patient.get_lux_status() != LUX_HAS_LUX)
		return FALSE

	if(!patient.getorganslot(ORGAN_SLOT_HEART))
		return FALSE

	return TRUE

/datum/surgery_operation/basic/extract_lux/on_preop(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_notice("I begin to scrape lux from [patient]'s heart..."),
		span_notice("[surgeon] begins to scrape lux from [patient]'s heart."),
		span_notice("[surgeon] begins to scrape lux from [patient]'s heart."),
	)

/datum/surgery_operation/basic/extract_lux/on_success(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	if(patient.get_lux_tainted_status() || patient.has_status_effect(/datum/status_effect/debuff/tainted_lux) || patient.has_status_effect(/datum/status_effect/debuff/received_tainted_lux))
		display_results(
			surgeon,
			patient,
			span_notice("You extract a single dose of tainted lux from [patient]'s heart."),
			span_notice("[surgeon] extracts tainted lux from [patient]'s innards."),
			span_notice("[surgeon] extracts something from [patient]'s innards."),
		)
		new /obj/item/reagent_containers/lux_tainted(get_turf(patient))
	else
		display_results(
			surgeon,
			patient,
			span_notice("You extract a single dose of lux from [patient]'s heart."),
			span_notice("[surgeon] extracts lux from [patient]'s innards."),
			span_notice("[surgeon] extracts something from [patient]'s innards."),
		)
		new /obj/item/reagent_containers/lux(get_turf(patient))

	patient.emote("painscream")

	if(patient.has_status_effect(/datum/status_effect/debuff/received_tainted_lux))
		patient.remove_status_effect(/datum/status_effect/debuff/received_tainted_lux)
	else if(patient.has_status_effect(/datum/status_effect/buff/received_lux))
		patient.remove_status_effect(/datum/status_effect/buff/received_lux)
	else
		patient.apply_status_effect(/datum/status_effect/debuff/lux_drained)
		patient.remove_status_effect(/datum/status_effect/debuff/tainted_lux)

	SEND_SIGNAL(surgeon, COMSIG_LUX_EXTRACTED, patient)

	record_featured_stat(FEATURED_STATS_CRIMINALS, surgeon)
	record_round_statistic(STATS_LUX_HARVESTED)

	if(patient.client)
		add_abstract_elastic_data(ELASCAT_MEDICAL, ELASDATA_LUX_EXTRACT_PLAYER, 1)
	else
		add_abstract_elastic_data(ELASCAT_MEDICAL, ELASDATA_LUX_EXTRACT, 1)
