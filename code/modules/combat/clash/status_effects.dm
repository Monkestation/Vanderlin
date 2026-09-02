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
	// Defending signals
	RegisterSignal(new_owner, COMSIG_ATOM_ATTACKBY, PROC_REF(attacked_item))
	RegisterSignal(new_owner, COMSIG_ATOM_ATTACK_HAND, PROC_REF(attacked_hand))

	// Outward attacking signals, to make sure we aren't cheesing
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(attacking_item))
	RegisterSignal(new_owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(attacking_hand))

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

	UnregisterSignal(owner, list(
		COMSIG_ATOM_ATTACKBY,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_MOB_ITEM_ATTACK,
		COMSIG_HUMAN_MELEE_UNARMED_ATTACK,
	))

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

/// Proc for getting attacked with an item "victim" is the owner
/datum/status_effect/buff/clash/proc/attacked_item(mob/living/victim, obj/item/weapon, mob/living/assailant, list/modifiers)
	SIGNAL_HANDLER

	if(QDELETED(src) || !owner)
		return

	if(!weapon)
		return

	if(victim.process_clash(assailant))
		return COMPONENT_NO_AFTERATTACK

/// Proc for getting attacked with hands "victim" is the owner
/datum/status_effect/buff/clash/proc/attacked_hand(mob/living/victim, mob/living/assailant)
	SIGNAL_HANDLER

	if(QDELETED(src) || !owner)
		return

	if(victim.process_clash(assailant))
		return COMPONENT_CANCEL_ATTACK_CHAIN

/// Proc for attacking with an item "assailant" is the owner
/datum/status_effect/buff/clash/proc/attacking_item(mob/living/assailant, mob/living/victim, obj/item/weapon)
	SIGNAL_HANDLER

	if(QDELETED(src) || !owner)
		return

	if(!weapon)
		return

	// We have Guard / Clash active, and are hitting someone who doesn't. Cheesing a 'free' hit with a defensive buff is a no-no. You get punished.
	if(!victim.has_status_effect(/datum/status_effect/buff/clash))
		assailant.bad_guard(span_suicide("I tried to strike while focused on defense whole! It drains me!"), cheesy = TRUE)
		return COMPONENT_CANCEL_ATTACK_CHAIN

/// Proc for attacking with hands "assailant" is the owner
/datum/status_effect/buff/clash/proc/attacking_hand(mob/living/assailant, atom/target, proximity_flag, list/modifiers)
	SIGNAL_HANDLER

	if(QDELETED(src) || !owner)
		return

	if(!proximity_flag)
		return

	if(!isliving(target))
		return

	var/mob/living/victim = target

	// We have Guard / Clash active, and are hitting someone who doesn't. Cheesing a 'free' hit with a defensive buff is a no-no. You get punished.
	if(!victim.has_status_effect(/datum/status_effect/buff/clash))
		assailant.bad_guard(span_suicide("I tried to strike while focused on defense whole! It drains me!"), cheesy = TRUE)
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
