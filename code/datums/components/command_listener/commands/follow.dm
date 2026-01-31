/datum/follower_command/follow
	command_name = "Follow Target"
	var/atom/target
	var/datum/component/bounded/bound_component

/datum/follower_command/follow/execute(mob/living/carbon/human/automaton, mob/living/issuer)
	target = issuer
	if(!target || !automaton)
		return

	bound_component = automaton.AddComponent(/datum/component/bounded, \
		target, \
		0, \
		2, \
		null, \
		CALLBACK(src, PROC_REF(on_target_destroyed)), \
		FALSE, \
		FALSE)

	automaton.say("EXECUTING: Following [target]", forced = TRUE)

/datum/follower_command/follow/terminate(mob/living/carbon/human/automaton)
	if(bound_component)
		QDEL_NULL(bound_component)

/datum/follower_command/follow/proc/on_target_destroyed()
	if(component)
		component.clear_command()
