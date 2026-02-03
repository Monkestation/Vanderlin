/datum/surgery/organ_manipulation
	name = "Organ manipulation"

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/saw,
		/datum/surgery_step/manipulate_organs,
		/datum/surgery_step/cauterize,
	)

	possible_locs = list(BODY_ZONE_PRECISE_SKULL, BODY_ZONE_CHEST)

	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_EXPERT

/datum/surgery/organ_manipulation/soft
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract,
		/datum/surgery_step/clamp,
		/datum/surgery_step/incise,
		/datum/surgery_step/manipulate_organs,
		/datum/surgery_step/cauterize
	)

	possible_locs = list(
		BODY_ZONE_PRECISE_R_EYE,
		BODY_ZONE_PRECISE_L_EYE,
		BODY_ZONE_PRECISE_MOUTH,
		BODY_ZONE_PRECISE_STOMACH,
		BODY_ZONE_PRECISE_GROIN,
	)

/datum/surgery_step/manipulate_organs
	name = "Manipulate organs"
	time = 6.4 SECONDS
	accept_hand = TRUE

	implements = list(
		/obj/item/organ = 80,
	)

	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

	/// Implements used to extract an organ - This really should be split into two different steps...
	var/list/implements_extract = list(
		TOOL_HEMOSTAT = 80,
		TOOL_IMPROVISED_HEMOSTAT = 70,
		TOOL_CROWBAR = 65,
		TOOL_HAND = 60,
	)

/datum/surgery_step/manipulate_organs/New()
	. = ..()
	implements = implements_extract + implements

/datum/surgery_step/manipulate_organs/initiate(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, try_to_fail)
	// stupid workaround right now because eyes are a single organ in a single slot
	if(target_zone == BODY_ZONE_PRECISE_L_EYE)
		target_zone = BODY_ZONE_PRECISE_R_EYE
	return ..()

/datum/surgery_step/manipulate_organs/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/organ/organ_tool = tool
	if(istype(organ_tool))
		if(target_zone != organ_tool.zone)
			to_chat(user, span_warning("[organ_tool] does not belong in [target]'s [parse_zone(target_zone)]!"))
			return FALSE
		else if(target.getorganslot(organ_tool.slot))
			to_chat(user, span_warning("[target] already has [parse_organ_slot(organ_tool.slot)]!"))
			return FALSE

		user.select_organ_slot(organ_tool.slot)

		display_results(
			user,
			target,
			span_notice("I begin to insert [tool] into [target]'s [parse_zone(target_zone)]..."),
			span_notice("[user] begins to insert [tool] into [target]'s [parse_zone(target_zone)]."),
			span_notice("[user] begins to insert something into [target]'s [parse_zone(target_zone)]."),
		)

		return TRUE

	var/list/organs = target.getorganszone(target_zone, subzones = FALSE)
	if(!length(organs))
		to_chat(user, span_warning("There are no removable organs in [target]'s [parse_zone(target_zone)]!"))
		return FALSE
	for(var/obj/item/organ/found_organ as anything in organs)
		found_organ.on_find(user)
		organs -= found_organ
		organs[found_organ.name] = found_organ

	var/selected = browser_input_list(user, "Remove which organ?", "PESTRA", sortList(organs))
	if(QDELETED(user) || QDELETED(target) || !user.Adjacent(target) || (user.get_active_held_item() != tool))
		return FALSE

	var/obj/item/organ/final_organ = organs[selected]
	if(QDELETED(final_organ))
		return FALSE

	user.select_organ_slot(final_organ.slot)

	display_results(
		user,
		target,
		span_notice("I begin to extract [final_organ] from [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to extract [final_organ] from [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to extract something from [target]'s [parse_zone(target_zone)].")
	)

	return TRUE

/datum/surgery_step/manipulate_organs/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/organ/organ_tool = tool
	if(istype(organ_tool) && user.temporarilyRemoveItemFromInventory(organ_tool))
		organ_tool.Insert(target)
		display_results(
			user,
			target,
			span_notice("I insert [tool] into [target]'s [parse_zone(target_zone)]."),
			span_notice("[user] inserts [tool] into [target]'s [parse_zone(target_zone)]!"),
			span_notice("[user] inserts something into [target]'s [parse_zone(target_zone)]!")
		)
		return TRUE

	var/obj/item/organ/selected_organ = target.getorganslot(user.organ_slot_selected)
	if(QDELETED(selected_organ) || (selected_organ.owner != target))
		display_results(
			user,
			target,
			span_warning("I can't extract anything from [target]'s [parse_zone(target_zone)]!"),
			span_notice("[user] can't seem to extract anything from [target]'s [parse_zone(target_zone)]!"),
			span_notice("[user] can't seem to extract anything from [target]'s [parse_zone(target_zone)]!")
		)

		return FALSE

	display_results(
		user,
		target,
		span_notice("I successfully extract [selected_organ] from [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] successfully extracts [selected_organ] from [target]'s [parse_zone(target_zone)]!"),
		span_notice("[user] successfully extracts something from [target]'s [parse_zone(target_zone)]!"),
	)

	log_combat(user, target, "surgically removed [selected_organ.name] from")
	selected_organ.Remove(target)
	selected_organ.forceMove(target.drop_location())
	user.put_in_hands(selected_organ)

	return TRUE
