/datum/action/cooldown/spell/essence/purify_water
	name = "Purify Water"
	desc = "Removes all impurities and toxins from water, making it pure and safe."
	button_icon_state = "purify_water"
	cast_range = 1
	point_cost = 5
	attunements = list(/datum/attunement/life, /datum/attunement/blood)

/datum/action/cooldown/spell/essence/purify_water/cast(atom/cast_on)
	. = ..()
	var/obj/item/target = cast_on
	if(!isobj(target))
		return FALSE
	owner.visible_message(span_notice("[owner] purifies [target] with life-giving energy."))
	new /obj/effect/temp_visual/solosnake(get_turf(target))

	if(target.reagents)
		target.reagents.remove_all_type(/datum/reagent/toxin)
		target.reagents.remove_all_type(/datum/reagent/poison)
		target.reagents.remove_reagent(/datum/reagent/water/gross, 999)
		target.reagents.add_reagent(/datum/reagent/water, 20)
