/datum/action/cooldown/spell/essence/fertile_soil
	name = "Fertile Soil"
	desc = "Enriches soil to promote plant growth."
	button_icon_state = "blesscrop"
	cast_range = 2
	essences = list(/datum/thaumaturgical_essence/water, /datum/thaumaturgical_essence/earth)

/datum/action/cooldown/spell/essence/fertile_soil/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] enriches the soil with life-giving properties."))

	for(var/obj/structure/soil/plant in range(1, target_turf))
		plant.bless_soil()
		new /obj/effect/temp_visual/bless_swirl(get_turf(plant))

/datum/action/cooldown/spell/essence/fertile_soil/spell
	name = "Fertilze Land"
	spell_cost = 15
	spell_type = SPELL_MANA

	required_form = FORM_EARTH
