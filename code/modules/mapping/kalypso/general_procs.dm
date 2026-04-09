GLOBAL_LIST_EMPTY(spawned_features)
GLOBAL_LIST_EMPTY(flora_blocked_tiles)

/proc/place_comprehensive_flora(list/env_data)
	world.log << "Placing comprehensive flora system..."
	var/list/biome_map = env_data["biomes"]
	var/list/temperature_map = env_data["temperature"]
	var/list/moisture_map = env_data["moisture"]
	var/list/elevation_map = env_data["elevation"]

	for(var/x = 1; x <= MAP_SIZE; x++)
		for(var/y = 1; y <= MAP_SIZE; y++)
			var/checked_z = Z_GROUND
			var/turf/T = locate(x, y, checked_z)
			while(T && T?.density && checked_z != Z_HIGH_AIR + 1)
				if(!T || T.density)
					checked_z++
					T = locate(x, y, checked_z)
			if(!T || T.density)
				continue

			var/biome = biome_map["[x]"]["[y]"]
			var/temp = temperature_map["[x]"]["[y]"]
			var/moisture = moisture_map["[x]"]["[y]"]
			var/elevation = elevation_map["[x]"]["[y]"]

			place_biome_specific_flora(T, biome, temp, moisture, elevation, x, y, env_data)

/proc/place_biome_specific_flora(turf/T, biome, temp, moisture, elevation, x, y, list/env_data)
	if(is_flora_blocked(x, y, T.z))
		return

	var/datum/biome/biome_datum = get_biome_datum(biome)
	if(!biome_datum)
		return

	var/flora_density = biome_datum.get_flora_density(temp, moisture, elevation)

	if(!prob(flora_density * 100))
		return

	// Check for rivers first
	generate_river_terrain(T, env_data, x, y)

	var/list/river_map = env_data["rivers"]
	if(river_map && river_map["[x]"]["[y]"])
		return // TODO: add water based ecosystem

	biome_datum.place_ecosystem(T, temp, moisture, elevation, x, y)

// Comprehensive terrain generation for all z-levels
/proc/generate_comprehensive_terrain(list/env_data, list/cave_map, list/ore_map)
	world.log << "Generating comprehensive terrain across all z-levels with verticality..."

	var/list/biome_map = env_data["biomes"]
	var/list/temperature_map = env_data["temperature"]
	var/list/moisture_map = env_data["moisture"]
	var/list/elevation_map = env_data["elevation"]

	// Generate height map for vertical features
	var/list/height_map = generate_height_map(biome_map, elevation_map)

	// Store height map in env_data for later use
	env_data["height"] = height_map

	// Generate underground level first
	generate_underground_terrain(biome_map, elevation_map, cave_map, ore_map)

	for(var/x = 1; x <= MAP_SIZE; x++)
		for(var/y = 1; y <= MAP_SIZE; y++)
			var/terrain_height = height_map["[x]"]["[y]"]
			var/biome = biome_map["[x]"]["[y]"]
			var/temperature = temperature_map["[x]"]["[y]"]
			var/moisture = moisture_map["[x]"]["[y]"]
			var/elevation = elevation_map["[x]"]["[y]"]

			// Generate terrain for each z-level
			generate_vertical_terrain_column(x, y, terrain_height, biome, temperature, moisture, elevation, env_data)

/proc/generate_vertical_terrain_column(x, y, height, biome, temperature, moisture, elevation, list/env_data)
	var/turf/ground_turf = locate(x, y, Z_GROUND)
	if(ground_turf)
		if(height > 0)
			// If there's height above, this becomes a mineral wall base
			generate_mineral_wall_base(ground_turf, biome, elevation, x, y, env_data)
		else
			// Normal ground terrain
			generate_detailed_ground_tile(ground_turf, biome, temperature, moisture, elevation, x, y, env_data)

	for(var/z = Z_AIR; z <= Z_HIGH_AIR; z++)
		var/turf/air_turf = locate(x, y, z)
		if(!air_turf) continue

		var/relative_height = z - Z_GROUND  // Height relative to ground level

		if(relative_height <= height)
			// This level should have terrain
			generate_elevated_terrain(air_turf, biome, temperature, moisture, elevation, relative_height, x, y, env_data)
		else
			// This level should be open space
			air_turf.ChangeTurf(/turf/open/openspace, flags = CHANGETURF_SKIP)

/proc/generate_mineral_wall_base(turf/T, biome, elevation, x, y, list/env_data)
	generate_river_terrain(T, env_data, x, y)

	var/list/river_map = env_data["rivers"]
	if(river_map && river_map["[x]"]["[y]"])
		return

	var/datum/biome/biome_datum = get_biome_datum(biome)
	if(biome_datum)
		biome_datum.generate_structural_terrain(T, elevation, 1, x, y)

/proc/generate_elevated_terrain(turf/T, biome, temperature, moisture, elevation, relative_height, x, y, list/env_data)
	var/list/height_map = env_data["height"]
	var/max_height = height_map["[x]"]["[y]"]
	var/is_top_level = (relative_height == max_height)
	var/datum/biome/biome_datum = get_biome_datum(biome)
	if(!biome_datum)
		return

	if(is_top_level)
		biome_datum.generate_elevated_terrain(T, temperature, moisture, elevation, relative_height, x, y)
	else
		biome_datum.generate_structural_terrain(T, elevation, relative_height, x, y)

/proc/generate_vertical_wall_base(turf/T, biome, elevation, x, y, list/env_data)
	generate_river_terrain(T, env_data, x, y)

	var/list/river_map = env_data["rivers"]
	if(river_map && river_map["[x]"]["[y]"])
		return

	var/datum/biome/biome_datum = get_biome_datum(biome)
	if(biome_datum)
		biome_datum.generate_structural_terrain(T, elevation, 1, x, y)


/proc/add_cave_features(turf/T, biome, elevation, x, y) //TODO: Swap this over to a cave biome
	// Crystal formations in mountains
	if(biome == BIOME_MOUNTAIN && elevation > 0.7 && prob(2))
		new /obj/item/mana_battery/mana_crystal/standard(T)

/proc/generate_ground_terrain(list/biome_map, list/temperature_map, list/moisture_map, list/elevation_map, list/env_data)
	world.log << "Generating detailed ground terrain..."

	for(var/x = 1; x <= MAP_SIZE; x++)
		for(var/y = 1; y <= MAP_SIZE; y++)
			var/turf/T = locate(x, y, Z_GROUND)
			if(!T) continue

			var/biome = biome_map["[x]"]["[y]"]
			var/temperature = temperature_map["[x]"]["[y]"]
			var/moisture = moisture_map["[x]"]["[y]"]
			var/elevation = elevation_map["[x]"]["[y]"]

			generate_detailed_ground_tile(T, biome, temperature, moisture, elevation, x, y, env_data)


/proc/generate_detailed_ground_tile(turf/T, biome, temperature, moisture, elevation, x, y, list/env_data)
	generate_river_terrain(T, env_data, x, y)

	var/list/river_map = env_data["rivers"]
	if(river_map && river_map["[x]"]["[y]"])
		return //! Skip other terrain generation for river tiles

	var/datum/biome/biome_datum = get_biome_datum(biome)
	if(biome_datum)
		biome_datum.generate_ground_terrain(T, temperature, moisture, elevation, x, y)

/proc/smooth_terrain_post_process()
	world.log << "Applying enhanced terrain smoothing..."

	for(var/pass = 1; pass <= 4; pass++)
		for(var/x = 2; x <= MAP_SIZE-1; x++)
			for(var/y = 2; y <= MAP_SIZE-1; y++)
				var/turf/T = locate(x, y, Z_GROUND)
				if(!T) continue

				smooth_terrain_tile(T, x, y)

/proc/smooth_terrain_tile(turf/T, x, y)
	var/list/terrain_counts = list()

	// Check 3x3 neighborhood
	for(var/dx = -1; dx <= 1; dx++)
		for(var/dy = -1; dy <= 1; dy++)
			var/nx = x + dx
			var/ny = y + dy
			if(nx >= 1 && nx <= MAP_SIZE && ny >= 1 && ny <= MAP_SIZE)
				var/turf/neighbor = locate(nx, ny, Z_GROUND)
				if(neighbor)
					var/terrain_type = neighbor.type
					terrain_counts["[terrain_type]"] = (terrain_counts["[terrain_type]"] || 0) + 1

	// Find most common terrain type
	var/dominant_terrain = T.type
	var/max_count = 0

	for(var/terrain_type in terrain_counts)
		var/count = terrain_counts["[terrain_type]"]
		if(count > max_count)
			max_count = count
			dominant_terrain = text2path(terrain_type)

	if(max_count >= 5 && T.type != dominant_terrain)
		T.ChangeTurf(dominant_terrain, flags = CHANGETURF_SKIP)

/proc/generate_complete_world()
	world.log << "=== Starting Complete World Generation with Verticality ==="
	var/start_timeofday = REALTIMEOFDAY
	var/time
	// Initialize seed
	init_world_seed()

	// Step 1: Generate environmental data
	world.log << "Step 1: Generating environmental maps..."
	var/list/env_data = generate_biome_map()
	time = (REALTIMEOFDAY - start_timeofday) / 10
	start_timeofday = REALTIMEOFDAY
	world.log << "Step 1: Took [time] Seconds"

	// Step 2: Generate cave systems
	world.log << "Step 2: Generating cave systems..."
	var/list/maps = generate_cave_system(env_data)
	time = (REALTIMEOFDAY - start_timeofday) / 10
	start_timeofday = REALTIMEOFDAY
	world.log << "Step 2: Took [time] Seconds"

	var/list/cave_map = maps["caves"]
	var/list/ore_map = maps["ores"]

	// Step 2.5: Generate river systems
	world.log << "Step 3: Generating river systems..."
	generate_river_system(env_data)
	time = (REALTIMEOFDAY - start_timeofday) / 10
	start_timeofday = REALTIMEOFDAY
	world.log << "Step 3: Took [time] Seconds"

	// Step 4: Generate all terrain with verticality
	world.log << "Step 4: Generating terrain with verticality..."
	generate_comprehensive_terrain(env_data, cave_map, ore_map)
	time = (REALTIMEOFDAY - start_timeofday) / 10
	start_timeofday = REALTIMEOFDAY
	world.log << "Step 4: Took [time] Seconds"

	// Step 4.5: Apply terrain smoothing
	world.log << "Step 4.5: Applying terrain smoothing..."
	smooth_terrain_post_process()
	time = (REALTIMEOFDAY - start_timeofday) / 10
	start_timeofday = REALTIMEOFDAY
	world.log << "Step 4.5: Took [time] Seconds"

	// Step 5: Place features
	world.log << "Step 5: Spawning world features..."
	spawn_world_features(env_data)
	time = (REALTIMEOFDAY - start_timeofday) / 10
	start_timeofday = REALTIMEOFDAY
	world.log << "Step 5: Took [time] Seconds"

	// Step 6: Place flora
	world.log << "Step 6: Placing flora..."
	place_comprehensive_flora(env_data)
	time = (REALTIMEOFDAY - start_timeofday) / 10
	start_timeofday = REALTIMEOFDAY
	world.log << "Step 6: Took [time] Seconds"

	// Step 7: Spawn creatures
	world.log << "Step 7: Spawning ecological creatures..."
	spawn_ecological_creatures(env_data)
	time = (REALTIMEOFDAY - start_timeofday) / 10
	start_timeofday = REALTIMEOFDAY
	world.log << "Step 7: Took [time] Seconds"

	world.log << "=== World Generation Complete ==="
	world.log << "Generated [MAP_SIZE]x[MAP_SIZE]x4 world."
