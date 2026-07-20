
/// Nearsighted
/datum/status_effect/grouped/nearsighted
	id = "nearsighted"
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = null
	// This is not "remove on fullheal" as in practice,
	// fullheal should instead remove all the sources and in turn cure this

	/// Static list of signals that, when recieved, we force an update to our nearsighted overlay
	var/static/list/update_signals = list(SIGNAL_ADDTRAIT(TRAIT_NEARSIGHTED_CORRECTED), SIGNAL_REMOVETRAIT(TRAIT_NEARSIGHTED_CORRECTED))
	/// How severe is our nearsightedness right now
	var/overlay_severity = 1

/datum/status_effect/grouped/nearsighted/on_apply()
	RegisterSignals(owner, update_signals, PROC_REF(update_nearsightedness))
	update_nearsighted_overlay()
	return ..()

/datum/status_effect/grouped/nearsighted/on_remove()
	UnregisterSignal(owner, update_signals)
	owner.clear_fullscreen(id)
	return ..()

/// Signal proc for when we gain or lose [TRAIT_NEARSIGHTED_CORRECTED] - (temporarily) disable the overlay if we're correcting it
/datum/status_effect/grouped/nearsighted/proc/update_nearsightedness(datum/source)
	SIGNAL_HANDLER

	update_nearsighted_overlay()

/// Checks if we should be nearsighted currently, or if we should clear the overlay
/datum/status_effect/grouped/nearsighted/proc/should_be_nearsighted()
	return !HAS_TRAIT(owner, TRAIT_NEARSIGHTED_CORRECTED)

/// Updates our nearsightd overlay, either removing it if we have the trait or adding it if we don't
/datum/status_effect/grouped/nearsighted/proc/update_nearsighted_overlay()
	if(should_be_nearsighted())
		owner.overlay_fullscreen(id, /atom/movable/screen/fullscreen/impaired, overlay_severity)
	else
		owner.clear_fullscreen(id)

/// Sets the severity of our nearsighted overlay
/datum/status_effect/grouped/nearsighted/proc/set_nearsighted_severity(to_value)
	if(!isnum(to_value))
		return
	if(overlay_severity == to_value)
		return

	overlay_severity = to_value
	update_nearsighted_overlay()
