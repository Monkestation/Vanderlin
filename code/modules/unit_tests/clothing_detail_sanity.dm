/// Test that every item with detail tags has a default colour
/datum/unit_test/item_detail_sanity

/datum/unit_test/item_detail_sanity/Run()
	var/list/bad_types = list()
	for(var/obj/item/thing as anything in subtypesof(/obj/item))
		if(IS_ABSTRACT(thing))
			continue
		if(!thing.get_detail_tag())
			continue
		if(!thing.get_detail_color())
			bad_types += thing.type

	if(length(bad_types))
		TEST_FAIL("Items types with detail_tag lacking detail_color:\n[bad_types.Join("\n")]")

