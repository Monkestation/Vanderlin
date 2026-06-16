/datum/action/cooldown/spell/essence/create_beer
	name = "Create Beer"
	desc = "A dwarven secret - transforms water and grain into fine ale."
	button_icon_state = "bread"
	cast_range = 1
	point_cost = 4
	attunements = list(/datum/attunement/earth, /datum/attunement/blood)
	essences = list(/datum/thaumaturgical_essence/earth, /datum/thaumaturgical_essence/water)

/datum/action/cooldown/spell/essence/create_beer/cast(atom/cast_on)
	. = ..()
	var/atom/movable/target = cast_on
	owner.visible_message(span_notice("[owner] works dwarven brewing magic."))

	if(isopenturf(target))
		var/turf/open/open = target
		if(open.liquids)
			var/water_amount = open.liquids.liquid_group.reagents.get_reagent_amount(/datum/reagent/water)
			if(water_amount)
				open.liquids.liquid_group.remove_specific(open.liquids, water_amount, /datum/reagent/water)
				open.liquids.liquid_group.add_reagent(open.liquids, /datum/reagent/consumable/ethanol/beer, water_amount)
			else
				open.liquids.liquid_group.add_reagent(open.liquids, /datum/reagent/consumable/ethanol/beer, 20)
		else
			open.add_liquid(/datum/reagent/consumable/ethanol/beer, 20)
	else if(istype(target, /obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/glass = target
		glass.reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, 20)
