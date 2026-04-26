/datum/component/minion_tracker
	var/list/tracked_minions = list()

/datum/component/minion_tracker/Initialize()
	. = ..()
	if(!istype(parent, /mob/living))
		return COMPONENT_INCOMPATIBLE

/datum/component/minion_tracker/proc/register_minion(mob/living/minion)
	if(QDELETED(minion) || (minion in tracked_minions))
		return
	tracked_minions += minion
	RegisterSignal(minion, COMSIG_LIVING_DEATH, PROC_REF(on_minion_death))
	RegisterSignal(minion, COMSIG_QDELETING, PROC_REF(on_minion_delete))

/datum/component/minion_tracker/proc/on_minion_death(mob/living/minion)
	SIGNAL_HANDLER
	unregister_minion(minion)

/datum/component/minion_tracker/proc/on_minion_delete(mob/living/minion)
	SIGNAL_HANDLER
	unregister_minion(minion)

/datum/component/minion_tracker/proc/unregister_minion(mob/living/minion)
	tracked_minions -= minion
	UnregisterSignal(minion, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING))
	var/mob/living/F = parent
	if(F?.ai_controller)
		var/current_count = F.ai_controller.blackboard[BB_MINION_COUNT]
		F.ai_controller.set_blackboard_key(BB_MINION_COUNT, max(0, current_count - 1))
