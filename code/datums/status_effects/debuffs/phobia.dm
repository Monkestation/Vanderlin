/// Basically a cooldown which makes you emote when it starts, but allows it to be easily shared between multiple phobias
/datum/status_effect/minor_phobia_reaction
	id = "phobia_minor"
	duration = 12 SECONDS
	alert_type = null

/datum/status_effect/minor_phobia_reaction/on_apply()
	. = ..()
	owner.emote("scream")
	owner.adjust_jitter(12 SECONDS)
	owner.add_stress(/datum/stress_event/startled)

/// Stacking severity of phobic reaction
/// The more stacks you are the more scared you are
/datum/status_effect/stacking/phobia_reaction
	id = "phobia"
	status_type = STATUS_EFFECT_REFRESH
	stacks = 1
	max_stacks = 6
	tick_interval = 40 SECONDS
	consumed_on_threshold = FALSE

/datum/status_effect/stacking/phobia_reaction/on_creation(mob/living/new_owner, duration_override, stacks_to_apply = 1, stress_event_type)
	. = ..()
	if(!.)
		return FALSE

	if(stress_event_type)
		owner.add_stress(stress_event_type)

	return TRUE

/datum/status_effect/stacking/phobia_reaction/refresh(mob/living/new_owner, duration_override, stacks_to_add, datum/stress_event/event_type)
	. = ..()
	add_stacks(stacks_to_add)

/datum/status_effect/stacking/phobia_reaction/add_stacks(stacks_added)
	. = ..()
	if (stacks_added <= 0 || stacks <= 0)
		return

	var/reaction = rand(1,4)
	switch(reaction)
		if(1)
			to_chat(owner, span_warning("You are startled!"))
			owner.emote("jump")
			owner.Immobilize(0.1 SECONDS * stacks)

		if(2)
			owner.emote("scream")
			owner.say("AAAAH!!", forced = "phobia")

			if(stacks >= 5)
				var/held_item = owner.get_active_held_item()
				if (owner.dropItemToGround(held_item))
					owner.visible_message(
						span_danger("[owner.name] drops \the [held_item]!"),
						span_warning("You drop \the [held_item]!"), null, COMBAT_MESSAGE_RANGE)

		if(3)
			to_chat(owner, span_warning("You lose your balance!"))
			owner.add_movespeed_modifier("spooked_phobia", multiplicative_slowdown = 0.25)
			// We're relying on the fact that there's a 12 second application cooldown to not have to bother cancelling and replacing this timer
			// So if you adjust the duration keep that in mind
			addtimer(CALLBACK(src, PROC_REF(speed_up)), 1 SECONDS * stacks, TIMER_STOPPABLE | TIMER_DELETE_ME)

		if(4)
			to_chat(owner, span_warning("You feel faint with fright!"))
			owner.set_dizzy(2 * stacks SECONDS)
			owner.set_eye_blur_if_lower(3 * stacks SECONDS)

/datum/status_effect/stacking/phobia_reaction/fadeout_effect()
	to_chat(owner, span_notice("You calm down."))

/// Remove our active movespeed modifier
/datum/status_effect/stacking/phobia_reaction/proc/speed_up()
	owner.remove_movespeed_modifier("spooked_phobia")
