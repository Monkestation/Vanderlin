/datum/chimeric_node/input/bleeding
	name = "wound weeping"
	desc = "Triggered when your bleeding rate goes up."

	var/last_bleed_rate = 0

/datum/chimeric_node/input/bleeding/register_triggers(mob/living/carbon/target)
	if(!target)
		return

	unregister_triggers()
	registered_signals += COMSIG_CARBON_ON_HANDLE_BLOOD
	RegisterSignal(target, COMSIG_CARBON_ON_HANDLE_BLOOD, PROC_REF(on_bleed_rate))

/datum/chimeric_node/input/bleeding/proc/on_bleed_rate(datum/source, bleed_rate)
	SIGNAL_HANDLER

	if(last_bleed_rate >= bleed_rate)
		last_bleed_rate = bleed_rate
		return
	last_bleed_rate = bleed_rate

	trigger_output(tier * node_purity * 0.01)
