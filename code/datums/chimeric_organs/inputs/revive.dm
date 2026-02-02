/datum/chimeric_node/input/revival
	name = "phoenix"
	desc = "Triggered when you are revived."

/datum/chimeric_node/input/revival/register_triggers(mob/living/carbon/target)
	if(!target)
		return

	unregister_triggers()
	registered_signals += COMSIG_LIVING_REVIVE
	RegisterSignal(target, COMSIG_LIVING_REVIVE, PROC_REF(on_revival))

/datum/chimeric_node/input/revival/proc/on_revival(datum/source)
	SIGNAL_HANDLER

	var/potency = node_purity / 100
	trigger_output(potency * 5)
