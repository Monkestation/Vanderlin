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

/mob/living/proc/create_chimeric_node()
	var/obj/item/chimeric_node/new_node = generate_chimeric_node_from_mob()
	new_node.forceMove(get_turf(src))

/datum/chimeric_table/proc/get_likelihood_text(weight)
	if(weight <= 0)
		return "<span style='color: #444;'>Very Unlikely</span>"
	else if(weight < 5)
		return "<span style='color: #444;'>Unlikely</span>"
	else if(weight < 10)
		return "<span style='color: #444;'>Less Likely</span>"
	else if(weight < 15)
		return "<span style='color: #444;'>Likely</span>"
	else if(weight < 25)
		return "<span style='color: #444;'>More Likely</span>"
	else
		return "<span style='color: #444;'>Very Likely</span>"

/datum/chimeric_table/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	SSassets.transport.send_assets(client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	user << browse_rsc('html/book.png')

	var/html = {"
		<!DOCTYPE html>
		<html>
		<head>
			<link rel="stylesheet" type="text/css" href="slop_menustyle2.css">
		</head>
		<body>
			<div class='book'>
				<div class='page'>
					<h1>[name] Chimeric Dossier</h1>
	"}

	html += "<div class='section'>"
	html += "<h2>Node Information</h2>"
	html += "<b>Maximum Tier</b>: [node_tier]<br>"
	html += "<b>Purity Range:</b> [node_purity_min]% - [node_purity_max]%<br>"
	html += "<b>Average Purity:</b> [(node_purity_min + node_purity_max) / 2]%<br>"
	html += "</div>"

	html += "<div class='section'>"
	html += "<h2>Blood Cost</h2>"
	html += "<b>Base Blood Cost:</b> [base_blood_cost] [LIQUID_UNIT_NAME_PLURAL] per heartbeat<br>"
	html += "<b>Preferred Bonus:</b> -[preferred_blood_bonus * 100]% cost ([base_blood_cost * (1 - preferred_blood_bonus)] [LIQUID_UNIT_NAME_PLURAL]/heartbeat)<br>"
	html += "<b>Incompatible Penalty:</b> +[incompatible_blood_penalty * 100]% cost ([base_blood_cost * (1 + incompatible_blood_penalty)] [LIQUID_UNIT_NAME_PLURAL]/heartbeat)<br>"
	html += "</div>"

	html += "<div class='section'>"
	html += "<h2>Blood Type Relationships</h2>"

	if(length(preferred_blood_types))
		html += "<div style='color: green;'><b>Preferred Blood Types:</b><br>"
		for(var/datum/blood_type/BT as anything in preferred_blood_types)
			var/bt_name = initial(BT.name)
			html += "• [bt_name] (Enhanced efficiency)<br>"
		html += "</div>"

	if(length(compatible_blood_types))
		html += "<div style='color: cyan;'><b>Compatible Blood Types:</b><br>"
		for(var/datum/blood_type/BT as anything in compatible_blood_types)
			var/bt_name = initial(BT.name)
			html += "• [bt_name] (Normal efficiency)<br>"
		html += "</div>"

	if(length(incompatible_blood_types))
		html += "<div style='color: red;'><b>✗ Incompatible Blood Types:</b><br>"
		for(var/datum/blood_type/BT as anything in incompatible_blood_types)
			var/bt_name = initial(BT.name)
			html += "• [bt_name] (Reduced efficiency + damage)<br>"
		html += "</div>"

	if(!length(preferred_blood_types) && !length(compatible_blood_types) && !length(incompatible_blood_types))
		html += "<div style='color: white;'><b>No blood type restrictions - accepts all blood types normally</b></div>"

	html += "</div>"

	html += "<div class='section'>"
	html += "<h2>Available Node Types</h2>"

	if(length(input_nodes) || length(generic_inputs))
		html += "<div style='border: 1px solid cyan; padding: 10px; margin: 5px 0;'>"
		html += "<h3 style='color: cyan;'>Input Nodes</h3>"
		var/total_weight = 0
		var/list/nodes = input_nodes + generic_inputs
		for(var/node_type in nodes)
			total_weight += nodes[node_type]

		for(var/datum/chimeric_node/node_type as anything in nodes)
			var/weight = nodes[node_type]
			var/node_name = initial(node_type.name)
			var/likelihood = get_likelihood_text(weight)
			html += "• <b>[node_name]</b> - [likelihood]<br>"
		html += "</div>"

	if(length(output_nodes) || length(generic_outputs))
		html += "<div style='border: 1px solid orange; padding: 10px; margin: 5px 0;'>"
		html += "<h3 style='color: orange;'>Output Nodes</h3>"
		var/total_weight = 0
		var/list/nodes = output_nodes + generic_outputs
		for(var/node_type in nodes)
			total_weight += nodes[node_type]

		for(var/datum/chimeric_node/node_type as anything in nodes)
			var/weight = nodes[node_type]
			var/node_name = initial(node_type.name)
			var/likelihood = get_likelihood_text(weight)
			html += "• <b>[node_name]</b> - [likelihood]<br>"
		html += "</div>"

	if(length(special_nodes) || length(generic_specials))
		html += "<div style='border: 1px solid purple; padding: 10px; margin: 5px 0;'>"
		html += "<h3 style='color: purple;'>Special Nodes</h3>"
		var/total_weight = 0
		var/list/nodes = special_nodes + generic_specials
		for(var/node_type in nodes)
			total_weight += nodes[node_type]

		for(var/datum/chimeric_node/node_type as anything in nodes)
			var/weight = nodes[node_type]
			var/node_name = initial(node_type.name)
			var/likelihood = get_likelihood_text(weight)
			html += "• <b>[node_name]</b> - [likelihood]<br>"
		html += "</div>"

	html += "</div>"

	html += "<div class='section'>"
	html += "<h2>Slot Distribution</h2>"
	html += "<b>All slots available:</b> Input, Output, and Special (33.3% each)<br>"
	html += "</div>"

	html += {"
				</div>
			</div>
		</body>
		</html>
	"}

	return html

/datum/chimeric_table/proc/show_menu(mob/user)
	user << browse(generate_html(user), "window=chimeric_table;size=650x900")
