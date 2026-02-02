/datum/stress_event
	/// Description shown to the player
	var/desc
	/// Integer value for stress change
	var/stress_change = 0
	/// How long should this last
	var/timer = 0
	/// Stacks of this event
	var/stacks = 0
	/// Max stacks of this event
	var/max_stacks = 1
	/// Amount of stress each extra stack adds
	var/stress_change_per_extra_stack = 0
	/// If this event is always hidden from checks
	var/hidden = FALSE
	///this is how much we affect quality in the end
	var/quality_modifier = 0

/datum/stress_event/proc/can_apply(mob/living/user)
	return TRUE

/datum/stress_event/proc/on_apply(mob/living/user)
	return TRUE

/datum/stress_event/proc/on_remove(mob/living/user)
	return TRUE

/datum/stress_event/proc/can_show(mob/living/user)
	return !hidden

/datum/stress_event/proc/get_desc(mob/living/user)
	return desc

/datum/stress_event/proc/get_stress(mob/living/user)
	return stress_change + ((stacks - 1) * stress_change_per_extra_stack)
