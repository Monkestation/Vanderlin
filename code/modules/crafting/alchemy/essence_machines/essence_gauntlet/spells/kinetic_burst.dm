/datum/action/cooldown/spell/essence/kinetic_burst
	name = "Kinetic Burst"
	desc = "Releases stored energy as a burst of kinetic force."
	button_icon_state = "kinetic_burst"
	cast_range = 3
	point_cost = 7
	attunements = list(/datum/attunement/light, /datum/attunement/aeromancy)
	essences = list(/datum/thaumaturgical_essence/energia, /datum/thaumaturgical_essence/motion)

/datum/action/cooldown/spell/essence/kinetic_burst/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] releases a burst of kinetic energy."))

	for(var/obj/item/I in range(1, target_turf))
		if(I.w_class <= WEIGHT_CLASS_NORMAL)
			var/distfromcaster = get_dist(owner, I)
			var/throwtarget = get_edge_target_turf(owner, get_dir(owner, get_step_away(I, owner)))
			I.safe_throw_at(throwtarget, ((CLAMP((5 - (CLAMP(distfromcaster - 2, 0, distfromcaster))), 3, 5))), 1,owner, force = 5)
