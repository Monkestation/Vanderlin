/datum/surgery/fix_bone
	name = "Bone fixing"
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(
		BODY_ZONE_PRECISE_SKULL,
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_PRECISE_GROIN,
		BODY_ZONE_R_ARM,
		BODY_ZONE_PRECISE_R_HAND,
		BODY_ZONE_L_ARM,
		BODY_ZONE_PRECISE_L_HAND,
		BODY_ZONE_R_LEG,
		BODY_ZONE_PRECISE_R_FOOT,
		BODY_ZONE_L_LEG,
		BODY_ZONE_PRECISE_L_FOOT,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/set_bone,
		/datum/surgery_step/cauterize,
	)

/datum/surgery_step/set_bone
	name = "Set bones"
	time = 6.4 SECONDS
	accept_hand = TRUE
	implements = list(
		TOOL_BONESETTER = 80,
		TOOL_HAND = 40,
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	surgery_flags = SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_BROKEN
	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_EXPERT

/datum/surgery_step/set_bone/validate_bodypart(mob/user, mob/living/carbon/target, obj/item/bodypart/bodypart, target_zone)
	. = ..()
	if(!.)
		return
	var/can_set = FALSE
	for(var/datum/wound/fracture/bone in bodypart.wounds)
		can_set ||= bone.can_set
	if(!can_set)
		to_chat(user, span_warning("There are no more fractures to set in [target]'s [parse_zone(target_zone)]."))
	return can_set

/datum/surgery_step/set_bone/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I begin to set the bone in [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to set the bone in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to set the bone in [target]'s [parse_zone(target_zone)].</span>")
	return TRUE

/datum/surgery_step/set_bone/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I successfully set the bone in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] successfully sets the bone in [target]'s [parse_zone(target_zone)]!</span>",
		"<span class='notice'>[user] successfully sets the bone in [target]'s [parse_zone(target_zone)]!</span>")
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	if(bodypart)
		for(var/datum/wound/fracture/bone in bodypart.wounds)
			bone.set_bone()
	return TRUE
