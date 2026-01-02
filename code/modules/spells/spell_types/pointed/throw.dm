/datum/action/cooldown/spell/throw_target
	name = "Predatory Throw"
	desc = "Hurl whoever you're grabbing at a target location with tremendous force. The victim will be sent flying and take damage on impact."

	spell_type = SPELL_RAGE
	has_visual_effects = FALSE
	charge_required = FALSE
	cooldown_time = 30 SECONDS
	spell_cost = 25
	var/throw_range = 7
	var/throw_speed = 2

/datum/action/cooldown/spell/throw_target/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE

	if(QDELETED(owner.pulling))
		return FALSE

	if(!isliving(owner.pulling))
		return FALSE

	if(!QDELETED(owner.pulledby) && owner.pulledby.grab_state >= GRAB_AGGRESSIVE)
		return FALSE

	return TRUE

/datum/action/cooldown/spell/throw_target/is_valid_target(atom/target_atom)
	. = ..()
	if(!.)
		return FALSE

	// Must target a turf or something on a turf
	var/turf/target_turf = get_turf(target_atom)
	if(!target_turf)
		return FALSE

	var/mob/living/user = owner
	if(user.body_position == LYING_DOWN || HAS_TRAIT(owner, TRAIT_IMMOBILIZED))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/throw_target/cast(atom/target_atom)
	. = ..()
	owner.face_atom(target_atom)

	prepare_throw(target_atom)
	return TRUE

/datum/action/cooldown/spell/throw_target/proc/CheckCanThrow(atom/target_atom)
	var/mob/living/user = owner
	if(user.body_position == LYING_DOWN || HAS_TRAIT(owner, TRAIT_IMMOBILIZED))
		return FALSE

	if(QDELETED(owner.pulling) || !isliving(owner.pulling))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/throw_target/proc/prepare_throw(atom/target_atom)
	owner.balloon_alert(owner, "winding up...")

	var/mob/living/victim = owner.pulling

	var/base_x = owner.base_pixel_x
	var/base_y = owner.base_pixel_y
	animate(owner, pixel_x = base_x - 4, pixel_y = base_y, time = 0.5 SECONDS)

	if(!do_after(owner, 1 SECONDS, timed_action_flags = (IGNORE_USER_LOC_CHANGE|IGNORE_SLOWDOWNS), extra_checks = CALLBACK(src, PROC_REF(CheckCanThrow), target_atom), hidden = TRUE))
		end_throw_prep(base_x, base_y)
		return FALSE

	end_throw_prep(base_x, base_y)
	do_throw(target_atom, victim)
	return TRUE

/datum/action/cooldown/spell/throw_target/proc/end_throw_prep(base_x, base_y)
	animate(owner, pixel_x = base_x, pixel_y = base_y, time = 0.2 SECONDS)

/datum/action/cooldown/spell/throw_target/proc/do_throw(atom/target_atom, mob/living/victim)
	if(!victim || QDELETED(victim))
		return

	var/turf/target_turf = get_turf(target_atom)
	var/mob/living/user = owner

	user.stop_pulling()

	owner.balloon_alert(owner, "you hurl [victim]!")
	victim.balloon_alert(victim, "[owner] hurls you!")

	victim.adjustBruteLoss(10)
	victim.Knockdown(1 SECONDS)

	var/throw_dist = min(get_dist(user, target_turf), throw_range)

	victim.throw_at(target_turf, throw_dist, throw_speed, user, spin = TRUE, callback = CALLBACK(src, PROC_REF(throw_impact), victim))

	user.visible_message(
		span_warning("[user] hurls [victim] through the air!"),
		span_warning("You hurl [victim] at [target_atom]!"))

/datum/action/cooldown/spell/throw_target/proc/throw_impact(mob/living/victim)
	if(!victim || QDELETED(victim))
		return

	victim.adjustBruteLoss(15)
	victim.Knockdown(2 SECONDS)
	victim.Paralyze(0.5 SECONDS)

	victim.add_splatter_floor()

	victim.visible_message(
		span_warning("[victim] slams into the ground with a sickening thud!"),
		span_userdanger("You slam into the ground!"))

	var/turf/landing_turf = get_turf(victim)
	for(var/mob/living/bystander in landing_turf)
		if(bystander == victim)
			continue

		bystander.adjustBruteLoss(10)
		bystander.Knockdown(1.5 SECONDS)
		bystander.visible_message(
			span_warning("[victim] crashes into [bystander]!"),
			span_userdanger("[victim] crashes into you!"))
