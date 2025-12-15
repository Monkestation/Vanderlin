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
	/// Assoc list of statkey to value
	var/list/effectedstats = list()

/datum/status_effect/New(list/arguments)
	on_creation(arglist(arguments))

/datum/status_effect/proc/on_creation(mob/living/new_owner, duration_override, ...)
	if(new_owner)
		owner = new_owner
	if(owner)
		LAZYADD(owner.status_effects, src)
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
	START_PROCESSING(SSfastprocess, src)
	return TRUE

/datum/status_effect/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	if(owner)
		linked_alert = null
		owner.clear_alert(id)
		LAZYREMOVE(owner.status_effects, src)
		on_remove()
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

//////////////////
// HELPER PROCS //
//////////////////

/// Applies a given status effect to this mob, returning the effect if it was successful
/mob/living/proc/apply_status_effect(datum/status_effect/new_effect, duration_override, ...)
	RETURN_TYPE(/datum/status_effect)

	// The arguments we pass to the start effect. The 1st argument is this mob.
	var/list/arguments = args.Copy()
	arguments[1] = src

	// If the status effect we're applying doesn't allow multiple effects, we need to handle it
	if(initial(new_effect.status_type) != STATUS_EFFECT_MULTIPLE)
		for(var/datum/status_effect/existing_effect as anything in status_effects)
			if(existing_effect.id != initial(new_effect.id))
				continue

			switch(existing_effect.status_type)
				// Multiple are allowed, continue as normal. (Not normally reachable)
				if(STATUS_EFFECT_MULTIPLE)
					break
				// Only one is allowed of this type - early return
				if(STATUS_EFFECT_UNIQUE)
					return
				// Replace the existing instance (deletes it).
				if(STATUS_EFFECT_REPLACE)
					existing_effect.be_replaced()
				// Refresh the existing type, then early return
				if(STATUS_EFFECT_REFRESH)
					existing_effect.refresh(arglist(arguments))
					SEND_SIGNAL(src, COMSIG_MOB_APPLIED_STATUS_EFFECT, existing_effect)
					return

	// Create the status effect with our mob + our arguments
	var/datum/status_effect/new_instance = new new_effect(arguments)
	if(!QDELETED(new_instance))
		SEND_SIGNAL(src, COMSIG_MOB_APPLIED_STATUS_EFFECT, new_instance)
		return new_instance

/**
 * Removes all instances of a given status effect from this mob
 *
 * removed_effect - TYPEPATH of a status effect to remove.
 * Additional status effect arguments can be passed - these are passed into before_remove.
 *
 * Returns TRUE if at least one was removed.
 */
/mob/living/proc/remove_status_effect(datum/status_effect/removed_effect, ...)
	var/list/arguments = args.Copy(2)

	. = FALSE
	for(var/datum/status_effect/existing_effect as anything in status_effects)
		if(existing_effect.id == initial(removed_effect.id) && existing_effect.before_remove(arglist(arguments)))
			qdel(existing_effect)
			. = TRUE

	return .

/// Returns the effect if the mob calling the proc owns the given status effect
/mob/living/proc/has_status_effect(effect)
	. = FALSE
	if(status_effects)
		var/datum/status_effect/S1 = effect
		for(var/datum/status_effect/S in status_effects)
			if(initial(S1.id) == S.id)
				return S

/// Returns a list of effects with matching IDs that the mod owns; use for effects there can be multiple of
/mob/living/proc/has_status_effect_list(effect)
	. = list()
	if(status_effects)
		var/datum/status_effect/S1 = effect
		for(var/datum/status_effect/S in status_effects)
			if(initial(S1.id) == S.id)
				. += S

//////////////////////
// STACKING EFFECTS //
//////////////////////

/datum/status_effect/stacking
	id = "stacking_base"
	/// Removed under specific conditions
	duration = -1
	alert_type = null
	/// How many stacks are accumulated, also is # of stacks that target will have when first applied
	var/stacks = 0
	/// Deciseconds until ticks start occuring, which removes stacks (first stack will be removed at this time plus tick_interval)
	var/delay_before_decay
	/// Deciseconds between decays once decay starts
	tick_interval = 10
	/// How many stacks are lost per tick (decay trigger)
	var/stack_decay = 1
	/// Special effects trigger when stacks reach this amount
	var/stack_threshold
	/// Stacks cannot exceed this amount
	var/max_stacks
	/// If status should be removed once threshold is crossed
	var/consumed_on_threshold = TRUE
	/// Set to true once the threshold is crossed, false once it falls back below
	var/threshold_crossed = FALSE
	var/overlay_file
	var/underlay_file
	/// States in .dmi must be given a name followed by a number which corresponds to a number of stacks. put the state name without the number in these state vars
	var/overlay_state
	/// The number is concatenated onto the string based on the number of stacks to get the correct state name
	var/underlay_state
	var/mutable_appearance/status_overlay
	var/mutable_appearance/status_underlay

/// What happens when threshold is crossed
/datum/status_effect/stacking/proc/threshold_cross_effect()

/// Runs if status is deleted due to threshold being crossed
/datum/status_effect/stacking/proc/stacks_consumed_effect()

/// Runs if status is deleted due to being under one stack
/datum/status_effect/stacking/proc/fadeout_effect()

/// Runs every time tick() causes stacks to decay
/datum/status_effect/stacking/proc/stack_decay_effect()

/datum/status_effect/stacking/proc/on_threshold_cross()
	threshold_cross_effect()
	if(consumed_on_threshold)
		stacks_consumed_effect()
		qdel(src)

/datum/status_effect/stacking/proc/on_threshold_drop()

/datum/status_effect/stacking/proc/can_have_status()
	return owner.stat != DEAD

/datum/status_effect/stacking/proc/can_gain_stacks()
	return owner.stat != DEAD

/datum/status_effect/stacking/tick()
	if(!can_have_status())
		qdel(src)
	else
		add_stacks(-stack_decay)
		stack_decay_effect()

/datum/status_effect/stacking/proc/add_stacks(stacks_added)
	if(stacks_added > 0 && !can_gain_stacks())
		return FALSE
	owner.cut_overlay(status_overlay)
	owner.underlays -= status_underlay
	stacks += stacks_added
	if(stacks > 0)
		if(stacks >= stack_threshold && !threshold_crossed) //threshold_crossed check prevents threshold effect from occuring if changing from above threshold to still above threshold
			threshold_crossed = TRUE
			on_threshold_cross()
		else if(stacks < stack_threshold && threshold_crossed)
			threshold_crossed = FALSE //resets threshold effect if we fall below threshold so threshold effect can trigger again
			on_threshold_drop()
		if(stacks_added > 0)
			tick_interval += delay_before_decay //refreshes time until decay
		stacks = min(stacks, max_stacks)
		status_overlay.icon_state = "[overlay_state][stacks]"
		status_underlay.icon_state = "[underlay_state][stacks]"
		owner.add_overlay(status_overlay)
		owner.underlays += status_underlay
	else
		fadeout_effect()
		qdel(src) //deletes status if stacks fall under one

/datum/status_effect/stacking/on_creation(mob/living/new_owner, duration_override, stacks_to_apply)
	. = ..()
	if(.)
		add_stacks(stacks_to_apply)

/datum/status_effect/stacking/on_apply()
	if(!can_have_status())
		return FALSE
	status_overlay = mutable_appearance(overlay_file, "[overlay_state][stacks]")
	status_underlay = mutable_appearance(underlay_file, "[underlay_state][stacks]")
	var/icon/I = icon(owner.icon, owner.icon_state, owner.dir)
	var/icon_height = I.Height()
	status_overlay.pixel_x = -owner.pixel_x
	status_overlay.pixel_y = FLOOR(icon_height * 0.25, 1)
	status_overlay.transform = matrix() * (icon_height/world.icon_size) //scale the status's overlay size based on the target's icon size
	status_underlay.pixel_x = -owner.pixel_x
	status_underlay.transform = matrix() * (icon_height/world.icon_size) * 3
	status_underlay.alpha = 40
	owner.add_overlay(status_overlay)
	owner.underlays += status_underlay
	return ..()

/datum/status_effect/stacking/Destroy()
	if(owner)
		owner.cut_overlay(status_overlay)
		owner.underlays -= status_underlay
	QDEL_NULL(status_overlay)
	return ..()
