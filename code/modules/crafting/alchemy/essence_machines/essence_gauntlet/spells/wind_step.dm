/datum/action/cooldown/spell/essence/wind_step
	name = "Wind Step"
	desc = "Allows rapid movement by riding currents of air."
	button_icon_state = "haste"
	cast_range = 0
	point_cost = 6
	has_visual_effects = FALSE
	attunements = list(/datum/attunement/aeromancy, /datum/attunement/aeromancy)
	essences = list(/datum/thaumaturgical_essence/motion, /datum/thaumaturgical_essence/air)

/datum/action/cooldown/spell/essence/wind_step/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] steps upon the wind itself."))
	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/wind_walking, 30 SECONDS)
	new /obj/effect/temp_visual/snake/swarm(null, L)

/atom/movable/screen/alert/status_effect/wind_walking
	name = "Wind Walking"
	desc = "You move with supernatural speed on air currents."
	icon_state = "buff"

/datum/status_effect/buff/wind_walking
	id = "wind_walking"
	alert_type = /atom/movable/screen/alert/status_effect/wind_walking
	duration = 30 SECONDS

/datum/status_effect/buff/wind_walking/on_apply()
	. = ..()
	owner.add_movespeed_modifier(MOVESPEED_ID_STATUS_EFFECT(id), multiplicative_slowdown = -0.3)
	to_chat(owner, span_notice("You step upon the wind itself!"))

/datum/status_effect/buff/wind_walking/on_remove()
	. = ..()
	owner.remove_movespeed_modifier(MOVESPEED_ID_STATUS_EFFECT(id))
