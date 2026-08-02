/datum/biome/mountain
	name = "Mountain"
	id = BIOME_MOUNTAIN

	flora_density_base = 1.1
	wild_herb = 6
	wild_crop = 8
	understory_chance = 20
	tree = 15

	temp_preference = 0.35
	temp_tolerance = 0.25
	temp_falloff = 0.3

	trees = list(
		/obj/structure/flora/tree/pine,
		/obj/structure/flora/newtree
	)

/datum/biome/mountain/calculate_height(elevation, x, y)
	// Mountain-specific seed
	var/elevation_noise = dot_point_noise(x * 0.01, y * 0.01, 2001) * 0.15
	var/modified_elevation = elevation + elevation_noise

	if(modified_elevation > 0.75)
		return 3
	else if(modified_elevation > 0.55)
		return 2
	else if(modified_elevation > 0.35)
		return 1
	else
		return 0

/datum/biome/mountain/apply_height_noise(height, elevation, x, y)
	var/height_noise = dot_point_noise(x * 0.02, y * 0.02, 2002)

	if(height_noise > 0.3 && height < 3)
		height = min(height + 1, 3)
	else if(height_noise < -0.3 && height > 0)
		height = max(height - 1, 0)

	return height

/datum/biome/mountain/calculate_suitability_score(temp, moisture, elevation)
	var/score = 0.2  // Slightly higher base
	// Cooler temperature preference
	if(temp >= 0.1 && temp <= 0.6)
		score += 0.4
	else
		score -= abs(temp - 0.35) * 0.3
	// Mountains are less moisture dependent
	if(moisture >= 0.1 && moisture <= 0.8)
		score += 0.2
	else
		score -= 0.1
	// Mountains need high elevation
	if(elevation >= 0.65)  // More reasonable threshold
		score += (elevation - 0.65) * 3.0
	else if(elevation >= 0.45)
		score += (elevation - 0.45) * 1.2
	else if(elevation >= 0.3)
		score += (elevation - 0.3) * 0.4
	else
		score -= (0.3 - elevation) * 1.0
	return max(0, score)

/datum/biome/mountain/generate_ground_terrain(turf/T, temp, moisture, elevation, x, y)
	var/rock_noise = simple_noise(x * 0.0025, y * 0.0025, 7000)
	var/detail_noise = simple_noise(x * 0.01, y * 0.01, 7001)

	var/rock_value = (elevation * 0.85) + (rock_noise * 0.15)
	var/terrain_value = (elevation * 0.6) + (detail_noise * 0.15) + (moisture * 0.25)

	if(rock_value > 0.5)
		T.ChangeTurf(/turf/open/floor/naturalstone, flags = CHANGETURF_SKIP)
	else if(rock_value > 0.3)
		T.ChangeTurf(/turf/open/floor/cobblerock, flags = CHANGETURF_SKIP)
	else if(terrain_value > 0.25)
		T.ChangeTurf(/turf/open/floor/grass/cold, flags = CHANGETURF_SKIP)
	else if(terrain_value > 0.05)
		T.ChangeTurf(/turf/open/floor/dirt/road, flags = CHANGETURF_SKIP)
	else
		T.ChangeTurf(/turf/open/floor/dirt/road, flags = CHANGETURF_SKIP)

/datum/biome/mountain/generate_elevated_terrain(turf/T, temp, moisture, elevation, relative_height, x, y)
	var/terrain_noise = simple_noise(x * 0.003, y * 0.003, 8000 + relative_height * 100)

	if(relative_height >= 3)
		// High peaks - snow and bare rock
		if(terrain_noise > 0.3)
			T.ChangeTurf(/turf/open/floor/naturalstone, flags = CHANGETURF_SKIP)
		else
			T.ChangeTurf(/turf/open/floor/cobblerock, flags = CHANGETURF_SKIP)
	else if(relative_height >= 2)
		// Mid-high mountains
		if(terrain_noise > 0.2)
			T.ChangeTurf(/turf/open/floor/naturalstone, flags = CHANGETURF_SKIP)
		else
			T.ChangeTurf(/turf/open/floor/cobblerock, flags = CHANGETURF_SKIP)
	else
		// Lower mountains - more vegetation possible
		if(terrain_noise > 0.1)
			T.ChangeTurf(/turf/open/floor/cobblerock, flags = CHANGETURF_SKIP)
		else
			T.ChangeTurf(/turf/open/floor/grass/cold, flags = CHANGETURF_SKIP)

/datum/biome/mountain/generate_structural_terrain(turf/T, elevation, relative_height, x, y)
	if(elevation > 0.8)
		T.ChangeTurf(/turf/closed/mineral/random/high_valuable, flags = CHANGETURF_SKIP)
	else if(elevation > 0.6)
		T.ChangeTurf(/turf/closed/mineral/random, flags = CHANGETURF_SKIP)
	else if(elevation > 0.4)
		T.ChangeTurf(/turf/closed/mineral/iron, flags = CHANGETURF_SKIP)
	else
		T.ChangeTurf(/turf/closed/mineral, flags = CHANGETURF_SKIP)

/datum/biome/mountain/select_wild_crops(temp, moisture, elevation)
	var/list/available_crops = list()

	// Hardy mountain plants
	available_crops += /obj/structure/wild_plant/nospread/potato
	available_crops += /obj/structure/wild_plant/nospread/turnip
	available_crops += /obj/structure/wild_plant/nospread/oat

	// Lower elevation mountain crops
	if(elevation < 0.7)
		available_crops += /obj/structure/wild_plant/nospread/cabbage
		available_crops += /obj/structure/wild_plant/nospread/onion
		available_crops += /obj/structure/wild_plant/nospread/wheat
		available_crops += /obj/structure/wild_plant/nospread/sunreed
		available_crops += /obj/structure/wild_plant/nospread/strawberry

	// Mountain meadow flowers
	if(prob(30))
		available_crops += /obj/structure/wild_plant/nospread/sunflower
		available_crops += /obj/structure/wild_plant/nospread/poppy

	// Rare mountain berries
	if(prob(15) && elevation < 0.75)
		available_crops += /obj/structure/wild_plant/nospread/raspberry
		available_crops += /obj/structure/wild_plant/nospread/blackberry

	return pick(available_crops)

/datum/biome/mountain/select_herbs(temp, moisture, elevation)
	var/list/available_herbs = list()

	// Hardy mountain plants
	available_herbs += /obj/structure/flora/grass/herb/artemisia
	available_herbs += /obj/structure/flora/grass/herb/hypericum
	available_herbs += /obj/structure/flora/grass/herb/taraxacum

	// Lower elevation mountain herbs
	if(elevation < 0.7)
		available_herbs += /obj/structure/flora/grass/herb/salvia
		available_herbs += /obj/structure/flora/grass/herb/matricaria
		available_herbs += /obj/structure/flora/grass/herb/urtica

	// Alpine specialists (high elevation)
	if(elevation > 0.75)
		available_herbs += /obj/structure/flora/grass/herb/benedictus
		available_herbs += /obj/structure/wild_plant/nospread/poppy

	return pick(available_herbs)
