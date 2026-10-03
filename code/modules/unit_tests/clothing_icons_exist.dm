/datum/unit_test/clothing_icons_exist/Run()
	for(var/obj/item/clothing/thing as anything in subtypesof(/obj/item/clothing))
		if(IS_ABSTRACT(thing))
			continue
		thing = allocate(thing)
		if(thing.mob_overlay_icon && !icon_exists(thing.mob_overlay_icon, thing.icon_state))
			TEST_FAIL("[thing.type] missing mob overlay icon [thing.icon_state] in [thing.mob_overlay_icon]")
