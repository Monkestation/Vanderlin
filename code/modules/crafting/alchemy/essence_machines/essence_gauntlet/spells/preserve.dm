/datum/action/cooldown/spell/essence/preserve
	name = "Preserve"
	desc = "Prevents food from spoiling and extends its freshness."
	button_icon_state = "preserve"
	cast_range = 1
	point_cost = 2
	attunements = list(/datum/attunement/ice)

/datum/action/cooldown/spell/essence/preserve/cast(atom/cast_on)
	. = ..()
	var/atom/target = cast_on
	if(!target)
		return FALSE
	owner.visible_message(span_notice("[owner] preserves [target] with frost magic."))
	new /obj/effect/temp_visual/solosnake(get_turf(target))

	if(istype(target, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/food = target
		food.warming += 2 HOURS
