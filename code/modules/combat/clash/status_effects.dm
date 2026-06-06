/datum/status_effect/buff/clash
	id = "clash"
	duration = 6 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/clash
	/// Reference to the overlay to remove it
	var/mutable_appearance/clash_overlay

	/// Signals that cancel the clash
	var/static/list/interrupt_signals = list(
		COMSIG_ATOM_BULLET_ACT, // Any projectile
		COMSIG_ATOM_HITBY, // Thrown items
		COMSIG_MOB_SWAPPING_HANDS, // Swapping and twohanding
		COMSIG_MOB_KICKED, // getting kicked
		SIGNAL_ADDTRAIT(TRAIT_KNOCKEDOUT),
		SIGNAL_ADDTRAIT(TRAIT_INCAPACITATED),
		SIGNAL_ADDTRAIT(TRAIT_IMMOBILIZED),
		SIGNAL_ADDTRAIT(TRAIT_FLOORED),
		SIGNAL_ADDTRAIT(TRAIT_PACIFISM),
	)

	/// Signals that punish the owner and cancel the clash
	var/static/list/punishmment_signals = list(
		COMSIG_MOB_SPELL_ACTIVATED, // Trying to cast
		COMSIG_MOB_PRE_SPECIAL_MIDDLE, // Before: kick/bite/jump/etc
		COMSIG_MOB_FIRED_GUN, // Shooting a gun (We can clash with them)
	)

/datum/status_effect/buff/clash/on_creation(mob/living/new_owner, duration_override, ...)
	. = ..()

	RegisterSignal(new_owner, COMSIG_ATOM_ATTACKBY, PROC_REF(attacked_item))
	RegisterSignal(new_owner, COMSIG_ATOM_ATTACK_HAND, PROC_REF(attacked_hand))

	RegisterSignals(new_owner, interrupt_signals, PROC_REF(cancel_clash))
	RegisterSignals(new_owner, punishmment_signals, PROC_REF(cancel_punish_clash))

/datum/status_effect/buff/clash/on_apply()
	. = ..()
	if(!ishuman(owner))
		return

	clash_overlay = mutable_appearance('icons/mob/mob_effects.dmi', "eff_riposte_trans", ABOVE_ALL_MOB_LAYER)
	clash_overlay.pixel_y = 20

	owner.add_overlay(clash_overlay)

/datum/status_effect/buff/clash/on_remove()
	. = ..()
	if(!owner)
		clash_overlay = null
		return

	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(owner, COMSIG_ATOM_ATTACK_HAND)

	UnregisterSignal(owner, interrupt_signals)
	UnregisterSignal(owner, punishmment_signals)

	owner.cut_overlay(clash_overlay)
	clash_overlay = null

	owner.apply_status_effect(/datum/status_effect/debuff/clashcd)

/datum/status_effect/buff/clash/tick()
	if(QDELETED(src))
		return

	if(!owner.get_active_held_item() || owner.is_blind())
		owner.bad_guard()

/datum/status_effect/buff/clash/proc/attacked_item(mob/living/victim, obj/item/weapon, mob/living/assailant, list/modifiers)
	SIGNAL_HANDLER

	if(QDELETED(src) || !owner)
		return

	if(!weapon)
		return

	// Attacker has Guard / Clash active, and is hitting us who doesn't. Cheesing a 'free' hit with a defensive buff is a no-no. You get punished.
	if(assailant.has_status_effect(/datum/status_effect/buff/clash) && !victim.has_status_effect(/datum/status_effect/buff/clash))
		assailant.bad_guard(span_suicide("I tried to strike while focused on defense whole! It drains me!"), cheesy = TRUE)
		return

	// var/weapon_range = victim.used_intent?.reach
	// if(get_dist(victim, assailant) > weapon_range)
	// 	cancel_clash() // If we are getting stabbed by a spear, we can't clash unless we can match
	// 	return

	if(victim.dir == REVERSE_DIR(get_dir(victim, assailant)))
		cancel_clash() // Attacked from behind
		return

	victim.process_clash(assailant)

	return COMPONENT_NO_ATTACK

/datum/status_effect/buff/clash/proc/attacked_hand(mob/living/victim, mob/living/assailant)
	SIGNAL_HANDLER

	// Attacker has Guard / Clash active, and is hitting us who doesn't. Cheesing a 'free' hit with a defensive buff is a no-no. You get punished.
	if(assailant.has_status_effect(/datum/status_effect/buff/clash) && !victim.has_status_effect(/datum/status_effect/buff/clash))
		assailant.bad_guard(span_suicide("I tried to strike while focused on defense whole! It drains me!"), cheesy = TRUE)
		return

	if(victim.dir == REVERSE_DIR(get_dir(victim, assailant)))
		cancel_clash() // Attacked from behind
		return

	victim.process_clash(assailant)

	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/status_effect/buff/clash/proc/cancel_clash()
	SIGNAL_HANDLER

	owner.bad_guard(span_userdanger("My focus was interrupted!"))

/datum/status_effect/buff/clash/proc/cancel_punish_clash()
	SIGNAL_HANDLER

	owner.bad_guard(span_userdanger("My focus was <b>heavily</b> interrupted!"), cheesy = TRUE)

/atom/movable/screen/alert/status_effect/buff/clash
	name = "Ready to Clash"
	desc = span_notice("I am on guard, and ready to clash. If I am hit, I will successfully defend. Attacking will make me lose my focus.")
	icon_state = "clash"
