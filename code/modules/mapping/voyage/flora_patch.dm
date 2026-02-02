/obj/effect/flora_patch_spawner
	var/list/blacklisted_turfs
	var/patch_size = 3 // Radius of the patch
	var/spawn_chance = 60 // Chance to spawn flora at each valid tile

/obj/effect/flora_patch_spawner/Initialize(mapload, _temperature, _moisture, datum/island_biome/_biome)
	. = ..()
	generate_patch(_temperature, _moisture, _biome)
	return INITIALIZE_HINT_QDEL

/obj/effect/flora_patch_spawner/proc/generate_patch(_temperature, _moisture, datum/island_biome/_biome)
	if(!_biome)
		return

	var/turf/center = get_turf(src)
	if(!center)
		return

	// Initialize blacklisted_turfs if not set
	if(!blacklisted_turfs)
		blacklisted_turfs = list()

	// Generate flora in a radius around the spawner
	for(var/turf/T in range(patch_size, center))
		// Skip if turf is blacklisted
		if(is_type_in_list(T, blacklisted_turfs))
			continue

		// Skip if turf already has flora or trees
		if(has_flora_or_tree(T))
			continue

		// Skip beach turfs if defined in biome
		if(_biome.beach_turf && istype(T, _biome.beach_turf))
			continue

		// Roll for spawn chance
		if(!prob(spawn_chance))
			continue

		// Select and spawn flora based on biome
		var/flora_type = _biome.select_patch_flora(_temperature, _moisture, 0)
		if(ispath(flora_type, /obj/structure/flora/newtree) || ispath(flora_type, /obj/effect/flora_patch_spawner))
			continue

		if(flora_type)
			new flora_type(T)

/obj/effect/flora_patch_spawner/proc/has_flora_or_tree(turf/T)
	// Check if the turf already contains flora or tree structures
	for(var/obj/structure/flora/F in T)
		return TRUE
	for(var/obj/structure/wild_plant/W in T)
		return TRUE
	return FALSE

/obj/effect/flora_patch_spawner/plains
	blacklisted_turfs = list(/turf/open/floor/sand, /turf/open/water)
	patch_size = 2
	spawn_chance = 40
