/datum/surgery/relocate_bone
	name = "Bone relocation"
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
		/datum/surgery_step/relocate_bone,
		/datum/surgery_step/cauterize,
	)

/datum/surgery_step/relocate_bone
	name = "Relocate bones"
	minimum_time = 5 SECONDS
	maximum_time = 7 SECONDS
	accept_hand = TRUE
	implements = list(
		TOOL_BONESETTER = 90,
		TOOL_HAND = 50,
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	surgery_flags = SURGERY_DISLOCATED
	ignore_clothes = TRUE
	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_JOURNEYMAN

/datum/surgery_step/relocate_bone/validate_bodypart(mob/user, mob/living/carbon/target, obj/item/bodypart/bodypart, target_zone)
	. = ..()
	if(!.)
		return
	return bodypart.has_wound(/datum/wound/dislocation)

/datum/surgery_step/relocate_bone/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I begin to set the bone in [target]'s [parse_zone(target_zone)]...</span>",
		"<span class='notice'>[user] begins to relocate the bone in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] begins to relocate the bone in [target]'s [parse_zone(target_zone)].</span>")
	return TRUE

/datum/surgery_step/relocate_bone/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, "<span class='notice'>I successfully relocate the bone in [target]'s [parse_zone(target_zone)].</span>",
		"<span class='notice'>[user] successfully relocate the bone in [target]'s [parse_zone(target_zone)]!</span>",
		"<span class='notice'>[user] successfully relocate the bone in [target]'s [parse_zone(target_zone)]!</span>")
	var/obj/item/bodypart/bodypart = target.get_bodypart(check_zone(target_zone))
	if(bodypart)
		for(var/datum/wound/dislocation/bone in bodypart.wounds)
			bone.relocate_bone()
	return TRUE
