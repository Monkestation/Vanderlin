/datum/elastic_shard/enchanting
	name = "Enchantments"
	upload_frequency = 5 MINUTES
	shard_category = ELASCAT_ENCHANTING

/datum/elastic_shard/enchanting/get_endpoint()
	return CONFIG_GET(string/enchanting_endpoint)
