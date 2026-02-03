/datum/surgery/augmentation
	name = "Augmentation"

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/saw,
		/datum/surgery_step/replace_limb,
	)

	skill_min = SKILL_LEVEL_JOURNEYMAN
	skill_median = SKILL_LEVEL_EXPERT

/datum/surgery_step/replace_limb
	name = "Replace limb"

	implements = list(
		/obj/item/bodypart = 80,
	)

	time = 3.2 SECONDS

/datum/surgery_step/replace_limb/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/bodypart/aug = tool
	if(!istype(aug) || aug.status != BODYPART_ROBOTIC)
		to_chat(user, span_warning("That's not an augment, silly!"))
		return SURGERY_STEP_FAIL

	if(aug.body_zone != target_zone)
		to_chat(user, span_warning("[tool] isn't the right type for [parse_zone(target_zone)]."))
		return SURGERY_STEP_FAIL

	var/obj/item/bodypart/existing = target.get_bodypart(check_zone(target_zone))
	if(!existing)
		user.visible_message(span_notice("[user] looks for [target]'s [parse_zone(user.zone_selected)]."),
							span_notice("I look for [target]'s [parse_zone(user.zone_selected)]..."))
		return SURGERY_STEP_FAIL

	display_results(
		user,
		target,
		span_notice("I begin to augment [target]'s [parse_zone(user.zone_selected)]..."),
		span_notice("[user] begins to augment [target]'s [parse_zone(user.zone_selected)] with [aug]."),
		span_notice("[user] begins to augment [target]'s [parse_zone(user.zone_selected)].")
	)

/datum/surgery_step/replace_limb/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/obj/item/bodypart/existing = target.get_bodypart(check_zone(target_zone))
	if(!existing)
		to_chat(user, span_warning("[target] has no organic [parse_zone(target_zone)] there!"))
		return TRUE

	var/obj/item/bodypart/bodypart = tool
	if(istype(bodypart) && user.temporarilyRemoveItemFromInventory(bodypart))
		if(bodypart.replace_limb(target, special = TRUE) && bodypart.attach_wound)
			bodypart.add_wound(bodypart.attach_wound)

	display_results(
		user,
		target,
		span_notice("I successfully augment [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] successfully augments [target]'s [parse_zone(target_zone)] with [bodypart]!"),
		span_notice("[user] successfully augments [target]'s [parse_zone(target_zone)]!"),
	)

	log_combat(user, target, "augmented", addition = "by giving him new [parse_zone(target_zone)])")

	return TRUE
