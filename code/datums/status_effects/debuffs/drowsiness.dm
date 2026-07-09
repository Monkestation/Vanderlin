/datum/status_effect/drowsiness
	id = "drowsiness"
	tick_interval = 2 SECONDS
	alert_type = null

/datum/status_effect/drowsiness/on_apply()
	. = ..()

	if(HAS_TRAIT(owner, TRAIT_SLEEPIMMUNE) || !(owner.status_flags & CANUNCONSCIOUS))
		return FALSE

/datum/status_effect/drowsiness/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_COMPONENT_CLEAN_FACE_ACT)

/datum/status_effect/drowsiness/tick(seconds_between_ticks)
	// You do not feel drowsy while unconscious or in stasis
	if(owner.stat >= UNCONSCIOUS)
		return

	// Resting helps against drowsiness
	// While resting, we lose 4 seconds of duration (2 additional ticks) per tick
	if(owner.resting && remove_duration(2 * seconds_between_ticks))
		return

	owner.set_eye_blur_if_lower(2 SECONDS * seconds_between_ticks)

	if(SPT_PROB(2.5, seconds_between_ticks))
		owner.AdjustSleeping(5 SECONDS * seconds_between_ticks)
