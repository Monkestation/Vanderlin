/datum/surgery/prosthetic_replacement
	name = "Limb replacement"
	surgery_flags = NONE

	steps = list(
		/datum/surgery_step/add_prosthetic,
	)

	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_HEAD,
	)

	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN

/datum/surgery_step/add_prosthetic
	name = "Implant limb"

	implements = list(
		/obj/item/bodypart = 80,
	)

	time = 3 SECONDS

	var/required_replacement = BODYPART_ORGANIC

/datum/surgery_step/add_prosthetic/tool_check(mob/user, obj/item/tool)
	if(tool.item_flags & (ABSTRACT | DROPDEL))
		return FALSE

	if(!isbodypart(tool))
		return

	var/obj/item/bodypart/part = tool

	return part.status == required_replacement

/datum/surgery_step/add_prosthetic/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/bodypart/tool, datum/intent/intent)
	if(tool.animal_origin)
		to_chat(user, span_warning("[tool] doesn't match the patient's morphology."))
		return SURGERY_STEP_FAIL

	if(target_zone != tool.body_zone) //so we can't replace a leg with an arm, or a human arm with a monkey arm.
		to_chat(user, span_warning("[tool] isn't the right type for [parse_zone(target_zone)]."))
		return SURGERY_STEP_FAIL

	display_results(
		user,
		target,
		span_notice("I begin to replace [target]'s [parse_zone(target_zone)] with [tool]..."),
		span_notice("[user] begins to replace [target]'s [parse_zone(target_zone)] with [tool]."),
		span_notice("[user] begins to replace [target]'s [parse_zone(target_zone)]."),
	)

/datum/surgery_step/add_prosthetic/success(mob/user, mob/living/target, target_zone, obj/item/bodypart/tool, datum/intent/intent)
	if(tool.attach_limb(target) && tool.attach_wound)
		tool.add_wound(tool.attach_wound)

	display_results(
		user,
		target,
		span_notice("I succeed transplanting [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] successfully transplants [target]'s [parse_zone(target_zone)] with [tool]!"),
		span_notice("[user] successfully transplants [target]'s [parse_zone(target_zone)]!"),
	)

	user.update_inv_hands() // attach_limb moves to nullspace

	return TRUE

/datum/surgery/prosthetic_replacement/prosthetic
	name = "Prosthetic replacement"
	surgery_flags = NONE

	steps = list(
		/datum/surgery_step/add_prosthetic/prosthetic,
	)

	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
	)

	skill_used = /datum/skill/craft/engineering

/datum/surgery_step/add_prosthetic/prosthetic
	name = "Implant prosthetic"

	time = 15 SECONDS

	required_replacement = BODYPART_ROBOTIC

/datum/surgery/prosthetic_removal
	name = "Prosthetic removal"
	surgery_flags = SURGERY_REQUIRE_LIMB
	requires_bodypart_type = BODYPART_ROBOTIC

	steps = list(
		/datum/surgery_step/remove_prosthetic,
	)

	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
		BODY_ZONE_HEAD,
	)

	skill_min = SKILL_LEVEL_NOVICE
	skill_median = SKILL_LEVEL_EXPERT

/datum/surgery_step/remove_prosthetic
	name = "Remove prosthetic"

	implements = list(
		TOOL_SAW = 90,
		TOOL_IMPROVISED_SAW = 60,
	)

	preop_sound = 'sound/foley/sewflesh.ogg'
	success_sound = 'sound/items/wood_sharpen.ogg'

/datum/surgery_step/remove_prosthetic/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_notice("I begin to saw through the base of [target]'s [parse_zone(target_zone)] prosthetic..."),
		span_notice("[user] begins to saw through the base of [target]'s prosthetic [parse_zone(target_zone)]."),
		span_notice("[user] begins to saw [target]'s prosthetic [parse_zone(target_zone)].")
	)

/datum/surgery_step/remove_prosthetic/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_notice("I saw through the base of [target]'s prosthetic [parse_zone(target_zone)]."),
		span_notice("[user] saws through the base of [target]'s prosthetic [parse_zone(target_zone)]!"),
		span_notice("[user] saws [target]'s prosthetic [parse_zone(target_zone)]!"),
	)

	var/obj/item/bodypart/target_limb = target.get_bodypart(check_zone(target_zone))
	if(target_limb)
		target_limb.drop_limb(TRUE)
		target_limb.set_brute_dam(target_limb.max_damage * 0.5)

	return TRUE
