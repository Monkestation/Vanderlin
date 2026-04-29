/datum/action/cooldown/spell/essence/seasonal_attune
	name = "Seasonal Attune"
	desc = "Attunes the caster to natural cycles, providing minor benefits."
	button_icon_state = "seasonal_attune"
	cast_range = 0
	point_cost = 3
	attunements = list(/datum/attunement/light)

/datum/action/cooldown/spell/essence/seasonal_attune/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] harmonizes with the natural cycles."))
	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/seasonal_attunement, 600 SECONDS)
	new /obj/effect/temp_visual/snake/twin_up(null, L)

/datum/status_effect/buff/seasonal_attunement
	id = "seasonal_attunement"
	alert_type = /atom/movable/screen/alert/status_effect/seasonal_attunement
	duration = 600 SECONDS

/datum/status_effect/buff/seasonal_attunement/on_apply()
	. = ..()
	// Minor resistances based on current season/time
	ADD_TRAIT(owner, TRAIT_RESISTCOLD, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_RESISTHEAT, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_notice("You harmonize with the natural cycles."))

/datum/status_effect/buff/seasonal_attunement/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_RESISTCOLD, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_RESISTHEAT, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_notice("Your connection to natural cycles fades."))

/atom/movable/screen/alert/status_effect/seasonal_attunement
	name = "Seasonal Attunement"
	desc = "You are harmonized with natural cycles."
	icon_state = "buff"
