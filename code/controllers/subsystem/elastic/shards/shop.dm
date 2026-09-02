/datum/elastic_shard/shop
	name = "Shop"
	upload_frequency = 5 MINUTES
	shard_category = ELASCAT_SHOP

/datum/elastic_shard/shop/get_endpoint()
	return CONFIG_GET(string/shop_endpoint)
