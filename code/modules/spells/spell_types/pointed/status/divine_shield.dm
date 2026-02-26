#define SHIELD_DURATION 1 MINUTES
/// Duration + (3 * Duration)
#define SHIELD_COOLDOWN ((3 * SHIELD_DURATION) + SHIELD_DURATION)

/datum/action/cooldown/spell/status/divine_shield
	name = "Divine Shield"
	desc = "Protect the target from harm, taking their suffering unto yourself."
	button_icon_state = "regression"
	sound = 'sound/magic/holyshield.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'

	cast_range = 3
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine)

	self_cast_possible = FALSE

	charge_required = TRUE
	charge_time = 3 SECONDS
	cooldown_time = SHIELD_COOLDOWN

	invocation = "May The Ten protect you!"
	invocation_type = INVOCATION_SHOUT

	spell_cost = 100

	status_effect = /datum/status_effect/buff/divine_shield

/datum/action/cooldown/spell/status/divine_shield/before_cast(mob/living/cast_on)
	. = ..()
	extra_args = list(owner)

/datum/status_effect/buff/divine_shield
	id = "divine_shield"
	alert_type = /atom/movable/screen/alert/status_effect/buff/divine_shield
	duration = SHIELD_DURATION
	effectedstats = list(STATKEY_CON = 3)
	var/static/mutable_appearance/shielded = mutable_appearance('icons/effects/effects.dmi', "shieldsparkles")
	var/mob/living/carbon/protector_mob
	COOLDOWN_DECLARE(message_cooldown)
	var/changed_godmode = FALSE

/datum/status_effect/buff/divine_shield/on_creation(mob/living/new_owner, duration_override, mob/living/protector)
	if(!protector)
		qdel(src)
		return FALSE

	protector_mob = protector
	protector_mob.apply_status_effect(arglist(list(/datum/status_effect/debuff/divine_shield, duration)))
	return ..()

/datum/status_effect/buff/divine_shield/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_overlay(shielded)
	target.AddElement(/datum/element/relay_attackers)
	RegisterSignal(target, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(upon_attacked))
	if(target.status_flags & GODMODE)
		return
	changed_godmode = TRUE
	target.status_flags |= GODMODE

/datum/status_effect/buff/divine_shield/on_remove()
	var/mob/living/target = owner
	target.cut_overlay(shielded)
	target.RemoveElement(/datum/element/relay_attackers)
	UnregisterSignal(target, COMSIG_ATOM_WAS_ATTACKED)
	if(changed_godmode)
		owner.status_flags &= ~GODMODE
	return ..()

/datum/status_effect/buff/divine_shield/proc/upon_attacked(mob/living/attacked, mob/living/carbon/human/attacker, damage)
	SIGNAL_HANDLER
	protector_mob.apply_damage(damage, BRUTE, forced = TRUE)
	owner.heal_overall_damage(damage, damage)//Currently the closest option I have, I can't find a way to relay damage but also not take the damage.

	if(COOLDOWN_FINISHED(src, message_cooldown))
		to_chat(protector_mob, SPAN_GOD_RAVOX("Your divine shield reflects damage to you from [owner.real_name]."))
		to_chat(owner, SPAN_GOD_RAVOX("Your divine shield reflects damage from you to [protector_mob.real_name]."))
		COOLDOWN_START(src, message_cooldown, 5 SECONDS)

/atom/movable/screen/alert/status_effect/buff/divine_shield
	name = "Divine Shield"
	desc = span_nicegreen("I am shielded by divine energies.")
	icon_state = "buff"


/datum/status_effect/debuff/divine_shield
	id = "divine_shield_r"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/divine_shield
	duration = SHIELD_DURATION
	effectedstats = list(STATKEY_CON = -2)

/atom/movable/screen/alert/status_effect/debuff/divine_shield
	name = "Divine Shield"
	desc = span_red("I am channeling divine power to shield my target.")
	icon_state = "debuff"
	alert_group = ALERT_DEBUFF


#undef SHIELD_DURATION
#undef SHIELD_COOLDOWN
