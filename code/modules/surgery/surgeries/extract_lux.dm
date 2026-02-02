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
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/extract_lux
	name = "Extract Lux"
	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_SHARP = 60,
		/obj/item/kitchen/spoon = 40
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	time = 8 SECONDS
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED | SURGERY_BROKEN
	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/extract_lux/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(target.stat == DEAD)
		to_chat(user, "They're dead!")
		return FALSE
	var/lux_state = target.get_lux_status()
	if(lux_state != LUX_HAS_LUX)
		to_chat(user, "They do not have any lux to extract!")
		return FALSE

/datum/surgery_step/extract_lux/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I begin to scrape lux from [target]'s heart..."),
		span_notice("[user] begins to scrape lux from [target]'s heart."),
		span_notice("[user] begins to scrape lux from [target]'s heart."))
	return TRUE

/datum/surgery_step/extract_lux/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	target.emote("painscream")
	if(target.has_status_effect(/datum/status_effect/debuff/lux_drained))
		display_results(user, target, span_notice("You cannot draw lux from [target]; they have none left to give."),
		"[user] extracts lux from [target]'s innards.",
		"[user] extracts lux from [target]'s innards.")
		return FALSE
	else
		if(target.get_lux_tainted_status() || target.has_status_effect(/datum/status_effect/debuff/tainted_lux) || target.has_status_effect(/datum/status_effect/debuff/received_tainted_lux))
			display_results(user, target, span_notice("You extract a single dose of tainted lux from [target]'s heart."),
				"[user] extracts tainted lux from [target]'s innards.",
				"[user] extracts tainted lux from [target]'s innards.")
			new /obj/item/reagent_containers/lux_tainted(target.loc)
		else
			display_results(user, target, span_notice("You extract a single dose of lux from [target]'s heart."),
				"[user] extracts lux from [target]'s innards.",
				"[user] extracts lux from [target]'s innards.")
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
