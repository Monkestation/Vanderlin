//used for holding information about unique properties of maps
//feed it json files that match the datum layout
//defaults to box
//  -Cyberboss

/datum/map_config
	// Metadata
	/// Full path to map load json
	var/config_filename = "_maps/vanderlin.json"
	/// If TRUE map config was either not loaded or loaded unsuccessfully via LoadConfig()
	var/defaulted = TRUE
	// Config from maps.txt
	var/config_max_users = 0
	var/config_min_users = 0
	var/voteweight = 1
	var/votable = FALSE

	// Config actually from the JSON - should default to Vanderlin
	var/map_name = "Vanderlin"
	var/map_path = "map_files/vanderlin"
	var/map_file = "vanderlin.dmm"

	var/immigrant_origin = "Kingsfield"
	var/monarch_title = "King"
	var/monarch_title_f = "Queen"

	var/traits = null
	var/space_ruin_levels = 7
	var/space_empty_levels = 1

	/// List of unit tests that are skipped when running this map
	var/list/skipped_tests

	var/custom_area_sound = null
	var/list/other_z
	var/delve = 0

/**
 * Proc that simply loads the default map config, which should always be functional.
 */
/proc/load_default_map_config()
	return new /datum/map_config

/**
 * Proc handling the loading of map configs. Will return the default map config using [/proc/load_default_map_config] if the loading of said file fails for any reason whatsoever, so we always have a working map for the server to run.
 * Arguments:
 * * filename - Name of the config file for the map we want to load. The .json file extension is added during the proc, so do not specify filenames with the extension.
 * * directory - Name of the directory containing our .json - Must be in MAP_DIRECTORY_WHITELIST. We default this to MAP_DIRECTORY_MAPS as it will likely be the most common usecase. If no filename is set, we ignore this.
 * * error_if_missing - Bool that says whether failing to load the config for the map will be logged in log_world or not as it's passed to LoadConfig().
 *
 * Returns the config for the map to load.
 */
/proc/load_map_config(filename = null, directory = null, error_if_missing = TRUE)
	var/datum/map_config/config = load_default_map_config()

	if(filename) // If none is specified, then go to look for next_map.json, for map rotation purposes.
		if(directory)
			if(!(directory in MAP_DIRECTORY_WHITELIST))
				log_world("map directory not in whitelist: [directory] for map [filename]")
				return config
		else
			directory = MAP_DIRECTORY_MAPS

		filename = "[directory]/[filename].json"
	else
		filename = PATH_TO_NEXT_MAP_JSON

	if(!config.LoadConfig(filename, error_if_missing))
		qdel(config)
		return load_default_map_config()

	return config

#define CHECK_EXISTS(X) if(!istext(json[X])) { log_world("[##X] missing from json!"); return; }

/datum/map_config/proc/LoadConfig(filename, error_if_missing)
	if(!fexists(filename))
		if(error_if_missing)
			log_world("map_config not found: [filename]")
		return

	var/json = file(filename)
	if(!json)
		log_world("Could not open map_config: [filename]")
		return

	json = file2text(json)
	if(!json)
		log_world("map_config is not text: [filename]")
		return

	json = json_decode(json)
	if(!json)
		log_world("map_config is not json: [filename]")
		return

	config_filename = filename

	CHECK_EXISTS("map_name")
	map_name = json["map_name"]
	CHECK_EXISTS("map_path")
	map_path = json["map_path"]
	// Per-map flavour:
	immigrant_origin = json["immigrant_origin"]
	monarch_title = json["monarch_title"]
	monarch_title_f = json["monarch_title_f"]

	map_file = json["map_file"]
	if (istext(map_file))
		if (!fexists("_maps/[map_path]/[map_file]"))
			log_world("Map file ([map_path]/[map_file]) does not exist!")
			return

	// "map_file": ["Lower.dmm", "Upper.dmm"]
	else if (islist(map_file))
		for (var/file in map_file)
			if (!fexists("_maps/[map_path]/[file]"))
				log_world("Map file ([map_path]/[file]) does not exist!")
				return
	else
		log_world("map_file missing from json!")
		return

	traits = json["traits"]
	// "traits": [{"Linkage": "Cross"}, {"Space Ruins": true}]
	if (islist(traits))
		// "Station" is set by default, but it's assumed if you're setting
		// traits you want to customize which level is cross-linked
		for (var/level in traits)
			if (!(ZTRAIT_STATION in level))
				level[ZTRAIT_STATION] = TRUE
	// "traits": null or absent -> default
	else if (!isnull(traits))
		log_world("map_config traits is not a list!")
		return

	var/temp = json["space_ruin_levels"]
	if (isnum(temp))
		space_ruin_levels = temp
	else if (!isnull(temp))
		log_world("map_config space_ruin_levels is not a number!")
		return

	temp = json["space_empty_levels"]
	if (isnum(temp))
		space_empty_levels = temp
	else if (!isnull(temp))
		log_world("map_config space_empty_levels is not a number!")
		return

	var/soundTemp = json["custom_area_sound"]
	if (istext(soundTemp))
		if(!findtextEx(soundTemp, new /regex("\\.ogg$"))) //makes sure this is an ogg file
			log_world("map_config [soundTemp] is not a valid .ogg file!")
			return
		var/soundFile = file(soundTemp)
		if(!soundFile)
			log_world("map_config custom_area_sound not found at [soundTemp]!")
			return
		custom_area_sound = soundFile
	else if (!isnull(soundTemp))
		log_world("map_config custom_area_sound is not a string!")
		return

	var/list/other_z = json["other_z"]
	var/list/final_z
	for(var/map_path in other_z)
		var/map_file = file(map_path)
		if(!map_file)
			stack_trace("tried to load another z-level that didn't exist")
			continue
		if(map_path in final_z)
			stack_trace("tried to add two of the same z-level")
			continue
		LAZYOR(final_z, map_path)

	delve = json["delve"]

#ifdef UNIT_TESTS
	// Check for unit tests to skip, no reason to check these if we're not running tests
	for(var/path_as_text in json["ignored_unit_tests"])
		var/path_real = text2path(path_as_text)
		if(!ispath(path_real, /datum/unit_test))
			stack_trace("Invalid path in mapping config for ignored unit tests: \[[path_as_text]\]")
			continue
		LAZYADD(skipped_tests, path_real)
#endif

	src.other_z = final_z
	defaulted = FALSE
	return TRUE
#undef CHECK_EXISTS

/datum/map_config/proc/GetFullMapPaths()
	if (istext(map_file))
		return list("_maps/[map_path]/[map_file]")
	. = list()
	for (var/file in map_file)
		. += "_maps/[map_path]/[file]"

/datum/map_config/proc/MakeNextMap()
	return config_filename == PATH_TO_NEXT_MAP_JSON || fcopy(config_filename, PATH_TO_NEXT_MAP_JSON)

/// Checks config parameters to see if this map can be voted for. Returns TRUE or FALSE accordingly.
/datum/map_config/proc/available_for_vote()
	if(!votable)
		return FALSE

	var/player_count = length(GLOB.clients)

	if(config_min_users && player_count < config_min_users)
		return FALSE

	if(config_max_users && player_count > config_max_users)
		return FALSE

	return TRUE
