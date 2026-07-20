/datum/unit_test/subsystem_init/Run()
	for(var/datum/controller/subsystem/ss as anything in Master.subsystems)
		if(ss.flags & SS_NO_INIT)
			continue
		if(!ss.initialized)
			TEST_FAIL("[ss]([ss.type]) is a subsystem meant to initialize but doesn't get set as initialized.")
