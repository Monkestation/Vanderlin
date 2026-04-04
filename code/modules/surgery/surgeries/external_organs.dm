
/datum/surgery_step/remove_external_organs
	name = "Sever external organs"
	time = 5.0 SECONDS
	accept_hand = FALSE
	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_SAW = 60,
		TOOL_IMPROVISED_SAW = 50,
		TOOL_SHARP = 40,
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	surgery_flags = SURGERY_INCISED
	skill_min = SKILL_RANK_NOVICE
	skill_median = SKILL_RANK_JOURNEYMAN

/datum/surgery_step/remove_external_organs/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/list/initial_organs = target.getorganszone(target_zone, subzones = FALSE)
	var/list/organs = list()
	for(var/obj/item/organ/cur_organ as anything in initial_organs)
		if(cur_organ.visible_organ || cur_organ.slot == ORGAN_SLOT_TONGUE)
			organs += cur_organ

	if(!length(organs))
		to_chat(user, span_warning("There are no severable parts on [target]'s [parse_zone(target_zone)]!"))
		return FALSE
	for(var/obj/item/organ/found_organ as anything in organs)
		found_organ.on_find(user)
		organs -= found_organ
		organs[found_organ.name] = found_organ

	var/selected = input(user, "Sever which part?", "PESTRA") as null|anything in sortList(organs)
	if(QDELETED(user) || QDELETED(target) || !user.Adjacent(target) || (user.get_active_held_item() != tool))
		return FALSE
	var/obj/item/organ/final_organ = organs[selected]
	if(QDELETED(final_organ))
		return FALSE

	user.select_organ_slot(final_organ.slot)
	display_results(user, target, span_notice("I begin to sever [final_organ] from [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to sever [final_organ] from [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to sever something from [target]'s [parse_zone(target_zone)]."))

	return TRUE

/datum/surgery_step/remove_external_organs/try_op(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, try_to_fail)
	// stupid workaround right now because eyes are a single organ in a single slot
	if(target_zone == BODY_ZONE_PRECISE_L_EYE)
		target_zone = BODY_ZONE_PRECISE_R_EYE
	return ..()

/datum/surgery_step/remove_external_organs/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/organ/selected_organ = target.getorganslot(user.organ_slot_selected)
	if(QDELETED(selected_organ) || (selected_organ.owner != target))
		display_results(user, target, span_warning("I can't sever anything from [target]'s [parse_zone(target_zone)]!"),
			span_notice("[user] can't seem to sever anything from [target]'s [parse_zone(target_zone)]!"),
			span_notice("[user] can't seem to sever anything from [target]'s [parse_zone(target_zone)]!"))
		return FALSE

	display_results(user, target, span_notice("I successfully sever [selected_organ] from [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] successfully severs [selected_organ] from [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] successfully severs something from [target]'s [parse_zone(target_zone)]!"))
	log_combat(user, target, "surgically removed [selected_organ.name] from")

	selected_organ.Remove(target)
	selected_organ.forceMove(target.drop_location())
	user.put_in_hands(selected_organ)

	var/obj/item/bodypart/gotten_part = target.get_bodypart(check_zone(target_zone))
	if(gotten_part) //Vrell - This stuff is meant to be a jank/awful solution, so it leaves the target very wounded when you literally server a part of them via blade or saw
		gotten_part.add_wound(/datum/wound/artery)
		gotten_part.add_wound(/datum/wound/slash/large)

	return TRUE

/datum/surgery_step/remove_external_organs/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	var/obj/item/organ/selected_organ = target.getorganslot(user.organ_slot_selected)
	if(QDELETED(selected_organ) || (selected_organ.owner != target))
		display_results(user, target, span_warning("I can't sever anything from [target]'s [parse_zone(target_zone)]!"),
			span_notice("[user] can't seem to sever anything from [target]'s [parse_zone(target_zone)]!"),
			span_notice("[user] can't seem to sever anything from [target]'s [parse_zone(target_zone)]!"))
		return FALSE

	display_results(user, target, span_warning("I screwed up!"),
		span_warning("[user] screws up!"),
		span_notice("[user] screws up."), TRUE)

	var/obj/item/bodypart/gotten_part = target.get_bodypart(check_zone(target_zone))
	if(gotten_part) //Vrell - This stuff is meant to be a jank/awful solution, so it leaves the target very wounded when you literally server a part of them via blade or saw
		gotten_part.add_wound(/datum/wound/slash/large)

	return TRUE
