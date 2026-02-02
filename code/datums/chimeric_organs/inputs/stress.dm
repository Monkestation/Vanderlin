/datum/chimeric_node/input/stress
	name = "stressed"
	desc = "Triggered when you are stressed."
	var/stress_needed = 1

/datum/chimeric_node/input/stress/register_triggers(mob/living/carbon/target)
	if(!target)
		return

	unregister_triggers()
	registered_signals += COMSIG_MOB_ADD_STRESS
	RegisterSignal(target, COMSIG_MOB_ADD_STRESS, PROC_REF(on_stress_add))

/datum/chimeric_node/input/stress/proc/on_stress_add(datum/source, datum/stress_event/event)
	SIGNAL_HANDLER
	if(stress_needed > 0)
		if(stress_needed > event.get_stress())
			return FALSE
	else
		if(stress_needed < event.get_stress())
			return FALSE
	var/potency = node_purity / 100
	trigger_output(potency)

/datum/chimeric_node/input/stress/joy
	name = "blissed"
	desc = "Triggered when you are relieved."
	stress_needed = -1
