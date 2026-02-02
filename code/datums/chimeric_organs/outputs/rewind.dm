/datum/chimeric_node/output/rewinding
	name = "rewinding"
	desc = "When activated teleports you back to the last place you were hit."

	var/turf/last_hit_turf

/datum/chimeric_node/output/rewinding/register_listeners(mob/living/carbon/target)
	if(!target)
		return

	unregister_listeners()
	registered_signals += COMSIG_ATOM_WAS_ATTACKED

	target.AddElement(/datum/element/relay_attackers)
	RegisterSignal(target, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(on_attacked))

/datum/chimeric_node/output/rewinding/trigger_effect(multiplier)
	. = ..()
	if(!last_hit_turf)
		return
	hosted_carbon.forceMove(last_hit_turf)

/datum/chimeric_node/output/rewinding/proc/on_attacked(datum/source, datum/stress_event/event)
	last_hit_turf = get_turf(hosted_carbon)
