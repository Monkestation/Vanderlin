/datum/elastic_shard/crafting
	name = "Crafting"
	upload_frequency = 5 MINUTES
	shard_category = ELASCAT_CRAFTING

/datum/elastic_shard/crafting/get_endpoint()
	return CONFIG_GET(string/crafting_endpoint)
