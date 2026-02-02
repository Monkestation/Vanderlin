
/datum/crop_debug_system
	var/list/crop_grid = list() // 2D grid: grid[x][y] = plant_def_type or null
	var/grid_width = 8
	var/grid_height = 8
	var/selected_plant_type = null
	var/surrounding_bonus = TRUE

/datum/crop_debug_system/New()
	. = ..()
	// Initialize empty grid
	for(var/x = 1 to grid_width)
		crop_grid["[x]"] = list()
		for(var/y = 1 to grid_height)
			crop_grid["[x]"]["[y]"] = null

/datum/crop_debug_system/proc/calculate_cell_nutrients(x, y)
	var/plant_type = crop_grid["[x]"]["[y]"]
	if(!plant_type)
		return null

	var/datum/plant_def/plant = new plant_type()
	var/list/result = list()

	// Base production and requirements
	var/n_production = plant.nitrogen_production
	var/p_production = plant.phosphorus_production
	var/k_production = plant.potassium_production
	var/n_requirement = plant.nitrogen_requirement
	var/p_requirement = plant.phosphorus_requirement
	var/k_requirement = plant.potassium_requirement

	// Calculate adjacency bonuses if enabled
	var/n_bonus = 0, p_bonus = 0, k_bonus = 0
	if(surrounding_bonus)
		var/list/adjacent_coords = get_adjacent_coords(x, y)
		for(var/list/coord in adjacent_coords)
			var/adj_x = coord[1]
			var/adj_y = coord[2]
			var/adj_plant_type = crop_grid["[adj_x]"]["[adj_y]"]
			if(!adj_plant_type) continue

			var/datum/plant_def/adj_plant = new adj_plant_type()
			n_bonus += FLOOR((adj_plant.nitrogen_production)/2, 1)
			p_bonus += FLOOR((adj_plant.phosphorus_production)/2, 1)
			k_bonus += FLOOR((adj_plant.potassium_production)/2, 1)
			qdel(adj_plant)

	// Calculate net values
	result["net_nitrogen"] = (n_production + n_bonus) - n_requirement
	result["net_phosphorus"] = (p_production + p_bonus) - p_requirement
	result["net_potassium"] = (k_production + k_bonus) - k_requirement
	result["n_production"] = n_production
	result["p_production"] = p_production
	result["k_production"] = k_production
	result["n_bonus"] = n_bonus
	result["p_bonus"] = p_bonus
	result["k_bonus"] = k_bonus
	result["n_requirement"] = n_requirement
	result["p_requirement"] = p_requirement
	result["k_requirement"] = k_requirement
	result["plant_name"] = plant.name

	qdel(plant)
	return result

/datum/crop_debug_system/proc/show_debug_menu(mob/user)
	var/list/html_content = list()

	html_content += "<html><head><title>Crop Nutrient Debug System</title>"
	html_content += "<style>"
	html_content += "body { font-family: Arial, sans-serif; margin: 20px; background: #1a1a1a; color: #fff; }"
	html_content += ".container { max-width: 1400px; margin: 0 auto; }"
	html_content += ".section { background: #2a2a2a; padding: 15px; margin: 10px 0; border-radius: 5px; }"
	html_content += ".grid-container { display: flex; gap: 20px; }"
	html_content += ".grid-section { flex: 1; }"
	html_content += ".plants-section { flex: 0 0 300px; }"
	html_content += ".crop-grid { display: grid; grid-template-columns: repeat([grid_width], 50px); grid-template-rows: repeat([grid_height], 50px); gap: 2px; background: #333; padding: 10px; border-radius: 5px; }"
	html_content += ".grid-cell { width: 50px; height: 50px; border: 1px solid #555; background: #444; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 10px; text-align: center; position: relative; }"
	html_content += ".grid-cell:hover { background: #666; }"
	html_content += ".grid-cell.occupied { background: #4CAF50; color: white; font-weight: bold; }"
	html_content += ".plant-list { max-height: 400px; overflow-y: auto; }"
	html_content += ".plant-item { background: #3a3a3a; padding: 8px; margin: 5px 0; border-radius: 3px; cursor: pointer; border: 2px solid transparent; }"
	html_content += ".plant-item:hover { background: #4a4a4a; }"
	html_content += ".plant-item.selected { border-color: #4CAF50; }"
	html_content += ".plant-name { font-weight: bold; color: #4CAF50; }"
	html_content += ".nutrient-info { font-size: 11px; margin-top: 5px; }"
	html_content += ".positive { color: #4CAF50; }"
	html_content += ".negative { color: #f44336; }"
	html_content += ".neutral { color: #888; }"
	html_content += ".controls { margin: 10px 0; }"
	html_content += ".btn { padding: 5px 10px; margin: 2px; background: #555; color: white; border: 1px solid #777; cursor: pointer; text-decoration: none; display: inline-block; }"
	html_content += ".btn:hover { background: #666; }"
	html_content += ".summary { background: #1e3a8a; padding: 20px; border-radius: 5px; }"
	html_content += ".summary h3 { margin-top: 0; color: #60a5fa; }"
	html_content += ".summary-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }"
	html_content += ".summary-item { text-align: center; }"
	html_content += ".big-number { font-size: 24px; font-weight: bold; }"
	html_content += ".grid-coords { font-size: 12px; color: #888; margin-bottom: 10px; }"

	// Tooltip styles
	html_content += ".tooltip { position: absolute; background: rgba(0,0,0,0.95); color: white; padding: 10px; border-radius: 5px; font-size: 12px; z-index: 1000; min-width: 200px; border: 1px solid #555; box-shadow: 0 4px 8px rgba(0,0,0,0.3); pointer-events: none; opacity: 0; transition: opacity 0.2s; }"
	html_content += ".grid-cell:hover .tooltip { opacity: 1; }"
	html_content += ".tooltip-header { font-weight: bold; color: #4CAF50; margin-bottom: 8px; border-bottom: 1px solid #555; padding-bottom: 4px; }"
	html_content += ".tooltip-section { margin: 6px 0; }"
	html_content += ".tooltip-label { font-weight: bold; color: #ccc; }"
	html_content += ".nutrient-line { display: flex; justify-content: space-between; margin: 2px 0; }"
	html_content += ".status-indicator { font-weight: bold; padding: 2px 6px; border-radius: 3px; font-size: 11px; }"
	html_content += ".status-positive { background: #2d5a2d; color: #4CAF50; }"
	html_content += ".status-negative { background: #5a2d2d; color: #f44336; }"
	html_content += ".status-neutral { background: #3a3a3a; color: #888; }"

	html_content += "</style></head><body>"

	html_content += "<div class='container'>"
	html_content += "<h1>Crop Nutrient Debug System</h1>"

	// Controls section
	html_content += "<div class='section'>"
	html_content += "<h3>Controls</h3>"
	html_content += "<div class='controls'>"
	html_content += "<a href='?src=[REF(src)];action=toggle_bonus' class='btn'>[surrounding_bonus ? "Disable" : "Enable"] Surrounding Bonus</a>"
	html_content += "<a href='?src=[REF(src)];action=clear_grid' class='btn'>Clear Grid</a>"
	html_content += "<a href='?src=[REF(src)];action=clear_selection' class='btn'>Clear Selection</a>"
	html_content += "</div>"
	html_content += "<p>Surrounding Bonus: <strong>[surrounding_bonus ? "ON" : "OFF"]</strong> - Adjacent crops give floor(production/2) bonus to neighbors</p>"
	if(selected_plant_type)
		var/datum/plant_def/selected = new selected_plant_type()
		html_content += "<p>Selected Plant: <strong style='color: #4CAF50;'>[selected.name]</strong> - Click on grid to place</p>"
		qdel(selected)
	else
		html_content += "<p>No plant selected - Select a plant from the list to place on grid</p>"
	html_content += "</div>"

	html_content += "<div class='grid-container'>"

	// Grid section
	html_content += "<div class='grid-section'>"
	html_content += "<div class='section'>"
	html_content += "<h3>Crop Grid</h3>"
	html_content += "<div class='grid-coords'>Click cells to place selected plant. Right-click to remove. Hover for nutrient status.</div>"
	html_content += "<div class='crop-grid'>"

	for(var/y = grid_height; y >= 1; y--) // Start from top
		for(var/x = 1 to grid_width)
			var/plant_type = crop_grid["[x]"]["[y]"]
			var/cell_class = "grid-cell"
			var/cell_content = ""
			var/tooltip_content = ""

			if(plant_type)
				var/datum/plant_def/plant = new plant_type()
				cell_class += " occupied"
				cell_content = copytext(plant.name, 1, 4) // First 3 chars
				qdel(plant)

				// Generate detailed tooltip with nutrient analysis
				var/list/nutrients = calculate_cell_nutrients(x, y)
				if(nutrients)
					tooltip_content = "<div class='tooltip'>"
					tooltip_content += "<div class='tooltip-header'>[nutrients["plant_name"]] ([x],[y])</div>"

					tooltip_content += "<div class='tooltip-section'>"
					tooltip_content += "<div class='tooltip-label'>Net Nutrient Status:</div>"

					// Nitrogen status
					var/n_net = nutrients["net_nitrogen"]
					var/n_class = n_net > 0 ? "status-positive" : (n_net < 0 ? "status-negative" : "status-neutral")
					var/n_sign = n_net > 0 ? "+" : ""
					tooltip_content += "<div class='nutrient-line'><span>Nitrogen:</span> <span class='status-indicator [n_class]'>[n_sign][n_net]</span></div>"

					// Phosphorus status
					var/p_net = nutrients["net_phosphorus"]
					var/p_class = p_net > 0 ? "status-positive" : (p_net < 0 ? "status-negative" : "status-neutral")
					var/p_sign = p_net > 0 ? "+" : ""
					tooltip_content += "<div class='nutrient-line'><span>Phosphorus:</span> <span class='status-indicator [p_class]'>[p_sign][p_net]</span></div>"

					// Potassium status
					var/k_net = nutrients["net_potassium"]
					var/k_class = k_net > 0 ? "status-positive" : (k_net < 0 ? "status-negative" : "status-neutral")
					var/k_sign = k_net > 0 ? "+" : ""
					tooltip_content += "<div class='nutrient-line'><span>Potassium:</span> <span class='status-indicator [k_class]'>[k_sign][k_net]</span></div>"
					tooltip_content += "</div>"

					// Detailed breakdown
					tooltip_content += "<div class='tooltip-section'>"
					tooltip_content += "<div class='tooltip-label'>Breakdown:</div>"
					tooltip_content += "<div style='font-size: 11px;'>"
					tooltip_content += "Base Production: N+[nutrients["n_production"]] P+[nutrients["p_production"]] K+[nutrients["k_production"]]<br>"
					if(surrounding_bonus && (nutrients["n_bonus"] > 0 || nutrients["p_bonus"] > 0 || nutrients["k_bonus"] > 0))
						tooltip_content += "Adjacency Bonus: N+[nutrients["n_bonus"]] P+[nutrients["p_bonus"]] K+[nutrients["k_bonus"]]<br>"
					tooltip_content += "Requirements: N-[nutrients["n_requirement"]] P-[nutrients["p_requirement"]] K-[nutrients["k_requirement"]]"
					tooltip_content += "</div></div>"

					tooltip_content += "</div>"
			else
				tooltip_content = "<div class='tooltip'><div class='tooltip-header'>Empty Cell ([x],[y])</div><div>Click to place selected plant</div></div>"

			html_content += "<div class='[cell_class]' onclick=\"location.href='?src=[REF(src)];action=place;x=[x];y=[y]'\" oncontextmenu=\"location.href='?src=[REF(src)];action=remove;x=[x];y=[y]'; return false;\">[cell_content][tooltip_content]</div>"

	html_content += "</div></div></div>"

	// Plants section
	html_content += "<div class='plants-section'>"
	html_content += "<div class='section'>"
	html_content += "<h3>Available Plants</h3>"
	html_content += "<div class='plant-list'>"

	for(var/plant_type in subtypesof(/datum/plant_def))
		var/datum/plant_def/plant = new plant_type()
		if(!plant.name || plant.name == "Some plant") // Skip abstract types
			qdel(plant)
			continue

		var/selected_class = (selected_plant_type == plant_type) ? " selected" : ""
		html_content += "<div class='plant-item[selected_class]' onclick=\"location.href='?src=[REF(src)];action=select;plant=[plant_type]'\">"
		html_content += "<div class='plant-name'>[plant.name]</div>"
		html_content += "<div class='nutrient-info'>"
		html_content += "Req: <span class='negative'>N-[plant.nitrogen_requirement] P-[plant.phosphorus_requirement] K-[plant.potassium_requirement]</span><br>"
		html_content += "Prod: <span class='positive'>N+[plant.nitrogen_production] P+[plant.phosphorus_production] K+[plant.potassium_production]</span>"
		html_content += "</div></div>"

		qdel(plant)

	html_content += "</div></div></div>"
	html_content += "</div>" // End grid-container

	// System analysis
	var/list/totals = calculate_system_totals()
	if(totals["total_crops"] > 0)
		html_content += "<div class='section summary'>"
		html_content += "<h3>System Nutrient Analysis ([totals["total_crops"]] crops)</h3>"
		html_content += "<div class='summary-grid'>"

		html_content += "<div class='summary-item'>"
		html_content += "<h4>Nitrogen (N)</h4>"
		html_content += "<div class='big-number [totals["net_nitrogen"] >= 0 ? "positive" : "negative"]'>[totals["net_nitrogen"] >= 0 ? "+" : ""][totals["net_nitrogen"]]</div>"
		html_content += "<div>Required: -[totals["total_n_req"]]</div>"
		html_content += "<div>Produced: +[totals["total_n_prod"]]</div>"
		if(surrounding_bonus && totals["bonus_n_prod"] > 0)
			html_content += "<div>Adjacency Bonus: +[totals["bonus_n_prod"]]</div>"
		html_content += "</div>"

		html_content += "<div class='summary-item'>"
		html_content += "<h4>Phosphorus (P)</h4>"
		html_content += "<div class='big-number [totals["net_phosphorus"] >= 0 ? "positive" : "negative"]'>[totals["net_phosphorus"] >= 0 ? "+" : ""][totals["net_phosphorus"]]</div>"
		html_content += "<div>Required: -[totals["total_p_req"]]</div>"
		html_content += "<div>Produced: +[totals["total_p_prod"]]</div>"
		if(surrounding_bonus && totals["bonus_p_prod"] > 0)
			html_content += "<div>Adjacency Bonus: +[totals["bonus_p_prod"]]</div>"
		html_content += "</div>"

		html_content += "<div class='summary-item'>"
		html_content += "<h4>Potassium (K)</h4>"
		html_content += "<div class='big-number [totals["net_potassium"] >= 0 ? "positive" : "negative"]'>[totals["net_potassium"] >= 0 ? "+" : ""][totals["net_potassium"]]</div>"
		html_content += "<div>Required: -[totals["total_k_req"]]</div>"
		html_content += "<div>Produced: +[totals["total_k_prod"]]</div>"
		if(surrounding_bonus && totals["bonus_k_prod"] > 0)
			html_content += "<div>Adjacency Bonus: +[totals["bonus_k_prod"]]</div>"
		html_content += "</div>"

		html_content += "</div>"

		// Sustainability assessment
		html_content += "<h4>Sustainability Assessment:</h4>"
		var/sustainable_nutrients = 0
		if(totals["net_nitrogen"] >= 0) sustainable_nutrients++
		if(totals["net_phosphorus"] >= 0) sustainable_nutrients++
		if(totals["net_potassium"] >= 0) sustainable_nutrients++

		var/assessment_class = "neutral"
		var/assessment_text = ""
		switch(sustainable_nutrients)
			if(3)
				assessment_class = "positive"
				assessment_text = "FULLY SUSTAINABLE - All nutrients self-sufficient!"
			if(2)
				assessment_class = "neutral"
				assessment_text = "MOSTLY SUSTAINABLE - One nutrient needs external input"
			if(1)
				assessment_class = "negative"
				assessment_text = "POOR SUSTAINABILITY - Two nutrients need external input"
			if(0)
				assessment_class = "negative"
				assessment_text = "UNSUSTAINABLE - All nutrients need external input"

		html_content += "<div class='[assessment_class]' style='font-size: 18px; font-weight: bold; text-align: center; padding: 10px;'>[assessment_text]</div>"
		html_content += "</div>"

	html_content += "</div></body></html>"

	var/html_string = jointext(html_content, "")
	user << browse(html_string, "window=crop_debug;size=1400x900")

/datum/crop_debug_system/proc/get_adjacent_coords(x, y)
	var/list/adjacent = list()
	// Check 4-directional adjacency
	if(x > 1) adjacent += list(list(x-1, y))
	if(x < grid_width) adjacent += list(list(x+1, y))
	if(y > 1) adjacent += list(list(x, y-1))
	if(y < grid_height) adjacent += list(list(x, y+1))
	return adjacent

/datum/crop_debug_system/proc/calculate_system_totals()
	var/list/totals = list()
	var/total_n_req = 0, total_p_req = 0, total_k_req = 0
	var/total_n_prod = 0, total_p_prod = 0, total_k_prod = 0
	var/total_crops = 0

	// Calculate base requirements and production
	for(var/x = 1 to grid_width)
		for(var/y = 1 to grid_height)
			var/plant_type = crop_grid["[x]"]["[y]"]
			if(!plant_type) continue

			var/datum/plant_def/plant = new plant_type()
			total_crops++

			// Requirements
			total_n_req += plant.nitrogen_requirement
			total_p_req += plant.phosphorus_requirement
			total_k_req += plant.potassium_requirement

			// Production
			total_n_prod += plant.nitrogen_production
			total_p_prod += plant.phosphorus_production
			total_k_prod += plant.potassium_production

			qdel(plant)

	// Calculate surrounding bonuses based on actual adjacency
	var/bonus_n_prod = 0, bonus_p_prod = 0, bonus_k_prod = 0
	if(surrounding_bonus)
		for(var/x = 1 to grid_width)
			for(var/y = 1 to grid_height)
				var/plant_type = crop_grid["[x]"]["[y]"]
				if(!plant_type) continue

				// Check each adjacent cell for bonus providers
				var/list/adjacent_coords = get_adjacent_coords(x, y)
				for(var/list/coord in adjacent_coords)
					var/adj_x = coord[1]
					var/adj_y = coord[2]
					var/adj_plant_type = crop_grid["[adj_x]"]["[adj_y]"]
					if(!adj_plant_type) continue

					// Adjacent plant gives half its production (floored) as bonus
					var/datum/plant_def/adj_plant = new adj_plant_type()
					bonus_n_prod += FLOOR((adj_plant.nitrogen_production)/2, 1)
					bonus_p_prod += FLOOR((adj_plant.phosphorus_production)/2, 1)
					bonus_k_prod += FLOOR((adj_plant.potassium_production)/2, 1)
					qdel(adj_plant)

	totals["total_n_req"] = total_n_req
	totals["total_p_req"] = total_p_req
	totals["total_k_req"] = total_k_req
	totals["total_n_prod"] = total_n_prod
	totals["total_p_prod"] = total_p_prod
	totals["total_k_prod"] = total_k_prod
	totals["bonus_n_prod"] = bonus_n_prod
	totals["bonus_p_prod"] = bonus_p_prod
	totals["bonus_k_prod"] = bonus_k_prod
	totals["net_nitrogen"] = (total_n_prod + bonus_n_prod) - total_n_req
	totals["net_phosphorus"] = (total_p_prod + bonus_p_prod) - total_p_req
	totals["net_potassium"] = (total_k_prod + bonus_k_prod) - total_k_req
	totals["total_crops"] = total_crops

	return totals

/datum/crop_debug_system/Topic(href, href_list)
	var/action = href_list["action"]

	switch(action)
		if("select")
			var/plant_type = text2path(href_list["plant"])
			if(plant_type)
				selected_plant_type = plant_type

		if("place")
			var/x = text2num(href_list["x"])
			var/y = text2num(href_list["y"])
			if(x && y && selected_plant_type && x >= 1 && x <= grid_width && y >= 1 && y <= grid_height)
				crop_grid["[x]"]["[y]"] = selected_plant_type

		if("remove")
			var/x = text2num(href_list["x"])
			var/y = text2num(href_list["y"])
			if(x && y && x >= 1 && x <= grid_width && y >= 1 && y <= grid_height)
				crop_grid["[x]"]["[y]"] = null

		if("clear_grid")
			for(var/x = 1 to grid_width)
				for(var/y = 1 to grid_height)
					crop_grid["[x]"]["[y]"] = null

		if("clear_selection")
			selected_plant_type = null

		if("toggle_bonus")
			surrounding_bonus = !surrounding_bonus

	// Refresh the menu for the user who clicked
	var/mob/user = usr
	if(user)
		show_debug_menu(user)

// Admin verb to open the debug menu
/client/proc/crop_nutrient_debug()
	set name = "Crop Nutrient Debug"
	set category = "Debug"

	if(!check_rights(R_ADMIN))
		return

	debug_system = new()
	debug_system.show_debug_menu(mob)

/client
	var/datum/crop_debug_system/debug_system
