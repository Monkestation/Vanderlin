// Base input datum - all inputs inherit from this
/datum/chimeric_node/input
	abstract_type = /datum/chimeric_node/input
	var/datum/chimeric_node/output/attached_output
	var/list/registered_signals = list()
	COOLDOWN_DECLARE(trigger_cooldown)

/datum/chimeric_node/input/Destroy()
	unregister_triggers()
	attached_output = null
	attached_organ = null
	hosted_carbon = null
	. = ..()

/datum/chimeric_node/input/proc/register_triggers(mob/living/carbon/target)
	return

/datum/chimeric_node/input/proc/unregister_triggers()
	if(!hosted_carbon || !registered_signals.len)
		return

	for(var/signal in registered_signals)
		UnregisterSignal(hosted_carbon, signal)

	registered_signals.Cut()

/datum/chimeric_node/input/proc/trigger_output(potency)
	if(!attached_output)
		return FALSE

	if(HAS_TRAIT(attached_organ, "delayed"))
		if(!COOLDOWN_FINISHED(src, trigger_cooldown))
			return FALSE
		addtimer(CALLBACK(src, PROC_REF(delayed_trigger), potency), 2 SECONDS)
		return TRUE

	if(node_purity < 100) //!think on this idk if I want a cooldown or just chain in a SS
		if(!COOLDOWN_FINISHED(src, trigger_cooldown))
			return FALSE
		var/cooldown_value = round(10 - (node_purity * 0.1), 0.1) SECONDS
		COOLDOWN_START(src, trigger_cooldown, cooldown_value)


	attached_output.trigger_effect(TRUE, potency)
	SEND_SIGNAL(attached_organ, COMSIG_CHIMERIC_ORGAN_TRIGGER, src, potency)
	return TRUE

/datum/chimeric_node/input/proc/delayed_trigger(potency, natural = TRUE)
	if(!attached_output)
		return FALSE

	if(node_purity < 100)
		var/cooldown_value = round(10 - (node_purity * 0.1), 0.1) SECONDS
		COOLDOWN_START(src, trigger_cooldown, cooldown_value)


	attached_output.trigger_effect(TRUE, potency)
	if(natural)
		SEND_SIGNAL(attached_organ, COMSIG_CHIMERIC_ORGAN_TRIGGER, src, potency)
	return TRUE
