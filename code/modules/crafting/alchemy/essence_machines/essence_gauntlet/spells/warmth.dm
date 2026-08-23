/datum/action/cooldown/spell/essence/warmth
	name = "Warmth"
	desc = "Provides resistance to cold and warms the body."
	button_icon_state = "warmth"
	cast_range = 1
	essences = list(/datum/thaumaturgical_essence/fire)

/datum/action/cooldown/spell/essence/warmth/cast(atom/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	if(!istype(target))
		target = owner
	owner.visible_message(span_notice("[target] radiates gentle warmth."))
	target.apply_status_effect(/datum/status_effect/buff/warmth, 120 SECONDS)

/atom/movable/screen/alert/status_effect/warmth
	name = "Warmth"
	desc = "Magical warmth protects you from cold."
	icon_state = "buff"

/datum/status_effect/buff/warmth
	id = "warmth"
	alert_type = /atom/movable/screen/alert/status_effect/warmth
	duration = 120 SECONDS

/datum/status_effect/buff/warmth/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_RESISTCOLD, TRAIT_STATUS_EFFECT(id))
	owner.bodytemperature = max(owner.bodytemperature, BODYTEMP_NORMAL)
	to_chat(owner, span_notice("A gentle warmth spreads through your body."))

/datum/status_effect/buff/warmth/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_RESISTCOLD, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_notice("The magical warmth fades away."))

/datum/action/cooldown/spell/essence/warmth/spell
	name = "Lesser Warmth"
	charge_required = TRUE
	charge_time = 1 SECONDS
	spell_cost = 40
	spell_type = SPELL_MANA

	required_form = FORM_FIRE
