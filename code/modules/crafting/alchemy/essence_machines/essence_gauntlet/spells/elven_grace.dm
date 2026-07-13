/datum/action/cooldown/spell/essence/elven_grace
	name = "Elven Grace"
	desc = "Grants the ethereal grace and agility of the ancient elves."
	button_icon_state = "conjinstrum"
	cast_range = 0
	point_cost = 6
	attunements = list(/datum/attunement/life, /datum/attunement/light)
	essences = list(/datum/thaumaturgical_essence/life, /datum/thaumaturgical_essence/light)

/datum/action/cooldown/spell/essence/elven_grace/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] moves with the grace of the ancient elves."))
	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/elven_grace, 300 SECONDS)

/atom/movable/screen/alert/status_effect/elven_grace
	name = "Elven Grace"
	desc = "You move with ethereal grace and agility."
	icon_state = "buff"

/datum/status_effect/buff/elven_grace/on_apply()
	. = ..()
	owner.add_movespeed_modifier(MOVESPEED_ID_STATUS_EFFECT(id), multiplicative_slowdown = -0.2)

/datum/status_effect/buff/elven_grace/on_remove()
	. = ..()
	owner.remove_movespeed_modifier(MOVESPEED_ID_STATUS_EFFECT(id))

/datum/status_effect/buff/elven_grace
	id = "elven_grace"
	alert_type = /atom/movable/screen/alert/status_effect/elven_grace
	duration = 300 SECONDS

/datum/status_effect/buff/elven_grace/on_apply()
	. = ..()
	owner.add_movespeed_modifier(MOVESPEED_ID_STATUS_EFFECT(id), multiplicative_slowdown = -0.2)

/datum/status_effect/buff/elven_grace/on_remove()
	. = ..()
	owner.remove_movespeed_modifier(MOVESPEED_ID_STATUS_EFFECT(id))
