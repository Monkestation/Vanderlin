/datum/inquisition_hierarchy_interface
	var/mob/living/carbon/human/user
	var/datum/oratorium/user_inquisition
	var/datum/inquisition_hierarchy_node/selected_position
	var/selected_school = "Venatari"
	COOLDOWN_DECLARE(last_creation)

/datum/inquisition_hierarchy_interface/New(mob/living/carbon/human/target_user)
	user = target_user
	user_inquisition = user.inquisition
	calculate_hierarchy_positions()
	..()

/datum/inquisition_hierarchy_interface/proc/can_manage_hierarchy()
	if(!user.inquisition_position)
		return FALSE

	//leaders can manage their school
	if(user.inquisition_position.is_school_leader)
		return TRUE

	return user.inquisition_position.can_assign_positions

/datum/inquisition_hierarchy_interface/proc/can_manage_position(datum/inquisition_hierarchy_node/target_position)
	if(!target_position)
		return FALSE

	//leaders can manage their entire school
	if(user.inquisition_position && user.inquisition_position.is_school_leader && user.inquisition_position.school == target_position.school)
		return TRUE

	if(!user.inquisition_position || !user.inquisition_position.can_assign_positions)
		return FALSE

	//makes sure we are in our school
	var/list/manageable_positions = user.inquisition_position.get_all_subordinates()
	return (target_position in manageable_positions)

//!hold over from the clan menu don't really use it
/datum/inquisition_hierarchy_interface/proc/can_create_position_under(datum/inquisition_hierarchy_node/superior_position)
	if(!superior_position)
		return FALSE

	if(user.inquisition_position && user.inquisition_position.is_school_leader && user.inquisition_position.school == superior_position.school)
		return TRUE

	if(!user.inquisition_position || !user.inquisition_position.can_assign_positions)
		return FALSE

	if(superior_position == user.inquisition_position)
		return TRUE

	var/list/manageable_positions = user.inquisition_position.get_all_subordinates()
	return (superior_position in manageable_positions)

/datum/inquisition_hierarchy_interface/proc/generate_hierarchy_html()
	if(!user_inquisition)
		return "<div class='error'>No inquisition hierarchy found</div>"

	var/hierarchy_html = {"
	<div class="school-tabs">
		<button class="school-tab [selected_school == "Order of the Venatari" ? "active" : ""]" onclick="switchSchool('Order of the Venatari')">Order of the Venatari</button>
		<button class="school-tab [selected_school == "Benetarus" ? "active" : ""]" onclick="switchSchool('Benetarus')">Benetarus</button>
		<button class="school-tab [selected_school == "Sanctae" ? "active" : ""]" onclick="switchSchool('Sanctae')">Ordo Sanctae Cruoris</button>
	</div>

	<div class="research-container" id="container">
		<div class="parallax-container" id="parallax-container">
			<div class="parallax-layer parallax-bg"></div>
			<div class="parallax-layer parallax-stars-1"></div>
		</div>
		<div class="research-canvas" id="canvas">
			[generate_hierarchy_connections_html()]
			[generate_hierarchy_nodes_html()]
		</div>
	</div>
	<div class="tooltip" id="tooltip" style="display: none;"></div>
	[generate_hierarchy_sidebar()]
	[can_manage_hierarchy() ? generate_management_modal() : ""]

	<style>
		* {
			margin: 0;
			padding: 0;
			box-sizing: border-box;
		}

		body, html {
			width: 100%;
			height: 100%;
			overflow: hidden;
			background: #0a0a0a;
		}

		.school-tabs {
			position: fixed;
			top: 10px;
			left: 50%;
			transform: translateX(-50%);
			display: flex;
			gap: 10px;
			z-index: 1000;
			background: rgba(20, 20, 30, 0.95);
			padding: 10px;
			border-radius: 8px;
			border: 1px solid #444;
		}

		.school-tab {
			padding: 10px 20px;
			background: rgba(40, 40, 50, 0.8);
			color: #ccc;
			border: 1px solid #555;
			border-radius: 5px;
			cursor: pointer;
			font-size: 14px;
			transition: all 0.3s;
		}

		.school-tab:hover {
			background: rgba(60, 60, 70, 0.9);
			color: #fff;
		}

		.school-tab.active {
			background: #8B0000;
			color: white;
			border-color: #600000;
		}

		/* Main container - fixed fullscreen */
		.research-container {
			position: fixed;
			top: 0;
			left: 0;
			right: 320px;
			bottom: 0;
			overflow: hidden;
			background: #0a0a0a;
			cursor: grab;
		}

		.research-container.dragging {
			cursor: grabbing;
		}

		/* Parallax background - fixed behind everything */
		.parallax-container {
			position: fixed;
			top: 0;
			left: 0;
			right: 320px;
			bottom: 0;
			overflow: hidden;
			pointer-events: none;
			z-index: 1;
		}

		.parallax-layer {
			position: absolute;
			top: -20%;
			left: -20%;
			width: 140%;
			height: 140%;
			will-change: transform;
			pointer-events: none;
		}

		.parallax-bg {
			background-image: url('KettleParallaxBG.png');
			background-size: cover;
			background-repeat: no-repeat;
			background-position: center;
		}

		.parallax-stars-1 {
			background: radial-gradient(ellipse at center,
				rgba(139, 69, 19, 0.3) 0%,
				rgba(160, 82, 45, 0.2) 40%,
				transparent 70%),
				radial-gradient(circle at 20% 30%, rgba(255, 215, 0, 0.8) 1px, transparent 2px),
				radial-gradient(circle at 80% 20%, rgba(139, 69, 19, 0.6) 1px, transparent 2px),
				radial-gradient(circle at 60% 80%, rgba(160, 82, 45, 0.4) 2px, transparent 4px);
			background-size: 800px 600px, 200px 150px, 300px 200px, 250px 180px;
			opacity: 0.8;
		}

		/* Canvas that can be dragged */
		.research-canvas {
			position: absolute;
			width: 3000px;
			height: 2000px;
			z-index: 10;
			pointer-events: none;
			transform-origin: 0 0;
		}

		.hierarchy-node {
			position: absolute;
			width: 120px;
			height: 80px;
			background: rgba(40, 40, 50, 0.9);
			border: 2px solid #666;
			border-radius: 8px;
			cursor: pointer;
			transition: all 0.3s ease;
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;
			text-align: center;
			padding: 5px;
			z-index: 100;
			pointer-events: auto;
		}

		.hierarchy-node.selected {
			border-color: #4CAF50;
			box-shadow: 0 0 15px rgba(76, 175, 80, 0.5);
			z-index: 101;
		}

		.hierarchy-node.filled {
			background: rgba(60, 80, 60, 0.9);
			border-color: #4CAF50;
		}

		.hierarchy-node.vacant {
			background: rgba(60, 40, 40, 0.9);
			border-color: #f44336;
		}

		.hierarchy-node.leader {
			background: rgba(80, 60, 40, 0.9);
			border-color: #FF9800;
			box-shadow: 0 0 10px rgba(255, 152, 0, 0.3);
		}

		.hierarchy-node:hover {
			transform: scale(1.05);
			box-shadow: 0 0 20px rgba(255, 255, 255, 0.2);
			z-index: 102;
		}

		.connection-line {
			position: absolute;
			height: 3px;
			background: linear-gradient(90deg, #666, #888, #666);
			border-radius: 1px;
			opacity: 0.8;
			z-index: 50;
			pointer-events: none;
		}

		.hierarchy-sidebar {
			position: fixed;
			right: 10px;
			top: 70px;
			width: 300px;
			height: calc(100vh - 80px);
			background: rgba(20, 20, 30, 0.95);
			border: 1px solid #444;
			border-radius: 8px;
			padding: 15px;
			overflow-y: auto;
			z-index: 1000;
			box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
		}

		.sidebar-header {
			border-bottom: 1px solid #444;
			padding-bottom: 10px;
			margin-bottom: 15px;
		}

		.sidebar-header h3 {
			margin: 0 0 10px 0;
			color: #fff;
			font-size: 16px;
		}

		.sidebar-content {
			color: #ccc;
			font-size: 13px;
			line-height: 1.4;
		}

		.position-details h4 {
			color: #fff;
			margin: 0 0 10px 0;
			font-size: 14px;
			border-bottom: 1px solid #333;
			padding-bottom: 5px;
		}

		.position-details p {
			margin: 8px 0;
		}

		.position-details strong {
			color: #aaa;
		}

		.position-actions {
			margin-top: 15px;
			padding-top: 10px;
			border-top: 1px solid #333;
			display: flex;
			flex-direction: column;
			gap: 5px;
		}

		.position-actions button {
			width: 100%;
			padding: 8px;
			border: none;
			border-radius: 4px;
			cursor: pointer;
			font-size: 12px;
			transition: all 0.2s ease;
		}

		.btn-primary {
			background: #2196F3;
			color: white;
		}

		.btn-primary:hover {
			background: #1976D2;
		}

		.btn-secondary {
			background: #666;
			color: white;
		}

		.btn-secondary:hover {
			background: #555;
		}

		.btn-danger {
			background: #f44336;
			color: white;
		}

		.btn-danger:hover {
			background: #d32f2f;
		}

		.tooltip {
			position: fixed;
			background: rgba(0,0,0,0.9);
			color: white;
			padding: 8px;
			border-radius: 4px;
			font-size: 12px;
			z-index: 2000;
			max-width: 200px;
			border: 1px solid #444;
			box-shadow: 0 2px 8px rgba(0,0,0,0.5);
			pointer-events: none;
		}

		.modal {
			position: fixed;
			top: 0;
			left: 0;
			width: 100%;
			height: 100%;
			background: rgba(0,0,0,0.8);
			z-index: 2000;
			display: none;
		}

		.modal-content {
			position: relative;
			background: #2a2a2a;
			margin: 10% auto;
			padding: 20px;
			width: 500px;
			border-radius: 8px;
			color: #fff;
			overflow-y: auto;
			max-height: 80vh;
		}

		.close {
			position: absolute;
			top: 10px;
			right: 15px;
			font-size: 24px;
			cursor: pointer;
			color: #ccc;
		}

		.close:hover {
			color: #fff;
		}

		.form-group {
			margin-bottom: 15px;
		}

		.form-group label {
			display: block;
			margin-bottom: 5px;
			color: #ccc;
		}

		.form-group input, .form-group textarea, .form-group select {
			width: 100%;
			padding: 8px;
			border: 1px solid #555;
			background: #1a1a1a;
			color: #fff;
			border-radius: 4px;
		}

		.form-actions {
			margin-top: 20px;
			text-align: right;
			display: flex;
			gap: 10px;
			justify-content: flex-end;
		}

		.form-actions button {
			padding: 8px 16px;
			border: none;
			border-radius: 4px;
			cursor: pointer;
			font-size: 14px;
		}

		.dialog-content h3 {
			margin-top: 0;
			color: #fff;
		}
			</style>
	"}

	return hierarchy_html


/datum/inquisition_hierarchy_interface/proc/calculate_hierarchy_positions()
	if(!user_inquisition)
		return

	var/horizontal_spacing = 200  // Space between columns
	var/vertical_spacing = 100    // Space between siblings
	var/base_x = 400
	var/base_y = 50

	var/datum/inquisition_hierarchy_node/school_root = user_inquisition.get_school_root(selected_school)

	if(school_root)
		// Sort all subordinates by merit (recursive)
		sort_subordinates_by_merits(school_root)
		// Position using vertical merit layout
		position_vertical_merit_layout(school_root, base_x, base_y, horizontal_spacing, vertical_spacing)

/datum/inquisition_hierarchy_interface/proc/position_vertical_merit_layout(datum/inquisition_hierarchy_node/node, center_x, y_pos, h_spacing, v_spacing_base, v_spacing_per_merit)
	if(!node)
		return

	// Position this node
	node.node_x = center_x - 60
	node.node_y = y_pos

	if(node.subordinates.len == 0)
		return

	// Group subordinates by merit
	var/list/merit_groups = list()
	var/list/merit_values = list()  // Track unique merit values in order

	for(var/datum/inquisition_hierarchy_node/sub in node.subordinates)
		var/merit_key = "[sub.merits]"
		if(!merit_groups[merit_key])
			merit_groups[merit_key] = list()
			merit_values += sub.merits
		merit_groups[merit_key] += sub

	var/current_y = y_pos + v_spacing_base
	var/previous_merit = null

	for(var/merit_value in merit_values)
		var/merit_key = "[merit_value]"
		var/list/same_merit_nodes = merit_groups[merit_key]

		if(previous_merit != null)
			var/merit_diff = previous_merit - merit_value
			var/spacing = v_spacing_base + (merit_diff * v_spacing_per_merit)
			current_y += spacing

		var/group_count = same_merit_nodes.len
		var/total_width = (group_count - 1) * h_spacing
		var/start_x = center_x - (total_width / 2)

		for(var/i = 1 to group_count)
			var/datum/inquisition_hierarchy_node/merit_node = same_merit_nodes[i]
			var/node_x = start_x + ((i - 1) * h_spacing)

			position_vertical_merit_layout(merit_node, node_x, current_y, h_spacing, v_spacing_base, v_spacing_per_merit)

		previous_merit = merit_value


/datum/inquisition_hierarchy_interface/proc/sort_subordinates_by_merits(datum/inquisition_hierarchy_node/node)
	if(!node || !node.subordinates.len)
		return

	var/list/sorted_subs = node.subordinates.Copy()

	//bibble sort
	for(var/i = 1 to sorted_subs.len)
		for(var/j = 1 to sorted_subs.len - 1)
			var/datum/inquisition_hierarchy_node/sub1 = sorted_subs[j]
			var/datum/inquisition_hierarchy_node/sub2 = sorted_subs[j + 1]

			var/merits1 = sub1.merits
			var/merits2 = sub2.merits

			if(merits1 < merits2)
				sorted_subs.Swap(j, j + 1)

	node.subordinates = sorted_subs

	for(var/datum/inquisition_hierarchy_node/subordinate in node.subordinates)
		sort_subordinates_by_merits(subordinate)

/datum/inquisition_hierarchy_interface/proc/calculate_subtree_width(datum/inquisition_hierarchy_node/node, h_spacing)
	if(!node || node.subordinates.len == 0)
		return h_spacing

	var/total_width = 0
	for(var/datum/inquisition_hierarchy_node/subordinate in node.subordinates)
		total_width += calculate_subtree_width(subordinate, h_spacing)

	return max(total_width, h_spacing)

/datum/inquisition_hierarchy_interface/proc/generate_hierarchy_connections_html()
	var/html = ""
	var/center_x = 0
	var/center_y = 0

	var/list/school_positions = user_inquisition.get_school_positions(selected_school)

	for(var/datum/inquisition_hierarchy_node/position in school_positions)
		if(!position.superior || position.superior.school != selected_school)
			continue

		var/start_center_x = center_x + position.superior.node_x + 60
		var/start_center_y = center_y + position.superior.node_y + 40
		var/end_center_x = center_x + position.node_x + 60
		var/end_center_y = center_y + position.node_y + 10

		var/dx = end_center_x - start_center_x
		var/dy = end_center_y - start_center_y
		var/distance = sqrt(dx*dx + dy*dy)

		if(distance == 0)
			continue

		var/angle = arctan(dx, dy)
		if(angle < 0)
			angle += 360

		html += {"<div class="connection-line hierarchy-connection"
			style="left: [start_center_x]px; top: [start_center_y - 1.5]px; width: [distance]px;
			transform: rotate([angle]deg); transform-origin: 0 50%; z-index: 1;"></div>"}

	return html

/datum/inquisition_hierarchy_interface/proc/generate_hierarchy_nodes_html()
	var/html = ""
	var/list/school_positions = user_inquisition.get_school_positions(selected_school)

	for(var/datum/inquisition_hierarchy_node/position in school_positions)
		var/member_name = position.assigned_member ? position.assigned_member.real_name : "Vacant"
		var/member_merits = position ? position.merits : 0
		var/node_classes = "hierarchy-node"

		if(position.assigned_member)
			node_classes += " filled"
		else
			node_classes += " vacant"

		if(position.is_school_leader)
			node_classes += " leader"
		if(position == selected_position)
			node_classes += " selected"

		var/list/node_data = list(
			"name" = position.name,
			"desc" = position.desc,
			"member" = member_name,
			"required_merits" = position.required_merits,
			"member_merits" = member_merits,
			"subordinates" = "[position.subordinates.len]/[position.max_subordinates]",
			"can_assign" = position.can_assign_positions,
			"school" = position.school
		)

		var/node_data_json = json_encode(node_data)
		var/escaped_node_data_json = replacetext(node_data_json, "'", "&#39;")

		var/icon_html = ""
		if(position.cloned_look)
			icon_html = ma2html(position.cloned_look, user)

		html += {"<div class="[node_classes]"
			style="left: [position.node_x]px; top: [position.node_y]px; border-color: [position.position_color];"
			data-node-id="[REF(position)]"
			onclick="selectHierarchyPosition('[REF(position)]')"
			onmouseover="showNodeTooltip(event, '[escaped_node_data_json]')"
			onmouseout="hideNodeTooltip()">

			[icon_html]
			<div style="font-size: 12px; font-weight: bold; color: white; margin-top: 4px;">[position.name]</div>
			[position.assigned_member ? "<div style='font-size: 10px; color: #aaa;'>Merits: [member_merits]</div>" : ""]
		</div>"}

	return html

/datum/inquisition_hierarchy_interface/proc/generate_hierarchy_sidebar()
	var/sidebar_html = {"
	<div class="hierarchy-sidebar">
		<div class="sidebar-header">
			<h3>Position Details</h3>
		</div>
		<div class="sidebar-content">
			[selected_position ? generate_position_details_html() : "<p>Select a position to view details</p>"]
		</div>
	</div>

	<style>
		.hierarchy-sidebar {
			position: fixed;
			right: 10px;
			top: 90px;
			width: 280px;
			height: calc(100vh - 100px);
			background: rgba(20, 20, 30, 0.95);
			border: 1px solid #444;
			border-radius: 8px;
			padding: 15px;
			overflow-y: auto;
			z-index: 1000;
			box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
		}

		.sidebar-header {
			border-bottom: 1px solid #444;
			padding-bottom: 10px;
			margin-bottom: 15px;
		}

		.sidebar-header h3 {
			margin: 0 0 10px 0;
			color: #fff;
			font-size: 16px;
		}

		.sidebar-content {
			color: #ccc;
			font-size: 13px;
			line-height: 1.4;
		}

		.position-details h4 {
			color: #fff;
			margin: 0 0 10px 0;
			font-size: 14px;
			border-bottom: 1px solid #333;
			padding-bottom: 5px;
		}

		.position-details p {
			margin: 8px 0;
		}

		.position-details strong {
			color: #aaa;
		}

		.position-actions {
			margin-top: 15px;
			padding-top: 10px;
			border-top: 1px solid #333;
			display: flex;
			flex-direction: column;
			gap: 5px;
		}

		.position-actions button {
			width: 100%;
			padding: 8px;
			border: none;
			border-radius: 4px;
			cursor: pointer;
			font-size: 12px;
			transition: all 0.2s ease;
		}

		.btn-primary {
			background: #2196F3;
			color: white;
		}

		.btn-primary:hover {
			background: #1976D2;
		}

		.btn-secondary {
			background: #666;
			color: white;
		}

		.btn-secondary:hover {
			background: #555;
		}

		.btn-danger {
			background: #f44336;
			color: white;
		}

		.btn-danger:hover {
			background: #d32f2f;
		}

		.hierarchy-node {
			position: absolute;
			width: 120px;
			height: 80px;
			background: rgba(40, 40, 50, 0.9);
			border: 2px solid #666;
			border-radius: 8px;
			cursor: pointer;
			transition: all 0.3s ease;
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;
			text-align: center;
			padding: 5px;
			box-sizing: border-box;
		}

		.hierarchy-node.selected {
			border-color: #4CAF50;
			box-shadow: 0 0 15px rgba(76, 175, 80, 0.5);
		}

		.hierarchy-node.filled {
			background: rgba(60, 80, 60, 0.9);
			border-color: #4CAF50;
		}

		.hierarchy-node.vacant {
			background: rgba(60, 40, 40, 0.9);
			border-color: #f44336;
		}

		.hierarchy-node.leader {
			background: rgba(80, 60, 40, 0.9);
			border-color: #FF9800;
			box-shadow: 0 0 10px rgba(255, 152, 0, 0.3);
		}

		.hierarchy-node:hover {
			transform: scale(1.05);
			box-shadow: 0 0 20px rgba(255, 255, 255, 0.2);
		}

		.connection-line {
			position: absolute;
			height: 3px;
			background: linear-gradient(90deg, #666, #888, #666);
			border-radius: 1px;
			opacity: 0.8;
			z-index: 1;
		}

		.research-container {
			position: relative;
			overflow: auto;
			background: #1a1a1a;
			height: calc(100vh - 100px);
		}

		.research-canvas {
			position: relative;
			min-height: 600px;
			margin-right: 300px;
		}

		.tooltip {
			position: absolute;
			background: rgba(0,0,0,0.9);
			color: white;
			padding: 8px;
			border-radius: 4px;
			font-size: 12px;
			z-index: 1001;
			max-width: 200px;
			border: 1px solid #444;
			box-shadow: 0 2px 8px rgba(0,0,0,0.5);
		}

		.modal {
			position: fixed;
			top: 0;
			left: 0;
			width: 100%;
			height: 100%;
			background: rgba(0,0,0,0.8);
			z-index: 2000;
		}

		.modal-content {
			position: relative;
			background: #2a2a2a;
			margin: 10% auto;
			padding: 20px;
			width: 500px;
			border-radius: 8px;
			color: #fff;
			overflow-y: auto;
			max-height: 80vh;
		}

		.close {
			position: absolute;
			top: 10px;
			right: 15px;
			font-size: 24px;
			cursor: pointer;
			color: #ccc;
		}

		.close:hover {
			color: #fff;
		}

		.form-group {
			margin-bottom: 15px;
		}

		.form-group label {
			display: block;
			margin-bottom: 5px;
			color: #ccc;
		}

		.form-group input, .form-group textarea, .form-group select {
			width: 100%;
			padding: 8px;
			border: 1px solid #555;
			background: #1a1a1a;
			color: #fff;
			border-radius: 4px;
			box-sizing: border-box;
		}

		.form-actions {
			margin-top: 20px;
			text-align: right;
			display: flex;
			gap: 10px;
			justify-content: flex-end;
		}

		.form-actions button {
			padding: 8px 16px;
			border: none;
			border-radius: 4px;
			cursor: pointer;
			font-size: 14px;
		}

		.dialog-content h3 {
			margin-top: 0;
			color: #fff;
		}

		@media (max-width: 1200px) {
			.hierarchy-sidebar {
				width: 250px;
			}
		}

		@media (max-width: 1000px) {
			.hierarchy-sidebar {
				position: relative;
				right: auto;
				top: auto;
				width: 100%;
				height: auto;
				margin-top: 20px;
			}
		}
	</style>
	"}
	return sidebar_html


/datum/inquisition_hierarchy_interface/proc/generate_position_details_html()
	if(!selected_position)
		return "<p>No position selected</p>"

	var/member_info = selected_position.assigned_member ? selected_position.assigned_member.real_name : "Vacant"
	var/can_modify = can_manage_position(selected_position)

	var/html = {"
	<div class="position-details">
		<h4>[selected_position.name]</h4>
		<p><strong>School:</strong> Ordo [selected_position.school]</p>
		<p><strong>Description:</strong> [selected_position.desc]</p>
		<p><strong>Assigned Member:</strong> [member_info]</p>
		<p><strong>Merits:</strong> [selected_position.merits]</p>
		<p><strong>Subordinates:</strong> [selected_position.subordinates.len]/[selected_position.max_subordinates]</p>
		<p><strong>Can Assign Positions:</strong> [selected_position.can_assign_positions ? "Yes" : "No"]</p>

		[can_modify ? {"
		<div class="position-actions">
			<button onclick='editPosition("[REF(selected_position)]")' class='btn-primary'>Edit Position</button>
			<button onclick='toggleAssignPermission("[REF(selected_position)]")' class='btn-secondary'>[selected_position.can_assign_positions ? "Remove" : "Grant"] Assign Permission</button>
			[!selected_position.is_school_leader ? "<button onclick='removePosition(\"[REF(selected_position)]\")' class='btn-danger'>Remove Position</button>" : ""]
		</div>
		"} : ""]
	</div>
	"}

	return html

/datum/inquisition_hierarchy_interface/proc/generate_member_options(list/available_members)
	var/html = ""

	for(var/mob/living/carbon/human/member in available_members)
		if(!member || !member.real_name)
			continue

		if(member.inquisition_position && !can_manage_position(member.inquisition_position))
			continue

		html += "<option value='[REF(member)]'>[member.real_name]</option>"

	return html

/datum/inquisition_hierarchy_interface/proc/show_edit_position_dialog()
	if(!selected_position || !can_manage_position(selected_position))
		return

	var/modal_content = {"
	<div class='dialog-content'>
		<h3>Edit Position: [selected_position.name]</h3>
		<form id='edit-position-form'>
			<div class='form-group'>
				<label for='edit-position-name'>Position Name:</label>
				<input type='text' id='edit-position-name' name='position_name' value='[selected_position.name]' required maxlength='50'>
			</div>

			<div class='form-group'>
				<label for='edit-position-desc'>Description:</label>
				<textarea id='edit-position-desc' name='position_desc' rows='3' maxlength='200'>[selected_position.desc]</textarea>
			</div>

			<div class='form-group'>
				<label for='edit-position-color'>Position Color:</label>
				<input type='color' id='edit-position-color' name='position_color' value='[selected_position.position_color]'>
			</div>

			<div class='form-group'>
				<label>
					<input type='checkbox' id='edit-can-assign-positions' name='can_assign_positions' value='1' [selected_position.can_assign_positions ? "checked" : ""]>
					Can assign subordinate positions
				</label>
			</div>

			<div class='form-actions'>
				<button type='button' onclick='submitEditPosition()' class='btn-primary'>Save Changes</button>
				<button type='button' onclick='closeHierarchyModal()' class='btn-secondary'>Cancel</button>
			</div>
		</form>
	</div>

	<script>
		document.getElementById('management-modal').style.display = 'block';
		document.getElementById('modal-title').textContent = '';
		document.getElementById('modal-body').innerHTML = document.querySelector('.dialog-content').outerHTML;
	</script>
	"}

	var/updated_html = generate_hierarchy_html()
	updated_html = replacetext(updated_html, "<!-- Dynamic content goes here -->", modal_content)
	user << browse(updated_html, "window=inquisition_menu;size=1200x800")

/datum/inquisition_hierarchy_interface/proc/generate_superior_position_options()
	var/html = ""
	var/list/school_positions = user_inquisition.get_school_positions(selected_school)

	for(var/datum/inquisition_hierarchy_node/position in school_positions)
		if(position.subordinates.len >= position.max_subordinates)
			continue

		if(!can_create_position_under(position))
			continue

		html += "<option value='[REF(position)]'>[position.name] (Merits [position.merits]) - [position.subordinates.len]/[position.max_subordinates] slots</option>"

	return html

/datum/inquisition_hierarchy_interface/proc/generate_management_modal()
	return {"
	<div id="management-modal" class="modal" style="display: none;">
		<div class="modal-content">
			<span class="close" onclick="closeHierarchyModal()">&times;</span>
			<h3 id="modal-title">Manage Position</h3>
			<div id="modal-body">
				<!-- Dynamic content goes here -->
			</div>
		</div>
	</div>

	<script>
		var selectedPosition = '[selected_position ? REF(selected_position) : ""]';
		var currentSchool = '[selected_school]';

		// Dragging state - SIMPLIFIED
		var isDragging = false;
		var startX = 0;
		var startY = 0;
		var currentX = 0;
		var currentY = 0;

		// Initialize on page load
		window.addEventListener('DOMContentLoaded', function() {
			var container = document.getElementById('container');
			var canvas = document.getElementById('canvas');
			var parallaxBg = document.querySelector('.parallax-bg');
			var parallaxStars = document.querySelector('.parallax-stars-1');

			if(!container || !canvas) return;

			// Set initial position from storage
			try {
				const savedX = sessionStorage.getItem('translateX');
				const savedY = sessionStorage.getItem('translateY');
				if (savedX !== null) currentX = parseFloat(savedX);
				if (savedY !== null) currentY = parseFloat(savedY);
			} catch(e) {
				currentX = 0;
				currentY = 0;
			}

			canvas.style.transform = 'translate(' + currentX + 'px, ' + currentY + 'px)';

			// Restore selected position if exists
			if(selectedPosition) {
				var selectedNode = document.querySelector('\[data-node-id="' + selectedPosition + '"\]');
				if(selectedNode) {
					selectedNode.classList.add('selected');
				}
			}

			// Mouse down - start dragging
			container.addEventListener('mousedown', function(e) {
				// Ignore if clicking on a node or button
				if(e.target.closest('.hierarchy-node') || e.target.closest('button')) {
					return;
				}

				isDragging = true;
				container.classList.add('dragging');
				startX = e.clientX - currentX;
				startY = e.clientY - currentY;
				e.preventDefault();
			});

			// Mouse move - drag canvas (NO requestAnimationFrame)
			container.addEventListener('mousemove', function(e) {
				if(!isDragging) return;

				currentX = e.clientX - startX;
				currentY = e.clientY - startY;

				// Direct update - no animation frame needed
				canvas.style.transform = 'translate(' + currentX + 'px, ' + currentY + 'px)';

				// Update parallax
				if(parallaxBg && parallaxStars) {
					parallaxBg.style.transform = 'translate(' + (currentX * 0.1) + 'px, ' + (currentY * 0.1) + 'px)';
					parallaxStars.style.transform = 'translate(' + (currentX * 0.3) + 'px, ' + (currentY * 0.3) + 'px)';
				}
			});

			// Mouse up - stop dragging
			window.addEventListener('mouseup', function() {
				if(isDragging) {
					isDragging = false;
					container.classList.remove('dragging');
					// Save current position
					try {
						sessionStorage.setItem('translateX', currentX.toString());
						sessionStorage.setItem('translateY', currentY.toString());
					} catch(e) {
						// Ignore storage errors
					}
				}
			});

			// Prevent text selection while dragging
			container.addEventListener('selectstart', function(e) {
				if(isDragging) {
					e.preventDefault();
				}
			});
		});

		function switchSchool(school) {
			window.location.href = '?src=[REF(src)];action=switch_school;school=' + school;
		}

		function showNodeTooltip(event, nodeDataJson) {
			try {
				var nodeData = JSON.parse(nodeDataJson);
				var tooltip = document.getElementById('tooltip');
				if(tooltip) {
					tooltip.innerHTML = '<strong>' + nodeData.name + '</strong><br>' +
						'<em>' + nodeData.desc + '</em><br>' +
						'<strong>School:</strong> Ordo ' + nodeData.school + '<br>' +
						'<strong>Member:</strong> ' + nodeData.member + '<br>' +
						(nodeData.member_merits > 0 ? '<strong>Member Merits:</strong> ' + nodeData.member_merits + '<br>' : '') +
						'<strong>Subordinates:</strong> ' + nodeData.subordinates + '<br>' +
						'<strong>Can Assign:</strong> ' + (nodeData.can_assign ? 'Yes' : 'No');
					tooltip.style.display = 'block';
					tooltip.style.left = (event.clientX + 10) + 'px';
					tooltip.style.top = (event.clientY + 10) + 'px';
				}
			} catch(e) {
				console.error('Error parsing tooltip data:', e);
			}
		}

		function hideNodeTooltip() {
			var tooltip = document.getElementById('tooltip');
			if(tooltip) {
				tooltip.style.display = 'none';
			}
		}

		function selectHierarchyPosition(positionRef) {
			selectedPosition = positionRef;
			window.location.href = '?src=[REF(src)];action=select_position;position_id=' + positionRef;
		}

		function editPosition(positionRef) {
			window.location.href = '?src=[REF(src)];action=edit_position;position_id=' + positionRef;
		}

		function toggleAssignPermission(positionRef) {
			window.location.href = '?src=[REF(src)];action=toggle_assign_permission;position_id=' + positionRef;
		}

		function removePosition(positionRef) {
			if(confirm('Are you sure you want to remove this position?')) {
				window.location.href = '?src=[REF(src)];action=remove_position;position_id=' + positionRef;
			}
		}

		function closeHierarchyModal() {
			var modal = document.getElementById('management-modal');
			if(modal) {
				modal.style.display = 'none';
			}
		}

		function submitEditPosition() {
			const form = document.getElementById('edit-position-form');
			const formData = new FormData(form);
			let params = '?src=[REF(src)];action=submit_edit_position';
			for(let \[key, value\] of formData.entries()) {
				params += ';' + key + '=' + encodeURIComponent(value);
			}
			params += ';position_id=' + selectedPosition;
			window.location.href = params;
		}
	</script>
	"}

/datum/inquisition_hierarchy_interface/Topic(href, href_list)
	if(!user || !user_inquisition)
		return

	switch(href_list["action"])
		if("switch_school")
			selected_school = href_list["school"]
			selected_position = null
			refresh_hierarchy()

		if("select_position")
			var/position_ref = href_list["position_id"]
			for(var/datum/inquisition_hierarchy_node/position in user_inquisition.all_positions)
				if(REF(position) == position_ref)
					selected_position = position
					selected_school = position.school
					break
			refresh_hierarchy()

		if("toggle_assign_permission")
			var/position_ref = href_list["position_id"]
			for(var/datum/inquisition_hierarchy_node/position in user_inquisition.all_positions)
				if(REF(position) == position_ref)
					if(can_manage_position(position))
						position.can_assign_positions = !position.can_assign_positions
						to_chat(user, "<span class='notice'>[position.name] assignment permission [position.can_assign_positions ? "granted" : "removed"]</span>")
					else
						to_chat(user, "<span class='warning'>You don't have permission to modify this position.</span>")
					break
			refresh_hierarchy()

		if("remove_position")
			var/position_ref = href_list["position_id"]
			for(var/datum/inquisition_hierarchy_node/position in user_inquisition.all_positions)
				if(REF(position) == position_ref)
					if(can_manage_position(position) && !position.is_school_leader)
						user_inquisition.remove_position(position)
						selected_position = null
						to_chat(user, "<span class='notice'>Position removed successfully.</span>")
					else
						to_chat(user, "<span class='warning'>You don't have permission to remove this position.</span>")
					break
			refresh_hierarchy()

		if("edit_position")
			var/position_ref = href_list["position_id"]
			var/datum/inquisition_hierarchy_node/target_position
			for(var/datum/inquisition_hierarchy_node/position in user_inquisition.all_positions)
				if(REF(position) == position_ref)
					target_position = position
					break

			if(target_position && can_manage_position(target_position))
				selected_position = target_position
				show_edit_position_dialog()
			else
				to_chat(user, "<span class='warning'>You don't have permission to edit this position.</span>")

		if("submit_edit_position")
			if(selected_position && can_manage_position(selected_position))
				handle_edit_position(href_list)
			else
				to_chat(user, "<span class='warning'>You don't have permission to edit this position.</span>")

/datum/inquisition_hierarchy_interface/proc/refresh_hierarchy()
	if(!user_inquisition)
		return

	calculate_hierarchy_positions()

	user << browse_rsc('html/KettleParallaxBG.png')
	user << browse_rsc('html/KettleParallaxNeb.png')

	var/html = generate_hierarchy_html()
	user << browse(html, "window=inquisition_menu;size=1200x800")

/datum/inquisition_hierarchy_interface/proc/handle_create_position(list/params)
	if(!COOLDOWN_FINISHED(src, last_creation))
		return
	COOLDOWN_START(src, last_creation, 0.1 SECONDS)

	if(!can_manage_hierarchy())
		return

	var/position_name = strip_html(params["position_name"], MAX_NAME_LEN)
	var/position_desc = strip_html(params["position_desc"])
	var/superior_ref = params["superior_position"]
	var/rank_level = text2num(params["rank_level"])
	var/max_subordinates = text2num(params["max_subordinates"])
	var/position_color = sanitize_hexcolor(params["position_color"], include_crunch = TRUE)
	var/can_assign = params["can_assign_positions"] ? TRUE : FALSE

	if(!position_name || !superior_ref || !rank_level)
		to_chat(user, "<span class='warning'>Error: Missing required fields</span>")
		return

	var/datum/inquisition_hierarchy_node/superior_position
	for(var/datum/inquisition_hierarchy_node/position in user_inquisition.all_positions)
		if(REF(position) == superior_ref)
			superior_position = position
			break

	if(!superior_position)
		to_chat(user, "<span class='warning'>Error: Invalid superior position</span>")
		return

	if(!can_create_position_under(superior_position))
		to_chat(user, "<span class='warning'>Error: You don't have permission to create positions under [superior_position.name]</span>")
		return

	var/datum/inquisition_hierarchy_node/new_position = user_inquisition.create_position(position_name, position_desc, superior_position, rank_level, selected_school)

	if(new_position)
		new_position.max_subordinates = max_subordinates
		new_position.position_color = position_color
		new_position.can_assign_positions = can_assign
		to_chat(user, "<span class='notice'>Position '[position_name]' created successfully!</span>")
		refresh_hierarchy()
	else
		to_chat(user, "<span class='warning'>Error: Failed to create position</span>")

/datum/inquisition_hierarchy_interface/proc/handle_edit_position(list/params)
	if(!selected_position || !can_manage_position(selected_position))
		to_chat(user, "<span class='warning'>You don't have permission to edit this position.</span>")
		return

	var/position_name = strip_html(params["position_name"], MAX_NAME_LEN)
	var/position_desc = strip_html(params["position_desc"])
	var/max_subordinates = text2num(params["max_subordinates"])
	var/position_color = sanitize_hexcolor(params["position_color"], include_crunch = TRUE)
	var/can_assign = params["can_assign_positions"] ? TRUE : FALSE

	if(!position_name || !max_subordinates)
		to_chat(user, "<span class='warning'>Error: Missing required fields</span>")
		return

	if(max_subordinates < selected_position.subordinates.len)
		to_chat(user, "<span class='warning'>Error: Cannot set max subordinates below current count ([selected_position.subordinates.len])</span>")
		return

	selected_position.name = position_name
	selected_position.desc = position_desc
	selected_position.max_subordinates = max_subordinates
	selected_position.position_color = position_color
	selected_position.can_assign_positions = can_assign

	to_chat(user, "<span class='notice'>Position '[position_name]' updated successfully!</span>")
	refresh_hierarchy()
