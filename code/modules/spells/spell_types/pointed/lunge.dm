/datum/action/cooldown/spell/lunge
	name = "Predatory Lunge"
	desc = "Spring at your target to grapple them without warning, or tear the dead's heart out. Attacks from concealment or the rear may even knock them down if strong enough."

	spell_type = SPELL_RAGE
	has_visual_effects = FALSE
	charge_required = FALSE
	cooldown_time = 45 SECONDS
	spell_cost = 30
	var/target_range = 6

/datum/action/cooldown/spell/lunge/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE
	// Are we being grabbed?
	if(!QDELETED(owner.pulledby) && owner.pulledby.grab_state >= GRAB_AGGRESSIVE)
		owner.balloon_alert(owner, "grabbed!")
		return FALSE
	if(!QDELETED(owner.pulling))
		owner.balloon_alert(owner, "grabbing someone!")
		return FALSE
	return TRUE

/// Check: Are we lunging at a person?
/datum/action/cooldown/spell/lunge/is_valid_target(atom/target_atom)
	. = ..()
	if(!.)
		return FALSE

	if(isliving(target_atom))
		var/mob/living/turf_target = target_atom
		if(!isturf(turf_target.loc))
			return FALSE
		var/mob/living/user = owner
		if(user.body_position == LYING_DOWN || HAS_TRAIT(owner, TRAIT_IMMOBILIZED))
			return FALSE
		return TRUE


/datum/action/cooldown/spell/lunge/cast(atom/target_atom)
	. = ..()
	owner.face_atom(target_atom)

	prepare_target_lunge(target_atom)
	return TRUE

/datum/action/cooldown/spell/lunge/proc/CheckCanTarget(atom/target_atom)
	// Check: Turf
	var/mob/living/turf_target = target_atom
	if(!isturf(turf_target.loc))
		return FALSE
	// Check: can the Bloodsucker even move?
	var/mob/living/user = owner
	if(user.body_position == LYING_DOWN || HAS_TRAIT(owner, TRAIT_IMMOBILIZED))
		return FALSE
	return TRUE

///Starts processing the power and prepares the lunge by spinning, calls lunge at the end of it.
/datum/action/cooldown/spell/lunge/proc/prepare_target_lunge(atom/target_atom)
	owner.balloon_alert(owner, "lunge started!")
	//animate them shake
	var/base_x = owner.base_pixel_x
	var/base_y = owner.base_pixel_y
	animate(owner, pixel_x = base_x, pixel_y = base_y, time = 1, loop = -1)
	for(var/i in 1 to 25)
		var/x_offset = base_x + rand(-3, 3)
		var/y_offset = base_y + rand(-3, 3)
		animate(pixel_x = x_offset, pixel_y = y_offset, time = 1)

	if(!do_after(owner, 2 SECONDS, timed_action_flags = (IGNORE_USER_LOC_CHANGE|IGNORE_TARGET_LOC_CHANGE|IGNORE_SLOWDOWNS), extra_checks = CALLBACK(src, TYPE_PROC_REF(/datum/action/cooldown/spell/lunge, CheckCanTarget), target_atom), hidden = TRUE))
		end_target_lunge(base_x, base_y)

		return FALSE

	end_target_lunge()
	do_lunge(target_atom)
	return TRUE

///When preparing to lunge ends, this clears it up.
/datum/action/cooldown/spell/lunge/proc/end_target_lunge(base_x, base_y)
	animate(owner, pixel_x = base_x, pixel_y = base_y, time = 1)

///Actually lunges the target, then calls lunge end.
/datum/action/cooldown/spell/lunge/proc/do_lunge(atom/hit_atom)
	var/turf/targeted_turf = get_turf(hit_atom)
	owner.AddComponent(/datum/component/after_image)

	var/dist = get_dist(owner, targeted_turf)
	if(target_range ? (dist <= target_range) : CAN_THEY_SEE(owner, targeted_turf))
		var/safety = dist * 3 + 1
		var/consequetive_failures = 0
		while(--safety && !hit_atom.Adjacent(owner))
			if(!step_to(owner, targeted_turf))
				consequetive_failures++
			if(consequetive_failures >= 3) // If 3 steps don't work, just stop.
				break
			sleep(1)
	else
		owner.balloon_alert(owner, "too far away!")

	lunge_end(hit_atom, targeted_turf)
	sleep(0.5 SECONDS)
	qdel(owner.GetComponent(/datum/component/after_image))

/datum/action/cooldown/spell/lunge/proc/lunge_end(atom/hit_atom, turf/target_turf)
	// Am I next to my target to start giving the effects?
	if(!owner.Adjacent(hit_atom))
		return

	var/mob/living/user = owner
	var/mob/living/carbon/human/target = hit_atom

	// Did I slip or get knocked unconscious?
	if(user.body_position != STANDING_UP || user.incapacitated())
		var/send_dir = get_dir(user, target_turf)
		new /datum/forced_movement(user, get_ranged_target_turf(user, send_dir, 1), 1, FALSE)
		user.spin(10)
		return
	// Is my target a Monster hunter?
	if(istype(target) && target.is_shove_knockdown_blocked())
		owner.balloon_alert(owner, "pushed away!")
		target.grabbedby(owner)
		return

	owner.balloon_alert(owner, "you lunge at [target]!")
	if(target.stat == DEAD)
		var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
		chest.add_wound(/datum/wound/slash/disembowel)
		target.playsound_local(get_turf(target), pick(list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')), 70)
		owner.visible_message(
			span_warning("[owner] tears into [target]'s chest!"),
			span_warning("You tear into [target]'s chest!"))

		var/obj/item/organ/heart/myheart_now = locate() in target.getorganslot(ORGAN_SLOT_HEART)
		if(myheart_now)
			myheart_now.Remove(target)
			user.put_in_hands(myheart_now)

	else
		var/obj/item/weapon/werewolf_claw/claw = owner.get_active_held_item()
		if(claw)
			var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
			to_chat(target,span_danger("[owner] tears into me!"))
			chest.add_wound(/datum/wound/slash/large)
			chest.receive_damage(40)
			target.add_splatter_floor()
			target.emote("scream")
		else
			target.grabbedby(owner)
			target.grippedby(owner, instant = TRUE)
		// Did we knock them down?
		if(!is_source_facing_target(target, owner) || owner.alpha <= 40)
			target.Knockdown(2 SECONDS)
			target.Paralyze(0.1)
