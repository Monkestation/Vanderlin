/datum/chimeric_node/input/wounded
	name = "wounded"
	desc = "Triggered when you receive a wound."

/datum/chimeric_node/input/wounded/register_triggers(mob/living/carbon/target)
	if(!target)
		return

	unregister_triggers()
	registered_signals += COMSIG_LIVING_WOUND_GAINED
	RegisterSignal(target, COMSIG_LIVING_WOUND_GAINED, PROC_REF(on_wound_gain))

/datum/chimeric_node/input/wounded/proc/on_wound_gain(datum/source, bleed_rate)
	SIGNAL_HANDLER
	trigger_output(tier * node_purity * 0.01)
