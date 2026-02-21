/obj/machinery/essence/research_matrix
	name = "Alchemical Engine"
	desc = "A black iconosphere which heat radiates from. It hums with alchemic energy, assisting in process of extraction. "
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "placeholder"
	density = TRUE
	anchored = TRUE
	processing_priority = 3
	var/datum/essence_storage/storage
	var/datum/thaumic_research_node/selected_research
	var/datum/weakref/current_user

/obj/machinery/essence/research_matrix/Initialize()
	. = ..()
	storage = new /datum/essence_storage(src)
	storage.max_total_capacity = INFINITY
	storage.max_essence_types = 10

/obj/machinery/essence/research_matrix/Destroy()
	if(storage)
		qdel(storage)
	if(selected_research)
		qdel(selected_research)
	current_user = null
	return ..()

/obj/machinery/essence/research_matrix/attack_hand(mob/user, list/modifiers)
	current_user = WEAKREF(user)
	open_research_interface(user)

/obj/machinery/essence/research_matrix/return_storage()
	return storage

/obj/machinery/essence/research_matrix/can_target_accept_essence(target, essence_type)
	return is_essence_allowed(essence_type)

/obj/machinery/essence/research_matrix/is_essence_allowed(essence_type)
	if(!selected_research)
		return FALSE
	if(!(essence_type in selected_research.required_essences))
		return FALSE

	var/needed = selected_research.required_essences[essence_type]
	var/current = storage.get_essence_amount(essence_type)
	var/remaining_needed = needed - current

	if(remaining_needed <= 0)
		return FALSE

	return TRUE

/obj/machinery/essence/research_matrix/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/essence_connector))
		return ..()

	if(istype(I, /obj/item/essence_vial))
		var/obj/item/essence_vial/vial = I

		if(!vial.contained_essence || vial.essence_amount <= 0)
			to_chat(user, span_warning("The vial is empty."))
			return
		if(!selected_research)
			to_chat(user, span_warning("No research is currently selected."))
			return

		var/essence_type = vial.contained_essence.type
		if(!is_essence_allowed(essence_type))
			to_chat(user, span_warning("This essence is not needed for the current research."))
			return

		var/needed = selected_research.required_essences[essence_type]
		var/current = storage.get_essence_amount(essence_type)
		var/remaining_needed = needed - current

		var/to_transfer = min(vial.essence_amount, remaining_needed)
		var/transferred = storage.add_essence(essence_type, to_transfer)

		if(transferred > 0)
			vial.essence_amount -= transferred
			if(vial.essence_amount <= 0)
				vial.contained_essence = null
			vial.update_appearance(UPDATE_OVERLAYS)
			to_chat(user, span_info("You pour [transferred] units of essence into the engine."))
		return

	return ..()

/obj/machinery/essence/research_matrix/proc/open_research_interface(mob/user)
	var/datum/research_interface/interface = new(src, user)
	interface.show()

/obj/machinery/essence/research_matrix/on_transfer_in(essence_type, amount, datum/essence_storage/source)
	var/mob/user = current_user.resolve()
	if(user)
		check_research_completion(user)

/obj/machinery/essence/research_matrix/proc/check_research_completion(mob/user)
	if(!selected_research)
		return

	var/can_complete = TRUE
	for(var/essence_type in selected_research.required_essences)
		var/needed = selected_research.required_essences[essence_type]
		var/current = storage.get_essence_amount(essence_type)
		if(current < needed)
			can_complete = FALSE
			break

	if(can_complete)
		complete_research(user)

/obj/machinery/essence/research_matrix/proc/complete_research(mob/user)
	if(!selected_research)
		return

	for(var/essence_type in selected_research.required_essences)
		var/needed = selected_research.required_essences[essence_type]
		storage.remove_essence(essence_type, needed)

	GLOB.thaumic_research.unlock_research(selected_research.type)

	for(var/datum/thaumic_research_node/node_type as anything in subtypesof(/datum/thaumic_research_node))
		var/datum/thaumic_research_node/temp_node = new node_type
		if(IS_ABSTRACT(node_type))
			continue
		if(selected_research.type in temp_node.prerequisites)
			for(var/prereq in temp_node.prerequisites)
				if(!GLOB.thaumic_research.has_research(prereq))
					break
		qdel(temp_node)

	visible_message(span_notice("The engine hums and grumbles with alchemic energy as it's fueled!"))

	if(user)
		var/boon = user.get_learning_boon(/datum/skill/craft/alchemy)
		user.adjust_experience(/datum/skill/craft/alchemy, selected_research.experience_reward * boon, FALSE)

	selected_research = null

	addtimer(CALLBACK(src, PROC_REF(open_research_interface), user), 1)

/obj/machinery/essence/research_matrix/examine(mob/user)
	. = ..()
	. += span_notice("Storage: [storage.get_total_stored()] units")
	. += span_notice("Unlocked research nodes: [GLOB.thaumic_research.unlocked_research.len]")

	if(selected_research)
		. += span_notice("Selected research: [selected_research.name]")
		. += span_notice("Required essences:")
		for(var/essence_type in selected_research.required_essences)
			var/needed = selected_research.required_essences[essence_type]
			var/current = storage.get_essence_amount(essence_type)
			var/datum/thaumaturgical_essence/essence = new essence_type
			. += span_notice("- [essence.name]: [current]/[needed] units")
			qdel(essence)

/datum/research_interface
	var/obj/machinery/essence/research_matrix/matrix
	var/datum/browser/window
	var/mob/user

/datum/research_interface/New(obj/machinery/essence/research_matrix/M, mob/U)
	matrix = M
	user = U

/datum/research_interface/Destroy(force, ...)
	matrix = null
	user = null
	window = null
	return ..()

/datum/research_interface/proc/show()
	if(!user || !matrix)
		return

	var/content = generate_interface_html()
	window = new(user, "alchemic_engine", null, 800, 600)
	window.set_content(content)
	window.open()

/datum/research_interface/proc/generate_interface_html()
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
					rgba(170, 71, 173, 0.3) 0%,
					rgba(65, 36, 74, 0.2) 40%,
					transparent 70%),
					radial-gradient(circle at 20% 30%, rgba(255, 99, 239, 0.8) 1px, transparent 2px),
					radial-gradient(circle at 80% 20%, rgba(170, 71, 173, 0.6) 1px, transparent 2px),
					radial-gradient(circle at 60% 80%, rgba(48, 26, 67, 0.4) 2px, transparent 4px),
					radial-gradient(circle at 30% 60%, rgba(255, 99, 239, 0.7) 1px, transparent 2px),
					radial-gradient(circle at 90% 70%, rgba(170, 71, 173, 0.5) 1px, transparent 2px);
				background-size: 800px 600px, 200px 150px, 300px 200px, 250px 180px, 180px 120px, 220px 160px;
				opacity: 0.8;
			}

			.parallax-stars-2 {
				background: radial-gradient(ellipse at 40% 60%,
					rgba(170, 71, 173, 0.2) 0%,
					rgba(65, 36, 74, 0.1) 50%,
					transparent 80%),
					radial-gradient(circle at 15% 85%, rgba(255, 99, 239, 0.9) 1px, transparent 2px),
					radial-gradient(circle at 70% 15%, rgba(170, 71, 173, 0.7) 1px, transparent 2px),
					radial-gradient(circle at 45% 35%, rgba(48, 26, 67, 0.5) 2px, transparent 4px),
					radial-gradient(circle at 85% 90%, rgba(255, 99, 239, 0.6) 1px, transparent 2px),
					radial-gradient(circle at 25% 25%, rgba(170, 71, 173, 0.4) 1px, transparent 2px);
				background-size: 600px 450px, 180px 130px, 280px 190px, 230px 170px, 160px 110px, 200px 140px;
				opacity: 0.6;
			}

			.parallax-neb {
				background-image: url('KettleParallaxNeb.png');
				background-size: cover;
				background-repeat: no-repeat;
				background-position: center;
				opacity: 0.4;
			}

			.research-container {
				position: relative;
				width: 100%;
				height: 100vh;
				overflow: hidden;
				cursor: grab;
				z-index: 1;
			}

			.research-container.dragging { cursor: grabbing; }

			.research-canvas {
				position: absolute;
				transform-origin: 0 0;
			}

			.connection-line {
				position: absolute;
				height: 3px;
				background: linear-gradient(90deg,
					rgba(100,149,237,0.8) 0%,
					rgba(147,112,219,0.6) 50%,
					rgba(100,149,237,0.4) 100%);
				transform-origin: left center;
				z-index: 5;
				border-radius: 1px;
				box-shadow: 0 0 4px rgba(100,149,237,0.3);
			}

			.connection-line.unlocked {
				background: linear-gradient(90deg,
					rgba(50,205,50,0.8) 0%,
					rgba(34,139,34,0.6) 50%,
					rgba(50,205,50,0.4) 100%);
				box-shadow: 0 0 4px rgba(50,205,50,0.3);
			}

			.research-node {
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
			}

			.research-node img {
				width: 32px;
				height: 32px;
				object-fit: contain;
			}

			.research-node.unlocked {
				background: url('research_known.png');
			}

			.research-node.unlocked img {
				filter: hue-rotate(120deg) brightness(1.2) drop-shadow(0 0 4px rgba(50,205,50,0.8));
			}

			.research-node.available {
			}

			.research-node.available img {
				filter: hue-rotate(45deg) brightness(1.1) drop-shadow(0 0 4px rgba(255,215,0,0.6));
			}

			.research-node.locked img {
				opacity: 0.4;
				filter: grayscale(100%) brightness(0.7);
			}

			.research-node.selected {
				background: url('research_selected.png');
				transform: scale(1.05);
			}

			.research-node.selected img {
				filter: hue-rotate(-30deg) brightness(1.3) drop-shadow(0 0 8px rgba(255, 69, 0, 0.8));
			}

			.research-node:hover {
				background: url('research_hover.png');
				transform: scale(1.15);
				z-index: 100;
			}

			.research-node:hover img {
				filter: brightness(1.4) drop-shadow(0 0 6px rgba(255, 255, 255, 0.8));
			}

			.tooltip {
				position: absolute;
				background: rgba(15,15,30,0.95);
				border: 2px solid #6a5acd;
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
				color: #FFD700;
				text-shadow: 0 0 4px rgba(255,215,0,0.5);
			}

			.tooltip p { margin: 5px 0; font-size: 12px; }
			.requirements { color: #FF6B6B; }
			.unlocks { color: #4ECDC4; }
		</style>
	</head>
	<body>
		<div class="parallax-container">
			<div class="parallax-layer parallax-bg" id="parallax-bg"></div>
			<div class="parallax-layer parallax-stars-1" id="parallax-stars-1"></div>
			<div class="parallax-layer parallax-stars-2" id="parallax-stars-2"></div>
			<div class="parallax-layer parallax-neb" id="parallax-neb"></div>
		</div>

		<div class="research-container" id="container">
			<div class="research-canvas" id="canvas">
				[generate_connections_html()]
				[generate_nodes_html()]
			</div>
		</div>

		<div class="tooltip" id="tooltip" style="display: none;"></div>

		<script>
			let isDragging = false;
			let startX, startY;
			let currentX = 400, currentY = 300;
			let scale = 1;

			try {
				const savedX = sessionStorage.getItem('research_pos_x');
				const savedY = sessionStorage.getItem('research_pos_y');
				const savedScale = sessionStorage.getItem('research_scale');
				if (savedX !== null) currentX = parseFloat(savedX);
				if (savedY !== null) currentY = parseFloat(savedY);
				if (savedScale !== null) scale = parseFloat(savedScale);
			} catch(e) {
				// Fallback to defaults if sessionStorage not available
				currentX = 400;
				currentY = 300;
				scale = 1;
			}

			const container = document.getElementById('container');
			const canvas = document.getElementById('canvas');
			const tooltip = document.getElementById('tooltip');

			const parallaxBg = document.getElementById('parallax-bg');
			const parallaxStars1 = document.getElementById('parallax-stars-1');
			const parallaxStars2 = document.getElementById('parallax-stars-2');
			const parallaxNeb = document.getElementById('parallax-neb');

			updateCanvasTransform();
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
					savePosition();
				}

				// Tooltip handling
				if (e.target.classList.contains('research-node') || e.target.parentElement.classList.contains('research-node')) {
					const node = e.target.classList.contains('research-node') ? e.target : e.target.parentElement;
					showTooltip(e, node);
				} else {
					hideTooltip();
				}
			});

			document.addEventListener('mouseup', function() {
				isDragging = false;
				container.classList.remove('dragging');
			});

			// Zoom with mouse wheel
			container.addEventListener('wheel', function(e) {
				e.preventDefault();
				const zoomSpeed = 0.1;
				const rect = container.getBoundingClientRect();
				const mouseX = e.clientX - rect.left;
				const mouseY = e.clientY - rect.top;

				const oldScale = scale;
				scale += e.deltaY > 0 ? -zoomSpeed : zoomSpeed;
				scale = Math.max(0.3, Math.min(3, scale));

				// Adjust position to zoom towards mouse
				const scaleChange = scale / oldScale;
				currentX = mouseX - (mouseX - currentX) * scaleChange;
				currentY = mouseY - (mouseY - currentY) * scaleChange;

				updateCanvasTransform();
				updateParallax();
				savePosition();
			});

			function updateCanvasTransform() {
				canvas.style.transform = 'translate(' + currentX + 'px, ' + currentY + 'px) scale(' + scale + ')';
			}

			function updateParallax() {
				const bgSlowness = 0.998046875;        // Background layer (slowest)
				const stars1Slowness = 0.696625;       // First star layer (faster)
				const stars2Slowness = 0.896625;       // Second star layer (medium)
				const nebSlowness = 0.5;               // Nebula foreground (fastest)

				const bgX = currentX * (1 - bgSlowness);
				const bgY = currentY * (1 - bgSlowness);

				const stars1X = currentX * (1 - stars1Slowness);
				const stars1Y = currentY * (1 - stars1Slowness);

				const stars2X = currentX * (1 - stars2Slowness);
				const stars2Y = currentY * (1 - stars2Slowness);

				const nebX = currentX * (1 - nebSlowness);
				const nebY = currentY * (1 - nebSlowness);

				parallaxBg.style.transform = 'translate(' + bgX + 'px, ' + bgY + 'px)';
				parallaxStars1.style.transform = 'translate(' + stars1X + 'px, ' + stars1Y + 'px)';
				parallaxStars2.style.transform = 'translate(' + stars2X + 'px, ' + stars2Y + 'px)';
				parallaxNeb.style.transform = 'translate(' + nebX + 'px, ' + nebY + 'px)';
			}

			function savePosition() {
				try {
					sessionStorage.setItem('research_pos_x', currentX.toString());
					sessionStorage.setItem('research_pos_y', currentY.toString());
					sessionStorage.setItem('research_scale', scale.toString());
				} catch(e) {
					// Silently fail if sessionStorage not available
				}
			}

			function resetView() {
				currentX = 400;
				currentY = 300;
				scale = 1;
				updateCanvasTransform();
				updateParallax();
				savePosition();
			}

			function zoomIn() {
				scale = Math.min(3, scale + 0.2);
				updateCanvasTransform();
				savePosition();
			}

			function zoomOut() {
				scale = Math.max(0.3, scale - 0.2);
				updateCanvasTransform();
				savePosition();
			}

			function showTooltip(e, node) {
				try {
					const nodeData = JSON.parse(node.dataset.nodeinfo);
					let html = '<h3>' + nodeData.name + '</h3>';
					html += '<p>' + nodeData.desc + '</p>';

					if (nodeData.requirements && nodeData.requirements.length > 0) {
						html += '<p class="requirements"><strong>Requirements:</strong></p>';
						nodeData.requirements.forEach(function(req) {
							html += '<p class="requirements">' + req + '</p>';
						});
					}

					if (nodeData.unlocks && nodeData.unlocks.length > 0) {
						html += '<p class="unlocks"><strong>Unlocks:</strong></p>';
						nodeData.unlocks.forEach(function(unlock) {
							html += '<p class="unlocks">' + unlock + '</p>';
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

			function selectNode(nodeType) {
				savePosition();
				window.location.href = "byond://?src=[REF(matrix)];action=select_research;node=" + nodeType;
			}

			// Initialize parallax on load
			updateParallax();
		</script>
	</body>
	</html>
	"}

	return html


/datum/research_interface/proc/generate_nodes_html()
	var/html = ""
	var/center_x = 0
	var/center_y = 0
	var/list/available_research = GLOB.thaumic_research.get_available_research()

	for(var/datum/thaumic_research_node/node_type as anything in subtypesof(/datum/thaumic_research_node))
		if(IS_ABSTRACT(node_type))
			continue

		var/datum/thaumic_research_node/node = new node_type

		var/is_unlocked = GLOB.thaumic_research.has_research(node_type)
		var/is_available = (node_type in available_research)
		var/is_selected = (matrix.selected_research && matrix.selected_research.type == node_type)

		var/class_list = "research-node"
		if(is_unlocked)
			class_list += " unlocked"
		else if(is_available)
			class_list += " available"
		else
			class_list += " locked"

		if(is_selected)
			class_list += " selected"

		var/node_x = center_x + node.node_x - 16
		var/node_y = center_y + node.node_y - 16

		var/list/req_text = list()
		for(var/essence_type in node.required_essences)
			var/datum/thaumaturgical_essence/essence = new essence_type
			var/needed = node.required_essences[essence_type]
			var/current = matrix.storage.get_essence_amount(essence_type)
			req_text += "[essence.name]: [current]/[needed]"
			qdel(essence)

		var/node_data = list(
			"name" = node.name,
			"desc" = node.desc,
			"requirements" = req_text,
			"unlocks" = node.unlocks
		)

		html += {"<div class="[class_list]"
			style="left: [node_x]px; top: [node_y]px;"
			data-nodeinfo='[json_encode(node_data)]'
			onclick="selectNode('[node_type]')"
			title="[node.name]">
			<img src='\ref[node.icon]?state=[node.icon_state]' alt="[node.name]" />
		</div>"}

		qdel(node)

	return html

/datum/research_interface/proc/generate_connections_html()
	var/html = ""
	var/center_x = 0
	var/center_y = 0

	var/list/node_positions = list()
	for(var/datum/thaumic_research_node/node_type as anything in subtypesof(/datum/thaumic_research_node))
		if(IS_ABSTRACT(node_type))
			continue

		var/datum/thaumic_research_node/temp_node = new node_type

		node_positions[node_type] = list("x" = temp_node.node_x, "y" = temp_node.node_y)
		qdel(temp_node)

	for(var/datum/thaumic_research_node/node_type as anything in subtypesof(/datum/thaumic_research_node))
		if(IS_ABSTRACT(node_type))
			continue

		var/datum/thaumic_research_node/node = new node_type

		// Draw connections FROM prerequisites TO this node
		for(var/prereq_type in node.prerequisites)
			if(!(prereq_type in node_positions))
				continue

			var/list/prereq_pos = node_positions[prereq_type]
			var/list/current_pos = node_positions[node_type]

			var/start_center_x = center_x + prereq_pos["x"]
			var/start_center_y = center_y + prereq_pos["y"]
			var/end_center_x = center_x + current_pos["x"]
			var/end_center_y = center_y + current_pos["y"]

			var/dx = end_center_x - start_center_x
			var/dy = end_center_y - start_center_y
			var/distance = sqrt(dx*dx + dy*dy)

			if(distance == 0)
				continue

			var/angle = 0

			if(distance == 0)
				continue

			angle = arctan(dx, dy)

			if(angle < 0)
				angle += 360

			var/start_x = start_center_x
			var/start_y = start_center_y
			var/line_length = distance

			var/is_unlocked_connection = (GLOB.thaumic_research.has_research(prereq_type)) && (GLOB.thaumic_research.has_research(node_type))
			var/connection_class = "connection-line"
			if(is_unlocked_connection)
				connection_class += " unlocked"

			html += {"<div class="[connection_class]"
				style="left: [start_x]px; top: [start_y - 1.5]px; width: [line_length]px; transform: rotate([angle]deg); transform-origin: 0 50%; z-index: 1;">
			</div>"}

		qdel(node)
	return html

/datum/research_interface/proc/can_research_node(datum/thaumic_research_node/node)
	return GLOB.thaumic_research.can_research(node.type)

/obj/machinery/essence/research_matrix/Topic(href, href_list)
	if(href_list["action"] == "select_research")
		var/node_type = text2path(href_list["node"])
		if(!node_type)
			return

		var/datum/thaumic_research_node/node = new node_type
		if(GLOB.thaumic_research.has_research(node_type))
			to_chat(usr, span_warning("This research has already been completed."))
			qdel(node)
			return

		if(!GLOB.thaumic_research.can_research(node_type))
			to_chat(usr, span_warning("Prerequisites not met for this research."))
			qdel(node)
			return

		selected_research = node
		to_chat(usr, span_info("Selected research: [node.name]"))
		addtimer(CALLBACK(src, PROC_REF(open_research_interface), usr), 0.1)

