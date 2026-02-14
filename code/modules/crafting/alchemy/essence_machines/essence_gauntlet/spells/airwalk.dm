/datum/action/cooldown/spell/essence/air_walk
	name = "Air Walk"
	desc = "Allows brief movement over chasms or gaps by creating temporary air platforms."
	button_icon_state = "air_walk"
	cast_range = 0
	point_cost = 5
	attunements = list(/datum/attunement/aeromancy)
	has_visual_effects = FALSE

/datum/action/cooldown/spell/essence/air_walk/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] steps onto solidified air."))
	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/air_walking, 15 SECONDS)
	new /obj/effect/temp_visual/snake/swarm(null, L)

/atom/movable/screen/alert/status_effect/air_walking
	name = "Air Walking"
	desc = "You can step on solidified air over gaps."
	icon_state = "buff"

/datum/status_effect/buff/air_walking
	id = "air_walking"
	alert_type = /atom/movable/screen/alert/status_effect/air_walking
	duration = 15 SECONDS

/datum/status_effect/buff/air_walking/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_HOLLOWBONES, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_MOVE_FLYING, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_notice("You feel light as air, able to step over gaps and chasms."))

/datum/status_effect/buff/air_walking/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_HOLLOWBONES, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_MOVE_FLYING, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_notice("Your feet return to solid ground."))
