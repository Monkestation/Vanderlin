/datum/surgery_operation/basic/restore_lux
	name = "Restore Lux"
	desc = "Grant a patient a dosage of lux to restore their own."

	implements = list(
		/obj/item/reagent_containers/lux = 1,
		/obj/item/reagent_containers/lux_tainted = 1.4,
	)

	time = 10 SECONDS

	skill_min = SKILL_LEVEL_EXPERT
	skill_median = SKILL_LEVEL_MASTER

	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_BONE_SAWED|SURGERY_VESSELS_CLAMPED

/datum/surgery_operation/basic/restore_lux/get_recommended_tool()
	return "Fragment of Lux"

/datum/surgery_operation/basic/restore_lux/get_default_radial_image()
	return image(/obj/item/reagent_containers/lux)

/datum/surgery_operation/basic/restore_lux/snowflake_check_availability(mob/living/patient, mob/living/surgeon, tool, operated_zone)
	if(!patient.getorganslot(ORGAN_SLOT_HEART))
		return FALSE

	if(patient.get_lux_status() == LUX_HAS_LUX)
		return FALSE

	if(!patient.get_lux_tainted_status())
		return TRUE

	if(!istype(tool, /obj/item/reagent_containers/lux_tainted))
		to_chat(surgeon, "They can only receive tainted lux!")
		return FALSE

	return TRUE

/datum/surgery_operation/basic/restore_lux/on_preop(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_notice("I begin to implant [tool] into [patient]..."),
		span_notice("[surgeon] begins to work [tool] into [patient]'s heart."),
		span_notice("[surgeon] begins to work something into [patient]'s innards."),
	)

/datum/surgery_operation/basic/restore_lux/on_success(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	if(patient.get_lux_tainted_status() && istype(tool, /obj/item/reagent_containers/lux_tainted))
		display_results(
			surgeon,
			patient,
			span_danger("You succeed in infusing [tool] into [patient]'s heart, but their body struggles under its power!"),
			span_danger("[patient]'s heart writhes with dark, twisted energy... the [tool] has left its mark on them."),
		)
		patient.apply_status_effect(/datum/status_effect/debuff/corrupted_by_tainted_lux)

		if(patient.get_lux_status() == LUX_NO_LUX)
			patient.apply_status_effect(/datum/status_effect/debuff/received_tainted_lux)
		else
			patient.apply_status_effect(/datum/status_effect/debuff/tainted_lux)
	else
		display_results(
			surgeon,
			patient,
			span_notice("You succeed in integrating [tool] into [patient]'s heart."),
			span_notice("[surgeon] works the [tool] into [patient]'s heart."),
			span_notice("[surgeon] works something into [patient]'s innards."),
		)
		if(patient.get_lux_status() == LUX_NO_LUX)
			patient.apply_status_effect(/datum/status_effect/buff/received_lux)
		else
			patient.remove_status_effect(/datum/status_effect/debuff/lux_drained)
			patient.remove_status_effect(/datum/status_effect/debuff/flaw_lux_taken)

	qdel(tool)

	patient.emote("breathgasp")
	patient.adjust_jitter(100 SECONDS)

/datum/surgery_operation/basic/restore_lux/on_failure(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_danger("I work the [tool] into [patient]'s heart, but nothing happens!"),
		span_danger("[surgeon] works [tool] into [patient]'s heart. But nothing happens!"),
		span_danger("[surgeon] works something into [patient]'s innards. But nothing happens!"),
	)
