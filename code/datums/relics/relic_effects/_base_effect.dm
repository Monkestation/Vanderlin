/datum/relic_effect
	VAR_PRIVATE/duration = 0
	///this is the amount of subsystem processes we have until we toggle the linger effect, -1 is forever once triggered
	var/active_duration = 1
	var/is_lingering = TRUE
	///do we setup signals?
	var/signal = FALSE

	var/datum/component/relic/stored_lookup

/datum/relic_effect/New()
	. = ..()
	duration = active_duration

/datum/relic_effect/proc/setup_signals()
	return

/datum/relic_effect/proc/remove_signals()
	return

/datum/relic_effect/proc/refresh()
	SHOULD_CALL_PARENT(TRUE)
	duration = active_duration

/datum/relic_effect/proc/execute_effect(atom/parent_atom, datum/relic_information/info, datum/component/relic/relic_comp)
	SHOULD_CALL_PARENT(TRUE)
	if(active_duration == -1)
		is_lingering = TRUE
		return
	duration--
	if(duration <= 0)
		duration = active_duration
		is_lingering = FALSE
		return
	is_lingering = TRUE
	stored_lookup.play_relic_effects()
	return
