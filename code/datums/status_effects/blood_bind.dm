/atom/movable/screen/alert/status_effect/buff/blood_bound
	name = "Blood Bind"
	desc = "A weapon has been bound in blood to serve you."
	icon_state = "buff"

/datum/status_effect/buff/blood_bound
	id = "blood_bound"
	alert_type = /atom/movable/screen/alert/status_effect/buff/blood_bound
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_UNIQUE
	var/obj/item/bound_weapon

/datum/status_effect/buff/blood_bound/on_apply()
	. = ..()
	// Flag the mind so it persists through death/revival
	if(owner.mind)
		ADD_TRAIT(owner.mind, TRAIT_BLOOD_BIND, "[type]")
