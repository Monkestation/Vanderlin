/datum/surgery_operation/basic/extract_tooth
	name = "Extract Tooth"

	implements = list(
		/obj/item/weapon/tongs = 1.2,
		/obj/item/weapon/surgery/hemostat = 1.35,
	)

	time = 3 SECONDS

	target_zone = BODY_ZONE_PRECISE_MOUTH

	skill_min = SKILL_LEVEL_EXPERT
	skill_median = SKILL_LEVEL_MASTER

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
		span_danger("I start pulling [patient]'s tooth out!"),
		span_warning("[surgeon] shoves [tool] into [patient]'s mouth!"),
		span_warning("[surgeon] begins performing an extraction on [patient]'s mouth."),
	)

/datum/surgery_operation/basic/extract_tooth/on_success(mob/living/patient, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		patient,
		span_danger("I pull [patient]'s tooth out!"),
		span_danger("[surgeon] pulls a tooth out of [patient]'s mouth!"),
		span_danger("[surgeon] pulls a tooth out of [patient]'s mouth!"),
		TRUE,
	)

	var/obj/item/bodypart/mouth/jaw = patient.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(!jaw)
		return

	jaw.knock_out_teeth(1, pick(GLOB.alldirs))
	jaw.add_pain(25)

	patient.emote("scream", intentional = TRUE)
