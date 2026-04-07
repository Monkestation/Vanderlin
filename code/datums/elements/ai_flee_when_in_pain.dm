/**
 * Attached to a mob with an AI controller, simply sets a flag on whether or not to run away based on current health values.
 */
/datum/element/ai_flee_while_in_pain

/datum/element/ai_flee_while_in_pain/Attach(datum/target)
	. = ..()
	if(!ishuman(target))
		return ELEMENT_INCOMPATIBLE
	var/mob/living/living_target = target
	if(!living_target.ai_controller)
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(on_health_changed))

/datum/element/ai_flee_while_in_pain/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, COMSIG_LIVING_HEALTH_UPDATE)

/// When the mob's health changes, check what the blackboard state should be
/datum/element/ai_flee_while_in_pain/proc/on_health_changed(mob/living/carbon/human/source)
	SIGNAL_HANDLER

	if (!source.ai_controller)
		return

	var/paine = source.get_complex_pain()
	if (source.ai_controller.blackboard[BB_BASIC_MOB_FLEEING])
		if(paine > ((GET_MOB_ATTRIBUTE_VALUE(source, STAT_ENDURANCE) * 10)*0.9))
			return
		source.ai_controller.CancelActions() // Stop fleeing go back to whatever you were doing
		source.ai_controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, FALSE)
		return

	if(BB_BASIC_MOB_NEXT_FLEEING in source.ai_controller.blackboard)
		if(source.ai_controller.blackboard[BB_BASIC_MOB_NEXT_FLEEING] > world.time)
			return

	if(paine <= ((GET_MOB_ATTRIBUTE_VALUE(source, STAT_ENDURANCE) * 10)*0.9))
		return
	source?.ai_controller.CancelActions()
	source.ai_controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, TRUE)
	source.ai_controller.set_blackboard_key(BB_BASIC_MOB_NEXT_FLEEING, world.time + 60 SECONDS)

	///we don't want ai's to run forever this makes us run for 10 seconds then fight until
	addtimer(CALLBACK(src, PROC_REF(cancel_flee), source), 10 SECONDS, flags = TIMER_UNIQUE)

/datum/element/ai_flee_while_in_pain/proc/cancel_flee(mob/living/source)
	source?.ai_controller?.set_blackboard_key(BB_BASIC_MOB_FLEEING, FALSE)
