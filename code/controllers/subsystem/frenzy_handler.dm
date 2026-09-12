SUBSYSTEM_DEF(frenzy_handler)
	name = "Frenzy Handler"
	flags = SS_POST_FIRE_TIMING|SS_NO_INIT|SS_BACKGROUND
	priority = FIRE_PRIORITY_NPC
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()

/datum/controller/subsystem/frenzy_handler/stat_entry(msg)
	msg = "Frenzy:[length(GLOB.frenzy_list)]"
	return ..()

/datum/controller/subsystem/frenzy_handler/fire(resumed = FALSE)

	if(!resumed)
		var/list/activelist = GLOB.frenzy_list
		src.currentrun = activelist.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(length(currentrun))
		var/mob/living/carbon/H = currentrun[length(currentrun)]
		currentrun.len--

		if (QDELETED(H)) // Some issue causes nulls to get into this list some times. This keeps it running, but the bug is still there.
			GLOB.frenzy_list -= H
			log_world("Found a null in frenzy list!")
			continue

		if(HAS_TRAIT(H, TRAIT_IN_FRENZY))
			H.handle_automated_frenzy()
		else
			GLOB.frenzy_list -= H

		if (MC_TICK_CHECK)
			return
