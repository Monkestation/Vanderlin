
/datum/twitch_data
	/// The details of the linked player.
	var/client/owner
	///the stored twitch client key for the information
	var/client_key
	///the stored twitch rank collected from the server
	var/owned_rank = NO_TWITCH_SUB
	///access rank in numbers
	var/access_rank = ACCESS_TWITCH_UNSUBBED


/datum/twitch_data/New(client/owner)
	. = ..()
	if(!owner)
		return
	src.owner = owner
	if(!SSdbcore.IsConnected())
		owned_rank = ACCESS_TWITCH_SUB_TIER_3 ///this is a testing variable
		return

	fetch_key_and_rank()
	assign_access_rank()
	add_to_global_list()

/datum/twitch_data/proc/add_to_global_list()
	GLOB.donator_data_by_key[owner.key] += access_rank
	GLOB.donator_data_by_ckey[owner.ckey] += access_rank

/datum/twitch_data/proc/fetch_key_and_rank()
	if(!SSdbcore.IsConnectedCross())
		SSdbcore.Connect_Cross()

	var/datum/DBQuery/query_get_key = SSdbcore.NewQuery("SELECT twitch_user, twitch_rank FROM [format_table_name("player")] WHERE ckey = :ckey", list("ckey" = owner.ckey), db = TRUE)
	if(query_get_key.warn_execute())
		if(query_get_key.NextRow())
			client_key = query_get_key.item[1]
			owned_rank = query_get_key.item[2]
			if(owned_rank == "")
				owned_rank = NO_RANK
	qdel(query_get_key)

/datum/twitch_data/proc/assign_access_rank()
	switch(owned_rank)
		if(TWITCH_SUB_TIER_1)
			access_rank =  ACCESS_TWITCH_SUB_TIER_1
		if(TWITCH_SUB_TIER_2)
			access_rank =  ACCESS_TWITCH_SUB_TIER_2
		if(TWITCH_SUB_TIER_3)
			access_rank =  ACCESS_TWITCH_SUB_TIER_3

/datum/twitch_data/proc/has_access(rank)
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

/datum/twitch_data/proc/is_donator()
	return owned_rank && owned_rank != NO_RANK && owned_rank != UNSUBBED


