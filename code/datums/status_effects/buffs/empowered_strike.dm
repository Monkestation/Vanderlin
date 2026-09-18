#define EMPOWER_FILTER "empower_glow"

/atom/movable/screen/alert/status_effect/buff/empowered_strike
	name = "Empowered Strike"
	desc = "My next melee strike will bypass parry and dodge."
	icon_state = "buff"

/datum/status_effect/buff/empowered_strike
	id = "empowered_strike"
	alert_type = /atom/movable/screen/alert/status_effect/buff/empowered_strike
	duration = 8 SECONDS
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/buff/empowered_strike/on_creation(mob/living/new_owner, new_duration)
	if(new_duration)
		duration = new_duration
	return ..()

/datum/status_effect/buff/empowered_strike/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))
	owner.add_filter(EMPOWER_FILTER, 2, outline_filter(2, "#ff2020"))
	owner.balloon_alert_to_viewers("<font color='#ff2020'>empowered!</font>")

/datum/status_effect/buff/empowered_strike/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_HUMAN_MELEE_UNARMED_ATTACK))
	owner.remove_filter(EMPOWER_FILTER)
	return ..()

/datum/status_effect/buff/empowered_strike/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(target == owner || target.stat == DEAD)
		return
	// Consume the buff - this swing bypasses defense
	consume_empower(target)
	return COMPONENT_ITEM_NO_DEFENSE

/datum/status_effect/buff/empowered_strike/proc/on_unarmed_attack(mob/living/source, atom/target, proximity)
	SIGNAL_HANDLER
	if(!isliving(target) || target == owner)
		return
	var/mob/living/L = target
	if(L.stat == DEAD)
		return
	// Consume on next tick after the attack resolves
	addtimer(CALLBACK(src, PROC_REF(consume_empower), L), 0)

/datum/status_effect/buff/empowered_strike/proc/consume_empower(mob/living/hit_target)
	playsound(get_turf(owner), 'sound/magic/antimagic.ogg', 40, TRUE)
	owner.visible_message(
		span_danger("[owner]'s empowered strike blazes through!"),
		span_notice("My empowered strike lands true!"))
	if(istype(hit_target) && hit_target != owner)
		to_chat(hit_target, span_bigbold("<font color='#ff69b4'>There was no way to avoid that empowered attack!</font>"))
	owner.remove_status_effect(/datum/status_effect/buff/empowered_strike)

#undef EMPOWER_FILTER
