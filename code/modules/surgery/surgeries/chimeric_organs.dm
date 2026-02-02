/mob/living/carbon/proc/get_organs_in_zone(zone)
	var/list/organs_in_zone = list()

	for(var/obj/item/organ/O in internal_organs)
		if(O.zone == zone)
			organs_in_zone += O

	return organs_in_zone

/datum/surgery/chimeric_transformation
	name = "Chimeric Transformation"
	desc = "Transform a normal organ into a chimeric organ capable of accepting grafted nodes."
	category = "Pestran"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract,
		/datum/surgery_step/create_chimeric_organ,
		/datum/surgery_step/cauterize
	)
	heretical = TRUE
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD)
	target_mobtypes = list(/mob/living/carbon/human)
	requires_bodypart_type = BODYPART_ORGANIC

/datum/surgery/chimeric_grafting
	name = "Humor Grafting"
	desc = "Graft a harvested humor into a chimeric organ."
	category = "Pestran"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract,
		/datum/surgery_step/graft_chimeric_node,
		/datum/surgery_step/cauterize
	)
	heretical = TRUE
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD)
	target_mobtypes = list(/mob/living/carbon/human)
	requires_bodypart_type = BODYPART_ORGANIC

/datum/surgery/chimeric_repair
	name = "Chimeric Organ Repair"
	desc = "Attempt to repair a failed chimeric organ."
	category = "Pestran"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract,
		/datum/surgery_step/repair_chimeric_organ,
		/datum/surgery_step/cauterize
	)
	heretical = TRUE
	possible_locs = list(BODY_ZONE_CHEST, BODY_ZONE_HEAD)
	target_mobtypes = list(/mob/living/carbon/human)
	requires_bodypart_type = BODYPART_ORGANIC



/datum/surgery_step/create_chimeric_organ
	name = "perform chimeric ritual"
	desc = "Transform a normal organ into a chimeric organ capable of accepting grafted nodes."
	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_SHARP = 60,
	)
	time = 10 SECONDS
	skill_min = SKILL_LEVEL_JOURNEYMAN
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_RETRACTED

	var/obj/item/organ/selected_organ

/datum/surgery_step/create_chimeric_organ/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/intent/intent)
	selected_organ = target.getorganslot(ORGAN_SLOT_HEART)
	if(!selected_organ)
		return FALSE

	display_results(
		user,
		target,
		span_notice("I begin carving dark runes into [target]'s [selected_organ.name], preparing it for transformation..."),
		span_notice("[user] begins carving strange patterns into [target]'s exposed organ."),
		span_notice("[user] mutters dark incantations while working on [target].")
	)
	return TRUE

/datum/surgery_step/create_chimeric_organ/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/intent/intent)
	if(!selected_organ)
		return FALSE
	selected_organ.AddComponent(/datum/component/chimeric_organ)

	if(!target.GetComponent(/datum/component/blood_stability))
		target.AddComponent(/datum/component/blood_stability)
		to_chat(user, span_boldnotice("As the ritual completes, [target]'s body adapts to accept infused blood essence."))

	display_results(
		user,
		target,
		span_notice("The ritual completes! [target]'s [selected_organ.name] pulses with unnatural life as it transforms."),
		span_notice("[user] completes the dark ritual. The organ writhes and changes."),
		span_notice("[user] steps back from [target], the ritual complete.")
	)

	to_chat(user, span_warning("[target]'s [selected_organ.name] can now accept grafted flesh nodes. Each node will require stored blood essence based on its tier and purity."))
	to_chat(target, span_userdanger("You feel something inside you change fundamentally. Your body now stores the essence of blood..."))

	selected_organ = null
	return TRUE

/datum/surgery_step/create_chimeric_organ/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(
		user,
		target,
		span_warning("The ritual fails! The organ rejects the transformation!"),
		span_warning("[user]'s ritual fails spectacularly!"),
		""
	)

	target.adjustToxLoss(5)
	return TRUE


/datum/surgery_step/graft_chimeric_node
	name = "graft humor"
	desc = "Graft a harvested humor into a chimeric organ."
	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_SHARP = 60,
	)
	time = 8 SECONDS
	skill_min = SKILL_LEVEL_JOURNEYMAN
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_RETRACTED

	var/obj/item/organ/selected_organ
	var/obj/item/chimeric_node/node_to_graft

/datum/surgery_step/graft_chimeric_node/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/intent/intent)
	var/obj/item/held = user.get_inactive_held_item()
	if(!istype(held, /obj/item/chimeric_node))
		to_chat(user, span_warning("You need to hold a humor in your other hand to graft it!"))
		return FALSE

	var/list/available_organs = target.get_organs_in_zone(target_zone)
	var/list/chimeric_organs = list()

	for(var/obj/item/organ/O in available_organs)
		var/datum/component/chimeric_organ/chimeric = O.GetComponent(/datum/component/chimeric_organ)
		if(chimeric && !chimeric.failed)
			chimeric_organs += O

	if(!chimeric_organs.len)
		to_chat(user, span_warning("There are no functioning chimeric organs in [target]'s [target_zone]!"))
		return FALSE

	if(chimeric_organs.len == 1)
		selected_organ = chimeric_organs[1]
	else
		var/list/organ_names = list()
		for(var/obj/item/organ/O in chimeric_organs)
			organ_names[O.name] = O

		var/choice = input(user, "Which organ do you want to graft into?", "Select Organ") as null|anything in organ_names
		if(!choice)
			return FALSE
		selected_organ = organ_names[choice]

	node_to_graft = held
	if(!selected_organ)
		return FALSE

	display_results(
		user,
		target,
		span_notice("I begin the delicate process of grafting [node_to_graft] into [target]'s [selected_organ.name]..."),
		span_notice("[user] begins grafting something grotesque into [target]'s organ."),
		span_notice("[user] performs an unholy grafting ritual on [target].")
	)
	return TRUE

/datum/surgery_step/graft_chimeric_node/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/intent/intent)
	if(!selected_organ)
		return FALSE

	var/datum/component/chimeric_organ/chimeric = selected_organ.GetComponent(/datum/component/chimeric_organ)
	if(!chimeric)
		return FALSE

	if(chimeric.failed)
		display_results(
			user,
			target,
			span_warning("[selected_organ.name] has failed and is too corrupted to accept more nodes!"),
			span_warning("[user] recoils from the decayed organ."),
			""
		)
		selected_organ = null
		return FALSE

	if(!node_to_graft)
		selected_organ = null
		return FALSE

	var/datum/component/blood_stability/blood_stab = target.GetComponent(/datum/component/blood_stability)
	if(!blood_stab)
		display_results(
			user,
			target,
			span_warning("[target] lacks a blood stability system!"),
			span_warning("The grafting fails."),
			""
		)
		selected_organ = null
		return FALSE

	var/datum/chimeric_node/test_node = node_to_graft.stored_node
	var/node_slot = INPUT_NODE
	if(istype(test_node, /datum/chimeric_node/output))
		node_slot = OUTPUT_NODE

	// Calculate what the blood requirement will be
	var/final_tier = node_to_graft.node_tier + chimeric.tier_modifier
	var/final_purity = min(node_to_graft.node_purity + chimeric.purity_modifier, 100)
	var/blood_cost = chimeric.calculate_node_blood_cost(final_tier, final_purity)

	var/list/required_blood_types = list()
	if(length(test_node.preferred_blood_types))
		required_blood_types = test_node.preferred_blood_types.Copy()
	else if(length(test_node.compatible_blood_types))
		required_blood_types = test_node.compatible_blood_types.Copy()
	else
		for(var/blood_type in blood_stab.blood_storage)
			if(blood_type in test_node.incompatible_blood_types)
				continue
			required_blood_types += blood_type
			break

	if(!length(required_blood_types))
		display_results(
			user,
			target,
			span_warning("This node cannot find any compatible blood type in [target]!"),
			span_warning("The grafting fails."),
			""
		)
		selected_organ = null
		return FALSE

	to_chat(user, span_notice("This node will require [round(blood_cost, 0.1)] units of compatible blood to be stored."))
	to_chat(user, span_notice("Compatible blood types: [english_list(required_blood_types)]"))

	var/datum/chimeric_node/new_node = node_to_graft.stored_node

	var/value = chimeric.handle_node_injection(
		tier = node_to_graft.node_tier,
		purity = node_to_graft.node_purity,
		slot = node_slot,
		injected_node = new_node,
		overlay_state = node_to_graft.icon_state
	)

	if(!value)
		display_results(
			user,
			target,
			span_warning("[selected_organ.name] has failed!"),
			span_warning("[user] recoils."),
			""
		)
		return FALSE
	node_to_graft.stored_node = null
	qdel(node_to_graft)
	node_to_graft = null

	display_results(
		user,
		target,
		span_notice("The grafting succeeds! The node melds seamlessly with [selected_organ.name], pulsing with unnatural life."),
		span_notice("[user] completes the grafting ritual. The flesh writhes and accepts the graft."),
		span_notice("[user] finishes working on [target].")
	)

	to_chat(user, span_warning("Current blood requirements for [selected_organ.name]:"))
	for(var/blood_type in chimeric.blood_requirements)
		var/required_amount = chimeric.blood_requirements[blood_type]
		var/stored_amount = blood_stab.get_blood_amount(blood_type)
		var/status = stored_amount >= required_amount ? "✓" : "✗"
		to_chat(user, span_notice("  [status] [blood_type]: [stored_amount] / [required_amount] required"))

	if(!chimeric.check_blood_requirements(blood_stab))
		to_chat(user, span_boldwarning("[target] needs more blood infusions for this organ to function!"))
		to_chat(target, span_userdanger("You feel your [selected_organ.name] struggling - it needs more blood essence!"))
	else
		to_chat(target, span_notice("You feel alien flesh merging with your [selected_organ.name]!"))

	selected_organ = null
	return TRUE

/datum/surgery_step/graft_chimeric_node/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(
		user,
		target,
		span_warning("The grafting fails! The node rejects the organ!"),
		span_warning("[user]'s grafting fails!"),
		""
	)

	target.adjustToxLoss(10)
	return TRUE


/datum/surgery_step/repair_chimeric_organ
	name = "attempt organ repair"
	desc = "Try to repair a failed chimeric organ. Does not restore blood requirements."
	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_SHARP = 60,
	)
	time = 15 SECONDS
	skill_min = SKILL_LEVEL_EXPERT
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_RETRACTED

	var/obj/item/organ/selected_organ

/datum/surgery_step/repair_chimeric_organ/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/intent/intent)
	var/list/available_organs = target.get_organs_in_zone(target_zone)
	var/list/failed_organs = list()

	for(var/obj/item/organ/O in available_organs)
		var/datum/component/chimeric_organ/chimeric = O.GetComponent(/datum/component/chimeric_organ)
		if(chimeric && chimeric.failed)
			failed_organs += O

	if(!failed_organs.len)
		to_chat(user, span_warning("There are no failed chimeric organs in [target]'s [target_zone]!"))
		return FALSE

	if(length(failed_organs) == 1)
		selected_organ = failed_organs[1]
	else
		var/list/organ_names = list()
		for(var/obj/item/organ/O in failed_organs)
			organ_names[O.name] = O

		var/choice = input(user, "Which organ do you want to repair?", "Select Organ") as null|anything in organ_names
		if(!choice)
			return FALSE
		selected_organ = organ_names[choice]

	if(!selected_organ)
		return FALSE

	display_results(
		user,
		target,
		span_notice("I begin the complex ritual to repair [target]'s failed [selected_organ.name]..."),
		span_notice("[user] begins an elaborate ritual over [target]'s corrupted organ."),
		""
	)
	return TRUE

/datum/surgery_step/repair_chimeric_organ/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/intent/intent)
	if(!selected_organ)
		return FALSE

	var/datum/component/chimeric_organ/chimeric = selected_organ.GetComponent(/datum/component/chimeric_organ)
	if(!chimeric)
		return FALSE

	var/datum/component/blood_stability/blood_stab = target.GetComponent(/datum/component/blood_stability)

	if(!blood_stab)
		display_results(
			user,
			target,
			span_warning("The repair fails! [target] lacks a blood stability system."),
			span_warning("[user]'s ritual fails."),
			""
		)
		selected_organ = null
		return FALSE

	// Reset the organ
	chimeric.failed = FALSE
	chimeric.failed_precent = 0
	chimeric.start_processing()

	for(var/datum/chimeric_node/input/input_node as anything in chimeric.inputs)
		input_node.register_triggers(target)

	display_results(
		user,
		target,
		span_boldnotice("The repair succeeds! [selected_organ.name] pulses back to life!"),
		span_boldnotice("[user] completes the repair ritual. The organ begins functioning again!"),
		""
	)

	// Display blood requirements status
	to_chat(user, span_warning("Blood requirements for [selected_organ.name]:"))
	var/all_met = TRUE
	for(var/blood_type in chimeric.blood_requirements)
		var/required_amount = chimeric.blood_requirements[blood_type]
		var/stored_amount = blood_stab.get_blood_amount(blood_type)
		var/status = stored_amount >= required_amount ? "✓" : "✗"
		to_chat(user, span_notice("  [status] [blood_type]: [stored_amount] / [required_amount] required"))
		if(stored_amount < required_amount)
			all_met = FALSE

	if(!all_met)
		to_chat(user, span_boldwarning("WARNING: [target] still needs more blood infusions for stable function!"))
		to_chat(target, span_warning("Your [selected_organ.name] is repaired, but still craves more blood essence..."))
	else
		to_chat(target, span_notice("You feel your [selected_organ.name] stabilize and resume functioning!"))

	selected_organ = null
	return TRUE

/datum/surgery_step/repair_chimeric_organ/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(
		user,
		target,
		span_boldwarning("The repair fails catastrophically! The organ is beyond saving!"),
		span_warning("[user]'s ritual backfires!"),
		""
	)

	target.adjustToxLoss(15)
	to_chat(user, span_boldwarning("The organ cannot be repaired. Consider replacement."))

	selected_organ = null
	return TRUE
