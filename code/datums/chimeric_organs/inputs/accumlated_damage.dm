/datum/chimeric_node/input/accumlated_damage
	name = "responsive"
	desc = "Triggers when you have a combined amount of damage."

	weight = 2

	var/minimum_damage = 150

/datum/chimeric_node/input/accumlated_damage/register_triggers(mob/living/carbon/target)
	if(!target)
		return

	unregister_triggers()
	registered_signals += COMSIG_LIVING_ADJUSTED
	RegisterSignal(target, COMSIG_LIVING_ADJUSTED, PROC_REF(on_damage_taken))


/datum/chimeric_node/input/accumlated_damage/proc/on_damage_taken(datum/source, damage_type, damage_amount)
	SIGNAL_HANDLER

	var/total_damage = hosted_carbon.getBruteLoss() + hosted_carbon.getFireLoss()
	if(total_damage < minimum_damage)
		return

	trigger_output(2 * tier * (node_purity * 0.01))

