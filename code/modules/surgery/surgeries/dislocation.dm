/datum/surgery/relocate_bone
	name = "Bone relocation"
	surgery_flags = SURGERY_REQUIRE_LIMB | SURGERY_IGNORE_CLOTHES

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/relocate_bone,
		/datum/surgery_step/cauterize,
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
	skill_median = SKILL_LEVEL_JOURNEYMAN

	targetable_wound = /datum/wound/dislocation

/datum/surgery_step/relocate_bone
	name = "Relocate bones"

	accept_hand = TRUE
	implements = list(
		TOOL_BONESETTER = 90,
		TOOL_HAND = 50,
	)

	time = 6.4 SECONDS

/datum/surgery_step/relocate_bone/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("I begin to set the bone in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to relocate the bone in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to relocate the bone in [target]'s [parse_zone(target_zone)].")
	)

	return SURGERY_STEP_CONTINUE

/datum/surgery_step/relocate_bone/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("I successfully relocate the bone in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] successfully relocate the bone in [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] successfully relocate the bone in [target]'s [parse_zone(target_zone)]!"),
	)

	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	if(bodypart)
		for(var/datum/wound/dislocation/bone in bodypart.wounds)
			bone.relocate_bone()

	return TRUE
