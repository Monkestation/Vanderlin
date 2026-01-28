/datum/cave_generator
	var/size_x = 100
	var/size_y = 100
	var/datum/cave_biome/biome
	var/turf/wall_turf = /turf/closed/mineral
	var/turf/ravine_turf = /turf/open/openspace
	var/turf/lava_turf = /turf/open/lava

	// Cave generation parameters
	var/cave_threshold = 0.50
	var/smoothing_passes = 4
	var/connectivity_threshold = 20
	var/seed = 0
	var/feature_attempts = 8
	var/min_feature_distance = 12

	// Noise parameters for cave shape
	var/cave_frequency = 0.06
	var/octaves = 3
	var/gain = 0.5
	var/lacunarity = 2.0

	// Ravine parameters
	var/ravine_frequency = 0.04
	var/ravine_threshold = 0.55
	var/min_ravine_width = 3
	var/ravine_expansion_passes = 2

	// Lava river parameters
	var/lava_river_count = 2
	var/lava_river_width = 2
	var/lava_path_points = 15
	var/lava_path_smoothness = 0.6
	var/lava_drop_on_ravine = TRUE

	// Environmental variation
	var/temperature_frequency = 0.18
	var/moisture_frequency = 0.18

	var/ore_vein_attempts = 20         // How many ore veins to attempt per ore type

	var/datum/noise_generator/cave_noise
	var/datum/noise_generator/ravine_noise

/datum/cave_generator/New(datum/cave_biome/selected_biome, sx = 100, sy = 100)
	..()
	size_x = sx
	size_y = sy
	biome = selected_biome
	seed = rand(1, 999999)

	cave_noise = new /datum/noise_generator(seed)
	cave_noise.octaves = octaves
	cave_noise.gain = gain
	cave_noise.lacunarity = lacunarity
	cave_noise.frequency = cave_frequency

	ravine_noise = new /datum/noise_generator(seed + 11111)
	ravine_noise.octaves = 3
	ravine_noise.gain = 0.5
	ravine_noise.lacunarity = 2.0
	ravine_noise.frequency = ravine_frequency

/datum/cave_generator/proc/get_cave_noise(x, y)
	return cave_noise.fbm2(x, y)

/datum/cave_generator/proc/get_ravine_noise(x, y)
	return ravine_noise.fbm2(x, y)

/datum/cave_generator/proc/get_temperature_noise(x, y)
	var/datum/noise_generator/temp_noise = new /datum/noise_generator(seed + 33333)
	temp_noise.octaves = 4
	temp_noise.gain = 0.5
	temp_noise.lacunarity = 2.0
	temp_noise.frequency = temperature_frequency
	return temp_noise.fbm2(x, y)

/datum/cave_generator/proc/get_moisture_noise(x, y)
	var/datum/noise_generator/moist_noise = new /datum/noise_generator(seed + 44444)
	moist_noise.octaves = 4
	moist_noise.gain = 0.5
	moist_noise.lacunarity = 2.0
	moist_noise.frequency = moisture_frequency
	return moist_noise.fbm2(x, y)

/datum/cave_generator/proc/generate_ore_veins(list/cave_map, list/wall_coords, list/ore_list)
	if(!ore_list || !ore_list.len)
		return list()

	var/list/all_ore_placements = list()

	// Generate veins for each ore type
	for(var/ore_type in ore_list)
		var/list/ore_data = ore_list[ore_type]
		var/turf/ore_turf = ore_data["turf"]
		var/spread_chance = ore_data["spread_chance"]
		var/spread_range = ore_data["spread_range"]

		// Use Poisson disk sampling to find vein seed points
		var/list/samples = cave_noise.poisson_disk_sampling(0, size_x - 1, 0, size_y - 1, biome.ore_vein_density)

		var/veins_placed = 0
		for(var/list/sample in samples)
			if(veins_placed >= ore_vein_attempts)
				break

			var/sx = round(sample[1])
			var/sy = round(sample[2])
			var/seed_coord = "[sx],[sy]"

			// Only place if it's a wall tile in a cave
			if(!wall_coords[seed_coord])
				continue
			if(!is_near_cave(sx, sy, cave_map, 3))
				continue

			// Spread from this seed point
			var/list/vein_coords = spread_ore_cluster(sx, sy, spread_chance, spread_range, wall_coords, cave_map)

			if(vein_coords.len > 0)
				for(var/coord in vein_coords)
					all_ore_placements[coord] = ore_turf
				veins_placed++

	return all_ore_placements

/datum/cave_generator/proc/spread_ore_cluster(seed_x, seed_y, spread_chance, spread_range, list/wall_coords, list/cave_map)
	var/list/cluster = list()
	var/list/active = list("[seed_x],[seed_y]")
	var/list/processed = list()

	cluster["[seed_x],[seed_y]"] = TRUE

	for(var/iteration = 1 to biome.ore_spread_iterations)
		var/list/next_active = list()

		for(var/coord in active)
			var/list/coords = splittext(coord, ",")
			var/cx = text2num(coords[1])
			var/cy = text2num(coords[2])

			processed[coord] = TRUE

			// Try to spread to neighbors
			for(var/dx = -spread_range to spread_range)
				for(var/dy = -spread_range to spread_range)
					if(dx == 0 && dy == 0)
						continue

					// Distance-based probability (closer = more likely)
					var/dist = sqrt(dx * dx + dy * dy)
					if(dist > spread_range)
						continue

					var/dist_factor = 1 - (dist / spread_range)
					var/actual_chance = spread_chance * dist_factor

					if(!prob(actual_chance))
						continue

					var/nx = cx + dx
					var/ny = cy + dy
					var/new_coord = "[nx],[ny]"

					// Must be a wall tile and not already in cluster
					if(!wall_coords[new_coord] || cluster[new_coord] || processed[new_coord])
						continue

					// Must be reasonably close to cave
					if(!is_near_cave(nx, ny, cave_map, 4))
						continue

					cluster[new_coord] = TRUE
					if(iteration < biome.ore_spread_iterations)
						next_active += new_coord

		active = next_active
		if(!active.len)
			break

	return cluster

/datum/cave_generator/proc/is_near_cave(x, y, list/cave_map, check_radius)
	for(var/dx = -check_radius to check_radius)
		for(var/dy = -check_radius to check_radius)
			if(cave_map["[x+dx],[y+dy]"])
				return TRUE
	return FALSE

/datum/cave_generator/proc/generate_deferred(turf/bottom_left_corner, datum/controller/subsystem/terrain_generation/subsystem, datum/terrain_generation_job/job)
	set waitfor = FALSE

	if(!bottom_left_corner)
		return FALSE

	var/start_x = bottom_left_corner.x
	var/start_y = bottom_left_corner.y
	var/start_z = bottom_left_corner.z

	var/list/upper_cave_map = list()
	var/list/lower_cave_map = list()
	var/list/ravine_map = list()
	var/list/temperature_map = list()
	var/list/moisture_map = list()

	// Phase 1: Generate noise maps
	var/tiles_processed = 0
	var/total_tiles = size_x * size_y

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/cave_val_upper = get_cave_noise(x, y)
			var/normalized_upper = (cave_val_upper + 1) / 2
			if(normalized_upper > cave_threshold)
				upper_cave_map["[x],[y]"] = TRUE

			var/cave_val_lower = get_cave_noise(x + 50, y + 50)
			var/normalized_lower = (cave_val_lower + 1) / 2
			if(normalized_lower > cave_threshold)
				lower_cave_map["[x],[y]"] = TRUE

			if(upper_cave_map["[x],[y]"])
				var/ravine_val = get_ravine_noise(x, y)
				var/normalized_ravine = (ravine_val + 1) / 2
				if(normalized_ravine > ravine_threshold)
					ravine_map["[x],[y]"] = TRUE

			var/temp_noise = get_temperature_noise(x, y)
			temperature_map["[x],[y]"] = (temp_noise + 1) / 2

			var/moist_noise = get_moisture_noise(x, y)
			moisture_map["[x],[y]"] = (moist_noise + 1) / 2

			tiles_processed++
			if(tiles_processed % 500 == 0)
				if(job)
					job.progress = (tiles_processed / total_tiles) * 20 // 0-20% for noise generation
				CHECK_TICK

	// Phase 2: Smooth caves
	for(var/i = 1 to smoothing_passes)
		upper_cave_map = smooth_caves(upper_cave_map)
		lower_cave_map = smooth_caves(lower_cave_map)
		CHECK_TICK

	upper_cave_map = remove_small_pockets(upper_cave_map, connectivity_threshold)
	CHECK_TICK
	lower_cave_map = remove_small_pockets(lower_cave_map, connectivity_threshold)
	CHECK_TICK

	ravine_map = create_single_ravine(ravine_map, upper_cave_map)
	CHECK_TICK

	// Phase 3: Generate lava rivers
	var/list/lava_map_upper = list()
	var/list/lava_map_lower = list()

	for(var/i = 1 to lava_river_count)
		var/list/river_data = generate_lava_river_path(upper_cave_map, lower_cave_map, ravine_map)
		if(river_data && river_data["upper"] && river_data["lower"])
			for(var/coord in river_data["upper"])
				lava_map_upper[coord] = TRUE
			for(var/coord in river_data["lower"])
				lava_map_lower[coord] = TRUE
		CHECK_TICK

	biome.temperature_map = temperature_map
	biome.moisture_map = moisture_map

	// Phase 4: Place lower level tiles
	var/list/lower_valid_tiles = list()
	tiles_processed = 0

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/turf/T = locate(start_x + x, start_y + y, start_z)
			if(!T)
				continue

			if(lava_map_lower["[x],[y]"])
				T.ChangeTurf(lava_turf)
			else if(lower_cave_map["[x],[y]"])
				var/temperature = temperature_map["[x],[y]"] || 0.5
				var/moisture = moisture_map["[x],[y]"] || 0.5
				var/turf_type = biome.select_terrain(temperature, moisture, 0)
				T.ChangeTurf(turf_type)

				lower_valid_tiles += list(list(
					"turf" = T,
					"x" = x,
					"y" = y,
					"temperature" = temperature,
					"moisture" = moisture,
					"level" = 0
				))
			else
				T.ChangeTurf(wall_turf, list(/turf/open/openspace, /turf/open/floor/naturalstone))

			tiles_processed++
			if(tiles_processed % 200 == 0)
				if(job)
					job.progress = 20 + (tiles_processed / total_tiles) * 15 // 20-35% for lower level
				CHECK_TICK

	// Phase 4.5: Generate ore veins for lower level
	var/list/lower_wall_coords = list()
	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/coord = "[x],[y]"
			if(!lower_cave_map[coord] && !lava_map_lower[coord])
				lower_wall_coords[coord] = TRUE

	var/list/lower_ore_placements = generate_ore_veins(lower_cave_map, lower_wall_coords, biome.ore_types_lower)

	// Apply lower level ores
	tiles_processed = 0
	for(var/coord in lower_ore_placements)
		var/list/coords = splittext(coord, ",")
		var/x = text2num(coords[1])
		var/y = text2num(coords[2])
		var/turf/T = locate(start_x + x, start_y + y, start_z)
		if(T)
			var/ore_turf = lower_ore_placements[coord]
			T.ChangeTurf(ore_turf, list(/turf/open/openspace, /turf/open/floor/naturalstone))

		tiles_processed++
		if(tiles_processed % 100 == 0)
			CHECK_TICK

	// Phase 5: Place upper level tiles
	var/list/upper_valid_tiles = list()
	tiles_processed = 0

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/turf/T = locate(start_x + x, start_y + y, start_z + 1)
			if(!T)
				continue

			if(ravine_map["[x],[y]"])
				T.ChangeTurf(ravine_turf)
			else if(lava_map_upper["[x],[y]"])
				T.ChangeTurf(lava_turf)
			else if(upper_cave_map["[x],[y]"])
				var/temperature = temperature_map["[x],[y]"] || 0.5
				var/moisture = moisture_map["[x],[y]"] || 0.5
				var/turf_type = biome.select_terrain(temperature, moisture, 1)
				T.ChangeTurf(turf_type)

				upper_valid_tiles += list(list(
					"turf" = T,
					"x" = x,
					"y" = y,
					"temperature" = temperature,
					"moisture" = moisture,
					"level" = 1
				))
			else
				T.ChangeTurf(wall_turf, list(/turf/open/openspace, /turf/open/floor/naturalstone))

			tiles_processed++
			if(tiles_processed % 200 == 0)
				if(job)
					job.progress = 35 + (tiles_processed / total_tiles) * 15 // 35-50% for upper level
				CHECK_TICK

	// Phase 5.5: Generate ore veins for upper level
	var/list/upper_wall_coords = list()
	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/coord = "[x],[y]"
			if(!upper_cave_map[coord] && !ravine_map[coord] && !lava_map_upper[coord])
				upper_wall_coords[coord] = TRUE

	var/list/upper_ore_placements = generate_ore_veins(upper_cave_map, upper_wall_coords, biome.ore_types_upper)

	// Apply upper level ores
	tiles_processed = 0
	for(var/coord in upper_ore_placements)
		var/list/coords = splittext(coord, ",")
		var/x = text2num(coords[1])
		var/y = text2num(coords[2])
		var/turf/T = locate(start_x + x, start_y + y, start_z + 1)
		if(T)
			var/ore_turf = upper_ore_placements[coord]
			T.ChangeTurf(ore_turf, list(/turf/open/openspace, /turf/open/floor/naturalstone))

		tiles_processed++
		if(tiles_processed % 100 == 0)
			CHECK_TICK

	// Phase 6: Spawn flora and fauna
	spawn_flora_poisson(upper_valid_tiles)
	CHECK_TICK
	spawn_flora_poisson(lower_valid_tiles)
	CHECK_TICK

	spawn_fauna_poisson(upper_valid_tiles)
	CHECK_TICK
	spawn_fauna_poisson(lower_valid_tiles, TRUE)
	CHECK_TICK

	// Phase 7: Place features
	if(biome.feature_templates && biome.feature_templates.len)
		var/list/upper_turfs = list()
		var/list/lower_turfs = list()
		for(var/list/tile_data in upper_valid_tiles)
			upper_turfs += tile_data["turf"]
		for(var/list/tile_data in lower_valid_tiles)
			lower_turfs += tile_data["turf"]

		place_cave_features(upper_turfs, start_z + 1)
		CHECK_TICK
		place_cave_features(lower_turfs, start_z)
		CHECK_TICK

	return TRUE

/datum/cave_generator/proc/generate(turf/bottom_left_corner)
	if(!bottom_left_corner)
		return FALSE

	var/start_x = bottom_left_corner.x
	var/start_y = bottom_left_corner.y
	var/start_z = bottom_left_corner.z

	var/list/upper_cave_map = list()
	var/list/lower_cave_map = list()
	var/list/ravine_map = list()
	var/list/temperature_map = list()
	var/list/moisture_map = list()

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/cave_val_upper = get_cave_noise(x, y)
			var/normalized_upper = (cave_val_upper + 1) / 2
			if(normalized_upper > cave_threshold)
				upper_cave_map["[x],[y]"] = TRUE

			var/cave_val_lower = get_cave_noise(x + 50, y + 50)
			var/normalized_lower = (cave_val_lower + 1) / 2
			if(normalized_lower > cave_threshold)
				lower_cave_map["[x],[y]"] = TRUE

			if(upper_cave_map["[x],[y]"])
				var/ravine_val = get_ravine_noise(x, y)
				var/normalized_ravine = (ravine_val + 1) / 2
				if(normalized_ravine > ravine_threshold)
					ravine_map["[x],[y]"] = TRUE

			var/temp_noise = get_temperature_noise(x, y)
			temperature_map["[x],[y]"] = (temp_noise + 1) / 2

			var/moist_noise = get_moisture_noise(x, y)
			moisture_map["[x],[y]"] = (moist_noise + 1) / 2

	for(var/i = 1 to smoothing_passes)
		upper_cave_map = smooth_caves(upper_cave_map)
		lower_cave_map = smooth_caves(lower_cave_map)

	upper_cave_map = remove_small_pockets(upper_cave_map, connectivity_threshold)
	lower_cave_map = remove_small_pockets(lower_cave_map, connectivity_threshold)

	ravine_map = create_single_ravine(ravine_map, upper_cave_map)

	var/list/lava_map_upper = list()
	var/list/lava_map_lower = list()

	for(var/i = 1 to lava_river_count)
		var/list/river_data = generate_lava_river_path(upper_cave_map, lower_cave_map, ravine_map)
		if(river_data && river_data["upper"] && river_data["lower"])
			for(var/coord in river_data["upper"])
				lava_map_upper[coord] = TRUE
			for(var/coord in river_data["lower"])
				lava_map_lower[coord] = TRUE

	biome.temperature_map = temperature_map
	biome.moisture_map = moisture_map

	var/list/lower_valid_tiles = list()
	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/turf/T = locate(start_x + x, start_y + y, start_z)
			if(!T)
				continue

			if(lava_map_lower["[x],[y]"])
				T.ChangeTurf(lava_turf)
			else if(lower_cave_map["[x],[y]"])
				var/temperature = temperature_map["[x],[y]"] || 0.5
				var/moisture = moisture_map["[x],[y]"] || 0.5
				var/turf_type = biome.select_terrain(temperature, moisture, 0)
				T.ChangeTurf(turf_type)

				lower_valid_tiles += list(list(
					"turf" = T,
					"x" = x,
					"y" = y,
					"temperature" = temperature,
					"moisture" = moisture,
					"level" = 0
				))
			else
				T.ChangeTurf(wall_turf, list(/turf/open/openspace, /turf/open/floor/naturalstone))

	// Generate ore veins for lower level
	var/list/lower_wall_coords = list()
	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/coord = "[x],[y]"
			if(!lower_cave_map[coord] && !lava_map_lower[coord])
				lower_wall_coords[coord] = TRUE

	var/list/lower_ore_placements = generate_ore_veins(lower_cave_map, lower_wall_coords, biome.ore_types_lower)

	// Apply lower level ores
	for(var/coord in lower_ore_placements)
		var/list/coords = splittext(coord, ",")
		var/x = text2num(coords[1])
		var/y = text2num(coords[2])
		var/turf/T = locate(start_x + x, start_y + y, start_z)
		if(T)
			var/ore_turf = lower_ore_placements[coord]
			T.ChangeTurf(ore_turf, list(/turf/open/openspace, /turf/open/floor/naturalstone))

	var/list/upper_valid_tiles = list()
	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/turf/T = locate(start_x + x, start_y + y, start_z + 1)
			if(!T)
				continue

			if(ravine_map["[x],[y]"])
				T.ChangeTurf(ravine_turf)
			else if(lava_map_upper["[x],[y]"])
				T.ChangeTurf(lava_turf)
			else if(upper_cave_map["[x],[y]"])
				var/temperature = temperature_map["[x],[y]"] || 0.5
				var/moisture = moisture_map["[x],[y]"] || 0.5
				var/turf_type = biome.select_terrain(temperature, moisture, 1)
				T.ChangeTurf(turf_type)

				upper_valid_tiles += list(list(
					"turf" = T,
					"x" = x,
					"y" = y,
					"temperature" = temperature,
					"moisture" = moisture,
					"level" = 1
				))
			else
				T.ChangeTurf(wall_turf, list(/turf/open/openspace, /turf/open/floor/naturalstone))

	// Generate ore veins for upper level
	var/list/upper_wall_coords = list()
	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/coord = "[x],[y]"
			if(!upper_cave_map[coord] && !ravine_map[coord] && !lava_map_upper[coord])
				upper_wall_coords[coord] = TRUE

	var/list/upper_ore_placements = generate_ore_veins(upper_cave_map, upper_wall_coords, biome.ore_types_upper)

	// Apply upper level ores
	for(var/coord in upper_ore_placements)
		var/list/coords = splittext(coord, ",")
		var/x = text2num(coords[1])
		var/y = text2num(coords[2])
		var/turf/T = locate(start_x + x, start_y + y, start_z + 1)
		if(T)
			var/ore_turf = upper_ore_placements[coord]
			T.ChangeTurf(ore_turf, list(/turf/open/openspace, /turf/open/floor/naturalstone))

	spawn_flora_poisson(upper_valid_tiles)
	spawn_flora_poisson(lower_valid_tiles)

	spawn_fauna_poisson(upper_valid_tiles)
	spawn_fauna_poisson(lower_valid_tiles, TRUE)

	if(biome.feature_templates && biome.feature_templates.len)
		var/list/upper_turfs = list()
		var/list/lower_turfs = list()
		for(var/list/tile_data in upper_valid_tiles)
			upper_turfs += tile_data["turf"]
		for(var/list/tile_data in lower_valid_tiles)
			lower_turfs += tile_data["turf"]

		place_cave_features(upper_turfs, start_z + 1)
		place_cave_features(lower_turfs, start_z)

	return TRUE

/datum/cave_generator/proc/spawn_flora_poisson(list/valid_tiles)
	if(!valid_tiles.len || biome.flora_density <= 0)
		return

	var/min_radius = biome.flora_density
	var/max_radius = min_radius * 1.5

	// Build fast lookup
	var/list/coord_to_tile = list()
	for(var/list/tile_data in valid_tiles)
		coord_to_tile["[tile_data["x"]],[tile_data["y"]]"] = tile_data

	// Generate full Poisson sample
	var/list/samples = cave_noise.poisson_disk_sampling(0, size_x - 1, 0, size_y - 1, min_radius, max_radius)

	// Filter to valid tiles only
	for(var/list/sample in samples)
		var/sx = round(sample[1])
		var/sy = round(sample[2])

		var/list/tile_data = coord_to_tile["[sx],[sy]"]
		if(!tile_data)
			continue

		var/temperature = tile_data["temperature"]
		var/moisture = tile_data["moisture"]
		var/level = tile_data["level"]
		var/turf/T = tile_data["turf"]

		var/flora_type = biome.select_flora(temperature, moisture, level)
		if(flora_type)
			new flora_type(T)

/datum/cave_generator/proc/spawn_fauna_poisson(list/valid_tiles, lower_world = FALSE)
	if(!valid_tiles.len)
		return

	// Determine which level we're on from the first tile
	var/level = -1
	if(valid_tiles.len)
		var/list/first_tile = valid_tiles[1]
		level = first_tile["level"]

	var/list/active_fauna_types
	var/active_density

	if(level == 0)
		active_fauna_types = biome.fauna_types_lower
		active_density = max(2, biome.fauna_density_lower - biome.difficulty)
	else
		active_fauna_types = biome.fauna_types
		active_density = biome.fauna_density

	if(!active_fauna_types || !active_fauna_types.len || active_density <= 0)
		return

	var/min_radius = active_density
	var/max_radius = min_radius * 2

	// Build fast lookup
	var/list/coord_to_tile = list()
	for(var/list/tile_data in valid_tiles)
		coord_to_tile["[tile_data["x"]],[tile_data["y"]]"] = tile_data

	// Generate full Poisson sample
	var/list/samples = cave_noise.poisson_disk_sampling(0, size_x - 1, 0, size_y - 1, min_radius, max_radius)

	// Filter to valid tiles only
	for(var/list/sample in samples)
		var/sx = round(sample[1])
		var/sy = round(sample[2])

		var/list/tile_data = coord_to_tile["[sx],[sy]"]
		if(!tile_data)
			continue

		var/temperature = tile_data["temperature"]
		var/moisture = tile_data["moisture"]
		var/tile_level = tile_data["level"]
		var/turf/T = tile_data["turf"]

		var/spawn_chance = 100
		var/temp_factor = 1 - abs(temperature - 0.5) * 2
		spawn_chance *= (0.5 + temp_factor * 0.5)

		if(!prob(spawn_chance))
			continue

		var/list/valid_fauna = list()
		for(var/fauna_path in active_fauna_types)
			var/datum/fauna_spawn_rule/rule = active_fauna_types[fauna_path]

			if(temperature < rule.min_temperature || temperature > rule.max_temperature)
				continue
			if(moisture < rule.min_moisture || moisture > rule.max_moisture)
				continue
			if(tile_level < rule.min_height || tile_level > rule.max_height)
				continue

			valid_fauna[fauna_path] = rule.spawn_weight

		if(valid_fauna.len)
			var/chosen = pickweight(valid_fauna)
			if(chosen)
				var/mob/living/mob = new chosen(T)
				mob.faction |= "islander"
				SSisland_mobs.register_mob(mob)
				if(lower_world)
					SSmobs.enhance_mob(mob, 1 + (biome.difficulty * 2))

/datum/cave_generator/proc/generate_lava_river_path(list/upper_cave_map, list/lower_cave_map, list/ravine_map)
	var/list/valid_starts = list()
	var/list/valid_ends = list()

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to 10)
			if(upper_cave_map["[x],[y]"])
				valid_starts += "[x],[y]"

	for(var/x = 0 to size_x - 1)
		for(var/y = (size_y - 10) to size_y - 1)
			if(upper_cave_map["[x],[y]"])
				valid_ends += "[x],[y]"

	if(!valid_starts.len || !valid_ends.len)
		return null

	var/start_coord = pick(valid_starts)
	var/end_coord = pick(valid_ends)

	var/list/start_coords = splittext(start_coord, ",")
	var/start_x = text2num(start_coords[1])
	var/start_y = text2num(start_coords[2])

	var/list/end_coords = splittext(end_coord, ",")
	var/end_x = text2num(end_coords[1])
	var/end_y = text2num(end_coords[2])

	var/list/waypoints = list()
	waypoints += list(list(start_x, start_y))

	for(var/i = 1 to lava_path_points - 1)
		var/progress = i / lava_path_points
		var/base_x = start_x + (end_x - start_x) * progress
		var/base_y = start_y + (end_y - start_y) * progress

		var/offset_x = rand(-15, 15) * (1 - lava_path_smoothness)
		var/offset_y = rand(-15, 15) * (1 - lava_path_smoothness)

		var/waypoint_x = round(clamp(base_x + offset_x, 5, size_x - 5))
		var/waypoint_y = round(clamp(base_y + offset_y, 5, size_y - 5))

		waypoints += list(list(waypoint_x, waypoint_y))

	waypoints += list(list(end_x, end_y))

	var/list/lava_upper = list()
	var/list/lava_lower = list()
	var/on_lower_level = FALSE

	for(var/i = 1 to waypoints.len - 1)
		var/list/point_a = waypoints[i]
		var/list/point_b = waypoints[i + 1]

		var/list/path = get_line_between_points(point_a[1], point_a[2], point_b[1], point_b[2])

		for(var/coord in path)
			var/list/coords = splittext(coord, ",")
			var/px = text2num(coords[1])
			var/py = text2num(coords[2])

			if(!on_lower_level && lava_drop_on_ravine && ravine_map["[px],[py]"])
				on_lower_level = TRUE

			for(var/dx = -lava_river_width to lava_river_width)
				for(var/dy = -lava_river_width to lava_river_width)
					if(dx * dx + dy * dy <= lava_river_width * lava_river_width)
						var/river_x = px + dx
						var/river_y = py + dy

						if(river_x < 0 || river_x >= size_x || river_y < 0 || river_y >= size_y)
							continue

						var/river_coord = "[river_x],[river_y]"

						if(on_lower_level)
							if(lower_cave_map[river_coord])
								lava_lower[river_coord] = TRUE
						else
							if(upper_cave_map[river_coord])
								lava_upper[river_coord] = TRUE

	return list("upper" = lava_upper, "lower" = lava_lower)

/datum/cave_generator/proc/get_line_between_points(x1, y1, x2, y2)
	var/list/line = list()
	var/dx = abs(x2 - x1)
	var/dy = abs(y2 - y1)
	var/sx = x1 < x2 ? 1 : -1
	var/sy = y1 < y2 ? 1 : -1
	var/err = dx - dy
	var/x = x1
	var/y = y1

	var/max_iterations = dx + dy + 10
	var/iterations = 0

	while(iterations < max_iterations)
		iterations++
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

/datum/cave_generator/proc/smooth_caves(list/cave_map)
	var/list/new_map = list()

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/neighbors = count_neighbors(cave_map, x, y)

			if(cave_map["[x],[y]"])
				new_map["[x],[y]"] = (neighbors >= 3)
			else
				new_map["[x],[y]"] = (neighbors >= 5)

	return new_map

/datum/cave_generator/proc/remove_small_pockets(list/cave_map, min_size)
	var/list/components = list()
	var/list/visited = list()

	for(var/coord in cave_map)
		if(visited[coord])
			continue

		var/list/component = list()
		var/list/queue = list(coord)
		visited[coord] = TRUE

		while(queue.len)
			var/current = queue[1]
			queue.Cut(1, 2)
			component += current

			var/list/coords = splittext(current, ",")
			var/x = text2num(coords[1])
			var/y = text2num(coords[2])

			for(var/dx = -1 to 1)
				for(var/dy = -1 to 1)
					if(dx == 0 && dy == 0)
						continue
					var/neighbor = "[x+dx],[y+dy]"
					if(cave_map[neighbor] && !visited[neighbor])
						visited[neighbor] = TRUE
						queue += neighbor

		if(component.len > 0)
			components += list(component)

	var/list/filtered = list()
	for(var/list/component in components)
		if(component.len >= min_size)
			for(var/coord in component)
				filtered[coord] = TRUE

	return filtered

/datum/cave_generator/proc/create_single_ravine(list/ravine_map, list/cave_map)
	var/list/components = list()
	var/list/visited = list()

	for(var/coord in ravine_map)
		if(visited[coord])
			continue

		var/list/component = list()
		var/list/queue = list(coord)
		visited[coord] = TRUE

		while(queue.len)
			var/current = queue[1]
			queue.Cut(1, 2)
			component += current

			var/list/coords = splittext(current, ",")
			var/x = text2num(coords[1])
			var/y = text2num(coords[2])

			for(var/dx = -1 to 1)
				for(var/dy = -1 to 1)
					if(dx == 0 && dy == 0)
						continue
					var/neighbor = "[x+dx],[y+dy]"
					if(ravine_map[neighbor] && !visited[neighbor])
						visited[neighbor] = TRUE
						queue += neighbor

		if(component.len > 0)
			components += list(component)

	var/list/largest = list()
	for(var/list/component in components)
		if(component.len > largest.len)
			largest = component

	for(var/pass = 1 to ravine_expansion_passes)
		var/list/expanded = largest.Copy()
		for(var/coord in largest)
			var/list/coords = splittext(coord, ",")
			var/x = text2num(coords[1])
			var/y = text2num(coords[2])

			for(var/dx = -1 to 1)
				for(var/dy = -1 to 1)
					if(dx == 0 && dy == 0)
						continue
					var/new_coord = "[x+dx],[y+dy]"
					if(cave_map[new_coord] && !expanded[new_coord] && prob(70))
						expanded[new_coord] = TRUE
		largest = expanded

	var/list/final_ravine = list()
	for(var/coord in largest)
		final_ravine[coord] = TRUE

	return final_ravine

/datum/cave_generator/proc/place_cave_features(list/valid_tiles, level_z)
	if(!valid_tiles.len)
		return

	var/list/placed_features = list()
	var/list/weighted_templates = list()

	for(var/template_type in biome.feature_templates)
		var/datum/cave_feature_template/template = new template_type()
		weighted_templates[template] = template.spawn_weight

	for(var/attempt = 1 to feature_attempts)
		if(!valid_tiles.len || !weighted_templates.len)
			break

		var/datum/cave_feature_template/feature_template = pickweight(weighted_templates)
		var/turf/spawn_loc = find_valid_cave_feature_location(feature_template, valid_tiles, placed_features)

		if(!spawn_loc)
			continue

		var/datum/map_template/template = new feature_template.template_path()
		if(template && template.load(spawn_loc, centered = FALSE))
			placed_features += spawn_loc

			var/blocked_radius = max(feature_template.width, feature_template.height) + min_feature_distance
			for(var/turf/check in valid_tiles)
				var/dx = spawn_loc.x - check.x
				var/dy = spawn_loc.y - check.y
				if(dx * dx + dy * dy < blocked_radius * blocked_radius)
					valid_tiles -= check

/datum/cave_generator/proc/find_valid_cave_feature_location(datum/cave_feature_template/feature_template, list/valid_tiles, list/placed_features)
	var/max_attempts = 20

	for(var/i = 1 to max_attempts)
		var/turf/candidate = pick(valid_tiles)

		var/too_close = FALSE
		for(var/turf/placed in placed_features)
			var/dx = candidate.x - placed.x
			var/dy = candidate.y - placed.y
			if(dx * dx + dy * dy < min_feature_distance * min_feature_distance)
				too_close = TRUE
				break

		if(too_close)
			continue

		var/valid = TRUE
		for(var/x = 0 to feature_template.width - 1)
			for(var/y = 0 to feature_template.height - 1)
				var/turf/T = locate(candidate.x + x, candidate.y + y, candidate.z)
				if(!T || istype(T, wall_turf) || istype(T, ravine_turf) || istype(T, lava_turf))
					valid = FALSE
					break
			if(!valid)
				break

		if(valid)
			return candidate

	return null

/datum/cave_generator/proc/count_neighbors(list/map, x, y)
	var/count = 0
	for(var/dx = -1 to 1)
		for(var/dy = -1 to 1)
			if(dx == 0 && dy == 0)
				continue
			if(map["[x+dx],[y+dy]"])
				count++
	return count
