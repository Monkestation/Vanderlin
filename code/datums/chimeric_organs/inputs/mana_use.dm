/datum/chimeric_node/input/mana_spent
	name = "fey tuned"
	desc = "Triggered when you spend a certain amount of mana."

	var/mana_required = 100
	var/current_mana = 0

/datum/chimeric_node/input/mana_spent/set_ranges()
	. = ..()
	mana_required = 60 + (100 - node_purity)

/datum/chimeric_node/input/mana_spent/register_triggers(mob/living/carbon/target)
	if(!target)
		return

	unregister_triggers()
	registered_signals += COMSIG_MANA_POOL_ADJUSTED
	RegisterSignal(target, COMSIG_MANA_POOL_ADJUSTED, PROC_REF(on_adjust))

/datum/chimeric_node/input/mana_spent/proc/on_adjust(datum/source, amount_adjusted)
	SIGNAL_HANDLER

	if(amount_adjusted > 0)
		return

	current_mana += -amount_adjusted

	if(current_mana >= mana_required)
		current_mana -= mana_required
		var/potency = node_purity / 100
		trigger_output(potency)
