/// CPR
// Mouth to Mouth to fix oxygen loss.
// Target mouth on a person on the floor with help intent. If they are passed out from oxy-damage, you will start breathing air into their lungs.

/datum/surgery_step/mouth_to_mouth
	name = "Mouth to Mouth"

	possible_locs = list(BODY_ZONE_HEAD)
	time = 4 SECONDS
	accept_hand = TRUE
	accept_any_item = TRUE
	possible_intents = list(
		INTENT_HELP
	)
	possible_locs = list(
		BODY_ZONE_PRECISE_MOUTH
	)
	lying_required = TRUE
	self_operable = FALSE
	skill_min = SKILL_RANK_NONE
	skill_median = SKILL_RANK_NOVICE
	surgery_flags = NONE
	repeating = TRUE

	// How much oxy damage we heal per completion
	var/oxyhealing = 10

/datum/surgery_step/mouth_to_mouth/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(!.)
		return
	if(!((oxyhealing && target.getOxyLoss())))
		return FALSE


/datum/surgery_step/mouth_to_mouth/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I attempt to breath air into [target]'s mouth."),
			span_notice("[user] attempts to breath air into [target]'s mouth."),
			span_notice("[user] attempts to breath air into [target]'s mouth."))
	return TRUE

/datum/surgery_step/mouth_to_mouth/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("You successfully filled [target]'s lungs with a breath of air."),
		"[user] gave [target] a breath of air.",
		"[user] gave [target] a breath of air.")
	target.adjustOxyLoss(-oxyhealing)
	return TRUE

/datum/surgery_step/mouth_to_mouth/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, span_warning("I failed!"),
		span_warning("[user] failed!"),
		span_notice("[user] failed to get air into [target]'s lungs."), TRUE)
	return TRUE
