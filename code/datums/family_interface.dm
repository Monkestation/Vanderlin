
/datum/family_tree_interface
	var/datum/heritage/current_family
	var/mob/viewer

/datum/family_tree_interface/New(datum/heritage/family, mob/user)
	current_family = family
	viewer = user

/datum/family_tree_interface/proc/show_interface()
	var/html = generate_interface_html()
	viewer << browse(html, "window=family_tree;size=800x600")

/datum/family_tree_interface/proc/generate_interface_html()
	var/html = {"
	<html>
	<head>
		<style>
			body {
				margin: 0;
				padding: 0;
				background: #000;
				color: #eee;
				font-family: Arial, sans-serif;
				overflow: hidden;
			}

			.family-tree-container {
				position: relative;
				width: 100%;
				height: 100vh;
				overflow: hidden;
				cursor: grab;
			}

			.family-canvas {
				position: absolute;
				transform-origin: 0 0;
			}

			.connection-line {
				position: absolute;
				height: 2px;
				background: linear-gradient(90deg,
					rgba(255,215,0,0.8) 0%,
					rgba(218,165,32,0.6) 50%,
					rgba(255,215,0,0.4) 100%);
				transform-origin: left center;
				z-index: 1;
				border-radius: 1px;
				box-shadow: 0 0 4px rgba(255,215,0,0.3);
			}

			.spouse-connection {
				position: absolute;
				height: 3px;
				background: linear-gradient(90deg,
					rgba(255,20,147,0.8) 0%,
					rgba(255,105,180,0.6) 50%,
					rgba(255,20,147,0.4) 100%);
				transform-origin: left center;
				z-index: 1;
				border-radius: 1px;
				box-shadow: 0 0 4px rgba(255,20,147,0.3);
			}

			.family-node {
				position: absolute;
				width: 64px;
				height: 64px;
				display: flex;
				align-items: center;
				justify-content: center;
				cursor: pointer;
				transition: all 0.2s;
				z-index: 2;
			}

			.node-border {
				width: 64px;
				height: 64px;
				border: 3px solid;
				border-radius: 50%;
				overflow: hidden;
				box-shadow: 0 0 10px rgba(0,0,0,0.5);
				position: relative;
				display: flex;
				align-items: center;
				justify-content: center;
			}

			/* Blood family members */
			.founder .node-border {
				border-color: #4169E1;
				box-shadow: 0 0 15px rgba(65,105,225,0.6);
			}
			.child .node-border {
				border-color: #32CD32;
				box-shadow: 0 0 10px rgba(50,205,50,0.4);
			}
			.relative .node-border {
				border-color: #9370DB;
				box-shadow: 0 0 10px rgba(147,112,219,0.4);
			}

			/* Married-in family members - distinct styling */
			.spouse .node-border {
				border-color: #FF69B4;
				border-style: dashed;
				box-shadow: 0 0 10px rgba(255,105,180,0.4);
			}
			.married-in .node-border {
				border-color: #FF1493;
				border-style: dotted;
				box-shadow: 0 0 8px rgba(255,20,147,0.3);
			}

			/* Adopted family members */
			.adopted .node-border {
				border-color: #FFD700;
				border-style: double;
				border-width: 4px;
				box-shadow: 0 0 12px rgba(255,215,0,0.5);
			}

			.family-node .character-preview {
				width: 32px;
				height: 32px;
				image-rendering: pixelated;
				image-rendering: -moz-crisp-edges;
				image-rendering: crisp-edges;
			}

			.family-node:hover {
				transform: scale(1.2);
				z-index: 100;
			}

			.tooltip {
				position: absolute;
				background: rgba(0,0,0,0.95);
				border: 2px solid #444;
				padding: 12px;
				border-radius: 8px;
				display: none;
				z-index: 1000;
				max-width: 250px;
				box-shadow: 0 4px 12px rgba(0,0,0,0.7);
			}

			.tooltip .name {
				font-size: 14px;
				font-weight: bold;
				margin-bottom: 4px;
				color: #fff;
			}

			.tooltip .role {
				font-size: 12px;
				color: #ccc;
				margin-bottom: 6px;
			}

			.tooltip .details {
				font-size: 11px;
				color: #aaa;
				line-height: 1.3;
			}

			.controls {
				position: absolute;
				top: 10px;
				left: 10px;
				z-index: 1000;
				background: rgba(0,0,0,0.9);
				padding: 12px;
				border-radius: 8px;
				border: 2px solid #444;
				box-shadow: 0 4px 12px rgba(0,0,0,0.7);
			}

			.control-button {
				background: #1a472a;
				color: #0f0;
				padding: 6px 12px;
				border: 1px solid #0f0;
				border-radius: 4px;
				cursor: pointer;
				margin: 3px;
				font-size: 12px;
				display: inline-block;
				transition: all 0.2s;
			}

			.control-button:hover {
				background: #2a573a;
				box-shadow: 0 0 8px #0f0;
				transform: translateY(-1px);
			}

			.member-details {
				position: absolute;
				top: 60px;
				right: 10px;
				width: 280px;
				background: rgba(0,0,0,0.95);
				border: 2px solid #444;
				padding: 18px;
				border-radius: 8px;
				display: none;
				z-index: 1000;
				box-shadow: 0 4px 12px rgba(0,0,0,0.7);
			}

			.legend {
				position: absolute;
				bottom: 10px;
				left: 10px;
				z-index: 1000;
				background: rgba(0,0,0,0.9);
				padding: 12px;
				border-radius: 8px;
				border: 2px solid #444;
				box-shadow: 0 4px 12px rgba(0,0,0,0.7);
				font-size: 11px;
			}

			.legend-item {
				display: flex;
				align-items: center;
				margin: 4px 0;
			}

			.legend-circle {
				width: 16px;
				height: 16px;
				border-radius: 50%;
				margin-right: 8px;
				border: 2px solid;
			}

			.legend-founder { border-color: #4169E1; }
			.legend-child { border-color: #32CD32; }
			.legend-spouse { border-color: #FF69B4; border-style: dashed; }
			.legend-adopted { border-color: #FFD700; border-style: double; border-width: 3px; }
			.legend-relative { border-color: #9370DB; }
		</style>
	</head>
	<body>
		<div class="family-tree-container" id="container">
			<div class="controls">
				<div style="margin-bottom: 8px; font-weight: bold;">Family Tree: [current_family.housename]</div>
				<button class="control-button" onclick="resetView()">Reset View</button>
				<button class="control-button" onclick="centerTree()">Center Tree</button>
				<button class="control-button" onclick="toggleCompact()">Toggle Layout</button>
			</div>
			<div class="family-canvas" id="canvas">
				[generate_family_connections()]
				[generate_family_nodes()]
			</div>
			<div class="member-details" id="memberDetails">
				<h3 id="memberName">Select a member</h3>
				<div id="memberInfo"></div>
			</div>
			<div class="legend">
				<div style="font-weight: bold; margin-bottom: 6px;">Legend:</div>
				<div class="legend-item"><div class="legend-circle legend-founder"></div>Founder</div>
				<div class="legend-item"><div class="legend-circle legend-child"></div>Blood Family</div>
				<div class="legend-item"><div class="legend-circle legend-spouse"></div>Married In</div>
				<div class="legend-item"><div class="legend-circle legend-adopted"></div>Adopted</div>
				<div class="legend-item"><div class="legend-circle legend-relative"></div>Extended</div>
			</div>
		</div>
		<div class="tooltip" id="tooltip">
			<div class="name"></div>
			<div class="role"></div>
			<div class="details"></div>
		</div>

		<script>
			let isDragging = false;
			let startX, startY;
			let currentX = 400, currentY = 300;
			let scale = 1;
			let compactMode = false;

			const container = document.getElementById('container');
			const canvas = document.getElementById('canvas');
			const tooltip = document.getElementById('tooltip');
			const memberDetails = document.getElementById('memberDetails');

			function updateTransform() {
				canvas.style.transform = `translate(${currentX}px, ${currentY}px) scale(${scale})`;
			}

			function resetView() {
				currentX = 400;
				currentY = 300;
				scale = 1;
				updateTransform();
			}

			function centerTree() {
				const nodes = document.querySelectorAll('.family-node');
				if (nodes.length === 0) return;

				let minX = Infinity, maxX = -Infinity;
				let minY = Infinity, maxY = -Infinity;

				nodes.forEach(node => {
					const rect = node.getBoundingClientRect();
					const x = parseInt(node.style.left);
					const y = parseInt(node.style.top);
					minX = Math.min(minX, x);
					maxX = Math.max(maxX, x);
					minY = Math.min(minY, y);
					maxY = Math.max(maxY, y);
				});

				const centerX = (minX + maxX) / 2;
				const centerY = (minY + maxY) / 2;

				currentX = window.innerWidth / 2 - centerX * scale;
				currentY = window.innerHeight / 2 - centerY * scale;
				updateTransform();
			}

			function toggleCompact() {
				compactMode = !compactMode;
				// This would trigger a server-side layout recalculation
				// For now, just re-center
				centerTree();
			}

			function showMemberDetails(node) {
				const name = node.dataset.name;
				const role = node.dataset.role;
				const species = node.dataset.species;
				const generation = node.dataset.generation;
				const adopted = node.dataset.adopted;
				const marriedIn = node.dataset.marriedIn;

				document.getElementById('memberName').textContent = name;

				let info = `<strong>Role:</strong> ${role}<br>`;
				if (species) info += `<strong>Species:</strong> ${species}<br>`;
				info += `<strong>Generation:</strong> ${generation}<br>`;
				if (adopted === 'true') info += `<em>Adopted Family Member</em><br>`;
				if (marriedIn === 'true') info += `<em>Married into Family</em><br>`;

				document.getElementById('memberInfo').innerHTML = info;
				memberDetails.style.display = 'block';
			}

			container.addEventListener('mousedown', function(e) {
				if (e.target === container || e.target === canvas) {
					isDragging = true;
					startX = e.clientX - currentX;
					startY = e.clientY - currentY;
					container.style.cursor = 'grabbing';
				}
			});

			document.addEventListener('mousemove', function(e) {
				if (isDragging) {
					currentX = e.clientX - startX;
					currentY = e.clientY - startY;
					updateTransform();
				}
			});

			document.addEventListener('mouseup', function() {
				isDragging = false;
				container.style.cursor = 'grab';
			});

			container.addEventListener('wheel', function(e) {
				e.preventDefault();
				const delta = e.deltaY > 0 ? -0.1 : 0.1;
				scale = Math.max(0.3, Math.min(3, scale + delta));
				updateTransform();
			});

			document.addEventListener('mouseover', function(e) {
				if (e.target.classList.contains('family-node')) {
					const tooltip = document.getElementById('tooltip');
					const name = e.target.dataset.name;
					const role = e.target.dataset.role;
					const species = e.target.dataset.species;
					const adopted = e.target.dataset.adopted;
					const marriedIn = e.target.dataset.marriedIn;

					tooltip.querySelector('.name').textContent = name;
					tooltip.querySelector('.role').textContent = role;

					let details = '';
					if (species) details += `Species: ${species}`;
					if (adopted === 'true') details += details ? ' • Adopted' : 'Adopted';
					if (marriedIn === 'true') details += details ? ' • Married In' : 'Married In';

					tooltip.querySelector('.details').textContent = details;
					tooltip.style.display = 'block';
					tooltip.style.left = e.pageX + 15 + 'px';
					tooltip.style.top = e.pageY + 15 + 'px';
				}
			});

			document.addEventListener('mouseout', function(e) {
				if (e.target.classList.contains('family-node')) {
					document.getElementById('tooltip').style.display = 'none';
				}
			});

			updateTransform();
		</script>
	</body>
	</html>
	"}
	return html

/datum/family_tree_interface/proc/generate_family_nodes()
	var/html = ""
	var/list/node_positions = calculate_node_positions()

	for(var/datum/family_member/member in current_family.members)
		var/list/pos = node_positions[member]
		if(!pos)
			continue

		var/node_class = get_node_class(member)
		var/role_title = get_role_title(member)

		html += generate_node(member, pos["x"], pos["y"], node_class, role_title)

	return html

/datum/family_tree_interface/proc/get_node_class(datum/family_member/member)
	if(member == current_family.founder)
		return "founder"
	if(member.adoption_status)
		return "adopted"

	// Check if this person married into the family (not blood related)
	var/is_blood_related = is_blood_family_member(member)

	// If they have a spouse and aren't blood related, they married in
	if(!is_blood_related && member.spouses && member.spouses.len > 0)
		return "married-in"

	// If they have a spouse (and are blood related)
	if(member.spouses && member.spouses.len > 0)
		return "spouse"

	if(member.children && member.children.len > 0)
		return "relative"

	return "child"

/datum/family_tree_interface/proc/is_blood_family_member(datum/family_member/member)
	// Check if member is blood related to founder
	if(member == current_family.founder)
		return TRUE

	// Check if they're a descendant of the founder
	if(is_descendant_of_founder(member))
		return TRUE

	// Check if they have blood family parents in the tree
	for(var/datum/family_member/parent in member.parents)
		if(parent == current_family.founder || is_descendant_of_founder(parent))
			return TRUE

	return FALSE

/datum/family_tree_interface/proc/is_descendant_of_founder(datum/family_member/member)
	var/list/checked = list()
	var/list/to_check = list(member)

	while(to_check.len)
		var/datum/family_member/current = to_check[1]
		to_check -= current

		if(current in checked)
			continue
		checked += current

		for(var/datum/family_member/parent in current.parents)
			if(parent == current_family.founder)
				return TRUE
			if(!(parent in checked))
				to_check += parent

	return FALSE

/datum/family_tree_interface/proc/get_role_title(datum/family_member/member)
	if(member == current_family.founder)
		return "Founder"

	if(member.adoption_status)
		return "Adopted [member.person.gender == MALE ? "Son" : "Daughter"]"

	// Check relationship to founder
	if(member in current_family.founder.children)
		return member.person.gender == MALE ? "Son" : "Daughter"

	if(member in current_family.founder.spouses)
		return member.person.gender == MALE ? "Husband" : "Wife"

	// Check if grandchild
	for(var/datum/family_member/child in current_family.founder.children)
		if(member in child.children)
			return member.person.gender == MALE ? "Grandson" : "Granddaughter"

	// Check if married into family
	if(!is_blood_family_member(member))
		// Find their spouse to determine relationship
		for(var/datum/family_member/spouse in member.spouses)
			if(is_blood_family_member(spouse))
				var/spouse_relation = get_role_title(spouse)
				switch(spouse_relation)
					if("Son", "Daughter")
						return member.person.gender == MALE ? "Son-in-law" : "Daughter-in-law"
					if("Grandson", "Granddaughter")
						return member.person.gender == MALE ? "Grandson-in-law" : "Granddaughter-in-law"
				return member.person.gender == MALE ? "Brother-in-law" : "Sister-in-law"

	// Default based on generation
	switch(member.generation)
		if(0)
			return "Founder"
		if(1)
			return member.person.gender == MALE ? "Son" : "Daughter"
		if(2)
			return member.person.gender == MALE ? "Grandson" : "Granddaughter"
		else
			return "Descendant"

/datum/family_tree_interface/proc/calculate_node_positions()
	var/list/positions = list()
	var/vertical_spacing = 150
	var/min_node_spacing = 80
	var/family_group_spacing = min_node_spacing * 2  // Space between different family units

	// Group members by generation
	var/list/members_by_gen = list()
	for(var/datum/family_member/member in current_family.members)
		var/gen_key = "[member.generation]"
		if(!members_by_gen[gen_key])
			members_by_gen[gen_key] = list()
		members_by_gen[gen_key] += member

	// Find max generation
	var/max_gen = 0
	for(var/gen_key in members_by_gen)
		max_gen = max(max_gen, text2num(gen_key))

	// Start with founders
	if(members_by_gen["0"])
		var/x_pos = 0
		var/datum/family_member/last_family = null
		for(var/datum/family_member/founder in members_by_gen["0"])
			// Add spacing between different family units
			if(last_family && !are_siblings(founder, last_family) && !(founder in last_family.spouses))
				x_pos += family_group_spacing

			positions[founder] = list("x" = x_pos, "y" = 0)
			x_pos += min_node_spacing

			// Place spouses right next to founder
			for(var/datum/family_member/spouse in founder.spouses)
				if((spouse in current_family.members) && spouse.generation == 0)
					positions[spouse] = list("x" = x_pos, "y" = 0)
					x_pos += min_node_spacing

			last_family = founder

	// Position remaining generations
	for(var/gen = 1 to max_gen)
		var/gen_key = "[gen]"
		if(!members_by_gen[gen_key])
			continue

		var/x_pos = 0
		var/last_parent = null
		for(var/datum/family_member/member in members_by_gen[gen_key])
			if(member in positions) // Skip if already positioned (as a spouse)
				continue

			// Add spacing between different family groups
			var/datum/family_member/parent = null
			if(member.parents.len)
				for(var/datum/family_member/possible_parent in member.parents)
					if(possible_parent in current_family.members)
						parent = possible_parent
						break

			if(last_parent && parent && last_parent != parent && !are_siblings(last_parent, parent))
				x_pos += family_group_spacing

			positions[member] = list("x" = x_pos, "y" = gen * vertical_spacing)
			x_pos += min_node_spacing

			// Place spouses right next to member
			for(var/datum/family_member/spouse in member.spouses)
				if((spouse in current_family.members) && spouse.generation == gen && !(spouse in positions))
					positions[spouse] = list("x" = x_pos, "y" = gen * vertical_spacing)
					x_pos += min_node_spacing

			if(parent)
				last_parent = parent

	// Center each generation
	for(var/gen = 0 to max_gen)
		var/gen_key = "[gen]"
		if(!members_by_gen[gen_key])
			continue

		var/leftmost = 999999
		var/rightmost = -999999
		for(var/datum/family_member/member in members_by_gen[gen_key])
			if(member in positions)
				leftmost = min(leftmost, positions[member]["x"])
				rightmost = max(rightmost, positions[member]["x"])

		var/center_offset = -(leftmost + rightmost) / 2
		for(var/datum/family_member/member in members_by_gen[gen_key])
			if(member in positions)
				positions[member]["x"] += center_offset

	return positions

/datum/family_tree_interface/proc/build_family_clusters()
	var/list/by_generation = list()
	var/list/family_clusters = list()

	// Group by generation first
	for(var/datum/family_member/member in current_family.members)
		var/gen = member.generation
		if(!by_generation["[gen]"])
			by_generation["[gen]"] = list()
		by_generation["[gen]"] += member

	// For each generation, create clusters based on family relationships
	for(var/gen_key in by_generation)
		var/list/gen_members = by_generation[gen_key]
		var/list/clusters = list()
		var/list/processed = list()

		for(var/datum/family_member/member in gen_members)
			if(member in processed)
				continue

			// Start a new cluster with this member
			var/list/cluster = list(member)
			processed += member

			// Always group spouses together - this is the key improvement
			for(var/datum/family_member/spouse in member.spouses)
				if((spouse in gen_members) && !(spouse in processed))
					cluster += spouse
					processed += spouse

			// Find nuclear family units (parents and their children)
			// For each spouse pair, add their children to the same cluster if in this generation
			var/list/family_spouses = list(member) + member.spouses
			for(var/datum/family_member/family_spouse in family_spouses)
				// Get siblings (people who share parents with this member)
				for(var/datum/family_member/sibling in gen_members)
					if(sibling in processed)
						continue
					if(are_siblings(member, sibling))
						cluster += sibling
						processed += sibling
						// Add sibling's spouse too
						for(var/datum/family_member/sibling_spouse in sibling.spouses)
							if((sibling_spouse in gen_members) && !(sibling_spouse in processed))
								cluster += sibling_spouse
								processed += sibling_spouse

			clusters += list(cluster)

		family_clusters[gen_key] = clusters

	return family_clusters

/datum/family_tree_interface/proc/are_siblings(datum/family_member/member1, datum/family_member/member2)
	if(!member1.parents.len || !member2.parents.len)
		return FALSE

	// Check if they share at least one parent
	for(var/datum/family_member/parent1 in member1.parents)
		for(var/datum/family_member/parent2 in member2.parents)
			if(parent1 == parent2)
				return TRUE
	return FALSE

/datum/family_tree_interface/proc/generate_node(datum/family_member/member, x, y, class, role_title)
	var/status_color
	var/is_married_in = !is_blood_family_member(member) && member != current_family.founder

	switch(class)
		if("founder")
			status_color = "#4169E1" // Royal Blue
		if("married-in")
			status_color = "#FF1493" // Deep Pink
		if("spouse")
			status_color = "#FF69B4" // Hot Pink
		if("child")
			status_color = "#32CD32" // Lime Green
		if("adopted")
			status_color = "#FFD700" // Gold
		if("relative")
			status_color = "#9370DB" // Medium Purple
		else
			status_color = "#FFFFFF" // White

	// Use ma2html for character preview
	var/image_data = ma2html(member.cloned_look, viewer)

	return {"
	<div class="family-node [class]" style="left: [x]px; top: [y]px"
		data-name="[member.person.real_name]"
		data-role="[role_title]"
		data-species="[member.person.dna?.species?.name || "Unknown"]"
		data-generation="[member.generation]"
		data-adopted="[member.adoption_status ? "true" : "false"]"
		data-married-in="[is_married_in ? "true" : "false"]"
		onclick="showMemberDetails(this)">
		<div class="node-border" style="border-color: [status_color]">
			<div class="character-preview">[image_data]</div>
		</div>
	</div>
	"}

/datum/family_tree_interface/proc/draw_connection(start_x, start_y, end_x, end_y)
	var/dx = end_x - start_x
	var/dy = end_y - start_y
	var/distance = sqrt(dx*dx + dy*dy)

	if(distance == 0)
		return ""

	var/angle = arctan(dx, dy)
	if(angle < 0)
		angle += 360

	return {"<div class="connection-line" style="
		left: [start_x]px;
		top: [start_y - 1]px;
		width: [distance]px;
		transform: rotate([angle]deg);
		transform-origin: 0 50%;
		z-index: 1;
	"></div>"}

/datum/family_tree_interface/proc/draw_spouse_connection(start_x, start_y, end_x, end_y)
	var/dx = end_x - start_x
	var/dy = end_y - start_y
	var/distance = sqrt(dx*dx + dy*dy)

	if(distance == 0)
		return ""

	var/angle = arctan(dx, dy)
	if(angle < 0)
		angle += 360

	return {"<div class="spouse-connection" style="
		left: [start_x]px;
		top: [start_y - 1.5]px;
		width: [distance]px;
		transform: rotate([angle]deg);
		transform-origin: 0 50%;
		z-index: 1;
	"></div>"}

/datum/family_tree_interface/proc/generate_family_connections()
	var/html = ""
	var/list/node_positions = calculate_node_positions()

	// Draw parent-child connections FROM parent TO child
	for(var/datum/family_member/member in current_family.members)
		if(!member.parents.len)
			continue

		var/list/child_pos = node_positions[member]
		if(!child_pos)
			continue

		for(var/datum/family_member/parent in member.parents)
			var/list/parent_pos = node_positions[parent]
			if(!parent_pos)
				continue

			// Connect from center of parent to center of child
			var/start_center_x = parent_pos["x"] + 32  // Center of 64px wide node
			var/start_center_y = parent_pos["y"] + 32  // Center of node
			var/end_center_x = child_pos["x"] + 32     // Center of child node
			var/end_center_y = child_pos["y"] + 32     // Center of child node

			html += draw_connection(start_center_x, start_center_y, end_center_x, end_center_y)

	// Draw spouse connections
	var/list/drawn_spouse_pairs = list()
	for(var/datum/family_member/member in current_family.members)
		if(!member.spouses.len)
			continue

		var/list/pos1 = node_positions[member]
		if(!pos1)
			continue

		for(var/datum/family_member/spouse in member.spouses)
			var/list/pos2 = node_positions[spouse]
			if(!pos2)
				continue

			// Avoid drawing the same connection twice
			var/pair_key = "[min(REF(member), REF(spouse))]-[max(REF(member), REF(spouse))]"
			if(pair_key in drawn_spouse_pairs)
				continue
			drawn_spouse_pairs += pair_key

			// Connect center to center for spouses
			var/start_center_x = pos1["x"] + 32    // Center X
			var/start_center_y = pos1["y"] + 32    // Center Y
			var/end_center_x = pos2["x"] + 32      // Center X
			var/end_center_y = pos2["y"] + 32      // Center Y

			html += draw_spouse_connection(start_center_x, start_center_y, end_center_x, end_center_y)

	return html

/datum/controller/subsystem/familytree/proc/show_family_tree(datum/heritage/family, mob/user)
	var/datum/family_tree_interface/interface = new(family, user)
	interface.show_interface()
/client/proc/family_tree_debug_menu()
	set name = "Family Tree Debug Menu"
	set category = "Debug.Debug"

	var/html = {"
	<html>
	<head>
		<style>
			body {
				font-family: Arial, sans-serif;
				margin: 20px;
				background: #1a1a1a;
				color: #eee;
			}
			.container {
				max-width: 1000px;
				margin: 0 auto;
				background: #2a2a2a;
				padding: 20px;
				border-radius: 10px;
				border: 1px solid #444;
			}
			.section {
				margin-bottom: 30px;
				padding: 15px;
				border: 1px solid #444;
				border-radius: 5px;
				background: #333;
			}
			.family-card {
				border: 1px solid #666;
				margin: 10px 0;
				padding: 10px;
				border-radius: 5px;
				background: #3a3a3a;
				cursor: pointer;
				transition: all 0.2s;
			}
			.family-card:hover {
				background: #4a4a4a;
				border-color: #0f0;
			}
			.button {
				background: #1a472a;
				color: #0f0;
				padding: 10px 15px;
				border: 1px solid #0f0;
				border-radius: 5px;
				cursor: pointer;
				margin: 5px;
				display: inline-block;
				text-decoration: none;
			}
			.button:hover {
				background: #2a573a;
				box-shadow: 0 0 10px #0f0;
			}
			.button.large {
				background: #472a1a;
				border-color: #f90;
				color: #f90;
			}
			.button.large:hover {
				background: #573a2a;
				box-shadow: 0 0 10px #f90;
			}
			.button.royal {
				background: #2a1a47;
				border-color: #c090ff;
				color: #c090ff;
			}
			.button.royal:hover {
				background: #3a2a57;
				box-shadow: 0 0 10px #c090ff;
			}
		</style>
	</head>
	<body>
		<div class="container">
			<h1>Family Tree Debug Menu</h1>

			<div class="section">
				<h2>Quick Actions</h2>
				<a href="?src=\ref[src];action=view_royal" class="button royal">View Royal Family</a>
				<a href="?src=\ref[src];action=generate_test" class="button">Generate Test Family</a>
				<a href="?src=\ref[src];action=generate_large" class="button large">Generate Large Dynasty</a>
				<a href="?src=\ref[src];action=list_all" class="button">List All Families</a>
			</div>

			<div class="section">
				<h2>Active Families</h2>
				<div id="family-list">
					[generate_new_family_list()]
				</div>
			</div>
		</div>
	</body>
	</html>
	"}

	usr << browse(html, "window=family_debug;size=1000x800")

/proc/generate_new_family_list()
	var/list/output = list()
	var/debug_info = list()

	// Add debug information
	debug_info += "<div class='debug-info'>"
	debug_info += "Debug Info:<br>"

	// Check if SSfamilytree exists
	if(!SSfamilytree)
		debug_info += "ERROR: SSfamilytree subsystem not found!<br>"
	else
		debug_info += "SSfamilytree found<br>"

		// Check if families list exists
		if(!SSfamilytree.families)
			debug_info += "ERROR: SSfamilytree.families is null!<br>"
		else if(!islist(SSfamilytree.families))
			debug_info += "ERROR: SSfamilytree.families is not a list!<br>"
		else
			debug_info += "Families list found, length: [SSfamilytree.families.len]<br>"

		// Normal processing
		for(var/datum/heritage/H in SSfamilytree.families)
			if(H)
				output += generate_new_family_entry(H)
			else
				debug_info += "Found null heritage entry<br>"

	debug_info += "</div>"

	// Add debug info first
	output = debug_info + output

	if(!output.len || output.len == 1) // Only debug info
		output += "<div class='family-card'>"
		output += "<h3>No Families Found</h3>"
		output += "<div>Either no families exist or there's an issue accessing them.</div>"
		output += "<div>Check the debug information above.</div>"
		output += "</div>"

	return output.Join()

/proc/generate_new_family_entry(datum/heritage/H)
	if(!H)
		return "<div class='family-card'><h3>NULL HERITAGE</h3></div>"

	var/house_ref = "\ref[H]"
	var/html = "<div class='family-card' onclick='window.location=\"?src=\ref[usr.client];action=view_tree;family=[house_ref]\"'>"

	// Safe access to housename
	var/house_name = "Unnamed House"
	if(H.housename)
		house_name = H.housename
	html += "<h3>[house_name]</h3>"

	// Safe member counting
	var/member_count = 0
	var/adopted_count = 0
	if(H.members && islist(H.members))
		member_count = H.members.len
		for(var/datum/family_member/member in H.members)
			if(member && member.adoption_status)
				adopted_count++

	var/founder_name = "None"
	if(H.founder)
		if(H.founder.person && H.founder.person.real_name)
			founder_name = H.founder.person.real_name
		else if(istype(H.founder, /mob) && H.founder.person:real_name)
			founder_name = H.founder.person:real_name
		else
			founder_name = "Unknown"

	html += "<div>Members: [member_count] ([adopted_count] adopted)</div>"
	html += "<div>Founder: [founder_name]</div>"
	html += "<div style='text-align: right; font-style: italic;'>Click to view family tree</div>"
	html += "</div>"
	return html

/client/Topic(href, list/href_list)
	. = ..()

	if(!check_rights(R_DEBUG, FALSE))
		return

	switch(href_list["action"])
		if("view_royal")
			if(SSfamilytree?.ruling_family)
				var/datum/family_tree_interface/interface = new(SSfamilytree.ruling_family, usr)
				interface.show_interface()
			else
				to_chat(usr, "No royal family found!")
		if("view_tree")
			var/datum/heritage/H = locate(href_list["family"])
			if(H)
				var/datum/family_tree_interface/interface = new(H, usr)
				interface.show_interface()
			else
				to_chat(usr, "Could not locate family!")
		if("generate_test")
			var/datum/heritage/test_family = generate_test_family_new()
			var/datum/family_tree_interface/interface = new(test_family, usr)
			interface.show_interface()
		if("generate_large")
			var/datum/heritage/large_family = generate_large_dynasty()
			var/datum/family_tree_interface/interface = new(large_family, usr)
			interface.show_interface()

/proc/generate_test_family_new()
	// Create founder
	var/mob/living/carbon/human/species/kobold/founder = new()
	founder.real_name = "Lord [pick("Stark", "Lannister", "Targaryen", "Baratheon")]"
	founder.gender = MALE
	var/datum/heritage/H = new(founder, null, null)
	SSfamilytree.families |= H

	// Add spouse
	var/mob/living/carbon/human/species/kobold/spouse = new()
	spouse.real_name = "Lady [H.housename]"
	spouse.gender = FEMALE
	var/datum/family_member/spouse_member = H.CreateFamilyMember(spouse)
	H.MarryMembers(H.founder, spouse_member)

	// Add children
	var/num_children = rand(2, 4)
	for(var/i in 1 to num_children)
		var/mob/living/carbon/human/child = new()
		child.gender = prob(50) ? MALE : FEMALE
		child.real_name = "[pick(child.gender == MALE ? list("Jon", "Robb", "Bran") : list("Sansa", "Arya", "Lyanna"))] [H.housename]"
		H.AddToFamily(child, H.founder, spouse_member, prob(20))

	return H

/proc/generate_large_dynasty()
	// Create founder
	var/mob/living/carbon/human/species/kobold/founder = new()
	var/dynasty_names = list("Dragonheart", "Ironhold", "Goldmane", "Stormwind", "Nightfall", "Brightblade", "Shadowmere", "Flamecrest", "Thornwick", "Ravencrown")
	var/house_name = pick(dynasty_names)
	founder.real_name = "Emperor [pick("Alexander", "Magnus", "Augustus", "Maximilian", "Constantine")] [house_name] the Great"
	founder.gender = MALE
	var/datum/heritage/H = new(founder, null, null)
	SSfamilytree.families |= H

	// Add primary spouse
	var/mob/living/carbon/human/species/kobold/spouse = new()
	spouse.real_name = "Empress [pick("Victoria", "Isabella", "Catherine", "Anastasia", "Theodora")] [house_name]"
	spouse.gender = FEMALE
	var/datum/family_member/spouse_member = H.CreateFamilyMember(spouse)
	H.MarryMembers(H.founder, spouse_member)

	// Keep track of all generations
	var/list/generations = list()
	var/list/current_gen = list(H.founder)
	generations += list(current_gen)

	// Generate 6 generations
	for(var/gen_num in 1 to 6)
		var/list/next_gen = list()
		for(var/datum/family_member/parent in current_gen)
			// Skip if no spouse
			if(!parent.spouses || !parent.spouses.len)
				continue

			// Determine number of children based on generation and status
			var/num_children = get_children_count(gen_num, parent)

			for(var/i in 1 to num_children)
				var/mob/living/carbon/human/child = new()
				child.gender = prob(50) ? MALE : FEMALE

				// Generate appropriate name for generation and gender
				var/child_name = get_generation_name(gen_num, child.gender, house_name)
				child.real_name = child_name

				// Add to family with chance of adoption
				var/is_adopted = prob(get_adoption_chance(gen_num))
				var/datum/family_member/child_member = H.AddToFamily(child, parent, parent.spouses[1], is_adopted)
				next_gen += child_member

				// Give children spouses based on generation marriage rates
				if(prob(get_marriage_chance(gen_num)))
					create_spouse_for_member(child_member, gen_num, house_name, H)

		// Add some external marriages and adoptions for variety
		add_external_connections(next_gen, gen_num, house_name, H)

		// Store generation and move to next
		generations += list(next_gen)
		current_gen = next_gen

	return H

/proc/get_children_count(gen_num, datum/family_member/parent)
	// Earlier generations have more children, later ones fewer
	switch(gen_num)
		if(1 to 3) return rand(2, 3)      // 3-8 children
		if(4 to 6) return rand(2, 3)      // 2-6 children
		if(7 to 9) return rand(1, 2)      // 1-4 children
		if(10 to 12) return rand(0, 1)    // 1-3 children

/proc/get_adoption_chance(gen_num)
	// Adoption becomes more common in later generations
	switch(gen_num)
		if(1 to 4) return 5    // 5% chance
		if(5 to 8) return 10   // 10% chance
		if(9 to 12) return 15  // 15% chance

/proc/get_marriage_chance(gen_num)
	// Marriage rates vary by generation
	switch(gen_num)
		if(1 to 3) return 85   // 85% marriage rate
		if(4 to 6) return 75   // 75% marriage rate
		if(7 to 9) return 70   // 70% marriage rate
		if(10 to 12) return 65 // 65% marriage rate

/proc/get_generation_name(gen_num, gender, house_name)
	var/male_titles = list()
	var/female_titles = list()
	var/male_names = list()
	var/female_names = list()

	switch(gen_num)
		if(1) // Princes and Princesses
			male_titles = list("Prince")
			female_titles = list("Princess")
			male_names = list("Alexander", "William", "Edward", "Henry", "Charles", "Richard", "George", "Frederick")
			female_names = list("Elizabeth", "Margaret", "Anne", "Victoria", "Catherine", "Mary", "Charlotte", "Sophia")

		if(2) // Grand Dukes/Duchesses
			male_titles = list("Grand Duke", "Archduke")
			female_titles = list("Grand Duchess", "Archduchess")
			male_names = list("Marcus", "Adrian", "Sebastian", "Nicholas", "Damien", "Theodore", "Maximilian", "Constantine")
			female_names = list("Isabella", "Anastasia", "Gabrielle", "Evangeline", "Seraphina", "Valentina", "Arabella", "Cordelia")

		if(3 to 4) // Dukes/Duchesses
			male_titles = list("Duke", "Count")
			female_titles = list("Duchess", "Countess")
			male_names = list("Roderick", "Alaric", "Casimir", "Leander", "Octavius", "Percival", "Thaddeus", "Lysander")
			female_names = list("Beatrice", "Celestine", "Isadora", "Penelope", "Rosalind", "Vivienne", "Genevieve", "Ophelia")

		if(5 to 6) // Marquess/Marchioness
			male_titles = list("Marquess", "Earl")
			female_titles = list("Marchioness", "Countess")
			male_names = list("Barnabas", "Crispin", "Dorian", "Evander", "Fitzroy", "Gareth", "Hadrian", "Ignatius")
			female_names = list("Cordelia", "Daphne", "Estelle", "Felicity", "Guinevere", "Hermione", "Imogen", "Josephine")

		if(7 to 8) // Barons/Baronesses
			male_titles = list("Baron", "Viscount")
			female_titles = list("Baroness", "Viscountess")
			male_names = list("Jasper", "Kieran", "Leopold", "Montague", "Nigel", "Oswald", "Peregrine", "Quentin")
			female_names = list("Katarina", "Lavinia", "Millicent", "Nadine", "Octavia", "Prudence", "Quintessa", "Rowena")

		if(9 to 10) // Lords/Ladies
			male_titles = list("Lord", "Sir")
			female_titles = list("Lady", "Dame")
			male_names = list("Rupert", "Silas", "Tobias", "Ulric", "Vincent", "Winthrop", "Xavier", "Yorick")
			female_names = list("Sabrina", "Tabitha", "Ursula", "Veronica", "Winifred", "Ximena", "Yolanda", "Zelda")

		else // Lower nobility
			male_titles = list("Sir", "Master")
			female_titles = list("Lady", "Mistress")
			male_names = list("Aldric", "Balthazar", "Cedric", "Duncan", "Edmund", "Finnegan", "Gideon", "Hamish")
			female_names = list("Adelaide", "Bernadette", "Clarissa", "Dorothea", "Estella", "Francesca", "Gwendolyn", "Henrietta")

	var/title = pick(gender == MALE ? male_titles : female_titles)
	var/name = pick(gender == MALE ? male_names : female_names)
	return "[title] [name] [house_name]"

/proc/create_spouse_for_member(datum/family_member/member, gen_num, house_name, datum/heritage/H)
	var/mob/living/carbon/human/spouse = new()
	spouse.gender = member.person.gender == MALE ? FEMALE : MALE

	var/allied_houses = list("Westmarch", "Easthold", "Northgate", "Southport", "Silverbrook", "Goldenvale",
					   "Redcliff", "Bluehaven", "Greenwood", "Blackstone", "Whitehall", "Greycastle")
	var/spouse_house = pick(allied_houses)

	var/spouse_title
	var/spouse_name
	if(spouse.gender == MALE) {
		spouse_title = pick("Duke", "Count", "Baron", "Lord", "Sir")
		spouse_name = pick("Robert", "James", "Thomas", "George", "Francis", "Arthur", "Philip", "Anthony")
	} else {
		spouse_title = pick("Duchess", "Countess", "Baroness", "Lady", "Dame")
		spouse_name = pick("Marie", "Sophie", "Charlotte", "Helena", "Louise", "Alice", "Beatrice", "Eugenie")
	}

	spouse.real_name = "[spouse_title] [spouse_name] of [spouse_house]"

	var/datum/family_member/spouse_member = H.CreateFamilyMember(spouse)
	spouse_member.generation = member.generation  // Ensure same generation
	spouse_member.adoption_status = FALSE
	H.MarryMembers(member, spouse_member)

	return spouse_member

/proc/add_external_connections(list/generation, gen_num, house_name, datum/heritage/H)
	if(prob(20))
		var/mob/living/carbon/human/species/kobold/bastard = new()
		bastard.gender = prob(50) ? MALE : FEMALE
		bastard.real_name = "[pick("Snow", "Stone", "Rivers", "Hill")] [pick("the Bastard", "the Legitimized")]"

		if(generation.len > 0)
			var/datum/family_member/parent = pick(generation)
			H.AddToFamily(bastard, parent, null, FALSE)

	if(prob(15))
		var/mob/living/carbon/human/species/kobold/ward = new()
		ward.gender = prob(50) ? MALE : FEMALE
		ward.real_name = "Ward [pick("Blackwood", "Greycliff", "Redstone", "Thornfield", "Ashford")]"

		if(generation.len > 0)
			var/datum/family_member/adoptive_parent = pick(generation)
			if(adoptive_parent.spouses && adoptive_parent.spouses.len > 0)
				H.AddToFamily(ward, adoptive_parent, adoptive_parent.spouses[1], TRUE)
