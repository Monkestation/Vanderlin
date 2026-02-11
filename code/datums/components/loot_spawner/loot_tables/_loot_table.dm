/*
HOW THE SCALING WORKS:

1. DELVE LEVEL SCALING:
- Quantity: Higher delves spawn more items (base_min/max * delve_quantity_scaling^(delve_level-1))
- Quality: Rare items (low base weight) get exponentially better odds at higher delves
- Items with weight 1 become much more common at delve 5 vs delve 1
- Items with weight 50 see minimal change between delve levels

2. ITEM RARITY MULTIPLIER:
- Multiplicative with all other scaling
- item_rarity = 2.0 doubles all drop chances
- item_rarity = 0.5 halves all drop chances
- Works independently of delve scaling

3. COMBINED EFFECT:
- A rare item (weight 1) at delve 5 with 2.0 item rarity will be MUCH more common
- A common item (weight 100) sees less dramatic changes
- The system naturally creates better loot at higher delves while respecting player modifiers

CONFIGURATION:
- delve_quantity_scaling: How much more loot spawns per delve level (1.5 = 50% more per level)
- delve_rarity_scaling: How much rare items benefit from higher delves (1.3 = 30% bonus per level)
- min_delve_level/max_delve_level: Valid delve range for this table
*/

/datum/loot_table
	var/name = "generic table"
	///okay this is quite the different thing, essentially this works with 2 things, either a an assoc list of stat or skill
	///to list of items with weights. Or Just raw list with weights, these then get added in with bonuses based on their skills based on a minimum
	///you can set the minimum value in the second list or leave it default which is 0
	///if a number is in the list ie item_path = 5, 12 if you aren't higher then that level it just ends there
	///this does mean that you should structure it lowest to highest or you will run into issues
	var/list/loot_table = list()

	///this is our minimum skill list
	var/list/minimum_skill_list = list()
	///our growth factor for each skill
	var/list/growth_factor_list = list(
		STATKEY_LCK = 0.99
	)

	///this is at bare minimum spawn at base
	var/base_min = 1
	///this is at bare minimum our maximum spawn count. Luck and the scaling factor is added to this
	var/base_max = 3
	///how much each point of luck affects the max and minimum
	var/scaling_factor = 0.4

	///delve level scaling for loot quantity (multiplier per delve level)
	var/delve_quantity_scaling = 1.1
	///delve level scaling for rare loot weights (multiplier per delve level)
	var/delve_rarity_scaling = 1.3
	///minimum delve level for this loot table (1-5)
	var/min_delve_level = 1
	///maximum delve level for this loot table (1-5)
	var/max_delve_level = 5

/datum/loot_table/proc/spawn_loot(mob/living/looter = null, delve_level = 1, item_rarity = 1.0)
	var/list/weighted_list = return_list(looter, delve_level, item_rarity)
	var/mob_stat_level = 0

	if(istype(looter))
		mob_stat_level = looter.get_stat_level(STATKEY_LCK)

	// Apply delve level scaling to spawn counts
	var/delve_multiplier = delve_level >= min_delve_level ? (delve_quantity_scaling ** (delve_level - 1)) : 1

	var/adjusted_min = base_min + round(mob_stat_level * scaling_factor, 1)
	var/adjusted_max = base_max + round(mob_stat_level * scaling_factor, 1)

	// Scale by delve level - higher delves = more loot
	adjusted_min = round(adjusted_min * delve_multiplier, 1)
	adjusted_max = round(adjusted_max * delve_multiplier, 1)

	adjusted_min = min(adjusted_min, adjusted_max)
	var/spawn_count = rand(adjusted_min, adjusted_max)

	var/turf/spawn_location = looter ? get_turf(looter) : null

	var/list/loot = list()
	for(var/i = 1 to spawn_count)
		var/atom/spawn_path = pickweight(weighted_list)
		var/atom/movable/new_spawn = new spawn_path(spawn_location)
		if(spawn_location)
			if(istype(looter))
				looter.put_in_active_hand(new_spawn)
		loot += new_spawn
	return loot

/datum/loot_table/proc/return_list(mob/looter = null, delve_level = 1, item_rarity = 1.0)
	var/list/weighted_list = list()

	if(!istype(looter))
		for(var/thing in loot_table)
			if(islist(thing))
				var/list/temp_list = apply_delve_and_rarity_scaling(thing, delve_level, item_rarity)
				weighted_list |= temp_list
		return weighted_list

	for(var/thing in loot_table)
		if(islist(thing))
			var/list/temp_list = apply_delve_and_rarity_scaling(thing, delve_level, item_rarity)
			weighted_list |= temp_list
		if(thing in MOBSTATS)
			var/list/stat_list = return_stat_weight(thing, looter)
			var/list/scaled_stat_list = apply_delve_and_rarity_scaling(stat_list, delve_level, item_rarity)
			weighted_list |= scaled_stat_list
		if(ispath(thing, /datum/skill))
			var/list/skill_list = return_skill_weight(thing, looter)
			var/list/scaled_skill_list = apply_delve_and_rarity_scaling(skill_list, delve_level, item_rarity)
			weighted_list |= scaled_skill_list
	return weighted_list

/datum/loot_table/proc/apply_delve_and_rarity_scaling(list/input_list, delve_level = 1, item_rarity = 1.0)
	var/list/scaled_list = list()

	// Clamp delve level to valid range
	delve_level = max(min_delve_level, min(delve_level, max_delve_level))

	// Calculate delve scaling factor for rare items
	var/delve_rare_multiplier = delve_level >= min_delve_level ? (delve_rarity_scaling ** (delve_level - 1)) : 1

	for(var/item in input_list)
		if(isnum(item)) // Skip numeric delimiters
			continue

		var/base_weight = input_list[item]
		var/final_weight = base_weight

		// Apply delve level scaling (higher delves favor rarer items)
		// Items with lower base weights (rarer) get more benefit from higher delves
		if(base_weight > 0)
			// Rare items (low weight) benefit more from delve scaling
			var/rarity_factor = max(0.1, 1.0 / base_weight) // Lower weight = higher rarity factor
			var/delve_bonus = (delve_rare_multiplier - 1) * min(rarity_factor, 10) // Cap the bonus
			final_weight = base_weight * (1 + delve_bonus)

		// Apply item rarity multiplier (multiplicative)
		final_weight = final_weight * item_rarity

		scaled_list[item] = max(0.01, final_weight) // Ensure minimum weight

	return scaled_list

/datum/loot_table/proc/return_stat_weight(stat_key, mob/living/looter)
	var/list/weighted_list = list()
	var/list/pre_weight_list = loot_table[stat_key]

	var/mob_stat_level = looter?.get_stat_level(stat_key)
	var/minimum_stat_level = 0
	var/growth_factor = 1.02
	if(stat_key in growth_factor_list)
		growth_factor = growth_factor_list[stat_key]
	if(stat_key in minimum_skill_list)
		minimum_stat_level = minimum_skill_list[stat_key]
	mob_stat_level -= minimum_stat_level

	for(var/item in pre_weight_list)
		if(isnum(item))
			if(item > mob_stat_level)
				break
			continue
		var/base_weight = pre_weight_list[item]
		var/scaled_weight = base_weight * (1 + growth_factor ** mob_stat_level)
		if(mob_stat_level == 0)
			scaled_weight = base_weight
		weighted_list |= item
		weighted_list[item] = scaled_weight

	return weighted_list

/datum/loot_table/proc/return_skill_weight(datum/skill/skill_type, mob/living/looter)
	var/list/weighted_list = list()
	var/list/pre_weight_list = loot_table[skill_type]

	var/mob_skill_level = looter.get_skill_level(skill_type)
	var/minimum_skill_level = 0
	var/growth_factor = 1.05
	if(skill_type in growth_factor_list)
		growth_factor = growth_factor_list[skill_type]
	if(skill_type in minimum_skill_list)
		minimum_skill_level = minimum_skill_list[skill_type]
	mob_skill_level -= minimum_skill_level

	for(var/item in pre_weight_list)
		if(isnum(item))
			if(item > mob_skill_level)
				break
			continue
		var/base_weight = pre_weight_list[item]
		var/scaled_weight = base_weight * (1 + growth_factor ** mob_skill_level)
		if(mob_skill_level == 0)
			scaled_weight = base_weight
		weighted_list |= item
		weighted_list[item] = scaled_weight

	return weighted_list

/datum/loot_table/proc/debug_loot_table(mob/living/user, delve_level = 1, item_rarity = 1.0)
	if(!istype(user))
		return

	var/luck_stat = user.get_stat_level(STATKEY_LCK)

	// Calculate spawn quantities with delve scaling
	var/delve_multiplier = delve_level >= min_delve_level ? (delve_quantity_scaling ** (delve_level - 1)) : 1
	var/adjusted_min = base_min + round(luck_stat * scaling_factor, 1)
	var/adjusted_max = base_max + round(luck_stat * scaling_factor, 1)
	adjusted_min = round(adjusted_min * delve_multiplier, 1)
	adjusted_max = round(adjusted_max * delve_multiplier, 1)
	adjusted_min = min(adjusted_min, adjusted_max)
	var/avg_spawn = (adjusted_min + adjusted_max) / 2

	// Get weighted list for this user with delve and rarity scaling
	var/list/weighted_list = return_list(user, delve_level, item_rarity)
	var/total_weight = 0
	for(var/item in weighted_list)
		total_weight += weighted_list[item]

	// Build HTML output
	var/html = {"
	<html>
	<head>
		<title>Loot Table Debug - [type]</title>
		<style>
			body { font-family: Arial, sans-serif; margin: 10px; background: #1a1a1a; color: #ffffff; }
			.header { background: #333; padding: 10px; border-radius: 5px; margin-bottom: 10px; }
			.stats { background: #2a2a2a; padding: 8px; border-radius: 3px; margin: 5px 0; }
			.delve-controls { background: #2a4a2a; padding: 8px; border-radius: 3px; margin: 5px 0; }
			.loot-table { width: 100%; border-collapse: collapse; margin: 10px 0; }
			.loot-table th { background: #444; padding: 8px; text-align: left; border: 1px solid #555; }
			.loot-table td { padding: 6px 8px; border: 1px solid #555; background: #2a2a2a; }
			.loot-table tr:nth-child(even) td { background: #333; }
			.simulate-btn {
				background: #4CAF50; color: white; padding: 10px 20px;
				border: none; border-radius: 5px; cursor: pointer; margin: 5px;
				font-size: 14px;
			}
			.simulate-btn:hover { background: #45a049; }
			.stat-input {
				background: #333; color: white; padding: 5px; border: 1px solid #555;
				border-radius: 3px; width: 60px; margin: 0 5px;
			}
			.update-btn {
				background: #2196F3; color: white; padding: 5px 15px;
				border: none; border-radius: 3px; cursor: pointer; margin: 5px;
			}
			.update-btn:hover { background: #1976D2; }
			.stat-link {
				color: #4CAF50; text-decoration: none; margin-left: 10px;
				padding: 2px 8px; background: #333; border-radius: 3px;
				font-size: 12px;
			}
			.stat-link:hover { background: #4CAF50; color: white; }
			.reset-link {
				color: #f44336; text-decoration: none; margin-left: 5px;
				padding: 2px 8px; background: #333; border-radius: 3px;
				font-size: 12px;
			}
			.reset-link:hover { background: #f44336; color: white; }
			.results { background: #2a2a2a; padding: 10px; border-radius: 5px; margin: 10px 0; }
			.progress-bar {
				width: 100%; height: 20px; background: #444; border-radius: 10px;
				overflow: hidden; margin: 5px 0;
			}
			.progress-fill {
				height: 100%; background: linear-gradient(90deg, #4CAF50, #45a049);
				transition: width 0.3s ease;
			}
			.delve-btn {
				background: #673AB7; color: white; padding: 5px 10px;
				border: none; border-radius: 3px; cursor: pointer; margin: 2px;
				font-size: 12px;
			}
			.delve-btn:hover { background: #5E35B1; }
			.delve-btn.active { background: #FF9800; }
		</style>
		<script>
			function simulateLoot(times) {
				var btn = event.target;
				btn.disabled = true;
				btn.innerHTML = 'Simulating...';

				var delve = document.getElementById('delve-input').value;
				var rarity = document.getElementById('rarity-input').value;
				window.location = 'byond://?src=[ref(user)];action=simulate;times=' + times + ';user=[ref(user)];delve=' + delve + ';rarity=' + rarity;

				setTimeout(function() {
					btn.disabled = false;
					btn.innerHTML = 'Simulate ' + times + 'x';
				}, 2000);
			}

			function updateStats() {
				var luck = document.getElementById('luck-input').value;
				var delve = document.getElementById('delve-input').value;
				var rarity = document.getElementById('rarity-input').value;
				window.location = 'byond://?src=[ref(user)];action=update_stats;luck=' + luck + ';user=[ref(user)];delve=' + delve + ';rarity=' + rarity;
			}

			function setDelveLevel(level) {
				document.getElementById('delve-input').value = level;
				updateStats();
			}
		</script>
	</head>
	<body>
		<div class='header'>
			<h2>Loot Table Debug: [type]</h2>
		</div>

		<div class='stats'>
			<strong>Player Stats:</strong><br>
			Luck Level: [luck_stat]
			<a href='byond://?src=[ref(user)];action=change_luck;user=[ref(user)]' class='stat-link'>\[Change\]</a>
			<a href='byond://?src=[ref(user)];action=reset_debug;user=[ref(user)]' class='reset-link'>\[Reset\]</a><br>
			Spawn Range: [adjusted_min] - [adjusted_max] items (avg: [avg_spawn])<br>
			Scaling Factor: [scaling_factor]<br>
			Total Weight: [total_weight]
		</div>

		<div class='delve-controls'>
			<strong>Delve Level:</strong>
			<input type='number' id='delve-input' value='[delve_level]' min='1' max='5' class='stat-input'>
			<button class='delve-btn' onclick='setDelveLevel(1)'>D1</button>
			<button class='delve-btn' onclick='setDelveLevel(2)'>D2</button>
			<button class='delve-btn' onclick='setDelveLevel(3)'>D3</button>
			<button class='delve-btn' onclick='setDelveLevel(4)'>D4</button>
			<button class='delve-btn' onclick='setDelveLevel(5)'>D5</button><br>
			<strong>Item Rarity Multiplier:</strong>
			<input type='number' id='rarity-input' value='[item_rarity]' min='0.1' max='10' step='0.1' class='stat-input'>
			<button class='update-btn' onclick='updateStats()'>Update</button><br>
			<small>Delve Quantity Scaling: [delve_quantity_scaling]x | Delve Rarity Scaling: [delve_rarity_scaling]x</small>
		</div>

		<h3>Loot Probabilities (Delve [delve_level], Rarity [item_rarity]x)</h3>
		<table class='loot-table'>
			<tr>
				<th>Item</th>
				<th>Weight</th>
				<th>Chance %</th>
				<th>Progress</th>
			</tr>
	"}

	// Add each item to the table
	for(var/item in weighted_list)
		var/weight = weighted_list[item]
		var/chance = round((weight / total_weight) * 100, 0.1)
		var/progress_width = min((chance / (100/length(weighted_list))) * 100, 100)

		var/item_name = "[item]"
		if(ispath(item))
			var/atom/temp = item
			item_name = initial(temp.name) || "[item]"

		html += {"
			<tr>
				<td>[item_name]</td>
				<td>[weight]</td>
				<td>[chance]%</td>
				<td>
					<div class='progress-bar'>
						<div class='progress-fill' style='width: [progress_width]%'></div>
					</div>
				</td>
			</tr>
		"}

	html += {"
		</table>

		<h3>Simulation</h3>
		<div class='stats'>
			Click below to simulate loot generation multiple times and see actual results:
		</div>

		<button class='simulate-btn' onclick='simulateLoot(10)'>Simulate 10x</button>
		<button class='simulate-btn' onclick='simulateLoot(100)'>Simulate 100x</button>
		<button class='simulate-btn' onclick='simulateLoot(1000)'>Simulate 1000x</button>

		<div id='results' class='results' style='display: none;'>
			<h4>Simulation Results</h4>
			<div id='results-content'></div>
		</div>

	</body>
	</html>
	"}

	var/size_string = "size=800x700"
	if(user?.client.window_scaling)
		size_string = "size=[800 * user?.client?.window_scaling]x[700 * user?.client?.window_scaling]"

	user << browse(html, "window=loot_debug;[size_string]")

/datum/loot_table/proc/simulate_loot_generation(mob/living/user, times = 100, delve_level = 1, item_rarity = 1.0)
	var/list/results = list()
	var/total_items = 0
	var/list/weighted_list = return_list(user, delve_level, item_rarity)

	// Run simulation
	for(var/i = 1 to times)
		var/luck_stat = user.get_stat_level(STATKEY_LCK)
		var/delve_multiplier = delve_level >= min_delve_level ? (delve_quantity_scaling ** (delve_level - 1)) : 1
		var/adjusted_min = base_min + round(luck_stat * scaling_factor, 1)
		var/adjusted_max = base_max + round(luck_stat * scaling_factor, 1)
		adjusted_min = round(adjusted_min * delve_multiplier, 1)
		adjusted_max = round(adjusted_max * delve_multiplier, 1)
		adjusted_min = min(adjusted_min, adjusted_max)
		var/spawn_count = rand(adjusted_min, adjusted_max)
		total_items += spawn_count

		for(var/j = 1 to spawn_count)
			var/picked_item = pickweight(weighted_list)
			if(picked_item in results)
				results[picked_item]++
			else
				results[picked_item] = 1

	// Build results HTML
	var/html = {"
	<html>
	<head>
		<title>Simulation Results</title>
		<style>
			body { font-family: Arial, sans-serif; margin: 10px; background: #1a1a1a; color: #ffffff; }
			.header { background: #333; padding: 10px; border-radius: 5px; margin-bottom: 10px; }
			.results-table { width: 100%; border-collapse: collapse; margin: 10px 0; }
			.results-table th { background: #444; padding: 8px; text-align: left; border: 1px solid #555; }
			.results-table td { padding: 6px 8px; border: 1px solid #555; background: #2a2a2a; }
			.results-table tr:nth-child(even) td { background: #333; }
			.close-btn {
				background: #f44336; color: white; padding: 8px 16px;
				border: none; border-radius: 3px; cursor: pointer; float: right;
			}
		</style>
	</head>
	<body>
		<div class='header'>
			<button class='close-btn' onclick='window.close()'>Close</button>
			<h3>Simulation Results ([times] runs, Delve [delve_level], Rarity [item_rarity]x)</h3>
			<p>Total items generated: [total_items] (avg: [round(total_items/times, 0.1)] per run)</p>
		</div>

		<table class='results-table'>
			<tr>
				<th>Item</th>
				<th>Count</th>
				<th>Actual %</th>
				<th>Per Run Avg</th>
			</tr>
	"}

	// Sort results by count (descending)
	var/list/sorted_results = list()
	for(var/item in results)
		sorted_results += list(list("item" = item, "count" = results[item]))

	// Simple bubble sort by count
	for(var/i = 1 to length(sorted_results))
		for(var/j = 1 to length(sorted_results) - 1)
			if(sorted_results[j]["count"] < sorted_results[j+1]["count"])
				var/temp = sorted_results[j]
				sorted_results[j] = sorted_results[j+1]
				sorted_results[j+1] = temp

	// Add results to table
	for(var/list/result in sorted_results)
		var/item = result["item"]
		var/count = result["count"]
		var/percentage = round((count / total_items) * 100, 0.1)
		var/per_run = round(count / times, 0.01)

		var/item_name = "[item]"
		if(ispath(item))
			var/atom/temp = item
			item_name = initial(temp.name) || "[item]"

		html += {"
			<tr>
				<td>[item_name]</td>
				<td>[count]</td>
				<td>[percentage]%</td>
				<td>[per_run]</td>
			</tr>
		"}

	html += {"
		</table>
	</body>
	</html>
	"}

	user << browse(html, "window=simulation_results;size=600x500")
	to_chat(user, "<span class='notice'>Simulation complete! Check the results window.</span>")

/client/proc/debug_loot_tables()
	set name = "Debug Loot Tables"
	set category = "Debug.Debug"
	set desc = "Select and debug loot tables"

	var/mob/living/user = mob
	if(!istype(user))
		to_chat(user, "<span class='warning'>You must be a living mob to use this.</span>")
		return

	// Collect all loot table types
	var/list/loot_table_types = list()
	for(var/datum/loot_table/LT as anything in subtypesof(/datum/loot_table))
		loot_table_types += LT

	if(!length(loot_table_types))
		to_chat(user, "<span class='warning'>No configured loot tables found.</span>")
		return

	user.show_loot_table_menu(user, loot_table_types)

// Add a variable to store the debug table on the client
/client
	var/datum/loot_table/debug_loot_table

/client/Topic(href, href_list)
	. = ..()

	if(!check_rights(R_DEBUG, FALSE))
		return

	if(href_list["action"] == "select_loot_table")
		var/datum/loot_table/selected_type = text2path(href_list["table_type"])
		if(!selected_type)
			return

		// Store the debug table on the client so it persists
		debug_loot_table = new selected_type()
		debug_loot_table.debug_loot_table(mob)

		// Close the selection window
		src << browse(null, "window=loot_selection")

	// Handle loot table debugging actions
	else if(href_list["action"] in list("simulate", "update_stats", "change_luck", "reset_debug"))
		if(!debug_loot_table)
			return

		if(href_list["action"] == "simulate")
			var/times = text2num(href_list["times"])
			var/mob/living/user = locate(href_list["user"])
			var/delve_level = text2num(href_list["delve"]) || 1
			var/item_rarity = text2num(href_list["rarity"]) || 1.0

			if(!times || !istype(user))
				return

			debug_loot_table.simulate_loot_generation(user, times, delve_level, item_rarity)

		else if(href_list["action"] == "update_stats")
			var/mob/living/user = locate(href_list["user"])
			var/new_luck = text2num(href_list["luck"])
			var/delve_level = text2num(href_list["delve"]) || 1
			var/item_rarity = text2num(href_list["rarity"]) || 1.0

			if(!istype(user) || !isnum(new_luck))
				return

			// Remove old debug modifier and set new one using proper modifier system
			var/current_luck = user.get_stat_level(STATKEY_LCK)
			user.remove_stat_modifier("loot_debug")
			if(new_luck != current_luck)
				user.set_stat_modifier("loot_debug", STATKEY_LCK, new_luck - current_luck)

			// Refresh the debug window with new parameters
			debug_loot_table.debug_loot_table(user, delve_level, item_rarity)

		else if(href_list["action"] == "change_luck")
			var/mob/living/user = locate(href_list["user"])

			if(!istype(user))
				return

			var/current_luck = user.get_stat_level(STATKEY_LCK)
			var/new_luck = input(user, "Enter new luck level (0-100):", "Set Luck Level", current_luck) as num|null
			if(!isnull(new_luck))
				new_luck = max(0, min(100, new_luck))
				// Remove old debug modifier and set new one
				user.remove_stat_modifier("loot_debug")
				if(new_luck != current_luck)
					user.set_stat_modifier("loot_debug", STATKEY_LCK, new_luck - current_luck)
				debug_loot_table.debug_loot_table(user)

		else if(href_list["action"] == "reset_debug")
			var/mob/living/user = locate(href_list["user"])

			if(!istype(user))
				return

			// Remove debug modifiers
			user.remove_stat_modifier("loot_debug")
			debug_loot_table.debug_loot_table(user)

/mob/proc/show_loot_table_menu(mob/living/user, list/loot_table_types)
	var/html = {"
	<html>
	<head>
		<title>Loot Table Selection</title>
		<style>
			body { font-family: Arial, sans-serif; margin: 10px; background: #1a1a1a; color: #ffffff; }
			.header { background: #333; padding: 10px; border-radius: 5px; margin-bottom: 10px; }
			.loot-list { background: #2a2a2a; padding: 10px; border-radius: 5px; }
			.loot-item {
				display: block; padding: 8px 12px; margin: 5px 0;
				background: #333; border-radius: 3px; text-decoration: none;
				color: #ffffff; border-left: 4px solid #4CAF50;
			}
			.loot-item:hover { background: #4CAF50; }
		</style>
	</head>
	<body>
		<div class='header'>
			<h2>Select Loot Table to Debug</h2>
		</div>

		<div class='loot-list'>
	"}

	for(var/datum/loot_table/LT as anything in loot_table_types)
		var/name = initial(LT.name) || "[LT]"
		html += "<a href='byond://?src=\ref[user];action=select_loot_table;table_type=[LT]' class='loot-item'>[name]</a>"

	html += {"
		</div>
	</body>
	</html>
	"}

	user << browse(html, "window=loot_selection;size=400x600")
