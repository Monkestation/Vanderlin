GLOBAL_LIST_INIT(contributors, load_contributors())
GLOBAL_LIST_EMPTY(donator_data_by_key)
GLOBAL_LIST_EMPTY(donator_data_by_ckey)

/proc/load_contributors()
	var/contribs = file("data/contributors.json")
	if(!fexists(contribs))
		return list()
	return json_decode(file2text(contribs))

/datum/patreon_data
	/// The details of the linked player.
	var/client/owner
	///the stored patreon client key for the information
	var/client_key
	///the stored patreon rank collected from the server
	var/owned_rank = NO_RANK
	///access rank in numbers
	var/access_rank = ACCESS_NONE_RANK


/datum/patreon_data/New(client/owner)
	. = ..()
	if(!owner)
		return
	src.owner = owner
	if(!SSdbcore.IsConnected())
		owned_rank = NUKIE_RANK ///this is a testing variable
		return

	fetch_key_and_rank()
	assign_access_rank()
	add_to_global_list()

/datum/patreon_data/proc/add_to_global_list()
	GLOB.donator_data_by_key[owner.key] = access_rank
	GLOB.donator_data_by_ckey[owner.ckey] = access_rank

/datum/patreon_data/proc/fetch_key_and_rank()
	if(!SSdbcore.IsConnectedCross())
		SSdbcore.Connect_Cross()

	var/datum/DBQuery/query_get_key = SSdbcore.NewQuery("SELECT patreon_key, patreon_rank FROM [format_table_name("player")] WHERE ckey = :ckey", list("ckey" = owner.ckey), db = TRUE)
	if(query_get_key.warn_execute())
		if(query_get_key.NextRow())
			client_key = query_get_key.item[1]
			owned_rank = query_get_key.item[2]
			if(owned_rank == "UNSUBBED2")
				owned_rank = NO_RANK
	qdel(query_get_key)

/datum/patreon_data/proc/assign_access_rank()
	switch(owned_rank)
		if(THANKS_RANK)
			access_rank =  ACCESS_THANKS_RANK
		if(ASSISTANT_RANK)
			access_rank =  ACCESS_ASSISTANT_RANK
		if(COMMAND_RANK)
			access_rank =  ACCESS_COMMAND_RANK
		if(TRAITOR_RANK)
			access_rank =  ACCESS_TRAITOR_RANK
		if(NUKIE_RANK, OLD_NUKIE_RANK, REALLY_ANOTHER_FUCKING_NUKIE_RANK)
			access_rank =  ACCESS_NUKIE_RANK

/datum/patreon_data/proc/has_access(rank)
	if(owner.ckey in GLOB.contributors)
		return TRUE
	if(owner.holder || (owner.ckey in GLOB.deadmins))
		return TRUE
	// Only care about access if the above isn't true.
	if(!access_rank)
		assign_access_rank()
	if(rank <= access_rank)
		return TRUE
	return FALSE

/datum/patreon_data/proc/is_donator()
	return owned_rank && owned_rank != NO_RANK && owned_rank != UNSUBBED

/proc/key_is_donator(key)
	if(GLOB.donator_data_by_key[key])
		return TRUE
	return FALSE

/proc/ckey_is_donator(ckey)
	if(GLOB.donator_data_by_ckey[ckey])
		return TRUE
	return FALSE

