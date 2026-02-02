/datum/follower_command/guard_position
	command_name = "Guard Position"
	var/turf/guard_location
	var/datum/component/bounded/bound_component

/datum/follower_command/guard_position/execute(mob/living/carbon/human/automaton, mob/living/issuer)
	guard_location = get_turf(automaton)
	if(!guard_location || !automaton)
		return

	bound_component = automaton.AddComponent(/datum/component/bounded, \
		guard_location, \
		0, \
		3, \
		null, \
		null, \
		FALSE, \
		FALSE)

	automaton.say("EXECUTING: Guarding position.", forced = TRUE)

/datum/follower_command/guard_position/terminate(mob/living/carbon/human/automaton)
	if(bound_component)
		QDEL_NULL(bound_component)
