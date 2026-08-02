/datum/component/storage/concrete/grid/messkit
	screen_max_rows = 2
	screen_max_columns = 5
	max_w_class = WEIGHT_CLASS_BULKY
	not_while_equipped = TRUE
	allow_big_nesting = TRUE

/datum/component/storage/concrete/grid/messkit/New(datum/P, ...)
	. = ..()
	can_hold = typecacheof(list(/obj/item/kitchen, /obj/item/folding_table_stored, /obj/item/cooking, /obj/item/reagent_containers/food/snacks, /obj/item/reagent_containers, /obj/item/mobilestove))

/obj/item/storage/messkit
	name = "mess kit"
	desc = "A small, portable mess kit. It can be used to cook food."
	slot_flags = ITEM_SLOT_HIP
	grid_width = 64
	grid_height = 32
	icon_state = "messkit"
	icon = 'icons/roguetown/items/gadgets.dmi'
	component_type = /datum/component/storage/concrete/grid/messkit
	populate_contents = list(
		/obj/item/plate,
		/obj/item/reagent_containers/glass/bowl,
		/obj/item/cooking/pan,
		/obj/item/mobilestove,
		/obj/item/folding_table_stored
	)

	item_weight = 750 GRAMS
