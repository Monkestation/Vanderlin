/datum/unit_test/species_whitelist_check/Run()
	for(var/datum/species/S as anything in subtypesof(/datum/species))
		if(initial(S.changesource_flags) == NONE)
			TEST_FAIL("A species type was detected with no changesource flags: [S]")
