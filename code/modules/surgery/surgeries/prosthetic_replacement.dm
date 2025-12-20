/datum/surgery/prosthetic_replacement
	name = "Limb replacement"
	steps = list(
		/datum/surgery_step/add_prosthetic,
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_HEAD,
	)
	requires_bodypart = FALSE //need a missing limb
	requires_missing_bodypart = TRUE
	requires_bodypart_type = NONE

/datum/surgery_step/add_prosthetic
	name = "Implant limb"
	implements = list(
		/obj/item/bodypart = 80,
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_HEAD,
	)
	time = 3 SECONDS
	requires_bodypart = FALSE //need a missing limb
	requires_missing_bodypart = TRUE
	requires_bodypart_type = NONE
	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN
	var/bodypart_status = BODYPART_ORGANIC

/datum/surgery_step/add_prosthetic/tool_check(mob/user, obj/item/tool)
	. = ..()
	var/obj/item/bodypart/bodypart = tool
	if(!istype(bodypart))
		return FALSE
	if(bodypart.status != bodypart_status)
		return FALSE

/datum/surgery_step/add_prosthetic/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/bodypart = tool
	if(ismonkey(target) && bodypart.animal_origin != MONKEY_BODYPART)
		to_chat(user, "<span class='warning'>[bodypart] doesn't match the patient's morphology.</span>")
		return FALSE
	else if(bodypart.animal_origin)
		to_chat(user, "<span class='warning'>[bodypart] doesn't match the patient's morphology.</span>")
		return FALSE

	if(target_zone != bodypart.body_zone) //so we can't replace a leg with an arm, or a human arm with a monkey arm.
		to_chat(user, "<span class='warning'>[tool] isn't the right type for [parse_zone(target_zone)].</span>")
		return FALSE

	display_results(user, target, "<span class='notice'>I begin to replace [target]'s [parse_zone(target_zone)] with [tool]...</span>",
		"<span class='notice'>[user] begins to replace [target]'s [parse_zone(target_zone)] with [tool].</span>",
		"<span class='notice'>[user] begins to replace [target]'s [parse_zone(target_zone)].</span>")
	return TRUE

/datum/surgery_step/add_prosthetic/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/bodypart = tool
	if(bodypart.attach_limb(target) && bodypart.attach_wound)
		bodypart.add_wound(bodypart.attach_wound)
	display_results(user, target, "<span class='notice'>I succeed transplanting [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] successfully transplants [target]'s [parse_zone(target_zone)] with [tool]!</span>",
		"<span class='notice'>[user] successfully transplants [target]'s [parse_zone(target_zone)]!</span>")
	user.update_inv_hands() // attach_limb moves to nullspace
	return TRUE

/datum/surgery/prosthetic_replacement/prosthetic
	name = "Prosthetic replacement"
	steps = list(
		/datum/surgery_step/add_prosthetic/prosthetic,
	)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
	)

/datum/surgery_step/add_prosthetic/prosthetic
	name = "Implant prosthetic"
	implements = list(
		/obj/item/bodypart = 80,
	)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
	)
	skill_used = /datum/skill/craft/engineering
	bodypart_status = BODYPART_ROBOTIC


/datum/surgery/prosthetic_removal
	name = "Prosthetic removal"
	steps = list(
		/datum/surgery_step/remove_prosthetic
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG
	)
	requires_bodypart = TRUE
	requires_bodypart_type = BODYPART_ROBOTIC

/datum/surgery_step/remove_prosthetic
	name = "Remove prosthetic"
	implements = list(
		TOOL_SAW = 90,
		TOOL_IMPROVISED_SAW = 60,
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)
	time = 15 SECONDS
	requires_bodypart = TRUE
	requires_bodypart_type = BODYPART_ROBOTIC
	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_EXPERT
	surgery_flags = NONE
	preop_sound = 'sound/foley/sewflesh.ogg'
	success_sound = 'sound/items/wood_sharpen.ogg'

/datum/surgery_step/remove_prosthetic/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I begin to saw through the base of [target]'s [parse_zone(target_zone)] prosthetic..."),
		span_notice("[user] begins to saw through the base of [target]'s prosthetic [parse_zone(target_zone)]."),
		span_notice("[user] begins to saw through the base of [target]'s prosthetic [parse_zone(target_zone)]."))
	return TRUE

/datum/surgery_step/remove_prosthetic/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I saw through the base of [target]'s prosthetic [parse_zone(target_zone)]."),
		span_notice("[user] saws through the base of [target]'s prosthetic [parse_zone(target_zone)]!"),
		span_notice("[user] saws through the base of [target]'s prosthetic [parse_zone(target_zone)]!"))
	var/obj/item/bodypart/target_limb = target.get_bodypart(check_zone(target_zone))
	target_limb?.drop_limb(TRUE)
	target_limb.brute_dam += target_limb.max_damage * 0.5 // doctors doing emergency removals damages the prosthetic
	return TRUE
