/datum/action/cooldown/spell/essence/chill
	name = "Frost Touch"
	desc = "Creates a small patch of frost that can preserve food or cool drinks."
	button_icon_state = "chill"
	//sound = 'sound/magic/whiff.ogg'
	cast_range = 1
	attunements = list(/datum/attunement/ice)

/datum/action/cooldown/spell/essence/chill/cast(atom/cast_on)
	. = ..()
	var/atom/target = cast_on
	if(!target)
		return FALSE
	target = get_turf(target)

	owner.visible_message(span_notice("[owner] gestures, creating a small patch of frost around [target]."))
	//playsound(get_turf(target), 'sound/magic/whiff.ogg', 50, TRUE)

	var/obj/structure/ice_zone/zone = new(get_turf(target))
	QDEL_IN(zone, 45 MINUTES)

/obj/structure/ice_zone
	name = "frozen zone"
	desc = "A magic pile of ice used to chill things."
	icon = 'icons/effects/freeze.dmi'
	icon_state = "ice_shards"
	alpha = 200
	density = FALSE
	anchored = TRUE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

/obj/structure/ice_zone/Initialize()
	. = ..()
	propagate_temp_change(-30, 8, 0.9, 2) // Cooling effect

/obj/structure/ice_zone/Destroy()
	remove_temp_effect()
	return ..()
