
/datum/clan_hierarchy_interface
	var/mob/living/carbon/human/user
	var/datum/clan/user_clan
	var/datum/clan_hierarchy_node/selected_position
	COOLDOWN_DECLARE(last_creation)

/datum/clan_hierarchy_interface/New(mob/living/carbon/human/target_user)
	user = target_user
	user_clan = user.clan
	calculate_hierarchy_positions()
	..()

/datum/clan_hierarchy_interface/proc/can_manage_hierarchy()
	if(!user.clan_position)
		return user == user_clan.clan_leader
	return user.clan_position.can_assign_positions

/datum/clan_hierarchy_interface/proc/can_manage_position(datum/clan_hierarchy_node/target_position)
	if(!target_position)
		return FALSE

	// Clan leader can manage any position
	if(user == user_clan.clan_leader)
		return TRUE

	if(!user.clan_position || !user.clan_position.can_assign_positions)
		return FALSE

	// Can only manage positions within your hierarchy section
	// This includes: direct subordinates, subordinates of subordinates, etc.
	var/list/manageable_positions = user.clan_position.get_all_subordinates()
	return (target_position in manageable_positions)

/datum/clan_hierarchy_interface/proc/can_create_position_under(datum/clan_hierarchy_node/superior_position)
	if(!superior_position)
		return FALSE

	// Clan leader can create anywhere
	if(user == user_clan.clan_leader)
		return TRUE

	if(!user.clan_position || !user.clan_position.can_assign_positions)
		return FALSE

	// Can create under your own position
	if(superior_position == user.clan_position)
		return TRUE

	// Can create under any position in your subordinate tree
	var/list/manageable_positions = user.clan_position.get_all_subordinates()
	return (superior_position in manageable_positions)

// This should match the coven research tree structure - Kinda important since it just replaces the dynamic content with it.
/datum/clan_hierarchy_interface/proc/generate_hierarchy_html()
	if(!user_clan || !user_clan.hierarchy_root)
		return "<div class='error'>No clan hierarchy found</div>"

	var/hierarchy_html = {"
	<div class="parallax-container">
		<div class="parallax-layer parallax-bg" id="parallax-bg"></div>
		<div class="parallax-layer parallax-stars-1" id="parallax-stars-1"></div>
		<div class="parallax-layer parallax-neb" id="parallax-neb"></div>
	</div>
	<div class="research-container" id="container">
		<div class="research-canvas" id="canvas">
			[generate_hierarchy_connections_html()]
			[generate_hierarchy_nodes_html()]
		</div>
	</div>
	<div class="tooltip" id="tooltip" style="display: none; position: absolute; background: rgba(0,0,0,0.9); color: white; padding: 8px; border-radius: 4px; font-size: 12px; z-index: 1001; max-width: 200px; border: 1px solid #444; box-shadow: 0 2px 8px rgba(0,0,0,0.5);"></div>
	[generate_hierarchy_sidebar()]
	[can_manage_hierarchy() ? generate_management_modal() : ""]
	"}

	return hierarchy_html

/datum/clan_hierarchy_interface/proc/calculate_hierarchy_positions()
	if(!user_clan || !user_clan.hierarchy_root)
		return

	var/vertical_spacing = 120
	var/horizontal_spacing = 160
	var/base_x = 400
	var/base_y = 50

	// Start with the root and position recursively
	position_node_and_children(user_clan.hierarchy_root, base_x, base_y, horizontal_spacing, vertical_spacing)

/datum/clan_hierarchy_interface/proc/position_node_and_children(datum/clan_hierarchy_node/node, center_x, y_pos, h_spacing, v_spacing)
	if(!node)
		return 0

	var/subordinate_count = node.subordinates.len

	node.node_x = center_x - 60 // Offset to center the node visual
	node.node_y = y_pos

	if(subordinate_count == 0)
		return h_spacing // Return minimum width needed

	// Calculate total width needed for all subordinates and their children
	var/list/subordinate_widths = list()
	var/total_width = 0

	for(var/datum/clan_hierarchy_node/subordinate in node.subordinates)
		var/width_needed = calculate_subtree_width(subordinate, h_spacing)
		subordinate_widths += width_needed
		total_width += width_needed

	var/start_x = center_x - total_width / 2
	var/current_x = start_x
	var/child_y = y_pos + v_spacing

	for(var/i = 1; i <= subordinate_count; i++)
		var/datum/clan_hierarchy_node/subordinate = node.subordinates[i]
		var/width_for_this_subtree = subordinate_widths[i]
		var/subtree_center = current_x + width_for_this_subtree / 2

		position_node_and_children(subordinate, subtree_center, child_y, h_spacing, v_spacing)

		current_x += width_for_this_subtree

	return max(total_width, h_spacing)

/datum/clan_hierarchy_interface/proc/calculate_subtree_width(datum/clan_hierarchy_node/node, h_spacing)
	if(!node || node.subordinates.len == 0)
		return h_spacing

	var/total_width = 0
	for(var/datum/clan_hierarchy_node/subordinate in node.subordinates)
		total_width += calculate_subtree_width(subordinate, h_spacing)

	return max(total_width, h_spacing)

/datum/clan_hierarchy_interface/proc/generate_hierarchy_connections_html()
	var/html = ""
	var/center_x = 0
	var/center_y = 0

	for(var/datum/clan_hierarchy_node/position in user_clan.all_positions)
		if(!position.superior)
			continue

		var/start_center_x = center_x + position.superior.node_x + 60 // Center of superior node
		var/start_center_y = center_y + position.superior.node_y + 40 // Bottom of superior node
		var/end_center_x = center_x + position.node_x + 60  // Center of current node
		var/end_center_y = center_y + position.node_y + 10  // Top of current node

		// Calculate distance and angle
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

/datum/clan_hierarchy_interface/proc/generate_hierarchy_nodes_html()
	var/html = ""

	for(var/datum/clan_hierarchy_node/position in user_clan.all_positions)
		var/member_name = position.assigned_member ? position.assigned_member.real_name : "Vacant"
		var/node_classes = "hierarchy-node"

		if(position.assigned_member)
			node_classes += " filled"
		else
			node_classes += " vacant"

		if(position == user_clan.hierarchy_root)
			node_classes += " leader"
		if(position == selected_position)
			node_classes += " selected"

		// Create node data JSON for tooltip
		var/list/node_data = list(
			"name" = position.name,
			"desc" = position.desc,
			"member" = member_name,
			"rank_level" = position.rank_level,
			"subordinates" = "[position.subordinates.len]/[position.max_subordinates]",
			"can_assign" = position.can_assign_positions
		)

		var/node_data_json = json_encode(node_data)
		// Escape single quotes in the JSON for HTML attribute safety
		var/escaped_node_data_json = replacetext(node_data_json, "'", "&#39;")

		var/icon_html = ""
		if(position.cloned_look)
			icon_html = ma2html(position.cloned_look, user)

		html += {"<div class="[node_classes]"
			style="left: [position.node_x]px; top: [position.node_y]px; border-color: [position.position_color]; text-align: center; display: flex; flex-direction: column; align-items: center; justify-content: center; width: 120px; height: 80px;"
			data-node-id="[REF(position)]"
			data-user-ref="[REF(user)]"
			data-node-data='[escaped_node_data_json]'
			onclick="selectHierarchyPosition('[REF(position)]')"
			onmouseover="showNodeTooltip(event, '[escaped_node_data_json]')"
			onmouseout="hideNodeTooltip()">

			[icon_html]
			<div style="font-size: 12px; font-weight: bold; color: white; margin-top: 4px;">[position.name]</div>
		</div>"}

	return html


/datum/clan_hierarchy_interface/proc/generate_hierarchy_sidebar()
	var/sidebar_html = {"
	<div class="hierarchy-sidebar" id="hierarchy-sidebar">
		<div class="sidebar-header">
			<h3>Position Details</h3>
			[can_manage_hierarchy() ? "<button onclick='createNewPosition()' class='btn-primary'>Create Position</button>" : ""]
		</div>
		<div class="sidebar-content" id="sidebar-content">
			[selected_position ? generate_position_details_html() : "<p>Select a position to view details</p>"]
		</div>
	</div>

	<style>
		.hierarchy-sidebar {
			position: fixed;
			right: 10px;
			top: 90px; /* Account for header height */
			width: 280px;
			height: calc(100vh - 80px); /* Full height minus header and padding */
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
		}

		.position-actions button {
			display: block;
			width: 100%;
			margin: 5px 0;
			padding: 8px;
			border: none;
			border-radius: 4px;
			cursor: pointer;
			font-size: 12px;
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

		/* Make sidebar responsive */
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

/datum/clan_hierarchy_interface/proc/generate_position_details_html()
	if(!selected_position)
		return "<p>No position selected</p>"

	var/member_info = selected_position.assigned_member ? selected_position.assigned_member.real_name : "Vacant"
	var/can_modify = can_manage_position(selected_position)

	var/html = {"
	<div class="position-details">
		<h4 style="color: #fff; margin-top: 0;">[selected_position.name]</h4>
		<p><strong>Description:</strong> [selected_position.desc]</p>
		<p><strong>Assigned Member:</strong> [member_info]</p>
		<p><strong>Rank Level:</strong> [selected_position.rank_level]</p>
		<p><strong>Subordinates:</strong> [selected_position.subordinates.len]/[selected_position.max_subordinates]</p>
		<p><strong>Can Assign Positions:</strong> [selected_position.can_assign_positions ? "Yes" : "No"]</p>

		[can_modify ? {"
		<div class="position-actions" style="margin-top: 15px;">
			<button onclick='editPosition("[REF(selected_position)]")' class='btn-primary' style='width: 100%; margin-bottom: 5px; padding: 6px; background: #2196F3; color: white; border: none; border-radius: 3px; cursor: pointer;'>Edit Position</button>
			<button onclick='assignMember("[REF(selected_position)]")' class='btn-secondary' style='width: 100%; margin-bottom: 5px; padding: 6px; background: #666; color: white; border: none; border-radius: 3px; cursor: pointer;'>Assign Member</button>
			<button onclick='toggleAssignPermission("[REF(selected_position)]")' class='btn-secondary' style='width: 100%; margin-bottom: 5px; padding: 6px; background: #006600; color: white; border: none; border-radius: 3px; cursor: pointer;'>[selected_position.can_assign_positions ? "Remove" : "Grant"] Assign Permission</button>
			[selected_position != user_clan.hierarchy_root ? "<button onclick='removePosition(\"[REF(selected_position)]\")' class='btn-danger' style='width: 100%; margin-bottom: 5px; padding: 6px; background: #cc0000; color: white; border: none; border-radius: 3px; cursor: pointer;'>Remove Position</button>" : ""]
		</div>
		"} : can_manage_hierarchy() ? {"
		<div class="position-actions" style="margin-top: 15px;">
			<p style="color: #888; font-style: italic; font-size: 11px;">This position is outside your management scope.</p>
		</div>
		"} : ""]
	</div>
	"}

	return html

/datum/clan_hierarchy_interface/proc/generate_management_modal()
	return {"
	<div id="management-modal" class="modal" style="display: none; position: fixed; z-index: 2000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5);">
		<div class="modal-content" style="background-color: #2a2a2a; margin: 10% auto; padding: 20px; border: 1px solid #444; border-radius: 5px; width: 500px; color: #ccc;">
			<span class="close" onclick="closeHierarchyModal()" style="color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer;">&times;</span>
			<h3 id="modal-title" style="color: #fff;">Manage Position</h3>
			<div id="modal-body">
				<!-- Dynamic content goes here -->
			</div>
		</div>
	</div>

	<script>
		var selectedPosition = null;

		function showNodeTooltip(event, nodeDataJson) {
		try {
			var nodeData = JSON.parse(nodeDataJson);
			var tooltip = document.getElementById('tooltip');

			if(tooltip) {
				tooltip.innerHTML = `
					<strong>${nodeData.name}</strong><br>
					<em>${nodeData.desc}</em><br>
					<strong>Member:</strong> ${nodeData.member}<br>
					<strong>Rank Level:</strong> ${nodeData.rank_level}<br>
					<strong>Subordinates:</strong> ${nodeData.subordinates}<br>
					<strong>Can Assign:</strong> ${nodeData.can_assign ? 'Yes' : 'No'}
				`;

				tooltip.style.display = 'block';
				tooltip.style.left = (event.pageX + 10) + 'px';
				tooltip.style.top = (event.pageY + 10) + 'px';
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
			// Remove previous selection
			var prevSelected = document.querySelector('.hierarchy-node.selected');
			if(prevSelected) {
				prevSelected.classList.remove('selected');
			}

			// Add selection to clicked node
			var clickedNode = document.querySelector('\[data-node-id=\"' + positionRef + '\"\]');
			if(clickedNode) {
				clickedNode.classList.add('selected');
				selectedPosition = positionRef;

				// Trigger server-side selection update
				window.location.href = '?src=[REF(src)];action=select_position;position_id=' + positionRef;
			}
		}

		function createNewPosition() {
			window.location.href = '?src=[REF(src)];action=create_position';
		}

		function editPosition(positionRef) {
			window.location.href = '?src=[REF(src)];action=edit_position;position_id=' + positionRef;
		}
		function assignMember(positionRef) {
			window.location.href = '?src=[REF(src)];action=assign_member;position_id=' + positionRef;
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
			document.getElementById('management-modal').style.display = 'none';
		}

		function submitCreatePosition() {
			const form = document.getElementById('create-position-form');
			const formData = new FormData(form);

			let params = '?src=[REF(src)];action=submit_create_position';
			for(let \[key, value\] of formData.entries()) {
				params += ';' + key + '=' + encodeURIComponent(value);
			}

			window.location.href = params;
		}

		function submitAssignMember() {
			const form = document.getElementById('assign-member-form');
			const formData = new FormData(form);

			let params = '?src=[REF(src)];action=submit_assign_member';
			for(let \[key, value\] of formData.entries()) {
				params += ';' + key + '=' + encodeURIComponent(value);
			}

			window.location.href = params;
		}

	</script>
	"}


/datum/clan_hierarchy_interface/proc/show_edit_position_dialog()
	if(!can_manage_position(selected_position))
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
				<label for='edit-rank-level'>Rank Level:</label>
				<input type='number' id='edit-rank-level' name='rank_level' min='1' max='10' value='[selected_position.rank_level]'>
			</div>

			<div class='form-group'>
				<label for='edit-max-subordinates'>Max Subordinates:</label>
				<input type='number' id='edit-max-subordinates' name='max_subordinates' min='1' max='20' value='[selected_position.max_subordinates]'>
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

	// Generate updated HTML with modal open
	var/updated_html = generate_hierarchy_html()
	updated_html = replacetext(updated_html, "<!-- Dynamic content goes here -->", modal_content)

	var/datum/clan_menu_interface/menu = user.clan_menu_interface
	if(menu)
		user << browse(menu.generate_combined_html(updated_html), "window=clan_menu")

/datum/clan_hierarchy_interface/Topic(href, href_list)
	if(!user || !user_clan)
		return

	switch(href_list["action"])
		if("select_position")
			var/position_ref = href_list["position_id"]
			for(var/datum/clan_hierarchy_node/position in user_clan.all_positions)
				if(REF(position) == position_ref)
					selected_position = position
					break
			refresh_hierarchy()

		if("create_position")
			if(can_manage_hierarchy())
				show_create_position_dialog()

		if("submit_create_position")
			if(can_manage_hierarchy())
				handle_create_position(href_list)

		if("assign_member")
			var/position_ref = href_list["position_id"]
			var/datum/clan_hierarchy_node/target_position
			for(var/datum/clan_hierarchy_node/position in user_clan.all_positions)
				if(REF(position) == position_ref)
					target_position = position
					break

			if(target_position && can_manage_position(target_position))
				selected_position = target_position
				show_assign_member_dialog()
			else
				to_chat(user, "<span class='warning'>You don't have permission to assign members to this position.</span>")

		if("submit_assign_member")
			if(selected_position && can_manage_position(selected_position))
				handle_assign_member(href_list)
			else
				to_chat(user, "<span class='warning'>You don't have permission to manage this position.</span>")

		if("toggle_assign_permission")
			var/position_ref = href_list["position_id"]
			for(var/datum/clan_hierarchy_node/position in user_clan.all_positions)
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
			for(var/datum/clan_hierarchy_node/position in user_clan.all_positions)
				if(REF(position) == position_ref)
					if(can_manage_position(position) && position != user_clan.hierarchy_root)
						user_clan.remove_position(position)
						selected_position = null
						to_chat(user, "<span class='notice'>Position removed successfully.</span>")
					else
						to_chat(user, "<span class='warning'>You don't have permission to remove this position.</span>")
					break
			refresh_hierarchy()

		if("edit_position")
			var/position_ref = href_list["position_id"]
			var/datum/clan_hierarchy_node/target_position
			for(var/datum/clan_hierarchy_node/position in user_clan.all_positions)
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


/datum/clan_hierarchy_interface/proc/refresh_hierarchy()
	if(!user_clan)
		return

	calculate_hierarchy_positions()

	var/datum/clan_menu_interface/menu = user.clan_menu_interface
	if(menu)
		menu.show_hierarchy()

/datum/clan_hierarchy_interface/proc/show_create_position_dialog()
	if(!can_manage_hierarchy())
		return

	var/modal_content = {"
	<div class='dialog-content'>
		<h3>Create New Position</h3>
		<form id='create-position-form'>
			<div class='form-group'>
				<label for='position-name'>Position Name:</label>
				<input type='text' id='position-name' name='position_name' required maxlength='50'>
			</div>

			<div class='form-group'>
				<label for='position-desc'>Description:</label>
				<textarea id='position-desc' name='position_desc' rows='3' maxlength='200'></textarea>
			</div>

			<div class='form-group'>
				<label for='superior-position'>Reports To:</label>
				<select id='superior-position' name='superior_position' required>
					<option value=''>Select Superior Position</option>
					[generate_all_position_options()]
				</select>
			</div>

			<div class='form-group'>
				<label for='rank-level'>Rank Level:</label>
				<input type='number' id='rank-level' name='rank_level' min='1' max='10' value='[selected_position ? selected_position.rank_level + 1 : 1]'>
			</div>

			<div class='form-group'>
				<label for='max-subordinates'>Max Subordinates:</label>
				<input type='number' id='max-subordinates' name='max_subordinates' min='1' max='100' value='5'>
			</div>

			<div class='form-group'>
				<label for='position-color'>Position Color:</label>
				<input type='color' id='position-color' name='position_color' value='#ffffff'>
			</div>

			<div class='form-group'>
				<label>
					<input type='checkbox' id='can-assign-positions' name='can_assign_positions' value='1'>
					Can assign subordinate positions
				</label>
			</div>

			<div class='form-actions'>
				<button type='button' onclick='submitCreatePosition()' class='btn-primary'>Create Position</button>
				<button type='button' onclick='closeHierarchyModal()' class='btn-secondary'>Cancel</button>
			</div>
		</form>
	</div>

	<script>
		document.getElementById('management-modal').style.display = 'block';
		document.getElementById('modal-title').textContent = 'Create New Position';
		document.getElementById('modal-body').innerHTML = document.querySelector('.dialog-content').outerHTML;
	</script>
	"}

	// Generate updated HTML with modal open
	var/updated_html = generate_hierarchy_html()
	updated_html = replacetext(updated_html, "<!-- Dynamic content goes here -->", modal_content) //AI Wishes it could replicate this level of thinking

	var/datum/clan_menu_interface/menu = user.clan_menu_interface
	if(menu)
		user << browse(menu.generate_combined_html(updated_html), "window=clan_menu")

/datum/clan_hierarchy_interface/proc/generate_all_position_options()
	var/html = ""

	for(var/datum/clan_hierarchy_node/position in user_clan.all_positions)
		if(position.subordinates.len >= position.max_subordinates)
			continue

		// Check if user can create positions under this position
		if(!can_create_position_under(position))
			continue

		html += "<option value='[REF(position)]'>[position.name] (Level [position.rank_level]) - [position.subordinates.len]/[position.max_subordinates] slots</option>"

	return html

/datum/clan_hierarchy_interface/proc/show_assign_member_dialog()
	if(!can_manage_hierarchy() || !selected_position)
		return

	var/list/available_members = list()
	for(var/mob/living/carbon/human/member in user_clan.clan_members)
		if(!member.clan_position || member.clan_position == selected_position)
			available_members += member

	var/modal_content = {"
	<div class='dialog-content'>
		<h3>Assign Member to [selected_position.name]</h3>
		[selected_position.assigned_member ? "<p><strong>Current Assignment:</strong> [selected_position.assigned_member.real_name]</p>" : "<p><strong>Current Assignment:</strong> Vacant</p>"]
		<form id='assign-member-form'>
			<div class='form-group' style='margin-bottom: 15px;'>
				<label for='member-select' style='display: block; margin-bottom: 5px; color: #fff;'>Select Member:</label>
				<select id='member-select' name='member_ref' required style='width: 100%; padding: 8px; background: #444; color: #fff; border: 1px solid #666; border-radius: 3px;'>
					<option value=''>-- Leave Vacant --</option>
					[generate_member_options(available_members)]
				</select>
			</div>
			<div class='form-actions' style='text-align: right; margin-top: 20px;'>
				<button type='button' onclick='submitAssignMember()' class='btn-primary' style='padding: 8px 16px; background: #0066cc; color: white; border: none; border-radius: 3px; cursor: pointer; margin-right: 10px;'>Assign Member</button>
				<button type='button' onclick='closeHierarchyModal()' class='btn-secondary' style='padding: 8px 16px; background: #666; color: white; border: none; border-radius: 3px; cursor: pointer;'>Cancel</button>
			</div>
		</form>
	</div>

	<script>
		document.getElementById('management-modal').style.display = 'block';
		document.getElementById('modal-title').textContent = '';
		document.getElementById('modal-body').innerHTML = document.querySelector('.dialog-content').outerHTML;
	</script>
	"}

	// Generate updated HTML with modal open
	var/updated_html = generate_hierarchy_html()
	updated_html = replacetext(updated_html, "<!-- Dynamic content goes here -->", modal_content)

	var/datum/clan_menu_interface/menu = user.clan_menu_interface
	if(menu)
		user << browse(menu.generate_combined_html(updated_html), "window=clan_menu")

/datum/clan_hierarchy_interface/proc/generate_position_options()
	var/html = ""

	for(var/datum/clan_hierarchy_node/position in user_clan.all_positions)
		// Allow assignment under any position that has room for subordinates
		// OR if the user has hierarchy management permissions (can override)
		if(position.subordinates.len < position.max_subordinates)
			var/can_assign_under = FALSE

			// Check if current user can assign under this position
			if(can_manage_hierarchy()) // User has full management rights
				can_assign_under = TRUE
			else if(user.clan_position == position && position.can_assign_positions) // User is in this position and has assign rights
				can_assign_under = TRUE
			else if(position.can_assign_positions) // Position itself allows assignments
				can_assign_under = TRUE

			if(can_assign_under)
				html += "<option value='[REF(position)]'>[position.name] (Level [position.rank_level]) - [position.subordinates.len]/[position.max_subordinates]</option>"

	return html

/datum/clan_hierarchy_interface/proc/generate_member_options(list/available_members)
	var/html = ""

	for(var/mob/living/carbon/human/member in available_members)
		if(!member || !member.real_name)
			continue

		// Only show members that can be assigned to positions we can manage
		if(member.clan_position && !can_manage_position(member.clan_position))
			continue

		html += "<option value='[REF(member)]'>[member.real_name]</option>"

	return html


/datum/clan_hierarchy_interface/proc/handle_edit_position(list/params)
	if(!selected_position || !can_manage_position(selected_position))
		to_chat(user, "<span class='warning'>You don't have permission to edit this position.</span>")
		return

	var/position_name = strip_html(params["position_name"], MAX_NAME_LEN)
	var/position_desc = strip_html(params["position_desc"])
	var/rank_level = text2num(params["rank_level"])
	var/max_subordinates = text2num(params["max_subordinates"])
	var/position_color = sanitize_hexcolor(params["position_color"])
	var/can_assign = params["can_assign_positions"] ? TRUE : FALSE

	if(!position_name || !max_subordinates)
		to_chat(user, "<span class='warning'>Error: Missing required fields</span>")
		return

	// Validate max_subordinates - can't be less than current subordinates
	if(max_subordinates < selected_position.subordinates.len)
		to_chat(user, "<span class='warning'>Error: Cannot set max subordinates below current count ([selected_position.subordinates.len])</span>")
		return

	// Update the position
	selected_position.name = position_name
	selected_position.desc = position_desc
	selected_position.rank_level = rank_level
	selected_position.max_subordinates = max_subordinates
	selected_position.position_color = position_color
	selected_position.can_assign_positions = can_assign

	to_chat(user, "<span class='notice'>Position '[position_name]' updated successfully!</span>")
	refresh_hierarchy()

/datum/clan_hierarchy_interface/proc/handle_create_position(list/params)
	if(!COOLDOWN_FINISHED(src, last_creation))
		return
	COOLDOWN_START(src, last_creation, 0.1 SECONDS) //

	if(!can_manage_hierarchy())
		return

	var/position_name = strip_html(params["position_name"], MAX_NAME_LEN)
	var/position_desc = strip_html(params["position_desc"])
	var/superior_ref = params["superior_position"]
	var/rank_level = text2num(params["rank_level"])
	var/max_subordinates = text2num(params["max_subordinates"])
	var/position_color = sanitize_hexcolor(params["position_color"])
	var/can_assign = params["can_assign_positions"] ? TRUE : FALSE

	if(!position_name || !superior_ref || !rank_level)
		to_chat(user, "<span class='warning'>Error: Missing required fields</span>")
		return

	// Find the superior position
	var/datum/clan_hierarchy_node/superior_position
	for(var/datum/clan_hierarchy_node/position in user_clan.all_positions)
		if(REF(position) == superior_ref)
			superior_position = position
			break

	if(!superior_position)
		to_chat(user, "<span class='warning'>Error: Invalid superior position</span>")
		return

	// Check if user can create position under this superior
	if(!can_create_position_under(superior_position))
		to_chat(user, "<span class='warning'>Error: You don't have permission to create positions under [superior_position.name]</span>")
		return

	var/datum/clan_hierarchy_node/new_position = user_clan.create_position(position_name, position_desc, superior_position, rank_level)

	if(new_position)
		new_position.max_subordinates = max_subordinates
		new_position.position_color = position_color
		new_position.can_assign_positions = can_assign
		to_chat(user, "<span class='notice'>Position '[position_name]' created successfully!</span>")
		refresh_hierarchy()
	else
		to_chat(user, "<span class='warning'>Error: Failed to create position</span>")

/datum/clan_hierarchy_interface/proc/handle_assign_member(list/params)
	if(!selected_position || !can_manage_position(selected_position))
		to_chat(user, "<span class='warning'>You don't have permission to manage this position.</span>")
		return

	var/member_ref = params["member_ref"]

	if(!member_ref)
		selected_position.remove_member()
		to_chat(user, "<span class='notice'>Position vacated successfully</span>")
		refresh_hierarchy()
		return

	var/mob/living/carbon/human/target_member
	for(var/mob/living/carbon/human/member in user_clan.clan_members)
		if(REF(member) == member_ref)
			target_member = member
			break

	if(!target_member)
		to_chat(user, "<span class='warning'>Error: Invalid member selection</span>")
		return

	// Check if the member currently has a position we can't manage
	if(target_member.clan_position && !can_manage_position(target_member.clan_position))
		to_chat(user, "<span class='warning'>Error: You don't have permission to reassign [target_member.real_name] from their current position</span>")
		return

	if(selected_position.assign_member(target_member))
		to_chat(user, "<span class='notice'>[target_member.real_name] assigned to [selected_position.name]</span>")
		refresh_hierarchy()
	else
		to_chat(user, "<span class='warning'>Error: Failed to assign member</span>")

