/datum/elastic_shard/heartbeat
	name = "Heartbeat"
	upload_frequency = 30 SECONDS
	shard_category = ELASCAT_HEARTBEAT

/datum/elastic_shard/heartbeat/get_compiled_data(datum/controller/subsystem/elastic/SS)
	var/list/compiled = list()
	compiled["@timestamp"] = time_stamp_metric()
	compiled["shard"] = shard_category
	compiled["round_id"] = GLOB.rogue_round_id
	compiled["cpu"] = world.cpu
	compiled["elapsed_process_time"] = world.time
	compiled["elapsed_real_time"] = (REALTIMEOFDAY - SS.world_init_time)
	compiled["client_count"] = length(GLOB.clients)
	compiled |= assoc_list_data
	return json_encode(compiled)

/datum/elastic_shard/heartbeat/get_endpoint()
	return CONFIG_GET(string/heartbeat_endpoint)
