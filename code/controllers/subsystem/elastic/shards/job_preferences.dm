/datum/elastic_shard/job_preferences
	name = "Job Preferences"
	upload_frequency = 60 SECONDS
	shard_category = ELASCAT_JOB_PREFERENCES

/datum/elastic_shard/job_preferences/get_endpoint()
	return CONFIG_GET(string/job_endpoint)

/datum/elastic_shard/job_preferences/get_compiled_data(datum/controller/subsystem/elastic/SS)
	if(!length(assoc_list_data))
		return null
	var/list/compiled = list()
	compiled["@timestamp"] = time_stamp_metric()
	compiled["shard"] = shard_category
	compiled["round_id"] = GLOB.rogue_round_id
	compiled["elapsed_real_time"] = (REALTIMEOFDAY - SS.world_init_time)
	compiled["job_preferences"] = assoc_list_data // already keyed by job title
	return json_encode(compiled)

/proc/record_job_preferences_full(job_title, high_count, medium_count, low_count, never_count, banned_count, young_count)
	var/datum/elastic_shard/job_preferences/S = SSelastic.get_shard(ELASCAT_JOB_PREFERENCES)
	if(!S)
		return
	S.assoc_list_data[job_title] = list(
		"pref_high"   = high_count,
		"pref_medium" = medium_count,
		"pref_low"    = low_count,
		"pref_never"  = never_count,
		"pref_banned" = banned_count,
		"pref_young"  = young_count,
	)
