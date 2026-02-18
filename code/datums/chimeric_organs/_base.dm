/proc/get_weighted_nodes_by_tier(slot_type, max_tier)
	var/list/weighted_nodes = list()
	var/list/node_types

	switch(slot_type)
		if(INPUT_NODE)
			node_types = subtypesof(/datum/chimeric_node/input)
		if(OUTPUT_NODE)
			node_types = subtypesof(/datum/chimeric_node/output)
		if(SPECIAL_NODE)
			node_types = subtypesof(/datum/chimeric_node/special)
		else
			return weighted_nodes

	for(var/datum/chimeric_node/node_type as anything in node_types)
		if(IS_ABSTRACT(node_type))
			continue
		var/tier = initial(node_type.tier)
		if(tier > max_tier)
			continue
		weighted_nodes[node_type] = initial(node_type.weight)

	return weighted_nodes

/datum/chimeric_node
	abstract_type = /datum/chimeric_node
	var/name = ""
	var/desc = ""

	var/slot = INPUT_NODE
	var/is_special = FALSE
	var/node_purity = 100
	var/tier = 1
	var/weight = 10
	var/obj/item/organ/attached_organ
	var/mob/living/carbon/hosted_carbon
	///a special node that interacts with either the input or output
	var/datum/chimeric_node/special/attached_special

	/// Blood types this node can use (empty = can use any)
	var/list/compatible_blood_types = list()
	/// Blood types that provide bonus efficiency
	var/list/preferred_blood_types = list()
	/// Blood types that harm the node/host
	var/list/incompatible_blood_types = list()

	/// Base blood stability consumed per second by this node
	var/base_blood_cost = 0.3
	/// Efficiency bonus when using preferred blood (0.5 = 50% reduction)
	var/preferred_blood_bonus = 0.5
	/// Penalty when using incompatible blood (2.0 = double cost)
	var/incompatible_blood_penalty = 2.0

	// List of organ slots this node can be installed in (empty = any organ)
	///ORGAN_SLOT_BRAIN, ORGAN_SLOT_HEART, ORGAN_SLOT_LUNGS, etc.
	var/list/allowed_organ_slots = list()
	/// List of organ slots this node is explicitly forbidden from
	var/list/forbidden_organ_slots = list()

/datum/component/chimeric_organ/proc/check_node_compatibility(datum/chimeric_node/node)
	var/obj/item/organ/organ = parent
	if(!istype(organ))
		return FALSE

	// Check if node has forbidden slots
	if(length(node.forbidden_organ_slots))
		if(organ.slot in node.forbidden_organ_slots)
			return FALSE

	// Check if node has allowed slots restriction
	if(length(node.allowed_organ_slots))
		if(!(organ.slot in node.allowed_organ_slots))
			return FALSE

	return TRUE

/datum/chimeric_node/proc/setup()
	return

/datum/chimeric_node/proc/set_ranges()
	return

/datum/chimeric_node/proc/return_description(skill_level)
	return

/datum/chimeric_node/proc/check_active()
	return

/datum/chimeric_node/proc/removal_setup()
	return

/datum/chimeric_node/proc/final_setup()
	return

/datum/chimeric_node/proc/set_values(node_purity, tier)
	src.node_purity = node_purity
	src.tier = tier

	set_ranges()

/datum/chimeric_node/proc/generate_html(mob/user)
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
					<h1>[name]</h1>
					<div class='info'>
						<p class='desc'>[desc]</p>
	"}

	var/slot_name = "Unknown"
	var/slot_color = "white"
	switch(slot)
		if(INPUT_NODE)
			slot_name = "Input Node"
			slot_color = "cyan"
		if(OUTPUT_NODE)
			slot_name = "Output Node"
			slot_color = "orange"
		if(SPECIAL_NODE)
			slot_name = "Special Node"
			slot_color = "purple"

	html += "<div class='brew-time' style='color: [slot_color];'><b>Type: [slot_name]</b></div>"

	if(is_special)
		html += "<div style='color: purple;'><b>SPECIAL NODE</b></div>"

	html += "</div>"

	html += "<div class='section'><h2>Installation Requirements</h2>"

	if(length(allowed_organ_slots))
		html += "<div style='color: cyan;'><b>Can ONLY be installed in:</b><br>"
		for(var/organ_slot in allowed_organ_slots)
			html += "• [organ_slot]<br>"
		html += "</div>"
	else if(length(forbidden_organ_slots))
		html += "<div style='color: orange;'><b>Can be installed in any organ EXCEPT:</b><br>"
		for(var/organ_slot in forbidden_organ_slots)
			html += "• [organ_slot]<br>"
		html += "</div>"
	else
		html += "<div style='color: green;'><b>✓ Can be installed in any organ</b></div>"

	html += "</div>"

	html += {"
				</div>
			</div>
		</body>
		</html>
	"}

	return html

/datum/chimeric_node/proc/show_menu(mob/user)
	user << browse(generate_html(user), "window=chimeric_node;size=600x900")

/proc/cmp_chimeric_node_tier_asc(datum/chimeric_node/a, datum/chimeric_node/b)
	return a.tier - b.tier
