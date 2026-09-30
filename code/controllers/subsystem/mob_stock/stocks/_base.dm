/// Finds the map_mob_stock subtype whose map_name matches the given string.
/// Returns null if none exists.
/proc/get_map_mob_stock(map_name)
	for(var/datum/map_mob_stock/candidate as anything in subtypesof(/datum/map_mob_stock))
		if(initial(candidate.map_name) == map_name)
			return new candidate
	return null

/datum/map_mob_stock
	/// Must match the maps config name (like everything Case-Sensative)
	var/map_name

	/// assoc list: mob typepath -> desired standing population
	var/list/stock = list()

	// --- wave defense config ---
	var/wave_defense_enabled = FALSE
	/// wave_defense landmark set_ids this map can attack. One is picked at
	/// random each wave, so a map can have several independent attack points like Wyrmwoods 4 gates
	var/list/wave_defense_set_ids = list("default")
	///lower and upper bounds for wave mobs
	var/wave_mob_count_low = 3
	var/wave_mob_count_high = 8
	///lower and upper bounds for wave cooldown
	var/wave_time_min = 10 MINUTES
	var/wave_time_max = 20 MINUTES

/// Waves are drawn from the same pool as the standing population, anything
/// in `stock` is fair game to show up in an attack.
/// scalar (0..1) shrinks the wave size for low pop; 1 = full configured size.
/datum/map_mob_stock/proc/pick_wave_mobs(scalar = 1)
	if(!length(stock))
		return list()
	var/count = round(rand(wave_mob_count_low, wave_mob_count_high) * scalar)
	count = max(count, 1)
	var/list/picked = list()
	for(var/i in 1 to count)
		picked += pick(stock)
	return picked

