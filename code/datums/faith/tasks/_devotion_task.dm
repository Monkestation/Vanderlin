/datum/devotion_task
	var/name = "Divine Task"
	var/desc = "Complete tasks to gain devotion"
	var/devotion_reward = 5
	var/progression_reward = 5
	/// How often this task can be completed (in deciseconds, 0 = unlimited)
	var/cooldown_time = 0
	var/last_completion = 0
	/// Reference to the devotion datum
	var/datum/devotion/parent_devotion
	/// Signal to listen for
	var/signal_type
	/// Whether this task requires the user to be near something specific
	var/requires_proximity = FALSE
	var/proximity_range = 7

/datum/devotion_task/New(datum/devotion/parent)
	. = ..()
	parent_devotion = parent
	if(signal_type && parent_devotion?.holder_mob)
		RegisterSignal(parent_devotion.holder_mob, signal_type, PROC_REF(on_signal_received))

/datum/devotion_task/Destroy()
	if(parent_devotion?.holder_mob)
		UnregisterSignal(parent_devotion.holder_mob, signal_type)
	parent_devotion = null
	return ..()

/datum/devotion_task/proc/can_complete(mob/living/carbon/human/user)
	if(!user || user.stat >= DEAD)
		return FALSE
	if(cooldown_time && world.time < last_completion + cooldown_time)
		return FALSE
	return TRUE

/datum/devotion_task/proc/on_signal_received(datum/source, ...)
	var/mob/living/carbon/human/user = source
	if(!can_complete(user))
		return

	on_complete(user, args)

/datum/devotion_task/proc/on_complete(mob/living/carbon/human/user, list/signal_args)
	if(!can_complete(user))
		return FALSE

	last_completion = world.time
	parent_devotion?.update_devotion(devotion_reward)
	parent_devotion?.update_progression(progression_reward)

	to_chat(user, span_notice("[name] complete! Gained [devotion_reward] devotion."))
	user.playsound_local(user, 'sound/misc/notice (2).ogg', 50, FALSE)
	return TRUE
