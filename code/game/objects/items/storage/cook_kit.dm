/datum/storage/messkit
	screen_max_rows = 2
	screen_max_columns = 5
	max_specific_storage = WEIGHT_CLASS_BULKY
	allow_big_nesting = TRUE
	equipped_access_flags = STORAGE_ACCESS_NOT_WORN

/datum/storage/messkit/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()

	set_holdable(list(/obj/item/kitchen, /obj/item/folding_table_stored, /obj/item/cooking, /obj/item/reagent_containers/food/snacks, /obj/item/reagent_containers, /obj/item/mobilestove))

/obj/item/storage/messkit
	name = "mess kit"
	desc = "A small, portable mess kit. It can be used to cook food."
	slot_flags = ITEM_SLOT_HIP
	grid_width = 64
	grid_height = 32
	icon_state = "messkit"
	icon = 'icons/roguetown/items/gadgets.dmi'
	storage_type = /datum/storage/messkit

/obj/item/storage/messkit/populate_contents()
	new /obj/item/plate(src)
	new /obj/item/reagent_containers/glass/bowl(src)
	new /obj/item/cooking/pan(src)
	new /obj/item/mobilestove(src)
	new /obj/item/folding_table_stored(src)
