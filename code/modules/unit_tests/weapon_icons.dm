/// Simple test to assure all weapons have a valid icon
/datum/unit_test/weapon_icons/Run()
	for(var/obj/item/weapon/checked as anything in subtypesof(/obj/item/weapon))
		if(IS_ABSTRACT(checked))
			continue
		checked = allocate(checked)
		if(checked.icon_state && !icon_exists(checked.icon, checked.icon_state))
			var/icon_file = "[checked.icon]" || "Unknown Generated Icon"
			TEST_FAIL("Invalid icon_state: Icon object '[icon_file]' [REF(checked.icon)] used in '[checked]' [checked.type] is missing icon state [checked.icon_state].")
