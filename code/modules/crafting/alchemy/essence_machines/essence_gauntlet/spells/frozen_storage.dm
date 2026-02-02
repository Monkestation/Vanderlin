/datum/action/cooldown/spell/essence/frozen_storage
	name = "Frozen Storage"
	desc = "Creates a magical ice chest that preserves items indefinitely."
	button_icon_state = "frozen_storage"
	cast_range = 1
	point_cost = 6
	attunements = list(/datum/attunement/ice, /datum/attunement/blood)

/datum/action/cooldown/spell/essence/frozen_storage/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] creates a chest of magical ice."))

	var/obj/structure/closet/crate/chest/magical/chest = new(target_turf)
	QDEL_IN(chest, 5 MINUTES)

/obj/structure/closet/crate/chest/magical
	name = "magical ice chest"
	desc = "A chest made of supernatural ice that preserves items indefinitely."
	icon_state = "freezer"
	color = LIGHT_COLOR_LIGHT_CYAN

/obj/structure/closet/crate/chest/magical/Initialize()
	. = ..()
	propagate_temp_change(-15, 6, 0.4, 2)

/obj/structure/closet/crate/chest/magical/Destroy()
	remove_temp_effect()
	return ..()
