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
	/*
	var/list/available_organs = target.get_organs_in_zone(target_zone)

	if(!available_organs.len)
		to_chat(user, span_warning("There are no organs in [target]'s [target_zone] to transform!"))
		return FALSE

	var/list/valid_organs = list()
	for(var/obj/item/organ/O in available_organs)
		if(!O.GetComponent(/datum/component/chimeric_organ))
			valid_organs += O

	if(!valid_organs.len)
		to_chat(user, span_warning("All organs in [target]'s [target_zone] have already been transformed!"))
		return FALSE

	if(valid_organs.len == 1)
		selected_organ = valid_organs[1]
	else
		var/list/organ_names = list()
		for(var/obj/item/organ/O in valid_organs)
			organ_names[O.name] = O

		var/choice = input(user, "Which organ do you want to transform?", "Select Organ") as null|anything in organ_names
		if(!choice)
			return FALSE
		selected_organ = organ_names[choice]
	*/

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

	to_chat(user, span_warning("[target]'s [selected_organ.name] can now accept grafted flesh nodes, but will require blood infusions to survive."))
	to_chat(target, span_userdanger("You feel something inside you change fundamentally. Your body now craves strange blood..."))

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
	if(blood_stab)
		var/datum/chimeric_node/test_node = node_to_graft.stored_node
		var/available_blood = chimeric.get_available_blood_for_node(blood_stab, test_node)

		if(available_blood < chimeric.node_injection_cost)
			display_results(
				user,
				target,
				span_warning("[target] lacks sufficient compatible blood essence! The grafting requires [chimeric.node_injection_cost] units."),
				span_warning("The grafting ritual falters as [user] works."),
				""
			)
			to_chat(user, span_notice("Available compatible blood: [available_blood] / [chimeric.node_injection_cost] required"))
			selected_organ = null
			return FALSE

	var/datum/chimeric_node/test_node = node_to_graft.stored_node
	var/node_slot = INPUT_NODE
	if(istype(test_node, /datum/chimeric_node/output))
		node_slot = OUTPUT_NODE

	var/datum/chimeric_node/new_node = node_to_graft.stored_node

	var/value = chimeric.handle_node_injection(
		tier = node_to_graft.node_tier,
		purity = node_to_graft.node_purity,
		slot = node_slot,
		injected_node = new_node
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

	var/total_cost = 0
	var/list/blood_costs_by_type = list()

	for(var/datum/chimeric_node/N as anything in (chimeric.inputs + chimeric.outputs))
		total_cost += N.base_blood_cost

		for(var/blood_type in N.preferred_blood_types)
			var/adjusted_cost = N.base_blood_cost * (1 - N.preferred_blood_bonus)
			if(!blood_costs_by_type[blood_type])
				blood_costs_by_type[blood_type] = 0
			blood_costs_by_type[blood_type] += adjusted_cost

		if(length(N.compatible_blood_types))
			for(var/blood_type in N.compatible_blood_types)
				if(blood_type in N.preferred_blood_types)
					continue
				if(!blood_costs_by_type[blood_type])
					blood_costs_by_type[blood_type] = 0
				blood_costs_by_type[blood_type] += N.base_blood_cost
		else
			if(blood_stab)
				for(var/blood_type in blood_stab.blood_stability)
					if(blood_type in N.incompatible_blood_types)
						continue
					if(blood_type in N.preferred_blood_types)
						continue
					if(!blood_costs_by_type[blood_type])
						blood_costs_by_type[blood_type] = 0
					blood_costs_by_type[blood_type] += N.base_blood_cost

		// Note incompatible blood types
		for(var/blood_type in N.incompatible_blood_types)
			var/adjusted_cost = N.base_blood_cost * (1 + N.incompatible_blood_penalty)
			if(!blood_costs_by_type["[blood_type] (HARMFUL)"])
				blood_costs_by_type["[blood_type] (HARMFUL)"] = 0
			blood_costs_by_type["[blood_type] (HARMFUL)"] += adjusted_cost

	to_chat(user, span_warning("[selected_organ.name] now requires approximately [round(total_cost, 0.1)] blood essence per second."))

	if(length(blood_costs_by_type))
		to_chat(user, span_notice("Blood types that can sustain this organ:"))
		for(var/datum/blood_type/blood_type as anything in blood_costs_by_type)
			to_chat(user, span_notice("  [initial(blood_type.name)] Blood: [round(blood_costs_by_type[blood_type], 0.1)] units/sec"))

	to_chat(target, span_userdanger("You feel alien flesh merging with your [selected_organ.name]!"))

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
	desc = "Try to repair a failed chimeric organ. Requires significant blood essence."
	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_SHARP = 60,
	)
	time = 15 SECONDS
	skill_min = SKILL_LEVEL_EXPERT
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED  | SURGERY_RETRACTED

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

	var/repair_cost = 50
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

	var/available_blood = chimeric.get_available_blood_for_organ(blood_stab)

	if(available_blood < repair_cost)
		display_results(
			user,
			target,
			span_warning("The repair fails! [target] lacks sufficient compatible blood essence for this organ."),
			span_warning("[user]'s ritual fails."),
			""
		)
		to_chat(user, span_notice("Available compatible blood: [available_blood] / [repair_cost] required"))
		selected_organ = null
		return FALSE

	chimeric.consume_any_blood(blood_stab, repair_cost)

	chimeric.failed = FALSE
	chimeric.start_processing()

	for(var/datum/chimeric_node/input/input_node as anything in chimeric.inputs)
		input_node.register_triggers(target)

	display_results(
		user,
		target,
		span_boldnotice("The repair succeeds! [selected_organ.name] pulses back to life, its corruption cleansed!"),
		span_boldnotice("[user] completes the repair ritual. The organ begins functioning again!"),
		""
	)

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
