/datum/chimeric_node/output/stressor
	name = "remembering"
	desc = "When activated triggers the last stress event you've had"

	var/datum/stress_event/last_event

/datum/chimeric_node/output/stressor/register_listeners(mob/living/carbon/target)
	if(!target)
		return

	unregister_listeners()
	registered_signals += COMSIG_MOB_ADD_STRESS
	RegisterSignal(target, COMSIG_MOB_ADD_STRESS, PROC_REF(on_stress_add))

/datum/chimeric_node/output/stressor/trigger_effect(multiplier)
	. = ..()
	hosted_carbon.add_stress(last_event)

/datum/chimeric_node/output/stressor/proc/on_stress_add(datum/source, datum/stress_event/event)
	last_event = event.type
