/datum/elastic_shard/quests
	name = "Quests"
	upload_frequency = 5 MINUTES
	shard_category = ELASCAT_QUESTS

/datum/elastic_shard/quests/get_endpoint()
	return CONFIG_GET(string/quest_endpoint)

/datum/elastic_shard/quests_finished
	name = "Finished Quests"
	upload_frequency = 5 MINUTES
	shard_category = ELASCAT_QUESTS_FINISHED

/datum/elastic_shard/quests_finished/get_endpoint()
	return CONFIG_GET(string/quest_finished_endpoint)
