SUBSYSTEM_DEF(minor_mapping)
	name = "Minor Mapping"
	init_order = INIT_ORDER_MINOR_MAPPING
	flags = SS_NO_FIRE

/datum/controller/subsystem/minor_mapping/Initialize(timeofday)
	//Minor mapping comes quite late in the init list so it should be safe to add here. We want this long after everything else is done
	SSmapping.load_marks()

	return ..()
