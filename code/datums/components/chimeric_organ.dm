
/datum/component/chimeric_organ
	///list of attached nodes to the organ split into their node types
	var/list/inputs = list()
	var/list/outputs = list()
	var/list/special_nodes = list()

	var/list/attachment_less_special_inputs = list()
	var/list/attachment_less_special_outputs = list()

	var/list/partnerless_inputs = list()
	var/list/partnerless_outputs = list()

	var/list/overlay_states = list()

	///the carbon this organ is owned and inside of
	var/mob/living/carbon/organ_owner

	///the maximum tier difference between inputs and outputs
	var/maximum_tier_difference = 1
	///how many tiers should it increase when a new node is added
	var/tier_modifier = 0
	///how much purity should be modified when a new node is added
	var/purity_modifier = 0
	///stability cost when adding new nodes
	var/node_injection_cost = 10

	///is the organ currently processing
	var/processing = FALSE
	///is the organ currently failed
	var/failed = FALSE
	///this is our failed %
	var/failed_precent = 0
	COOLDOWN_DECLARE(last_fail_message)

/datum/component/chimeric_organ/Initialize(maximum_tier_difference = 1)
	. = ..()
	if(!istype(parent, /obj/item/organ))
		return COMPONENT_INCOMPATIBLE

	src.maximum_tier_difference = maximum_tier_difference

	RegisterSignal(parent, COMSIG_ORGAN_INSERTED, PROC_REF(on_inserted))
	RegisterSignal(parent, COMSIG_ORGAN_REMOVED, PROC_REF(on_removed))

	var/obj/item/organ/O = parent
	if(O.owner)
		on_inserted(null, O.owner)

/datum/component/chimeric_organ/Destroy()
	stop_processing()
	cleanup_nodes()
	organ_owner = null
	. = ..()

/datum/component/chimeric_organ/proc/cleanup_nodes()
	QDEL_LIST(inputs)
	QDEL_LIST(outputs)
	QDEL_LIST(special_nodes)
	QDEL_LIST(partnerless_inputs)
	QDEL_LIST(partnerless_outputs)
	QDEL_LIST(attachment_less_special_inputs)
	QDEL_LIST(attachment_less_special_outputs)

/datum/component/chimeric_organ/proc/on_inserted(datum/source, mob/living/carbon/organ_receiver)
	SIGNAL_HANDLER

	organ_owner = organ_receiver

	RegisterSignal(organ_owner, COMSIG_DEVOUR_OVERDRIVE, PROC_REF(force_trigger))
	if(!organ_owner.GetComponent(/datum/component/blood_stability))
		organ_owner.AddComponent(/datum/component/blood_stability)

	for(var/datum/chimeric_node/output/listed_output as anything in outputs)
		listed_output.hosted_carbon = organ_owner
		listed_output.register_listeners(organ_owner)
		listed_output.final_setup()

	for(var/datum/chimeric_node/input/listed_input as anything in inputs)
		listed_input.hosted_carbon = organ_owner
		listed_input.register_triggers(organ_owner)
		listed_input.final_setup()

	for(var/datum/chimeric_node/special/listed_special as anything in special_nodes)
		listed_special.hosted_carbon = organ_owner
		listed_special.final_setup()

	start_processing()

/datum/component/chimeric_organ/proc/on_removed(datum/source, mob/living/carbon/organ_receiver)
	SIGNAL_HANDLER

	stop_processing()
	UnregisterSignal(organ_owner, COMSIG_DEVOUR_OVERDRIVE)

	for(var/datum/chimeric_node/input/listed_input as anything in inputs)
		listed_input.unregister_triggers()
		listed_input.removal_setup()
	for(var/datum/chimeric_node/output/listed_output as anything in outputs)
		listed_output.unregister_listeners(organ_owner)
		listed_output.removal_setup()
	for(var/datum/chimeric_node/special/listed_special as anything in special_nodes)
		listed_special.removal_setup()

	organ_owner = null

/datum/component/chimeric_organ/proc/start_processing()
	if(processing)
		return
	processing = TRUE
	START_PROCESSING(SSobj, src)

/datum/component/chimeric_organ/proc/stop_processing()
	if(!processing)
		return
	processing = FALSE
	STOP_PROCESSING(SSobj, src)

/datum/component/chimeric_organ/process()
	if(!organ_owner || failed)
		return

	var/datum/component/blood_stability/blood_stab = organ_owner.GetComponent(/datum/component/blood_stability)
	if(!blood_stab)
		trigger_organ_failure("no blood stability component", 100)
		return

	for(var/datum/chimeric_node/input/input_node as anything in inputs)
		if(!input_node.try_consume_blood(blood_stab, 1))
			trigger_organ_failure("lacks suitable thaumiel blood", 2)
			return

	for(var/datum/chimeric_node/output/output_node as anything in outputs)
		if(!output_node.try_consume_blood(blood_stab, 1))
			trigger_organ_failure("lacks suitable thaumiel blood", 2)
			return
	failed_precent = max(failed_precent - 1, 0)

/datum/component/chimeric_organ/proc/force_trigger()
	var/datum/component/blood_stability/blood_stab = organ_owner.GetComponent(/datum/component/blood_stability)
	if(!blood_stab)
		trigger_organ_failure("no blood stability component", 100)
		return

	for(var/datum/chimeric_node/input/input_node as anything in inputs)
		if(!input_node.try_consume_blood(blood_stab, 1))
			trigger_organ_failure("lacks suitable thaumiel blood", 2)
			return
		input_node.trigger_output(1)

	for(var/datum/chimeric_node/output/output_node as anything in outputs)
		if(!output_node.try_consume_blood(blood_stab, 1))
			trigger_organ_failure("lacks suitable thaumiel blood", 2)
			return

/datum/component/chimeric_organ/proc/get_available_blood_for_node(datum/component/blood_stability/blood_stab, datum/chimeric_node/node)
	var/available_blood = 0

	for(var/blood_type in node.preferred_blood_types)
		if(blood_stab.blood_stability[blood_type])
			available_blood += blood_stab.blood_stability[blood_type]

	if(length(node.compatible_blood_types))
		for(var/blood_type in node.compatible_blood_types)
			if(blood_stab.blood_stability[blood_type])
				available_blood += blood_stab.blood_stability[blood_type]
	else
		for(var/blood_type in blood_stab.blood_stability)
			if(blood_type in node.incompatible_blood_types)
				continue
			available_blood += blood_stab.blood_stability[blood_type]

	return available_blood

/datum/component/chimeric_organ/proc/get_available_blood_for_organ(datum/component/blood_stability/blood_stab)
	var/available_blood = 0
	var/list/usable_blood_types = list()

	for(var/datum/chimeric_node/node as anything in (inputs + outputs))
		for(var/blood_type in node.preferred_blood_types)
			usable_blood_types[blood_type] = TRUE

		if(length(node.compatible_blood_types))
			for(var/blood_type in node.compatible_blood_types)
				usable_blood_types[blood_type] = TRUE
		else
			for(var/blood_type in blood_stab.blood_stability)
				if(blood_type in node.incompatible_blood_types)
					continue
				usable_blood_types[blood_type] = TRUE

	for(var/blood_type in usable_blood_types)
		if(blood_stab.blood_stability[blood_type])
			available_blood += blood_stab.blood_stability[blood_type]

	return available_blood

/datum/component/chimeric_organ/proc/trigger_organ_failure(reason, amount)
	if(failed)
		return
	failed_precent += amount
	if(failed_precent < 100)
		if(COOLDOWN_FINISHED(src, last_fail_message))
			to_chat(organ_owner, span_danger("Your [parent] is starting to fail because it [reason]!"))
			organ_owner.emote("painscream")
			COOLDOWN_START(src, last_fail_message, 30 SECONDS)
		organ_owner.adjustToxLoss(5)
		return

	failed = TRUE

	if(!organ_owner)
		return

	for(var/datum/chimeric_node/input/listed_input as anything in inputs)
		listed_input.unregister_triggers()

	SEND_SIGNAL(parent, COMSIG_CHIMERIC_ORGAN_FAILURE)
	to_chat(organ_owner, span_danger("Your [parent] fails catastrophically!"))
	organ_owner.adjustToxLoss(20)

	stop_processing()

/datum/component/chimeric_organ/proc/handle_node_injection(tier, purity, slot, datum/chimeric_node/injected_node, overlay_state)
	SIGNAL_HANDLER

	if(failed)
		return

	if(!check_node_compatibility(injected_node))
		trigger_failure(injected_node, FALSE, "incompatible organ slot")
		if(organ_owner)
			to_chat(organ_owner, span_warning("The node rejects the [parent] - it's incompatible with this organ type!"))
		return

	var/mutable_appearance/node_overlay = mutable_appearance('icons/obj/chimeric_nodes.dmi', overlay_state)

	var/matrix/M = matrix()
	M.Scale(0.5, 0.5)
	M.Turn(pick(0, 90, 180, 270))

	node_overlay.pixel_x = rand(-6, 6)
	node_overlay.pixel_y = rand(-6, 6)
	node_overlay.transform = M
	node_overlay.appearance_flags = RESET_COLOR | RESET_ALPHA

	overlay_states += node_overlay

	if(organ_owner)
		var/datum/component/blood_stability/blood_stab = organ_owner.GetComponent(/datum/component/blood_stability)
		if(blood_stab && blood_stab.get_total_stability() < node_injection_cost)
			trigger_failure(injected_node, FALSE, "insufficient blood stability")
			return
		if(blood_stab)
			consume_any_blood(blood_stab, node_injection_cost)

	switch(slot)
		if(INPUT_NODE)
			var/datum/chimeric_node/input/injected_input = injected_node
			if(injected_input.is_special && ((injected_input in inputs) || (injected_input in partnerless_inputs)))
				trigger_failure(failed_type = injected_input, special_failure = TRUE)
				return

			injected_input.node_purity = min(purity + purity_modifier, 100)
			injected_input.tier = tier + tier_modifier
			injected_input.attached_organ = parent
			injected_input.setup()

			handle_input_injection(injected_input)

			if(organ_owner)
				injected_input.hosted_carbon = organ_owner
				injected_input.register_triggers(organ_owner)

		if(OUTPUT_NODE)
			var/datum/chimeric_node/output/injected_output = injected_node
			if(injected_output.is_special && ((injected_output in outputs) || (injected_output in partnerless_outputs)))
				trigger_failure(failed_type = injected_output, special_failure = TRUE)
				return

			injected_output.node_purity = min(purity + purity_modifier, 100)
			injected_output.tier = tier + tier_modifier
			injected_output.attached_organ = parent
			injected_output.setup()

			handle_output_injection(injected_output)

			if(organ_owner)
				injected_output.hosted_carbon = organ_owner

		if(SPECIAL_NODE)
			var/datum/chimeric_node/special/injected_special = injected_node
			injected_special.setup()
			handle_special_injection(injected_special)
	return TRUE

/datum/component/chimeric_organ/proc/consume_any_blood(datum/component/blood_stability/blood_stab, amount)
	for(var/blood_type in blood_stab.blood_stability)
		if(blood_stab.consume_stability(blood_type, amount))
			return TRUE
	return FALSE

/datum/component/chimeric_organ/proc/trigger_failure(failed_type, special_failure = TRUE, reason)
	return

/datum/component/chimeric_organ/proc/handle_input_injection(datum/chimeric_node/input/injected_input)
	if(!partnerless_outputs.len)
		partnerless_inputs += injected_input
		return

	var/datum/chimeric_node/output/picked_output = find_compatible_output(injected_input)
	if(!picked_output)
		partnerless_inputs += injected_input
		return

	pair_input_output(injected_input, picked_output)
	attach_special_to_input(injected_input)

/datum/component/chimeric_organ/proc/handle_output_injection(datum/chimeric_node/output/injected_output)
	if(!partnerless_inputs.len)
		partnerless_outputs += injected_output
		return

	var/datum/chimeric_node/input/picked_input = find_compatible_input(injected_output)
	if(!picked_input)
		partnerless_outputs += injected_output
		return

	pair_input_output(picked_input, injected_output)
	attach_special_to_output(injected_output)

/datum/component/chimeric_organ/proc/find_compatible_output(datum/chimeric_node/input/input_node)
	var/list/viable_outputs = list()
	var/min_tier = input_node.tier - maximum_tier_difference
	var/max_tier = input_node.tier + maximum_tier_difference

	for(var/datum/chimeric_node/output/listed_output as anything in partnerless_outputs)
		if(min_tier <= listed_output.tier && listed_output.tier <= max_tier)
			viable_outputs += listed_output

	return viable_outputs.len ? pick(viable_outputs) : null

/datum/component/chimeric_organ/proc/find_compatible_input(datum/chimeric_node/output/output_node)
	var/list/viable_inputs = list()
	var/min_tier = output_node.tier - maximum_tier_difference
	var/max_tier = output_node.tier + maximum_tier_difference

	for(var/datum/chimeric_node/input/listed_input as anything in partnerless_inputs)
		if(min_tier <= listed_input.tier && listed_input.tier <= max_tier)
			viable_inputs += listed_input

	return viable_inputs.len ? pick(viable_inputs) : null

/datum/component/chimeric_organ/proc/pair_input_output(datum/chimeric_node/input/input_node, datum/chimeric_node/output/output_node)
	input_node.attached_output = output_node
	output_node.attached_input = input_node

	inputs += input_node
	outputs += output_node
	partnerless_inputs -= input_node
	partnerless_outputs -= output_node

/datum/component/chimeric_organ/proc/attach_special_to_input(datum/chimeric_node/input/input_node)
	if(!attachment_less_special_inputs.len)
		return

	var/datum/chimeric_node/special/listed_special = pick(attachment_less_special_inputs)
	listed_special.attached_input = input_node
	attachment_less_special_inputs -= listed_special

/datum/component/chimeric_organ/proc/attach_special_to_output(datum/chimeric_node/output/output_node)
	if(!attachment_less_special_outputs.len)
		return

	var/datum/chimeric_node/special/listed_special = pick(attachment_less_special_outputs)
	listed_special.attached_output = output_node
	attachment_less_special_outputs -= listed_special

/datum/component/chimeric_organ/proc/handle_special_injection(datum/chimeric_node/special/injected_special)
	if(!injected_special.needs_attachment)
		injected_special.trigger_special(modifier = src)
		special_nodes += injected_special
		return

	switch(injected_special.attachement_type)
		if(INPUT_NODE)
			var/list/available_inputs = partnerless_inputs + inputs
			if(!available_inputs.len)
				attachment_less_special_inputs += injected_special
				return
			var/datum/chimeric_node/input/picked_input = pick(available_inputs)
			injected_special.attached_input = picked_input

		if(OUTPUT_NODE)
			var/list/available_outputs = partnerless_outputs + outputs
			if(!available_outputs.len)
				attachment_less_special_outputs += injected_special
				return
			var/datum/chimeric_node/output/picked_output = pick(available_outputs)
			injected_special.attached_output = picked_output
