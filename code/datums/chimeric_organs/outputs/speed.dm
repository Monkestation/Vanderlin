/datum/chimeric_node/output/speed
	name = "galewind"
	desc = "When activated gives you a speed boost for a duration."

/datum/chimeric_node/output/speed/trigger_effect(multiplier)
	. = ..()
	hosted_carbon.apply_status_effect(/datum/status_effect/buff/galewind, multiplier * (3 * node_purity))

/atom/movable/screen/alert/status_effect/buff/galewind
	name = "Galewind"
	desc = "I am magically hastened."

/datum/status_effect/buff/galewind
	id = "galewind"
	alert_type = /atom/movable/screen/alert/status_effect/buff/galewind
	duration = 30 SECONDS

/datum/status_effect/buff/galewind/on_apply()
	. = ..()
	owner.AddComponent(/datum/component/after_image)
	owner.add_movespeed_modifier(MOVESPEED_ID_STATUS_EFFECT(id), multiplicative_slowdown = -0.3)

/datum/status_effect/buff/galewind/on_remove()
	. = ..()
	var/datum/component/after_image = owner.GetComponent(/datum/component/after_image)
	if(after_image)
		qdel(after_image)
	owner.remove_movespeed_modifier(MOVESPEED_ID_STATUS_EFFECT(id))
