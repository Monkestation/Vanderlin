/datum/biome/swamp
	name = "Swamp"
	id = BIOME_SWAMP

	flora_density_base = 0.8
	tree = 25
	wild_crop = 12
	understory_chance = 35


	temp_preference = 0.65
	temp_tolerance = 0.25
	temp_falloff = 0.3

	trees = list(
		/obj/structure/flora/tree
	)

/datum/biome/swamp/calculate_height(elevation, x, y)
	// Swamp-specific seed
	var/elevation_noise = dot_point_noise(x * 0.01, y * 0.01, 3001) * 0.15
	var/modified_elevation = elevation + elevation_noise

	if(modified_elevation > 0.75)
		return 1
	else
		return 0

/datum/biome/swamp/apply_height_noise(height, elevation, x, y)
	var/height_noise = dot_point_noise(x * 0.02, y * 0.02, 3002)

	if(height_noise > 0.6 && elevation > 0.5)
		height = 1
	else if(height_noise < -0.4 && height > 0)
		height = 0

	return height

/datum/biome/swamp/calculate_suitability_score(temp, moisture, elevation)
	var/score = 0.4  // Above forests because it has harsh requirements
	// Warm temperature preference: 0.4 to 0.9
	if(temp >= 0.4 && temp <= 0.9)
		score += 0.45
	else
		score -= abs(temp - 0.65) * 0.3
	// High moisture requirement: 0.4 to 1.0
	if(moisture >= 0.4)  // Reasonable threshold
		score += moisture * 0.6  // Good bonus for moisture
	else
		score -= (0.4 - moisture) * 0.5
	// Preference for low elevations
	if(elevation <= 0.25)  // Reasonable low elevation
		score += (0.25 - elevation) * 0.8
	else if(elevation <= 0.4)
		score += 0.15
	else if(elevation <= 0.6)
		score -= (elevation - 0.4) * 0.4
	else
		score -= (elevation - 0.4) * 1.5
	return max(0, score)

/datum/biome/swamp/generate_ground_terrain(turf/T, temp, moisture, elevation, x, y)
	var/water_noise1 = dot_point_noise(x * 0.005, y * 0.005, 5002)
	var/water_noise2 = dot_point_noise(x * 0.02, y * 0.02, 5003)

	var/water_threshold = 0.0

	// Low elevation greatly increases water chance
	if(elevation < 0.15)
		water_threshold -= 0.5
	else if(elevation < 0.25)
		water_threshold -= 0.3
	else if(elevation < 0.35)
		water_threshold -= 0.1

	// High moisture increases water chance
	if(moisture > 0.6)
		water_threshold -= 0.3
	else if(moisture > 0.45)
		water_threshold -= 0.15

	var/water_value = (water_noise1 * 0.7) + (water_noise2 * 0.3)

	if(water_value < water_threshold)
		// Deep water in the wettest areas
		if(water_value < (water_threshold - 0.3) && elevation < 0.1)
			T.ChangeTurf(/turf/open/water/marsh/deep, flags = CHANGETURF_SKIP)
		else
			T.ChangeTurf(/turf/open/water/marsh, flags = CHANGETURF_SKIP)
	else
		// Varied swamp terrain
		var/terrain_val = elevation + (water_noise2 * 0.2)

		if(terrain_val > 0.4)
			T.ChangeTurf(/turf/open/floor/grass/red, flags = CHANGETURF_SKIP)
		else if(terrain_val > 0.3)
			T.ChangeTurf(/turf/open/floor/grass/mixyel, flags = CHANGETURF_SKIP)
		else if(terrain_val > 0.2)
			T.ChangeTurf(/turf/open/floor/grass/yel, flags = CHANGETURF_SKIP)
		else if(moisture > 0.5)
			T.ChangeTurf(/turf/open/floor/dirt/road, flags = CHANGETURF_SKIP)
		else
			T.ChangeTurf(/turf/open/floor/dirt, flags = CHANGETURF_SKIP)

/datum/biome/swamp/generate_elevated_terrain(turf/T, temp, moisture, elevation, relative_height, x, y)
	var/terrain_noise = simple_noise(x * 0.005, y * 0.005, 10000 + relative_height * 100)

	if(terrain_noise > 0.3)
		T.ChangeTurf(/turf/open/floor/grass/mixyel, flags = CHANGETURF_SKIP)
	else
		T.ChangeTurf(/turf/open/floor/dirt, flags = CHANGETURF_SKIP)

/datum/biome/swamp/generate_structural_terrain(turf/T, elevation, relative_height, x, y)
	T.ChangeTurf(/turf/closed/mineral, flags = CHANGETURF_SKIP)

/datum/biome/swamp/select_wild_crops(temp, moisture, elevation)
	var/list/available_crops = list()

	// Swamp specialists
	available_crops += /obj/structure/wild_plant/nospread/swampweed
	available_crops += /obj/structure/wild_plant/nospread/manabloom
	available_crops += /obj/structure/wild_plant/nospread/westleach

	// Wet-tolerant crops
	available_crops += /obj/structure/wild_plant/nospread/turnip
	available_crops += /obj/structure/wild_plant/nospread/potato
	available_crops += /obj/structure/wild_plant/nospread/cabbage

	// Warm swamps
	if(temp > 0.6)
		available_crops += /obj/structure/wild_plant/nospread/sugarcane

	// Swamp edge plants
	if(prob(20))
		available_crops += /obj/structure/wild_plant/nospread/fyritiusflower
		available_crops += /obj/structure/wild_plant/nospread/jacksberry

	return pick(available_crops)

/datum/biome/swamp/select_herbs(temp, moisture, elevation)
	var/list/available_herbs = list()

	// Wetland specialists
	available_herbs += /obj/structure/flora/grass/herb/mentha
	available_herbs += /obj/structure/flora/grass/herb/valeriana
	available_herbs += /obj/structure/flora/grass/herb/symphitum
	available_herbs += /obj/structure/flora/grass/herb/euphrasia

	// Warm swamp plants
	if(temp > 0.5)
		available_herbs += /obj/structure/flora/grass/herb/calendula
		available_herbs += /obj/structure/flora/grass/herb/euphorbia

	// Special swamp herb
	available_herbs += /obj/structure/wild_plant/manabloom

	return pick(available_herbs)
