/datum/elastic_shard/economy
	name = "Economy"
	upload_frequency = 4 MINUTES
	shard_category = ELASCAT_ECONOMY

/datum/elastic_shard/economy/get_endpoint()
	return CONFIG_GET(string/economy_endpoint)
