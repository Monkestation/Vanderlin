/datum/elastic_shard/round_data
	name = "Round Data"
	upload_frequency = 5 MINUTES
	shard_category = ELASCAT_ROUND

/datum/elastic_shard/round_data/get_compiled_data(datum/controller/subsystem/elastic/SS)
	var/list/compiled = list()
	compiled["@timestamp"] = time_stamp_metric()
	compiled["shard"] = shard_category
	compiled["round_id"] = GLOB.rogue_round_id
	for(var/patron_name in GLOB.patron_follower_counts)
		compiled["[patron_name]_followers"] = GLOB.patron_follower_counts[patron_name]
	for(var/stat in GLOB.vanderlin_round_stats)
		compiled[stat] = GLOB.vanderlin_round_stats[stat]
	compiled |= assoc_list_data
	return json_encode(compiled)

/datum/elastic_shard/round_data/get_endpoint()
	return CONFIG_GET(string/round_endpoint)
