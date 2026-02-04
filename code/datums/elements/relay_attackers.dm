/**
 * This element registers to a shitload of signals which can signify "someone attacked me".
 * If anyone does it sends a single "someone attacked me" signal containing details about who done it.
 * This prevents other components and elements from having to register to the same list of a million signals, should be more maintainable in one place.
 */
/datum/element/relay_attackers

/datum/element/relay_attackers/Attach(datum/target)
	. = ..()
	if (!HAS_TRAIT(target, TRAIT_RELAYING_ATTACKER))
		// Boy this sure is a lot of ways to tell us that someone tried to attack us
		RegisterSignal(target, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))
		RegisterSignal(target, list(COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_ATTACK_PAW), PROC_REF(on_attack_generic))
		RegisterSignal(target, list(COMSIG_ATOM_ATTACK_ANIMAL), PROC_REF(on_attack_npc))
		RegisterSignal(target, COMSIG_ATOM_BULLET_ACT, PROC_REF(on_bullet_act))
		RegisterSignal(target, COMSIG_ATOM_HITBY, PROC_REF(on_hitby))
	ADD_TRAIT(target, TRAIT_RELAYING_ATTACKER, REF(src))

/datum/element/relay_attackers/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, list(
		COMSIG_ATOM_ATTACKBY,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_ATTACK_PAW,
		COMSIG_ATOM_ATTACK_ANIMAL,
		COMSIG_ATOM_BULLET_ACT,
		COMSIG_ATOM_HITBY,
	))

/datum/element/relay_attackers/proc/on_attackby(atom/target, obj/item/weapon, mob/attacker, list/modifiers)
	SIGNAL_HANDLER
	if(weapon.force)
		relay_attacker(target, attacker, weapon.force)

/datum/element/relay_attackers/proc/on_attack_generic(atom/target, mob/living/attacker, list/modifiers)
	SIGNAL_HANDLER
	if(!attacker.cmode)
		return
	relay_attacker(target, attacker, 10)

/datum/element/relay_attackers/proc/on_attack_npc(atom/target, mob/living/attacker)
	SIGNAL_HANDLER
	relay_attacker(target, attacker, 10)

/datum/element/relay_attackers/proc/on_bullet_act(atom/target, obj/projectile/hit_projectile)
	SIGNAL_HANDLER
	if(hit_projectile.nodamage)
		return
	if(!ismob(hit_projectile.firer))
		return
	relay_attacker(target, hit_projectile.firer, hit_projectile.damage)

/datum/element/relay_attackers/proc/on_hitby(atom/target, atom/movable/hit_atom, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	if(!isitem(hit_atom))
		return
	var/obj/item/hit_item = hit_atom
	if(!hit_item.throwforce)
		return
	var/mob/thrown_by = hit_item.thrownby
	if(!ismob(thrown_by))
		return
	relay_attacker(target, thrown_by, hit_item.throwforce)

/// Send out a signal identifying whoever just attacked us (usually a mob but sometimes a mech or turret)
/datum/element/relay_attackers/proc/relay_attacker(atom/victim, atom/attacker, damage)
	SEND_SIGNAL(victim, COMSIG_ATOM_WAS_ATTACKED, attacker, damage)
