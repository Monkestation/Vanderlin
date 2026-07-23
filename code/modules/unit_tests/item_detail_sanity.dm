/// Test that every item with detail tags has a default colour and icon
/datum/unit_test/item_detail_sanity

/datum/unit_test/item_detail_sanity/Run()
	var/list/bad_colours = list()
	var/list/bad_icons = list()
	for(var/obj/item/thing as anything in subtypesof(/obj/item))
		thing = allocate(thing)
		if(!thing.get_detail_tag())
			continue
		if(!thing.get_detail_color())
			bad_colours += thing.type
		if(!icon_exists(thing.icon, "[thing.icon_state][thing.get_detail_tag()]"))
			bad_icons += thing.type

	if(length(bad_colours))
		TEST_FAIL("Items types with detail_tag lacking detail_color:\n[bad_colours.Join("\n")]")

	if(length(bad_icons))
		TEST_FAIL("Items types with detail_tag lacking valid icon state:\n[bad_icons.Join("\n")]")

