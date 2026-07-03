/datum/surgery_operation/basic/revival
	name = "Revive"
	desc = "Bring someone back to the world of the living through a dosage of Lux."

	category = "Pestran"

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

/datum/surgery_operation/basic/revival/get_recommended_tool()
	return "Fragment of Lux"

/datum/surgery_operation/basic/revival/get_default_radial_image()
	return image(/obj/item/reagent_containers/lux)

/datum/surgery_operation/basic/revival/snowflake_check_availability(mob/living/patient, mob/living/surgeon, tool, operated_zone)
	if(!patient.get_lux_tainted_status())
		return TRUE

	if(!istype(tool, /obj/item/reagent_containers/lux_tainted))
		to_chat(surgeon, "They can only receive tainted lux!")
		return FALSE

	return TRUE

/datum/surgery_operation/basic/revival/state_check(mob/living/patient)
	if(patient.stat != DEAD)
		return FALSE

	if(!patient.getorganslot(ORGAN_SLOT_HEART))
		return FALSE

	if(patient.mob_biotypes & MOB_UNDEAD)
		return FALSE

	if(HAS_TRAIT(patient, TRAIT_NECRA_CURSE))
		return FALSE

	return TRUE

/datum/surgery_operation/basic/revival/on_preop(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_notice("I begin to infuse [patient]'s heart with [tool]."),
		span_notice("[surgeon] begins to work [tool] into [patient]'s heart."),
		span_notice("[surgeon] begins to something into [patient]'s innards..."),
	)

/datum/surgery_operation/basic/revival/on_success(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	if(!patient.revive(excess_healing = 50))
		return on_failure(patient, surgeon, tool, operation_args)

	patient.reagents.add_reagent(/datum/reagent/medicine/atropine, 25)

	add_abstract_elastic_data(ELASCAT_MEDICAL, ELASDATA_LUX_REVIVE, 1)

	if(patient.get_lux_tainted_status() && istype(tool, /obj/item/reagent_containers/lux_tainted))
		display_results(
			surgeon,
			patient,
			span_danger("I succeed in restarting [patient]'s heart, but the [tool] has corrupted their being!"),
			span_danger("[patient]'s heart is clouded with a dark, sinister energy from the [tool]."),
		)
		patient.apply_status_effect(/datum/status_effect/debuff/corrupted_by_tainted_lux)
	else
		display_results(
			surgeon,
			patient,
			span_notice("I succeed in restarting [patient]'s heart with the infusion of [tool]."),
			span_notice("[surgeon] works [tool] into [patient]'s heart."),
			span_notice("[surgeon] works something into [patient]'s innards."),
		)

	qdel(tool)

	if(patient.health > HALFWAYCRITDEATH)
		patient.adjustOxyLoss(patient.health - HALFWAYCRITDEATH)

	if(iscarbon(patient))
		var/mob/living/carbon/carbon_patient = patient
		for(var/obj/item/organ/organs as anything in carbon_patient.internal_organs)
			if(organs.germ_level >= INFECTION_LEVEL_ONE * 0.2)
				organs.set_germ_level(INFECTION_LEVEL_ONE * 0.2)
			if(organs.organ_flags & ORGAN_DESTROYED)
				organs.organ_flags &= ~ORGAN_DESTROYED //I am having pity on people here at this point I won't force you to get new organs unless they fully necrose.
				organs.scar_organ(20, 40)
			if(organs.damage > organs.medium_threshold)
				organs.applyOrganDamage(-organs.medium_threshold)

	patient.grab_ghost(force = TRUE, grab_spirit = TRUE) // even suicides
	patient.visible_message(span_notice("[patient] is dragged back from Necra's hold!"), span_green("I awake from the void."))

	patient.remove_status_effect(/datum/status_effect/debuff/lux_drained)
	patient.remove_status_effect(/datum/status_effect/debuff/flaw_lux_taken)

	record_round_statistic(STATS_LUX_REVIVALS)

/datum/surgery_operation/basic/revival/on_failure(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_danger("I work the [tool] into [patient]'s heart, but nothing happens!"),
		span_danger("[surgeon] works [tool] into [patient]'s heart. But nothing happens!"),
		span_danger("[surgeon] works something into [patient]'s innards. But nothing happens!"),
	)
