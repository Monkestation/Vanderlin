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
