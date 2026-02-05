/datum/action/cooldown/spell/undirected/divine_strike
	name = "Divine Strike"
	desc = ""
	button_icon_state = "createlight"
	sound = 'sound/magic/timestop.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/ravox)

	invocation = "Ravox deems your persistence worthy!"
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 30 SECONDS
	spell_cost = 30

/datum/action/cooldown/spell/undirected/divine_strike/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE
	return isliving(owner)

/datum/action/cooldown/spell/undirected/divine_strike/cast(mob/living/cast_on)
	. = ..()
	cast_on.apply_status_effect(/datum/status_effect/divine_strike, cast_on.get_active_held_item())

/datum/status_effect/divine_strike
	id = "divine_strike"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/divine_strike
	on_remove_on_mob_delete = TRUE
	var/datum/weakref/buffed_item

/datum/status_effect/divine_strike/on_creation(mob/living/new_owner, duration_override, obj/item/I)
	. = ..()
	if(istype(I) && !(I.item_flags & ABSTRACT))
		buffed_item = WEAKREF(I)
		if(!I.light_outer_range && I.light_system == STATIC_LIGHT)
			I.set_light(1)
		RegisterSignal(I, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	else
		RegisterSignal(owner, COMSIG_MOB_ATTACK_HAND, PROC_REF(hand_attack))

/datum/status_effect/divine_strike/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_ATTACK_HAND)
	if(buffed_item)
		var/obj/item/I = buffed_item.resolve()
		if(istype(I))
			I.set_light(0)
		UnregisterSignal(I, COMSIG_ITEM_AFTERATTACK)

/atom/movable/screen/alert/status_effect/buff/divine_strike
	name = "Divine Strike"
	desc = "Your next attack deals additional damage and slows your target."
	icon_state = "stressvg"

/datum/status_effect/divine_strike/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, list/modifiers)
	if(!proximity_flag)
		return
	if(!isliving(target))
		return
	var/mob/living/living_target = target
	living_target.apply_status_effect(/datum/status_effect/debuff/ravox_burden)
	living_target.visible_message(span_warning("The strike from [user]'s weapon causes [living_target] to go stiff!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/datum/status_effect/divine_strike/proc/hand_attack(datum/source, mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if(!istype(M))
		return
	if(!istype(H))
		return
	if(!istype(M.used_intent, INTENT_HARM))
		return
	H.apply_status_effect(/datum/status_effect/debuff/ravox_burden)
	H.visible_message(span_warning("The strike from [M]'s fist causes [H] to go stiff!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/datum/status_effect/debuff/ravox_burden
	id = "ravox_burden"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ravox_burden
	effectedstats = list(STATKEY_SPD = -2, STATKEY_END = -3)
	duration = 12 SECONDS

/datum/status_effect/debuff/ravox_burden/on_creation(mob/living/new_owner, ...)
	. = ..()
	if(owner.mob_biotypes & MOB_UNDEAD)
		effectedstats[STATKEY_SPD] -= 1
		effectedstats[STATKEY_END] -= 1

/atom/movable/screen/alert/status_effect/debuff/ravox_burden
	name = "Ravox's Burden"
	desc = "My arms and legs are restrained by divine chains!"
	icon_state = "restrained"

