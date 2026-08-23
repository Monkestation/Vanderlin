/datum/unit_test/item_melting_material_crucible_insertion

/datum/unit_test/item_melting_material_crucible_insertion/Run()
	var/obj/item/storage/crucible/test_crucible = allocate(/obj/item/storage/crucible)

	for(var/obj/item/item_type as anything in typesof(/obj/item))
		if(IS_ABSTRACT(item_type))
			continue
		if(!initial(item_type.melting_material))
			continue

		var/obj/item/test_item = allocate(item_type)
		if(HAS_TRAIT(test_item, TRAIT_NODROP))
			continue

		var/inserted = SEND_SIGNAL(test_crucible, COMSIG_TRY_STORAGE_INSERT, test_item, null, TRUE, FALSE)
		if(!inserted)
			TEST_FAIL("[item_type] with melting_material [initial(item_type.melting_material)] failed to insert into crucible")
			qdel(test_item)
			continue

		if(!(test_item in test_crucible.contents))
			TEST_FAIL("[item_type] was not found in crucible contents after insertion")
			qdel(test_item)
			continue

		var/turf/drop_loc = get_turf(test_crucible)
		SEND_SIGNAL(test_crucible, COMSIG_TRY_STORAGE_TAKE, test_item, drop_loc, TRUE)

		if(test_item in test_crucible.contents)
			TEST_FAIL("[item_type] was still in crucible contents after removal")
			qdel(test_item)
