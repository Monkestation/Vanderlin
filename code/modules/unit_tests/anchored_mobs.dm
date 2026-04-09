/datum/unit_test/anchored_mobs/Run()
	var/list/L = list()
	for(var/mob/M as anything in typesof(/mob))
		if(initial(M.anchored))
			L += "[M]"
	if(!length(L))
		return			//passed!
	TEST_FAIL("The following mobs are defined as anchored. This is incompatible with the new move force/resist system and needs to be revised.: [L.Join(" ")]")
