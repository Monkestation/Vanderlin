GLOBAL_LIST_EMPTY(active_chimeric_surgeries)

/obj/item/chimeric_node
	name = "humors"
	desc = "A preserved piece of flesh containing a humor. It pulses with unnatural life."
	icon = 'icons/obj/chimeric_nodes.dmi'
	icon_state = "capillary"
	var/datum/chimeric_node/stored_node
	grid_height = 64
	grid_width = 32
	var/node_tier = 1
	var/node_purity = 80
	var/datum/chimeric_table/table_type

/obj/item/chimeric_node/Destroy()
	if(GLOB.active_chimeric_surgeries?[src])
		var/datum/chimeric_surgery_state/surgery = GLOB.active_chimeric_surgeries[src]
		if(surgery.surgeon)
			to_chat(surgery.surgeon, span_warning("The surgery was interrupted!"))
		GLOB.active_chimeric_surgeries -= src
		qdel(surgery)
	return ..()

/obj/item/chimeric_node/examine(mob/user)
	. = ..()
	if(stored_node)
		if(length(stored_node.allowed_organ_slots))
			. += span_notice("This node can only be installed in: [english_list(stored_node.allowed_organ_slots)]")
		if(length(stored_node.forbidden_organ_slots))
			. += span_warning("This node cannot be installed in: [english_list(stored_node.forbidden_organ_slots)]")
		if(!length(stored_node.allowed_organ_slots) && !length(stored_node.forbidden_organ_slots))
			. += span_blue("This node is compatible with any organ.")
		if(length(stored_node.compatible_blood_types) || length(stored_node.preferred_blood_types))
			. += span_notice("This node can use these blood types:")
			for(var/datum/blood_type/blood_type as anything in stored_node.preferred_blood_types)
				. += span_notice("   -[initial(blood_type.name)] Blood (Preferred)")
			for(var/datum/blood_type/blood_type as anything in stored_node.compatible_blood_types)
				if(blood_type in stored_node.preferred_blood_types)
					continue
				. += span_notice("   -[initial(blood_type.name)] Blood")
		if(length(stored_node.incompatible_blood_types))
			. += span_warning("This node isn't able to use these blood types:")
			for(var/datum/blood_type/blood_type as anything in stored_node.incompatible_blood_types)
				. += span_warning("   -[initial(blood_type.name)] Blood")

/obj/item/chimeric_node/proc/setup_node(datum/chimeric_node/incoming_node, list/compatible_blood_types = list(), list/incompatible_blood_types = list(), list/preferred_blood_types = list(), base_blood_cost = 0.3, preferred_blood_bonus = 0.5, incompatible_blood_penalty = 2.0)
	stored_node = new incoming_node

	stored_node.compatible_blood_types = compatible_blood_types
	stored_node.preferred_blood_types = preferred_blood_types
	stored_node.incompatible_blood_types = incompatible_blood_types
	stored_node.base_blood_cost = base_blood_cost
	stored_node.preferred_blood_bonus = preferred_blood_bonus
	stored_node.incompatible_blood_penalty = incompatible_blood_penalty

	stored_node.set_values(node_purity, node_tier)

	switch(stored_node?.slot)
		if(INPUT_NODE)
			icon_state = "input_organoid-[rand(1,7)]"
		if(OUTPUT_NODE)
			icon_state = "output_organoid-[rand(1,7)]"
		if(SPECIAL_NODE)
			icon_state = "process_organoid-[rand(1,7)]"

	update_appearance(UPDATE_NAME)

/obj/item/chimeric_node/update_name(updates)
	. = ..()
	if(!stored_node)
		return
	name = "[lowertext(stored_node.name)] humor"

/mob/living/proc/generate_random_chimeric_organs(amount = 3)
	for(var/i=1 to amount)
		var/obj/item/organ/organ_type = pick(/obj/item/organ/heart, /obj/item/organ/lungs, /obj/item/organ/brain, /obj/item/organ/liver, /obj/item/organ/guts)
		var/obj/item/organ/new_organ = new organ_type(get_turf(src))
		new_organ.generate_chimeric_organ(src)

/obj/item/chimeric_node/attackby(obj/item/I, mob/user, params)
	var/datum/chimeric_surgery_state/surgery = GLOB.active_chimeric_surgeries?[src]

	if(istype(I, /obj/item/weapon/surgery/scalpel))
		if(!surgery)
			start_node_surgery(user)
		return TRUE

	if(!surgery)
		return ..()

	if(istype(I, /obj/item/weapon/surgery/hemostat))
		if(!surgery.extracted)
			surgery_step_extract(user)
		return TRUE

	if(istype(I, /obj/item/weapon/surgery/retractor))
		if(surgery.extracted && !surgery.selected_node)
			surgery_step_select_node(user)
		return TRUE

	if(istype(I, /obj/item/weapon/surgery/cautery))
		if(surgery.selected_node)
			surgery_step_seal(user)
		return TRUE

	to_chat(user, span_warning("That tool isn't useful at this stage of the surgery."))
	return TRUE

/obj/item/chimeric_node/proc/start_node_surgery(mob/user)
	if(!stored_node)
		to_chat(user, span_warning("There's no node to modify!"))
		return

	to_chat(user, span_notice("You begin to carefully open the preserved flesh..."))
	if(!do_after(user, 3 SECONDS, src))
		return

	playsound(src, 'sound/surgery/scalpel1.ogg', 50, TRUE)
	to_chat(user, span_notice("The humor is exposed. You can now modify its essence with the proper tools."))

	var/datum/chimeric_surgery_state/surgery = new()
	surgery.target_node = src
	surgery.current_tier = stored_node.tier
	surgery.current_slot = stored_node.slot
	surgery.preserved_purity = node_purity
	surgery.preserved_tier = node_tier
	surgery.surgeon = user

	LAZYADDASSOC(GLOB.active_chimeric_surgeries, src, surgery)

	to_chat(user, span_info("Use a <b>hemostat</b> to extract the current node essence."))

/obj/item/chimeric_node/proc/surgery_step_extract(mob/user)
	var/datum/chimeric_surgery_state/surgery = GLOB.active_chimeric_surgeries[src]
	if(!surgery || surgery.extracted)
		return FALSE

	to_chat(user, span_notice("You carefully extract the node essence from the preserved tissue..."))
	if(!do_after(user, 4 SECONDS, src))
		return FALSE

	playsound(src, 'sound/surgery/hemostat1.ogg', 50, TRUE)
	surgery.extracted = TRUE
	to_chat(user, span_notice("The essence has been extracted. Use a <b>retractor</b> to select a new node type."))
	return TRUE

/obj/item/chimeric_node/proc/surgery_step_select_node(mob/user)
	var/datum/chimeric_surgery_state/surgery = GLOB.active_chimeric_surgeries[src]
	if(!surgery || !surgery.extracted || surgery.selected_node)
		return FALSE

	// Create a list of node names for selection
	var/datum/chimeric_table/table = new table_type()
	var/list/available_nodes = table.input_nodes.Copy() + table.generic_inputs.Copy() + table.output_nodes.Copy() + table.generic_outputs.Copy()
	if(!length(available_nodes))
		to_chat(user, span_warning("No compatible nodes available!"))
		return FALSE
	var/list/node_names = list()
	var/list/node_lookup = list()
	for(var/datum/chimeric_node/node_type as anything in available_nodes)
		var/node_name = initial(node_type.name)
		var/node_tier = initial(node_type.tier)
		var/display_name = "[node_name] (Tier [node_tier]) ([ispath(node_type, /datum/chimeric_node/input ? "Input Node" : "Trigger Node")])"
		node_names += display_name
		node_lookup[display_name] = node_type

	var/choice = browser_input_list(user, "Select a new node type:", "Node Selection", node_names)
	if(!choice || !do_after(user, 2 SECONDS, src))
		return FALSE

	surgery.selected_node = node_lookup[choice]
	playsound(src, 'sound/surgery/retractor1.ogg', 50, TRUE)
	to_chat(user, span_notice("You prepare the [initial(surgery.selected_node.name)] essence. Use a <b>cautery</b> to seal the new node."))
	return TRUE

/obj/item/chimeric_node/proc/surgery_step_seal(mob/user)
	var/datum/chimeric_surgery_state/surgery = GLOB.active_chimeric_surgeries[src]
	if(!surgery || !surgery.selected_node)
		return FALSE

	to_chat(user, span_notice("You begin to seal the modified humor..."))
	if(!do_after(user, 5 SECONDS, src))
		return FALSE

	playsound(src, 'sound/surgery/cautery1.ogg', 50, TRUE)

	var/old_name = stored_node.name
	var/new_node_type = surgery.selected_node

	var/list/old_compatible = stored_node.compatible_blood_types?.Copy()
	var/list/old_preferred = stored_node.preferred_blood_types?.Copy()
	var/list/old_incompatible = stored_node.incompatible_blood_types?.Copy()
	var/old_blood_cost = stored_node.base_blood_cost
	var/old_preferred_bonus = stored_node.preferred_blood_bonus
	var/old_incompatible_penalty = stored_node.incompatible_blood_penalty

	QDEL_NULL(stored_node)
	setup_node(
		new_node_type,
		old_compatible,
		old_incompatible,
		old_preferred,
		old_blood_cost,
		old_preferred_bonus,
		old_incompatible_penalty
	)

	GLOB.active_chimeric_surgeries -= src
	qdel(surgery)

	user.visible_message(
		span_notice("[user] completes the modification of \the [src]."),
		span_notice("You successfully transform the [old_name] into a [stored_node.name], preserving its essence!")
	)

	return TRUE

// Datum to track surgery state
/datum/chimeric_surgery_state
	var/obj/item/chimeric_node/target_node
	var/mob/surgeon
	var/current_slot
	var/current_tier
	var/preserved_purity
	var/preserved_tier
	var/extracted = FALSE
	var/datum/chimeric_node/selected_node
