/datum/surgery/amputation
	name = "Amputation"

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/saw,
		/datum/surgery_step/amputate,
	)

	possible_locs = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)

	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN

/datum/surgery_step/amputate
	name = "Amputate"

	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_SAW = 60,
		TOOL_IMPROVISED_SAW = 50,
		TOOL_SHARP = 40,
	)

	time = 6.4 SECONDS

	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/amputate/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("I begin to sever [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to sever [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] begins to sever [target]'s [parse_zone(target_zone)]!"),
	)

/datum/surgery_step/amputate/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("I sever [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] severs [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] severs [target]'s [parse_zone(target_zone)]!"),
	)

	var/obj/item/bodypart/target_limb = target.get_bodypart(check_zone(target_zone))
	target_limb?.drop_limb()

	return TRUE
