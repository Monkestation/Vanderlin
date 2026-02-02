/datum/chimeric_node/input/spell_cast
	name = "mage tuned"
	desc = "Triggers when you cast a spell."

/datum/chimeric_node/input/spell_cast/register_triggers(mob/living/carbon/target)
	if(!target)
		return

	unregister_triggers()
	registered_signals += COMSIG_MOB_CAST_SPELL
	RegisterSignal(target, COMSIG_MOB_CAST_SPELL, PROC_REF(on_cast))

/datum/chimeric_node/input/spell_cast/proc/on_cast(datum/source)
	SIGNAL_HANDLER

	var/potency = node_purity / 100
	trigger_output(potency)
