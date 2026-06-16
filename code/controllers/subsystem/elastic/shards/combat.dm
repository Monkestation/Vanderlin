/datum/elastic_shard/combat
	name = "Combat"
	upload_frequency = 2 MINUTES
	shard_category = ELASCAT_COMBAT

/datum/elastic_shard/combat/get_endpoint()
	return CONFIG_GET(string/combat_endpoint)
