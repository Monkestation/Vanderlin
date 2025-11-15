/datum/action/cooldown/spell/essence/ice_bridge
	name = "Ice Bridge"
	desc = "Creates a temporary bridge of solid ice from the cast location to you."
	button_icon_state = "ice_bridge"
	cast_range = 3
	point_cost = 7
	attunements = list(/datum/attunement/ice, /datum/attunement/blood)

/datum/action/cooldown/spell/essence/ice_bridge/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	var/turf/caster_turf = get_turf(owner)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] creates a bridge of solid ice."))

	var/steps = 0
	var/broken = FALSE

	while(steps < 4 && !broken)
		if(target_turf == caster_turf)
			broken = TRUE
		steps++
		var/obj/structure/ice_bridge/bridge = new(target_turf)
		QDEL_IN(bridge, 300 SECONDS)
		target_turf = step_towards(target_turf, caster_turf)

/obj/structure/ice_bridge
	name = "ice bridge"
	desc = "A solid bridge made of magical ice."
	icon = 'icons/effects/freeze.dmi'
	icon_state = "ice_bridge"
	alpha = 255
	density = FALSE
	anchored = TRUE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

/obj/structure/ice_bridge/Initialize()
	. = ..()
	propagate_temp_change(-20, 8, 0.5, 2) // Cooling effect

/obj/structure/ice_bridge/Destroy()
	remove_temp_effect()
	return ..()
