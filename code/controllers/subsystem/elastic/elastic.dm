SUBSYSTEM_DEF(elastic)
	name = "Elastic Middleware"
	wait = 5 SECONDS
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	flags = SS_KEEP_TIMING
	var/world_init_time = 0
	var/list/active_requests = list()
	var/list/shards = list()
	var/shutting_down = FALSE

/datum/controller/subsystem/elastic/Initialize(start_timeofday)
	if(!CONFIG_GET(flag/elastic_middleware_enabled))
		flags |= SS_NO_FIRE
		return ..()
	register_shards()
	init_abstract_zeros()
	return ..()

/datum/controller/subsystem/elastic/proc/register_shards()
	for(var/datum/elastic_shard/shard as anything in subtypesof(/datum/elastic_shard))
		shards += new shard()

/datum/controller/subsystem/elastic/proc/get_shard(shard_category)
	for(var/datum/elastic_shard/S as anything in shards)
		if(S.shard_category == shard_category)
			return S

/datum/controller/subsystem/elastic/fire(resumed)
	for(var/datum/elastic_shard/S as anything in shards)
		if(S.should_fire())
			S.fire(src)
	// Clean up completed requests
	for(var/datum/http_request/request as anything in active_requests)
		if(request.is_complete())
			active_requests -= request
			qdel(request)

/datum/controller/subsystem/elastic/proc/dispatch_request(datum/elastic_shard/shard, json_body)
    if(shutting_down)
        return
    var/endpoint = shard.get_endpoint()
    if(!endpoint)
        return
    var/datum/http_request/request = new()
    request.prepare(RUSTG_HTTP_METHOD_POST, endpoint, json_body, list(
        "Authorization" = "ApiKey [CONFIG_GET(string/metrics_api_token)]",
        "Content-Type" = "application/json"
    ))
    request.begin_async()
    active_requests += request
