SUBSYSTEM_DEF(assets)
	name = "Assets"
	lazy_load = FALSE
	init_order = INIT_ORDER_ASSETS
	flags = SS_NO_FIRE
	var/list/datum/asset_cache_item/cache = list()
	var/list/preload = list()
	var/datum/asset_transport/transport = new()

/datum/controller/subsystem/assets/OnConfigLoad()
	var/newtransporttype = /datum/asset_transport
	switch (CONFIG_GET(string/asset_transport))
		if ("webroot")
			newtransporttype = /datum/asset_transport/webroot

	if (newtransporttype == transport.type)
		return

	var/datum/asset_transport/newtransport = new newtransporttype ()
	if (newtransport.validate_config())
		transport = newtransport
	transport.Load()

/datum/controller/subsystem/assets/Initialize(timeofday)
	for(var/datum/asset/asset as anything in typesof(/datum/asset))
		if(!IS_ABSTRACT(asset))
			load_asset_datum(asset)

	transport.Initialize(cache)
	return ..()
