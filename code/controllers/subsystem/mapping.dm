SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE
	lazy_load = FALSE

	var/list/nuke_tiles = list()
	var/list/nuke_threats = list()

	var/datum/map_config/config
	var/datum/map_config/next_map_config
	var/datum/map_adjustment/map_adjustment

	var/map_voted = FALSE

	var/list/map_templates = list()
	var/list/map_load_marks = list() //The game scans thru the map and looks for marks, then adds them to this list for caching

	var/list/ruins_templates = list()
	var/datum/space_level/isolated_ruins_z //Created on demand during ruin loading.

	var/list/shelter_templates = list()

	var/list/areas_in_z = list()

	var/list/turf/unused_turfs = list()				//Not actually unused turfs they're unused but reserved for use for whatever requests them. "[zlevel_of_turf]" = list(turfs)
	var/list/datum/turf_reservations		//list of turf reservations
	var/list/used_turfs = list()				//list of turf = datum/turf_reservation

	var/list/reservation_ready = list()
	var/clearing_reserved_turfs = FALSE

	// Z-manager stuff
	var/station_start  // should only be used for maploading-related tasks
	var/space_levels_so_far = 0
	///list of all z level datums in the order of their z (z level 1 is at index 1, etc.)
	var/list/datum/space_level/z_list
	///list of all z level indices that form multiz connections and whether theyre linked up or down
	///list of lists, inner lists are of the form: list("up or down link direction" = TRUE)
	var/list/multiz_levels = list()
	var/datum/space_level/transit
	var/datum/space_level/empty_space
	var/num_of_res_levels = 1
	/// True when in the process of adding a new Z-level, global locking
	var/adding_new_zlevel = FALSE

	///this is a list of all the world_traits we have from things like god interventions
	var/list/active_world_traits = list()
	///antag retainer
	var/datum/antag_retainer/retainer

/datum/controller/subsystem/mapping/PreInit()
#ifdef FORCE_MAP
	config = load_map_config(FORCE_MAP, FORCE_MAP_DIRECTORY)
#else
	config = load_map_config(error_if_missing = FALSE)
#endif

#ifdef FORCE_RANDOM_WORLD_GEN
	config = load_map_config("kalypso")
	log_world("FORCE_RANDOM_WORLD_GEN enabled - loading Kalypso only for random world generation")
#endif

#ifndef FORCE_RANDOM_WORLD_GEN
	// After assigning a config datum to var/config, we check which map adjustment fits the current config
	for(var/datum/map_adjustment/adjust as anything in subtypesof(/datum/map_adjustment))
		if(!adjust.map_file_name)
			continue
		var/map = config.map_file
		if(islist(map))
			var/list/maps = map
			map = maps[1]
		if(!map)
			break
		if(map_adjustment)
			stack_trace("[map] is trying to set map adjustments after they have been set!")
			break
		if(adjust.map_file_name != map)
			continue
		map_adjustment = new adjust()
		log_world("Loaded '[map]' map adjustment.")
		break
#endif
	return ..()

/datum/controller/subsystem/mapping/Initialize(timeofday)
	retainer = new
	if(initialized)
		return
#ifdef FORCE_RANDOM_WORLD_GEN
	// Skip normal initialization and go straight to random world gen
	log_world("Initializing random world generation...")
	initialize_random_world_generation()
	return ..()
#endif

	if(config.defaulted)
		var/old_config = config
		config = global.config.defaultmap
		if(!config || config.defaulted)
			to_chat(world, "<span class='boldannounce'>Unable to load next or default map config, defaulting to Vanderlin</span>")
			config = old_config
	if(map_adjustment)
		map_adjustment.on_mapping_init()
		log_world("Applied '[map_adjustment.map_file_name]' map adjustment: on_mapping_init()")
	loadWorld()
	require_area_resort()
	process_teleport_locs()			//Sets up the wizard teleport locations
	preloadTemplates()
	// Add the transit level
	transit = add_new_zlevel("Transit/Reserved", list(ZTRAIT_RESERVED = TRUE))
	require_area_resort()
	initialize_reserved_level(transit.z_value)
	generate_z_level_linkages()
	return ..()

/datum/controller/subsystem/mapping/proc/generate_z_level_linkages()
	for(var/z_level in 1 to length(z_list))
		generate_linkages_for_z_level(z_level)

/datum/controller/subsystem/mapping/proc/generate_linkages_for_z_level(z_level)
	if(!isnum(z_level) || z_level <= 0)
		return FALSE

	if(multiz_levels.len < z_level)
		multiz_levels.len = z_level

	var/z_above = level_trait(z_level, ZTRAIT_UP)
	var/z_below = level_trait(z_level, ZTRAIT_DOWN)
	if(!(z_above == TRUE || z_above == FALSE || z_above == null) || !(z_below == TRUE || z_below == FALSE || z_below == null))
		stack_trace("Warning, numeric mapping offsets are deprecated. Instead, mark z level connections by setting UP/DOWN to true if the connection is allowed")
	multiz_levels[z_level] = new /list(LARGEST_Z_LEVEL_INDEX)
	multiz_levels[z_level][Z_LEVEL_UP] = !!z_above
	multiz_levels[z_level][Z_LEVEL_DOWN] = !!z_below


/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	initialized = SSmapping.initialized
	map_templates = SSmapping.map_templates
	ruins_templates = SSmapping.ruins_templates
	shelter_templates = SSmapping.shelter_templates
	unused_turfs = SSmapping.unused_turfs
	turf_reservations = SSmapping.turf_reservations
	used_turfs = SSmapping.used_turfs

	config = SSmapping.config
	next_map_config = SSmapping.next_map_config

	clearing_reserved_turfs = SSmapping.clearing_reserved_turfs

	z_list = SSmapping.z_list
	multiz_levels = SSmapping.multiz_levels

#define INIT_ANNOUNCE(X) to_chat(world, span_boldannounce("[X]")); log_world(X)
/datum/controller/subsystem/mapping/proc/LoadGroup(list/errorList, name, path, files, list/traits, list/default_traits, silent = FALSE, delve = 0)
	. = list()
	var/start_time = REALTIMEOFDAY

	if (!islist(files))  // handle single-level maps
		files = list(files)

	// check that the total z count of all maps matches the list of traits
	var/total_z = 0
	var/list/parsed_maps = list()
	for (var/file in files)
		var/full_path = "_maps/[path]/[file]"
		var/datum/parsed_map/pm = new(file(full_path))
		var/bounds = pm?.bounds
		if (!bounds)
			errorList |= full_path
			continue
		parsed_maps[pm] = total_z  // save the start Z of this file
		total_z += bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1

	if (!length(traits))  // null or empty - default
		for (var/i in 1 to total_z)
			traits += list(default_traits)
	else if (total_z != traits.len)  // mismatch
		INIT_ANNOUNCE("WARNING: [traits.len] trait sets specified for [total_z] z-levels in [path]!")
		if (total_z < traits.len)  // ignore extra traits
			traits.Cut(total_z + 1)
		while (total_z > traits.len)  // fall back to defaults on extra levels
			traits += list(default_traits)

	// preload the relevant space_level datums
	var/start_z = world.maxz + 1
	var/i = 0
	for (var/level in traits)
		add_new_zlevel("[name][i ? " [i + 1]" : ""]", level, delve = delve)
		++i

	// load the maps
	for (var/P in parsed_maps)
		var/datum/parsed_map/pm = P
		if (!pm.load(1, 1, start_z + parsed_maps[P], no_changeturf = TRUE, new_z = TRUE))
			errorList |= pm.original_path

	log_game("Loaded [name] in [(REALTIMEOFDAY - start_time)/10]s!")

	return parsed_maps

/datum/controller/subsystem/mapping/proc/loadWorld()
	// If any of these fail, something has gone horribly, HORRIBLY, wrong
	var/list/FailedZs = list()

	// Ensure we have space_level datums for compiled-in maps
	InitializeDefaultZLevels()

	// load the station
	station_start = world.maxz + 1
#ifdef TESTING
	INIT_ANNOUNCE("Loading [config.map_name]...")
#endif
	LoadGroup(FailedZs, config.map_name, config.map_path, config.map_file, config.traits, ZTRAITS_TOWN, delve = config.delve)

	var/list/otherZ = list()
	for(var/map_json in config.other_z)
		otherZ += load_map_config(map_json)

#ifndef NO_DUNGEON
	// Load base dungeon level
	if(config.map_name != "Voyage")
		otherZ += load_map_config("map_files/shared/dungeon")

		// Load additional delve levels if multi-level dungeons are enabled
		if(SSdungeon_generator.multilevel_dungeons)
			for(var/level = 2; level <= SSdungeon_generator.max_delve_levels; level++)
				otherZ += load_map_config("map_files/shared/dungeon_delve[level]")
#endif

	//For all maps

#ifndef LOWMEMORYMODE
	otherZ += load_map_config("map_files/shared/underworld") // don't load underworld on lowmem
#endif

	if(length(otherZ))
		for(var/datum/map_config/OtherZ as anything in otherZ)
			if(OtherZ.defaulted)
				continue
			LoadGroup(FailedZs, OtherZ.map_name, OtherZ.map_path, OtherZ.map_file, OtherZ.traits, ZTRAITS_STATION, delve = OtherZ.delve)

	if(SSdbcore.Connect())
		var/datum/DBQuery/query_round_map_name = SSdbcore.NewQuery({"
			UPDATE [format_table_name("round")] SET map_name = :map_name WHERE id = :round_id
		"}, list("map_name" = config.map_name, "round_id" = GLOB.round_id))
		query_round_map_name.Execute()
		qdel(query_round_map_name)

#ifndef LOWMEMORYMODE
	// TODO: remove this when the DB is prepared for the z-levels getting reordered
	while (world.maxz < (5 - 1) && space_levels_so_far < config.space_ruin_levels)
		++space_levels_so_far
		add_new_zlevel("Empty Area [space_levels_so_far]", ZTRAITS_SPACE)
#endif

	if(LAZYLEN(FailedZs))	//but seriously, unless the server's filesystem is messed up this will never happen
		var/msg = "RED ALERT! The following map files failed to load: [FailedZs[1]]"
		if(length(FailedZs) > 1)
			for(var/I in 2 to FailedZs.len)
				msg += ", [FailedZs[I]]"
		msg += ". Yell at your server host!"
		INIT_ANNOUNCE(msg)

#undef INIT_ANNOUNCE

	// Custom maps are removed after station loading so the map files does not persist for no reason.
	if(config.map_path == CUSTOM_MAP_PATH)
		fdel("_maps/custom/[config.map_file]")
		// And as the file is now removed set the next map to default.
		next_map_config = load_default_map_config()

/datum/controller/subsystem/mapping/proc/maprotate()
	if(map_voted)
		map_voted = FALSE
		return

	var/players = GLOB.clients.len
	var/list/mapvotes = list()
	//count votes
	var/pmv = CONFIG_GET(flag/preference_map_voting)
	if(pmv)
		for (var/client/c in GLOB.clients)
			var/vote = c.prefs.preferred_map
			if (!vote)
				if (global.config.defaultmap)
					mapvotes[global.config.defaultmap.map_name] += 1
				continue
			mapvotes[vote] += 1
	else
		for(var/M in global.config.maplist)
			mapvotes[M] = 1

	//filter votes
	for (var/map in mapvotes)
		if (!map)
			mapvotes.Remove(map)
		if (!(map in global.config.maplist))
			mapvotes.Remove(map)
			continue
		var/datum/map_config/VM = global.config.maplist[map]
		if (!VM)
			mapvotes.Remove(map)
			continue
		if (VM.voteweight <= 0)
			mapvotes.Remove(map)
			continue
		if (VM.config_min_users > 0 && players < VM.config_min_users)
			mapvotes.Remove(map)
			continue
		if (VM.config_max_users > 0 && players > VM.config_max_users)
			mapvotes.Remove(map)
			continue

		if(pmv)
			mapvotes[map] = mapvotes[map]*VM.voteweight

	var/pickedmap = pickweight(mapvotes)
	if (!pickedmap)
		return
	var/datum/map_config/VM = global.config.maplist[pickedmap]
	message_admins("Randomly rotating map to [VM.map_name]")
	. = changemap(VM)
	if (. && VM.map_name != config.map_name)
		to_chat(world, "<span class='boldannounce'>Map rotation has chosen [VM.map_name] for next round!</span>")

/datum/controller/subsystem/mapping/proc/changemap(datum/map_config/VM)
	if(!VM.MakeNextMap())
		next_map_config = load_default_map_config()
		message_admins("Failed to set new map with next_map.json for [VM.map_name]! Using default as backup!")
		return

	next_map_config = VM
	return TRUE

//Precache the templates via map template datums, not directly from files
//This lets us preload as many files as we want without explicitely loading ALL of them into cache (ie WIP maps or what have you)
/datum/controller/subsystem/mapping/proc/preloadTemplates()
	for(var/item in subtypesof(/datum/map_template)) //Look for our template subtypes and fire them up to be used later
		var/datum/map_template/template = new item()
		map_templates[template.id] = template


/datum/controller/subsystem/mapping/proc/RequestBlockReservation(width, height, z, type = /datum/turf_reservation, turf_type_override)
	UNTIL((!z || reservation_ready["[z]"]) && !clearing_reserved_turfs)
	var/datum/turf_reservation/reserve = new type
	if(turf_type_override)
		reserve.turf_type = turf_type_override
	if(!z)
		for(var/i in levels_by_trait(ZTRAIT_RESERVED))
			if(reserve.Reserve(width, height, i))
				return reserve
		//If we didn't return at this point, theres a good chance we ran out of room on the exisiting reserved z levels, so lets try a new one
		num_of_res_levels += 1
		var/datum/space_level/newReserved = add_new_zlevel("Transit/Reserved [num_of_res_levels]", list(ZTRAIT_RESERVED = TRUE))
		initialize_reserved_level(newReserved.z_value)
		if(reserve.Reserve(width, height, newReserved.z_value))
			return reserve
	else
		if(!level_trait(z, ZTRAIT_RESERVED))
			qdel(reserve)
			return
		else
			if(reserve.Reserve(width, height, z))
				return reserve
	QDEL_NULL(reserve)

//This is not for wiping reserved levels, use wipe_reservations() for that.
/datum/controller/subsystem/mapping/proc/initialize_reserved_level(z)
	UNTIL(!clearing_reserved_turfs)				//regardless, lets add a check just in case.
	clearing_reserved_turfs = TRUE			//This operation will likely clear any existing reservations, so lets make sure nothing tries to make one while we're doing it.
	if(!level_trait(z,ZTRAIT_RESERVED))
		clearing_reserved_turfs = FALSE
		CRASH("Invalid z level prepared for reservations.")
	var/turf/A = get_turf(locate(16, 16,z))
	var/turf/B = get_turf(locate(world.maxx - 16,world.maxy - 16,z))
	var/block = block(A, B)
	for(var/t in block)
		// No need to empty() these, because it's world init and they're
		// already /turf/open/space/basic.
		var/turf/T = t
		T.turf_flags |= UNUSED_RESERVATION_TURF
	unused_turfs["[z]"] = block
	reservation_ready["[z]"] = TRUE
	clearing_reserved_turfs = FALSE

/datum/controller/subsystem/mapping/proc/reserve_turfs(list/turfs)
	for(var/turf/T as anything in turfs)
		T.empty(RESERVED_TURF_TYPE, RESERVED_TURF_TYPE, null, TRUE)
		LAZYINITLIST(unused_turfs["[T.z]"])
		unused_turfs["[T.z]"] |= T
		T.turf_flags |= UNUSED_RESERVATION_TURF
		GLOB.areas_by_type[world.area].contents += T
		CHECK_TICK

/datum/controller/subsystem/mapping/proc/reg_in_areas_in_z(list/areas)
	for(var/area/A as anything in areas)
		A.reg_in_areas_in_z()

/datum/controller/subsystem/mapping/proc/get_isolated_ruin_z()
	if(!isolated_ruins_z)
		isolated_ruins_z = add_new_zlevel("Isolated Ruins/Reserved", list(ZTRAIT_RESERVED = TRUE, ZTRAIT_ISOLATED_RUINS = TRUE))
		initialize_reserved_level(isolated_ruins_z.z_value)
	return isolated_ruins_z.z_value


//The initialization of all our marks - this is what gets the ball rolling and self-deletes the marks after the maps are loaded
/datum/controller/subsystem/mapping/proc/load_marks()
	var/list/sites = SSmapping.map_load_marks

	if(!LAZYLEN(sites)) //This should never happen unless the base map failed to load or there are 0 marks on the map
		return

	for(var/M in sites) //Start it up
		var/obj/effect/landmark/map_load_mark/mark = M

		if(!LAZYLEN(mark.templates)) //Somehow our templates are empty
			continue

		var/datum/map_template/template = SSmapping.map_templates[pick(mark.templates)] //Find our actual existing template, it should be pre-loaded
		//Pick() should just randomly pick out of the templates list, or just grab the one there if there is only one
		if(istype(template)) //If our template pick failed, it should just abort and not do anything
			if(template.load(get_turf(mark))) //Fire it up. Should use bottom left corner.  This will take the majority of loading time
				LAZYREMOVE(SSmapping.map_load_marks,mark) //Get rid of the mark from our global list of marks
				qdel(mark) //Delete the mark now that the map is loaded
			else
				//Loading the template failed somehow (template.load returned a FALSE), did you spell the paths right?
				log_world("SSMapping: Failed to load template: [template.name] ([template.mappath])")

/datum/controller/subsystem/mapping/proc/add_world_trait(datum/world_trait/trait_type, duration = 30 MINUTES)
	var/datum/world_trait/new_trait = new trait_type
	active_world_traits |= new_trait

	if(duration > 0)
		addtimer(CALLBACK(src, PROC_REF(remove_world_trait), new_trait), duration)

/datum/controller/subsystem/mapping/proc/remove_world_trait(datum/world_trait/trait_to_remove)
	active_world_traits -= trait_to_remove
	qdel(trait_to_remove)

/datum/controller/subsystem/mapping/proc/find_and_remove_world_trait(datum/world_trait/trait_to_remove)
	for(var/datum/world_trait/trait in active_world_traits)
		if(!istype(trait, trait_to_remove))
			continue
		active_world_traits -= trait
		qdel(trait)
		return TRUE
	return FALSE

/datum/controller/subsystem/mapping/proc/build_area_turfs(z_level, space_guaranteed)
	// If we know this is filled with default tiles, we can use the default area
	// Faster
	if(space_guaranteed)
		var/area/global_area = GLOB.areas_by_type[world.area]
		LISTASSERTLEN(global_area.turfs_by_zlevel, z_level, list())
		global_area.turfs_by_zlevel[z_level] = Z_TURFS(z_level)
		return

	for(var/turf/to_contain as anything in Z_TURFS(z_level))
		var/area/our_area = to_contain.loc
		LISTASSERTLEN(our_area.turfs_by_zlevel, z_level, list())
		our_area.turfs_by_zlevel[z_level] += to_contain

/proc/has_world_trait(datum/world_trait/trait_type)
	if(!length(SSmapping.active_world_traits))
		return FALSE
	for(var/datum/world_trait/trait in SSmapping.active_world_traits)
		if(!istype(trait, trait_type))
			continue
		return TRUE
	return FALSE

/proc/add_tracked_world_trait_atom(atom/incoming, datum/world_trait/trait_type)
	if(!length(SSmapping.active_world_traits))
		return FALSE
	for(var/datum/world_trait/trait in SSmapping.active_world_traits)
		if(!istype(trait, trait_type))
			continue
		trait.add_tracked(incoming)

/proc/remove_tracked_world_trait_atom(atom/removing, datum/world_trait/trait_type)
	if(!length(SSmapping.active_world_traits))
		return FALSE
	for(var/datum/world_trait/trait in SSmapping.active_world_traits)
		if(!istype(trait, trait_type))
			continue
		trait.remove_tracked(removing)

/datum/controller/subsystem/mapping/proc/initialize_random_world_generation()
	// Ensure we have space_level datums for compiled-in maps
	InitializeDefaultZLevels()

	// Load only Kalypso as the base
	station_start = world.maxz + 1

	#ifdef TESTING
	message_admins("Loading Kalypso for random world generation...")
	#endif

	var/list/FailedZs = list()
	LoadGroup(FailedZs, "Kalypso", config.map_path, config.map_file, config.traits, ZTRAITS_TOWN)

	if(LAZYLEN(FailedZs))
		var/msg = "RED ALERT! Failed to load Kalypso for random world generation: [FailedZs[1]]"
		message_admins(msg)
		return

	// Skip loading other z-levels - we only want Kalypso
	log_world("Kalypso loaded successfully for random world generation")

	// Generate the random world content
	generate_random_world()

	// Basic post-load setup
	require_area_resort()
	process_teleport_locs()
	preloadTemplates()

	// Add minimal transit level
	transit = add_new_zlevel("Transit/Reserved", list(ZTRAIT_RESERVED = TRUE))
	require_area_resort()
	initialize_reserved_level(transit.z_value)
	generate_z_level_linkages()


/datum/controller/subsystem/mapping/proc/generate_random_world()
	generate_complete_world()
