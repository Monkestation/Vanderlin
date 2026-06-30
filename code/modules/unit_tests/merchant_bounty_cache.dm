/datum/unit_test/merchant_bounty_cache_sellable_items/Run()
	TEST_ASSERT(SSmerchant, "SSmerchant was not initialized.")
	TEST_ASSERT(length(SSmerchant.valid_bounty_items), "No bounty items were initialized.")

	var/list/invalid_bounty_items = list()
	for(var/obj_type in SSmerchant.valid_bounty_items)
		var/obj/item/item_template = obj_type
		if(!item_template || item_template.sellprice <= 0)
			invalid_bounty_items += "[obj_type]"

	TEST_ASSERT(!length(invalid_bounty_items), "Bounty cache includes items without a positive sell price: [invalid_bounty_items.Join(\", \")]")
