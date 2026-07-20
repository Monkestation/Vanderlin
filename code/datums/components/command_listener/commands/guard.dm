/datum/follower_command/guard_position
	command_name = "Guard Position"
	var/turf/guard_location
	var/datum/component/bounded/bound_component

/datum/follower_command/guard_position/post_setup(mob/living/carbon/human/automaton, mob/living/issuer)
	if(!issuer.say("Guard Position."))
		return FALSE
	if(!(automaton in get_hearers_in_view(DEFAULT_MESSAGE_RANGE, issuer)))
		return FALSE
	return TRUE

/datum/follower_command/guard_position/execute(mob/living/carbon/human/automaton, mob/living/issuer)
	guard_location = get_turf(automaton)
	if(!guard_location || !automaton)
		return

	bound_component = automaton.AddComponent(/datum/component/bounded, \
		guard_location, \
		0, \
		5, \
		null, \
		null, \
		FALSE, \
		FALSE)

	playsound(automaton, 'sound/vo/automaton/executingorders.ogg', 70)
	automaton.say("EXECUTING: Guarding position.", forced = TRUE)

/datum/follower_command/guard_position/terminate(mob/living/carbon/human/automaton)
	if(bound_component)
		QDEL_NULL(bound_component)
