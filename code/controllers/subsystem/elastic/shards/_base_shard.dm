/datum/elastic_shard
	/// Display name for debugging
	var/name = "Generic Shard"
	/// How often this shard fires, in real seconds
	var/upload_frequency = 30 SECONDS
	/// Elasticsearch index/category this shard posts to (can be a different endpoint suffix)
	var/shard_category = ELASCAT_GENERIC
	/// Tracks the last REALTIMEOFDAY this shard fired
	var/last_fired = 0
	/// Accumulated assoc data for this shard
	var/list/assoc_list_data = list()
	/// Abstract (cumulative numeric) data, keyed by ELASDATA_ defines
	var/list/abstract_information = list()
	///should we keep things dated? (send on loop if its being triggered once)
	var/should_keep_dated = FALSE

/datum/elastic_shard/proc/should_fire()
	return (REALTIMEOFDAY - last_fired) >= upload_frequency

/datum/elastic_shard/proc/get_endpoint()
	return CONFIG_GET(string/elastic_endpoint)

/datum/elastic_shard/proc/fire(datum/controller/subsystem/elastic/SS)
	last_fired = REALTIMEOFDAY
	var/compiled = get_compiled_data(SS)
	if(!compiled)
		return
	SS.dispatch_request(src, compiled)
	reset()

/datum/elastic_shard/proc/get_compiled_data(datum/controller/subsystem/elastic/SS)
	if(!length(assoc_list_data) && (should_keep_dated && !length(abstract_information)))
		return null
	var/list/compiled = list()
	compiled["@timestamp"] = time_stamp_metric()
	compiled["shard"] = shard_category
	compiled["round_id"] = GLOB.rogue_round_id
	compiled["elapsed_real_time"] = (REALTIMEOFDAY - SS.world_init_time)
	compiled |= assoc_list_data
	return json_encode(compiled)

/datum/elastic_shard/proc/reset()
	assoc_list_data = list()
	// Note: abstract_information is NOT reset - it's cumulative

/datum/elastic_shard/proc/add_list_data(list/assoc_data)
	assoc_list_data |= assoc_data

/datum/elastic_shard/proc/add_abstract_data(abstract_name, abstract_value, maximum)
	if(!isnum(abstract_value))
		return
	abstract_information |= abstract_name
	abstract_information[abstract_name] += abstract_value
	if(maximum)
		abstract_information[abstract_name] = min(maximum, abstract_information[abstract_name])
	// Mirror into assoc so it gets compiled
	assoc_list_data["[abstract_name]"] = abstract_information[abstract_name]
