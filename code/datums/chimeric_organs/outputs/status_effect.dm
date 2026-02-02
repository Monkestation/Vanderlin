/datum/chimeric_node/output/status_effect
	name = "affecting"
	desc = "When activated triggers the last status effect you've had affect you."

	var/datum/status_effect/last_event

/datum/chimeric_node/output/status_effect/register_listeners(mob/living/carbon/target)
	if(!target)
		return

	unregister_listeners()
	registered_signals += COMSIG_MOB_APPLIED_STATUS_EFFECT
	RegisterSignal(target, COMSIG_MOB_APPLIED_STATUS_EFFECT, PROC_REF(on_status_effect_applied))

/datum/chimeric_node/output/status_effect/trigger_effect(multiplier)
	. = ..()
	hosted_carbon.add_stress(last_event)

/datum/chimeric_node/output/status_effect/proc/on_status_effect_applied(datum/source, datum/status_effect/event)
	last_event = event.type
