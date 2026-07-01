/datum/surgery_operation/basic/extract_tooth
	name = "Extract Tooth"
	desc = "Pull a tooth from the patient's jaw."

	implements = list(
		/obj/item/weapon/tongs = 1,
		/obj/item/weapon/surgery/hemostat = 1.35,
	)

	time = 3 SECONDS

	target_zone = BODY_ZONE_PRECISE_MOUTH

	skill_min = SKILL_LEVEL_EXPERT
	skill_median = SKILL_LEVEL_MASTER

	any_surgery_states_blocked = SURGERY_SKIN_OPEN

/datum/surgery_operation/basic/extract_tooth/get_recommended_tool()
	return "Tongs"

/datum/surgery_operation/basic/extract_tooth/get_default_radial_image()
	return image(/obj/item/weapon/tongs)

/datum/surgery_operation/basic/extract_tooth/all_required_strings()
	return list("patient needs teeth") + ..()

/datum/surgery_operation/basic/extract_tooth/state_check(mob/living/patient)
	var/obj/item/bodypart/mouth/mouth = patient.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(!mouth)
		return FALSE

	return (mouth.get_teeth_amount() > 0)

/datum/surgery_operation/basic/extract_tooth/on_preop(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_danger("I start removing [patient]'s tooth."),
		span_danger("[surgeon] start removing <b>[patient]</b>'s tooth."),
		span_warning("[surgeon] begins performing an extraction in [patient]'s mouth."),
	)

/datum/surgery_operation/basic/extract_tooth/on_success(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_danger("I remove [patient]'s tooth!"),
		span_danger("[surgeon] removes a tooth from [patient]'s mouth!"),
		span_danger("[surgeon] removes a tooth from [patient]'s mouth!"),
		TRUE,
	)

	var/obj/item/bodypart/mouth/jaw = patient.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(!jaw)
		return

	jaw.knock_out_teeth(1, pick(GLOB.alldirs))
	jaw.add_pain(25)

	patient.emote("scream")
