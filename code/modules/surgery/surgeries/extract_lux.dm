/datum/surgery/extract_lux
	name = "Lux Extraction"
	category = "Pestran"

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/saw,
		/datum/surgery_step/extract_lux,
		/datum/surgery_step/cauterize
	)

	possible_locs = list(BODY_ZONE_CHEST)

	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT

/datum/surgery/extract_lux/can_start(mob/user, mob/living/patient, obj/item/tool, feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE

	if(patient.stat == DEAD)
		if(feedback)
			patient.balloon_alert(user, "patient is dead")
		return FALSE

	if(patient.get_lux_status() != LUX_HAS_LUX)
		if(feedback)
			patient.balloon_alert(user, "patient has no lux")
		return FALSE

	if(!patient.getorganslot(ORGAN_SLOT_HEART))
		if(feedback)
			patient.balloon_alert(user, "paint has no heart")
		return FALSE

/datum/surgery_step/extract_lux
	name = "Extract Lux"

	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_SHARP = 60,
		/obj/item/kitchen/spoon = 40,
	)

	time = 8 SECONDS

	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/extract_lux/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("I begin to scrape lux from [target]'s heart..."),
		span_notice("[user] begins to scrape lux from [target]'s heart."),
		span_notice("[user] begins to scrape lux from [target]'s heart."),
	)

	return SURGERY_STEP_CONTINUE

/datum/surgery_step/extract_lux/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	target.emote("painscream")

	if(target.get_lux_tainted_status() || target.has_status_effect(/datum/status_effect/debuff/tainted_lux) || target.has_status_effect(/datum/status_effect/debuff/received_tainted_lux))
		display_results(
			user,
			target,
			span_notice("You extract a single dose of tainted lux from [target]'s heart."),
			"[user] extracts tainted lux from [target]'s innards.",
			"[user] extracts something from [target]'s innards.",
		)
		new /obj/item/reagent_containers/lux_tainted(target.loc)
	else
		display_results(
			user,
			target,
			span_notice("You extract a single dose of lux from [target]'s heart."),
			"[user] extracts lux from [target]'s innards.",
			"[user] extracts something from [target]'s innards.",
		)
		new /obj/item/reagent_containers/lux(target.loc)

	if(target.has_status_effect(/datum/status_effect/debuff/received_tainted_lux))
		target.remove_status_effect(/datum/status_effect/debuff/received_tainted_lux)
	else if(target.has_status_effect(/datum/status_effect/buff/received_lux))
		target.remove_status_effect(/datum/status_effect/buff/received_lux)
	else
		target.apply_status_effect(/datum/status_effect/debuff/lux_drained)
		target.remove_status_effect(/datum/status_effect/debuff/tainted_lux)

	SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, target)

	record_featured_stat(FEATURED_STATS_CRIMINALS, user)
	record_round_statistic(STATS_LUX_HARVESTED)

	return TRUE
