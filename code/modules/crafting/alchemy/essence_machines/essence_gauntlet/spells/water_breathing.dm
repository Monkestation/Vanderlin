/datum/action/cooldown/spell/essence/water_breathing
	name = "Water Breathing"
	desc = "Allows breathing underwater for a short duration."
	button_icon_state = "water_breathing"
	cast_range = 1
	point_cost = 4
	attunements = list(/datum/attunement/blood)

/datum/action/cooldown/spell/essence/water_breathing/cast(atom/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	if(!istype(target))
		target = owner
	owner.visible_message(span_notice("[target] gains the ability to breathe underwater."))
	target.apply_status_effect(/datum/status_effect/buff/water_breathing, 60 SECONDS)

/atom/movable/screen/alert/status_effect/water_breathing
	name = "Water Breathing"
	desc = "You can breathe underwater."
	icon_state = "buff"

/datum/status_effect/buff/water_breathing
	id = "water_breathing"
	alert_type = /atom/movable/screen/alert/status_effect/water_breathing
	duration = 60 SECONDS

/datum/status_effect/buff/water_breathing/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_WATER_BREATHING, MAGIC_TRAIT)
	to_chat(owner, span_notice("You can now breathe underwater."))

/datum/status_effect/buff/water_breathing/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_WATER_BREATHING, MAGIC_TRAIT)
	to_chat(owner, span_notice("Your ability to breathe underwater fades."))
