
/datum/surgery/remove_external_organs
	name = "Sever External Organs"
	surgery_flags = SURGERY_REQUIRES_REAL_LIMB | SURGERY_REQUIRE_LIMB

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/sever_external,
	)

	possible_locs = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)

	skill_min = SKILL_LEVEL_NONE
	skill_median = SKILL_LEVEL_NOVICE

/datum/surgery/remove_external_organs/can_start(mob/user, mob/living/patient, obj/item/tool, feedback)
	. = ..()
	if(!.)
		return

	var/list/organs = list()
	for(var/obj/item/organ/cur_organ as anything in patient.getorganszone(user.zone_selected, subzones = TRUE))
		if(cur_organ.visible_organ || cur_organ.slot == ORGAN_SLOT_TONGUE)
			organs += cur_organ

	if(!length(organs))
		return FALSE

/datum/surgery_step/sever_external
	name = "Sever External Organ"

	implements = list(
		TOOL_SCALPEL = 100,
		TOOL_SAW = 75,
		TOOL_IMPROVISED_SAW = 60,
		/obj/item = 40,
	)

	time = 5 SECONDS

	var/obj/item/organ/selected_organ

/datum/surgery_step/sever_external/Destroy()
	selected_organ = null
	return ..()

/datum/surgery_step/sever_external/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE
	return TRUE

/datum/surgery_step/sever_external/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/list/organs = list()
	for(var/obj/item/organ/cur_organ as anything in target.getorganszone(user.zone_selected, subzones = TRUE))
		if(cur_organ.visible_organ || cur_organ.slot == ORGAN_SLOT_TONGUE)
			organs += cur_organ

	if(!length(organs))
		return SURGERY_STEP_FAIL

	selected_organ = browser_input_list(user, "Which organ?", "PESTRA", organs)
	if(!selected_organ || QDELETED(user) || QDELETED(target) || !user.Adjacent(target) || (user.get_active_held_item() != tool))
		return SURGERY_STEP_FAIL

	display_results(
		user,
		target,
		span_notice("I begin to sever [selected_organ] from [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to sever [selected_organ] from [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to sever something from [selected_organ]'s [parse_zone(target_zone)]."),
	)

/datum/surgery_step/sever_external/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if(QDELETED(selected_organ) || !selected_organ.owner != target)
		display_results(
			user,
			target,
			span_warning("I can't sever anything from [target]'s [parse_zone(target_zone)]!"),
			span_notice("[user] can't seem to sever anything from [target]'s [parse_zone(target_zone)]!"),
			span_notice("[user] can't seem to sever anything from [target]'s [parse_zone(target_zone)]!"),
		)
		return ..()

	display_results(
		user,
		target,
		span_warning("I sever [selected_organ] from [target]'s [parse_zone(target_zone)]!"),
		span_warning("[user] servers [selected_organ] from [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] severs something from [target]!"),
		TRUE
	)

	log_combat(user, target, "surgically removed [selected_organ.name] from")
	selected_organ.Remove(target)
	selected_organ.forceMove(target.drop_location())
	user.put_in_hands(selected_organ)

	var/obj/item/bodypart/gotten_part = target.get_bodypart(check_zone(target_zone))
	if(gotten_part)
		gotten_part.receive_damage(20)
		gotten_part.add_wound(/datum/wound/slash/large)

	return ..()

/datum/surgery_step/sever_external/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob)
	if(QDELETED(selected_organ) || !selected_organ.owner != target)
		display_results(
			user,
			target,
			span_warning("I can't sever anything from [target]'s [parse_zone(target_zone)]!"),
			span_notice("[user] can't seem to sever anything from [target]'s [parse_zone(target_zone)]!"),
			span_notice("[user] can't seem to sever anything from [target]'s [parse_zone(target_zone)]!"),
		)
		return ..()

	display_results(
		user,
		target,
		span_warning("I sever [selected_organ] from [target]... along with a chunk of [parse_zone(target_zone)]!"),
		span_warning("[user] servers [selected_organ] and a chunk of [parse_zone(target_zone)] from [target]!"),
		span_notice("[user] severs something from [target] but screws up!"),
		TRUE
	)

	log_combat(user, target, "surgically removed [selected_organ.name] from")
	selected_organ.Remove(target)
	selected_organ.forceMove(target.drop_location())
	user.put_in_hands(selected_organ)

	var/obj/item/bodypart/gotten_part = target.get_bodypart(check_zone(target_zone))
	if(gotten_part)
		gotten_part.receive_damage(40)
		gotten_part.add_wound(/datum/wound/artery)
		gotten_part.add_wound(/datum/wound/slash/large)

	return ..()
