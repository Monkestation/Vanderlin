/datum/chimeric_table
	abstract_type = /datum/chimeric_table
	var/name = "Unknown"
	/// Blood types that work normally with this node (list of /datum/blood_type paths)
	var/list/compatible_blood_types = list()
	/// Blood types that are rejected by this node (list of /datum/blood_type paths)
	var/list/incompatible_blood_types = list()
	/// Blood types that work exceptionally well (list of /datum/blood_type paths)
	var/list/preferred_blood_types = list()
	var/base_blood_cost = 0.3
	var/preferred_blood_bonus = 0.5
	var/incompatible_blood_penalty = 2.0
	var/node_tier = 1
	var/node_purity_min = 30
	var/node_purity_max = 70

	// Weighted lists for each node slot type - if no length just picks randomly using assigned weights
	var/list/input_nodes = list()
	var/list/output_nodes = list()
	var/list/special_nodes = list()

	var/list/generic_outputs = list(
		/datum/chimeric_node/output/hallucinate = 1,
		/datum/chimeric_node/output/healing_coma = 1,
		/datum/chimeric_node/output/vomit = 1,
	)
	var/list/generic_inputs = list(
		/datum/chimeric_node/input/reagent = 1,
		/datum/chimeric_node/input/revival = 1,
		/datum/chimeric_node/input/heartbeat = 1,
	)
	var/list/generic_specials = list(
		/datum/chimeric_node/special/repeater = 1,
		/datum/chimeric_node/special/delayer = 1,
	)

/mob/living/proc/generate_chimeric_node_from_mob()
	var/datum/blood_type/blood = get_blood_type()
	var/datum/chimeric_table/table_type
	if(blood)
		table_type = blood.used_table
	if(!table_type)
		return null
	var/datum/chimeric_table/table = new table_type()
	var/list/available_slots = list()

	var/list/inputs = table.input_nodes.Copy() + table.generic_inputs.Copy()
	var/list/outputs = table.output_nodes.Copy() + table.generic_outputs.Copy()
	var/list/specials = table.special_nodes.Copy() + table.generic_specials.Copy()
	if(length(inputs))
		available_slots[INPUT_NODE] = 10
	if(length(outputs))
		available_slots[OUTPUT_NODE] = 10
	if(length(specials))
		available_slots[SPECIAL_NODE] = 1
	if(!length(available_slots))
		available_slots = list(INPUT_NODE = 10, OUTPUT_NODE = 10, SPECIAL_NODE = 1)
	var/selected_slot = pickweight(available_slots)
	var/list/node_pool
	switch(selected_slot)
		if(INPUT_NODE)
			node_pool = inputs
		if(OUTPUT_NODE)
			node_pool = outputs
		if(SPECIAL_NODE)
			node_pool = specials

	if(!length(node_pool))
		node_pool = get_weighted_nodes_by_tier(selected_slot, table.node_tier)
	else
		var/list/tier_nodes = get_weighted_nodes_by_tier(selected_slot, table.node_tier)
		for(var/node_type in tier_nodes)
			if(node_type in node_pool)
				node_pool[node_type] += tier_nodes[node_type]
			else
				node_pool[node_type] = tier_nodes[node_type]

	if(!length(node_pool))
		qdel(table)
		return null
	var/datum/chimeric_node/selected_node_type = pickweight(node_pool)
	var/obj/item/chimeric_node/new_node = new()
	new_node.table_type = table.type
	new_node.node_tier = rand(1, table.node_tier)
	new_node.node_purity = rand(table.node_purity_min, table.node_purity_max)
	new_node.setup_node(
		selected_node_type,
		table.compatible_blood_types,
		table.incompatible_blood_types,
		table.preferred_blood_types,
		table.base_blood_cost,
		table.preferred_blood_bonus,
		table.incompatible_blood_penalty,
	)
	qdel(table)
	return new_node

/mob/living/proc/create_chimeric_node(moves = TRUE)
	var/obj/item/chimeric_node/new_node = generate_chimeric_node_from_mob()
	if(moves)
		new_node.forceMove(get_turf(src))
	return new_node
