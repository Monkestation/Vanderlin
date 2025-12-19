
/obj/item/chimeric_node
	name = "umors"
	desc = "A preserved piece of flesh containing a humor. It pulses with unnatural life."
	icon = 'icons/obj/chimeric_nodes.dmi'
	icon_state = "capillary"
	var/datum/chimeric_node/stored_node
	grid_height = 64
	grid_width = 32
	var/node_tier = 1
	var/node_purity = 80

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
