/// Check if smelting material matches input ingot for items
/datum/unit_test/smithing_materials/Run()
	for(var/datum/anvil_recipe/recipe as anything in subtypesof(/datum/anvil_recipe))
		var/obj/item/ingot/bar_type = recipe::required_material
		if(!ispath(bar_type))
			continue
		var/obj/item/created_item = recipe::created_item
		var/datum/material/item_material = created_item::melting_material
		if(!item_material)
			// This is because some things like spears don't give anything back intentionally
			continue
		var/datum/material/bar_material = bar_type::melting_material
		if(!ispath(item_material, bar_material))
			TEST_FAIL("[created_item] melting material [item_material] does not match input ingot material [bar_material].")
		// var/obj/item/ingot/smelt_result = created_item::smeltresult
		// if(!ispath(smelt_result))
		// 	continue
		// if(!ispath(smelt_result, bar_type))
		// 	TEST_FAIL("[created_item] melting ingot [smelt_result] does not match input ingot [bar_type].")
