/obj/structure/ship_wheel
	name = "ship wheel"
	desc = "A large wooden ship wheel. Use it to navigate between islands."
	icon = 'icons/obj/helm.dmi'
	icon_state = "wheel"
	density = TRUE
	anchored = TRUE
	dir = EAST

	var/datum/ship_data/controlled_ship

	// Navigation state
	var/sailing_direction = 0 // Current direction (NORTH, SOUTH, etc.)
	var/sailing_speed = 0 // Current speed (0-100)
	var/max_sailing_speed = 20 // Maximum speed in leagues/tick

	//nav location and bounds
	var/nav_x = 0
	var/nav_y = 0
	var/const/nav_min = -1500
	var/const/nav_max = 1500

	var/datum/island_data/target_island = null // Island we're auto-navigating to
	var/const/course_correction_threshold = 20 // How far off course before recalculating

	// Docking prevention
	var/datum/island_data/last_docked_island = null // Track last island we were docked at
	var/undock_time = 0 // World.time when we last undocked
	var/const/redock_cooldown = 300 // 30 seconds (in deciseconds) before can redock at same island
	var/const/redock_min_distance = 100 // Must move at least this far away before can redock

	var/const/map_view_size = 1000 // Size of the visible map area
	var/const/map_zoom = 1.0 // Zoom level for the map

	// UI
	var/const/ui_x = 1200
	var/const/ui_y = 900


/obj/structure/ship_wheel/Initialize(mapload)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(find_controlled_ship))

/obj/structure/ship_wheel/proc/find_controlled_ship()
	sleep(10)
	controlled_ship = SSterrain_generation?.get_ship_at_location(loc)
	if(!controlled_ship)
		log_world("WARNING: Ship wheel at ([x], [y], [z]) not in a registered ship area!")
		return

	if(!controlled_ship.nav_x && !controlled_ship.nav_y)
		controlled_ship.nav_x = rand(nav_min, nav_max)
		controlled_ship.nav_y = rand(nav_min, nav_max)

	nav_x = controlled_ship.nav_x
	nav_y = controlled_ship.nav_y

/obj/structure/ship_wheel/attack_hand(mob/user)
	if(!controlled_ship)
		to_chat(user, span_warning("This wheel isn't connected to a ship!"))
		return

	interact(user)

/obj/structure/ship_wheel/interact(mob/user)
	user << browse_rsc('html/map.jpg')
	var/datum/browser/popup = new(user, "ship_wheel", "Ship Navigation", ui_x, ui_y)
	popup.set_content(get_ui_html(user))
	popup.open()

/obj/structure/ship_wheel/proc/get_ui_html(mob/user)
	var/dat = {"
		<html>
		<head>
			<style>
				body {
					background: #000000;
					color: #897472;
					font-family: monospace;
					margin: 0;
					padding: 10px;
				}
				.container {
					display: flex;
					gap: 10px;
				}
				.left-panel {
					flex: 1;
				}
				.right-panel {
					flex: 0 0 350px;
				}
				.section {
					background: #202020;
					border: 1px solid #2f1c37;
					padding: 10px;
					margin-bottom: 10px;
				}
				.section-title {
					font-size: 16px;
					font-weight: bold;
					color: #ae3636;
					margin-bottom: 10px;
					border-bottom: 2px solid #161616;
					padding-bottom: 5px;
				}
				.map-container {
					width: 100%;
					height: 100%;
					min-height: 700px;
					background: url('map.jpg') center/cover no-repeat;
					border: 1px solid #2f1c37;
					position: relative;
					overflow: hidden;
				}
				.map-grid {
					position: absolute;
					width: 100%;
					height: 100%;
				}
				.grid-line {
					position: absolute;
					background: #2f1c37;
				}
				.coordinate-label {
					position: absolute;
					color: #2f1c37;
					font-size: 10px;
					z-index: 1;
				}
				.ship-icon {
					position: absolute;
					width: 32px;
					height: 32px;
					transform: translate(-50%, -50%);
					z-index: 100;
				}
				.ship-icon img {
					width: 100%;
					height: 100%;
					image-rendering: pixelated;
				}
				.island-icon {
					position: absolute;
					width: 32px;
					height: 32px;
					transform: translate(-50%, -50%);
					cursor: pointer;
					z-index: 50;
				}
				.island-icon img {
					width: 100%;
					height: 100%;
					image-rendering: pixelated;
				}
				.island-icon:hover {
					filter: brightness(1.3);
				}
				.docked-island {
					filter: hue-rotate(90deg) brightness(1.5);
				}
				.target-island {
					filter: hue-rotate(180deg) brightness(1.5);
					animation: pulse 1.5s ease-in-out infinite;
				}
				.cooldown-island {
					filter: grayscale(1) brightness(0.6);
					cursor: not-allowed;
				}
				.matthios-island {
					animation: glow 2s ease-in-out infinite;
				}
				.island-player-badge {
					position: absolute;
					top: -5px;
					right: -5px;
					background: #ae3636;
					color: #ffffff;
					border-radius: 50%;
					width: 16px;
					height: 16px;
					display: flex;
					align-items: center;
					justify-content: center;
					font-size: 10px;
					font-weight: bold;
				}
				@keyframes pulse {
					0%, 100% { transform: translate(-50%, -50%) scale(1); }
					50% { transform: translate(-50%, -50%) scale(1.2); }
				}
				@keyframes glow {
					0%, 100% { filter: brightness(1); }
					50% { filter: brightness(1.5) drop-shadow(0 0 5px #ffff00); }
				}
				.controls {
					display: grid;
					grid-template-columns: repeat(3, 1fr);
					gap: 5px;
					margin: 10px 0;
				}
				.btn {
					background: #000000;
					border: 1px solid #000000;
					color: #7b5353;
					padding: 10px;
					cursor: pointer;
					font-family: monospace;
					font-size: 14px;
					text-align: center;
					text-decoration: none;
				}
				.btn:hover {
					background: #000000;
					border-color: #000000;
					color: #eac0b9;
					text-decoration: underline;
				}
				.btn:active {
					background: #000000;
				}
				.btn-active {
					background: #000000;
					border-color: #7b5353;
					color: #7b5353;
				}
				.btn-disabled {
					opacity: 0.3;
					cursor: not-allowed;
				}
				.btn-center {
					grid-column: 2;
					grid-row: 2;
				}
				.info-row {
					display: flex;
					justify-content: space-between;
					padding: 5px 0;
					border-bottom: 1px solid #2f1c37;
				}
				.info-label {
					color: #897472;
				}
				.info-value {
					color: #7b5353;
					font-weight: bold;
				}
				.speed-bar {
					width: 100%;
					height: 20px;
					background: #000000;
					border: 1px solid #2f1c37;
					position: relative;
					margin: 5px 0;
				}
				.speed-fill {
					height: 100%;
					background: #2f1c37;
					transition: width 0.3s;
				}
				.island-list {
					max-height: 200px;
					overflow-y: auto;
					scrollbar-color: #7b5353 #000000;
					scrollbar-width: thin;
				}
				.island-item {
					padding: 8px;
					margin: 5px 0;
					background: #000000;
					border: 1px solid #2f1c37;
					cursor: pointer;
				}
				.island-item:hover {
					background: #202020;
				}
				.island-item-target {
					background: #202020;
					border-color: #7b5353;
				}
				.island-item-cooldown {
					opacity: 0.5;
					cursor: not-allowed;
				}
				.island-item-cooldown:hover {
					background: #000000;
				}
				.difficulty-0 { color: #00ff00; }
				.difficulty-1 { color: #00ff00; }
				.difficulty-2 { color: #d09000; }
				.difficulty-3 { color: #d09000; }
				.difficulty-4 { color: #ff0000; }
				.warning-text {
					color: #d09000;
					font-size: 11px;
					margin-top: 3px;
				}
				.player-count {
					color: #ae3636;
					font-weight: bold;
					margin-left: 5px;
				}
				.matthios-indicator {
					color: #ffff00;
					font-size: 16px;
					margin-left: 5px;
					text-shadow: 0 0 5px #ffff00;
				}
				.modal {
					display: none;
					position: fixed;
					z-index: 1000;
					left: 0;
					top: 0;
					width: 100%;
					height: 100%;
					background-color: rgba(0,0,0,0.7);
				}
				.modal-content {
					background-color: #202020;
					margin: 15% auto;
					padding: 20px;
					border: 2px solid #ae3636;
					width: 400px;
					color: #897472;
				}
				.modal-title {
					color: #ae3636;
					font-size: 18px;
					font-weight: bold;
					margin-bottom: 15px;
				}
				.modal-buttons {
					display: flex;
					gap: 10px;
					margin-top: 20px;
					justify-content: flex-end;
				}
			</style>
		</head>
		<body>
			<div class='container'>
				<div class='left-panel'>
					<div class='section'>
						<div class='section-title'>NAVIGATION MAP</div>
						<div class='map-container' id='navMap'>
							<!-- Map will be drawn here -->
						</div>
					</div>
				</div>

				<div class='right-panel'>
					<div class='section'>
						<div class='section-title'>SHIP STATUS</div>
						<div class='info-row'>
							<span class='info-label'>Position:</span>
							<span class='info-value'>[round(nav_x)], [round(nav_y)]</span>
						</div>
						<div class='info-row'>
							<span class='info-label'>Heading:</span>
							<span class='info-value'>[dir2text(sailing_direction)]</span>
						</div>
						<div class='info-row'>
							<span class='info-label'>Status:</span>
							<span class='info-value'>[controlled_ship.docked_island ? "DOCKED" : (target_island ? "AUTO-NAVIGATING" : "AT SEA")]</span>
						</div>
						[controlled_ship.docked_island ? "<div class='info-row'><span class='info-label'>Location:</span><span class='info-value'>[controlled_ship.docked_island.island_name]</span></div>" : ""]
						[target_island && !controlled_ship.docked_island ? "<div class='info-row'><span class='info-label'>Destination:</span><span class='info-value'>[target_island.island_name]</span></div>" : ""]
						[target_island && !controlled_ship.docked_island ? "<div class='info-row'><span class='info-label'>ETA:</span><span class='info-value'>[get_eta_text()]</span></div>" : ""]
						[controlled_ship.docked_island ? "<div style='margin-top: 10px;'><a class='btn' href='javascript:void(0)' onclick='confirmUndock()' style='width: 100%'>UNDOCK</a></div>" : ""]
						[target_island && !controlled_ship.docked_island ? "<div style='margin-top: 10px;'><a class='btn' href='?src=[REF(src)];cancel_navigation=1' style='width: 100%'>CANCEL AUTO-NAV</a></div>" : ""]
					</div>

					<div class='section'>
						<div class='section-title'>SHIP CONTROL</div>
						<div class='controls'>
							<a class='btn' href='?src=[REF(src)];set_direction=[NORTHWEST]'>NW</a>
							<a class='btn' href='?src=[REF(src)];set_direction=[NORTH]'>N</a>
							<a class='btn' href='?src=[REF(src)];set_direction=[NORTHEAST]'>NE</a>
							<a class='btn' href='?src=[REF(src)];set_direction=[WEST]'>W</a>
							<a class='btn btn-center' href='?src=[REF(src)];stop=1'>STOP</a>
							<a class='btn' href='?src=[REF(src)];set_direction=[EAST]'>E</a>
							<a class='btn' href='?src=[REF(src)];set_direction=[SOUTHWEST]'>SW</a>
							<a class='btn' href='?src=[REF(src)];set_direction=[SOUTH]'>S</a>
							<a class='btn' href='?src=[REF(src)];set_direction=[SOUTHEAST]'>SE</a>
						</div>
						<div class='info-row'>
							<span class='info-label'>Speed:</span>
							<span class='info-value'>[sailing_speed]%</span>
						</div>
						<div class='speed-bar'>
							<div class='speed-fill' style='width: [sailing_speed]%'></div>
						</div>
						<a class='btn' href='?src=[REF(src)];adjust_speed=10' style='width: 46%; display: inline-block'>SPEED +</a>
						<a class='btn' href='?src=[REF(src)];adjust_speed=-10' style='width: 46%; display: inline-block; float: right'>SPEED -</a>
					</div>

					<div class='section'>
						<div class='section-title'>DISCOVERED ISLANDS</div>
						<div class='island-list'>
							[get_island_list_html()]
						</div>
					</div>
				</div>
			</div>

			<div id='undockModal' class='modal'>
				<div class='modal-content'>
					<div class='modal-title'>CONFIRM UNDOCK</div>
					<div id='undockMessage'></div>
					<div class='modal-buttons'>
						<a class='btn' href='javascript:void(0)' onclick='closeUndockModal()'>CANCEL</a>
						<a class='btn' href='?src=[REF(src)];undock=1&confirm=1' style='color: #ae3636;'>UNDOCK ANYWAY</a>
					</div>
				</div>
			</div>

			<script>
				var playersOnIsland = [length(controlled_ship.docked_island ? get_players_on_island(controlled_ship.docked_island) : list())];

				function confirmUndock() {
					if(playersOnIsland > 0) {
						document.getElementById('undockMessage').innerHTML =
							'<p>There ' + (playersOnIsland == 1 ? 'is <strong>1 player</strong>' : 'are <strong>' + playersOnIsland + ' players</strong>') +
							' currently on the island!</p>' +
							'<p style=\"color: #d09000;\">Undocking will leave them stranded. Are you sure?</p>';
						document.getElementById('undockModal').style.display = 'block';
					} else {
						window.location.href = '?src=[REF(src)];undock=1&confirm=1';
					}
				}

				function closeUndockModal() {
					document.getElementById('undockModal').style.display = 'none';
				}

				function drawMap() {
					var map = document.getElementById('navMap');
					var mapWidth = map.clientWidth;
					var mapHeight = map.clientHeight;
					var shipX = [nav_x];
					var shipY = [nav_y];
					var viewSize = [map_view_size];

					var minX = shipX - viewSize / 2;
					var maxX = shipX + viewSize / 2;
					var minY = shipY - viewSize / 2;
					var maxY = shipY + viewSize / 2;

					var gridSpacing = 100;
					var gridLines = Math.floor(viewSize / gridSpacing);

					for(var i = 0; i <= gridLines; i++) {
						var coordX = Math.floor(minX / gridSpacing) * gridSpacing + (i * gridSpacing);
						var coordY = Math.floor(minY / gridSpacing) * gridSpacing + (i * gridSpacing);

						var vlinePos = ((coordX - minX) / viewSize) * 100;
						if(vlinePos >= 0 && vlinePos <= 100) {
							var vline = document.createElement('div');
							vline.className = 'grid-line';
							vline.style.left = vlinePos + '%';
							vline.style.width = '1px';
							vline.style.height = '100%';
							map.appendChild(vline);
						}

						var hlinePos = ((coordY - minY) / viewSize) * 100;
						if(hlinePos >= 0 && hlinePos <= 100) {
							var hline = document.createElement('div');
							hline.className = 'grid-line';
							hline.style.top = (100 - hlinePos) + '%';
							hline.style.height = '1px';
							hline.style.width = '100%';
							map.appendChild(hline);
						}
					}

					[get_island_markers_js()]

					var ship = document.createElement('div');
					ship.className = 'ship-icon';
					ship.style.left = '50%';
					ship.style.top = '50%';
					ship.innerHTML = "<img src='\ref['icons/obj/overmap.dmi']?state=ship&dir=2' />";
					ship.title = 'Your Ship (' + Math.round(shipX) + ', ' + Math.round(shipY) + ')';
					map.appendChild(ship);
				}

				drawMap();
			</script>
		</body>
		</html>
	"}

	return dat

/obj/structure/ship_wheel/proc/get_eta_text()
	if(!target_island || sailing_speed == 0)
		return "N/A"

	var/distance = sqrt((nav_x - target_island.nav_x)**2 + (nav_y - target_island.nav_y)**2)
	var/move_speed = (sailing_speed / 100) * max_sailing_speed

	if(move_speed <= 0)
		return "N/A"

	var/seconds = round(distance / move_speed)

	if(seconds < 60)
		return "[seconds]s"
	else if(seconds < 3600)
		return "[round(seconds / 60)]m"
	else
		return "[round(seconds / 3600)]h"

/obj/structure/ship_wheel/proc/can_dock_at_island(datum/island_data/island)
	if(controlled_ship.docked_island)
		return FALSE

	if(last_docked_island == island)
		var/time_since_undock = world.time - undock_time
		if(time_since_undock < redock_cooldown)
			return FALSE

		var/distance = sqrt((nav_x - island.nav_x)**2 + (nav_y - island.nav_y)**2)
		if(distance < redock_min_distance)
			return FALSE

	return TRUE

/obj/structure/ship_wheel/proc/get_island_cooldown_text(datum/island_data/island)
	if(last_docked_island != island)
		return ""

	var/time_since_undock = world.time - undock_time
	var/time_remaining = redock_cooldown - time_since_undock

	if(time_remaining > 0)
		return "Cooldown: [round(time_remaining / 10)]s"

	var/distance = sqrt((nav_x - island.nav_x)**2 + (nav_y - island.nav_y)**2)
	if(distance < redock_min_distance)
		return "Too close: [round(distance)]/[redock_min_distance]"

	return ""

/obj/structure/ship_wheel/proc/get_players_on_island(datum/island_data/island)
	var/list/players = list()
	for(var/mob/living/M in GLOB.player_list)
		if(M.z == island.z_level)
			if(M.x >= island.bottom_left.x && M.x <= island.top_right.x)
				if(M.y >= island.bottom_left.y && M.y <= island.top_right.y)
					players += M
	return players

/obj/structure/ship_wheel/proc/get_island_ore_text(datum/island_data/island)
	var/list/ore_names = list()

	if(island.ore_types_upper && length(island.ore_types_upper))
		for(var/ore_name in island.ore_types_upper)
			if(!(ore_name in ore_names))
				ore_names += ore_name

	if(island.ore_types_lower && length(island.ore_types_lower))
		for(var/ore_name in island.ore_types_lower)
			if(!(ore_name in ore_names))
				ore_names += ore_name

	if(!length(ore_names))
		return "Unknown"

	var/list/formatted_ores = list()
	for(var/ore_name in ore_names)
		formatted_ores += capitalize(ore_name)

	return jointext(formatted_ores, ", ")


/obj/structure/ship_wheel/proc/get_island_list_html()
	var/dat = ""
	for(var/datum/island_data/island in SSterrain_generation.island_registry)
		var/distance = sqrt((nav_x - island.nav_x)**2 + (nav_y - island.nav_y)**2)
		var/is_docked = controlled_ship.docked_island == island
		var/is_target = target_island == island
		var/can_dock = can_dock_at_island(island)
		var/cooldown_text = get_island_cooldown_text(island)
		var/list/players_on_island = get_players_on_island(island)
		var/player_count = length(players_on_island)

		var/ore_text = get_island_ore_text(island)

		var/tooltip = ""
		tooltip += "Distance: ~[round(distance)] leagues\\n"
		tooltip += "Coordinates: ([round(island.nav_x)], [round(island.nav_y)])\\n"
		tooltip += "Difficulty: [island.get_difficulty_text()]\\n"
		if(island.matthios_fragment)
			tooltip += "Contains: Matthios Fragment\\n"
		tooltip += "Ores: [ore_text]\\n"
		if(player_count > 0)
			tooltip += "Players on island: [player_count]\\n"
			for(var/mob/living/M in players_on_island)
				tooltip += "  - [M.real_name]\\n"

		dat += {"<div class='island-item [is_docked ? "docked-island" : ""] [is_target ? "island-item-target" : ""] [!can_dock && !is_docked ? "island-item-cooldown" : ""]'
			[!is_docked && can_dock ? "onclick=\"window.location.href='?src=[REF(src)];navigate_to=[island.island_id]'\"" : ""]
			title='[tooltip]'>
			<div>
				<strong class='difficulty-[island.difficulty]'>[island.island_name]</strong>
				[is_target ? "(DESTINATION)" : ""]
				[player_count > 0 ? "<span class='player-count'>([player_count])</span>" : ""]
				[island.matthios_fragment ? "<span class='matthios-indicator'>Fragment of Matthios</span>" : ""]
			</div>
			<div class='info-label'>Difficulty: [island.get_difficulty_text()]</div>
			<div class='info-label'>Distance: ~[round(distance)] leagues</div>
			<div class='info-label'>Ores: [ore_text]</div>
			[player_count > 0 ? "<div class='info-label' style='color: #7b5353;'>[player_count] player[player_count > 1 ? "s" : ""] present</div>" : ""]
			[cooldown_text ? "<div class='warning-text'>[cooldown_text]</div>" : ""]
			[!is_docked && can_dock ? "<div class='info-label' style='color: #7b5353; margin-top: 5px;'>Click to navigate</div>" : ""]
		</div>"}

	if(!length(SSterrain_generation.island_registry))
		dat += "<div class='info-label'>No islands discovered</div>"

	return dat


/obj/structure/ship_wheel/proc/get_island_markers_js()
	var/js = ""
	var/view_size = map_view_size
	var/min_x = nav_x - view_size / 2
	var/max_x = nav_x + view_size / 2
	var/min_y = nav_y - view_size / 2
	var/max_y = nav_y + view_size / 2

	for(var/datum/island_data/island in SSterrain_generation.island_registry)
		if(island.nav_x < min_x || island.nav_x > max_x || island.nav_y < min_y || island.nav_y > max_y)
			continue

		var/x_percent = ((island.nav_x - min_x) / view_size) * 100
		var/y_percent = 100 - (((island.nav_y - min_y) / view_size) * 100)

		var/is_target = target_island == island
		var/is_docked = controlled_ship.docked_island == island
		var/can_dock = can_dock_at_island(island)
		var/list/players_on_island = get_players_on_island(island)
		var/player_count = length(players_on_island)
		var/ore_text = get_island_ore_text(island)

		// Build tooltip for map marker
		var/tooltip = "[island.island_name] ([round(island.nav_x)], [round(island.nav_y)])"
		if(island.matthios_fragment)
			tooltip += "\\nContains Matthios Fragment"
		tooltip += "\\nOres: [ore_text]"
		if(player_count > 0)
			tooltip += "\\n[player_count] player[player_count > 1 ? "s" : ""] present"
		if(!can_dock && !is_docked)
			tooltip += "\\nCOOLDOWN ACTIVE"

		js += {"
			var island[island.island_id] = document.createElement('div');
			island[island.island_id].className = 'island-icon [is_docked ? "docked-island" : ""] [is_target ? "target-island" : ""] [!can_dock && !is_docked ? "cooldown-island" : ""] [island.matthios_fragment ? "matthios-island" : ""]';
			island[island.island_id].style.left = '[x_percent]%';
			island[island.island_id].style.top = '[y_percent]%';
			island[island.island_id].innerHTML = "<img src='\ref['icons/obj/overmap.dmi']?state=event&dir=2' />[player_count > 0 ? "<span class='island-player-badge'>[player_count]</span>" : ""]";
			island[island.island_id].title = '[tooltip]';
			map.appendChild(island[island.island_id]);
		"}

	return js

/obj/structure/ship_wheel/Topic(href, href_list)
	if(..())
		return

	if(!isliving(usr))
		return

	if(!controlled_ship)
		return
	SEND_SIGNAL(usr, COMSIG_SHIP_SAILED)

	if(href_list["set_direction"])
		if(controlled_ship.docked_island)
			to_chat(usr, span_warning("The ship must be undocked before sailing!"))
			return

		var/new_dir = text2num(href_list["set_direction"])
		sailing_direction = new_dir
		target_island = null

		if(sailing_speed == 0)
			sailing_speed = 50

		START_PROCESSING(SSobj, src)
		notify_crew("Course set to [dir2text(new_dir)]!")

	if(href_list["stop"])
		sailing_direction = 0
		sailing_speed = 0
		target_island = null
		STOP_PROCESSING(SSobj, src)
		notify_crew("Ship coming to a stop.")

	if(href_list["adjust_speed"])
		if(controlled_ship.docked_island)
			to_chat(usr, span_warning("The ship must be undocked before adjusting speed!"))
			return

		var/adjustment = text2num(href_list["adjust_speed"])
		sailing_speed = clamp(sailing_speed + adjustment, 0, 100)

		if(sailing_speed == 0)
			STOP_PROCESSING(SSobj, src)
		else if(sailing_direction)
			START_PROCESSING(SSobj, src)

	if(href_list["undock"])
		if(controlled_ship.docked_island)
			if(!href_list["confirm"])
				to_chat(usr, span_warning("Undock request requires confirmation!"))
				return

			var/datum/island_data/island = controlled_ship.docked_island
			if(SSterrain_generation.undock_ship(controlled_ship))
				last_docked_island = island
				undock_time = world.time
				notify_crew("Ship has undocked and is now at sea!")

	if(href_list["cancel_navigation"])
		target_island = null
		sailing_direction = 0
		sailing_speed = 0
		STOP_PROCESSING(SSobj, src)
		notify_crew("Auto-navigation cancelled.")

	if(href_list["navigate_to"])
		if(controlled_ship.docked_island)
			to_chat(usr, span_warning("The ship must be undocked before sailing!"))
			return

		var/target_island_id = href_list["navigate_to"]
		var/datum/island_data/found_island = null

		for(var/datum/island_data/island in SSterrain_generation.island_registry)
			if(island.island_id == target_island_id)
				found_island = island
				break

		if(found_island)
			if(!can_dock_at_island(found_island))
				var/cooldown_text = get_island_cooldown_text(found_island)
				to_chat(usr, span_warning("Cannot navigate to [found_island.island_name] yet! [cooldown_text]"))
				return

			var/distance = sqrt((nav_x - found_island.nav_x)**2 + (nav_y - found_island.nav_y)**2)

			if(distance <= 5)
				to_chat(usr, span_notice("Already at [found_island.island_name]!"))
				return

			target_island = found_island

			if(sailing_speed == 0)
				sailing_speed = 50

			calculate_course_to_target()
			START_PROCESSING(SSobj, src)
			notify_crew("Auto-navigation engaged! Setting course for [target_island.island_name]!")

	interact(usr)

/obj/structure/ship_wheel/proc/calculate_course_to_target()
	if(!target_island)
		return

	var/dx = target_island.nav_x - nav_x
	var/dy = target_island.nav_y - nav_y

	var/new_direction = 0

	if(dy > 5)
		new_direction |= NORTH
	else if(dy < -5)
		new_direction |= SOUTH

	if(dx > 5)
		new_direction |= EAST
	else if(dx < -5)
		new_direction |= WEST

	if(new_direction)
		sailing_direction = new_direction

/obj/structure/ship_wheel/process()
	if(!sailing_direction || sailing_speed == 0)
		STOP_PROCESSING(SSobj, src)
		return

	if(controlled_ship.docked_island)
		STOP_PROCESSING(SSobj, src)
		return

	if(target_island)
		var/dx = target_island.nav_x - nav_x
		var/dy = target_island.nav_y - nav_y
		var/distance = sqrt(dx**2 + dy**2)

		var/ideal_dir = 0
		if(dy > 5)
			ideal_dir |= NORTH
		else if(dy < -5)
			ideal_dir |= SOUTH

		if(dx > 5)
			ideal_dir |= EAST
		else if(dx < -5)
			ideal_dir |= WEST

		if(ideal_dir != sailing_direction || distance < course_correction_threshold)
			calculate_course_to_target()

	var/move_speed = (sailing_speed / 100) * max_sailing_speed

	if(sailing_direction & NORTH)
		nav_y += move_speed
	if(sailing_direction & SOUTH)
		nav_y -= move_speed
	if(sailing_direction & EAST)
		nav_x += move_speed
	if(sailing_direction & WEST)
		nav_x -= move_speed

	nav_x = clamp(nav_x, nav_min, nav_max)
	nav_y = clamp(nav_y, nav_min, nav_max)

	controlled_ship.nav_x = nav_x
	controlled_ship.nav_y = nav_y

	check_island_proximity()

/obj/structure/ship_wheel/proc/check_island_proximity()
	if(controlled_ship.docked_island)
		return

	var/dock_range = 30

	for(var/datum/island_data/island in SSterrain_generation.island_registry)
		// Skip islands that are on cooldown
		if(!can_dock_at_island(island))
			continue

		var/distance = sqrt((nav_x - island.nav_x)**2 + (nav_y - island.nav_y)**2)

		if(distance <= dock_range)
			sailing_direction = 0
			sailing_speed = 0
			target_island = null
			STOP_PROCESSING(SSobj, src)

			if(SSterrain_generation.dock_ship_to_island(controlled_ship, island))
				notify_crew("Approaching [island.island_name]... Ship is now docking!")
				nav_x = island.nav_x
				nav_y = island.nav_y
				controlled_ship.nav_x = nav_x
				controlled_ship.nav_y = nav_y

			break

/obj/structure/ship_wheel/proc/notify_crew(message)
	for(var/mob/M in GLOB.player_list)
		if(M.z == controlled_ship.z_level)
			to_chat(M, span_notice("<b>\[Ship Navigation\]</b> [message]"))

/obj/structure/ship_wheel/Destroy()
	STOP_PROCESSING(SSobj, src)
	target_island = null
	last_docked_island = null
	return ..()

/obj/structure/ship_wheel/examine(mob/user)
	. = ..()
	if(controlled_ship)
		. += span_info("Current position: <b>([round(nav_x)], [round(nav_y)])</b>")
		if(controlled_ship.docked_island)
			. += span_info("The ship is docked at <b>[controlled_ship.docked_island.island_name]</b>.")
		else
			. += span_info("The ship is sailing at <b>[sailing_speed]%</b> speed.")
			if(sailing_direction)
				. += span_info("Current heading: <b>[dir2text(sailing_direction)]</b>")
			if(target_island)
				. += span_info("Auto-navigating to: <b>[target_island.island_name]</b>")
		. += span_info("Click to access the navigation console.")
	else
		. += span_warning("This wheel doesn't seem to be connected to a ship...")
