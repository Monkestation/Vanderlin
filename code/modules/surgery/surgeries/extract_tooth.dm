/datum/surgery/extract_tooth
	name = "Extract Tooth"

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/extract_tooth,
	)

	possible_locs = list(BODY_ZONE_PRECISE_MOUTH)

	skill_min = SKILL_LEVEL_EXPERT
	skill_median = SKILL_LEVEL_MASTER

/datum/surgery/extract_tooth/surgery_valid(mob/living/surgeon, mob/living/carbon/patient, obj/item/implement)
	. = ..()
	if(!.)
		return

	var/obj/item/bodypart/mouth/mouth = patient.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(!mouth)
		return FALSE

	return mouth.get_teeth_amount() > 0

/datum/surgery_step/extract_tooth
	name = "Extract tooth"

	implements = list(
		/obj/item/weapon/tongs = 90,
		/obj/item/weapon/surgery/hemostat = 70,
	)

	time = 3 SECONDS

/datum/surgery_step/extract_tooth/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_danger("I start ripping <b>[target]</b>'s tooth out!"),
		span_warning("<b>[user]</b> shoves [tool] into <b>[target]</b>'s mouth!"),
		span_warning("<b>[user]</b> begins performing an extraction on <b>[target]</b>'s mouth."),
	)
	return TRUE

/datum/surgery_step/extract_tooth/success(mob/user, mob/living/target, target_zone, obj/item/weapon/tongs/tool, datum/intent/intent)
	var/obj/item/bodypart/mouth/jaw = target.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(!jaw)
		return FALSE

	jaw.knock_out_teeth(1, pick(GLOB.alldirs))
	target.emote("scream", intentional = TRUE)
	jaw.add_pain(25)

	display_results(
		user,
		target,
		span_danger("I rip <b>[target]</b>'s tooth out!"),
		span_danger("<b>[user]</b> rips a tooth out of <b>[target]</b>'s mouth!"),
		span_danger("<b>[user]</b> rips a tooth out of <b>[target]</b>'s mouth!"),
		TRUE,
	)
	return TRUE

/datum/surgery_step/extract_tooth/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(
		user,
		target,
		span_warning("I fumble with the tongs inside <b>[target]</b>'s mouth!"),
		span_warning("<b>[user]</b> fumbles with the tongs inside <b>[target]</b>'s mouth!"),
		span_warning("<b>[user]</b> fumbles with something inside <b>[target]</b>'s mouth!"),
		TRUE,
	)
	return TRUE
