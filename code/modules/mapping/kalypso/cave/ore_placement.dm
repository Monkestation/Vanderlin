
/proc/generate_ore_veins_old(list/biome_map, list/elevation_map, list/cave_map)
	world.log << "Generating ore veins using improved vein placement..."
	var/list/ore_map = list()

	for(var/x = 1; x <= MAP_SIZE; x++)
		ore_map["[x]"] = list()
		for(var/y = 1; y <= MAP_SIZE; y++)
			ore_map["[x]"]["[y]"] = null

	var/map_scale = (MAP_SIZE * MAP_SIZE) / 100000

	var/list/ore_types = list(
		list("iron", 80 * map_scale, 25),      // name, num_veins, avg_length
		list("copper", 70 * map_scale, 17),
		list("coal", 90 * map_scale, 15),
		list("tin", 60 * map_scale, 17),
		list("silver", 45 * map_scale, 15),
		list("gold", 30 * map_scale, 13),
		list("mana", 20 * map_scale, 10),
		list("cinnabar", 20 * map_scale, 10),
		list("salt", 10 * map_scale, 10),
	)

	for(var/list/ore_config in ore_types)
		var/ore_name = ore_config[1]
		var/num_veins = ore_config[2]
		var/avg_length = ore_config[3]

		for(var/i = 1; i <= num_veins; i++)
			generate_organic_vein(ore_map, biome_map, cave_map, ore_name, avg_length)

	return ore_map

/proc/generate_organic_vein(list/ore_map, list/biome_map, list/cave_map, ore_name, avg_length)
	var/start_x, start_y
	var/attempts = 0

	while(attempts < 20)
		attempts++
		start_x = rand(1, MAP_SIZE)
		start_y = rand(1, MAP_SIZE)

		if(cave_map["[start_x]"]["[start_y]"] != CAVE_WALL)
			continue

		if(ore_map["[start_x]"]["[start_y]"])
			continue

		var/biome = biome_map["[start_x]"]["[start_y]"]
		var/biome_suitable = TRUE

		//TODO: have biomes return probs instead
		switch(ore_name)
			if("coal")
				biome_suitable = (biome == BIOME_FOREST) ? prob(70) : prob(30)
			if("gold", "mana")
				biome_suitable = (biome == BIOME_MOUNTAIN) ? prob(70) : prob(40)

		if(biome_suitable)
			break

	if(attempts >= 20)
		return

	create_ore_cluster(ore_map, cave_map, ore_name, start_x, start_y, rand(2, 4))

	var/num_tendrils = rand(2, 5)
	var/remaining_ore = avg_length - 6  // Account for initial cluster

	for(var/t = 1; t <= num_tendrils; t++)
		var/tendril_length = rand(remaining_ore / num_tendrils * 0.5, remaining_ore / num_tendrils * 1.5)
		generate_organic_tendril(ore_map, cave_map, ore_name, start_x, start_y, tendril_length)

/proc/create_ore_cluster(list/ore_map, list/cave_map, ore_name, center_x, center_y, radius)
	// Create a small cluster around the center point
	for(var/x = center_x - radius; x <= center_x + radius; x++)
		for(var/y = center_y - radius; y <= center_y + radius; y++)
			if(x >= 1 && x <= MAP_SIZE && y >= 1 && y <= MAP_SIZE)
				var/distance = sqrt((x - center_x)**2 + (y - center_y)**2)
				if(distance <= radius && prob(80 - distance * 20)) // Higher chance closer to center
					if(cave_map["[x]"]["[y]"] == CAVE_WALL && !ore_map["[x]"]["[y]"])
						ore_map["[x]"]["[y]"] = ore_name

/proc/generate_organic_tendril(list/ore_map, list/cave_map, ore_name, start_x, start_y, max_length)
	var/list/directions = list(
		list(1, 0), list(-1, 0), list(0, 1), list(0, -1),
		list(1, 1), list(-1, -1), list(1, -1), list(-1, 1)
	)

	var/current_x = start_x
	var/current_y = start_y
	var/length_used = 0
	var/current_direction = rand(1, 8)
	var/direction_changes = 0
	var/max_direction_changes = rand(3, 8)

	// Find a valid starting direction away from the cluster
	for(var/attempt = 1; attempt <= 8; attempt++)
		var/test_dir = rand(1, 8)
		var/list/move = directions[test_dir]
		var/test_x = start_x + move[1] * 2
		var/test_y = start_y + move[2] * 2

		if(test_x >= 1 && test_x <= MAP_SIZE && test_y >= 1 && test_y <= MAP_SIZE)
			if(cave_map["[test_x]"]["[test_y]"] == CAVE_WALL && !ore_map["[test_x]"]["[test_y]"])
				current_direction = test_dir
				break

	while(length_used < max_length && direction_changes < max_direction_changes)
		var/steps_in_direction = rand(1, 4)

		for(var/step = 1; step <= steps_in_direction && length_used < max_length; step++)
			var/list/move = directions[current_direction]
			var/next_x = current_x + move[1]
			var/next_y = current_y + move[2]

			if(next_x < 1 || next_x > MAP_SIZE || next_y < 1 || next_y > MAP_SIZE)
				break

			if(cave_map["[next_x]"]["[next_y]"] != CAVE_WALL)
				break

			if(ore_map["[next_x]"]["[next_y]"])
				current_x = next_x
				current_y = next_y
				continue

			// Place ore
			ore_map["[next_x]"]["[next_y]"] = ore_name
			length_used++

			// Chance to create a small pocket
			if(prob(25))
				create_small_pocket(ore_map, cave_map, ore_name, next_x, next_y)

			// Chance to branch
			if(prob(20) && length_used > 3)
				var/branch_length = rand(2, max_length * 0.4)
				generate_organic_branch(ore_map, cave_map, ore_name, next_x, next_y, branch_length)

			current_x = next_x
			current_y = next_y

		if(prob(70))
			var/new_direction = current_direction + rand(-2, 2)
			if(new_direction < 1) new_direction += 8
			if(new_direction > 8) new_direction -= 8
			current_direction = new_direction
			direction_changes++

/proc/create_small_pocket(list/ore_map, list/cave_map, ore_name, center_x, center_y)
	var/pocket_size = rand(1, 2)

	for(var/x = center_x - pocket_size; x <= center_x + pocket_size; x++)
		for(var/y = center_y - pocket_size; y <= center_y + pocket_size; y++)
			if(x >= 1 && x <= MAP_SIZE && y >= 1 && y <= MAP_SIZE)
				if(prob(60)) // Random chance for organic shape
					if(cave_map["[x]"]["[y]"] == CAVE_WALL && !ore_map["[x]"]["[y]"])
						ore_map["[x]"]["[y]"] = ore_name

/proc/generate_organic_branch(list/ore_map, list/cave_map, ore_name, start_x, start_y, max_length)
	var/list/directions = list(
		list(1, 0), list(-1, 0), list(0, 1), list(0, -1),
		list(1, 1), list(-1, -1), list(1, -1), list(-1, 1)
	)

	var/current_x = start_x
	var/current_y = start_y
	var/branch_direction = rand(1, 8)
	var/length_used = 0
	var/direction_persistence = rand(1, 3)

	for(var/step = 1; step <= max_length; step++)
		direction_persistence--

		if(direction_persistence <= 0 || prob(40))
			branch_direction = rand(1, 8)
			direction_persistence = rand(1, 3)

		var/list/move = directions[branch_direction]
		var/next_x = current_x + move[1]
		var/next_y = current_y + move[2]

		if(next_x < 1 || next_x > MAP_SIZE || next_y < 1 || next_y > MAP_SIZE)
			break

		if(cave_map["[next_x]"]["[next_y]"] != CAVE_WALL)
			break

		// Skip if already has ore
		if(ore_map["[next_x]"]["[next_y]"])
			current_x = next_x
			current_y = next_y
			continue

		ore_map["[next_x]"]["[next_y]"] = ore_name
		length_used++

		// Chance to create tiny pockets in branches
		if(prob(15))
			create_tiny_pocket(ore_map, cave_map, ore_name, next_x, next_y)

		current_x = next_x
		current_y = next_y

		// Branches can have sub-branches (rarely)
		if(prob(10) && length_used > 2 && step < max_length - 3)
			generate_organic_branch(ore_map, cave_map, ore_name, current_x, current_y, rand(2, 4))

/proc/create_tiny_pocket(list/ore_map, list/cave_map, ore_name, center_x, center_y)
	var/list/adjacent = list(
		list(1, 0), list(-1, 0), list(0, 1), list(0, -1)
	)

	for(var/list/offset in adjacent)
		var/x = center_x + offset[1]
		var/y = center_y + offset[2]

		if(x >= 1 && x <= MAP_SIZE && y >= 1 && y <= MAP_SIZE)
			if(prob(40))
				if(cave_map["[x]"]["[y]"] == CAVE_WALL && !ore_map["[x]"]["[y]"])
					ore_map["[x]"]["[y]"] = ore_name

/proc/place_ore_deposit_clustered(turf/T, ore_type, x, y, list/ore_map)
	var/static/list/ore_turf_map = list(
		"iron" = /turf/closed/mineral/iron,
		"copper" = /turf/closed/mineral/copper,
		"silver" = /turf/closed/mineral/silver,
		"gold" = /turf/closed/mineral/gold,
		"mana" = /turf/closed/mineral/mana_crystal,
		"cinnabar" = /turf/closed/mineral/cinnabar,
		"coal" = /turf/closed/mineral/coal,
		"tin" = /turf/closed/mineral/tin,
		"salt" = /turf/closed/mineral/salt,
	)

	var/turf_type = ore_turf_map[ore_type]
	if(!turf_type)
		turf_type = /turf/closed/mineral/iron

	T.ChangeTurf(turf_type, flags = CHANGETURF_SKIP)
