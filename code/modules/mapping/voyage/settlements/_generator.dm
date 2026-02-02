/datum/settlement_generator
	var/datum/island_biome/biome
	var/list/building_templates = list(
		/datum/settlement_building_template/house_1,
		/datum/settlement_building_template/house_2,
		/datum/settlement_building_template/house_3,
		/datum/settlement_building_template/house_4,
	)
	var/list/path_turfs = list(
		/turf/open/floor/dirt,
		/turf/open/floor/cobblerock,
	)
	var/list/bridge_turfs = list(
		/turf/open/floor/ruinedwood
	)
	var/list/mob_spawn_type

	var/settlement_radius = 60
	var/min_building_distance = 8
	var/max_building_attempts = 150
	var/path_width = 1

	// Road generation
	var/road_smoothness = 0.7
	var/max_path_deviation = 3
	var/road_avoidance_padding = 2

	var/generate_plots = TRUE
	var/num_plot_cells = 8
	var/farm_plot_chance = 0.6
	var/min_plot_area = 20

	var/settlement_tier = SETTLEMENT_TIER_BASIC
	var/list/decoration_templates = list(
	)

/datum/settlement_generator/New(datum/island_biome/selected_biome)
	..()
	biome = selected_biome
	mob_spawn_type = selected_biome.settlement_mobs
	setup_settlement_tier()

/datum/settlement_generator/proc/setup_settlement_tier()
	var/list/tiers = list(
		SETTLEMENT_TIER_BASIC = 100,
		SETTLEMENT_TIER_WOOD = 50,
		SETTLEMENT_TIER_STONE = 10,
	)

	settlement_tier = pickweight(tiers)
	switch(settlement_tier)
		if(SETTLEMENT_TIER_BASIC)
			building_templates = list(
				/datum/settlement_building_template/house_1,
				/datum/settlement_building_template/house_2,
				/datum/settlement_building_template/house_3,
				/datum/settlement_building_template/house_4,
			)
		if(SETTLEMENT_TIER_WOOD)
			building_templates = list(
				/datum/settlement_building_template/wood_house_1,
				/datum/settlement_building_template/wood_house_2,
				/datum/settlement_building_template/wood_house_3,
				/datum/settlement_building_template/wood_house_4,
			)
		if(SETTLEMENT_TIER_STONE)
			building_templates = list(
				/datum/settlement_building_template/stone_house_1,
				/datum/settlement_building_template/stone_house_2,
				/datum/settlement_building_template/stone_house_3,
				/datum/settlement_building_template/wood_house_3,
			)


/datum/settlement_generator/proc/generate_settlements(datum/island_generator/island_gen, turf/bottom_left_corner, list/mainland_tiles)
	if(!building_templates.len || !mainland_tiles.len)
		return

	var/list/coord_to_tile = list()
	for(var/list/tile_data in mainland_tiles)
		coord_to_tile["[tile_data["x"]],[tile_data["y"]]"] = tile_data

	var/settlement_min_distance = min_building_distance
	var/settlement_max_distance = min_building_distance * 1.5

	var/list/settlement_samples = island_gen.noise.poisson_disk_sampling(
		0, island_gen.size_x - 1,
		0, island_gen.size_y - 1,
		settlement_min_distance,
		settlement_max_distance
	)

	var/list/placed_settlements = list()

	for(var/list/sample in shuffle(settlement_samples))
		var/sx = round(sample[1])
		var/sy = round(sample[2])

		var/list/tile_data = coord_to_tile["[sx],[sy]"]
		if(!tile_data)
			continue

		var/list/settlement_data = generate_single_settlement(
			island_gen,
			bottom_left_corner,
			sx, sy,
			coord_to_tile
		)

		if(settlement_data)
			placed_settlements += list(settlement_data)
			break

	return placed_settlements

/datum/settlement_generator/proc/generate_single_settlement(datum/island_generator/island_gen, turf/bottom_left_corner, center_x, center_y, list/coord_to_tile)
	var/start_x = bottom_left_corner.x
	var/start_y = bottom_left_corner.y
	var/start_z = bottom_left_corner.z

	var/list/settlement_turfs = list()
	var/list/settlement_coords = list()

	for(var/dx = -settlement_radius to settlement_radius)
		for(var/dy = -settlement_radius to settlement_radius)
			if(dx * dx + dy * dy > settlement_radius * settlement_radius)
				continue

			var/tile_x = center_x + dx
			var/tile_y = center_y + dy
			var/list/tile_data = coord_to_tile["[tile_x],[tile_y]"]

			if(!tile_data)
				continue

			settlement_turfs += tile_data["turf"]
			settlement_coords["[tile_x],[tile_y]"] = tile_data

	if(settlement_turfs.len < 10)
		return null

	var/building_samples = island_gen.noise.poisson_disk_sampling(
		center_x - settlement_radius,
		center_x + settlement_radius,
		center_y - settlement_radius,
		center_y + settlement_radius,
		min_building_distance,
		min_building_distance * 1.5
	)

	var/list/placed_buildings = list()
	var/list/road_nodes = list()
	var/list/mob_spawn_points = list()
	var/list/building_bounds = list() //so we can build roads around

	for(var/list/sample in building_samples)
		if(placed_buildings.len >= max_building_attempts)
			break

		var/bx = round(sample[1])
		var/by = round(sample[2])

		if(!settlement_coords["[bx],[by]"])
			continue

		var/datum/settlement_building_template/template = pick(building_templates)
		var/list/building_data = try_place_building(
			template,
			bx, by,
			start_x, start_y, start_z,
			settlement_coords,
			island_gen
		)

		if(building_data)
			placed_buildings += list(building_data)

			if(building_data["road_node"])
				road_nodes += building_data["road_node"]

			if(building_data["mob_spawns"])
				mob_spawn_points += building_data["mob_spawns"]

			building_bounds += list(list(
				"x" = bx,
				"y" = by,
				"width" = template.width,
				"height" = template.height
			))

	if(!placed_buildings.len)
		return null

	var/turf/center_turf = locate(start_x + center_x, start_y + center_y, start_z)
	generate_road_network(center_turf, road_nodes, settlement_coords, start_x, start_y, start_z, building_bounds)

	if(length(mob_spawn_type))
		spawn_settlement_mobs(mob_spawn_points)

	if(generate_plots)
		generate_settlement_plots(
			island_gen,
			bottom_left_corner,
			list(
				"center_x" = center_x,
				"center_y" = center_y
			),
			settlement_coords,
			building_bounds
		)

	return list(
		"center_x" = center_x,
		"center_y" = center_y,
		"buildings" = placed_buildings,
		"mob_spawns" = mob_spawn_points
	)

/datum/settlement_generator/proc/try_place_building(datum/settlement_building_template/template, bx, by, start_x, start_y, start_z, list/settlement_coords, datum/island_generator/island_gen)
	var/list/building_tiles = list()

	for(var/dx = 0 to template.width - 1)
		for(var/dy = 0 to template.height - 1)
			var/check_x = bx + dx
			var/check_y = by + dy
			var/list/tile_data = settlement_coords["[check_x],[check_y]"]

			if(!tile_data)
				return null

			building_tiles += tile_data["turf"]

	var/actual_z = start_z + template.z_offset
	var/turf/spawn_turf = locate(start_x + bx, start_y + by, actual_z)

	if(!spawn_turf)
		return null

	var/datum/map_template/building = new template.template_path()
	if(!building || !building.load(spawn_turf, centered = FALSE))
		return null

	for(var/turf/turf in building.get_affected_turfs(spawn_turf, FALSE))
		if(isclosedturf(turf) || isopenspace(turf))
			for(var/obj/structure/flora/structure in turf.contents)
				qdel(structure)
			for(var/mob/living/mob in turf)
				var/turf/step_turf = turf
				while(isclosedturf(step_turf) || isopenspace(step_turf))
					step_turf = get_step(step_turf, NORTH)
				mob.forceMove(step_turf)

	var/turf/road_node = find_road_node(spawn_turf, template, start_z)
	var/list/mob_spawns = find_mob_spawn_points(spawn_turf, template, actual_z)

	return list(
		"template" = template,
		"x" = bx,
		"y" = by,
		"z_offset" = template.z_offset,
		"actual_z" = actual_z,
		"road_node" = road_node,
		"mob_spawns" = mob_spawns
	)

/datum/settlement_generator/proc/find_road_node(turf/building_origin, datum/settlement_building_template/template, level_z)
	for(var/x = 0 to template.width - 1)
		for(var/y = 0 to template.height - 1)
			var/turf/check = locate(building_origin.x + x, building_origin.y + y, level_z)
			if(!check)
				continue

			for(var/obj/effect/landmark/settlement_road_node/node in check)
				return check

	return locate(
		building_origin.x + round(template.width / 2),
		building_origin.y,
		level_z
	)

/datum/settlement_generator/proc/find_mob_spawn_points(turf/building_origin, datum/settlement_building_template/template, actual_z)
	var/list/spawn_points = list()

	var/z_min = actual_z
	var/z_max = actual_z

	for(var/x = 0 to template.width - 1)
		for(var/y = 0 to template.height - 1)
			for(var/z = z_min to z_max)
				var/turf/check = locate(building_origin.x + x, building_origin.y + y, z)
				if(!check)
					continue

				for(var/obj/effect/landmark/settlement_mob_spawn/marker in check)
					spawn_points += check
					qdel(marker)

	if(!spawn_points.len)
		var/mob_x = building_origin.x + round(template.width / 2)
		var/mob_y = building_origin.y + round(template.height / 2)
		var/turf/center_spawn = locate(mob_x, mob_y, actual_z)
		if(center_spawn)
			spawn_points += center_spawn

	return spawn_points

/datum/settlement_generator/proc/generate_road_network(turf/center, list/road_nodes, list/settlement_coords, start_x, start_y, start_z, list/building_bounds)
	for(var/turf/node in road_nodes)
		generate_road_path(center, node, settlement_coords, start_x, start_y, start_z, building_bounds)

/datum/settlement_generator/proc/generate_road_path(turf/from, turf/end, list/settlement_coords, start_x, start_y, start_z, list/building_bounds)
	var/list/path = get_smooth_path(from.x, from.y, end.x, end.y, start_x, start_y, building_bounds)

	for(var/coord in path)
		var/list/coords = splittext(coord, ",")
		var/px = text2num(coords[1])
		var/py = text2num(coords[2])

		var/rel_x = px - start_x
		var/rel_y = py - start_y
		var/list/tile_data = settlement_coords["[rel_x],[rel_y]"]

		var/is_water = !tile_data

		for(var/dx = -path_width to path_width)
			for(var/dy = -path_width to path_width)
				if(dx * dx + dy * dy > path_width * path_width)
					continue

				var/place_x = px + dx
				var/place_y = py + dy

				if(is_point_in_any_building(place_x - start_x, place_y - start_y, building_bounds))
					continue

				var/turf/T = locate(place_x, place_y, start_z)

				if(!T)
					continue

				var/turf_type = is_water ? pick(bridge_turfs) : pick(path_turfs)
				T.ChangeTurf(turf_type)

/datum/settlement_generator/proc/is_point_in_any_building(rel_x, rel_y, list/building_bounds)
	for(var/list/bounds in building_bounds)
		var/bx = bounds["x"]
		var/by = bounds["y"]
		var/width = bounds["width"]
		var/height = bounds["height"]

		if(rel_x >= bx - road_avoidance_padding && rel_x < bx + width + road_avoidance_padding)
			if(rel_y >= by - road_avoidance_padding && rel_y < by + height + road_avoidance_padding)
				return TRUE

	return FALSE

/datum/settlement_generator/proc/get_smooth_path(x1, y1, x2, y2, start_x, start_y, list/building_bounds)
	var/list/waypoints = list()
	waypoints += list(list(x1, y1))

	var/segments = round(sqrt((x2 - x1) ** 2 + (y2 - y1) ** 2) / 10)
	segments = max(2, segments)

	for(var/i = 1 to segments - 1)
		var/progress = i / segments
		var/base_x = x1 + (x2 - x1) * progress
		var/base_y = y1 + (y2 - y1) * progress

		var/offset_x = rand(-max_path_deviation, max_path_deviation) * (1 - road_smoothness)
		var/offset_y = rand(-max_path_deviation, max_path_deviation) * (1 - road_smoothness)

		var/test_x = round(base_x + offset_x)
		var/test_y = round(base_y + offset_y)

		if(is_point_in_any_building(test_x - start_x, test_y - start_y, building_bounds))
			var/list/alternative = find_waypoint_around_buildings(test_x, test_y, start_x, start_y, building_bounds)
			if(alternative)
				test_x = alternative[1]
				test_y = alternative[2]

		waypoints += list(list(test_x, test_y))

	waypoints += list(list(x2, y2))

	var/list/full_path = list()
	for(var/i = 1 to waypoints.len - 1)
		var/list/point_a = waypoints[i]
		var/list/point_b = waypoints[i + 1]
		var/list/segment = get_line_between_points(point_a[1], point_a[2], point_b[1], point_b[2])
		full_path += segment

	return full_path

/datum/settlement_generator/proc/find_waypoint_around_buildings(x, y, start_x, start_y, list/building_bounds)
	var/list/offsets = list(
		list(5, 0), list(-5, 0), list(0, 5), list(0, -5),
		list(5, 5), list(-5, -5), list(5, -5), list(-5, 5)
	)

	for(var/list/offset in offsets)
		var/test_x = x + offset[1]
		var/test_y = y + offset[2]

		if(!is_point_in_any_building(test_x - start_x, test_y - start_y, building_bounds))
			return list(test_x, test_y)

	return null

/datum/settlement_generator/proc/get_line_between_points(x1, y1, x2, y2)
	var/list/line = list()
	var/dx = abs(x2 - x1)
	var/dy = abs(y2 - y1)
	var/sx = x1 < x2 ? 1 : -1
	var/sy = y1 < y2 ? 1 : -1
	var/err = dx - dy
	var/x = x1
	var/y = y1

	while(TRUE)
		line += "[x],[y]"

		if(x == x2 && y == y2)
			break

		var/e2 = 2 * err
		if(e2 > -dy)
			err -= dy
			x += sx
		if(e2 < dx)
			err += dx
			y += sy

	return line

/datum/settlement_generator/proc/spawn_settlement_mobs(list/spawn_points)
	for(var/turf/spawn_point in spawn_points)
		if(length(mob_spawn_type))
			var/path = pick(mob_spawn_type)
			new path(spawn_point)



/datum/settlement_generator/proc/generate_settlement_plots(datum/island_generator/island_gen, turf/bottom_left_corner, list/settlement_data, list/settlement_coords, list/building_bounds)
	if(!generate_plots || !settlement_data)
		return

	var/center_x = settlement_data["center_x"]
	var/center_y = settlement_data["center_y"]
	var/start_x = bottom_left_corner.x
	var/start_y = bottom_left_corner.y
	var/start_z = bottom_left_corner.z

	// Generate Voronoi cells
	var/list/voronoi_cells = island_gen.noise.generate_voronoi_cells(
		center_x - settlement_radius,
		center_x + settlement_radius,
		center_y - settlement_radius,
		center_y + settlement_radius,
		num_plot_cells
	)

	// Assign each settlement tile to a Voronoi cell
	var/list/cell_tiles = list()
	for(var/coord_key in settlement_coords)
		var/list/coords = splittext(coord_key, ",")
		var/rel_x = text2num(coords[1])
		var/rel_y = text2num(coords[2])

		var/list/cell = island_gen.noise.get_voronoi_cell(rel_x, rel_y, voronoi_cells)
		if(!cell)
			continue

		var/cell_id = cell["id"]
		if(!cell_tiles["[cell_id]"])
			cell_tiles["[cell_id]"] = list()

		cell_tiles["[cell_id]"] += list(list("x" = rel_x, "y" = rel_y))

	var/list/plots = list()
	var/is_farm = TRUE
	for(var/cell_id in cell_tiles)
		var/list/tiles = cell_tiles[cell_id]

		if(tiles.len < min_plot_area)
			continue


		if(is_farm && prob(farm_plot_chance * 100))
			var/list/farm_data = generate_farm_plot_in_cell(
				tiles,
				start_x, start_y, start_z,
				building_bounds
			)
			if(farm_data)
				plots += list(farm_data)
			is_farm = FALSE
		else if(decoration_templates.len)
			var/list/decoration_data = generate_decoration_plot_in_cell(
				tiles,
				start_x, start_y, start_z,
				building_bounds
			)
			if(decoration_data)
				plots += list(decoration_data)

	return plots

/datum/settlement_generator/proc/generate_farm_plot_in_cell(list/cell_tiles, start_x, start_y, start_z, list/building_bounds)
	// Find bounding box of cell
	var/min_x = INFINITY
	var/max_x = -INFINITY
	var/min_y = INFINITY
	var/max_y = -INFINITY

	for(var/list/tile in cell_tiles)
		var/tx = tile["x"]
		var/ty = tile["y"]

		min_x = min(min_x, tx)
		max_x = max(max_x, tx)
		min_y = min(min_y, ty)
		max_y = max(max_y, ty)

	// Determine orientation (vertical or horizontal lines)
	var/width = max_x - min_x
	var/height = max_y - min_y
	var/vertical_lines = width > height

	var/list/valid_tiles = list()

	// Check each tile in cell
	for(var/list/tile in cell_tiles)
		var/tx = tile["x"]
		var/ty = tile["y"]

		// Skip if in building area
		if(is_point_in_any_building(tx, ty, building_bounds))
			continue

		var/turf/T = locate(start_x + tx, start_y + ty, start_z)
		if(!T)
			continue

		// Skip roads
		if(is_road_turf(T))
			continue

		// Skip if tree present
		if(locate(/obj/structure/flora/newtree) in T)
			continue

		valid_tiles += list(list("x" = tx, "y" = ty, "turf" = T))

	if(valid_tiles.len < min_plot_area)
		return null

	// Clear structures and place farm rows
	for(var/list/tile_data in valid_tiles)
		var/tx = tile_data["x"]
		var/ty = tile_data["y"]
		var/turf/T = tile_data["turf"]

		// Clear non-tree structures
		for(var/obj/structure/S in T)
			if(!istype(S, /obj/structure/flora/newtree))
				qdel(S)

		// Place irrigation channels in lines, soil elsewhere
		var/is_irrigation_line = FALSE

		if(vertical_lines)
			// Vertical lines every 3 tiles
			is_irrigation_line = (tx % 3 == 0)
		else
			// Horizontal lines every 3 tiles
			is_irrigation_line = (ty % 3 == 0)

		if(is_irrigation_line)
			new /obj/structure/irrigation_channel(T)
		else
			new /obj/structure/soil/debug_soil/random(T)

	return list(
		"type" = "farm",
		"tiles" = valid_tiles.len,
		"orientation" = vertical_lines ? "vertical" : "horizontal"
	)

/datum/settlement_generator/proc/generate_decoration_plot_in_cell(list/cell_tiles, start_x, start_y, start_z, list/building_bounds)
	if(!decoration_templates.len)
		return null

	// Find a good center point in the cell
	var/sum_x = 0
	var/sum_y = 0
	var/count = 0

	for(var/list/tile in cell_tiles)
		sum_x += tile["x"]
		sum_y += tile["y"]
		count++

	if(count == 0)
		return null

	var/center_x = round(sum_x / count)
	var/center_y = round(sum_y / count)

	// Try to place decoration template
	var/datum/settlement_building_template/template = pick(decoration_templates)

	// Check if placement is valid
	var/list/check_tiles = list()
	for(var/dx = 0 to template.width - 1)
		for(var/dy = 0 to template.height - 1)
			var/check_x = center_x + dx
			var/check_y = center_y + dy

			// Skip if in building area
			if(is_point_in_any_building(check_x, check_y, building_bounds))
				return null

			var/turf/check_turf = locate(start_x + check_x, start_y + check_y, start_z)
			if(!check_turf)
				return null

			// Skip if road
			if(is_road_turf(check_turf))
				return null

			// Skip if tree present
			if(locate(/obj/structure/flora/newtree) in check_turf)
				return null

			check_tiles += check_turf

	// Clear non-tree structures
	for(var/turf/T in check_tiles)
		for(var/obj/structure/S in T)
			if(!istype(S, /obj/structure/flora/newtree))
				qdel(S)

	// Place decoration
	var/turf/spawn_turf = locate(start_x + center_x, start_y + center_y, start_z)
	var/actual_z = start_z + template.z_offset
	var/datum/map_template/decoration = new template.template_path()

	spawn_turf = locate(spawn_turf.x, spawn_turf.y, actual_z)
	if(!decoration || !decoration.load(spawn_turf, centered = FALSE))
		return null

	return list(
		"type" = "decoration",
		"x" = center_x,
		"y" = center_y,
		"template" = template
	)

/datum/settlement_generator/proc/is_road_turf(turf/T)
	for(var/path_type in path_turfs)
		if(istype(T, path_type))
			return TRUE
	for(var/bridge_type in bridge_turfs)
		if(istype(T, bridge_type))
			return TRUE
	return FALSE
