/datum/surgery/fix_bone
	name = "Bone fixing"
	surgery_flags = parent_type::surgery_flags | SURGERY_REQUIRES_REAL_LIMB

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/set_bone,
	)

	possible_locs = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)

	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_EXPERT

/datum/surgery_step/set_bone
	name = "Set bones"

	accept_hand = TRUE
	implements = list(
		TOOL_BONESETTER = 100,
		TOOL_HAND = 60,
	)

	time = 6.4 SECONDS

/datum/surgery_step/set_bone/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("I begin to set the bone in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to set the bone in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to set the bone in [target]'s [parse_zone(target_zone)]."),
	)

/datum/surgery_step/set_bone/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("I successfully set the bone in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] successfully sets the bone in [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] successfully sets the bone in [target]'s [parse_zone(target_zone)]!"),
	)

	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	if(bodypart)
		for(var/datum/wound/fracture/bone in bodypart.wounds)
			bone.set_bone()

	return TRUE
