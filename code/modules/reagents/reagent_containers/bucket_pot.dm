/obj/item/reagent_containers/glass/bucket
	name = "bugged bucket please report to mappers"
	desc = ""
	icon = 'icons/roguetown/items/misc.dmi'
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	icon_state = "woodbucket"
	item_state = "woodbucket"
	fill_icon_thresholds = list(0, 50, 100)
	reagent_flags = OPENCONTAINER
	max_integrity = 300
	w_class = WEIGHT_CLASS_BULKY
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10)
	volume = 100
	flags_inv = HIDEHAIR
	obj_flags = CAN_BE_HIT
	resistance_flags = NONE

/obj/item/reagent_containers/glass/bucket/dropped(mob/user)
	. = ..()
	reagents.flags = initial(reagent_flags)

/obj/item/reagent_containers/glass/bucket/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/reagent_containers/powder/salt))
		if(!reagents.has_reagent(/datum/reagent/consumable/milk, 15) && !reagents.has_reagent(/datum/reagent/consumable/milk/gote, 15))
			to_chat(user, span_danger("Not enough milk."))
			return
		to_chat(user, span_danger("Adding salt to the milk."))
		playsound(src, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		if(do_after(user,2 SECONDS, src))
			if(reagents.has_reagent(/datum/reagent/consumable/milk, 15))
				reagents.remove_reagent(/datum/reagent/consumable/milk, 15)
				reagents.add_reagent(/datum/reagent/consumable/milk/salted, 15)
			if(reagents.has_reagent(/datum/reagent/consumable/milk/gote, 15))
				reagents.remove_reagent(/datum/reagent/consumable/milk/gote, 15)
				reagents.add_reagent(/datum/reagent/consumable/milk/salted_gote, 15)
			qdel(I)

/obj/item/reagent_containers/glass/bucket/wooden
	name = "bucket"
	fill_icon_state = "bucket"
	force = 5
	throwforce = 10
	armor = list("blunt" = 10, "slash" = 10, "stab" = 10,  "piercing" = 0, "fire" = 0, "acid" = 50)
	resistance_flags = FLAMMABLE
	dropshrink = 0.8
	slot_flags = null
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'

/obj/item/reagent_containers/glass/bucket/wooden/Initialize(mapload, vol)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/bucket)

/obj/item/reagent_containers/glass/bucket/wooden/alter // just new look, trying it on for size
	icon = 'icons/roguetown/items/cooking.dmi'

/obj/item/reagent_containers/glass/bucket/wooden/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -5,"sy" = -8,"nx" = 7,"ny" = -9,"wx" = -1,"wy" = -8,"ex" = -1,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)

/obj/item/reagent_containers/glass/bucket/pot
	name = "pot"
	desc = "The peasants friend, when filled with boiling water it will turn the driest oats to filling oatmeal."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "pote"
	fill_icon_state = "pote"
	force = 10
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'
	melting_material = /datum/material/iron
	melt_amount = 80
	var/processing_amount = 0 ///we use this to "reserve" reagents
	var/static/list/recipe_list = list()

/obj/item/reagent_containers/glass/bucket/pot/Initialize(mapload, vol)
	. = ..()
	if(!length(recipe_list))
		for(var/datum/container_craft/recipe as anything in subtypesof(/datum/container_craft/cooking))
			if(!IS_ABSTRACT(recipe))
				recipe_list += recipe

	AddComponent(/datum/component/storage/concrete/grid/food/cooking/pot)
	if(length(recipe_list))
		AddComponent(/datum/component/container_craft, recipe_list, TRUE)

/obj/item/reagent_containers/glass/bucket/pot/copper
	icon_state = "pote_copper"
	melting_material = /datum/material/copper

/obj/item/reagent_containers/glass/bucket/pot/stone
	icon_state = "pote_stone"
	melting_material = null

/obj/item/reagent_containers/glass/bucket/pot/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/bowl))
		to_chat(user, "<span class='notice'>Filling the bowl...</span>")
		playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 70, FALSE)
		if(do_after(user, 2 SECONDS, src))
			reagents.trans_to(I, reagents.total_volume)
		return TRUE
	return ..()

/obj/item/reagent_containers/glass/bucket/pot/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(reagents.total_volume > 5)
		new /obj/effect/decal/cleanable/food/mess/soup(get_turf(src))
	. = ..()

/obj/item/reagent_containers/glass/bucket/pot/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -5,"sy" = -8,"nx" = 7,"ny" = -9,"wx" = -1,"wy" = -8,"ex" = -1,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
