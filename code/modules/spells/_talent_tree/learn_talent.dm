/datum/action/cooldown/spell/undirected/talent_trees
	name = "Open Talent Trees"
	desc = "View and learn talents"
	button_icon_state = "book1"
	sound = null

	school = SCHOOL_TRANSMUTATION
	charge_required = FALSE
	has_visual_effects = FALSE
	spell_cost = 0

	var/list/available_trees = list() // List of talent_tree datums NEEDS TO BE REALIZED
	var/datum/talent_interface/current_interface = null

/datum/action/cooldown/spell/undirected/talent_trees/Destroy()
	available_trees = null
	if(current_interface)
		current_interface.Destroy()
		current_interface = null
	return ..()

/datum/action/cooldown/spell/undirected/talent_trees/cast(list/targets, mob/user = usr)
	. = ..()
	open_talent_interface(owner)

/datum/action/cooldown/spell/undirected/talent_trees/proc/open_talent_interface(mob/user)
	if(current_interface)
		current_interface.Destroy()
	current_interface = new(src, user)
	current_interface.show()

/datum/action/cooldown/spell/undirected/talent_trees/Topic(href, href_list)
	if(href_list["action"] == "learn_talent")
		var/talent_type = text2path(href_list["talent"])
		var/tree_id = href_list["tree"]

		if(!talent_type || !tree_id)
			return

		// Find the appropriate tree
		var/datum/talent_tree/target_tree = null
		for(var/datum/talent_tree/tree in available_trees)
			if(tree.tree_identifier == tree_id)
				target_tree = tree
				break

		if(!target_tree)
			return

		var/success = target_tree.learn_talent(talent_type, usr)

		if(success && owner == usr && current_interface)
			// Store current position and zoom before refreshing
			var/current_x = current_interface.canvas_x
			var/current_y = current_interface.canvas_y
			var/current_scale = current_interface.canvas_scale

			// Refresh the interface while maintaining state
			current_interface.refresh_interface(current_x, current_y, current_scale)

	else if(href_list["action"] == "select_tree")
		var/tree_id = href_list["tree"]
		if(owner == usr && current_interface)
			current_interface.selected_tree_id = tree_id
			current_interface.show()

	else if(href_list["action"] == "back")
		if(owner == usr && current_interface)
			current_interface.selected_tree_id = null
			current_interface.show()

	else if(href_list["action"] == "update_position")
		if(current_interface && owner == usr)
			current_interface.canvas_x = text2num(href_list["x"])
			current_interface.canvas_y = text2num(href_list["y"])
			current_interface.canvas_scale = text2num(href_list["scale"])

/datum/talent_interface
	var/datum/action/cooldown/spell/undirected/talent_trees/matrix
	var/datum/browser/window
	var/mob/living/user
	var/selected_tree_id = null

	var/canvas_x = 400
	var/canvas_y = 300
	var/canvas_scale = 1

/datum/talent_interface/New(datum/action/cooldown/spell/undirected/talent_trees/M, mob/U)
	matrix = M
	user = U

/datum/talent_interface/Destroy(force)
	matrix = null
	user = null
	if(window)
		window.close()
		window = null
	return ..()

/datum/talent_interface/proc/show()
	if(!user || !matrix)
		return

	var/content = ""
	if(selected_tree_id)
		content = generate_tree_interface_html()
	else
		content = generate_tree_selection_html()

	window = new(user, "talent_trees", null, 800, 600)
	window.set_content(content)
	window.open()

/datum/talent_interface/proc/refresh_interface(new_x = null, new_y = null, new_scale = null)
	if(!user || !matrix)
		return

	// Update position if provided
	if(new_x != null)
		canvas_x = new_x
	if(new_y != null)
		canvas_y = new_y
	if(new_scale != null)
		canvas_scale = new_scale

	show()

/datum/talent_interface/proc/generate_tree_selection_html()
	var/html = {"
	<html>
	<head>
		<style>
			body {
				background: #1a1a2e;
				color: #eee;
				font-family: Arial, sans-serif;
				padding: 20px;
			}
			.tree-selection {
				display: flex;
				flex-wrap: wrap;
				gap: 20px;
				justify-content: center;
			}
			.tree-card {
				background: linear-gradient(145deg, #16213e, #0f172a);
				border: 2px solid #3b82f6;
				border-radius: 12px;
				padding: 20px;
				width: 250px;
				cursor: pointer;
				transition: all 0.3s ease;
				text-align: center;
			}
			.tree-card:hover {
				border-color: #60a5fa;
				transform: scale(1.05);
				box-shadow: 0 8px 25px rgba(59, 130, 246, 0.3);
			}
			.tree-title {
				color: #60a5fa;
				font-size: 18px;
				font-weight: bold;
				margin-bottom: 10px;
			}
			.tree-desc {
				font-size: 14px;
				color: #cbd5e1;
				margin-bottom: 15px;
			}
			.tree-progress {
				font-size: 12px;
				color: #10b981;
			}
		</style>
	</head>
	<body>
		<h2 style="text-align: center; color: #60a5fa;">Select a Talent Tree</h2>
		<div class="tree-selection">
	"}

	for(var/datum/talent_tree/tree in matrix.available_trees)
		var/progress_text = "[tree.talent_points_spent]/[tree.max_talent_points] points spent"
		html += {"
			<div class="tree-card" onclick="selectTree('[tree.tree_identifier]')">
				<div class="tree-title">[tree.name]</div>
				<div class="tree-desc">[tree.desc]</div>
				<div class="tree-progress">[progress_text]</div>
			</div>
		"}

	html += {"
		</div>
		<script>
			function selectTree(treeId) {
				window.location.href = "byond://?src=[REF(matrix)];action=select_tree;tree=" + treeId;
			}
		</script>
	</body>
	</html>
	"}

	return html

/datum/talent_interface/proc/generate_tree_interface_html()
	var/datum/talent_tree/selected_tree = null
	for(var/datum/talent_tree/tree in matrix.available_trees)
		if(tree.tree_identifier == selected_tree_id)
			selected_tree = tree
			break

	if(!selected_tree)
		return generate_tree_selection_html()

	user << browse_rsc('html/research_hover.png')
	user << browse_rsc('html/research_base.png')
	user << browse_rsc('html/research_known.png')
	user << browse_rsc('html/research_selected.png')
	user << browse_rsc('html/KettleParallaxBG.png')
	user << browse_rsc('html/KettleParallaxNeb.png')

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

			.parallax-container {
				position: fixed;
				top: 0;
				left: 0;
				width: 100%;
				height: 100vh;
				overflow: hidden;
				z-index: -1;
			}

			.parallax-layer {
				position: absolute;
				width: 120%;
				height: 120%;
				background-repeat: repeat;
			}

			.parallax-bg {
				background-image: url('KettleParallaxBG.png');
				background-size: cover;
				background-repeat: no-repeat;
				background-position: center;
			}

			.parallax-stars-1 {
				background: radial-gradient(ellipse at center,
					rgba(59, 130, 246, 0.3) 0%,
					rgba(29, 78, 216, 0.2) 40%,
					transparent 70%),
					radial-gradient(circle at 20% 30%, rgba(96, 165, 250, 0.8) 1px, transparent 2px),
					radial-gradient(circle at 80% 20%, rgba(59, 130, 246, 0.6) 1px, transparent 2px),
					radial-gradient(circle at 60% 80%, rgba(37, 99, 235, 0.4) 2px, transparent 4px);
				background-size: 800px 600px, 200px 150px, 300px 200px, 250px 180px;
				opacity: 0.8;
			}

			.parallax-stars-2 {
				background: radial-gradient(ellipse at 40% 60%,
					rgba(59, 130, 246, 0.2) 0%,
					rgba(29, 78, 216, 0.1) 50%,
					transparent 80%),
					radial-gradient(circle at 15% 85%, rgba(96, 165, 250, 0.9) 1px, transparent 2px),
					radial-gradient(circle at 70% 15%, rgba(59, 130, 246, 0.7) 1px, transparent 2px);
				background-size: 600px 450px, 180px 130px, 280px 190px;
				opacity: 0.6;
			}

			.parallax-neb {
				background-image: url('KettleParallaxNeb.png');
				background-size: cover;
				background-repeat: no-repeat;
				background-position: center;
				opacity: 0.4;
			}

			.talent-container {
				position: relative;
				width: 100%;
				height: 100vh;
				overflow: hidden;
				cursor: grab;
				z-index: 1;
			}

			.talent-container.dragging { cursor: grabbing; }

			.talent-canvas {
				position: absolute;
				transform-origin: 0 0;
			}

			.connection-line {
				position: absolute;
				height: 3px;
				background: linear-gradient(90deg,
					rgba(59,130,246,0.8) 0%,
					rgba(96,165,250,0.6) 50%,
					rgba(59,130,246,0.4) 100%);
				transform-origin: left center;
				z-index: 5;
				border-radius: 1px;
				box-shadow: 0 0 4px rgba(59,130,246,0.3);
			}

			.connection-line.unlocked {
				background: linear-gradient(90deg,
					rgba(16,185,129,0.8) 0%,
					rgba(52,211,153,0.6) 50%,
					rgba(16,185,129,0.4) 100%);
				box-shadow: 0 0 4px rgba(16,185,129,0.3);
			}

			.talent-node {
				background: url('research_base.png');
				position: absolute;
				width: 32px;
				height: 32px;
				cursor: pointer;
				transition: all 0.15s ease;
				display: flex;
				align-items: center;
				justify-content: center;
				z-index: 10;
				border-radius: 4px;
				border: 2px solid rgba(59, 130, 246, 0.5);
			}

			.talent-node img {
				width: 32px;
				height: 32px;
				object-fit: contain;
			}

			.talent-node.unlocked {
				background: url('research_known.png');
				border-color: rgba(16, 185, 129, 0.8);
			}

			.talent-node.unlocked img {
				filter: hue-rotate(90deg) brightness(1.2) drop-shadow(0 0 4px rgba(16,185,129,0.8));
			}

			.talent-node.available img {
				filter: hue-rotate(45deg) brightness(1.1) drop-shadow(0 0 4px rgba(59,130,246,0.6));
			}

			.talent-node.locked img {
				opacity: 0.4;
				filter: grayscale(100%) brightness(0.7);
			}

			.talent-node:hover {
				background: url('research_hover.png');
				transform: scale(1.15);
				z-index: 100;
			}

			.talent-node:hover img {
				filter: brightness(1.4) drop-shadow(0 0 6px rgba(255, 255, 255, 0.8));
			}

			.tooltip {
				position: absolute;
				background: rgba(15,15,30,0.95);
				border: 2px solid #3b82f6;
				border-radius: 12px;
				padding: 12px;
				max-width: 320px;
				z-index: 1000;
				pointer-events: none;
				box-shadow: 0 8px 24px rgba(0,0,0,0.7);
				backdrop-filter: blur(5px);
			}

			.tooltip h3 {
				margin: 0 0 8px 0;
				color: #60a5fa;
				text-shadow: 0 0 4px rgba(96,165,250,0.5);
			}

			.tooltip p { margin: 5px 0; font-size: 12px; }
			.requirements { color: #f87171; }
			.unlocks { color: #34d399; }

			.info-panel {
				position: fixed;
				bottom: 10px;
				left: 10px;
				background: rgba(15,15,30,0.9);
				border: 2px solid #3b82f6;
				border-radius: 8px;
				padding: 10px;
				color: #60a5fa;
			}

			.back-button {
				position: fixed;
				top: 10px;
				left: 10px;
				background: rgba(15,15,30,0.9);
				border: 2px solid #3b82f6;
				border-radius: 8px;
				padding: 10px;
				color: #60a5fa;
				cursor: pointer;
				text-decoration: none;
			}

			.back-button:hover {
				background: rgba(25,25,40,0.9);
				border-color: #60a5fa;
			}
		</style>
	</head>
	<body>
		<div class="parallax-container">
			<div class="parallax-layer parallax-bg" id="parallax-bg"></div>
			<div class="parallax-layer parallax-stars-1" id="parallax-stars-1"></div>
			<div class="parallax-layer parallax-stars-2" id="parallax-stars-2"></div>
			<div class="parallax-layer parallax-neb" id="parallax-neb"></div>
		</div>

		<a href="byond://?src=[REF(matrix)];action=back" class="back-button">← Back to Trees</a>

		<div class="talent-container" id="container">
			<div class="talent-canvas" id="canvas">
				[generate_talent_connections_html(selected_tree)]
				[generate_talent_nodes_html(selected_tree)]
			</div>
		</div>

		<div class="info-panel">
			<div><strong>[selected_tree.name]</strong></div>
			<div>Available Points: [selected_tree.talent_points_available]</div>
			<div>Spent: [selected_tree.talent_points_spent]/[selected_tree.max_talent_points]</div>
		</div>

		<div class="tooltip" id="tooltip" style="display: none;"></div>

		<script>
			let isDragging = false;
			let startX, startY;
			let currentX = [canvas_x], currentY = [canvas_y];  // Use stored position
			let scale = [canvas_scale];  // Use stored scale

			const container = document.getElementById('container');
			const canvas = document.getElementById('canvas');
			const tooltip = document.getElementById('tooltip');

			const parallaxBg = document.getElementById('parallax-bg');
			const parallaxStars1 = document.getElementById('parallax-stars-1');
			const parallaxStars2 = document.getElementById('parallax-stars-2');
			const parallaxNeb = document.getElementById('parallax-neb');

			updateCanvasTransform();

			// Throttle position updates to avoid spam
			let positionUpdateTimeout = null;

			function updateStoredPosition() {
				if (positionUpdateTimeout) {
					clearTimeout(positionUpdateTimeout);
				}
				positionUpdateTimeout = setTimeout(function() {
					// Send position update to server
					window.location.href = "byond://?src=[REF(matrix)];action=update_position;x=" + currentX + ";y=" + currentY + ";scale=" + scale;
				}, 500); // Update every 500ms when position changes
			}

			container.addEventListener('mousedown', function(e) {
				if (e.target === container || e.target === canvas || e.target.classList.contains('connection-line')) {
					isDragging = true;
					startX = e.clientX - currentX;
					startY = e.clientY - currentY;
					container.classList.add('dragging');
					e.preventDefault();
				}
			});

			document.addEventListener('mousemove', function(e) {
				if (isDragging) {
					currentX = e.clientX - startX;
					currentY = e.clientY - startY;
					updateCanvasTransform();
					updateParallax();
					updateStoredPosition();
				}

				if (e.target.classList.contains('talent-node') || e.target.parentElement.classList.contains('talent-node')) {
					const node = e.target.classList.contains('talent-node') ? e.target : e.target.parentElement;
					showTooltip(e, node);
				} else {
					hideTooltip();
				}
			});

			document.addEventListener('mouseup', function() {
				isDragging = false;
				container.classList.remove('dragging');
			});

			container.addEventListener('wheel', function(e) {
				e.preventDefault();
				const zoomSpeed = 0.1;
				const rect = container.getBoundingClientRect();
				const mouseX = e.clientX - rect.left;
				const mouseY = e.clientY - rect.top;

				const oldScale = scale;
				scale += e.deltaY > 0 ? -zoomSpeed : zoomSpeed;
				scale = Math.max(0.3, Math.min(3, scale));

				const scaleChange = scale / oldScale;
				currentX = mouseX - (mouseX - currentX) * scaleChange;
				currentY = mouseY - (mouseY - currentY) * scaleChange;

				updateCanvasTransform();
				updateParallax();
				updateStoredPosition();
			});

			function updateCanvasTransform() {
				canvas.style.transform = 'translate(' + currentX + 'px, ' + currentY + 'px) scale(' + scale + ')';
			}

			function updateParallax() {
				const bgSlowness = 0.998046875;
				const stars1Slowness = 0.696625;
				const stars2Slowness = 0.896625;
				const nebSlowness = 0.5;

				parallaxBg.style.transform = 'translate(' + (currentX * (1 - bgSlowness)) + 'px, ' + (currentY * (1 - bgSlowness)) + 'px)';
				parallaxStars1.style.transform = 'translate(' + (currentX * (1 - stars1Slowness)) + 'px, ' + (currentY * (1 - stars1Slowness)) + 'px)';
				parallaxStars2.style.transform = 'translate(' + (currentX * (1 - stars2Slowness)) + 'px, ' + (currentY * (1 - stars2Slowness)) + 'px)';
				parallaxNeb.style.transform = 'translate(' + (currentX * (1 - nebSlowness)) + 'px, ' + (currentY * (1 - nebSlowness)) + 'px)';
			}

			function showTooltip(e, node) {
				try {
					const nodeData = JSON.parse(node.dataset.nodeinfo);

					let html = '<h3>' + nodeData.name + '</h3>';
					html += '<p>' + nodeData.desc + '</p>';
					html += '<p><strong>Cost:</strong> ' + nodeData.cost + ' talent points</p>';

					if (nodeData.requirements && nodeData.requirements.length > 0) {
						html += '<p class="requirements"><strong>Requirements:</strong></p>';
						nodeData.requirements.forEach(function(req) {
							html += '<p class="requirements">' + req + '</p>';
						});
					}

					tooltip.innerHTML = html;
					tooltip.style.display = 'block';
					tooltip.style.left = (e.clientX + 15) + 'px';
					tooltip.style.top = (e.clientY + 15) + 'px';
				} catch(err) {
					console.error('Error showing tooltip:', err);
				}
			}

			function hideTooltip() {
				tooltip.style.display = 'none';
			}

			function selectTalent(talentType) {
				window.location.href = "byond://?src=[REF(matrix)];action=learn_talent;talent=" + talentType + ";tree=[selected_tree_id]";
			}

			updateParallax();
		</script>
	</body>
	</html>
	"}

	return html

/datum/talent_interface/proc/generate_talent_nodes_html(datum/talent_tree/tree)
	var/html = ""

	for(var/node_type in tree.tree_nodes)
		var/datum/talent_node/node = new node_type
		var/is_unlocked = (node_type in tree.unlocked_talents)
		var/is_available = is_unlocked || tree.can_learn_talent(node)

		var/class_list = "talent-node"
		if(is_unlocked)
			class_list += " unlocked"
		else if(is_available)
			class_list += " available"
		else
			class_list += " locked"

		var/list/pos = tree.node_positions[node_type]
		if(!pos)
			qdel(node)
			continue

		var/node_x = pos["x"]
		var/node_y = pos["y"]

		var/list/req_text = list()
		for(var/prereq_type in node.prerequisites)
			var/datum/talent_node/prereq = new prereq_type
			var/status = (prereq_type in tree.unlocked_talents) ? "✓" : "✗"
			req_text += "[status] [prereq.name]"
			qdel(prereq)

		var/node_data = list(
			"name" = node.name,
			"desc" = node.desc,
			"cost" = node.talent_cost,
			"requirements" = req_text
		)

		html += {"<div class="[class_list]"
			style="left: [node_x]px; top: [node_y]px;"
			data-nodeinfo='[json_encode(node_data)]'
			onclick="selectTalent('[node_type]')"
			title="[node.name]">
			<img src='\ref[node.icon]?state=[node.icon_state]' alt="[node.name]" />
		</div>"}

		qdel(node)

	return html

/datum/talent_interface/proc/generate_talent_connections_html(datum/talent_tree/tree)
	var/html = ""

	for(var/node_type in tree.tree_nodes)
		var/datum/talent_node/node = new node_type

		for(var/prereq_type in node.prerequisites)
			var/list/prereq_pos = tree.node_positions[prereq_type]
			var/list/current_pos = tree.node_positions[node_type]

			if(!prereq_pos || !current_pos)
				continue

			var/start_x = prereq_pos["x"] + 16 // Center of node
			var/start_y = prereq_pos["y"] + 16
			var/end_x = current_pos["x"] + 16
			var/end_y = current_pos["y"] + 16

			var/dx = end_x - start_x
			var/dy = end_y - start_y
			var/distance = sqrt(dx*dx + dy*dy)

			if(distance == 0)
				continue

			var/angle = arctan(dx, dy)
			if(angle < 0)
				angle += 360

			var/is_unlocked_connection = (prereq_type in tree.unlocked_talents) && (node_type in tree.unlocked_talents)
			var/connection_class = "connection-line"
			if(is_unlocked_connection)
				connection_class += " unlocked"

			html += {"<div class="[connection_class]"
				style="left: [start_x]px; top: [start_y - 1.5]px; width: [distance]px; transform: rotate([angle]deg); transform-origin: 0 50%; z-index: 1;">
			</div>"}

		qdel(node)
	return html
