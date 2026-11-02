/datum/component/relic
	var/datum/relic_trigger/trigger
	var/datum/relic_effect/effect
	var/datum/relic_information/info

	// Tracks if an effect is persisting past its trigger
	var/is_lingering = FALSE
	// Tracks lifecycle for one-shot relics
	var/has_fired = FALSE

/datum/component/relic/Initialize(datum/relic_trigger/_trigger, datum/relic_effect/_effect, datum/relic_information/_info)
	if(!istype(_trigger) || !istype(_effect))
		return COMPONENT_INCOMPATIBLE

	src.trigger = _trigger
	src.effect = _effect
	src.info = _info

	// Let the trigger handle registering its specific signal signature to the parent atom
	trigger.register_events(parent, src)
	info.register_information(parent)
	trigger.stored_lookup = src
	effect.stored_lookup = src

/datum/component/relic/Destroy()
	SSrelics.active_relics -= src
	if(parent)
		trigger.unregister_events(parent, src)
	trigger.stored_lookup = null
	effect.stored_lookup = null
	QDEL_NULL(trigger)
	QDEL_NULL(effect)
	QDEL_NULL(info)
	return ..()

/**
 * Wakes up the component and adds it to the Subsystem's execution loop.
 */
/datum/component/relic/proc/activate_relic()
	if(has_fired && trigger.one_shot)
		return

	if(effect.signal)
		effect.setup_signals()
	else
		if(!(src in SSrelics.active_relics))
			SSrelics.active_relics += src
		if(trigger.duration_refreshing)
			effect.refresh()

/datum/component/relic/proc/play_relic_trigger_effects()
	info?.play_relic_trigger_effects(parent)

/datum/component/relic/proc/play_relic_effects()
	info?.play_relic_effects(parent)

/**
 * Called by SSrelics every tick. Internal logic lives here.
 * Returns TRUE to keep processing next tick, FALSE to go to sleep.
 */
/datum/component/relic/proc/process_tick()
	//If it shouldn't fire and isn't actively lingering from a previous fire, sleep it.
	if(!trigger.should_fire(parent, info) && !effect.is_lingering)
		effect.remove_signals()
		return FALSE

	effect.execute_effect(parent, info, src)

	//lifecycle cleanup
	if(trigger.one_shot)
		has_fired = TRUE
		trigger.unregister_events(parent, src)
		return FALSE

	//If the effect isn't lingering, we drop out of the loop until a signal wakes us up again
	if(!effect.is_lingering)
		return FALSE

	return TRUE
