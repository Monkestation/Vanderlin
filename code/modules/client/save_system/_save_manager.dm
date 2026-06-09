/datum/save_manager
	var/ckey
	var/base_path
	var/list/save_files = list() // List of save file datums
	var/auto_save = TRUE
	var/save_interval = 300 // 5 minutes in deciseconds
	var/last_save_time = 0

/datum/save_manager/New(target_ckey)
	if(!target_ckey)
		qdel(src)
		return
	ckey = ckey(target_ckey)
	initialize_base_path()
	if(auto_save)
		start_auto_save()

/datum/save_manager/Destroy()
	for(var/save_name in save_files)
		var/datum/save_file/SF = save_files[save_name]
		if(SF)
			SF.save_to_file()
			qdel(SF)
	save_files.Cut()
	return ..()

/datum/save_manager/proc/initialize_base_path()
	if(!ckey)
		return FALSE

	var/ckey_prefix = copytext(ckey, 1, 2)
	base_path = "data/player_saves/[ckey_prefix]/[ckey]/persistent_data"

	return TRUE

/datum/save_manager/proc/get_save_file(save_name, auto_create = TRUE)
	if(!save_name)
		return null

	save_name = lowertext(save_name)

	if(save_name in save_files)
		return save_files[save_name]

	if(!auto_create)
		return null

	var/datum/save_file/SF = new /datum/save_file(src, save_name)
	if(SF)
		save_files[save_name] = SF
		return SF

	return null

/datum/save_manager/proc/set_data(save_name, key, value)
	var/datum/save_file/SF = get_save_file(save_name)
	if(SF)
		return SF.set_data(key, value)
	return FALSE

/datum/save_manager/proc/get_data(save_name, key, default_value = null)
	var/datum/save_file/SF = get_save_file(save_name)
	if(SF)
		return SF.get_data(key, default_value)
	return default_value

/datum/save_manager/proc/has_data(save_name, key)
	var/datum/save_file/SF = get_save_file(save_name, FALSE)
	if(SF)
		return SF.has_data(key)
	return FALSE

/datum/save_manager/proc/remove_data(save_name, key)
	var/datum/save_file/SF = get_save_file(save_name, FALSE)
	if(SF)
		return SF.remove_data(key)
	return FALSE

/datum/save_manager/proc/increment_data(save_name, key, amount = 1, default_value = 0)
	var/datum/save_file/SF = get_save_file(save_name)
	if(SF)
		return SF.increment_data(key, amount, default_value)
	return default_value

/datum/save_manager/proc/add_to_list(save_name, key, value, max_size = 0)
	var/datum/save_file/SF = get_save_file(save_name)
	if(SF)
		return SF.add_to_list(key, value, max_size)
	return list()

/datum/save_manager/proc/remove_from_list(save_name, key, value)
	var/datum/save_file/SF = get_save_file(save_name, FALSE)
	if(SF)
		return SF.remove_from_list(key, value)
	return FALSE

/datum/save_manager/proc/get_all_data(save_name)
	var/datum/save_file/SF = get_save_file(save_name, FALSE)
	if(SF)
		return SF.get_all_data()
	return list()

/datum/save_manager/proc/clear_all_data(save_name)
	var/datum/save_file/SF = get_save_file(save_name, FALSE)
	if(SF)
		return SF.clear_all_data()
	return FALSE

/datum/save_manager/proc/delete_save_file(save_name)
	var/datum/save_file/SF = save_files[save_name]
	if(SF)
		SF.delete_file()
		qdel(SF)
		save_files -= save_name
		return TRUE
	return FALSE

/datum/save_manager/proc/get_save_file_info(save_name)
	var/datum/save_file/SF = get_save_file(save_name, FALSE)
	if(SF)
		return SF.get_file_info()
	return null

/datum/save_manager/proc/list_save_files()
	return save_files.Copy()

/datum/save_manager/proc/force_save_all()
	var/success = TRUE
	for(var/save_name in save_files)
		var/datum/save_file/SF = save_files[save_name]
		if(SF && !SF.save_to_file())
			success = FALSE
	return success

/datum/save_manager/proc/start_auto_save()
	if(!auto_save)
		return

	spawn()
		while(src && auto_save)
			sleep(save_interval)
			if(world.time > last_save_time + save_interval)
				force_save_all()
				last_save_time = world.time

// Individual save file datum
/datum/save_file
	var/datum/save_manager/parent_manager
	var/save_name
	var/file_path
	var/save_data = list()
	var/save_version = 1
	var/dirty = FALSE // Tracks if data has been modified

/datum/save_file/New(datum/save_manager/manager, name)
	if(!manager || !name)
		qdel(src)
		return

	parent_manager = manager
	save_name = lowertext(name)
	file_path = "[manager.base_path]/[save_name].sav"

	load_from_file()

/datum/save_file/Destroy()
	if(dirty)
		save_to_file()
	parent_manager = null
	return ..()

/datum/save_file/proc/load_from_file()
	if(!file_path)
		return FALSE

	if(!fexists(file_path))
		// Create default save data structure
		save_data = list(
			"version" = save_version,
			"created" = world.realtime,
			"last_accessed" = world.realtime,
			"data" = list()
		)
		save_to_file()
		return TRUE

	var/savefile/S = new /savefile(file_path)
	if(!S)
		return FALSE

	S.cd = "/"

	// Load save data
	var/loaded_data
	S["save_data"] >> loaded_data

	if(!islist(loaded_data))
		// Corrupted save, create new
		save_data = list(
			"version" = save_version,
			"created" = world.realtime,
			"last_accessed" = world.realtime,
			"data" = list()
		)
		return FALSE

	save_data = loaded_data
	save_data["last_accessed"] = world.realtime

	// Handle version updates if needed
	if(save_data["version"] < save_version)
		update_save_version()

	return TRUE

/datum/save_file/proc/save_to_file()
	if(!file_path || !save_data)
		return FALSE
	var/savefile/S = new /savefile(file_path)
	if(!S)
		return FALSE

	S.cd = "/"
	save_data["last_saved"] = world.realtime
	S["save_data"] << save_data
	dirty = FALSE

	return TRUE

/datum/save_file/proc/set_data(key, value)
	if(!save_data || !key)
		return FALSE

	if(!save_data["data"])
		save_data["data"] = list()

	save_data["data"][key] = value
	dirty = TRUE

	if(parent_manager && parent_manager.auto_save)
		save_to_file()

	return TRUE

/datum/save_file/proc/get_data(key, default_value = null)
	if(!save_data || !key)
		return default_value

	if(!save_data["data"] || !save_data["data"][key])
		return default_value

	return save_data["data"][key]

/datum/save_file/proc/has_data(key)
	if(!save_data || !key)
		return FALSE

	if(!save_data["data"])
		return FALSE

	return (key in save_data["data"])

/datum/save_file/proc/remove_data(key)
	if(!save_data || !key)
		return FALSE

	if(!save_data["data"])
		return FALSE

	if(key in save_data["data"])
		save_data["data"] -= key
		dirty = TRUE

		if(parent_manager && parent_manager.auto_save)
			save_to_file()

		return TRUE

	return FALSE

/datum/save_file/proc/get_all_data()
	if(!save_data || !save_data["data"])
		return list()

	var/list/data = save_data["data"]
	return data.Copy()

/datum/save_file/proc/clear_all_data()
	if(!save_data)
		return FALSE

	save_data["data"] = list()
	dirty = TRUE

	if(parent_manager && parent_manager.auto_save)
		save_to_file()

	return TRUE

/datum/save_file/proc/increment_data(key, amount = 1, default_value = 0)
	var/current_value = get_data(key, default_value)

	if(!isnum(current_value))
		current_value = default_value

	set_data(key, current_value + amount)
	return get_data(key)

/datum/save_file/proc/add_to_list(key, value, max_size = 0)
	var/list/current_list = get_data(key, list())

	if(!islist(current_list))
		current_list = list()

	current_list += value

	// Trim list if max_size is specified
	if(max_size > 0 && length(current_list) > max_size)
		current_list = current_list.Copy((length(current_list) - max_size + 1), 0)

	set_data(key, current_list)
	return current_list

/datum/save_file/proc/remove_from_list(key, value)
	var/current_list = get_data(key, list())

	if(!islist(current_list))
		return FALSE

	if(value in current_list)
		current_list -= value
		set_data(key, current_list)
		return TRUE

	return FALSE

/datum/save_file/proc/update_save_version()
	// Handle version updates here for specific save files
	save_data["version"] = save_version
	save_to_file()

/datum/save_file/proc/delete_file()
	if(file_path && fexists(file_path))
		fdel(file_path)
		return TRUE
	return FALSE

/datum/save_file/proc/get_file_info()
	if(!save_data)
		return null

	return list(
		"save_name" = save_name,
		"file_path" = file_path,
		"version" = save_data["version"],
		"created" = save_data["created"],
		"last_accessed" = save_data["last_accessed"],
		"last_saved" = save_data["last_saved"],
		"data_keys" = length(save_data["data"]),
		"dirty" = dirty
	)

// Global save manager system
GLOBAL_LIST_EMPTY(player_save_managers)

/proc/get_save_manager(ckey)
	if(!ckey)
		return null

	ckey = ckey(ckey)

	if(ckey in GLOB.player_save_managers)
		return GLOB.player_save_managers[ckey]

	var/datum/save_manager/SM = new /datum/save_manager(ckey)
	if(SM)
		GLOB.player_save_managers[ckey] = SM
		return SM

	return null

/proc/cleanup_save_managers()
	for(var/ckey in GLOB.player_save_managers)
		var/datum/save_manager/SM = GLOB.player_save_managers[ckey]
		if(SM)
			qdel(SM)

	GLOB.player_save_managers = list()

// Convenience procs for common save file types
/proc/get_player_coins(ckey)
	var/datum/save_manager/SM = get_save_manager(ckey)
	if(SM)
		return SM.get_data("economy", "coins", 0)
	return 0

/proc/set_player_coins(ckey, amount)
	var/datum/save_manager/SM = get_save_manager(ckey)
	if(SM)
		return SM.set_data("economy", "coins", amount)
	return FALSE

/proc/add_player_coins(ckey, amount)
	var/datum/save_manager/SM = get_save_manager(ckey)
	if(SM)
		return SM.increment_data("economy", "coins", amount, 0)
	return 0
