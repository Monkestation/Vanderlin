/proc/generate_cave_system(list/env_data)
	world.log << "Generating cave systems with large chambers and prominent lava lakes..."
	var/list/cave_map = list()
	var/list/biome_map = env_data["biomes"]
	var/list/elevation_map = env_data["elevation"]

	for(var/x = 1; x <= MAP_SIZE; x++)
		cave_map["[x]"] = list()
		for(var/y = 1; y <= MAP_SIZE; y++)
			cave_map["[x]"]["[y]"] = CAVE_WALL

	var/list/chamber_locations = generate_large_chambers(cave_map, biome_map, elevation_map)
	cave_map = connect_chambers_with_tunnels(cave_map, chamber_locations)
	cave_map = generate_cave_pockets(cave_map, biome_map, elevation_map)
	cave_map = generate_lava_features(cave_map, biome_map, elevation_map, chamber_locations)
	cave_map = cleanup_caves(cave_map)

	var/list/ore_map = generate_ore_veins_old(biome_map, elevation_map, cave_map)

	return list("caves" = cave_map, "ores" = ore_map)

/proc/generate_large_chambers(list/cave_map, list/biome_map, list/elevation_map)
	var/list/chamber_locations = list()
	var/chamber_count = rand(18, 33 )  // More chambers
	var/attempts = 0
	var/max_attempts = 200

	while(length(chamber_locations) < chamber_count && attempts < max_attempts)
		attempts++

		// Try to place a chamber
		var/chamber_x = rand(40, MAP_SIZE-40)
		var/chamber_y = rand(40, MAP_SIZE-40)
		var/chamber_size = rand(8, 12)

		// Check if this location is valid (not too close to other chambers)
		var/valid_location = 1
		for(var/list/existing_chamber in chamber_locations)
			var/dist = sqrt((chamber_x - existing_chamber[1])**2 + (chamber_y - existing_chamber[2])**2)
			if(dist < (chamber_size + existing_chamber[3] + 20))  // Minimum distance
				valid_location = 0
				break

		if(valid_location)
			// Create the chamber
			create_large_chamber(cave_map, chamber_x, chamber_y, chamber_size, biome_map, elevation_map)
			chamber_locations += list(list(chamber_x, chamber_y, chamber_size))
			world.log << "Created large chamber at ([chamber_x], [chamber_y]) with size [chamber_size]"

	return chamber_locations

/proc/create_large_chamber(list/cave_map, center_x, center_y, size, list/biome_map, list/elevation_map)
	var/num_circles = rand(5, 7)

	for(var/i = 1; i <= num_circles; i++)
		var/circle_x = center_x + rand(-size/3, size/3)
		var/circle_y = center_y + rand(-size/3, size/3)
		var/circle_size = size * rand(0.6, 1.2)

		for(var/dx = -circle_size; dx <= circle_size; dx++)
			for(var/dy = -circle_size; dy <= circle_size; dy++)
				var/dist = sqrt(dx*dx + dy*dy)

				// Add noise for irregular edges
				var/noise_factor = simple_noise((circle_x + dx) * 0.08, (circle_y + dy) * 0.08, 1000) * 3

				if(dist <= circle_size + noise_factor)
					var/nx = circle_x + dx
					var/ny = circle_y + dy
					if(nx >= 1 && nx <= MAP_SIZE && ny >= 1 && ny <= MAP_SIZE)
						cave_map["[nx]"]["[ny]"] = CAVE_CHAMBER

/proc/connect_chambers_with_tunnels(list/cave_map, list/chamber_locations)
	for(var/i = 1; i <= length(chamber_locations); i++)
		var/list/chamber1 = chamber_locations[i]

		var/closest_dist = 999999
		var/list/closest_chamber = null

		for(var/j = 1; j <= length(chamber_locations); j++)
			if(i == j) continue

			var/list/chamber2 = chamber_locations[j]
			var/dist = sqrt((chamber1[1] - chamber2[1])**2 + (chamber1[2] - chamber2[2])**2)

			if(dist < closest_dist)
				closest_dist = dist
				closest_chamber = chamber2

		if(closest_chamber)
			create_connecting_tunnel(cave_map, chamber1[1], chamber1[2], closest_chamber[1], closest_chamber[2])

		// Sometimes add a second connection for more interesting layouts
		if(prob(40) && length(chamber_locations) > 2)
			var/list/other_chamber = null
			var/attempts = 0
			while(!other_chamber && attempts < 10)
				attempts++
				var/random_index = rand(1, length(chamber_locations))
				if(random_index != i)
					other_chamber = chamber_locations[random_index]
					if(other_chamber == closest_chamber)
						other_chamber = null

			if(other_chamber)
				create_connecting_tunnel(cave_map, chamber1[1], chamber1[2], other_chamber[1], other_chamber[2])

	return cave_map

/proc/create_connecting_tunnel(list/cave_map, start_x, start_y, end_x, end_y)
	var/x = start_x
	var/y = start_y
	var/tunnel_width = 1  // Very narrow connecting tunnels
	var/steps = 0
	var/max_steps = 300

	while((abs(x - end_x) > 2 || abs(y - end_y) > 2) && steps < max_steps)
		steps++

		for(var/dx = -tunnel_width; dx <= tunnel_width; dx++)
			for(var/dy = -tunnel_width; dy <= tunnel_width; dy++)
				var/nx = x + dx
				var/ny = y + dy
				if(nx >= 1 && nx <= MAP_SIZE && ny >= 1 && ny <= MAP_SIZE)
					// Only carve if it's solid rock (preserve chambers)
					if(cave_map["[nx]"]["[ny]"] == CAVE_WALL)
						cave_map["[nx]"]["[ny]"] = CAVE_TUNNEL

		var/dx = end_x - x
		var/dy = end_y - y
		var/distance = sqrt(dx*dx + dy*dy)

		if(distance > 0)
			dx = dx / distance
			dy = dy / distance

		// Add some randomness for winding paths
		dx += rand(-0.3, 0.3)
		dy += rand(-0.3, 0.3)

		// Normalize again
		distance = sqrt(dx*dx + dy*dy)
		if(distance > 0)
			dx = dx / distance
			dy = dy / distance

		x += round(dx * 1.5)
		y += round(dy * 1.5)

		x = max(1, min(MAP_SIZE, x))
		y = max(1, min(MAP_SIZE, y))

		// Occasionally widen the tunnel slightly
		if(prob(5))
			tunnel_width = rand(1, 2)
		else
			tunnel_width = 1

/proc/generate_cave_pockets(list/cave_map, list/biome_map, list/elevation_map)
	// Generate smaller additional cave pockets
	for(var/x = 1; x <= MAP_SIZE; x++)
		for(var/y = 1; y <= MAP_SIZE; y++)
			// Skip if already carved
			if(cave_map["[x]"]["[y]"] != CAVE_WALL)
				continue

			var/cave_noise = simple_noise(x * 0.025, y * 0.025, 1000)
			var/detail_noise = simple_noise(x * 0.1, y * 0.1, 2000) * 0.4

			var/combined_noise = cave_noise + detail_noise

			// Higher threshold for smaller, scattered pockets
			var/cave_threshold = 0.85
			if(biome_map["[x]"]["[y]"] == BIOME_MOUNTAIN)
				cave_threshold = 0.8

			// Bias toward lower elevations
			var/elevation_factor = 1.2 - elevation_map["[x]"]["[y]"] * 0.4
			combined_noise *= elevation_factor

			if(combined_noise > cave_threshold)
				cave_map["[x]"]["[y]"] = CAVE_EMPTY

	return cave_map

/proc/cleanup_caves(list/cave_map)
	var/list/new_cave_map = list()

	for(var/x = 1; x <= MAP_SIZE; x++)
		new_cave_map["[x]"] = list()
		for(var/y = 1; y <= MAP_SIZE; y++)
			var/current_type = cave_map["[x]"]["[y]"]

			if(current_type == CAVE_EMPTY)
				var/wall_neighbors = 0
				for(var/dx = -1; dx <= 1; dx++)
					for(var/dy = -1; dy <= 1; dy++)
						if(dx == 0 && dy == 0) continue
						var/nx = x + dx
						var/ny = y + dy
						if(nx < 1 || nx > MAP_SIZE || ny < 1 || ny > MAP_SIZE)
							wall_neighbors++
						else if(cave_map["[nx]"]["[ny]"] == CAVE_WALL)
							wall_neighbors++

				if(wall_neighbors >= 7)
					new_cave_map["[x]"]["[y]"] = CAVE_WALL
				else
					new_cave_map["[x]"]["[y]"] = current_type
			else
				new_cave_map["[x]"]["[y]"] = current_type

	return new_cave_map

/proc/generate_underground_terrain(list/biome_map, list/elevation_map, list/cave_map, list/ore_map)
	world.log << "Generating underground terrain with large chambers and prominent lava features..."

	for(var/x = 1; x <= MAP_SIZE; x++)
		for(var/y = 1; y <= MAP_SIZE; y++)
			var/turf/T = locate(x, y, Z_UNDERGROUND)
			if(!T) continue

			var/biome = biome_map["[x]"]["[y]"]
			var/elevation = elevation_map["[x]"]["[y]"]
			var/cave_type = cave_map["[x]"]["[y]"]
			var/ore_type = ore_map["[x]"]["[y]"]

			///Dawg I swear one day I will add more to this
			if(cave_type != CAVE_WALL)
				switch(cave_type)
					if(CAVE_LAVA_LAKE, CAVE_LAVA_RIVER, CAVE_LAVA_STREAM)
						T.ChangeTurf(/turf/open/lava, flags = CHANGETURF_SKIP)
					else
						T.ChangeTurf(/turf/open/floor/naturalstone, flags = CHANGETURF_SKIP)
						add_cave_features(T, biome, elevation, x, y)
			else
				if(ore_type)
					place_ore_deposit_clustered(T, ore_type, x, y, ore_map)
				else
					T.ChangeTurf(/turf/closed/mineral, flags = CHANGETURF_SKIP)
