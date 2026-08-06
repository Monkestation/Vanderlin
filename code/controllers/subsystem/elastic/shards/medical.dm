/datum/elastic_shard/medical
	name = "Medical"
	upload_frequency = 60 SECONDS
	shard_category = ELASCAT_MEDICAL

/datum/elastic_shard/medical/get_endpoint()
	return CONFIG_GET(string/medical_endpoint)
