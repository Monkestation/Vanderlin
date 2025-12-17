/datum/chimeric_node/input/damage
	name = "responsive"
	desc = "Triggers when you take any damage."

	weight = 1

	var/list/damage_types = list(BRUTE, BURN, TOX, OXY) // Which damage types trigger this
	var/minimum_damage = 1 // Minimum damage to trigger

/datum/chimeric_node/input/damage/register_triggers(mob/living/carbon/target)
	if(!target)
		return

	unregister_triggers()
	registered_signals += COMSIG_LIVING_ADJUSTED
	RegisterSignal(target, COMSIG_LIVING_ADJUSTED, PROC_REF(on_damage_taken))

/datum/chimeric_node/input/damage/set_ranges()
	. = ..()
	minimum_damage = rand(max(1, minimum_damage - (3 + ((100 - node_purity) * 0.2))), minimum_damage + (3 + ((100 - node_purity) * 0.2)))

/datum/chimeric_node/input/damage/proc/on_damage_taken(datum/source, damage_amount, damage_type)
	SIGNAL_HANDLER

	if(damage_amount < minimum_damage)
		return

	// Check if this damage type should trigger
	if(!damage_types.len || (damage_type in damage_types))
		var/potency = calculate_potency(damage_type, damage_amount)
		trigger_output(potency)

/datum/chimeric_node/input/damage/proc/calculate_potency(damage_type, amount)
	return (amount / minimum_damage) * (node_purity / 100)

/datum/chimeric_node/input/damage/brute
	name = "brute response"
	desc = "Triggers when you take any brute damage."

	weight = 10

	damage_types = list(BRUTE)
	minimum_damage = 5

/datum/chimeric_node/input/damage/burn
	name = "burn response"
	desc = "Triggers when you take any burn damage."

	weight = 10

	damage_types = list(BURN)
	minimum_damage = 5
