/datum/action/cooldown/spell/essence/fertile_soil
	name = "Fertile Soil"
	desc = "Enriches soil to promote plant growth."
	button_icon_state = "fertile_soil"
	cast_range = 2
	point_cost = 4
	attunements = list(/datum/attunement/blood, /datum/attunement/earth)

/datum/action/cooldown/spell/essence/fertile_soil/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] enriches the soil with life-giving properties."))

	for(var/obj/structure/soil/plant in range(1, target_turf))
		plant.bless_soil()
		new /obj/effect/temp_visual/bless_swirl(get_turf(plant))
