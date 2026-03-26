/datum/action/cooldown/spell/undirected/learn
	name = "Attempt to learn a new spell"
	desc = "Weave a new spell"
	button_icon_state = "book1"
	sound = null

	school = SCHOOL_TRANSMUTATION

	charge_required = FALSE
	has_visual_effects = FALSE
	spell_cost = 0

	var/list/unlocked_spells = list()
	var/datum/spell_node/selected_spell = null

/datum/action/cooldown/spell/undirected/learn/Destroy()
	unlocked_spells = null
	selected_spell = null
	return ..()

/datum/action/cooldown/spell/undirected/learn/cast(list/targets, mob/user = usr)
	. = ..()
	open_spell_interface(owner)

/datum/action/cooldown/spell/undirected/learn/proc/open_spell_interface(mob/user)
	var/datum/spell_interface/interface = new(src, user)
	interface.show()

/datum/action/cooldown/spell/undirected/learn/Topic(href, href_list)
	if(href_list["action"] == "learn_spell")
		var/spell_type = text2path(href_list["spell"])
		if(!spell_type)
			return

		var/datum/spell_node/node = new spell_type

		if(spell_type in unlocked_spells)
			to_chat(usr, span_warning("You have already learned this [node.is_passive ? "technique" : "spell"]."))
			qdel(node)
			return

		for(var/prereq in node.prerequisites)
			if(!(prereq in unlocked_spells))
				to_chat(usr, span_warning("Prerequisites not met for this [node.is_passive ? "technique" : "spell"]."))
				qdel(node)
				return
		var/mob/living/user = usr
		var/cost = node.cost
		if(node.spell_type)
			for(var/datum/action/cooldown/spell in user.actions)
				if(istype(spell, node.spell_type))
					cost = 0
					break

		if(cost > user.spell_points - user.used_spell_points)
			to_chat(user, span_warning("You do not have enough spell points to learn this."))
			qdel(node)
			return

		user.adjust_spell_points(cost, TRUE)
		unlocked_spells += spell_type

		if(node.is_passive)
			node.on_node_buy(user)
			to_chat(user, span_notice("You have learned the passive technique: [node.name]"))
		else
			if(node.spell_type)
				user.add_spell(node.spell_type, override = TRUE)
			to_chat(usr, span_notice("You have learned the spell: [node.name]"))

		selected_spell = node

		if(owner == usr)
			addtimer(CALLBACK(src, PROC_REF(open_spell_interface), usr), 0.1)

/datum/spell_interface
	var/datum/action/cooldown/spell/undirected/learn/matrix
	var/datum/browser/window
	var/mob/living/user

/datum/spell_interface/New(datum/action/cooldown/spell/undirected/learn/M, mob/U)
	matrix = M
	user = U

/datum/spell_interface/Destroy(force)
	matrix = null
	user = null
	window.close()
	window = null
	return ..()

/datum/spell_interface/proc/show()
	if(!user || !matrix)
		return

	var/content = generate_interface_html()
	window = new(user, "spell_matrix", null, 800, 600)
	window.set_content(content)
	window.open()

/datum/spell_interface/proc/generate_interface_html()
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
					rgba(138, 43, 226, 0.3) 0%,
					rgba(75, 0, 130, 0.2) 40%,
					transparent 70%),
					radial-gradient(circle at 20% 30%, rgba(255, 20, 147, 0.8) 1px, transparent 2px),
					radial-gradient(circle at 80% 20%, rgba(138, 43, 226, 0.6) 1px, transparent 2px),
					radial-gradient(circle at 60% 80%, rgba(72, 61, 139, 0.4) 2px, transparent 4px);
				background-size: 800px 600px, 200px 150px, 300px 200px, 250px 180px;
				opacity: 0.8;
			}

			.parallax-stars-2 {
				background: radial-gradient(ellipse at 40% 60%,
					rgba(138, 43, 226, 0.2) 0%,
					rgba(75, 0, 130, 0.1) 50%,
					transparent 80%),
					radial-gradient(circle at 15% 85%, rgba(255, 20, 147, 0.9) 1px, transparent 2px),
					radial-gradient(circle at 70% 15%, rgba(138, 43, 226, 0.7) 1px, transparent 2px);
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

			.spell-container {
				position: relative;
				width: 100%;
				height: 100vh;
				overflow: hidden;
				cursor: grab;
				z-index: 1;
			}

			.spell-container.dragging { cursor: grabbing; }

			.spell-canvas {
				position: absolute;
				transform-origin: 0 0;
			}

			.connection-line {
				position: absolute;
				height: 3px;
				background: linear-gradient(90deg,
					rgba(138,43,226,0.8) 0%,
					rgba(147,112,219,0.6) 50%,
					rgba(138,43,226,0.4) 100%);
				transform-origin: left center;
				z-index: 5;
				border-radius: 1px;
				box-shadow: 0 0 4px rgba(138,43,226,0.3);
			}

			.connection-line.unlocked {
				background: linear-gradient(90deg,
					rgba(255,215,0,0.8) 0%,
					rgba(255,140,0,0.6) 50%,
					rgba(255,215,0,0.4) 100%);
				box-shadow: 0 0 4px rgba(255,215,0,0.3);
			}

			.spell-node {
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

			.spell-node.passive {
				background: url('research_base.png');
				border: 2px solid rgba(255, 215, 0, 0.5);
			}

			.spell-node img {
				width: 32px;
				height: 32px;
				object-fit: contain;
			}

			.spell-node.unlocked {
				background: url('research_known.png');
			}

			.spell-node.unlocked img {
				filter: hue-rotate(45deg) brightness(1.2) drop-shadow(0 0 4px rgba(255,215,0,0.8));
			}

			.spell-node.unlocked.passive img {
				filter: hue-rotate(90deg) brightness(1.2) drop-shadow(0 0 4px rgba(50,205,50,0.8));
			}

			.spell-node.available {
			}

			.spell-node.available img {
				filter: hue-rotate(20deg) brightness(1.1) drop-shadow(0 0 4px rgba(255,165,0,0.6));
			}

			.spell-node.locked img {
				opacity: 0.4;
				filter: grayscale(100%) brightness(0.7);
			}

			.spell-node.selected {
				background: url('research_selected.png');
				transform: scale(1.05);
			}

			.spell-node.selected img {
				filter: hue-rotate(-30deg) brightness(1.3) drop-shadow(0 0 8px rgba(255, 69, 0, 0.8));
			}

			.spell-node:hover {
				background: url('research_hover.png');
				transform: scale(1.15);
				z-index: 100;
			}

			.spell-node:hover img {
				filter: brightness(1.4) drop-shadow(0 0 6px rgba(255, 255, 255, 0.8));
			}

			.tooltip {
				position: absolute;
				background: rgba(15,15,30,0.95);
				border: 2px solid #8a2be2;
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

			.tooltip.passive h3 {
				color: #32CD32;
				text-shadow: 0 0 4px rgba(50,205,50,0.5);
			}

			.tooltip p { margin: 5px 0; font-size: 12px; }
			.requirements { color: #FF6B6B; }
			.unlocks { color: #4ECDC4; }
			.passive-info { color: #32CD32; }

			.info-panel {
				position: fixed;
				bottom: 10px;
				left: 10px;
				background: rgba(15,15,30,0.9);
				border: 2px solid #8a2be2;
				border-radius: 8px;
				padding: 10px;
				color: #FFD700;
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

		<div class="spell-container" id="container">
			<div class="spell-canvas" id="canvas">
				[generate_connections_html()]
				[generate_nodes_html()]
			</div>
		</div>

		<div class="info-panel">
			<div>Spell Points: [user.spell_points - user.used_spell_points]/[user.spell_points]</div>
		</div>

		<div class="tooltip" id="tooltip" style="display: none;"></div>

		<script>
			let isDragging = false;
			let startX, startY;
			let currentX = 400, currentY = 300;
			let scale = 1;

			// Load saved position
			try {
				const savedX = sessionStorage.getItem('spell_pos_x');
				const savedY = sessionStorage.getItem('spell_pos_y');
				const savedScale = sessionStorage.getItem('spell_scale');
				if (savedX !== null) currentX = parseFloat(savedX);
				if (savedY !== null) currentY = parseFloat(savedY);
				if (savedScale !== null) scale = parseFloat(savedScale);
			} catch(e) {
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

			// Event listeners (same as your research matrix)
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
				if (e.target.classList.contains('spell-node') || e.target.parentElement.classList.contains('spell-node')) {
					const node = e.target.classList.contains('spell-node') ? e.target : e.target.parentElement;
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
				savePosition();
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

			function savePosition() {
				try {
					sessionStorage.setItem('spell_pos_x', currentX.toString());
					sessionStorage.setItem('spell_pos_y', currentY.toString());
					sessionStorage.setItem('spell_scale', scale.toString());
				} catch(e) {
					// Silently fail
				}
			}

			function showTooltip(e, node) {
				try {
					const nodeData = JSON.parse(node.dataset.nodeinfo);
					const isPassive = node.classList.contains('passive');

					let html = '<h3>' + nodeData.name + '</h3>';
					html += '<p>' + nodeData.desc + '</p>';
					html += '<p><strong>Cost:</strong> ' + nodeData.cost + ' spell points</p>';

					if (isPassive) {
						html += '<p class="passive-info"><strong>Type:</strong> Passive Ability</p>';
					}

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
					tooltip.className = 'tooltip' + (isPassive ? ' passive' : '');
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

			function selectSpell(spellType) {
				savePosition();
				window.location.href = "byond://?src=[REF(matrix)];action=learn_spell;spell=" + spellType;
			}

			updateParallax();
		</script>
	</body>
	</html>
	"}

	return html

/datum/spell_interface/proc/generate_nodes_html()
	var/html = ""
	var/center_x = 0
	var/center_y = 0

	for(var/datum/spell_node/node_type as anything in subtypesof(/datum/spell_node))
		var/datum/spell_node/node = new node_type
		var/is_unlocked = (node_type in matrix.unlocked_spells)
		var/is_available = is_unlocked || can_learn_spell(node)
		var/is_selected = (matrix.selected_spell && matrix.selected_spell.type == node_type)

		var/class_list = "spell-node"
		if(node.is_passive)
			class_list += " passive"
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
		for(var/prereq_type in node.prerequisites)
			var/datum/spell_node/prereq = new prereq_type
			var/status = (prereq_type in matrix.unlocked_spells) ? "✓" : "✗"
			req_text += "[status] [prereq.name]"
			qdel(prereq)

		var/node_data = list(
			"name" = node.name,
			"desc" = node.desc,
			"cost" = node.cost,
			"requirements" = req_text,
			"unlocks" = node.unlocks,
			"is_passive" = node.is_passive
		)

		html += {"<div class="[class_list]"
			style="left: [node_x]px; top: [node_y]px;"
			data-nodeinfo='[json_encode(node_data)]'
			onclick="selectSpell('[node_type]')"
			title="[node.name]">
			<img src='\ref[node.icon]?state=[node.icon_state]' alt="[node.name]" />
		</div>"}

		qdel(node)

	return html

/datum/spell_interface/proc/generate_connections_html()
	var/html = ""
	var/center_x = 0
	var/center_y = 0

	var/list/node_positions = list()
	for(var/datum/spell_node/node_type as anything in subtypesof(/datum/spell_node))
		var/datum/spell_node/temp_node = new node_type
		node_positions[node_type] = list("x" = temp_node.node_x, "y" = temp_node.node_y)
		qdel(temp_node)

	for(var/datum/spell_node/node_type as anything in subtypesof(/datum/spell_node))
		var/datum/spell_node/node = new node_type

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

			var/angle = arctan(dx, dy)
			if(angle < 0)
				angle += 360

			var/is_unlocked_connection = (prereq_type in matrix.unlocked_spells) && (node_type in matrix.unlocked_spells)
			var/connection_class = "connection-line"
			if(is_unlocked_connection)
				connection_class += " unlocked"

			html += {"<div class="[connection_class]"
				style="left: [start_center_x]px; top: [start_center_y - 1.5]px; width: [distance]px; transform: rotate([angle]deg); transform-origin: 0 50%; z-index: 1;">
			</div>"}

		qdel(node)
	return html

/datum/spell_interface/proc/can_learn_spell(datum/spell_node/node)
	for(var/prereq in node.prerequisites)
		if(!(prereq in matrix.unlocked_spells))
			return FALSE
	if(node.cost > user.spell_points - user.used_spell_points)
		return FALSE

	return TRUE

