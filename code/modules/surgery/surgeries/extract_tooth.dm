/datum/surgery_step/extract_tooth
	name = "Extract tooth"
	implements = list(
		/obj/item/weapon/tongs = 90,
	)
	minimum_time = 2.2 SECONDS
	maximum_time = 3.5 SECONDS
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED
	possible_locs = list(BODY_ZONE_PRECISE_MOUTH)
	requires_bodypart_type = BODYPART_ORGANIC
	skill_min = SKILL_LEVEL_EXPERT
	skill_median = SKILL_LEVEL_MASTER

/datum/surgery_step/extract_tooth/validate_bodypart(mob/user, mob/living/carbon/target, obj/item/bodypart/mouth/bodypart, target_zone)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(bodypart))
		return FALSE
	return bodypart.get_teeth_amount() > 0

/datum/surgery_step/extract_tooth/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target,
		span_danger("I start removing <b>[target]</b>'s tooth."),
		span_danger("<b>[user]</b> start removing <b>[target]</b>'s tooth."),
		span_warning("[user] looks for something in [target]'s [parse_zone(user.zone_selected)]."))
	return TRUE

/datum/surgery_step/extract_tooth/success(mob/user, mob/living/target, target_zone, obj/item/weapon/tongs/tool, datum/intent/intent)
	var/obj/item/bodypart/mouth/jaw = target.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(!jaw)
		return FALSE
	jaw.knock_out_teeth(1, pick(GLOB.alldirs))
	display_results(user, target,
		span_danger("I remove <b>[target]</b>'s tooth."),
		span_danger("<b>[user]</b> removes a tooth from <b>[target]</b>'s mouth."),
		span_danger("<b>[user]</b> removes a tooth from <b>[target]</b>'s mouth."),
		TRUE)
	return TRUE

/datum/surgery_step/extract_tooth/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target,
		span_warning("I screw up the operation inside <b>[target]</b>'s mouth!"),
		span_warning("<b>[user]</b> screws up the operation inside <b>[target]</b>'s mouth!"),
		span_warning("<b>[user]</b> screws up the operation inside <b>[target]</b>'s mouth!"),
		TRUE)
	return TRUE
