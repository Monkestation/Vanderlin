#define FILE_ANTAG_REP "data/AntagReputation.json"

SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE
	flags = SS_NO_FIRE

	var/list/saved_messages = list()
	var/list/saved_modes = list(1,2,3)
	var/list/saved_trophies = list()
	var/list/antag_rep = list()
	var/list/antag_rep_change = list()
	var/list/picture_logging_information = list()

/datum/controller/subsystem/persistence/Initialize()
	LoadRecentModes()
	if(CONFIG_GET(flag/use_antag_rep))
		LoadAntagReputation()
	LoadRandomizedRecipes()
	return ..()

/datum/controller/subsystem/persistence/proc/LoadRecentModes()
	var/json_file = file("data/RecentModes.json")
	if(!fexists(json_file))
		return
	var/list/json = json_decode(file2text(json_file))
	if(!json)
		return
	saved_modes = json["data"]

/datum/controller/subsystem/persistence/proc/LoadAntagReputation()
	var/json = file2text(FILE_ANTAG_REP)
	if(!json)
		var/json_file = file(FILE_ANTAG_REP)
		if(!fexists(json_file))
			WARNING("Failed to load antag reputation. File likely corrupt.")
			return
		return
	antag_rep = json_decode(json)

/datum/controller/subsystem/persistence/proc/CollectData()
	CollectRoundtype()				//THIS IS PERSISTENCE, NOT THE LOGGING PORTION.
	if(CONFIG_GET(flag/use_antag_rep))
		CollectAntagReputation()
	SaveRandomizedRecipes()

/datum/controller/subsystem/persistence/proc/GetPhotoAlbums()
	var/album_path = file("data/old/photo_albums.json")
	if(fexists(album_path))
		return json_decode(file2text(album_path))

/datum/controller/subsystem/persistence/proc/GetPhotoFrames()
	var/frame_path = file("data/old/photo_frames.json")
	if(fexists(frame_path))
		return json_decode(file2text(frame_path))

/datum/controller/subsystem/persistence/proc/remove_duplicate_trophies(list/trophies)
	var/list/ukeys = list()
	. = list()
	for(var/trophy in trophies)
		var/tkey = "[trophy["path"]]-[trophy["message"]]"
		if(ukeys[tkey])
			continue
		else
			. += list(trophy)
			ukeys[tkey] = TRUE

/datum/controller/subsystem/persistence/proc/CollectRoundtype()
	saved_modes[3] = saved_modes[2]
	saved_modes[2] = saved_modes[1]
	saved_modes[1] = "storyteller"
	var/json_file = file("data/RecentModes.json")
	var/list/file_data = list()
	file_data["data"] = saved_modes
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

/datum/controller/subsystem/persistence/proc/CollectAntagReputation()
	var/ANTAG_REP_MAXIMUM = CONFIG_GET(number/antag_rep_maximum)

	for(var/p_ckey in antag_rep_change)
//		var/start = antag_rep[p_ckey]
		antag_rep[p_ckey] = max(0, min(antag_rep[p_ckey]+antag_rep_change[p_ckey], ANTAG_REP_MAXIMUM))

//		WARNING("AR_DEBUG: [p_ckey]: Committed [antag_rep_change[p_ckey]] reputation, going from [start] to [antag_rep[p_ckey]]")

	antag_rep_change = list()

	fdel(FILE_ANTAG_REP)
	text2file(json_encode(antag_rep), FILE_ANTAG_REP)


/datum/controller/subsystem/persistence/proc/LoadRandomizedRecipes()
	var/json_file = file("data/old/RandomizedChemRecipes.json")
	var/json
	if(fexists(json_file))
		json = json_decode(file2text(json_file))

	for(var/randomized_type in subtypesof(/datum/chemical_reaction/randomized))
		var/datum/chemical_reaction/randomized/R = new randomized_type
		var/loaded = FALSE
		if(R.persistent && json)
			var/list/recipe_data = json[R.id]
			if(recipe_data)
				if(R.LoadOldRecipe(recipe_data) && (daysSince(R.created) <= R.persistence_period))
					loaded = TRUE
		if(!loaded) //We do not have information for whatever reason, just generate new one
			R.GenerateRecipe()

		if(!R.HasConflicts()) //Might want to try again if conflicts happened in the future.
			add_chemical_reaction(R)

/datum/controller/subsystem/persistence/proc/SaveRandomizedRecipes()
	var/json_file = file("data/old/RandomizedChemRecipes.json")
	var/list/file_data = list()

	//asert globchems done
	for(var/datum/chemical_reaction/randomized/R as anything in subtypesof(/datum/chemical_reaction/randomized))
		R = get_chemical_reaction(initial(R.id)) //ew, would be nice to add some simple tracking
		if(R && R.persistent && R.id)
			var/recipe_data = list()
			recipe_data["timestamp"] = R.created
			recipe_data["required_reagents"] = R.required_reagents
			recipe_data["required_catalysts"] = R.required_catalysts
			recipe_data["required_temp"] = R.required_temp
			recipe_data["is_cold_recipe"] = R.is_cold_recipe
			recipe_data["results"] = R.results
			recipe_data["required_container"] = "[R.required_container]"
			file_data["[R.id]"] = recipe_data

	fdel(json_file)
	WRITE_FILE(json_file, json_encode(file_data))

#undef FILE_ANTAG_REP
