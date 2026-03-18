/datum/biome/forest
	name = "Forest"
	id = BIOME_FOREST

	flora_density_base = 1.2

	temp_preference = 0.5
	temp_tolerance = 0.2
	temp_falloff = 0.3

/datum/biome/forest/calculate_height(elevation, x, y)
	// Use biome-specific seed
	var/elevation_noise = dot_point_noise(x * 0.01, y * 0.01, 1001) * 0.15
	var/modified_elevation = elevation + elevation_noise

	if(modified_elevation > 0.7)
		return 2
	else if(modified_elevation > 0.5)
		return 1
	else
		return 0

/datum/biome/forest/apply_height_noise(height, elevation, x, y)
	// Different seed and scale for height variation
	var/height_noise = dot_point_noise(x * 0.02, y * 0.02, 1002)

	if(height_noise > 0.6 && elevation > 0.5)
		height = min(height + 1, 2)
	else if(height_noise < -0.6 && height > 0)
		height = max(height - 1, 0)

	return height

/datum/biome/forest/calculate_suitability_score(temp, moisture, elevation)
	var/score = 0.3
	// Ideal temperature range: 0.3 to 0.7
	if(temp >= 0.3 && temp <= 0.7)
		score += 0.4
	else
		score -= abs(temp - 0.5) * 0.3
	// Moderate moisture preference: 0.2 to 0.6
	if(moisture >= 0.2 && moisture <= 0.6)
		score += 0.3
	else
		score -= abs(moisture - 0.4) * 0.2
	// Prefer mid-range elevations
	if(elevation >= 0.2 && elevation <= 0.6)
		score += 0.3
	else if(elevation > 0.6 && elevation <= 0.8)
		score -= (elevation - 0.6) * 0.4
	else if(elevation > 0.8)
		score -= (elevation - 0.6) * 2.0
	else
		score -= (0.2 - elevation) * 0.8
	return max(0, score)

/datum/biome/forest/generate_ground_terrain(turf/T, temp, moisture, elevation, x, y)
	var/terrain_noise = simple_noise(x * 0.002, y * 0.002, 5000)
	var/detail_noise = simple_noise(x * 0.008, y * 0.008, 5001)

	var/terrain_value = (elevation * 0.8) + (terrain_noise * 0.15) + (detail_noise * 0.05)
	var/moisture_value = (moisture * 0.85) + (simple_noise(x * 0.005, y * 0.005, 5002) * 0.15)

	if(terrain_value > 0.7)
		T.ChangeTurf(/turf/open/floor/grass/cold, flags = CHANGETURF_SKIP)
	else if(terrain_value > 0.4)
		T.ChangeTurf(/turf/open/floor/grass, flags = CHANGETURF_SKIP)
	else if(moisture_value > 0.3)
		T.ChangeTurf(/turf/open/floor/grass, flags = CHANGETURF_SKIP)
	else if(moisture_value > -0.3)
		T.ChangeTurf(/turf/open/floor/grass/mixyel, flags = CHANGETURF_SKIP)
	else if(moisture_value > -0.6)
		T.ChangeTurf(/turf/open/floor/grass/yel, flags = CHANGETURF_SKIP)
	else if(moisture_value < -0.6)
		T.ChangeTurf(/turf/open/floor/dirt, flags = CHANGETURF_SKIP)
	else
		T.ChangeTurf(/turf/open/floor/grass/mixyel, flags = CHANGETURF_SKIP)

/datum/biome/forest/generate_elevated_terrain(turf/T, temp, moisture, elevation, relative_height, x, y)
	var/terrain_noise = simple_noise(x * 0.002, y * 0.002, 5000)
	var/detail_noise = simple_noise(x * 0.008, y * 0.008, 5001)

	var/terrain_value = (elevation * 0.8) + (terrain_noise * 0.15) + (detail_noise * 0.05)
	var/moisture_value = (moisture * 0.85) + (simple_noise(x * 0.005, y * 0.005, 5002) * 0.15)

	if(relative_height >= 2)
		if(terrain_value > 0.7)
			T.ChangeTurf(/turf/open/floor/grass/cold, flags = CHANGETURF_SKIP)
		else if(terrain_value > 0.4)
			T.ChangeTurf(/turf/open/floor/grass, flags = CHANGETURF_SKIP)
		else if(moisture_value > 0.3)
			T.ChangeTurf(/turf/open/floor/grass, flags = CHANGETURF_SKIP)
		else if(moisture_value < -0.3)
			T.ChangeTurf(/turf/open/floor/dirt, flags = CHANGETURF_SKIP)
		else
			T.ChangeTurf(/turf/open/floor/grass/mixyel, flags = CHANGETURF_SKIP)
	else
		// Lower forest hills
		if(terrain_value > 0.7)
			T.ChangeTurf(/turf/open/floor/grass/cold, flags = CHANGETURF_SKIP)
		else if(terrain_value > 0.4)
			T.ChangeTurf(/turf/open/floor/grass, flags = CHANGETURF_SKIP)
		else if(moisture_value > 0.3)
			T.ChangeTurf(/turf/open/floor/grass, flags = CHANGETURF_SKIP)
		else if(moisture_value < -0.3)
			T.ChangeTurf(/turf/open/floor/dirt, flags = CHANGETURF_SKIP)
		else
			T.ChangeTurf(/turf/open/floor/grass/mixyel, flags = CHANGETURF_SKIP)

/datum/biome/forest/generate_structural_terrain(turf/T, elevation, relative_height, x, y)
	if(elevation > 0.7)
		T.ChangeTurf(/turf/closed/mineral/random, flags = CHANGETURF_SKIP)
	else
		T.ChangeTurf(/turf/closed/mineral, flags = CHANGETURF_SKIP)

/datum/biome/forest/select_wild_crops(temp, moisture, elevation)
	var/list/available_crops = list()

	// Always available
	available_crops += /obj/structure/wild_plant/nospread/strawberry
	available_crops += /obj/structure/wild_plant/nospread/blackberry
	available_crops += /obj/structure/wild_plant/nospread/raspberry
	available_crops += /obj/structure/wild_plant/nospread/jacksberry

	// Temperature dependent
	if(temp > 0.5)
		available_crops += /obj/structure/wild_plant/nospread/apple
		available_crops += /obj/structure/wild_plant/nospread/pear
		available_crops += /obj/structure/wild_plant/nospread/plum

	// Warm forests only
	if(temp > 0.6)
		available_crops += /obj/structure/wild_plant/nospread/tangerine
		available_crops += /obj/structure/wild_plant/nospread/lemon
		available_crops += /obj/structure/wild_plant/nospread/lime

	// Forest clearings
	if(prob(30))
		available_crops += /obj/structure/wild_plant/nospread/wheat
		available_crops += /obj/structure/wild_plant/nospread/oat
		available_crops += /obj/structure/wild_plant/nospread/sunflower
		available_crops += /obj/structure/wild_plant/nospread/sunreed

	// Moist forest floors
	if(moisture > 0.4)
		available_crops += /obj/structure/wild_plant/nospread/turnip
		available_crops += /obj/structure/wild_plant/nospread/cabbage
		available_crops += /obj/structure/wild_plant/nospread/onion
		available_crops += /obj/structure/wild_plant/nospread/pompkaun

	// Rare poison berries
	if(prob(10))
		available_crops += /obj/structure/wild_plant/nospread/jacksberry_poison

	return pick(available_crops)

/datum/biome/forest/select_herbs(temp, moisture, elevation)
	var/list/available_herbs = list()

	// Common forest herbs
	available_herbs += /obj/structure/flora/grass/herb/urtica
	available_herbs += /obj/structure/flora/grass/herb/hypericum
	available_herbs += /obj/structure/flora/grass/herb/symphitum

	// Temperature dependent
	if(temp > 0.4)
		available_herbs += /obj/structure/flora/grass/herb/salvia
		available_herbs += /obj/structure/flora/grass/herb/calendula

	// Moisture dependent
	if(moisture > 0.4)
		available_herbs += /obj/structure/flora/grass/herb/mentha
		available_herbs += /obj/structure/flora/grass/herb/valeriana

	// Shade tolerant forest herbs
	if(moisture > 0.3 && temp < 0.7)
		available_herbs += /obj/structure/flora/grass/herb/paris
		available_herbs += /obj/structure/flora/grass/herb/atropa

	// Always possible
	available_herbs += /obj/structure/wild_plant/nospread/poppy

	return pick(available_herbs)

/datum/biome/forest/select_understory(temp, moisture, elevation)
	var/list/available_understory = list()

	if(moisture > 0.3)
		available_understory += /obj/structure/flora/grass/bush_meagre
	if(temp > 0.4)
		available_understory += /obj/structure/flora/grass/pyroclasticflowers

	available_understory += /obj/structure/flora/grass/tundra
	available_understory += /obj/structure/flora/grass/bush
	available_understory += /obj/structure/flora/grass

	return pick(available_understory)

/datum/biome/forest/select_tree(temp, moisture, elevation)
	var/list/possible_trees = list()
	if(temp > 0.4 && moisture > 0.2)
		possible_trees += /obj/structure/flora/newtree
	if(temp < 0.6 && elevation > 0.3)
		possible_trees += /obj/structure/flora/newtree
	if(temp > 0.3 && moisture > 0.4)
		possible_trees += /obj/structure/flora/tree/pine
	if(temp > 0.5 && moisture > 0.3)
		possible_trees += /obj/structure/flora/newtree
	return possible_trees.len ? pick(possible_trees) : null
