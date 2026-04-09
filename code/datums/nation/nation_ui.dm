/datum/nation/proc/open_trade_ui(mob/user)
	if(!user?.client)
		return

	ui_users |= user
	var/html = generate_trade_html(user)
	user << browse(html, "window=trade_program;size=1200x800")
	onclose(user, "trade_program", src)

/datum/nation/proc/update_ui()
	var/list/data = get_ui_data()
	var/json_data = json_encode(data)

	for(var/mob/user in ui_users)
		if(!user?.client)
			ui_users -= user
			continue
		user << output(json_data, "trade_program.browser:updateData")

/datum/nation/proc/get_ui_data()
	var/list/data = list()

	data["rep"] = nation_rep
	data["completed_count"] = length(completed_trades)

	var/count = 0
	for(var/datum/trade_agreement/assign in active_agreements)
		if(assign.active)
			count++

	data["active_count"] = count

	var/list/nodes_data = list()
	for(var/datum/trade/node in nodes)
		var/is_completed = (node.type in completed_trades)
		var/is_available = !is_completed && (node in lazyman)

		var/list/node_data = list(
			"id" = "[node.type]",
			"name" = node.name,
			"desc" = node.desc,
			"status" = is_completed ? "completed" : (is_available ? "available" : "locked"),
			"current" = node.current_imports,
			"target" = node.target_imports,
			"icon" = node.trade_icon ? "\ref[node.trade_icon]" : null,
			"icon_state" = node.trade_icon_state
		)

		if(length(node.required_trades))
			var/list/prereqs = list()
			for(var/required_path in node.required_trades)
				var/datum/trade/req_node = find_node_by_path(required_path)
				if(req_node)
					prereqs += list(list(
						"name" = req_node.name,
						"completed" = (required_path in completed_trades)
					))
			node_data["prerequisites"] = prereqs

		if(length(node.acceptable_imports))
			var/list/imports = list()
			for(var/item_path in node.acceptable_imports)
				imports += get_item_name(item_path)
			node_data["accepts"] = imports

		if(length(node.supply_packs))
			var/list/names = list()
			for(var/datum/supply_pack/pack as anything in node.supply_packs)
				names += initial(pack.name)
			node_data["unlocks"] = names

		nodes_data += list(node_data)

	data["nodes"] = nodes_data

	var/list/agreements_data = list()
	for(var/datum/trade_agreement/agreement in active_agreements)
		var/original = agreement.max_requested
		var/remaining = agreement.amount_requested
		var/progress = original > 0 ? ((original - remaining) / original) * 100 : 0

		var/list/agreement_data = list(
			"id" = "\ref[agreement]",
			"name" = agreement.name,
			"desc" = agreement.desc,
			"active" = agreement.active,
			"remaining" = remaining,
			"progress" = progress,
			"reward" = agreement.mammon_reward
		)

		if(length(agreement.required_items))
			var/list/items = list()
			for(var/item_path in agreement.required_items)
				items += get_item_name(item_path)
			agreement_data["required_items"] = items

		if(agreement.time && agreement.fail_time)
			agreement_data["time_remaining"] = (agreement.fail_time - world.time) / 10

		if(length(agreement.reward_items))
			agreement_data["bonus_items"] = length(agreement.reward_items)

		agreements_data += list(agreement_data)

	data["agreements"] = agreements_data

	return data

/datum/nation/proc/generate_trade_html(mob/user)
	var/list/html_parts = list()

	html_parts += {"<!DOCTYPE html>
<html>
<head>
	<meta charset='UTF-8'>
	<style>
		* {
			margin: 0;
			padding: 0;
			box-sizing: border-box;
		}

		body {
			background: #1a1a1a;
			color: #00ff00;
			font-family: 'Courier New', monospace;
			overflow: hidden;
			height: 100vh;
		}

		.header {
			background: #0d0d0d;
			padding: 10px;
			border-bottom: 2px solid #00ff00;
			display: flex;
			justify-content: space-between;
			align-items: center;
		}

		.header h1 {
			font-size: 20px;
		}

		.status-bar {
			display: flex;
			gap: 20px;
			font-size: 14px;
		}

		.status-item {
			padding: 5px 10px;
			background: #2a2a2a;
			border: 1px solid #00ff00;
		}

		.main-container {
			display: flex;
			height: calc(100vh - 60px);
		}

		.tree-section {
			flex: 1;
			background: #0d0d0d;
			border-right: 2px solid #00ff00;
			overflow: hidden;
			position: relative;
			cursor: grab;
		}

		.tree-section.dragging {
			cursor: grabbing;
		}

		.tree-canvas {
			position: absolute;
			width: 4000px;
			height: 4000px;
			left: -1600px;
			top: -1600px;
		}

		.trade-node {
			position: absolute;
			width: 60px;
			height: 60px;
			border: 2px solid #00ff00;
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;
			cursor: pointer;
			transition: all 0.2s;
			font-size: 10px;
		}

		.trade-node:hover {
			transform: scale(1.1);
			box-shadow: 0 0 15px #00ff00;
			z-index: 100;
		}

		.trade-node.completed {
			background: #00ff00;
			color: #000;
			border-color: #00ff00;
		}

		.trade-node.available {
			background: #003300;
			border-color: #00ff00;
		}

		.trade-node.locked {
			background: #330000;
			border-color: #ff0000;
			color: #ff0000;
		}

		.trade-node img {
			width: 32px;
			height: 32px;
			image-rendering: pixelated;
		}

		.node-progress {
			position: absolute;
			bottom: -15px;
			font-size: 9px;
			white-space: nowrap;
		}

		.connection-line {
			position: absolute;
			background: #00ff00;
			transform-origin: top left;
			pointer-events: none;
		}

		.connection-line.locked {
			background: #ff0000;
		}

		.agreements-section {
			width: 400px;
			background: #0d0d0d;
			display: flex;
			flex-direction: column;
		}

		.section-header {
			padding: 15px;
			background: #1a1a1a;
			border-bottom: 2px solid #00ff00;
			font-size: 16px;
			font-weight: bold;
		}

		.agreements-list {
			flex: 1;
			overflow-y: auto;
			padding: 10px;
		}

		.agreement-card {
			background: #1a1a1a;
			border: 1px solid #00ff00;
			margin-bottom: 10px;
			padding: 12px;
			cursor: pointer;
			transition: all 0.2s;
			position: relative;
		}

		.agreement-card:hover {
			border-color: #00ffff;
			box-shadow: 0 0 10px rgba(0, 255, 0, 0.3);
		}

		.agreement-card.inactive {
			opacity: 0.6;
			border-color: #666;
		}

		.agreement-title {
			font-weight: bold;
			margin-bottom: 5px;
			font-size: 14px;
		}

		.agreement-desc {
			font-size: 11px;
			color: #aaa;
			margin-bottom: 8px;
		}

		.agreement-progress {
			display: flex;
			justify-content: space-between;
			margin-bottom: 5px;
			font-size: 12px;
		}

		.progress-bar {
			width: 100%;
			height: 8px;
			background: #333;
			border: 1px solid #00ff00;
			margin-bottom: 5px;
		}

		.progress-fill {
			height: 100%;
			background: #00ff00;
			transition: width 0.3s;
		}

		.agreement-rewards {
			font-size: 11px;
			color: #ffff00;
		}

		.required-items {
			margin-top: 5px;
			font-size: 10px;
		}

		.item-tag {
			display: inline-block;
			background: #2a2a2a;
			padding: 2px 6px;
			margin: 2px;
			border: 1px solid #00ff00;
		}

		.btn {
			padding: 8px 15px;
			background: #003300;
			border: 1px solid #00ff00;
			color: #00ff00;
			cursor: pointer;
			font-family: 'Courier New', monospace;
			transition: all 0.2s;
		}

		.btn:hover {
			background: #00ff00;
			color: #000;
		}

		.tooltip {
			position: fixed;
			background: #000;
			border: 2px solid #00ff00;
			padding: 10px;
			z-index: 1000;
			pointer-events: none;
			max-width: 300px;
			font-size: 12px;
			display: none;
		}

		.tooltip-title {
			font-weight: bold;
			margin-bottom: 5px;
			color: #00ffff;
		}

		.tooltip-section {
			margin-top: 5px;
			padding-top: 5px;
			border-top: 1px solid #00ff00;
		}

		::-webkit-scrollbar {
			width: 10px;
		}

		::-webkit-scrollbar-track {
			background: #0d0d0d;
		}

		::-webkit-scrollbar-thumb {
			background: #00ff00;
			border: 1px solid #0d0d0d;
		}
	</style>
</head>
<body>
	<div class='header'>
		<h1>[name] National Information</h1>
		<div class='status-bar'>
			<div class='status-item' id='stat-rep'>REP: <span id='rep-value'>[nation_rep]</span></div>
			<div class='status-item' id='stat-completed'>COMPLETED: <span id='completed-value'>[length(completed_trades)]</span></div>
			<div class='status-item' id='stat-active'>ACTIVE: <span id='active-value'>[length(active_agreements)]</span></div>
		</div>
	</div>

	<div class='main-container'>
		<div class='tree-section' id='treeSection'>
			<div class='tree-canvas' id='treeCanvas'>
			</div>
		</div>

		<div class='agreements-section'>
			<div class='section-header'>Active Agreements</div>
			<div class='agreements-list' id='agreementsList'>
			</div>
		</div>
	</div>

	<div class='tooltip' id='tooltip'></div>

	<script>
		let currentData = null;
		let nodePositions = {};

		function calculateNodePositions(nodes) {
			const positions = {};
			const nodeMap = new Map();

			nodes.forEach(node => nodeMap.set(node.id, node));

			// Build layer assignments
			const layers = \[\];
			const layerMap = new Map();

			function getLayer(nodeId, visited = new Set()) {
				if (layerMap.has(nodeId)) return layerMap.get(nodeId);
				if (visited.has(nodeId)) return 0;

				const node = nodeMap.get(nodeId);
				if (!node || !node.prerequisites || node.prerequisites.length === 0) {
					layerMap.set(nodeId, 0);
					return 0;
				}

				visited.add(nodeId);
				let maxLayer = -1;

				node.prerequisites.forEach(prereq => {
					const parent = nodes.find(n => n.name === prereq.name);
					if (parent) {
						maxLayer = Math.max(maxLayer, getLayer(parent.id, visited));
					}
				});

				visited.delete(nodeId);
				const layer = maxLayer + 1;
				layerMap.set(nodeId, layer);
				return layer;
			}

			nodes.forEach(node => {
				const layer = getLayer(node.id);
				if (!layers\[layer\]) layers\[layer\] = \[\];
				layers\[layer\].push(node);
			});

			const horizontalSpacing = 200;
			const verticalSpacing = 200;
			const startY = 1800;

			// Position root layer centered
			const rootLayer = layers\[0\];
			const rootCount = rootLayer.length;
			const rootWidth = (rootCount - 1) * horizontalSpacing;
			const rootStartX = 2000 - (rootWidth / 2);

			rootLayer.forEach((node, i) => {
				positions\[node.id\] = {
					x: rootStartX + i * horizontalSpacing,
					y: startY
				};
			});

			// For each subsequent layer, position nodes based on parent relationships
			for (let layerIdx = 1; layerIdx < layers.length; layerIdx++) {
				const layer = layers\[layerIdx\];
				const positioned = new Set();

				// Group nodes by their parent sets to identify branches
				const branches = new Map();

				layer.forEach(node => {
					const parentIds = \[\];
					if (node.prerequisites) {
						node.prerequisites.forEach(prereq => {
							const parent = nodes.find(n => n.name === prereq.name);
							if (parent) parentIds.push(parent.id);
						});
					}
					parentIds.sort();
					const branchKey = parentIds.join(',');

					if (!branches.has(branchKey)) {
						branches.set(branchKey, \[\]);
					}
					branches.get(branchKey).push(node);
				});

				// Sort branches by leftmost parent
				const branchArray = Array.from(branches.entries()).map((\[key, nodes\]) => {
					const parentIds = key.split(',').filter(id => id);
					let minX = Infinity;
					parentIds.forEach(pid => {
						if (positions\[pid\]) {
							minX = Math.min(minX, positions\[pid\].x);
						}
					});
					return { key, nodes, minX, parentIds };
				});

				branchArray.sort((a, b) => a.minX - b.minX);

				// Position each branch
				let currentX = 1500; // Start from left

				branchArray.forEach(branch => {
					const branchNodes = branch.nodes;

					// Calculate ideal X position (average of parents)
					let targetX = 0;
					let parentCount = 0;
					branch.parentIds.forEach(pid => {
						if (positions\[pid\]) {
							targetX += positions\[pid\].x;
							parentCount++;
						}
					});

					if (parentCount > 0) {
						targetX = targetX / parentCount;
					} else {
						targetX = currentX;
					}

					// Make sure we don't overlap with previous branch
					targetX = Math.max(targetX, currentX);

					// Position nodes in this branch
					if (branchNodes.length === 1) {
						positions\[branchNodes\[0\].id\] = {
							x: targetX,
							y: startY + layerIdx * verticalSpacing
						};
						currentX = targetX + horizontalSpacing;
					} else {
						// Multiple nodes in branch - spread them out
						const branchWidth = (branchNodes.length - 1) * horizontalSpacing;
						const branchStartX = targetX - (branchWidth / 2);

						branchNodes.forEach((node, i) => {
							positions\[node.id\] = {
								x: branchStartX + i * horizontalSpacing,
								y: startY + layerIdx * verticalSpacing
							};
						});

						currentX = branchStartX + branchWidth + horizontalSpacing;
					}
				});
			}

			return positions;
		}

		function calculateDepth(node, allNodes, visited = new Set()) {
			if (visited.has(node.id)) return 0;
			visited.add(node.id);

			if (!node.prerequisites || node.prerequisites.length === 0) return 0;

			let maxDepth = 0;
			node.prerequisites.forEach(prereq => {
				const parent = allNodes.find(n => n.name === prereq.name);
				if (parent) {
					const parentDepth = calculateDepth(parent, allNodes, visited);
					maxDepth = Math.max(maxDepth, parentDepth);
				}
			});

			return maxDepth + 1;
		}

		function drawConnectionLine(fromPos, toPos, isLocked) {
			const dx = toPos.x - fromPos.x;
			const dy = toPos.y - fromPos.y;

			if(dx === 0 && dy === 0) return '';

			const lockClass = isLocked ? 'locked' : '';

			// Starting point (center of parent node)
			const startX = fromPos.x + 30;
			const startY = fromPos.y + 30;

			// Ending point (center of child node)
			const endX = toPos.x + 30;
			const endY = toPos.y + 30;

			// Calculate midpoint for the bend
			const midY = startY + (endY - startY) / 2;

			let html = '';

			// Vertical line from parent node down to midpoint
			const verticalHeight = Math.abs(midY - startY);
			html += `<div class='connection-line ${lockClass}' style='left: ${startX}px; top: ${Math.min(startY, midY)}px; width: 2px; height: ${verticalHeight}px;'></div>`;

			// Horizontal line at midpoint connecting the two vertical lines
			const horizontalWidth = Math.abs(endX - startX);
			html += `<div class='connection-line ${lockClass}' style='left: ${Math.min(startX, endX)}px; top: ${midY}px; width: ${horizontalWidth}px; height: 2px;'></div>`;

			// Vertical line from midpoint up to child node
			const verticalHeight2 = Math.abs(endY - midY);
			html += `<div class='connection-line ${lockClass}' style='left: ${endX}px; top: ${Math.min(midY, endY)}px; width: 2px; height: ${verticalHeight2}px;'></div>`;

			return html;
		}

		function generateNodeTooltip(node) {
			let html = `<div class='tooltip-title'>${node.name}</div>`;
			html += `<div>${node.desc}</div>`;
			html += `<div class='tooltip-section'>`;
			html += `<b>Status:</b> ${node.status}<br>`;

			if(node.status === 'available' && node.current > 0) {
				html += `<b>Progress:</b> ${node.current} / ${node.target}<br>`;
			}

			html += `</div>`;

			if(node.prerequisites && node.prerequisites.length > 0) {
				html += `<div class='tooltip-section'><b>Prerequisites:</b><br>`;
				node.prerequisites.forEach(p => {
					const check = p.completed ? '\[+\]' : '\[ \]';
					html += `${check} ${p.name}<br>`;
				});
				html += `</div>`;
			}

			if(node.accepts && node.accepts.length > 0) {
				html += `<div class='tooltip-section'><b>Accepts:</b><br>`;
				node.accepts.forEach(item => html += `- ${item}<br>`);
				html += `</div>`;
			}

			if(node.unlocks && node.unlocks.length > 0) {
				html += `<div class='tooltip-section'><b>Unlocks:</b><br>`;
				node.unlocks.forEach(unlock => html += `- ${unlock}<br>`);
				html += `</div>`;
			}

			return html;
		}

		function generateAgreementTooltip(agreement) {
			let html = `<div class='tooltip-title'>${agreement.name}</div>`;
			html += `<div>${agreement.desc}</div>`;
			html += `<div class='tooltip-section'>`;
			html += `<b>Status:</b> ${agreement.active ? 'Active' : 'Inactive'}<br>`;
			html += `<b>Requested:</b> ${agreement.remaining} items<br>`;
			html += `<b>Reward:</b> ${agreement.reward} mammons`;

			if(agreement.bonus_items) {
				html += `<br><b>Bonus Items:</b> ${agreement.bonus_items} items`;
			}

			html += `</div>`;

			if(agreement.required_items && agreement.required_items.length > 0) {
				html += `<div class='tooltip-section'><b>Required Items:</b><br>`;
				agreement.required_items.forEach(item => html += `- ${item}<br>`);
				html += `</div>`;
			}

			if(agreement.time_remaining) {
				html += `<div class='tooltip-section'><b>Time Remaining:</b> ${agreement.time_remaining}s</div>`;
			}

			return html;
		}

		function renderTree(data) {
			const canvas = document.getElementById('treeCanvas');
			if(!canvas) return;

			nodePositions = calculateNodePositions(data.nodes);
			let html = '';

			data.nodes.forEach(node => {
				if(!node.prerequisites) return;
				const nodePos = nodePositions\[node.id\];

				node.prerequisites.forEach(prereq => {
					const parentNode = data.nodes.find(n => n.name === prereq.name);
					if(!parentNode) return;

					const parentPos = nodePositions\[parentNode.id\];
					const isLocked = node.status === 'locked';
					html += drawConnectionLine(parentPos, nodePos, isLocked);
				});
			});

			data.nodes.forEach(node => {
				const pos = nodePositions\[node.id\];
				const tooltip = generateNodeTooltip(node);

				html += `<div class='trade-node ${node.status}'
							 style='left: ${pos.x}px; top: ${pos.y}px;'
							 data-tooltip="${tooltip.replace(/"/g, '&quot;')}"
							 onclick='selectNode("${node.id}")'>`;

				if(node.icon && node.icon_state) {
					html += `<img src='${node.icon}?state=${node.icon_state}' alt='${node.name}'>`;
				} else {
					html += `<div style='font-size: 24px;'>?</div>`;
				}

				if(node.status === 'available' && node.current > 0) {
					html += `<div class='node-progress'>${node.current}/${node.target}</div>`;
				}

				html += `</div>`;
			});

			canvas.innerHTML = html;
		}

		function renderAgreements(data) {
			const list = document.getElementById('agreementsList');
			if(!list) return;

			if(data.agreements.length === 0) {
				list.innerHTML = `<div style='text-align: center; padding: 20px; color: #666;'>No active agreements</div>`;
				return;
			}

			let html = '';
			data.agreements.forEach(agreement => {
				const inactiveClass = agreement.active ? '' : 'inactive';
				const tooltip = generateAgreementTooltip(agreement);

				html += `<div class='agreement-card ${inactiveClass}' data-tooltip="${tooltip.replace(/"/g, '&quot;')}">`;
				html += `<div class='agreement-title'>${agreement.name}</div>`;
				html += `<div class='agreement-progress'>`;
				html += `<span>Progress:</span>`;
				html += `<span>${agreement.remaining} remaining</span>`;
				html += `</div>`;
				html += `<div class='progress-bar'>`;
				html += `<div class='progress-fill' style='width: ${agreement.progress}%'></div>`;
				html += `</div>`;

				if(agreement.reward > 0) {
					html += `<div class='agreement-rewards'>Reward: ${agreement.reward} mammons</div>`;
				}

				if(!agreement.active) {
					html += `<div style='margin-top: 8px;'>`;
					html += `<button class='btn' onclick='activateAgreement("${agreement.id}");'>Activate</button>`;
					html += `</div>`;
				}

				html += `</div>`;
			});

			list.innerHTML = html;
		}

		function updateData(jsonData) {
			const data = JSON.parse(jsonData);
			currentData = data;

			document.getElementById('rep-value').textContent = data.rep;
			document.getElementById('completed-value').textContent = data.completed_count;
			document.getElementById('active-value').textContent = data.active_count;

			renderTree(data);

			renderAgreements(data);
		}

		window.addEventListener('load', function() {
			//we need to fetch data
			window.location.href = '?src=\ref[src];action=get_initial_data';
		});

		(function() {
			const treeSection = document.getElementById('treeSection');
			const treeCanvas = document.getElementById('treeCanvas');
			let isDragging = false;
			let startX, startY, scrollLeft, scrollTop;

			treeSection.addEventListener('mousedown', function(e) {
				if(!e.target) return;
				if(e.target.closest('.trade-node')) return;
				isDragging = true;
				treeSection.classList.add('dragging');
				startX = e.pageX;
				startY = e.pageY;
				const rect = treeCanvas.getBoundingClientRect();
				scrollLeft = -rect.left;
				scrollTop = -rect.top;
			});

			treeSection.addEventListener('mousemove', function(e) {
				if(!isDragging) return;
				e.preventDefault();
				const x = e.pageX - startX;
				const y = e.pageY - startY;
				treeCanvas.style.left = (x - scrollLeft) + 'px';
				treeCanvas.style.top = (y - scrollTop) + 'px';
			});

			treeSection.addEventListener('mouseup', function() {
				isDragging = false;
				treeSection.classList.remove('dragging');
			});

			treeSection.addEventListener('mouseleave', function() {
				isDragging = false;
				treeSection.classList.remove('dragging');
			});
		})();

		(function() {
			const tooltip = document.getElementById('tooltip');

			document.addEventListener('mouseenter', function(e) {
				const target = e.target.closest('\[data-tooltip\]');
				if(target) {
					const tooltipContent = target.getAttribute('data-tooltip');
					if(tooltipContent) {
						tooltip.innerHTML = tooltipContent;
						tooltip.style.display = 'block';
					}
				}
			}, true);

			document.addEventListener('mousemove', function(e) {
				if(tooltip.style.display === 'block') {
					tooltip.style.left = (e.pageX + 15) + 'px';
					tooltip.style.top = (e.pageY + 15) + 'px';
				}
			});

			document.addEventListener('mouseleave', function(e) {
				const target = e.target.closest('\[data-tooltip\]');
				if(target) {
					tooltip.style.display = 'none';
				}
			}, true);
		})();

		//this does shit all right now idk if we want it to though
		function selectNode(nodeId) {
			window.location.href = '?src=\ref[src];action=select_node;node=' + nodeId;
		}

		function activateAgreement(agreementId) {
			event.stopPropagation();
			window.location.href = '?src=\ref[src];action=activate_agreement;agreement=' + agreementId;
		}
	</script>
</body>
</html>"}

	return html_parts.Join()

/datum/nation/proc/find_node_by_path(node_path)
	for(var/datum/trade/node in nodes)
		if(node.type == node_path)
			return node
	return null

/datum/nation/proc/get_item_name(item_path)
	if(ispath(item_path))
		var/atom/A = item_path
		return initial(A.name)
	return "Unknown Item"

/datum/nation/Topic(href, href_list)
	. = ..()

	var/mob/user = usr
	if(!user?.client)
		return

	switch(href_list["action"])
		if("get_initial_data")
			//honestly more ui's should be doing this
			var/list/data = get_ui_data()
			var/json_data = json_encode(data)
			user << output(json_data, "trade_program.browser:updateData")

		if("activate_agreement")
			var/agreement_ref = href_list["agreement"]
			handle_agreement_activation(user, agreement_ref)
			update_ui()

/datum/nation/proc/handle_agreement_activation(mob/user, agreement_ref)
	for(var/datum/trade_agreement/agreement in active_agreements)
		if("\ref[agreement]" == agreement_ref)
			if(!activate_agreement(agreement))
				to_chat(user, "<span class='warning'>Agreement is already active.</span>")
			return
