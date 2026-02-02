/datum/action/cooldown/spell/essence/warmth
	name = "Warmth"
	desc = "Provides resistance to cold and warms the body."
	button_icon_state = "warmth"
	cast_range = 1
	point_cost = 3
	attunements = list(/datum/attunement/fire)

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
	ADD_TRAIT(owner, TRAIT_RESISTCOLD, MAGIC_TRAIT)
	owner.bodytemperature = max(owner.bodytemperature, BODYTEMP_NORMAL)
	to_chat(owner, span_notice("A gentle warmth spreads through your body."))

/datum/status_effect/buff/warmth/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_RESISTCOLD, MAGIC_TRAIT)
	to_chat(owner, span_notice("The magical warmth fades away."))
