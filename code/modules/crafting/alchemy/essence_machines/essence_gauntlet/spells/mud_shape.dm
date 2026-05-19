/datum/action/cooldown/spell/essence/mud_shape
	name = "Mud Shape"
	desc = "Combines water and earth to create moldable mud for construction."
	button_icon_state = "stone1"
	button_icon = 'icons/roguetown/items/natural.dmi'
	cast_range = 2
	point_cost = 5
	attunements = list(/datum/attunement/blood, /datum/attunement/earth)
	essences = list(/datum/thaumaturgical_essence/water, /datum/thaumaturgical_essence/earth)

/datum/action/cooldown/spell/essence/mud_shape/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] creates moldable mud from earth and water."))
	new /obj/item/natural/clay(target_turf)
