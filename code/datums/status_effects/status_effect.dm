/**

* Status effects are used to apply temporary or permanent effects to mobs. Mobs are aware of their status effects at all times.
* * This file contains their code, plus code for applying and removing them.
* * When making a new status effect, add a define to status_effects.dm in __DEFINES for ease of use!
*/

/datum/status_effect
	/// Used for screen alerts.
	var/id = "effect"
	/// How long the status effect lasts in DECISECONDS. Enter -1 for an effect that never ends unless removed through some means.
	var/duration = -1
	/// What the duration was when we applied the status effect
	var/initial_duration
	/// How many deciseconds between ticks, approximately. Leave at 10 for every second.
	var/tick_interval = 1 SECONDS
	/// The mob affected by the status effect.
	var/mob/living/owner
	/// How many of the effect can be on one mob, and what happens when you try to add another
	var/status_type = STATUS_EFFECT_UNIQUE
	/// if we call on_remove() when the mob is deleted
	var/on_remove_on_mob_delete = FALSE
	/// If defined, this text will appear when the mob is examined - to use he, she etc. use "SUBJECTPRONOUN" and replace it in the examines themselves
	var/examine_text
	/// The alert thrown by the status effect, contains name and description
	var/alert_type = /atom/movable/screen/alert/status_effect
	/// The alert itself, if it exists
	var/atom/movable/screen/alert/status_effect/linked_alert = null
	/// Used to define if the status effect should be using SSfastprocess or SSprocessing
	var/processing_speed = STATUS_EFFECT_FAST_PROCESS
	/// Do we self-terminate when a fullheal is called?
	var/remove_on_fullheal = FALSE
	/// If remove_on_fullheal is TRUE, what flag do we need to be removed?
	var/heal_flag_necessary = HEAL_STATUS
	/// Assoc list of statkey to value
	var/list/effectedstats = list()

/datum/status_effect/New(list/arguments)
	on_creation(arglist(arguments))

/datum/status_effect/proc/on_creation(mob/living/new_owner, duration_override, ...)
	if(new_owner)
		owner = new_owner
	if(owner)
		LAZYADD(owner.status_effects, src)
		RegisterSignal(owner, COMSIG_LIVING_POST_FULLY_HEAL, PROC_REF(remove_effect_on_heal))
	if(!owner || !on_apply())
		qdel(src)
		return
	if(isnum(duration_override) && duration_override != duration)
		duration = duration_override
	initial_duration = duration
	if(duration != -1)
		duration = world.time + duration
	tick_interval = world.time + tick_interval
	if(alert_type)
		var/atom/movable/screen/alert/status_effect/A = owner?.throw_alert(id, alert_type)
		if(A)
			A?.attached_effect = src //so the alert can reference us, if it needs to
			linked_alert = A //so we can reference the alert, if we need to

	if(duration > world.time || tick_interval > world.time) //don't process if we don't care
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

/datum/status_effect/process()
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!owner)
		qdel(src)
		return
	if(tick_interval < world.time)
		tick()
		tick_interval = world.time + initial(tick_interval)
	if(duration != -1 && duration < world.time)
		qdel(src)

/// Called whenever the buff is applied; returning FALSE will cause it to autoremove itself.
/datum/status_effect/proc/on_apply()
	SHOULD_CALL_PARENT(TRUE)

	for(var/stat in effectedstats)
		owner.set_stat_modifier("[id]", stat, effectedstats[stat])

	return TRUE

/// Called before being fully removed (before on_remove)
/// Returning FALSE will cancel removal
/datum/status_effect/proc/before_remove()
	return TRUE

/// Called whenever the buff expires or is removed; do note that at the point this is called, it is out of the owner's status_effects but owner is not yet null
/datum/status_effect/proc/on_remove()
	SHOULD_CALL_PARENT(TRUE)

	owner.remove_stat_modifier("[id]")

/// Called instead of on_remove when a status effect is replaced by itself or when a status effect with on_remove_on_mob_delete = FALSE has its mob deleted
/datum/status_effect/proc/be_replaced()
	qdel(src)

/// Gets and formats examine text associated with our status effect.
/// Return 'null' to have no examine text appear (default behavior).
/// Use "SUBJECTPRONOUN is" to autoreplace with correct pronouns + linking verb in the examines themselves
/datum/status_effect/proc/get_examine_text()
	return null

/// Called every tick.
/datum/status_effect/proc/tick()
	return

/datum/status_effect/proc/refresh(mob/living/new_owner, duration_override, ...)
	if(initial_duration == -1)
		return
	duration = world.time + initial_duration

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

/// Remove [seconds] of duration from the status effect, qdeling / ending if we eclipse the current world time.
/datum/status_effect/proc/remove_duration(seconds)
	if(duration == -1) // Infinite duration
		return FALSE

	duration -= seconds
	if(duration <= world.time)
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
			inspec += "<br><span class='purple'>[S]</span> \Roman [attached_effect.effectedstats[S]]"
		if(attached_effect.effectedstats[S] < 0)
			var/newnum = attached_effect.effectedstats[S] * -1
			inspec += "<br><span class='danger'>[S]</span> \Roman [newnum]"

	inspec += "<br>----------------------"
	to_chat(user, "[inspec.Join()]")

/atom/movable/screen/alert/status_effect/Destroy()
	attached_effect = null
	return ..()
