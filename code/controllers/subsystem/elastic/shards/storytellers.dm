/datum/elastic_shard/storytellers
	name = "Storytellers"
	upload_frequency = 5 MINUTES
	shard_category = ELASCAT_STORYTELLER

/datum/elastic_shard/storytellers/get_endpoint()
	return CONFIG_GET(string/storyteller_endpoint)
