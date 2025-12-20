/obj/item/ammo_holder/quiver
	name = "quiver"
	icon_state = "quiver0"
	item_state = "quiver"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	max_storage = 20
	ammo_type = list (/obj/item/ammo_casing/caseless/arrow, /obj/item/ammo_casing/caseless/bolt)

/obj/item/ammo_holder/quiver/arrows
	fill_type = /obj/item/ammo_casing/caseless/arrow

/obj/item/ammo_holder/quiver/arrows/water
	fill_type = /obj/item/ammo_casing/caseless/arrow/water
	fill_to = 10

/obj/item/ammo_holder/quiver/arrows/pyro
	fill_type = /obj/item/ammo_casing/caseless/arrow/pyro
	fill_to = 10

/obj/item/ammo_holder/quiver/arrows/poison
	fill_type = /obj/item/ammo_casing/caseless/arrow/poison
	fill_to = 10

/obj/item/ammo_holder/quiver/bolts
	fill_type = /obj/item/ammo_casing/caseless/bolt

/obj/item/ammo_holder/quiver/bolt/water
	fill_type = /obj/item/ammo_casing/caseless/bolt/water
	fill_to = 10

/obj/item/ammo_holder/quiver/bolt/holy
	fill_type = /obj/item/ammo_casing/caseless/bolt/holy
	fill_to = 10


/obj/item/ammo_holder/quiver/bolts/pyro
	fill_type = /obj/item/ammo_casing/caseless/bolt/pyro
	fill_to = 10

/obj/item/ammo_holder/quiver/bolts/poison
	fill_type = /obj/item/ammo_casing/caseless/bolt/poison
	fill_to = 10

/obj/item/ammo_holder/bullet
	name = "bullet pouch"
	icon_state = "dartpouch0"
	item_state = "dartpouch"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	max_storage = 10
	ammo_type = list(/obj/item/ammo_casing/caseless/bullet)
	fill_type = /obj/item/ammo_casing/caseless/bullet

/obj/item/ammo_holder/dartpouch
	name = "dart pouch"
	icon_state = "dartpouch0"
	item_state = "dartpouch"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	max_storage = 10
	ammo_type = list(/obj/item/ammo_casing/caseless/dart)

/obj/item/ammo_holder/dartpouch/darts
	fill_type = /obj/item/ammo_casing/caseless/dart

/obj/item/ammo_holder/dartpouch/poisondarts
	fill_type = /obj/item/ammo_casing/caseless/dart/poison

