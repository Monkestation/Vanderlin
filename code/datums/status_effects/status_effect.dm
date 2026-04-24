/**

* Status effects are used to apply temporary or permanent effects to mobs. Mobs are aware of their status effects at all times.
* * This file contains their code, plus code for applying and removing them.
* * When making a new status effect, add a define to status_effects.dm in __DEFINES for ease of use!
*/

/datum/status_effect
	/// The ID of the effect. ID is used in adding and removing effects to check for duplicates, among other things.
	var/id = "effect"
	/// This is how long the status effect lasts in deciseconds.
	/// You can put STATUS_EFFECT_PERMANENT (or INFINITY) here for infinite duration.
	var/duration = STATUS_EFFECT_PERMANENT
	/// What the duration was when we applied the status effect. We don't use initial(duration) in case of duration_override.
	var/initial_duration
	/// How many deciseconds between ticks, approximately. Leave at 10 for every second.
	var/tick_interval = 1 SECONDS
	/// The time until the next [proc/tick] call, gets set to [var/tick_interval] after every [proc/tick] call and decrements on every [proc/process] call.
	var/time_until_next_tick
	/// The mob affected by the status effect.
	VAR_FINAL/mob/living/owner
	/// How many of the effect can be on one mob, and what happens when you try to add another
	var/status_type = STATUS_EFFECT_UNIQUE
	/// if we call on_remove() when the mob is deleted
	var/on_remove_on_mob_delete = FALSE
	/// If defined, this text will appear when the mob is examined - to use he, she etc. use "SUBJECTPRONOUN" and replace it in the examines themselves
	var/examine_text
	/// The alert thrown by the status effect, contains name and description
	var/alert_type = /atom/movable/screen/alert/status_effect
	/// The alert itself, created in [proc/on_creation] (if alert_type is specified).
	VAR_FINAL/atom/movable/screen/alert/status_effect/linked_alert
	/// Used to define if the status effect should be using SSfastprocess or SSprocessing
	var/processing_speed = STATUS_EFFECT_FAST_PROCESS
	/// Do we self-terminate when a fullheal is called?
	var/remove_on_fullheal = FALSE
	/// If remove_on_fullheal is TRUE, what flag do we need to be removed?
	var/heal_flag_necessary = HEAL_STATUS
	/// Assoc list of statkey to value
	var/list/effectedstats = list()

	/// Variables to create a mob overlay if applicable
	var/mob_overlay_icon = 'icons/mob/mob_effects.dmi'
	var/mob_overlay_icon_state
	var/mob_overlay_layer

	/// The AM for the mob visual
	var/atom/movable/mob_visual

/datum/status_effect/New(list/arguments)
	on_creation(arglist(arguments))

/datum/status_effect/proc/on_creation(mob/living/new_owner, duration_override, ...)
	if(new_owner)
		owner = new_owner

	if(QDELETED(owner) || !on_apply())
		qdel(src)
		return

	if(owner)
		LAZYADD(owner.status_effects, src)
		RegisterSignal(owner, COMSIG_LIVING_POST_FULLY_HEAL, PROC_REF(remove_effect_on_heal))

	if(isnum(duration_override) && duration_override != duration)
		duration = duration_override
	initial_duration = duration

	if(duration == INFINITY)
		// we will optionally allow INFINITY, because i imagine it'll be convenient in some places,
		// but we'll still set it to -1 / STATUS_EFFECT_PERMANENT for proper unified handling
		duration = STATUS_EFFECT_PERMANENT

	if(tick_interval != STATUS_EFFECT_NO_TICK)
		time_until_next_tick = tick_interval

	if(alert_type)
		var/atom/movable/screen/alert/status_effect/A = owner?.throw_alert(id, alert_type)
		if(A)
			A?.attached_effect = src //so the alert can reference us, if it needs to
			linked_alert = A //so we can reference the alert, if we need to

	if(duration != STATUS_EFFECT_PERMANENT || tick_interval != STATUS_EFFECT_NO_TICK) //don't process if we don't care
		switch(processing_speed)
			if(STATUS_EFFECT_FAST_PROCESS)
				START_PROCESSING(SSfastprocess, src)
			if(STATUS_EFFECT_NORMAL_PROCESS)
				START_PROCESSING(SSprocessing, src)

	return TRUE

/datum/status_effect/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	if(owner)
		linked_alert = null
		owner.clear_alert(id)
		LAZYREMOVE(owner.status_effects, src)
		on_remove()
		UnregisterSignal(owner, COMSIG_LIVING_POST_FULLY_HEAL)
		owner = null
	return ..()

// Status effect process. Handles adjusting its duration and ticks.
// If you're adding processed effects, put them in [proc/tick]
// instead of extending / overriding the process() proc.
/datum/status_effect/process(seconds_per_tick)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(QDELETED(owner))
		qdel(src)
		return

	if (duration != STATUS_EFFECT_PERMANENT)
		duration = max(0, duration - (seconds_per_tick SECONDS)) // doing it first means its more up to date for ticks to read

	if (tick_interval != STATUS_EFFECT_NO_TICK)
		time_until_next_tick = max(0, time_until_next_tick - (seconds_per_tick SECONDS)) // same here

	if(tick_interval == STATUS_EFFECT_AUTO_TICK)
		tick(seconds_per_tick)
	else if(tick_interval != STATUS_EFFECT_NO_TICK && time_until_next_tick <= 0)
		time_until_next_tick = tick_interval // same here as well
		tick(tick_interval / 10)

	if(QDELING(src))
		return // tick deleted us, no need to continue

	if(duration != STATUS_EFFECT_PERMANENT)
		if(duration <= 0)
			qdel(src)
			return

/// Called whenever the buff is applied; returning FALSE will cause it to autoremove itself.
/datum/status_effect/proc/on_apply()
	SHOULD_CALL_PARENT(TRUE)

	owner.set_stat_modifier("[id]",effectedstats)

	if(mob_overlay_icon && mob_overlay_icon_state)
		mob_visual = build_mob_icon()

	return TRUE

/// Called before being fully removed (before on_remove)
/// Returning FALSE will cancel removal
/datum/status_effect/proc/before_remove()
	return TRUE

/// Called whenever the buff expires or is removed; do note that at the point this is called, it is out of the owner's status_effects but owner is not yet null
/datum/status_effect/proc/on_remove()
	SHOULD_CALL_PARENT(TRUE)

	owner.remove_stat_modifier("[id]")

	if(mob_visual)
		QDEL_NULL(mob_visual)

/// Called instead of on_remove when a status effect is replaced by itself or when a status effect with on_remove_on_mob_delete = FALSE has its mob deleted
/datum/status_effect/proc/be_replaced()
	qdel(src)

/// Build the on mob appearance for the overlay if applicable
/datum/status_effect/proc/build_mob_icon()
	var/mutable_appearance/appearance = mutable_appearance(mob_overlay_icon, mob_overlay_icon_state, mob_overlay_layer, ABOVE_LIGHTING_PLANE)
	return owner.flick_overlay_view(appearance, duration - 1 DECISECONDS)

/// Gets and formats examine text associated with our status effect.
/// Return 'null' to have no examine text appear (default behavior).
/// This can be used in two ways. Use "SUBJECTPRONOUN is" to autoreplace with correct pronouns + linking verb in the examines themselves,
/// or you can use the provided list of pronouns. See examine defines
/datum/status_effect/proc/get_examine_text(mob/user, list/P)
	return examine_text

/**
 * Called every tick from process().
 * This is only called of tick_interval is not -1.
 *
 * Note that every tick =/= every processing cycle.
 *
 * * seconds_between_ticks = This is how many SECONDS that elapse between ticks.
 * This is a constant value based upon the initial tick interval set on the status effect.
 * It is similar to seconds_per_tick, from processing itself, but adjusted to the status effect's tick interval.
 */
/datum/status_effect/proc/tick(seconds_between_ticks)
	return

/datum/status_effect/proc/refresh(mob/living/new_owner, duration_override, ...)
	duration = initial_duration

/// clickdelay/nextmove modifiers!
/datum/status_effect/proc/nextmove_modifier()
	return 1

/datum/status_effect/proc/nextmove_adjust()
	return 0

/// Signal proc for [COMSIG_LIVING_POST_FULLY_HEAL] to remove us on fullheal
/datum/status_effect/proc/remove_effect_on_heal(datum/source, heal_flags)
	SIGNAL_HANDLER

	if(!remove_on_fullheal)
		return

	if(!heal_flag_necessary || (heal_flags & heal_flag_necessary))
		qdel(src)

/// Removes [seconds] of duration from the status effect.
/// Returns whether or not the status effect was qdeleted due to running out of duration.
/datum/status_effect/proc/remove_duration(seconds)
	if(duration == STATUS_EFFECT_PERMANENT) // Infinite duration
		return FALSE

	duration -= (seconds SECONDS)
	if(duration <= 0)
		qdel(src)
		return TRUE

	return FALSE

////////////////
// ALERT HOOK //
////////////////

/atom/movable/screen/alert/status_effect
	name = "Curse of Mundanity"
	desc = ""
	var/datum/status_effect/attached_effect

/atom/movable/screen/alert/status_effect/examine_ui(mob/user)
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b></span>"
	if(desc)
		inspec += "<br>[desc]"

	for(var/S in attached_effect?.effectedstats)
		if(attached_effect.effectedstats[S] > 0)
			var/datum/attribute/attribute = GET_ATTRIBUTE_DATUM(S)
			inspec += "<br><span class='purple'>[attribute?.name]</span> \Roman [attached_effect.effectedstats[S]]"
		if(attached_effect.effectedstats[S] < 0)
			var/newnum = attached_effect.effectedstats[S] * -1
			var/datum/attribute/attribute = GET_ATTRIBUTE_DATUM(S)
			inspec += "<br><span class='danger'>[attribute?.name]</span> \Roman [newnum]"

	inspec += "<br>----------------------"
	to_chat(user, "[inspec.Join()]")

/atom/movable/screen/alert/status_effect/Destroy()
	attached_effect = null
	return ..()
