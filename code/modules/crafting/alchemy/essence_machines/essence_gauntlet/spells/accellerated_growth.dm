/datum/action/cooldown/spell/essence/growth_acceleration
	name = "Growth Acceleration"
	desc = "Dramatically speeds up natural growth processes."
	button_icon_state = "great_shelter"
	cast_range = 2
	point_cost = 7
	attunements = list(/datum/attunement/light, /datum/attunement/life)
	essences = list(/datum/thaumaturgical_essence/life, /datum/thaumaturgical_essence/light)

/datum/action/cooldown/spell/essence/growth_acceleration/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] accelerates natural growth in the area."))

	for(var/obj/structure/soil/plant in range(1, target_turf))
		plant.accellerated_growth = world.time + 600 SECONDS
		new /obj/effect/temp_visual/bless_swirl(get_turf(plant))
