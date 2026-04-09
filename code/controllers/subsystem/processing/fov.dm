/// This subsystem handles the object permanence feature of FoV
SUBSYSTEM_DEF(field_of_vision)
	name = "Field of Vision"
	init_order = INIT_ORDER_XKEYSCORE
	flags = SS_NO_INIT|SS_BACKGROUND
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 2 SECONDS
	var/list/datum/component/field_of_vision/processing = list()

/datum/controller/subsystem/field_of_vision/fire(resumed)
	for(var/datum/component/field_of_vision/fov_component as anything in processing)
		fov_component.object_permanence_update()
		// this really isn't essential
		if(MC_TICK_CHECK)
			return
